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
add_shortcode('osp-login', 'osp_login');
add_shortcode('osp-register', 'osp_register_account');
add_shortcode('osp-confirm-account', 'osp_confirm_account');
add_shortcode('osp-dashboard-offers', 'osp_dashboard_offers');
add_shortcode('osp-dashboard-deals', 'osp_dashboard_deals');
add_shortcode('osp-certifications', 'osp_certifications');
add_shortcode('osp-dashboard-account', 'osp_dashboard_account');
//PSP
add_shortcode('psp-login', 'psp_login');
add_shortcode('psp-dashboard', 'psp_dashboard');


add_action('wp_enqueue_scripts', 'load_swarm_resources');
add_action('wp_enqueue_scripts', 'confirmUserController');
add_action('wp_enqueue_scripts', 'loginController');
add_action('wp_enqueue_scripts', 'signupController');
add_action('wp_enqueue_scripts', 'userDashboardController');
add_action('wp_enqueue_scripts', 'confirmOSPController');
add_action('wp_enqueue_scripts', 'ospLoginController');
add_action('wp_enqueue_scripts', 'ospSignupController');
add_action('wp_enqueue_scripts', 'ospOffersController');
add_action('wp_enqueue_scripts', 'ospDealsController');
add_action('wp_enqueue_scripts', 'ospAccountController');
add_action('wp_enqueue_scripts', 'pspLoginController');
add_action('wp_enqueue_scripts', 'pspDashboardController');

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

//OSP
function osp_register_account()
{
    echo file_get_contents(plugins_url('/html/osp/register_osp.html', __FILE__));
}

function osp_login(){
    echo file_get_contents(plugins_url('/html/osp/login_osp.html', __FILE__));
}

function osp_confirm_account()
{
    if (isset ($_GET['confirmation_code']) && $_GET['confirmation_code']) {
        echo file_get_contents(plugins_url('/html/osp/osp_confirm_account.html', __FILE__));
    }
}

function osp_dashboard_offers()
{
    echo file_get_contents(plugins_url('/html/osp/dashboard/offers.html', __FILE__));
}

function osp_dashboard_deals()
{
    echo file_get_contents(plugins_url('/html/osp/dashboard/deals.html', __FILE__));
}

function osp_certifications(){
    echo file_get_contents(plugins_url('/html/osp/dashboard/certifications.html', __FILE__));
}

function osp_dashboard_account()
{
    echo file_get_contents(plugins_url('/html/osp/dashboard/account.html', __FILE__));
}

//PSP
function psp_login(){
    echo file_get_contents(plugins_url('/html/psp/psp_login.html', __FILE__));
}

function psp_dashboard(){
    echo file_get_contents(plugins_url('/html/psp/psp_dashboard.html', __FILE__));
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

//OSP
function ospLoginController()
{
    insertScriptIfShortcode("ospLoginController", 'osp-login', plugins_url('/js/app/controllers/osp/ospLoginController.js', __FILE__));
}

function ospSignupController()
{
    insertScriptIfShortcode("intel-tel-input", 'osp-register', plugins_url('/js/utils/ng-intel-tel-input/js/intlTelInput.min.js', __FILE__));
    insertScriptIfShortcode("intel-tel-input-utils", 'osp-register', plugins_url('/js/utils/ng-intel-tel-input/js/utils.js', __FILE__));
    insertScriptIfShortcode("intel-tel-input-directive", 'osp-register', plugins_url('/js/utils/ng-intel-tel-input/ng-intl-tel-input.directive.js', __FILE__));
    insertStyleIfShortcode("intel-tel-input-style", 'osp-register', plugins_url('/js/utils/ng-intel-tel-input/css/intlTelInput.css', __FILE__));
    insertScriptIfShortcode("ospSignupController", 'osp-register', plugins_url('/js/app/controllers/osp/ospSignupController.js', __FILE__));
}

function confirmOSPController(){
    insertScriptIfShortcode("confirmUserController", 'osp-confirm-account', plugins_url('/js/app/controllers/osp/confirmOSPController.js', __FILE__));
}

function ospOffersController()
{   insertScriptIfShortcode("angular-material-js", 'osp-dashboard-offers', plugins_url('/js/utils/angular-material/angular-material.min.js', __FILE__));
    insertStyleIfShortcode("angular-material-style", 'osp-dashboard-offers', plugins_url('/js/utils/angular-material/angular-material.css', __FILE__));
    insertScriptIfShortcode("moment.js", 'osp-dashboard-offers', plugins_url('/js/utils/momentjs/moment.js', __FILE__));
    insertScriptIfShortcode("angular-aria.js", 'osp-dashboard-offers', plugins_url('/js/utils/angular-aria/angular-aria.min.js', __FILE__));
    insertScriptIfShortcode("angular-messages.js", 'osp-dashboard-offers', plugins_url('/js/utils/angular-messages/angular-messages.min.js', __FILE__));
    insertScriptIfShortcode("mdPickers.js", 'osp-dashboard-offers', plugins_url('/js/utils/mdPickers/mdPickers.min.js', __FILE__));
    insertStyleIfShortcode("mdPickers.css", 'osp-dashboard-offers', plugins_url('/js/utils/mdPickers/mdPickers.min.css', __FILE__));

    insertScriptIfShortcode("angular-datatables.min.js", 'osp-dashboard-offers', plugins_url('/js/utils/angular-datatables/angular-datatables.min.js', __FILE__));
    insertScriptIfShortcode("angular-datatables.bootstrap.min", 'osp-dashboard-offers', plugins_url('/js/utils/angular-datatables/angular-datatables.bootstrap.min.js', __FILE__));
    insertScriptIfShortcode("jquery.dataTables.min", 'osp-dashboard-offers', plugins_url('/js/utils/angular-datatables/jquery.dataTables.min.js', __FILE__));
    insertStyleIfShortcode("datatables.bootstrap", 'osp-dashboard-offers', plugins_url('/js/utils/angular-datatables/datatables.bootstrap.min.css', __FILE__));

    insertScriptIfShortcode("datePicker-directive", 'osp-dashboard-offers', plugins_url('/js/app/directives/datePicker.js', __FILE__));
    insertScriptIfShortcode("ospOffersController", 'osp-dashboard-offers', plugins_url('/js/app/controllers/osp/ospOffersController.js', __FILE__));
}

function ospDealsController()
{
    insertScriptIfShortcode("chart.js", 'osp-dashboard-deals', plugins_url('/js/utils/angular-chart/chart.js', __FILE__));
    insertScriptIfShortcode("angular-chart.js", 'osp-dashboard-deals', plugins_url('/js/utils/angular-chart/angular-chart.min.js', __FILE__));

    insertScriptIfShortcode("jquery.dataTables.min", 'osp-dashboard-deals', plugins_url('/js/utils/angular-datatables/jquery.dataTables.min.js', __FILE__));
    insertScriptIfShortcode("jquery.dataTables.min", 'osp-dashboard-deals', plugins_url('/js/utils/angular-datatables/jquery.dataTables.min.js', __FILE__));
    insertScriptIfShortcode("angular-datatables.min.js", 'osp-dashboard-deals', plugins_url('/js/utils/angular-datatables/angular-datatables.min.js', __FILE__));
    insertScriptIfShortcode("angular-datatables.bootstrap.min", 'osp-dashboard-deals', plugins_url('/js/utils/angular-datatables/angular-datatables.bootstrap.min.js', __FILE__));
    insertScriptIfShortcode("dataTables.buttons.min.js", 'osp-dashboard-deals', plugins_url('/js/utils/angular-datatables/exports/dataTables.buttons.min.js', __FILE__));
    insertScriptIfShortcode("jszip.min.js", 'osp-dashboard-deals', plugins_url('/js/utils/angular-datatables/exports/jszip.min.js', __FILE__));
    insertScriptIfShortcode("pdfmake.min.js", 'osp-dashboard-deals', plugins_url('/js/utils/angular-datatables/exports/pdfmake.min.js', __FILE__));
    insertScriptIfShortcode("vfs_fonts.js", 'osp-dashboard-deals', plugins_url('/js/utils/angular-datatables/exports/vfs_fonts.js', __FILE__));
    insertScriptIfShortcode("buttons.html5.min.js", 'osp-dashboard-deals', plugins_url('/js/utils/angular-datatables/exports/buttons.html5.min.js', __FILE__));

    insertStyleIfShortcode("datatables.bootstrap", 'osp-dashboard-deals', plugins_url('/js/utils/angular-datatables/datatables.bootstrap.min.css', __FILE__));
    insertScriptIfShortcode("ospDealsController", 'osp-dashboard-deals', plugins_url('/js/app/controllers/osp/ospDealsController.js', __FILE__));
}

function ospAccountController()
{
    insertScriptIfShortcode("ospAccountController", 'osp-dashboard-account', plugins_url('/js/app/controllers/osp/ospAccountController.js', __FILE__));
}
//PSP
function pspLoginController(){
    insertScriptIfShortcode("pspLoginController", 'psp-login', plugins_url('/js/app/controllers/psp/pspLoginController.js', __FILE__));
}

function pspDashboardController(){
    insertScriptIfShortcode("jquery.dataTables.min", 'psp-dashboard', plugins_url('/js/utils/angular-datatables/jquery.dataTables.min.js', __FILE__));
    insertScriptIfShortcode("angular-datatables.min.js", 'psp-dashboard', plugins_url('/js/utils/angular-datatables/angular-datatables.min.js', __FILE__));
    insertScriptIfShortcode("angular-datatables.bootstrap.min", 'psp-dashboard', plugins_url('/js/utils/angular-datatables/angular-datatables.bootstrap.min.js', __FILE__));
    insertScriptIfShortcode("dataTables.buttons.min.js", 'psp-dashboard', plugins_url('/js/utils/angular-datatables/exports/dataTables.buttons.min.js', __FILE__));
    insertScriptIfShortcode("jszip.min.js", 'psp-dashboard', plugins_url('/js/utils/angular-datatables/exports/jszip.min.js', __FILE__));
    insertScriptIfShortcode("pdfmake.min.js", 'psp-dashboard', plugins_url('/js/utils/angular-datatables/exports/pdfmake.min.js', __FILE__));
    insertScriptIfShortcode("vfs_fonts.js", 'psp-dashboard', plugins_url('/js/utils/angular-datatables/exports/vfs_fonts.js', __FILE__));
    insertScriptIfShortcode("buttons.html5.min.js", 'psp-dashboard', plugins_url('/js/utils/angular-datatables/exports/buttons.html5.min.js', __FILE__));

    insertStyleIfShortcode("datatables.bootstrap", 'psp-dashboard', plugins_url('/js/utils/angular-datatables/datatables.bootstrap.min.css', __FILE__));
    insertScriptIfShortcode("pspDashboardController", 'psp-dashboard', plugins_url('/js/app/controllers/psp/pspDashboardController.js', __FILE__));
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