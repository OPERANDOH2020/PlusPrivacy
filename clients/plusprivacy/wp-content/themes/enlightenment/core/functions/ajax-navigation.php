<?php

add_action( 'after_setup_theme', 'enlightenment_ajax_navigation_theme_support_args', 999 );

function enlightenment_ajax_navigation_theme_support_args() {
	global $_wp_theme_features;
	$defaults = array(
		'selector' => '#posts-nav',
		'type' => 'GET',
		'next' => '.next a, a.next',
		'content' => '#content',
		'item' => '.hentry',
		'label' => __( 'Load more posts', 'enlightenment' ),
		'loading' => __( 'Loading&#8230;', 'enlightenment' ),
		'image' => enlightenment_images_directory_uri() . '/ajax-loader.gif',
	);
	$args = get_theme_support( 'enlightenment-ajax-navigation' );
	if( is_array( $args ) )
		$args = array_shift( $args );
	else
		$args = $_wp_theme_features['enlightenment-ajax-navigation'] = array();
	$args = wp_parse_args( $args, $defaults );
	$_wp_theme_features['enlightenment-ajax-navigation'][0] = $args;
}

add_filter( 'current_theme_supports-enlightenment-ajax-navigation', 'enlightenment_filter_current_theme_supports', 10, 3 );

add_action( 'wp_enqueue_scripts', 'enlightenment_enqueue_ajax_navigation_script' );

function enlightenment_enqueue_ajax_navigation_script() {
	$args = get_theme_support( 'enlightenment-ajax-navigation' );
	if( is_array( $args ) )
		$args = array_shift( $args );
	else
		$args = array();
	$args = apply_filters( 'enlightenment_ajax_navigation_script_args', $args );
	wp_enqueue_script( 'ajax-navigation' );
	wp_localize_script( 'ajax-navigation', 'enlightenment_ajax_navigation_args', $args );
}

add_filter( 'enlightenment_call_js', 'enlightenment_call_ajax_navigation_script' );

function enlightenment_call_ajax_navigation_script( $deps ) {
	$deps[] = 'ajax-navigation';
	return $deps;
}



