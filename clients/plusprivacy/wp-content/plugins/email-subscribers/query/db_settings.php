<?php

// Exit if accessed directly
if ( ! defined( 'ABSPATH' ) ) {
	exit;
}

class es_cls_settings {
	public static function es_setting_select($id = 1) {

		global $wpdb;

		$arrRes = array();

		$sSql = "SELECT * FROM `".$wpdb->prefix."es_pluginconfig` where 1=1";
		$sSql = $sSql . " and es_c_id=".$id;
		$arrRes = $wpdb->get_row($sSql, ARRAY_A);

		return $arrRes;
	}

	public static function es_get_all_settings() {
		global $wpdb;

	 	$query = "SELECT option_name, option_value FROM {$wpdb->prefix}options WHERE option_name LIKE 'ig_es%'";
	 	$result = $wpdb->get_results( $query, ARRAY_A);

	 	$settings = array();

	 	if ( ! empty( $result ) ) {
	 		foreach ($result as $index => $data ) {
	 			$settings[ $data['option_name'] ] = $data['option_value'];
	 		}
	 	}

	 	return $settings;
	}
}