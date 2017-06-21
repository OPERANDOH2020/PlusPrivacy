<?php

add_filter( 'enlightenment_theme_options_page_tabs', 'enlightenment_theme_options_grid_loop_tab' );

function enlightenment_theme_options_grid_loop_tab( $tabs ) {
	$tabs['grid_loop'] = __( 'Grid Loop', 'enlightenment' );
	return $tabs;
}

add_action( 'enlightenment_grid_loop_settings_sections', 'enlightenment_grid_loop_settings' );

function enlightenment_grid_loop_settings() {
	add_settings_section(
		'select_template', // Unique identifier for the settings section
		__( 'Select Template', 'enlightenment' ), // Section title
		'__return_false', // Section callback (we don't want anything)
		'enlightenment_theme_options' // Menu slug, used to uniquely identify the page
	);
	add_settings_field(
		'select_template',  // Unique identifier for the field for this section
		__( 'Select Template to Edit', 'enlightenment' ), // Setting field label
		'enlightenment_grid_loop_select_template', // Function that renders the settings field
		'enlightenment_theme_options', // Menu slug, used to uniquely identify the page
		'select_template', // Settings section. Same as the first argument in the add_settings_section() above
		array(
			'name' => 'select_template',
			'class' => 'select-template',
		)
	);
	add_settings_section(
		'grid_loop', // Unique identifier for the settings section
		__( 'Grid Loop', 'enlightenment' ), // Section title
		'__return_false', // Section callback (we don't want anything)
		'enlightenment_theme_options' // Menu slug, used to uniquely identify the page
	);
	add_settings_field(
		'grid',  // Unique identifier for the field for this section
		__( 'Select Grid', 'enlightenment' ), // Setting field label
		'enlightenment_grid_loop_options', // Function that renders the settings field
		'enlightenment_theme_options', // Menu slug, used to uniquely identify the page
		'grid_loop', // Settings section. Same as the first argument in the add_settings_section() above
		array(
			'name' => 'grids[' . enlightenment_current_grid_loop_template() . '][grid]',
		)
	);
	$grids = enlightenment_archive_grids();
	$grids['default']['lead_posts'] = '';
	$options = array();
	for( $i = 0; $i <= get_option( 'posts_per_page' ); $i++ ) {
		$options[$i] = $i;
	}
	add_settings_field(
		'lead_posts',  // Unique identifier for the field for this section
		__( 'Lead Posts', 'enlightenment' ), // Setting field label
		'enlightenment_select_box', // Function that renders the settings field
		'enlightenment_theme_options', // Menu slug, used to uniquely identify the page
		'grid_loop', // Settings section. Same as the first argument in the add_settings_section() above
		array(
			'name' => 'grids[' . enlightenment_current_grid_loop_template() . '][lead_posts]',
			'value' => $grids[ enlightenment_current_grid_loop_template() ]['lead_posts'],
			'options' => $options,
		)
	);
}

function enlightenment_grid_loop_select_template( $args, $echo = true ) {
	$templates = enlightenment_grid_loop_templates();
	$defaults = array(
		'class' => '',
		'id' => '',
		'options' => $templates,
		'description' => '',
	);
	$args = wp_parse_args( $args, $defaults );
	$args['multiple'] = false;
	$output = enlightenment_select_box( $args, false );
	if( ! $echo )
		return $output;
	echo $output;
}

function enlightenment_grid_loop_templates() {
	$templates = array(
		'default' => __( 'All', 'enlightenment' ),
		'search' => __( 'Search', 'enlightenment' ),
		'post' => __( 'Blog', 'enlightenment' ),
		'author' => __( 'Author', 'enlightenment' ),
		'date' => __( 'Date', 'enlightenment' ),
		'category' => __( 'Category', 'enlightenment' ),
		'post_tag' => __( 'Tag', 'enlightenment' ),
	);
	$post_types = get_post_types( array( 'has_archive' => true ), 'objects' );
	foreach( $post_types as $name => $post_type )
		$templates[$name] = sprintf( __( '%1$s Archive', 'enlightenment' ), $post_type->labels->name );
	$taxonomies = get_taxonomies( array( 'public' => true ), 'objects' );
	foreach( $taxonomies as $name => $taxonomy ) {
		if( 'Format' == $taxonomy->labels->singular_name )
			$taxonomy->labels->singular_name = __( 'Post Format', 'enlightenment' );
		$templates[$name] = $taxonomy->labels->singular_name;
	}
	return apply_filters( 'enlightenment_grid_loop_templates', $templates );
}

function enlightenment_grid_loop_options( $args, $echo = true ) {
	$buttons = array();
	$grids = enlightenment_grid_columns();
	foreach( $grids as $grid => $atts ) {
		$buttons[] = array(
			'label' => $atts['name'],
			'image' => $atts['image'],
			'value' => $grid,
		);
	}
	$grids = enlightenment_archive_grids();
	$grids['default']['grid'] = '';
	$defaults = array(
		'class' => '',
		'buttons' => $buttons,
		'value' => $grids[ enlightenment_current_grid_loop_template() ]['grid'],
		'description' => '',
	);
	$args = wp_parse_args( $args, $defaults );
	$output = enlightenment_image_radio_buttons( $args, false );
	$output = apply_filters( 'enlightenment_grid_loop_options', $output, $args );
	if( ! $echo )
		return $output;
	echo $output;
}

function enlightenment_current_grid_loop_template() {
	if( isset( $_GET['template'] ) )
		$template = esc_attr( $_GET['template'] );
	else {
		$templates = enlightenment_grid_loop_templates();
		reset( $templates );
		$template = key( $templates );
	}
	return $template;
}

add_filter( 'enlightenment_validate_grid_loop_theme_options', 'enlightenment_validate_grid_loop_options' );

function enlightenment_validate_grid_loop_options( $input ) {
	$template = $input['select_template'];
	$templates = enlightenment_grid_loop_templates();
	if( ! array_key_exists( $template, $templates ) )
		unset( $input['grids'][$template] );
	unset( $input['select_template'] );
	if( 'default' == $template ) {
		$grid = $input['grids'][$template]['grid'];
		if( ! array_key_exists( $grid, enlightenment_grid_columns() ) ) {
			$input['grids'] = enlightenment_archive_grids();
			return $input;
		}
		$lead_posts = intval( $input['grids'][$template]['lead_posts'] );
		if( 0 > $lead_posts || get_option( 'posts_per_page' ) < $lead_posts ) {
			$input['grids'] = enlightenment_archive_grids();
			return $input;
		}
		$templates = array_keys( $templates );
		foreach( $templates as $template ) {
			$input['grids'][$template]['grid'] = $grid;
			$input['lead_posts'][$template]['lead_posts'] = $grid;
		}
		unset( $input['grids']['default'] );
		return $input;
	}
	$grids = enlightenment_archive_grids();
	foreach( $input['grids'] as $template => $grid ) {
		if( ! array_key_exists( $template, enlightenment_grid_loop_templates() ) )
			unset( $input['grids'][$template] );
		if( ! array_key_exists( $grid['grid'], enlightenment_grid_columns() ) )
			$input['grids'][$template]['grid'] = $grids[$template]['grid'];
		if( 0 > $grid['lead_posts'] || get_option( 'posts_per_page' ) < $grid['lead_posts'] )
			$input['grids'][$template]['lead_posts'] = $grids[$template]['lead_posts'];
	}
	$input['grids'] = array_merge( $grids, $input['grids'] );
	return $input;
}