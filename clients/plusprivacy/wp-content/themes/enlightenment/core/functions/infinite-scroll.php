<?php

add_action( 'after_setup_theme', 'enlightenment_infinite_scroll_theme_support_args', 999 );

function enlightenment_infinite_scroll_theme_support_args() {
	global $_wp_theme_features;
	$defaults = array(
		'loading' => array(
			'img' => enlightenment_images_directory_uri() . '/ajax-loader-transparent.gif',
			'msgText' => __( 'Loading more posts &#8230;', 'enlightenment' ),
			'finishedMsg' => __( 'There are no more posts to display.', 'enlightenment' ),
		),
		'navSelector' => '#posts-nav',
		'nextSelector' => '.next a, a.next',
		'contentSelector' => '#primary',
		'itemSelector' => '.hentry',
		'debug' => false,
	);
	$args = get_theme_support( 'enlightenment-infinite-scroll' );
	if( is_array( $args ) )
		$args = array_shift( $args );
	else
		$args = $_wp_theme_features['enlightenment-infinite-scroll'] = array();
	$args = wp_parse_args( $args, $defaults );
	$_wp_theme_features['enlightenment-infinite-scroll'][0] = $args;
}

add_filter( 'current_theme_supports-enlightenment-infinite-scroll', 'enlightenment_filter_current_theme_supports', 10, 3 );

add_action( 'wp_enqueue_scripts', 'enlightenment_enqueue_infinite_scroll_script' );

function enlightenment_enqueue_infinite_scroll_script() {
	if( is_singular() )
		return;
	$args = get_theme_support( 'enlightenment-infinite-scroll' );
	if( is_array( $args ) )
		$args = array_shift( $args );
	else
		$args = array();
	$args = apply_filters( 'enlightenment_infinite_scroll_script_args', $args );
	wp_enqueue_script( 'infinitescroll' );
	wp_localize_script( 'infinitescroll', 'enlightenment_infinite_scroll_args', $args );
}

add_filter( 'enlightenment_call_js', 'enlightenment_call_infinite_scroll_script' );

function enlightenment_call_infinite_scroll_script( $deps ) {
	$deps[] = 'infinitescroll';
	return $deps;
}