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

	public static function es_setting_count($id = "") {

		global $wpdb;

		$result = '0';

		if($id > 0) {
			$sSql = $wpdb->prepare("SELECT COUNT(*) AS `count` FROM `".$wpdb->prefix."es_pluginconfig` WHERE `es_c_id` = %s", array($id));
		} else {
			$sSql = "SELECT COUNT(*) AS `count` FROM `".$wpdb->prefix."es_pluginconfig`";
		}
		$result = $wpdb->get_var($sSql);

		return $result;
	}

	public static function es_setting_update($data = array()) {

		global $wpdb;

		$sSql = $wpdb->prepare("UPDATE `".$wpdb->prefix."es_pluginconfig` SET 
			`es_c_fromname` = %s, `es_c_fromemail` = %s, `es_c_mailtype` = %s, `es_c_adminmailoption` = %s, 
			`es_c_adminemail` = %s, `es_c_adminmailsubject` = %s, `es_c_adminmailcontant` = %s, `es_c_usermailoption` = %s, 
			`es_c_usermailsubject` = %s, `es_c_usermailcontant` = %s, `es_c_optinoption` = %s, `es_c_optinsubject` = %s, 
			`es_c_optincontent` = %s, `es_c_optinlink` = %s, `es_c_unsublink` = %s, `es_c_unsubtext` = %s, 
			`es_c_unsubhtml` = %s, `es_c_subhtml` = %s, `es_c_message1` = %s, `es_c_message2` = %s 
			WHERE es_c_id = %d	LIMIT 1", 
			array($data["es_c_fromname"], $data["es_c_fromemail"], $data["es_c_mailtype"], $data["es_c_adminmailoption"], 
			$data["es_c_adminemail"], $data["es_c_adminmailsubject"], $data["es_c_adminmailcontant"], $data["es_c_usermailoption"],
			$data["es_c_usermailsubject"], $data["es_c_usermailcontant"], $data["es_c_optinoption"], $data["es_c_optinsubject"], 
			$data["es_c_optincontent"], $data["es_c_optinlink"], $data["es_c_unsublink"], $data["es_c_unsubtext"], 
			$data["es_c_unsubhtml"], $data["es_c_subhtml"], $data["es_c_message1"], $data["es_c_message2"], 
			$data["es_c_id"]));
		$wpdb->query($sSql);

		return "sus";
	}
}