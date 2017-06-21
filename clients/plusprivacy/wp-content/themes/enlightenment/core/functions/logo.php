<?php

add_action( 'after_setup_theme', 'enlightenment_logo_theme_support_args', 999 );

function enlightenment_logo_theme_support_args() {
	global $_wp_theme_features;
	$defaults = array(
		'crop_flag' => false,
	);
	$args = get_theme_support( 'enlightenment-logo' );
	if( is_array( $args ) )
		$args = array_shift( $args );
	else
		$args = $_wp_theme_features['enlightenment-logo'] = array();
	$args = wp_parse_args( $args, $defaults );
	$args = apply_filters( 'enlightenment_logo_theme_support_args', $args );
	if( ! isset( $args['width'] ) ) {
		_doing_it_wrong( 'add_theme_support( \'enlightenment-logo\' );', __( 'Please add the width parameter for your logo.', 'enlightenment' ), '' );
		return;
	}
	if( ! isset( $args['height'] ) ) {
		_doing_it_wrong( 'add_theme_support( \'enlightenment-logo\' );', __( 'Please add the height parameter for your logo.', 'enlightenment' ), '' );
		return;
	}
	$_wp_theme_features['enlightenment-logo'][0] = $args;
	add_image_size( 'enlightenment-logo', $args['width'], $args['height'], $args['crop_flag'] );
}

add_filter( 'current_theme_supports-enlightenment-logo', 'enlightenment_filter_current_theme_supports', 10, 3 );

add_filter( 'enlightenment_logo_theme_support_args', 'enlightenment_logo_theme_options_args' );

function enlightenment_logo_theme_options_args( $args ) {
	$logo = enlightenment_theme_option( 'logo' );
	if( is_array( $logo ) ) {
		if( isset( $logo['width'] ) )
			$args['width'] = $logo['width'];
		if( isset( $logo['height'] ) )
			$args['height'] = $logo['height'];
		if( isset( $logo['crop_flag'] ) )
			$args['crop_flag'] = $logo['crop_flag'];
	}
	return $args;
}

function enlightenment_logo_image_src() {
	$logo = enlightenment_theme_option( 'logo' );
	$logo_id = is_array( $logo ) && isset( $logo['image'] ) ? $logo['image'] : false;
	if( false === $logo_id )
		$logo = false;
	else {
		$logo = wp_get_attachment_image_src( $logo_id, 'enlightenment-logo' );
		$logo = $logo[0];
	}
	return esc_url( apply_filters( 'enlightenment_logo_image_src', $logo[0] ) );
}

function enlightenment_logo_image( $args = null ) {
	$defaults = array(
		'class' => 'site-logo',
		'alt' => get_bloginfo( 'name' ),
	);
	$defaults = apply_filters( 'enlightenment_logo_image_args', $defaults );
	$args = wp_parse_args( $args, $defaults );
	$logo = enlightenment_theme_option( 'logo' );
	$logo_id = is_array( $logo ) && isset( $logo['image'] ) ? $logo['image'] : false;
	if( false === $logo_id && current_theme_supports( 'enlightenment-logo', 'default-image' ) )
		$logo = '<img' . enlightenment_class( $args['class'] ) . ( empty( $args['alt'] ) ? '' : 'alt="' . esc_attr( $args['alt'] ) . '"' ) . ' src="' . esc_url( current_theme_supports( 'enlightenment-logo', 'default-image' ) ) . '" />';
	elseif( false == $logo_id )
		$logo = '';
	else
		$logo = wp_get_attachment_image( $logo_id, 'enlightenment-logo', false, $args );
	return apply_filters( 'enlightenment_logo_image', $logo );
}

add_filter( 'enlightenment_site_title', 'enlightenment_site_title_logo' );

function enlightenment_site_title_logo( $site_title ) {
	$logo = enlightenment_logo_image();
	if( ! empty( $logo ) && apply_filters( 'enlightenment_site_title_logo', true ) ) {
		if( apply_filters( 'enlightenment_hide_site_title_text', false ) )
			$site_title = sprintf( '%1$s <span class="site-title-text hidden">%2$s</span>', $logo, $site_title );
		else
			$site_title = sprintf( '%1$s <span class="site-title-text">%2$s</span>', $logo, $site_title );
	}
	return $site_title;
}

add_filter( 'enlightenment_site_title_logo', 'enlightenment_site_title_logo_theme_option' );

function enlightenment_site_title_logo_theme_option( $option ) {
	$logo = enlightenment_theme_option( 'logo' );
	if( is_array( $logo ) && isset( $logo['insert_site_title'] ) )
		return $logo['insert_site_title'];
	return $option;
}

add_filter( 'enlightenment_hide_site_title_text', 'enlightenment_hide_site_title_text_theme_option' );

function enlightenment_hide_site_title_text_theme_option( $option ) {
	$logo = enlightenment_theme_option( 'logo' );
	if( is_array( $logo ) && isset( $logo['hide_text'] ) )
		return $logo['hide_text'];
	return $option;
}

function enlightenment_logo_image_wrap_home_link( $logo ) {
	return '<a href="' . home_url( '/' ) . '">' . $logo . '</a>';
}




