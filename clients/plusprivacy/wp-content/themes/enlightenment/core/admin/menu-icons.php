<?php

add_filter( 'wp_edit_nav_menu_walker', 'enlightenment_menu_icons_nav_menu_walker', 10, 2 );

function enlightenment_menu_icons_nav_menu_walker( $walker, $menu_id ) {
	require_once( enlightenment_admin_directory() . '/menu-icons-walker.php' );
	return 'Enlightenment_Walker_Nav_Menu_Edit';
}

add_action( 'admin_enqueue_scripts', 'enlightenment_menu_icons_enqueue_scripts' );

function enlightenment_menu_icons_enqueue_scripts( $hook_suffix ) {
	if( 'nav-menus.php' == $hook_suffix ) {
		wp_enqueue_style( 'glyphicons', enlightenment_styles_directory_uri() . '/glyphicons.min.css', false, null );
		wp_enqueue_style( 'enlightenment-menu-icons', enlightenment_styles_directory_uri() . '/menu-icons.css', false, null );
		wp_enqueue_script( 'enlightenment-menu-icons', enlightenment_scripts_directory_uri() . '/menu-icons.js', array( 'jquery' ), null );
	}
}

add_action( 'wp_update_nav_menu_item', 'enlightenment_menu_icons_nav_fields', 10, 3 );

function enlightenment_menu_icons_nav_fields( $menu_id, $menu_item_db_id, $args ) {
	// Check if element is properly sent
	if ( isset( $_REQUEST['menu-item-icon'] ) && is_array( $_REQUEST['menu-item-icon'] ) ) {
		$icon = $_REQUEST['menu-item-icon'][$menu_item_db_id];
		update_post_meta( $menu_item_db_id, '_enlightenment_menu_item_icon', $icon );
	}
}