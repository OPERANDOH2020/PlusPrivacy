<?php

// Exit if accessed directly
if ( ! defined( 'ABSPATH' ) ) {
	exit; 
}

class es_cls_dbquery {
	public static function es_view_subscriber_search($search = "", $id = 0) {

		global $wpdb;

		$arrRes = array();

		$sSql = "SELECT * FROM `".$wpdb->prefix."es_emaillist` where es_email_mail != '' ";
		if($search != "" && $search != "ALL") {
			$letter = explode(',', $search);
			$length = count($letter);
			for ($i = 0; $i < $length; $i++) {
				if($i == 0) {
					$sSql = $sSql . " and";
				} else {
					$sSql = $sSql . " or";
				}
				$sSql = $sSql . " es_email_mail LIKE '" . $letter[$i]. "%'";
			}
		}
		if($id > 0) {
			$sSql = $sSql . " and es_email_id=".$id;
			
		}
		$sSql = $sSql . " order by es_email_id asc";
		$arrRes = $wpdb->get_results($sSql, ARRAY_A);

		return $arrRes;
	}

	// Query to fetch subscribers data on view subscribers screen
	public static function es_view_subscribers_details($id = 0, $search_sts = "", $offset = 0, $limit = 0, $search_group = "") {

		global $wpdb;

		$view_subscribers_details = array();

		$sSql = "SELECT * FROM `".$wpdb->prefix."es_emaillist` WHERE es_email_mail != '' ";
		if($search_sts != "") {
			$sSql = $sSql . " and es_email_status='".$search_sts."'";
		}

		if($search_group != "" && $search_group != "ALL") {
			$sSql = $sSql . ' and es_email_group="'.$search_group.'"';
		}

		if($id > 0) {
			$sSql = $sSql . " and es_email_id=".$id;
			
		}
		$sSql = $sSql . " order by es_email_id desc";
		$sSql = $sSql . " LIMIT $offset, $limit";
		$view_subscribers_details = $wpdb->get_results($sSql, ARRAY_A);

		return $view_subscribers_details;
	}


	public static function es_view_subscriber_delete($id = 0) {

		global $wpdb;

		$sSql = $wpdb->prepare("DELETE FROM `".$wpdb->prefix."es_emaillist` WHERE `es_email_id` = %d LIMIT 1", $id);
		$wpdb->query($sSql);

		return true;
	}

	public static function es_view_subscriber_ins($data = array(), $action = "insert") {

		global $wpdb;

		$result = 0;

		if (!filter_var($data["es_email_mail"], FILTER_VALIDATE_EMAIL)) {
			return "invalid";
		}

		$es_subscriber_name = sanitize_text_field(esc_attr($data["es_email_name"]));
		$es_subscriber_status = sanitize_text_field(esc_attr($data["es_email_status"]));
		$es_subscriber_group = sanitize_text_field(esc_attr($data["es_email_group"]));
		$es_subscriber_email = sanitize_email(esc_attr($data["es_email_mail"]));

		$CurrentDate = date('Y-m-d G:i:s');
		if($action == "insert") {
			$sSql = "SELECT * FROM `".$wpdb->prefix."es_emaillist` where es_email_mail='".$es_subscriber_email."' and es_email_group='".trim($es_subscriber_group)."'";
			$result = $wpdb->get_var($sSql);
			if ( $result > 0) {
				return "ext";
			} else {
				$guid = es_cls_common::es_generate_guid(60);
				$sql = $wpdb->prepare("INSERT INTO `".$wpdb->prefix."es_emaillist` 
						(`es_email_name`,`es_email_mail`, `es_email_status`, `es_email_created`, `es_email_viewcount`, `es_email_group`, `es_email_guid`)
						VALUES(%s, %s, %s, %s, %d, %s, %s)", array(trim($es_subscriber_name), trim($es_subscriber_email), 
						trim($es_subscriber_status), $CurrentDate, 0, trim($es_subscriber_group), $guid));
				$wpdb->query($sql);

				/* Added from ES v3.1.5 - If subscribing via Rainmaker
				 * if double opt-in, send confirmation email to subscriber
				 * if single opt-in, send welcome email to subscriber
				 */
				$active_plugins = (array) get_option('active_plugins', array());
				if (is_multisite()) {
					$active_plugins = array_merge($active_plugins, get_site_option('active_sitewide_plugins', array()));
				}

				if (( in_array('icegram-rainmaker/icegram-rainmaker.php', $active_plugins) || array_key_exists('icegram-rainmaker/icegram-rainmaker.php', $active_plugins) )) {			// To Do- Handle via actions

					$es_settings = es_cls_settings::es_setting_select();
					$subscribers = array();
					$subscribers = self::es_view_subscriber_one($es_subscriber_email,$es_subscriber_group);

					if( did_action( 'rainmaker_post_lead' ) >= 1 ) {
						if ( (!empty($es_settings['es_c_optinoption'])) && ($es_settings['es_c_optinoption'] == 'Double Opt In') ) {
							es_cls_sendmail::es_sendmail("optin", $template = 0, $subscribers, "optin", 0);
						} else if ( (!empty($es_settings['es_c_optinoption'])) && ($es_settings['es_c_optinoption'] == 'Single Opt In' ) ) {
							es_cls_sendmail::es_sendmail("welcome", $template = 0, $subscribers, "welcome", 0);
						}
					}
				}
				return "sus";
			}
		} elseif($action == "update") {
			$sSql = "SELECT * FROM `".$wpdb->prefix."es_emaillist` where es_email_mail='".$es_subscriber_email."'"; 
			$sSql = $sSql . " and es_email_group='".trim($es_subscriber_group)."' and es_email_id != ".$data["es_email_id"];
			$result = $wpdb->get_var($sSql);
			if ( $result > 0) {
				return "ext";
			} else {
				$sSql = $wpdb->prepare("UPDATE `".$wpdb->prefix."es_emaillist` SET `es_email_name` = %s, `es_email_mail` = %s,
						`es_email_status` = %s, `es_email_group` = %s WHERE es_email_id = %d LIMIT 1", array($es_subscriber_name, $es_subscriber_email, 
						$es_subscriber_status, $es_subscriber_group, $data["es_email_id"]));
				$wpdb->query($sSql);
				return "sus";
			}
		}
	}

	public static function es_view_subscriber_bulk($idlist = "") {

		global $wpdb;

		$arrRes = array();

		$sSql = "SELECT * FROM `".$wpdb->prefix."es_emaillist` where es_email_mail <> '' ";
		if($idlist != "") {
			$sSql = $sSql . " and es_email_id in (" . $idlist. ");";
		}
		$arrRes = $wpdb->get_results($sSql, ARRAY_A);

		return $arrRes;
	}

	public static function es_view_subscriber_group() {

		global $wpdb;

		$arrRes = array();

		$sSql = "SELECT distinct(es_email_group) FROM `".$wpdb->prefix."es_emaillist`";
		$arrRes = $wpdb->get_results($sSql, ARRAY_A);

		return $arrRes;
	}

	public static function es_view_subscriber_one($mail = "", $group = "") {

		global $wpdb;

		$arrRes = array();

		$sSql = "SELECT * FROM `".$wpdb->prefix."es_emaillist` WHERE es_email_mail = '".$mail."' AND es_email_group = '".$group."'";
		$arrRes = $wpdb->get_results($sSql, ARRAY_A);

		return $arrRes;
	}

	public static function es_view_subscriber_upd_status($status = "", $idlist = "") {

		global $wpdb;

		$sSql = "UPDATE `".$wpdb->prefix."es_emaillist` SET `es_email_status` = '".$status."'";
		$sSql = $sSql . " WHERE es_email_id IN (".$idlist.")";
		$wpdb->query($sSql);

		return "sus";
	}

	public static function es_view_subscriber_upd_group($group = "", $idlist = "") {

		global $wpdb;

		$sSql = "UPDATE `".$wpdb->prefix."es_emaillist` SET `es_email_group` = '".$group."'";
		$sSql = $sSql . " WHERE es_email_id IN (".$idlist.")";
		$wpdb->query($sSql);

		return "sus";
	}

	public static function es_view_subscriber_job($status = "", $id = 0, $guid = "", $email = "") {

		global $wpdb;

		$sSql = "SELECT COUNT(*) AS `count` FROM `".$wpdb->prefix."es_emaillist`";
		$sSql = $sSql . " WHERE es_email_id = %d";
		$sSql = $sSql . " and es_email_mail = %s";
		$sSql = $sSql . " and es_email_guid = %s Limit 1";
		$sSql = $wpdb->prepare($sSql, array($id, $email, $guid));
		$result = $wpdb->get_var($sSql);

		if ( $result > 0 ) {
			$sSql = "UPDATE `".$wpdb->prefix."es_emaillist` SET `es_email_status` = %s";
			$sSql = $sSql . " WHERE es_email_mail = %s Limit 10";
			$sSql = $wpdb->prepare($sSql, array($status, $email));
			$wpdb->query($sSql);
			return true;
		} else {
			return false;
		}
	}

	public static function es_view_subscriber_jobstatus($status = "", $id = 0, $guid = "", $email = "") {

		global $wpdb;

		$sSql = "SELECT COUNT(*) AS `count` FROM `".$wpdb->prefix."es_emaillist`";
		$sSql = $sSql . " WHERE es_email_id = %d";
		$sSql = $sSql . " and es_email_mail = %s";
		$sSql = $sSql . " and es_email_status = %s";
		$sSql = $sSql . " and es_email_guid = %s Limit 1";
		$sSql = $wpdb->prepare($sSql, array($id, $email, $status, $guid));
		$result = $wpdb->get_var($sSql);

		if ( $result > 0) {
			return true;
		} else {
			return false;
		}
	}

	public static function es_view_subscriber_widget($data = array()) {

		global $wpdb;

		$arrRes = array();
		$currentdate = date('Y-m-d G:i:s');

		$sSql = "SELECT * FROM `".$wpdb->prefix."es_emaillist` where es_email_mail='".$data["es_email_mail"]."' and es_email_group='".trim($data["es_email_group"])."'";
		$arrRes = $wpdb->get_results($sSql, ARRAY_A);

		if ( !empty( $arrRes ) && count($arrRes) > 0 ) {
			if( $arrRes[0]['es_email_status'] == "Confirmed" || $arrRes[0]['es_email_status'] == "Single Opt In" ) {
				return "ext";
			} else {
				$action = "";
				$form['es_email_name'] = sanitize_text_field(esc_attr($data["es_email_name"]));
				$form['es_email_mail'] = sanitize_email(esc_attr($data["es_email_mail"]));
				$form['es_email_group'] = sanitize_text_field(esc_attr($data["es_email_group"]));
				$form['es_email_status'] = sanitize_text_field(esc_attr($data["es_email_status"]));
				$form['es_email_id'] = $arrRes[0]["es_email_id"];
				$action = es_cls_dbquery::es_view_subscriber_ins($form, $action = "update");
				return $action;
			}
		} else {
			$action = es_cls_dbquery::es_view_subscriber_ins($data, $action = "insert");
			return $action;
		}
	}

	// Query to fetch count of subscribers from a particular group
	public static function es_subscriber_count_in_group( $groups = "" ) {

		global $wpdb;

		$sSql = "SELECT COUNT(*) AS `count` FROM `".$wpdb->prefix."es_emaillist` WHERE es_email_group = '".$groups."' AND ( es_email_status = 'Confirmed' OR es_email_status = 'Single Opt In' )";
		$total_subscribers = $wpdb->get_var( $sSql );

		return $total_subscribers;

	}

	// Query to fetch all subscribers data from a particular group
	public static function es_subscribers_data_in_group( $group = "" ) {

		global $wpdb;

		$subscribers_in_group = array();

		$sSql = "SELECT * FROM  `".$wpdb->prefix."es_emaillist` WHERE es_email_group = '".$group."' AND ( es_email_status = 'Confirmed' OR es_email_status = 'Single Opt In' ) ";
		$subscribers_in_group = $wpdb->get_results( $sSql, ARRAY_A );

		return $subscribers_in_group;

	}

	// Query to fetch subscribers count (all status)
	public static function es_view_subscriber_count( $id = 0 ) {

		global $wpdb;

		$result = '0';

		if($id > 0) {
			$sSql = $wpdb->prepare("SELECT COUNT(*) AS `count` FROM `".$wpdb->prefix."es_emaillist` WHERE `es_email_id` = %d", array($id));
		} else {
			$sSql = "SELECT COUNT(*) AS `count` FROM `".$wpdb->prefix."es_emaillist`";
		}

		$result = $wpdb->get_var( $sSql );

		return $result;

	}

	// Query to fetch active subscribers (status = Confirmed / Single Opt In)
	public static function es_active_subscribers() {

		global $wpdb;

		$active_subscribers_count = '0';

		$sSql = "SELECT COUNT(*) AS `count` FROM ". $wpdb->prefix . "es_emaillist WHERE es_email_status IN ( 'Confirmed', 'Single Opt In' )";
		$active_subscribers_count = $wpdb->get_var( $sSql );

		return $active_subscribers_count;

	}

	// Query to fetch inactive subscribers (status = Unconfirmed / Unsubscribed)
	public static function es_inactive_subscribers() {

		global $wpdb;

		$inactive_subscribers_count = '0';

		$sSql = "SELECT COUNT(*) AS `count` FROM ". $wpdb->prefix . "es_emaillist WHERE es_email_status IN ( 'Unconfirmed', 'Unsubscribed' )";
		$inactive_subscribers_count = $wpdb->get_var( $sSql );

		return $inactive_subscribers_count;

	}

}