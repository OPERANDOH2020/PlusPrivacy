<?php

function enlightenment_menu_icons() {
	$icons = array(
		'' => __( 'None', 'enlightenment' ),
		'home' => __( 'Home', 'enlightenment' ),
		'pencil' => __( 'Pencil', 'enlightenment' ),
		'paperclip' => __( 'Paper Clip', 'enlightenment' ),
		'edit' => __( 'Edit', 'enlightenment' ),
		'picture' => __( 'Picture', 'enlightenment' ),
		'camera' => __( 'Camera', 'enlightenment' ),
		'music' => __( 'Audio', 'enlightenment' ),
		'film' => __( 'Video', 'enlightenment' ),
		'cloud' => __( 'Cloud', 'enlightenment' ),
		'comment' => __( 'Comment', 'enlightenment' ),
		'file' => __( 'File', 'enlightenment' ),
		'th' => __( 'Grid', 'enlightenment' ),
		'cog' => __( 'Settings', 'enlightenment' ),
		'flag' => __( 'Flag', 'enlightenment' ),
		'folder-open' => __( 'Folder', 'enlightenment' ),
		'globe' => __( 'Globe', 'enlightenment' ),
		'map-marker' => __( 'Map Marker', 'enlightenment' ),
		'shopping-cart' => __( 'Shopping Cart', 'enlightenment' ),
		'tag' => __( 'Tag', 'enlightenment' ),
		'user' => __( 'User', 'enlightenment' ),
		'search' => __( 'Search', 'enlightenment' ),
		'calendar' => __( 'Calendar', 'enlightenment' ),
		'bookmark' => __( 'Bookmark', 'enlightenment' ),
		'cloud-download' => __( 'Download', 'enlightenment' ),
		'upload' => __( 'Upload', 'enlightenment' ),
		'eye-open' => __( 'Eye', 'enlightenment' ),
		'flash' => __( 'Flash', 'enlightenment' ),
		'heart' => __( 'Heart', 'enlightenment' ),
		'leaf' => __( 'Leaf', 'enlightenment' ),
		'play' => __( 'Play', 'enlightenment' ),
		'plus-sign' => __( 'Plus', 'enlightenment' ),
		'pushpin' => __( 'Pin', 'enlightenment' ),
		'refresh' => __( 'Refresh', 'enlightenment' ),
		'remove' => __( 'Remove', 'enlightenment' ),
		'star' => __( 'Star', 'enlightenment' ),
		'time' => __( 'Time', 'enlightenment' ),
	);
	return apply_filters( 'enlightenment_menu_icons', $icons );
}

add_filter( 'wp_setup_nav_menu_item', 'enlightenment_menu_icons_item_element' );

function enlightenment_menu_icons_item_element( $menu_item ) {
	$menu_item->icon = get_post_meta( $menu_item->ID, '_enlightenment_menu_item_icon', true );
    return $menu_item;
}

add_filter( 'nav_menu_css_class', 'enlightenment_menu_icons_nav_menu_css_class', 10, 3 );

function enlightenment_menu_icons_nav_menu_css_class( $classes, $item, $args ) {
	if( '' != $item->icon )
		$classes[] = 'menu-item-has-icon';
	return $classes;
}

add_filter( 'enlightenment_nav_menu_link_before', 'enlightenment_menu_icons_nav_menu_link_before', 10, 2 );

function enlightenment_menu_icons_nav_menu_link_before( $output, $item ) {
	if( '' != $item->icon )
		$output .= '<span class="glyphicon glyphicon-' . esc_attr( $item->icon ) . '"></span> ';
	return $output;
}



