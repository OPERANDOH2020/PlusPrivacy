<?php

// Exit if accessed directly
if ( ! defined( 'ABSPATH' ) ) {
	exit; 
}

class es_cls_notification {
	public static function es_notification_select($id = 0) {

		global $wpdb;

		$arrRes = array();

		$sSql = "SELECT * FROM `".$wpdb->prefix."es_notification` where 1=1";
		if($id > 0) {
			$sSql = $sSql . " and es_note_id=".$id;
			$arrRes = $wpdb->get_row($sSql, ARRAY_A);
		} else {
			$arrRes = $wpdb->get_results($sSql, ARRAY_A);
		}

		return $arrRes;

	}

	public static function es_notification_count($id = 0) {

		global $wpdb;

		$result = '0';

		if($id > 0) {
			$sSql = $wpdb->prepare("SELECT COUNT(*) AS `count` FROM `".$wpdb->prefix."es_notification` WHERE `es_note_id` = %d", array($id));
		} else {
			$sSql = "SELECT COUNT(*) AS `count` FROM `".$wpdb->prefix."es_notification`";
		}
		$result = $wpdb->get_var($sSql);

		return $result;

	}

	public static function es_notification_delete($id = 0) {

		global $wpdb;

		$sSql = $wpdb->prepare("DELETE FROM `".$wpdb->prefix."es_notification` WHERE `es_note_id` = %d LIMIT 1", $id);
		$wpdb->query($sSql);

		return true;

	}

	public static function es_notification_ins($data = array(), $action = "insert")	{

		global $wpdb;

		if($action == "insert") {
			$sSql = $wpdb->prepare("INSERT INTO `".$wpdb->prefix."es_notification` (`es_note_cat`,
			`es_note_group`, `es_note_templ`, `es_note_status`) VALUES(%s, %s, %s, %s)", 
			array($data["es_note_cat"], $data["es_note_group"], $data["es_note_templ"], $data["es_note_status"]));
		} elseif($action == "update") {
			$sSql = $wpdb->prepare("UPDATE `".$wpdb->prefix."es_notification` SET `es_note_cat` = %s, `es_note_group` = %s, `es_note_templ` = %d, 
			`es_note_status` = %s WHERE es_note_id = %d	LIMIT 1", 
			array($data["es_note_cat"], $data["es_note_group"], $data["es_note_templ"], $data["es_note_status"], $data["es_note_id"]));
		}
		$wpdb->query($sSql);

		return true;

	}

	public static function es_notification_prepare($post_id = 0) {

		global $wpdb;

		$arrNotification = array();

		if($post_id > 0) {
			$post_type = get_post_type( $post_id );
			$sSql = "SELECT * FROM `".$wpdb->prefix."es_notification` where (es_note_status = 'Enable' or es_note_status = 'Cron') ";
			if($post_type == "post") {
				$category = get_the_category( $post_id );
				$totcategory = count($category);
				if ( $totcategory > 0) {
					for($i=0; $i<$totcategory; $i++) {				
						if($i == 0) {
							$sSql = $sSql . " and (";
						} else {
							$sSql = $sSql . " or";
						}
						$sSql = $sSql . " es_note_cat LIKE '%##" . addslashes(htmlspecialchars_decode($category[$i]->cat_name)). "##%'";	// alternative addslashes(htmlspecialchars_decode(text)) = mysqli_real_escape_string but not working all the time
						if($i == ($totcategory-1)) {
							$sSql = $sSql . ")";
						}
					}
					$arrNotification = $wpdb->get_results($sSql, ARRAY_A);
				}
			} else {
				$sSql = $sSql . " and es_note_cat LIKE '%##{T}" . $post_type . "{T}##%'";
				$arrNotification = $wpdb->get_results($sSql, ARRAY_A);
			}
		}

		return $arrNotification;

	}

	public static function es_notification_subscribers($arrNotification = array()) {

		global $wpdb;

		$subscribers = array();
		$totnotification = count($arrNotification);

		if($totnotification > 0) {
			$sSql = "SELECT * FROM `".$wpdb->prefix."es_emaillist` where es_email_mail <> '' ";
			for($i=0; $i<$totnotification; $i++) {
				if($i == 0) {
					$sSql = $sSql . " and (";
				} else {
					$sSql = $sSql . " or";
				}
				$sSql = $sSql . " es_email_group = '" . $arrNotification[$i]['es_note_group']. "'";
				if($i == ($totnotification-1)) {
					$sSql = $sSql . ")";
				}
			}
			$sSql = $sSql . " and (es_email_status = 'Confirmed' or es_email_status = 'Single Opt In')";
			$sSql = $sSql . " order by es_email_mail asc";
			$subscribers = $wpdb->get_results($sSql, ARRAY_A);
		}

		return $subscribers;

	}
}