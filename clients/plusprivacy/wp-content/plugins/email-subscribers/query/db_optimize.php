<?php

// Exit if accessed directly
if ( ! defined( 'ABSPATH' ) ) {
	exit; 
}

class es_cls_optimize {
	public static function es_optimize_setdetails() {

		global $wpdb;

		$total = es_cls_sentmail::es_sentmail_count($id = 0);
		if ($total > 10) {
			$delete = $total - 10;
			$sSql = "DELETE FROM `".$wpdb->prefix."es_sentdetails` ORDER BY es_sent_id ASC LIMIT ".$delete;
			$wpdb->query($sSql);
		}

		$sSql = "DELETE FROM `".$wpdb->prefix."es_deliverreport` WHERE es_deliver_sentguid NOT IN";
		$sSql = $sSql . " (SELECT es_sent_guid FROM `".$wpdb->prefix."es_sentdetails`)";
		$wpdb->query($sSql);

		return true;
	}
}