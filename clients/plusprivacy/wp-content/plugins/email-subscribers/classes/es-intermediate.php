<?php

// Exit if accessed directly
if ( ! defined( 'ABSPATH' ) ) {
	exit; 
}

class es_cls_intermediate {
	public static function es_subscribers() {
		global $wpdb;
		$current_page = isset($_GET['ac']) ? $_GET['ac'] : '';
		switch($current_page) {
			case 'add':
				require_once(ES_DIR.'subscribers'.DIRECTORY_SEPARATOR.'view-subscriber-add.php');
				break;
			case 'edit':
				require_once(ES_DIR.'subscribers'.DIRECTORY_SEPARATOR.'view-subscriber-edit.php');
				break;
			case 'export':
				require_once(ES_DIR.'subscribers'.DIRECTORY_SEPARATOR.'view-subscriber-export.php');
				break;
			case 'import':
				require_once(ES_DIR.'subscribers'.DIRECTORY_SEPARATOR.'view-subscriber-import.php');
				break;
			case 'sync':
				require_once(ES_DIR.'subscribers'.DIRECTORY_SEPARATOR.'view-subscriber-sync.php');
				break;
			default:
				require_once(ES_DIR.'subscribers'.DIRECTORY_SEPARATOR.'view-subscriber-show.php');
				break;
		}
	}

	public static function es_compose() {
		global $wpdb;
		$current_page = isset($_GET['ac']) ? $_GET['ac'] : '';
		switch($current_page) {
			case 'add':
				require_once(ES_DIR.'compose'.DIRECTORY_SEPARATOR.'compose-add.php');
				break;
			case 'edit':
				require_once(ES_DIR.'compose'.DIRECTORY_SEPARATOR.'compose-edit.php');
				break;
			case 'preview':
				require_once(ES_DIR.'compose'.DIRECTORY_SEPARATOR.'compose-preview.php');
				break;
			default:
				require_once(ES_DIR.'compose'.DIRECTORY_SEPARATOR.'compose-show.php');
				break;
		}
	}

	public static function es_notification() {
		global $wpdb;
		$current_page = isset($_GET['ac']) ? $_GET['ac'] : '';
		switch($current_page) {
			case 'add':
				require_once(ES_DIR.'notification'.DIRECTORY_SEPARATOR.'notification-add.php');
				break;
			case 'edit':
				require_once(ES_DIR.'notification'.DIRECTORY_SEPARATOR.'notification-edit.php');
				break;
			default:
				require_once(ES_DIR.'notification'.DIRECTORY_SEPARATOR.'notification-show.php');
				break;
		}
	}

	public static function es_sendemail() {
		require_once(ES_DIR.'sendmail'.DIRECTORY_SEPARATOR.'sendmail.php');
	}

	public static function es_settings() {
		global $wpdb;
		$current_page = isset($_GET['ac']) ? $_GET['ac'] : '';
		switch($current_page) {
			case 'add':
				require_once(ES_DIR.'settings'.DIRECTORY_SEPARATOR.'settings-add.php');
				break;
			case 'sync':
				require_once(ES_DIR.'settings'.DIRECTORY_SEPARATOR.'setting-sync.php');
				break;
			default:
				require_once(ES_DIR.'settings'.DIRECTORY_SEPARATOR.'settings-edit.php');
				break;
		}
	}

	public static function es_sentmail() {
		global $wpdb;
		$current_page = isset($_GET['ac']) ? $_GET['ac'] : '';
		switch($current_page) {
			case 'delivery':
				require_once(ES_DIR.'sentmail'.DIRECTORY_SEPARATOR.'deliverreport-show.php');
				break;
			case 'preview':
				require_once(ES_DIR.'sentmail'.DIRECTORY_SEPARATOR.'sentmail-preview.php');
				break;
			default:
				require_once(ES_DIR.'sentmail'.DIRECTORY_SEPARATOR.'sentmail-show.php');
				break;
		}
	}

	public static function es_roles() {
		global $wpdb;
		$current_page = isset($_GET['ac']) ? $_GET['ac'] : '';
		switch($current_page) {
			case 'add':
				require_once(ES_DIR.'roles'.DIRECTORY_SEPARATOR.'roles-add.php');
				break;
			case 'edit':
				require_once(ES_DIR.'roles'.DIRECTORY_SEPARATOR.'roles-edit.php');
				break;
			default:
				require_once(ES_DIR.'roles'.DIRECTORY_SEPARATOR.'roles-add.php');
				break;
		}
	}
	
	public static function es_cron() {
		global $wpdb;
		$current_page = isset($_GET['ac']) ? $_GET['ac'] : '';
		switch($current_page) {
			case 'add':
				require_once(ES_DIR.'cron'.DIRECTORY_SEPARATOR.'cron-add.php');
				break;
			case 'edit':
				require_once(ES_DIR.'cron'.DIRECTORY_SEPARATOR.'cron-edit.php');
				break;
			default:
				require_once(ES_DIR.'cron'.DIRECTORY_SEPARATOR.'cron-add.php');
				break;
		}
	}

	public static function es_information() {
		require_once(ES_DIR.'help'.DIRECTORY_SEPARATOR.'help.php');
	}
}