<?php

add_action( 'add_meta_boxes', 'enlightenment_page_design_meta_boxes' );

function enlightenment_page_design_meta_boxes() {
	$post_types = array_merge( array( 'page' => 'page' ), get_post_types( array( 'publicly_queryable' => true ) ) );
	foreach( $post_types as $post_type )
		add_meta_box( 'enlightenment_page_design', __( 'Page Design', 'enlightenment' ), 'enlightenment_page_design_form', $post_type, 'side', 'default' );
}

function enlightenment_page_design_form( $post ) {
	wp_nonce_field( 'enlightenment_page_design_form', 'enlightenment_page_design_form_nonce' );
	echo enlightenment_open_tag( 'p' );
	global $wp_post_types;
	enlightenment_select_box( array(
		'name'    => 'enlightenment_page_design',
		'value'   => ( '' != get_post_meta( $post->ID, '_enlightenment_page_design', true ) ) ? get_post_meta( $post->ID, '_enlightenment_page_design', true ) : enlightenment_theme_option( 'page_design' ),
		'options' => array(
			'boxed'       => 'Boxed',
			'full-screen' => 'Full Screen',
		),
	) );
	echo enlightenment_close_tag( 'p' );
}

add_action( 'save_post', 'enlightenment_page_design_form_save_postdata' );

function enlightenment_page_design_form_save_postdata( $post_id ) {
	if( ! isset( $_POST['enlightenment_page_design'] ) )
		return $post_id;
	$nonce = $_POST['enlightenment_page_design_form_nonce'];
	if( ! wp_verify_nonce( $nonce, 'enlightenment_page_design_form' ) )
		return $post_id;
	if( defined( 'DOING_AUTOSAVE' ) && DOING_AUTOSAVE )
		return $post_id;
	$post = get_post( $post_id );
	if ( ! current_user_can( get_post_type_object( $post->post_type )->cap->edit_post, $post_id ) )
		return $post_id;
	if( ! in_array( $_POST['enlightenment_page_design'], array( 'boxed', 'full-screen' ) ) )
		return $post_id;
	update_post_meta( $post_id, '_enlightenment_page_design', $_POST['enlightenment_page_design'] );
}