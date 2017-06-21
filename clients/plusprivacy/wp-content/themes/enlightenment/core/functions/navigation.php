<?php

function enlightenment_navicon( $args = null ) {
	$defaults = array(
		'container' => 'a',
		'container_class' => 'navicon',
		'container_id' => '',
		'container_extra_atts' => array( 'href' => '#site-navigation' ),
		'target' => '#site-navigation',
		'text' => __( 'Toggle Navigation', 'enlightenment' ),
		'echo' => true,
	);
	$defaults = apply_filters( 'enlightenment_navicon_args', $defaults );
	$args = wp_parse_args( $args, $defaults );
	$output = enlightenment_open_tag( $args['container'], $args['container_class'], $args['container_id'], $args['container_extra_atts'] );
	$output .= $args['text'];
	$output .= enlightenment_close_tag( $args['container'] );
	$output = apply_filters( 'enlightenment_navicon', $output, $args );
	if( ! $args['echo'] )
		return $output;
	echo $output;
}

add_filter( 'wp_nav_menu', 'enlightenment_nav_menu_container_extra_atts', 10, 2 );

function enlightenment_nav_menu_container_extra_atts( $nav_menu, $args ) {
	$atts = apply_filters( 'enlightenment_nav_menu_container_extra_atts', ' role="navigation"' );
	$nav_menu = preg_replace('/(class=\"[^"]*\")/i', '\1' . enlightenment_extra_atts( $atts ), $nav_menu);
	return $nav_menu;
}

add_filter( 'wp_nav_menu_args', 'enlightenment_nav_menu_args', 20 );

function enlightenment_nav_menu_args( $args ) {
	if( '' != $args['theme_location'] ) {
		$args['container'] = 'nav';
		$args['container_class'] = 'menu-container';
		$args['container_id'] = 'site-navigation';
		$args['menu_class'] = 'menu nav';
		$args['walker'] = new Enlightenment_Walker_Nav_Menu;
	}
	return $args;
}

class Enlightenment_Walker_Nav_Menu extends Walker_Nav_Menu {

	function start_lvl( &$output, $depth = 0, $args = array() ) {
		// depth dependent classes
		$indent = ( $depth > 0  ? str_repeat( "\t", $depth ) : '' ); // code indent
		$display_depth = ( $depth + 1); // because it counts the first submenu as 0
		$class = apply_filters( 'enlightenment_submenu_class', 'sub-menu' );
		$id = apply_filters( 'enlightenment_submenu_id', '' );
		$extra_atts = apply_filters( 'enlightenment_submenu_extra_atts', '' );
		// build html
		$output .= "\n" . $indent . enlightenment_open_tag( 'ul', $class, $id, $extra_atts );
	}

	function start_el( &$output, $item, $depth = 0, $args = array(), $id = 0 ) {
		$indent = ( $depth ) ? str_repeat( "\t", $depth ) : '';

		$class_names = '';

		$classes = empty( $item->classes ) ? array() : (array) $item->classes;
		$classes[] = 'menu-item-' . $item->ID;

		$class_names = join( ' ', apply_filters( 'nav_menu_css_class', array_filter( $classes ), $item, $args ) );
		$class_names = ' class="' . esc_attr( $class_names ) . '"';

		$id = apply_filters( 'nav_menu_item_id', 'menu-item-' . $item->ID, $item, $args );
		$id = $id ? ' id="' . esc_attr( $id ) . '"' : '';

		$atts = apply_filters( 'enlightenment_nav_menu_item_attributes', array(), $item, $args );

		$attributes = enlightenment_extra_atts( $atts );

		$output .= $indent . '<li' . $id . $class_names . $attributes . '>';

		$atts = array();
		$atts['title']  = ! empty( $item->attr_title ) ? $item->attr_title : '';
		$atts['target'] = ! empty( $item->target )     ? $item->target     : '';
		$atts['rel']    = ! empty( $item->xfn )        ? $item->xfn        : '';
		$atts['href']   = ! empty( $item->url )        ? $item->url        : '';

		$atts = apply_filters( 'nav_menu_link_attributes', $atts, $item, $args );

		$attributes = enlightenment_extra_atts( $atts );

		$item_output = $args->before;
		$item_output .= '<a'. $attributes .'>';

		$item_output .= apply_filters( 'enlightenment_nav_menu_link_before', $args->link_before, $item );
		$item_output .= apply_filters( 'the_title', $item->title, $item->ID );

		$item_output .= apply_filters( 'enlightenment_nav_menu_link_after', $args->link_after, $item );

		$item_output .= '</a>';

		$item_output .= $args->after;
		$output .= apply_filters( 'walker_nav_menu_start_el', $item_output, $item, $depth, $args );
	}

}

function enlightenment_archive_location( $args = null ) {

	//Args
	$defaults = array(
		'container' => 'div',
		'container_id' => '',
		'container_class' => 'archive-header',
		'before' => '',
		'after' => '',
		'title_tag' => is_singular() ? 'div' : 'h1',
		'title_class' => 'archive-title',
		'show_description' => true,
		'description_tag' => 'div',
		'description_class' => 'archive-description',
		'prefix_tag' => 'small',
		'prefix_class' => 'prefix',
		'prefix_format' => __( 'Browsing %1$s%2$s', 'enlightenment' ),
		'prefix_sep' => ':',
		'blog_text' => __( 'From the Blog', 'enlightenment' ),
		'blog_description' => '',
		'page_tag' => 'span',
		'page_class' => array( 'page' ),
		'page_format' => __( '%1$s Page %2$s', 'enlightenment' ),
		'page_sep' => ',',
		'format' => __( '%1$s %2$s%3$s', 'enlightenment' ),
		'echo' => true,
	);
	$defaults = apply_filters( 'enlightenment_archive_location_args', $defaults );
	$args = wp_parse_args( $args, $defaults );

	// Prefix
	$prefix = '';
	if( is_404() )
		$prefix = '404';
	elseif( is_author() )
		$prefix = __( 'Author', 'enlightenment' );
	elseif( is_tax( 'post_format' ) )
		$prefix = __( 'Post Formats', 'enlightenment' );
	elseif( is_category() || is_tag() || is_tax() )
		$prefix = get_taxonomy( get_queried_object()->taxonomy )->labels->singular_name;
	elseif( is_search() )
		$prefix = __( 'Search Results for', 'enlightenment' );
	elseif( ! is_home() && ! is_front_page() && ! is_singular() )
		$prefix = __( 'Archives for', 'enlightenment' );
	if( ! is_home() && ! is_front_page() && ! is_singular() ) {
		$prefix = sprintf( $args['prefix_format'], $prefix, $args['prefix_sep'] );
		$prefix = enlightenment_open_tag( $args['prefix_tag'], $args['prefix_class'] ) . $prefix . enlightenment_close_tag( $args['prefix_tag'] );
	}
	$prefix = apply_filters( 'enlightenment_archive_location_prefix', $prefix );

	// Location
	$description = '';
	if( is_404() )
		$location = __( 'Content Not Found', 'enlightenment' );
	elseif( is_page() ) {
		global $post;
		$location = $post->post_title;
	} elseif( is_search() ) {
		$location = ' &ldquo;' .  get_search_query() . '&rdquo;';
	} elseif( is_home() || is_singular( 'post' ) ) {
		$location = $args['blog_text'];
		$description = $args['blog_description'];
	} elseif( is_singular() ) {
		$post_type = get_post_type_object( get_post_type(), false );
		$location = $post_type->labels->singular_name;
	} elseif( is_post_type_archive() ) {
		$location = post_type_archive_title( '', false );
	} elseif( is_author() ) {
		$author = get_userdata( get_query_var( 'author' ) );
		$location = $author->display_name;
	} elseif ( is_year() ) {
		$location = get_query_var( 'year' );
	} elseif ( is_month() ) {
		$location = get_the_time( 'F Y' );
	} elseif ( is_day() ) {
		$location = get_the_time( 'F j, Y' );
	} else {
		$location = single_term_title( '', false );
		$description = term_description();
	}
	$location = apply_filters( 'enlightenment_location', $location );

	// Page
	if( is_paged() ) {
		$page = get_query_var( 'paged' );
		$page = enlightenment_open_tag( $args['page_tag'], $args['page_class'] ) . $page . enlightenment_close_tag( $args['page_tag'] );
		if( '' == $location )
			$args['page_sep'] = '';
		$page = sprintf( $args['page_format'], $args['page_sep'], $page );
	} else
		$page = '';
	$page = apply_filters( 'enlightenment_location_page', $page );

	// Output
	$output = enlightenment_open_tag( $args['container'], $args['container_class'], $args['container_id'] );
	$output .= $args['before'];
	$output .= enlightenment_open_tag( $args['title_tag'], $args['title_class'] );
	$output .= sprintf( $args['format'], $prefix, $location, $page ) . "\n";
	$output .= enlightenment_close_tag( $args['title_tag'] );
	if( $args['show_description'] && '' != $description ) {
		$output .= enlightenment_open_tag( $args['description_tag'], $args['description_class'] );
		$output .= apply_filters( 'enlightenment_archive_location_description', $description ) . "\n";
		$output .= enlightenment_close_tag( $args['description_tag'] );
	}
	$output .= $args['after'];
	$output .= enlightenment_close_tag( $args['container'] );
	$output = apply_filters( 'enlightenment_archive_location', $output, $args, $prefix, $location, $page );
	if( ! $args['echo'] )
		return $output;
	echo $output;
}

add_filter( 'enlightenment_archive_location_description', 'wpautop' );

add_filter( 'enlightenment_archive_location_description', 'wptexturize' );

add_filter( 'wp_link_pages_args', 'enlightenment_link_pages_args', 20 );

function enlightenment_link_pages_args( $args ) {
	$args['before'] = '<nav class="post-pagination">' . $args['before'];
	$args['after'] .= '</nav>';
	return $args;
}

function enlightenment_posts_nav( $args = null ) {
	$defaults = array(
		'container' => 'nav',
		'container_id' => 'posts-nav',
		'container_class' => 'posts-nav navigation',
		'before' => '',
		'after' => '',
		'link_container' => 'div',
		'prev_class' => 'previous',
		'next_class' => 'next',
		'all_class' => 'nav-all',
		'pointer_tag' => 'span',
		'prev_label' => __( 'Previous Page', 'enlightenment' ),
		'next_label' => __( 'Next Page', 'enlightenment' ),
		'all_label' => __( 'Read all Articles', 'enlightenment' ),
		'pointer_class' => 'pointer',
		'prev_pointer' => '&larr;',
		'next_pointer' => '&rarr;',
		'paged' => false,
		'type' => 'plain',
		'single_home_link' => false,
		'custom_cb' => '',
		'custom_cb_args' => array(),
		'echo' => true,
	);
	$defaults['all_pointer'] = $defaults['next_pointer'];
	$defaults = apply_filters( 'enlightenment_posts_nav_args', $defaults );
	$args = wp_parse_args( $args, $defaults );
	if( is_callable( $args['custom_cb'] ) ) {
		call_user_func_array( $args['custom_cb'], $args['custom_cb_args'] );
		return;
	}
	global $wp_query;
	if ( $wp_query->max_num_pages > 1 ) {
		$prev_label = enlightenment_open_tag( $args['pointer_tag'], $args['pointer_class'] ) . $args['prev_pointer'] . enlightenment_close_tag( $args['pointer_tag'] ) . $args['prev_label'];
		$next_label = $args['next_label'] . enlightenment_open_tag( $args['pointer_tag'], $args['pointer_class'] ) . $args['next_pointer'] . enlightenment_close_tag( $args['pointer_tag'] );
		$output = enlightenment_open_tag( $args['container'], $args['container_class'], $args['container_id'], 'role="navigation"' );
		$output .= $args['before'];
		if( $args['paged'] ) {
			$big = 999999999; // need an unlikely integer
			$paginate_links_args = apply_filters( 'enlightenment_paginate_links_args', array(
				'base' => str_replace( $big, '%#%', get_pagenum_link( $big ) ),
				'format' => '?paged=%#%',
				'current' => max( 1, get_query_var('paged') ),
				'total' => $wp_query->max_num_pages,
				'prev_text' => $prev_label,
				'next_text' => $next_label,
				'type' => $args['type']
			) );
			$output .= paginate_links( $paginate_links_args );
		} else {
			if( is_home() && ! is_paged() && $args['single_home_link'] ) {
				$all_label = $args['all_label'] . enlightenment_open_tag( $args['pointer_tag'], $args['pointer_class'] ) . $args['next_pointer'] . enlightenment_close_tag( $args['pointer_tag'] );
				$output .= enlightenment_open_tag( $args['link_container'], $args['all_class'] );
				$output .= get_next_posts_link( $all_label ) . "\n";
				$output .= enlightenment_close_tag( $args['link_container'] );
			} else {
				if( 1 < intval( get_query_var( 'paged' ) ) ) {
					$output .= enlightenment_open_tag( $args['link_container'], $args['prev_class'] );
					$output .= get_previous_posts_link( $prev_label ) . "\n";
					$output .= enlightenment_close_tag( $args['link_container'] );
				}
				if( $wp_query->max_num_pages > intval( get_query_var( 'paged' ) ) ) {
					$output .= enlightenment_open_tag( $args['link_container'], $args['next_class'] );
					$output .= get_next_posts_link( $next_label ) . "\n";
					$output .= enlightenment_close_tag( $args['link_container'] );
				}
			}
		}
		$output .= $args['after'];
		$output .= enlightenment_close_tag( $args['container'] );
		$output = apply_filters( 'enlightenment_posts_nav', $output, $args );
		if( ! $args['echo'] )
			return $output;
		echo $output;
	}
}

function enlightenment_comments_nav( $args = null ) {
	$defaults = array(
		'container' => 'nav',
		'container_id' => 'comments-nav',
		'container_class' => 'comments-nav navigation',
		'before' => '',
		'after' => '',
		'link_container' => 'div',
		'prev_class' => 'previous',
		'next_class' => 'next',
		'pointer_tag' => 'span',
		'prev_label' => __( 'Older Comments', 'enlightenment' ),
		'next_label' => __( 'Newer Comments', 'enlightenment' ),
		'pointer_class' => 'pointer',
		'prev_pointer' => '&larr;',
		'next_pointer' => '&rarr;',
		'paged' => true,
		'type' => 'plain',
		'custom_cb' => '',
		'custom_cb_args' => array(),
		'echo' => true,
	);
	$defaults['all_pointer'] = $defaults['next_pointer'];
	$defaults = apply_filters( 'enlightenment_comments_nav_args', $defaults );
	$args = wp_parse_args( $args, $defaults );
	if( is_callable( $args['custom_cb'] ) ) {
		call_user_func_array( $args['custom_cb'], $args['custom_cb_args'] );
		return;
	}
	if( get_comment_pages_count() > 1 && get_option( 'page_comments' ) ) {
		$prev_label = enlightenment_open_tag( $args['pointer_tag'], $args['pointer_class'] ) . $args['prev_pointer'] . enlightenment_close_tag( $args['pointer_tag'] ) . $args['prev_label'];
		$next_label = $args['next_label'] . enlightenment_open_tag( $args['pointer_tag'], $args['pointer_class'] ) . $args['next_pointer'] . enlightenment_close_tag( $args['pointer_tag'] );
		$output = enlightenment_open_tag( $args['container'], $args['container_class'], $args['container_id'], 'role="navigation"' );
		$output .= $args['before'];
		if( $args['paged'] ) {
			$big = 999999999; // need an unlikely integer
			$paginate_comments_links_args = apply_filters( 'enlightenment_paginate_comments_links_args', array(
				'prev_text' => $prev_label,
				'next_text' => $next_label,
				'type' => $args['type'],
				'echo' => false
			) );
			$links = paginate_comments_links( $paginate_comments_links_args );
			$output .= $links;
		} else {
			if( 1 < intval( get_query_var( 'cpage' ) ) ) {
				$output .= enlightenment_open_tag( $args['link_container'], $args['prev_class'] );
				$output .= get_previous_comments_link( $prev_label ) . "\n";
				$output .= enlightenment_close_tag( $args['link_container'] );
			}
			global $wp_query;
			if( get_comment_pages_count() > intval( get_query_var('cpage') ) ) {
				$output .= enlightenment_open_tag( $args['link_container'], $args['next_class'] );
				$output .= get_next_comments_link( $next_label ) . "\n";
				$output .= enlightenment_close_tag( $args['link_container'] );
			}
		}
		$output .= $args['after'];
		$output .= enlightenment_close_tag( $args['container'] );
		$output = apply_filters( 'enlightenment_comments_nav', $output, $args );
		if( ! $args['echo'] )
			return $output;
		echo $output;
	}
}