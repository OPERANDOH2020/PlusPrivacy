<?php

add_filter( 'enlightenment_theme_options_page_tabs', 'enlightenment_theme_options_layouts_tab' );

function enlightenment_theme_options_layouts_tab( $tabs ) {
	$tabs['layouts'] = __( 'Layouts', 'enlightenment' );
	return $tabs;
}

add_action( 'enlightenment_layouts_settings_sections', 'enlightenment_layouts_settings' );

function enlightenment_layouts_settings() {
	add_settings_section(
		'select_template', // Unique identifier for the settings section
		__( 'Select Template', 'enlightenment' ), // Section title
		'__return_false', // Section callback (we don't want anything)
		'enlightenment_theme_options' // Menu slug, used to uniquely identify the page
	);
	add_settings_field(
		'select_template',  // Unique identifier for the field for this section
		__( 'Select Template to Edit', 'enlightenment' ), // Setting field label
		'enlightenment_layouts_select_template', // Function that renders the settings field
		'enlightenment_theme_options', // Menu slug, used to uniquely identify the page
		'select_template', // Settings section. Same as the first argument in the add_settings_section() above
		array(
			'name' => 'select_template',
			'class' => 'select-template',
		)
	);
	add_settings_section(
		'layout', // Unique identifier for the settings section
		__( 'Layout', 'enlightenment' ), // Section title
		'__return_false', // Section callback (we don't want anything)
		'enlightenment_theme_options' // Menu slug, used to uniquely identify the page
	);
	add_settings_field(
		'layout',  // Unique identifier for the field for this section
		__( 'Select Layout', 'enlightenment' ), // Setting field label
		'enlightenment_layout_options', // Function that renders the settings field
		'enlightenment_theme_options', // Menu slug, used to uniquely identify the page
		'layout', // Settings section. Same as the first argument in the add_settings_section() above
		array(
			'name' => 'layouts[' . enlightenment_current_layout_template() . ']',
		)
	);
}

function enlightenment_layouts_select_template( $args, $echo = true ) {
	$templates = enlightenment_layout_templates();
	$defaults = array(
		'class' => '',
		'id' => '',
		'options' => $templates,
		'description' => '',
	);
	$args = wp_parse_args( $args, $defaults );
	$args['value'] = enlightenment_current_layout_template();
	$args['multiple'] = false;
	$output = enlightenment_select_box( $args, false );
	if( ! $echo )
		return $output;
	echo $output;
}

function enlightenment_layout_templates() {
	$templates = array(
		'default' => __( 'All', 'enlightenment' ),
		'error404' => __( '404', 'enlightenment' ),
		'search' => __( 'Search', 'enlightenment' ),
		'blog' => __( 'Blog', 'enlightenment' ),
		'post' => __( 'Post', 'enlightenment' ),
		'page' => __( 'Page', 'enlightenment' ),
		'author' => __( 'Author', 'enlightenment' ),
		'date' => __( 'Date', 'enlightenment' ),
		'category' => __( 'Category', 'enlightenment' ),
		'post_tag' => __( 'Tag', 'enlightenment' ),
	);
	$post_types = get_post_types( array( 'has_archive' => true ), 'objects' );
	foreach( $post_types as $name => $post_type )
		$templates[$name . '-archive'] = sprintf( __( '%1$s Archive', 'enlightenment' ), $post_type->labels->name );
	$post_types = get_post_types( array( 'publicly_queryable' => true ), 'objects' );
	foreach( $post_types as $name => $post_type )
		$templates[$name] = $post_type->labels->singular_name;
	$taxonomies = get_taxonomies( array( 'public' => true ), 'objects' );
	unset( $taxonomies['post_format'] );
	foreach( $taxonomies as $name => $taxonomy ) {
		if( 'Format' == $taxonomy->labels->singular_name )
			$taxonomy->labels->singular_name = __( 'Post Format', 'enlightenment' );
		$templates[$name] = $taxonomy->labels->singular_name;
	}
	return apply_filters( 'enlightenment_layout_templates', $templates );
}

function enlightenment_layout_options( $args, $echo = true ) {
	$buttons = array();
	$layouts = enlightenment_custom_layouts();
	foreach( $layouts as $layout => $atts ) {
		$buttons[] = array(
			'label' => $atts['name'],
			'image' => $atts['image'],
			'value' => $layout,
		);
	}
	$layouts = enlightenment_archive_layouts();
	$layouts['default'] = '';
	$defaults = array(
		'class' => '',
		'buttons' => $buttons,
		'value' => $layouts[ enlightenment_current_layout_template() ],
		'description' => '',
	);
	$args = wp_parse_args( $args, $defaults );
	$output = enlightenment_image_radio_buttons( $args, false );
	$output = apply_filters( 'enlightenment_layout_options', $output, $args );
	if( ! $echo )
		return $output;
	echo $output;
}

function enlightenment_current_layout_template() {
	global $pagenow;
	if( 'post.php' == $pagenow && isset( $_GET['action'] ) && 'edit' == $_GET['action'] )
		$template = get_post_type();
	elseif( isset( $_GET['template'] ) )
		$template = esc_attr( $_GET['template'] );
	else {
		$templates = enlightenment_layout_templates();
		reset( $templates );
		$template = key( $templates );
	}
	return $template;
}

add_filter( 'enlightenment_validate_layouts_theme_options', 'enlightenment_validate_layout_options' );

function enlightenment_validate_layout_options( $input ) {
	$template = $input['select_template'];
	$templates = enlightenment_layout_templates();
	if( ! array_key_exists( $template, $templates ) )
		unset( $input['layouts'][$template] );
	unset( $input['select_template'] );
	if( 'default' == $template ) {
		$layout = $input['layouts'][$template];
		if( ! array_key_exists( $layout, enlightenment_custom_layouts() ) ) {
			$input['layouts'] = enlightenment_archive_layouts();
			return $input;
		}
		$templates = array_keys( $templates );
		foreach( $templates as $template ) {
			$input['layouts'][$template] = $layout;
		}
		unset( $input['layouts']['default'] );
		return $input;
	}
	$layouts = enlightenment_archive_layouts();
	foreach( $input['layouts'] as $template => $layout ) {
		if( ! array_key_exists( $template, enlightenment_layout_templates() ) )
			unset( $input['layouts'][$template] );
		if( ! array_key_exists( $layout, enlightenment_custom_layouts() ) )
			$input['layouts'][$template] = $layouts[$template];
	}
	$input['layouts'] = array_merge( $layouts, $input['layouts'] );
	return $input;
}

add_action( 'add_meta_boxes', 'enlightenment_custom_layout_meta_boxes' );

function enlightenment_custom_layout_meta_boxes() {
	$post_types = array_merge( array( 'page' => 'page' ), get_post_types( array( 'publicly_queryable' => true ) ) );
	unset( $post_types['attachment'] );
	foreach( $post_types as $post_type )
		add_meta_box( 'enlightenment_custom_layout', __( 'Custom Layout', 'enlightenment' ), 'enlightenment_custom_layout_form', $post_type, 'normal', 'high' );
}

function enlightenment_custom_layout_form( $post ) {
	wp_nonce_field( 'enlightenment_custom_layout_form', 'enlightenment_custom_layout_form_nonce' );
	echo '<p><label class="image-radio-button-label">';
	echo '<input name="enlightenment_custom_layout" class="image-radio-button" value="" type="radio" ' . checked( get_post_meta( $post->ID, '_enlightenment_custom_layout', true ), '', false ) . ' /> ';
	echo sprintf( __( 'Use default layout for %1$s', 'enlightenment' ), $post->post_type );
	echo '</label></p>';
	enlightenment_layout_options( array(
		'name' => 'enlightenment_custom_layout',
		'value' => get_post_meta( $post->ID, '_enlightenment_custom_layout', true ),
	) );
}

add_action( 'save_post', 'enlightenment_custom_layout_form_save_postdata' );

function enlightenment_custom_layout_form_save_postdata( $post_id ) {
	if( ! isset( $_POST['enlightenment_custom_layout'] ) )
		return $post_id;
	$nonce = $_POST['enlightenment_custom_layout_form_nonce'];
	if( ! wp_verify_nonce( $nonce, 'enlightenment_custom_layout_form' ) )
		return $post_id;
	if( defined( 'DOING_AUTOSAVE' ) && DOING_AUTOSAVE )
		return $post_id;
	$post = get_post( $post_id );
	if( ! current_user_can( get_post_type_object( $post->post_type )->cap->edit_post, $post_id ) )
		return $post_id;
	$layouts = enlightenment_custom_layouts();
	if( array_key_exists( $_POST['enlightenment_custom_layout'], $layouts ) || '' == $_POST['enlightenment_custom_layout'] )
		update_post_meta( $post_id, '_enlightenment_custom_layout', $_POST['enlightenment_custom_layout'] );
}




