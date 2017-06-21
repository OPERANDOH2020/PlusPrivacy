<?php

function enlightenment_header_hooks() {
	$hooks = array(
		'enlightenment_before_page'     => array(
			'name' => __( 'Before Page', 'enlightenment' ),
			'functions' => array(),
		),
		'enlightenment_before_header'   => array(
			'name' => __( 'Before Header', 'enlightenment' ),
			'functions' => array(),
		),
		'enlightenment_header'          => array(
			'name' => __( 'Header', 'enlightenment' ),
			'functions' => array( 'enlightenment_site_branding', 'wp_nav_menu' ),
		),
		'enlightenment_after_header'    => array(
			'name' => __( 'After Header', 'enlightenment' ),
			'functions' => array(),
		),
	);
	return apply_filters( 'enlightenment_header_hooks', $hooks );
}

function enlightenment_content_hooks() {
	$hooks = array_merge(
		array(
			'enlightenment_before_content'  => array(
				'name' => __( 'Before Content', 'enlightenment' ),
				'functions' => array('enlightenment_archive_location' ),
			),
			'enlightenment_content'         => array(
				'name' => __( 'Content', 'enlightenment' ),
				'functions' => array( 'enlightenment_archive_location', 'enlightenment_the_loop' ),
			),
			'enlightenment_before_entries_list' => array(
				'name' => __( 'Before Entries List', 'enlightenment' ),
				'functions' => array(),
			),
		),
		enlightenment_entry_hooks(),
		array( 'enlightenment_after_entries_list' => array(
				'name' => __( 'After Entries List', 'enlightenment' ),
				'functions' => array( 'enlightenment_posts_nav' ),
			),
			'enlightenment_no_entries'=> array(
				'name' => __( 'No Content Found', 'enlightenment' ),
				'functions' => array(),
			),
			'enlightenment_after_the_loop' => array(
				'name' => __( 'After The Loop', 'enlightenment' ),
				'functions' => array(),
			),
			'enlightenment_after_content'   => array(
				'name' => __( 'After Content', 'enlightenment' ),
				'functions' => array(),
			),
		)
	);
	return apply_filters( 'enlightenment_content_hooks', $hooks );
}

function enlightenment_entry_hooks() {
	$hooks = array(
		'enlightenment_before_entry' => array(
			'name' => __( 'Before Entry', 'enlightenment' ),
			'functions' => array(),
		),
		'enlightenment_before_entry_header' => array(
			'name' => __( 'Before Entry Header', 'enlightenment' ),
			'functions' => array(),
		),
		'enlightenment_entry_header' => array(
			'name' => __( 'Entry Header', 'enlightenment' ),
			'functions' => array( 'the_post_thumbnail', 'the_title', 'enlightenment_entry_meta', 'enlightenment_entry_utility' ),
		),
		'enlightenment_after_entry_header' => array(
			'name' => __( 'After Entry Header', 'enlightenment' ),
			'functions' => array(),
		),
		'enlightenment_before_entry_content' => array(
			'name' => __( 'Before Entry Content', 'enlightenment' ),
			'functions' => array(),
		),
		'enlightenment_entry_content' => array(
			'name' => __( 'Entry Content', 'enlightenment' ),
			'functions' => array( 'the_excerpt', 'the_post_thumbnail', 'the_content' ),
		),
		'enlightenment_after_entry_content' => array(
			'name' => __( 'After Entry Content', 'enlightenment' ),
			'functions' => array(),
		),
		'enlightenment_before_entry_footer' => array(
			'name' => __( 'Before Entry Footer', 'enlightenment' ),
			'functions' => array(),
		),
		'enlightenment_entry_footer' => array(
			'name' => __( 'Entry Footer', 'enlightenment' ),
			'functions' => array( 'enlightenment_entry_meta', 'enlightenment_entry_utility' ),
		),
		'enlightenment_after_entry_footer' => array(
			'name' => __( 'After Entry Footer', 'enlightenment' ),
			'functions' => array( 'comments_template' ),
		),
		'enlightenment_after_entry' => array(
			'name' => __( 'After Entry', 'enlightenment' ),
			'functions' => array(),
		),
	);
	return apply_filters( 'enlightenment_entry_hooks', $hooks );
}

function enlightenment_comments_hooks() {
	$hooks = array(
		'enlightenment_before_comments'      => array(
			'name' => __( 'Before Comments', 'enlightenment' ),
			'functions' => array(),
		),
		'enlightenment_before_comments_list' => array(
			'name' => __( 'Before Comments List', 'enlightenment' ),
			'functions' => array( 'enlightenment_comments_number', 'enlightenment_comments_nav' ),
		),
		'enlightenment_comments'        => array(
			'name' => __( 'Comments', 'enlightenment' ),
			'functions' => array( 'wp_list_comments' ),
		),
		'enlightenment_after_comments_list'  => array(
			'name' => __( 'After Comments List', 'enlightenment' ),
			'functions' => array( 'enlightenment_comments_nav' ),
		),
		'enlightenment_no_comments'     => array(
			'name' => __( 'No Comments', 'enlightenment' ),
			'functions' => array(),
		),
		'enlightenment_after_comments'  => array(
			'name' => __( 'After Comments', 'enlightenment' ),
			'functions' => array( 'comment_form' ),
		),
	);
	return apply_filters( 'enlightenment_comments_hooks', $hooks );
}

function enlightenment_footer_hooks() {
	$hooks = array(
		'enlightenment_before_footer'   => array(
			'name' => __( 'Before Footer', 'enlightenment' ),
			'functions' => array(),
		),
		'enlightenment_footer'          => array(
			'name' => __( 'Footer', 'enlightenment' ),
			'functions' => array( 'enlightenment_copyright_notice', 'enlightenment_credit_links' ),
		),
		'enlightenment_after_footer'    => array(
			'name' => __( 'After Footer', 'enlightenment' ),
			'functions' => array(),
		),
	);
	return apply_filters( 'enlightenment_footer_hooks', $hooks );
}

function enlightenment_template_hooks() {
	$hooks = array_merge( enlightenment_header_hooks(), enlightenment_content_hooks(), enlightenment_comments_hooks(), enlightenment_footer_hooks() );
	return apply_filters( 'enlightenment_template_hooks', $hooks );
}

function enlightenment_get_template_hook( $hook ) {
	$hooks = enlightenment_template_hooks();
	if( isset( $hooks[$hook] ) )
		return $hooks[$hook];
	return false;
}

function enlightenment_template_functions() {
	$functions = array(
		'enlightenment_site_branding' => __( 'Site Branding', 'enlightenment' ),
		'wp_nav_menu' => __( 'Navigation Menu', 'enlightenment' ),
		'enlightenment_archive_location' => __( 'Archive Location', 'enlightenment' ),
		'enlightenment_the_loop' => __( 'The Loop', 'enlightenment' ),
		'the_title' => __( 'Post Title', 'enlightenment' ),
		'enlightenment_entry_meta' => __( 'Post Meta', 'enlightenment' ),
		'the_excerpt' => __( 'Post Excerpt', 'enlightenment' ),
		'the_post_thumbnail' => __( 'Post Thumbnail', 'enlightenment' ),
		'the_content' => __( 'Post Content', 'enlightenment' ),
		'enlightenment_entry_utility' => __( 'Post Meta Utility', 'enlightenment' ),
		'enlightenment_autor_hcard' => __( 'Author Bio', 'enlightenment' ),
		'comments_template' => __( 'Comments', 'enlightenment' ),
		'enlightenment_comments_number' => __( 'Comments Title', 'enlightenment' ),
		'enlightenment_comments_nav' => __( 'Comments Navigation', 'enlightenment' ),
		'wp_list_comments' => __( 'Comments List', 'enlightenment' ),
		'comment_form' => __( 'Comment Form', 'enlightenment' ),
		'enlightenment_posts_nav' => __( 'Posts Navigation', 'enlightenment' ),
		'enlightenment_copyright_notice' => __( 'Copyright Notice', 'enlightenment' ),
		'enlightenment_credit_links' => __( 'Credit Links', 'enlightenment' ),
		'enlightenment_custom_function' => __( 'Custom Function', 'enlightenment' ),
	);
	return apply_filters( 'enlightenment_template_functions', $functions );
}

function enlightenment_template_function_name( $function ) {
	$functions = enlightenment_template_functions();
	if( isset( $functions[$function] ) )
		return $functions[$function];
	return false;
}

function enlightenment_templates() {
	$templates = array(
		'error404' => array(
			'name' => __( '404', 'enlightenment' ),
			'conditional' => 'is_404',
			'type' => 'special',
		),
		'search' => array(
			'name' => __( 'Search', 'enlightenment' ),
			'conditional' => 'is_search',
			'type' => 'archive',
		),
		'blog' => array(
			'name' => __( 'Blog', 'enlightenment' ),
			'conditional' => 'is_home',
			'type' => 'post_type_archive',
		),
		'post' => array(
			'name' => __( 'Post', 'enlightenment' ),
			'conditional' => 'is_single',
			'type' => 'post_type',
		),
		'page' => array(
			'name' => __( 'Page', 'enlightenment' ),
			'conditional' => 'is_page',
			'type' => 'post_type',
		),
		'author' => array(
			'name' => __( 'Author', 'enlightenment' ),
			'conditional' => 'is_author',
			'type' => 'archive',
		),
		'date' => array(
			'name' => __( 'Date', 'enlightenment' ),
			'conditional' => 'is_date',
			'type' => 'archive',
		),
		'category' => array(
			'name' => __( 'Category', 'enlightenment' ),
			'conditional' => 'is_category',
			'type' => 'archive',
		),
		'post_tag' => array(
			'name' => __( 'Tag', 'enlightenment' ),
			'conditional' => 'is_tag',
			'type' => 'archive',
		),
		'comments' => array(
			'name' => __( 'Comments', 'enlightenment' ),
			'conditional' => 'is_singular',
			'hooks' => array_keys( enlightenment_comments_hooks() ),
			'type' => 'special',
		),
	);
	$post_types = get_post_types( array( 'has_archive' => true ), 'objects' );
	foreach( $post_types as $name => $post_type )
		$templates[$name . '-archive'] = array(
			'name' => sprintf( __( '%1$s Archive', 'enlightenment' ), $post_type->labels->name ),
			'conditional' => array( 'is_post_type_archive', $name ),
			'type' => 'post_type_archive',
		);
	$post_types = get_post_types( array( 'publicly_queryable' => true ), 'objects' );
	foreach( $post_types as $name => $post_type )
		$templates[$name] = array(
			'name' => $post_type->labels->singular_name,
			'conditional' => array( 'is_singular', $name ),
			'type' => 'post_type',
		);
	$taxonomies = get_taxonomies( array( 'public' => true ), 'objects' );
	unset( $taxonomies['post_format'] );
	unset( $taxonomies['category'] );
	unset( $taxonomies['post_tag'] );
	foreach( $taxonomies as $name => $taxonomy )
		$templates[$name] = array(
			'name' => $taxonomy->labels->singular_name,
			'conditional' => array( 'is_tax', $name ),
			'type' => 'taxonomy',
		);
	$default_hooks = array_keys( enlightenment_template_hooks() );
	foreach( $templates as $name => $template )
		if( ! isset( $template['hooks'] ) || empty( $template['hooks'] ) )
			$templates[$name]['hooks'] = $default_hooks;
	return apply_filters( 'enlightenment_templates', $templates );
}

add_filter( 'enlightenment_templates', 'enlightenment_templates_blog_post_teaser' );

function enlightenment_templates_blog_post_teaser( $templates ) {
	if( current_theme_supports( 'enlightenment-grid-loop' ) ) {
		$templates = array_slice( $templates, 0, 3, true ) + array(
			'post-teaser' => array(
				'name' => __( 'Blog Post Teaser', 'enlightenment' ),
				'hooks' => array_keys( enlightenment_entry_hooks() ),
				'type' => 'special',
			),
		) + array_slice( $templates, 3, null, true );
	}
	return $templates;
}

function enlightenment_get_template( $template ) {
	$templates = enlightenment_templates();
	if( array_key_exists( $template, $templates) )
		return $templates[$template];
	return false;
}

function enlightenment_current_query() {
	if( is_admin() )
		return;
	if( is_404() )
		$query = 'error404';
	elseif( is_search() )
		$query = 'search';
	elseif( is_home() )
		$query = 'blog';
	elseif( is_single() && 'post' == get_post_type() )
		$query = 'post';
	elseif( is_page() )
		$query = 'page';
	elseif( is_author() )
		$query = 'author';
	elseif( is_date() )
		$query = 'date';
	elseif( is_category() )
		$query = 'category';
	elseif( is_tag() )
		$query = 'post_tag';
	elseif( is_post_type_archive() )
		$query = get_queried_object()->name . '-archive';
	elseif( is_singular() )
		$query = get_post_type();
	elseif( is_tax() )
		$query = get_queried_object()->taxonomy;
	return apply_filters( 'enlightenment_current_query', $query );
}

add_action( 'wp', 'enlightenment_add_template_actions', 30 );

function enlightenment_add_template_actions() {
	if( is_admin() )
		return;
	$hooks = enlightenment_theme_option( 'template_hooks' );
	$query = enlightenment_current_query();
	if( current_theme_supports( 'enlightenment-page-builder' ) && is_singular() ) {
		global $post;
		$page_builder_hooks = get_post_meta( $post->ID, '_enlightenment_page_builder', true );
		if( '' != $page_builder_hooks )
			$hooks[$query] = $page_builder_hooks;
	}
	if( isset( $hooks[$query] ) )
		foreach( $hooks[$query] as $hook => $functions ) {
			global $wp_filter;
			if( isset( $wp_filter[$hook][10] ) && ! empty( $wp_filter[$hook][10] ) ) {
				remove_all_actions( $hook, 10 );
			}
			
			if( ! empty( $functions ) ) {
				foreach( $functions as $function )
					add_action( $hook, $function, 10, apply_filters( 'enlightenment_template_actions_accepted_args', 2 ) );
			}
		}
	if( is_singular() && isset( $hooks['comments'] ) ) {
		foreach( $hooks['comments'] as $hook => $functions ) {
			global $wp_filter;
			if( isset( $wp_filter[$hook][10] ) && ! empty( $wp_filter[$hook][10] ) ) {
				remove_all_actions( $hook, 10 );
			}
			
			if( ! empty( $functions ) ) {
				foreach( $functions as $function )
					add_action( $hook, $function );
			}
		}
	}
}

add_action( 'enlightenment_before_entry', 'enlightenment_add_lead_post_actions', 5 );

function enlightenment_add_lead_post_actions() {
	if( ! is_singular() && '' == get_post_format()  ) {
		$hooks = enlightenment_theme_option( 'template_hooks' );
		$template = 'blog';
		if( isset( $hooks[$template] ) ) {
			foreach( $hooks[$template] as $hook => $functions ) {
				remove_all_actions( $hook, 10 );
				if( ! empty( $functions ) ) {
					foreach( $functions as $function )
						add_action( $hook, $function, 10, apply_filters( 'enlightenment_template_actions_accepted_args', 2 ) );
				}
			}
		}
	}
}

add_action( 'enlightenment_before_entry', 'enlightenment_add_post_teaser_actions', 6 );

function enlightenment_add_post_teaser_actions() {
	if( current_theme_supports( 'enlightenment-grid-loop' ) && ! enlightenment_is_lead_post() && '' == get_post_format()  ) {
		$hooks = enlightenment_theme_option( 'template_hooks' );
		$template = 'post-teaser';
		if( isset( $hooks[$template] ) ) {
			foreach( $hooks[$template] as $hook => $functions ) {
				remove_all_actions( $hook, 10 );
				if( ! empty( $functions ) ) {
					foreach( $functions as $function )
						add_action( $hook, $function, 10, apply_filters( 'enlightenment_template_actions_accepted_args', 2 ) );
				}
			}
		} else {
			enlightenment_teaser_entry_hooks();
		}
	}
}




