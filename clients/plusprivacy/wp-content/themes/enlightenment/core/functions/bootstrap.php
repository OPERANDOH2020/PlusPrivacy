<?php

add_action( 'after_setup_theme', 'enlightenment_bootstrap_theme_support_args', 999 );

function enlightenment_bootstrap_theme_support_args() {
	$defaults = array(
		'min_files' => false,
		'load_styles' => true,
		'load_scripts' => true,
		'navbar-position' => 'static-top',
		'navbar-background' => 'default',
	);
	$args = get_theme_support( 'enlightenment-bootstrap' );
	$args = is_array( $args ) ? array_shift( $args ) : array();
	$args = wp_parse_args( $args, $defaults );
	global $_wp_theme_features;
	if( ! is_array( $_wp_theme_features['enlightenment-bootstrap'] ) )
		$_wp_theme_features['enlightenment-bootstrap'] = array();
	$_wp_theme_features['enlightenment-bootstrap'][0] = $args;
}

add_filter( 'current_theme_supports-enlightenment-bootstrap', 'enlightenment_filter_current_theme_supports', 10, 3 );

add_filter( 'enlightenment_theme_stylesheet_deps', 'enlightenment_bootstrap_theme_stylesheet_deps' );

function enlightenment_bootstrap_theme_stylesheet_deps( $deps ) {
	if( current_theme_supports( 'enlightenment-bootstrap', 'load_styles' ) ) {
		if( current_theme_supports( 'enlightenment-bootstrap', 'min_files' ) ) {
            $deps[] = 'bootstrap-min';
        } else {
            $deps[] = 'bootstrap';
        }
	}
	return $deps;
}

add_action( 'wp_enqueue_scripts', 'enlightenment_enqueue_bootstrap_script' );

function enlightenment_enqueue_bootstrap_script() {
	if( current_theme_supports( 'enlightenment-bootstrap', 'load_scripts' ) )
		if( current_theme_supports( 'enlightenment-bootstrap', 'min_files' ) )
        {
            wp_enqueue_script( 'bootstrap-min' );
        }
		else
        {
            wp_enqueue_script( 'bootstrap' );
        }
}

add_filter( 'enlightenment_call_js', 'enlightenment_call_bootstrap_script' );

function enlightenment_call_bootstrap_script( $deps ) {
	if( current_theme_supports( 'enlightenment-bootstrap', 'load_scripts' ) )
		if( current_theme_supports( 'enlightenment-bootstrap', 'min_files' ) )
			$deps[] = 'bootstrap-min';
		else
			$deps[] = 'bootstrap';
	return $deps;
}

function enlightenment_open_container() {
	echo enlightenment_open_tag( 'div', 'container' );
}

function enlightenment_open_container_fluid() {
	echo enlightenment_open_tag( 'div', 'container-fluid' );
}

function enlightenment_close_container() {
	echo enlightenment_close_tag();
}

function enlightenment_open_row() {
	echo enlightenment_open_tag( 'div', 'row' );
}

add_action( 'init', 'enlightenment_add_header_container' );

function enlightenment_add_header_container() {
	$theme_support = get_theme_support( 'enlightenment-bootstrap' );
	$header_class = enlightenment_header_class( array( 'echo' => false ) );
	if( false !== strpos( $header_class, 'navbar-static' ) && false !== strpos( $header_class, 'navbar-fixed' ) ) {
		add_action( 'enlightenment_header', 'enlightenment_open_container', 1 );
		add_action( 'enlightenment_header', 'enlightenment_close_container', 999 );
	}
}

add_filter( 'body_class', 'enlightenment_bootstrap_body_class' );

function enlightenment_bootstrap_body_class( $classes ) {
	if( 'fixed-top' == current_theme_supports( 'enlightenment-bootstrap', 'navbar-position' ) )
		$classes[] = 'navbar-offset';
	return $classes;
}

add_filter( 'enlightenment_header_class_args', 'enlightenment_bootstrap_header_class_args' );

function enlightenment_bootstrap_header_class_args( $args ) {
	$position = esc_attr( current_theme_supports( 'enlightenment-bootstrap', 'navbar-position' ) );
	$background = esc_attr( current_theme_supports( 'enlightenment-bootstrap', 'navbar-background' ) );
	$args['class'] .= ' navbar';
	if( '' != $position )
		$args['class'] .= " navbar-$position";
	if( '' != $background )
		$args['class'] .= " navbar-$background";
	return $args;
}

add_filter( 'enlightenment_site_branding_args', 'enlightenment_bootstrap_site_branding_args', 20 );

function enlightenment_bootstrap_site_branding_args( $args ) {
	$args['container_class'] .= ' navbar-header';
	$args['site_description'] = false;
	$args['site_title_tag'] = '';
	$args['home_link_class'] .= ' navbar-brand';
	return $args;
}

add_filter( 'enlightenment_contents_menu_args', 'enlightenment_bootstrap_contents_menu_args', 20 );

function enlightenment_bootstrap_contents_menu_args( $args ) {
	$args['menu_class'] .= ' nav-pills';
	if( ! isset( $args['items_wrap'] ) )
		$args['items_wrap'] = '<ul id="%1$s" class="%2$s">%3$s</ul>';
	$args['items_wrap'] = '<div class="container">' . $args['items_wrap'] . '</div>';
	return $args;
}

add_filter( 'enlightenment_navicon_args', 'enlightenment_bootstrap_navicon_args' );

function enlightenment_bootstrap_navicon_args( $args ) {
	$args['container'] = 'button';
	$args['container_class'] .= ' navbar-toggle';
	$args['container_extra_atts'] = array(
		'type'        => 'button',
		'data-toggle' => 'collapse',
		'data-target' => '.navbar-collapse',
	);
	$args['text'] = sprintf( '<span class="sr-only">%s</span>', $args['text'] );
	$args['text'] .= '<span class="icon-bar"></span>' . "\n";
	$args['text'] .= '<span class="icon-bar"></span>' . "\n";
	$args['text'] .= '<span class="icon-bar"></span>' . "\n";
	return $args;
}

add_filter( 'nav_menu_css_class', 'enlightenment_bootstrap_nav_menu_css_class', 10, 3 );

function enlightenment_bootstrap_nav_menu_css_class( $classes, $item, $args ) {
	if( in_array( 'current-menu-item', $classes ) )
		$classes[] = 'active';
	return $classes;
}

add_filter( 'wp_nav_menu_objects', 'enlightenment_bootstrap_menu_parent_class' );

function enlightenment_bootstrap_menu_parent_class( $items ) {
	
	$parents = array();
	foreach ( $items as $item ) {
		if ( $item->menu_item_parent && $item->menu_item_parent > 0 ) {
			$parents[] = $item->menu_item_parent;
		}
	}
	
	foreach ( $items as $item ) {
		if ( in_array( $item->ID, $parents ) ) {
			if( $item->menu_item_parent && $item->menu_item_parent > 0 )
				$item->classes[] = 'dropdown-submenu';
			else
				$item->classes[] = 'dropdown';
		}
	}
	
	return $items;
}

add_filter( 'enlightenment_submenu_class', 'enlightenment_bootstrap_submenu_class' );

function enlightenment_bootstrap_submenu_class( $class ) {
	$class .= ' dropdown-menu';
	return $class;
}

add_filter( 'enlightenment_nav_menu_link_after', 'enlightenment_bootstrap_caret', 10, 2 );

function enlightenment_bootstrap_caret( $link_after, $item ) {
	if( in_array( 'dropdown', (array) $item->classes ) )
		$link_after .= ' <span class="caret"></span>';
	return $link_after;
}

add_filter( 'wp_nav_menu_args', 'enlightenment_bootstrap_nav_menu_args', 22 );

function enlightenment_bootstrap_nav_menu_args( $args ) {
	if( '' != $args['theme_location'] ) {
		$args['container_class'] .= ' navbar-collapse collapse';
		$args['menu_class'] .= ' nav navbar-nav navbar-right';
	}
	return $args;
}

add_filter( 'enlightenment_search_form', 'enlightenment_bootstrap_search_form_wrap' );

function enlightenment_bootstrap_search_form_wrap( $output ) {
	if( doing_action( 'enlightenment_header' ) ) {
		$before = '<div class="dropdown searchform-dropdown">
			<a id="toggle-search-form" data-toggle="dropdown" href="#" aria-expanded="false"><span class="glyphicon glyphicon-search"></span></a>
			<ul class="dropdown-menu" role="menu" aria-labelledby="toggle-search-form">
				<li>';
		$after = '</li>
			</ul>
		</div>';
		$output = $before . $output . $after;
	}
	return $output;
}

add_filter( 'enlightenment_callout_args', 'enlightenment_bootstrap_callout_args' );

function enlightenment_bootstrap_callout_args( $args ) {
	$args['container_class'] .= ' jumbotron subhead';
	$args['before'] = '<div class="container">' . $args['before'];
	$args['after'] .= '</div>';
	return $args;
}

add_filter( 'enlightenment_archive_location_args', 'enlightenment_bootstrap_archive_location_args' );

function enlightenment_bootstrap_archive_location_args( $args ) {
	$args['container_class'] .= ' page-header';
	$args['before'] = enlightenment_open_tag( 'div', 'container' ) . $args['before'];
	$args['after'] .= enlightenment_close_tag( 'div' );
	$args['title_class'] .= ' page-title';
	$args['prefix_format'] = '%1$s';
	$args['format'] = __( '%2$s%3$s %1$s', 'enlightenment' );
	return $args;
}

add_filter( 'enlightenment_archive_location_prefix', 'enlightenment_bootstrap_archive_location_prefix' );

function enlightenment_bootstrap_archive_location_prefix( $output ) {
	$output = str_replace( __( 'Search Results for', 'enlightenment' ), __( 'Search Results', 'enlightenment' ), $output );
	$output = str_replace( __( 'Archives for', 'enlightenment' ), __( 'Archive', 'enlightenment' ), $output );
	$output = str_replace( __( 'Archives for', 'enlightenment' ), __( 'Archive', 'enlightenment' ), $output );
	return $output;
}

if( current_theme_supports( 'jetpack-portfolio' ) && class_exists( 'Jetpack' ) && in_array( 'custom-content-types', Jetpack::get_active_modules() ) ) {

	add_filter( 'enlightenment_project_types_filter_args', 'enlightenment_bootstrap_project_types_filter_args' );
	
	function enlightenment_bootstrap_project_types_filter_args( $args ) {
		$args['container_class'] .= ' nav nav-pills';
		$args['current_term_class'] .= ' active';
		
		return $args;
	}
	
}

if( current_theme_supports( 'enlightenment-custom-layouts' ) ) {

	add_filter( 'enlightenment_custom_layouts', 'enlightenment_bootstrap_custom_layouts' );

	function enlightenment_bootstrap_custom_layouts( $layouts ) {
		$layouts['content-sidebar']['content_class'] = 'col-md-8';
		$layouts['content-sidebar']['sidebar_class'] = 'col-md-4';
		$layouts['sidebar-content']['content_class'] = 'col-md-8 col-md-push-4';
		$layouts['sidebar-content']['sidebar_class'] = 'col-md-4 col-md-pull-8';
		$layouts['full-width']['content_class']      = 'col-md-12';
		$layouts['full-width']['sidebar_class']      = '';
		return $layouts;
	}

} else {

	add_filter( 'enlightenment_content_class_args', 'enlightenment_bootstrap_content_class_args' );

	function enlightenment_bootstrap_content_class_args( $args ) {
		$args['class'] .= ' col-md-' . ( is_page() ? 12 : 8 );
		return $args;
	}

	add_filter( 'enlightenment_sidebar_class_args', 'enlightenment_bootstrap_sidebar_class_args' );

	function enlightenment_bootstrap_sidebar_class_args( $args ) {
		$args['class'] .= ' col-md-4';
		return $args;
	}

}

add_filter( 'use_default_gallery_style', '__return_false' );

function enlightenment_bootstrap_gallery_style_open_row( $output ) {
	return $output . '<div class="row">';
}

function enlightenment_bootstrap_gallery_shortcode_close_row( $output ) {
	// Allow use of Jetpack Tiled Galleries Module
	if( class_exists( 'Jetpack' ) && in_array( 'tiled-gallery', Jetpack::get_active_modules() ) )
		return $output;
	return $output . '</div>';
}

function enlightenment_bootstrap_gallery_item( $item, $attachment, $id, $attr, $columns ) {
	$colspan = intval( 12 / $columns );
	return '<div class="col-md-' . $colspan . '">' . $item . '</div>';
}

add_filter( 'wp_link_pages_args', 'enlightenment_bootstrap_link_pages_args', 22 );

function enlightenment_bootstrap_link_pages_args( $args ) {
	$args['before']      = '<nav class="post-pagination"><ul class="pagination"><li class="disabled"><span>' . __( 'Pages: ', 'enlightenment' ) . '</span></li>';
	$args['after']       = '</ul></nav>';
	$args['link_before'] = '<span>';
	$args['link_after']  = '</span>';
	if( 'next' == $args['next_or_number'] )
		$args['before'] = '<nav class="post-pagination"><ul class="pager">';
	return $args;
}

add_filter( 'wp_link_pages', 'enlightenment_bootstrap_link_pages', 22 );

function enlightenment_bootstrap_link_pages( $output ) {
	$output = str_replace( '<a', '<li><a', $output );
	$output = str_replace( '</a>', '</a></li>', $output );
	$output = str_replace( ' <span', '<li class="disabled"><span', $output );
	$output = str_replace( '</span> ', '</span></li>', $output );
	return $output;
}

add_filter( 'enlightenment_posts_nav_args', 'enlightenment_bootstrap_posts_nav_args' );
add_filter( 'enlightenment_comments_nav_args', 'enlightenment_bootstrap_posts_nav_args' );

function enlightenment_bootstrap_posts_nav_args( $args ) {
	$args['type'] = 'list';
	$args['link_container'] = 'li';
	if( ! $args['paged'] ) {
		$args['before'] = '<ul class="pager">';
		$args['after']  = '</ul>';
	}
	return $args;
}

add_filter( 'enlightenment_autor_hcard_args', 'enlightenment_bootstrap_autor_hcard_args' );

function enlightenment_bootstrap_autor_hcard_args( $args ) {
	$args['container_class'] .= ' media';
	$args['title_class'] .= ' media-heading';
	return $args;
}

add_filter( 'enlightenment_autor_hcard_avatar', 'enlightenment_bootstrap_autor_hcard_avatar' );

function enlightenment_bootstrap_autor_hcard_avatar( $avatar ) {
	$avatar = sprintf( '<span class="pull-left">%s</span><div class="media-body">', $avatar );
	return $avatar;
}

add_filter( 'enlightenment_author_bio', 'enlightenment_bootstrap_author_bio', 10 );

function enlightenment_bootstrap_author_bio( $output ) {
	$output .= '</div>';
	return $output;
}

add_filter( 'enlightenment_posts_nav', 'enlightenment_bootstrap_paginate_links', 10, 2 );
add_filter( 'enlightenment_comments_nav', 'enlightenment_bootstrap_paginate_links', 10, 2 );

function enlightenment_bootstrap_paginate_links( $output, $args ) {
	if( $args['paged'] ) {
		$args['prev_class'] .= ' page-numbers';
		$args['next_class'] .= ' page-numbers';
		$output = str_replace( 'prev page-numbers', $args['prev_class'], $output );
		$output = str_replace( 'next page-numbers', $args['next_class'], $output );
		$output = str_replace( '<ul class=\'page-numbers\'>', '<ul class="page-numbers pagination">', $output );
		$output = str_replace( '<li><a' . enlightenment_class( $args['prev_class'] ), '<li' . enlightenment_class( $args['prev_class'] ) . '><a', $output );
		$output = str_replace( '<li><a' . enlightenment_class( $args['next_class'] ), '<li' . enlightenment_class( $args['next_class'] ) . '><a', $output );
		$output = str_replace( "<li><a class='page-numbers'", '<li class="page-numbers"><a', $output );
		$output = str_replace( "<li><span class='page-numbers current'>", '<li class="page-numbers current active"><span>', $output );
	}
	return $output;
}

add_filter( 'enlightenment_comment_args', 'enlightenment_bootstrap_comment_args' );

function enlightenment_bootstrap_comment_args( $args ) {
	$args['comment_class'] .= ' media';
	return $args;
}

remove_action( 'enlightenment_comment_header', 'enlightenment_comment_author_avatar', 10, 2 );

add_action( 'enlightenment_before_comment_header', 'enlightenment_comment_author_avatar', 8, 2 );

add_filter( 'enlightenment_comment_author_avatar_args', 'enlightenment_bootstrap_comment_author_avatar_args' );

function enlightenment_bootstrap_comment_author_avatar_args( $args ) {
	$args['avatar_container'] = 'a';
	$args['avatar_container_class'] .= ' pull-left';
	return $args;
}

add_filter( 'enlightenment_comment_author_args', 'enlightenment_bootstrap_comment_author_args' );

function enlightenment_bootstrap_comment_author_args( $args ) {
	$args['container_class'] .= ' media-heading';
	return $args;
}

add_action( 'enlightenment_before_comment_header', 'enlightenment_open_media_body_tag' );

function enlightenment_open_media_body_tag() {
	echo enlightenment_open_tag( 'div', 'media-body' );
}

add_filter( 'enlightenment_after_comment', 'enlightenment_close_tag' );

add_filter( 'enlightenment_comment_form_fields_args', 'enlightenment_bootstrap_comment_form_fields_args' );

function enlightenment_bootstrap_comment_form_fields_args( $args ) {
	$args['author_container_class'] .= ' input-group';
	$args['author_label_class'] .= ' input-group-addon';
	$args['author_class'] .= ' form-control';
	$args['after_author_label'] = str_replace( '">', ' text-danger">', $args['after_author_label'] );
	$args['email_container_class'] .= ' input-group';
	$args['email_label_class'] .= ' input-group-addon';
	$args['email_class'] .= ' form-control';
	$args['after_email_label'] = str_replace( '">', ' text-danger">', $args['after_email_label'] );
	$args['url_container_class'] .= ' input-group';
	$args['url_label_class'] .= ' input-group-addon';
	$args['url_class'] .= ' form-control';
	return $args;
}

add_filter( 'enlightenment_search_form_args', 'enlightenment_bootstrap_search_form_args' );

function enlightenment_bootstrap_search_form_args( $args ) {
	$args['before'] .= '<div class="input-group">';
	$args['after'] .= '</div>';
	$args['input_class'] .= ' form-control';
	$args['submit_class'] .= ' btn btn-default';
	$args['before_submit'] .= '<span class="input-group-btn">';
	$args['after_submit'] .= '</span>';
	return $args;
}

if( current_theme_supports( 'enlightenment-accessibility' ) ) {

	add_filter( 'enlightenment_skip_link_args', 'enlightenment_bootstrap_screen_reader_class' );
	
	add_filter( 'enlightenment_nav_menu_title_args', 'enlightenment_bootstrap_screen_reader_class' );

	function enlightenment_bootstrap_screen_reader_class( $args ) {
		$args['container_class'] .= ' sr-only';
		return $args;
	}
	
	add_filter( 'enlightenment_skip_link_args', 'enlightenment_bootstrap_focusable_screen_reader_class' );
	
	function enlightenment_bootstrap_focusable_screen_reader_class( $args ) {
		$args['container_class'] .= ' sr-only-focusable';
		return $args;
	}

	add_filter( 'enlightenment_accessibility_search_form_args', 'enlightenment_bootstrap_accessibility_search_form_args' );

	function enlightenment_bootstrap_accessibility_search_form_args( $args ) {
		$args['label_class'] .= ' sr-only';
		return $args;
	}

}

if( current_theme_supports( 'enlightenment-grid-loop' ) ) {

	add_filter( 'enlightenment_grid_columns', 'enlightenment_bootstrap_grid_columns' );

	function enlightenment_bootstrap_grid_columns( $columns ) {
		$columns['onecol']['entry_class'] = '';
		$columns['onecol']['full_width_class'] = '';
		$columns['twocol']['entry_class'] = 'col-sm-6';
		$columns['twocol']['full_width_class'] = 'col-md-12';
		$columns['threecol']['entry_class'] = 'col-sm-4';
		$columns['threecol']['full_width_class'] = 'col-md-12';
		$columns['fourcol']['entry_class'] = 'col-md-3 col-sm-6';
		$columns['fourcol']['full_width_class'] = 'col-md-12';
		return $columns;
	}

	add_filter( 'enlightenment_masonry_script_args', 'enlightenment_bootstrap_masonry_script_args' );

	function enlightenment_bootstrap_masonry_script_args( $args ) {
		$grid = enlightenment_get_grid( enlightenment_current_grid() );
		$entry_class = explode( ' ', $grid['entry_class'] );
		$column_width = '.' . $entry_class[0];
		$args['masonry_args']['container']   = '#primary .row';
		$args['masonry_args']['columnWidth'] = $args['masonry_args']['container'] . ' ' . $column_width;
		return $args;
	}
	
	add_action( 'wp', 'enlightenment_grid_loop_content_row' );

	function enlightenment_grid_loop_content_row() {
		if( is_singular() || is_admin() )
			return;
		$grid = enlightenment_get_grid( enlightenment_current_grid() );
		if( 1 != $grid['content_columns'] ) {
			add_action( 'enlightenment_before_entries_list', 'enlightenment_open_row', 999 );
			add_action( 'enlightenment_after_entries_list', 'enlightenment_close_container', 1 );
		}

	}

	if( current_theme_supports( 'enlightenment-infinite-scroll' ) ) {

		add_filter( 'enlightenment_infinite_scroll_script_args', 'enlightenment_bootstrap_infinite_scroll_script_args' );

		function enlightenment_bootstrap_infinite_scroll_script_args( $args ) {
			$grid = enlightenment_get_grid( enlightenment_current_grid() );
			if( 1 != $grid['content_columns'] ) {
				$args['loading']['selector'] = '#primary';
				$args['contentSelector'] = '#primary .row';
			}
			return $args;
		}

	}

}

if( current_theme_supports( 'enlightenment-featured-content' ) ) {

	add_filter( 'enlightenment_custom_post_class-count-1', 'enlightenment_bootstrap_carousel_active_item_class' );

	function enlightenment_bootstrap_carousel_active_item_class( $post_class ) {
		if( 'bootstrap-carousel' == current_theme_supports( 'enlightenment-featured-content', 'slider' ) )
			$post_class .= ' active';
		return $post_class;
	}

	add_filter( 'enlightenment_featured_content_args', 'enlightenment_bootstrap_carousel_featured_content_args' );

	function enlightenment_bootstrap_carousel_featured_content_args( $args ) {
		if( 'bootstrap-carousel' == current_theme_supports( 'enlightenment-featured-content', 'slider' ) ) {
			$args['container_class'] .= ' carousel slide';
			$args['slides_container'] = 'div';
			$args['slides_class'] .= ' carousel-inner';
			$args['slide_container'] = 'div';
			$args['slide_class'] .= ' item';

			$args['before'] .= '<ol class="carousel-indicators">';
			if( 'sticky-posts' == current_theme_supports( 'enlightenment-featured-content', 'query' ) )
				$count = count( get_option( 'sticky_posts' ) );
			elseif( 'pages' == current_theme_supports( 'enlightenment-featured-content', 'query' ) )
				$count = count( $args['page_ids'] );
			for ( $i = 0; $i < $count; $i++ ) {
				$args['before'] .= '<li data-target="#' . $args['container_id'] . '" data-slide-to="' . $i . '"' . ( 0 == $i ? ' class="active"' : '' ) . '></li>';
			}
			$args['before'] .= '</ol>';

			$args['after'] .= '<a class="left carousel-control" href="#' . $args['container_id'] . '" data-slide="prev">';
			$args['after'] .= '<span class="glyphicon glyphicon-chevron-left"></span>';
			$args['after'] .= '</a>';
			$args['after'] .= '<a class="right carousel-control" href="#' . $args['container_id'] . '" data-slide="next">';
			$args['after'] .= '<span class="glyphicon glyphicon-chevron-right"></span>';
			$args['after'] .= '</a>';
		}
		return $args;
	}

	add_action( 'wp_enqueue_scripts', 'enlightenment_bootstrap_localize_carousel' );

	function enlightenment_bootstrap_localize_carousel() {
		if( 'bootstrap-carousel' == current_theme_supports( 'enlightenment-featured-content', 'slider' ) ) {
			$args = apply_filters( 'enlightenment_bootstrap_localize_carousel_args', current_theme_supports( 'enlightenment-featured-content', 'slider_args' ) );
			wp_localize_script( 'bootstrap', 'enlightenment_carousel_args', $args );
			wp_localize_script( 'bootstrap-min', 'enlightenment_carousel_args', $args );
		}
	}

}

if( current_theme_supports( 'enlightenment-unlimited-sidebars' ) && current_theme_supports( 'enlightenment-grid-loop' ) ) {

	add_action( 'enlightenment_before_widgets', 'enlightenment_open_sidebar_row', 999 );

	function enlightenment_open_sidebar_row() {
		$sidebars = enlightenment_theme_option( 'sidebars' );
		$sidebar = enlightenment_dynamic_sidebar();
		if( isset( $sidebars[$sidebar] ) && isset( $sidebars[$sidebar]['grid'] ) ) {
			$grid = enlightenment_get_grid( $sidebars[$sidebar]['grid'] );
			if( 1 < $grid['content_columns'] )
				enlightenment_open_row();
		}
	}

	add_action( 'enlightenment_after_widgets', 'enlightenment_close_sidebar_row', 1 );

	function enlightenment_close_sidebar_row() {
		$sidebars = enlightenment_theme_option( 'sidebars' );
		$sidebar = enlightenment_dynamic_sidebar();
		if( isset( $sidebars[$sidebar] ) && isset( $sidebars[$sidebar]['grid'] ) ) {
			$grid = enlightenment_get_grid( $sidebars[$sidebar]['grid'] );
			if( 1 < $grid['content_columns'] )
				enlightenment_close_container();
		}
	}

}



