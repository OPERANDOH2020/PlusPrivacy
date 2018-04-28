<?php
function EWD_UFAQ_Submit_Question($success_message) {
	$Submit_Question_Captcha = get_option("EWD_UFAQ_Submit_Question_Captcha");
	$Admin_Question_Notification = get_option("EWD_UFAQ_Admin_Question_Notification");
	$Submit_FAQ_Email = get_option("EWD_UFAQ_Submit_FAQ_Email");

	$FAQ_Fields_Array = get_option("EWD_UFAQ_FAQ_Fields");
	if (!is_array($FAQ_Fields_Array)) {$FAQ_Fields_Array = array();}

	$Post_Title = sanitize_text_field($_POST['Post_Title']);
	$Post_Body = (isset($_POST['Post_Body']) ? sanitize_text_field($_POST['Post_Body']) : '');
	$Post_Author = sanitize_text_field($_POST['Post_Author']);

	if ($Submit_Question_Captcha == "Yes" and EWD_UFAQ_Validate_Captcha() != "Yes") {
		$user_message = __("Captcha number didn't match image.", 'ultimate-faqs'); 
		return $user_message;
	}

	$post = array(
		'post_content' => $Post_Body,
		'post_title' => $Post_Title,
		'post_type' => 'ufaq',
		'post_status' => 'draft' //Can create an option for admin approval of reviews here
	);
	$post_id = wp_insert_post($post);
	if ($post_id == 0) {$user_message = __("FAQ was not created succesfully.", 'ultimate-faqs'); return $user_message;}

	update_post_meta($post_id, "EWD_UFAQ_Post_Author", $Post_Author);

	foreach ($FAQ_Fields_Array as $FAQ_Field_Item) {
		if ($FAQ_Field_Item['FieldType'] == "checkbox") {$FieldName = "Custom_Field_" . $FAQ_Field_Item['FieldID'];}
		else {$FieldName = "Custom_Field_" . $FAQ_Field_Item['FieldID'];}
		if (isset($_POST[$FieldName]) or isset($_FILES[$FieldName])) {
			// If it's a file, pass back to Prepare_Data_For_Insertion.php to upload the file and get the name
			$Value = '';
			if ($FAQ_Field_Item['FieldType'] == "checkbox") {
				foreach ($_POST[$FieldName] as $SingleValue) {$Value .= trim(sanitize_text_field($SingleValue)) . ",";}
				$Value = substr($Value, 0, strlen($Value)-1);
			}
			else {
				$Value = stripslashes_deep(trim(sanitize_text_field($_POST[$FieldName])));
				$Options = explode(",", $FAQ_Field_Item['FieldValues']);
				if (sizeOf($Options) > 0 and $Options[0] != "") {
					$Trimmed_Options = array_map('trim', $Options);
					$Options = $Trimmed_Options;
					$InArray = in_array($Value, $Options);
				}
			}
			if (!isset($InArray) or $InArray) {
				update_post_meta($post_id, "Custom_Field_" . $FAQ_Field_Item['FieldID'], $Value);
			}
			unset($Value);
			unset($InArray);
			unset($FieldName);
		}
	}

	if ($Submit_FAQ_Email != 0 and isset($_POST['Author_Email'])) {
		update_post_meta($post_id, 'EWD_UFAQ_Post_Author_Email', sanitize_text_field($_POST['Author_Email']));
		if (function_exists('EWD_URP_Send_Email_To_Non_User')) {
			$Params = array(
				'Email_ID' => $Submit_FAQ_Email,
				'Email_Address' => $_POST['Author_Email'],
				'post_id' => $post_id
			);

			EWD_URP_Send_Email_To_Non_User($Params);
		}
	}

	if ($Admin_Question_Notification == "Yes") {
		EWD_UFAQ_Send_Admin_Notification_Email($post_id, $Post_Title, $Post_Body);
	}

	return $success_message;
}

function EWD_UFAQ_Send_Admin_Notification_Email($post_id, $Post_Title, $Post_Body) {
	if (get_option("EWD_UFAQ_Admin_Notification_Email") != "") {$Admin_Email = get_option("EWD_UFAQ_Admin_Notification_Email");}
	else {$Admin_Email = get_option( 'admin_email' );}

	$ReviewLink = site_url() . "/wp-admin/post.php?post=" . $post_id . "&action=edit";

	$Subject_Line = __("New Question Received", 'ultimate-faqs');

	$Message_Body = __("Hello Admin,", 'ultimate-faqs') . "<br/><br/>";
	$Message_Body .= __("You've received a new question titled", 'ultimate-faqs') . " '" . $Post_Title . "'.<br/><br/>";
	if ($Post_Body != "") {
		$Message_Body .= __("The answer reads:<br>", 'ultimate-faqs');
		$Message_Body .= $Post_Body . "<br><br><br>";
	}
	$Message_Body .= __("You can view the question in the admin area by going to the following link:<br>", 'ultimate-faqs');
	$Message_Body .= "<a href='" . $ReviewLink . "' />" . __("See the review", 'ultimate-faqs') . "</a><br/><br/>";
	$Message_Body .= __("Have a great day,", 'ultimate-faqs') . "<br/><br/>";
	$Message_Body .= __("Ultimate FAQs Team");

	$headers = array('Content-Type: text/html; charset=UTF-8');
	$Mail_Success = wp_mail($Admin_Email, $Subject_Line, $Message_Body, $headers);
}

function EWD_UFAQ_Add_UWPM_Element_Sections() {
	if (function_exists('uwpm_register_custom_element_section')) {
		uwpm_register_custom_element_section('ewd_ufaq_uwpm_elements', array('label' => 'FAQ Tags'));
	}
}
add_action('uwpm_register_custom_element_section', 'EWD_UFAQ_Add_UWPM_Element_Sections');

function EWD_UFAQ_Add_UWPM_Elements() {
	if (function_exists('uwpm_register_custom_element')) {

		uwpm_register_custom_element('ewd_ufaq_author', 
			array(
				'label' => 'FAQ Author',
				'callback_function' => 'EWD_UFAQ_UWPM_FAQ_Author',
				'section' => 'ewd_ufaq_uwpm_elements'
			)
		);
		uwpm_register_custom_element('ewd_ufaq_author_email', 
			array(
				'label' => 'FAQ Author Email',
				'callback_function' => 'EWD_UFAQ_UWPM_FAQ_Author_Email',
				'section' => 'ewd_ufaq_uwpm_elements'
			)
		);
	}
}
add_action('uwpm_register_custom_element', 'EWD_UFAQ_Add_UWPM_Elements');

function EWD_UFAQ_UWPM_FAQ_Author($Params, $User) {
	if (!isset($Params['post_id'])) {return;}

	return get_post_meta($Params['post_id'], 'EWD_UFAQ_Post_Author', true);
}

function EWD_UFAQ_UWPM_FAQ_Author_Email($Params, $User) {
	if (!isset($Params['post_id'])) {return;}

	return get_post_meta($Params['post_id'], 'EWD_UFAQ_Post_Author_Email', true);
}
?>
