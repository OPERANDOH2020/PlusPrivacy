<?php

add_filter( 'the_excerpt', 'enlightenment_excerpt_wrap', 999 );
add_filter( 'the_content', 'enlightenment_content_wrap', 999 );
add_filter( 'comment_form_default_fields', 'enlightenment_comment_form_fields' );
add_filter( 'comment_form_defaults', 'enlightenment_comment_form_defaults' );

add_action( 'wp_enqueue_scripts', 'enlightenment_register_core_styles' );
add_action( 'wp_enqueue_scripts', 'enlightenment_enqueue_core_styles' );
add_action( 'wp_enqueue_scripts', 'enlightenment_register_core_scripts' );
add_action( 'wp_enqueue_scripts', 'enlightenment_enqueue_core_scripts' );

add_action( 'enlightenment_head', 'enlightenment_meta_charset', 1 );
add_action( 'enlightenment_head', 'enlightenment_meta_viewport', 1 );
add_action( 'enlightenment_head', 'enlightenment_ie_compat', 1 );
add_action( 'enlightenment_head', 'enlightenment_profile_link', 1 );
add_action( 'enlightenment_head', 'enlightenment_pingback_link', 1 );

add_action( 'wp_print_scripts', 'enlightenment_ie_shim' );

add_action( 'enlightenment_header', 'enlightenment_site_branding' );
add_action( 'enlightenment_header', 'wp_nav_menu' );
add_action( 'enlightenment_callout', 'enlightenment_archive_location' );

add_action( 'enlightenment_comment_header', 'enlightenment_comment_author_avatar', 10, 2 );
add_action( 'enlightenment_comment_header', 'enlightenment_comment_author' );
add_action( 'enlightenment_comment_header', 'enlightenment_comment_meta' );
add_action( 'enlightenment_comment_header', 'enlightenment_comment_awaiting_moderation' );
add_action( 'enlightenment_comment_meta', 'enlightenment_comment_time' );
add_action( 'enlightenment_comment_content', 'comment_text' );
add_action( 'enlightenment_after_comment_content', 'comment_reply_link', 10, 3 );
add_action( 'enlightenment_comments_require_password', 'enlightenment_comments_password_notice' );
add_action( 'comment_form_comments_closed', 'enlightenment_comments_closed_notice' );

add_action( 'wp', 'enlightenment_wp_actions', 8 );

function enlightenment_wp_actions() {
	if( ! is_singular() ) {
		add_action( 'enlightenment_after_header', 'enlightenment_archive_location' );
	}
	
	add_action( 'enlightenment_content', 'enlightenment_the_loop' );
	
	enlightenment_lead_entry_hooks();
	
	if( is_single() && 'post' == get_post_type() ) {
		add_action( 'enlightenment_entry_footer', 'enlightenment_entry_meta' );
	}
	
	if( is_singular() ) {
		add_action( 'enlightenment_after_entry_footer', 'comments_template' );
	} else {
		add_action( 'enlightenment_after_entries_list', 'enlightenment_posts_nav' );
	}
	
	add_action( 'enlightenment_before_comments_list', 'enlightenment_comments_number' );
	add_action( 'enlightenment_before_comments_list', 'enlightenment_comments_nav' );
	add_action( 'enlightenment_comments', 'wp_list_comments' );
	add_action( 'enlightenment_after_comments_list', 'enlightenment_comments_nav' );
	add_action( 'enlightenment_after_comments', 'comment_form' );
	add_action( 'enlightenment_footer', 'enlightenment_copyright_notice' );
	add_action( 'enlightenment_footer', 'enlightenment_credit_links' );
}

function enlightenment_lead_entry_hooks() {
	
	add_action( 'enlightenment_entry_header', 'the_title', 10, 2 );
	
	if( ! is_page() ) {
		add_action( 'enlightenment_entry_header', 'enlightenment_entry_meta' );
	}
	if( ! is_singular() ) {
		add_action( 'enlightenment_entry_content', 'the_post_thumbnail' );
	}
	
	add_action( 'enlightenment_entry_content', 'the_content' );
}

add_action( 'enlightenment_before_entry', 'enlightenment_teaser_entry_hooks', 5 );

function enlightenment_teaser_entry_hooks() {
	if( current_theme_supports( 'enlightenment-grid-loop' ) && ! enlightenment_is_lead_post() ) {
		enightenment_clear_entry_hooks();
		add_action( 'enlightenment_entry_header', 'the_post_thumbnail' );
		add_action( 'enlightenment_entry_header', 'the_title', 10, 2 );
		add_action( 'enlightenment_entry_content', 'the_excerpt' );
		add_action( 'enlightenment_entry_footer', 'enlightenment_entry_meta' );
	}
}

add_action( 'enlightenment_before_entry', 'enlightenment_entry_meta_hooks', 4 );

function enlightenment_entry_meta_hooks() {
	add_action( 'enlightenment_entry_meta', 'the_author_posts_link' );
	add_action( 'enlightenment_entry_meta', 'the_time' );
	if( 'post' == get_post_type() ) {
		add_action( 'enlightenment_entry_meta', 'the_category' );
	} elseif( 'attachment' == get_post_type() ) {
		add_action( 'enlightenment_entry_meta', 'enlightenment_meta_image_size' );
	} elseif( current_theme_supports( 'jetpack-portfolio' ) && class_exists( 'Jetpack' ) && in_array( 'custom-content-types', Jetpack::get_active_modules() ) && is_post_type_archive( 'jetpack-portfolio' ) ) {
		add_action( 'enlightenment_entry_meta', 'enlightenment_project_types' );
	}
	if( comments_open() ) {
		add_action( 'enlightenment_entry_meta', 'comments_popup_link' );
	}
	add_action( 'enlightenment_entry_meta', 'edit_post_link' );
	
	add_action( 'enlightenment_entry_utility', 'wp_link_pages' );
	if( 'post' == get_post_type() ) {
		add_action( 'enlightenment_entry_utility', 'the_tags' );
	}
}

add_action( 'wp', 'enlightenment_portfolio_actions', 7 );

function enlightenment_portfolio_actions() {
	if( current_theme_supports( 'jetpack-portfolio' ) && class_exists( 'Jetpack' ) && in_array( 'custom-content-types', Jetpack::get_active_modules() ) ) {
		if( is_post_type_archive( 'jetpack-portfolio' ) || is_tax( 'jetpack-portfolio-type' ) ) {
			add_action( 'enlightenment_content', 'enlightenment_project_types_filter' );
		}
	}
}

add_action( 'enlightenment_before_entry', 'enlightenment_project_actions', 5 );

function enlightenment_project_actions() {
	if( current_theme_supports( 'jetpack-portfolio' ) && class_exists( 'Jetpack' ) && in_array( 'custom-content-types', Jetpack::get_active_modules() ) ) {
		if( is_post_type_archive( 'jetpack-portfolio' ) || is_tax( 'jetpack-portfolio-type' ) || is_tax( 'jetpack-portfolio-tag' ) ) {
			remove_action( 'enlightenment_entry_header', 'the_title', 10, 2 );
			remove_action( 'enlightenment_entry_header', 'enlightenment_entry_meta' );
			add_action( 'enlightenment_entry_header', 'the_post_thumbnail' );
			add_action( 'enlightenment_entry_header', 'the_title', 10, 2 );
			add_action( 'enlightenment_entry_header', 'enlightenment_entry_meta' );
			remove_action( 'enlightenment_entry_content', 'the_post_thumbnail' );
			remove_action( 'enlightenment_entry_content', 'the_content' );
			remove_action( 'enlightenment_entry_content', 'the_excerpt' );
			add_action( 'enlightenment_entry_content', 'the_excerpt' );
		}
	}
}

add_action( 'enlightenment_before_entry', 'enlightenment_project_teaser_actions', 7 );

function enlightenment_project_teaser_actions() {
	if( current_theme_supports( 'jetpack-portfolio' ) && class_exists( 'Jetpack' ) && in_array( 'custom-content-types', Jetpack::get_active_modules() ) ) {
		if( ( is_post_type_archive( 'jetpack-portfolio' ) || is_tax( 'jetpack-portfolio-type' ) || is_tax( 'jetpack-portfolio-tag' ) ) && current_theme_supports( 'enlightenment-grid-loop' ) && ! enlightenment_is_lead_post() ) {
			enightenment_clear_entry_hooks();
			add_action( 'enlightenment_entry_header', 'the_post_thumbnail' );
			add_action( 'enlightenment_entry_header', 'the_title', 10, 2 );
		}
	}
}



