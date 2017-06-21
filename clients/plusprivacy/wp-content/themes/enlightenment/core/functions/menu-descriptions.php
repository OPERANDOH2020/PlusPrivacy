<?php

add_filter( 'nav_menu_css_class', 'enlightenment_menu_descriptions_nav_menu_css_class', 10, 3 );

function enlightenment_menu_descriptions_nav_menu_css_class( $classes, $item, $args ) {
	if( '' != $item->description )
		$classes[] = 'menu-item-has-description';
	return $classes;
}

add_filter( 'enlightenment_nav_menu_link_after', 'enlightenment_menu_descriptions_nav_menu_link_after', 10, 2 );

function enlightenment_menu_descriptions_nav_menu_link_after( $output, $item ) {
	if( '' != $item->description )
		$output .= '<br /><span class="menu-item-description">' . $item->description . '</span>';
	return $output;
}