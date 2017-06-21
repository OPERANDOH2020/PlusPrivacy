<?php

function enlightenment_theme_option( $option, $default_value = null ) {
	global $enlightenment_theme_options, $enlightenment_default_theme_options;
	if( ! isset( $enlightenment_theme_options ) )
		$enlightenment_theme_options = get_option( 'enlightenment_theme_options', enlightenment_default_theme_options() );
	if( isset( $enlightenment_theme_options[ $option ] ) )
		$return = $enlightenment_theme_options[ $option ];
	else {
		if( ! isset( $enlightenment_default_theme_options ) )
			$enlightenment_default_theme_options = enlightenment_default_theme_options();
		if( isset( $enlightenment_default_theme_options[ $option ] ) )
			$return = $enlightenment_default_theme_options[ $option ];
		else
			$return = $default_value;
	}
	return apply_filters( 'enlightenment_theme_option-' . $option, $return );
}

function enlightenment_default_theme_options() {
	return apply_filters( 'enlightenment_default_theme_options', array() );
}

function enlightenment_set_content_width( $width, $force = false ) {
	global $content_width;
	if( isset( $content_width ) && ! $force )
		return;
	$content_width = apply_filters( 'enlightenment_content_width', $width );
}

function enlightenment_filter_current_theme_supports( $support, $args ) {
	if( false === $support )
		return false;
	global $_wp_theme_features, $wp_current_filter;
	if( false === strpos( end( $wp_current_filter ), 'current_theme_supports-' ) ) {
		_doing_it_wrong( __FUNCTION__, __( 'This function must be hooked to the \'current_theme_supports-{$theme_feature}\' filter.', 'enlightenment' ), '' );
		return;
	}
	$feature = str_replace( 'current_theme_supports-', '', end( $wp_current_filter ) );
	if( ! isset( $_wp_theme_features[$feature][0][$args[0]] ) )
		return false;
	return $_wp_theme_features[$feature][0][$args[0]];
}

function enlightenment_current_template_file() {
	$files = get_included_files();
	return basename( end( $files ) );
}

function enlightenment_post_is_paged() {
	global $page;
	return is_singular() && isset( $page ) && 1 < $page;
}

function enlightenment_class( $class, $echo = false ) {
	if( '' == $class )
		$output = '';
	else
		$output = apply_filters( 'enlightenment_class', sprintf( ' class="%s"', trim( esc_attr( $class ) ) ) );
	if( ! $echo )
		return $output;
	echo $output;
}

function enlightenment_id( $id, $echo = false ) {
	if( '' == $id )
		$output = '';
	else
		$output = sprintf( ' id="%s"', esc_attr( $id ) );
	if( ! $echo )
		return $output;
	echo $output;
}

function enlightenment_attr_is_type( $attr, $type ) {
	if( 'data' != $type && 'aria' != $type ) {
		_doing_it_wrong( __FUNCTION__, __ ( "Second parameter can only be 'data' or 'aria'", 'enlightenment' ), '' );
		return;
	}
	$pos = strpos( $attr, $type . '-' );
	return ( false !== $pos && 0 === $pos );
}

function enlightenment_extra_atts( $atts, $echo = false ) {
	/* 
	 * Attributes that load external resources like src are not safe,
	 * attributes that point to external resources like href are fine
	 * except inside tags that load the resources like <link>
	 */
	$safe_atts = apply_filters( 'enlightenment_safe_extra_atts',  array(
		'alt',
		'title',
		'href',
		'rel',
		'role',
		'style',
		'target',
		'name',
		'type',
		'value',
		'checked',
		'selected',
		'multiple',
		'width',
		'height',
		'action',
		'itemscope',
		'itemprop',
		'itemtype',
	) );
	// data-* attributes
	$data_atts_allowed = apply_filters( 'enlightenment_data_atts_allowed', true );
	// aria-* attributes
	$aria_atts_allowed = apply_filters( 'enlightenment_aria_atts_allowed', true );
	if( is_string( $atts ) ) {
		$atts = trim( $atts );
		
		$html = sprintf( '<span %s></span>', $atts );
		$atts = array();
		
		$dom = new DOMDocument();
		$dom->loadHTML( $html );
		
		$span = $dom->getElementsByTagName( 'span' )->item( 0 );
		if( $span->hasAttributes() ) {
			foreach( $span->attributes as $attr ) {
				$atts[$attr->nodeName] = $attr->nodeValue;
			}
		}
		
	} elseif( ! is_array( $atts ) ) {
		_doing_it_wrong( __FUNCTION__, __ ( 'First parameter must be string or associative array.', 'enlightenment' ), '' );
		return;
	}
	$output = '';
	foreach( $atts as $attr => $value )
		if( in_array( $attr, $safe_atts ) || ( enlightenment_attr_is_type( $attr, 'data' ) && $data_atts_allowed ) || ( enlightenment_attr_is_type( $attr, 'aria' ) && $aria_atts_allowed ) )
			$output .= ' ' . esc_attr( $attr ) . ( '' !== $value ? '="' . esc_attr( $value ) . '"' : '' );
	$output = apply_filters( 'enlightenment_extra_atts', $output );
	if( ! $echo )
		return $output;
	echo $output;
}

function enlightenment_extra_attr( $attr, $echo = false ) {
	return enlightenment_extra_atts( $attr, $echo );
}

function enlightenment_open_tag( $container = 'div', $class = '', $id = '', $extra = '' ) {
	$container = esc_attr( $container );
	$class = enlightenment_class( $class );
	$id = enlightenment_id( $id );
	$extra = enlightenment_extra_atts( $extra );
	$output = '';
	if( '' != $container ) {
		$format = apply_filters( 'enlightenment_open_tag_format', '<%1$s%2$s%3$s%4$s>' . "\n", $container, $class, $id, $extra );
		$output = sprintf( $format, $container, $class, $id, $extra );
	}
	return apply_filters( 'enlightenment_open_tag', $output, $container, $id, $class, $extra );
}

function enlightenment_close_tag( $container = 'div' ) {
	$output = '';
	
	if( ! empty( $container ) ) {
		$output = sprintf( "</%s>\n", $container );
	}
	
	return apply_filters( 'enlightenment_close_tag', $output, $container );
}

add_action( 'after_setup_theme', 'enlightenment_load_framework_text_domain', 5 );

function enlightenment_load_framework_text_domain() {
	load_theme_textdomain( 'enlightenment', enlightenment_languages_directory() );
}

add_action( 'after_setup_theme', 'enlightenment_setup_theme_minimals', 5 );

function enlightenment_setup_theme_minimals() {
	add_theme_support( 'title-tag' );
	add_theme_support( 'automatic-feed-links' );
	add_theme_support( 'html5', array( 'comment-list', 'comment-form', 'search-form', 'gallery', 'caption' ) );
	register_nav_menu( 'primary', __( 'Primary Menu', 'enlightenment' ) );
}

function enlightenment_register_core_styles() {

	wp_register_style( 'bootstrap', enlightenment_styles_directory_uri() . '/bootstrap.css', false, null );
	wp_register_style( 'bootstrap-min', enlightenment_styles_directory_uri() . '/bootstrap.min.css', false, null );
	wp_register_style( 'colorbox', enlightenment_styles_directory_uri() . '/colorbox.css', false, null );
	wp_register_style( 'fluidbox', enlightenment_styles_directory_uri() . '/fluidbox.css', false, null );
	wp_register_style( 'imagelightbox', enlightenment_styles_directory_uri() . '/imagelightbox.css', false, null );
	wp_register_style( 'flexslider', enlightenment_styles_directory_uri() . '/flexslider.css', false, null );
	$theme_stylesheet_deps = apply_filters( 'enlightenment_theme_stylesheet_deps', array() );
	if( get_stylesheet_directory() != get_template_directory() ) {
		wp_register_style( 'enlightenment-parent-stylesheet', get_template_directory_uri() . '/style.css', apply_filters( 'enlightenment_parent_stylesheet_deps', $theme_stylesheet_deps ), null );
		$theme_stylesheet_deps = apply_filters( 'enlightenment_child_stylesheet_deps', $theme_stylesheet_deps );
	}
	wp_register_style( 'enlightenment-theme-stylesheet', get_stylesheet_uri(), $theme_stylesheet_deps, null );
}

add_filter( 'enlightenment_child_stylesheet_deps', 'enlightenment_child_stylesheet_parent_dependent' );

function enlightenment_child_stylesheet_parent_dependent( $deps ) {
	$deps[] = 'enlightenment-parent-stylesheet';
	return $deps;
}

function enlightenment_enqueue_core_styles() {
	wp_enqueue_style( 'enlightenment-theme-stylesheet' );
	$custom_css = apply_filters( 'enlightenment_theme_custom_css', '' );
	if( ! empty( $custom_css ) )
		wp_add_inline_style( 'enlightenment-theme-stylesheet', $custom_css );
}

function enlightenment_register_core_scripts() {
	wp_register_script( 'bootstrap', enlightenment_scripts_directory_uri() . '/bootstrap.js', array( 'jquery' ), null, true );
	wp_register_script( 'bootstrap-min', enlightenment_scripts_directory_uri() . '/bootstrap.min.js', array( 'jquery' ), null, true );
	wp_register_script( 'colorbox', enlightenment_scripts_directory_uri() . '/jquery.colorbox.js', array( 'jquery' ), null, true );
	wp_register_script( 'colorbox-min', enlightenment_scripts_directory_uri() . '/jquery.colorbox-min.js', array( 'jquery' ), null, true );
	wp_register_script( 'fluidbox', enlightenment_scripts_directory_uri() . '/jquery.fluidbox.min.js', array( 'jquery' ), null, true );
	wp_register_script( 'imagelightbox', enlightenment_scripts_directory_uri() . '/imagelightbox.min.js', array( 'jquery' ), null, true );
	wp_register_script( 'fitvids', enlightenment_scripts_directory_uri() . '/jquery.fitvids.js', array( 'jquery' ), null, true );
	wp_register_script( 'flexslider', enlightenment_scripts_directory_uri() . '/jquery.flexslider.js', array( 'jquery' ), null, true );
	wp_register_script( 'flexslider-min', enlightenment_scripts_directory_uri() . '/jquery.flexslider-min.js', array( 'jquery' ), null, true );
	wp_register_script( 'ajax-navigation', enlightenment_scripts_directory_uri() . '/ajax-navigation.js', array( 'jquery' ), null, true );
	wp_register_script( 'infinitescroll', enlightenment_scripts_directory_uri() . '/jquery.infinitescroll.js', array( 'jquery' ), null, true );
	wp_register_script( 'enlightenment-call-js', enlightenment_scripts_directory_uri() . '/call.js', apply_filters( 'enlightenment_call_js', array() ), null, true );
	wp_localize_script( 'enlightenment-call-js', 'enlightenment_call_js', array(
		'ajaxurl' => admin_url( 'admin-ajax.php' ),
		'includes_url' => includes_url(),
	) );
}

function enlightenment_call_js_add_mediaelement( $deps ) {
	wp_enqueue_style( 'wp-mediaelement' );
	$deps[] = 'wp-mediaelement';
	return $deps;
}

function enlightenment_enqueue_core_scripts() {
	if ( is_singular() && get_option( 'thread_comments' ) && comments_open() )
		wp_enqueue_script( 'comment-reply' );
	$deps = apply_filters( 'enlightenment_call_js', array() );
	if( ! empty( $deps ) )
		wp_enqueue_script( 'enlightenment-call-js' );
}

function enlightenment_meta_charset( $args = null ) {
	$defaults = array(
		'echo' => true,
	);
	$defaults = apply_filters( 'enlightenment_meta_charset_args', $defaults );
	$args = wp_parse_args( $args, $defaults );
	$output = sprintf( "<meta charset='%s' />\n", get_bloginfo('charset') );
	$output = apply_filters( 'enlightenment_meta_charset', $output, $args );
	if( ! $args['echo'] )
		return $output;
	echo $output;
}

function enlightenment_meta_viewport( $args = null ) {
	$defaults = array(
		'width' => 'device-width',
		'height' => '',
		'initial_scale' => '1.0',
		'minimum_scale' => '',
		'maximum_scale' => '',
		'user_scalable' => '',
		'echo' => true,
	);
	$defaults = apply_filters( 'enlightenment_meta_viewport_args', $defaults );
	$args = wp_parse_args( $args, $defaults );
	$content = array();
	if( '' != $args['width'] )
		$content['width'] = $args['width'];
	if( '' != $args['height'] )
		$content['height'] = $args['height'];
	if( '' != $args['initial_scale'] )
		$content['initial-scale'] = $args['initial_scale'];
	if( '' != $args['minimum_scale'] )
		$content['minimum-scale'] = $args['minimum_scale'];
	if( '' != $args['maximum_scale'] )
		$content['maximum-scale'] = $args['maximum_scale'];
	if( '' != $args['user_scalable'] )
		$content['user-scalable'] = $args['user_scalable'];
	$content = apply_filters( 'enlightenment_meta_viewport_content', $content );
	$str = '';
	foreach( $content as $key => $value ){
		$str .= $key . '=' . $value;
		$values = array_values( $content );
		if( $value != end( $values ) )
			$str .= ', ';
	}
	$content = $str;
	$output = '';
	if( ! empty( $content ) ) {
		$output = sprintf( "<meta name='viewport' content='%s' />\n", esc_attr( $content ) );
	}
	$output = apply_filters( 'enlightenment_meta_viewport', $output, $args );
	if( ! $args['echo'] )
		return $output;
	echo $output;
}

function enlightenment_ie_compat( $args = null ) {
	$defaults = array(
		'docmode' => 'IE=edge,chrome=1',
		'echo'    => true,
	);
	$defaults = apply_filters( 'enlightenment_ie_compat_args', $defaults );
	$args = wp_parse_args( $args, $defaults );
	$output = '';
	if( '' != $args['docmode'] ) {
		$output .= sprintf( "<meta http-equiv='X-UA-Compatible' content='%s' />\n", esc_attr( $args['docmode'] ) );
	}
	$output = apply_filters( 'enlightenment_ie_compat', $output, $args );
	if( ! $args['echo'] )
		return $output;
	echo $output;
}

function enlightenment_ie_shim( $args = null ) {
	$defaults = array(
		'conditional' => 'lt IE 9',
		'html5shiv'   => true,
		'respond.js'  => true,
		'echo'        => true,
	);
	$defaults = apply_filters( 'enlightenment_ie_shim_args', $defaults );
	$args = wp_parse_args( $args, $defaults );
	$output = '';
	if( $args['html5shiv'] || $args['respond.js'] ) {
		$output .= sprintf( "<!--[if %s]>\n", esc_attr( $args['conditional'] ) );
		if( $args['html5shiv'] )
			$output .= sprintf( "<script src='%s'></script>\n", esc_url( enlightenment_scripts_directory_uri() . '/html5shiv.min.js' ) );
		if( $args['respond.js'] )
			$output .= sprintf( "<script src='%s'></script>\n", esc_url( enlightenment_scripts_directory_uri() . '/respond.min.js' ) );
		$output .= "<![endif]-->\n";
	}
	$output = apply_filters( 'enlightenment_ie_shim', $output, $args );
	if( ! $args['echo'] )
		return $output;
	echo $output;
}

add_filter( 'wp_title', 'enlightenment_wp_title', 10, 3 );

function enlightenment_wp_title( $title, $sep, $seplocation ) {
	// Function obsolete for WP 4.1 and above
	if( function_exists( '_wp_render_title_tag' ) ) {
		// Do nothing and return default value
		return $title;
	}
	
	global $page, $paged;
	if ( is_feed() ) {
		return $title;
	}

	// Add the site name.
	$title .= get_bloginfo( 'name' );

	// Add the site description for the home/front page.
	$site_description = get_bloginfo( 'description', 'display' );
	if ( $site_description && ( is_home() || is_front_page() ) ) {
		$title = "$title $sep $site_description";
	}

	// Add a page number if necessary.
	if ( $paged >= 2 || $page >= 2 ) {
		$title = "$title $sep " . sprintf( __( 'Page %s', 'enlightenment' ), max( $paged, $page ) );
	}

	return $title;
}

function enlightenment_profile_link( $args = null ) {
	$defaults = array(
		'link' => 'http://gmpg.org/xfn/11',
		'echo' => true,
	);
	$defaults = apply_filters( 'enlightenment_profile_link_args', $defaults );
	$args = wp_parse_args( $args, $defaults );
	$output = sprintf( "<link rel='profile' href='%s' />\n", esc_url( $args['link'] ) );
	$output = apply_filters( 'enlightenment_profile_link', $output, $args );
	if( ! $args['echo'] )
		return $output;
	echo $output;
}

function enlightenment_pingback_link( $args = null ) {
	$defaults = array(
		'echo' => true,
		'link' => get_bloginfo('pingback_url'),
	);
	$defaults = apply_filters( 'enlightenment_pingback_link_args', $defaults );
	$args = wp_parse_args( $args, $defaults );
	$output = sprintf( "<link rel='pingback' href='%s' />\n", esc_url( $args['link'] ) );
	$output = apply_filters( 'enlightenment_pingback_link', $output, $args );
	if( ! $args['echo'] )
		return $output;
	echo $output;
}

function enlightenment_clearfix( $args = null ) {
	$defaults = array(
		'container' => 'div',
		'container_class' => 'clearfix',
		'echo' => true,
	);
	$defaults = apply_filters( 'enlightenment_clearfix_args', $defaults );
	$args = wp_parse_args( $args, $defaults );
	$output = str_replace( "\n", '', enlightenment_open_tag( $args['container'], $args['container_class'] ) );
	$output .= enlightenment_close_tag( $args['container'] );
	$output = apply_filters( 'enlightenment_clearfix', $output, $args );
	if( ! $args['echo'] )
		return $output;
	echo $output;
}

function enlightenment_body_extra_atts( $args = null ) {
	$defaults = array(
		'atts' => '',
		'echo' => true,
	);
	$defaults = apply_filters( 'enlightenment_body_extra_atts_args', $defaults );
	$args = wp_parse_args( $args, $defaults );
	return enlightenment_extra_atts( $args['atts'], $args['echo'] );
}

function enlightenment_header_class( $args = null ) {
	$defaults = array(
		'class' => 'site-header',
		'echo' => true,
	);
	$defaults = apply_filters( 'enlightenment_header_class_args', $defaults );
	$args = wp_parse_args( $args, $defaults );
	return enlightenment_class( $args['class'], $args['echo'] );
}

function enlightenment_header_extra_atts( $args = null ) {
	$defaults = array(
		'atts' => array( 'role' => 'banner' ),
		'echo' => true,
	);
	$defaults = apply_filters( 'enlightenment_header_extra_atts', $defaults );
	$args = wp_parse_args( $args, $defaults );
	return enlightenment_extra_atts( $args['atts'], $args['echo'] );
}

function enlightenment_site_branding( $args = null ) {
	$defaults = array(
		'site_title' => true,
		'site_description' => true,
		'home_link' => true,
		'container' => 'div',
		'container_class' => 'branding',
		'container_extra_atts' => '',
		'before' => enlightenment_navicon( array( 'echo' => false ) ),
		'after' => '',
		'site_title_tag' => 'h1',
		'site_title_class' => 'site-title',
		'site_title_id' => 'site-title',
		'site_title_extra_atts' => '',
		'home_link_class' => '',
		'home_link_id' => '',
		'home_link_extra_atts' => array( 'href' => home_url( '/' ), 'rel' => 'home' ),
		'site_description_tag' => 'h2',
		'site_description_class' => 'site-description',
		'site_description_id' => 'site-description',
		'site_description_extra_atts' => '',
		'echo' => true,
	);
	$defaults = apply_filters( 'enlightenment_site_branding_args', $defaults );
	$args = wp_parse_args( $args, $defaults );
	$site_title = apply_filters( 'enlightenment_site_title', get_bloginfo( 'name' ) );
	$site_description = apply_filters( 'enlightenment_site_description', get_bloginfo( 'description' ) );
	$output = enlightenment_open_tag( $args['container'], $args['container_class'], '', $args['container_extra_atts'] );
	$output .= $args['before'];
	if( $args['site_title'] ) {
		$output .= enlightenment_open_tag( $args['site_title_tag'],  $args['site_title_class'], $args['site_title_id'], $args['site_title_extra_atts'] );
		if( $args['home_link'] ) {
			$output .= enlightenment_open_tag( 'a',  $args['home_link_class'], $args['home_link_id'], $args['home_link_extra_atts'] );
			$output .= $site_title;
			$output .= enlightenment_close_tag( 'a' );
		} else {
			$output .= $site_title;
		}
		$output .= enlightenment_close_tag( $args['site_title_tag'] );
	}
	if( $args['site_description'] ) {
		$output .= enlightenment_open_tag( $args['site_description_tag'], $args['site_description_class'], $args['site_description_id'], $args['site_description_extra_atts'] );
		$output .= $site_description . "\n";
		$output .= enlightenment_close_tag( $args['site_description_tag'] );
	}
	$output .= $args['after'];
	$output .= enlightenment_close_tag( $args['container'] );
	$output = apply_filters( 'enlightenment_site_branding', $output, $args );
	if( ! $args['echo'] )
		return $output;
	echo $output;
}

function enlightenment_search_form( $args = null ) {
	$defaults = array(
		'container_class' => 'form-search',
		'container_id' => 'searchform',
		'before' => '',
		'after' => '',
		'input_class' => 'search-query',
		'input_id' => 's',
		'placeholder' => __( 'Search this website', 'enlightenment' ),
		'submit_class' => '',
		'submit_id' => 'searchsubmit',
		'submit_extra_atts' => ' type="submit"',
		'submit' => __( 'Search', 'enlightenment' ),
		'before_submit' => '',
		'after_submit' => '',
		'echo' => true,
	);
	$defaults = apply_filters( 'enlightenment_search_form_args', $defaults );
	$args = wp_parse_args( $args, $defaults );
	$output = enlightenment_open_tag(
		'form',
		$args['container_class'],
		$args['container_id'],
		array(
			'action' => home_url( '/' ),
			'method' => 'get',
			'role' => 'search'
		)
	);
	$output .= $args['before'];
	$output .= '<input name="s"' . enlightenment_class( $args['input_class'] ) . enlightenment_id( $args['input_id'] ) . ' type="text" value="' . get_search_query() . '"' . ( ! empty( $args['placeholder'] ) ? ' placeholder="' . esc_attr( $args['placeholder'] ) . '"' : '' ) . ' />';
	$output .= $args['before_submit'];
	$output .= enlightenment_open_tag( 'button', $args['submit_class'], $args['submit_id'] , $args['submit_extra_atts'] );
	$output .= strip_tags( $args['submit'], '<span><i>' );
	$output .= enlightenment_close_tag( 'button' );
	$output .= $args['after_submit'];
	$output .= $args['after'];
	$output .= enlightenment_close_tag( 'form' );
	$output = apply_filters( 'enlightenment_search_form', $output, $args );
	if( ! $args['echo'] )
		return $output;
	echo $output;
}

function enlightenment_content_class( $args = null ) {
	$defaults = array(
		'class' => 'content-area hfeed',
		'echo' => true,
	);
	$defaults = apply_filters( 'enlightenment_content_class_args', $defaults );
	$args = wp_parse_args( $args, $defaults );
	return enlightenment_class( $args['class'], $args['echo'] );
}

function enlightenment_content_extra_atts( $args = null ) {
	$defaults = array(
		'atts' => ' role="main"',
		'echo' => true,
	);
	$defaults = apply_filters( 'enlightenment_content_extra_atts_args', $defaults );
	$args = wp_parse_args( $args, $defaults );
	return enlightenment_extra_atts( $args['atts'], $args['echo'] );
}

function enlightenment_register_sidebars_args( $args = null ) {
	$defaults = array(
		'before_widget' => '<aside id="%1$s" class="widget %2$s">' . "\n",
		'after_widget' => '</aside>' . "\n",
		'before_title' => '<h3 class="widget-title">',
		'after_title' => '</h3>' . "\n",
	);
	$defaults = apply_filters( 'enlightenment_register_sidebars_args', $defaults );
	$args = wp_parse_args( $args, $defaults );
	return $args;
}

add_action( 'widgets_init', 'enlightenment_widgets_init_minimals', 5 );

function enlightenment_widgets_init_minimals() {
	register_sidebar( wp_parse_args( enlightenment_register_sidebars_args(), array(
		'name' => 'Sidebar',
		'id' => 'sidebar-1',
		'description' => __( 'The Primary Sidebar', 'enlightenment' ),
	) ) );
}

function enlightenment_sidebar_class( $args = null ) {
	$defaults = array(
		'class' => 'widget-area sidebar sidebar-' . enlightenment_current_sidebar_name(),
		'echo' => true,
	);
	$defaults = apply_filters( 'enlightenment_sidebar_class_args', $defaults );
	$args = wp_parse_args( $args, $defaults );
	return enlightenment_class( $args['class'], $args['echo'] );
}

function enlightenment_sidebar_extra_atts( $args = null ) {
	$defaults = array(
		'atts' => ' role="complementary"',
		'echo' => true,
	);
	$defaults = apply_filters( 'enlightenment_sidebar_extra_atts_args', $defaults );
	$args = wp_parse_args( $args, $defaults );
	return enlightenment_extra_attr( $args['atts'], $args['echo'] );
}

function enlightenment_current_sidebar_name() {
	$files = array_reverse( get_included_files() );
	foreach( $files as $file ) {
		if( false !== strpos( $file, 'sidebar') ) {
			$sidebar = basename( $file );
			break;
		}
	}
	
	if( 'sidebar.php' == $sidebar )
		return 'primary';
	$sidebar = str_replace( 'sidebar-', '', $sidebar );
	$sidebar = str_replace( '.php', '', $sidebar );
	return $sidebar;
}

function enlightenment_footer_class( $args = null ) {
	$defaults = array(
		'class' => 'site-footer',
		'echo' => true,
	);
	$defaults = apply_filters( 'enlightenment_footer_class_args', $defaults );
	$args = wp_parse_args( $args, $defaults );
	return enlightenment_class( $args['class'], $args['echo'] );
}

function enlightenment_footer_extra_atts( $args = null ) {
	$defaults = array(
		'atts' => ' role="contentinfo"',
		'echo' => true,
	);
	$defaults = apply_filters( 'enlightenment_footer_extra_atts_args', $defaults );
	$args = wp_parse_args( $args, $defaults );
	return enlightenment_extra_atts( $args['atts'], $args['echo'] );
}

function enlightenment_copyright_notice( $args = null ) {
	$defaults = array(
		'container' => 'div',
		'container_class' => 'copyright',
		'wrap' => 'p',
		'format' => '&copy; %1$s %2$s',
		'echo' => true,
	);
	$defaults = apply_filters( 'enlightenment_copyright_notice_args', $defaults );
	$args = wp_parse_args( $args, $defaults );
	$output = enlightenment_open_tag( $args['container'], $args['container_class'] );
	$output .= enlightenment_open_tag( $args['wrap'] );
	$text = sprintf( $args['format'], date( 'Y' ), get_bloginfo( 'name' ) );
	$output .= strip_tags( $text, '<a><abbr>' );
	$output .= enlightenment_close_tag( $args['wrap'] );
	$output .= enlightenment_close_tag( $args['container'] );
	$output = apply_filters( 'enlightenment_copyright_notice', $output, $args );
	if( ! $args['echo'] )
		return $output;
	echo $output;
}

function enlightenment_credit_links( $args = null ) {
	$defaults = array(
		'container' => 'div',
		'container_class' => 'credits',
		'wrap' => 'p',
		'text' => sprintf( __( 'Built with <a href="%1$s" rel="designer">Enlightenment Framework</a> and <a href="%2$s" rel="generator">WordPress</a>', 'enlightenment' ), esc_url( 'http://enlightenmentcore.com/'), esc_url( 'http://wordpress.org/') ) . "\n",
		'echo' => true,
	);
	$defaults = apply_filters( 'enlightenment_credit_links_args', $defaults );
	$args = wp_parse_args( $args, $defaults );
	$output = enlightenment_open_tag( $args['container'], $args['container_class'] );
	$output .= enlightenment_open_tag( $args['wrap'] );
	$output .= strip_tags( $args['text'], '<a><abbr>' );
	$output .= enlightenment_close_tag( $args['wrap'] );
	$output .= enlightenment_close_tag( $args['container'] );
	$output = apply_filters( 'enlightenment_credit_links', $output, $args );
	if( ! $args['echo'] )
		return $output;
	echo $output;
}




