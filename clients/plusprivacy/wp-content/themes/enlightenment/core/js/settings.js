jQuery(document).ready(function($) {
	if($.fn.wpColorPicker)
		$('.wp-color-picker').wpColorPicker({
			change: function(event, ui) {
				var color = ui.color.toString();
				$(this).closest('td').find('.font-options-preview').css('color', color);
			}
		});

	$('.image-radio-button-label').each(function() {
		if($('.image-radio-button', this).attr('checked') == 'checked' )
			$(this).addClass('checked');
	});
	$('.image-radio-button-label').click(function() {
		$('.image-radio-button-label', $(this).parent()).each(function() {
			if($('.image-radio-button', this).attr('checked') == 'checked' )
				$(this).removeClass('checked');
		});
		$(this).addClass('checked');
	});

	var file_frame;
	$('.upload-media-button').live('click', function(event) {
		event.preventDefault();
		var upload_button = $(this);

		// If the media frame already exists, reopen it.
		// if ( file_frame ) {
		// 	file_frame.open();
		// 	return;
		// }

		// Create the media frame.
		file_frame = wp.media.frames.file_frame = wp.media({
			title: jQuery(this).data( 'uploader-title' ),
			button: {
				text: jQuery(this).data( 'uploader-button-text' ),
			},
			library: {
				type: jQuery(this).data( 'mime-type' ),
			},
			multiple: jQuery(this).data( 'multiple' )  // Set to true to allow multiple files to be selected
		});

		// When an image is selected, run a callback.
		file_frame.on( 'select', function() {
			// We set multiple to false so only get one image from the uploader
			// attachment = file_frame.state().get('selection').first().toJSON();
			
			var val = [];
			attachments = file_frame.state().get('selection').toJSON();
			$(attachments).each(function() {
				val.push(this.id);
			});
			val = val.join();

			// Do something with attachment.id and/or attachment.url here
			$('input[type="hidden"]', upload_button.parent()).val(val);

			if($('.preview-media').length) {
				$(attachments).each(function() {
					attachment = this;
					var mime_type = attachment.mime.replace('/' + attachment.subtype, '');
					// console.log(mime_type);
					var data = {
						action: 'enlightenment_media_preview',
						id: attachment.id,
						size: upload_button.data('thumbnail'),
						mime_type: mime_type,
					}
					$.post(ajaxurl, data, function(r) {
						var preview_media = $('.preview-media', upload_button.parent());
						preview_media.html(r);
						console.log(preview_media.css('height'));
						if( 0 == preview_media.css('height') || '0px' == preview_media.css('height') )
							preview_media.css('height', 'auto');
					});
				});
			}
			$('.remove-media-button', upload_button.parent()).show();
		});

		// Finally, open the modal
		file_frame.open();

	});

	$('.remove-media-button').live('click', function(event) {
		event.preventDefault();
		var remove_button = $(this);
		$('input[type="hidden"]', remove_button.parent()).val('');
		$('.preview-media', remove_button.parent()).css('height', 0);
		remove_button.hide();
	});
	
	$('.enlightenment-opacity-slider').each(function() {
		var $this = $(this);
		$('.enlightenment-jquery-ui-slider', $this).slider({
			range: "min",
			min: 0,
			max: 100,
			value: $('input', $this).val(),
			slide: function( event, ui ) {
				$('input', $this).val( ui.value );
			}
		});
	});

	$('.font-options').after('<div class="font-options-preview">Grumpy wizards make toxic brew for the evil Queen and Jack.</div>');
	$('.font-options-preview').each(function() {
		var family = $(this).parent().find('.font_family').val();
		var size = $(this).parent().find('.font_size').val()+'px';
		switch( $(this).parent().find('.font_style').val() ) {
			case '400italic':
			case '400italic':
			case '500italic':
			case '600italic':
			case '700italic':
				var style = 'italic';
				break;
			default:
				var style = 'normal';
		}
		switch( $(this).parent().find('.font_style').val() ) {
			case '300':
			case '300italic':
				var weight = '300';
				break;
			case '500':
			case '500italic':
				var weight = '500';
				break;
			case '600':
			case '600italic':
				var weight = '600';
				break;
			case '700':
			case '700italic':
				var weight = '700';
				break;
			default:
				var weight = '400';
		}
		var color = $(this).parent().find('.font_color').val();
		var src = family.replace(' ', '+')+':'+$(this).parent().find('.font_style').val();
		if( $('head #enlightenment-web-font').length ) {
			var href = $('head #enlightenment-web-font').attr('href');
			$('head #enlightenment-web-font').attr('href', href+'|'+src);
		} else {
			$('head').append("<link id='enlightenment-web-font' href='//fonts.googleapis.com/css?family="+src+"' rel='stylesheet' type='text/css'>");
		}
		$(this).css({
			'font-family': family,
			'font-size': size,
			'font-style': style,
			'font-weight': weight,
			'color': color,
		});
	});

	$('.font-options .font_family, .font-options .font_style').change(function() {
		var family = $(this).parent().find('.font_family').val();
		var src = family.replace(' ', '+')+':'+$(this).parent().find('.font_style').val();
		var href = $('head #enlightenment-web-font').attr('href');
		$('head #enlightenment-web-font').attr('href', href+'|'+src);
		$(this).parent().parent().find('.font-options-preview').css('font-family', family);
	});

	$('.font-options .font_size').change(function() {
		var size = $(this).val()+'px';
		$(this).parent().parent().find('.font-options-preview').css('font-size', size);
	});

	$('.font-options .font_style').change(function() {
		switch( $(this).val() ) {
			case '300italic':
			case '400italic':
			case '500italic':
			case '600italic':
			case '700italic':
				var style = 'italic';
				break;
			default:
				var style = 'normal';
		}
		$(this).parent().parent().find('.font-options-preview').css('font-style', style);
	});

	$('.font-options .font_style').change(function() {
		switch( $(this).val() ) {
			case 300:
			case '300italic':
				var weight = '300';
				break;
			case 500:
			case '500italic':
				var weight = '500';
				break;
			case 600:
			case '600italic':
				var weight = '600';
				break;
			case 700:
			case '700italic':
				var weight = '700';
				break;
			default:
				var weight = '400';
		}
		$(this).parent().parent().find('.font-options-preview').css('font-weight', weight);
	});

	/*$('.font-options .font_color').keyup(function() {
		var color = $(this).val();
		$(this).closest('td').find('.font-options-preview').css('color', color);
	});*/

	if( $('.google-fonts').length ) {
		var src = '';
		$('.google-fonts label').each(function() {
			var family = $(this).html().replace(/(<([^>]+)>)/ig,"").trim();
			if('' != src)
				src += '|';
			src += family.replace(/ /g, '+');
			$(this).css('font-family', family);
		});
		if( $('head #enlightenment-web-font').length ) {
			var href = $('head #enlightenment-web-font').attr('href');
			$('head #enlightenment-web-font').attr('href', '//fonts.googleapis.com/css?family=' + src);
		} else {
			$('head').append("<link id='enlightenment-web-font' href='//fonts.googleapis.com/css?family=" + src + "' rel='stylesheet' type='text/css'>");
		}
		
		if( typeof enlightenment_settings_args.google_api_key != 'undefined' ) {
			$.get('https://www.googleapis.com/webfonts/v1/webfonts?sort=' + enlightenment_settings_args.sort_fonts_by + '&key=' + enlightenment_settings_args.google_api_key, function(data) {
				var src = '';
				for( var i in data.items ) {
					if( typeof enlightenment_settings_args.subsets != 'undefined' ) {
						var cont = false;
						for( var j in enlightenment_settings_args.subsets ) {
							if( -1 === $.inArray( enlightenment_settings_args.subsets[j], data.items[i].subsets ) )
								cont = true;
						}
						if( cont )
							continue;
					}
					if('' != src)
						src += '|';
					// console.log(font);
					src += data.items[i].family.replace(/ /g, '+');
				}
				data = JSON.stringify(data);
				$.post(ajaxurl, {
					action: 'enlightenment_build_google_fonts_list',
					data: data,
				}, function(r) {
					$('.google-fonts h3').remove();
					// $('.google-fonts').append('<br />');
					$('.google-fonts').append(r);
					if( enlightenment_settings_args.live_preview_fonts ) {
						$('.google-fonts label').each(function() {
							var family = $(this).html().replace(/(<([^>]+)>)/ig,"").trim();
							$(this).css('font-family', family);
						});
					}
				});
				if( enlightenment_settings_args.live_preview_fonts ) {
					if( $('head #enlightenment-web-font').length ) {
						var href = $('head #enlightenment-web-font').attr('href');
						$('head #enlightenment-web-font').attr('href', '//fonts.googleapis.com/css?family=' + src);
					} else {
						$('head').append("<link id='enlightenment-web-font' href='//fonts.googleapis.com/css?family=" + src + "' rel='stylesheet' type='text/css'>");
					}
				}
			});
		}
	}

	if($('input[name="enlightenment_default_template_hooks"]:checked').length)
		$('.template-hooks').hide();

	$('input[name="enlightenment_default_template_hooks"]').change(function() {
		if($(this).is(':checked'))
			$('.template-hooks').slideUp();
		else
			$('.template-hooks').slideDown();
	});

	if($('input[name="enlightenment_default_sidebar_locations"]:checked').length)
		$('.sidebar-locations').hide();

	$('input[name="enlightenment_default_sidebar_locations"]').change(function() {
		if($(this).is(':checked'))
			$('.sidebar-locations').slideUp();
		else
			$('.sidebar-locations').slideDown();
	});
	
	$('.select-template').change(function(event) {
		event.stopPropagation();
		window.location = enlightenment_settings_args.admin_url + 'themes.php?page=' + enlightenment_settings_args.menu_slug + '&tab=' + enlightenment_settings_args.current_tab + '&template=' + $(this).val();
	});
	
	$('.select-post-format').change(function(event) {
		event.stopPropagation();
		window.location = enlightenment_settings_args.admin_url + 'themes.php?page=' + enlightenment_settings_args.menu_slug + '&tab=' + enlightenment_settings_args.current_tab + '&format=' + $(this).val();
	});
});