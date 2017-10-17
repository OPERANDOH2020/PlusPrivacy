<?php

include_once(LOGINIZER_DIR.'/IPv6/IPv6.php');

// Get the client IP
function _lz_getip(){
	if(isset($_SERVER["REMOTE_ADDR"])){
		return $_SERVER["REMOTE_ADDR"];
	}elseif(isset($_SERVER["HTTP_X_FORWARDED_FOR"])){
		return $_SERVER["HTTP_X_FORWARDED_FOR"];
	}elseif(isset($_SERVER["HTTP_CLIENT_IP"])){
		return $_SERVER["HTTP_CLIENT_IP"];
	}
}

// Get the client IP
function lz_getip(){
	
	global $loginizer;
	
	// Just so that we have something
	$ip = _lz_getip();
	
	$loginizer['ip_method'] = (int) @$loginizer['ip_method'];
	
	if(isset($_SERVER["REMOTE_ADDR"])){
		$ip = $_SERVER["REMOTE_ADDR"];
	}
	
	if(isset($_SERVER["HTTP_X_FORWARDED_FOR"]) && @$loginizer['ip_method'] == 1){
		$ip = $_SERVER["HTTP_X_FORWARDED_FOR"];
	}
	
	if(isset($_SERVER["HTTP_CLIENT_IP"]) && @$loginizer['ip_method'] == 2){
		$ip = $_SERVER["HTTP_CLIENT_IP"];
	}
	
	if(@$loginizer['ip_method'] == 3 && isset($_SERVER[@$loginizer['custom_ip_method']])){
		$ip = $_SERVER[@$loginizer['custom_ip_method']];
	}
	
	// Hacking fix for X-Forwarded-For
	if(!lz_valid_ip($ip)){
		return '';
	}
	
	return $ip;
	
}

// Execute a select query and return an array
function lz_selectquery($query, $array = 0){
	global $wpdb;
	
	$result = $wpdb->get_results($query, 'ARRAY_A');
	
	if(empty($array)){
		return current($result);
	}else{
		return $result;
	}
}

// Check if an IP is valid
function lz_valid_ip($ip){
	
	// IPv6
	if(lz_valid_ipv6($ip)){
		return true;
	}
	
	// IPv4
	if(!ip2long($ip)){
		return false;
	}
	
	return true;
}

function lz_valid_ipv6($ip){

	$pattern = '/^((([0-9A-Fa-f]{1,4}:){7}[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){6}:[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){5}:([0-9A-Fa-f]{1,4}:)?[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){4}:([0-9A-Fa-f]{1,4}:){0,2}[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){3}:([0-9A-Fa-f]{1,4}:){0,3}[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){2}:([0-9A-Fa-f]{1,4}:){0,4}[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){6}((\b((25[0-5])|(1\d{2})|(2[0-4]\d)|(\d{1,2}))\b)\.){3}(\b((25[0-5])|(1\d{2})|(2[0-4]\d)|(\d{1,2}))\b))|(([0-9A-Fa-f]{1,4}:){0,5}:((\b((25[0-5])|(1\d{2})|(2[0-4]\d)|(\d{1,2}))\b)\.){3}(\b((25[0-5])|(1\d{2})|(2[0-4]\d)|(\d{1,2}))\b))|(::([0-9A-Fa-f]{1,4}:){0,5}((\b((25[0-5])|(1\d{2})|(2[0-4]\d)|(\d{1,2}))\b)\.){3}(\b((25[0-5])|(1\d{2})|(2[0-4]\d)|(\d{1,2}))\b))|([0-9A-Fa-f]{1,4}::([0-9A-Fa-f]{1,4}:){0,5}[0-9A-Fa-f]{1,4})|(::([0-9A-Fa-f]{1,4}:){0,6}[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){1,7}:))$/';
	
	if(!preg_match($pattern, $ip)){
		return false;	
	}
	
	return true;
	
}

// Check if a field is posted via POST else return default value
function lz_optpost($name, $default = ''){
	
	if(!empty($_POST[$name])){
		return lz_inputsec(lz_htmlizer(trim($_POST[$name])));
	}
	
	return $default;	
}

// Check if a field is posted via GET else return default value
function lz_optget($name, $default = ''){
	
	if(!empty($_GET[$name])){
		return lz_inputsec(lz_htmlizer(trim($_GET[$name])));
	}
	
	return $default;	
}

// Check if a field is posted via GET or POST else return default value
function lz_optreq($name, $default = ''){
	
	if(!empty($_REQUEST[$name])){
		return lz_inputsec(lz_htmlizer(trim($_REQUEST[$name])));
	}
	
	return $default;	
}

// For filling in posted values
function lz_POSTval($name, $default = ''){
	
	return (!empty($_POST) ? (!isset($_POST[$name]) ? '' : $_POST[$name]) : $default);

}

function lz_POSTchecked($name, $default = false){
	
	return (!empty($_POST) ? (isset($_POST[$name]) ? 'checked="checked"' : '') : (!empty($default) ? 'checked="checked"' : ''));

}

function lz_POSTselect($name, $value, $default = false){
	
	if(empty($_POST)){
		if(!empty($default)){
			return 'selected="selected"';
		}
	}else{
		if(isset($_POST[$name])){
			if(trim($_POST[$name]) == $value){
				return 'selected="selected"';
			}
		}
	}

}

function lz_inputsec($string){

	if(!get_magic_quotes_gpc()){
	
		$string = addslashes($string);
	
	}else{
	
		$string = stripslashes($string);
		$string = addslashes($string);
	
	}
	
	// This is to replace ` which can cause the command to be executed in exec()
	$string = str_replace('`', '\`', $string);
	
	return $string;

}

function lz_htmlizer($string){

	$string = htmlentities($string, ENT_QUOTES, 'UTF-8');
	
	preg_match_all('/(&amp;#(\d{1,7}|x[0-9a-fA-F]{1,6});)/', $string, $matches);//r_print($matches);
	
	foreach($matches[1] as $mk => $mv){		
		$tmp_m = lz_entity_check($matches[2][$mk]);
		$string = str_replace($matches[1][$mk], $tmp_m, $string);
	}
	
	return $string;
	
}

function lz_entity_check($string){
	
	//Convert Hexadecimal to Decimal
	$num = ((substr($string, 0, 1) === 'x') ? hexdec(substr($string, 1)) : (int) $string);
	
	//Squares and Spaces - return nothing 
	$string = (($num > 0x10FFFF || ($num >= 0xD800 && $num <= 0xDFFF) || $num < 0x20) ? '' : '&#'.$num.';');
	
	return $string;
			
}

// Check if a checkbox is selected
function lz_is_checked($post){

	if(!empty($_POST[$post])){
		return true;
	}	
	return false;
}

// Reoort an error
function lz_report_error($error = array()){

	if(empty($error)){
		return true;
	}
	
	$error_string = '<b>Please fix the below error(s) :</b> <br />';
	
	foreach($error as $ek => $ev){
		$error_string .= '* '.$ev.'<br />';
	}
	
	echo '<div id="message" class="error"><p>'
					. __($error_string, 'loginizer')
					. '</p></div>';
}

// Report a notice
function lz_report_notice($notice = array()){

	global $wp_version;
	
	if(empty($notice)){
		return true;
	}
	
	// Which class do we have to use ?
	if(version_compare($wp_version, '3.8', '<')){
		$notice_class = 'updated';
	}else{
		$notice_class = 'updated';
	}
	
	$notice_string = '<b>Please check the below notice(s) :</b> <br />';
	
	foreach($notice as $ek => $ev){
		$notice_string .= '* '.$ev.'<br />';
	}
	
	echo '<div id="message" class="'.$notice_class.'"><p>'
					. __($notice_string, 'loginizer')
					. '</p></div>';
}

// Convert an objext to array
function lz_objectToArray($d){
	
	if(is_object($d)){
		$d = get_object_vars($d);
	}
	
	if(is_array($d)){
		return array_map(__FUNCTION__, $d); // recursive
	}elseif(is_object($d)){
		return lz_objectToArray($d);
	}else{
		return $d;
	}
}

// Sanitize variables
function lz_sanitize_variables($variables = array()){
	
	if(is_array($variables)){
		foreach($variables as $k => $v){
			$variables[$k] = trim($v);
			$variables[$k] = escapeshellcmd($v);
		}
	}else{
		$variables = escapeshellcmd(trim($variables));
	}
	
	return $variables;
}

// Is multisite ?
function lz_is_multisite() {
	
	if(function_exists('get_site_option') && function_exists('is_multisite') && is_multisite()){
		return true;
	}
	
	return false;
}

// Generate a random string
function lz_RandomString($length = 10){
	$characters = '0123456789abcdefghijklmnopqrstuvwxyz';
	$charactersLength = strlen($characters);
	$randomString = '';
	for($i = 0; $i < $length; $i++){
		$randomString .= $characters[rand(0, $charactersLength - 1)];
	}
	return $randomString;
}

function lz_print($array){

	echo '<pre>';
	print_r($array);
	echo '</pre>';

}

function lz_cleanpath($path){
	$path = str_replace('\\\\', '/', $path);
	$path = str_replace('\\', '/', $path);
	$path = str_replace('//', '/', $path);
	return rtrim($path, '/');
}

// Returns the Numeric Value of results Per Page
function lz_get_page($get = 'page', $resperpage = 50){

	$resperpage = (!empty($_REQUEST['reslen']) && is_numeric($_REQUEST['reslen']) ? (int) lz_optreq('reslen') : $resperpage);
	
	if(lz_optget($get)){
		$pg = (int) lz_optget($get);
		$pg = $pg - 1;		
		$page = ($pg * $resperpage);
		$page = ($page <= 0 ? 0 : $page);
	}else{	
		$page = 0;		
	}	
	return $page;
}

// Replaces the Variables with the supplied ones
function lz_lang_vars_name($str, $array){
	
	foreach($array as $k => $v){
		
		$str = str_replace('$'.$k, $v, $str);
	
	}
	
	return $str;

}