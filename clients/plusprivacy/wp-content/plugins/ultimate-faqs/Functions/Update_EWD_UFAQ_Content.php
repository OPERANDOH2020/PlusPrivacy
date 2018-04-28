<?php
/* This file is the action handler. The appropriate function is then called based 
*  on the action that's been selected by the user. The functions themselves are all
* stored either in Prepare_Data_For_Insertion.php or Update_Admin_Databases.php */
		
function Update_EWD_UFAQ_Content() {
global $ewd_ufaq_message;
global $ews_ufaq_import;
if (isset($_GET['Action'])) {
		switch ($_GET['Action']) {
			case "EWD_UFAQ_UpdateOptions":
       			$ewd_ufaq_message = EWD_UFAQ_UpdateOptions();
				break;
			case "EWD_UFAQ_ImportFaqs":
       			$ewd_ufaq_message = EWD_UFAQ_Import();
				break;
			case "EWD_UFAQ_ImportFaqsFromSpreadsheet":
       			$ewd_ufaq_message = EWD_UFAQ_Import_From_Spreadsheet();
				break;
			case "EWD_UFAQ_ExportToPDF":
       			$ewd_ufaq_message = EWD_UFAQ_Export_To_PDF();
				break;
			case "EWD_UFAQ_ExportToSpreadsheet":
       			$ewd_ufaq_message = EWD_UFAQ_Export_To_Excel();
				break;
			default:
				$ewd_ufaq_message = __("The form has not worked correctly. Please contact the plugin developer.", 'EWD_UFAQP');
				break;
		}
	}
}

?>