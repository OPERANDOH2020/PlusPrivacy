<?php

function enlightenment_print_background_options( $selector, $option, $echo = true ) {
	$default_options = enlightenment_default_theme_options();
	
	if( ! isset( $default_options[ $option ] ) ) {
		$default_options[ $option ] = false;
	}
	
	$defaults = apply_filters( 'enlightenment_print_background_settings_defaults', $default_options[ $option ], $selector, $option );
	
	$settings = apply_filters( 'enlightenment_print_background_settings', enlightenment_theme_option( $option ), $selector, $option );
	
	if( empty( $settings ) || $settings === $defaults ) {
		return;
	}
	
	extract( $settings );
	
	$output = "$selector {\n";
	
	if( $color != $defaults['color'] ) {
		if( is_array( $color ) ) {
			if( isset( $color['transparent'] ) && $color['transparent'] ) {
				$output .= "\tbackground-color: transparent;\n";
			} else {
				if( strlen( $color['hex'] ) === 4 ) {
					list($r, $g, $b) = sscanf( $color['hex'], "#%1x%1x%1x" );
					
					$r .= $r;
					$g .= $g;
					$b .= $b;
				} else {
					list($r, $g, $b) = sscanf( $color['hex'], "#%2x%2x%2x" );
				}
				
				$a = absint( $color['alpha'] ) / 100;
				
				$output .= "\tbackground-color: rgba($r, $g, $b, $a);\n";
			}
		} else {
			$output .= sprintf( "\tbackground-color: %s;\n", esc_attr( $color ) );
		}
	}
	
	if( $image != $defaults['image'] ) {
		$image = wp_get_attachment_image_src( $image, 'full' );
		$image = $image[0];
		$output .= "\tbackground-image: url(\"$image\");\n";
	}
	
	if( $position != $defaults['position'] ) {
		$position = str_replace( '-', ' ', $position );
		$output .= "\tbackground-position: $position;\n";
	}
	
	if( $repeat != $defaults['repeat'] ) {
		$output .= "\tbackground-repeat: $repeat;\n";
	}
	
	if( $size != $defaults['size'] ) {
		$output .= "\tbackground-size: $size;\n";
	}
	
	if( $scroll != $defaults['scroll'] ) {
		if( 'fixed' == $scroll ) {
			$output .= "\tbackground-attachment: fixed;\n";
		} else {
			$output .= "\tbackground-attachment: scroll;\n";
		}
	}
	
	$output .= "}\n";
	
	$output = apply_filters( 'enlightenment_print_background_options', $output );
	
	if( ! $echo ) {
		return $output;
	}
	
	echo $output;
}

add_filter( 'enlightenment_print_background_options', 'enlightenment_sanitize_custom_css' );

function enlightenment_print_font_options( $selector, $option, $echo = true ) {
	$defaults = enlightenment_default_theme_options();
	
	$fonts  = enlightenment_available_fonts();
	$family = enlightenment_theme_option( $option . '_font_family' );
	$size   = enlightenment_theme_option( $option . '_font_size' );
	$variant  = enlightenment_theme_option( $option . '_font_style' );
	$color  = enlightenment_theme_option( $option . '_font_color' );
	
	$output = '';
	if( $family != $defaults[$option . '_font_family'] || $size != $defaults[$option . '_font_size'] || $variant != $defaults[$option . '_font_style'] || $color != $defaults[$option . '_font_color'] ) {
		$output .= "$selector {\n";
		
		if( $family != $defaults[$option . '_font_family'] )
			$output .= sprintf( "\tfont-family: %1s, %2s;\n", $fonts[$family]['family'], $fonts[$family]['category'] );
		
		if( $size != $defaults[$option . '_font_size'] )
			$output .= sprintf( "\tfont-size: %1s%2s;\n", $size, apply_filters( 'enlightenment_font_size_unit', 'px' ) );
		
		if( $variant != $defaults[$option . '_font_style'] ) {
			if( false !== strpos( $variant, 'italic' ) )
				$output .= "\tfont-style: italic;\n";
			else
				$output .= "\tfont-style: normal;\n";
			
			switch( $variant ) {
				case '300':
				case '300italic':
					$output .= "\tfont-weight: 300;\n";
					break;
				case '400':
				case 'italic':
					$output .= "\tfont-weight: 400;\n";
					break;
				case '500':
				case '500italic':
					$output .= "\tfont-weight: 500;\n";
					break;
				case '600':
				case '600italic':
					$output .= "\tfont-weight: 600;\n";
					break;
				case '700':
				case '700italic':
					$output .= "\tfont-weight: 700;\n";
					break;
			}
		}
		
		if( $color != $defaults[$option . '_font_color'] )
			$output .= "\tcolor: $color;\n";
		
		$output .= "}\n";
	}
	
	$output = apply_filters( 'enlightenment_print_font_options', $output );
	if( ! $echo )
		return $output;
	echo $output;
}

add_filter( 'enlightenment_print_font_options', 'enlightenment_sanitize_custom_css' );

function enlightenment_available_fonts() {
	$fonts = array(
		'Helvetica Neue' => array(
			'category' => 'sans-serif',
			'family' => '"Helvetica Neue", Helvetica, "Nimbus Sans L"',
		),
		'Geneva' => array(
			'category' => 'sans-serif',
			'family' => 'Geneva, Verdana, "DejaVu Sans"',
		),
		'Tahoma' => array(
			'category' => 'sans-serif',
			'family' => 'Tahoma, "DejaVu Sans"',
		),
		'Trebuchet MS' => array(
			'category' => 'sans-serif',
			'family' => '"Trebuchet MS", "Bitstream Vera Sans"',
		),
		'Lucida Grande' => array(
			'category' => 'sans-serif',
			'family' => '"Lucida Grande", "Lucida Sans Unicode", "Bitstream Vera Sans"',
		),
		'Georgia' => array(
			'category' => 'serif',
			'family' => 'Georgia, "URW Bookman L"',
		),
		'Times' => array(
			'category' => 'serif',
			'family' => 'Times, "Times New Roman", "Century Schoolbook L"',
		),
		'Palatino' => array(
			'category' => 'serif',
			'family' => 'Palatino, "Palatino Linotype", "URW Palladio L"',
		),
		'Courier' => array(
			'category' => 'monospace',
			'family' => 'Courier, "Courier New", "Nimbus Mono L"',
		),
		'Monaco' => array(
			'category' => 'monospace',
			'family' => 'Monaco, Consolas, "Lucida Console", "Bitstream Vera Sans Mono"',
		),
	);
	if( current_theme_supports( 'enlightenment-web-fonts' ) ) {
		$web_fonts = enlightenment_web_fonts();
		$fonts = array_merge( $fonts, $web_fonts );
	}
	return apply_filters( 'enlightenment_available_fonts', $fonts );
}

function enlightenment_print_color_option( $selector, $option, $echo = true ) {
	$default_options = enlightenment_default_theme_options();
	
	if( ! isset( $default_options[ $option ] ) ) {
		$default_options[ $option ] = false;
	}
	
	$defaults = apply_filters( 'enlightenment_print_color_option_settings_defaults', $default_options[ $option ], $selector, $option );
	
	$color = apply_filters( 'enlightenment_print_color_option_settings', enlightenment_theme_option( $option ), $selector, $option );
	$output = '';
	
	if( $color != $defaults ) {
		$output  = "$selector {\n";
		
		if( is_array( $color ) ) {
			if( isset( $color['transparent'] ) && $color['transparent'] ) {
				$output .= "\tcolor: rgba(0, 0, 0, 0);\n";
			} else {
				if( strlen( $color['hex'] ) === 4 ) {
					list($r, $g, $b) = sscanf( $color['hex'], "#%1x%1x%1x" );
					
					$r .= $r;
					$g .= $g;
					$b .= $b;
				} else {
					list($r, $g, $b) = sscanf( $color['hex'], "#%2x%2x%2x" );
				}
				
				if( isset( $color['alpha'] ) ) {
					$a = absint( $color['alpha'] ) / 100;
				} else {
					$a = 1;
				}
				
				$output .= "\tcolor: rgba($r, $g, $b, $a);\n";
			}
		} else {
			$output .= "\tcolor: $color;\n";
		}
		$output .= "}\n";
	}
	
	$output = apply_filters( 'enlightenment_print_color_option', $output );
	if( ! $echo )
		return $output;
	echo $output;
}

add_filter( 'enlightenment_print_color_option', 'enlightenment_sanitize_custom_css' );

function enlightenment_print_background_color_option( $selector, $option, $echo = true ) {
	$default_options = enlightenment_default_theme_options();
	
	if( ! isset( $default_options[ $option ] ) ) {
		$default_options[ $option ] = false;
	}
	
	$defaults = apply_filters( 'enlightenment_print_background_color_option_settings_defaults', $default_options[ $option ], $selector, $option );
	
	$color = apply_filters( 'enlightenment_print_background_color_option_settings', enlightenment_theme_option( $option ), $selector, $option );
	$output = '';
	
	if( $color != $defaults ) {
		$output  = "$selector {\n";
		
		if( is_array( $color ) ) {
			if( isset( $color['transparent'] ) && $color['transparent'] ) {
				$output .= "\tbackground-color: transparent;\n";
			} else {
				if( strlen( $color['hex'] ) === 4 ) {
					list($r, $g, $b) = sscanf( $color['hex'], "#%1x%1x%1x" );
					
					$r .= $r;
					$g .= $g;
					$b .= $b;
				} else {
					list($r, $g, $b) = sscanf( $color['hex'], "#%2x%2x%2x" );
				}
				
				if( isset( $color['alpha'] ) ) {
					$a = absint( $color['alpha'] ) / 100;
				} else {
					$a = 1;
				}
				
				$output .= "\tbackground-color: rgba($r, $g, $b, $a);\n";
			}
		} else {
			$output .= sprintf( "\tbackground-color: %s;\n", esc_attr( $color ) );
		}
		
		$output .= "}\n";
	}
	
	$output = apply_filters( 'enlightenment_print_color_option', $output );
	if( ! $echo )
		return $output;
	echo $output;
}

add_filter( 'enlightenment_print_background_color_option', 'enlightenment_sanitize_custom_css' );

function enlightenment_sanitize_custom_css( $input, $default = false ) {
	$input = strip_tags( $input );
	$input = str_replace( 'behavior', '', $input );
	$input = str_replace( 'expression', '', $input );
	$input = str_replace( 'binding', '', $input );
	$input = str_replace( '@import', '', $input );
	return $input;
}



