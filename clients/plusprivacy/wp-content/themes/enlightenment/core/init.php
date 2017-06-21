<?php

do_action( 'enlightenment_before_framework_init' );

function enlightenment_framework_directory() {
	return apply_filters( 'enlightenment_framework_directory', get_template_directory() . '/core' );
}

function enlightenment_functions_directory() {
	return apply_filters( 'enlightenment_functions_directory', get_template_directory() . '/core/functions' );
}

function enlightenment_admin_directory() {
	return apply_filters( 'enlightenment_functions_directory', get_template_directory() . '/core/admin' );
}

function enlightenment_languages_directory() {
	return apply_filters( 'enlightenment_languages_directory', get_template_directory() . '/core/languages' );
}

function enlightenment_styles_directory_uri() {
	return apply_filters( 'enlightenment_styles_directory_uri', get_template_directory_uri() . '/core/css' );
}

function enlightenment_scripts_directory_uri() {
	return apply_filters( 'enlightenment_scripts_directory_uri', get_template_directory_uri() . '/core/js' );
}

function enlightenment_images_directory_uri() {
	return apply_filters( 'enlightenment_images_directory_uri', get_template_directory_uri() . '/core/images' );
}

function enlightenment_fonts_directory_uri() {
	return apply_filters( 'enlightenment_fonts_directory_uri', get_template_directory_uri() . '/core/fonts' );
}

function enlightenment_head() {
	do_action( 'enlightenment_head' );
}

function enlightenment_before_page() {
	do_action( 'enlightenment_before_page' );
}

function enlightenment_before_header() {
	do_action( 'enlightenment_before_header' );
}

function enlightenment_header() {
	do_action( 'enlightenment_header' );
}

function enlightenment_after_header() {
	do_action( 'enlightenment_after_header' );
}

function enlightenment_before_container() {
	do_action( 'enlightenment_before_container' );
}

function enlightenment_before_content() {
	do_action( 'enlightenment_before_content' );
}

function enlightenment_content() {
	do_action( 'enlightenment_content' );
}

function enlightenment_after_content() {
	do_action( 'enlightenment_after_content' );
}

function enlightenment_after_container() {
	do_action( 'enlightenment_after_container' );
}

function enlightenment_comments_require_password() {
	do_action( 'enlightenment_comments_require_password' );
}

function enlightenment_before_comments() {
	do_action( 'enlightenment_before_comments' );
}

function enlightenment_comments( $args = null ) {
	if( empty( $args ) )
		$args = enlightenment_list_comments_args();
	do_action( 'enlightenment_comments', $args );
}

function enlightenment_after_comments() {
	do_action( 'enlightenment_after_comments' );
}

function enlightenment_no_comments() {
	do_action( 'enlightenment_no_comments' );
}

function enlightenment_before_sidebar() {
	do_action( 'enlightenment_before_sidebar' );
}

function enlightenment_after_sidebar() {
	do_action( 'enlightenment_after_sidebar' );
}

function enlightenment_before_widgets() {
	do_action( 'enlightenment_before_widgets' );
}

function enlightenment_after_widgets() {
	do_action( 'enlightenment_after_widgets' );
}

function enlightenment_before_footer() {
	do_action( 'enlightenment_before_footer' );
}

function enlightenment_footer() {
	do_action( 'enlightenment_footer' );
}

function enlightenment_after_footer() {
	do_action( 'enlightenment_after_footer' );
}

do_action( 'enlightenment_before_framework_functions' );

require_once( enlightenment_functions_directory() . '/general.php' );
require_once( enlightenment_functions_directory() . '/navigation.php' );
require_once( enlightenment_functions_directory() . '/content.php' );
require_once( enlightenment_functions_directory() . '/comments.php' );

add_action( 'after_setup_theme', 'enlightenment_theme_supported_functions', 30 );

function enlightenment_theme_supported_functions() {
	require_if_theme_supports( 'enlightenment-web-fonts', enlightenment_functions_directory() . '/web-fonts.php' );
	require_if_theme_supports( 'enlightenment-accessibility', enlightenment_functions_directory() . '/accessibility.php' );
	require_if_theme_supports( 'enlightenment-bootstrap', enlightenment_functions_directory() . '/bootstrap.php' );
	require_if_theme_supports( 'enlightenment-schema-markup', enlightenment_functions_directory() . '/schema-markup.php' );
	require_if_theme_supports( 'enlightenment-logo', enlightenment_functions_directory() . '/logo.php' );
	require_if_theme_supports( 'enlightenment-menu-icons', enlightenment_functions_directory() . '/menu-icons.php' );
	require_if_theme_supports( 'enlightenment-menu-descriptions', enlightenment_functions_directory() . '/menu-descriptions.php' );
	if( current_theme_supports( 'jetpack-portfolio' ) && class_exists( 'Jetpack' ) && in_array( 'custom-content-types', Jetpack::get_active_modules() ) ) {
		require_once( enlightenment_functions_directory() . '/jetpack-portfolio.php' );
	}
	require_if_theme_supports( 'enlightenment-lightbox', enlightenment_functions_directory() . '/lightbox.php' );
	require_if_theme_supports( 'enlightenment-ajax-navigation', enlightenment_functions_directory() . '/ajax-navigation.php' );
	require_if_theme_supports( 'enlightenment-infinite-scroll', enlightenment_functions_directory() . '/infinite-scroll.php' );
	require_if_theme_supports( 'custom-header', enlightenment_functions_directory() . '/custom-header.php' );
	require_if_theme_supports( 'post-thumbnails', enlightenment_functions_directory() . '/post-thumbnails.php' );
	require_if_theme_supports( 'post-formats', enlightenment_functions_directory() . '/post-formats.php' );
	require_if_theme_supports( 'enlightenment-custom-layouts', enlightenment_functions_directory() . '/custom-layouts.php' );
	require_if_theme_supports( 'enlightenment-grid-loop', enlightenment_functions_directory() . '/grid-loop.php' );
	if( current_theme_supports( 'enlightenment-template-editor' ) ) {
		require_once( enlightenment_functions_directory() . '/template-editor.php' );
		require_if_theme_supports( 'post-formats', enlightenment_functions_directory() . '/post-formats-editor.php' );
	}
	require_if_theme_supports( 'enlightenment-unlimited-sidebars', enlightenment_functions_directory() . '/unlimited-sidebars.php' );
	require_if_theme_supports( 'enlightenment-custom-queries', enlightenment_functions_directory() . '/custom-queries.php' );

	require_if_theme_supports( 'enlightenment-theme-settings', enlightenment_functions_directory() . '/settings.php' );
	
	if( is_admin() && current_theme_supports( 'enlightenment-theme-settings' ) ) {
		require_once( enlightenment_admin_directory() . '/init.php' );
	}
}

require_once( enlightenment_functions_directory() . '/default-hooks.php' );

do_action( 'enlightenment_framework_loaded' );