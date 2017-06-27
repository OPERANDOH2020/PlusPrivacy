<?php

// Exit if accessed directly
if ( ! defined( 'ABSPATH' ) ) {
	exit; 
}

if( ( isset($_GET['es']) ) && $_GET['es'] == "viewstatus" ) {
	$form = array();
	$form['delvid'] = isset($_GET['delvid']) ? $_GET['delvid'] : 0;
	if(is_numeric($form['delvid'])) {
		es_cls_delivery::es_delivery_ups($form['delvid']);
	}
}
die();