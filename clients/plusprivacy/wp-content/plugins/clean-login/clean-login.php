<?php
/**
 * @package Clean_Login
 * @version 1.8.1
 */
/*
Plugin Name: Clean Login
Plugin URI: http://cleanlogin.codection.com
Description: Responsive Frontend Login and Registration plugin. A plugin for displaying login, register, editor and restore password forms through shortcodes. [clean-login] [clean-login-edit] [clean-login-register] [clean-login-restore]
Author: codection
Version: 1.8.1
Author URI: https://codection.com
Text Domain: clean-login
Domain Path: /lang
*/

if ( ! defined( 'ABSPATH' ) ) exit; 

/**
 * Enqueue plugin style
 *
 * @since 0.8
 */

function clean_login_enqueue_style() {
    wp_register_style( 'clean-login-css', plugins_url( 'content/style.css', __FILE__ ) );
    wp_enqueue_style( 'clean-login-css' );
}
add_action( 'wp_enqueue_scripts', 'clean_login_enqueue_style' ); 

/**
 * [clean-login] shortcode
 *
 * @since 0.8
 */
function clean_login_show($atts) {

	ob_start();
	
	if ( isset( $_GET['authentication'] ) ) {
		if ( $_GET['authentication'] == 'success' )
			echo "<div class='cleanlogin-notification success'><p>". __( 'Successfully logged in!', 'clean-login' ) ."</p></div>";
		else if ( $_GET['authentication'] == 'failed' )
			echo "<div class='cleanlogin-notification error'><p>". __( 'Wrong credentials', 'clean-login' ) ."</p></div>";
		else if ( $_GET['authentication'] == 'logout' )
			echo "<div class='cleanlogin-notification success'><p>". __( 'Successfully logged out!', 'clean-login' ) ."</p></div>";
		else if ( $_GET['authentication'] == 'failed-activation' )
			echo "<div class='cleanlogin-notification error'><p>". __( 'Something went wrong while activating your user', 'clean-login' ) ."</p></div>";
				else if ( $_GET['authentication'] == 'disabled' )
			echo "<div class='cleanlogin-notification error'><p>". __( 'Your account is currently disabled', 'clean-login' ) ."</p></div>";
		else if ( $_GET['authentication'] == 'success-activation' )
			echo "<div class='cleanlogin-notification success'><p>". __( 'Successfully activated', 'clean-login' ) ."</p></div>";
	}

	if ( is_user_logged_in() ) {
		// show user preview data
		clean_login_get_template_file( 'login-preview.php' );

	} else {
		// show login form
		clean_login_get_template_file( 'login-form.php' );
	}

	return ob_get_clean();

}
add_shortcode('clean-login', 'clean_login_show');

/**
 * [clean-login-edit] shortcode
 *
 * @since 0.8
 */
function clean_login_edit_show($atts) {
	
	ob_start();

	if ( isset( $_GET['updated'] ) ) {
		if ( $_GET['updated'] == 'success' )
			echo "<div class='cleanlogin-notification success'><p>". __( 'Information updated', 'clean-login' ) ."</p></div>";
		else if ( $_GET['updated'] == 'passcomplex' )
			echo "<div class='cleanlogin-notification error'><p>". __( 'Passwords must be eight characters including one upper/lowercase letter, one special/symbol character and alphanumeric characters. Passwords should not contain the user\'s username, email, or first/last name.', 'clean-login' ) ."</p></div>";
		else if ( $_GET['updated'] == 'wrongpass' )
			echo "<div class='cleanlogin-notification error'><p>". __( 'Passwords must be identical', 'clean-login' ) ."</p></div>";
		else if ( $_GET['updated'] == 'wrongmail' )
			echo "<div class='cleanlogin-notification error'><p>". __( 'Error updating email', 'clean-login' ) ."</p></div>";
		else if ( $_GET['updated'] == 'failed' )
			echo "<div class='cleanlogin-notification error'><p>". __( 'Something strange has ocurred', 'clean-login' ) ."</p></div>";
	}

	if ( is_user_logged_in() ) {
		clean_login_get_template_file( 'login-edit.php' );
	} else {
		echo "<div class='cleanlogin-notification error'><p>". __( 'You need to be logged in to edit your profile', 'clean-login' ) ."</p></div>";
		clean_login_get_template_file( 'login-form.php' );
		/*$login_url = get_option( 'cl_login_url', '');
		if ( $login_url != '' )
			echo "<script>window.location = '$login_url'</script>";*/
	}

	return ob_get_clean();

}
add_shortcode('clean-login-edit', 'clean_login_edit_show');

/**
 * [clean-login-register] shortcode
 *
 * @since 0.8
 */
function clean_login_register_show($atts) {
	
	$param = shortcode_atts( array(
        'role' => false,
    ), $atts );

	ob_start();

	if ( isset( $_GET['created'] ) ) {
		if ( $_GET['created'] == 'success' )
			echo "<div class='cleanlogin-notification success'><p>". __( 'User created', 'clean-login' ) ."</p></div>";
		else if ( $_GET['created'] == 'success-link' )
			echo "<div class='cleanlogin-notification success'><p>". __( 'User created', 'clean-login' ) ."<br>". __( 'Please confirm your account, you will receive an email', 'clean-login' ) ."</p></div>";
		else if ( $_GET['created'] == 'created' )
			echo "<div class='cleanlogin-notification success'><p>". __( 'New user created', 'clean-login' ) ."</p></div>";
		else if ( $_GET['created'] == 'passcomplex' )
			echo "<div class='cleanlogin-notification error'><p>". __( 'Passwords must be eight characters including one upper/lowercase letter, one special/symbol character and alphanumeric characters. Passwords should not contain the user\'s username, email, or first/last name.', 'clean-login' ) ."</p></div>";
		else if ( $_GET['created'] == 'wronguser' )
			echo "<div class='cleanlogin-notification error'><p>". __( 'Username is not valid', 'clean-login' ) ."</p></div>";
		else if ( $_GET['created'] == 'wrongname' )
			echo "<div class='cleanlogin-notification error'><p>". __( 'First name is not valid', 'clean-login' ) ."</p></div>";
		else if ( $_GET['created'] == 'wrongsurname' )
			echo "<div class='cleanlogin-notification error'><p>". __( 'Last name is not valid', 'clean-login' ) ."</p></div>";
		else if ( $_GET['created'] == 'wrongpass' )
			echo "<div class='cleanlogin-notification error'><p>". __( 'Passwords must be identical and filled', 'clean-login' ) ."</p></div>";
		else if ( $_GET['created'] == 'wrongmail' )
			echo "<div class='cleanlogin-notification error'><p>". __( 'Email is not valid', 'clean-login' ) ."</p></div>";
		else if ( $_GET['created'] == 'wrongcaptcha' )
			echo "<div class='cleanlogin-notification error'><p>". __( 'CAPTCHA is not valid, please try again', 'clean-login' ) ."</p></div>";
		else if ( $_GET['created'] == 'failed' )
			echo "<div class='cleanlogin-notification error'><p>". __( 'Something strange has ocurred while created the new user', 'clean-login' ) ."</p></div>";
		else if ( $_GET['created'] == 'terms' )
			echo "<div class='cleanlogin-notification error'><p>\"". get_option ( 'cl_termsconditionsMSG' ) . '" ' .__( 'must be checked', 'clean-login' ) . "</p></div>";
	}

	if ( !is_user_logged_in() ) {
		clean_login_get_template_file( 'register-form.php', $param );
	} else {
		echo "<div class='cleanlogin-notification error'><p>". __( 'You are now logged in. It makes no sense to register a new user', 'clean-login' ) ."</p></div>";
		clean_login_get_template_file( 'login-preview.php' );
		/*$login_url = get_option( 'cl_login_url', '');
		if ( $login_url != '' )
			echo "<script>window.location = '$login_url'</script>";*/
	}

	return ob_get_clean();

}
add_shortcode('clean-login-register', 'clean_login_register_show');

/**
 * [clean-login-restore] shortcode
 *
 * @since 0.8
 */
function clean_login_restore_show($atts) {

	ob_start();

	if ( isset( $_GET['sent'] ) ) {
		if ( $_GET['sent'] == 'success' )
			echo "<div class='cleanlogin-notification success'><p>". __( 'You will receive an email with the activation link', 'clean-login' ) ."</p></div>";
		else if ( $_GET['sent'] == 'sent' )
			echo "<div class='cleanlogin-notification success'><p>". __( 'You may receive an email with the activation link', 'clean-login' ) ."</p></div>";
		else if ( $_GET['sent'] == 'failed' )
			echo "<div class='cleanlogin-notification error'><p>". __( 'An error has ocurred sending the email', 'clean-login' ) ."</p></div>";
		else if ( $_GET['sent'] == 'wronguser' )
			echo "<div class='cleanlogin-notification error'><p>". __( 'Username is not valid', 'clean-login' ) ."</p></div>";
	}

	if ( !is_user_logged_in() ) {
		if ( isset( $_GET['pass'] ) ) {
			clean_login_get_template_file( 'restore-new.php' );
		} else
			clean_login_get_template_file( 'restore-form.php' );
	} else {
		echo "<div class='cleanlogin-notification error'><p>". __( 'You are now logged in. It makes no sense to restore your account', 'clean-login' ) ."</p></div>";
		clean_login_get_template_file( 'login-preview.php' );
		/*$login_url = get_option( 'cl_login_url', '');
		if ( $login_url != '' )
			echo "<script>window.location = '$login_url'</script>";*/
	}

	return ob_get_clean();

}
add_shortcode('clean-login-restore', 'clean_login_restore_show');


/**
 * Password complexity checker
 *
 * @since 1.2
 */
function clean_login_is_password_complex($candidate) {
	// The third parameter for preg_match_all became optional from PHP 5.4.0. but before it's mandatory
	$dummy = array();
	if (!preg_match_all('$\S*(?=\S{8,})(?=\S*[a-z])(?=\S*[A-Z])(?=\S*[\d])(?=\S*[\W])\S*$', $candidate, $dummy))
        return false;
    return true;

    /* Explaining $\S*(?=\S{8,})(?=\S*[a-z])(?=\S*[A-Z])(?=\S*[\d])(?=\S*[\W])\S*$
    $ = beginning of string
    \S* = any set of characters
    (?=\S{8,}) = of at least length 8
    (?=\S*[a-z]) = containing at least one lowercase letter
    (?=\S*[A-Z]) = and at least one uppercase letter
    (?=\S*[\d]) = and at least one number
    (?=\S*[\W]) = and at least a special character (non-word characters)
    $ = end of the string */
}


/**
 * Custom code to be loaded before headers
 *
 * @since 0.8
 */
function clean_login_load_before_headers() {
	global $wp_query; 
	if ( is_singular() ) { 
		$post = $wp_query->get_queried_object();
		
		// If contains any shortcode of our ones
		if ( $post && strpos($post->post_content, 'clean-login' ) !== false ) {

			// Sets the redirect url to the current page 
			$url = clean_login_url_cleaner( wp_get_referer() );

			// LOGIN
			if ( isset( $_REQUEST['action'] ) && $_REQUEST['action'] == 'login' ) {
				$url = clean_login_get_translated_option_page( 'cl_login_url','');
				
				$user = wp_signon();
				if ( is_wp_error( $user ) )
					$url = esc_url( add_query_arg( 'authentication', 'failed', $url ) );
				else {
					// if the user is disabled
					if( empty($user->roles) ) {
						wp_logout();
						$url = esc_url( add_query_arg( 'authentication', 'disabled', $url ) );
					}
					else 
						$url = get_option('cl_login_redirect', false) ? esc_url(apply_filters('cl_login_redirect_url', clean_login_get_translated_option_page('cl_login_redirect_url'), $user)): esc_url( add_query_arg( 'authentication', 'success', $url ) );
				}
					

				wp_safe_redirect( $url );

			// LOGOUT
			} else if ( isset( $_REQUEST['action'] ) && $_REQUEST['action'] == 'logout' ) {
				wp_logout();
				$url = esc_url( add_query_arg( 'authentication', 'logout', $url ) );
				
				wp_safe_redirect( $url );

			// EDIT profile
			} else if ( isset( $_REQUEST['action'] ) && $_REQUEST['action'] == 'edit' ) {
				$url = esc_url( add_query_arg( 'updated', 'success', $url ) );

				$current_user = wp_get_current_user();
				$userdata = array( 'ID' => $current_user->ID );

				$first_name = isset( $_POST['first_name'] ) ? sanitize_text_field( $_POST['first_name'] ) : '';
				$last_name = isset( $_POST['last_name'] ) ? sanitize_text_field( $_POST['last_name'] ) : '';
				$userdata['first_name'] = $first_name;
				$userdata['last_name'] = $last_name;
			
				$email = isset( $_POST['email'] ) ? sanitize_email( $_POST['email'] ) : '';
				if ( ! $email || empty ( $email ) ) {
					$url = esc_url( add_query_arg( 'updated', 'wrongmail', $url ) );
				} elseif ( ! is_email( $email ) ) {
					$url = esc_url( add_query_arg( 'updated', 'wrongmail', $url ) );
				} elseif ( ( $email != $current_user->user_email ) && email_exists( $email ) ) {
					$url = esc_url( add_query_arg( 'updated', 'wrongmail', $url ) );
				} else {
					$userdata['user_email'] = $email;
				}

				// check if password complexity is checked
				$enable_passcomplex = get_option( 'cl_passcomplex' ) == 'on' ? true : false;

				// password checker
				if ( isset( $_POST['pass1'] ) && ! empty( $_POST['pass1'] ) ) {
					if ( ! isset( $_POST['pass2'] ) || ( isset( $_POST['pass2'] ) && $_POST['pass2'] != $_POST['pass1'] ) ) {
						$url = esc_url( add_query_arg( 'updated', 'wrongpass', $url ) );
					}
					else {
						if( $enable_passcomplex && !clean_login_is_password_complex($_POST['pass1']) )
							$url = esc_url( add_query_arg( 'updated', 'passcomplex', $url ) );
						else
							$userdata['user_pass'] = $_POST['pass1'];
					}
					
				}

				$user_id = wp_update_user( $userdata );
				if ( is_wp_error( $user_id ) ) {
					$url = esc_url( add_query_arg( 'updated', 'failed', $url ) );
				}

				wp_safe_redirect( $url );

			// REGISTER a new user
			} else if ( isset( $_REQUEST['action'] ) && $_REQUEST['action'] == 'register' ) {

				// check if captcha is checked
				$enable_captcha = get_option( 'cl_antispam' ) == 'on' ? true : false;
				// check if standby role is checked
				$create_standby_role = get_option( 'cl_standby' ) == 'on' ? true : false;
				// check if password complexity is checked
				$enable_passcomplex = get_option( 'cl_passcomplex' ) == 'on' ? true : false;
				// check if custom role is selected and get the roles choosen
				$create_customrole = get_option( 'cl_chooserole' ) == 'on' ? true : false;
				$newuserroles = get_option ( 'cl_newuserroles' );
				// check if the user should receive an email
				$emailnotification = get_option ( 'cl_emailnotification' );
    			$emailnotificationcontent = get_option ( 'cl_emailnotificationcontent' );
    			// check if termsconditions is checked
    			$termsconditions = get_option( 'cl_termsconditions' ) == 'on' ? true : false;
    			// check if the email as username is checked
    			$emailusername = get_option('cl_email_username') != 'on' ? true : false;
    			// check if ask once for password is checked
    			$singlepassword = get_option('cl_single_password') != 'on' ? true : false;
    			// check if automatic login in on registration is checked
    			$automaticlogin = get_option('cl_automatic_login', false) != '' ? true : false;
    			// check if nameandsurname is checked
    			$nameandsurname = get_option('cl_nameandsurname', false) != '' ? true : false;
    			// check if emailvalidation is checked, cannot be used with $automaticlogin
    			$emailvalidation = get_option('cl_emailvalidation', false) != '' ? true : false;

    			$successful_registration = false;

    			$url = esc_url( add_query_arg( 'created', 'success', $url ) );

    			//if nameandsurname is checked then get them
    			if ($nameandsurname) {
    				$first_name = isset( $_POST['first_name'] ) ? sanitize_text_field( $_POST['first_name'] ) : '';
    				$last_name = isset( $_POST['last_name'] ) ? sanitize_text_field( $_POST['last_name'] ) : '';
    			}
    			//if email as username is checked then use email as username
    			if ($emailusername)
    				$username = isset( $_POST['username'] ) ? sanitize_user( $_POST['username'] ) : '';
				else 
					$username = isset( $_POST['email'] ) ? sanitize_email( $_POST['email'] ) : '';
				$email = isset( $_POST['email'] ) ? sanitize_email( $_POST['email'] ) : '';
				$pass1 = isset( $_POST['pass1'] ) ? $_POST['pass1'] : '';
				//if single password is checked then use pass1 as pass2
				if ($singlepassword)
					$pass2 = isset( $_POST['pass2'] ) ? $_POST['pass2'] : '';
				else
					$pass2 = isset( $_POST['pass1'] ) ? $_POST['pass1'] : '';
				$website = isset( $_POST['website'] ) ? sanitize_text_field( $_POST['website'] ) : '';
				$captcha = isset( $_POST['captcha'] ) ? sanitize_text_field( $_POST['captcha'] ) : '';
				if( !session_id() ) session_start();
				$captcha_session = isset( $_SESSION['cleanlogin-captcha'] ) ? $_SESSION['cleanlogin-captcha'] : '';
				if( session_id() ) session_destroy();
				$role = isset( $_POST['role'] ) ? sanitize_text_field( $_POST['role'] ) : '';
				$terms = isset( $_POST['termsconditions'] ) && $_POST['termsconditions'] == 'on' ? true : false;
				
				// terms and conditions
				if( $termsconditions && !$terms )
					$url = esc_url( add_query_arg( 'created', 'terms', $url ) );
				// password complexity checker
				else if( $enable_passcomplex && !clean_login_is_password_complex($pass1) )
					$url = esc_url( add_query_arg( 'created', 'passcomplex', $url ) );
				// check if the selected role is contained in the roles selected in CL
				else if ( $create_customrole && !in_array($role, $newuserroles))
					$url = esc_url( add_query_arg( 'created', 'failed', $url ) );
				// captcha enabled
				else if( $enable_captcha && $captcha != $captcha_session )
					$url = esc_url( add_query_arg( 'created', 'wrongcaptcha', $url ) );
				// honeypot detection
				else if( $website != '.' )
					$url = esc_url( add_query_arg( 'created', 'created', $url ) );
				// if nameandsurname then check them
				else if( $nameandsurname && $first_name == '' )
					$url = esc_url( add_query_arg( 'created', 'wrongname', $url ) );
				else if( $nameandsurname && $last_name == '' )
					$url = esc_url( add_query_arg( 'created', 'wrongsurname', $url ) );
				// check defaults
				else if( $username == '' || username_exists( $username ) )
					$url = esc_url( add_query_arg( 'created', 'wronguser', $url ) );
				else if( $email == '' || email_exists( $email ) || !is_email( $email ) )
					$url = esc_url( add_query_arg( 'created', 'wrongmail', $url ) );
				else if ( $pass1 == '' || $pass1 != $pass2)
					$url = esc_url( add_query_arg( 'created', 'wrongpass', $url ) );
				else {
					$user_id = wp_create_user( $username, $pass1, $email );
					if ( is_wp_error( $user_id ) )
						$url = esc_url( add_query_arg( 'created', 'failed', $url ) );
					else {
						$successful_registration = true;
						$user = new WP_User( $user_id );

						// email validation
						if( $emailvalidation ) {
							$user->set_role( '' );
							// Send auth email
							$url_msg = get_permalink();
							$url_msg = esc_url( add_query_arg( 'activate', $user->ID, $url_msg ) );
							$url_msg = wp_nonce_url( $url_msg, $user->ID );

							$blog_title = get_bloginfo();
							$message = sprintf( __( "Use the following link to activate your account: <a href='%s'>activate your account</a>.<br/><br/>%s<br/>", 'clean-login' ), $url_msg, $blog_title );

							$subject = "[$blog_title] " . __( 'Activate your account', 'clean-login' );
							add_filter( 'wp_mail_content_type', 'clean_login_set_html_content_type' );
							if( !wp_mail( $email, $subject , $message ) )
								$url = esc_url( add_query_arg( 'created', 'failed', $url ) );
							remove_filter( 'wp_mail_content_type', 'clean_login_set_html_content_type' );

							$url = esc_url( add_query_arg( 'created', 'success-link', $url ) );
						}
						else if( $create_customrole ){
							$user->set_role( $role );
							// notify the user registration
							do_action( 'user_register', $user_id );
						}
						else if ( $create_standby_role )
							$user->set_role( 'standby' );
						
						if( $nameandsurname ) {
							$userdata = array( 'ID' => $user_id );
							$userdata['first_name'] = $first_name;
							$userdata['last_name'] = $last_name;
							wp_update_user( $userdata );
						}

						$adminemail = get_bloginfo( 'admin_email' );
						$blog_title = get_bloginfo();

						if ( $create_standby_role && !$emailvalidation )
							$message = sprintf( __( "New user registered: %s <br/><br/>Please change the role from 'Stand By' to 'Subscriber' or higher to allow full site access", 'clean-login' ), $username );
						else
							$message = sprintf( __( "New user registered: %s <br/>", 'clean-login' ), $username );
						
						$subject = "[$blog_title] " . __( 'New user', 'clean-login' );
						add_filter( 'wp_mail_content_type', 'clean_login_set_html_content_type' );
						if( !wp_mail( $adminemail, $subject, $message ) )
							$url = esc_url( add_query_arg( 'sent', 'failed', $url ) );
						remove_filter( 'wp_mail_content_type', 'clean_login_set_html_content_type' );

						if( $emailnotification ) {
							$emailnotificationcontent = str_replace("{username}", $username, $emailnotificationcontent);
							$emailnotificationcontent = str_replace("{password}", $pass1, $emailnotificationcontent);
							$emailnotificationcontent = str_replace("{email}", $email, $emailnotificationcontent);
							
							add_filter( 'wp_mail_content_type', 'clean_login_set_html_content_type' );
							if( !wp_mail( $email, $subject , $emailnotificationcontent ) )
								$url = esc_url( add_query_arg( 'sent', 'failed', $url ) );
							remove_filter( 'wp_mail_content_type', 'clean_login_set_html_content_type' );
						}
					}
				}

				// if automatic login is enabled then log the user in and redirect them, checking if it was successful or not,
				//  is not compatible with email validation feature. This had no meaning!
				if($automaticlogin && $successful_registration && !$emailvalidation) {
					$url = esc_url(clean_login_get_translated_option_page('cl_url_redirect'));
					wp_signon(array('user_login' => $username, 'user_password' => $pass1), false);
				}					
					
				wp_safe_redirect( $url );

			// When a user click the activation link goes here to activate his/her account
			} else if ( isset( $_REQUEST['activate'] ) ) {
				
				$user_id = $_REQUEST['activate'];

				$retrieved_nonce = $_REQUEST['_wpnonce'];
				if ( !wp_verify_nonce($retrieved_nonce, $user_id ) )
					die( 'Failed security check, expired Activation Link due to duplication or date.' );

				$url = clean_login_get_translated_option_page( 'cl_login_url', '');
				
				$user = get_user_by( 'id', $user_id );
				
				if ( !$user ) {
					$url = esc_url( add_query_arg( 'authentication', 'failed-activation', $url ) );
				} else {
					$user->set_role( get_option('default_role') );
					$url = esc_url( add_query_arg( 'authentication', 'success-activation', $url ) );
				}
				
				wp_safe_redirect( $url );

			// RESTORE a password by sending an email with the activation link
			} else if ( isset( $_REQUEST['action'] ) && $_REQUEST['action'] == 'restore' ) {
				$url = esc_url( add_query_arg( 'sent', 'success', $url ) );

				$username = isset( $_POST['username'] ) ? sanitize_user( $_POST['username'] ) : '';
				$website = isset( $_POST['website'] ) ? sanitize_text_field( $_POST['website'] ) : '';

				// Since 1.1 (get username from email if so)
				if ( is_email( $username ) ) {
					$userFromMail = get_user_by( 'email', $username );
					if ( $userFromMail == false )
						$username = '';
					else
						$username = $userFromMail->user_login;
				}

				// honeypot detection
				if( $website != '.' )
					$url = esc_url( add_query_arg( 'sent', 'sent', $url ) );
				else if( $username == '' || !username_exists( $username ) )
					$url = esc_url( add_query_arg( 'sent', 'wronguser', $url ) );
				else {
					$user = get_user_by( 'login', $username );

					$url_msg = get_permalink();
					$url_msg = esc_url( add_query_arg( 'restore', $user->ID, $url_msg ) );
					$url_msg = wp_nonce_url( $url_msg, $user->ID );

					$email = $user->user_email;
					$blog_title = get_bloginfo();
					$message = sprintf( __( "Use the following link to restore your password: <a href='%s'>restore your password</a> <br/><br/>%s<br/>", 'clean-login' ), $url_msg, $blog_title );

					$subject = "[$blog_title] " . __( 'Restore your password', 'clean-login' );
					add_filter( 'wp_mail_content_type', 'clean_login_set_html_content_type' );
					if( !wp_mail( $email, $subject , $message ) )
						$url = esc_url( add_query_arg( 'sent', 'failed', $url ) );
					remove_filter( 'wp_mail_content_type', 'clean_login_set_html_content_type' );

				}

				wp_safe_redirect( $url );

			// When a user click the activation link goes here to RESTORE his/her password
			} else if ( isset( $_REQUEST['restore'] ) ) {
				

				$user_id = $_REQUEST['restore'];

				$retrieved_nonce = $_REQUEST['_wpnonce'];
				if ( !wp_verify_nonce($retrieved_nonce, $user_id ) )
					die( 'Failed security check, expired Activation Link due to duplication or date.' );

				$edit_url = clean_login_get_translated_option_page( 'cl_edit_url', '');
				
				// If edit profile page exists the user will be redirected there
				if( $edit_url != '') {
					wp_clear_auth_cookie();
				    wp_set_current_user ( $user_id );
				    wp_set_auth_cookie  ( $user_id );
				    $url = $edit_url;

				// If not, a new password will be generated and notified
				} else {
					$url = clean_login_get_translated_option_page( 'cl_restore_url', '');
					// check if password complexity is checked
					$enable_passcomplex = get_option( 'cl_passcomplex' ) == 'on' ? true : false;
					
					if($enable_passcomplex)
						$new_password = wp_generate_password(12, true);
					else
						$new_password = wp_generate_password(8, false);

					$user_id = wp_update_user( array( 'ID' => $user_id, 'user_pass' => $new_password ) );

					if ( is_wp_error( $user_id ) ) {
						$url = esc_url( add_query_arg( 'sent', 'wronguser', $url ) );
					} else {
						$url = esc_url( add_query_arg( 'pass', $new_password, $url ) );
					}
				}

				wp_safe_redirect( $url );
			}
		} 
	}
}
add_action('template_redirect', 'clean_login_load_before_headers');

/**
 * Cleans an url
 *
 * @since 0.8
 * @param url to be cleaned
 */
function clean_login_url_cleaner( $url ) {
	$query_args = array(
		'authentication',
		'updated',
		'created',
		'sent',
		'restore'
	);
	return esc_url( remove_query_arg( $query_args, $url ) );
}

/**
 * Set email format to html
 *
 * @since 0.8
 */
function clean_login_set_html_content_type()
{
    return 'text/html';
}

/**
 * It will only display the admin bar for users with administrative privileges
 *
 * @since 0.8
 */
function clean_login_remove_admin_bar() {
	$remove_adminbar = get_option( 'cl_adminbar' ) == 'on' ? true : false;

	if ( $remove_adminbar && !current_user_can( 'manage_options' ) )
    	show_admin_bar( false );
}
add_action('after_setup_theme', 'clean_login_remove_admin_bar');

/**
 * It will only enable the dashboard for users with administrative privileges
 * Please note that you can only log in through wp-login.php and this plugin
 *
 * @since 0.9
 */
function clean_login_block_dashboard_access() {
	$block_dashboard = get_option( 'cl_dashboard' ) == 'on' ? true : false;

	if ( $block_dashboard && !current_user_can( 'manage_options' ) && ( !defined( 'DOING_AJAX' ) || !DOING_AJAX ) ) {
		wp_redirect( home_url() );
		exit;
	}
}
add_action( 'admin_init', 'clean_login_block_dashboard_access', 1 );

/**
 * Detect shortcodes and update the plugin options
 *
 * @since 0.8
 * @param post_id of an updated post
 */
function clean_login_get_pages_with_shortcodes( $post_id ) {

	$revision = wp_is_post_revision( $post_id );

	if ( $revision ) $post_id = $revision;
	
	$post = get_post( $post_id );

	if ( has_shortcode( $post->post_content, 'clean-login' ) ) {
		update_option( 'cl_login_url', get_permalink( $post->ID ) );
	}

	if ( has_shortcode( $post->post_content, 'clean-login-edit' ) ) {
		update_option( 'cl_edit_url', get_permalink( $post->ID ) );
	}

	if ( has_shortcode( $post->post_content, 'clean-login-register' ) ) {
		update_option( 'cl_register_url', get_permalink( $post->ID ) );
	}

	if ( has_shortcode( $post->post_content, 'clean-login-restore' ) ) {
		update_option( 'cl_restore_url', get_permalink( $post->ID ) );
	}

}
add_action( 'save_post', 'clean_login_get_pages_with_shortcodes' );

/**
 * Add a role without any capability
 *
 * @since 0.8
 */
function clean_login_add_roles() {

	$create_standby_role = get_option( 'cl_standby' ) == 'on' ? true : false;
	$role = get_role( 'standby' );

	if ( $create_standby_role ) {
		// create if neccesary
	    if ( !$role )
	    	$role = add_role('standby', 'StandBy');
		// and remove capabilities
		$role->remove_cap( 'read' );
	} else {
		// remove if exists
		if ( $role )
			remove_role( 'standby' );
	}
}
add_action( 'admin_init', 'clean_login_add_roles');

/**
* Add plugin text domain
*
* @since 0.8
*/
function clean_login_load_textdomain(){
	load_plugin_textdomain( 'clean-login', false, dirname( plugin_basename( __FILE__ ) ) . '/lang/' );
}
add_action( 'plugins_loaded', 'clean_login_load_textdomain' );

/**
* Add donation link
*
* @since 1.6
*/
function clean_login_plugin_row_meta( $links, $file ){
	if ( strpos( $file, basename( __FILE__ ) ) !== false ) {
		$new_links = array( '<a href="https://www.paypal.me/codection" target="_blank">' . __( 'Donate', 'clean-login' ) . '</a>' );
		$links = array_merge( $links, $new_links );
	}
	return $links;
}
add_filter('plugin_row_meta', 'clean_login_plugin_row_meta', 10, 2);

/*  __               __                  __               __  _                 
   / /_  ____ ______/ /_____  ____  ____/ /  ____  ____  / /_(_)___  ____  _____
  / __ \/ __ `/ ___/ //_/ _ \/ __ \/ __  /  / __ \/ __ \/ __/ / __ \/ __ \/ ___/
 / /_/ / /_/ / /__/ ,< /  __/ / / / /_/ /  / /_/ / /_/ / /_/ / /_/ / / / (__  ) 
/_.___/\__,_/\___/_/|_|\___/_/ /_/\__,_/   \____/ .___/\__/_/\____/_/ /_/____/  
                                               /_/                              
*/

/**
* Backend options
*
* @since 0.9
*/

function clean_login_menu() {
    add_options_page( 'Clean Login Options', 'Clean Login', 'manage_options', 'clean_login_menu', 'clean_login_options' );
}
add_action( 'admin_menu', 'clean_login_menu' );
 
function clean_login_options() {
    // No debería ser necesario, pero no está de más
    if (!current_user_can('manage_options')){
        wp_die( __('Admin area', 'clean-login') );
    }

    // Comprobar el estado del plugin y mostrarlo
    $login_url = get_option( 'cl_login_url');
	$edit_url = get_option( 'cl_edit_url');
	$register_url = get_option( 'cl_register_url');
	$restore_url = get_option( 'cl_restore_url');
    ?>
	    <div class="wrap">
	        <!-- donation box -->
	        <div class="card">

			    <h3 class="title" id="like-donate-more" style="cursor: pointer;"><?php echo __( 'Do you like it?', 'clean-login' ); ?> <span id="like-donate-arrow" class="dashicons dashicons-arrow-down"></span><span id="like-donate-smile" class="dashicons dashicons-smiley hidden"></span></h3>
			    <div class="hidden" id="like-donate">
				    <p>Hi there! We are <a href="https://twitter.com/fjcarazo" target="_blank" title="Javier Carazo">Javier Carazo</a> and <a href="https://twitter.com/ahornero" target="_blank" title="Alberto Hornero">Alberto Hornero</a> from <a href="http://codection.com">Codection</a>, developers of this plugin. We have been spending many hours to develop this plugin, we keep updating it and we always try do the best in the <a href="https://wordpress.org/support/plugin/clean-login">support forum</a>.</p>
				    <p>If you like it, you can <strong>buy us a cup of coffee</strong> or whatever ;-)</p>
				    <form action="https://www.paypal.com/cgi-bin/webscr" method="post" target="_top">
						<input type="hidden" name="cmd" value="_s-xclick">
						<input type="hidden" name="hosted_button_id" value="HGAS22NVY7Q8N">
						<input type="image" src="https://www.paypalobjects.com/en_US/i/btn/btn_donate_LG.gif" border="0" name="submit" alt="PayPal - The safer, easier way to pay online!">
						<img alt="" border="0" src="https://www.paypalobjects.com/es_ES/i/scr/pixel.gif" width="1" height="1">
					</form>
					<p>Sure! You can also <strong><a href="https://wordpress.org/support/view/plugin-reviews/clean-login?filter=5">rate our plugin</a></strong> and provide us your feedback. Thanks!</p>
				</div>
			</div>
			<br>

	        <h2><?php echo __( 'Clean Login status', 'clean-login' ); ?></h2>

	        <p><?php echo __( 'Below you can check the plugin status regarding the shortcodes usage and the pages/posts which contain  it.', 'clean-login' ); ?></p>


	    	<table class="widefat importers">
				<tbody>
					<tr class="alternate">
						<td class="import-system row-title"><a>[clean-login]</a></td>
						<?php if( !$login_url ): ?>
							<td class="desc"><?php echo __( 'Currently not used', 'clean-login' ); ?></td>
						<?php else: ?>
							<td class="desc"><?php printf( __( 'Used <a href="%s">here</a>', 'clean-login' ), $login_url ); ?></td>
						<?php endif; ?>
						<td class="desc"><?php echo __( 'This shortcode contains login form and login information.', 'clean-login' ); ?></td>
					</tr>
					<tr>
						<td class="import-system row-title"><a>[clean-login-edit]</a></td>
						<?php if( !$edit_url ): ?>
							<td class="desc"><?php echo __( 'Currently not used', 'clean-login' ); ?></td>
						<?php else: ?>
							<td class="desc"><?php printf( __( 'Used <a href="%s">here</a>', 'clean-login' ), $edit_url ); ?></td>
						<?php endif; ?>
						<td class="desc"><?php echo __( 'This shortcode contains the profile editor. If you include in a page/post a link will appear on your login preview.', 'clean-login' ); ?></td>
					</tr>
					<tr class="alternate">
						<td class="import-system row-title"><a>[clean-login-register]</a></td>
						<?php if( !$register_url ): ?>
							<td class="desc"><?php echo __( 'Currently not used', 'clean-login' ); ?></td>
						<?php else: ?>
							<td class="desc"><?php printf( __( 'Used <a href="%s">here</a>', 'clean-login' ), $register_url ); ?></td>
						<?php endif; ?>
						<td class="desc"><?php echo __( 'This shortcode contains the register form. If you include in a page/post a link will appear on your login form.', 'clean-login' ); ?></td>
					</tr>
					<tr>
						<td class="import-system row-title"><a>[clean-login-restore]</a></td>
						<?php if( !$restore_url ): ?>
							<td class="desc"><?php echo __( 'Currently not used', 'clean-login' ); ?></td>
						<?php else: ?>
							<td class="desc"><?php printf( __( 'Used <a href="%s">here</a>', 'clean-login' ), $restore_url ); ?></td>
						<?php endif; ?>
						<td class="desc"><?php echo __( 'This shortcode contains the restore (lost password?) form. If you include in a page/post a link will appear on your login form.', 'clean-login' ); ?></td>
					</tr>
				</tbody>
			</table>

			<h2><?php echo __( 'Options', 'clean-login' ); ?></h2>

    <?php

    $hidden_field_name = 'cl_hidden_field';
    $hidden_field_value = 'hidden_field_to_update_others';

    if( isset($_POST[ $hidden_field_name ]) && $_POST[ $hidden_field_name ] == $hidden_field_value ) {
	
		$_POST  = filter_input_array(INPUT_POST, FILTER_SANITIZE_FULL_SPECIAL_CHARS );

        update_option( 'cl_adminbar', isset( $_POST['adminbar'] ) ? $_POST['adminbar'] : '' );
        update_option( 'cl_dashboard', isset( $_POST['dashboard'] ) ? $_POST['dashboard'] : '' );
        update_option( 'cl_antispam', isset( $_POST['antispam'] ) ? $_POST['antispam'] : '' );
        update_option( 'cl_standby', isset( $_POST['standby'] ) ? $_POST['standby'] : '' );
        update_option( 'cl_hideuser', isset( $_POST['hideuser'] ) ? $_POST['hideuser'] : '' );
        update_option( 'cl_passcomplex', isset( $_POST['passcomplex'] ) ? $_POST['passcomplex'] : '' );
        update_option( 'cl_emailnotification', isset( $_POST['emailnotification'] ) ? $_POST['emailnotification'] : '' );
        update_option( 'cl_emailnotificationcontent', isset( $_POST['emailnotificationcontent'] ) ? $_POST['emailnotificationcontent'] : '' );
        update_option( 'cl_chooserole', isset( $_POST['chooserole'] ) ? $_POST['chooserole'] : '' );
        update_option( 'cl_newuserroles', isset( $_POST['newuserroles'] ) ? $_POST['newuserroles'] : '' );
        update_option( 'cl_termsconditions', isset( $_POST['termsconditions'] ) ? $_POST['termsconditions'] : '' );
        update_option( 'cl_termsconditionsMSG', isset( $_POST['termsconditionsMSG'] ) ? $_POST['termsconditionsMSG'] : '' );
        update_option( 'cl_termsconditionsURL', isset( $_POST['termsconditionsURL'] ) ? $_POST['termsconditionsURL'] : '' );
        update_option( 'cl_email_username', isset( $_POST['emailusername'] ) ? $_POST['emailusername'] : '' );
        update_option( 'cl_single_password', isset( $_POST['singlepassword'] ) ? $_POST['singlepassword'] : '' );
        update_option( 'cl_automatic_login', isset( $_POST['automaticlogin'] ) ? $_POST['automaticlogin'] : '' );
        update_option( 'cl_url_redirect', isset($_POST['automaticlogin']) && isset($_POST['urlredirect']) ? esc_url_raw($_POST['urlredirect']) : home_url() );
        update_option( 'cl_nameandsurname', isset( $_POST['nameandsurname'] ) ? $_POST['nameandsurname'] : '' );
        update_option( 'cl_emailvalidation', isset( $_POST['emailvalidation'] ) ? $_POST['emailvalidation'] : '' );
        update_option( 'cl_login_redirect', isset( $_POST['loginredirect'] ) ? $_POST['loginredirect'] : '' );
        update_option( 'cl_login_redirect_url', isset($_POST['loginredirect']) && isset($_POST['loginredirect_url']) ? esc_url_raw($_POST['loginredirect_url']) : home_url() );
        update_option( 'cl_logout_redirect', isset( $_POST['logoutredirect'] ) ? $_POST['logoutredirect'] : '' );
        update_option( 'cl_logout_redirect_url', isset($_POST['logoutredirect']) && isset($_POST['logoutredirect_url']) ? esc_url_raw($_POST['logoutredirect_url']) : home_url() );

		echo '<div class="updated"><p><strong>'. __( 'Settings saved.', 'clean-login' ) .'</strong></p></div>';
    }

    // Recoger las opciones del plugin
    $adminbar = get_option( 'cl_adminbar' , 'on' );
    $dashboard = get_option( 'cl_dashboard' );
    $antispam = get_option( 'cl_antispam' );
    $standby = get_option( 'cl_standby' );
    $hideuser = get_option ( 'cl_hideuser' );
    $passcomplex = get_option ( 'cl_passcomplex' );
    $emailnotification = get_option ( 'cl_emailnotification' );
    $emailnotificationcontent = get_option ( 'cl_emailnotificationcontent' );
    $chooserole = get_option ( 'cl_chooserole' );
    $newuserroles = get_option ( 'cl_newuserroles' );
    $termsconditions = get_option ( 'cl_termsconditions' );
    $termsconditionsMSG = get_option ( 'cl_termsconditionsMSG' );
    $termsconditionsURL = get_option ( 'cl_termsconditionsURL' );
    $emailusername = get_option('cl_email_username');
    $singlepassword = get_option('cl_single_password');
    $automaticlogin = get_option('cl_automatic_login', false) ? true: false;
    $urlredirect = get_option('cl_url_redirect', false) ? esc_url(get_option('cl_url_redirect')): home_url();
    $nameandsurname = get_option('cl_nameandsurname', false) ? true: false;
    $emailvalidation = get_option('cl_emailvalidation', false) ? true: false;
    $loginredirect = get_option('cl_login_redirect', false) ? true: false;
    $loginredirect_url = get_option('cl_login_redirect_url', false) ? esc_url(get_option('cl_login_redirect_url')): home_url();
    $logoutredirect = get_option('cl_logout_redirect', false) ? true: false;
    $logoutredirect_url = get_option('cl_logout_redirect_url', false) ? esc_url(get_option('cl_logout_redirect_url')): home_url();

    ?>
    	<form name="form1" method="post" action="">
    	<table class="form-table">
			<tbody>
				<tr>
					<th scope="row"><?php echo __( 'Admin bar', 'clean-login' ); ?></th>
					<td>
						<label><input name="adminbar" type="checkbox" id="adminbar" <?php if( $adminbar == 'on' ) echo 'checked="checked"'; ?>><?php echo __( 'Hide admin bar for non-admin users?', 'clean-login' ); ?></label>
					</td>
				</tr>
				<tr>
					<th scope="row"><?php echo __( 'Dashboard access', 'clean-login' ); ?></th>
					<td>
						<label><input name="dashboard" type="checkbox" id="dashboard" <?php if( $dashboard == 'on' ) echo 'checked="checked"'; ?>><?php echo __( 'Disable dashboard access for non-admin users?', 'clean-login' ); ?></label>
						<p class="description"><?php echo __( 'Please note that you can only log in through <strong>wp-login.php</strong> and this plugin. <strong>wp-admin</strong> permalink will be inaccessible.', 'clean-login' ); ?></p>
					</td>
				</tr>
				<tr>
					<th scope="row"><?php echo __( 'Antispam protection', 'clean-login' ); ?></th>
					<td>
						<label><input name="antispam" type="checkbox" id="antispam" <?php if( $antispam == 'on' ) echo 'checked="checked"'; ?>><?php echo __( 'Enable captcha?', 'clean-login' ); ?></label>
						<p class="description"><?php echo __( 'Honeypot antispam detection is enabled by default.', 'clean-login' ); ?></p>
						<p class="description"><?php echo __( 'For captcha usage the PHP-GD library needs to be enabled in your server/hosting.', 'clean-login' ); ?></p>
					</td>
				</tr>
				<tr>
					<th scope="row"><?php echo __( 'User role', 'clean-login' ); ?></th>
					<td>
						<label><input name="standby" type="checkbox" id="standby" <?php if( $standby == 'on' ) echo 'checked="checked"'; ?>><?php echo __( 'Enable Standby role?', 'clean-login' ); ?></label>
						<p class="description"><?php echo __( 'Standby role disables all the capabilities for new users, until the administrator changes. It usefull for site with restricted components.', 'clean-login' ); ?></p>
						<br>
						<label><input name="chooserole" type="checkbox" id="chooserole" <?php if( $chooserole == 'on' ) echo 'checked="checked"'; ?>><?php echo __( 'Choose the role(s) in the registration form?', 'clean-login' ); ?></label>
						<p class="description"><?php echo __( 'This feature allows you to choose the role from the frontend, with the selected roles you want to show. You can also define an standard predefined role through a shortcode parameter, e.g. [clean-login-register role="contributor"]. Anyway, you need to choose only the role(s) you want to accept to avoid security/infiltration issues.', 'clean-login' ); ?></p>
						<p>
							<select name="newuserroles[]" id="newuserroles" multiple size="5"><?php wp_dropdown_roles(); ?></select>
							<?php //print_r($newuserroles); ?>
						</p>
					</td>
				</tr>
				<tr>
					<th scope="row"><?php echo __( 'Hide username', 'clean-login' ); ?></th>
					<td>
						<label><input name="hideuser" type="checkbox" id="hideuser" <?php if( $hideuser == 'on' ) echo 'checked="checked"'; ?>><?php echo __( 'Hide username?', 'clean-login' ); ?></label>
						<p class="description"><?php echo __( 'Hide username from the preview form.', 'clean-login' ); ?></p>
					</td>
				</tr>
				<tr>
					<th scope="row"><?php echo __( 'Password complexity', 'clean-login' ); ?></th>
					<td>
						<label><input name="passcomplex" type="checkbox" id="passcomplex" <?php if( $passcomplex == 'on' ) echo 'checked="checked"'; ?>><?php echo __( 'Enable password complexity?', 'clean-login' ); ?></label>
						<p class="description"><?php echo __( 'Passwords must be eight characters including one upper/lowercase letter, one special/symbol character and alphanumeric characters. Passwords should not contain the user\'s username, email, or first/last name.', 'clean-login' ); ?></p>
					</td>
				</tr>
				<tr>
					<th scope="row"><?php echo __( 'Email notification', 'clean-login' ); ?></th>
					<td>
						<label><input name="emailnotification" type="checkbox" id="emailnotification" <?php if( $emailnotification == 'on' ) echo 'checked="checked"'; ?>><?php echo __( 'Enable email notification for new registered users?', 'clean-login' ); ?></label>
						<p><textarea name="emailnotificationcontent" id="emailnotificationcontent" placeholder="<?php echo __( 'Please use HMTL tags for all formatting. And also you can use:', 'clean-login' ) . ' {username} {password} {email}'; ?>" rows="8" cols="50" class="large-text code"><?php echo $emailnotificationcontent; ?></textarea></p>
					</td>
				</tr>
				<tr>
					<th scope="row"><?php echo __( 'Terms and conditions', 'clean-login' ); ?></th>
					<td>
						<label><input name="termsconditions" type="checkbox" id="termsconditions" <?php if( $termsconditions == 'on' ) echo 'checked="checked"'; ?>><?php echo __( 'Accept terms / conditions in the registration form?', 'clean-login' ); ?></label>
						<p><input name="termsconditionsMSG" type="text" id="termsconditionsMSG" value="<?php echo $termsconditionsMSG; ?>" placeholder="<?php echo __( 'Terms and conditions message', 'clean-login' ); ?>" class="regular-text"></p>
						<p><input name="termsconditionsURL" type="url" id="termsconditionsURL" value="<?php echo $termsconditionsURL; ?>" placeholder="<?php echo __( 'Target URL', 'clean-login' ); ?>" class="regular-text"></p>
					</td>
				</tr>
				<tr>
					<th scope="row"><?php echo __( 'Use Email as Username', 'clean-login' ); ?></th>
					<td>
						<label><input name="emailusername" type="checkbox" id="emailusername" <?php if( $emailusername == 'on' ) echo 'checked="checked"'; ?>><?php echo __( 'Allow user to use email as username? If you want to use both, WP Email Login plugin will help you', 'clean-login' ); ?></label>
					</td>
				</tr>
				<tr>
					<th scope="row"><?php echo __( 'Single Password', 'clean-login' ); ?></th>
					<td>
						<label><input name="singlepassword" type="checkbox" id="singlepassword" <?php if( $singlepassword == 'on' ) echo 'checked="checked"'; ?>><?php echo __( 'Only ask for password once on registration form?', 'clean-login' ); ?></label>
					</td>
				</tr>
				<tr>
					<th scope="row"><?php echo __( 'Registration', 'clean-login' ); ?></th>
					<td>
						<label><input name="automaticlogin" type="checkbox" id="automaticlogin" <?php if( $automaticlogin != '' ) echo 'checked="checked"'; ?>><?php echo __( 'Automatically Login after registration?', 'clean-login' ); ?></label>
						<div id="urlredirect">
							<p class="description"><?php echo __( 'URL after registration (if blank then homepage)', 'clean-login' ); ?></p>
							<label><input class="regular-text" type="text" name="urlredirect" value="<?php echo $urlredirect; ?>"></label>
						</div>
						<br>
						<label><input name="nameandsurname" type="checkbox" id="nameandsurname" <?php if( $nameandsurname != '' ) echo 'checked="checked"'; ?>><?php echo __( 'Add name and surname?', 'clean-login' ); ?></label>
						<br>
						<label><input name="emailvalidation" type="checkbox" id="emailvalidation" <?php if( $emailvalidation != '' ) echo 'checked="checked"'; ?>><?php echo __( 'Validate user registration through an email?', 'clean-login' ); ?></label>
						<p class="description"><?php echo __( 'This feature cannot be used with the automatic login after registration', 'clean-login' ); ?></p>
					</td>
				</tr>
				<tr>
					<th scope="row"><?php echo __( 'Redirections', 'clean-login' ); ?></th>
					<td>
						<label><input name="loginredirect" type="checkbox" id="loginredirect" <?php if( $loginredirect != '' ) echo 'checked="checked"'; ?>><?php echo __( 'Redirect after log in?', 'clean-login' ); ?></label>
						<div id="loginredirect_url">
							<p class="description"><?php echo __( 'URL after login (if blank then homepage)', 'clean-login' ); ?></p>
							<label><input class="regular-text" type="text" name="loginredirect_url" value="<?php echo $loginredirect_url; ?>"></label>
						</div>
						<br>
						<label><input name="logoutredirect" type="checkbox" id="logoutredirect" <?php if( $logoutredirect != '' ) echo 'checked="checked"'; ?>><?php echo __( 'Redirect after log out?', 'clean-login' ); ?></label>
						<div id="logoutredirect_url">
							<p class="description"><?php echo __( 'URL after logout (if blank then homepage)', 'clean-login' ); ?></p>
							<label><input class="regular-text" type="text" name="logoutredirect_url" value="<?php echo $logoutredirect_url; ?>"></label>
						</div>
					</td>
				</tr>

			</tbody>
		</table>
		<input type="hidden" name="<?php echo $hidden_field_name; ?>" value="<?php echo $hidden_field_value; ?>">

	    <p class="submit"><input type="submit" name="Submit" class="button-primary" value="<?php echo __( 'Save Changes', 'clean-login' ); ?>" /></p>
        </form>

    </div>
    <script>
    jQuery(document).ready(function( $ ) {

    	var selected_roles = <?php echo json_encode($newuserroles); ?>;
    	$('select#newuserroles').find('option').each(function() {
    		//alert(jQuery.inArray($(this).val(), selected_roles));
		    if( jQuery.inArray($(this).val(), selected_roles) < 0 )
		    	$(this).attr('selected', false);
		    else
		    	$(this).attr('selected', true);
		});

    	if ($('#chooserole').is(':checked')) {
            $('#newuserroles').show();
        } else {
        	$('#newuserroles').hide();
        }

    	$('#chooserole').click(function() {
	       $('#newuserroles').toggle();
	    });

	    if ($('#automaticlogin').is(':checked')) {
            $('#urlredirect').show();
            $('#emailvalidation').prop('checked', false);
        } else {
        	$('#urlredirect').hide();
        }

        $('#automaticlogin').click(function() {
    		$('#urlredirect').toggle();

    		if ($(this).is(':checked'))
            	$('#emailvalidation').prop('checked', false);
    	});

    	$('#emailvalidation').click(function() {
    		if ($(this).is(':checked')) {
				$('#automaticlogin').prop('checked', false);
    			$('#urlredirect').hide();
    		}
    	});

    	if ($('#loginredirect').is(':checked')) {
            $('#loginredirect_url').show();
        } else {
        	$('#loginredirect_url').hide();
        }

        $('#loginredirect').click(function() {
    		$('#loginredirect_url').toggle();
    	});

    	if ($('#logoutredirect').is(':checked')) {
            $('#logoutredirect_url').show();
        } else {
        	$('#logoutredirect_url').hide();
        }

        $('#logoutredirect').click(function() {
    		$('#logoutredirect_url').toggle();
    	});

		if ($('#emailnotification').is(':checked')) {
            $('#emailnotificationcontent').show();
        } else {
        	$('#emailnotificationcontent').hide();
        }

	    $('#emailnotification').click(function() {
	        if ($(this).is(':checked')) {
	            $('#emailnotificationcontent').show();
	        } else {
	        	$('#emailnotificationcontent').hide();
	        }
	    });

	    if ($('#termsconditions').is(':checked')) {
            $('#termsconditionsMSG').show();
            $('#termsconditionsURL').show();
        } else {
        	$('#termsconditionsMSG').hide();
        	$('#termsconditionsURL').hide();
        }

    	$('#termsconditions').click(function() {
	        if ($(this).is(':checked')) {
	            $('#termsconditionsMSG').show();
	            $('#termsconditionsURL').show();
	        } else {
	        	$('#termsconditionsMSG').hide();
	        	$('#termsconditionsURL').hide();
	        }
	    });

	    $('#like-donate-more').click(function() {
	        $('#like-donate').fadeToggle();
	        $('#like-donate-arrow').toggle();
	        $('#like-donate-smile').toggle();
	    });

	});
    </script>
	<?php
}

/*         _     __           __ 
 _      __(_)___/ /___ ____  / /_
| | /| / / / __  / __ `/ _ \/ __/
| |/ |/ / / /_/ / /_/ /  __/ /_  
|__/|__/_/\__,_/\__, /\___/\__/  
               /____/            
*/

/**
* This widget shows both the current user status and the links to access to the different pages/post which contain the shorcodes
*
* @since 1.0
*/
// Creating the widget 
class clean_login_widget extends WP_Widget {


	function __construct() {
		parent::__construct(
			'clean_login_widget', 
			'Clean Login status and links', 
			array( 'description' => __( 'Use this widget to show the user login status and Clean Login links.', 'clean-login' ), ) 
		);
	}

	// Frontend
	public function widget( $args, $instance ) {
		$title = apply_filters( 'widget_title', $instance['title'] );
		
		echo $args['before_widget'];
		
		if ( ! empty( $title ) )
			echo $args['before_title'] . $title . $args['after_title'];

		$login_url = get_option( 'cl_login_url', '');
		$edit_url = get_option( 'cl_edit_url', '');
		$register_url = get_option( 'cl_register_url', '');
		$restore_url = get_option( 'cl_restore_url', '');
		// Output stars
		if ( is_user_logged_in() ) {
			$current_user = wp_get_current_user();
			
			echo get_avatar( $current_user->ID, 96 );
			if ( $current_user->user_firstname == '')
				echo "<h1 class='widget-title'>$current_user->user_login</h1>";
			else
				echo "<h1 class='widget-title'>$current_user->user_firstname $current_user->user_lastname</h1>";
			
			if ( $edit_url != '' || $login_url != '' ) echo "<ul>";
			
			if ( $edit_url != '' )
				echo "<li><a href='$edit_url'>". __( 'Edit my profile', 'clean-login') ."</a></li>";

			if ( $login_url != '' )
				echo "<li><a href='$login_url?action=logout'>". __( 'Logout', 'clean-login') ."</a></li>";
			
			if ( $edit_url != '' || $login_url != '' ) echo "</ul>";

		} else {
			echo "<ul>";
			if ( $login_url != '' ) echo "<li><a href='$login_url'>". __( 'Log in', 'clean-login') ."</a></li>";
			if ( $register_url != '' ) echo "<li><a href='$register_url'>". __( 'Register', 'clean-login') ."</a></li>";
			if ( $restore_url != '' )echo "<li><a href='$restore_url'>". __( 'Lost password?', 'clean-login') ."</a></li>";
			echo "</ul>";
		}
		// Output ends

		echo $args['after_widget'];
	}
		
	// Backend 
	public function form( $instance ) {
		if ( isset( $instance[ 'title' ] ) )
			$title = $instance[ 'title' ];
		else
			$title = __( 'User login status', 'clean-login' );
		// Widget admin form
		?>
		<p>
			<label for="<?php echo $this->get_field_id( 'title' ); ?>"><?php __( 'Title:', 'clean-login' ); ?></label> 
			<input class="widefat" id="<?php echo $this->get_field_id( 'title' ); ?>" name="<?php echo $this->get_field_name( 'title' ); ?>" type="text" value="<?php echo esc_attr( $title ); ?>" />
		</p>
		<?php 
	}
	
	// Updating widget replacing old instances with new
	public function update( $new_instance, $old_instance ) {
		$instance = array();
		$instance['title'] = ( ! empty( $new_instance['title'] ) ) ? strip_tags( $new_instance['title'] ) : '';
	return $instance;
	}
}

function clean_login_load_widget() {
	register_widget( 'clean_login_widget' );
}
add_action( 'widgets_init', 'clean_login_load_widget' );

/**
* This widget shows both the current user status and the links to access to the different pages/post which contain the shorcodes
*
* @since 1.6.1
*/
function clean_login_settings_link( $links ) { 
    $url = "options-general.php?page=clean_login_menu";
    $settings_link = "<a href='$url'>" . __( 'Settings', 'clean-login' ) . "</a>";
    array_unshift($links, $settings_link); 
    return $links; 
}
 
$plugin = plugin_basename(__FILE__); 
add_filter("plugin_action_links_$plugin", 'clean_login_settings_link' );

/**
* This functions redirect after logout
*
* @since 1.6.1
*/
function clean_login_redirect_after_logout(){
	$logoutredirect_url = get_option('cl_logout_redirect_url', false) ? esc_url(apply_filters('cl_logout_redirect_url', clean_login_get_translated_option_page('cl_logout_redirect_url'))): home_url();
	wp_redirect( $logoutredirect_url );
	exit();
}
// check if logout redirect is enabled
if( get_option('cl_logout_redirect', false) != '' )
	add_action('wp_logout','clean_login_redirect_after_logout');

/**
 * template file overriding support
 *
 * @since 1.7.7
 */
function clean_login_get_template_file($template, $param = false){
	if ( $overridden_template = locate_template( 'clean-login/'.$template ) ) {
		require($overridden_template);
	} else {
		require('content/'.$template);
	}
}

/**
 * WPML redirection support
 *
 * @since 1.7.7
 */
function clean_login_get_translated_option_page($page, $param = false) {
	$url = get_option($page, $param);
	//if WPML is installed get the page translation
	if (!function_exists('icl_object_id')) {
		return $url;
	} else {
		//get the page ID
		$pid = url_to_postid( $url ); 
		//set the translated urls
		return get_permalink( icl_object_id( $pid, 'page', false, ICL_LANGUAGE_CODE ) );
	}
}

/**
 * Load admin textdomain in frontend, to translate the user roles through translate_user_role()
 *
 * @since 1.7.9
 */

function clean_login_load_admin_textdomain_in_frontend() {
    if ( ! is_admin() && get_option( 'cl_chooserole' ) == 'on' ) {
        load_textdomain( 'default', WP_LANG_DIR . '/admin-' . get_locale() . '.mo' );
    }
}
add_action( 'init', 'clean_login_load_admin_textdomain_in_frontend' );

?>
