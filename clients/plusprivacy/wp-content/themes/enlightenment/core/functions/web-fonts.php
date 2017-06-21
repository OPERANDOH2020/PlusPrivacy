<?php

function enlightenment_web_fonts() {
	$available_fonts = apply_filters( 'enlightenment_web_fonts', array(
		'Open Sans'  => array(
			'family' => 'Open Sans',
			'category' => 'sans-serif',
			'variants' => array( '300', '300italic', '400', 'italic', '600', '600italic', '700', '700italic' ),
			'subsets' => array( 'latin', 'latin-ext', 'greek', 'greek-ext', 'cyrillic', 'cyrillic-ext', 'vietnamese' ),
		),
		'Roboto' => array(
			'family' => 'Roboto',
			'category' => 'sans-serif',
			'variants' => array( '300', '300italic', '400', 'italic', '500', '500italic', '700', '700italic' ),
			'subsets' => array( 'latin', 'latin-ext', 'greek', 'greek-ext', 'cyrillic', 'cyrillic-ext', 'vietnamese' ),
		),
		'Source Sans Pro' => array(
			'family' => 'Source Sans Pro',
			'category' => 'sans-serif',
			'variants' => array( '300', '300italic', '400', 'italic', '600', '600italic', '700', '700italic' ),
			'subsets' => array( 'latin', 'latin-ext', 'vietnamese' ),
		),
		'Lato'       => array(
			'family' => 'Lato',
			'category' => 'sans-serif',
			'variants' => array( '300', '300italic', '400', 'italic', '700', '700italic' ),
			'subsets' => array( 'latin' ),
		),
		'Droid Sans' => array(
			'family' => 'Droid Sans',
			'category' => 'sans-serif',
			'variants' => array( '400', '700' ),
			'subsets' => array( 'latin' ),
		),
		'PT Sans'    => array(
			'family' => 'PT Sans',
			'category' => 'sans-serif',
			'variants' => array( '400', 'italic', '700', '700italic' ),
			'subsets' => array( 'latin', 'latin-ext', 'cyrillic, cyrillic-ext' ),
		),
		'Fira Sans'    => array(
			'family' => 'Fira Sans',
			'category' => 'sans-serif',
			'variants' => array( '300', '300italic', '400', 'italic', '500', '500italic', '700', '700italic' ),
			'subsets' => array( 'latin', 'latin-ext', 'greek', 'cyrillic', 'cyrillic-ext' ),
		),
		'Hind'    => array(
			'family' => 'Hind',
			'category' => 'sans-serif',
			'variants' => array( '300', '400', '500', '600', '700' ),
			'subsets' => array( 'latin', 'latin-ext', 'devanagari' ),
		),
		'Ek Mukta'    => array(
			'family' => 'Ek Mukta',
			'category' => 'sans-serif',
			'variants' => array( '300', '400', '500', '600', '700', '800' ),
			'subsets' => array( 'latin', 'latin-ext', 'devanagari' ),
		),
		'Noto Sans'    => array(
			'family' => 'Noto Sans',
			'category' => 'sans-serif',
			'variants' => array( '400', 'italic', '700', '700italic' ),
			'subsets' => array( 'latin', 'latin-ext', 'greek', 'greek-ext', 'cyrillic', 'cyrillic-ext', 'vietnamese', 'devanagari' ),
		),
		'Ubuntu' => array(
			'family' => 'Ubuntu',
			'category' => 'sans-serif',
			'variants' => array( '300', '300italic', '400', 'italic', '500', '500italic', '700', '700italic' ),
			'subsets' => array( 'latin', 'latin-ext', 'greek', 'greek-ext', 'cyrillic', 'cyrillic-ext' ),
		),
		'Cantarell'  => array(
			'family' => 'Cantarell',
			'category' => 'sans-serif',
			'variants' => array( '400', 'italic', '700', '700italic' ),
			'subsets' => array( 'latin' ),
		),
		'Raleway' => array(
			'family' => 'Raleway',
			'category' => 'sans-serif',
			'variants' => array( '300', '400', '500', '600', '700' ),
			'subsets' => array( 'latin' ),
		),
		'Oswald'     => array(
			'family' => 'Oswald',
			'category' => 'sans-serif',
			'variants' => array( '300', '400', '700' ),
			'subsets' => array( 'latin', 'latin-ext' ),
		),
		'Yanone Kaffeesatz' => array(
			'family' => 'Yanone Kaffeesatz',
			'category' => 'sans-serif',
			'variants' => array( '300', '400', '700' ),
			'subsets' => array( 'latin', 'latin-ext' ),
		),
		'Montserrat'     => array(
			'family' => 'Montserrat',
			'category' => 'sans-serif',
			'variants' => array( '400', '700' ),
			'subsets' => array( 'latin' ),
		),
		'Quattrocento Sans' => array(
			'family' => 'Quattrocento Sans',
			'category' => 'sans-serif',
			'variants' => array( '400', 'italic', '700', '700italic' ),
			'subsets' => array( 'latin', 'latin-ext' ),
		),
		'Arimo' => array(
			'family' => 'Arimo',
			'category' => 'sans-serif',
			'variants' => array( '400', 'italic', '700', '700italic' ),
			'subsets' => array( 'latin', 'latin-ext', 'greek', 'greek-ext', 'cyrillic', 'cyrillic-ext', 'vietnamese' ),
		),
		'Oxygen' => array(
			'family' => 'Oxygen',
			'category' => 'sans-serif',
			'variants' => array( '300', '400', '700' ),
			'subsets' => array( 'latin', 'latin-ext' ),
		),
		'Droid Serif' => array(
			'family' => 'Droid Serif',
			'category' => 'serif',
			'variants' => array( '400', 'italic', '700', '700italic' ),
			'subsets' => array( 'latin' ),
		),
		'Lora'       => array(
			'family' => 'Lora',
			'category' => 'serif',
			'variants' => array( '400', 'italic', '700', '700italic' ),
			'subsets' => array( 'latin' ),
		),
		'PT Serif'   => array(
			'family' => 'PT Serif',
			'category' => 'serif',
			'variants' => array( '400', 'italic', '700', '700italic' ),
			'subsets' => array( 'latin', 'latin-ext', 'cyrillic, cyrillic-ext' ),
		),
		'Arvo' => array(
			'family' => 'Arvo',
			'category' => 'serif',
			'variants' => array( '400', 'italic', '700', '700italic' ),
			'subsets' => array( 'latin' ),
		),
		'Roboto Slab' => array(
			'family' => 'Roboto Slab',
			'category' => 'serif',
			'variants' => array( '300', '400', '700' ),
			'subsets' => array( 'latin', 'latin-ext', 'greek', 'greek-ext', 'cyrillic', 'cyrillic-ext', 'vietnamese' ),
		),
		'Bitter'       => array(
			'family' => 'Bitter',
			'category' => 'serif',
			'variants' => array( '400', 'italic', '700' ),
			'subsets' => array( 'latin', 'latin-ext' ),
		),
		'Merriweather' => array(
			'family' => 'Merriweather',
			'category' => 'serif',
			'variants' => array( '300', '300italic', '400', 'italic', '700', '700italic' ),
			'subsets' => array( 'latin', 'latin-ext' ),
		),
		'Crimson Text' => array(
			'family' => 'Crimson Text',
			'category' => 'serif',
			'variants' => array( '400', 'italic', '600', '600italic', '700', '700italic' ),
			'subsets' => array( 'latin' ),
		),
		'Neuton' => array(
			'family' => 'Neuton',
			'category' => 'serif',
			'variants' => array( '200', '300', '400', 'italic', '700', '700italic' ),
			'subsets' => array( 'latin', 'latin-ext' ),
		),
		'Playfair Display' => array(
			'family' => 'Playfair Display',
			'category' => 'serif',
			'variants' => array( '400', 'italic', '700', '700italic', '900', '900italic' ),
			'subsets' => array( 'latin', 'latin-ext', 'cyrillic' ),
		),
		'Libre Baskerville' => array(
			'family' => 'Libre Baskerville',
			'category' => 'serif',
			'variants' => array( '400', 'italic', '700' ),
			'subsets' => array( 'latin', 'latin-ext' ),
		),
		'Gentium Basic' => array(
			'family' => 'Gentium Basic',
			'category' => 'serif',
			'variants' => array( '400', 'italic', '700', '700italic' ),
			'subsets' => array( 'latin', 'latin-ext' ),
		),
		'Gentium Book Basic' => array(
			'family' => 'Gentium Book Basic',
			'category' => 'serif',
			'variants' => array( '400', 'italic', '700', '700italic' ),
			'subsets' => array( 'latin', 'latin-ext' ),
		),
		'Sorts Mill Goudy' => array(
			'family' => 'Sorts Mill Goudy',
			'category' => 'serif',
			'variants' => array( '400', 'italic' ),
			'subsets' => array( 'latin', 'latin-ext' ),
		),
		'Halant' => array(
			'family' => 'Halant',
			'category' => 'serif',
			'variants' => array( '400', '500', '600', '700' ),
			'subsets' => array( 'latin', 'latin-ext', 'devanagari' ),
		),
		'Domine' => array(
			'family' => 'Domine',
			'category' => 'serif',
			'variants' => array( '400', '700' ),
			'subsets' => array( 'latin', 'latin-ext' ),
		),
		'Poly' => array(
			'family' => 'Poly',
			'category' => 'serif',
			'variants' => array( '400', 'italic' ),
			'subsets' => array( 'latin' ),
		),
		'Ovo' => array(
			'family' => 'Ovo',
			'category' => 'serif',
			'variants' => array( '400' ),
			'subsets' => array( 'latin' ),
		),
	) );
	return $available_fonts;
}

add_filter( 'enlightenment_web_fonts', 'enlightenment_theme_options_web_fonts' );

function enlightenment_theme_options_web_fonts( $fonts ) {
	$option = enlightenment_theme_option( 'web_fonts' );
	if( is_array( $option ) )
		$fonts = array_merge( $fonts, $option );
	return $fonts;
}

function enlightenment_theme_support_fonts( $available_fonts ) {
	$fonts = get_theme_support( 'enlightenment-web-fonts' );
	if( ! is_array( $fonts ) )
		return $available_fonts;
	$fonts = array_shift( $fonts );
	return wp_parse_args( $fonts, $available_fonts );
}

add_action( 'after_setup_theme', 'enlightenment_web_fonts_theme_support_args', 999 );

function enlightenment_web_fonts_theme_support_args() {
	$defaults = array(
		'variants' => array( '400', 'italic', '700' ),
		'subsets' => array( 'latin' ),
		'google_api_key' => '',
		'filter_by_subsets' => true,
		'live_preview_fonts' => false,
		'sort_fonts_by' => 'popularity',
	);
	$args = get_theme_support( 'enlightenment-web-fonts' );
	$args = is_array( $args ) ? array_shift( $args ) : array();
	$args = wp_parse_args( $args, $defaults );
	$args = apply_filters( 'enlightenment_web_fonts_theme_support_args', $args );
	global $_wp_theme_features;
	if( ! is_array( $_wp_theme_features['enlightenment-web-fonts'] ) )
		$_wp_theme_features['enlightenment-web-fonts'] = array();
	$_wp_theme_features['enlightenment-web-fonts'][0] = $args;
}

add_filter( 'current_theme_supports-enlightenment-web-fonts', 'enlightenment_filter_current_theme_supports', 10, 3 );

add_filter( 'enlightenment_web_fonts_theme_support_args', 'enlightenment_web_fonts_theme_options_args' );

function enlightenment_web_fonts_theme_options_args( $args ) {
	$subsets = enlightenment_theme_option( 'subsets' );
	if( ! empty( $subsets ) )
		$args['subsets'] = $subsets;
	$google_api_key = enlightenment_theme_option( 'google_api_key' );
	if( ! empty( $google_api_key ) || '' === $google_api_key )
		$args['google_api_key'] = esc_attr( $google_api_key );
	$filter_by_subsets = enlightenment_theme_option( 'filter_by_subsets' );
	if( ! empty( $filter_by_subsets ) || false === $filter_by_subsets )
		$args['filter_by_subsets'] = $filter_by_subsets;
	$live_preview_fonts = enlightenment_theme_option( 'live_preview_fonts' );
	if( ! empty( $live_preview_fonts ) || false === $live_preview_fonts )
		$args['live_preview_fonts'] = $live_preview_fonts;
	$sort_fonts_by = enlightenment_theme_option( 'sort_fonts_by' );
	if( ! empty( $sort_fonts_by ) )
		$args['sort_fonts_by'] = $sort_fonts_by;
	return $args;
}

function enlightenment_fonts_to_load() {
	global $enlightenment_web_fonts;
	if( ! isset( $enlightenment_web_fonts ) )
		$enlightenment_web_fonts = array();

	do_action( 'enlightenment_enqueue_fonts' );
	
	return apply_filters( 'enlightenment_fonts_to_load', $enlightenment_web_fonts );
}

function enlightenment_enqueue_font( $font, $styles = null ) {
	if( null === $styles )
		$styles = current_theme_supports( 'enlightenment-web-fonts', 'variants' );
	global $enlightenment_web_fonts;
	if( ! isset( $enlightenment_web_fonts ) )
		$enlightenment_web_fonts = array();
	$fonts = enlightenment_web_fonts();
	if( array_key_exists( $font, $fonts ) ) {
		if( isset( $enlightenment_web_fonts[$font] ) )
			$enlightenment_web_fonts[$font] = array_unique( array_merge( $enlightenment_web_fonts[$font], $styles ) );
		else
			$enlightenment_web_fonts[$font] = $styles;
	}
}

function enlightenment_dequeue_font( $font ) {
	global $enlightenment_web_fonts;
	if( ! isset( $enlightenment_web_fonts ) )
		return;
	if( array_key_exists( $font, $enlightenment_web_fonts ) ) {
		unset( $enlightenment_web_fonts[$font] );
		$enlightenment_web_fonts = array_values( $enlightenment_web_fonts );
	}
}

function enlightenment_web_fonts_style( $args = null ) {
	$defaults = array(
		'variants' => current_theme_supports( 'enlightenment-web-fonts', 'variants' ),
		'subsets' => current_theme_supports( 'enlightenment-web-fonts', 'subsets' ),
	);
	$defaults = apply_filters( 'enlightenment_web_fonts_style_args', $defaults );
	$args = wp_parse_args( $args, $defaults );
	$fonts = enlightenment_fonts_to_load();
	if( ! empty( $fonts ) ) {
		global $enlightenment_web_fonts_errors;
		if( ! isset( $enlightenment_web_fonts_errors ) )
			$enlightenment_web_fonts_errors = array();
		$stylesheet = 'http' . ( is_ssl() ? 's' : '' ) . '://fonts.googleapis.com/css?family=';
		foreach( $fonts as $font => $styles ) {
			if( empty( $styles ) )
				$styles = $args['variants'];
			$atts = enlightenment_get_font_atts( $font );
			
			/* Backwards compatibility code, to be removed in a future version */
			foreach( $atts['variants'] as $key => $variant ) {
				$variant = str_replace( 'light', '300', $variant );
				$variant = str_replace( 'normal', '400', $variant );
				$variant = str_replace( 'medium', '700', $variant );
				$variant = str_replace( 'semibold', '600', $variant );
				$variant = str_replace( 'bold', '700', $variant );
				$atts['variants'][$key] = $variant;
			}
			
			foreach( $styles as $key => $style ) {
				if( ! in_array( $style, $atts['variants'], true ) ) {
					unset( $styles[$key] );
				}
			}
			$styles = array_values( $styles );
			foreach( $args['subsets'] as $key => $subset )
				if( ! in_array( $subset, $atts['subsets'] ) )
					$enlightenment_web_fonts_errors[] = sprintf( __( 'The font "%1$s" does not support your selected subset <code>%2$s</code>.', 'enlightenment' ), $font, $subset );
			$fonts[$font] = array_values( $styles );
		}
		$i = 0;
		$c = count( $fonts );
		foreach( $fonts as $font => $styles ) {
			$i++;
			$font = str_replace( ' ', '+', $font );
			$stylesheet .= $font;
			if( ! empty( $styles ) && array( '400' ) != $styles ) {
				$stylesheet .= ':';
				$tmpstyles = $styles;
				$laststyle = array_pop( $tmpstyles );
				unset( $tmpstyles );
				foreach( $styles as $style ) {
					$stylesheet .= $style;
					if( $style != $laststyle ) {
						$stylesheet .= ',';
					}
				}
			}
			if( $i != $c )
				$stylesheet .= '|';
		}
		$stylesheet .= '&subset=';
		foreach( $args['subsets'] as $subset ) {
			$stylesheet .= $subset;
				if( $subset != end( $args['subsets'] ) )
					$stylesheet .= ',';
		}
		return esc_url( $stylesheet );
	}
	return false;
}

function enlightenment_get_font_atts( $font ) {
	$fonts = enlightenment_web_fonts();
	if( isset( $fonts[$font] ) )
		return $fonts[$font];
	return false;
}

add_action( 'init', 'enlightenment_register_web_fonts_style' );

function enlightenment_register_web_fonts_style() {
	$fonts = enlightenment_fonts_to_load();
	if( ! empty( $fonts ) )
		wp_register_style( 'enlightenment-web-fonts', enlightenment_web_fonts_style(), false, null );
}

add_filter( 'enlightenment_theme_stylesheet_deps', 'enlightenment_web_fonts_theme_stylesheet_deps' );

function enlightenment_web_fonts_theme_stylesheet_deps( $deps ) {
	$fonts = enlightenment_fonts_to_load();
	if( ! empty( $fonts ) )
		$deps[] = 'enlightenment-web-fonts';
	return $deps;
}

add_filter( 'enlightenment_theme_option-subsets', 'enlightenment_default_subsets' );

function enlightenment_default_subsets( $option ) {
	if( empty( $option ) )
		$option = apply_filters( 'enlightenment_default_subsets', current_theme_supports( 'enlightenment-web-fonts', 'subsets' ) );
	return $option;
}



