<?php

add_filter( 'enlightenment_theme_options_page_tabs', 'enlightenment_theme_options_web_fonts_tab' );

function enlightenment_theme_options_web_fonts_tab( $tabs ) {
	$tabs['web_fonts'] = __( 'Web Fonts', 'enlightenment' );
	return $tabs;
}

add_action( 'enlightenment_web_fonts_settings_sections', 'enlightenment_web_fonts_settings' );

function enlightenment_web_fonts_settings() {
	remove_filter( 'enlightenment_hidden_input_args', 'enlightenment_theme_settings_override_value' );
	add_settings_section(
		'subsets', // Unique identifier for the settings section
		__( 'Subsets', 'enlightenment' ), // Section title
		'__return_false', // Section callback (we don't want anything)
		'enlightenment_theme_options' // Menu slug, used to uniquely identify the page
	);
	add_settings_section(
		'google_dir', // Unique identifier for the settings section
		__( 'Google Web Fonts Directory', 'enlightenment' ), // Section title
		'__return_false', // Section callback (we don't want anything)
		'enlightenment_theme_options' // Menu slug, used to uniquely identify the page
	);
	$subsets = current_theme_supports( 'enlightenment-web-fonts', 'subsets' );
	add_settings_field(
		'select_subsets',  // Unique identifier for the field for this section
		__( 'Select your font subsets', 'enlightenment' ), // Setting field label
		'enlightenment_checkboxes', // Function that renders the settings field
		'enlightenment_theme_options', // Menu slug, used to uniquely identify the page
		'subsets', // Settings section. Same as the first argument in the add_settings_section() above
		array(
			'class' => 'subset',
			'boxes' => array(
				array(
					'name' => 'subsets[]',
					'value' => 'latin',
					'checked' => in_array( 'latin', $subsets ),
					'label' => __( 'Latin', 'enlightenment' ),
				),
				array(
					'name' => 'subsets[]',
					'value' => 'latin-ext',
					'checked' => in_array( 'latin-ext', $subsets ),
					'label' => __( 'Latin Extended', 'enlightenment' ),
				),
				array(
					'name' => 'subsets[]',
					'value' => 'greek',
					'checked' => in_array( 'greek', $subsets ),
					'label' => __( 'Greek', 'enlightenment' ),
				),
				array(
					'name' => 'subsets[]',
					'value' => 'greek-ext',
					'checked' => in_array( 'greek-ext', $subsets ),
					'label' => __( 'Greek Extended', 'enlightenment' ),
				),
				array(
					'name' => 'subsets[]',
					'value' => 'cyrillic',
					'checked' => in_array( 'cyrillic', $subsets ),
					'label' => __( 'Cyrillic', 'enlightenment' ),
				),
				array(
					'name' => 'subsets[]',
					'value' => 'cyrillic-ext',
					'checked' => in_array( 'cyrillic-ext', $subsets ),
					'label' => __( 'Cyrillic Extended', 'enlightenment' ),
				),
				array(
					'name' => 'subsets[]',
					'value' => 'devangari',
					'checked' => in_array( 'devangari', $subsets ),
					'label' => __( 'Devangari', 'enlightenment' ),
				),
				array(
					'name' => 'subsets[]',
					'value' => 'khmer',
					'checked' => in_array( 'khmer', $subsets ),
					'label' => __( 'Khmer', 'enlightenment' ),
				),
				array(
					'name' => 'subsets[]',
					'value' => 'telugu',
					'checked' => in_array( 'telugu', $subsets ),
					'label' => __( 'Telugu', 'enlightenment' ),
				),
				array(
					'name' => 'subsets[]',
					'value' => 'vietnamese',
					'checked' => in_array( 'vietnamese', $subsets ),
					'label' => __( 'Vietnamese', 'enlightenment' ),
				),
			),
		)
	);
	add_settings_field(
		'google_api_key',  // Unique identifier for the field for this section
		__( 'Google Developer API Key', 'enlightenment' ), // Setting field label
		'enlightenment_text_input', // Function that renders the settings field
		'enlightenment_theme_options', // Menu slug, used to uniquely identify the page
		'google_dir', // Settings section. Same as the first argument in the add_settings_section() above
		array(
			'name'  => 'google_api_key',
			'value' => current_theme_supports( 'enlightenment-web-fonts', 'google_api_key' ),
			'description' => sprintf( __( 'Learn how to obtain an API key <a href="%s" target="_blank">here</a>.', 'enlightenment' ), esc_url( 'https://developers.google.com/console/help/new/#generatingdevkeys' ) ),
		)
	);
	add_settings_field(
		'filter_by_subsets',  // Unique identifier for the field for this section
		__( 'Filter by Subsets', 'enlightenment' ), // Setting field label
		'enlightenment_checkbox', // Function that renders the settings field
		'enlightenment_theme_options', // Menu slug, used to uniquely identify the page
		'google_dir', // Settings section. Same as the first argument in the add_settings_section() above
		array(
			'name' => 'filter_by_subsets',
			'checked' => current_theme_supports( 'enlightenment-web-fonts', 'filter_by_subsets' ),
			'label' => 'Only display fonts with my selected subsets',
		)
	);
	add_settings_field(
		'live_preview',  // Unique identifier for the field for this section
		__( 'Live Preview Fonts', 'enlightenment' ), // Setting field label
		'enlightenment_checkbox', // Function that renders the settings field
		'enlightenment_theme_options', // Menu slug, used to uniquely identify the page
		'google_dir', // Settings section. Same as the first argument in the add_settings_section() above
		array(
			'name' => 'live_preview_fonts',
			'label' => 'Load and preview all available fonts',
			'checked' => current_theme_supports( 'enlightenment-web-fonts', 'live_preview_fonts' ),
			'description' => __( "Enabling this option will severely impact your browser's performance.", 'enlightenment' ),
		)
	);
	add_settings_field(
		'sort_by',  // Unique identifier for the field for this section
		__( 'Sort by', 'enlightenment' ), // Setting field label
		'enlightenment_select_box', // Function that renders the settings field
		'enlightenment_theme_options', // Menu slug, used to uniquely identify the page
		'google_dir', // Settings section. Same as the first argument in the add_settings_section() above
		array(
			'name' => 'sort_fonts_by',
			'value' => current_theme_supports( 'enlightenment-web-fonts', 'sort_fonts_by' ),
			'options' => array(
				'popularity' => ' Popularity',
				'trending' => 'Trending',
				'alpha' => 'Alphabetically',
				'date' => 'Date Added',
				'style' => 'Most Styles',
			),
		)
	);
	add_settings_field(
		'google_fonts',  // Unique identifier for the field for this section
		__( 'Fonts in Google Directory', 'enlightenment' ), // Setting field label
		'enlightenment_google_fonts_list', // Function that renders the settings field
		'enlightenment_theme_options', // Menu slug, used to uniquely identify the page
		'google_dir', // Settings section. Same as the first argument in the add_settings_section() above
		array(
			'name' => 'filter_by_subsets',
			'label' => 'Only display fonts with my selected subsets',
		)
	);
}

function enlightenment_google_fonts_list( $args, $echo = true ) {
	$fonts = enlightenment_web_fonts();
	$output = enlightenment_open_tag( 'fieldset', 'google-fonts' );
	foreach( $fonts as $font ) {
		if( current_theme_supports( 'enlightenment-web-fonts', 'filter_by_subsets' ) ) {
			$continue = false;
			foreach( current_theme_supports( 'enlightenment-web-fonts', 'subsets' ) as $subset ) {
				if( ! in_array( $subset, $font['subsets'] ) ) {
					$continue = true;
				}
			}
			if( $continue )
				continue;
		}
		$output .= enlightenment_checkbox( array(
			'name' => 'web_fonts[' . $font['family'] . '][family]',
			'value' => $font['family'],
			'checked' => true,
			'label' => $font['family'],
		), false );
		$output .= enlightenment_hidden_input( array(
			'name' => 'web_fonts[' . $font['family'] . '][category]',
			'value' => $font['category'],
		), false );
		$output .= enlightenment_hidden_input( array(
			'name' => 'web_fonts[' . $font['family'] . '][variants]',
			'value' => join( ',', $font['variants'] ),
		), false );
		$output .= enlightenment_hidden_input( array(
			'name' => 'web_fonts[' . $font['family'] . '][subsets]',
			'value' => join( ',', $font['subsets'] ),
		), false );
		$output .= '<br />';
	}
	if( '' == current_theme_supports( 'enlightenment-web-fonts', 'google_api_key' ) )
		$output .= sprintf( '<h3>%s</h3>', __( 'Obtain a Google Developer API key to see all fonts in the Google Directory.', 'enlightenment' ) );
	else
		$output .= sprintf( '<h3>%s</h3>', __( 'Please wait while the fonts list is being populated.', 'enlightenment' ) );
	$output .= enlightenment_close_tag( 'fieldset' );
	$output = apply_filters( 'enlightenment_google_fonts_list', $output, $args );
	if( ! $echo )
		return $output;
	echo $output;
}

add_action( 'wp_ajax_enlightenment_build_google_fonts_list', 'enlightenment_build_google_fonts_list' );

function enlightenment_build_google_fonts_list() {
	$data = json_decode( stripslashes( $_POST['data'] ), true );
	$fonts = $data['items'];
	$local = enlightenment_web_fonts();
	$output = '';
	foreach( $fonts as $font ) {
		if( array_key_exists( $font['family'], $local ) )
			continue;
		if( current_theme_supports( 'enlightenment-web-fonts', 'filter_by_subsets' ) ) {
			$continue = false;
			foreach( current_theme_supports( 'enlightenment-web-fonts', 'subsets' ) as $subset ) {
				if( ! in_array( $subset, $font['subsets'] ) ) {
					$continue = true;
				}
			}
			if( $continue )
				continue;
		}
		$output .= enlightenment_checkbox( array(
			'name' => current_theme_supports( 'enlightenment-theme-settings', 'option_name' ) . '[web_fonts][' . $font['family'] . '][family]',
			'value' => $font['family'],
			'checked' => false,
			'label' => $font['family'],
		), false );
		$output .= enlightenment_hidden_input( array(
			'name' => current_theme_supports( 'enlightenment-theme-settings', 'option_name' ) . '[web_fonts][' . $font['family'] . '][category]',
			'value' => $font['category'],
		), false );
		$output .= enlightenment_hidden_input( array(
			'name' => current_theme_supports( 'enlightenment-theme-settings', 'option_name' ) . '[web_fonts][' . $font['family'] . '][variants]',
			'value' => join( ',', $font['variants'] ),
		), false );
		$output .= enlightenment_hidden_input( array(
			'name' => current_theme_supports( 'enlightenment-theme-settings', 'option_name' ) . '[web_fonts][' . $font['family'] . '][subsets]',
			'value' => join( ',', $font['subsets'] ),
		), false );
		$output .= '<br />';
	}
	echo apply_filters( 'enlightenment_build_google_fonts_list', $output );
	die();
}

add_filter( 'enlightenment_settings_args', 'enlightenment_build_google_fonts_list_args' );

function enlightenment_build_google_fonts_list_args( $args ) {
	$args['google_api_key'] = current_theme_supports( 'enlightenment-web-fonts', 'google_api_key' );
	$args['live_preview_fonts'] = current_theme_supports( 'enlightenment-web-fonts', 'live_preview_fonts' );
	$args['sort_fonts_by'] = current_theme_supports( 'enlightenment-web-fonts', 'sort_fonts_by' );
	if( current_theme_supports( 'enlightenment-web-fonts', 'filter_by_subsets' ) )
		$args['subsets'] = current_theme_supports( 'enlightenment-web-fonts', 'subsets' );
	return $args;
}

add_filter( 'enlightenment_validate_web_fonts_theme_options', 'enlightenment_validate_web_fonts_theme_options' );

function enlightenment_validate_web_fonts_theme_options( $input ) {
	if( isset( $input['subsets'] ) ) {
		$subsets = array( 'latin', 'latin-ext', 'greek', 'greek-ext', 'cyrillic', 'cyrillic-ext', 'vietnamese' );
		foreach( $input['subsets'] as $i => $subset ) {
			if( ! in_array( $subset, $subsets ) )
				unset( $input[$i] );
		}
	}
	
	$input['filter_by_subsets'] = isset( $input['filter_by_subsets'] );
	
	$input['live_preview_fonts'] = isset( $input['live_preview_fonts'] );
	
	$sort_fonts_by = array( 'popularity', 'trending', 'alpha', 'date', 'style' );
	if( ! in_array( $input['sort_fonts_by'], $sort_fonts_by ) )
		$input['sort_fonts_by'] = current_theme_supports( 'enlightenment-web-fonts', 'sort_fonts_by' );
		
	foreach( $input['web_fonts'] as $font => $atts ) {
		if( ! isset( $atts['family'] ) ) {
			unset( $input['web_fonts'][$font] );
		} else {
			$atts['variants'] = explode( ',', $atts['variants'] );
			$atts['subsets'] = explode( ',', $atts['subsets'] );
			$input['web_fonts'][$font] = $atts;
		}
	}
	return $input;
}



