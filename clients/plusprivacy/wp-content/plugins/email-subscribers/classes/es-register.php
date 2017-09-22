<?php

// Exit if accessed directly
if ( ! defined( 'ABSPATH' ) ) {
	exit;
}

class es_cls_registerhook {
	public static function es_activation() {
		global $wpdb;

		add_option('email-subscribers', "2.9");

		// Creating default tables
		global $wpdb;

		$charset_collate = '';
		$charset_collate = $wpdb->get_charset_collate();

		$es_default_tables = "CREATE TABLE {$wpdb->prefix}es_emaillist (
									es_email_id INT unsigned NOT NULL AUTO_INCREMENT,
									es_email_name VARCHAR(255) NOT NULL,
									es_email_mail VARCHAR(255) NOT NULL,
									es_email_status VARCHAR(25) NOT NULL default 'Unconfirmed',
									es_email_created datetime NOT NULL default '0000-00-00 00:00:00',
									es_email_viewcount VARCHAR(100) NOT NULL,
									es_email_group VARCHAR(255) NOT NULL default 'Public',
									es_email_guid VARCHAR(255) NOT NULL,
									PRIMARY KEY  (es_email_id)
									) $charset_collate;
								CREATE TABLE {$wpdb->prefix}es_templatetable (
									es_templ_id INT unsigned NOT NULL AUTO_INCREMENT,
									es_templ_heading VARCHAR(255) NOT NULL,
									es_templ_body TEXT NULL,
									es_templ_status VARCHAR(25) NOT NULL default 'Published',
									es_email_type VARCHAR(100) NOT NULL default 'Newsletter',
									es_templ_slug VARCHAR(255) NULL,
									PRIMARY KEY  (es_templ_id)
								) $charset_collate;
								CREATE TABLE {$wpdb->prefix}es_notification (
									es_note_id INT unsigned NOT NULL AUTO_INCREMENT,
									es_note_cat TEXT NULL,
									es_note_group VARCHAR(255) NOT NULL,
									es_note_templ INT unsigned NOT NULL,
									es_note_status VARCHAR(10) NOT NULL default 'Enable',
									PRIMARY KEY  (es_note_id)
								) $charset_collate;
								CREATE TABLE {$wpdb->prefix}es_sentdetails (
									es_sent_id INT unsigned NOT NULL AUTO_INCREMENT,
									es_sent_guid VARCHAR(255) NOT NULL,
									es_sent_qstring VARCHAR(255) NOT NULL,
									es_sent_source VARCHAR(255) NOT NULL,
									es_sent_starttime datetime NOT NULL default '0000-00-00 00:00:00',
									es_sent_endtime datetime NOT NULL default '0000-00-00 00:00:00',
									es_sent_count INT unsigned NOT NULL,
									es_sent_preview TEXT NULL,
									es_sent_status VARCHAR(25) NOT NULL default 'Sent',
									es_sent_type VARCHAR(25) NOT NULL default 'Immediately',
									es_sent_subject VARCHAR(255) NOT NULL,
									PRIMARY KEY  (es_sent_id)
								) $charset_collate;
								CREATE TABLE {$wpdb->prefix}es_deliverreport (
									es_deliver_id INT unsigned NOT NULL AUTO_INCREMENT,
									es_deliver_sentguid VARCHAR(255) NOT NULL,
									es_deliver_emailid INT unsigned NOT NULL,
									es_deliver_emailmail VARCHAR(255) NOT NULL,
									es_deliver_sentdate datetime NOT NULL default '0000-00-00 00:00:00',
									es_deliver_status VARCHAR(25) NOT NULL,
									es_deliver_viewdate datetime NOT NULL default '0000-00-00 00:00:00',
									es_deliver_sentstatus VARCHAR(25) NOT NULL default 'Sent',
									es_deliver_senttype VARCHAR(25) NOT NULL default 'Immediately',
									PRIMARY KEY  (es_deliver_id)
								) $charset_collate;
							";

		require_once( ABSPATH . 'wp-admin/includes/upgrade.php' );
		dbDelta( $es_default_tables );

		$es_default_table_names = array( 'es_emaillist', 'es_templatetable', 'es_notification', 'es_sentdetails', 'es_deliverreport' );

		$es_has_errors = false;
		$es_missing_tables = array();
		foreach($es_default_table_names as $table_name) {
			if(strtoupper($wpdb->get_var("SHOW TABLES like  '". $wpdb->prefix.$table_name . "'")) != strtoupper($wpdb->prefix.$table_name)) {
				$es_missing_tables[] = $wpdb->prefix.$table_name;
			}
		}

		if($es_missing_tables) {
			$errors[] = __( 'These tables could not be created on installation ' . implode(', ',$es_missing_tables), 'email-subscribers' );
			$es_has_errors = true;
		}

		// if error call wp_die()
		if($es_has_errors) {
			wp_die( __( $errors[0] , 'email-subscribers' ) );
			return false;
		} else {
			// Inserting dummy data on first activation
			es_cls_default::es_pluginconfig_default();
			es_cls_default::es_subscriber_default();
			es_cls_default::es_template_default();
			es_cls_default::es_notifications_default();
		}

		if ( ! is_network_admin() && ! isset( $_GET['activate-multi'] ) ) {
			set_transient( '_es_activation_redirect', 1, 30 );
		}

		return true;
	}

	/**
	 * Sends user to the help & info page on activation.
	 */
	public static function es_welcome() {

		if ( ! get_transient( '_es_activation_redirect' ) ) {
			return;
		}

		// Delete the redirect transient
		delete_transient( '_es_activation_redirect' );

		wp_redirect( admin_url( 'admin.php?page=es-general-information' ) );
		exit;
	}

	public static function es_synctables() {
		$es_c_email_subscribers_ver = get_option( "email-subscribers" );

		if( $es_c_email_subscribers_ver != "2.9" ) {

			$guid = es_cls_common::es_generate_guid(60);
			$home_url = home_url('/');
			$blogname = get_option('blogname');
			$cronurl = $home_url . "?es=cron&guid=". $guid;

			add_option( "ig_es_cronurl", $cronurl );
			add_option( "ig_es_cron_mailcount", "50" );
			add_option( "ig_es_cron_adminmail", "Hi Admin,\r\n\r\nCron URL has been triggered successfully on ###DATE### for the email ###SUBJECT###. And it sent email to ###COUNT### recipient(s).\r\n\r\nBest,\r\n".$blogname."" );

			update_option( "email-subscribers", "2.9" );
		}
	}

	public static function es_deactivation() {
		// do not generate any output here
	}

	public static function es_admin_option() {
		// do not generate any output here
	}

	public static function es_adminmenu() {
		$es_c_rolesandcapabilities = get_option('ig_es_rolesandcapabilities', 'norecord');
		if($es_c_rolesandcapabilities == 'norecord' || $es_c_rolesandcapabilities == "") {
			$es_roles_subscriber = "manage_options";
			$es_roles_mail = "manage_options";
			$es_roles_notification = "manage_options";
			$es_roles_sendmail = "manage_options";
			$es_roles_sentmail = "manage_options";
		} else {
			$es_roles_subscriber = $es_c_rolesandcapabilities['es_roles_subscriber'];
			$es_roles_mail = $es_c_rolesandcapabilities['es_roles_mail'];
			$es_roles_notification = $es_c_rolesandcapabilities['es_roles_notification'];
			$es_roles_sendmail = $es_c_rolesandcapabilities['es_roles_sendmail'];
			$es_roles_sentmail = $es_c_rolesandcapabilities['es_roles_sentmail'];
		}

		add_menu_page( __( 'Email Subscribers', 'email-subscribers' ),
			__( 'Email Subscribers', 'email-subscribers' ), 'admin_dashboard', 'email-subscribers', array( 'es_cls_registerhook', 'es_admin_option'), 'dashicons-email', 51 );

		add_submenu_page('email-subscribers', __( 'Subscribers', ES_TDOMAIN ),
			__( 'Subscribers', ES_TDOMAIN ), $es_roles_subscriber, 'es-view-subscribers', array( 'es_cls_intermediate', 'es_subscribers' ));

		add_submenu_page('email-subscribers', __( 'Compose', ES_TDOMAIN ),
			__( 'Compose', ES_TDOMAIN ), $es_roles_mail, 'es-compose', array( 'es_cls_intermediate', 'es_compose' ));

		add_submenu_page('email-subscribers', __( 'Post Notifications', ES_TDOMAIN ),
			__( 'Post Notifications', ES_TDOMAIN ), $es_roles_notification, 'es-notification', array( 'es_cls_intermediate', 'es_notification' ));

		add_submenu_page('email-subscribers', __( 'Newsletters', ES_TDOMAIN ),
			__( 'Newsletters', ES_TDOMAIN ), $es_roles_sendmail, 'es-sendemail', array( 'es_cls_intermediate', 'es_sendemail' ));

		add_submenu_page('email-subscribers', __( 'Settings', ES_TDOMAIN ),
			__( 'Settings', ES_TDOMAIN ), 'manage_options', 'es-settings', array( 'es_cls_intermediate', 'es_settings' ));

		add_submenu_page('email-subscribers', __( 'Reports', ES_TDOMAIN ),
			__( 'Reports', ES_TDOMAIN ), $es_roles_sentmail, 'es-sentmail', array( 'es_cls_intermediate', 'es_sentmail' ));

		add_submenu_page('email-subscribers', __( 'Help & Info', ES_TDOMAIN ),
			__( '<span style="color:#f18500;font-weight:bolder;">Help & Info</span>', ES_TDOMAIN ), 'edit_posts', 'es-general-information', array( 'es_cls_intermediate', 'es_information' ));
	}

	public static function es_load_scripts() {

		if( !empty( $_GET['page'] ) ) {
			switch ( $_GET['page'] ) {
				case 'es-view-subscribers':
					wp_register_script( 'es-view-subscribers', ES_URL . 'subscribers/view-subscriber.js', '', '', true );
					wp_enqueue_script( 'es-view-subscribers' );
					$es_select_params = array(
						'es_subscriber_email'           => _x( 'Please enter subscriber email address.', 'view-subscriber-enhanced-select', ES_TDOMAIN ),
						'es_subscriber_email_status'    => _x( 'Please select subscriber email status.', 'view-subscriber-enhanced-select', ES_TDOMAIN ),
						'es_subscriber_group'           => _x( 'Please select or create group for this subscriber.', 'view-subscriber-enhanced-select', ES_TDOMAIN ),
						'es_subscriber_delete_record'   => _x( 'Do you want to delete this record?', 'view-subscriber-enhanced-select', ES_TDOMAIN ),
						'es_subscriber_bulk_action'     => _x( 'Please select the bulk action.', 'view-subscriber-enhanced-select', ES_TDOMAIN ),
						'es_subscriber_confirm_delete'  => _x( 'Are you sure you want to delete selected records?', 'view-subscriber-enhanced-select', ES_TDOMAIN ),
						'es_subscriber_resend_email'    => _x( 'Do you want to resend confirmation email? \nAlso please note, this will update subscriber current status to \'Unconfirmed\'.', 'view-subscriber-enhanced-select', ES_TDOMAIN ),
						'es_subscriber_new_group'       => _x( 'Please select new subscriber group.', 'view-subscriber-enhanced-select', ES_TDOMAIN ),
						'es_subscriber_new_status'	    => _x( 'Please select new status for subscribers', 'view-subscriber-enhanced-select', ES_TDOMAIN ),
						'es_subscriber_group_update'    => _x( 'Do you want to update subscribers group?', 'view-subscriber-enhanced-select', ES_TDOMAIN ),
						'es_subscriber_status_update'	=> _x( 'Do you want to update subscribers status?', 'view-subscriber-enhanced-select', ES_TDOMAIN ),
						'es_subscriber_csv_file'        => _x( 'Please select only csv file. Please check official website for csv structure..', 'view-subscriber-enhanced-select', ES_TDOMAIN )
					);
					wp_localize_script( 'es-view-subscribers', 'es_view_subscriber_notices', $es_select_params );
					break;
				case 'es-compose':
					wp_register_script( 'es-compose', ES_URL . 'compose/compose.js', '', '', true );
					wp_enqueue_script( 'es-compose' );
					$es_select_params = array(
						'es_configuration_name'     => _x( 'Please enter the Email Subject.', 'compose-enhanced-select', ES_TDOMAIN ),
						'es_compose_delete_record'  => _x( 'Do you want to delete this record?', 'compose-enhanced-select', ES_TDOMAIN )
					);
					wp_localize_script( 'es-compose', 'es_compose_notices', $es_select_params );
					break;
				case 'es-notification':
					wp_register_script( 'es-notification', ES_URL . 'notification/notification.js', '', '', true );
					wp_enqueue_script( 'es-notification' );
					$es_select_params = array(
						'es_notification_select_group'  => _x( 'Please select subscribers group.', 'notification-enhanced-select', ES_TDOMAIN ),
						'es_notification_mail_subject'  => _x( 'Please select notification mail subject. Use compose menu to create new.', 'notification-enhanced-select', ES_TDOMAIN ),
						'es_notification_status'        => _x( 'Please select notification status.', 'notification-enhanced-select', ES_TDOMAIN ),
						'es_notification_delete_record' => _x( 'Do you want to delete this record?', 'notification-enhanced-select', ES_TDOMAIN )
					);
					wp_localize_script( 'es-notification', 'es_notification_notices', $es_select_params );
					break;
				case 'es-sendemail':
					wp_register_script( 'sendmail', ES_URL . 'sendmail/sendmail.js', '', '', true );
					wp_enqueue_script( 'sendmail' );
					$es_select_params = array(
						'es_sendmail_subject'  => _x( 'Please select your mail subject.', 'sendmail-enhanced-select', ES_TDOMAIN ),
						'es_sendmail_status'   => _x( 'Please select your mail type.', 'sendmail-enhanced-select', ES_TDOMAIN ),
						'es_sendmail_confirm'  => _x( 'Have you double checked your selected group? If so, let\'s go ahead and send this.', 'sendmail-enhanced-select', ES_TDOMAIN )
					);
					wp_localize_script( 'sendmail', 'es_sendmail_notices', $es_select_params );
					break;
				case 'es-sentmail':
					wp_register_script( 'es-sentmail', ES_URL . 'sentmail/sentmail.js', '', '', true );
					wp_enqueue_script( 'es-sentmail' );
					$es_select_params = array(
						'es_sentmail_delete'      => _x( 'Do you want to delete this record?', 'sentmail-enhanced-select', ES_TDOMAIN ),
						'es_sentmail_delete_all'  => _x( 'Do you want to delete all records except latest 10?', 'sentmail-enhanced-select', ES_TDOMAIN )
					);
					wp_localize_script( 'es-sentmail', 'es_sentmail_notices', $es_select_params );
					break;
				case 'es-settings':
					wp_register_script( 'es-settings', ES_URL . 'settings/es-settings.js', '', '', true );
					wp_enqueue_script( 'es-settings' );
					$es_select_params = array(
						'es_cron_number'           => _x( 'Please select enter number of mails you want to send per hour/trigger.', 'cron-enhanced-select', ES_TDOMAIN ),
						'es_cron_input_type'       => _x( 'Please enter the mail count, only number.', 'cron-enhanced-select', ES_TDOMAIN )
					);
					wp_localize_script( 'es-settings', 'es_cron_notices', $es_select_params );
					break;
			}
		}
	}

	public static function es_load_widget_scripts_styles() {

		wp_register_script( 'es-widget', ES_URL . 'widget/es-widget.js', '', '', true );
		wp_enqueue_script( 'es-widget' );
		$es_select_params = array(
			'es_email_notice'       => _x( 'Please enter email address', 'widget-enhanced-select', ES_TDOMAIN ),
			'es_incorrect_email'    => _x( 'Please provide a valid email address', 'widget-enhanced-select', ES_TDOMAIN ),
			'es_load_more'          => _x( 'loading...', 'widget-enhanced-select', ES_TDOMAIN ),
			'es_ajax_error'         => _x( 'Cannot create XMLHTTP instance', 'widget-enhanced-select', ES_TDOMAIN ),
			'es_success_message'    => _x( 'Successfully Subscribed.', 'widget-enhanced-select', ES_TDOMAIN ),
			'es_success_notice'     => _x( 'Your subscription was successful! Within a few minutes, kindly check the mail in your mailbox and confirm your subscription. If you can\'t see the mail in your mailbox, please check your spam folder.', 'widget-enhanced-select', ES_TDOMAIN ),
			'es_email_exists'       => _x( 'Email Address already exists!', 'widget-enhanced-select', ES_TDOMAIN ),
			'es_error'              => _x( 'Oops.. Unexpected error occurred.', 'widget-enhanced-select', ES_TDOMAIN ),
			'es_invalid_email'      => _x( 'Invalid email address', 'widget-enhanced-select', ES_TDOMAIN ),
			'es_try_later'          => _x( 'Please try after some time', 'widget-enhanced-select', ES_TDOMAIN ),
			'es_problem_request'    => _x( 'There was a problem with the request', 'widget-enhanced-select', ES_TDOMAIN )
		);
		wp_localize_script( 'es-widget', 'es_widget_notices', $es_select_params );

		wp_register_script( 'es-widget-page', ES_URL . 'widget/es-widget-page.js', '', '', true );
		wp_enqueue_script( 'es-widget-page' );
		$es_select_params = array(
			'es_email_notice'       => _x( 'Please enter email address', 'widget-page-enhanced-select', ES_TDOMAIN ),
			'es_incorrect_email'    => _x( 'Please provide a valid email address', 'widget-page-enhanced-select', ES_TDOMAIN ),
			'es_load_more'          => _x( 'loading...', 'widget-page-enhanced-select', ES_TDOMAIN ),
			'es_ajax_error'         => _x( 'Cannot create XMLHTTP instance', 'widget-page-enhanced-select', ES_TDOMAIN ),
			'es_success_message'    => _x( 'Successfully Subscribed.', 'widget-page-enhanced-select', ES_TDOMAIN ),
			'es_success_notice'     => _x( 'Your subscription was successful! Within a few minutes, kindly check the mail in your mailbox and confirm your subscription. If you can\'t see the mail in your mailbox, please check your spam folder.', 'widget-page-enhanced-select', ES_TDOMAIN ),
			'es_email_exists'       => _x( 'Email Address already exists!', 'widget-page-enhanced-select', ES_TDOMAIN ),
			'es_error'              => _x( 'Oops.. Unexpected error occurred.', 'widget-page-enhanced-select', ES_TDOMAIN ),
			'es_invalid_email'      => _x( 'Invalid email address', 'widget-page-enhanced-select', ES_TDOMAIN ),
			'es_try_later'          => _x( 'Please try after some time', 'widget-page-enhanced-select', ES_TDOMAIN ),
			'es_problem_request'    => _x( 'There was a problem with the request', 'widget-page-enhanced-select', ES_TDOMAIN )
		);
		wp_localize_script( 'es-widget-page', 'es_widget_page_notices', $es_select_params );

		wp_register_style( 'es-widget-css', ES_URL . 'widget/es-widget.css' );
		wp_enqueue_style( 'es-widget-css' );
	}

	public static function es_widget_loading() {
		register_widget( 'es_widget_register' );
	}

	// Function for Klawoo's Subscribe form on Help & Info page
	public static function klawoo_subscribe() {
		$url = 'http://app.klawoo.com/subscribe';

		if( !empty( $_POST ) ) {
			$params = $_POST;
		} else {
			exit();
		}
		$method = 'POST';
		$qs = http_build_query( $params );

		$options = array(
			'timeout' => 15,
			'method' => $method
		);

		if ( $method == 'POST' ) {
			$options['body'] = $qs;
		} else {
			if ( strpos( $url, '?' ) !== false ) {
				$url .= '&'.$qs;
			} else {
				$url .= '?'.$qs;
			}
		}

		$response = wp_remote_request( $url, $options );

		if ( wp_remote_retrieve_response_code( $response ) == 200 ) {
			$data = $response['body'];
			if ( $data != 'error' ) {

				$message_start = substr( $data, strpos( $data,'<body>' ) + 6 );
				$remove = substr( $message_start, strpos( $message_start,'</body>' ) );
				$message = trim( str_replace( $remove, '', $message_start ) );
				echo ( $message );
				exit();
			}
		}
		exit();
	}

	/**
	 * Update current_sa_email_subscribers_db_version
	 */
	public static function sa_email_subscribers_db_update() {

		$email_subscribers_current_db_version = get_option( 'current_sa_email_subscribers_db_version', 'no' );

		if ( $email_subscribers_current_db_version == 'no' ) {
			es_cls_registerhook::es_upgrade_database_for_3_2();
		}

		if ( $email_subscribers_current_db_version == '3.2' ) {
			es_cls_registerhook::es_upgrade_database_for_3_2_7();
		}


		if ( $email_subscribers_current_db_version == '3.2.7' ) {
			es_cls_registerhook::es_upgrade_database_for_3_3();
		}

		if ( $email_subscribers_current_db_version == '3.3' ) {
			es_cls_registerhook::es_upgrade_database_for_3_3_6();
		}
	}

	/**
	 * To alter templatable for extra slug column - to support new template designs
	 * ES version 3.3.6 onwards
	 */
	public static function es_upgrade_database_for_3_3_6() {

		global $wpdb;

		// To check if column es_templ_slug exists or not
		$es_template_col = "SHOW COLUMNS FROM {$wpdb->prefix}es_templatetable LIKE 'es_templ_slug' ";
		$results_template_col = $wpdb->get_results($es_template_col, 'ARRAY_A');
		$template_num_rows = $wpdb->num_rows;

		// If column doesn't exists, then insert it
		if ( $template_num_rows != '1' ) {
			// Template table
			$wpdb->query( "ALTER TABLE {$wpdb->prefix}es_templatetable
							ADD COLUMN `es_templ_slug` VARCHAR(255) NULL
							AFTER `es_email_type` " );
		}

		update_option( 'current_sa_email_subscribers_db_version', '3.3.6' );

	}

	/**
	 * To update sync email option to remove Commented user & it's group - ig_es_sync_wp_users
	 * ES version 3.2 onwards
	 */
	public static function es_upgrade_database_for_3_2() {

		$sync_subscribers = get_option( 'ig_es_sync_wp_users' );

		$es_unserialized_data = maybe_unserialize($sync_subscribers);
		unset($es_unserialized_data['es_commented']);
		unset($es_unserialized_data['es_commented_group']);

		$es_serialized_data = serialize($es_unserialized_data);
		update_option( 'ig_es_sync_wp_users', $es_serialized_data );

		update_option( 'current_sa_email_subscribers_db_version', '3.2' );
	}

	/**
	 * To rename a few terms in compose & reports menu
	 * ES version 3.2.7 onwards
	 */
	public static function es_upgrade_database_for_3_2_7() {

		global $wpdb;

		// Compose table
		$wpdb->query( "UPDATE {$wpdb->prefix}es_templatetable
					   SET es_email_type =
					   ( CASE
							WHEN es_email_type = 'Static Template' THEN 'Newsletter'
							WHEN es_email_type = 'Dynamic Template' THEN 'Post Notification'
							ELSE es_email_type
						 END ) " );

		// Sent Details table
		$wpdb->query( "UPDATE {$wpdb->prefix}es_sentdetails
					   SET es_sent_type =
					   ( CASE
							WHEN es_sent_type = 'Instant Mail' THEN 'Immediately'
							WHEN es_sent_type = 'Cron Mail' THEN 'Cron'
							ELSE es_sent_type
						 END ),
						   es_sent_source =
					   ( CASE
							WHEN es_sent_source = 'manual' THEN 'Newsletter'
							WHEN es_sent_source = 'notification' THEN 'Post Notification'
							ELSE es_sent_source
					   END ) " );

		// Delivery Reports table
		$wpdb->query( "UPDATE {$wpdb->prefix}es_deliverreport
					   SET es_deliver_senttype =
					   ( CASE
							WHEN es_deliver_senttype = 'Instant Mail' THEN 'Immediately'
							WHEN es_deliver_senttype = 'Cron Mail' THEN 'Cron'
							ELSE es_deliver_senttype
						 END ) " );

		update_option( 'current_sa_email_subscribers_db_version', '3.2.7' );
	}

	/**
	 * To migrate Email Settings data from custom pluginconfig table to wordpress options table and to update user roles
	 * ES version 3.3 onwards
	 */
	public static function es_upgrade_database_for_3_3() {
		global $wpdb;

		$settings_to_rename = array(
			'es_c_fromname' => 'ig_es_fromname',
			'es_c_fromemail' => 'ig_es_fromemail',
			'es_c_mailtype' => 'ig_es_emailtype',
			'es_c_adminmailoption' => 'ig_es_notifyadmin',
			'es_c_adminemail' => 'ig_es_adminemail',
			'es_c_adminmailsubject' => 'ig_es_admin_new_sub_subject',
			'es_c_adminmailcontant' => 'ig_es_admin_new_sub_content',
			'es_c_usermailoption' => 'ig_es_welcomeemail',
			'es_c_usermailsubject' => 'ig_es_welcomesubject',
			'es_c_usermailcontant' => 'ig_es_welcomecontent',
			'es_c_optinoption' => 'ig_es_optintype',
			'es_c_optinsubject' => 'ig_es_confirmsubject',
			'es_c_optincontent' => 'ig_es_confirmcontent',
			'es_c_optinlink' => 'ig_es_optinlink',
			'es_c_unsublink' => 'ig_es_unsublink',
			'es_c_unsubtext' => 'ig_es_unsubcontent',
			'es_c_unsubhtml' => 'ig_es_unsubtext',
			'es_c_subhtml' => 'ig_es_successmsg',
			'es_c_message1' => 'ig_es_suberror',
			'es_c_message2' => 'ig_es_unsuberror',
		);

		$options_to_rename = array(
			'es_c_post_image_size' => 'ig_es_post_image_size',
			'es_c_sentreport' => 'ig_es_sentreport',
			'es_c_sentreport_subject' => 'ig_es_sentreport_subject',
			'es_c_rolesandcapabilities' => 'ig_es_rolesandcapabilities',
			'es_c_cronurl' => 'ig_es_cronurl',
			'es_cron_mailcount' => 'ig_es_cron_mailcount',
			'es_cron_adminmail' => 'ig_es_cron_adminmail',
			'es_c_emailsubscribers' => 'ig_es_sync_wp_users',
		);

		// Rename options that were previously stored
		foreach ( $options_to_rename as $old_option_name => $new_option_name ) {
			$option_value = get_option( $old_option_name );
			if ( $option_value ) {
				update_option( $new_option_name, $option_value );
				delete_option( $old_option_name );
			}
		}

		// Do not pull data for new users as there is no pluginconfig table created on activation
		$table_exists = $wpdb->query( "SHOW TABLES LIKE '{$wpdb->prefix}es_pluginconfig'" );

		if ( $table_exists > 0 ) {

			// Pull out ES settings data of existing users and move them to options table
			$settings_data = es_cls_settings::es_setting_select(1);

			if ( ! empty( $settings_data ) ) {
				foreach ( $settings_data as $name => $value ) {
					if( array_key_exists( $name, $settings_to_rename ) ){
						update_option( $settings_to_rename[ $name ], $value );
					}
				}
			}
		}

		//Update User Roles Settings
		$es_c_rolesandcapabilities = get_option( 'ig_es_rolesandcapabilities', 'norecord' );

		if ( $es_c_rolesandcapabilities != 'norecord' ) {
			$remove_roles = array( 'es_roles_setting', 'es_roles_help' );

			foreach ( $es_c_rolesandcapabilities as $role_name => $role_value ) {
				if ( in_array( $role_name, $remove_roles ) ) {
					unset( $es_c_rolesandcapabilities[$role_name] );
				}
			}
			update_option( 'ig_es_rolesandcapabilities', $es_c_rolesandcapabilities );
		}

		update_option( 'current_sa_email_subscribers_db_version', '3.3' );
	}

	// Function to show any notices in admin section
	public static function es_add_admin_notices() {

		$screen = get_current_screen();
		if( stripos($screen->id, 'email-subscribers' ) === false ) return;
		if( get_option('es_survey_done') == 1 ) return;

		?>
		<style type="text/css">
			a.es-admin-btn {
				margin-left: 10px;
				padding: 4px 8px;
				position: relative;
				text-decoration: none;
				border: none;
				-webkit-border-radius: 2px;
				border-radius: 2px;
				background: #e0e0e0;
				text-shadow: none;
				font-weight: 600;
				font-size: 13px;
			}
			a.es-admin-btn-secondary {
				background: #fafafa;
				margin-left: 20px;
				font-weight: 400;
			}
			a.es-admin-btn:hover {
				color: #FFF;
				background-color: #363b3f;
			}
			.es-form-container .es-form-field {
				display: inline-block;
			}
			.es-form-container .es-form-field:not(:first-child) {
				margin-left: 4%;
			}
			.es-form-container {
				background-color: rgb(42, 2, 86) !important;
				border-radius: 0.618em;
				margin-top: 1%;
				padding: 1em 1em 0.5em 1em;
				box-shadow: 0 0 7px 0 rgba(0, 0, 0, .2);
				color: #FFF;
				font-size: 1.1em;
			}
			.es-form-wrapper {
				margin-bottom:0.4em;
			}
			.es-form-headline div.es-mainheadline {
				font-weight: bold;
				font-size: 1.618em;
				line-height: 1.8em;
			}
			.es-form-headline div.es-subheadline {
				padding-bottom: 0.4em;
				font-family: Georgia, Palatino, serif;
				font-size: 1.2em;
				color: #d4a000;
			}
			.es-survey-ques {
				font-size:1.1em;
				padding-bottom: 0.3em;
			}
			.es-form-field label {
				font-size:0.9em;
				margin-left: 0.2em;
			}
			.es-survey-next,.es-button {
				box-shadow: 0 1px 0 #03a025;
				font-weight: bold;
				height: 2em;
				line-height: 1em;
			}
			.es-survey-next,.es-button.primary {
				color: #FFFFFF!important;
				border-color: #a7c53c !important;
				background: #a7c53c !important;
				box-shadow: none;
				padding: 0 3.6em;
			}
			.es-heading {
				font-size: 1.218em;
				padding-bottom: 0.5em;
				padding-top: 0.5em;
				display: block;
				font-weight: bold;
				color: #ffd3a2;
			}
			.es-button.secondary {
				color: #545454!important;
				border-color: #d9dcda!important;
				background: rgba(243, 243, 243, 0.83) !important;
			}
			.es-loader-wrapper {
				position: absolute;
				display: none;
				left: 50%;
				margin-top: 0.4em;
				margin-left: 4em;
			}
			.es-loader-wrapper img {
				width: 60%;
			}
			.es-msg-wrap {
				display: none;
				text-align: center;
			}
			.es-msg-wrap .es-msg-text {
				padding: 1%;
				font-size: 2em;
			}
			.es-form-field.es-left {
				margin-bottom: 0.6em;
				width: 29%;
				display: inline-block;
				float: left;
			}
			.es-form-field.es-right {
				margin-left: 3%;
				width: 67%;
				display: inline-block;
			}
			.es-profile-txt:before {
				font-family: dashicons;
				content: "\f345";
				vertical-align: middle;
			}
			.es-profile-txt {
				font-size: 0.9em; 
			}
			.es-right-info .es-right {
				width: 50%;
				display: inline-block;
				float: right;
				margin-top: 2em;
			}
			.es-right-info .es-left {
				width: 50%;
				display: inline-block;
			}
			.es-form-wrapper form {
				margin-top: 0.6em;
			}
			.es-right-info label {
				padding: 0 0.5em 0 0;
				font-size: 0.8em;
				text-transform: uppercase;
				color: rgba(239, 239, 239, 0.98);
			}
			.es-list-item {
				margin-bottom: 0.9em;
				display: none;
				margin-top: 0.5em;
			}
			.es-rocket {
				position: absolute;
				top: 1.5em;
				right: 5%;
			}
			#es-no {
				box-shadow: none;
				cursor: pointer;
				color: #c3bfbf;
				text-decoration: underline;
				width: 100%;
				display: inline-block;
				margin: 0 auto;
				margin-left: 11em;
				margin-top: 0.2em;
			}
			.es-clearfix:after {
				content: ".";
				display: block;
				clear: both;
				visibility: hidden;
				line-height: 0;
				height: 0;
			}
			.es-survey-next {
			   text-decoration: none;
			   color: #fff;
			   margin-top: -1em!important;
			}
		</style>
		<script type="text/javascript">
			jQuery(function() {
				jQuery('.es-list-item:nth-child(2)').show();
				jQuery('.es-list-item:nth-child(2)').addClass('current');
				jQuery('.es-form-container').on('click', '.es-survey-next', function(){
					jQuery('.es-list-item.current').hide();
					jQuery('.es-list-item.current').next().show().addClass('current');
					jQuery('.es-list-item.current').prev('.es-list-item').hide();
					if(jQuery('.es-list-item.current').is(':last-child')){
						jQuery('.es-survey-next').hide();

					}
				});

			});
		</script>

		<?php

		// 13th June 17 - 0.1
		// updated on 5th July 17 - 0.2
		// updated on 26th July 17 - 0.2
		// updated on 21st Aug 17 - 0.3
		$es_data = es_cls_dbquery::es_survey_res();

		// Check days passed from this update (v3.3.4)
		$timezone_format = _x('Y-m-d', 'timezone date format');
		$es_current_date = date_i18n($timezone_format);
		$es_update_date = get_option('ig_es_update_v_3_3_4_date');

		if ( $es_update_date === false ) {
			$es_update_date = $es_current_date;
			add_option( 'ig_es_update_v_3_3_4_date',$es_update_date );
		}

		$date_diff = floor( ( strtotime($es_current_date) - strtotime($es_update_date) ) / (3600 * 24) );
		if($date_diff < 30) return;

		?>

		<div class="es-form-container wrap">
			<div class="es-form-wrapper">
				<div class="es-form-headline">
					<div class="es-mainheadline"><?php echo __( 'Email Subscribers', ES_TDOMAIN ); ?> <u><?php echo __( 'is getting even better!', ES_TDOMAIN ); ?></u></div>
					<div class="es-subheadline"><?php echo __( 'But I need you to', ES_TDOMAIN ); ?> <strong><?php echo __( 'help me prioritize', ES_TDOMAIN ); ?></strong>! <?php echo __( 'Please send your response today.', ES_TDOMAIN ); ?></div>
				</div>
				<form name="es-survey-form" action="#" method="POST" accept-charset="utf-8">
					<div class="es-container-1 es-clearfix">	
						<div class="es-form-field es-left">
							<div class="es-profile">
								<div class="es-profile-info">
									<div class="es-heading"><?php echo __( "Here's how you use ES:",ES_TDOMAIN ); ?></div>
									<ul style="margin: 0 0.5em;">
										<li class="es-profile-txt">
											<?php 
												if( $es_data['post_notification'] > $es_data['newsletter'] ) {
													echo __( 'Post Notifications more often than Newsletter', ES_TDOMAIN );
												} else if($es_data['newsletter'] > $es_data['post_notification']){
													echo __( 'Newsletter more often than Post Notifications', ES_TDOMAIN );
												} else{
													echo __( 'Post Notification &amp; Newsletter equally', ES_TDOMAIN );
												}
											?>
										</li>
										<li class="es-profile-txt"> <?php echo __('Have ',ES_TDOMAIN ) .$es_data['es_active_subscribers'] . __(' Active Subscribers', ES_TDOMAIN); ?></li>
										<li class="es-profile-txt"> <?php echo __('Post ',ES_TDOMAIN ) .$es_data['es_avg_post_cnt'] . __(' blog per week', ES_TDOMAIN); ?></li>
										<li class="es-profile-txt">
											<?php 
												if( $es_data['cron'] > $es_data['immediately'] ) {
													echo __( 'Send emails via Cron', ES_TDOMAIN );
												} else {
													echo __( 'Send emails Immediately', ES_TDOMAIN );
												}
											?>
										</li>
										<li class="es-profile-txt">
											<?php 
												if ( $es_data['es_opt_in_type'] == 'Double Opt In' ) {
													echo __( 'Using Double Opt In', ES_TDOMAIN );
												} else {
													echo __( 'Using Single Opt In', ES_TDOMAIN );
												}
											?>
										</li>
										<input type="hidden" name="es_data[data][post_notification]" value="<?php echo $es_data['post_notification']; ?>">
										<input type="hidden" name="es_data[data][newsletter]" value="<?php echo $es_data['newsletter']; ?>">
										<input type="hidden" name="es_data[data][cron]" value="<?php echo $es_data['cron']; ?>">
										<input type="hidden" name="es_data[data][immediately]" value="<?php echo $es_data['immediately']; ?>">
										<input type="hidden" name="es_data[data][es_active_subscribers]" value="<?php echo $es_data['es_active_subscribers']; ?>">
										<input type="hidden" name="es_data[data][es_total_subscribers]" value="<?php echo $es_data['es_total_subscribers']; ?>">
										<input type="hidden" name="es_data[data][es_avg_post_cnt]" value="<?php echo $es_data['es_avg_post_cnt']; ?>">
										<input type="hidden" name="es_data[data][es_opt_in_type]" value="<?php echo $es_data['es_opt_in_type']; ?>">
										<input type="hidden" name="es_data[es-survey-version]" value="0.3">
									</ul>
								</div>
							</div>
						</div>
						<div class="es-form-field es-right">
							<div class="es-heading"><?php echo __( 'How soon do you want these new features?', ES_TDOMAIN ); ?></div>
							<div class="es-right-info">
								<div class="es-left">
									<ul style="margin-top:0;"><span class="es-counter">
										<li class="es-list-item"><?php echo __( 'Beautiful Email Designs', ES_TDOMAIN ); ?><br>
											<label title="days"><input checked="" type="radio" name="es_data[design_tmpl]" value="0"><?php echo __( 'Right now!', ES_TDOMAIN ); ?></label>
											<label title="days"><input type="radio" name="es_data[design_tmpl]" value="1"><?php echo __( 'Soon', ES_TDOMAIN ); ?></label>
											<label title="days"><input type="radio" name="es_data[design_tmpl]" value="2"><?php echo __( 'Later', ES_TDOMAIN ); ?></label>
										</li>
										<li class="es-list-item"><?php echo __( 'Spam Check, Scheduling... (Better Email Delivery)', ES_TDOMAIN); ?><br>
											<label title="days"><input type="radio" name="es_data[email_control]" value="0"><?php echo __( 'Right now!', ES_TDOMAIN ); ?></label>
											<label title="days"><input checked="" type="radio" name="es_data[email_control]" value="1"><?php echo __( 'Soon', ES_TDOMAIN ); ?></label>
											<label title="days"><input type="radio" name="es_data[email_control]" value="2"><?php echo __( 'Later', ES_TDOMAIN ); ?></label>
										</li>
										<li class="es-list-item"><?php echo __( 'Discard Fake / Bouncing Emails', ES_TDOMAIN); ?><br>
											<label title="days"><input type="radio" name="es_data[cleanup]" value="0"><?php echo __( 'Right now!', ES_TDOMAIN ); ?></label>
											<label title="days"><input checked="" type="radio" name="es_data[cleanup]" value="1"><?php echo __( 'Soon', ES_TDOMAIN ); ?></label>
											<label title="days"><input type="radio" name="es_data[cleanup]" value="2"><?php echo __( 'Later', ES_TDOMAIN ); ?></label>
										</li>
										<li class="es-list-item"><?php echo __( 'Advanced Reporting', ES_TDOMAIN ); ?><br>
											<label title="days"><input type="radio" name="es_data[report]" value="0"><?php echo __( 'Right now!', ES_TDOMAIN ); ?></label>
											<label title="days"><input type="radio" name="es_data[report]" value="1"><?php echo __( 'Soon', ES_TDOMAIN ); ?></label>
											<label title="days"><input checked="" type="radio" name="es_data[report]" value="2"><?php echo __( 'Later', ES_TDOMAIN ); ?></label>
										</li>
										<li class="es-list-item">
											<div>
												<input style="width: 70%;vertical-align: middle;display: inline-block;" placeholder="Enter your email to get early access" type="email" name="es_data[email]" value="<?php echo get_option( 'admin_email' ); ?>">
												<div class="" style="display: inline-block;margin-left: 0.4em;width: 23%;vertical-align: middle;">
													<input data-val="yes" type="submit" id="es-yes" value="Alright, Send It All" class="es-button button primary">
												</div>
												<div class="es-loader-wrapper"><img src="<?php echo ES_URL ?>images/spinner-2x.gif"></div>
												<a id="es-no" data-val="no" class=""><?php echo __( 'Nah, I don\'t like improvements', ES_TDOMAIN ); ?></a>
											</div>
										</li>
									</ul>
								</div>
								<div class="es-right">
									<a href="#" class="es-survey-next button primary"><?php echo __( 'Next', ES_TDOMAIN ); ?> </a>
								</div>
							</div>
						</div>
					</div>
				</form>
				<div class="es-rocket"><img src="<?php echo ES_URL?>images/es-growth-rocket.png"/></div>
			</div>
			<div class="es-msg-wrap">
				<div class="es-logo-wrapper"><img style="width:5%;" src="<?php echo ES_URL ?>images/es-logo-128x128.png"></div>
				<div class="es-msg-text es-yes"><?php echo __( 'Thank you!', ES_TDOMAIN ); ?></div>
				<div class="es-msg-text es-no"><?php echo __( 'No issues, have a nice day!', ES_TDOMAIN ); ?></div>
			</div>
		</div>

		<script type="text/javascript">
			jQuery(function () {
				jQuery("form[name=es-survey-form]").on('click','.es-button, #es-no',function(e){
					e.preventDefault();
					jQuery("form[name=es-survey-form]").find('.es-loader-wrapper').show();
					var params = jQuery("form[name=es-survey-form]").serializeArray();
					var that = this;
					params.push({name: 'btn-val', value: jQuery(this).data('val') });
					params.push({name: 'action', value: 'es_submit_survey' });
					jQuery.ajax({
							method: 'POST',
							type: 'text',
							url: "<?php echo admin_url( 'admin-ajax.php' ); ?>",
							data: params,
							success: function(response) {  
								jQuery("form[name=es-survey-form]").find('.es-loader-wrapper').hide();
								jQuery(".es-msg-wrap").show('slow');
								if( jQuery(that).attr('id') =='es-no'){
									jQuery(".es-msg-wrap .es-yes").hide();
								}else{
									jQuery(".es-msg-wrap .es-no").hide();
								}
								jQuery(".es-form-wrapper").hide('slow');
								setTimeout(function(){
										jQuery(".es-form-container").hide('slow');
								}, 5000);
							}
					});
				})

			});
		</script>
		<?php

	}

	public static function es_submit_survey() {

		$url = 'https://www.icegram.com/wp-admin/admin-ajax.php';

		if( !empty($_POST['btn-val']) &&  $_POST['btn-val'] == 'no' ) {
			update_option('es_survey_done', true);
			exit();
		}

		if( !empty( $_POST ) ) {
			$params = $_POST;
			$params['domain'] = home_url();
		} else {
			exit();
		}

		$method = 'POST';
		$qs = http_build_query( $params );

		$options = array(
			'timeout' => 15,
			'method' => $method
		);

		if ( $method == 'POST' ) {
			$options['body'] = $qs;
		} else {
			if ( strpos( $url, '?' ) !== false ) {
				$url .= '&'.$qs;
			} else {
				$url .= '?'.$qs;
			}
		}

		$response = wp_remote_request( $url, $options );
		if ( wp_remote_retrieve_response_code( $response ) == 200 ) {
			$data = json_decode($response['body'], true);
			if ( empty($data['error']) ) {
				if(!empty($data) && !empty($data['success'])){
					update_option('es_survey_done', true);
				}
				echo ( json_encode($data) );
				exit();                
			}
		}
		exit();
	}


	public static function es_footer_text($es_rating_text) {

		if ( isset($_GET['page']) && ( $_GET['page'] == 'es-view-subscribers' || $_GET['page'] == 'es-compose' || $_GET['page'] == 'es-notification' || $_GET['page'] == 'es-sendemail' || $_GET['page'] == 'es-settings' || $_GET['page'] == 'es-sentmail' || $_GET['page'] == 'es-general-information' ) ) {
			$es_rating_text = __( 'If you like <strong>Email Subscribers</strong>, please consider leaving us a <a target="_blank" href="https://wordpress.org/support/plugin/email-subscribers/reviews/?filter=5#new-post">&#9733;&#9733;&#9733;&#9733;&#9733;</a> rating. A huge thank you from Icegram in advance!', ES_TDOMAIN );
		}

		return $es_rating_text;
	}

	public static function es_update_footer_text($es_text) {

		$social_link = '<style type="text/css">
								div.ig_es_social_links > iframe {
									max-height: 1.5em;
									vertical-align: middle;
									padding: 5px 2px 0px 0px;
								}
								iframe[id^="twitter-widget"] {
									max-width: 15em;
								}
								iframe#fb_like_ig {
									max-width: 6em;
								}
								span > iframe {
									vertical-align: middle;
								}
							</style>';
			$social_link .= '<a href="https://twitter.com/icegram" class="twitter-follow-button" data-show-count="true" data-dnt="true" data-show-screen-name="false">Follow</a>';
			$social_link .= "<script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+'://platform.twitter.com/widgets.js';fjs.parentNode.insertBefore(js,fjs);}}(document, 'script', 'twitter-wjs');</script>";
			$social_link .= '<iframe id="fb_like_ig" src="http://www.facebook.com/plugins/like.php?href=https%3A%2F%2Fwww.facebook.com%2Fpages%2Ficegram%2F236428693214953&width=100&layout=button_count&action=like&show_faces=false&share=false&height=41"></iframe>';

		if ( isset($_GET['page']) && ( $_GET['page'] == 'es-view-subscribers' || $_GET['page'] == 'es-compose' || $_GET['page'] == 'es-notification' || $_GET['page'] == 'es-sendemail' || $_GET['page'] == 'es-settings' || $_GET['page'] == 'es-sentmail' || $_GET['page'] == 'es-general-information' ) ) {
			$es_text = __( '<div id="ig_es_social_links" class="ig_es_social_links" style="float:right;">'.
						$social_link. ''.
					'</div>', ES_TDOMAIN );
		}

		return $es_text;
	}

}

function es_sync_registereduser( $user_id ) {

	$es_c_emailsubscribers = get_option('ig_es_sync_wp_users', 'norecord');

	if( $es_c_emailsubscribers == 'norecord' || $es_c_emailsubscribers == "" ) {
		// No action is required
	} else {
		$es_sync_unserialized_data = maybe_unserialize($es_c_emailsubscribers);
		if(($es_sync_unserialized_data['es_registered'] == "YES") && ($user_id != "")) {
			$es_registered = $es_sync_unserialized_data['es_registered'];
			$es_registered_group = $es_sync_unserialized_data['es_registered_group'];

			$user_info = get_userdata($user_id);
			$user_firstname = $user_info->user_firstname;

			if($user_firstname == "") {
				$user_firstname = $user_info->user_login;
			}
			$user_mail = $user_info->user_email;

			$form['es_email_name'] = $user_firstname;
			$form['es_email_mail'] = $user_mail;
			$form['es_email_group'] = $es_sync_unserialized_data['es_registered_group'];
			$form['es_email_status'] = "Confirmed";
			$action = es_cls_dbquery::es_view_subscriber_ins($form, "insert");

			if($action == "sus") {
				//Inserted successfully. Below 3 line of code will send WELCOME email to subscribers.
				$subscribers = array();
				$subscribers = es_cls_dbquery::es_view_subscriber_one($user_mail, $form['es_email_group']);
				es_cls_sendmail::es_sendmail("welcome", $template = 0, $subscribers, "welcome", 0);
			}
		}
	}
}

class es_widget_register extends WP_Widget {
	function __construct() {
		$widget_ops = array('classname' => 'widget_text elp-widget', 'description' => __( ES_PLUGIN_DISPLAY, ES_TDOMAIN ), ES_PLUGIN_NAME);
		parent::__construct(ES_PLUGIN_NAME, __( ES_PLUGIN_DISPLAY, ES_TDOMAIN ), $widget_ops);
	}

	function widget( $args, $instance ) {
		extract( $args, EXTR_SKIP );

		$es_title   = apply_filters( 'widget_title', empty( $instance['es_title'] ) ? '' : $instance['es_title'], $instance, $this->id_base );
		$es_desc    = $instance['es_desc'];
		$es_name    = $instance['es_name'];
		$es_group   = $instance['es_group'];

		echo $args['before_widget'];
		if ( ! empty( $es_title ) ) {
			echo $args['before_title'] . $es_title . $args['after_title'];
		}

		// display widget method
		$url = home_url();

		global $es_includes;
		if (!isset($es_includes) || $es_includes !== true) {
			$es_includes = true;
		}
		?>

		<div>
			<form class="es_widget_form" data-es_form_id="es_widget_form">
				<?php if( $es_desc != "" ) { ?>
					<div class="es_caption"><?php echo $es_desc; ?></div>
				<?php } ?>
				<?php if( $es_name == "YES" ) { ?>
					<div class="es_lablebox"><label class="es_widget_form_name"><?php echo __( 'Name', ES_TDOMAIN ); ?></label></div>
					<div class="es_textbox">
						<input type="text" id="es_txt_name" class="es_textbox_class" name="es_txt_name" value="" maxlength="225">
					</div>
				<?php } ?>
				<div class="es_lablebox"><label class="es_widget_form_email"><?php echo __( 'Email *', ES_TDOMAIN ); ?></label></div>
				<div class="es_textbox">
					<input type="text" id="es_txt_email" class="es_textbox_class" name="es_txt_email" onkeypress="if(event.keyCode==13) es_submit_page(event,'<?php echo $url; ?>')" value="" maxlength="225">
				</div>
				<div class="es_button">
					<input type="button" id="es_txt_button" class="es_textbox_button es_submit_button" name="es_txt_button" onClick="return es_submit_page(event,'<?php echo $url; ?>')" value="<?php echo __( 'Subscribe', ES_TDOMAIN ); ?>">
				</div>
				<div class="es_msg" id="es_widget_msg">
					<span id="es_msg"></span>
				</div>
				<?php if( $es_name != "YES" ) { ?>
					<input type="hidden" id="es_txt_name" name="es_txt_name" value="">
				<?php } ?>
				<input type="hidden" id="es_txt_group" name="es_txt_group" value="<?php echo $es_group; ?>">
			</form>
		</div>
		<?php
		echo $args['after_widget'];
	}

	function update( $new_instance, $old_instance ) {
		$instance               = $old_instance;
		$instance['es_title']   = ( ! empty( $new_instance['es_title'] ) ) ? strip_tags( $new_instance['es_title'] ) : '';
		$instance['es_desc']    = ( ! empty( $new_instance['es_desc'] ) ) ? strip_tags( $new_instance['es_desc'] ) : '';
		$instance['es_name']    = ( ! empty( $new_instance['es_name'] ) ) ? strip_tags( $new_instance['es_name'] ) : '';
		$instance['es_group']   = ( ! empty( $new_instance['es_group'] ) ) ? strip_tags( $new_instance['es_group'] ) : '';
		return $instance;
	}

	function form( $instance ) {
		$defaults = array(
			'es_title' => '',
			'es_desc'   => '',
			'es_name'   => '',
			'es_group'  => ''
		);
		$instance       = wp_parse_args( (array) $instance, $defaults);
		$es_title       = $instance['es_title'];
		$es_desc        = $instance['es_desc'];
		$es_name        = $instance['es_name'];
		$es_group       = $instance['es_group'];
		?>
		<p>
			<label for="<?php echo $this->get_field_id('es_title'); ?>"><?php echo __( 'Widget Title', ES_TDOMAIN ); ?></label>
			<input class="widefat" id="<?php echo $this->get_field_id('es_title'); ?>" name="<?php echo $this->get_field_name('es_title'); ?>" type="text" value="<?php echo $es_title; ?>" />
		</p>
		<p>
			<label for="<?php echo $this->get_field_id('es_desc'); ?>"><?php echo __( 'Short description about subscription form', ES_TDOMAIN ); ?></label>
			<input class="widefat" id="<?php echo $this->get_field_id('es_desc'); ?>" name="<?php echo $this->get_field_name('es_desc'); ?>" type="text" value="<?php echo $es_desc; ?>" />
		</p>
		<p>
			<label for="<?php echo $this->get_field_id('es_name'); ?>"><?php echo __( 'Display Name Field', ES_TDOMAIN ); ?></label>
			<select class="widefat" id="<?php echo $this->get_field_id('es_name'); ?>" name="<?php echo $this->get_field_name('es_name'); ?>">
				<option value="YES" <?php $this->es_selected($es_name == 'YES'); ?>><?php echo __( 'YES', ES_TDOMAIN ); ?></option>
				<option value="NO" <?php $this->es_selected($es_name == 'NO'); ?>><?php echo __( 'NO', ES_TDOMAIN ); ?></option>
			</select>
		</p>
		<p>
			<label for="<?php echo $this->get_field_id('es_group'); ?>"><?php echo __( 'Subscriber Group', ES_TDOMAIN ); ?></label>
			<select class="widefat" name="<?php echo $this->get_field_name('es_group'); ?>" id="<?php echo $this->get_field_id('es_group'); ?>">
				<?php
					$groups = array();
					$groups = es_cls_dbquery::es_view_subscriber_group();
					if(count($groups) > 0) {
						$i = 1;
						foreach ($groups as $group) {
							?>
							<option value="<?php echo esc_html(stripslashes($group["es_email_group"])); ?>" <?php if(stripslashes($es_group) == $group["es_email_group"]) { echo 'selected="selected"' ; } ?>>
								<?php echo stripslashes($group["es_email_group"]); ?>
							</option>
							<?php
						}
					}
				?>
			</select>
		</p>
		<?php
	}

	function es_selected($var) {
		if ($var==1 || $var==true) {
			echo 'selected="selected"';
		}
	}
}