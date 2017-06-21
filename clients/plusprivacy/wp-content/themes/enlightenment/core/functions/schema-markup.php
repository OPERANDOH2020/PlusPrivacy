<?php

add_filter( 'enlightenment_body_extra_atts_args', 'enlightenment_schema_markup_body_extra_atts_args' );

function enlightenment_schema_markup_body_extra_atts_args( $args ) {
	$args['atts'] .= ' itemscope itemtype="http://schema.org/WebPage"';
	return $args;
}

add_filter( 'enlightenment_site_branding_args', 'enlightenment_schema_markup_site_branding_args' );

function enlightenment_schema_markup_site_branding_args( $args ) {
	$args['container_extra_atts'] .= ' itemscope itemtype="http://schema.org/WPHeader"';
	$args['site_title_extra_atts'] .= ' itemprop="headline"';
	$args['site_description_extra_atts'] .= ' itemprop="description"';
	return $args;
}

add_filter( 'enlightenment_nav_menu_container_extra_atts', 'enlightenment_schema_markup_nav_menu_container_extra_atts' );

function enlightenment_schema_markup_nav_menu_container_extra_atts( $atts ) {
	$atts .= ' itemscope itemtype="http://schema.org/SiteNavigationElement"';
	return $atts;
}

add_filter( 'enlightenment_nav_menu_item_attributes', 'enlightenment_schema_markup_nav_menu_item_attributes' );

function enlightenment_schema_markup_nav_menu_item_attributes( $atts ) {
	$atts['itemprop'] = 'name';
	return $atts;
}

add_filter( 'nav_menu_link_attributes', 'enlightenment_schema_markup_nav_menu_link_attributes' );

function enlightenment_schema_markup_nav_menu_link_attributes( $atts ) {
	$atts['itemprop'] = 'url';
	return $atts;
}

add_filter( 'enlightenment_content_extra_atts_args', 'enlightenment_schema_markup_content_extra_atts_args' );

function enlightenment_schema_markup_content_extra_atts_args( $args ) {
	$args['atts'] .= ' itemscope itemprop="mainContentOfPage" itemtype="http://schema.org/Blog"';
	return $args;
}

add_filter( 'enlightenment_the_loop_args', 'enlightenment_schema_markup_the_loop_args' );

function enlightenment_schema_markup_the_loop_args( $args ) {
	$args['container_extra_atts'] .= ' itemscope itemprop="blogPost" itemtype="http://schema.org/' . ( 'post' == get_post_type() ? 'BlogPosting' : 'Article' ) . '"';
	return $args;
}

if( current_theme_supports( 'post-thumbnails' ) ) {
	add_filter( 'post_thumbnail_html', 'enlightenment_post_thumbnail_schema_markup' );
	
	function enlightenment_post_thumbnail_schema_markup( $html ) {
		if( has_post_thumbnail() )
			$html = str_replace( '<img ', '<img itemprop="image" ', $html );
		return $html;
	}
}

add_filter( 'enlightenment_the_title_args', 'enlightenment_schema_markup_the_title_args' );

function enlightenment_schema_markup_the_title_args( $args ) {
	$args['title_extra_atts'] .= ' itemprop="headline"';
	return $args;
}

add_filter( 'enlightenment_the_author_wrap_args', 'enlightenment_schema_markup_the_author_wrap_args' );

function enlightenment_schema_markup_the_author_wrap_args( $args ) {
	$args['container_extra_atts'] .= ' itemprop="name"';
	return $args;
}

add_filter( 'enlightenment_the_author_posts_link_wrap_args', 'enlightenment_schema_markup_the_author_posts_link_wrap_args' );

function enlightenment_schema_markup_the_author_posts_link_wrap_args( $args ) {
	$args['author_extra_atts'] .= ' itemscope itemprop="author" itemtype="http://schema.org/Person"';
	$args['author_link_extra_atts'] .= ' itemprop="url"';
	return $args;
}

add_filter( 'enlightenment_the_time_wrap_args', 'enlightenment_schema_markup_the_time_wrap_args' );

function enlightenment_schema_markup_the_time_wrap_args( $atts ) {
	$atts['time_extra_atts'] .= ' itemprop="datePublished"';
	return $atts;
}

add_filter( 'enlightenment_excerpt_wrap_args', 'enlightenment_schema_markup_excerpt_wrap_args' );

function enlightenment_schema_markup_excerpt_wrap_args( $args ) {
	$args['extra_atts'] .= ' itemprop="text"';
	return $args;
}

add_filter( 'enlightenment_content_wrap_args', 'enlightenment_schema_markup_content_wrap_args' );

function enlightenment_schema_markup_content_wrap_args( $args ) {
	$args['extra_atts'] .= ' itemprop="text"';
	return $args;
}

add_filter( 'enlightenment_comment_args', 'enlightenment_schema_markup_comment_args' );

function enlightenment_schema_markup_comment_args( $args ) {
	$args['comment_extra_atts'] .= ' itemscope itemprop="comment" itemtype="http://schema.org/UserComments"';
	$args['comment_content_extra_atts'] .= ' itemprop="commentText"';
	return $args;
}

add_filter( 'enlightenment_comment_author_args', 'enlightenment_schema_markup_comment_author_args' );

function enlightenment_schema_markup_comment_author_args( $args ) {
	$args['container_extra_atts'] .= ' itemscope itemprop="creator" itemtype="http://schema.org/Person"';
	$args['author_name_extra_atts'] .= ' itemprop="name"';
	return $args;
}

add_filter( 'get_comment_author_link', 'enlightenment_schema_markup_comment_author_link_extra_atts' );

function enlightenment_schema_markup_comment_author_link_extra_atts( $output ) {
	$output = str_replace( '\'>', '\' itemprop=\'url\'>', $output );
	return $output;
}

add_filter( 'enlightenment_comment_time_args', 'enlightenment_schema_markup_comment_time_args' );

function enlightenment_schema_markup_comment_time_args( $args ) {
	$args['time_extra_atts'] .= ' itemprop="commentTime"';
	return $args;
}

add_filter( 'enlightenment_sidebar_extra_atts_args', 'enlightenment_schema_markup_sidebar_extra_atts_args' );

function enlightenment_schema_markup_sidebar_extra_atts_args( $args ) {
	$args['atts'] .= ' itemscope itemtype="http://schema.org/WPSideBar"';
	return $args;
}

add_filter( 'enlightenment_footer_extra_atts_args', 'enlightenment_footer_extra_atts_args' );

function enlightenment_footer_extra_atts_args( $args ) {
	$args['atts'] .= ' itemscope itemtype="http://schema.org/WPFooter"';
	return $args;
}



