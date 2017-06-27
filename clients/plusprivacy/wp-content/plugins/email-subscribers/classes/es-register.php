<?php

// Exit if accessed directly
if ( ! defined( 'ABSPATH' ) ) {
	exit; 
}

class es_cls_registerhook {
	public static function es_activation() {
		global $wpdb;

		add_option('email-subscribers', "2.9");

		// Plugin tables
		$array_tables_to_plugin = array('es_emaillist','es_sentdetails','es_deliverreport','es_pluginconfig');
		$errors = array();
		
		// loading the sql file, load it and separate the queries
		$sql_file = ES_DIR.'sql'.DS.'es-createdb.sql';
		$prefix = $wpdb->prefix;
		$handle = fopen($sql_file, 'r');
		$query = fread($handle, filesize($sql_file));
		fclose($handle);
		$query=str_replace('CREATE TABLE IF NOT EXISTS ','CREATE TABLE IF NOT EXISTS '.$prefix, $query);
		$queries=explode('-- SQLQUERY ---', $query);

		// run the queries one by one
		$has_errors = false;
		foreach($queries as $qry) {
			$wpdb->query($qry);
		}

		// list the tables that haven't been created
		$missingtables=array();
		foreach($array_tables_to_plugin as $table_name) {
			if(strtoupper($wpdb->get_var("SHOW TABLES like  '". $prefix.$table_name . "'")) != strtoupper($prefix.$table_name)) {
				$missingtables[]=$prefix.$table_name;
			}
		}

		// add error in to array variable
		if($missingtables) {
			$errors[] = __('These tables could not be created on installation ' . implode(', ',$missingtables), 'email-subscribers');
			$has_errors=true;
		}

		// if error call wp_die()
		if($has_errors) {
			wp_die( __( $errors[0] , 'email-subscribers' ) );
			return false;
		} else {
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
		$es_c_email_subscribers_ver = get_option('email-subscribers');

		if($es_c_email_subscribers_ver != "2.9") {

			global $wpdb;

			// loading the sql file, load it and separate the queries
			$sql_file = ES_DIR.'sql'.DS.'es-createdb.sql';
			$prefix = $wpdb->prefix;
			$handle = fopen($sql_file, 'r');
			$query = fread($handle, filesize($sql_file));
			fclose($handle);
			$query=str_replace('CREATE TABLE IF NOT EXISTS ','CREATE TABLE '.$prefix, $query);
			$query=str_replace('ENGINE=MyISAM /*!40100 DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci*/','', $query);
			$queries=explode('-- SQLQUERY ---', $query);
	
			// includes db upgrade file
			require_once( ABSPATH . 'wp-admin/includes/upgrade.php' );
			
			// run the queries one by one
			foreach($queries as $sSql) {
				dbDelta( $sSql );
			}

			$guid = es_cls_common::es_generate_guid(60);
			$home_url = home_url('/');
			$cronurl = $home_url . "?es=cron&guid=". $guid;
			add_option('es_c_cronurl', $cronurl);
			add_option('es_cron_mailcount', "50");
			add_option('es_cron_adminmail', "Hi Admin, \r\n\r\nCron URL has been triggered successfully on ###DATE### for the email ###SUBJECT###. And it sent email to ###COUNT### recipient. \r\n\r\nThank You");
			update_option('email-subscribers', "2.9" );
		}
	}
	
	public static function es_deactivation() {
		// do not generate any output here
	}

	public static function es_admin_option() {
		// do not generate any output here
	}

	public static function es_adminmenu() {
		$es_c_rolesandcapabilities = get_option('es_c_rolesandcapabilities', 'norecord');
		if($es_c_rolesandcapabilities == 'norecord' || $es_c_rolesandcapabilities == "") {
			$es_roles_subscriber = "manage_options";
			$es_roles_mail = "manage_options";
			$es_roles_notification = "manage_options";
			$es_roles_sendmail = "manage_options";
			$es_roles_setting = "manage_options";
			$es_roles_sentmail = "manage_options";
			$es_roles_help = "manage_options";
		} else {
			$es_roles_subscriber = $es_c_rolesandcapabilities['es_roles_subscriber'];
			$es_roles_mail = $es_c_rolesandcapabilities['es_roles_mail'];
			$es_roles_notification = $es_c_rolesandcapabilities['es_roles_notification'];
			$es_roles_sendmail = $es_c_rolesandcapabilities['es_roles_sendmail'];
			$es_roles_setting = $es_c_rolesandcapabilities['es_roles_setting'];
			$es_roles_sentmail = $es_c_rolesandcapabilities['es_roles_sentmail'];
			$es_roles_help = $es_c_rolesandcapabilities['es_roles_help'];
		}

		add_menu_page( __( 'Email Subscribers', 'email-subscribers' ), 
			__( 'Email Subscribers', 'email-subscribers' ), 'admin_dashboard', 'email-subscribers', array( 'es_cls_registerhook', 'es_admin_option'), ES_URL.'images/mail.png', 51 );

		add_submenu_page('email-subscribers', __( 'Subscribers', ES_TDOMAIN ), 
			__( 'Subscribers', ES_TDOMAIN ), $es_roles_subscriber, 'es-view-subscribers', array( 'es_cls_intermediate', 'es_subscribers' ));

		add_submenu_page('email-subscribers', __( 'Compose', ES_TDOMAIN ), 
			__( 'Compose', ES_TDOMAIN ), $es_roles_mail, 'es-compose', array( 'es_cls_intermediate', 'es_compose' ));

		add_submenu_page('email-subscribers', __( 'Post Notifications', ES_TDOMAIN ), 
			__( 'Post Notifications', ES_TDOMAIN ), $es_roles_notification, 'es-notification', array( 'es_cls_intermediate', 'es_notification' ));

		add_submenu_page('email-subscribers', __( 'Newsletters', ES_TDOMAIN ), 
			__( 'Newsletters', ES_TDOMAIN ), $es_roles_sendmail, 'es-sendemail', array( 'es_cls_intermediate', 'es_sendemail' ));

		add_submenu_page('email-subscribers', __( 'Cron Settings', ES_TDOMAIN ), 
			__( 'Cron Settings', ES_TDOMAIN ), $es_roles_sendmail, 'es-cron', array( 'es_cls_intermediate', 'es_cron' ));

		add_submenu_page('email-subscribers', __( 'Email Settings', ES_TDOMAIN ), 
			__( 'Email Settings', ES_TDOMAIN ), $es_roles_setting, 'es-settings', array( 'es_cls_intermediate', 'es_settings' ));

		add_submenu_page('email-subscribers', __( 'User Roles', ES_TDOMAIN ), 
			__( 'User Roles', ES_TDOMAIN ), 'administrator', 'es-roles', array( 'es_cls_intermediate', 'es_roles' ));

		add_submenu_page('email-subscribers', __( 'Reports', ES_TDOMAIN ), 
			__( 'Reports', ES_TDOMAIN ), $es_roles_sentmail, 'es-sentmail', array( 'es_cls_intermediate', 'es_sentmail' ));

		add_submenu_page('email-subscribers', __( 'Help & Info', ES_TDOMAIN ), 
			__( '<span style="color:#f18500;font-weight:bolder;">Help & Info', ES_TDOMAIN ), $es_roles_help, 'es-general-information', array( 'es_cls_intermediate', 'es_information' ));
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
						'es_subscriber_export'          => _x( 'Do you want to export the emails?', 'view-subscriber-enhanced-select', ES_TDOMAIN ),
						'es_subscriber_csv_file'        => _x( 'Please select only csv file. Please check official website for csv structure..', 'view-subscriber-enhanced-select', ES_TDOMAIN )
					);
					wp_localize_script( 'es-view-subscribers', 'es_view_subscriber_notices', $es_select_params );
					break;
				case 'es-compose':
					wp_register_script( 'es-compose', ES_URL . 'compose/compose.js', '', '', true );
					wp_enqueue_script( 'es-compose' );
					$es_select_params = array(
						'es_configuration_name'     => _x( 'Please enter name for configuration.', 'compose-enhanced-select', ES_TDOMAIN ),
						'es_configuration_template' => _x( 'Please select template for this configuration.', 'compose-enhanced-select', ES_TDOMAIN ),
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
				case 'es-cron':
					wp_register_script( 'cron', ES_URL . 'cron/cron.js', '', '', true );
					wp_enqueue_script( 'cron' );
					$es_select_params = array(
						'es_cron_number'           => _x( 'Please select enter number of mails you want to send per hour/trigger.', 'cron-enhanced-select', ES_TDOMAIN ),
						'es_cron_input_type'       => _x( 'Please enter the mail count, only number.', 'cron-enhanced-select', ES_TDOMAIN )
					);
					wp_localize_script( 'cron', 'es_cron_notices', $es_select_params );
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

	}

	/**
	 * To update sync email option to remove Commented user & it's group - es_c_emailsubscribers 
	 * ES version 3.2 onwards
	 */
	public static function es_upgrade_database_for_3_2() {

		$sync_subscribers = get_option( 'es_c_emailsubscribers' );

		$es_unserialized_data = maybe_unserialize($sync_subscribers);
		unset($es_unserialized_data['es_commented']);
		unset($es_unserialized_data['es_commented_group']);

		$es_serialized_data = serialize($es_unserialized_data);
		update_option( 'es_c_emailsubscribers', $es_serialized_data );

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

	// Function to show any notices in admin section
	public static function es_add_admin_notices() {
		?>
		<style type="text/css">
			a.es-admin-btn{
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
			a.es-admin-btn-secondary{
				background: #fafafa;
				margin-left: 20px;
				font-weight: 400;
			}

			a.es-admin-btn:hover{
				color: #FFF;
				background-color: #363b3f;
			}
		</style>

		<?php
		// To show IG recommendation
		$active_plugins = (array) get_option('active_plugins', array());
		if (is_multisite()) {
			$active_plugins = array_merge($active_plugins, get_site_option('active_sitewide_plugins', array()));
		}

		$es_ig_notice_email_subscribers = get_option( 'es_ig_notice_email_subscribers' );

		if ( in_array('icegram/icegram.php', $active_plugins) || array_key_exists('icegram/icegram.php', $active_plugins) || !empty($es_ig_notice_email_subscribers) ) {
			return;
		} else {
			$url = wp_nonce_url(self_admin_url('update.php?action=install-plugin&plugin=' . 'icegram'), 'install-plugin_' . 'icegram');
			$admin_notice_text_for_ig = __( '<b>FREE</b> plugin: Quickly grow your subscribers list with beautiful and high converting optins.', ES_TDOMAIN );
			echo '<div class="notice notice-warning"><p>'.$admin_notice_text_for_ig.'<a style="display:inline-block" class="es-admin-btn" href="'.$url.'">'.__( 'Try Icegram', ES_TDOMAIN ).'</a><a style="display:inline-block" class="es-admin-btn es-admin-btn-secondary" href="?dismiss_admin_notice=1&option_name=es_ig_notice">'.__( 'No, I don\'t need it', ES_TDOMAIN ).'</a></p></div>';
		}

		// To show RM recommendation
		// $active_plugins = (array) get_option('active_plugins', array());
		// if (is_multisite()) {
		// 	$active_plugins = array_merge($active_plugins, get_site_option('active_sitewide_plugins', array()));
		// }

		// $es_rm_notice_email_subscribers = get_option( 'es_rm_notice_email_subscribers' );

		// if ( in_array('icegram-rainmaker/icegram-rainmaker.php', $active_plugins) || array_key_exists('icegram-rainmaker/icegram-rainmaker.php', $active_plugins) || !empty($es_rm_notice_email_subscribers) ) {
		// 	return;
		// } else {
		// 	$url = wp_nonce_url(self_admin_url('update.php?action=install-plugin&plugin=' . 'icegram-rainmaker'), 'install-plugin_' . 'icegram-rainmaker');
		// 		$admin_notice_text_for_rm = __( 'Email Subscribers recommends free plugin <b>Rainmaker</b> to collect leads instantly', ES_TDOMAIN );
		// 		echo '<div class="notice notice-warning"><p>'.$admin_notice_text_for_rm.'<a style="display:inline-block" class="es-admin-btn" href="'.$url.'">'.__( 'Yes, I want this', ES_TDOMAIN ).'</a><a style="display:inline-block" class="es-admin-btn es-admin-btn-secondary" href="?dismiss_admin_notice=1&option_name=es_rm_notice">'.__( 'No, I don\'t want it', ES_TDOMAIN ).'</a></p></div>';
		// }
	}

	// Function to dismiss any admin notice
	public static function dismiss_admin_notice() {

		if(isset($_GET['dismiss_admin_notice']) && $_GET['dismiss_admin_notice'] == '1' && isset($_GET['option_name'])) {
			$option_name = sanitize_text_field($_GET['option_name']);
			update_option( $option_name.'_email_subscribers', 'no' );

			$referer = wp_get_referer();
			wp_safe_redirect( $referer );
			exit();
		}

	}

}

function es_sync_registereduser( $user_id ) {

	$es_c_emailsubscribers = get_option('es_c_emailsubscribers', 'norecord');

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
			<input class="widefat" id="<?php echo $this->get_field_id('es_group'); ?>" name="<?php echo $this->get_field_name('es_group'); ?>" type="text" value="<?php echo $es_group; ?>" />
		</p>
		<?php
	}
	
	function es_selected($var) {
		if ($var==1 || $var==true) {
			echo 'selected="selected"';
		}
	}
}