<?php

function enlightenment_current_template() {
	global $pagenow;
	if( 'post.php' == $pagenow && isset( $_GET['action'] ) && 'edit' == $_GET['action'] )
		$template = get_post_type();
	elseif( isset( $_GET['template'] ) )
		$template = esc_attr( $_GET['template'] );
	elseif( isset( $_GET['format'] ) )
		$template = esc_attr( $_GET['format'] );
	elseif( isset( $_GET['tab'] ) && 'post_formats' == $_GET['tab'] )
		$template = esc_attr( key( enlightenment_post_formats() ) );
	else {
		$templates = enlightenment_templates();
		reset( $templates );
		$template = key( $templates );
	}
	return $template;
}

add_action( 'admin_enqueue_scripts', 'enlightenment_template_editor_scripts' );

function enlightenment_template_editor_scripts( $page_hook ) {
	if( 'appearance_page_' . current_theme_supports( 'enlightenment-theme-settings', 'menu_slug' ) == $page_hook ) {
		wp_enqueue_script( 'jquery-ui-core' );
		wp_enqueue_script( 'jquery-ui-draggable' );
		wp_enqueue_script( 'jquery-ui-droppable' );
		wp_enqueue_script( 'jquery-ui-sortable' );
	}
}

add_filter( 'enlightenment_theme_options_page_tabs', 'enlightenment_theme_options_template_tab' );

function enlightenment_theme_options_template_tab( $tabs ) {
	$tabs['templates'] = __( 'Templates', 'enlightenment' );
	return $tabs;
}

add_action( 'enlightenment_before_theme_settings', 'enlightenment_simmulate_query' );

function enlightenment_simmulate_query( $tab ) {
	global $wp_query;
	if( doing_action( 'enlightenment_before_page_builder' ) ) {
		$post_id = $_GET['post'];
		$post = get_post( $post_id );
		if( 'page' == $post->post_type )
			$wp_query = new WP_Query( array( 'page_id' => $post->ID ) );
		elseif( 'post' == $post->post_type )
			$wp_query = new WP_Query( array( 'p' => $post->ID ) );
		else
			$wp_query = new WP_Query( array( $post->post_type => $post->slug ) );
		do_action_ref_array( 'wp', array( &$wp_query ) );
	} elseif( 'templates' == $tab ) {
		$template = enlightenment_current_template();
		// var_dump($template);
		if( 'header' == $template || 'footer' == $template )
			return;
		if( 'error404' == $template ) {
			$wp_query->is_404 = true;
		} elseif( 'search' == $template ) {
			$wp_query->is_search = true;
			$wp_query->is_archive = true;
		} elseif( 'blog' == $template || 'post-teaser' == $template ) {
			$wp_query->is_home = true;
			$wp_query->is_archive = true;
		} elseif( 'post' == $template ) {
			$posts = get_posts( array(
				'post_type' => $template,
				'meta_query' => array(
					'relation' => 'OR',
					array(
						'key'     => '_enlightenment_page_builder',
						'value'   => '',
						'compare' => '=',
					),
					array(
						'key'     => '_enlightenment_page_builder',
						'value'   => 'bug #23268',
						'compare' => 'NOT EXISTS',
					),
				),
			) );
			$wp_query = new WP_Query( array( 'p' => $posts[0]->ID, 'post_type' => $template ) );
		} elseif( 'page' == $template ) {
			$wp_query->is_page = true;
			$wp_query->is_singular = true;
		} elseif( 'author' == $template ) {
			$wp_query->is_author = true;
			$wp_query->is_archive = true;
		} elseif( 'date' == $template ) {
			$wp_query->is_date = true;
			$wp_query->is_archive = true;
		} elseif( 'category' == $template ) {
			$wp_query->is_category = true;
			$wp_query->is_archive = true;
		} elseif( 'post_tag' == $template ) {
			$wp_query->is_tag = true;
			$wp_query->is_archive = true;
		} elseif( 'comments' == $template ) {
			$wp_query->is_singular = true;
			$wp_query->is_page = true;
			$wp_query->is_single = true;
		} else {
			$atts = enlightenment_get_template( $template );
			if( 'post_type_archive' == $atts['type'] ) {
				$wp_query->is_archive = true;
				$wp_query->is_post_type_archive = true;
				$template = str_replace( '-archive', '', $template );
				$wp_query->query_vars['post_type'] = $template;
			} elseif( 'post_type' == $atts['type'] ) {
				$posts = get_posts( array(
					'post_type' => $template,
					'meta_query' => array(
						'relation' => 'OR',
						array(
							'key'     => '_enlightenment_page_builder',
							'value'   => '',
							'compare' => '=',
						),
						array(
							'key'     => '_enlightenment_page_builder',
							'value'   => 'bug #23268',
							'compare' => 'NOT EXISTS',
						),
					),
				) );
				$wp_query = new WP_Query( array( 'p' => $posts[0]->ID, 'post_type' => $template ) );
			} elseif( 'taxonomy' == $atts['type'] ) {
				$terms = get_terms( $template );
				$wp_query = new WP_Query( array( $template => $terms[0]->slug ) );
			}
		}
		do_action_ref_array( 'wp', array( &$wp_query ) );
		add_filter( 'enlightenment_is_lead_post', '__return_true' );
		if( 'post-teaser' == $template ) {
			$wp_query = new WP_Query( array( 'is_home' => true ) );
			the_post();
			add_filter( 'enlightenment_is_lead_post', '__return_false' );
			do_action( 'enlightenment_before_entry' );
		}
	}
}

add_action( 'enlightenment_after_theme_settings', 'wp_reset_query' );

add_filter( 'enlightenment_theme_option-select_template', 'enlightenment_current_template' );

add_action( 'enlightenment_templates_settings_sections', 'enlightenment_templates_settings' );

function enlightenment_templates_settings() {
	add_settings_section(
		'select_template', // Unique identifier for the settings section
		__( 'Select Template', 'enlightenment' ), // Section title
		'__return_false', // Section callback (we don't want anything)
		'enlightenment_theme_options' // Menu slug, used to uniquely identify the page
	);
	add_settings_field(
		'select_template',  // Unique identifier for the field for this section
		__( 'Select Template to Edit', 'enlightenment' ), // Setting field label
		'enlightenment_select_template', // Function that renders the settings field
		'enlightenment_theme_options', // Menu slug, used to uniquely identify the page
		'select_template', // Settings section. Same as the first argument in the add_settings_section() above
		array(
			'name' => 'select_template',
			'class' => 'select-template',
		)
	);
	add_settings_section(
		'template_hooks', // Unique identifier for the settings section
		__( 'Template Hooks', 'enlightenment' ), // Section title
		'__return_false', // Section callback (we don't want anything)
		'enlightenment_theme_options' // Menu slug, used to uniquely identify the page
	);

	remove_filter( 'enlightenment_hidden_input_args', 'enlightenment_theme_settings_override_value' );

	$template = enlightenment_get_template( enlightenment_current_template() );
	foreach( $template['hooks'] as $hook ) {
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
					'name' => 'template_hooks[' . enlightenment_current_template() . '][' . $hook . ']',
					'class' => 'template-hooks',
				)
			);
	}
}

function enlightenment_select_template( $args, $echo = true ) {
	$templates = enlightenment_templates();
	foreach( $templates as $name => $template ) {
		$templates[$name] = $template['name'];
	}
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

function enlightenment_template_hook_actions( $args, $echo = true ) {
	global $wp_filter, $pagenow;
	$hook = enlightenment_get_template_hook( $args['hook'] );
	$available_functions = apply_filters( $args['hook'] . '_available_functions', $hook['functions'] );
	$template = enlightenment_get_template( enlightenment_current_template() );
	if( current_theme_supports( 'enlightenment-page-builder' ) && 'post_type' == $template['type'] && ( 'post.php' == $pagenow || 'post-new.php' == $pagenow ) && isset( $_GET['action'] ) && 'edit' == $_GET['action'] ) {
		global $post;
		$template_hooks = array();
		$template_hooks[enlightenment_current_template()] = get_post_meta( $post->ID, '_enlightenment_page_builder', true );
		if( '' == $template_hooks )
			$template_hooks = enlightenment_theme_option( 'template_hooks' );
	} else
		$template_hooks = enlightenment_theme_option( 'template_hooks' );
	if( isset( $template_hooks[enlightenment_current_template()][$args['hook']] ) ) {
		$hooked_functions = $template_hooks[enlightenment_current_template()][$args['hook']];
	} else {
		$hooked_functions = array();
		if( isset( $wp_filter[$args['hook']] ) && isset( $wp_filter[$args['hook']][10] ) ) {
			foreach( $wp_filter[$args['hook']][10] as $function )
				$hooked_functions[] = $function['function'];
		}
	}
	$available_functions = array_diff( $available_functions, $hooked_functions );
	$output = '';
	$output .= '<div class="widget-liquid-left">';
	$output .= '<div id="widgets-left">';
	$output .= '<div id="available-widgets" class="widgets-holder-wrap available-functions-' . esc_attr( $args['hook'] ) . '">';
	
	$output .= '<div class="sidebar-name">';
	$output .= '<h3>Available Functions <span id="removing-widget">Deactivate <span></span></span></h3>';
	$output .= '</div>';

	$output .= '<div class="widget-holder">';
	$output .= '<div id="widget-list" class="widget-list">';
	foreach( $available_functions as $function ) {
		$output .= enlightenment_open_tag( 'div', 'widget', '', 'data-function="' . $function . '"' );// ui-draggable' );
		$output .= '<div class="widget-top">';
		$output .= '<div class="widget-title">';
		$output .= '<h4>' . enlightenment_template_function_name( $function ) . '</h4>';
		$output .= enlightenment_close_tag( 'div' );
		$output .= enlightenment_close_tag( 'div' );
		$output .= enlightenment_close_tag( 'div' );
	}
	$output .= '</div>';
	$output .= '</div>';

	$output .= '</div>';
	$output .= '</div>';
	$output .= '</div>';

	$output .= '<div class="widget-liquid-right">';
	$output .= '<div id="widgets-right">';
	$output .= '<div class="widgets-holder-wrap">';
	$output .= '<div id="sidebar-' . esc_attr( $args['hook'] ) . '" class="widgets-sortables hooked-functions-' . esc_attr( $args['hook'] ) . '">';

	$output .= '<div class="sidebar-name">';
	$output .= '<h3>Hooked Functions <span class="spinner"></span></h3>';
	$output .= '</div>';

	foreach( $hooked_functions as $function ) {
		$output .= enlightenment_open_tag( 'div', 'widget', '', 'data-function="' . $function . '"' );
		$output .= '<div class="widget-top">';
		$output .= '<div class="widget-title">';
		$output .= '<h4>' . enlightenment_template_function_name( $function ) . '</h4>';
		$output .= enlightenment_close_tag( 'div' );
		$output .= enlightenment_close_tag( 'div' );
		$output .= enlightenment_close_tag( 'div' );
	}
	$output .= '</div>';
	$output .= '</div>';
	$output .= '</div>';
	$output .= '</div>';
	$output .= enlightenment_hidden_input( array(
		'name' => $args['name'],
		'value' => join( ',', $hooked_functions ),
	), false );
	ob_start(); ?>
	<script>
		jQuery(document).ready(function($) {
			var submitted = false;
			$('form').submit(function() {
				submitted = true;
			});
			$('.available-functions-<?php echo esc_attr( $args['hook'] ); ?> .widget-list').sortable({
				connectWith: '.hooked-functions-<?php echo esc_attr( $args['hook'] ); ?>',
				items: '.widget',
				placeholder: "widget-placeholder",
				revert: 'invalid',
			});
			$('.hooked-functions-<?php echo esc_attr( $args['hook'] ); ?>').sortable({
				connectWith: '.available-functions-<?php echo esc_attr( $args['hook'] ); ?> .widget-list',
				items: '.widget',
				placeholder: "widget-placeholder",
				revert: 'invalid',
				activate: function(event, ui) {
					$(this).parent().addClass('widget-hover');
				},
				deactivate: function(event, ui) {
					$(this).parent().removeClass('widget-hover');
				},
				change: function(event, ui) {
					window.onbeforeunload = function(e) {
						if( ! submitted ) {
							var message = '<?php _e( 'The changes you made will be lost if you navigate away from this page.', 'enlightenment' ); ?>';
							e = e || window.event;
							// For IE and Firefox
							if(e) {
								e.returnValue = message;
							}
	
							// For Safari
							return message;
						}
					};
				},
				stop: function(event, ui) {
					if( $(ui.item).parent().hasClass('widgets-sortables') ) {
						var functions = [];
						$('.widget', $(ui.item).parent()).each(function() {
							functions.push($(this).data('function'));
						});
						$(ui.item).closest('.widget-liquid-right').next('input').val(functions.join());
					}
				},
				receive: function(event, ui) {
					var functions = [];
					$('.widget', $(ui.item).parent()).each(function() {
						functions.push($(this).data('function'));
					});
					$(ui.item).closest('.widget-liquid-right').next('input').val(functions.join());
				},
				remove: function(event, ui) {
					var functions = [];
					$('.widget', $(ui.item).closest('.widget-liquid-left').next('.widget-liquid-right')).each(function() {
						functions.push($(this).data('function'));
					});
					$(ui.item).closest('.widget-liquid-left').next('.widget-liquid-right').next('input').val(functions.join());
				},
			});
		});
	</script>
	<?php
	$output .= ob_get_clean();
	$output .= '<br style="clear:both">';
	if( ! $echo )
		return $output;
	echo $output;
}

add_filter( 'enlightenment_validate_templates_theme_options', 'enlightenment_validate_template_editor' );

function enlightenment_validate_template_editor( $input ) {
	foreach( $input['template_hooks'] as $template => $hooks ) {
		if( $template != $input['select_template'] )
			unset( $input['template_hooks'][$template] );
	}
	$template = $input['select_template'];
	unset( $input['select_template'] );
	$atts = enlightenment_get_template( $template );
	foreach( $input['template_hooks'][$template] as $hook => $functions ) {
		if( ! in_array( $hook, $atts['hooks'] ) )
			unset( $input['template_hooks'][$template][$hook] );
	}
	foreach( $input['template_hooks'][$template] as $hook => $functions ) {
		$functions = explode( ',', $functions );
		$atts = enlightenment_get_template_hook( $hook );
		foreach( $functions as $key => $function ) {
		if( ! in_array( $function, $atts['functions'] ) )
			unset( $functions[$key] );
		}
		$input['template_hooks'][$template][$hook] = $functions;
	}
	$option = enlightenment_theme_option( 'template_hooks', array() );
	$input['template_hooks'] = array_merge( $option, $input['template_hooks'] );
	return $input;
}
