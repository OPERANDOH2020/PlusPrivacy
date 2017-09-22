=== Clean Login ===
Contributors: hornero, carazo
Donate link: http://codection.com
Tags: form, login, registration, editor, lost password, responsive, wpml, internationalization, languages, role, CAPTCHA, honeypot, shortcode, wordpress, frontend
Requires at least: 3.4
Tested up to: 4.7
Stable tag: 1.8.1
License: GPLv2 or later
License URI: http://www.gnu.org/licenses/gpl-2.0.html

A plugin for displaying useful forms in front-end only using shortcodes. Login, Registration, Profile Editor and Lost Password forms

== Description ==

Responsive Frontend Login and Registration plugin. A plugin for displaying login, register, editor and restore password forms through shortcodes.

*   _[clean-login]_
*   _[clean-login-edit]_
*   _[clean-login-register]_
*   _[clean-login-restore]_

### Basics

*   Add your login form in the frontend easily (page or post)
*   And also the registration and the lost password form
*   If user is logged in, the user will see a custom profile and will be able to edit his/her data in another front-end form
*   One shortcode per form, you only need to create a page or post and apply this shortcode to create each form you want

### Style

*   Every form created is responsive
*   CSS adapted to each theme

### Spam protection

*   Register form protected with CAPTCHA (as an option)
*   Forms are also protected by Honeypot antispam protection

### Internacionalization

*   WMPL ready with [oficial certification](http://wpml.org/plugin/clean-login/)
*   .po/.mo template included
*	Many languages included by default

### More features

*   Auto status checker
*   Hide admin bar for non-admin users as an option
*   Disable dashboard access as an option
*   Standby user role for new user registration. With no capabilities, to allow admin approval of users optionally
*   Auto linked forms, if you place a shortcode in a page/post the link between them will be automatically generated
*   And yes, this is WordPress 4.6 ready! Also compatible with WooCommerce.

You could test it here [cleanlogin.codection.com](http://cleanlogin.codection.com/). Enjoy!

== Usage and Settings ==

Please, refer to [Installation section](https://wordpress.org/plugins/clean-login/installation/)

== Screenshots ==

1. Login form
2. Preview user
3. Editor form
4. Lost password form
5. Register form with CAPTCHA
6. Setting access from the dashboard
7. Setting page from the dashboard
8. Settings menu
9. Plugin status
10. Options section
11. Settings updated
12. WPML. Certificate of Compatibility

== Changelog ==

= 1.8.1 =
*   $_POST sanitizing bug solved. Thanks to tomykas (@tomykas)

= 1.8 =
*   Norwegian language included. Thanks to Pablo Gómez Margareto
*   Security exploits fixed, described below. Thanks to Ipstenu (Mika Epstein)
*   Sanitize, escape, and validate all POST calls. Bug fixed
*   Checked using Nonces and permissions. Bug fixed
*   Prevent direct file access for all PHP files. Bug fixed
*   Unique function name for all internal functions. Bug fixed
*   index.php file (silence is golden) included.
*	clean_login_register_session removed, code consequently updated.

= 1.7.12 =
*   Trying to get property of non-object at clean_login_load_before_headers() function is now fixed. Thanks to rasika17 (@rasika17) for reporting this issue.

= 1.7.11 =
*   Thumbnail image updated. icon-128x128 and icon-256x256
*   Text domain updated to clean-login, https://translate.wordpress.org/locale/es/default/wp-plugins/clean-login
*   get_translated_option_page() function bug fixed. Thanks to Ignazio Lucenti
*   The third parameter for preg_match_all became optional from PHP 5.4.0. but before it's mandatory. Fixed! Thanks to Hemant Arora (@hemantkumararora)

= 1.7.10 =
*   Ukrainian language included. Thanks to Павел Дидыченко @didychenko
*   Tested on 4.7

= 1.7.9 =
*   Bug solved. User Roles are not translated on the frontend. Thanks to @ramzesimus for reporting it.
*   Partial support with Black Studio TinyMCE Widget and Shortcode Widget plugins, but one extra shortcode [clean-login] is needed to be include in a page/post. Thanks to Marco Chiesi @marcochiesi
*   Bug due to template support is now solved. Notice in the Register Form after 1.7.8 update. Thanks to @ramzesimus
*   Potential bug solved, due to variable scope at register-new.php

= 1.7.8 =
*   WPML redirection fixed. Thanks to @provinciacreative for the feedback

= 1.7.7 =
*   WPML redirection support for all the pages with clean-login shortcode and for the terms and conditions url. Thanks to Ignazio Lucenti, and also thanks to @webanwendung24
*   Template support added. Now the plugin looks for the templates in the "theme_folder/clean-login/" as well. This is very useful to override the look of the content pages and keep this overrides when updating the plugin. Thanks to Ignazio Lucenti
*   cl_login_form filter included in the login form (this can be also updated through templates)

= 1.7.6 =
*   Added filter cl_login_redirect_url to allow overriding the login redirect, thanks to Diego Zanella <support@aelia.co>
*   Added filter cl_logout_redirect_url to allow overriding the logout redirect, thanks to Diego Zanella <support@aelia.co>

= 1.7.5 =
*   get_currentuserinfo() has been also replaced in all the forms, thanks to @ramzesimus
*   wp_enqueue_style unique handle name and dependency, thanks to @ramzesimus
*   Tested on 4.6 (beta1)

= 1.7.4 =
*   get_currentuserinfo() has been deprecated in WordPress 4.5. It is currently replaced by wp_get_current_user(). Thanks to @christer_f for notifying us

= 1.7.3 =
*   Turkish language updated. Thanks to Mert Eden
*   Tested on 4.5

= 1.7.2 =
*   French language updated. Thanks to thaipop

= 1.7.1 =
*   'Clean Login status and links' widget markup bug fixed. Thanks to ramzesimus (Роман Перевала)

= 1.7 =
*   Add name and surname in the registration form feature. Feature supported by Jordi Raüll
*   Validate user registration through an email. Feature supported by Jordi Raüll
*   Name and username as mandatory fields. Feature proposed by Vess Ivanov
*   Spanish translation updated
*   Catalonian language template (empty) created
*   Bug fixed in the login form when using redirections
*   Tested on 4.4

= 1.6.1 =
*   Settings link included in the plugins list
*   Redirection feature after registration bug fixed. Thanks to plentyland and davispe for reporting it
*   Tested on 4.3.1
*   Redirect after login and logout. Feature supported by Juan Manuel Caceres from JC Global Resources
*   Spanish translation updated
*   Some improvements in the setting page

= 1.6 =
*   Spanish translation updated
*   Notify the user registration through the 'user_register' action hook. By ensuring, inter alia, the user role registration and MailPoet newsletters compatibility. Thanks to [hamlet237](https://profiles.wordpress.org/hamlet237/)
*   Bug fixed in the URL for terms and conditions at registration form. Thanks again to [hamlet237](https://profiles.wordpress.org/hamlet237/)
*   en_US translation created, with the idea of translating default strings :-) Thanks to [fdkfashiondesign](https://profiles.wordpress.org/fdkfashiondesign/)
*   Username as email feature. Thanks to [Lindsay Macvean](https://github.com/lindsaymacvean)
*   Single password feature. Admins can simplify the registration process if desired. Thanks again to [Lindsay Macvean](https://github.com/lindsaymacvean)
*   Redirection feature after registration. Thanks once again to [Lindsay Macvean](https://github.com/lindsaymacvean)
*   jQuery cleaned up, and log_me bug fixed. Thanks third again to [Lindsay Macvean](https://github.com/lindsaymacvean)
*   FAQ updated
*   Tested on 4.3
*   Donation link included

= 1.5.1 =
*   Spanish translation updated
*   Donation link included
*   Reflected XSS vulnerability fixed. Thanks to [HSASec-Team](https://www.HSASec.de)

= 1.5 =
*   Spanish translation updated
*   Clean Login register with mandatory checkbox. Feature supported by Martijn van der Wijck

= 1.4.1 =
*   Swedish language included. Thanks to Didrik Holstensson Kvist
*   Tested on 4.2.2
*   Bug fixed 'query_arg not sanitized at login form'. Thanks to KTS915.

= 1.4 =
*   Spanish translation updated
*   .cleanlogin-field-role class added to ensure more flexibility in CSS styling
*   Polish language included. Thanks to Jarosław Idzior
*   ...query_arg()'s have been sanitized to avoid [XSS vulnerability](https://blog.sucuri.net/2015/04/security-advisory-xss-vulnerability-affecting-multiple-wordpress-plugins.html)
*   Registration form shortcode adds standard role capability as parameter, e.g. [clean-login-register role="contributor"]. Feature supported by Joyce Tan

= 1.3 =
*   Email notification for new registered users with an editable email content, as option in the setting page. Feature supported by Роман Перевала (Perevala Roman)
*   Predefined roles by the administrator when a new user is registered with the ability to choose his/her own role, as option in the setting page. Feature supported by Роман Перевала (Perevala Roman)
*   Translation included in the restore password email subject
*   Translation included in the new user email subject

= 1.2.8 =
*   Logout link included in default Clean Login Widget

= 1.2.7 =
*   Bug fixed 'Notice: Use of undefined constant DOING_AJAX'

= 1.2.6 =
*   Bug fixed in AJAX queries. Thanks again to Роман Перевала for reporting

= 1.2.5 =
*   Bug fixed in block dashboard access (as option) related with some AJAX interactions. Thanks to Роман Перевала for reporting

= 1.2.4 =
*   FAQ section included.

= 1.2.3 =
*   French language updated. Thanks to Alain Sole
*   Tested on 4.2

= 1.2.2 =
*   Bug fixed in password complexity checker. Thanks to Steve Scofield for reporting

= 1.2.1 =
*   Russian language included. Thanks to Anastassiya Polyakova
*	Hebrew language filename fixed

= 1.2 =
*   Password complexity as option. Passwords must be at least eight characters including one upper/lowercase letter, one special/symbol character and alphanumeric characters. Passwords should not contain the user\'s username, email, or first/last name. Feature supported by Steve Scofield
*	"Failed security check" replaced by "Failed security check, expired Activation Link due to duplication or date."

= 1.1.11 =
*   Italian language included. Thanks to Walter Priori Friggi

= 1.1.10 =
*   Persian language included. Thanks to Morteza Rajabzade
*   Dutch language included. Thanks to Hans van der Marel

= 1.1.9 =
*   Improving captcha visibility (higher font size). Thanks to plentyland for the feedback.
*   WP Super Cache full compatibility (https://wordpress.org/plugins/wp-super-cache/)

= 1.1.8 =
*   Brazilian Portuguese language included. Thanks to Filipe Mendes Schüler (@fmschuler)
*   Tested on 4.1.1

= 1.1.7 =
*   German language included. Thanks to Rainer (rainerma)
*   Serbian language included. Thanks to Borisa Djuraskovic (from webhostinghub.com)

= 1.1.6 =
*   Hebrew language updated. Thanks again to Ahrale (from Atar4U)

= 1.1.5 =
*   Hebrew language included. Thanks to Ahrale (from Atar4U)
*   Tested on 4.1
*   WPML Certified plugin (http://wpml.org/plugin/clean-login/)

= 1.1.4 =
*   Danish language included. Thanks to Bkold (Børge Kolding)
*   Registration button disabled on submit (with JS, no jQuery to ensure themes compatibility)
*   Icon for WordPress dashboard included (for both 128 and 256 px resolutions)

= 1.1.3 =
*   French language updated from sources (no translation included)

= 1.1.2 =
*   Simplifying the placeholder in the restore form by ensuring external plugins (which replace strings) compatibility.

= 1.1.1 =
*   Bug detected: First name and last name of the current user is hidden if the username is hidden by settings. Solved!

= 1.1.0 =
*   Enabling to permit users to reset their password using their email. Feature supported by KTS915
*   The username can be switched off from the preview form. Feature supported by KTS915
*   Spanish language updated.

= 1.0.6 =
*   French language included. Thanks to Blasteur83 (Dylan Lane)

= 1.0.5 =
*   Prepend all the functions names by ensuring the plugin compatibility and stability. Thanks to dharmashanti
*   Tested on 3.9.2

= 1.0.4 =
*   Output buffering turned on, following the Shortcode API. Thanks to stewarty

= 1.0.3 =
*   Mistake solved under plugin description. Thanks to WP-Biz (Ryan)

= 1.0.2 =
*   Demo site URL updated and also the content
*   Screenshots updated
*   Documentation deleted from index.html and also updated here.

= 1.0.1 =
*   Banner created
*   Screenshots added
*   Demo site for testing purposes

= 1.0.0 =
*   First release

== Upgrade Notice ==

= 1.0 =
*   First installation

== Demo site ==

[cleanlogin.codection.com](http://cleanlogin.codection.com/)

== Frequently Asked Questions ==

*   Can I use my email in addition to your username for login? Yes, through [WP Email Login](https://wordpress.org/plugins/wp-email-login/).
*   Can I modify my Avatar? Clean Login uses your email to get your Avatar from the Gravatar service (from Automattic), but if you want to modify from the WordPress dashboard you can use [WP User Avatar](https://wordpress.org/plugins/wp-user-avatar/).
*   Is Clean Login compatible with AJAX-based plugins/themes/queries? Yes, from the version 1.2.6.
*   Can I change the sender name from Wordpress to my domain name? Yes, through [WP Simple Mail Sender](https://wordpress.org/plugins/wp-simple-mail-sender/).

== Installation ==

### Installation

*   Install **Clean Login** automatically through the WordPress Dashboard or by uploading the ZIP file in the _plugins_ directory.
*   Then, after the package is uploaded and extracted, click&nbsp;_Activate Plugin_.

Now going through the points above, you should now see a new&nbsp;_Clean Login_&nbsp;menu item under Settings menu in the sidebar of the admin panel, see figure below of how it looks like.

[Setting Menu image link](https://ps.w.org/clean-login/assets/screenshot-8.jpg)

If you get any error after following through the steps above please contact us through item support comments so we can get back to you with possible helps in installing the plugin and more. On successful activation of this plugin, you should be able to see the login form when you place this shortcode&nbsp;_[clean-login]_&nbsp;in any page or post

* * *

### Settings

Below, the description of each shortcode for use as registration, login, lost password and profile editor forms

*   _[clean-login]_ This shortcode contains login form and login information.
*   _[clean-login-edit]_ This shortcode contains the profile editor. If you include in a page/post a link will appear on your login preview.
*   _[clean-login-register]_ This shortcode contains the register form. If you include in a page/post a link will appear on your login form.
*   _[clean-login-restore]_ This shortcode contains the restore (lost password?) form. If you include in a page/post a link will appear on your login form.

Also, in the Clean Login settings page you can check the plugin status as follows:

[Plugin status image link](https://ps.w.org/clean-login/assets/screenshot-9.jpg)

In this setting page you can also find the way to enable/disable the differents options of the plugin, like below:

[Options image link](https://ps.w.org/clean-login/assets/screenshot-10.jpg)

Regarding the widget usage, just place the&nbsp;_Clean Login status and links_&nbsp;widget in the widget area you prefer. It will show the user status and the links to the pages/posts which contains the plugin shortcodes.

Please feel free to contact us if you have any questions.

* * *

### Example

A post/page need to be created by typing the main shortcode&nbsp;_[clean-login]_&nbsp;in the content.

When you save or update this post/page you will see the login form.

And also in the setting page&nbsp;_[clean-login]_&nbsp;entry will be updated pointing to the current post/page which contains the shortcode (and generates the login form):

[Settings updated image link](https://ps.w.org/clean-login/assets/screenshot-11.jpg)

We would repeat the same process with the rest of shortcodes if we need it:

*   _[clean-login-edit]_&nbsp;to create an edit profile form
*   _[clean-login-register]_&nbsp;to create a registration form
*   _[clean-login-restore]_&nbsp;to create a forgotten password and restore form
