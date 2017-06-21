<?php

add_filter( 'enlightenment_template_functions', 'enlightenment_post_formats_template_functions' );

function enlightenment_post_formats_template_functions( $functions ) {
	$f = apply_filters( 'enlightenment_post_formats_template_functions', array(
		'enlightenment_entry_gallery'       => __( 'Gallery Shortcode', 'enlightenment' ),
		'enlightenment_entry_video'         => __( 'Video Shortcode', 'enlightenment' ),
		'enlightenment_entry_audio'         => __( 'Audio Shortcode', 'enlightenment' ),
		'enlightenment_entry_image'         => __( 'Post Image', 'enlightenment' ),
		'enlightenment_entry_blockquote'    => __( 'Post Blockquote', 'enlightenment' ),
		'enlightenment_entry_author_avatar' => __( 'Author Avatar', 'enlightenment' ),
	) );
	return array_merge( $functions, $f );
}

function enlightenment_post_formats() {
	$formats = get_theme_support( 'post-formats' );
	$post_formats = array();
	foreach( $formats[0] as $format ) {
		$post_formats[ $format ] = get_post_format_string( $format );
		if( current_theme_supports( 'enlightenment-grid-loop' ) ) {
			$post_formats[ $format . '-teaser' ] = get_post_format_string( $format ) . ' Teaser';
		}
	}
	return apply_filters( 'enlightenment_post_formats', $post_formats );
}

add_action( 'enlightenment_before_entry', 'enlightenment_add_post_formats_actions', 8 );

function enlightenment_add_post_formats_actions() {
	if( is_admin() || is_singular() || '' == get_post_format()  )
		return;
	$hooks = enlightenment_theme_option( 'template_hooks' );
	$format = get_post_format();
	if( current_theme_supports( 'enlightenment-grid-loop' ) && ! enlightenment_is_lead_post() )
		$format = $format . '-teaser';
		
	if( isset( $hooks[$format] ) )
		foreach( $hooks[$format] as $hook => $functions ) {
			remove_all_actions( $hook, 10 );
			if( ! empty( $functions ) ) {
				foreach( $functions as $function )
					add_action( $hook, $function, 10, apply_filters( 'enlightenment_template_actions_accepted_args', 2 ) );
			}
		}
}