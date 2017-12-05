jQuery(function() {
	var el_notice = jQuery( ".iworks-notice" ),
		plugin_id = el_notice.find( "input[name=plugin_id]" ).val(),
		slug = el_notice.find( "input[name=slug]" ).val(),
		btn_act = el_notice.find( ".iworks-notice-act" ),
		btn_dismiss = el_notice.find( ".iworks-notice-dismiss" )
		ajax_data = {};

	ajax_data.plugin_id = plugin_id;

	// Display the notice after the page was loaded.
	function initialize() {
		el_notice.fadeIn( 500 );
	}

	// Hide the notice after a CTA button was clicked
	function remove_notice() {
		el_notice.fadeTo( 100 , 0, function() {
			el_notice.slideUp( 100, function() {
				el_notice.remove();
			});
		});
	}

	// Notify WordPress about the users choice and close the message.
	function notify_wordpress( action, message ) {
		el_notice.attr( "data-message", message );
		el_notice.addClass( "loading" );

		ajax_data.action = action;
		jQuery.post(
			window.ajaxurl,
			ajax_data,
			remove_notice
		);
	}

	// Handle click on the primary CTA button.
	// Either open the wp.org page or submit the email address.
	btn_act.click(function( ev ) {
		ev.preventDefault();
		var url = 'https://wordpress.org/support/plugin/'+slug+'/reviews/?rate=5#new-post';
        var link = jQuery( '<a href="' + url + '" target="_blank">Rate</a>' );
		link.appendTo( "body" );
		link[0].click();
		link.remove();
		notify_wordpress( "iworks_act", btn_act.data( "msg" ) );
	});

	// Dismiss the notice without any action.
	btn_dismiss.click(function( ev ) {
		ev.preventDefault();

		notify_wordpress( "iworks_dismiss", btn_dismiss.data( "msg" ) );
	});

	window.setTimeout( initialize, 500 );
});

