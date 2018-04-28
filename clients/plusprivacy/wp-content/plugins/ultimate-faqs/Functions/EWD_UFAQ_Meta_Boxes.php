<?php

add_filter("get_sample_permalink_html", "EWD_UFAQ_Add_FAQ_Shortcode", 10, 5);
function EWD_UFAQ_Add_FAQ_Shortcode($HTML, $post_id, $title, $slug, $post) {
	if ($post->post_type == "ufaq") {
		$HTML .= "<div class='ewd-ufaq-shortcode-help'>";
		$HTML .= __("Use the following shortcode to add this FAQ to a page:", 'ultimate-faqs') . "<br>";
		$HTML .= "[select-faq faq_id='" . $post_id . "']";
		$HTML .= "</div>";
	}

	return $HTML;
}

add_action("ufaq-category_edit_form_fields", "EWD_UFAQ_Taxonomy_Page", 10, 2);
function EWD_UFAQ_Taxonomy_Page($tag, $taxonomy) {
	echo __("FAQ shortcode for this category", 'ultimate-faqs') . ":<br />[ultimate-faqs include_category='" . $tag->slug . "']";
}

add_action( 'add_meta_boxes', 'EWD_UFAQ_Add_Meta_Boxes' );
function EWD_UFAQ_Add_Meta_Boxes () {
	add_meta_box("ufaq-meta", __("FAQ Details", 'ultimate-faqs'), "EWD_UFAQ_Meta_Box", "ufaq", "normal", "high");
}

/**
 * Prints the box content.
 *
 * @param WP_Post $post The object for the current post/page.
 */
function EWD_UFAQ_Meta_Box( $post ) {
	$FAQ_Fields_Array = get_option("EWD_UFAQ_FAQ_Fields");
	if (!is_array($FAQ_Fields_Array)) {$FAQ_Fields_Array = array();}
	$FAQ_Ratings = get_option("EWD_UFAQ_FAQ_Ratings");

	// Add a nonce field so we can check for it later.
	wp_nonce_field( 'EWD_UFAQ_Save_Meta_Box_Data', 'EWD_UFAQ_meta_box_nonce' );

	/*
	 * Use get_post_meta() to retrieve an existing value
	 * from the database and use the value for the form.
	 */
	$Author = get_post_meta( $post->ID, 'EWD_UFAQ_Post_Author', true );

	if ($Author == "") {
		$User = wp_get_current_user();
		$Author = $User->display_name;
	}

	echo "<div class='ewd-ufaq-meta-field'>";
	echo "<label for='Post_Author'>";
	echo __( "Author Display Name:", 'EWD_UFAQ' );
	echo " </label>";
	echo "<input type='text' id='ewd-ufaq-post-author' name='Post_Author' value='" . esc_attr( $Author ) . "' size='25' />";
	echo "</div>";

	if ($FAQ_Ratings == "Yes") {
		$Up_Votes = get_post_meta($post->ID, "FAQ_Up_Votes", true);
		$Down_Votes = get_post_meta($post->ID, "FAQ_Down_Votes", true);

		echo "<div class='ewd-ufaq-meta-field'>";
		echo "<label for='Up_Votes'>";
		echo __( "Up Votes:", 'EWD_UFAQ' );
		echo " </label>";
		echo "<input type='text' id='ewd-ufaq-up-votes' name='Up_Votes' value='" . esc_attr( $Up_Votes ) . "' size='25' />";
		echo "</div>";
		echo "<div class='ewd-ufaq-meta-field'>";
		echo "<label for='Down_Votes'>";
		echo __( "Down Votes:", 'EWD_UFAQ' );
		echo " </label>";
		echo "<input type='text' id='ewd-ufaq-down-votes' name='Down_Votes' value='" . esc_attr( $Down_Votes ) . "' size='25' />";
		echo "</div>";
	}

	foreach ($FAQ_Fields_Array as $FAQ_Field_Item) {
		echo "<div class='ewd-ufaq-meta-field'>";
		echo "<label for='" . $FAQ_Field_Item['FieldName'] . "'>";
		echo $FAQ_Field_Item['FieldName'] . ": ";
		echo "</label>";
		$Value = get_post_meta($post->ID, "Custom_Field_" . $FAQ_Field_Item['FieldID'], true);
		if ($FAQ_Field_Item['FieldType'] == "text") {
		    echo "<input name='Custom_Field_" . $FAQ_Field_Item['FieldID'] . "' id='ewd-ufaq-input-" . $FAQ_Field_Item['FieldID'] . "' class='ewd-ufaq-text-input' type='text' value='" . htmlspecialchars($Value, ENT_QUOTES) . "' size='60' />";
		}
		elseif ($FAQ_Field_Item['FieldType'] == "textarea") {
			echo "<textarea name='Custom_Field_" . $FAQ_Field_Item['FieldID'] . "' id='ewd-ufaq-input-" . $FAQ_Field_Item['FieldID'] . "' class='ewd-ufaq-textarea' cols='60' rows='6'>" . $Value . "</textarea>";
		}
		elseif ($FAQ_Field_Item['FieldType'] == "select") {
			$Options = explode(",", $FAQ_Field_Item['FieldValues']);
			echo "<select name='Custom_Field_" . $FAQ_Field_Item['FieldID'] . "' id='ewd-ufaq-input-" . $FAQ_Field_Item['FieldID'] . "' class='ewd-ufaq-select'>";
 			foreach ($Options as $Option) {
				echo "<option value='" . $Option . "' ";
				if (trim($Option) == trim($Value)) {echo "selected='selected'";}
				echo ">" . $Option . "</option>";
			}
			echo "</select>";
		}
		elseif ($FAQ_Field_Item['FieldType'] == "radio") {
			$Counter = 0;
			$Options = explode(",", $FAQ_Field_Item['FieldValues']);
			echo "";
			foreach ($Options as $Option) {
				if ($Counter != 0) {echo "<label class='radio'></label>";}
				echo "<input type='radio' name='Custom_Field_" . $FAQ_Field_Item['FieldID'] . "' value='" . $Option . "' class='ewd-ufaq-radio' ";
				if (trim($Option) == trim($Value)) {echo "checked";}
				echo ">" . $Option;
				$Counter++;
			}
			echo "";
		}
		elseif ($FAQ_Field_Item['FieldType'] == "checkbox") {
			$Counter = 0;
			$Options = explode(",", $FAQ_Field_Item['FieldValues']);
			$Values = explode(",", $Value);
			echo "";
			foreach ($Options as $Option) {
				if ($Counter != 0) {echo "<label class='radio'></label>";}
				echo "<input type='checkbox' name='Custom_Field_" . $FAQ_Field_Item['FieldID'] . "[]' value='" . $Option . "' class='ewd-ufaq-checkbox' ";
				if (in_array($Option, $Values)) {echo "checked";}
				echo ">" . $Option . "</br>";
				$Counter++;
			}
			echo "";
		}
		elseif ($FAQ_Field_Item['FieldType'] == "file") {
			echo "<input name='Custom_Field_" . $FAQ_Field_Item['FieldID'] . "' class='ewd-ufaq-file-input' type='file' value='" . $Value . "' /><br/>Current Filename: " . $Value . "";
		}
		elseif ($FAQ_Field_Item['FieldType'] == "link") {
		    echo "<input name='Custom_Field_" . $FAQ_Field_Item['FieldID'] . "' id='ewd-ufaq-input-" . $FAQ_Field_Item['FieldID'] . "' class='ewd-ufaq-text-input' type='text' value='" . $Value . "' size='60' />";
		}
		elseif ($FAQ_Field_Item['FieldType'] == "date") {
			echo "<input name='Custom_Field_" . $FAQ_Field_Item['FieldID'] . "' class='ewd-ufaq-date-input' type='date' value='" . $Value . "' />";
		}
		elseif ($FAQ_Field_Item['FieldType'] == "datetime") {
			echo "<input name='Custom_Field_" . $FAQ_Field_Item['FieldID'] . "' class='ewd-ufaq-datetime-input' type='datetime-local' value='" . $Value . "' />";
		}
		unset($Value);
		echo "</div>";
	}
}

add_action( 'save_post', 'EWD_UFAQ_Save_Meta_Box_Data' );
function EWD_UFAQ_Save_Meta_Box_Data($post_id) {
	$FAQ_Fields_Array = get_option("EWD_UFAQ_FAQ_Fields");
	if (!is_array($FAQ_Fields_Array)) {$FAQ_Fields_Array = array();}
	$FAQ_Ratings = get_option("EWD_UFAQ_FAQ_Ratings");

	/*
	 * We need to verify this came from our screen and with proper authorization,
	 * because the save_post action can be triggered at other times.
	 */

	// Check if our nonce is set.
	if ( ! isset( $_POST['EWD_UFAQ_meta_box_nonce'] ) ) {
		return;
	}

	// Verify that the nonce is valid.
	if ( ! wp_verify_nonce( $_POST['EWD_UFAQ_meta_box_nonce'], 'EWD_UFAQ_Save_Meta_Box_Data' ) ) {
		return;
	}

	// If this is an autosave, our form has not been submitted, so we don't want to do anything.
	if ( defined( 'DOING_AUTOSAVE' ) && DOING_AUTOSAVE ) {
		return;
	}

	// Check the user's permissions.
	if ( isset( $_POST['post_type'] ) && 'page' == $_POST['post_type'] ) {

		if ( ! current_user_can( 'edit_page', $post_id ) ) {
			return;
		}

	} else {

		if ( ! current_user_can( 'edit_post', $post_id ) ) {
			return;
		}
	}

	foreach ($FAQ_Fields_Array as $FAQ_Field_Item) {
		$FieldName = "Custom_Field_" . $FAQ_Field_Item['FieldID'];
		if (isset($_POST[$FieldName]) or isset($_FILES[$FieldName])) {
			// If it's a file, pass back to Prepare_Data_For_Insertion.php to upload the file and get the name
			$Value = '';
			$NoFile = '';
			if ($FAQ_Field_Item['FieldType'] == "file") {
				$File_Upload_Return = EWD_UFAQ_Handle_File_Upload($FieldName);
				if ($File_Upload_Return['Success'] == "No") {return $File_Upload_Return['Data'];}
				elseif ($File_Upload_Return['Success'] == "N/A") {$NoFile = "Yes";}
				else {$Value = $File_Upload_Return['Data'];}
			}
			elseif ($FAQ_Field_Item['FieldType'] == "checkbox") {
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
				if ($NoFile != "Yes") {
					update_post_meta($post_id, "Custom_Field_" . $FAQ_Field_Item['FieldID'], $Value);
				}
			}
			elseif ($InArray == false) {$CustomFieldError = __(" One or more custom field values were incorrect.", 'ultimate-faqs');}
			unset($Value);
			unset($InArray);
			unset($NoFile);
			unset($CombinedValue);
			unset($FieldName);
		}
	}

	// Sanitize user input.
	$Post_Author = sanitize_text_field( $_POST['Post_Author'] );

	// Update the meta field in the database.
	update_post_meta( $post_id, 'EWD_UFAQ_Post_Author', $Post_Author );

	if ($FAQ_Ratings == "Yes") {
		update_post_meta($post_id, "FAQ_Up_Votes", sanitize_text_field($_POST['Up_Votes']));
		update_post_meta($post_id, "FAQ_Down_Votes", sanitize_text_field($_POST['Down_Votes']));
		update_post_meta($post_id, "FAQ_Total_Score", sanitize_text_field($_POST['Up_Votes']) - sanitize_text_field($_POST['Down_Votes']));
	}
}

function EWD_UFAQ_Add_Edit_Form_Multipart_Encoding() {
    global $post;

    if(!$post) {return;}

    $post_type = get_post_type($post->ID);

    if ($post_type = "ufaq") {echo ' enctype="multipart/form-data"';}
}
add_action('post_edit_form_tag', 'EWD_UFAQ_Add_Edit_Form_Multipart_Encoding');

function EWD_UFAQ_Handle_File_Upload($Field_Name) {

	if (!is_user_logged_in()) {exit();}

	if (isset($_FILES[$Field_Name]) && ($_FILES[$Field_Name]['size'] > 0)) {
		$uploaded_file = wp_handle_upload($_FILES[$Field_Name], array( 'test_form' => false ));
		if (isset($uploaded_file['file'])) {
			$Return['Success'] = "Yes";
			$Return['Data'] = $uploaded_file['url'];
		}
		else {
			$Return['Success'] = "No";
			$Return['Data'] = "There was an error with the file upload";
		}
	}
	else {
		$Return['Success'] = "N/A";
		$Return['Data'] = __('No file was uploaded.', 'UPCP');
	}

	return $Return;
}

?>
