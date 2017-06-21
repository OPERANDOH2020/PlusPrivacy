<?php

function enlightenment_current_post_format() {
	global $pagenow;
	if( 'post.php' == $pagenow && isset( $_GET['action'] ) && 'edit' == $_GET['action'] ) {
		$format = get_post_format();
	} elseif( isset( $_GET['format'] ) ) {
		$format = esc_attr( $_GET['format'] );
		$format = str_replace( '-teaser', '', $format );
	} else {
		$formats = enlightenment_post_formats();
		reset( $formats );
		$format = key( $formats );
	}
	return $format;
}

function enlightenment_current_post_format_template() {
	global $pagenow;
	if( 'post.php' == $pagenow && isset( $_GET['action'] ) && 'edit' == $_GET['action'] ) {
		$format = get_post_format();
	} elseif( isset( $_GET['format'] ) ) {
		$format = esc_attr( $_GET['format'] );
	} else {
		$formats = enlightenment_post_formats();
		reset( $formats );
		$format = key( $formats );
	}
	return $format;
}

add_filter( 'enlightenment_theme_options_page_tabs', 'enlightenment_theme_options_post_formats_tab' );

function enlightenment_theme_options_post_formats_tab( $tabs ) {
	$tabs['post_formats'] = __( 'Post Formats', 'enlightenment' );
	return $tabs;
}

add_action( 'enlightenment_before_theme_settings', 'enlightenment_simmulate_post_format' );

function enlightenment_simmulate_post_format( $tab ) {
	global $wp_current_filter, $post, $wp_query;
	if( doing_action( 'enlightenment_before_page_builder' ) ) {
		
	} elseif( 'post_formats' == $tab ) {
		$wp_query = new WP_Query( array( 'post_format' => 'post-format-' . enlightenment_current_post_format() ) );
		do_action_ref_array( 'wp', array( &$wp_query ) );
		the_post();
		if( current_theme_supports( 'enlightenment-grid-loop' ) ) {
			if( isset( $_GET['format'] )  && strpos( $_GET['format'], '-teaser' ) )
				add_filter( 'enlightenment_is_lead_post', '__return_false' );
			else
				add_filter( 'enlightenment_is_lead_post', '__return_true' );
		}
		do_action( 'enlightenment_before_entry' );
		// var_dump( get_post_format( $post->ID ) );
	}
}

add_action( 'enlightenment_after_theme_settings', 'wp_reset_query' );

add_filter( 'enlightenment_theme_option-select_post_format', 'enlightenment_current_post_format_template' );

add_action( 'enlightenment_post_formats_settings_sections', 'enlightenment_post_formats_settings' );

function enlightenment_post_formats_settings() {
	add_settings_section(
		'select_post_format', // Unique identifier for the settings section
		__( 'Select Post Format', 'enlightenment' ), // Section title
		'__return_false', // Section callback (we don't want anything)
		'enlightenment_theme_options' // Menu slug, used to uniquely identify the page
	);
	add_settings_field(
		'select_post_format',  // Unique identifier for the field for this section
		__( 'Select Post Format to Edit', 'enlightenment' ), // Setting field label
		'enlightenment_select_post_format', // Function that renders the settings field
		'enlightenment_theme_options', // Menu slug, used to uniquely identify the page
		'select_post_format', // Settings section. Same as the first argument in the add_settings_section() above
		array(
			'name' => 'select_post_format',
			'class' => 'select-post-format',
		)
	);
	add_settings_section(
		'template_hooks', // Unique identifier for the settings section
		__( 'Template Hooks', 'enlightenment' ), // Section title
		'__return_false', // Section callback (we don't want anything)
		'enlightenment_theme_options' // Menu slug, used to uniquely identify the page
	);
	$template = enlightenment_get_template( 'blog' );
	foreach( array_keys( enlightenment_entry_hooks() ) as $hook ) {
		$atts = enlightenment_get_template_hook( $hook );
		if( ! empty( $atts['functions'] ) )
			add_settings_field(
				'template_hooks_' . $hook,  // Unique identifier for the field for this section
				$atts['name'], // Setting field label
				'enlightenment_template_hook_actions', // Function that renders the settings field
				'enlightenment_theme_options', // Menu slug, used to uniquely identify the page
				'template_hooks', // Settings section. Same as the first argument in the add_settings_section() above
				array(
					'hook' => $hook,
					'name' => 'template_hooks[' . enlightenment_current_post_format_template() . '][' . $hook . ']',
					'class' => 'template-hooks',
				)
			);
	}
}

function enlightenment_select_post_format( $args, $echo = true ) {
	$defaults = array(
		'class' => '',
		'id' => '',
		'options' => enlightenment_post_formats(),
		'description' => '',
	);
	$args = wp_parse_args( $args, $defaults );
	$args['multiple'] = false;
	$output = enlightenment_select_box( $args, false );
	if( ! $echo )
		return $output;
	echo $output;
}

add_filter( 'enlightenment_entry_hooks', 'enlightenment_post_formats_available_functions' );

function enlightenment_post_formats_available_functions( $hooks ) {
	$functions = array();
	if( isset( $_GET['format'] ) )
		$post_format = esc_attr( $_GET['format'] );
	elseif( isset( $_POST['enlightenment_theme_options']['select_post_format'] ) )
		$post_format = esc_attr( $_POST['enlightenment_theme_options']['select_post_format'] );
	else
		$post_format = key( enlightenment_post_formats() );
	
	$post_format = str_replace( '-teaser', '', $post_format );
	if( 'gallery' == $post_format )
		$functions[] = 'enlightenment_entry_gallery';
	elseif( 'video' == $post_format )
		$functions[] = 'enlightenment_entry_video';
	elseif( 'audio' == $post_format )
		$functions[] = 'enlightenment_entry_audio';
	elseif( 'image' == $post_format )
		$functions[] = 'enlightenment_entry_image';
	elseif( 'quote' == $post_format )
		$functions[] = 'enlightenment_entry_blockquote';
	elseif( 'status' == $post_format )
		$functions[] = 'enlightenment_entry_author_avatar';
	$functions = apply_filters( 'enlightenment_post_formats_available_functions', $functions );
	$hooks['enlightenment_entry_header']['functions'] = array_merge( $hooks['enlightenment_entry_header']['functions'], $functions );
	$hooks['enlightenment_entry_content']['functions'] = array_merge( $hooks['enlightenment_entry_content']['functions'], $functions );
	return $hooks;
}

add_filter( 'enlightenment_validate_post_formats_theme_options', 'enlightenment_validate_post_formats_editor' );

function enlightenment_validate_post_formats_editor( $input ) {
	foreach( $input['template_hooks'] as $post_format => $hooks ) {
		if( $post_format != $input['select_post_format'] )
			unset( $input['template_hooks'][$post_format] );
	}
	$post_format = $input['select_post_format'];
	unset( $input['select_post_format'] );
	foreach( $input['template_hooks'][$post_format] as $hook => $functions ) {
		if( ! in_array( $hook, array_keys( enlightenment_entry_hooks() ) ) )
			unset( $input['template_hooks'][$post_format][$hook] );
	}
	foreach( $input['template_hooks'][$post_format] as $hook => $functions ) {
		$functions = explode( ',', $functions );
		$atts = enlightenment_get_template_hook( $hook );
		foreach( $functions as $key => $function ) {
			if( ! in_array( $function, $atts['functions'] ) ) {
				unset( $functions[$key] );
			}
		}
		$input['template_hooks'][$post_format][$hook] = $functions;
	}
	$option = enlightenment_theme_option( 'template_hooks', array() );
	$input['template_hooks'] = array_merge( $option, $input['template_hooks'] );
	return $input;
}




