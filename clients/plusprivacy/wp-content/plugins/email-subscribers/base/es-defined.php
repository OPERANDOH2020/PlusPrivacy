<?php

// Exit if accessed directly
if ( ! defined( 'ABSPATH' ) ) {
	exit; 
}

$es_plugin_name = 'email-subscribers';
$es_plugin_folder_name = dirname(dirname(plugin_basename(__FILE__)));
$es_current_folder = dirname(dirname(__FILE__));

if(!defined('DS')) define('DS', DIRECTORY_SEPARATOR);

if(!defined('ES_TDOMAIN')) define('ES_TDOMAIN', $es_plugin_name);

if(!defined('ES_PLUGIN_NAME')) define('ES_PLUGIN_NAME', $es_plugin_name);

if(!defined('ES_PLUGIN_DISPLAY')) define('ES_PLUGIN_DISPLAY', 'Email Subscribers');

if(!defined('ES_PLG_DIR')) define('ES_PLG_DIR', dirname($es_current_folder).DS);

if(!defined('ES_DIR')) define('ES_DIR', $es_current_folder.DS);

if(!defined('ES_URL')) define('ES_URL',plugins_url().'/'.strtolower('email-subscribers').'/');

define( 'ES_FILE',ES_DIR.'email-subscribers.php' );

if(!defined('ES_FAV')) define('ES_FAV', admin_url( 'admin.php?page=es-general-information' ) );

if(!defined('ES_ADMINURL')) define( 'ES_ADMINURL', site_url( '/wp-admin/admin.php' ) );

$es_rating_text = __( 'If you like <strong>Email Subscribers</strong>, please consider leaving us a <a target="_blank" href="https://wordpress.org/support/plugin/email-subscribers/reviews/?filter=5#new-post">&#9733;&#9733;&#9733;&#9733;&#9733;</a> rating. A huge thank you from Icegram in advance!', ES_TDOMAIN );
define( 'ES_OFFICIAL', $es_rating_text );

global $es_includes;