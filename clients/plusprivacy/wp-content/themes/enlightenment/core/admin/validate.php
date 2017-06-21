<?php

function enlightenment_validate_theme_options( $input ) {
	$input = apply_filters( 'enlightenment_validate_theme_options', $input );
	return $input;
}

add_filter( 'enlightenment_validate_theme_options', 'enlightenment_validate_tab_theme_options' );

function enlightenment_validate_tab_theme_options( $input ) {
	if( isset( $input['tab'] ) ) {
		$tab = $input['tab'];
		$input = apply_filters( "enlightenment_validate_{$tab}_theme_options", $input );
		unset( $input['tab'] );
	}
	return $input;
}

add_filter( 'enlightenment_validate_theme_options', 'enlightenment_reset_theme_options', 35 );

function enlightenment_reset_theme_options( $input ) {
	global $enlightenment_theme_options_input;
	
	if( isset( $enlightenment_theme_options_input['reset_settings'] ) ) {	
		unset( $input['reset_settings'] );
		
		$defaults = enlightenment_default_theme_options();
		foreach( $enlightenment_theme_options_input as $option => $value ) {
			unset( $input[$option] );
		}
	}
	unset( $GLOBALS['enlightenment_theme_options_input'] );
	
	return $input;
}

add_filter( 'enlightenment_validate_theme_options', 'enlightenment_merge_theme_options', 30 );

function enlightenment_merge_theme_options( $input ) {
	global $enlightenment_theme_options_input;
	$enlightenment_theme_options_input = $input;
	
	$options = get_option( 'enlightenment_theme_options', enlightenment_default_theme_options() );
	return array_merge( $options, $input );
}

function enlightenment_validate_scalar( $input, $default = false ) {
	if( is_scalar( $input ) )
		return $input;
	return $default;
}

function enlightenment_validate_bool( $input = false ) {
	if( false !== $input )
		return true;
	return false;
}

function enlightenment_validate_single_choice( $input, $accepted, $default = false ) {
	if( in_array( $input, $accepted ) )
		return $input;
	return $default;
}

function enlightenment_validate_multiple_choice( $input, $accepted, $default = false ) {
	foreach( $input as $key => $option )
		if( in_array( $option, $accepted ) )
			unset( $input[$key] );
	$input = array_values( $input );
	if( ! empty( $input ) )
		return $input;
	return $default;
}

function enlightenment_validate_media( $input, $default = false ) {
	if( '' == $input )
		return $input;
	$post = get_post( intval( $input ) );
	if( 'attachment' == $post->post_type )
		return $input;
	return $default;
}

function enlightenment_validate_color( $input, $default = false ) {
	if( is_array( $input ) ) {
		$input['hex'] = enlightenment_validate_color( $input['hex'], isset( $default['hex'] ) ? $default['hex'] : false );
		
		if( isset( $input['alpha'] ) ) {
			$input['alpha'] = ( 0 <= $input['alpha'] && 100 >= $input['alpha'] ) ? $input['alpha'] : ( isset( $default['alpha'] ) ? $default['alpha'] : false );
		}
		
		$input['transparent'] = isset( $input['transparent'] );

		return $input;
	} else {
		$input = substr( $input, 0, 7 );
		if( '#' != $input[0] )
			return $default;
		if( ctype_xdigit( substr( $input, 1, 6 ) ) )
			return $input;
		return $default;
	}
}

function enlightenment_validate_background_options( $input, $default = false ) {
	$input['color'] = enlightenment_validate_color( $input['color'], $default['color'] );
	
	$input['image'] = enlightenment_validate_media( $input['image'], $default['image'] );
	
	$accepted = array( 'center', 'center-top', 'center-bottom', 'left-top', 'left-center', 'left-bottm', 'right-top', 'right-center', 'right-bottom' );
	$input['position'] = in_array( $input['position'], $accepted ) ? $input['position'] : $default['position'];
	
	$accepted = array( 'repeat', 'no-repeat', 'repeat-x', 'repeat-y' );
	$input['repeat'] = in_array( $input['repeat'], $accepted ) ? $input['repeat'] : $default['repeat'];
	
	$accepted = array( 'auto', 'cover', 'contain' );
	$input['size'] = in_array( $input['size'], $accepted ) ? $input['size'] : $default['size'];
	
	$accepted = array( 'scroll', 'fixed', 'parallax' );
	$input['scroll'] = in_array( $input['scroll'], $accepted ) ? $input['scroll'] : $default['scroll'];
	
	return $input;
}

function enlightenment_validate_font_family( $input, $default = false ) {
	if( array_key_exists( $input, enlightenment_available_fonts() ) )
		return $input;
	return $default;
}

function enlightenment_validate_font_size( $input, $default = false ) {
	$input = intval( $input );
	$min_font_size = apply_filters( 'enlightenment_min_font_size', 10 );
	$max_font_size = apply_filters( 'enlightenment_max_font_size', 48 );
	if( $input >= $min_font_size && $input <= $max_font_size )
		return $input;
	return $default;
}

function enlightenment_validate_font_style( $input, $default = false ) {
	if( array_key_exists( $input, enlightenment_font_styles() ) )
		return $input;
	return $default;
}

add_filter( 'enlightenment_validate_theme_options', 'enlightenment_auto_validate_checkbox' );

function enlightenment_auto_validate_checkbox( $input ) {
	global $wp_settings_fields;
	foreach( $wp_settings_fields as $page ) {
		foreach( $page as $section ) {
			foreach( $section as $field ) {
				if( isset( $field['args']['name'] ) && strpos( $field['args']['name'], '[' ) )
					continue;
				if( 'enlightenment_checkbox' == $field['callback'] && ! isset( $input[$field['args']['name']] ) ) {
					$input[$field['args']['name']] = false;
				}
			}
		}
	}
	return $input;
}

add_filter( 'enlightenment_validate_theme_options', 'enlightenment_auto_validate_checkboxes' );

function enlightenment_auto_validate_checkboxes( $input ) {
	global $wp_settings_fields;
	foreach( $wp_settings_fields as $page ) {
		foreach( $page as $section ) {
			foreach( $section as $field ) {
				if( isset( $field['args']['name'] ) && strpos( $field['args']['name'], '[' ) )
					continue;
				if( 'enlightenment_checkboxes' == $field['callback'] ) {
					foreach( $field['args']['boxes'] as $checkbox ) {
						if( ! isset( $input[$checkbox['name']] ) ) {
							$input[$checkbox['name']] = false;
						}
					}
				}
			}
		}
	}
	return $input;
}

add_filter( 'enlightenment_validate_theme_options', 'enlightenment_auto_validate_radio_buttons' );

function enlightenment_auto_validate_radio_buttons( $input ) {
	global $wp_settings_fields;
	foreach( $wp_settings_fields as $page ) {
		foreach( $page as $section ) {
			foreach( $section as $field ) {
				if( isset( $field['args']['name'] ) && strpos( $field['args']['name'], '[' ) )
					continue;
				if( 'enlightenment_radio_buttons' == $field['callback'] || 'enlightenment_image_radio_buttons' == $field['callback'] ) {
					$values = array();
					foreach( $field['args']['buttons'] as $button ) {
						$values[] = $button['value'];
					}
					$input[$field['args']['name']] = enlightenment_validate_single_choice( $input[$field['args']['name']], $values, enlightenment_theme_option( $field['args']['name'] ) );
				}
			}
		}
	}
	return $input;
}

add_filter( 'enlightenment_validate_theme_options', 'enlightenment_auto_validate_select_boxes' );

function enlightenment_auto_validate_select_boxes( $input ) {
	global $wp_settings_fields;
	foreach( $wp_settings_fields as $page ) {
		foreach( $page as $section ) {
			foreach( $section as $field ) {
				if( isset( $field['args']['name'] ) && strpos( $field['args']['name'], '[' ) )
					continue;
				if( 'enlightenment_select_box' == $field['callback'] ) {
					$values = array_keys( $field['args']['options'] );
					if( isset( $field['args']['multiple'] ) && $field['args']['multiple'] ) {
						$input[$field['args']['name']] = enlightenment_validate_multiple_choice( $input[$field['args']['name']], $values, enlightenment_theme_option( $field['args']['name'] ) );
					} else {
						$input[$field['args']['name']] = enlightenment_validate_single_choice( $input[$field['args']['name']], $values, enlightenment_theme_option( $field['args']['name'] ) );
					}
				}
			}
		}
	}
	return $input;
}

add_filter( 'enlightenment_validate_theme_options', 'enlightenment_auto_validate_upload_media' );

function enlightenment_auto_validate_upload_media( $input ) {
	global $wp_settings_fields;
	foreach( $wp_settings_fields as $page ) {
		foreach( $page as $section ) {
			foreach( $section as $field ) {
				if( isset( $field['args']['name'] ) && strpos( $field['args']['name'], '[' ) )
					continue;
				if( 'enlightenment_upload_media' == $field['callback'] ) {
					$input[$field['args']['name']] = enlightenment_validate_media( $input[$field['args']['name']], enlightenment_theme_option( $field['args']['name'] ) );
					//multiple
				}
			}
		}
	}
	return $input;
}

add_filter( 'enlightenment_validate_theme_options', 'enlightenment_auto_validate_color_picker' );

function enlightenment_auto_validate_color_picker( $input ) {
	global $wp_settings_fields;
	foreach( $wp_settings_fields as $page ) {
		foreach( $page as $section ) {
			foreach( $section as $field ) {
				if( isset( $field['args']['name'] ) && strpos( $field['args']['name'], '[' ) )
					continue;
				if( 'enlightenment_color_picker' == $field['callback'] ) {
					$input[$field['args']['name']] = enlightenment_validate_color( $input[$field['args']['name']], enlightenment_theme_option( $field['args']['name'] ) );
				}
			}
		}
	}
	return $input;
}

add_filter( 'enlightenment_validate_theme_options', 'enlightenment_auto_validate_background_options' );

function enlightenment_auto_validate_background_options( $input ) {
	global $wp_settings_fields;
	foreach( $wp_settings_fields as $page ) {
		foreach( $page as $section ) {
			foreach( $section as $field ) {
				if( isset( $field['args']['name'] ) && false !== strpos( $field['args']['name'], '[' ) )
					continue;
				if( 'enlightenment_background_options' == $field['callback'] ) {
					$input[$field['args']['name']] = enlightenment_validate_background_options( $input[$field['args']['name']], enlightenment_theme_option( $field['args']['name'] ) );
				}
			}
		}
	}
	return $input;
}

add_filter( 'enlightenment_validate_theme_options', 'enlightenment_auto_validate_font_options' );

function enlightenment_auto_validate_font_options( $input ) {
	global $wp_settings_fields;
	foreach( $wp_settings_fields as $page ) {
		foreach( $page as $section ) {
			foreach( $section as $field ) {
				if( isset( $field['args']['name'] ) && false !== strpos( $field['args']['name'], '[' ) )
					continue;
				if( 'enlightenment_font_options' == $field['callback'] ) {
					$input[$field['args']['name'] . '_font_family'] = enlightenment_validate_font_family( $input[$field['args']['name'] . '_font_family'], enlightenment_theme_option( $field['args']['name'] . '_font_family' ) );
					$input[$field['args']['name'] . '_font_size'] = enlightenment_validate_font_size( $input[$field['args']['name'] . '_font_size'], enlightenment_theme_option( $field['args']['name'] . '_font_size' ) );
					$input[$field['args']['name'] . '_font_style'] = enlightenment_validate_font_style( $input[$field['args']['name'] . '_font_style'], enlightenment_theme_option( $field['args']['name'] . '_font_style' ) );
					$input[$field['args']['name'] . '_font_color'] = enlightenment_validate_color( $input[$field['args']['name'] . '_font_color'], enlightenment_theme_option( $field['args']['name'] . '_font_color' ) );
				}
			}
		}
	}
	return $input;
}


