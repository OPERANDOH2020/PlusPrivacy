<?php

// Exit if accessed directly
if ( ! defined( 'ABSPATH' ) ) {
	exit; 
}

class es_cls_default {
	public static function es_pluginconfig_default() {

		global $wpdb;

		$result = es_cls_settings::es_setting_count(0);
		if ($result == 0) {
			$admin_email = get_option('admin_email');
			$blogname = get_option('blogname');

			if($admin_email == "") {
				$admin_email = "admin@gmail.com";
			}

			$home_url = home_url('/');
			$optinlink = $home_url . "?es=optin&db=###DBID###&email=###EMAIL###&guid=###GUID###";
			$unsublink = $home_url . "?es=unsubscribe&db=###DBID###&email=###EMAIL###&guid=###GUID###"; 

			$es_c_fromname = "Admin";
			$es_c_fromemail = $admin_email;
			$es_c_mailtype = "WP HTML MAIL";
			$es_c_adminmailoption = "YES";
			$es_c_adminemail = $admin_email;
			$es_c_adminmailsubject = $blogname . " New email subscription";
			$es_c_adminmailcontant = "Hi Admin, \r\n\r\nWe have received a request to subscribe new email address to receive emails from our website. \r\n\r\nEmail: ###EMAIL### \r\nName : ###NAME### \r\n\r\nThank You\r\n".$blogname;
			$es_c_usermailoption = "YES";
			$es_c_usermailsubject = $blogname . " Welcome to our newsletter";
			$es_c_usermailcontant = "Hi ###NAME###, \r\n\r\nWe have received a request to subscribe this email address to receive newsletter from our website in group ###GROUP###. \r\n\r\nThank You\r\n".$blogname." \r\n\r\n No longer interested in emails from ".$blogname."?. Please <a href='###LINK###'>click here</a> to unsubscribe";
			$es_c_optinoption = "Double Opt In";
			$es_c_optinsubject = $blogname . " confirm subscription";
			$es_c_optincontent = "Hi ###NAME###, \r\n\r\nA subscription request for this email address was received. Please confirm it by <a href='###LINK###'>clicking here</a>.\r\n\r\nIf you still cannot subscribe, please click this link : \r\n ###LINK### \r\n\r\nThank You\r\n".$blogname;
			$es_c_optinlink = $optinlink;
			$es_c_unsublink = $unsublink;
			$es_c_unsubtext = "No longer interested in emails from ".$blogname."?. Please <a href='###LINK###'>click here</a> to unsubscribe";
			$es_c_unsubhtml = "Thank You, You have been successfully unsubscribed. You will no longer hear from us.";
			$es_c_subhtml = "Thank You, You have been successfully subscribed.";
			$es_c_message1 = "Oops.. This subscription cant be completed, sorry. The email address is blocked or already subscribed. Thank you.";
			$es_c_message2 = "Oops.. We are getting some technical error. Please try again or contact admin.";

			$sSql = $wpdb->prepare("INSERT INTO `".$wpdb->prefix."es_pluginconfig` 
					(`es_c_fromname`,`es_c_fromemail`, `es_c_mailtype`, `es_c_adminmailoption`, `es_c_adminemail`, `es_c_adminmailsubject`,
					`es_c_adminmailcontant`,`es_c_usermailoption`, `es_c_usermailsubject`, `es_c_usermailcontant`, `es_c_optinoption`, `es_c_optinsubject`,
					`es_c_optincontent`,`es_c_optinlink`, `es_c_unsublink`, `es_c_unsubtext`, `es_c_unsubhtml`, `es_c_subhtml`, `es_c_message1`, `es_c_message2`)
					VALUES(%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)", 
					array($es_c_fromname,$es_c_fromemail, $es_c_mailtype, $es_c_adminmailoption, $es_c_adminemail, $es_c_adminmailsubject,
					$es_c_adminmailcontant,$es_c_usermailoption, $es_c_usermailsubject, $es_c_usermailcontant, $es_c_optinoption, $es_c_optinsubject,
					$es_c_optincontent,$es_c_optinlink, $es_c_unsublink, $es_c_unsubtext, $es_c_unsubhtml, $es_c_subhtml, $es_c_message1, $es_c_message2));
			$wpdb->query($sSql);
		}

		return true;

	}

	public static function es_subscriber_default() {

		$result = es_cls_dbquery::es_view_subscriber_count(0);
		if ($result == 0) {
			$form["es_email_mail"] = get_option('admin_email');
			$form["es_email_name"] = "Admin";
			$form["es_email_group"] = "Public";
			$form["es_email_status"] = "Confirmed";
			es_cls_dbquery::es_view_subscriber_ins($form, "insert");

			$form["es_email_mail"] = "a.example@example.com";
			$form["es_email_name"] = "Example";
			$form["es_email_group"] = "Public";
			$form["es_email_status"] = "Confirmed";
			es_cls_dbquery::es_view_subscriber_ins($form, "insert");
		}
		return true;

	}

	public static function es_template_default() {

		$result = es_cls_compose::es_template_count(0);
		if ($result == 0) {
			$form['es_templ_heading'] = 'New post published ###POSTTITLE###';
			$es_b = "Hello ###NAME###,\r\n\r\n";
			$es_b = $es_b . "We have published a new blog in our website. ###POSTTITLE###\r\n";
			$es_b = $es_b . "###POSTDESC###\r\n";
			$es_b = $es_b . "You may view the latest post at ";
			$es_b = $es_b . "###POSTLINK###\r\n";
			$es_b = $es_b . "You received this e-mail because you asked to be notified when new updates are posted.\r\n\r\n";
			$es_b = $es_b . "Thanks & Regards\r\n";
			$es_b = $es_b . "Admin";
			$form['es_templ_body'] = $es_b;
			$form['es_templ_status'] = 'Published';
			$form['es_email_type'] = 'Post Notification';
			$action = es_cls_compose::es_template_ins($form, $action = "insert");

			$form['es_templ_heading'] = 'Post notification ###POSTTITLE###';
			$es_b = "Hello ###EMAIL###,\r\n\r\n";
			$es_b = $es_b . "We have published a new blog in our website. ###POSTTITLE###\r\n";
			$es_b = $es_b . "###POSTIMAGE###\r\n";
			$es_b = $es_b . "###POSTFULL###\r\n";
			$es_b = $es_b . "You may view the latest post at ";
			$es_b = $es_b . "###POSTLINK###\r\n";
			$es_b = $es_b . "You received this e-mail because you asked to be notified when new updates are posted.\r\n\r\n";
			$es_b = $es_b . "Thanks & Regards\r\n";
			$es_b = $es_b . "Admin";
			$form['es_templ_body'] = $es_b;
			$form['es_templ_status'] = 'Published';
			$form['es_email_type'] = 'Post Notification';
			$action = es_cls_compose::es_template_ins($form, $action = "insert");

			$Sample = '<strong style="color: #990000"> Email Subscribers</strong><p>Email Subscribers plugin has options to send newsletters to subscribers. It has a separate page with HTML editor to create a HTML newsletter.'; 
			$Sample .= ' Also have options to send notification email to subscribers when new posts are published to your blog. Separate page available to include and exclude categories to send notifications.';
			$Sample .= ' Using plugin Import and Export options admins can easily import registered users and commenters to subscriptions list.</p>';
			$Sample .= ' <strong style="color: #990000">Plugin Features</strong><ol>';
			$Sample .= ' <li>Send notification email to subscribers when new posts are published.</li>';
			$Sample .= ' <li>Subscription box.</li><li>Double opt-in and single opt-in facility for subscriber.</li>';
			$Sample .= ' <li>Email notification to admin when user signs up (Optional).</li>';
			$Sample .= ' <li>Automatic welcome mail to subscriber (Optional).</li>';
			$Sample .= ' <li>Unsubscribe link in the mail.</li>';
			$Sample .= ' <li>Import/Export subscriber emails.</li>';
			$Sample .= ' <li>HTML editor to compose newsletter.</li>';
			$Sample .= ' </ol>';
			$Sample .= ' <p>Plugin live demo and video tutorial available on the official website. Check official website for more information.</p>';
			$Sample .= ' <strong>Thanks & Regards</strong><br>Admin';

			$form['es_templ_heading'] = 'Hello World Newsletter';
			$form['es_templ_body'] = $Sample;
			$form['es_templ_status'] = 'Published';
			$form['es_email_type'] = 'Newsletter';
			$action = es_cls_compose::es_template_ins($form, $action = "insert");
		}

		return true;
	}
	
	public static function es_notifications_default() {

		$result = es_cls_notification::es_notification_count(0);
		if ($result == 0) {
			$form["es_note_group"] = "Public";
			$form["es_note_status"] = "Enable";
			$form["es_note_templ"] = "1";

			$listcategory = "";
			$args = array( 'hide_empty' => 0, 'orderby' => 'name', 'order' => 'ASC' );
			$categories = get_categories($args); 
			$total = count($categories);
			$i = 1;
			foreach($categories as $category) {
				$listcategory = $listcategory . " ##" . $category->cat_name . "## ";
				if($i < $total) {
					$listcategory = $listcategory .  "--";
				}
				$i = $i + 1;
			}
			$form["es_note_cat"] = $listcategory;
			es_cls_notification::es_notification_ins($form, "insert");
		}

		return true;

	}
}