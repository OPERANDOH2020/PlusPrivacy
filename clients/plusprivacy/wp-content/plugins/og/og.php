<?php
/*
Plugin Name: OG
Plugin URI: http://iworks.pl/
Description: Very tiny Open Graph plugin - add featured image as facebook image. This plugin do not have any configuration - you can check how it works looking into page source.
Text Domain: og
Version: 2.4.7
Author: Marcin Pietrzak
Author URI: http://iworks.pl/
License: GNU GPL
 */

require_once dirname( __FILE__ ) .'/vendor/iworks/opengraph.php';
new iworks_opengraph();

include_once dirname( __FILE__ ) .'/vendor/iworks/rate/rate.php';
do_action(
	'iworks-register-plugin',
	plugin_basename( __FILE__ ),
    __( 'OG', 'og' ),
    'og'
);
