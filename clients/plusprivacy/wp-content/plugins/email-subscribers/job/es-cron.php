<?php

// Exit if accessed directly
if ( ! defined( 'ABSPATH' ) ) {
	exit;
}

if( (isset($_GET['es'])) && ($_GET['es'] == "cron") ) {

	$es_c_cronguid = isset($_GET['guid']) ? $_GET['guid'] : '';
	$es_c_cronguid = trim($es_c_cronguid);

	if($es_c_cronguid != "") {
		$security1 = strlen($es_c_cronguid);
		$es_c_cronguid_noslash = str_replace("-", "", $es_c_cronguid);
		$security2 = strlen($es_c_cronguid_noslash);
		if($security1 == 34 && $security2 == 30) {
			if ( !preg_match('/[^a-z]/', $es_c_cronguid_noslash) ) {
			   	$es_c_cronurl = get_option('ig_es_cronurl');
				$es_c_croncount = get_option('ig_es_cron_mailcount');
				parse_str($es_c_cronurl, $output);
				if($es_c_cronguid == $output['guid']) {
					if( !is_numeric($es_c_croncount) ) {	//if $es_c_croncount is coming empty, then set $es_c_croncount should be passed empty?
						$es_c_croncount = 50;
					}

					$cronmailqueue = es_cls_sentmail::es_sentmail_cronmail_inqueue();
					if(count($cronmailqueue) > 0) {
						$crondeliveryqueue = es_cls_delivery::es_delivery_cronmail_inqueue($es_c_croncount, $cronmailqueue[0]['es_sent_guid']);
						if(count($crondeliveryqueue) > 0) {
							es_cls_sendmail::es_prepare_send_cronmail($cronmailqueue, $crondeliveryqueue);
						}

						$cronmailqueuecnt = es_cls_delivery::es_delivery_cronmail_count($cronmailqueue[0]['es_sent_guid']);
						if($cronmailqueuecnt == 0) {
							es_cls_sentmail::es_sentmail_cronmail_ups($cronmailqueue[0]['es_sent_guid']);
						}
					}
				}
			}
		}
	}
}
die();