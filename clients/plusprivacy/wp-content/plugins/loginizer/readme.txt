=== Loginizer ===
Contributors: loginizer
Tags: access, admin, Loginizer, login, logs, ban ip, failed login, ip, whitelist ip, blacklist ip, failed attempts, lockouts, hack, authentication, login, security, rename login url, rename login, rename wp-admin, secure wp-admin, rename admin url, secure admin
Requires at least: 3.0
Tested up to: 4.7
Stable tag: 1.3.2
License: GPLv3 or later
License URI: http://www.gnu.org/licenses/gpl.html

Loginizer is a WordPress security plugin which helps you fight against bruteforce attacks.

== Description ==

Loginizer is a WordPress plugin which helps you fight against bruteforce attack by blocking login for the IP after it reaches maximum retries allowed. You can blacklist or whitelist IPs for login using Loginizer. You can use various other features like Two Factor Auth, reCAPTCHA, PasswordLess Login, etc. to improve security of your website.

Loginizer is actively used by more than 300000+ WordPress websites.

You can find our official documentation at <a href="https://loginizer.com/docs">https://loginizer.com/docs</a> and our Frequently Asked Questions on our support portal at <a href="https://loginizer.com/members">https://loginizer.com/members</a>. We are also active in our community support forums on <a href="https://wordpress.org/support/plugin/loginizer">wordpress.org</a> if you are one of our free users. Our Premium Support Ticket System is at <a href="https://loginizer.com/members">https://loginizer.com/members</a>

= Get Support and Pro Features =

Get professional support from our experts and pro features to take your site's security to the next level with <a href="https://loginizer.com/pricing">Loginizer-Security</a>.

Pro Features :

* MD5 Checksum - of Core WordPress Files. The admin can check and ignore files as well.
* PasswordLess Login - At the time of Login, the username / email address will be asked and an email will be sent to the email address of that account with a temporary link to login.
* Two Factor Auth via Email - On login, an email will be sent to the email address of that account with a temporary 6 digit code to complete the login.
* Two Factor Auth via App - The user can configure the account with a 2FA App like Google Authenticator, Authy, etc.
* Login Challenge Question - The user can setup a <i>Challenge Question and Answer</i> as an additional security layer. After Login, the user will need to answer the question to complete the login.
* reCAPTCHA - Google's reCAPTCHA can be configured for the Login screen, Comments Section, Registration Form, etc. to prevent automated brute force attacks. Supports WooCommerce as well.
* Rename Login Page - The Admin can rename the login URL (slug) to something different from wp-login.php to prevent automated brute force attacks.
* Rename WP-Admin URL - The Admin area in WordPress is accessed via wp-admin. With loginizer you can change it to anything e.g. site-admin
* Rename Login with Secrecy - If set, then all Login URL's will still point to wp-login.php and users will have to access the New Login Slug by typing it in the browser.
* Disable XML-RPC - An option to simply disable XML-RPC in WordPress. Most of the WordPress users don't need XML-RPC and can disable it to prevent automated brute force attacks.
* Rename XML-RPC - The Admin can rename the XML-RPC to something different from xmlrpc.php to prevent automated brute force attacks.
* Change the Admin Username - The Admin can rename the admin username to something more difficult.
* Auto Blacklist IPs - IPs will be auto blacklisted, if certain usernames saved by the Admin are used to login by malicious bots / users.
* Disable Pingbacks - Simple way to disable PingBacks.

Features in Loginizer include:

* Blocks IP after maximum retries allowed
* Extended Lockout after maximum lockouts allowed
* Email notification to admin after max lockouts
* Blacklist IP/IP range
* Whitelist IP/IP range
* Check logs of failed attempts
* Create IP ranges
* Delete IP ranges
* Licensed under GNU GPL version 3
* Safe & Secure


== Installation ==

Upload the Loginizer plugin to your blog, Activate it.
That's it. You're done!

== Screenshots ==

1. Login Failed Error message
2. Loginizer Dashboard page
3. Loginizer Brute Force Settings page

== Changelog ==

= 1.3.2 =
* [Feature] Added option to choose between REMOTE_ADDR, HTTP_CLIENT_IP and HTTP_X_FORWARDED for websites behind a proxy 
* [Task] The news.js will now be loaded from HTTPS servers

= 1.3.1 =
* [Feature] The Login attempt logs will now be shown as per the last attempt TIME and in Descending Order
* [Feature] Added an option to Reset the Login attempts for all or specific IPs 

= 1.3.0 =
* [Feature] Added pagination in the Brute Force Logs Wizard
* [Bug Fix] Disabling and Re-Enabling Loginizer caused an SQL error

= 1.2.0 =
* [Task] The brute force logs will now be sorted as per the time of failed login attemps
* [Bug Fix] Dashboard showed wrong permissions if wp-content path had been changed
* [Bug Fix] Added Directory path to include files which caused issues with some plugins

= 1.1.1 =
* [Bug Fix] Added ABSPATH instead of get_home_path()

= 1.1.0 =

* [Feature] New Dashboard
* [Feature] System Information added in the new Dashboard
* [Feature] File Permissions added in the new Dashboard
* [Feature] New UI
* [Bug Fix] Fixed bug to add IP Range from 0.0.0.1 - 255.255.255.255
* [Bug Fix] Removed /e from preg_replace causing warnings in PHP

= 1.0.2 =

* Fixed Extended Lockout bug
* Fixed Lockout bug
* Handle login attempts via XML-RPC

= 1.0.1 =

* Database structure changes to make the plugin work faster
* Minor fixes

= 1.0 =

* Blocks IP after maximum retries allowed
* Extended Lockout after maximum lockouts allowed
* Email notification to admin after max lockouts
* Blacklist IP/IP range
* Whitelist IP/IP range
* Check logs of failed attempts
* Create IP ranges
* Delete IP ranges
* Licensed under GNU GPL version 3
* Safe & Secure