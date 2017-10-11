<?php
/**
 * Plugin Name: Email Subscribers & Newsletters
 * Plugin URI: https://www.icegram.com/
 * Description: Add subscription forms on website, send HTML newsletters & automatically notify subscribers about new blog posts once it is published.
 * Version: 3.3.7
 * Author: Icegram
 * Author URI: https://www.icegram.com/
 * Requires at least: 3.4
 * Tested up to: 4.8.1
 * Text Domain: email-subscribers
 * Domain Path: /languages/
 * License: GPLv3
 * License URI: http://www.gnu.org/licenses/gpl-3.0.html
 * Copyright (c) 2016, 2017 Icegram
 */

if ( preg_match('#' . basename(__FILE__) . '#', $_SERVER['PHP_SELF']) ) {
	die('You are not allowed to call this page directly.');
}

require_once(dirname(__FILE__).DIRECTORY_SEPARATOR.'base'.DIRECTORY_SEPARATOR.'es-defined.php');
require_once(dirname(__FILE__).DIRECTORY_SEPARATOR.'classes'.DIRECTORY_SEPARATOR.'es-stater.php');

add_action( 'admin_menu', array( 'es_cls_registerhook', 'es_adminmenu' ) );
add_action( 'admin_init', array( 'es_cls_registerhook', 'es_welcome' ) );
add_action( 'admin_enqueue_scripts', array( 'es_cls_registerhook', 'es_load_scripts' ) );
add_action( 'wp_enqueue_scripts', array( 'es_cls_registerhook', 'es_load_widget_scripts_styles' ) );
add_action( 'widgets_init', array( 'es_cls_registerhook', 'es_widget_loading' ) );

// Action to Upgrade Email Subscribers database
add_action( 'init', array( 'es_cls_registerhook', 'sa_email_subscribers_db_update' ) );

// Admin Notices
add_action( 'admin_notices', array( 'es_cls_registerhook', 'es_add_admin_notices' ) );

add_shortcode( 'email-subscribers', 'es_shortcode' );

add_action( 'wp_ajax_es_klawoo_subscribe', array( 'es_cls_registerhook', 'klawoo_subscribe' ) );
add_action( 'wp_ajax_es_submit_survey', array( 'es_cls_registerhook', 'es_submit_survey' ) );

require_once(dirname(__FILE__).DIRECTORY_SEPARATOR.'classes'.DIRECTORY_SEPARATOR.'es-directly.php');

add_action( 'plugins_loaded', 'es_textdomain' );
function es_textdomain() {
	load_plugin_textdomain( 'email-subscribers' , false, dirname( plugin_basename( __FILE__ ) ) . '/languages/' );
}

add_action( 'transition_post_status', array( 'es_cls_sendmail', 'es_prepare_notification' ), 10, 3 );

// To change default footer text
add_filter( 'admin_footer_text', array( 'es_cls_registerhook' , 'es_footer_text' ) );
add_filter( 'update_footer', array( 'es_cls_registerhook' , 'es_update_footer_text' ), 99 );

// Sync upcoming WordPress users
add_action( 'user_register', 'es_sync_registereduser' );

// To store current date and version in db with each update
add_action( 'upgrader_process_complete', 'es_update_current_version_and_date', 10, 2 );
function es_update_current_version_and_date( $upgrader_object, $options ) {

	// The path to our plugin's main file
	$our_plugin = plugin_basename( __FILE__ );

	// If an update has taken place and the updated type is plugins and the plugins element exists
	if( $options['action'] == 'update' && $options['type'] == 'plugin' && isset( $options['plugins'] ) ) {

		// Iterate through the plugins being updated and check if ours is there
		foreach( $options['plugins'] as $plugin ) {

			if( $plugin == $our_plugin ) {
				$es_plugin_meta_data = get_plugin_data( WP_PLUGIN_DIR.'/email-subscribers/email-subscribers.php' );
				$es_current_version = $es_plugin_meta_data['Version'];

				$timezone_format = _x('Y-m-d H:i:s', 'timezone date format');
				$es_current_date = date_i18n($timezone_format);

				$es_current_version_date_details = array(
					'es_current_version' => '',
					'es_current_date' => ''
				);

				$es_current_version_date_details['es_current_version'] = $es_current_version;
				$es_current_version_date_details['es_current_date'] = $es_current_date;

				update_option( 'ig_es_current_version_date_details', $es_current_version_date_details );
			}
		}
	}
}

register_activation_hook( ES_FILE, array( 'es_cls_registerhook', 'es_activation' ) );
register_deactivation_hook( ES_FILE, array( 'es_cls_registerhook', 'es_deactivation' ) );