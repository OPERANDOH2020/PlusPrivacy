<?php

// Exit if accessed directly
if ( ! defined( 'ABSPATH' ) ) {
	exit; 
}

class es_cls_sendmail {
	public static function es_prepare_optin($type= "", $id = 0, $idlist = "") {
		$subscribers = array();
		switch($type) {
			case 'group':
				$subscribers = es_cls_dbquery::es_view_subscriber_bulk($idlist);
				es_cls_sendmail::es_sendmail("optin", $template = 0, $subscribers, $action = "optin-group", "Immediately");
				break;
				
			case 'single':
				$subscribers = es_cls_dbquery::es_view_subscriber_search($search = "", $id);
				es_cls_sendmail::es_sendmail("optin", $template = 0, $subscribers, $action = "optin-single", "Immediately");
				break;
		}
		return true;
	}

	public static function es_prepare_welcome($id = 0) {
		$subscribers = array();
		$subscribers = es_cls_dbquery::es_view_subscriber_search("", $id);
		es_cls_sendmail::es_sendmail("welcome", $template = 0, $subscribers, $action = "welcome", 0, "Immediately");
	}

	public static function es_prepare_notification( $post_status, $original_post_status, $post_id ) {	
		if( ( $post_status == 'publish' ) && ( $original_post_status != 'publish' ) ) {
			$notification = array();
			
			// $post_id is Object type containing the post information 
			// Thus we need to get post_id from $post_id object
			if(is_numeric($post_id)) {
				$post_id = $post_id;
			} else {
				if(is_object($post_id)) {
					$post_id = $post_id->ID;
				} else {
					$post_id = $post_id;
				}
			}

			$notification = es_cls_notification::es_notification_prepare($post_id);

			if ( count($notification) > 0 ) {
				$template = $notification[0]["es_note_templ"];
				$mailsenttype = $notification[0]["es_note_status"];
				if($mailsenttype == "Enable") {
					$mailsenttype = "Immediately";
				} elseif($mailsenttype == "Cron") {
					$mailsenttype = "Cron";
				} else {
					$mailsenttype = "Immediately";
				}
				$subscribers = array();
				$subscribers = es_cls_notification::es_notification_subscribers($notification);
				if ( count($subscribers) > 0 ) {
					es_cls_sendmail::es_sendmail( "notification", $template, $subscribers, "Post Notification", $post_id,  $mailsenttype );
				}
			}
		}
	}

	// Function to prepare sending Static Newsletters
	public static function es_prepare_newsletter_manual( $template, $mailsenttype, $group ) {

		$subscribers = array();
		$subscribers = es_cls_dbquery::es_subscribers_data_in_group( $group );

		es_cls_sendmail::es_sendmail( "newsletter", $template, $subscribers, "Newsletter", 0, $mailsenttype );
	}

	public static function es_prepare_send_cronmail($cronmailqueue = array(), $crondeliveryqueue = array()) {
		$subscriber = array();
		$htmlmail = false;
		$wpmail = false;
		$type = $cronmailqueue[0]['es_sent_source'];
		$content = $cronmailqueue[0]['es_sent_preview'];
		$subject = $cronmailqueue[0]['es_sent_subject'];
		$cacheid = es_cls_common::es_generate_guid(100);
		$replacefrom = array("<ul><br />", "</ul><br />", "<li><br />", "</li><br />", "<ol><br />", "</ol><br />", "</h2><br />", "</h1><br />");
		$replaceto = array("<ul>", "</ul>", "<li>" ,"</li>", "<ol>", "</ol>", "</h2>", "</h1>");
		$count = 1;

		$settings = es_cls_settings::es_setting_select(1);
		if( trim($settings['es_c_fromname']) == "" || trim($settings['es_c_fromemail']) == '' ) {
			get_currentuserinfo();
			$sender_name = $user_login;
			$sender_email = $user_email;
		} else {
			$sender_name = stripslashes($settings['es_c_fromname']);
			$sender_email = $settings['es_c_fromemail'];
		}

		if( $settings['es_c_mailtype'] == "WP HTML MAIL" || $settings['es_c_mailtype'] == "PHP HTML MAIL" ) {
			$htmlmail = true;
		}

		if( $settings['es_c_mailtype'] == "WP HTML MAIL" || $settings['es_c_mailtype'] == "WP PLAINTEXT MAIL" ) { // check this code
			$wpmail = true;
		}
		
		$headers  = "From: \"$sender_name\" <$sender_email>\n";
		$headers .= "Return-Path: <" . $sender_email . ">\n";
		$headers .= "Reply-To: \"" . $sender_name . "\" <" . $sender_email . ">\n";
		$headers .= "X-Mailer: PHP" . phpversion() . "\n";

		if($htmlmail) {
			$headers .= "MIME-Version: 1.0\n";
			$headers .= "Content-Type: text/html; charset=\"". get_bloginfo('charset') . "\"\n";
		} else {
			$headers .= "MIME-Version: 1.0\n";
			$headers .= "Content-Type: text/plain; charset=\"". get_bloginfo('charset') . "\"\n";
		}

		$url = home_url('/');
		$viewstatus = '<img src="'.$url.'?es=viewstatus&delvid=###DELVIID###" width="1" height="1" />';
		
		foreach ($crondeliveryqueue as $crondelivery) {
			$es_email_id = $crondelivery['es_deliver_emailid'];
			$es_deliver_id = $crondelivery['es_deliver_id'];
			$subscriber = es_cls_dbquery::es_view_subscriber_search("", $es_email_id);
			if(count($subscriber) > 0) {
				$unsublink = $settings['es_c_unsublink'];				
				$unsublink = str_replace("###DBID###", $subscriber[0]["es_email_id"], $unsublink);
				$unsublink = str_replace("###EMAIL###", $subscriber[0]["es_email_mail"], $unsublink);
				$unsublink = str_replace("###GUID###", $subscriber[0]["es_email_guid"], $unsublink);
				$unsublink  = $unsublink . "&cache=".$cacheid;
				
				$unsubtext = stripslashes($settings['es_c_unsubtext']);
				$unsubtext = str_replace("###LINK###", $unsublink , $unsubtext);
				if ( $settings['es_c_mailtype'] == "WP HTML MAIL" || $settings['es_c_mailtype'] == "PHP HTML MAIL" ) {
					$unsubtext = '<br><br>' . $unsubtext;
				} else {
					$unsubtext = '\n\n' . $unsubtext;
				}

				$viewstslink = str_replace("###DELVIID###", $es_deliver_id, $viewstatus);
				$content_send = str_replace("###EMAIL###", $subscriber[0]["es_email_mail"], $content);
				$content_send = str_replace("###NAME###", $subscriber[0]["es_email_name"], $content_send);	
				
				if ( $settings['es_c_mailtype'] == "WP HTML MAIL" || $settings['es_c_mailtype'] == "PHP HTML MAIL" ) {
					$content_send = nl2br($content_send);
					$content_send = str_replace($replacefrom, $replaceto, $content_send);
				} else {
					$content_send = str_replace("<br />", "\r\n", $content_send);
					$content_send = str_replace("<br>", "\r\n", $content_send);
				}

				if($wpmail) {
					wp_mail($subscriber[0]["es_email_mail"], $subject, $content_send . $unsubtext . $viewstslink, $headers);
				} else {
					mail($subscriber[0]["es_email_mail"] ,$subject, $content_send . $unsubtext . $viewstslink, $headers);
				}
				es_cls_delivery::es_delivery_ups_cron($es_deliver_id);
				$count = $count + 1;
			}

			if($count % 25 == 0) {
				sleep(60); //sleep 60 seconds for every 25 emails.
			}
			
		}

		$es_cron_adminmail = get_option('es_cron_adminmail');
		if($es_cron_adminmail <> "") {
			$adminmail = $settings['es_c_adminemail'];
			$crondate = date('Y-m-d G:i:s');
			$count = $count - 1;
			$es_cron_adminmail = str_replace("###COUNT###", $count, $es_cron_adminmail);	
			$es_cron_adminmail = str_replace("###DATE###", $crondate, $es_cron_adminmail);	
			$es_cron_adminmail = str_replace("###SUBJECT###", $subject, $es_cron_adminmail);	
			
			if($htmlmail) {
				$es_cron_adminmail = nl2br($es_cron_adminmail);
			} else {
				$es_cron_adminmail = str_replace("<br />", "\r\n", $es_cron_adminmail);
				$es_cron_adminmail = str_replace("<br>", "\r\n", $es_cron_adminmail);
			}

			if($wpmail) {
				wp_mail($adminmail, "Cron URL has been triggered successfully", $es_cron_adminmail, $headers);
			} else {
				mail($adminmail ,"Cron URL has been triggered successfully", $es_cron_adminmail, $headers);
			}
		}
	}

	public static function es_sendmail($type = "", $template = 0, $subscribers = array(), $action = "", $post_id = 0, $mailsenttype = "Immediately") {
		$data = array();
		$htmlmail = true;
		$wpmail = true;
		$unsublink = "";
		$unsubtext = "";
		$sendguid = "";
		$viewstatus = "";
		$viewstslink = "";
		$adminmail = "";
		$adminmailsubject = "";
		$adminmailcontant = "";
		$reportmail = "";
		$currentdate = date('Y-m-d G:i:s');
		$cacheid = es_cls_common::es_generate_guid(100);
		$replacefrom = array("<ul><br />", "</ul><br />", "<li><br />", "</li><br />", "<ol><br />", "</ol><br />", "</h2><br />", "</h1><br />");
		$replaceto = array("<ul>", "</ul>", "<li>" ,"</li>", "<ol>", "</ol>", "</h2>", "</h1>");

		$settings = es_cls_settings::es_setting_select(1);
		$adminmail = $settings['es_c_adminemail'];
		$es_c_adminmailoption = $settings['es_c_adminmailoption'];
		$es_c_usermailoption = $settings['es_c_usermailoption'];

		if( trim($settings['es_c_fromname']) == "" || trim($settings['es_c_fromemail']) == '' ) {
			get_currentuserinfo();
			$sender_name = $user_login;
			$sender_email = $user_email;
		} else {
			$sender_name = stripslashes($settings['es_c_fromname']);
			$sender_email = $settings['es_c_fromemail'];
		}

		if( $settings['es_c_mailtype'] == "WP HTML MAIL" || $settings['es_c_mailtype'] == "PHP HTML MAIL" ) {
			$htmlmail = true;
		} else {
			$htmlmail = false;
		}

		if( $settings['es_c_mailtype'] == "WP HTML MAIL" || $settings['es_c_mailtype'] == "WP PLAINTEXT MAIL" ) {
			$wpmail = true;
		} else {
			$wpmail = false;
		}

		$headers  = "From: \"$sender_name\" <$sender_email>\n";
		$headers .= "Return-Path: <" . $sender_email . ">\n";
		$headers .= "Reply-To: \"" . $sender_name . "\" <" . $sender_email . ">\n";
		$headers .= "X-Mailer: PHP" . phpversion() . "\n";

		if($htmlmail) {
			$headers .= "MIME-Version: 1.0\n";
			$headers .= "Content-Type: text/html; charset=\"". get_bloginfo('charset') . "\"\n";
		} else {
			$headers .= "MIME-Version: 1.0\n";
			$headers .= "Content-Type: text/plain; charset=\"". get_bloginfo('charset') . "\"\n";
		}

		switch($type) {
			case 'optin':
				$subject = stripslashes($settings['es_c_optinsubject']);
				$content = stripslashes($settings['es_c_optincontent']);
				break;

			case 'welcome':
				$subject = stripslashes($settings['es_c_usermailsubject']);
				$content = stripslashes($settings['es_c_usermailcontant']);
				break;

			case 'newsletter':
				$template = es_cls_compose::es_template_select($template);
				$subject = stripslashes($template['es_templ_heading']);
				$content = stripslashes($template['es_templ_body']);
				break;

			case 'notification':
				$template = es_cls_compose::es_template_select($template);
				$subject = stripslashes($template['es_templ_heading']);
				$content = stripslashes($template['es_templ_body']);
				$post_title  = "";
				$post_excerpt  = "";
				$post_link  = "";
				$post_thumbnail  = "";
				$post_thumbnail_link  = "";
				$post = get_post($post_id);
				$excerpt_length = 50; 						// Change this value to increase the content length in newsletter.
				$post_title = $post->post_title;
				$subject = str_replace('###POSTTITLE###', $post_title, $subject);
				$post_link = get_permalink($post_id);
				$subject = str_replace('###POSTLINK###', $post_link, $subject);
				$post_date = $post->post_modified;			

				// Get full post
				$post_full = $post->post_content;
				$post_full = wpautop($post_full);

				// Get post excerpt
				$the_excerpt = $post->post_content;
				$the_excerpt = strip_tags(strip_shortcodes($the_excerpt));
				$words = explode(' ', $the_excerpt, $excerpt_length + 1);
				if(count($words) > $excerpt_length) {
					array_pop($words);
					array_push($words, '...');
					$the_excerpt = implode(' ', $words);
				}

				if ( (function_exists('has_post_thumbnail')) && (has_post_thumbnail($post_id)) ) {
					$es_post_image_size = get_option( 'es_c_post_image_size', 'full' );
					switch ( $es_post_image_size ) {
						case 'full':
							$post_thumbnail = get_the_post_thumbnail( $post_id, 'full' );
							break;
						case 'medium':
							$post_thumbnail = get_the_post_thumbnail( $post_id, 'medium' );
							break;
						case 'thumbnail':
							$post_thumbnail = get_the_post_thumbnail( $post_id, 'thumbnail' );
							break;
					}
				}

				if($post_thumbnail != "") {
					$post_thumbnail_link = "<a href='".$post_link."' target='_blank'>".$post_thumbnail."</a>";
				}

				$content = str_replace('###POSTLINK-ONLY###', $post_link, $content);

				if($post_link != "") {
					$post_link_with_title = "<a href='".$post_link."' target='_blank'>".$post_title."</a>";
					$content = str_replace('###POSTLINK-WITHTITLE###', $post_link_with_title, $content);
					
					$post_link = "<a href='".$post_link."' target='_blank'>".$post_link."</a>";
				}

				$content = str_replace('###POSTTITLE###', $post_title, $content);
				$content = str_replace('###POSTLINK###', $post_link, $content);
				$content = str_replace('###POSTIMAGE###', $post_thumbnail_link, $content);
				$content = str_replace('###POSTDESC###', $the_excerpt, $content);
				$content = str_replace('###POSTFULL###', $post_full, $content);
				$content = str_replace('###DATE###', $post_date, $content);
				break;
		}

		if ( $settings['es_c_mailtype'] == "WP HTML MAIL" || $settings['es_c_mailtype'] == "PHP HTML MAIL" ) {
			$content = str_replace("\r\n", "<br />", $content);
		} else {
			$content = str_replace("<br />", "\r\n", $content);
		}

		if($type == "newsletter" || $type == "notification") {
			$sendguid = es_cls_common::es_generate_guid(60);
			$url = home_url('/');
			$viewstatus = '<img src="'.$url.'?es=viewstatus&delvid=###DELVIID###" width="1" height="1" />';
			es_cls_sentmail::es_sentmail_ins($sendguid, $qstring = 0, $action, $currentdate, $enddt = "", count($subscribers), $content, $mailsenttype);
		}

		$count = 1;
		if(count($subscribers) > 0) {
			foreach ($subscribers as $subscriber) {
				$to = $subscriber['es_email_mail'];
				$name = $subscriber['es_email_name'];
				if($name == "") {
					$name = $to;
				}
				$group = $subscriber['es_email_group'];

				switch($type) {
					case 'optin':
						$content_send = str_replace("###NAME###", $name, $content);
						$content_send = str_replace("###EMAIL###", $to, $content_send);
						$optinlink = $settings['es_c_optinlink'];
						$optinlink = str_replace("###DBID###", $subscriber["es_email_id"], $optinlink);
						$optinlink = str_replace("###EMAIL###", $subscriber["es_email_mail"], $optinlink);
						$optinlink = str_replace("###GUID###", $subscriber["es_email_guid"], $optinlink);
						$optinlink  = $optinlink . "&cache=".$cacheid;
						$content_send = str_replace("###LINK###", $optinlink , $content_send);
						break;

					case 'welcome':
						$content_send = str_replace("###NAME###", $name, $content);
						$content_send = str_replace("###EMAIL###", $to, $content_send);
						$content_send = str_replace("###GROUP###", $group, $content_send);

						// Making an unsubscribe link
						$unsublink = $settings['es_c_unsublink'];
						$unsublink = str_replace("###DBID###", $subscriber["es_email_id"], $unsublink);
						$unsublink = str_replace("###EMAIL###", $subscriber["es_email_mail"], $unsublink);
						$unsublink = str_replace("###GUID###", $subscriber["es_email_guid"], $unsublink);
						$unsublink  = $unsublink . "&cache=".$cacheid;
						$content_send = str_replace("###LINK###", $unsublink, $content_send);

						$adminmailsubject = stripslashes($settings['es_c_adminmailsubject']);	
						$adminmailcontant = stripslashes($settings['es_c_adminmailcontant']);
						$adminmailcontant = str_replace("###NAME###", $name , $adminmailcontant);
						$adminmailcontant = str_replace("###EMAIL###", $to, $adminmailcontant);

						if ( $settings['es_c_mailtype'] == "WP HTML MAIL" || $settings['es_c_mailtype'] == "PHP HTML MAIL" ) {
							$adminmailcontant = nl2br($adminmailcontant);
							$content_send = str_replace($replacefrom, $replaceto, $content_send);
						} else {
							$adminmailcontant = str_replace("<br />", "\r\n", $adminmailcontant);
							$adminmailcontant = str_replace("<br>", "\r\n", $adminmailcontant);
						}
						break;

					case 'newsletter':
						if($mailsenttype != "Cron") { 					// Cron mail not sending by this method
							$unsublink = $settings['es_c_unsublink'];
							$unsublink = str_replace("###DBID###", $subscriber["es_email_id"], $unsublink);
							$unsublink = str_replace("###EMAIL###", $subscriber["es_email_mail"], $unsublink);
							$unsublink = str_replace("###GUID###", $subscriber["es_email_guid"], $unsublink);
							$unsublink  = $unsublink . "&cache=".$cacheid;

							$unsubtext = stripslashes($settings['es_c_unsubtext']);
							$unsubtext = str_replace("###LINK###", $unsublink , $unsubtext);
							if ( $settings['es_c_mailtype'] == "WP HTML MAIL" || $settings['es_c_mailtype'] == "PHP HTML MAIL" ) {
								$unsubtext = '<br><br>' . $unsubtext;
							} else {
								$unsubtext = '\n\n' . $unsubtext;
							}

							$returnid = es_cls_delivery::es_delivery_ins($sendguid, $subscriber["es_email_id"], $subscriber["es_email_mail"], $mailsenttype);
							$viewstslink = str_replace("###DELVIID###", $returnid, $viewstatus);
							$content_send = str_replace("###EMAIL###", $subscriber["es_email_mail"], $content);
							$content_send = str_replace("###NAME###", $subscriber["es_email_name"], $content_send);	
							
							if ( $settings['es_c_mailtype'] == "WP HTML MAIL" || $settings['es_c_mailtype'] == "PHP HTML MAIL" ) {
								$content_send = nl2br($content_send);
								$content_send = str_replace($replacefrom, $replaceto, $content_send);
							} else {
								$content_send = str_replace("<br />", "\r\n", $content_send);
								$content_send = str_replace("<br>", "\r\n", $content_send);
							}
						} else {
							es_cls_delivery::es_delivery_ins($sendguid, $subscriber["es_email_id"], $subscriber["es_email_mail"], $mailsenttype);
						}
						break;

					case 'notification':  // notification mail to subscribers
						if($mailsenttype != "Cron") { 					// Cron mail not sending by this method

							$unsublink = $settings['es_c_unsublink'];				
							$unsublink = str_replace("###DBID###", $subscriber["es_email_id"], $unsublink);
							$unsublink = str_replace("###EMAIL###", $subscriber["es_email_mail"], $unsublink);
							$unsublink = str_replace("###GUID###", $subscriber["es_email_guid"], $unsublink);
							$unsublink  = $unsublink . "&cache=".$cacheid;
							$unsubtext = stripslashes($settings['es_c_unsubtext']);
							$unsubtext = str_replace("###LINK###", $unsublink , $unsubtext);
							if ( $settings['es_c_mailtype'] == "WP HTML MAIL" || $settings['es_c_mailtype'] == "PHP HTML MAIL" ) {
								$unsubtext = '<br><br>' . $unsubtext;
							} else {
								$unsubtext = '\n\n' . $unsubtext;
							}

							$returnid = es_cls_delivery::es_delivery_ins($sendguid, $subscriber["es_email_id"], $subscriber["es_email_mail"], $mailsenttype);
							$viewstslink = str_replace("###DELVIID###", $returnid, $viewstatus);

							$content_send = str_replace("###EMAIL###", $subscriber["es_email_mail"], $content);
							$content_send = str_replace("###NAME###", $subscriber["es_email_name"], $content_send);	
							
							if ( $settings['es_c_mailtype'] == "WP HTML MAIL" || $settings['es_c_mailtype'] == "PHP HTML MAIL" ) {
								$content_send = nl2br($content_send);
								$content_send = str_replace($replacefrom, $replaceto, $content_send);
							} else {
								$content_send = str_replace("<br />", "\r\n", $content_send);
								$content_send = str_replace("<br>", "\r\n", $content_send);
							}
						} else {
							$returnid = es_cls_delivery::es_delivery_ins($sendguid, $subscriber["es_email_id"], $subscriber["es_email_mail"], $mailsenttype);
						}
						break;
				}

				if($wpmail) {  // WP Mail
					// Users mails
					if($type == "welcome") {
						if($es_c_usermailoption == "YES") {
							wp_mail($to, $subject, $content_send . $unsubtext . $viewstslink, $headers);
						}
					} else {
						if($mailsenttype != "Cron") { 					// Cron mail not sending by this method
							wp_mail($to, $subject, $content_send . $unsubtext . $viewstslink, $headers);
						}
					}

					// Admin mails
					if($type == "welcome" && $adminmail <> "" && $es_c_adminmailoption == "YES") {
						wp_mail($adminmail, $adminmailsubject, $adminmailcontant, $headers);
					}
				} else {		// PHP Mail
					// Users mails
					if($type == "welcome") {
						if($es_c_usermailoption == "YES") {
							mail($to ,$subject, $content_send . $unsubtext . $viewstslink, $headers);
						}
					} else {	
						if($mailsenttype != "Cron") { 					// Cron mail not sending by this method 
							mail($to ,$subject, $content_send . $unsubtext . $viewstslink, $headers);
						}
					}

					// Admin mails
					if($type == "welcome" && $adminmail <> "" && $es_c_adminmailoption == "YES") {
						mail($adminmail, $adminmailsubject, $adminmailcontant, $headers);
					}
				}
				$count = $count + 1;
			}
		}

		if( $type == "newsletter" || $type == "notification" ) {
			$count = $count - 1;
			es_cls_sentmail::es_sentmail_ups($sendguid, $subject);
			if($adminmail != "") {

				$subject = get_option('es_c_sentreport_subject', 'nosubjectexists');
				if ( $subject == "" || $subject == "nosubjectexists") {
					$subject = es_cls_common::es_sent_report_subject();
				}

				if($mailsenttype == "Cron") {
					$subject = $subject . " - Cron Email scheduled";
				}

				if($htmlmail) {
					$reportmail = get_option('es_c_sentreport', 'nooptionexists');
					if ( $reportmail == "" || $reportmail == "nooptionexists") {
						$reportmail = es_cls_common::es_sent_report_html();
					}
					$reportmail = nl2br($reportmail);
				} else {
					$reportmail = get_option('es_c_sentreport', 'nooptionexists');
					if ( $reportmail == "" || $reportmail == "nooptionexists") {
						$reportmail = es_cls_common::es_sent_report_plain();
					}
					$reportmail = str_replace("<br />", "\r\n", $reportmail);
					$reportmail = str_replace("<br>", "\r\n", $reportmail);
				}
				$enddate = date('Y-m-d G:i:s');
				$reportmail = str_replace("###COUNT###", $count, $reportmail);	
				$reportmail = str_replace("###UNIQUE###", $sendguid, $reportmail);	
				$reportmail = str_replace("###STARTTIME###", $currentdate, $reportmail);	
				$reportmail = str_replace("###ENDTIME###", $enddate, $reportmail);
				if($wpmail) {
					wp_mail($adminmail, $subject, $reportmail, $headers);
				} else {
					mail($adminmail ,$subject, $reportmail, $headers);
				}
			}
		}
	}
}