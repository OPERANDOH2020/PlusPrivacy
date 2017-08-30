<?php
/*
Plugin Name: SMNTCS Google Webmaster Tools
Description: Adds <a href="https://www.google.com/webmasters/tools/">Google Webmaster Tools</a> to your site.
Version: 2.0.1
Author: Niels Lange
Author URI: http://www.nielslange.de
Text Domain: smntcs-google-webmaster-tools
Domain Path: /languages/ 
*/

/*  Copyright 2014-2016	Niels Lange (email : info@nielslange.de)

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
*/


// Avoid direct plugin access
if ( !defined( 'ABSPATH' ) ) exit;

// Load text domain
add_action('plugins_loaded', 'smntcs_google_webmaster_tools_load_textdomain');
function smntcs_google_webmaster_tools_load_textdomain() {
	load_plugin_textdomain( 'smntcs-google-webmaster-tools', false, dirname( plugin_basename(__FILE__) ) . '/languages/' );
}

// Add Adobe Typekit Fonts to WordPress Customizer
add_action( 'customize_register', 'smntcs_google_webmaster_tools_register_customize' );
function smntcs_google_webmaster_tools_register_customize( $wp_customize ) {
	$wp_customize->add_section( 'smntcs_google_webmaster_tools_section', array(
		'priority' 	=> 150,
		'title' 	=> __('Google Search Console', 'smntcs-google-webmaster-tools'),
	));

	$wp_customize->add_setting( 'smntcs_google_webmaster_tools_tracking_code', array(
		'type'		=> 'option',
	));

	$wp_customize->add_control( 'smntcs_google_webmaster_tools_tracking_code', array(
		'label' 	=> __('Verification code', 'smntcs-google-webmaster-tools'),
		'section' 	=> 'smntcs_google_webmaster_tools_section',
		'type' 		=> 'textarea',
	));
}

// Add settings link on plugin page
add_filter("plugin_action_links_" . plugin_basename(__FILE__), 'smntcs_google_webmaster_tools_settings_link' );
function smntcs_google_webmaster_tools_settings_link($links) {
	$admin_url = admin_url( 'customize.php?autofocus[control]=smntcs_google_webmaster_tools_tracking_code' );
	$settings_link =  '<a href="' . $admin_url . '">' . __('Settings', 'smntcs-google-webmaster-tools') . '</a>';
	array_unshift($links, $settings_link);
	return $links;
}

// Load Adobe Typekit Fonts code and custom CSS
add_action('wp_head', 'smntcs_google_webmaster_tools_enqueue');
function smntcs_google_webmaster_tools_enqueue() {
	if ( get_option('smntcs_google_webmaster_tools_tracking_code') ) {
		print(get_option('smntcs_google_webmaster_tools_tracking_code') . "\n");
	}
}