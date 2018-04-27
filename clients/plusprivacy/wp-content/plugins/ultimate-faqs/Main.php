<?php
/*
Plugin Name: Ultimate FAQ
Plugin URI: http://www.EtoileWebDesign.com/wordpress-plugins/
Description: FAQ plugin that lets you easily create, order and publicize FAQs using shortcodes, with many unique styles, WooCommerce FAQs and AJAX FAQ search
Author: Etoile Web Design
Author URI: http://www.EtoileWebDesign.com/wordpress-plugins/
Terms and Conditions: http://www.etoilewebdesign.com/plugin-terms-and-conditions/
Text Domain: ultimate-faqs
Version: 1.7.0
*/

global $ewd_ufaq_message;
global $UFAQ_Full_Version;
global $EWD_UFAQ_Version;

$EWD_UFAQ_Version = '1.7.0';
if (get_option("EWD_UFAQ_Version") == "") {update_option("EWD_UFAQ_Version", $EWD_UFAQ_Version);}

define( 'EWD_UFAQ_CD_PLUGIN_PATH', plugin_dir_path( __FILE__ ) );
define( 'EWD_UFAQ_CD_PLUGIN_URL', plugin_dir_url( __FILE__ ) );

//define('WP_DEBUG', true);

register_activation_hook(__FILE__,'Set_EWD_UFAQ_Options');
register_activation_hook(__FILE__,'Run_UFAQ_Tutorial');
add_filter('upgrader_post_install', 'Set_EWD_UFAQ_Options');

/* Hooks neccessary admin tasks */
if ( is_admin() ){
	add_action('widgets_init', 'Update_EWD_UFAQ_Content');
	add_action('admin_notices', 'EWD_UFAQ_Error_Notices');
	add_action('admin_enqueue_scripts', 'Add_EWD_UFAQ_Scripts', 10, 1);
	add_action('admin_head', 'EWD_UFAQ_Admin_Options');
}

function EWD_UFAQ_Enable_Sub_Menu() {
	global $submenu;

	$Admin_Approval = get_option("EWD_UFAQ_Admin_Approval");
	$Access_Role = get_option("UPCP_Access_Role");

	if ($Access_Role == "") {$Access_Role = "edit_posts";}

	remove_menu_page('edit.php?post_type=ufaq');

	add_menu_page( 'Ultimate FAQs', 'FAQs', $Access_Role, 'EWD-UFAQ-Options', 'EWD_UFAQ_Output_Pages', 'dashicons-format-chat', '49.1' );
	add_submenu_page('EWD-UFAQ-Options', 'FAQ Options', 'FAQ Settings', $Access_Role, 'EWD-UFAQ-Options&DisplayPage=Options', 'EWD_UFAQ_Output_Pages');
	if ($Admin_Approval == "Yes") {
		$submenu['EWD-UFAQ-Options'][6] = $submenu['EWD-UFAQ-Options'][1];
		$submenu['EWD-UFAQ-Options'][1] = array( 'Approved FAQs', $Access_Role, "edit.php?post_type=ufaq&post_status=publish", "Approved FAQs" );
		$submenu['EWD-UFAQ-Options'][2] = array( 'Awaiting Approval', $Access_Role, "edit.php?post_type=ufaq&post_status=draft", "Awaiting Approval" );
		$submenu['EWD-UFAQ-Options'][3] = array( 'Add New', $Access_Role, "post-new.php?post_type=ufaq", "Add New" );
		$submenu['EWD-UFAQ-Options'][4] = array( 'FAQ Categories', $Access_Role, "edit-tags.php?taxonomy=ufaq-category&post_type=ufaq", "FAQ Categories" );
		$submenu['EWD-UFAQ-Options'][5] = array( 'FAQ Tags', $Access_Role, "edit-tags.php?taxonomy=ufaq-tag&post_type=ufaq", "FAQ Tags" );
	}
	else {
		$submenu['EWD-UFAQ-Options'][5] = $submenu['EWD-UFAQ-Options'][1];
		$submenu['EWD-UFAQ-Options'][1] = array( 'FAQs', $Access_Role, "edit.php?post_type=ufaq", "FAQs" );
		$submenu['EWD-UFAQ-Options'][2] = array( 'Add New', $Access_Role, "post-new.php?post_type=ufaq", "Add New" );
		$submenu['EWD-UFAQ-Options'][3] = array( 'FAQ Categories', $Access_Role, "edit-tags.php?taxonomy=ufaq-category&post_type=ufaq", "FAQ Categories" );
		$submenu['EWD-UFAQ-Options'][4] = array( 'FAQ Tags', $Access_Role, "edit-tags.php?taxonomy=ufaq-tag&post_type=ufaq", "FAQ Tags" );
	}
	add_submenu_page('EWD-UFAQ-Options', 'FAQ Export', 'FAQ Export', $Access_Role, 'EWD-UFAQ-Options&DisplayPage=Export', 'EWD_UFAQ_Output_Pages');
	add_submenu_page('EWD-UFAQ-Options', 'FAQ Import', 'FAQ Import', $Access_Role, 'EWD-UFAQ-Options&DisplayPage=ImportPosts', 'EWD_UFAQ_Output_Pages');

	$submenu['EWD-UFAQ-Options'][0][0] = "Dashboard";
	ksort($submenu['EWD-UFAQ-Options']);
}
add_action('admin_menu' , 'EWD_UFAQ_Enable_Sub_Menu', 1);

function EWD_UFAQ_Add_Header_Bar($Called = "No") {
	global $pagenow, $post;

	if ($Called != "Yes" and (!isset($_GET['post_type']) or $_GET['post_type'] != "ufaq") and (!is_object($post) or $post->post_type != 'ufaq')) {return;}

	$Admin_Approval = get_option("EWD_UFAQ_Admin_Approval"); ?>

	<div class="EWD_UFAQ_Menu">
		<h2 class="nav-tab-wrapper">
		<a id="ewd-ufaq-dash-mobile-menu-open" href="#" class="MenuTab nav-tab"><?php _e("MENU", 'ultimate-faqs'); ?><span id="ewd-ufaq-dash-mobile-menu-down-caret">&nbsp;&nbsp;&#9660;</span><span id="ewd-ufaq-dash-mobile-menu-up-caret">&nbsp;&nbsp;&#9650;</span></a>
		<a id="Dashboard_Menu" href='admin.php?page=EWD-UFAQ-Options' class="MenuTab nav-tab <?php if (!isset($_GET['post_type']) and ($_GET['DisplayPage'] == '' or $_GET['DisplayPage'] == 'Dashboard')) {echo 'nav-tab-active';}?>"><?php _e("Dashboard", 'ultimate-faqs'); ?></a>
		<?php if ($Admin_Approval == "Yes") { ?>
			<a id="Approved_FAQs_Menu" href='edit.php?post_type=ufaq&post_status=publish' class="MenuTab nav-tab <?php if (isset($_GET['post_type']) and $_GET['post_type'] == 'ufaq' and $pagenow == 'edit.php' and (!isset($_GET['post_status']) or $_GET['post_status'] == 'publish')) {echo 'nav-tab-active';}?>"><?php _e("Approved FAQs", 'ultimate-faqs'); ?></a>
			<a id="FAQs_Awaiting_Approval_Menu" href='edit.php?post_type=ufaq&post_status=draft' class="MenuTab nav-tab <?php if (isset($_GET['post_type']) and $_GET['post_type'] == 'ufaq' and $pagenow == 'edit.php' and $_GET['post_status'] == 'draft') {echo 'nav-tab-active';}?>"><?php _e("Awaiting Approval", 'ultimate-faqs'); ?></a>
		<?php } else { ?>
			<a id="FAQs_Menu" href='edit.php?post_type=ufaq' class="MenuTab nav-tab <?php if (isset($_GET['post_type']) and $_GET['post_type'] == 'ufaq' and $pagenow == 'edit.php') {echo 'nav-tab-active';}?>"><?php _e("FAQs", 'ultimate-faqs'); ?></a>
		<?php } ?>
		<a id="Add_New_Menu" href='post-new.php?post_type=ufaq' class="MenuTab nav-tab <?php if (isset($_GET['post_type']) and $_GET['post_type'] == 'ufaq' and $pagenow == 'post-new.php') {echo 'nav-tab-active';}?>"><?php _e("Add New", 'ultimate-faqs'); ?></a>
		<a id="FAQ_Categories_Menu" href='edit-tags.php?taxonomy=ufaq-category&post_type=ufaq' class="MenuTab nav-tab <?php if (isset($_GET['post_type']) and $_GET['post_type'] == 'ufaq' and $pagenow == 'edit-tags.php' and $_GET['taxonomy'] == "ufaq-category") {echo 'nav-tab-active';}?>"><?php _e("Categories", 'ultimate-faqs'); ?></a>
		<a id="FAQ_Categories_Menu" href='edit-tags.php?taxonomy=ufaq-tag&post_type=ufaq' class="MenuTab nav-tab <?php if (isset($_GET['post_type']) and $_GET['post_type'] == 'ufaq' and $pagenow == 'edit-tags.php' and $_GET['taxonomy'] == "ufaq-tag") {echo 'nav-tab-active';}?>"><?php _e("Tags", 'ultimate-faqs'); ?></a>
		<a id="Options_Menu" href='admin.php?page=EWD-UFAQ-Options&DisplayPage=Options' class="MenuTab nav-tab <?php if (!isset($_GET['post_type']) and $_GET['DisplayPage'] == 'Options') {echo 'nav-tab-active';}?>"><?php _e("Settings", 'ultimate-faqs'); ?></a>
		<a id="WooCommerce_Import_Menu" href='admin.php?page=EWD-UFAQ-Options&DisplayPage=Export' class="MenuTab nav-tab <?php if (!isset($_GET['post_type']) and $_GET['DisplayPage'] == 'Export') {echo 'nav-tab-active';}?>"><?php _e("Export", 'ultimate-faqs'); ?></a>
		<a id="WooCommerce_Import_Menu" href='admin.php?page=EWD-UFAQ-Options&DisplayPage=ImportPosts' class="MenuTab nav-tab <?php if (!isset($_GET['post_type']) and $_GET['DisplayPage'] == 'ImportPosts') {echo 'nav-tab-active';}?>"><?php _e("Import", 'ultimate-faqs'); ?></a>
		</h2>
	</div>
<?php }
add_action('admin_notices', 'EWD_UFAQ_Add_Header_Bar');

/* Add localization support */
function EWD_UFAQ_localization_setup() {
		load_plugin_textdomain('ultimate-faqs', false, dirname(plugin_basename(__FILE__)) . '/lang/');
}
add_action('after_setup_theme', 'EWD_UFAQ_localization_setup');

// Add settings link on plugin page
function EWD_UFAQ_plugin_settings_link($links) {
  $settings_link = '<a href="admin.php?page=EWD-UFAQ-Options">Settings</a>';
  array_unshift($links, $settings_link);
  return $links;
}
$plugin = plugin_basename(__FILE__);
add_filter("plugin_action_links_$plugin", 'EWD_UFAQ_plugin_settings_link' );

function Add_EWD_UFAQ_Scripts($hook) {
	global $post, $EWD_UFAQ_Version;

	if ((isset($_GET['post_type']) && $_GET['post_type'] == 'ufaq') or
		(isset($_GET['page']) && $_GET['page'] == 'EWD-UFAQ-Options')) {
		$url_one = plugins_url("ultimate-faqs/js/sorttable.js");
		$url_two = plugins_url("ultimate-faqs/js/Admin.js");
		$url_three = plugins_url("ultimate-faqs/js/spectrum.js");

		wp_enqueue_script('jquery-ui-sortable');
		wp_enqueue_script('sortable', $url_one, array('jquery'));
		wp_enqueue_script('UFAQ Admin', $url_two, array('jquery'), $EWD_UFAQ_Version);
		wp_enqueue_script('spectrum', $url_three, array('jquery'));
	}

	if ($hook == 'edit.php' or $hook == 'post-new.php' or $hook == 'post.php') {
        if (isset($post->post_type) and $post->post_type == 'product') {
			wp_enqueue_script('ewd-ufaq-wc-admin', plugins_url("js/ewd-ufaq-wc-admin.js", __FILE__, array('jquery')));
		}
	}
}

function EWD_UFAQ_Admin_Options() {
	global $EWD_UFAQ_Version;

	wp_enqueue_style( 'ewd-ufaq-admin', plugins_url("ultimate-faqs/css/Admin.css"), array(), $EWD_UFAQ_Version);
	wp_enqueue_style( 'ewd-ufaq-spectrum', plugins_url("ultimate-faqs/css/spectrum.css"));
}

add_action( 'wp_enqueue_scripts', 'Add_EWD_UFAQ_FrontEnd_Scripts' );
function Add_EWD_UFAQ_FrontEnd_Scripts() {
	global $EWD_UFAQ_Version;

	wp_register_script('ewd-ufaq-js', plugins_url( '/js/ewd-ufaq-js.js' , __FILE__ ), array( 'jquery' ), $EWD_UFAQ_Version);

	$Retrieving_Results = get_option("EWD_UFAQ_Retrieving_Results");
	if ($Retrieving_Results == "") {$Retrieving_Results = __("Retrieving Results", 'ultimate-faqs') . "...";}

	$ewd_ufaq_php_data = array(
								'retrieving_results' => $Retrieving_Results
	);

	wp_localize_script('ewd-ufaq-js', 'ewd_ufaq_php_data', $ewd_ufaq_php_data );
}


add_action( 'wp_enqueue_scripts', 'EWD_UFAQ_Add_Stylesheet' );
function EWD_UFAQ_Add_Stylesheet() {
    wp_register_style( 'ewd-ufaq-style', plugins_url('css/ewd-ufaq-styles.css', __FILE__) );
    wp_enqueue_style( 'ewd-ufaq-style' );

    wp_register_style( 'ewd-ufaq-rrssb', plugins_url('css/rrssb-min.css', __FILE__) );
    wp_enqueue_style( 'ewd-ufaq-rrssb' );
}

//add_action('activated_plugin','save_ufaq_error');
function save_ufaq_error(){
		update_option('plugin_error',  ob_get_contents());
		file_put_contents("Error.txt", ob_get_contents());
}

function Set_EWD_UFAQ_Options() {
	if (get_option("EWD_UFAQ_Toggle") == "") {update_option("EWD_UFAQ_Toggle", "Yes");}
	if (get_option("EWD_UFAQ_Category_Toggle") == "") {update_option("EWD_UFAQ_Category_Toggle", "No");}
	if (get_option("EWD_UFAQ_Category_Accordion") == "") {update_option("EWD_UFAQ_Category_Accordion", "No");}
	if (get_option("EWD_UFAQ_Expand_Collapse_All") == "") {update_option("EWD_UFAQ_Expand_Collapse_All", "No");}
	if (get_option("EWD_UFAQ_FAQ_Accordion") == "") {update_option("EWD_UFAQ_FAQ_Accordion", "No");}
	if (get_option("EWD_UFAQ_Hide_Categories") == "") {update_option("EWD_UFAQ_Hide_Categories", "No");}
	if (get_option("EWD_UFAQ_Hide_Tags") == "") {update_option("EWD_UFAQ_Hide_Tags", "No");}
	if (get_option("EWD_UFAQ_Scroll_To_Top") == "") {update_option("EWD_UFAQ_Scroll_To_Top", "Yes");}
	if (get_option("EWD_UFAQ_Display_All_Answers") == "") {update_option("EWD_UFAQ_Display_All_Answers", "No");}
	if (get_option("EWD_UFAQ_Display_Author") == "") {update_option("EWD_UFAQ_Display_Author", "Yes");}
	if (get_option("EWD_UFAQ_Display_Date") == "") {update_option("EWD_UFAQ_Display_Date", "Yes");}
	if (get_option("EWD_UFAQ_Display_Back_To_Top") == "") {update_option("EWD_UFAQ_Display_Back_To_Top", "No");}
	if (get_option("EWD_UFAQ_Include_Permalink") == "") {update_option("EWD_UFAQ_Include_Permalink", "Yes");}
	if (get_option("EWD_UFAQ_Permalink_Type") == "") {update_option("EWD_UFAQ_Permalink_Type", "SamePage");}
	if (get_option("EWD_UFAQ_Show_TinyMCE") == "") {update_option("EWD_UFAQ_Show_TinyMCE", "Yes");}
	if (get_option("EWD_UFAQ_Comments_On") == "") {update_option("EWD_UFAQ_Comments_On", "Yes");}
	if (get_option("EWD_UFAQ_Access_Role") == "") {update_option("EWD_UFAQ_Access_Role", "edit_posts");}

	if (get_option("EWD_UFAQ_Display_Style") == "") {update_option("EWD_UFAQ_Display_Style", "Default");}
	if (get_option("EWD_UFAQ_Color_Block_Shape") == "") {update_option("EWD_UFAQ_Color_Block_Shape", "Square");}
	if (get_option("EWD_UFAQ_FAQ_Ratings") == "") {update_option("EWD_UFAQ_FAQ_Ratings", "No");}
	if (get_option("EWD_UFAQ_WooCommerce_FAQs") == "") {update_option("EWD_UFAQ_WooCommerce_FAQs", "No");}
	if (get_option("EWD_UFAQ_Use_Product") == "") {update_option("EWD_UFAQ_Use_Product", "Yes");}
	if (get_option("EWD_UFAQ_Reveal_Effect") == "") {update_option("EWD_UFAQ_Reveal_Effect", "none");}
	if (get_option("EWD_UFAQ_Pretty_Permalinks") == "") {update_option("EWD_UFAQ_Pretty_Permalinks", "No");}
	if (get_option("EWD_UFAQ_Allow_Proposed_Answer") == "") {update_option("EWD_UFAQ_Allow_Proposed_Answer", "No");}
	if (get_option("EWD_UFAQ_Submit_Custom_Fields") == "") {update_option("EWD_UFAQ_Submit_Custom_Fields", "No");}
	if (get_option("EWD_UFAQ_Submit_Question_Captcha") == "") {update_option("EWD_UFAQ_Submit_Question_Captcha", "No");}
	if (get_option("EWD_UFAQ_Admin_Question_Notification") == "") {update_option("EWD_UFAQ_Admin_Question_Notification", "No");}
	if (get_option("EWD_UFAQ_Submit_FAQ_Email") == "") {update_option("EWD_UFAQ_Submit_FAQ_Email", 0);}
	if (get_option("EWD_UFAQ_Auto_Complete_Titles") == "") {update_option("EWD_UFAQ_Auto_Complete_Titles", "Yes");}
	if (get_option("EWD_UFAQ_Slug_Base") == "") {update_option("EWD_UFAQ_Slug_Base", "ufaqs");}

	if (get_option("EWD_UFAQ_FAQ_Elements") == "") {
		$FAQ_Elements = array();
		$FAQ_Elements[0] = "Author_Date";
		$FAQ_Elements[1] = "Body";
		$FAQ_Elements[2] = "Custom_Fields";
		$FAQ_Elements[3] = "Categories";
		$FAQ_Elements[4] = "Tags";
		$FAQ_Elements[5] = "Ratings";
		$FAQ_Elements[6] = "Social_Media";
		$FAQ_Elements[7] = "Permalink";
		$FAQ_Elements[8] = "Comments";
		$FAQ_Elements[9] = "Back_To_Top";

		update_option("EWD_UFAQ_FAQ_Elements", $FAQ_Elements);
	}

	if (get_option("EWD_UFAQ_Group_By_Category") == "") {update_option("EWD_UFAQ_Group_By_Category", "No");}
	if (get_option("EWD_UFAQ_Group_By_Category_Count") == "") {update_option("EWD_UFAQ_Group_By_Category_Count", "No");}
	if (get_option("EWD_UFAQ_Group_By_Order_By") == "") {update_option("EWD_UFAQ_Group_By_Order_By", "name");}
	if (get_option("EWD_UFAQ_Group_By_Order") == "") {update_option("EWD_UFAQ_Group_By_Order", "ASC");}
	if (get_option("EWD_UFAQ_Order_By") == "") {update_option("EWD_UFAQ_Order_By", "date");}
	if (get_option("EWD_UFAQ_Order") == "") {update_option("EWD_UFAQ_Order", "DESC");}

	if (get_option("EWD_UFAQ_Hide_Blank_Fields") == "") {update_option("EWD_UFAQ_Hide_Blank_Fields", "Yes");}

	if (get_option("EWD_UFAQ_Styling_Category_Heading_Type") == "") {update_option("EWD_UFAQ_Styling_Category_Heading_Type", "h4");}
	if (get_option("EWD_UFAQ_Styling_FAQ_Heading_Type") == "") {update_option("EWD_UFAQ_Styling_FAQ_Heading_Type", "h4");}
	if (get_option("EWD_UFAQ_Toggle_Symbol") == "") {update_option("EWD_UFAQ_Toggle_Symbol", "A");}

	if (get_option("EWD_UFAQ_Full_Version") == "") {update_option("EWD_UFAQ_Full_Version", "No");}
	if (get_option("EWD_UFAQ_Install_Flag") == "") {update_option("EWD_UFAQ_Update_Flag", "Yes");}
	if (get_option("EWD_UFAQ_Install_Flag") == "") {update_option("EWD_UFAQ_Install_Flag", "Yes");}

	if (get_option("EWD_UFAQ_Install_Version") == "") {update_option("EWD_UFAQ_Install_Version", 1.6);}
	if (get_option("EWD_UFAQ_Install_Time") == "") {update_option("EWD_UFAQ_Install_Time", time());}
}

$UFAQ_Full_Version = get_option("EWD_UFAQ_Full_Version");
if (isset($_GET['post_type']) and $_GET['post_type'] == 'ufaq' and isset($_POST['EWD_UFAQ_Upgrade_To_Full']) and $UFAQ_Full_Version == "Yes") {add_action("admin_notices", "EWD_UFAQ_Upgrade_Notice");}

$rules = get_option('rewrite_rules');
$PrettyLinks = get_option("EWD_UFAQ_Pretty_Permalinks");
if (!isset($rules['"(.?.+?)/single-faq/([^&]*)/?$"']) and $PrettyLinks == "Yes") {
	add_filter( 'query_vars', 'EWD_UFAQ_add_query_vars_filter' );
	add_filter('init', 'EWD_UFAQ_Rewrite_Rules');
	update_option("EWD_UFAQ_Update_RR_Rules", "No");
}

if (isset($_POST['EWD_UFAQ_Upgrade_To_Full'])) {
	  add_action('admin_init', 'EWD_UFAQ_Upgrade_To_Full');
}

$Show_TinyMCE = get_option("EWD_UFAQ_Show_TinyMCE");
if ($Show_TinyMCE == "Yes") {
	add_filter( 'mce_buttons', 'EWD_UFAQ_Register_TinyMCE_Buttons' );
	add_filter( 'mce_external_plugins', 'EWD_UFAQ_Register_TinyMCE_Javascript' );
	add_action('admin_head', 'EWD_UFAQ_Output_TinyMCE_Vars');
}

function EWD_UFAQ_Register_TinyMCE_Buttons( $buttons ) {
   array_push( $buttons, 'separator', 'UFAQ_Shortcodes' );
   return $buttons;
}

function EWD_UFAQ_Register_TinyMCE_Javascript( $plugin_array ) {
   $plugin_array['UFAQ_Shortcodes'] = plugins_url( '/js/tinymce-plugin.js',__FILE__ );

   return $plugin_array;
}

function EWD_UFAQ_Output_TinyMCE_Vars() {
   global $UFAQ_Full_Version;
   $UFAQ_Categories = get_terms('ufaq-category');

   echo "<script type='text/javascript'>";
   echo "var ufaq_premium = '" . $UFAQ_Full_Version . "';\n";
   echo "var ufaq_categories = " . json_encode($UFAQ_Categories) . ";\n";
   echo "</script>";
}

function Run_UFAQ_Tutorial() {
	update_option("UFAQ_Run_Tutorial", "Yes");
}

if (get_option("UFAQ_Run_Tutorial") == "Yes" and isset($_GET['page']) and $_GET['page'] == 'EWD-UFAQ-Options') {
	add_action( 'admin_enqueue_scripts', 'UFAQ_Set_Pointers', 10, 1);
}

function UFAQ_Set_Pointers($page) {
	  $Pointers = UFAQ_Return_Pointers();

	  //Arguments: pointers php file, version (dots will be replaced), prefix
	  $manager = new UFAQPointersManager( $Pointers, '1.0', 'ufaq_admin_pointers' );
	  $manager->parse();
	  $pointers = $manager->filter( $page );
	  if ( empty( $pointers ) ) { // nothing to do if no pointers pass the filter
	    return;
	  }
	  wp_enqueue_style( 'wp-pointer' );
	  $js_url = plugins_url( 'js/ewd-ufaq-pointers.js', __FILE__ );
	  wp_enqueue_script( 'ufaq_admin_pointers', $js_url, array('wp-pointer'), NULL, TRUE );
	  //data to pass to javascript
	  $data = array(
	    'next_label' => __( 'Next' ),
	    'close_label' => __('Close'),
	    'pointers' => $pointers
	  );
	  wp_localize_script( 'ufaq_admin_pointers', 'MyAdminPointers', $data );
	//update_option("UFAQ_Run_Tutorial", "No");
}

include "Functions/Error_Notices.php";
include "Functions/EWD_UFAQ_Add_Social_Media_Buttons.php";
include "Functions/EWD_UFAQ_Add_Views_Column.php";
include "Functions/EWD_UFAQ_Captcha.php";
include "Functions/EWD_UFAQ_Export.php";
include "Functions/EWD_UFAQ_Help_Pointers.php";
include "Functions/EWD_UFAQ_Import.php";
include "Functions/EWD_UFAQ_Meta_Boxes.php";
include "Functions/EWD_UFAQ_Styling.php";
include "Functions/EWD_UFAQ_Output_Pages.php";
include "Functions/EWD_UFAQ_Pointers_Manager_Interface.php";
include "Functions/EWD_UFAQ_Pointers_Manager_Class.php";
include "Functions/EWD_UFAQ_Rewrite_Rules.php";
include "Functions/EWD_UFAQ_Submit_Question.php";
include "Functions/EWD_UFAQ_Upgrade_Box.php";
include "Functions/EWD_UFAQ_Version_Reversion.php";
include "Functions/EWD_UFAQ_Version_Update.php";
include "Functions/EWD_UFAQ_Widgets.php";
include "Functions/EWD_UFAQ_WooCommerce_Tab.php";
include "Functions/FrontEndAjaxUrl.php";
include "Functions/Full_Upgrade.php";
include "Functions/Process_Ajax.php";
include "Functions/Register_EWD_UFAQ_Posts_Taxonomies.php";
include "Functions/Update_Admin_Databases.php";
include "Functions/Update_EWD_UFAQ_Content.php";

include "Shortcodes/DisplayFAQs.php";
include "Shortcodes/Display_FAQ_Search.php";
include "Shortcodes/Display_Popular_FAQs.php";
include "Shortcodes/Display_Recent_FAQs.php";
include "Shortcodes/Display_Top_Rated_FAQs.php";
include "Shortcodes/SelectFAQ.php";
include "Shortcodes/SubmitFAQ.php";

if ($EWD_UFAQ_Version != get_option('EWD_UFAQ_Version')) {
	Set_EWD_UFAQ_Options();
	EWD_UFAQ_Version_Update();
}

?>
