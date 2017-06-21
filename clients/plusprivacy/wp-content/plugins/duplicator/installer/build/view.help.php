<?php
	// Exit if accessed directly
	if (! defined('DUPLICATOR_INIT')) {
		$_baseURL = "http://" . strlen($_SERVER['SERVER_NAME']) ? $_SERVER['SERVER_NAME'] : $_SERVER['HTTP_HOST'];
		header("HTTP/1.1 301 Moved Permanently");
		header("Location: $_baseURL");
		exit; 
	}
?>
<!-- =========================================
HELP FORM -->
<div id="dup-main-help">
	<div style="text-align:center">For in-depth help please see the <a href="https://snapcreek.com/duplicator/docs/" target="_blank">online resources</a></div>

	<h3>Step 1 - Deploy</h3>
	<div id="dup-help-step1" class="dup-help-page">
		<!-- MYSQL SERVER -->
		<fieldset>
			<legend><b>MySQL Server</b></legend>

			<b>Action:</b><br/>
			'Create New' will attempt to create a new database if it does not exist.  This option will not work on many hosting providers.  If the database does not exist then you will need to login to your control panel and create the database.  If 'Connect and Remove All Data' is checked this will DELETE all tables in the database you are connecting to as the Duplicator requires a blank database.  Please make sure you have backups of all your data before using an portion of the installer, as this option WILL remove all data.  Please contact your server administrator for more details.
			<br/><br/>

			<b>Host:</b><br/>
			The name of the host server that the database resides on.  Many times this will be localhost, however each hosting provider will have it's own naming convention please check with your server administrator.  To add a port number just append it to the host i.e. 'localhost:3306'.
			<br/><br/>

			<b>User:</b><br/>
			The name of a MySQL database server user. This is special account that has privileges to access a database and can read from or write to that database.  <i style='font-size:11px'>This is <b>not</b> the same thing as your WordPress administrator account</i> 
			<br/><br/>

			<b>Password:</b><br/>
			The password of the MySQL database server user.
			<br/><br/>
			
			<b>Test Connection:</b><br/>
			The test connection button will help validate if the connection parameters are correct for this server.  There are three separate validation parameters: 
			<ul>
				<li><b>Host:</b> Returns a status to indicate if the server host name is a valid host name <br/><br/></li>
				<li><b>Database:</b> Returns a status to indicate if the database name is a valid <br/><br/></li>
				<li><b>Version:</b> Shows the difference in database engine version numbers. If the package was created on a newer database version than where its trying to 
				be installed then you can run into issues.  Its best to make sure the server where the installer is running has the same or higher version number than 
				where it was built.</li>
			</ul>
			<br/>			

			<b>Name:</b><br/>
			The name of the database to which this installation will connect and install the new tables onto.
			<br/><br/>

			<div class="help" style="border-top:1px solid silver">
				<b>Common Database Connection Issues:</b><br/>
				- Double check case sensitive values 'User', 'Password' &amp; the 'Database Name' <br/>
				- Validate the database and database user exist on this server <br/>
				- Check if the database user has the correct permission levels to this database <br/>
				- The host 'localhost' may not work on all hosting providers <br/>
				- Contact your hosting provider for the exact required parameters <br/>
				- See the 'Database Setup Help' section on step 1 for more details<br/>
				- Visit the online resources 'Common FAQ page' <br/>
			</div>


		</fieldset>				

		<!-- ADVANCED OPTS -->
		<fieldset>
			<legend><b>Advanced Options</b></legend>
			<b>Manual Package Extraction:</b><br/>
			This allows you to manually extract the zip archive on your own. This can be useful if your system does not have the ZipArchive support enabled.
			<br/><br/>		

			<b>Enforce SSL on Admin:</b><br/>
			Turn off SSL support for WordPress. This sets FORCE_SSL_ADMIN in your wp-config file to false if true, otherwise it will create the setting if not set.
			<br/><br/>	

			<b>Enforce SSL on Login:</b><br/>
			Turn off SSL support for WordPress Logins. This sets FORCE_SSL_LOGIN in your wp-config file to false if true, otherwise it will create the setting if not set.
			<br/><br/>			

			<b>Keep Cache Enabled:</b><br/>
			Turn off Cache support for WordPress. This sets WP_CACHE in your wp-config file to false if true, otherwise it will create the setting if not set.
			<br/><br/>	

			<b>Keep Cache Home Path:</b><br/>
			This sets WPCACHEHOME in your wp-config file to nothing if true, otherwise nothing is changed.
			<br/><br/>	

			<b>Fix non-breaking space characters:</b><br/>
			The process will remove utf8 characters represented as 'xC2' 'xA0' and replace with a uniform space.  Use this option if you find strange question marks in you posts
			<br/><br/>	
			
			<div id="help-mysql-mode">
				<b>Mysql Mode:</b><br/>
				The sql_mode option controls additional options you can pass to the MySQL server during the	database import process.  This option is only set <i>per session</i> 
				(during the Duplicator step 1 install process) and the modes here will return to their original state after step one runs.  The sql_mode options will vary 
				based on each version of mysql.  Below is a list list of links to the most recent MySQL versions.<br/>
				
				<ul>
					<li><a href="http://dev.mysql.com/doc/refman/5.5/en/sql-mode.html" target="_blank">MySQL Server 5.5 sql_mode options</a></li>
					<li><a href="http://dev.mysql.com/doc/refman/5.6/en/sql-mode.html" target="_blank">MySQL Server 5.6 sql_mode options</a></li>
					<li><a href="http://dev.mysql.com/doc/refman/5.7/en/sql-mode.html" target="_blank">MySQL Server 5.7 sql_mode options</a></li>
				</ul>
				
				This option creates a SET SESSION query such as <i>SET SESSION sql_mode = 'NO_ENGINE_SUBSTITUTION,NO_ZERO_IN_DATE'</i> and passes it to the MySQL server before any tables
				or data are created.	The following options are available:
				<br/>
				<ul>
					<li>
						<b>Default:</b> This option will not do anything and uses the default setting specified by the my.ini sql_mode value or the server's default sql_mode setting. 
						The installer-log.txt SQL_MODE value will show as NOT_SET if the my.ini sql_mode is not present or is set to empty.
						<br/><br/>
					</li>
					<li>
						<b>Disable:</b> This sets the sql_mode to an empty string which results in <i>SET SESSION sql_mode = ''</i>. 
						The installer-log.txt SQL_MODE value will show as NOT_SET<br/><br/>
					</li>
					<li>
						<b>Custom:</b> This setting allows you to pass in a custom set of sql_mode options such as <i>SET SESSION sql_mode = 'NO_ENGINE_SUBSTITUTION,NO_ZERO_IN_DATE'</i>.
						In the custom field input box enter in the sql_mode optionsthat you need for
						your particular server setup. 
						<br/><br/>
						Enter the sql mode as comma-separated values with no spaces, and <i>do not</i> include the 'SET SESSION' instruction. Be sure to pay attention to the MySQL server version and ensure it supports the specified options.
						The installer-log.txt file will record any errors that may occur while using this advanced option.
					</li>
				</ul>	

				Please note that if the SQL_MODE in the installer-log.txt is not showing correctly that you may need to check your database users privileges.  Also be sure that your MySQL
				server version supports all the the sql_mode options you're trying to pass. 
			</div>
			<br/>

			<b>MySQL Charset &amp; MySQL Collation:</b><br/>
			When the database is populated from the SQL script it will use this value as part of its connection.  Only change this value if you know what your databases character set should be.
			<br/>				
		</fieldset>			
	</div>

	<h3>Step 2 - Update</h3>
	<div id="dup-help-step2" class="dup-help-page">

		<!-- SETTINGS-->
		<fieldset>
			<legend><b>Settings</b></legend>
			<b>Old Settings:</b><br/>
			The URL and Path settings are the original values that the package was created with.  These values should not be changed.
			<br/><br/>

			<b>New Settings:</b><br/>
			These are the new values (URL, Path and Title) you can update for the new location at which your site will be installed at.
			<br/>		
		</fieldset>

		<!-- NEW ADMIN ACCOUNT-->
		<fieldset>
			<legend><b>New Admin Account</b></legend>
			<b>Username:</b><br/>
			The new username to create.  This will create a new WordPress administrator account.  Please note that usernames are not changeable from the within the UI.
			<br/><br/>

			<b>Password:</b><br/>
			The new password for the user. 
			<br/>		
		</fieldset>

		<!-- ADVANCED OPTS -->
		<fieldset>
			<legend><b>Advanced Options</b></legend>
			<b>Site URL:</b><br/>
			For details see WordPress <a href="http://codex.wordpress.org/Changing_The_Site_URL" target="_blank">Site URL</a> &amp; <a href="http://codex.wordpress.org/Giving_WordPress_Its_Own_Directory" target="_blank">Alternate Directory</a>.  If you're not sure about this value then leave it the same as the new settings URL.
			<br/><br/>

			<b>Scan Tables:</b><br/>
			Select the tables to be updated. This process will update all of the 'Old Settings' with the 'New Settings'. Hold down the 'ctrl key' to select/deselect multiple.
			<br/><br/>

			<b>Activate Plugins:</b><br/>
			These plug-ins are the plug-ins that were activated when the package was created and represent the plug-ins that will be activated after the install.
			<br/><br/>

			<b>Post GUID:</b><br/>
			If your moving a site keep this value checked. For more details see the <a href="http://codex.wordpress.org/Changing_The_Site_URL#Important_GUID_Note" target="_blank">notes on GUIDS</a>.	Changing values in the posts table GUID column can change RSS readers to evaluate that the posts are new and may show them in feeds again.		
			<br/><br/>	

			<b>Full Search:</b><br/>
			Full search forces a scan of every single cell in the database. If it is not checked then only text based columns are searched which makes the update process much faster.
			<br/>	
		</fieldset>

	</div>

	<h3>Step 3 - Test</h3>
	<div id="dup-help-step3" class="dup-help-page">
		<fieldset>
			<legend><b>Final Steps</b></legend>

			<b>Resave Permalinks</b><br/>
			Re-saving your perma-links will reconfigure your .htaccess file to match the correct path on your server.  This step requires logging back into the WordPress administrator.
			<br/><br/>

			<b>Delete Installer Files</b><br/>
			When you're completed with the installation please delete all installer files.  Leaving these files on your server can impose a security risk!
			<br/><br/>

			<b>Test Entire Site</b><br/>
			After the install is complete run through your entire site and test all pages and posts.
			<br/><br/>

			<b>View Install Report</b><br/>
			The install report is designed to give you a synopsis of the possible errors and warnings that may exist after the installation is completed.
			<br/>
		</fieldset>
	</div>

	
	<h3>Troubleshooting Tips</h3>
	<div id="troubleshoot" class="dup-help-page">
		<fieldset>
			<legend><b>Quick Overview</b></legend>

			<div style="padding: 0px 10px 10px 10px;">		
				<b>Common Quick Fix Issues:</b>
				<ul>
					<li>Use an <a href='https://snapcreek.com/duplicator/docs/faqs-tech/#faq-resource-040-q' target='_blank'>approved hosting provider</a></li>
					<li>Validate directory and file permissions (see below)</li>
					<li>Validate web server configuration file (see below)</li>
					<li>Clear your browsers cache</li>
					<li>Deactivate and reactivate all plugins</li>
					<li>Resave a plugins settings if it reports errors</li>
					<li>Make sure your root directory is empty</li>
				</ul>

				<b>Permissions:</b><br/> 
				Not all operating systems are alike.  Therefore, when you move a package (zip file) from one location to another the file and directory permissions may not always stick.  If this is the case then check your WordPress directories and make sure it's permissions are set to 755. For files make sure the permissions are set to 644 (this does not apply to windows servers).   Also pay attention to the owner/group attributes.  For a full overview of the correct file changes see the <a href='http://codex.wordpress.org/Hardening_WordPress#File_permissions' target='_blank'>WordPress permissions codex</a>
				<br/><br/>

				<b>Web server configuration files:</b><br/>
				For Apache web server the root .htaccess file was copied to .htaccess.orig. A new stripped down .htaccess file was created to help simplify access issues.  For IIS web server the web.config file was copied to web.config.orig, however no new web.config file was created.  If you have not altered this file manually then resaving your permalinks and resaving your plugins should resolve most all changes that were made to the root web configuration file.   If your still experiencing issues then open the .orig file and do a compare to see what changes need to be made. <br/><br/><b>Plugin Notes:</b><br/> It's impossible to know how all 3rd party plugins function.  The Duplicator attempts to fix the new install URL for settings stored in the WordPress options table.   Please validate that all plugins retained there settings after installing.   If you experience issues try to bulk deactivate all plugins then bulk reactivate them on your new duplicated site. If you run into issues were a plugin does not retain its data then try to resave the plugins settings.
				<br/><br/>

				 <b>Cache Systems:</b><br/>
				 Any type of cache system such as Super Cache, W3 Cache, etc. should be emptied before you create a package.  Another alternative is to include the cache directory in the directory exclusion path list found in the options dialog. Including a directory such as \pathtowordpress\wp-content\w3tc\ (the w3 Total Cache directory) will exclude this directory from being packaged. In is highly recommended to always perform a cache empty when you first fire up your new site even if you excluded your cache directory.
				 <br/><br/>

				 <b>Trying Again:</b><br/>
				 If you need to retry and reinstall this package you can easily run the process again by deleting all files except the installer.php and package file and then browse to the installer.php again.
				 <br/><br/>

				 <b>Additional Notes:</b><br/>
				 If you have made changes to your PHP files directly this might have an impact on your duplicated site.  Be sure all changes made will correspond to the sites new location. 
				 Only the package (zip file) and the installer.php file should be in the directory where you are installing the site.  Please read through our knowledge base before submitting any issues. 
				 If you have a large log file that needs evaluated please email the file, or attach it to a help ticket.
				 <br/><br/>

			</div>
		</fieldset>
	</div>

	<div style="text-align:center">For in-depth help please see the <a href="https://snapcreek.com/duplicator/docs/" target="_blank">online resources</a></div>

	<br/><br/>
</div>