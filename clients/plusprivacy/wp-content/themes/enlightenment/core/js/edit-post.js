jQuery(document).ready(function($) {
	$('.image-radio-button-label').each(function() {
		if($('.image-radio-button', this).attr('checked') == 'checked' )
			$(this).addClass('checked');
	});
	$('.image-radio-button-label').click(function() {
		$('.image-radio-button-label', $(this).closest('.inside')).each(function() {
			if($('.image-radio-button', this).attr('checked') == 'checked' )
				$(this).removeClass('checked');
		});
		$(this).addClass('checked');
	});
});