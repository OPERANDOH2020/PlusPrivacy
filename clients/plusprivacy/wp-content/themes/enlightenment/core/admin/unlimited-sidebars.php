<?php

add_filter( 'enlightenment_theme_options_page_tabs', 'enlightenment_theme_options_sidebars_tab' );

function enlightenment_theme_options_sidebars_tab( $tabs ) {
	$tabs['sidebars'] = __( 'Sidebars', 'enlightenment' );
	return $tabs;
}

add_action( 'enlightenment_sidebars_settings_sections', 'enlightenment_sidebars_settings' );

function enlightenment_sidebars_settings() {
	remove_filter( 'enlightenment_text_input_args', 'enlightenment_theme_settings_override_value' );
	remove_filter( 'enlightenment_select_box_args', 'enlightenment_theme_settings_override_value' );
	
	if( ! isset( $_GET['template'] ) ) {
		if( ! isset( $_GET['sidebar'] ) ) {
			$sidebar_options = enlightenment_theme_option( 'sidebars' );
			$sidebars = array();
			if( ! empty( $sidebar_options ) ) {
				add_settings_section(
					'edit_dynamic_sidebars', // Unique identifier for the settings section
					__( 'Edit Dynamic Sidebars', 'enlightenment' ), // Section title
					'__return_false', // Section callback (we don't want anything)
					'enlightenment_theme_options' // Menu slug, used to uniquely identify the page
				);
				
				foreach( $sidebar_options as $sidebar => $atts ) {
					add_settings_field(
						'edit_dynamic_' . $sidebar,  // Unique identifier for the field for this section
						$atts['name'], // Setting field label
						'enlightenment_edit_dynamic_sidebar_buttons', // Function that renders the settings field
						'enlightenment_theme_options', // Menu slug, used to uniquely identify the page
						'edit_dynamic_sidebars', // Settings section. Same as the first argument in the add_settings_section() above
						array(
							'name' => $sidebar,
							'atts' => $atts,
						)
					);
				}
			}
		}
		
		if( isset( $_GET['sidebar'] ) ) {
			$sidebar = esc_attr( $_GET['sidebar'] );
			$sidebar_options = enlightenment_theme_option( 'sidebars' );
			$atts = array_merge( enlightenment_registered_sidebars_default_atts(), $sidebar_options[ $sidebar ] );
		} else {
			global $wp_registered_sidebars;
			$i = count( $wp_registered_sidebars );// + 1;
			do {
				$i++;
			} while( array_key_exists( 'sidebar-' . $i, $wp_registered_sidebars ) );
			
			$sidebar = 'sidebar-' . $i;
			
			$atts = enlightenment_registered_sidebars_default_atts();
			$atts['name'] = '';
		}
		
		add_settings_section(
			'add_dynamic_sidebar', // Unique identifier for the settings section
			isset( $_GET['sidebar'] ) ? __( 'Edit Dynamic Sidebar', 'enlightenment' ) : __( 'Add Dynamic Sidebar', 'enlightenment' ), // Section title
			'__return_false', // Section callback (we don't want anything)
			'enlightenment_theme_options' // Menu slug, used to uniquely identify the page
		);
		add_settings_field(
			'sidebar_name',  // Unique identifier for the field for this section
			__( 'Sidebar Title', 'enlightenment' ), // Setting field label
			'enlightenment_text_input', // Function that renders the settings field
			'enlightenment_theme_options', // Menu slug, used to uniquely identify the page
			'add_dynamic_sidebar', // Settings section. Same as the first argument in the add_settings_section() above
			array(
				'name' => 'sidebars[' . $sidebar . '][name]',
				'value' => $atts['name'],
			)
		);
		add_settings_field(
			'display_title',  // Unique identifier for the field for this section
			__( 'Display Sidebar Title', 'enlightenment' ), // Setting field label
			'enlightenment_checkbox', // Function that renders the settings field
			'enlightenment_theme_options', // Menu slug, used to uniquely identify the page
			'add_dynamic_sidebar', // Settings section. Same as the first argument in the add_settings_section() above
			array(
				'name' => 'sidebars[' . $sidebar . '][display_title]',
				'label' => __( 'Show Title in Sidebar', 'enlightenment' ),
				'checked' => $atts['display_title'],
			)
		);
		add_settings_field(
			'sidebar_description',  // Unique identifier for the field for this section
			__( 'Sidebar Description', 'enlightenment' ), // Setting field label
			'enlightenment_textarea', // Function that renders the settings field
			'enlightenment_theme_options', // Menu slug, used to uniquely identify the page
			'add_dynamic_sidebar', // Settings section. Same as the first argument in the add_settings_section() above
			array(
				'name' => 'sidebars[' . $sidebar . '][description]',
				'value' => $atts['description'],
			)
		);
		add_settings_field(
			'display_description',  // Unique identifier for the field for this section
			__( 'Display Sidebar Description', 'enlightenment' ), // Setting field label
			'enlightenment_checkbox', // Function that renders the settings field
			'enlightenment_theme_options', // Menu slug, used to uniquely identify the page
			'add_dynamic_sidebar', // Settings section. Same as the first argument in the add_settings_section() above
			array(
				'name' => 'sidebars[' . $sidebar . '][display_description]',
				'label' => __( 'Show Description in Sidebar', 'enlightenment' ),
				'checked' => $atts['display_description'],
			)
		);
		
		if( current_theme_supports( 'enlightenment-grid-loop' ) ) {
			add_settings_field(
				'grid',  // Unique identifier for the field for this section
				__( 'Sidebar Grid', 'enlightenment' ), // Setting field label
				'enlightenment_dynamic_sidebar_grid', // Function that renders the settings field
				'enlightenment_theme_options', // Menu slug, used to uniquely identify the page
				'add_dynamic_sidebar', // Settings section. Same as the first argument in the add_settings_section() above
				array(
					'name' => 'sidebars[' . $sidebar . '][grid]',
					'value' => $atts['grid'],
				)
			);
		}
		
		if( current_theme_supports( 'enlightenment-bootstrap' ) ) {
			add_settings_field(
				'contain_widgets',  // Unique identifier for the field for this section
				__( 'Contain Widgets', 'enlightenment' ), // Setting field label
				'enlightenment_checkbox', // Function that renders the settings field
				'enlightenment_theme_options', // Menu slug, used to uniquely identify the page
				'add_dynamic_sidebar', // Settings section. Same as the first argument in the add_settings_section() above
				array(
					'name' => 'sidebars[' . $sidebar . '][contain_widgets]',
					'label' => __( 'Center widgets in a fixed-width wrapper', 'enlightenment' ),
					'checked' => $atts['contain_widgets'],
				)
			);
		}
		
		add_settings_field(
			'sidebar_background',  // Unique identifier for the field for this section
			__( 'Sidebar Background', 'enlightenment' ), // Setting field label
			'enlightenment_background_options', // Function that renders the settings field
			'enlightenment_theme_options', // Menu slug, used to uniquely identify the page
			'add_dynamic_sidebar', // Settings section. Same as the first argument in the add_settings_section() above
			array(
				'name' => 'sidebars[' . $sidebar . '][background]',
				'value' => $atts['background'],
				'description' => __( 'When Transparent is checked, the value passed to background color will be ignored.', 'enlightenment' ),
			)
		);
		add_settings_field(
			'sidebar_title_color',  // Unique identifier for the field for this section
			__( 'Sidebar Title Color', 'enlightenment' ), // Setting field label
			'enlightenment_color_picker', // Function that renders the settings field
			'enlightenment_theme_options', // Menu slug, used to uniquely identify the page
			'add_dynamic_sidebar', // Settings section. Same as the first argument in the add_settings_section() above
			array(
				'name' => 'sidebars[' . $sidebar . '][sidebar_title_color]',
				'value' => $atts['sidebar_title_color'],
				'description' => __( 'For sidebars with a background image it is recommended to set the title color to white.', 'enlightenment' ),
			)
		);
		add_settings_field(
			'sidebar_text_color',  // Unique identifier for the field for this section
			__( 'Sidebar Text Color', 'enlightenment' ), // Setting field label
			'enlightenment_color_picker', // Function that renders the settings field
			'enlightenment_theme_options', // Menu slug, used to uniquely identify the page
			'add_dynamic_sidebar', // Settings section. Same as the first argument in the add_settings_section() above
			array(
				'name' => 'sidebars[' . $sidebar . '][sidebar_text_color]',
				'value' => $atts['sidebar_text_color'],
				'description' => __( 'For sidebars with a background image it is recommended to set the text color to white.', 'enlightenment' ),
			)
		);
		add_settings_field(
			'widgets_background_color',  // Unique identifier for the field for this section
			__( 'Widgets Background Color', 'enlightenment' ), // Setting field label
			'enlightenment_color_picker', // Function that renders the settings field
			'enlightenment_theme_options', // Menu slug, used to uniquely identify the page
			'add_dynamic_sidebar', // Settings section. Same as the first argument in the add_settings_section() above
			array(
				'name' => 'sidebars[' . $sidebar . '][widgets_background_color]',
				'value' => $atts['widgets_background_color'],
				'transparent' => true,
				'description' => __( 'When Transparent is checked, the value passed to background color will be ignored.', 'enlightenment' ),
			)
		);
		add_settings_field(
			'widgets_title_color',  // Unique identifier for the field for this section
			__( 'Widgets Headings Color', 'enlightenment' ), // Setting field label
			'enlightenment_color_picker', // Function that renders the settings field
			'enlightenment_theme_options', // Menu slug, used to uniquely identify the page
			'add_dynamic_sidebar', // Settings section. Same as the first argument in the add_settings_section() above
			array(
				'name' => 'sidebars[' . $sidebar . '][widgets_title_color]',
				'value' => $atts['widgets_title_color'],
			)
		);
		add_settings_field(
			'widgets_text_color',  // Unique identifier for the field for this section
			__( 'Widgets Text Color', 'enlightenment' ), // Setting field label
			'enlightenment_color_picker', // Function that renders the settings field
			'enlightenment_theme_options', // Menu slug, used to uniquely identify the page
			'add_dynamic_sidebar', // Settings section. Same as the first argument in the add_settings_section() above
			array(
				'name' => 'sidebars[' . $sidebar . '][widgets_text_color]',
				'value' => $atts['widgets_text_color'],
			)
		);
		add_settings_field(
			'widgets_link_color',  // Unique identifier for the field for this section
			__( 'Widgets Link Color', 'enlightenment' ), // Setting field label
			'enlightenment_color_picker', // Function that renders the settings field
			'enlightenment_theme_options', // Menu slug, used to uniquely identify the page
			'add_dynamic_sidebar', // Settings section. Same as the first argument in the add_settings_section() above
			array(
				'name' => 'sidebars[' . $sidebar . '][widgets_link_color]',
				'value' => $atts['widgets_link_color'],
			)
		);
	}
	
	if( ! isset( $_GET['sidebar'] ) ) {
		add_settings_section(
			'sidebar_locations', // Unique identifier for the settings section
			__( 'Sidebar Locations', 'enlightenment' ), // Section title
			'__return_false', // Section callback (we don't want anything)
			'enlightenment_theme_options' // Menu slug, used to uniquely identify the page
		);
		add_settings_field(
			'select_template',  // Unique identifier for the field for this section
			__( 'Select Template to Edit', 'enlightenment' ), // Setting field label
			'enlightenment_unlimited_sidebars_select_template', // Function that renders the settings field
			'enlightenment_theme_options', // Menu slug, used to uniquely identify the page
			'sidebar_locations', // Settings section. Same as the first argument in the add_settings_section() above
			array(
				'name' => 'select_template',
				'class' => 'select-template',
				'value' => enlightenment_unlimited_sidebars_current_template(),
			)
		);
		$locations = enlightenment_sidebar_locations();
		$template = enlightenment_unlimited_sidebars_current_template();
		foreach( $locations[$template] as $location => $sidebar ) {
			add_settings_field(
				'edit_sidebar_location_' . $location,  // Unique identifier for the field for this section
				$sidebar['name'], // Setting field label
				'enlightenment_edit_sidebar_location', // Function that renders the settings field
				'enlightenment_theme_options', // Menu slug, used to uniquely identify the page
				'sidebar_locations', // Settings section. Same as the first argument in the add_settings_section() above
				array(
					'name' => 'sidebar_locations[' . $template . '][' . $location . ']',
					'value' => $sidebar['sidebar'],
					'description' => '',
				)
			);
		}
	}
}

function enlightenment_edit_dynamic_sidebar( $args, $echo = true ) {
	$defaults = array(
		'class' => '',
		'id' => '',
		'value' => '',
		'placeholder' => '',
		'size' => '',
		'description' => '',
	);
	$args = wp_parse_args( $args, $defaults );
	$args = apply_filters( 'enlightenment_edit_dynamic_sidebar_args', $args );
	$description = $args['description'];
	unset( $args['description'] );
	$output = '<p>';
	$args['name'] .= '[name]';
	$args['value'] = $args['atts']['name'];
	$output .= enlightenment_text_input( $args, false );
	if( current_theme_supports( 'enlightenment-grid-loop' ) ) {
		$output .= ' ';
		$args['value'] = $args['atts']['grid'];
		$output .= enlightenment_dynamic_sidebar_grid( $args, false );
	}
	$args['name'] = str_replace( '[name]', '[delete]', $args['name'] );
	$output .= ' ';
	$output .= enlightenment_submit_button( array(
		'name' => $args['name'],
		'class' => 'button delete-sidebar',
		'value' => __( 'Delete Sidebar', 'enlightenment' ),
	), false );
	$output .= '</p>';
	$output .= empty( $description ) ? '' : '<p class="description">' . strip_tags( $description, '<a><abbr><img>' ) . '</p>';
	$output = apply_filters( 'enlightenment_edit_dynamic_sidebar', $output, $args );
	if( ! $echo )
		return $output;
	echo $output;
}

function enlightenment_edit_dynamic_sidebar_buttons( $args, $echo = true ) {
	$defaults = array(
		'class' => '',
		'id' => '',
		'value' => '',
		'placeholder' => '',
		'size' => '',
		'description' => '',
	);
	$args = wp_parse_args( $args, $defaults );
	$args = apply_filters( 'enlightenment_edit_dynamic_sidebar_args', $args );
	$description = $args['description'];
	unset( $args['description'] );
	$output = '<p>';
	global $pagenow;
	$link = admin_url( 'themes.php?page=' . current_theme_supports( 'enlightenment-theme-settings', 'menu_slug' ) . '&tab=sidebars&sidebar=' . $args['name'] );
	$output .= sprintf( '<a href="%1$s" class="button">%2$s</a>', esc_url( $link ), __( 'Edit Sidebar', 'enlightenment' ) );
	$args['name'] = 'sidebars[' . $args['name'] . '][delete]';
	$output .= ' ';
	$output .= enlightenment_submit_button( array(
		'name' => $args['name'],
		'class' => 'button delete-sidebar',
		'value' => __( 'Delete Sidebar', 'enlightenment' ),
	), false );
	$output .= '</p>';
	$output .= empty( $description ) ? '' : '<p class="description">' . strip_tags( $description, '<a><abbr><img>' ) . '</p>';
	$output = apply_filters( 'enlightenment_edit_dynamic_sidebar', $output, $args );
	if( ! $echo )
		return $output;
	echo $output;
}

function enlightenment_dynamic_sidebar_grid( $args, $echo = true ) {
	$defaults = array(
		'class' => '',
		'id' => '',
		'value' => '',
		'description' => '',
	);
	$args = wp_parse_args( $args, $defaults );
	$args = apply_filters( 'enlightenment_dynamic_sidebar_grid_args', $args );
	$args['multiple'] = false;
	$args['options'] = array();
	$grids = enlightenment_grid_columns();
	foreach( $grids as $grid => $atts )
		$args['options'][$grid] = $atts['name'];
	if( ! empty( $args['options'] ) ) {
		$name = $args['name'];
		$args['name'] = str_replace( '[name]', '[grid]', $args['name'] );
		$output = enlightenment_select_box( $args, false );
		$args['name'] = $name;
	}
	$output .= empty( $args['description'] ) ? '' : '<p class="description">' . strip_tags( $args['description'], '<a><abbr><img>' ) . '</p>';
	$output = apply_filters( 'enlightenment_dynamic_sidebar_grid', $output, $args );
	if( ! $echo )
		return $output;
	echo $output;
}

function enlightenment_edit_dynamic_sidebars( $args, $echo = true ) {
	$defaults = array(
		'class' => '',
		'sidebars' => array(),
		'description' => '',
	);
	$args = wp_parse_args( $args, $defaults );
	$args = apply_filters( 'enlightenment_edit_dynamic_sidebars_args', $args );
	$output = '';
	foreach( $args['sidebars'] as $sidebar ) {
		$sidebar['class'] = $args['class'];
		unset( $sidebar['description'] );
		$output .= enlightenment_edit_dynamic_sidebar( $sidebar, false );
	}
	$output .= empty( $args['description'] ) ? '' : '<p class="description">' . strip_tags( $args['description'], '<a><abbr><img>' ) . '</p>';
	$output = apply_filters( 'enlightenment_edit_dynamic_sidebars', $output, $args );
	if( ! $echo )
		return $output;
	echo $output;
}

function enlightenment_add_dynamic_sidebar( $args, $echo = true ) {
	$defaults = array(
		'class' => '',
		'id' => '',
		'value' => '',
		'placeholder' => '',
		'size' => '',
		'description' => '',
	);
	$args = wp_parse_args( $args, $defaults );
	$args = apply_filters( 'enlightenment_add_dynamic_sidebar_args', $args );
	$description = $args['description'];
	unset( $args['description'] );
	$args['name'] .= '[name]';
	$output = enlightenment_text_input( $args, false );
	if( current_theme_supports( 'enlightenment-grid-loop' ) ) {
		$output .= ' ';
		$output .= enlightenment_dynamic_sidebar_grid( $args, false );
	}
	$output .= ' ';
	$output .= '<input name="' . current_theme_supports( 'enlightenment-theme-settings', 'option_name' ) . '[submit-sidebars]" class="button add-sidebar" type="submit" value="Add Sidebar" />';
	$output .= empty( $description ) ? '' : '<p class="description">' . strip_tags( $description, '<a><abbr><img>' ) . '</p>';
	$output = apply_filters( 'enlightenment_add_dynamic_sidebar', $output, $args );
	if( ! $echo )
		return $output;
	echo $output;
}

function enlightenment_unlimited_sidebars_select_template( $args, $echo = true ) {
	$templates = enlightenment_unlimited_sidebars_templates();
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

function enlightenment_edit_sidebar_location( $args, $echo = true ) {
	$defaults = array(
		'class' => '',
		'id' => '',
		'value' => '',
		'description' => '',
	);
	$args = wp_parse_args( $args, $defaults );
	$args = apply_filters( 'enlightenment_edit_sidebar_location_args', $args );
	$args['multiple'] = false;
	$args['options'] = array( '' => __( '[None]', 'enlightenment' ) );
	global $wp_registered_sidebars;
	foreach( $wp_registered_sidebars as $sidebar => $atts )
		$args['options'][$sidebar] = $atts['name'];
	$output = enlightenment_select_box( $args, false );
	$output = apply_filters( 'enlightenment_edit_sidebar_location', $output, $args );
	if( ! $echo )
		return $output;
	echo $output;
}

function enlightenment_unlimited_sidebars_current_template() {
	global $pagenow;
	if( 'post.php' == $pagenow && isset( $_GET['action'] ) && 'edit' == $_GET['action'] )
		$template = get_post_type();
	elseif( isset( $_GET['template'] ) )
		$template = esc_attr( $_GET['template'] );
	else {
		$templates = enlightenment_unlimited_sidebars_templates();
		reset( $templates );
		$template = key( $templates );
	}
	return $template;
}

add_filter( 'enlightenment_validate_sidebars_theme_options', 'enlightenment_validate_unlimited_sidebars' );

function enlightenment_validate_unlimited_sidebars( $input ) {
	global $wp_registered_sidebars;
	
	if( ! isset( $input['sidebars'] ) ) {
		$input['sidebars'] = array();
	}
	
	$delete = array();
	foreach( $input['sidebars'] as $sidebar => $atts ) {
		if( isset( $input['sidebars'][$sidebar]['delete'] ) ) {
			$delete[] = $sidebar;
		}
	}
	
	foreach( $input['sidebars'] as $sidebar => $atts ) {
		if( empty( $atts['name'] ) ) {
			unset( $input['sidebars'][$sidebar] );
			continue;
		}
		
		if( 0 !== strpos( $sidebar, 'sidebar-' ) ) {
			unset( $input['sidebars'][$sidebar] );
		}
		
		if( ! is_numeric( str_replace( 'sidebar-', '', $sidebar ) ) ) {
			unset( $input['sidebars'][$sidebar] );
		}
		
		$input['sidebars'][$sidebar]['display_title'] = isset( $input['sidebars'][$sidebar]['display_title'] ) && false !== $input['sidebars'][$sidebar]['display_title'];
		
		$input['sidebars'][$sidebar]['display_description'] = isset( $input['sidebars'][$sidebar]['display_description'] ) && false !== $input['sidebars'][$sidebar]['display_description'];
		
		if( current_theme_supports( 'enlightenment-bootstrap' ) ) {
			$input['sidebars'][$sidebar]['contain_widgets'] = isset( $input['sidebars'][$sidebar]['contain_widgets'] ) && false !== $input['sidebars'][$sidebar]['contain_widgets'];
		}
		
		$input['sidebars'][$sidebar]['background'] = enlightenment_validate_background_options( $input['sidebars'][$sidebar]['background'] );
		
		$input['sidebars'][$sidebar]['sidebar_title_color'] = enlightenment_validate_color( $input['sidebars'][$sidebar]['sidebar_title_color'] );
		
		$input['sidebars'][$sidebar]['sidebar_text_color'] = enlightenment_validate_color( $input['sidebars'][$sidebar]['sidebar_text_color'] );
		
		$input['sidebars'][$sidebar]['widgets_background_color'] = enlightenment_validate_color( $input['sidebars'][$sidebar]['widgets_background_color'] );
		
		$input['sidebars'][$sidebar]['widgets_title_color'] = enlightenment_validate_color( $input['sidebars'][$sidebar]['widgets_title_color'] );
		
		$input['sidebars'][$sidebar]['widgets_text_color'] = enlightenment_validate_color( $input['sidebars'][$sidebar]['widgets_text_color'] );
		
		$input['sidebars'][$sidebar]['widgets_link_color'] = enlightenment_validate_color( $input['sidebars'][$sidebar]['widgets_link_color'] );
	}
	
	$option = enlightenment_theme_option( 'sidebars' );
	if( ! is_array( $option ) ) {
		$option = array();
	}
	
	$input['sidebars'] = array_merge( $option, $input['sidebars'] );
	
	foreach( $input['sidebars'] as $sidebar => $atts ) {
		if( in_array( $sidebar, $delete ) ) {
			unset( $input['sidebars'][$sidebar] );
		}
	}
	
	if( isset( $input['select_template'] ) ) {
		$template = $input['select_template'];
		unset( $input['select_template'] );
		
		foreach ( $input['sidebar_locations'] as $tpl => $atts ) {
			if( $tpl != $template ) {
				unset( $input['sidebar_locations'][$tpl] );
			}
		}
		
		$locations = enlightenment_sidebar_locations();
		foreach ( $input['sidebar_locations'][$template] as $location => $sidebar ) {
			if( '' != $location ) {
				if( ! array_key_exists( $location, $locations ) ) {
					unset( $input['sidebar_locations'][$location] );
				}
				
				if( ! array_key_exists( $sidebar, $wp_registered_sidebars ) ) {
					unset( $input['sidebar_locations'][$location] );
				}
			}
		}
		
		$option = enlightenment_theme_option( 'sidebar_locations', array() );
		$input['sidebar_locations'] = array_merge( $option, $input['sidebar_locations'] );
	}
	
	return $input;
}

add_action( 'add_meta_boxes', 'enlightenment_unlimited_sidebars_meta_boxes' );

function enlightenment_unlimited_sidebars_meta_boxes() {
	$post_types = array_merge( array( 'page' => 'page' ), get_post_types( array( 'publicly_queryable' => true ) ) );
	unset( $post_types['attachment'] );
	foreach( $post_types as $post_type )
		add_meta_box( 'enlightenment_unlimited_sidebars', __( 'Sidebars', 'enlightenment' ), 'enlightenment_unlimited_sidebars_form', $post_type, 'normal', 'high' );
}

function enlightenment_unlimited_sidebars_form( $post ) {
	if( ! isset( $_GET['post'] ) ) {
		_e( 'Please save this post as Draft to use Unlimited Sidebars.', 'enlightenment' );
		return;
	}
	wp_nonce_field( 'enlightenment_unlimited_sidebars_form', 'enlightenment_unlimited_sidebars_form_nonce' );
	echo '<p>';
	enlightenment_checkbox( array(
		'name' => 'enlightenment_default_sidebar_locations',
		'checked' => ( '' == get_post_meta( $post->ID, '_enlightenment_sidebar_locations', true ) ),
		'label' => sprintf( __( 'Use default sidebar locations for %1$s', 'enlightenment' ), $post->post_type ),
	) );
	echo '</p>';
	echo enlightenment_open_tag( 'div', 'sidebar-locations' );
	$sidebar_locations = enlightenment_sidebar_locations();
	$post_type = get_post_type( $_GET['post'] );
	$post_meta = get_post_meta( $post->ID, '_enlightenment_sidebar_locations', true );
	$locations = $sidebar_locations[$post_type];
	foreach( $locations as $location => $sidebar ) {
		if( isset( $post_meta[$location] ) )
			$sidebar['sidebar'] = $post_meta[$location];
		$args = array(
			'name' => 'enlightenment_sidebar_locations[' . $location . ']',
			'value' => $sidebar['sidebar'],
			'description' => '',
		);
		echo enlightenment_open_tag( 'div', 'sidebar-location' );
		echo enlightenment_open_tag( 'h3' );
		echo $sidebar['name'];
		echo enlightenment_close_tag( 'h3' );
		enlightenment_edit_sidebar_location( $args );
		echo enlightenment_close_tag();
	}
	echo enlightenment_close_tag();
}

add_action( 'save_post', 'enlightenment_unlimited_sidebars_form_save_postdata' );

function enlightenment_unlimited_sidebars_form_save_postdata( $post_id ) {
	if( ! isset( $_POST['enlightenment_sidebar_locations'] ) )
		return $post_id;
	$nonce = $_POST['enlightenment_unlimited_sidebars_form_nonce'];
	if( ! wp_verify_nonce( $nonce, 'enlightenment_unlimited_sidebars_form' ) )
		return $post_id;
	if( defined( 'DOING_AUTOSAVE' ) && DOING_AUTOSAVE )
		return $post_id;
	$post = get_post( $post_id );
	if( ! current_user_can( get_post_type_object( $post->post_type )->cap->edit_post, $post_id ) )
		return $post_id;
	if( isset( $_POST['enlightenment_default_sidebar_locations'] ) && $_POST['enlightenment_default_sidebar_locations'] ) {
		update_post_meta( $post_id, '_enlightenment_sidebar_locations', '' );
		return;
	}
	$input = $_POST['enlightenment_sidebar_locations'];
	$locations = enlightenment_sidebar_locations();
	global $wp_registered_sidebars;
	foreach ( $input as $location => $sidebar ) {
		if( '' != $location ) {
			if( ! isset( $locations[get_post_type( $post_id )] ) )
				$locations[get_post_type( $post_id )] = array();
			if( 'revision' != $post->post_type && ! array_key_exists( $location, $locations[$post->post_type] ) )
				unset( $input[$location] );
			if( ! array_key_exists( $sidebar, $wp_registered_sidebars ) )
				unset( $input[$location] );
		}
	}
	update_post_meta( $post_id, '_enlightenment_sidebar_locations', $input );
}