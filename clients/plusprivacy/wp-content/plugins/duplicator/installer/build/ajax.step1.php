<?php
// Exit if accessed directly
if (! defined('DUPLICATOR_INIT')) {
	$_baseURL = "http://" . strlen($_SERVER['SERVER_NAME']) ? $_SERVER['SERVER_NAME'] : $_SERVER['HTTP_HOST'];
	header("HTTP/1.1 301 Moved Permanently");
	header("Location: $_baseURL");
	exit;
}

//POST PARAMS
$_POST['dbaction']			= isset($_POST['dbaction']) ? $_POST['dbaction'] : 'create';
$_POST['dbnbsp']			= (isset($_POST['dbnbsp']) && $_POST['dbnbsp'] == '1') ? true : false;
$_POST['ssl_admin']			= (isset($_POST['ssl_admin']))  ? true : false;
$_POST['ssl_login']			= (isset($_POST['ssl_login']))  ? true : false;
$_POST['cache_wp']			= (isset($_POST['cache_wp']))   ? true : false;
$_POST['cache_path']		= (isset($_POST['cache_path'])) ? true : false;
$_POST['package_name']		= isset($_POST['package_name']) ? $_POST['package_name'] : null;
$_POST['zip_manual']		= (isset($_POST['zip_manual']) && $_POST['zip_manual'] == '1') ? true : false;

//LOGGING
$POST_LOG = $_POST;
unset($POST_LOG['dbpass']);
ksort($POST_LOG);

//PAGE VARS
$root_path		= DUPX_Util::set_safe_path($GLOBALS['CURRENT_ROOT_PATH']);
$package_path	= "{$root_path}/{$_POST['package_name']}";
$package_size	= @filesize($package_path);
$ajax1_start	= DUPX_Util::get_microtime();
$zip_support	= class_exists('ZipArchive') ? 'Enabled' : 'Not Enabled';
$JSON = array();
$JSON['pass'] = 0;

/* JSON RESPONSE: Most sites have warnings turned off by default, but if they're turned on the warnings
cause errors in the JSON data Here we hide the status so warning level is reset at it at the end*/
$ajax1_error_level = error_reporting();
error_reporting(E_ERROR);

//====================================================================================================
//DATABASE TEST CONNECTION
//====================================================================================================
if (isset($_GET['dbtest'])) 
{
	$html     = "";
	$baseport =  parse_url($_POST['dbhost'], PHP_URL_PORT);
	$dbConn   = DUPX_Util::db_connect($_POST['dbhost'], $_POST['dbuser'], $_POST['dbpass'], null, $_POST['dbport']);
	$dbErr	  = mysqli_connect_error();

	$dbFound  = mysqli_select_db($dbConn, $_POST['dbname']);
	$port_view = (is_int($baseport) || substr($_POST['dbhost'], -1) == ":") ? "Port=[Set in Host]" : "Port={$_POST['dbport']}";

	$tstSrv   = ($dbConn)  ? "<div class='dup-pass'>Success</div>" : "<div class='dup-fail'>Fail</div>";
	$tstDB    = ($dbFound) ? "<div class='dup-pass'>Success</div>" : "<div class='dup-fail'>Fail</div>";
	
	$dbvar_version = DUPX_Util::mysql_version($dbConn);
	$dbvar_version = ($dbvar_version == 0) ? 'no connection' : $dbvar_version;
	$dbvar_version_fail = version_compare($dbvar_version, $GLOBALS['FW_VERSION_DB']) < 0;
	$tstCompat = ($dbvar_version_fail)
		? "<div class='dup-notice'>This Server: [{$dbvar_version}] -- Package Server: [{$GLOBALS['FW_VERSION_DB']}]</div>" 
		: "<div class='dup-pass'>This Server: [{$dbvar_version}] -- Package Server: [{$GLOBALS['FW_VERSION_DB']}]</div>";
	
	$html	 .= <<<DATA
	<div class='dup-db-test'>
		<small>
			Using Connection String:<br/>
			Host={$_POST['dbhost']}; Database={$_POST['dbname']}; Uid={$_POST['dbuser']}; Pwd={$_POST['dbpass']}; {$port_view}
		</small>
		<table class='dup-db-test-dtls'>
			<tr>
				<td>Host:</td>
				<td>{$tstSrv}</td>
			</tr>
			<tr>
				<td>Database:</td>
				<td>{$tstDB}</td>
			</tr>	
			<tr>
				<td>Version:</td>
				<td>{$tstCompat}</td>
			</tr>		
		</table>
DATA;
	
	//--------------------------------
	//WARNING: DB has tables with create option
	if ($_POST['dbaction'] == 'create')
	{
		$tblcount = DUPX_Util::dbtable_count($dbConn, $_POST['dbname']);
		$html .= ($tblcount > 0) 
			? "<div class='warn-msg'><b>WARNING:</b> " . sprintf(ERR_DBEMPTY, $_POST['dbname'], $tblcount) . "</div>"
			: '';
	}				

	//WARNNG: Input has utf8
	$dbConnItems = array($_POST['dbhost'], $_POST['dbuser'], $_POST['dbname'],$_POST['dbpass']);
	$dbUTF8_tst  = false;
	foreach ($dbConnItems as $value)
	{
		if (DUPX_Util::is_non_ascii($value)) {
			$dbUTF8_tst = true;
			break;
		}
	}
	$html .=  (! $dbConn && $dbUTF8_tst) 
		? "<div class='warn-msg'><b>WARNING:</b> " . ERR_TESTDB_UTF8 .  "</div>"	
		: '';
	
	//WARNING Version Incompat
	$html .=  ($dbvar_version_fail)  
		? "<div class='warn-msg'><b>NOTICE:</b> " . ERR_TESTDB_VERSION . "</div>" 
		: '';

	$html .= "</div>";
	die($html);
}

//===============================
//ERROR MESSAGES
//===============================
//ERR_MAKELOG
($GLOBALS['LOG_FILE_HANDLE'] != false) or DUPX_Log::Error(ERR_MAKELOG);

//ERR_MYSQLI_SUPPORT
function_exists('mysqli_connect') or DUPX_Log::Error(ERR_MYSQLI_SUPPORT);

//ERR_DBCONNECT
$dbh = DUPX_Util::db_connect($_POST['dbhost'], $_POST['dbuser'], $_POST['dbpass'], null, $_POST['dbport']);
@mysqli_query($dbh, "SET wait_timeout = {$GLOBALS['DB_MAX_TIME']}");
($dbh) or DUPX_Log::Error(ERR_DBCONNECT . mysqli_connect_error());
if ($_POST['dbaction'] == 'empty') {
	mysqli_select_db($dbh, $_POST['dbname']) or DUPX_Log::Error(sprintf(ERR_DBCREATE, $_POST['dbname']));
}
//ERR_DBEMPTY
if ($_POST['dbaction'] == 'create' ) {
	$tblcount = DUPX_Util::dbtable_count($dbh, $_POST['dbname']);
	if ($tblcount > 0) {
		DUPX_Log::Error(sprintf(ERR_DBEMPTY, $_POST['dbname'], $tblcount));
	}
}

//ERR_ZIPMANUAL
if ($_POST['zip_manual']) {
	if (!file_exists("wp-config.php") && !file_exists("database.sql")) {
		DUPX_Log::Error(ERR_ZIPMANUAL);
	}
} else {
	//ERR_CONFIG_FOUND
	(!file_exists('wp-config.php'))
		or DUPX_Log::Error(ERR_CONFIG_FOUND);
	//ERR_ZIPNOTFOUND
	(is_readable("{$package_path}"))
		or DUPX_Log::Error(ERR_ZIPNOTFOUND);
}

DUPX_Log::Info("********************************************************************************");
DUPX_Log::Info('DUPLICATOR-LITE INSTALL-LOG');
DUPX_Log::Info('STEP1 START @ ' . @date('h:i:s'));
DUPX_Log::Info('NOTICE: Do NOT post to public sites or forums');
DUPX_Log::Info("********************************************************************************");
DUPX_Log::Info("VERSION:\t{$GLOBALS['FW_DUPLICATOR_VERSION']}");
DUPX_Log::Info("PHP:\t\t" . phpversion() . ' | SAPI: ' . php_sapi_name());
DUPX_Log::Info("SERVER:\t\t{$_SERVER['SERVER_SOFTWARE']}");
DUPX_Log::Info("DOC ROOT:\t{$root_path}");
DUPX_Log::Info("DOC ROOT 755:\t" . var_export($GLOBALS['CHOWN_ROOT_PATH'], true));
DUPX_Log::Info("LOG FILE 644:\t" . var_export($GLOBALS['CHOWN_LOG_PATH'], true));
DUPX_Log::Info("BUILD NAME:\t{$GLOBALS['FW_SECURE_NAME']}");
DUPX_Log::Info("REQUEST URL:\t{$GLOBALS['URL_PATH']}");

$log  = "--------------------------------------\n";
$log .= "POST DATA\n";
$log .= "--------------------------------------\n";
$log .= print_r($POST_LOG, true);
DUPX_Log::Info($log, 2);


//====================================================================================================
//UNZIP & FILE SETUP - Extract the zip file and prep files
//====================================================================================================
$log  = "\n********************************************************************************\n";
$log .= "ARCHIVE SETUP\n";
$log .= "********************************************************************************\n";
$log .= "NAME:\t{$_POST['package_name']}\n";
$log .= "SIZE:\t" . DUPX_Util::readable_bytesize(@filesize($_POST['package_name'])) . "\n";
$log .= "ZIP:\t{$zip_support} (ZipArchive Support)";
DUPX_Log::Info($log);

$zip_start = DUPX_Util::get_microtime();

if ($_POST['zip_manual']) {
	DUPX_Log::Info("\n** PACKAGE EXTRACTION IS IN MANUAL MODE ** \n");
} else {
	if ($GLOBALS['FW_PACKAGE_NAME'] != $_POST['package_name']) {
		$log  = "\n--------------------------------------\n";
		$log .= "WARNING: This package set may be incompatible!  \nBelow is a summary of the package this installer was built with and the package used. \n";
		$log .= "To guarantee accuracy the installer and archive should match. For details see the online FAQs.";
		$log .= "\nCREATED WITH:\t{$GLOBALS['FW_PACKAGE_NAME']} \nPROCESSED WITH:\t{$_POST['package_name']}  \n";
		$log .= "--------------------------------------\n";
		DUPX_Log::Info($log);
	}

	if (! class_exists('ZipArchive')) {
		DUPX_Log::Info("ERROR: Stopping install process.  Trying to extract without ZipArchive module installed.  Please use the 'Manual Package extraction' mode to extract zip file.");
		DUPX_Log::Error(ERR_ZIPARCHIVE);
	}

	$target = $root_path;
	$zip = new ZipArchive();
	if ($zip->open($_POST['package_name']) === TRUE) {
		DUPX_Log::Info("EXTRACTING");
		if (! $zip->extractTo($target)) {
			DUPX_Log::Error(ERR_ZIPEXTRACTION);
		}
		$log  = print_r($zip, true);
		$close_response = $zip->close();
		$log .= "COMPLETE: " . var_export($close_response, true);
		DUPX_Log::Info($log);
	} else {
		DUPX_Log::Error(ERR_ZIPOPEN);
	}
	$zip = null;
}


//CONFIG FILE RESETS
DUPX_WPConfig::UpdateStep1();
DUPX_ServerConfig::Reset();


//====================================================================================================
//DATABASE ROUTINES
//====================================================================================================
@chmod("{$root_path}/database.sql", 0777);
if (filesize("{$root_path}/database.sql") > 100000000) {
	DUPX_Log::Info("\nWARNING: Database Script is larger than 100MB this may lead to PHP memory allocation issues on some budget hosts.");
}
$sql_file = file_get_contents('database.sql', true);
if ($sql_file == false || strlen($sql_file) < 10) {
	$sql_file = file_get_contents('installer-data.sql', true);
	if ($sql_file == false || strlen($sql_file) < 10) {
		DUPX_Log::Info("ERROR: Unable to read from the extracted database.sql file .\nValidate the permissions and/or group-owner rights on directory '{$root_path}'\n");
	}
}

//Complex Subject See: http://webcollab.sourceforge.net/unicode.html
//Removes invalid space characters
if ($_POST['dbnbsp']) {
	DUPX_Log::Info("ran fix non-breaking space characters\n");
	$sql_file = preg_replace('/\xC2\xA0/', ' ', $sql_file);
}

//Write new contents to install-data.sql
@chmod($sql_result_file_path, 0777);
file_put_contents($GLOBALS['SQL_FILE_NAME'], $sql_file);

$sql_result_file_data = explode(";\n", $sql_file);
$sql_result_file_length = count($sql_result_file_data);
$sql_result_file_path = "{$root_path}/{$GLOBALS['SQL_FILE_NAME']}";
$sql_file = null;

if (!is_readable($sql_result_file_path) || filesize($sql_result_file_path) == 0) {
	DUPX_Log::Info("ERROR: Unable to create new sql file {$GLOBALS['SQL_FILE_NAME']}.\nValidate the permissions and/or group-owner rights on directory '{$root_path}' and file '{$GLOBALS['SQL_FILE_NAME']}'\n");
}

DUPX_Log::Info("\nUPDATED FILES:");
DUPX_Log::Info("- SQL FILE:  '{$sql_result_file_path}'");
DUPX_Log::Info("- WP-CONFIG: '{$root_path}/wp-config.php' (if present)");
$zip_end = DUPX_Util::get_microtime();
DUPX_Log::Info("\nARCHIVE RUNTIME: " . DUPX_Util::elapsed_time($zip_end, $zip_start));
DUPX_Log::Info("\n");
DUPX_Util::fcgi_flush();

//=================================
//START DB RUN
@mysqli_query($dbh, "SET wait_timeout = {$GLOBALS['DB_MAX_TIME']}");
@mysqli_query($dbh, "SET max_allowed_packet = {$GLOBALS['DB_MAX_PACKETS']}");
DUPX_Util::mysql_set_charset($dbh, $_POST['dbcharset'], $_POST['dbcollate']);

//Will set mode to null only for this db handle session
//sql_mode can cause db create issues on some systems
switch ($_POST['dbmysqlmode']) {
    case 'DISABLE':
        @mysqli_query($dbh, "SET SESSION sql_mode = ''");
        break;
    case 'CUSTOM':
		$dbmysqlmode_opts = $_POST['dbmysqlmode_opts'];
		$qry_session_custom = @mysqli_query($dbh, "SET SESSION sql_mode = '{$dbmysqlmode_opts}'");
        if ($qry_session_custom == false) 
		{
			$sql_error = mysqli_error($dbh);
			$log  = "WARNING: A custom sql_mode setting issue has been detected:\n{$sql_error}.\n";
			$log .= "For more details visit: http://dev.mysql.com/doc/refman/5.7/en/sql-mode.html\n";
		}
        break;
}

//Set defaults in-case the variable could not be read
$dbvar_maxtime		= DUPX_Util::mysql_variable_value($dbh, 'wait_timeout');
$dbvar_maxpacks		= DUPX_Util::mysql_variable_value($dbh, 'max_allowed_packet');
$dbvar_sqlmode		= DUPX_Util::mysql_variable_value($dbh, 'sql_mode');
$dbvar_maxtime		= is_null($dbvar_maxtime) ? 300 : $dbvar_maxtime;
$dbvar_maxpacks		= is_null($dbvar_maxpacks) ? 1048576 : $dbvar_maxpacks;
$dbvar_sqlmode		= empty($dbvar_sqlmode) ? 'NOT_SET'  : $dbvar_sqlmode;
$dbvar_version		= DUPX_Util::mysql_version($dbh);

DUPX_Log::Info("{$GLOBALS['SEPERATOR1']}");
DUPX_Log::Info('DATABASE-ROUTINES');
DUPX_Log::Info("{$GLOBALS['SEPERATOR1']}");
DUPX_Log::Info("--------------------------------------");
DUPX_Log::Info("SERVER ENVIROMENT");
DUPX_Log::Info("--------------------------------------");
DUPX_Log::Info("MYSQL VERSION:\tThis Server: {$dbvar_version} -- Build Server: {$GLOBALS['FW_VERSION_DB']}");
DUPX_Log::Info("TIMEOUT:\t{$dbvar_maxtime}");
DUPX_Log::Info("MAXPACK:\t{$dbvar_maxpacks}");
DUPX_Log::Info("SQLMODE:\t{$dbvar_sqlmode}");

if ($qry_session_custom == false) 
{
	DUPX_Log::Info("\n{$log}\n");
}

//CREATE DB
switch ($_POST['dbaction']) {
	case "create":
		mysqli_query($dbh, "CREATE DATABASE IF NOT EXISTS `{$_POST['dbname']}`");
		mysqli_select_db($dbh, $_POST['dbname'])
		or DUPX_Log::Error(sprintf(ERR_DBCONNECT_CREATE, $_POST['dbname']));
		break;
	case "empty":
		//DROP DB TABLES
		$drop_log = "Database already empty. Ready for install.";
		$sql = "SHOW TABLES FROM `{$_POST['dbname']}`";
		$found_tables = null;
		if ($result = mysqli_query($dbh, $sql)) {
			while ($row = mysqli_fetch_row($result)) {
				$found_tables[] = $row[0];
			}
			if (count($found_tables) > 0) {
				foreach ($found_tables as $table_name) {
					$sql = "DROP TABLE `{$_POST['dbname']}`.`{$table_name}`";
					if (!$result = mysqli_query($dbh, $sql)) {
						DUPX_Log::Error(sprintf(ERR_DBTRYCLEAN, $_POST['dbname']));
					}
				}
			}
			$drop_log = 'removed (' . count($found_tables) . ') tables';
		}
		break;
}


//WRITE DATA
DUPX_Log::Info("--------------------------------------");
DUPX_Log::Info("DATABASE RESULTS");
DUPX_Log::Info("--------------------------------------");
$profile_start = DUPX_Util::get_microtime();
$fcgi_buffer_pool = 5000;
$fcgi_buffer_count = 0;
$dbquery_rows = 0;
$dbtable_rows = 1;
$dbquery_errs = 0;
$counter = 0;
@mysqli_autocommit($dbh, false);
while ($counter < $sql_result_file_length) {

	$query_strlen = strlen(trim($sql_result_file_data[$counter]));
	if ($dbvar_maxpacks < $query_strlen) {
		DUPX_Log::Info("**ERROR** Query size limit [length={$query_strlen}] [sql=" . substr($sql_result_file_data[$counter], 75) . "...]");
		$dbquery_errs++;
	} elseif ($query_strlen > 0) {
		@mysqli_free_result(@mysqli_query($dbh, ($sql_result_file_data[$counter])));
		$err = mysqli_error($dbh);
		//Check to make sure the connection is alive
		if (!empty($err)) {

			if (!mysqli_ping($dbh)) {
				mysqli_close($dbh);
				$dbh = DUPX_Util::db_connect($_POST['dbhost'], $_POST['dbuser'], $_POST['dbpass'], $_POST['dbname'], $_POST['dbport'] );
				// Reset session setup
				@mysqli_query($dbh, "SET wait_timeout = {$GLOBALS['DB_MAX_TIME']}");
				DUPX_Util::mysql_set_charset($dbh, $_POST['dbcharset'], $_POST['dbcollate']);
			}
			DUPX_Log::Info("**ERROR** database error write '{$err}' - [sql=" . substr($sql_result_file_data[$counter], 0, 75) . "...]");
			$dbquery_errs++;

		//Buffer data to browser to keep connection open
		} else {
			if ($fcgi_buffer_count++ > $fcgi_buffer_pool) {
				$fcgi_buffer_count = 0;
				DUPX_Util::fcgi_flush();
			}
			$dbquery_rows++;
		}
	}
	$counter++;
}
@mysqli_commit($dbh);
@mysqli_autocommit($dbh, true);

DUPX_Log::Info("ERRORS FOUND:\t{$dbquery_errs}");
DUPX_Log::Info("DROP TABLE:\t{$drop_log}");
DUPX_Log::Info("QUERIES RAN:\t{$dbquery_rows}\n");

$dbtable_count = 0;
if ($result = mysqli_query($dbh, "SHOW TABLES")) {
	while ($row = mysqli_fetch_array($result, MYSQLI_NUM)) {
		$table_rows = DUPX_Util::table_row_count($dbh, $row[0]);
		$dbtable_rows += $table_rows;
		DUPX_Log::Info("{$row[0]}: ({$table_rows})");
		$dbtable_count++;
	}
	@mysqli_free_result($result);
}

if ($dbtable_count == 0) {
	DUPX_Log::Error("No tables where created during step 1 of the install.  Please review the installer-log.txt file for sql error messages.
		You may have to manually run the installer-data.sql with a tool like phpmyadmin to validate the data input.  If you have enabled compatibility mode
		during the package creation process then the database server version your using may not be compatible with this script.\n");
}


//DATA CLEANUP: Perform Transient Cache Cleanup
//Remove all duplicator entries and record this one since this is a new install.
$dbdelete_count = 0;
@mysqli_query($dbh, "DELETE FROM `{$GLOBALS['FW_TABLEPREFIX']}duplicator_packages`");
$dbdelete_count1 = @mysqli_affected_rows($dbh) or 0;
@mysqli_query($dbh, "DELETE FROM `{$GLOBALS['FW_TABLEPREFIX']}options` WHERE `option_name` LIKE ('_transient%') OR `option_name` LIKE ('_site_transient%')");
$dbdelete_count2 = @mysqli_affected_rows($dbh) or 0;
$dbdelete_count = (abs($dbdelete_count1) + abs($dbdelete_count2));
DUPX_Log::Info("Removed '{$dbdelete_count}' cache/transient rows");
//Reset Duplicator Options
foreach ($GLOBALS['FW_OPTS_DELETE'] as $value) {
	mysqli_query($dbh, "DELETE FROM `{$GLOBALS['FW_TABLEPREFIX']}options` WHERE `option_name` = '{$value}'");
}

@mysqli_close($dbh);

$profile_end = DUPX_Util::get_microtime();
DUPX_Log::Info("\nSECTION RUNTIME: " . DUPX_Util::elapsed_time($profile_end, $profile_start));

//FINAL RESULTS
$ajax1_end = DUPX_Util::get_microtime();
$ajax1_sum = DUPX_Util::elapsed_time($ajax1_end, $ajax1_start);
DUPX_Log::Info("\n{$GLOBALS['SEPERATOR1']}");
DUPX_Log::Info('STEP1 COMPLETE @ ' . @date('h:i:s') . " - TOTAL RUNTIME: {$ajax1_sum}");
DUPX_Log::Info("{$GLOBALS['SEPERATOR1']}");

$JSON['pass'] = 1;
$JSON['table_count'] = $dbtable_count;
$JSON['table_rows']  = $dbtable_rows;
$JSON['query_errs']  = $dbquery_errs;
echo json_encode($JSON);
error_reporting($ajax1_error_level);
die('');
?>