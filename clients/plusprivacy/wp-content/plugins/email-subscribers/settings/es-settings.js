jQuery( function( $ ) {

	// Hide and show settings field depending on nav tab selected
	$( '.nav-tab' ).on( 'click', function() {
		var active_tab = this.id;
		window.history.pushState( "", "", '#'+active_tab );
		$( 'table.es-settings' ).find( '.active-settings' ).removeClass( 'active-settings' ).addClass( 'hidden' );
		$( document ).find('.nav-tab-active').removeClass( 'nav-tab-active' );
		$( 'table.es-settings tr.es-'+active_tab ).addClass( 'active-settings' ).removeClass( 'hidden' );
		$( this ).addClass( 'nav-tab-active' );

		return false;
	} );

	// Add action attribute to the form to maintain the structure of url
	$( '#es_form' ).submit( function(e) {
		e.preventDefault();

		// Cron field validation
		if ( document.es_form.es_cron_mailcount.value == "" ) {
			alert( es_cron_notices.es_cron_number );
			document.es_form.es_cron_mailcount.focus();
			return false;
		} else if ( isNaN( document.es_form.es_cron_mailcount.value ) ) {
			alert( es_cron_notices.es_cron_input_type );
			document.es_form.es_cron_mailcount.focus();
			return false;
		}

		// Hide all form setting initially on Save settings
		$( '.es-settings' ).find( 'tr' ).addClass( 'hidden' );
		$( '#es-save-settings' ).hide();

		// Add current location to the action attribute of form
		current_nav_tab = window.location;
		$( '#es_form' ).attr( 'action', current_nav_tab );

		// Submit Settings
		this.submit();
	} );

	// On clicking save settings make sure the same tab is reloaded
	$( window ).load( function() {
		default_nav_tab = '#admin';
		current_nav_tab = window.location.hash;
		if ( current_nav_tab == null || current_nav_tab == "" ) {
			current_nav_tab = default_nav_tab;
		}
		jQuery( '#es-tabs' ).find( current_nav_tab ).trigger( 'click' );
	});
});