<?php

// Exit if accessed directly
if ( ! defined( 'ABSPATH' ) ) {
	exit; 
}

if( (isset($_GET['es'])) && ($_GET['es'] == "subscribe") ) {
	$es_email = "";
	$es_name = "";
	$es_group = "";

	// get name and email value
	$es_email = isset($_POST['es_email']) ? $_POST['es_email'] : '';
	$es_name = isset($_POST['es_name']) ? $_POST['es_name'] : '';
	$es_group = isset($_POST['es_group']) ? $_POST['es_group'] : '';

	// trim querystring value
	$es_email = trim($es_email);
	$es_name = trim($es_name);
	$es_group = trim($es_group);

	$form = array(
		'es_email_name' => '',
		'es_email_status' => '',
		'es_email_group' => '',
		'es_email_mail' => ''
	);

	if($es_group == "") {
		$es_group = "Public";
	}

	if($es_email != "")	{
		if (!filter_var($es_email, FILTER_VALIDATE_EMAIL)) {
			echo "invalid-email";
		} else {
			$homeurl = home_url();
			$samedomain = strpos($_SERVER['HTTP_REFERER'], $homeurl);
			if (($samedomain !== false) && $samedomain < 5) {
				$action = "";
				global $wpdb;

				$form['es_email_name'] = $es_name;
				$form['es_email_mail'] = $es_email;
				$form['es_email_group'] = $es_group;

				$data = es_cls_settings::es_setting_select(1);
				if( $data['es_c_optinoption'] == "Double Opt In" ) {
					$form['es_email_status'] = "Unconfirmed";
				} else {
					$form['es_email_status'] = "Single Opt In";
				}

				$action = es_cls_dbquery::es_view_subscriber_widget($form);
				if($action == "sus") {
					$subscribers = array();
					$subscribers = es_cls_dbquery::es_view_subscriber_one($es_email,$es_group);
					if( $data['es_c_optinoption'] == "Double Opt In" ) {
						es_cls_sendmail::es_sendmail("optin", $template = 0, $subscribers, "optin", 0);
						echo "subscribed-pending-doubleoptin";
					} else {
						if ( $data['es_c_usermailoption'] == "YES" ) {
							es_cls_sendmail::es_sendmail("welcome", $template = 0, $subscribers, "welcome", 0);
						}
						echo "subscribed-successfully";
					}
				}
				elseif($action == "ext") {
					echo "already-exist";
				}
			} else {
				echo "unexpected-error";
			}
		}
	}
}
die();