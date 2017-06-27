<?php

// Exit if accessed directly
if ( ! defined( 'ABSPATH' ) ) {
	exit; 
}

class es_cls_compose {
	public static function es_template_select($id = 0) {

		global $wpdb;

		$arrRes = array();

		$sSql = "SELECT * FROM `".$wpdb->prefix."es_templatetable` where 1=1";
		if($id > 0) {
			$sSql = $sSql . " and es_templ_id=".$id;
			$arrRes = $wpdb->get_row($sSql, ARRAY_A);
		} else {
			$arrRes = $wpdb->get_results($sSql, ARRAY_A);
		}

		return $arrRes;
	}

	public static function es_template_select_type($type = "Newsletter") {

		global $wpdb;

		$arrRes = array();

		$sSql = $wpdb->prepare("SELECT * FROM `".$wpdb->prefix."es_templatetable` where  es_email_type = %s",  array($type));
		$arrRes = $wpdb->get_results($sSql, ARRAY_A);

		return $arrRes;
	}

	public static function es_template_count($id = 0) {

		global $wpdb;

		$result = '0';

		if($id > 0) {
			$sSql = $wpdb->prepare("SELECT COUNT(*) AS `count` FROM `".$wpdb->prefix."es_templatetable` WHERE `es_templ_id` = %d", array($id));
		} else {
			$sSql = "SELECT COUNT(*) AS `count` FROM `".$wpdb->prefix."es_templatetable`";
		}
		$result = $wpdb->get_var($sSql);

		return $result;
	}

	public static function es_template_delete($id = 0) {

		global $wpdb;

		$sSql = $wpdb->prepare("DELETE FROM `".$wpdb->prefix."es_templatetable` WHERE `es_templ_id` = %d LIMIT 1", $id);
		$wpdb->query($sSql);

		return true;
	}

	public static function es_template_ins($data = array(), $action = "insert") {

		global $wpdb;

		if($action == "insert") {
			$sSql = $wpdb->prepare("INSERT INTO `".$wpdb->prefix."es_templatetable` (`es_templ_heading`,
			`es_templ_body`, `es_templ_status`, `es_email_type`)
			VALUES(%s, %s, %s, %s)", 
			array(trim($data["es_templ_heading"]), trim($data["es_templ_body"]), trim($data["es_templ_status"]), trim($data["es_email_type"])));
		} elseif($action == "update") {
			$sSql = $wpdb->prepare("UPDATE `".$wpdb->prefix."es_templatetable` SET `es_templ_heading` = %s, `es_templ_body` = %s, 
			`es_templ_status` = %s, `es_email_type` = %s	WHERE es_templ_id = %d	LIMIT 1", 
			array($data["es_templ_heading"], $data["es_templ_body"], $data["es_templ_status"], $data["es_email_type"], $data["es_templ_id"]));
		}
		$wpdb->query($sSql);

		return true;
	}

	public static function es_template_getimage($postid=0, $size='thumbnail', $attributes='') {

		if ($images = get_children(array(
			'post_parent' => $postid,
			'post_type' => 'attachment',
			'numberposts' => 1,
			'post_mime_type' => 'image',)))
				foreach($images as $image) {
					$attachment = wp_get_attachment_image_src($image->ID, $size);
					return "<img src='". $attachment[0] . "' " . $attributes . " />";
				}

	}
}