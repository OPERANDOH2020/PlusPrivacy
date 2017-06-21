<?php

add_filter( 'enlightenment_theme_options_page_tabs', 'enlightenment_theme_options_logo_tab' );

function enlightenment_theme_options_logo_tab( $tabs ) {
	$tabs['logo'] = __( 'Logo', 'enlightenment' );
	return $tabs;
}

add_action( 'enlightenment_logo_settings_sections', 'enlightenment_logo_settings' );

function enlightenment_logo_settings() {
	add_settings_section(
		'logo_image', // Unique identifier for the settings section
		__( 'Logo Image', 'enlightenment' ), // Section title
		'__return_false', // Section callback (we don't want anything)
		'enlightenment_theme_options' // Menu slug, used to uniquely identify the page
	);
	$logo = enlightenment_theme_option( 'logo' );
	add_settings_field(
		'upload_logo',  // Unique identifier for the field for this section
		__( 'Upload Logo', 'enlightenment' ), // Setting field label
		'enlightenment_upload_media', // Function that renders the settings field
		'enlightenment_theme_options', // Menu slug, used to uniquely identify the page
		'logo_image', // Settings section. Same as the first argument in the add_settings_section() above
		array(
			'name'  => 'logo[image]',
			'value' => $logo['image'],
			'class' => 'site-logo',
			'id' => 'site-logo',
			'upload_button_text' => __( 'Choose Logo', 'enlightenment' ),
			'uploader_title' => __( 'Select Logo', 'enlightenment' ),
			'uploader_button_text' => __( 'Use as Logo', 'enlightenment' ),
			'remove_button_text' => __( 'Remove Logo', 'enlightenment' ),
			'mime_type' => 'image',
			'thumbnail' => 'enlightenment-logo',
		)
	);
	add_settings_section(
		'logo_settings', // Unique identifier for the settings section
		__( 'Settings', 'enlightenment' ), // Section title
		'__return_false', // Section callback (we don't want anything)
		'enlightenment_theme_options' // Menu slug, used to uniquely identify the page
	);
	add_settings_field(
		'logo_dimmensions',  // Unique identifier for the field for this section
		__( 'Dimmensions', 'enlightenment' ), // Setting field label
		'enlightenment_logo_dimmensions', // Function that renders the settings field
		'enlightenment_theme_options', // Menu slug, used to uniquely identify the page
		'logo_settings', // Settings section. Same as the first argument in the add_settings_section() above
		array(
			'width_name'  => 'logo[width]',
			'height_name'  => 'logo[height]',
			'width'  => current_theme_supports( 'enlightenment-logo', 'width' ),
			'height'  => current_theme_supports( 'enlightenment-logo', 'height' ),
		)
	);
	add_settings_field(
		'crop_logo',  // Unique identifier for the field for this section
		__( 'Crop Flag', 'enlightenment' ), // Setting field label
		'enlightenment_checkbox', // Function that renders the settings field
		'enlightenment_theme_options', // Menu slug, used to uniquely identify the page
		'logo_settings', // Settings section. Same as the first argument in the add_settings_section() above
		array(
			'name' => 'logo[crop_flag]',
			'label' => __( 'Crop Logo Image to fixed Dimmensions', 'enlightenment' ),
			'checked' => current_theme_supports( 'enlightenment-logo', 'crop_flag' ),
		)
	);
	add_settings_field(
		'site_title',  // Unique identifier for the field for this section
		__( 'Site Title', 'enlightenment' ), // Setting field label
		'enlightenment_checkboxes', // Function that renders the settings field
		'enlightenment_theme_options', // Menu slug, used to uniquely identify the page
		'logo_settings', // Settings section. Same as the first argument in the add_settings_section() above
		array(
			'boxes' => array(
				array(
					'name' => 'logo[insert_site_title]',
					'label' => __( 'Automatically insert Logo in Site Title', 'enlightenment' ),
					'checked' => apply_filters( 'enlightenment_site_title_logo', true ),
				),
				array(
					'name' => 'logo[hide_text]',
					'label' => __( 'Hide Site Title Text', 'enlightenment' ),
					'checked' => apply_filters( 'enlightenment_hide_site_title_text', false ),
				),
			),
		)
	);
}

function enlightenment_upload_logo( $args, $echo = true ) {
	$defaults = array(
		'class' => 'site-logo',
		'id' => 'site-logo',
		'upload_button_text' => __( 'Choose Logo', 'enlightenment' ),
		'uploader_title' => __( 'Select Logo', 'enlightenment' ),
		'uploader_button_text' => __( 'Use as Logo', 'enlightenment' ),
		'remove_button_text' => __( 'Remove Logo', 'enlightenment' ),
		'mime_type' => 'image',
		'thumbnail' => 'enlightenment-logo',
	);
	$args = wp_parse_args( $args, $defaults );
	if( ! isset( $args['name'] ) || empty( $args['name'] ) ) {
		_doing_it_wrong( __FUNCTION__, 'Please specify a name attribute for your logo uploader.', '' );
		return;
	}
	$output = enlightenment_upload_media( $args, false );
	$output = apply_filters( 'enlightenment_upload_logo', $output, $args );
	if( ! $echo )
		return $output;
	echo $output;
}

function enlightenment_logo_dimmensions( $args, $echo = true ) {
	$defaults = array(
		'size' => 3,
	);
	$args = wp_parse_args( $args, $defaults );
	if( ! isset( $args['width_name'] ) || empty( $args['width_name'] ) ) {
		_doing_it_wrong( __FUNCTION__, 'Please specify a name attribute for your width field.', '' );
		return;
	}
	if( ! isset( $args['height_name'] ) || empty( $args['height_name'] ) ) {
		_doing_it_wrong( __FUNCTION__, 'Please specify a name attribute for your height field.', '' );
		return;
	}
	$output = enlightenment_text_input( array(
		'name' => $args['width_name'],
		'size' => $args['size'],
		'value' => $args['width'],
		'description' => '',
	), false );
	$output .= ' &times; ';
	$output .= enlightenment_text_input( array(
		'name' => $args['height_name'],
		'size' => $args['size'],
		'value' => $args['height'],
		'description' => '',
	), false );
	$output .= ' ';
	$output .= __( 'pixels', 'enlightenment' );
	$output = apply_filters( 'enlightenment_logo_dimmensions', $output, $args );
	if( ! $echo )
		return $output;
	echo $output;
}

add_filter( 'enlightenment_validate_logo_theme_options', 'enlightenment_validate_logo_theme_options' );

function enlightenment_validate_logo_theme_options( $input ) {
	$logo = enlightenment_theme_option( 'logo' );
	if( '' != $input['logo']['image'] ) {
		$input['logo']['image'] = intval( $input['logo']['image'] );
		$post = get_post( $input['logo']['image'] );
		if( 'attachment' != $post->post_type || false === strpos( $post->post_mime_type, 'image' ) )
			$input['logo']['image'] = $logo['image'];
	}
	$input['logo']['width'] = intval( $input['logo']['width'] );
	$input['logo']['height'] = intval( $input['logo']['height'] );
	if( ! is_int( $input['logo']['width'] ) )
		$input['logo']['width'] = current_theme_supports( 'enlightenment-logo', 'width' );
	if( ! is_int( $input['logo']['height'] ) )
		$input['logo']['height'] = current_theme_supports( 'enlightenment-logo', 'height' );
	$input['logo']['crop_flag'] = isset( $input['logo']['crop_flag'] );
	$input['logo']['insert_site_title'] = isset( $input['logo']['insert_site_title'] );
	$input['logo']['hide_text'] = isset( $input['logo']['hide_text'] );
	return $input;
}