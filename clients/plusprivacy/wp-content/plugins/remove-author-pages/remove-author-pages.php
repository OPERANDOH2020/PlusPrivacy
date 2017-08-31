<?php
/*
Plugin Name: Remove Author Pages
Description: Trigger 404 error on author pages and change author links to home
Author: Vinicius Pinto <contact@codense.com>
Version: 0.2
*/

function remove_author_pages_page() {
	if ( is_author() ) {
		global $wp_query;
		$wp_query->set_404();
		status_header( 404 );
	}
}

function remove_author_pages_link( $content ) {
	return get_option( 'home' );
}

add_action( 'template_redirect', 'remove_author_pages_page' );
add_filter( 'author_link', 'remove_author_pages_link' );


