<?php

require_once( get_template_directory() . '/core/init.php' );

/**
 * Load the theme options page if in admin mode
 */
if ( is_admin() ) {
	require_once( get_template_directory() . '/inc/theme-options.php' );
	
	require_once( get_template_directory() . '/inc/page-design.php' );
}

require_once( get_template_directory() . '/inc/glyphicons.php' );
	
require_once( get_template_directory() . '/inc/custom-header.php' );

add_filter( 'enlightenment_default_theme_options', 'enlightenment_filter_default_theme_options' );

function enlightenment_filter_default_theme_options( $options ) {
	$defaults = array(
		'navbar_position' => 'fixed-top',
		'navbar_background' => 'default',
		'navbar_size' => 'large',
		'shrink_navbar' => true,
		'blog_header_text' => __( 'From The Blog', 'enlightenment' ),
		'blog_header_description' => '',
		'thumbnail_header_image' => false,
		'thumbnails_crop_flag' => false,
		'thumbnails_size' => 'large',
		'post_meta' => array(
			'author' => true,
			'date' => true,
			'category' => true,
			'comments' => true,
			'edit_link' => true,
		),
		'portfolio_meta' => array(
			'author' => true,
			'date' => true,
			'project_type' => true,
			'comments' => true,
			'edit_link' => true,
		),
		'enable_lightbox' => true,
		'lightbox_script' => 'colorbox',
		'posts_nav_style' => 'infinite',
		'posts_nav_labels' => 'older/newer',
		'copyright_notice' => sprintf( __( '&copy; %1$s %2$s', 'enlightenment' ), '%year%', '%sitename%' ),
		'theme_credit_link' => true,
		'author_credit_link' => false,
		'wordpress_credit_link' => true,
		
		'page_design' => 'boxed',
		'custom_css' => '',
		
		'link_color' => '#428bca',
		'link_hover_color' => '#2a6496',
		'brand_font_family' => 'Open Sans',
		'brand_font_size' => 24,
		'brand_font_style' => '300',
		'brand_font_color' => '#555',
		'brand_hover_color' => '#5e5e5e',
		'menu_items_font_family' => 'Open Sans',
		'menu_items_font_size' => 14,
		'menu_items_font_style' => '400',
		'menu_items_font_color' => '#555',
		'menu_items_hover_color' => '#428bca',
		'page_header_font_family' => 'Open Sans',
		'page_header_font_size' => 40,
		'page_header_font_style' => '300',
		'page_header_font_color' => '#777',
		'entry_title_font_family' => 'Open Sans',
		'entry_title_font_size' => 32,
		'entry_title_font_style' => '700',
		'entry_title_font_color' => '#333',
		'teaser_entry_title_font_family' => 'Open Sans',
		'teaser_entry_title_font_size' => 20,
		'teaser_entry_title_font_style' => '700',
		'teaser_entry_title_font_color' => '#333',
		'single_entry_title_font_family' => 'Open Sans',
		'single_entry_title_font_size' => 36,
		'single_entry_title_font_style' => '700',
		'single_entry_title_font_color' => '#333',
		'entry_title_hover_color' => '#428bca',
		'entry_meta_font_family' => 'Open Sans',
		'entry_meta_font_size' => 13,
		'entry_meta_font_style' => '300',
		'entry_meta_font_color' => '#999',
		'entry_meta_link_color' => '#456',
		'entry_meta_link_hover_color' => '#428bca',
		'entry_content_font_family' => 'Open Sans',
		'entry_content_font_size' => 16,
		'entry_content_font_style' => '400',
		'entry_content_font_color' => '#333',
		'entry_summary_font_family' => 'Open Sans',
		'entry_summary_font_size' => 14,
		'entry_summary_font_style' => '400',
		'entry_summary_font_color' => '#333',
		'widget_title_font_family' => 'Open Sans',
		'widget_title_font_size' => 24,
		'widget_title_font_style' => '700',
		'widget_title_font_color' => '#333',
		'widget_content_font_family' => 'Open Sans',
		'widget_content_font_size' => 14,
		'widget_content_font_style' => '400',
		'widget_content_font_color' => '#555',
		'widget_link_color' => '#428bca',
		'widget_link_hover_color' => '#2a6496',
		'footer_text_font_family' => 'Open Sans',
		'footer_text_font_size' => 14,
		'footer_text_font_style' => '400',
		'footer_text_font_color' => '#555',
		'footer_link_color' => '#428bca',
		'footer_link_hover_color' => '#2a6496',
		
		'page_header_tag' => 'h1',
		'single_page_header_tag' => 'div',
		'entry_title_tag' => 'h2',
		'teaser_entry_title_tag' => 'h2',
		'single_entry_title_tag' => 'h1',
		'comments_title_tag' => 'h2',
		'widget_title_tag' => 'h3',
	);
	return array_merge( $options, $defaults );
}

add_action( 'after_setup_theme', 'enlightenment_setup_theme' );

function enlightenment_setup_theme() {
	enlightenment_set_content_width( 640 );
	add_theme_support( 'enlightenment-web-fonts' );
	add_theme_support( 'enlightenment-accessibility' );
	add_theme_support( 'enlightenment-bootstrap', array(
		'min_files' => true,
		'navbar-position' => enlightenment_theme_option( 'navbar_position' ),
		'navbar-background' => enlightenment_theme_option( 'navbar_background' ),
	) );
	add_theme_support( 'enlightenment-schema-markup' );
	add_theme_support( 'enlightenment-logo', array(
		'width' => 48,
		'height' => 48,
	) );
	add_theme_support( 'enlightenment-menu-icons' );
	add_theme_support( 'enlightenment-menu-descriptions' );
	add_theme_support( 'enlightenment-custom-layouts', array( 'content-sidebar', 'sidebar-content', 'full-width', 'sidebar-content-sidebar' ) );
	add_theme_support( 'enlightenment-grid-loop' );
	
	add_theme_support( 'jetpack-portfolio' );
	
	if( enlightenment_theme_option( 'enable_lightbox' ) )
		add_theme_support( 'enlightenment-lightbox', array( 'script' => enlightenment_theme_option( 'lightbox_script' ) ) );
		
	if( 'infinite' == enlightenment_theme_option( 'posts_nav_style' ) )
		add_theme_support( 'enlightenment-infinite-scroll' );
	elseif( 'ajax' == enlightenment_theme_option( 'posts_nav_style' ) )
		add_theme_support( 'enlightenment-ajax-navigation' );
	add_theme_support( 'enlightenment-theme-settings', array( 'option_name' => 'enlightenment_theme_options' ) );
	add_theme_support( 'enlightenment-template-editor' );
	add_theme_support( 'enlightenment-page-builder' );
	add_theme_support( 'enlightenment-unlimited-sidebars' );
	add_theme_support( 'enlightenment-custom-queries' );

	add_theme_support( 'post-formats', array( 'aside', 'gallery', 'link', 'image', 'quote', 'status', 'video', 'audio', 'chat' ) );
	add_theme_support( 'enlightenment-breadcrumbs' );
	add_theme_support( 'enlightenment-share-buttons' );
	add_theme_support( 'custom-background' );
	add_theme_support( 'custom-header', array(
		'width' => 1440,
		'height' => 960,
		'default-text-color' => '777777',
		'flex-width' => true,
		'flex-height' => true,
		'wp-head-callback' => 'enlightenment_header_style',
		'admin-head-callback' => '',
		'admin-preview-callback' => ''
	) );
	add_theme_support( 'post-thumbnails' );
	if( enlightenment_theme_option( 'thumbnail_header_image' ) )
		add_theme_support( 'enlightenment-post-thumbnail-header' );
	$crop_flag = enlightenment_theme_option( 'thumbnails_crop_flag' );
	add_image_size( 'enlightenment-blog-thumb', 640, $crop_flag ? 480 : 9999, $crop_flag );
	add_image_size( 'enlightenment-teaser-thumb', 300, $crop_flag ? 225 : 9999, $crop_flag );
	load_theme_textdomain( 'enlightenment', get_template_directory() . '/languages' );
}

add_action( 'after_setup_theme', 'enlightenment_add_editor_style', 1000 );

function enlightenment_add_editor_style() {
	$editor_styles = array();
	$editor_styles[-2] = get_template_directory_uri() . '/core/css/bootstrap.min.css';
	$editor_styles[-1] = str_replace( ',', '%2C', enlightenment_web_fonts_style() );
	$editor_styles[0] = 'editor-style.css';
	
	add_editor_style( $editor_styles );
}

add_filter( 'enlightenment_theme_custom_css', 'enlightenment_filter_theme_custom_css' );

function enlightenment_filter_theme_custom_css( $output ) {
	$output .= enlightenment_print_color_option( 'a', 'link_color', false );
	$output .= enlightenment_print_color_option( 'a:hover', 'link_hover_color', false );

	$output .= enlightenment_print_font_options( '.navbar a.navbar-brand', 'brand', false );
	$output .= enlightenment_print_color_option( '.navbar .navbar-brand:hover, .navbar .navbar-brand:focus', 'brand_hover_color', false );
	
	$output .= enlightenment_print_font_options( '.navbar .nav > li > a, .navbar-large .menu-item .menu-item-description', 'menu_items', false );
	$output .= enlightenment_print_color_option( '.navbar .nav > li > a:hover, .navbar-large .menu-item a:hover .menu-item-description, .navbar .nav li.dropdown.open > .dropdown-toggle, .navbar .nav li.dropdown.open > .dropdown-toggle .menu-item-description', 'menu_items_hover_color', false );
	
	$output .= enlightenment_print_font_options( '.archive-title', 'page_header', false );
	
	$output .= enlightenment_print_font_options( '.entry-title', 'entry_title', false );
	$output .= enlightenment_print_font_options( '.entry-teaser .entry-title', 'teaser_entry_title', false );
	$output .= enlightenment_print_font_options( '.single .entry-title, .page .entry-title', 'single_entry_title', false );
	$output .= enlightenment_print_color_option( '.entry-title a:hover', 'entry_title_hover_color', false );
	
	$output .= enlightenment_print_font_options( '.entry-meta', 'entry_meta', false );
	$output .= enlightenment_print_color_option( '.entry-meta a', 'entry_meta_link_color', false );
	$output .= enlightenment_print_color_option( '.entry-meta a:hover', 'entry_meta_link_hover_color', false );
	
	$output .= enlightenment_print_font_options( '.entry-content', 'entry_content', false );
	$output .= enlightenment_print_font_options( '.entry-summary', 'entry_summary', false );
	
	$output .= enlightenment_print_font_options( '.widget-title', 'widget_title', false );
	$output .= enlightenment_print_font_options( '.widget', 'widget_content', false );
	$output .= enlightenment_print_color_option( '.widget a', 'widget_link_color', false );
	$output .= enlightenment_print_color_option( '.widget a:hover', 'widget_link_hover_color', false );
	
	$output .= enlightenment_print_font_options( '.site-footer', 'footer_text', false );
	$output .= enlightenment_print_color_option( '.site-footer a', 'footer_link_color', false );
	$output .= enlightenment_print_color_option( '.site-footer a:hover', 'footer_link_hover_color', false );
	
	$output .= enlightenment_sanitize_custom_css( enlightenment_theme_option( 'custom_css' ) );
	return $output;
}

add_action( 'after_setup_theme', 'enlightenment_remove_header_container', 999 );

function enlightenment_remove_header_container() {
	remove_action( 'init', 'enlightenment_add_header_container' );
}

function enlightenment_open_entry_tag() {
	echo enlightenment_open_tag( 'div', 'entry' );
}

add_action( 'enlightenment_before_entries_list', 'enlightenment_grid_add_entry_container', 8 );

function enlightenment_grid_add_entry_container() {
	if( is_singular() )
		return;
	$grid = enlightenment_get_grid( enlightenment_current_grid() );
//	if( 1 != $grid['content_columns'] ) {
		add_action( 'enlightenment_before_entry_header', 'enlightenment_open_entry_tag', 1 );
		add_action( 'enlightenment_after_entry_footer', 'enlightenment_close_container', 999 );
//	}
}

add_filter( 'enlightenment_current_layout', 'enlightenment_filter_grid_layout' );

function enlightenment_filter_grid_layout( $layout ) {
	if( is_singular() )
		return $layout;
	$grid = enlightenment_get_grid( enlightenment_current_grid() );
	if( 2 < $grid['content_columns'] )
		return 'full-width';
	return $layout;
}

add_filter( 'enlightenment_infinite_scroll_script_args', 'enlightenment_filter_infinite_scroll_script_args' );

function enlightenment_filter_infinite_scroll_script_args( $args ) {
	$grid = enlightenment_get_grid( enlightenment_current_grid() );
	return $args;
}

add_action( 'wp', 'enlightenment_layout_hooks' );

function enlightenment_layout_hooks() {

	add_action( 'enlightenment_before_content', 'enlightenment_open_container', 997 );
	
	add_action( 'enlightenment_before_content', 'enlightenment_open_content_sidebar_wrapper', 998 );
	
	add_action( 'enlightenment_before_content', 'enlightenment_open_row', 999 );
	
	add_action( 'enlightenment_content', 'enlightenment_open_content_wrapper', 9 );
	
	add_action( 'enlightenment_content', 'enlightenment_close_container', 11 );
	
	add_action( 'enlightenment_after_content', 'enlightenment_sidebar_alt', 11 );
	add_action( 'enlightenment_after_content', 'get_sidebar', 11 );
	
	add_action( 'enlightenment_after_content', 'enlightenment_close_container', 12 );
	
	add_action( 'enlightenment_after_content', 'enlightenment_close_container', 13 );
	
	add_action( 'enlightenment_after_content', 'enlightenment_close_container', 14 );
	
	add_action( 'enlightenment_before_widgets', 'enlightenment_open_widgets_wrapper', 8 );
	
	add_action( 'enlightenment_after_widgets', 'enlightenment_close_widgets_wrapper', 11 );
}

function enlightenment_open_content_start() {
	echo enlightenment_open_tag( 'div', 'content-start', 'content-start' );
}

function enlightenment_open_content_sidebar_wrapper() {
	echo enlightenment_open_tag( 'div', 'content-sidebar-wrapper' );
}

function enlightenment_open_content_wrapper() {
	echo enlightenment_open_tag( 'div', 'content-wrapper' );
}

function enlightenment_open_entry_content_column() {
	$layout = enlightenment_get_layout( enlightenment_current_layout() );
	echo enlightenment_open_tag( 'div', $layout['content_class'] );
}

function enlightenment_open_widgets_wrapper() {
	if( 'primary' == enlightenment_current_sidebar_name() ) {
		echo enlightenment_open_tag( 'div', 'widgets-wrapper' );
	}
}

function enlightenment_close_widgets_wrapper() {
	if( 'primary' == enlightenment_current_sidebar_name() ) {
		enlightenment_close_container();
	}
}

add_filter( 'enlightenment_author_posts_link_args', 'enlightenment_filter_author_posts_link_args' );

function enlightenment_filter_author_posts_link_args( $args ) {
	if( doing_action( 'enlightenment_entry_header' ) ) {
		$args['format'] = __( 'Posted by %s', 'enlightenment' );
	} elseif( is_single() && doing_action( 'enlightenment_entry_footer' ) ) {
		$args['container'] = 'h4';
		$args['format'] = __( 'Written by %s', 'enlightenment' );
	}
	return $args;
}

add_filter( 'enlightenment_entry_date_args', 'enlightenment_filter_entry_date_args' );

function enlightenment_filter_entry_date_args( $args ) {
	$args['format'] = __( 'On %s', 'enlightenment' );
	return $args;
}

add_filter( 'enlightenment_categories_list_args', 'enlightenment_filter_categories_list_args' );

function enlightenment_filter_categories_list_args( $args ) {
	$args['format'] = __( 'Filed under %s', 'enlightenment' );
	return $args;
}

add_filter( 'enlightenment_tags_list_args', 'enlightenment_filter_tags_list_args' );

function enlightenment_filter_tags_list_args( $args ) {
	$args['sep'] = ' ';
	return $args;
}

add_filter( 'enlightenment_project_types_args', 'enlightenment_filter_project_types_args' );

function enlightenment_filter_project_types_args( $args ) {
	$args['format'] = __( 'Filed under %s', 'enlightenment' );
	return $args;
}

add_filter( 'enlightenment_comments_link_args', 'enlightenment_filter_comments_link_args' );

function enlightenment_filter_comments_link_args( $args ) {
	$args['format']['zero'] = __( 'No Comments', 'enlightenment' );
	return $args;
}

add_filter( 'enlightenment_edit_post_link_args', 'enlightenment_filter_edit_post_link_args' );

function enlightenment_filter_edit_post_link_args( $args ) {
	$args['format'] =  __( 'Edit This', 'enlightenment' );
	return $args;
}

add_filter( 'enlightenment_author_avatar_args', 'enlightenment_filter_author_avatar_args' );

function enlightenment_filter_author_avatar_args( $args ) {
	if( is_singular() ) {
		$args['avatar_size'] = 96;
	}
	
	return $args;
}

add_filter( 'enlightenment_entry_meta_args', 'enlightenment_filter_entry_meta_args' );

function enlightenment_filter_entry_meta_args( $args ) {
	if( is_singular() && doing_action( 'enlightenment_entry_footer' ) ) {
		$args['format'] = '<div class="entry-author media"><span class="pull-left">%8$s</span> <div class="media-body">%1$s %9$s</div></div> %4$s';
	} elseif( is_singular( 'jetpack-portfolio' ) ) {
		$args['format'] = '';
		$meta = enlightenment_theme_option( 'portfolio_meta' );
		if( $meta['author'] ) {
			$args['format'] .= '%1$s ';
		}
		if( $meta['date'] ) {
			$args['format'] .= '%2$s ';
		}
		if( $meta['project_type'] ) {
			$args['format'] .= enlightenment_project_types( array( 'echo' => false ) );
		}
		if( $meta['comments'] ) {
			$args['format'] .= '%5$s ';
		}
		if( $meta['edit_link'] ) {
			$args['format'] .= '%6$s';
		}
	} else {
		$args['format'] = '';
		$meta = enlightenment_theme_option( 'post_meta' );
		if( $meta['author'] ) {
			$args['format'] .= '%1$s ';
		}
		if( $meta['date'] ) {
			$args['format'] .= '%2$s ';
		}
		if( $meta['category'] ) {
			$args['format'] .= '%3$s ';
		}
		if( $meta['comments'] ) {
			$args['format'] .= '%5$s ';
		}
		if( $meta['edit_link'] ) {
			$args['format'] .= '%6$s';
		}
	}
	
	return $args;
}

add_action( 'wp', 'enlightenment_remove_generated_excerpt' );

function enlightenment_remove_generated_excerpt() {
	if( is_singular() ) {
		remove_filter( 'get_the_excerpt', 'wp_trim_excerpt' );
	}
}

add_action( 'init', 'enlightenment_remove_excerpt_sharing_buttons' );

function enlightenment_remove_excerpt_sharing_buttons() {
	remove_filter( 'the_excerpt', 'sharing_display', 19 );
}

function enlightenment_scroll_to_content( $args = null ) {
	$defaults = array(
		'container' => 'div',
		'container_class' => 'scroll-to-content',
		'container_id' => '',
		'container_extra_atts' => '',
		'target' => '#content',
		'icon' => '<i class="icon-down-open-big"></i>',
		'screen_reader_text' => __( 'Scroll To Content', 'enlightenment' ),
		'echo' => true,
	);
	$defaults = apply_filters( 'enlightenment_scroll_to_content_args', $defaults );
	$args = wp_parse_args( $args, $defaults );
	
	$output = enlightenment_open_tag( $args['container'], $args['container_class'], $args['container_id'], $args['container_extra_atts'] );
	$output .= sprintf( '<a href="%s">', esc_attr( $args['target'] ) );
	$output .= strip_tags( $args['icon'], '<span><i>' );
	$output .= sprintf( '<span class="screen-reader-text sr-only">%s</span>', esc_html( $args['screen_reader_text'] ) );
	$output .= '</a>';
	$output .= enlightenment_close_tag( $args['container'] );
	$output = apply_filters( 'enlightenment_scroll_to_content', $output, $args );
	
	if( ! $args['echo'] ) {
		return $output;
	}
	
	echo $output;
}

add_filter( 'enlightenment_scroll_to_content_args', 'enlightenment_filter_scroll_to_content_args' );

function enlightenment_filter_scroll_to_content_args( $args ) {
	if( is_singular() ) {
		$args['target'] = '#content-start';
	}
	
	return $args;
}

add_action( 'wp', 'enlightenment_single_header_scroll_to_content' );

function enlightenment_single_header_scroll_to_content() {
	if( is_singular() && 'full-screen' == enlightenment_theme_option( 'header_size' ) ) {
		add_action( 'enlightenment_entry_header', 'enlightenment_scroll_to_content', 30 );
	}
}

add_filter( 'enlightenment_archive_location_args', 'enlightenment_archive_location_scroll_to_content' );

function enlightenment_archive_location_scroll_to_content( $args ) {
	if( 'full-screen' == enlightenment_theme_option( 'header_size' ) ) {
		$args['after'] .= enlightenment_scroll_to_content( array( 'echo' => false ) );
	}
	
	return $args;
}

add_action( 'enlightenment_before_sidebar', 'enlightenment_wrap_sidebar_container' );

function enlightenment_wrap_sidebar_container() {
	if( is_singular() )
		return;
	$grid = enlightenment_get_grid( enlightenment_current_grid() );
	if( 1 != $grid['content_columns'] && ( 'primary' == enlightenment_current_sidebar_name() || 'secondary' == enlightenment_current_sidebar_name() ) ) {
		add_action( 'enlightenment_before_widgets', 'enlightenment_open_sidebar_container' );
		add_action( 'enlightenment_after_widgets', 'enlightenment_close_container' );
	}
}

function enlightenment_open_sidebar_container() {
	echo '<div class="sidebar-container">';
}

add_action( 'enlightenment_before_entry', 'enlightenment_theme_options_entry_meta_hooks', 4 );

function enlightenment_theme_options_entry_meta_hooks() {
	if( 'post' == get_post_type() ) {
		$post_meta = enlightenment_theme_option( 'post_meta' );
		if( ! $post_meta['author'] )
			remove_action( 'enlightenment_entry_meta', 'the_author_posts_link' );
		if( ! $post_meta['date'] )
			remove_action( 'enlightenment_entry_meta', 'the_time' );
		if( ! $post_meta['category'] )
			remove_action( 'enlightenment_entry_meta', 'the_category' );
		if( ! $post_meta['comments'] )
			remove_action( 'enlightenment_entry_meta', 'comments_popup_link' );
		if( ! $post_meta['edit_link'] )
			remove_action( 'enlightenment_entry_meta', 'edit_post_link' );
	} elseif( 'jetpack-portfolio' == get_post_type() ) {
		$post_meta = enlightenment_theme_option( 'portfolio_meta' );
		if( ! $post_meta['author'] )
			remove_action( 'enlightenment_entry_meta', 'the_author_posts_link' );
		if( ! $post_meta['date'] )
			remove_action( 'enlightenment_entry_meta', 'the_time' );
		if( ! $post_meta['project_type'] )
			remove_action( 'enlightenment_entry_meta', 'enlightenment_project_types' );
		if( ! $post_meta['comments'] )
			remove_action( 'enlightenment_entry_meta', 'comments_popup_link' );
		if( ! $post_meta['edit_link'] )
			remove_action( 'enlightenment_entry_meta', 'edit_post_link' );
	}
}

add_filter( 'excerpt_length', 'enlightenment_excerpt_length' );

function enlightenment_excerpt_length( $length ) {
	if( is_singular() )
		return $length;
	if( doing_action( 'enlightenment_after_header' ) )
		return 18;
	$grid = enlightenment_get_grid( enlightenment_current_grid() );
	if( 3 == $grid['content_columns'] )
		return 24;
	if( 4 == $grid['content_columns'] )
		return 18;
	return $length;
}

add_filter( 'the_content', 'enlightenment_content_link_pages' );

function enlightenment_enqueue_theme_options_font( $option ) {
	$default_options = enlightenment_default_theme_options();
	if( ( enlightenment_theme_option( $option . '_font_family' ) != $default_options[$option . '_font_family'] ) && array_key_exists( enlightenment_theme_option( $option . '_font_family' ), enlightenment_web_fonts() ) )
		enlightenment_enqueue_font( enlightenment_theme_option( $option . '_font_family' ), array( enlightenment_theme_option( $option . '_font_style' ) ) );
}

add_action( 'enlightenment_enqueue_fonts', 'enlightenment_enqueue_web_fonts' );

function enlightenment_enqueue_web_fonts() {
	enlightenment_enqueue_font( 'Open Sans', array( '300', '400', 'italic', '600', '700' ) );
	
	enlightenment_enqueue_theme_options_font( 'brand' );
	enlightenment_enqueue_theme_options_font( 'menu_items' );
	enlightenment_enqueue_theme_options_font( 'page_header' );
	enlightenment_enqueue_theme_options_font( 'entry_title' );
	enlightenment_enqueue_theme_options_font( 'teaser_entry_title' );
	enlightenment_enqueue_theme_options_font( 'single_entry_title' );
	enlightenment_enqueue_theme_options_font( 'entry_meta' );
	enlightenment_enqueue_theme_options_font( 'entry_content' );
	enlightenment_enqueue_theme_options_font( 'entry_summary' );
	enlightenment_enqueue_theme_options_font( 'widget_title' );
	enlightenment_enqueue_theme_options_font( 'widget_content' );
	enlightenment_enqueue_theme_options_font( 'footer_text' );
}

add_action( 'widgets_init', 'enlightenment_widgets_init' );

function  enlightenment_widgets_init( $sidebars ) {
	register_sidebar( array(
		'name' => 'Secondary',
		'id' => 'sidebar-2',
		'before_widget' => '<aside id="%1$s" class="widget %2$s">' . "\n",
		'after_widget' => '</aside>' . "\n",
		'before_title' => sprintf( '<%s class="widget-title">', enlightenment_theme_option( 'widget_title_tag' ) ),
		'after_title' => sprintf( '</%s>', enlightenment_theme_option( 'widget_title_tag' ) ) . "\n",
	) );
	register_sidebar( array(
		'name' => 'Navbar',
		'id' => 'sidebar-3',
		'before_widget' => '<aside id="%1$s" class="widget %2$s">' . "\n",
		'after_widget' => '</aside>' . "\n",
		'before_title' => sprintf( '<%s class="widget-title">', enlightenment_theme_option( 'widget_title_tag' ) ),
		'after_title' => sprintf( '</%s>', enlightenment_theme_option( 'widget_title_tag' ) ) . "\n",
	) );
}

add_filter( 'enlightenment_register_sidebars_args', 'enlightenment_filter_register_sidebars_args' );

function enlightenment_filter_register_sidebars_args( $args ) {
	$args['before_title'] = sprintf( '<%s class="widget-title">', enlightenment_theme_option( 'widget_title_tag' ) );
	$args['after_title']  = sprintf( '</%s>', enlightenment_theme_option( 'widget_title_tag' ) ) . "\n";
	return $args;
}

add_filter( 'enlightenment_registered_sidebars_default_atts', 'enlightenment_filter_registered_sidebars_default_atts' );

function enlightenment_filter_registered_sidebars_default_atts( $atts ) {
	
	return $atts;
}

add_action( 'enlightenment_register_layouts', 'enlightenment_register_theme_layouts' );

function enlightenment_register_theme_layouts() {
	enlightenment_register_layout(
		'sidebar-content-sidebar',
		'Sidebar / Content / Sidebar',
		get_template_directory_uri() . '/images/sidebar-content-sidebar.png',
		'layout-sidebar-content-sidebar',
		'col-md-6 col-md-push-3',
		'col-md-3',
		array( 'sidebar_alt_class' => 'col-md-3 col-md-pull-6' )
	);
}

add_filter( 'enlightenment_call_js', 'enlightenment_call_js_add_fitvids' );

function enlightenment_call_js_add_fitvids( $deps ) {
	$deps[] = 'fitvids';
	return $deps;
}

add_action( 'wp_enqueue_scripts', 'enlightenment_enqueue_theme_scripts' );

function enlightenment_enqueue_theme_scripts() {
	wp_enqueue_script( 'fitvids' );
	wp_enqueue_script( 'enlightenment-theme-call-js', get_template_directory_uri() . '/js/call.js', array( 'jquery' ), null, true );
	$args = array(
		'nav_more_text' => __( 'More', 'enlightenment' ),
	);
	if( 'large' == enlightenment_theme_option( 'navbar_size' ) && 'fixed-top' == enlightenment_theme_option( 'navbar_position' ) )
		$args['shrink_navbar'] = enlightenment_theme_option( 'shrink_navbar' );
	if( ! empty( $args ) )
		wp_localize_script( 'enlightenment-theme-call-js', 'enlightenment_theme_call_js', $args );
}

add_filter( 'body_class', 'enlightenment_filter_body_class' );

function enlightenment_filter_body_class( $classes ) {
	if( is_singular() && '' != get_post_meta( get_the_ID(), '_enlightenment_page_design', true ) ) {
		$classes[] = 'design-' . esc_attr( get_post_meta( get_the_ID(), '_enlightenment_page_design', true ) );
	} else {
		$classes[] = 'design-' . esc_attr( enlightenment_theme_option( 'page_design' ) );
	}
	
	$classes[] = sprintf( 'navbar-%s-offset', esc_attr( enlightenment_theme_option( 'navbar_size' ) ) );
	
	return $classes;
}

add_filter( 'enlightenment_body_extra_atts_args', 'enlightenment_filter_body_extra_atts_args' );

function enlightenment_filter_body_extra_atts_args( $args ) {
	$args['atts'] .= ' data-spy="scroll" data-target=".subnav" data-offset="100"';
	return $args;
}

add_filter( 'enlightenment_header_class_args', 'enlightenment_filter_header_class_args' );

function enlightenment_filter_header_class_args( $args ) {
	if( 'large' == enlightenment_theme_option( 'navbar_size' ) )
		$args['class'] .= ' navbar-large';
	return $args;
}

add_filter( 'enlightenment_site_branding_args', 'enlightenment_filter_site_branding_args', 12 );

function enlightenment_filter_site_branding_args( $args ) {
	$args['site_title_tag'] = is_home() ? 'h1' : 'div';
	return $args;
}

add_filter( 'enlightenment_nav_menu_wrap_args', 'enlightenment_filter_nav_menu_wrap_args' );

function enlightenment_filter_nav_menu_wrap_args( $args ) {
	if( doing_action( 'enlightenment_header' ) )
		$args['container_class'] .= ' navbar-right';
	if( doing_action( 'enlightenment_after_header' ) ) {
		$args['container_class'] = 'subnav';
		$args['container_id'] = '';
	}
	return $args;
}

add_filter( 'wp_nav_menu_args', 'enlightenment_filter_nav_menu_args' );

function enlightenment_filter_nav_menu_args( $args ) {
	$args['fallback_cb'] = '__return_false';
	if( doing_action( 'enlightenment_header' ) )
		$args['theme_location'] = 'primary';
	return $args;
}

add_filter( 'enlightenment_archive_location_args', 'enlightenment_filter_archive_location_args' );

function enlightenment_filter_archive_location_args( $args ) {
	$args['title_tag'] = is_singular() ? enlightenment_theme_option( 'single_page_header_tag' ) : enlightenment_theme_option( 'page_header_tag' );
	$args['blog_text'] = enlightenment_theme_option( 'blog_header_text' );
	$args['blog_description'] = enlightenment_theme_option( 'blog_header_description' );
	return $args;
}

add_action( 'enlightenment_breadcrumbs_args', 'enlightenment_filter_breadcrumbs_args' );

function enlightenment_filter_breadcrumbs_args( $args ) {
	$args['prefix_format'] = '';
	return $args;
}

add_filter( 'enlightenment_the_title_args', 'enlightenment_filter_the_title_args' );

function enlightenment_filter_the_title_args( $args ) {
	if( is_singular() )
		$args['title_tag'] = enlightenment_theme_option( 'single_entry_title_tag' );
	elseif( enlightenment_is_lead_post() )
		$args['title_tag'] = enlightenment_theme_option( 'entry_title_tag' );
	else
		$args['title_tag'] = enlightenment_theme_option( 'teaser_entry_title_tag' );
	return $args;
}

add_filter( 'enlightenment_the_tags_wrap_args', 'enlightenment_filter_the_tags_wrap_args' );

function enlightenment_filter_the_tags_wrap_args( $args ) {
	$args['sep'] = ' ';
	$args['text_format'] = '%s';
	return $args;
}

add_filter( 'enlightenment_comments_number_args', 'enlightenment_filter_comments_number_args' );

function enlightenment_filter_comments_number_args( $args ) {
	$args['container'] = enlightenment_theme_option( 'comments_title_tag' );
	return $args;
}

add_filter( 'post_thumbnail_size', 'enlightenment_post_thumbnail_size' );

function enlightenment_post_thumbnail_size( $size ) {
	if( 'full-screen' == enlightenment_current_sidebar_name() && doing_action( 'enlightenment_custom_before_entry_header' ) ) {
		global $enlightenment_custom_query_name;
		if( 'custom_query_widget_slider' == $enlightenment_custom_query_name )
			return 'full';
	} elseif( ! enlightenment_is_lead_post() ) {
		return 'enlightenment-teaser-thumb';
	} elseif( 'small' == enlightenment_theme_option( 'thumbnails_size' ) ) {
		return 'thumbnail';
	}
	
	return 'enlightenment-blog-thumb';
}

add_filter( 'enlightenment_comment_form_defaults_args', 'enlightenment_filter_comment_form_defaults_args' );

function enlightenment_filter_comment_form_defaults_args( $args ) {
	$args['container_class'] .= ' input-group textarea-group';
	$args['label_class'] .= ' input-group-addon textarea-group-addon';
	$args['textarea_class'] .= ' form-control';
	return $args;
}

add_filter( 'enlightenment_posts_nav_args', 'enlightenment_filter_posts_nav_args' );

function enlightenment_filter_posts_nav_args( $args ) {
	if( 'older/newer' == enlightenment_theme_option( 'posts_nav_labels' ) ) {
		$args['prev_label'] = __( 'Newer Posts', 'enlightenment' );
		$args['next_label'] = __( 'Older Posts', 'enlightenment' );
	} elseif( 'earlier/later' == enlightenment_theme_option( 'posts_nav_labels' ) ) {
		$args['prev_label'] = __( 'Later Posts', 'enlightenment' );
		$args['next_label'] = __( 'Earlier Posts', 'enlightenment' );
	} elseif( 'numbered' == enlightenment_theme_option( 'posts_nav_labels' ) ) {
		$args['paged'] = true;
	}
	return $args;
}

add_filter( 'enlightenment_posts_nav', 'enlightenment_bootstrap_pagination_centered', 12, 2 );

function enlightenment_bootstrap_pagination_centered( $output, $args ) {
	if( $args['paged'] )
		$output = str_replace( 'pagination', 'pagination pagination-centered', $output );
	return $output;
}

add_filter( 'enlightenment_sidebar_class_args', 'enlightenment_filter_sidebar_class', 12 );

function enlightenment_filter_sidebar_class( $args ) {
	if( 'alt' == enlightenment_current_sidebar_name() ) {
		$layout = enlightenment_get_layout( enlightenment_current_layout() );
		$args['class'] .= ' ' . esc_attr( $layout['extra_atts']['sidebar_alt_class'] );
	}
	return $args;
}

add_filter( 'enlightenment_sidebar_locations', 'enlightenment_filter_sidebar_locations' );

function enlightenment_filter_sidebar_locations( $sidebars ) {
	$theme_sidebars = array(
		'alt' => array(
			'name' => 'Secondary',
			'contained' => true,
			'sidebar' => 'sidebar-2',
		),
		'navbar' => array(
			'name' => 'Navbar',
			'contained' => true,
			'sidebar' => 'sidebar-3',
		),
		'full-screen' => array(
			'name' => 'Full Screen',
			'contained' => true,
			'sidebar' => '',
		),
		'header' => array(
			'name' => 'Header Sidebar',
			'contained' => false,
			'sidebar' => '',
		),
		'header-secondary' => array(
			'name' => 'Secondary Header Sidebar',
			'contained' => false,
			'sidebar' => '',
		),
		'main' => array(
			'name' => 'Main Sidebar',
			'contained' => false,
			'sidebar' => '',
		),
		'main-secondary' => array(
			'name' => 'Secondary Main Sidebar',
			'contained' => false,
			'sidebar' => '',
		),
		'content' => array(
			'name' => 'Content Sidebar',
			'contained' => true,
			'sidebar' => '',
		),
		'content-secondary' => array(
			'name' => 'Secondary Content Sidebar',
			'contained' => true,
			'sidebar' => '',
		),
		'loop' => array(
			'name' => 'The Loop Sidebar',
			'contained' => true,
			'sidebar' => '',
		),
		'after-content' => array(
			'name' => 'After Content Sidebar',
			'contained' => true,
			'sidebar' => '',
		),
		'after-content-secondary' => array(
			'name' => 'Secondary After Content Sidebar',
			'contained' => true,
			'sidebar' => '',
		),
		'after-main' => array(
			'name' => 'After Main Sidebar',
			'contained' => false,
			'sidebar' => '',
		),
		'after-main-secondary' => array(
			'name' => 'Secondary After Main Sidebar',
			'contained' => false,
			'sidebar' => '',
		),
		'footer' => array(
			'name' => 'Footer Sidebar',
			'contained' => false,
			'sidebar' => '',
		),
		'footer-secondary' => array(
			'name' => 'Secondary Footer Sidebar',
			'contained' => false,
			'sidebar' => '',
		),
	);
	return array_merge( $sidebars, $theme_sidebars );
}

add_filter( 'enlightenment_add_new_sidebar_default_atts', 'enlightenment_filter_add_new_sidebar_default_atts' );

function enlightenment_filter_add_new_sidebar_default_atts( $atts ) {
	$atts['sidebar_title_color'] = enlightenment_theme_option( 'widget_title_font_color' );
	$atts['sidebar_text_color'] = enlightenment_theme_option( 'widget_content_font_color' );
	$atts['widgets_title_color'] = enlightenment_theme_option( 'widget_title_font_color' );
	$atts['widgets_text_color'] = enlightenment_theme_option( 'widget_content_font_color' );
	
	return $atts;
}

add_action( 'enlightenment_header', 'enlightenment_sidebar_navbar', 8 );

function enlightenment_sidebar_navbar() {
	get_sidebar( 'navbar' );
}

function enlightenment_sidebar_alt() {
	if( 'sidebar-content-sidebar' == enlightenment_current_layout() ) {
		get_sidebar( 'alt' );
	}
}

function enlightenment_sidebar_loop() {
	get_sidebar( 'loop' );
}

add_action( 'enlightenment_after_widgets', 'enlightenment_wrap_footer_sidebar_after_widgets' );

function enlightenment_wrap_footer_sidebar_after_widgets() {
	if( 'footer' == enlightenment_current_sidebar_name() ) {
		enlightenment_close_container();
		enlightenment_close_container();
	}
}

add_action( 'enlightenment_before_custom_loop', 'enlightenment_full_screen_slider_add_container' );

function enlightenment_full_screen_slider_add_container( $query_name ) {
	if( 'full-screen' == enlightenment_current_sidebar_name() && 'custom_query_widget_slider' == $query_name ) {
		add_action( 'enlightenment_custom_before_entry_content', 'enlightenment_open_container', 1 );
		add_action( 'enlightenment_custom_after_entry_content', 'enlightenment_close_container', 999 );
	}
}

add_action( 'enlightenment_after_custom_loop', 'enlightenment_full_screen_slider_remove_container' );

function enlightenment_full_screen_slider_remove_container( $query_name ) {
	if( 'full-screen' == enlightenment_current_sidebar_name() && 'custom_query_widget_slider' == $query_name ) {
		remove_action( 'enlightenment_custom_before_entry_content', 'enlightenment_open_container', 1 );
		remove_action( 'enlightenment_custom_after_entry_content', 'enlightenment_close_container', 999 );
	}
}

function enlightenment_full_screen_slider_add_overlay( $query_name ) {
	if( 'full-screen' == enlightenment_current_sidebar_name() && 'custom_query_widget_slider' == $query_name ) {
		add_action( 'enlightenment_custom_before_entry_header', 'enlightenment_slide_overlay' );
	}
}

function enlightenment_full_screen_slider_remove_overlay( $query_name ) {
	if( 'full-screen' == enlightenment_current_sidebar_name() && 'custom_query_widget_slider' == $query_name ) {
		remove_action( 'enlightenment_custom_before_entry_header', 'enlightenment_slide_overlay' );
	}
}

function enlightenment_slide_overlay() {
	echo enlightenment_open_tag( 'div', 'slide-overlay' );
	echo enlightenment_close_tag();
}

add_filter( 'enlightenment_theme_custom_css', 'enlightenment_unlimited_sidebars_print_theme_css', 12 );

function enlightenment_unlimited_sidebars_print_theme_css( $output ) {
	$sidebars = enlightenment_registered_sidebars();
	$defaults = enlightenment_registered_sidebars_default_atts();
	$default_bg = $defaults['widgets_background_color'];
	
	foreach( $sidebars as $sidebar => $atts ) {
		if( $default_bg != $atts['widgets_background_color'] ) {
			$output .= sprintf( ".custom-%s .widget {\n", $sidebar );
			$output .= "\tpadding-left: 20px;\n";
			$output .= "\tpadding-right: 20px;\n";
			$output .= "\tmargin-top: 15px;\n";
			$output .= "\tmargin-bottom: 15px;\n";
			$output .= "\tborder-radius: 2px;\n";
			$output .= "}\n";
		}
		
		if( 'parallax' == $atts['background']['scroll'] ) {
			$output .= sprintf( ".custom-%s {\n", $sidebar );
			$output .= "\tposition: relative;\n";
			$output .= "\toverflow: hidden;\n";
			$output .= "}\n";
		}
	}
	
	return $output;
}

add_action( 'enlightenment_footer', 'enlightenment_open_container', 1 );

add_action( 'enlightenment_footer', 'enlightenment_close_container', 999 );

add_filter( 'enlightenment_copyright_notice_args', 'enlightenment_filter_copyright_notice_args' );

function enlightenment_filter_copyright_notice_args( $args ) {
	$format = enlightenment_theme_option( 'copyright_notice' );
	$format = str_replace( '%year%', '%1$s', $format );
	$format = str_replace( '%sitename%', '%2$s', $format );
	
	$args['format'] = strip_tags( $format, '<a><img><strong><abbr>' );
	return $args;
}

add_filter( 'enlightenment_credit_links_args', 'enlightenment_filter_credit_links_args' );

function enlightenment_filter_credit_links_args( $args ) {
	$theme_credit_link = esc_url( 'https://www.onedesigns.com/themes/enlightenment');
	$author_credit_link = esc_url( 'https://www.onedesigns.com/');
	$wordpress_credit_link = esc_url( 'https://wordpress.org/');
	if( enlightenment_theme_option( 'theme_credit_link' ) && enlightenment_theme_option( 'author_credit_link' ) && enlightenment_theme_option( 'wordpress_credit_link' ) ) {
		$args['text'] = sprintf( __( 'Built with <a href="%1$s">Enlightenment Theme</a> by <a href="%2$s" rel="designer">One Designs</a> and <a href="%3$s" rel="generator">WordPress</a>', 'enlightenment' ), $theme_credit_link, $author_credit_link, $wordpress_credit_link ) . "\n";
	} elseif( enlightenment_theme_option( 'theme_credit_link' ) && enlightenment_theme_option( 'author_credit_link' ) && ! enlightenment_theme_option( 'wordpress_credit_link' ) ) {
		$args['text'] = sprintf( __( 'Built with <a href="%1$s">Enlightenment Theme</a> by <a href="%2$s" rel="designer">One Designs</a>', 'enlightenment' ), $theme_credit_link, $author_credit_link ) . "\n";
	} elseif( enlightenment_theme_option( 'theme_credit_link' ) && ! enlightenment_theme_option( 'author_credit_link' ) && enlightenment_theme_option( 'wordpress_credit_link' ) ) {
		$args['text'] = sprintf( __( 'Built with <a href="%1$s">Enlightenment Theme</a> and <a href="%2$s" rel="generator">WordPress</a>', 'enlightenment' ), $theme_credit_link, $wordpress_credit_link ) . "\n";
	} elseif( ! enlightenment_theme_option( 'theme_credit_link' ) && enlightenment_theme_option( 'author_credit_link' ) && enlightenment_theme_option( 'wordpress_credit_link' ) ) {
		$args['text'] = sprintf( __( 'Designed by <a href="%1$s" rel="designer">One Designs</a> with <a href="%2$s" rel="generator">WordPress</a>', 'enlightenment' ), $author_credit_link, $wordpress_credit_link ) . "\n";
	} elseif( enlightenment_theme_option( 'theme_credit_link' ) && ! enlightenment_theme_option( 'author_credit_link' ) && ! enlightenment_theme_option( 'wordpress_credit_link' ) ) {
		$args['text'] = sprintf( __( 'Built with <a href="%1$s">Enlightenment Theme</a>', 'enlightenment' ), $theme_credit_link ) . "\n";
	} elseif( ! enlightenment_theme_option( 'theme_credit_link' ) && enlightenment_theme_option( 'author_credit_link' ) && ! enlightenment_theme_option( 'wordpress_credit_link' ) ) {
		$args['text'] = sprintf( __( 'Designed by <a href="%1$s" rel="designer">One Designs</a>', 'enlightenment' ), $author_credit_link ) . "\n";
	} elseif( ! enlightenment_theme_option( 'theme_credit_link' ) && ! enlightenment_theme_option( 'author_credit_link' ) && enlightenment_theme_option( 'wordpress_credit_link' ) ) {
		$args['text'] = sprintf( __( 'Powered by <a href="%1$s" rel="generator">WordPress</a>', 'enlightenment' ), $wordpress_credit_link ) . "\n";
	} else {
		$args['echo'] = false;
	}
	return $args;
}



