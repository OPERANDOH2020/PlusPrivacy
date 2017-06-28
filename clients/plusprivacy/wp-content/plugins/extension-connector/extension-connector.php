<?php
/**
 * Plugin Name: PlusPrivacy Connector
 * Plugin URI: http://plusprivacy.com
 * Description: Communication between extension and website.
 * Version: 1.0.0
 * Author: Rafael Mastaleru
 * License: MIT
 */

add_action("plusprivacy_head", insertPlusPrivacyHeader);

function insertPlusPrivacyHeader(){
    echo file_get_contents(plugins_url('/html/header/navbar.html', __FILE__));
    wp_enqueue_style('app-navigation', plugins_url('/css/navigation.css', __FILE__));
}
//USER
add_shortcode('confirm-account', 'confirm_user_account');
add_shortcode('account-login', 'account_login');
add_shortcode('account-register', 'register_account');
add_shortcode('user-dashboard', 'user_dashboard');
//OSP
/*add_shortcode('osp-login', 'osp_login');
add_shortcode('osp-register', 'osp_register_account');
add_shortcode('osp-confirm-account', 'osp_confirm_account');
add_shortcode('osp-dashboard-offers', 'osp_dashboard_offers');
add_shortcode('osp-dashboard-deals', 'osp_dashboard_deals');
add_shortcode('osp-certifications', 'osp_certifications');
add_shortcode('osp-dashboard-account', 'osp_dashboard_account');
//PSP
add_shortcode('psp-login', 'psp_login');
add_shortcode('psp-dashboard', 'psp_dashboard');
*/

add_action('wp_enqueue_scripts', 'load_swarm_resources');
add_action('wp_enqueue_scripts', 'confirmUserController');
add_action('wp_enqueue_scripts', 'loginController');
add_action('wp_enqueue_scripts', 'signupController');
add_action('wp_enqueue_scripts', 'userDashboardController');

function load_swarm_resources()
{
    wp_enqueue_script('js-cookie', plugins_url('/js/utils/js.cookie.js', __FILE__));
    wp_enqueue_script('globals', plugins_url('/js/utils/globals.js', __FILE__));
    wp_enqueue_script('bootstrap-min', plugins_url('/js/utils/bootstrap/bootstrap.min.js', __FILE__));
    wp_enqueue_script('socket-io', plugins_url('/js/swarm-services/socket.io-1.0.6.js', __FILE__));
    wp_enqueue_script('swarm-debug', plugins_url('/js/swarm-services/SwarmDebug.js', __FILE__));
    wp_enqueue_script('swarm-client', plugins_url('/js/swarm-services/SwarmClient.js', __FILE__));
    wp_enqueue_script('swarm-hub', plugins_url('/js/swarm-services/SwarmHub.js', __FILE__));
    wp_enqueue_script('angular', plugins_url('/js/angular/angular.min.js', __FILE__));
    wp_enqueue_script('angular-animate', plugins_url('/js/utils/angular-animate/angular-animate.js', __FILE__));
    wp_enqueue_script('angular-strap', plugins_url('/js/utils/angular-strap/angular-strap.min.js', __FILE__));
    wp_enqueue_script('angular-strap-tpl', plugins_url('/js/utils/angular-strap/angular-strap.tpl.js', __FILE__));

    wp_enqueue_script('modal-service', plugins_url('/js/utils/angular-modal/angular-modal-service.js', __FILE__));
    wp_enqueue_script('notification-service', plugins_url('/js/utils/angular-ui-notification/angular-ui-notification.min.js', __FILE__));
    wp_enqueue_script('shared-service', plugins_url('/js/app/modules/sharedService.js', __FILE__));
    wp_enqueue_script('menu-angular-app', plugins_url('/js/app/menuApp.js', __FILE__));
    wp_enqueue_script('angular-service-connection', plugins_url('/js/app/services/connectionService.js', __FILE__));
    wp_enqueue_script('angular-messenger-service', plugins_url('/js/app/services/messengerService.js', __FILE__));
    wp_enqueue_script('angular-swarm-service', plugins_url('/js/app/services/swarm-service.js', __FILE__));
    wp_enqueue_script('user-service', plugins_url('/js/app/services/user-service.js', __FILE__));
    wp_enqueue_script('access-service', plugins_url('/js/app/services/access-service.js', __FILE__));
    wp_enqueue_script('menu-controller', plugins_url('/js/app/controllers/navigationController.js', __FILE__));
    wp_enqueue_script('navigation-directive', plugins_url('/js/app/directives/navigation.js', __FILE__));
    wp_enqueue_script('angular-app', plugins_url('/js/app/app.js', __FILE__));
    wp_enqueue_script('loader', plugins_url('/js/app/directives/loader.js', __FILE__));

    wp_enqueue_style('bootstrap', plugins_url('/css/bootstrap/bootstrap.css', __FILE__));
    wp_enqueue_style('bootstrap-theme', plugins_url('/css/bootstrap/bootstrap-theme.min.css', __FILE__));
    wp_enqueue_style('bootstrap-vertical-tabs', plugins_url('/css/bootstrap/bootstrap.vertical-tabs.min.css', __FILE__));
    wp_enqueue_style('plusprivacy-bootstrap', plugins_url('/css/bootstrap/plusprivacy-theme.css', __FILE__));
    wp_enqueue_style('notification-service-style', plugins_url('/js/utils/angular-ui-notification/angular-ui-notification.min.css', __FILE__));
    wp_enqueue_style('app-style', plugins_url('/css/app.css', __FILE__));
    wp_enqueue_style('angular-strap-libs', plugins_url('/js/utils/angular-strap/libs.min.css', __FILE__));
    wp_enqueue_style('angular-strap-docs', plugins_url('/js/utils/angular-strap/docs.min.css', __FILE__));

}


/************************************************
 *************** Add file contents ***************
 ************************************************/
//USER
function confirm_user_account()
{
    if (isset ($_GET['confirmation_code']) && $_GET['confirmation_code']) {
        echo file_get_contents(plugins_url('/html/confirm_user_tpl.html', __FILE__));
    }
}

function account_login()
{
    echo file_get_contents(plugins_url('/html/user/user_login.html', __FILE__));
}

function register_account()
{
    echo file_get_contents(plugins_url('/html/user/user_signup.html', __FILE__));
}

function user_dashboard(){
    echo file_get_contents(plugins_url('/html/user/user_dashboard.html', __FILE__));
}



/************************************************
 *************** Insert JS app files *************
 ************************************************/
//USER
function confirmUserController()
{
    insertScriptIfShortcode("confirmUserController", 'confirm-account', plugins_url('/js/app/controllers/user/confirmUserController.js', __FILE__));
}

function loginController()
{
    insertScriptIfShortcode("loginController", 'account-login', plugins_url('/js/app/controllers/user/loginController.js', __FILE__));
}

function signupController()
{
    insertScriptIfShortcode("signupController", 'account-register', plugins_url('/js/app/controllers/user/signupController.js', __FILE__));
}

function userDashboardController(){
    insertScriptIfShortcode("userDashboardController", 'user-dashboard', plugins_url('/js/app/controllers/user/dashboardController.js', __FILE__));
}


function insertScriptIfShortcode($script_name, $shortcode, $script)
{
    global $post;
    if (is_a($post, 'WP_Post') && has_shortcode($post->post_content, $shortcode)) {
        wp_enqueue_script($script_name, $script);
    }
}

function insertStyleIfShortcode($style_name, $shortcode, $style)
{
    global $post;
    if (is_a($post, 'WP_Post') && has_shortcode($post->post_content, $shortcode)) {
        wp_enqueue_style($style_name, $style);
    }
}

?>