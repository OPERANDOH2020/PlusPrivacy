<?php

function enlightenment_sidebar_locations() {
	$sidebars = apply_filters( 'enlightenment_sidebar_locations', array(
		'primary' => array(
			'name' => __( 'Primary Sidebar', 'enlightenment' ),
			'contained' => true,
			'sidebar' => 'sidebar-1',
		),
	) );
	$locations = array();
	foreach( enlightenment_unlimited_sidebars_templates() as $template => $name ) {
		$locations[$template] = $sidebars;
	}
	return apply_filters( 'enlightenment_sidebar_locations_options', $locations );
}

function enlightenment_unlimited_sidebars_templates() {
	$templates = array(
		'error404' => __( '404', 'enlightenment' ),
		'search' => __( 'Search', 'enlightenment' ),
		'blog' => __( 'Blog', 'enlightenment' ),
		'post' => __( 'Post', 'enlightenment' ),
		'page' => __( 'Page', 'enlightenment' ),
		'author' => __( 'Author', 'enlightenment' ),
		'date' => __( 'Date', 'enlightenment' ),
	);
	$post_types = get_post_types( array( 'has_archive' => true ), 'objects' );
	foreach( $post_types as $name => $post_type )
		$templates[$name . '-archive'] = sprintf( __( '%1$s Archive', 'enlightenment' ), $post_type->labels->name );
	$post_types = get_post_types( array( 'publicly_queryable' => true ), 'objects' );
	foreach( $post_types as $name => $post_type )
		$templates[$name] = $post_type->labels->singular_name;
	$taxonomies = get_taxonomies( array( 'public' => true ), 'objects' );
	foreach( $taxonomies as $name => $taxonomy ) {
		if( 'Format' == $taxonomy->labels->singular_name )
			$taxonomy->labels->singular_name = __( 'Post Format', 'enlightenment' );
		$templates[$name] = $taxonomy->labels->singular_name;
	}
	return apply_filters( 'enlightenment_unlimited_sidebars_templates', $templates );
}

add_filter( 'enlightenment_sidebar_locations_options', 'enlightenment_sidebar_locations_options' );

function enlightenment_sidebar_locations_options( $locations ) {
	if( is_singular() ) {
		global $post;
		$post_id = isset( $post ) ? $post->ID : $_GET['post'];
		$post_type = get_post_type( $post_id );
		$sidebars = array();
		$sidebars[$post_type] = get_post_meta( $post_id, '_enlightenment_sidebar_locations', true );
		if( '' == $sidebars[$post_type] )
			$sidebars = enlightenment_theme_option( 'sidebar_locations' );
	} else {
		$sidebars = enlightenment_theme_option( 'sidebar_locations' );
	}
	foreach( $locations as $template => $locs )
		foreach( $locs as $location => $atts )
			if( isset( $sidebars[$template][$location] ) )
				$locations[$template][$location]['sidebar'] = $sidebars[$template][$location];
	return $locations;
}

add_action( 'widgets_init', 'enlightenment_register_dynamic_sidebars', 30 );

function enlightenment_register_dynamic_sidebars() {
	$sidebars = (array) enlightenment_theme_option( 'sidebars' );
	foreach ( $sidebars as $sidebar => $atts ) {
		$before = '';
		$after = '';
		if( current_theme_supports( 'enlightenment-grid-loop' ) && isset( $atts['grid'] ) ) {
			$grid = enlightenment_get_grid( $atts['grid'] );
			$before = enlightenment_open_tag( 'div', $grid['entry_class'] );
			$after = enlightenment_close_tag( 'div' );
		}
		register_sidebar( array(
			'name' => $atts['name'],
			'id' => $sidebar,
			'before_widget' => $before . '<aside id="%1$s" class="widget %2$s">' . "\n",
			'after_widget' => '</aside>' . $after . "\n",
			'before_title' => '<h3 class="widget-title">',
			'after_title' => '</h3>' . "\n",
		) );
	}
}

function enlightenment_registered_sidebars_default_atts() {
	$defaults = array(
		'description' => '',
		'display_title' => false,
		'display_description' => false,
		'background' => array(
			'color' => array(
				'hex' => '#fff',
				'alpha' => 100,
				'transparent' => true,
			),
			'image' => false,
			'position' => 'center-top',
			'repeat' => 'no-repeat',
			'size' => 'cover',
			'scroll' => 'scroll',
		),
		'sidebar_title_color' => '#333333',
		'sidebar_text_color' => '#333333',
		'widgets_background_color' => array(
			'hex' => '#fff',
			'transparent' => true,
		),
		'widgets_title_color' => '#333333',
		'widgets_text_color' => '#555555',
		'widgets_link_color' => '#336699',
	);
	
	if( current_theme_supports( 'enlightenment-grid-loop' ) ) {
		$defaults['grid'] = 'onecol';
	}
	
	if( current_theme_supports( 'enlightenment-bootstrap' ) ) {
		$defaults['contain_widgets'] = true;
	}
	
	return apply_filters( 'enlightenment_registered_sidebars_default_atts', $defaults );
}

function enlightenment_registered_sidebars() {
	global $wp_registered_sidebars;
	$defaults = enlightenment_registered_sidebars_default_atts();
	
	$sidebars = array();
	foreach( $wp_registered_sidebars as $sidebar => $atts ) {
		$sidebars[$sidebar] = array(
			'name' => $atts['name'],
			'id' => $atts['id'],
			'description' => $atts['description'],
			'display_title' => false,
			'display_description' => false,
		);
		
		$sidebars[$sidebar] = array_merge( $sidebars[$sidebar], $defaults );
	}
	
	return apply_filters( 'enlightenment_registered_sidebars', $sidebars );
}

add_filter( 'enlightenment_registered_sidebars', 'enlightenment_registered_sidebars_merge_theme_options' );

function enlightenment_registered_sidebars_merge_theme_options( $sidebars ) {
	$options = (array) enlightenment_theme_option( 'sidebars' );
	$defaults = enlightenment_registered_sidebars_default_atts();
	
	foreach( $options as $sidebar => $atts ) {
		$options[$sidebar] = array_merge( $defaults, $atts );
	}
	
	$sidebars = array_merge( $sidebars, $options );
	
	return $sidebars;
}

function enlightenment_current_sidebars_template() {
	$template = '';
	if( is_404() )
		$template = 'error404';
	elseif( is_search() )
		$template = 'search';
	elseif( is_home() )
		$template = 'blog';
	elseif( is_page() )
		$template = 'page';
	elseif( is_author() )
		$template = 'author';
	elseif( is_date() )
		$template = 'date';
	elseif( is_category() )
		$template = 'category';
	elseif( is_tag() )
		$template = 'post_tag';
	elseif( is_post_type_archive() )
		$template = get_queried_object()->name . '-archive';
	elseif( is_singular() )
		$template = get_post_type();
	elseif( is_tax() )
		$template = get_queried_object()->taxonomy;
	
	return $template;
}

function enlightenment_dynamic_sidebar() {
	if( is_admin() )
		return;
	$locations = enlightenment_sidebar_locations();
	$sidebar = enlightenment_current_sidebar_name();
	$template = enlightenment_current_sidebars_template();
	
	$dynamic_sidebar = '';
	
	if( isset( $locations[$template][$sidebar] ) )
		$dynamic_sidebar = $locations[$template][$sidebar]['sidebar'];
	return apply_filters( 'enlightenment_dynamic_sidebar', $dynamic_sidebar );
}

add_filter( 'enlightenment_sidebar_class_args', 'enlightenment_unlimited_sidebars_sidebar_class_args' );

function enlightenment_unlimited_sidebars_sidebar_class_args( $args ) {
	$sidebar = enlightenment_dynamic_sidebar();
	if( isset( $sidebar ) ) {
		$args['class'] .= ' custom-sidebar custom-' . $sidebar;
	}
	
	return $args;
}

add_filter( 'enlightenment_theme_custom_css', 'enlightenment_unlimited_sidebars_print_css' );

function enlightenment_unlimited_sidebars_print_css( $output ) {
	$sidebars = enlightenment_registered_sidebars();
	
	foreach( $sidebars as $sidebar => $atts ) {
		$selector = '.custom-' . $sidebar;
		
		$bg_selector = $selector;
		if( 'parallax' == $sidebars[$sidebar]['background']['scroll'] ) {
			$bg_selector .= ' > .background-parallax';
		}
		$output .= enlightenment_print_background_options( $bg_selector, $sidebar, false );
		
		$widget_headings_selector = $selector . ' .widget-title, ' . $selector . ' .widget h1, ' . $selector . ' .widget h2, ' . $selector . ' .widget h3, ' . $selector . ' .widget h4, ' . $selector . ' .widget h5, ' . $selector . ' .widget h6';
		
		$output .= enlightenment_print_color_option( $selector . ' .sidebar-title', $sidebar, false );
		$output .= enlightenment_print_color_option( $selector . ' .sidebar-description', $sidebar, false );
		$output .= enlightenment_print_color_option( $widget_headings_selector, $sidebar, false );
		$output .= enlightenment_print_color_option( $selector . ' .widget', $sidebar, false );
		
		$output .= enlightenment_print_background_color_option( $selector . ' .widget', $sidebar, false );
	}
	
	return $output;
}

add_filter( 'enlightenment_print_background_settings', 'enlightenment_unlimited_sidebars_print_background_settings', 10, 3 );

function enlightenment_unlimited_sidebars_print_background_settings( $settings, $selector, $option ) {
	$sidebars = enlightenment_registered_sidebars();
	if( array_key_exists( $option, $sidebars ) ) {
		$settings = $sidebars[ $option ]['background'];
	}
	
	return $settings;
}

add_filter( 'enlightenment_print_background_settings_defaults', 'enlightenment_unlimited_sidebars_print_background_settings_defaults', 10, 3 );

function enlightenment_unlimited_sidebars_print_background_settings_defaults( $defaults, $selector, $option ) {
	$default_options = enlightenment_default_theme_options();
	$default_sidebars = isset( $default_options['sidebars'] ) ? $default_options['sidebars'] : array();
	if( array_key_exists( $option, $default_sidebars ) ) {
		$defaults = $default_sidebars[ $option ]['background'];
	} else {
		$defaults = enlightenment_registered_sidebars_default_atts();
		$defaults = $defaults['background'];
	}
	
	return $defaults;
}

add_filter( 'enlightenment_print_color_option_settings', 'enlightenment_unlimited_sidebars_print_color_option_settings', 10, 3 );

function enlightenment_unlimited_sidebars_print_color_option_settings( $color, $selector, $option ) {
	$sidebars = enlightenment_registered_sidebars();
	if( array_key_exists( $option, $sidebars ) ) {
		if( strpos( $selector, '.sidebar-title' ) ) {
			$color = $sidebars[ $option ]['sidebar_title_color'];
		} elseif( strpos( $selector, '.sidebar-description' ) ) {
			$color = $sidebars[ $option ]['sidebar_text_color'];
		} elseif( strpos( $selector, '.widget-title' ) ) {
			$color = $sidebars[ $option ]['widgets_title_color'];
		} elseif( strpos( $selector, '.widget a' ) ) {
			$color = $sidebars[ $option ]['widgets_link_color'];
		} elseif( strpos( $selector, '.widget' ) ) {
			$color = $sidebars[ $option ]['widgets_text_color'];
		}
	}
	
	return $color;
}

add_filter( 'enlightenment_print_color_option_settings_defaults', 'enlightenment_unlimited_sidebars_print_color_option_settings_defaults', 10, 3 );

function enlightenment_unlimited_sidebars_print_color_option_settings_defaults( $color, $selector, $option ) {
	$default_options = enlightenment_default_theme_options();
	$default_sidebars = isset( $default_options['sidebars'] ) ? $default_options['sidebars'] : array();
	if( array_key_exists( $option, $default_sidebars ) ) {
		if( strpos( $selector, '.sidebar-title' ) ) {
			$color = $default_sidebars[ $option ]['sidebar_title_color'];
		} elseif( strpos( $selector, '.sidebar-description' ) ) {
			$color = $default_sidebars[ $option ]['sidebar_text_color'];
		} elseif( strpos( $selector, '.widget-title' ) ) {
			$color = $default_sidebars[ $option ]['widgets_title_color'];
		} elseif( strpos( $selector, '.widget a' ) ) {
			$color = $default_sidebars[ $option ]['widgets_link_color'];
		} elseif( strpos( $selector, '.widget' ) ) {
			$color = $default_sidebars[ $option ]['widgets_text_color'];
		}
	} else {
		$defaults = enlightenment_registered_sidebars_default_atts();
		if( strpos( $selector, '.sidebar-title' ) ) {
			$color = $defaults['sidebar_title_color'];
		} elseif( strpos( $selector, '.sidebar-description' ) ) {
			$color = $defaults['sidebar_text_color'];
		} elseif( strpos( $selector, '.widget-title' ) ) {
			$color = $defaults['widgets_title_color'];
		} elseif( strpos( $selector, '.widget a' ) ) {
			$color = $defaults['widgets_link_color'];
		} elseif( strpos( $selector, '.widget' ) ) {
			$color = $defaults['widgets_text_color'];
		}
	}
	
	return $color;
}

add_filter( 'enlightenment_print_background_color_option_settings', 'enlightenment_unlimited_sidebars_print_background_color_option_settings', 10, 3 );

function enlightenment_unlimited_sidebars_print_background_color_option_settings( $color, $selector, $option ) {
	$sidebars = enlightenment_registered_sidebars();
	if( array_key_exists( $option, $sidebars ) ) {
		$color = $sidebars[ $option ]['widgets_background_color'];
	}
	
	return $color;
}

add_filter( 'enlightenment_print_background_color_option_settings_defaults', 'enlightenment_unlimited_sidebars_print_background_color_option_settings_defaults', 10, 3 );

function enlightenment_unlimited_sidebars_print_background_color_option_settings_defaults( $color, $selector, $option ) {
	$default_options = enlightenment_default_theme_options();
	$default_sidebars = isset( $default_options['sidebars'] ) ? $default_options['sidebars'] : array();
	if( array_key_exists( $option, $default_sidebars ) ) {
		$color = $default_sidebars[ $option ]['widgets_background_color'];
	} else {
		$defaults = enlightenment_registered_sidebars_default_atts();
		$color = $defaults['widgets_background_color'];
	}
	
	return $color;
}

add_action( 'enlightenment_before_widgets', 'enlightenment_unlimited_sidebars_add_parallax_background', 1 );

function enlightenment_unlimited_sidebars_add_parallax_background() {
	$sidebars = enlightenment_registered_sidebars();
	$sidebar = enlightenment_dynamic_sidebar();
	
	if( 'parallax' == $sidebars[$sidebar]['background']['scroll'] && ! empty( $sidebars[$sidebar]['background']['image'] ) ) {
		echo enlightenment_open_tag( 'div', 'background-parallax' );
		echo enlightenment_close_tag();
	}
}

if( current_theme_supports( 'enlightenment-bootstrap' ) ) {
	add_action( 'enlightenment_before_widgets', 'enlightenment_unlimited_sidebars_open_widgets_container', 2 );
	
	function enlightenment_unlimited_sidebars_open_widgets_container() {
		$locations = enlightenment_sidebar_locations();
		$template = enlightenment_current_sidebars_template();
		$location = enlightenment_current_sidebar_name();
			
		if( true === $locations[$template][$location]['contained'] ) {
			return;
		}
		
		$sidebars = enlightenment_registered_sidebars();
		$sidebar = enlightenment_dynamic_sidebar();
		
		if( $sidebars[$sidebar]['contain_widgets'] ) {
			enlightenment_open_container();
		} else {
			enlightenment_open_container_fluid();
		}
	}
	
	add_action( 'enlightenment_after_widgets', 'enlightenment_unlimited_sidebars_close_widgets_container', 999 );
	
	function enlightenment_unlimited_sidebars_close_widgets_container() {
		$locations = enlightenment_sidebar_locations();
		$template = enlightenment_current_sidebars_template();
		$location = enlightenment_current_sidebar_name();
			
		if( true === $locations[$template][$location]['contained'] ) {
			return;
		}
		
		enlightenment_close_container();
	}
}

add_action( 'enlightenment_before_widgets', 'enlightenment_sidebar_heading', 9 );

function enlightenment_sidebar_heading( $args = null ) {
	$defaults = array(
		'container' => 'header',
		'container_class' => 'sidebar-heading',
		'container_id' => '',
		'container_extra_atts' => '',
		'sidebar_title_tag' => 'h2',
		'sidebar_title_class' => 'sidebar-title',
		'sidebar_title_id' => '',
		'sidebar_title_extra_atts' => '',
		'sidebar_description_tag' => 'div',
		'sidebar_description_class' => 'sidebar-description',
		'sidebar_description_id' => '',
		'sidebar_description_extra_atts' => '',
		'echo' => true,
	);
	$defaults = apply_filters( 'enlightenment_sidebar_header_args', $defaults );
	$args = wp_parse_args( $args, $defaults );
	
	$locations = enlightenment_sidebar_locations();
	$template = enlightenment_current_sidebars_template();
	$location = enlightenment_current_sidebar_name();
	
	$sidebars = enlightenment_registered_sidebars();
	$sidebar = $sidebars[$locations[$template][$location]['sidebar']];
	
	$sidebar_title = apply_filters( 'enlightenment_sidebar_title', $sidebar['name'] );
	$sidebar_description = apply_filters( 'enlightenment_sidebar_description', $sidebar['description'] );
	
	if( ! $sidebar['display_title'] && ! ( $sidebar['display_description'] ) ) {
		return;
	}
	
	$output = enlightenment_open_tag( $args['container'], $args['container_class'], $args['container_id'], $args['container_extra_atts'] );
	
	if( $sidebar['display_title'] ) {
		$output .= enlightenment_open_tag( $args['sidebar_title_tag'],  $args['sidebar_title_class'], $args['sidebar_title_id'], $args['sidebar_title_extra_atts'] );
		$output .= $sidebar_title;
		$output .= enlightenment_close_tag( $args['sidebar_title_tag'] );
	}
	
	if( $sidebar['display_description'] && ! empty( $sidebar_description ) ) {
		$output .= enlightenment_open_tag( $args['sidebar_description_tag'], $args['sidebar_description_class'], $args['sidebar_description_id'], $args['sidebar_description_extra_atts'] );
		$output .= $sidebar_description . "\n";
		$output .= enlightenment_close_tag( $args['sidebar_description_tag'] );
	}
	
	$output .= enlightenment_close_tag( $args['container'] );
	$output = apply_filters( 'enlightenment_sidebar_header', $output, $args );
	
	if( ! $args['echo'] ) {
		return $output;
	}
	
	echo $output;
}

add_filter( 'enlightenment_sidebar_title', 'esc_html', 1 );
add_filter( 'enlightenment_sidebar_description', 'esc_html', 1 );

add_filter( 'enlightenment_sidebar_description', 'wpautop' );

add_filter( 'is_active_sidebar', 'enlightenment_remove_primary_sidebar_in_full_width', 5, 2 );

function enlightenment_remove_primary_sidebar_in_full_width( $is_active_sidebar, $index ) {
	if( current_theme_supports( 'enlightenment-custom-layouts' ) && 'full-width' == enlightenment_current_layout() && 'primary' == enlightenment_current_sidebar_name() ) {
		remove_filter( 'is_active_sidebar', 'enlightenment_remove_sidebar_in_full_width', 8 );
		return false;
	}
	return $is_active_sidebar;
}




