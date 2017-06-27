<?php

// Exit if accessed directly
if ( ! defined( 'ABSPATH' ) ) {
	exit; 
}

function es_plugin_query_vars($vars) {
	$vars[] = 'es';
	return $vars;
}
add_filter('query_vars', 'es_plugin_query_vars');

function es_plugin_parse_request($qstring) {
	if (array_key_exists('es', $qstring->query_vars)) {
		$page = $qstring->query_vars['es'];
		switch($page) {
			case 'subscribe':
				require_once(ES_DIR.'job'.DIRECTORY_SEPARATOR.'es-subscribe.php');
				break;
			case 'unsubscribe':
				require_once(ES_DIR.'job'.DIRECTORY_SEPARATOR.'es-unsubscribe.php');
				break;
			case 'viewstatus':
				require_once(ES_DIR.'job'.DIRECTORY_SEPARATOR.'es-viewstatus.php');
				break;
			case 'export':
				require_once(ES_DIR.'export'.DIRECTORY_SEPARATOR.'export-email-address.php');
				break;
			case 'optin':
				require_once(ES_DIR.'job'.DIRECTORY_SEPARATOR.'es-optin.php');
				break;
			case 'cron':
				require_once(ES_DIR.'job'.DIRECTORY_SEPARATOR.'es-cron.php');
				break;
		}
	}
}
add_action('parse_request', 'es_plugin_parse_request');