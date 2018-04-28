<?php

function UFAQ_AJAX_Search($atts) {
    global $wp;

    $Custom_CSS = get_option("EWD_UFAQ_Custom_CSS");
    $Auto_Complete_Titles = get_option("EWD_UFAQ_Auto_Complete_Titles");

    $Enter_Question_Label = get_option("EWD_UFAQ_Enter_Question_Label");
    if ($Enter_Question_Label == "") {$Enter_Question_Label =  __('Enter your question', 'ultimate-faqs');}
    $Search_Label = get_option("EWD_UFAQ_Search_Label");
    if ($Search_Label == "") {$Search_Label = __("Search", 'ultimate-faqs');}

    $current_url = $_SERVER['REQUEST_URI'];
    $ReturnString = "";

    // Get the attributes passed by the shortcode, and store them in new variables for processing
    extract( shortcode_atts( array(
            'include_category' => "",
            'exclude_category' => "",
            'show_on_load' => "No",
            'orderby' => "",
            'order' => "",
            'post_count' => -1),
            $atts
        )
    );

    $ReturnString .= "<style type='text/css'>";
    $ReturnString .= ".ui-autocomplete {background:#FFF; border: #000 solid 1px; max-width:400px; max-height:200px; overflow:auto;}";
    $ReturnString .= $Custom_CSS;
    $ReturnString .= "</style>";

    $ReturnString .= EWD_UFAQ_Add_Modified_Styles();

    if ($Auto_Complete_Titles == "Yes") {
        $ReturnString .= "<script>";
        $ReturnString .= "var autocompleteQuestion = 'Yes';\n";
        $ReturnString .= "var questionTitles = [";
        $ReturnString .= do_shortcode("[ultimate-faqs include_category='" . $include_category . "' exclude_category='" . $exclude_category . "' orderby='" . $orderby . "' order='" . $order . "' post_count='" . $post_count . "' only_titles='Yes']");
        $ReturnString .= "];\n";
        $ReturnString .= "</script>";
    }

    $ReturnString .= "<form action='#' method='post' id='ufaq-ajax-form' class='pure-form pure-form-aligned'>";
    $ReturnString .= "<input type='hidden' name='ufaq-input' value='Search'>";
    $ReturnString .= "<div id='ewd-ufaq-jquery-ajax-search' class='pure-control-group ui-front' style='position:relative;'>";
    $ReturnString .= "<label  id='ufaq-ajax-search-lbl' class='ewd-otp-field-label ewd-otp-bold'>" . $Enter_Question_Label . ":</label>";
    $ReturnString .= "<input type='hidden' name='include_category' value='" . $include_category . "' id='ufaq-include-category' />";
    $ReturnString .= "<input type='hidden' name='exclude_category' value='" . $exclude_category . "' id='ufaq-exclude-category' />";
    $ReturnString .= "<input type='hidden' name='orderby' value='" . $orderby . "' id='ufaq-orderby' />";
    $ReturnString .= "<input type='hidden' name='order' value='" . $order . "' id='ufaq-order' />";
    $ReturnString .= "<input type='hidden' name='post_count' value='" . $post_count . "' id='ufaq-post-count' />";
    $ReturnString .= "<input type='hidden' name='current_url' value='" . $_SERVER['REQUEST_URI'] . "' id='ufaq-current-url' />";
    $ReturnString .= "<input type='text' id='ufaq-ajax-text-input' class='ufaq-text-input' name='Question ' placeholder='" . $Enter_Question_Label . "...' value='" . (isset($_GET['faq_search_term']) ? esc_attr($_GET['faq_search_term']) : '') . "'>";
    $ReturnString .= "</div>";
    if ($Auto_Complete_Titles != "Yes" and $show_on_load == "No") {$ReturnString .= "<label for='Submit'></label><input type='button' id='ufaq-ajax-search-btn' class='ewd-otp-submit pure-button pure-button-primary' name='Search' value='" . $Search_Label . "'>";}
    $ReturnString .= "</form>";

    $ReturnString .= "<div id='ufaq-ajax-results'>";
    if ($show_on_load == "Yes") {$ReturnString .= do_shortcode("[ultimate-faqs include_category='" . $include_category . "' exclude_category='" . $exclude_category . "' orderby='" . $orderby . "' order='" . $order . "' post_count='" . $post_count . "']");}
    $ReturnString .= "</div>";
    
    return $ReturnString;
}
if ($UFAQ_Full_Version == "Yes") {add_shortcode("ultimate-faq-search", "UFAQ_AJAX_Search");}
?>