<?php

add_filter( 'enlightenment_author_posts_link_args', 'enlightenment_glyphicons_author_posts_link_args', 12 );

function enlightenment_glyphicons_author_posts_link_args( $args ) {
	if( ! is_single() || doing_action( 'enlightenment_entry_header' ) ) {
		$args['format'] = '<span class="glyphicon glyphicon-user"></span> ' . $args['format'];
	}
	return $args;
}

add_filter( 'enlightenment_entry_date_args', 'enlightenment_glyphicons_entry_date_args', 12 );

function enlightenment_glyphicons_entry_date_args( $args ) {
	$args['format'] = '<span class="glyphicon glyphicon-time"></span> ' . $args['format'];
	return $args;
}

add_filter( 'enlightenment_categories_list_args', 'enlightenment_glyphicons_categories_list_args', 12 );
add_filter( 'enlightenment_project_types_args', 'enlightenment_glyphicons_categories_list_args', 12 );

function enlightenment_glyphicons_categories_list_args( $args ) {
	$args['format'] = '<span class="glyphicon glyphicon-bookmark"></span> ' . $args['format'];
	return $args;
}

add_filter( 'enlightenment_meta_image_size_args', 'enlightenment_glyphicons_meta_image_size_args' );

function enlightenment_glyphicons_meta_image_size_args( $args ) {
	$args['before'] .= '<span class="glyphicon glyphicon-picture"></span> ';
	return $args;
}

add_filter( 'enlightenment_comments_link_args', 'enlightenment_glyphicons_comments_link_args', 12 );

function enlightenment_glyphicons_comments_link_args( $args ) {
	$args['before'] = '<span class="glyphicon glyphicon-comment"></span> ';
	return $args;
}

add_filter( 'enlightenment_edit_post_link_args', 'enlightenment_glyphicons_edit_post_link_args', 12 );

function enlightenment_glyphicons_edit_post_link_args( $args ) {
	$args['format'] =  '<span class="glyphicon glyphicon-edit"></span> ' . $args['format'];
	return $args;
}

add_filter( 'enlightenment_comment_form_fields_args', 'enlightenment_glyphicons_comment_form_fields_args' );

function enlightenment_glyphicons_comment_form_fields_args( $args ) {
	$args['before_author_label'] .= '<span class="glyphicon glyphicon-user"></span> ';
	$args['before_email_label'] .= '<span class="glyphicon glyphicon-envelope"></span> ';
	$args['before_url_label'] .= '<span class="glyphicon glyphicon-globe"></span> ';
	return $args;
}

add_filter( 'enlightenment_comment_form_defaults_args', 'enlightenment_glyphicons_comment_form_defaults_args' );

function enlightenment_glyphicons_comment_form_defaults_args( $args ) {
	$args['before_label'] .= '<span class="glyphicon glyphicon-edit"></span> ';
	return $args;
}