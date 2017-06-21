<?php

function enlightenment_available_layouts() {
	$layouts = array(
		'content-sidebar' => array(
			'name'          => __( 'Content / Sidebar', 'enlightenment' ),
			'image'         => enlightenment_images_directory_uri() . '/content-sidebar.png',
			'body_class'    => 'layout-content-sidebar',
			'content_class' => '',
			'sidebar_class' => '',
			'extra_atts'    => '',
		),
		'sidebar-content' => array(
			'name'          => __( 'Sidebar / Content', 'enlightenment' ),
			'image'         => enlightenment_images_directory_uri() . '/sidebar-content.png',
			'body_class'    => 'layout-sidebar-content',
			'content_class' => '',
			'sidebar_class' => '',
			'extra_atts'    => '',
		),
		'full-width' => array(
			'name'          => __( 'Full Width', 'enlightenment' ),
			'image'         => enlightenment_images_directory_uri() . '/full-width.png',
			'body_class'    => 'layout-full-width',
			'content_class' => '',
			'sidebar_class' => '',
			'extra_atts'    => '',
		),
	);
	global $enlightenment_registered_layouts;
	$enlightenment_registered_layouts = array();
	do_action( 'enlightenment_register_layouts' );
	$layouts = array_merge( $layouts, $enlightenment_registered_layouts );
	return apply_filters( 'enlightenment_available_layouts', $layouts );
}

function enlightenment_register_layout( $handle, $name, $image, $body_class = '', $content_class = '', $sidebar_class = '', $extra_atts = '' ) {
	global $enlightenment_registered_layouts;
	$enlightenment_registered_layouts[ $handle ] = array(
		'name'          => $name,
		'image'         => $image,
		'body_class'    => $body_class,
		'content_class' => $content_class,
		'sidebar_class' => $sidebar_class,
		'extra_atts'    => $extra_atts,
	);
}

add_action( 'after_setup_theme', 'enlightenment_theme_supported_layouts', 999 );

function enlightenment_theme_supported_layouts() {
	$layouts = get_theme_support( 'enlightenment-custom-layouts' );
	$layouts = is_array( $layouts ) ? array_shift( $layouts ) : array();
	if( empty( $layouts ) ) {
		_doing_it_wrong( 'add_theme_support( \'enlightenment-custom-layouts\' );', __( 'An array of supported layouts needs to be specified as second parameter.', 'enlightenment' ), '' );
	} elseif( 1 == count( $layouts ) ) {
		_doing_it_wrong( 'add_theme_support( \'enlightenment-custom-layouts\' );', __( 'At least two layouts need to be supported to use this feature.', 'enlightenment' ), '' );
	} else {
		$available_layouts = enlightenment_available_layouts();
		foreach ( $layouts as $layout ) {
			if( ! array_key_exists( $layout, $available_layouts ) )
				_doing_it_wrong( 'add_theme_support( \'enlightenment-custom-layouts\' );', sprintf( __( 'The layout \'%1$s\' does not exist. You can create it using the <a href="%2$s">enlightenment_register_layout()</a> function.', 'enlightenment' ), esc_attr( $layout ), esc_url( 'http://enlightenmentcore.com/documentation/function-reference/enlightenment_register_layout' ) ), '' );
		}
	}
}

function enlightenment_custom_layouts() {
	$theme_support = get_theme_support( 'enlightenment-custom-layouts' );
	$supported_layouts = array_shift( $theme_support );
	$available_layouts = enlightenment_available_layouts();
	$layouts = array();
	foreach ( $available_layouts as $layout => $atts ) {
		if( in_array( $layout, $supported_layouts ) )
			$layouts[ $layout ] = $atts;
	}
	return apply_filters( 'enlightenment_custom_layouts', $layouts );
}

function enlightenment_archive_layouts() {
	$layouts = array(
		'error404'   => enlightenment_default_layout(),
		'search'     => enlightenment_default_layout(),
		'blog'       => enlightenment_default_layout(),
		'post'       => enlightenment_default_layout(),
		'page'       => 'full-width',
		'author'     => enlightenment_default_layout(),
		'date'       => enlightenment_default_layout(),
	);
	$post_types = get_post_types( array( 'has_archive' => true ) );
	foreach( $post_types as $post_type )
		$layouts[$post_type . '-archive'] = enlightenment_default_layout();
	$post_types = get_post_types( array( 'publicly_queryable' => true ) );
	foreach( $post_types as $post_type )
		$layouts[$post_type] = enlightenment_default_layout();
	$taxonomies = get_taxonomies( array( 'public' => true ) );
	unset( $taxonomies['post_format'] );
	foreach( $taxonomies as $taxonomy )
		$layouts[$taxonomy] = enlightenment_default_layout();
	return apply_filters( 'enlightenment_archive_layouts', $layouts );
}

function enlightenment_default_layout() {
	return apply_filters( 'enlightenment_default_layout', 'content-sidebar' );
}

add_filter( 'enlightenment_archive_layouts', 'enlightenment_archive_layouts_merge_theme_options' );

function enlightenment_archive_layouts_merge_theme_options( $layouts ) {
	$options = enlightenment_theme_option( 'layouts' );
	if( ! is_array( $options ) )
		$options = array();
	return array_merge( $layouts, $options );
}

function enlightenment_current_layout() {
	if( is_admin() )
		return;
	$layouts = enlightenment_archive_layouts();
	if( is_404() )
		$layout = $layouts['error404'];
	elseif( is_search() )
		$layout = $layouts['search'];
	elseif( is_home() )
		$layout = $layouts['blog'];
	elseif( is_author() )
		$layout = $layouts['author'];
	elseif( is_date() )
		$layout = $layouts['date'];
	elseif( is_category() )
		$layout = $layouts['category'];
	elseif( is_tag() )
		$layout = $layouts['post_tag'];
	elseif( is_post_type_archive() )
		$layout = $layouts[ get_query_var( 'post_type' ) . '-archive' ];
	elseif( is_tax( 'post_format' ) )
		$layout = $layouts['blog'];
	elseif( is_tax() )
		$layout = $layouts[ get_queried_object()->taxonomy ];
	elseif( is_singular() ) {
		if( '' != get_post_meta( get_the_ID(), '_enlightenment_custom_layout', true ) )
			$layout = get_post_meta( get_the_ID(), '_enlightenment_custom_layout', true );
		elseif( ! is_singular( array( 'post', 'page', 'attachment' ) ) )
			$layout = $layouts[ get_post_type() ];
		elseif( is_single() )
			$layout = $layouts['post'];
		elseif( is_page() )
			$layout = $layouts['page'];
	}
	return apply_filters( 'enlightenment_current_layout', $layout );
}

add_filter( 'is_active_sidebar', 'enlightenment_remove_sidebar_in_full_width', 8, 2 );

function enlightenment_remove_sidebar_in_full_width( $is_active_sidebar, $index ) {
	if( 'full-width' == enlightenment_current_layout() && 'sidebar-1' == $index )
		return false;
	return $is_active_sidebar;
}

function enlightenment_get_layout( $layout ) {
	$layouts = enlightenment_custom_layouts();
	if( isset( $layouts[$layout] ) )
		return $layouts[$layout];
	return false;
}

add_filter( 'body_class', 'enlightenment_set_layout_body_class' );

function enlightenment_set_layout_body_class( $classes ) {
	$layout = enlightenment_get_layout( enlightenment_current_layout() );
	if( ! empty( $layout['body_class'] ) )
		$classes[] = $layout['body_class'];
	return $classes;
}

add_filter( 'enlightenment_content_class_args', 'enlightenment_set_layout_content_class' );

function enlightenment_set_layout_content_class( $args ) {
	$layout = enlightenment_get_layout( enlightenment_current_layout() );
	if( ! empty( $layout['content_class'] ) )
		$args['class'] .= ' ' . $layout['content_class'];
	return $args;
}

add_filter( 'enlightenment_sidebar_class_args', 'enlightenment_set_layout_sidebar_class' );

function enlightenment_set_layout_sidebar_class( $args ) {
	$layout = enlightenment_get_layout( enlightenment_current_layout() );
	if( ! empty( $layout['sidebar_class'] ) && 'primary' == enlightenment_current_sidebar_name() )
		$args['class'] .= ' ' . $layout['sidebar_class'];
	return $args;
}



