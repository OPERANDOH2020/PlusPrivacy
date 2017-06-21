<?php

if( ! current_theme_supports( 'enlightenment-template-editor' ) )
	_doing_it_wrong( 'add_theme_support( \'enlightenment_page_builder\' );', __( 'This Feature requires Theme Support for Template Editor.', 'enlightenment' ), '' );

if( ! current_theme_supports( 'enlightenment-theme-settings' ) )
	_doing_it_wrong( 'add_theme_support( \'enlightenment_page_builder\' );', __( 'This Feature requires Theme Support for Theme Settings.', 'enlightenment' ), '' );

add_action( 'add_meta_boxes', 'enlightenment_page_builder_meta_boxes' );

function enlightenment_page_builder_meta_boxes() {
	$post_types = array_merge( array( 'page' => 'page' ), get_post_types( array( 'publicly_queryable' => true ) ) );
	foreach( $post_types as $post_type )
		add_meta_box( 'enlightenment_page_builder', __( 'Page Builder', 'enlightenment' ), 'enlightenment_page_builder_form', $post_type, 'normal', 'high' );
}

add_action( 'enlightenment_before_page_builder', 'enlightenment_simmulate_query' );
add_action( 'enlightenment_after_page_builder', 'wp_reset_query' );

function enlightenment_page_builder_form( $post ) {
	if( ! isset( $_GET['post'] ) ) {
		_e( 'Please save this post as Draft to use the Page Builder.', 'enlightenment' );
		return;
	}
	wp_nonce_field( 'enlightenment_page_builder_form', 'enlightenment_page_builder_form_nonce' );
	echo enlightenment_open_tag( 'p' );
	enlightenment_checkbox( array(
		'name' => 'enlightenment_default_template_hooks',
		'checked' => ( '' == get_post_meta( $post->ID, '_enlightenment_page_builder', true ) ),
		'label' => sprintf( __( 'Use default template hooks for %1$s', 'enlightenment' ), $post->post_type ),
	) );
	echo enlightenment_close_tag( 'p' );
	$template = enlightenment_get_template( get_post_type() );
	$template['hooks'] = array_keys( enlightenment_template_hooks() );
	do_action( 'enlightenment_before_page_builder' );
	echo enlightenment_open_tag( 'div', 'template-hooks' );
	foreach( $template['hooks'] as $hook ) {
		$atts = enlightenment_get_template_hook( $hook );
		$available_functions = $atts['functions'];
		$template_hooks = get_post_meta( $post->ID, '_enlightenment_page_builder', true );
		if( '' == $template_hooks )
			$template_hooks = enlightenment_theme_option( 'template_hooks' );
		if( isset( $template_hooks[enlightenment_current_template()][$hook] ) ) {
			$hooked_functions = $template_hooks[enlightenment_current_template()][$hook];
		} else {
			$hooked_functions = array();
			global $wp_filter;
			if( isset( $wp_filter[$hook] ) && isset( $wp_filter[$hook][10] ) ) {
				foreach( $wp_filter[$hook][10] as $function )
					$hooked_functions[] = $function['function'];
			}
		}
		$available_functions = array_diff( $available_functions, $hooked_functions );
		if( ! empty( $available_functions ) || ! empty( $hooked_functions ) ) {
			echo '<h2>' . esc_attr( $atts['name'] ) . '</h2>';
			enlightenment_template_hook_actions( array(
				'hook' => $hook,
				'name' => 'enlightenment_page_builder[' . $hook . ']',
				'class' => 'template-hooks',
			) );
		}
	}
	echo enlightenment_close_tag();
	do_action( 'enlightenment_after_page_builder' );
}

add_action( 'save_post', 'enlightenment_page_builder_form_save_postdata' );

function enlightenment_page_builder_form_save_postdata( $post_id ) {
	if( ! isset( $_POST['enlightenment_page_builder'] ) )
		return $post_id;
	$nonce = $_POST['enlightenment_page_builder_form_nonce'];
	if( ! wp_verify_nonce( $nonce, 'enlightenment_page_builder_form' ) )
		return $post_id;
	if( defined( 'DOING_AUTOSAVE' ) && DOING_AUTOSAVE )
		return $post_id;
	$post = get_post( $post_id );
	if ( ! current_user_can( get_post_type_object( $post->post_type )->cap->edit_post, $post_id ) )
		return $post_id;
	if( isset( $_POST['enlightenment_default_template_hooks'] ) && $_POST['enlightenment_default_template_hooks'] ) {
		update_post_meta( $post_id, '_enlightenment_page_builder', '' );
		return;
	}
	$hooks = $_POST['enlightenment_page_builder'];
	foreach( $hooks as $hook => $functions ) {
		$functions = explode( ',', $functions );
		$atts = enlightenment_get_template_hook( $hook );
		foreach( $functions as $key => $function )
			if( ! in_array( $function, $atts['functions'] ) ) {
				unset( $functions[$key] );
			}
		$hooks[$hook] = $functions;
	}
	update_post_meta( $post_id, '_enlightenment_page_builder', $hooks );
}