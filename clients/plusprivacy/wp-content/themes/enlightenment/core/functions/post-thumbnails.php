<?php

function enlightenment_filter_post_thumbnail_attr( $attr ) {
	return apply_filters( 'enlightenment_filter_post_thumbnail_attr', $attr );
}

add_filter( 'enlightenment_filter_post_thumbnail_attr', 'enlightenment_post_thumbnail_title' );

function enlightenment_post_thumbnail_title( $attr ) {
	$attr['alt'] = the_title_attribute( array('echo' => 0 ) );
	$attr['title'] = the_title_attribute( array('echo' => 0 ) );
	return $attr;
}

add_action( 'begin_fetch_post_thumbnail_html', 'enlightenment_add_filter_post_thumbnail_attr' );

function enlightenment_add_filter_post_thumbnail_attr() {
	add_filter( 'wp_get_attachment_image_attributes', 'enlightenment_filter_post_thumbnail_attr' );
}

add_action( 'end_fetch_post_thumbnail_html', 'enlightenment_remove_filter_post_thumbnail_attr' );

function enlightenment_remove_filter_post_thumbnail_attr() {
	remove_filter( 'wp_get_attachment_image_attributes', 'enlightenment_filter_post_thumbnail_attr' );
}

add_filter( 'post_thumbnail_html', 'enlightenment_post_thumbnail_link' );

function enlightenment_post_thumbnail_link( $html ) {
	global $enlightenment_custom_query_name;
	if( '' != $html && ( ! is_singular() || isset( $enlightenment_custom_query_name ) ) )
		$html = '<a href="' . get_permalink() . '" title="' . the_title_attribute( array( 'echo' => 0 ) ) . '">' . "\n" . $html . "\n" . '</a>' . "\n";
	return $html;
}

add_filter( 'post_thumbnail_html', 'enlightenment_post_thumbnail_wrap' );

function enlightenment_post_thumbnail_wrap( $html, $args = null ) {
	$defaults = array(
		'container' => 'figure',
		'container_class' => 'entry-media',
	);
	$defaults = apply_filters( 'enlightenment_post_thumbnail_wrap_args', $defaults );
	$args = wp_parse_args( $args, $defaults );
	if( '' != $html ) {
		$output = enlightenment_open_tag( $args['container'], $args['container_class'] );
		$output .= $html . "\n";
		$output .= enlightenment_close_tag( $args['container'] );
		return $output;
	}
}

if( current_theme_supports( 'enlightenment-post-thumbnail-header' ) ) {
	
	add_filter( 'theme_mod_header_image', 'enlightenment_post_header_image' );

	function enlightenment_post_header_image( $url ) {
		if( is_singular() && has_post_thumbnail() ) {
			$url = wp_get_attachment_image_src( get_post_thumbnail_id(), 'full' );
			$url = $url[0];
		}
		return $url;
	}

}

add_filter( 'enlightenment_filter_post_thumbnail_attr', 'enlightenment_strip_accidental_attachment_image_attributes' );

function enlightenment_strip_accidental_attachment_image_attributes( $attr ) {
	unset( $attr["</a></h2>\n"] );
	return $attr;
}



