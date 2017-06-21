<?php

add_action( 'after_setup_theme', 'enlightenment_settings_theme_support_args', 999 );

function enlightenment_settings_theme_support_args() {
	global $_wp_theme_features;
	$defaults = array(
		'page_title' => __( 'Theme Options', 'enlightenment' ),
		'menu_title' => __( 'Theme Options', 'enlightenment' ),
		'menu_slug' => 'enlightenment_theme_options',
		'function' => 'enlightenment_theme_options_page',
		'option_group' => 'enlightenment_theme_options',
		'sanitize_callback' => 'enlightenment_validate_theme_options',
		'updated_message' => __( 'Theme settings updated successfully.', 'enlightenment' ),
		'save_settings' => __( 'Save Settings', 'enlightenment' ),
		'reset_settings' => __( 'Reset Defaults', 'enlightenment' ),
		'tabs' => array(
			'general' => __( 'General', 'enlightenment' )
		),
	);
	$args = get_theme_support( 'enlightenment-theme-settings' );
	if( is_array( $args ) )
		$args = array_shift( $args );
	else
		$args = $_wp_theme_features['enlightenment-theme-settings'] = array();
	$args = wp_parse_args( $args, $defaults );
	$_wp_theme_features['enlightenment-theme-settings'][0] = $args;
}

add_filter( 'current_theme_supports-enlightenment-theme-settings', 'enlightenment_filter_current_theme_supports', 10, 3 );

add_action( 'admin_menu', 'enlightenment_theme_page' );

function enlightenment_theme_page() {
	add_theme_page(
		current_theme_supports( 'enlightenment-theme-settings', 'page_title' ),
		current_theme_supports( 'enlightenment-theme-settings', 'menu_title' ),
		'edit_theme_options',
		current_theme_supports( 'enlightenment-theme-settings', 'menu_slug' ),
		current_theme_supports( 'enlightenment-theme-settings', 'function' )
	);
}

add_action( 'admin_init', 'enlightenment_register_settings' );

function enlightenment_register_settings() {
	$option_name = current_theme_supports( 'enlightenment-theme-settings', 'option_name' );
	if( empty( $option_name ) ) {
		_doing_it_wrong( __FUNCTION__, 'Please specify an Option Name for your Theme Setings.', '' );
		return;
	}
	register_setting(
		current_theme_supports( 'enlightenment-theme-settings', 'option_group' ),
		current_theme_supports( 'enlightenment-theme-settings', 'option_name' ),
		current_theme_supports( 'enlightenment-theme-settings', 'sanitize_callback' )
	);
}

add_action( 'admin_enqueue_scripts', 'enlightenment_theme_options_scripts' );

function enlightenment_theme_options_scripts( $page_hook ) {
	if( 'appearance_page_' . current_theme_supports( 'enlightenment-theme-settings', 'menu_slug' ) == $page_hook || 'post.php' == $page_hook ) {
		wp_enqueue_style( 'enlightenment_theme_options_style', enlightenment_styles_directory_uri() . '/settings.css' );
	}
	wp_enqueue_script( 'enlightenment_theme_options_script', enlightenment_scripts_directory_uri() . '/settings.js' );
	$tabs = enlightenment_theme_options_page_tabs();
	$args = apply_filters( 'enlightenment_settings_args', array(
		'admin_url' => admin_url(),
		'menu_slug' => current_theme_supports( 'enlightenment-theme-settings', 'menu_slug' ),
		'current_tab' => isset( $_GET['tab'] ) ? esc_attr( $_GET['tab'] ) : key( $tabs ),
	) );
	if( ! empty( $args ) )
		wp_localize_script( 'enlightenment_theme_options_script', 'enlightenment_settings_args', $args );
	if( current_theme_supports( 'enlightenment-custom-layouts' ) && ( 'post.php' == $page_hook || 'post-new.php' == $page_hook ) ) {
		wp_enqueue_style( 'enlightenment_edit_post_style', enlightenment_styles_directory_uri() . '/edit-post.css' );
		wp_enqueue_script( 'enlightenment_edit_post_script', enlightenment_scripts_directory_uri() . '/edit-post.js' );
	}
}

add_action( 'admin_init', 'enlightenment_theme_options_init' );

function enlightenment_theme_options_init() {
	global $pagenow;
	$tabs = enlightenment_theme_options_page_tabs();
	if( isset( $_GET['tab'] ) )
		$tab =  esc_attr( $_GET['tab'] );
	elseif( isset( $_POST[current_theme_supports( 'enlightenment-theme-settings', 'option_name' )]['tab'] ) )
		$tab = esc_attr( $_POST[current_theme_supports( 'enlightenment-theme-settings', 'option_name' )]['tab'] );
	else {
		reset( $tabs );
		$tab = key( $tabs );
	}
	do_action( "enlightenment_{$tab}_settings_sections" );
}

function enlightenment_theme_options_page_tabs() {
	$tabs = current_theme_supports( 'enlightenment-theme-settings', 'tabs' );
	
	return apply_filters( 'enlightenment_theme_options_page_tabs', $tabs );
}

function enlightenment_theme_options_page() { ?>
	<div class="wrap">
		<?php echo enlightenment_theme_options_page_title(); ?>
		<?php if ( isset( $_GET['settings-updated'] ) ) : ?>
			<div class='updated'><p><?php echo current_theme_supports( 'enlightenment-theme-settings', 'updated_message' ); ?></p></div>
		<?php endif; ?>
		<?php $tabs = enlightenment_theme_options_page_tabs();
		if( isset( $_GET['tab'] ) )
			$tab = esc_attr( $_GET['tab'] );
		else {
			reset( $tabs );
			$tab = key( $tabs );
		} ?>
		<form action="options.php" method="post">
			<?php settings_fields( current_theme_supports( 'enlightenment-theme-settings', 'option_group' ) ); ?>
			<?php do_action( 'enlightenment_before_theme_settings', $tab ); ?>
			<?php do_settings_sections( current_theme_supports( 'enlightenment-theme-settings', 'menu_slug' ) ); ?>
			<?php do_action( 'enlightenment_after_theme_settings', $tab ); ?>
			<p>&nbsp;</p>
			<?php $tab = '-' . $tab; ?>
			<input type="submit" class="button-primary" id="submit" value="<?php echo current_theme_supports( 'enlightenment-theme-settings', 'save_settings' ); ?>" />
			<input name="<?php echo current_theme_supports( 'enlightenment-theme-settings', 'option_name' ); ?>[reset_settings]" type="submit" class="button-secondary" id="reset" value="<?php echo current_theme_supports( 'enlightenment-theme-settings', 'reset_settings' ); ?>" />
		</form>
	</div>
<?php
}

function enlightenment_theme_options_page_title() {
	$tabs = enlightenment_theme_options_page_tabs();
	if( isset( $_GET['tab'] ) )
		$current =  esc_attr( $_GET['tab'] );
	else {
		reset( $tabs );
		$current = key( $tabs );
	}
	$output = '<div id="icon-themes" class="icon32"><br /></div>';
	if( 1 < count( $tabs ) ) {
		$output .= '<h2 class="nav-tab-wrapper">';
		$links = array();
		foreach( $tabs as $tab => $name )
			$links[] = "<a class='nav-tab" . ( $tab == $current ? ' nav-tab-active' : '' ) ."' href='?page=enlightenment_theme_options&tab=$tab'>$name</a>";
		foreach ( $links as $link )
			$output .= $link;
	} else {
		$output .= '<h2>';
		$output .= current_theme_supports( 'enlightenment-theme-settings', 'page_title' );
	}
	$output .= '</h2>';
	return apply_filters( 'enlightenment_theme_options_page_title', $output, $tabs );
}

add_action( 'enlightenment_before_theme_settings', 'enlightenment_hidden_tab_field' );

function enlightenment_hidden_tab_field( $tab ) {
	remove_filter( 'enlightenment_hidden_input_args', 'enlightenment_theme_settings_override_value' );
	enlightenment_hidden_input( array( 'name' => 'tab', 'value' => $tab ) );
	add_filter( 'enlightenment_hidden_input_args', 'enlightenment_theme_settings_override_value' );
}

add_filter( 'enlightenment_hidden_input_name', 'enlightenment_wrap_theme_settings_name' );
add_filter( 'enlightenment_text_input_name', 'enlightenment_wrap_theme_settings_name' );
add_filter( 'enlightenment_checkbox_name', 'enlightenment_wrap_theme_settings_name' );
add_filter( 'enlightenment_radio_buttons_name', 'enlightenment_wrap_theme_settings_name' );
add_filter( 'enlightenment_select_box_name', 'enlightenment_wrap_theme_settings_name' );
add_filter( 'enlightenment_textarea_name', 'enlightenment_wrap_theme_settings_name' );
add_filter( 'enlightenment_submit_button_name', 'enlightenment_wrap_theme_settings_name' );

function enlightenment_wrap_theme_settings_name( $name ) {
	global $pagenow;
	if( empty( $name ) )
		return $name;
	if( 'themes.php' == $pagenow && isset( $_GET['page'] ) && current_theme_supports( 'enlightenment-theme-settings', 'menu_slug' ) == $_GET['page'] ) {
		if( false !== strpos( $name, '[' ) ) {
			$opt  = substr( $name, 0, strpos( $name, '[' ) );
			$name = str_replace( $opt, current_theme_supports( 'enlightenment-theme-settings', 'option_name' ) . '[' . esc_attr( $opt ) . ']', $name );
		} else {
			$name = current_theme_supports( 'enlightenment-theme-settings', 'option_name' ) . '[' . esc_attr( $name ) . ']';
		}
	}
	return $name;
}

add_filter( 'enlightenment_hidden_input_args', 'enlightenment_theme_settings_override_value' );
add_filter( 'enlightenment_text_input_args', 'enlightenment_theme_settings_override_value' );
add_filter( 'enlightenment_checkbox_args', 'enlightenment_theme_settings_override_value' );
add_filter( 'enlightenment_radio_buttons_args', 'enlightenment_theme_settings_override_value' );
add_filter( 'enlightenment_select_box_args', 'enlightenment_theme_settings_override_value' );
add_filter( 'enlightenment_textarea_args', 'enlightenment_theme_settings_override_value' );
add_filter( 'enlightenment_upload_media_args', 'enlightenment_theme_settings_override_value' );

function enlightenment_theme_settings_override_value( $args ) {
	global $pagenow;
	if( 'themes.php' == $pagenow && isset( $_GET['page'] ) && current_theme_supports( 'enlightenment-theme-settings', 'menu_slug' ) == $_GET['page'] ) {
		if( false === strpos( $args['name'], '[' ) ) {
			if( doing_filter( 'enlightenment_checkbox_args' ) && empty( $args['checked'] ) ) {
				$checkbox = enlightenment_theme_option( $args['name'] );
				$args['checked'] = ! empty( $checkbox );
			} elseif( empty( $args['value'] ) ) {
				$args['value'] = enlightenment_theme_option( $args['name'] );
			}
		}
	}
	return $args;
}

require_once( enlightenment_admin_directory() . '/settings-api.php' );

require_if_theme_supports( 'enlightenment-web-fonts', enlightenment_admin_directory() . '/web-fonts.php' );
require_if_theme_supports( 'enlightenment-logo', enlightenment_admin_directory() . '/logo.php' );
require_if_theme_supports( 'enlightenment-menu-icons', enlightenment_admin_directory() . '/menu-icons.php' );
require_if_theme_supports( 'enlightenment-custom-layouts', enlightenment_admin_directory() . '/custom-layouts.php' );
require_if_theme_supports( 'enlightenment-grid-loop', enlightenment_admin_directory() . '/grid-loop.php' );
if( current_theme_supports( 'enlightenment-template-editor' ) ) {
	require_once( enlightenment_admin_directory() . '/template-editor.php' );
	require_if_theme_supports( 'enlightenment-page-builder', enlightenment_admin_directory() . '/page-builder.php' );
	require_if_theme_supports( 'post-formats', enlightenment_admin_directory() . '/post-formats-editor.php' );
}
require_if_theme_supports( 'enlightenment-unlimited-sidebars', enlightenment_admin_directory() . '/unlimited-sidebars.php' );

require_once( enlightenment_admin_directory() . '/validate.php' );



