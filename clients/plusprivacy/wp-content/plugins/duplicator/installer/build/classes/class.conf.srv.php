<?php
// Exit if accessed directly 
if (! defined('DUPLICATOR_INIT')) {
	$_baseURL = "http://" . strlen($_SERVER['SERVER_NAME']) ? $_SERVER['SERVER_NAME'] : $_SERVER['HTTP_HOST'];
	header("HTTP/1.1 301 Moved Permanently");
	header("Location: $_baseURL");
	exit; 
}

/** * *****************************************************
 * Class used to update and edit web server configuration files  */
class DUPX_ServerConfig {
	
    /** 
     *  Clear .htaccess and web.config files and backup
     */
    static public function Reset() {
		
		DUPX_Log::Info("\nWEB SERVER CONFIGURATION FILE RESET:");

		//Apache
		@copy('.htaccess', '.htaccess.orig');
		@unlink('.htaccess');
		
		//IIS
		@copy('web.config', 'web.config.orig');
		@unlink('web.config');

		//.user.ini - For WordFence
		@copy('.user.ini', '.user.ini.orig');
		@unlink('.user.ini');
		
		DUPX_Log::Info("- Backup of .htaccess/web.config made to .orig");
		DUPX_Log::Info("- Reset of .htaccess/web.config files");
		$tmp_htaccess = '# RESET FOR DUPLICATOR INSTALLER USEAGE';
		file_put_contents('.htaccess', $tmp_htaccess);
		@chmod('.htaccess', 0644);    		
	}		
		
	/** METHOD: ResetHTACCESS
     *  Resets the .htaccess file
     */
    static public function Setup() {
		
		if (! isset($_POST['url_new'])) {
			return;
		}
		
		DUPX_Log::Info("\nWEB SERVER CONFIGURATION FILE BASIC SETUP:");
		$currdata = parse_url($_POST['url_old']);
		$newdata  = parse_url($_POST['url_new']);
		$currpath = DUPX_Util::add_slash(isset($currdata['path']) ? $currdata['path'] : "");
		$newpath  = DUPX_Util::add_slash(isset($newdata['path'])  ? $newdata['path'] : "");

		$tmp_htaccess = <<<HTACCESS
# BEGIN WordPress
<IfModule mod_rewrite.c>
RewriteEngine On
RewriteBase {$newpath}
RewriteRule ^index\.php$ - [L]
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule . {$newpath}index.php [L]
</IfModule>
# END WordPress
HTACCESS;

		file_put_contents('.htaccess', $tmp_htaccess);
		@chmod('.htaccess', 0644);
		DUPX_Log::Info("created basic .htaccess file.  If using IIS web.config this process will need to be done manually.");

    }
	
	
}
?>
