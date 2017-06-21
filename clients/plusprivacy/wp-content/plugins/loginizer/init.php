<?php

if(!function_exists('add_action')){
	echo 'You are not allowed to access this page directly.';
	exit;
}

define('LOGINIZER_VERSION', '1.3.2');
define('LOGINIZER_DIR', WP_PLUGIN_DIR.'/'.basename(dirname(LOGINIZER_FILE)));
define('LOGINIZER_URL', plugins_url('', LOGINIZER_FILE));
define('LOGINIZER_PRO_URL', 'https://loginizer.com/features#compare');
define('LOGINIZER_DOCS', 'https://loginizer.com/wiki/');

include_once(LOGINIZER_DIR.'/functions.php');

// Ok so we are now ready to go
register_activation_hook(LOGINIZER_FILE, 'loginizer_activation');

// Is called when the ADMIN enables the plugin
function loginizer_activation(){

	global $wpdb;

	$sql = array();
	
	$sql[] = "DROP TABLE IF EXISTS `".$wpdb->prefix."loginizer_logs`";
	
	$sql[] = "CREATE TABLE `".$wpdb->prefix."loginizer_logs` (
				`username` varchar(255) NOT NULL DEFAULT '',
				`time` int(10) NOT NULL DEFAULT '0',
				`count` int(10) NOT NULL DEFAULT '0',
				`lockout` int(10) NOT NULL DEFAULT '0',
				`ip` varchar(255) NOT NULL DEFAULT '',
				UNIQUE KEY `ip` (`ip`)
			) ENGINE=MyISAM DEFAULT CHARSET=utf8;";

	foreach($sql as $sk => $sv){
		$wpdb->query($sv);
	}
	
	add_option('loginizer_version', LOGINIZER_VERSION);
	add_option('loginizer_options', array());
	add_option('loginizer_last_reset', 0);
	add_option('loginizer_whitelist', array());
	add_option('loginizer_blacklist', array());

}

// Checks if we are to update ?
function loginizer_update_check(){

global $wpdb;

	$sql = array();
	$current_version = get_option('loginizer_version');
	
	// It must be the 1.0 pre stuff
	if(empty($current_version)){
		$current_version = get_option('lz_version');
	}
	
	$version = (int) str_replace('.', '', $current_version);
	
	// No update required
	if($current_version == LOGINIZER_VERSION){
		return true;
	}
	
	// Is it first run ?
	if(empty($current_version)){
		
		// Reinstall
		loginizer_activation();
		
		// Trick the following if conditions to not run
		$version = (int) str_replace('.', '', LOGINIZER_VERSION);
		
	}
	
	// Is it less than 1.0.1 ?
	if($version < 101){
		
		// TODO : GET the existing settings
	
		// Get the existing settings		
		$lz_failed_logs = lz_selectquery("SELECT * FROM `".$wpdb->prefix."lz_failed_logs`;", 1);
		$lz_options = lz_selectquery("SELECT * FROM `".$wpdb->prefix."lz_options`;", 1);
		$lz_iprange = lz_selectquery("SELECT * FROM `".$wpdb->prefix."lz_iprange`;", 1);
				
		// Delete the three tables
		$sql = array();
		$sql[] = "DROP TABLE IF EXISTS ".$wpdb->prefix."lz_failed_logs;";
		$sql[] = "DROP TABLE IF EXISTS ".$wpdb->prefix."lz_options;";
		$sql[] = "DROP TABLE IF EXISTS ".$wpdb->prefix."lz_iprange;";

		foreach($sql as $sk => $sv){
			$wpdb->query($sv);
		}
		
		// Delete option
		delete_option('lz_version');
	
		// Reinstall
		loginizer_activation();
	
		// TODO : Save the existing settings

		// Update the existing failed logs to new table
		if(is_array($lz_failed_logs)){
			foreach($lz_failed_logs as $fk => $fv){
				$wpdb->query("INSERT INTO ".$wpdb->prefix."loginizer_logs SET `username` = '".$fv['username']."', `time` = '".$fv['time']."', `count` = '".$fv['count']."', `lockout` = '".$fv['lockout']."', `ip` = '".$fv['ip']."';");
			}			
		}

		// Update the existing options to new structure
		if(is_array($lz_options)){
			foreach($lz_options as $ok => $ov){
				
				if($ov['option_name'] == 'lz_last_reset'){
					update_option('loginizer_last_reset', $ov['option_value']);
					continue;
				}
				
				$old_option[str_replace('lz_', '', $ov['option_name'])] = $ov['option_value'];
			}
			// Save the options
			update_option('loginizer_options', $old_option);
		}

		// Update the existing iprange to new structure
		if(is_array($lz_iprange)){
			
			$old_blacklist = array();
			$old_whitelist = array();
			$bid = 1;
			$wid = 1;
			foreach($lz_iprange as $ik => $iv){
				
				if(!empty($iv['blacklist'])){
					$old_blacklist[$bid] = array();
					$old_blacklist[$bid]['start'] = long2ip($iv['start']);
					$old_blacklist[$bid]['end'] = long2ip($iv['end']);
					$old_blacklist[$bid]['time'] = strtotime($iv['date']);
					$bid = $bid + 1;
				}
				
				if(!empty($iv['whitelist'])){
					$old_whitelist[$wid] = array();
					$old_whitelist[$wid]['start'] = long2ip($iv['start']);
					$old_whitelist[$wid]['end'] = long2ip($iv['end']);
					$old_whitelist[$wid]['time'] = strtotime($iv['date']);
					$wid = $wid + 1;
				}
			}
			
			if(!empty($old_blacklist)) update_option('loginizer_blacklist', $old_blacklist);
			if(!empty($old_whitelist)) update_option('loginizer_whitelist', $old_whitelist);
		}
		
	}
	
	// Save the new Version
	update_option('loginizer_version', LOGINIZER_VERSION);
	
}

// Add the action to load the plugin 
add_action('plugins_loaded', 'loginizer_load_plugin');

// The function that will be called when the plugin is loaded
function loginizer_load_plugin(){
	
	global $loginizer;
	
	// Check if the installed version is outdated
	loginizer_update_check();
	
	// Set the array
	$loginizer = array();
	
	// The IP Method to use
	$loginizer['ip_method'] = get_option('loginizer_ip_method');
	
	// Load settings
	$options = get_option('loginizer_options');
	$loginizer['max_retries'] = empty($options['max_retries']) ? 3 : $options['max_retries'];
	$loginizer['lockout_time'] = empty($options['lockout_time']) ? 900 : $options['lockout_time']; // 15 minutes
	$loginizer['max_lockouts'] = empty($options['max_lockouts']) ? 5 : $options['max_lockouts'];
	$loginizer['lockouts_extend'] = empty($options['lockouts_extend']) ? 86400 : $options['lockouts_extend']; // 24 hours
	$loginizer['reset_retries'] = empty($options['reset_retries']) ? 86400 : $options['reset_retries']; // 24 hours
	$loginizer['notify_email'] = empty($options['notify_email']) ? 0 : $options['notify_email'];
		
	// Load the blacklist and whitelist
	$loginizer['blacklist'] = get_option('loginizer_blacklist');
	$loginizer['whitelist'] = get_option('loginizer_whitelist');
	
	// When was the database cleared last time
	$loginizer['last_reset']  = get_option('loginizer_last_reset');
	
	//print_r($loginizer);
	
	// Clear retries
	if((time() - $loginizer['last_reset']) >= $loginizer['reset_retries']){
		loginizer_reset_retries();
	}
	
	$ins_time = get_option('loginizer_ins_time');
	if(empty($ins_time)){
		$ins_time = time();
		update_option('loginizer_ins_time', $ins_time);
	}
	$loginizer['ins_time'] = $ins_time;
	
	// Set the current IP
	$loginizer['current_ip'] = lz_getip();

	/* Filters and actions */
	
	// Use this to verify before WP tries to login
	// Is always called and is the first function to be called
	//add_action('wp_authenticate', 'loginizer_wp_authenticate', 10, 2);// Not called by XML-RPC
	add_filter('authenticate', 'loginizer_wp_authenticate', 10001, 3);// This one is called by xmlrpc as well as GUI
	
	// Is called when a login attempt fails
	// Hence Update our records that the login failed
	add_action('wp_login_failed', 'loginizer_login_failed');
	
	// Is called before displaying the error message so that we dont show that the username is wrong or the password
	// Update Error message
	add_action('wp_login_errors', 'loginizer_error_handler', 10001, 2);
	
	// Is the premium features there ?
	if(file_exists(LOGINIZER_DIR.'/premium.php')){
		
		// Include the file
		include_once(LOGINIZER_DIR.'/premium.php');
		
		loginizer_security_init();
	
	// Its the free version
	}else{
		
		// The promo time
		$loginizer['promo_time'] = get_option('loginizer_promo_time');
		if(empty($loginizer['promo_time'])){
			$loginizer['promo_time'] = time();
			update_option('loginizer_promo_time', $loginizer['promo_time']);
		}
		
		// Are we to show the loginizer promo
		if(!empty($loginizer['promo_time']) && $loginizer['promo_time'] > 0 && $loginizer['promo_time'] < (time() - (30*24*3600))){
		
			add_action('admin_notices', 'loginizer_promo');
		
		}
		
		// Are we to disable the promo
		if(isset($_GET['loginizer_promo']) && (int)$_GET['loginizer_promo'] == 0){
			update_option('loginizer_promo_time', (0 - time()) );
			die('DONE');
		}
		
	}

}

// Show the promo
function loginizer_promo(){
	
	echo '
<style>
.lz_button {
background-color: #4CAF50; /* Green */
border: none;
color: white;
padding: 8px 16px;
text-align: center;
text-decoration: none;
display: inline-block;
font-size: 16px;
margin: 4px 2px;
-webkit-transition-duration: 0.4s; /* Safari */
transition-duration: 0.4s;
cursor: pointer;
}

.lz_button:focus{
border: none;
color: white;
}

.lz_button1 {
color: white;
background-color: #4CAF50;
border:3px solid #4CAF50;
}

.lz_button1:hover {
box-shadow: 0 6px 8px 0 rgba(0,0,0,0.24), 0 9px 25px 0 rgba(0,0,0,0.19);
color: white;
border:3px solid #4CAF50;
}

.lz_button2 {
color: white;
background-color: #0085ba;
}

.lz_button2:hover {
box-shadow: 0 6px 8px 0 rgba(0,0,0,0.24), 0 9px 25px 0 rgba(0,0,0,0.19);
color: white;
}

.lz_button3 {
color: white;
background-color: #365899;
}

.lz_button3:hover {
box-shadow: 0 6px 8px 0 rgba(0,0,0,0.24), 0 9px 25px 0 rgba(0,0,0,0.19);
color: white;
}

.lz_button4 {
color: white;
background-color: rgb(66, 184, 221);
}

.lz_button4:hover {
box-shadow: 0 6px 8px 0 rgba(0,0,0,0.24), 0 9px 25px 0 rgba(0,0,0,0.19);
color: white;
}

.loginizer_promo-close{
float:right;
text-decoration:none;
margin: 5px 10px 0px 0px;
}

.loginizer_promo-close:hover{
color: red;
}
</style>	

<script>
jQuery(document).ready( function() {
	(function($) {
		$("#loginizer_promo .loginizer_promo-close").click(function(){
			var data;
			
			// Hide it
			$("#loginizer_promo").hide();
			
			// Save this preference
			$.post("'.admin_url('?loginizer_promo=0').'", data, function(response) {
				//alert(response);
			});
		});
	})(jQuery);
});
</script>

<div class="notice notice-success" id="loginizer_promo" style="min-height:120px">
	<a class="loginizer_promo-close" href="javascript:" aria-label="Dismiss this Notice">
		<span class="dashicons dashicons-dismiss"></span> Dismiss
	</a>
	<img src="'.LOGINIZER_URL.'/loginizer-200.png" style="float:left; margin:10px 20px 10px 10px" width="100" />
	<p style="font-size:16px">We are glad you like Loginizer and have been using it since the past few days. It is time to take the next step </p>
	<p>
		<a class="lz_button lz_button1" target="_blank" href="https://loginizer.com/features">Upgrade to Pro</a>
		<a class="lz_button lz_button2" target="_blank" href="https://wordpress.org/support/view/plugin-reviews/loginizer">Rate it 5★\'s</a>
		<a class="lz_button lz_button3" target="_blank" href="https://www.facebook.com/Loginizer-815504798591884/">Like Us on Facebook</a>
		<a class="lz_button lz_button4" target="_blank" href="https://twitter.com/home?status='.rawurlencode('I use @loginizer to secure my #WordPress site - https://loginizer.com').'">Tweet about Loginizer</a>
	</p>
</div>';

}

// Should return NULL if everything is fine
function loginizer_wp_authenticate($user, $username, $password){
	
	global $loginizer, $lz_error, $lz_cannot_login, $lz_user_pass;
	
	if(!empty($username) && !empty($password)){
		$lz_user_pass = 1;
	}
	
	// Are you whitelisted ?
	if(loginizer_is_whitelisted()){
		$loginizer['ip_is_whitelisted'] = 1;
		return $user;
	}
	
	// Are you blacklisted ?
	if(loginizer_is_blacklisted()){
		$lz_cannot_login = 1;
		return new WP_Error('ip_blacklisted', implode('', $lz_error), 'loginizer');
	}
	
	// Is the username blacklisted ?
	if(function_exists('loginizer_user_blacklisted')){
		if(loginizer_user_blacklisted($username)){
			$lz_cannot_login = 1;
			return new WP_Error('user_blacklisted', implode('', $lz_error), 'loginizer');
		}
	}
	
	if(loginizer_can_login()){
		return $user;
	}
	
	$lz_cannot_login = 1;
	
	return new WP_Error('ip_blocked', implode('', $lz_error), 'loginizer');
	
}

function loginizer_can_login(){
	
	global $wpdb, $loginizer, $lz_error;
	
	// Get the logs
	$result = lz_selectquery("SELECT * FROM `".$wpdb->prefix."loginizer_logs` WHERE `ip` = '".$loginizer['current_ip']."';");
	
	if(!empty($result['count']) && ($result['count'] % $loginizer['max_retries']) == 0){
		
		// Has he reached max lockouts ?
		if($result['lockout'] >= $loginizer['max_lockouts']){
			$loginizer['lockout_time'] = $loginizer['lockouts_extend'];
		}
		
		// Is he in the lockout time ?
		if($result['time'] >= (time() - $loginizer['lockout_time'])){
			$banlift = ceil((($result['time'] + $loginizer['lockout_time']) - time()) / 60);
			
			//echo 'Current Time '.date('m/d/Y H:i:s', time()).'<br />';
			//echo 'Last attempt '.date('m/d/Y H:i:s', $result['time']).'<br />';
			//echo 'Unlock Time '.date('m/d/Y H:i:s', $result['time'] + $loginizer['lockout_time']).'<br />';
			
			$_time = $banlift.' minute(s)';
			
			if($banlift > 60){
				$banlift = ceil($banlift / 60);
				$_time = $banlift.' hour(s)';
			}
			
			$lz_error['ip_blocked'] = 'You have exceeded maximum login retries<br /> Please try after '.$_time;
			
			return false;
		}
	}
	
	return true;
}

function loginizer_is_blacklisted(){
	
	global $wpdb, $loginizer, $lz_error;
	
	$blacklist = $loginizer['blacklist'];
			
	foreach($blacklist as $k => $v){
		
		// Is the IP in the blacklist ?
		if(ip2long($v['start']) <= ip2long($loginizer['current_ip']) && ip2long($loginizer['current_ip']) <= ip2long($v['end'])){
			$result = 1;
			break;
		}
		
		// Is it in a wider range ?
		if(ip2long($v['start']) >= 0 && ip2long($v['end']) < 0){
			
			// Since the end of the RANGE (i.e. current IP range) is beyond the +ve value of ip2long, 
			// if the current IP is <= than the start of the range, it is within the range
			// OR
			// if the current IP is <= than the end of the range, it is within the range
			if(ip2long($v['start']) <= ip2long($loginizer['current_ip'])
				|| ip2long($loginizer['current_ip']) <= ip2long($v['end'])){				
				$result = 1;
				break;
			}
			
		}
		
	}
		
	// You are blacklisted
	if(!empty($result)){
		$lz_error['ip_blacklisted'] = 'Your IP has been blacklisted';
		return true;
	}
	
	return false;
	
}

function loginizer_is_whitelisted(){
	
	global $wpdb, $loginizer, $lz_error;
	
	$whitelist = $loginizer['whitelist'];
			
	foreach($whitelist as $k => $v){
		
		// Is the IP in the blacklist ?
		if(ip2long($v['start']) <= ip2long($loginizer['current_ip']) && ip2long($loginizer['current_ip']) <= ip2long($v['end'])){
			$result = 1;
			break;
		}
		
		// Is it in a wider range ?
		if(ip2long($v['start']) >= 0 && ip2long($v['end']) < 0){
			
			// Since the end of the RANGE (i.e. current IP range) is beyond the +ve value of ip2long, 
			// if the current IP is <= than the start of the range, it is within the range
			// OR
			// if the current IP is <= than the end of the range, it is within the range
			if(ip2long($v['start']) <= ip2long($loginizer['current_ip'])
				|| ip2long($loginizer['current_ip']) <= ip2long($v['end'])){				
				$result = 1;
				break;
			}
			
		}
		
	}
		
	// You are whitelisted
	if(!empty($result)){
		return true;
	}
	
	return false;
	
}


// When the login fails, then this is called
// We need to update the database
function loginizer_login_failed($username){
	
	global $wpdb, $loginizer, $lz_cannot_login;

	if(empty($lz_cannot_login) && empty($loginizer['ip_is_whitelisted']) && empty($loginizer['no_loginizer_logs'])){
		
		$result = lz_selectquery("SELECT * FROM `".$wpdb->prefix."loginizer_logs` WHERE `ip` = '".$loginizer['current_ip']."';");
		
		if(!empty($result)){
			$lockout = floor((($result['count']+1) / $loginizer['max_retries']));
			$sresult = $wpdb->query("UPDATE `".$wpdb->prefix."loginizer_logs` SET `username` = '".$username."', `time` = '".time()."', `count` = `count`+1, `lockout` = '".$lockout."' WHERE `ip` = '".$loginizer['current_ip']."';");
			
			// Do we need to email admin ?
			if(!empty($loginizer['notify_email']) && $lockout >= $loginizer['notify_email']){
				
				$sitename = lz_is_multisite() ? get_site_option('site_name') : get_option('blogname');
				$mail = array();
				$mail['to'] = lz_is_multisite() ? get_site_option('admin_email') : get_option('admin_email');	
				$mail['subject'] = 'Failed Login Attempts from IP '.$loginizer['current_ip'].' ('.$sitename.')';
				$mail['message'] = 'Hi,

'.($result['count']+1).' failed login attempts and '.$lockout.' lockout(s) from IP '.$loginizer['current_ip'].'

Last Login Attempt : '.date('d/m/Y H:i:s', time()).'
Last User Attempt : '.$username.'
IP has been blocked until : '.date('d/m/Y H:i:s', time() + $loginizer['lockout_time']).'

Regards,
Loginizer';

				@wp_mail($mail['to'], $mail['subject'], $mail['message']);
			}
		}else{
			$insert = $wpdb->query("INSERT INTO `".$wpdb->prefix."loginizer_logs` SET `username` = '".$username."', `time` = '".time()."', `count` = '1', `ip` = '".$loginizer['current_ip']."', `lockout` = '0';");
		}
	
		// We need to add one as this is a failed attempt as well
		$result['count'] = $result['count'] + 1;
		$loginizer['retries_left'] = ($loginizer['max_retries'] - ($result['count'] % $loginizer['max_retries']));
		$loginizer['retries_left'] = $loginizer['retries_left'] == $loginizer['max_retries'] ? 0 : $loginizer['retries_left'];
		
	}
}

// Handles the error of the password not being there
function loginizer_error_handler($errors, $redirect_to){
	
	global $wpdb, $loginizer, $lz_user_pass, $lz_cannot_login;
	
	//echo 'loginizer_error_handler :';print_r($errors->errors);echo '<br>';
	
	// Remove the empty password error
	if(is_wp_error($errors)){
		
		$codes = $errors->get_error_codes();
		
		foreach($codes as $k => $v){
			if($v == 'invalid_username' || $v == 'incorrect_password'){
				$show_error = 1;
			}
		}
		
		$errors->remove('invalid_username');
		$errors->remove('incorrect_password');
		
	}
	
	// Add the error
	if(!empty($lz_user_pass) && !empty($show_error) && empty($lz_cannot_login)){
		$errors->add('invalid_userpass', '<b>ERROR:</b> Incorrect Username or Password');
	}
	
	// Add the number of retires left as well
	if(count($errors->get_error_codes()) > 0 && isset($loginizer['retries_left'])){
		$errors->add('retries_left', loginizer_retries_left());
	}
	
	return $errors;
	
}

// Returns a string with the number of retries left
function loginizer_retries_left(){
	
	global $wpdb, $loginizer, $lz_user_pass, $lz_cannot_login;
	
	// If we are to show the number of retries left
	if(isset($loginizer['retries_left'])){
		return '<b>'.$loginizer['retries_left'].'</b> attempt(s) left';
	}
	
}

function loginizer_reset_retries(){
	
	global $wpdb, $loginizer;
	
	$deltime = time() - $loginizer['reset_retries'];	
	$result = $wpdb->query("DELETE FROM `".$wpdb->prefix."loginizer_logs` WHERE `time` <= '".$deltime."';");
	
	update_option('loginizer_last_reset', time());
	
}

add_filter("plugin_action_links_$plugin_loginizer", 'loginizer_plugin_action_links');

// Add settings link on plugin page
function loginizer_plugin_action_links($links) {
	
	if(!defined('LOGINIZER_PREMIUM')){
		 $links[] = '<a href="'.LOGINIZER_PRO_URL.'" style="color:#3db634;" target="_blank">'._x('Upgrade', 'Plugin action link label.', 'loginizer').'</a>';
	}

	$settings_link = '<a href="admin.php?page=loginizer">Settings</a>';	
	array_unshift($links, $settings_link); 
	
	return $links;
}

add_action('admin_menu', 'loginizer_admin_menu');

// Shows the admin menu of Loginizer
function loginizer_admin_menu() {
	
	global $wp_version, $loginizer;
	
	// Add the menu page
	add_menu_page(__('Loginizer Dashboard'), __('Loginizer Security'), 'activate_plugins', 'loginizer', 'loginizer_page_dashboard');
	
	// Dashboard
	add_submenu_page('loginizer', __('Loginizer Dashboard'), __('Dashboard'), 'activate_plugins', 'loginizer', 'loginizer_page_dashboard');
	
	// Brute Force
	add_submenu_page('loginizer', __('Loginizer Brute Force Settings'), __('Brute Force'), 'activate_plugins', 'loginizer_brute_force', 'loginizer_page_brute_force');
	
	if(defined('LOGINIZER_PREMIUM')){
	
		// PasswordLess
		add_submenu_page('loginizer', __('Loginizer PasswordLess Settings'), __('PasswordLess'), 'activate_plugins', 'loginizer_passwordless', 'loginizer_page_passwordless');
		
		// Two Factor Auth
		add_submenu_page('loginizer', __('Loginizer Two Factor Authentication'), __('Two Factor Auth'), 'activate_plugins', 'loginizer_2fa', 'loginizer_page_2fa');
		
		// reCaptcha
		add_submenu_page('loginizer', __('Loginizer reCAPTCHA Settings'), __('reCAPTCHA'), 'activate_plugins', 'loginizer_recaptcha', 'loginizer_page_recaptcha');
		
		// Security Settings
		add_submenu_page('loginizer', __('Loginizer Security Settings'), __('Security Settings'), 'activate_plugins', 'loginizer_security', 'loginizer_page_security');
		
		// Security Settings
		add_submenu_page('loginizer', __('Loginizer File Checksums'), __('File Checksums'), 'activate_plugins', 'loginizer_checksums', 'loginizer_page_checksums');
	
	}elseif(!defined('LOGINIZER_PREMIUM') && !empty($loginizer['ins_time']) && $loginizer['ins_time'] < (time() - (30*24*3600))){
		
		// Go Pro link
		add_submenu_page('loginizer', __('Loginizer Go Pro'), __('Go Pro'), 'activate_plugins', LOGINIZER_PRO_URL);
		
	}
	
}

// The Loginizer Admin Options Page
function loginizer_page_header($title = 'Loginizer'){
	/*wp_enqueue_script('common');
	wp_enqueue_script('wp-lists');
	wp_enqueue_script('postbox');
	wp_nonce_field('closedpostboxes', 'closedpostboxesnonce', false);
	
	echo '
<script>
jQuery(document).ready( function() {
	//add_postbox_toggles("loginizer");
});
</script>';*/

?>
<style>
.lz-right-ul{
	padding-left: 10px !important;
}

.lz-right-ul li{
	list-style: circle !important;
}
</style>
<?php
	
	echo '<div style="margin: 10px 20px 0 2px;">	
<div class="metabox-holder columns-2">
<div class="postbox-container">	
<div id="top-sortables" class="meta-box-sortables ui-sortable">
	
	<table cellpadding="2" cellspacing="1" width="100%" class="fixed" border="0">
		<tr>
			<td valign="top"><h3>'.$title.'</h3></td>
			<td align="right"><a target="_blank" class="button button-primary" href="https://wordpress.org/support/view/plugin-reviews/loginizer">Review Loginizer</a></td>
			<td align="right" width="40"><a target="_blank" href="https://twitter.com/loginizer"><img src="'.LOGINIZER_URL.'/twitter.png" /></a></td>
			<td align="right" width="40"><a target="_blank" href="https://www.facebook.com/Loginizer-815504798591884"><img src="'.LOGINIZER_URL.'/facebook.png" /></a></td>
		</tr>
	</table>
	<hr />
	
	<!--Main Table-->
	<table cellpadding="8" cellspacing="1" width="100%" class="fixed">
	<tr>
		<td valign="top">';

}

// The Loginizer Theme footer
function loginizer_page_footer(){
	
	echo '</td>
	<td width="200" valign="top" id="loginizer-right-bar">';
	
	if(!defined('LOGINIZER_PREMIUM')){
		
		echo '
		<div class="postbox" style="min-width:0px !important;">
			<h2 class="hndle ui-sortable-handle">
				<span>Premium Version</span>
			</h2>
			<div class="inside">
				<i>Upgrade to the premium version and get the following features </i>:<br>
				<ul class="lz-right-ul">
					<li>PasswordLess Login</li>
					<li>Two Factor Auth - Email</li>
					<li>Two Factor Auth - App</li>
					<li>Login Challenge Question</li>
					<li>reCAPTCHA</li>
					<li>Rename Login Page</li>
					<li>Disable XML-RPC</li>
					<li>And many more ...</li>
				</ul>
				<center><a class="button button-primary" href="https://loginizer.com/members/cart.php">Upgrade</a></center>
			</div>
		</div>';
		
	}else{
	
		echo '
		<div class="postbox" style="min-width:0px !important;">
			<h2 class="hndle ui-sortable-handle">
				<span>Recommendations</span>
			</h2>
			<div class="inside">
				<i>We recommed that you enable atleast one of the following security features</i>:<br>
				<ul class="lz-right-ul">
					<li>Rename Login Page</li>
					<li>Login Challenge Question</li>
					<li>reCAPTCHA</li>
					<li>Two Factor Auth - Email</li>
					<li>Two Factor Auth - App</li>
					<li>Change \'admin\' Username</li>
				</ul>
			</div>
		</div>';
	}
	
	echo '</td>
	</tr>
	</table>
	<br />
	<div style="width:45%;background:#FFF;padding:15px; margin:auto">
		<b>Let your friends know that you have secured your website :</b>
		<form method="get" action="http://twitter.com/intent/tweet" id="tweet" onsubmit="return dotweet(this);">
			<textarea name="text" cols="45" row="3" style="resize:none;">I just secured my @WordPress site against #bruteforce using @loginizer</textarea>
			&nbsp; &nbsp; <input type="submit" value="Tweet!" class="button button-primary" onsubmit="return false;" id="twitter-btn" style="margin-top:20px;"/>
		</form>
		
	</div>
	<br />
	
	<script>
	function dotweet(ele){
		window.open(jQuery("#"+ele.id).attr("action")+"?"+jQuery("#"+ele.id).serialize(), "_blank", "scrollbars=no, menubar=no, height=400, width=500, resizable=yes, toolbar=no, status=no");
		return false;
	}
	</script>
	
	<hr />
	<a href="http://loginizer.com" target="_blank">Loginizer</a> v'.LOGINIZER_VERSION.'. You can report any bugs <a href="http://wordpress.org/support/plugin/loginizer" target="_blank">here</a>.

</div>	
</div>
</div>
</div>';

}

// The Loginizer Admin Options Page
function loginizer_page_dashboard(){
	
	global $loginizer, $lz_error, $lz_env;

	// Is there a license key ?
	if(isset($_POST['save_lz'])){
	
		$license = lz_optpost('lz_license');
		
		// Check if its a valid license
		if(empty($license)){
			$lz_error['lic_invalid'] = __('The license key was not submitted', 'loginizer');
			return loginizer_page_dashboard_T();
		}
		
		$resp = wp_remote_get(LOGINIZER_API.'license.php?license='.$license);
		
		if(is_array($resp)){
			$json = json_decode($resp['body'], true);
			//print_r($json);
		}
		
		// Save the License
		if(empty($json)){
		
			$lz_error['lic_invalid'] = __('The license key is invalid', 'loginizer');
			return loginizer_page_dashboard_T();
			
		}else{
			
			update_option('loginizer_license', $json);
			
			// Mark as saved
			$GLOBALS['lz_saved'] = true;
		}
		
	}
	
	
	// Is there a IP Method ?
	if(isset($_POST['save_lz_ip_method'])){
		
		$ip_method = (int) lz_optpost('lz_ip_method');
		
		if($ip_method >= 0 && $ip_method <= 2){
			update_option('loginizer_ip_method', $ip_method);
		}
		
	}
	
	loginizer_page_dashboard_T();
	
}

// The Loginizer Admin Options Page - THEME
function loginizer_page_dashboard_T(){
	
	global $loginizer, $lz_error, $lz_env;

	loginizer_page_header('Loginizer Dashboard');
?>
<style>
.welcome-panel{
	margin: 0px;
	padding: 10px;
}

input[type="text"], textarea, select {
    width: 70%;
}

.form-table label{
	font-weight:bold;
}

.exp{
	font-size:12px;
}
</style>
	
	<?php	
	echo '<script src="https://api.loginizer.com/'.(defined('LOGINIZER_PREMIUM') ? 'news_security.js' : 'news.js').'"></script><br>';

	// Saved ?
	if(!empty($GLOBALS['lz_saved'])){
		echo '<div id="message" class="updated"><p>'. __('The settings were saved successfully', 'loginizer'). '</p></div><br />';
	}
	
	// Any errors ?
	if(!empty($lz_error)){
		lz_report_error($lz_error);echo '<br />';
	}
	
	?>	
	
	<div class="postbox">
	
		<button class="handlediv button-link" aria-expanded="true" type="button">
			<span class="screen-reader-text">Toggle panel: Getting Started</span>
			<span class="toggle-indicator" aria-hidden="true"></span>
		</button>
		
		<h2 class="hndle ui-sortable-handle">
			<span><?php echo __('Getting Started', 'loginizer'); ?></span>
		</h2>
		
		<div class="inside">
		
		<form action="" method="post" enctype="multipart/form-data">
		<?php wp_nonce_field('loginizer-options'); ?>
		<table class="form-table">
			<tr>
				<td scope="row" valign="top" colspan="2" style="line-height:150%">
					<i>Welcome to Loginizer Security. By default the <b>Brute Force Protection</b> is immediately enabled. You should start by going over the default settings and tweaking them as per your needs.</i>
					<?php 
					if(defined('LOGINIZER_PREMIUM')){
						echo '<br><i>In the Premium version of Loginizer you have many more features. We recommend you enable features like <b>reCAPTCHA, Two Factor Auth or Email based PasswordLess</b> login. These features will improve your websites security.</i>';
					} 
					?>
				</td>
			</tr>
		</table>
		</form>
		
		</div>
	</div>
	
	<div class="postbox">
	
		<button class="handlediv button-link" aria-expanded="true" type="button">
			<span class="screen-reader-text">Toggle panel: System Information</span>
			<span class="toggle-indicator" aria-hidden="true"></span>
		</button>
		
		<h2 class="hndle ui-sortable-handle">
			<span><?php echo __('System Information', 'loginizer'); ?></span>
		</h2>
		
		<div class="inside">
		
		<form action="" method="post" enctype="multipart/form-data">
		<?php wp_nonce_field('loginizer-options'); ?>
		<table class="wp-list-table fixed striped users" cellspacing="1" border="0" width="95%" cellpadding="10" align="center">
		<?php
			echo '
			<tr>				
				<th align="left" width="25%">'.__('Loginizer Version', 'loginizer').'</th>
				<td>'.LOGINIZER_VERSION.(defined('LOGINIZER_PREMIUM') ? ' (Security PRO Version)' : '').'</td>
			</tr>';
			
			if(defined('LOGINIZER_PREMIUM')){
			echo '
			<tr>			
				<th align="left" valign="top">'.__('Loginizer License', 'loginizer').'</th>
				<td align="left">
					'.(empty($loginizer['license']) ? '<span style="color:red">Unlicensed</span> &nbsp; &nbsp;' : '').' 
					<input type="text" name="lz_license" value="'.(empty($loginizer['license']) ? '' : $loginizer['license']['license']).'" size="30" placeholder="e.g. WXCSE-SFJJX-XXXXX-AAAAA-BBBBB" style="width:300px;" /> &nbsp; 
					<input name="save_lz" class="button button-primary" value="Update License" type="submit" />';
					
					if(!empty($loginizer['license'])){
						
						$expires = $loginizer['license']['expires'];
						$expires = substr($expires, 0, 4).'/'.substr($expires, 4, 2).'/'.substr($expires, 6);
						
						echo '<div style="margin-top:10px;">License Active : '.(empty($loginizer['license']['active']) ? '<span style="color:red">No</span>' : 'Yes').' &nbsp; &nbsp; &nbsp; 
						License Expires : '.($loginizer['license']['expires'] <= date('Ymd') ? '<span style="color:red">'.$expires.'</span>' : $expires).'
						</div>';
					}
					
					
				echo 
				'</td>
			</tr>';
			}
			
			echo '<tr>
				<th align="left">'.__('URL', 'loginizer').'</th>
				<td>'.get_site_url().'</td>
			</tr>
			<tr>				
				<th align="left">'.__('Path', 'loginizer').'</th>
				<td>'.ABSPATH.'</td>
			</tr>
			<tr>				
				<th align="left">'.__('Server\'s IP Address', 'loginizer').'</th>
				<td>'.$_SERVER['SERVER_ADDR'].'</td>
			</tr>
			<tr>				
				<th align="left">'.__('Your IP Address', 'loginizer').'</th>
				<td>'.lz_getip().'
					<div style="float:right">
						Method : 
						<select name="lz_ip_method" style="font-size:11px; width:150px">
							<option value="0" '.lz_POSTselect('lz_ip_method', 0, (@$loginizer['ip_method'] == 0)).'>REMOTE_ADDR</option>
							<option value="1" '.lz_POSTselect('lz_ip_method', 1, (@$loginizer['ip_method'] == 1)).'>HTTP_X_FORWARDED_FOR</option>
							<option value="2" '.lz_POSTselect('lz_ip_method', 2, (@$loginizer['ip_method'] == 2)).'>HTTP_CLIENT_IP</option>
						</select>
						<input name="save_lz_ip_method" class="button button-primary" value="Save" type="submit" />
					</div>
				</td>
			</tr>
			<tr>				
				<th align="left">'.__('wp-config.php is writable', 'loginizer').'</th>
				<td>'.(is_writable(ABSPATH.'/wp-config.php') ? '<span style="color:red">Yes</span>' : '<span style="color:green">No</span>').'</td>
			</tr>';
			
			if(file_exists(ABSPATH.'/.htaccess')){
				echo '
			<tr>				
				<th align="left">'.__('.htaccess is writable', 'loginizer').'</th>
				<td>'.(is_writable(ABSPATH.'/.htaccess') ? '<span style="color:red">Yes</span>' : '<span style="color:green">No</span>').'</td>
			</tr>';
			
			}
			
		?>
		</table>
		</form>
		
		</div>
	</div>
	
	<div id="" class="postbox">
	
		<button class="handlediv button-link" aria-expanded="true" type="button">
			<span class="screen-reader-text">Toggle panel: File Permissions</span>
			<span class="toggle-indicator" aria-hidden="true"></span>
		</button>
		
		<h2 class="hndle ui-sortable-handle">
			<span><?php echo __('File Permissions', 'loginizer'); ?></span>
		</h2>
		
		<div class="inside">
		
		<form action="" method="post" enctype="multipart/form-data">
		<?php wp_nonce_field('loginizer-options'); ?>
		<table class="wp-list-table fixed striped users" border="0" width="95%" cellpadding="10" align="center">
			<?php
			
			echo '
			<tr>
				<th style="background:#EFEFEF;">'.__('Relative Path', 'loginizer').'</th>
				<th style="width:10%; background:#EFEFEF;">'.__('Suggested', 'loginizer').'</th>
				<th style="width:10%; background:#EFEFEF;">'.__('Actual', 'loginizer').'</th>
			</tr>';
			
			$wp_content = basename(dirname(dirname(dirname(__FILE__))));
			
			$files_to_check = array('/' => '0755',
								'/wp-admin' => '0755',
								'/wp-includes' => '0755',
								'/wp-config.php' => '0444',
								'/'.$wp_content => '0755',
								'/'.$wp_content.'/themes' => '0755',
								'/'.$wp_content.'/plugins' => '0755',
								'.htaccess' => '0444');
			
			$root = ABSPATH;
			
			foreach($files_to_check as $k => $v){
				
				$path = $root.'/'.$k;
				$stat = @stat($path);
				$suggested = $v;
				$actual = substr(sprintf('%o', $stat['mode']), -4);
				
				echo '
			<tr>
				<td>'.$k.'</td>
				<td>'.$suggested.'</td>
				<td><span '.($suggested != $actual ? 'style="color: red;"' : '').'>'.$actual.'</span></td>
			</tr>';
				
			}
			
			?>
		</table>
		</form>
		
		</div>
	</div>

<?php
	
	loginizer_page_footer();

}

// The Loginizer Admin Options Page
function loginizer_page_brute_force(){

	global $wpdb, $wp_roles, $loginizer;
	 
	if(!current_user_can('manage_options')){
		wp_die('Sorry, but you do not have permissions to change settings.');
	}

	/* Make sure post was from this page */
	if(count($_POST) > 0){
		check_admin_referer('loginizer-options');
	}
	
	// BEGIN THEME
	loginizer_page_header('Loginizer - Brute Force Settings');
	
	// Load the blacklist and whitelist
	$loginizer['blacklist'] = get_option('loginizer_blacklist');
	$loginizer['whitelist'] = get_option('loginizer_whitelist');
	
	if(isset($_POST['save_lz'])){
		
		$max_retries = (int) lz_optpost('max_retries');
		$lockout_time = (int) lz_optpost('lockout_time');
		$max_lockouts = (int) lz_optpost('max_lockouts');
		$lockouts_extend = (int) lz_optpost('lockouts_extend');
		$reset_retries = (int) lz_optpost('reset_retries');
		$notify_email = (int) lz_optpost('notify_email');
		
		$lockout_time = $lockout_time * 60;
		$lockouts_extend = $lockouts_extend * 60 * 60;
		$reset_retries = $reset_retries * 60 * 60;
		
		if(empty($error)){
			
			$option['max_retries'] = $max_retries;
			$option['lockout_time'] = $lockout_time;
			$option['max_lockouts'] = $max_lockouts;
			$option['lockouts_extend'] = $lockouts_extend;
			$option['reset_retries'] = $reset_retries;
			$option['notify_email'] = $notify_email;
			
			// Save the options
			update_option('loginizer_options', $option);
			
			$saved = true;
			
		}else{
			lz_report_error($error);
		}
	
		if(!empty($notice)){
			lz_report_notice($notice);	
		}
			
		if(!empty($saved)){
			echo '<div id="message" class="updated"><p>'
				. __('The settings were saved successfully', 'loginizer')
				. '</p></div><br />';
		}
	
	}
	
	// Delete a Blackist IP range
	if(isset($_GET['bdelid'])){
		
		$delid = (int) lz_optreq('bdelid');
		
		// Unset and save
		$blacklist = $loginizer['blacklist'];
		unset($blacklist[$delid]);
		update_option('loginizer_blacklist', $blacklist);
		
		echo '<div id="message" class="updated fade"><p>'
			. __('The Blacklist IP range has been deleted successfully', 'loginizer')
			. '</p></div><br />';
			
	}
	
	// Delete a Whitelist IP range
	if(isset($_GET['delid'])){
		
		$delid = (int) lz_optreq('delid');
		
		// Unset and save
		$whitelist = $loginizer['whitelist'];
		unset($whitelist[$delid]);
		update_option('loginizer_whitelist', $whitelist);
		
		echo '<div id="message" class="updated fade"><p>'
			. __('The Whitelist IP range has been deleted successfully', 'loginizer')
			. '</p></div><br />';
			
	}
	
	// Reset All Logs
	if(isset($_POST['lz_reset_all_ip'])){
	
		$result = $wpdb->query("DELETE FROM `".$wpdb->prefix."loginizer_logs` 
							WHERE `time` > 0");
			
		echo '<div id="message" class="updated fade"><p>'
					. __('All the IP Logs have been cleared', 'loginizer')
					. '</p></div><br />';
	}
	
	// Reset Logs
	if(isset($_POST['lz_reset_ips']) && is_array($_POST['lz_reset_ips'])){

		$ips = $_POST['lz_reset_ips'];
		
		foreach($ips as $ip){
			if(!lz_valid_ip($ip)){
				$error[] = 'The IP - '.$ip.' is invalid !';
			}
		}
		
		if(count($ips) < 1){
			$error[] = 'There are no IPs submitted';
		}
		
		// Should we start deleting logs
		if(empty($error)){
			
			$result = $wpdb->query("DELETE FROM `".$wpdb->prefix."loginizer_logs` 
							WHERE `ip` IN ('".implode("', '", $ips)."')");
		
			if(empty($error)){
				
				echo '<div id="message" class="updated fade"><p>'
						. __('The selected IP Logs have been reset', 'loginizer')
						. '</p></div><br />';
				
			}
			
		}
		
		if(!empty($error)){
			lz_report_error($error);echo '<br />';
		}
		
	}
	
	if(isset($_POST['blacklist_iprange'])){

		$start_ip = lz_optpost('start_ip');
		$end_ip = lz_optpost('end_ip');
		
		if(empty($start_ip)){
			$error[] = 'Please enter the Start IP';
		}
		
		// If no end IP we consider only 1 IP
		if(empty($end_ip)){
			$end_ip = $start_ip;
		}
				
		if(!lz_valid_ip($start_ip)){
			$error[] = 'Please provide a valid start IP';
		}
		
		if(!lz_valid_ip($end_ip)){
			$error[] = 'Please provide a valid end IP';			
		}
		
		// Regular ranges will work
		if(ip2long($start_ip) > ip2long($end_ip)){
			
			// BUT, if 0.0.0.1 - 255.255.255.255 is given, it will not work
			if(ip2long($start_ip) >= 0 && ip2long($end_ip) < 0){
				// This is right
			}else{
				$error[] = 'The End IP cannot be smaller than the Start IP';
			}
			
		}
		
		if(empty($error)){
			
			$blacklist = $loginizer['blacklist'];
			
			foreach($blacklist as $k => $v){
				
				// This is to check if there is any other range exists with the same Start or End IP
				if(( ip2long($start_ip) <= ip2long($v['start']) && ip2long($v['start']) <= ip2long($end_ip) )
					|| ( ip2long($start_ip) <= ip2long($v['end']) && ip2long($v['end']) <= ip2long($end_ip) )
				){
					$error[] = 'The Start IP or End IP submitted conflicts with an existing IP range !';
					break;
				}
				
				// This is to check if there is any other range exists with the same Start IP
				if(ip2long($v['start']) <= ip2long($start_ip) && ip2long($start_ip) <= ip2long($v['end'])){
					$error[] = 'The Start IP is present in an existing range !';
					break;
				}
				
				// This is to check if there is any other range exists with the same End IP
				if(ip2long($v['start']) <= ip2long($end_ip) && ip2long($end_ip) <= ip2long($v['end'])){
					$error[] = 'The End IP is present in an existing range!';
					break;
				}
				
			}
			
			$newid = ( empty($blacklist) ? 0 : max(array_keys($blacklist)) ) + 1;
		
			if(empty($error)){
				
				$blacklist[$newid] = array();
				$blacklist[$newid]['start'] = $start_ip;
				$blacklist[$newid]['end'] = $end_ip;
				$blacklist[$newid]['time'] = time();
				
				update_option('loginizer_blacklist', $blacklist);
				
				echo '<div id="message" class="updated fade"><p>'
						. __('Blacklist IP range added successfully', 'loginizer')
						. '</p></div><br />';
				
			}
			
		}
		
		if(!empty($error)){
			lz_report_error($error);echo '<br />';
		}
		
	}
	
	if(isset($_POST['whitelist_iprange'])){

		$start_ip = lz_optpost('start_ip_w');
		$end_ip = lz_optpost('end_ip_w');
		
		if(empty($start_ip)){
			$error[] = 'Please enter the Start IP';
		}
		
		// If no end IP we consider only 1 IP
		if(empty($end_ip)){
			$end_ip = $start_ip;
		}
				
		if(!lz_valid_ip($start_ip)){
			$error[] = 'Please provide a valid start IP';
		}
		
		if(!lz_valid_ip($end_ip)){
			$error[] = 'Please provide a valid end IP';			
		}
			
		if(ip2long($start_ip) > ip2long($end_ip)){
			
			// BUT, if 0.0.0.1 - 255.255.255.255 is given, it will not work
			if(ip2long($start_ip) >= 0 && ip2long($end_ip) < 0){
				// This is right
			}else{
				$error[] = 'The End IP cannot be smaller than the Start IP';
			}
			
		}
		
		if(empty($error)){
			
			$whitelist = $loginizer['whitelist'];
			
			foreach($whitelist as $k => $v){
				
				// This is to check if there is any other range exists with the same Start or End IP
				if(( ip2long($start_ip) <= ip2long($v['start']) && ip2long($v['start']) <= ip2long($end_ip) )
					|| ( ip2long($start_ip) <= ip2long($v['end']) && ip2long($v['end']) <= ip2long($end_ip) )
				){
					$error[] = 'The Start IP or End IP submitted conflicts with an existing IP range !';
					break;
				}
				
				// This is to check if there is any other range exists with the same Start IP
				if(ip2long($v['start']) <= ip2long($start_ip) && ip2long($start_ip) <= ip2long($v['end'])){
					$error[] = 'The Start IP is present in an existing range !';
					break;
				}
				
				// This is to check if there is any other range exists with the same End IP
				if(ip2long($v['start']) <= ip2long($end_ip) && ip2long($end_ip) <= ip2long($v['end'])){
					$error[] = 'The End IP is present in an existing range!';
					break;
				}
				
			}
			
			$newid = ( empty($whitelist) ? 0 : max(array_keys($whitelist)) ) + 1;
			
			if(empty($error)){
				
				$whitelist[$newid] = array();
				$whitelist[$newid]['start'] = $start_ip;
				$whitelist[$newid]['end'] = $end_ip;
				$whitelist[$newid]['time'] = time();
				
				update_option('loginizer_whitelist', $whitelist);
				
				echo '<div id="message" class="updated fade"><p>'
						. __('Whitelist IP range added successfully', 'loginizer')
						. '</p></div><br />';
				
			}
			
		}
		
		if(!empty($error)){
			lz_report_error($error);echo '<br />';
		}
	}
					
	// Count the Results
	$tmp = lz_selectquery("SELECT COUNT(*) AS num FROM `".$wpdb->prefix."loginizer_logs`");
	//print_r($tmp);
	
	// Which Page is it
	$lz_env['res_len'] = 10;
	$lz_env['cur_page'] = lz_get_page('lzpage', $lz_env['res_len']);
	$lz_env['num_res'] = $tmp['num'];
	$lz_env['max_page'] = ceil($lz_env['num_res'] / $lz_env['res_len']);
	
	// Get the logs
	$result = lz_selectquery("SELECT * FROM `".$wpdb->prefix."loginizer_logs` 
							ORDER BY `time` DESC 
							LIMIT ".$lz_env['cur_page'].", ".$lz_env['res_len']."", 1);
	//print_r($result);
	
	$lz_env['cur_page'] = ($lz_env['cur_page'] / $lz_env['res_len']) + 1;
	$lz_env['cur_page'] = $lz_env['cur_page'] < 1 ? 1 : $lz_env['cur_page'];
	$lz_env['next_page'] = ($lz_env['cur_page'] + 1) > $lz_env['max_page'] ? $lz_env['max_page'] : ($lz_env['cur_page'] + 1);
	$lz_env['prev_page'] = ($lz_env['cur_page'] - 1) < 1 ? 1 : ($lz_env['cur_page'] - 1);
	
	// Reload the settings
	$loginizer['blacklist'] = get_option('loginizer_blacklist');
	$loginizer['whitelist'] = get_option('loginizer_whitelist');
	
	?>

	<div id="" class="postbox">
	
		<button class="handlediv button-link" aria-expanded="true" type="button">
			<span class="screen-reader-text">Toggle panel: Failed Login Attempts Logs</span>
			<span class="toggle-indicator" aria-hidden="true"></span>
		</button>
		
		<h2 class="hndle ui-sortable-handle">
			<?php echo __('<span>Failed Login Attempts Logs</span> &nbsp; (Past '.($loginizer['reset_retries']/60/60).' hours)','loginizer'); ?>
		</h2>
		
		<script>
		function yesdsd(){
			window.location = '<?php echo menu_page_url('loginizer_brute_force', false);?>&lzpage='+jQuery("#current-page-selector").val();
			return false;
		}
		</script>
		
		<form method="get" onsubmit="return yesdsd();">
			<div class="tablenav">
				<p class="tablenav-pages" style="margin: 5px 10px" align="right">
					<span class="displaying-num"><?php echo $lz_env['num_res'];?> items</span>
					<span class="pagination-links">
						<a class="first-page" href="<?php echo menu_page_url('loginizer_brute_force', false).'&lzpage=1';?>"><span class="screen-reader-text">First page</span><span aria-hidden="true">«</span></a>
						<a class="prev-page" href="<?php echo menu_page_url('loginizer_brute_force', false).'&lzpage='.$lz_env['prev_page'];?>"><span class="screen-reader-text">Previous page</span><span aria-hidden="true">‹</span></a>
						<span class="paging-input">
							<label for="current-page-selector" class="screen-reader-text">Current Page</label>
							<input class="current-page" id="current-page-selector" name="lzpage" value="<?php echo $lz_env['cur_page'];?>" size="3" aria-describedby="table-paging" type="text"><span class="tablenav-paging-text"> of <span class="total-pages"><?php echo $lz_env['max_page'];?></span></span>
						</span>						
						<a class="next-page" href="<?php echo menu_page_url('loginizer_brute_force', false).'&lzpage='.$lz_env['next_page'];?>"><span class="screen-reader-text">Next page</span><span aria-hidden="true">›</span></a>
						<a class="last-page" href="<?php echo menu_page_url('loginizer_brute_force', false).'&lzpage='.$lz_env['max_page'];?>"><span class="screen-reader-text">Last page</span><span aria-hidden="true">»</span></a>
					</span>
				</p>
			</div>
		</form>
		
		<form action="" method="post" enctype="multipart/form-data">
		<?php wp_nonce_field('loginizer-options'); ?>
		<div class="inside">
		<table class="wp-list-table widefat fixed users" border="0">
			<tr>
				<th scope="row" valign="top" style="background:#EFEFEF;" width="20">#</th>
				<th scope="row" valign="top" style="background:#EFEFEF;"><?php echo __('IP','loginizer'); ?></th>
				<th scope="row" valign="top" style="background:#EFEFEF;"><?php echo __('Last Failed Attempt  (DD/MM/YYYY)','loginizer'); ?></th>
				<th scope="row" valign="top" style="background:#EFEFEF;"><?php echo __('Failed Attempts Count','loginizer'); ?></th>
				<th scope="row" valign="top" style="background:#EFEFEF;" width="150"><?php echo __('Lockouts Count','loginizer'); ?></th>
			</tr>
			<?php
			
			if(empty($result)){
				echo '
				<tr>
					<td colspan="4">
						No Logs. You will see logs about failed login attempts here.
					</td>
				</tr>';
			}else{
				foreach($result as $ik => $iv){
					$status_button = (!empty($iv['status']) ? 'disable' : 'enable');
					echo '
					<tr>
						<td>
							<input type="checkbox" value="'.$iv['ip'].'" name="lz_reset_ips[]" />
						</td>
						<td>
							'.$iv['ip'].'
						</td>
						<td>
							'.date('d/m/Y H:i:s', $iv['time']).'
						</td>
						<td>
							'.$iv['count'].'
						</td>
						<td>
							'.$iv['lockout'].'
						</td>
					</tr>';
				}
			}
			
			?>
		</table>
		
		<br>
		<input name="lz_reset_ip" class="button button-primary action" value="<?php echo __('Remove From Logs', 'loginizer'); ?>" type="submit" />
		&nbsp; &nbsp; 
		<input name="lz_reset_all_ip" class="button button-primary action" value="<?php echo __('Clear All Logs', 'loginizer'); ?>" type="submit" />
		</div>
	</div>
	</form>
	<br />
	
	<div id="" class="postbox">
	
		<button class="handlediv button-link" aria-expanded="true" type="button">
			<span class="screen-reader-text">Toggle panel: Brute Force Settings</span>
			<span class="toggle-indicator" aria-hidden="true"></span>
		</button>
		
		<h2 class="hndle ui-sortable-handle">
			<span><?php echo __('Brute Force Settings', 'loginizer'); ?></span>
		</h2>
		
		<div class="inside">
		
		<form action="" method="post" enctype="multipart/form-data">
		<?php wp_nonce_field('loginizer-options'); ?>
		<table class="form-table">
			<tr>
				<th scope="row" valign="top"><label for="max_retries"><?php echo __('Max Retries','loginizer'); ?></label></th>
				<td>
					<input type="text" size="3" value="<?php echo lz_optpost('max_retries', $loginizer['max_retries']); ?>" name="max_retries" id="max_retries" /> <?php echo __('Maximum failed attempts allowed before lockout','loginizer'); ?> <br />
				</td>
			</tr>
			<tr>
				<th scope="row" valign="top"><label for="lockout_time"><?php echo __('Lockout Time','loginizer'); ?></label></th>
				<td>
				<input type="text" size="3" value="<?php echo (!empty($lockout_time) ? $lockout_time : $loginizer['lockout_time']) / 60; ?>" name="lockout_time" id="lockout_time" /> <?php echo __('minutes','loginizer'); ?> <br />
				</td>
			</tr>
			<tr>
				<th scope="row" valign="top"><label for="max_lockouts"><?php echo __('Max Lockouts','loginizer'); ?></label></th>
				<td>
					<input type="text" size="3" value="<?php echo lz_optpost('max_lockouts', $loginizer['max_lockouts']); ?>" name="max_lockouts" id="max_lockouts" /> <?php echo __('','loginizer'); ?> <br />
				</td>
			</tr>
			<tr>
				<th scope="row" valign="top"><label for="lockouts_extend"><?php echo __('Extend Lockout','loginizer'); ?></label></th>
				<td>
					<input type="text" size="3" value="<?php echo (!empty($lockouts_extend) ? $lockouts_extend : $loginizer['lockouts_extend']) / 60 / 60; ?>" name="lockouts_extend" id="lockouts_extend" /> <?php echo __('hours. Extend Lockout time after Max Lockouts','loginizer'); ?> <br />
				</td>
			</tr>
			<tr>
				<th scope="row" valign="top"><label for="reset_retries"><?php echo __('Reset Retries','loginizer'); ?></label></th>
				<td>
					<input type="text" size="3" value="<?php echo (!empty($reset_retries) ? $reset_retries : $loginizer['reset_retries']) / 60 / 60; ?>" name="reset_retries" id="reset_retries" /> <?php echo __('hours','loginizer'); ?> <br />
				</td>
			</tr>
			<tr>
				<th scope="row" valign="top"><label for="notify_email"><?php echo __('Email Notification','loginizer'); ?></label></th>
				<td>
					<?php echo __('after ','loginizer'); ?>
					<input type="text" size="3" value="<?php echo (!empty($notify_email) ? $notify_email : $loginizer['notify_email']); ?>" name="notify_email" id="notify_email" /> <?php echo __('lockouts <br />0 to disable email notifications','loginizer'); ?>
				</td>
			</tr>
		</table><br />
		<input name="save_lz" class="button button-primary action" value="<?php echo __('Save Settings','loginizer'); ?>" type="submit" />
		</form>
	
		</div>
	</div>
	<br />
	
	<div id="" class="postbox">
	
		<button class="handlediv button-link" aria-expanded="true" type="button">
			<span class="screen-reader-text">Toggle panel: Blacklist IP</span>
			<span class="toggle-indicator" aria-hidden="true"></span>
		</button>
		
		<h2 class="hndle ui-sortable-handle">
			<span><?php echo __('Blacklist IP','loginizer'); ?></span>
		</h2>
		
		<div class="inside">
		
		<?php echo __('Enter the IP you want to blacklist from login','loginizer'); ?>
	
		<form action="" method="post">
		<?php wp_nonce_field('loginizer-options'); ?>
		<table class="form-table">
			<tr>
				<th scope="row" valign="top"><label for="start_ip"><?php echo __('Start IP','loginizer'); ?></label></th>
				<td>
					<input type="text" size="25" value="<?php echo(lz_optpost('start_ip')); ?>" name="start_ip" id="start_ip"/> <?php echo __('Start IP of the range','loginizer'); ?> <br />
				</td>
			</tr>
			<tr>
				<th scope="row" valign="top"><label for="end_ip"><?php echo __('End IP (Optional)','loginizer'); ?></label></th>
				<td>
					<input type="text" size="25" value="<?php echo(lz_optpost('end_ip')); ?>" name="end_ip" id="end_ip"/> <?php echo __('End IP of the range. <br />If you want to blacklist single IP leave this field blank.','loginizer'); ?> <br />
				</td>
			</tr>
		</table><br />
		<input name="blacklist_iprange" class="button button-primary action" value="<?php echo __('Add Blacklist IP Range','loginizer'); ?>" type="submit" />		
		</form>
		</div>
		
		<table class="wp-list-table fixed striped users" border="0" width="95%" cellpadding="10" align="center">
			<tr>
				<th scope="row" valign="top" style="background:#EFEFEF;"><?php echo __('Start IP','loginizer'); ?></th>
				<th scope="row" valign="top" style="background:#EFEFEF;"><?php echo __('End IP','loginizer'); ?></th>
				<th scope="row" valign="top" style="background:#EFEFEF;"><?php echo __('Date (DD/MM/YYYY)','loginizer'); ?></th>
				<th scope="row" valign="top" style="background:#EFEFEF;" width="100"><?php echo __('Options','loginizer'); ?></th>
			</tr>
			<?php
				if(empty($loginizer['blacklist'])){
					echo '
					<tr>
						<td colspan="4">
							No Blacklist IPs. You will see blacklisted IP ranges here.
						</td>
					</tr>';
				}else{
					foreach($loginizer['blacklist'] as $ik => $iv){
						echo '
						<tr>
							<td>
								'.$iv['start'].'
							</td>
							<td>
								'.$iv['end'].'
							</td>
							<td>
								'.date('d/m/Y', $iv['time']).'
							</td>
							<td>
								<a class="submitdelete" href="admin.php?page=loginizer_brute_force&bdelid='.$ik.'" onclick="return confirm(\'Are you sure you want to delete this IP range ?\')">Delete</a>
							</td>
						</tr>';
					}
				}
			?>
		</table>
		<br />
		
	</div>
	
	<br />
	
	<div id="" class="postbox">
	
		<button class="handlediv button-link" aria-expanded="true" type="button">
			<span class="screen-reader-text">Toggle panel: Whitelist IP</span>
			<span class="toggle-indicator" aria-hidden="true"></span>
		</button>
		
		<h2 class="hndle ui-sortable-handle">
			<span><?php echo __('Whitelist IP', 'loginizer'); ?></span>
		</h2>
		
		<div class="inside">
		
		<?php echo __('Enter the IP you want to whitelist for login','loginizer'); ?>
		<form action="" method="post">
		<?php wp_nonce_field('loginizer-options'); ?>
		<table class="form-table">
			<tr>
				<th scope="row" valign="top"><label for="start_ip_w"><?php echo __('Start IP','loginizer'); ?></label></th>
				<td>
					<input type="text" size="25" value="<?php echo(lz_optpost('start_ip_w')); ?>" name="start_ip_w" id="start_ip_w"/> <?php echo __('Start IP of the range','loginizer'); ?> <br />
				</td>
			</tr>
			<tr>
				<th scope="row" valign="top"><label for="end_ip_w"><?php echo __('End IP (Optional)','loginizer'); ?></label></th>
				<td>
					<input type="text" size="25" value="<?php echo(lz_optpost('end_ip_w')); ?>" name="end_ip_w" id="end_ip_w"/> <?php echo __('End IP of the range. <br />If you want to whitelist single IP leave this field blank.','loginizer'); ?> <br />
				</td>
			</tr>
		</table><br />
		<input name="whitelist_iprange" class="button button-primary action" value="<?php echo __('Add Whitelist IP Range','loginizer'); ?>" type="submit" />
		</form>
		</div>
		
		<table class="wp-list-table fixed striped users" border="0" width="95%" cellpadding="10" align="center">
		<tr>
			<th scope="row" valign="top" style="background:#EFEFEF;"><?php echo __('Start IP','loginizer'); ?></th>
			<th scope="row" valign="top" style="background:#EFEFEF;"><?php echo __('End IP','loginizer'); ?></th>
			<th scope="row" valign="top" style="background:#EFEFEF;"><?php echo __('Date (DD/MM/YYYY)','loginizer'); ?></th>
			<th scope="row" valign="top" style="background:#EFEFEF;" width="100"><?php echo __('Options','loginizer'); ?></th>
		</tr>
		<?php
			if(empty($loginizer['whitelist'])){
				echo '
				<tr>
					<td colspan="4">
						No Whitelist IPs. You will see whitelisted IP ranges here.
					</td>
				</tr>';
			}else{
				foreach($loginizer['whitelist'] as $ik => $iv){
					echo '
					<tr>
						<td>
							'.$iv['start'].'
						</td>
						<td>
							'.$iv['end'].'
						</td>
						<td>
							'.date('d/m/Y', $iv['time']).'
						</td>
						<td>
							<a class="submitdelete" href="admin.php?page=loginizer_brute_force&delid='.$ik.'" onclick="return confirm(\'Are you sure you want to delete this IP range ?\')">Delete</a>
						</td>
					</tr>';
				}
			}
		?>
		</table>
		<br />
	
	</div>
	
<?php

loginizer_page_footer();

}


// Sorry to see you going
register_uninstall_hook(LOGINIZER_FILE, 'loginizer_deactivation');

function loginizer_deactivation(){

global $wpdb;

	$sql = array();
	$sql[] = "DROP TABLE ".$wpdb->prefix."loginizer_logs;";

	foreach($sql as $sk => $sv){
		$wpdb->query($sv);
	}

	delete_option('loginizer_version');
	delete_option('loginizer_options');
	delete_option('loginizer_last_reset');
	delete_option('loginizer_whitelist');
	delete_option('loginizer_blacklist');

}

