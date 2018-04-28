<?php
/* Creates the admin page, and fills it in based on whether the user is looking at
*  the overview page or an individual item is being edited */
function EWD_UFAQ_Output_Pages() {
		global $UFAQ_Full_Version;
		
		if (!isset($_GET['DisplayPage'])) {$_GET['DisplayPage'] = "";}

		include( plugin_dir_path( __FILE__ ) . '../html/AdminHeader.php');
		if ($_GET['DisplayPage'] == "" or $_GET['DisplayPage'] == "Dashboard") {include( plugin_dir_path( __FILE__ ) . '../html/DashboardPage.php');}
		if ($_GET['DisplayPage'] == "Options") {include( plugin_dir_path( __FILE__ ) . '../html/OptionsPage.php');}
		if ($_GET['DisplayPage'] == "Export") {include( plugin_dir_path( __FILE__ ) . '../html/ExportPage.php');}
		if ($_GET['DisplayPage'] == "ImportPosts") {include( plugin_dir_path( __FILE__ ) . '../html/ImportPage.php');}
		include( plugin_dir_path( __FILE__ ) . '../html/AdminFooter.php');
}
?>