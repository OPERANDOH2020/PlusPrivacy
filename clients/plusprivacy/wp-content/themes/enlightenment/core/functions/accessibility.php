<?php

add_action( 'enlightenment_before_page', 'enlightenment_skip_link', 1 );

function enlightenment_skip_link( $args = false ) {
	$defaults = array(
		'container_class' => 'skip-link screen-reader-text',
		'target' => '#content',
		'text' => __( 'Skip to content', 'enlightenment' ),
		'echo' => true,
	);
	$defaults = apply_filters( 'enlightenment_skip_link_args', $defaults );
	$args = wp_parse_args( $args, $defaults );
	$output = enlightenment_open_tag( 'a', $args['container_class'], '', ' href="' . esc_url( $args['target'] ) . '" title="' . esc_attr( $args['text'] ) . '"' );
	$output .= strip_tags( $args['text'] );
	$output .= enlightenment_close_tag( 'a' );
	$output = apply_filters( 'enlightenment_skip_link', $output, $args );
	if( ! $args['echo'] )
		return $output;
	echo $output;
}

function enlightenment_nav_menu_title( $args = null ) {
	$defaults = array(
		'container' => 'h2',
		'container_class' => 'screen-reader-text',
		'text' => __( 'Menu', 'enlightenment' ),
		'echo' => true,
	);
	$defaults = apply_filters( 'enlightenment_nav_menu_title_args', $defaults );
	$args = wp_parse_args( $args, $defaults );
	$output = enlightenment_open_tag( $args['container'], $args['container_class'] );
	$output .= esc_attr( $args['text'] );
	$output .= enlightenment_close_tag( $args['container'] );
	$output = apply_filters( 'enlightenment_nav_menu_title', $output, $args );
	if( ! $args['echo'] )
		return $output;
	echo $output;
}

add_filter( 'wp_nav_menu_args', 'enlightenment_accessibility_nav_menu_args', 22 );

function enlightenment_accessibility_nav_menu_args( $args ) {
	if( '' != $args['theme_location'] ) {
		$args['items_wrap'] = enlightenment_nav_menu_title( array( 'echo' => false ) ) . $args['items_wrap'];
	}
	return $args;
}

add_filter( 'nav_menu_link_attributes', 'nav_menu_link_aria_roles', 10, 2 );

function nav_menu_link_aria_roles( $atts, $item ) {
	if( in_array( 'dropdown', (array) $item->classes ) ) {
		$atts['role'] = 'button';
		$atts['aria-expanded'] = 'false';
	}
	
	return $atts;
}

add_filter( 'enlightenment_submenu_extra_atts', 'enlightenment_submenu_aria_roles' );

function enlightenment_submenu_aria_roles( $atts ) {
	$atts .= ' role="menu"';
	return $atts;
}

add_filter( 'enlightenment_search_form_args', 'enlightenment_accessibility_search_form_args' );

function enlightenment_accessibility_search_form_args( $args ) {
	$defaults = array(
		'label_class' => 'screen-reader-text',
		'label' => __( 'Search for:', 'enlightenment' ),
	);
	$defaults = apply_filters( 'enlightenment_accessibility_search_form_args', $defaults );
	$args = wp_parse_args( $args, $defaults );
	$args['before'] .= '<label' . ( ! empty( $args['input_id'] ) ? ' for="' . esc_attr( $args['input_id'] ) . '"' : '' ) . enlightenment_class( $args['label_class'] ) . '>';
	$args['before'] .= $args['label'];
	$args['before'] .= '</label>';
	return $args;
}