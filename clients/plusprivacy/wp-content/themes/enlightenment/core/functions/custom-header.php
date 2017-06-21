<?php

add_filter( 'body_class', 'enlightenment_custom_header_body_class' );

function enlightenment_custom_header_body_class( $classes ) {
	if( '' != get_header_image() || get_header_textcolor() != get_theme_support( 'custom-header', 'default-text-color' ) ) {
		$classes[] = 'custom-header';
		
		if( '' != get_header_image() ) {
			$classes[] = 'custom-header-image';
		}
		
		if( get_header_textcolor() != get_theme_support( 'custom-header', 'default-text-color' ) ) {
			$classes[] = 'custom-header-textcolor';
			
			if( 'blank' == get_header_textcolor() ) {
				$classes[] = 'custom-header-blank-textcolor';
			}
		}
	}
	
	return $classes;
}