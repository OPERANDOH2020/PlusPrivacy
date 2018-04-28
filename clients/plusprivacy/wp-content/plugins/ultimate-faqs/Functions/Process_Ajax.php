<?php
/* Processes the ajax requests being put out in the admin area and the front-end
*  of the UPCP plugin */

// Returns the FAQs that are found for a specific search
function UFAQ_Search() {
    $response = do_shortcode("[ultimate-faqs search_string='" . strtolower(sanitize_text_field($_POST['Q'])) . "' include_category='" . sanitize_text_field($_POST['include_category']) . "' exclude_category='" . sanitize_text_field($_POST['exclude_category']) . "' orderby='" . sanitize_text_field($_POST['orderby']) . "' order='" . sanitize_text_field($_POST['order']) . "' post_count='" . sanitize_text_field($_POST['post_count']) . "' current_url='" . sanitize_text_field($_POST['current_url']) . "' ajax='Yes']");

    $ReturnArray['request_count'] =  sanitize_text_field($_POST['request_count']);
    $ReturnArray['message'] = $response;
    echo json_encode($ReturnArray);

    die();
}
add_action('wp_ajax_ufaq_search', 'UFAQ_Search');
add_action( 'wp_ajax_nopriv_ufaq_search', 'UFAQ_Search');

// Change the up and down votes for a particular FAQ
function EWD_UFAQ_Update_Rating() {
    $FAQ_ID = is_numeric($_POST['FAQ_ID']) ? sanitize_text_field($_POST['FAQ_ID']) : 0;
    $Vote_Type = $_POST['Vote_Type'];

    if ($Vote_Type == "Up") {
        $Up_Votes = get_post_meta($FAQ_ID, "FAQ_Up_Votes", true);
        update_post_meta($FAQ_ID, "FAQ_Up_Votes", $Up_Votes + 1);
        $Total_Score = get_post_meta($FAQ_ID, "FAQ_Total_Score", true);
        update_post_meta($FAQ_ID, "FAQ_Total_Score", $Total_Score + 1);
    }
    if ($Vote_Type == "Down") {
        $Down_Votes = get_post_meta($FAQ_ID, "FAQ_Down_Votes", true);
        update_post_meta($FAQ_ID, "FAQ_Down_Votes", $Down_Votes + 1);
        $Total_Score = get_post_meta($FAQ_ID, "FAQ_Total_Score", true);
        update_post_meta($FAQ_ID, "FAQ_Total_Score", $Total_Score - 1);
    }

    die();
}
add_action('wp_ajax_ufaq_update_rating', 'EWD_UFAQ_Update_Rating');
add_action( 'wp_ajax_nopriv_ufaq_update_rating', 'EWD_UFAQ_Update_Rating');

// Records the number of time an FAQ post is opened
function UFAQ_Record_View() {
    global $wpdb;
    $wpdb->show_errors();
    $post_id = substr($_POST['post_id'], 4, strrpos(sanitize_text_field($_POST['post_id']), "-") - 4);

    if (!is_numeric($post_id)) {return;}

    $Meta_ID = $wpdb->get_var($wpdb->prepare("SELECT meta_id FROM $wpdb->postmeta WHERE post_id=%d AND meta_key='ufaq_view_count'", $post_id));
    if ($Meta_ID != "" and $Meta_ID != 0) {$wpdb->query($wpdb->prepare("UPDATE $wpdb->postmeta SET meta_value=meta_value+1 WHERE post_id=%d AND meta_key='ufaq_view_count'", $post_id));}
    else {$wpdb->query($wpdb->prepare("INSERT INTO $wpdb->postmeta (post_id,meta_key,meta_value) VALUES (%d,'ufaq_view_count','1')", $post_id));}

    die();
}
add_action('wp_ajax_ufaq_record_view', 'UFAQ_Record_View');
add_action( 'wp_ajax_nopriv_ufaq_record_view', 'UFAQ_Record_View');

function EWD_UFAQ_Save_Order(){   
    if (!is_array($_POST['ewd-ufaq-item'])) {return;}

    foreach ($_POST['ewd-ufaq-item'] as $Key=>$ID) {
        update_post_meta($ID, 'ufaq_order', $Key);
    }
    
    die();
}
add_action('wp_ajax_UFAQ_update_order','EWD_UFAQ_Save_Order');

function EWD_UFAQ_Add_WC_FAQs(){   
    $Post_ID = sanitize_text_field($_POST['Post_ID']);

    if (!is_numeric($Post_ID)) {return;}

    $Current_FAQs = get_post_meta($Post_ID, 'EWD_UFAQ_WC_Selected_FAQs', true );
    if (!is_array($Current_FAQs)) {$Current_FAQs = array();}

    $FAQs = json_decode(stripslashes_deep($_POST['FAQs']));
    if (!is_array($FAQs)) {$FAQs = array();}

    $Added_FAQs = array();
    foreach ($FAQs as $FAQ) {
        if (!in_array($FAQ, $Current_FAQs)) {
            $Current_FAQs[] = $FAQ;

            $FAQ_Post = get_post($FAQ);
            $Added_FAQs[] = array("ID" => $FAQ, "Name" => $FAQ_Post->post_title);
        }
    }

    update_post_meta($Post_ID, 'EWD_UFAQ_WC_Selected_FAQs', $Current_FAQs);

    echo json_encode($Added_FAQs);

    die();
}
add_action('wp_ajax_ewd_ufaq_add_wc_faqs','EWD_UFAQ_Add_WC_FAQs');

function EWD_UFAQ_Delete_WC_FAQs(){   
    $Post_ID = $_POST['Post_ID'];

    $Current_FAQs = get_post_meta($Post_ID, 'EWD_UFAQ_WC_Selected_FAQs', true );
    if (!is_array($Current_FAQs)) {$Current_FAQs = array();}

    $FAQs = json_decode(stripslashes_deep($_POST['FAQs']));
    if (!is_array($FAQs)) {$FAQs = array();}

    $Remaining_FAQs = array_diff($Current_FAQs, $FAQs);

    update_post_meta($Post_ID, 'EWD_UFAQ_WC_Selected_FAQs', $Remaining_FAQs);

    die();
}
add_action('wp_ajax_ewd_ufaq_delete_wc_faqs','EWD_UFAQ_Delete_WC_FAQs');

function EWD_UFAQ_WC_FAQ_Category() {   
    $Cat_ID = sanitize_text_field($_POST['Cat_ID']);
    
    $args = array("numberposts" => -1, "post_type" => 'ufaq');
    if ($Cat_ID != "") {
        $args['tax_query'] = array(array(
            'taxonomy' => 'ufaq-category',
            'terms' => $Cat_ID
            ));
    }
    $All_FAQs = get_posts($args);

    $ReturnString .= "<table class='form-table ewd-ufaq-faq-add-table'>";
    $ReturnString .= "<tr>";
    $ReturnString .= "<th>" . __("Add?", 'ultimate-faqs') . "</th>";
    $ReturnString .= "<th>" . __("FAQ", 'ultimate-faqs') . "</th>";
    $ReturnString .= "</tr>";
    foreach ($All_FAQs as $FAQ) {
        $ReturnString .= "<tr class='ewd-ufaq-faq-row' data-faqid='" . $FAQ->ID . "'>";
        $ReturnString .= "<td><input type='checkbox' class='ewd-ufaq-add-faq' name='Add_FAQs[]' value='" . $FAQ->ID . "'/></td>";
        $ReturnString .= "<td>" . $FAQ->post_title . "</td>";
        $ReturnString .= "</tr>";
    }
    $ReturnString .= "</table>";
    
    echo $ReturnString;

    die();
}
add_action('wp_ajax_ewd_ufaq_wc_faq_category','EWD_UFAQ_WC_FAQ_Category');

function EWD_UFAQ_Hide_Review_Ask(){   
    $Ask_Review_Date = sanitize_text_field($_POST['Ask_Review_Date']);

    update_option('EWD_UFAQ_Ask_Review_Date', time()+3600*24*$Ask_Review_Date);

    die();
}
add_action('wp_ajax_ewd_ufaq_hide_review_ask','EWD_UFAQ_Hide_Review_Ask');