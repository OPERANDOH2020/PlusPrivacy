<?php
/* The file contains all of the functions which make changes to the WordPress tables */

function EWD_UFAQ_Add_Post_Order_Meta($post_id) {
    $Current_Order = get_post_meta($post_id, "ufaq_order", true);

    if ($Current_Order == "") {
        update_post_meta($post_id, "ufaq_order", 1000);
    }
}
add_action('save_post_ufaq', 'EWD_UFAQ_Add_Post_Order_Meta');

function EWD_UFAQ_UpdateOptions() {
    global $UFAQ_Full_Version;

    if ( ! isset( $_POST['EWD_UFAQ_Save_Options_Nonce'] ) ) {return;}

    if ( ! wp_verify_nonce( $_POST['EWD_UFAQ_Save_Options_Nonce'], 'EWD_UFAQ_Save_Options' ) ) {return;}

    if (get_option("EWD_UFAQ_Access_Role") != '' and !current_user_can(get_option("EWD_UFAQ_Access_Role"))) {return;}

    $Custom_CSS = (isset($_POST['custom_css']) ? EWD_UFAQ_Validate_CSS($_POST['custom_css']) : null);
    $Social_Media_Array = (isset($_POST['Socialmedia']) ? $_POST['Socialmedia'] : array());
    array_walk($Social_Media_Array, 'sanitize_text_field');
    if (is_array($Social_Media_Array)) {$Social_Media = implode(",", $Social_Media_Array);}

    $Custom_CSS = stripslashes_deep($Custom_CSS);

    if (isset($_POST['Options_Submit'])) {update_option('EWD_UFAQ_Custom_CSS', $Custom_CSS);}
    if (isset($_POST['faq_toggle'])) {update_option('EWD_UFAQ_Toggle', sanitize_text_field($_POST['faq_toggle']));}
    if (isset($_POST['faq_category_toggle'])) {update_option('EWD_UFAQ_Category_Toggle', sanitize_text_field($_POST['faq_category_toggle']));}
    if (isset($_POST['faq_category_accordion'])) {update_option('EWD_UFAQ_Category_Accordion', sanitize_text_field($_POST['faq_category_accordion']));}
    if (isset($_POST['expand_collapse_all'])) {update_option('EWD_UFAQ_Expand_Collapse_All', sanitize_text_field($_POST['expand_collapse_all']));}
    if (isset($_POST['faq_accordion'])) {update_option('EWD_UFAQ_FAQ_Accordion', sanitize_text_field($_POST['faq_accordion']));}
    if (isset($_POST['faq_auto_complete_titles'])) {update_option('EWD_UFAQ_Auto_Complete_Titles', sanitize_text_field($_POST['faq_auto_complete_titles']));}
    if (isset($_POST['hide_categories'])) {update_option('EWD_UFAQ_Hide_Categories', sanitize_text_field($_POST['hide_categories']));}
    if (isset($_POST['hide_tags'])) {update_option('EWD_UFAQ_Hide_Tags', sanitize_text_field($_POST['hide_tags']));}
    if (isset($_POST['scroll_to_top'])) {update_option('EWD_UFAQ_Scroll_To_Top', sanitize_text_field($_POST['scroll_to_top']));}
    if (isset($_POST['display_all_answers'])) {update_option('EWD_UFAQ_Display_All_Answers', sanitize_text_field($_POST['display_all_answers']));}
    if (isset($_POST['display_author'])) {update_option('EWD_UFAQ_Display_Author',  sanitize_text_field($_POST['display_author']));}
    if (isset($_POST['display_date'])) {update_option('EWD_UFAQ_Display_Date',  sanitize_text_field($_POST['display_date']));}
    if (isset($_POST['display_back_to_top'])) {update_option('EWD_UFAQ_Display_Back_To_Top',  sanitize_text_field($_POST['display_back_to_top']));}
    if (isset($_POST['include_permalink'])) {update_option('EWD_UFAQ_Include_Permalink', sanitize_text_field($_POST['include_permalink']));}
    if (isset($_POST['permalink_type'])) {update_option('EWD_UFAQ_Permalink_Type', sanitize_text_field($_POST['permalink_type']));}
    if (isset($_POST['show_tinymce'])) {update_option('EWD_UFAQ_Show_TinyMCE', sanitize_text_field($_POST['show_tinymce']));}
    if (isset($_POST['comments_on'])) {update_option('EWD_UFAQ_Comments_On', sanitize_text_field($_POST['comments_on']));}
    if (isset($_POST['access_role'])) {update_option('EWD_UFAQ_Access_Role', sanitize_text_field($_POST['access_role']));}

    if (isset($_POST['display_style']) and $UFAQ_Full_Version == "Yes") {update_option('EWD_UFAQ_Display_Style',  sanitize_text_field($_POST['display_style']));}
    if (isset($_POST['color_block_shape']) and $UFAQ_Full_Version == "Yes") {update_option('EWD_UFAQ_Color_Block_Shape',  sanitize_text_field($_POST['color_block_shape']));}
    if (isset($_POST['Options_Submit']) and $UFAQ_Full_Version == "Yes") {update_option('EWD_UFAQ_FAQs_Per_Page',  sanitize_text_field($_POST['faqs_per_page']));}
    if (isset($_POST['faq_ratings']) and $UFAQ_Full_Version == "Yes") {update_option('EWD_UFAQ_FAQ_Ratings',  sanitize_text_field($_POST['faq_ratings']));}
    if (isset($_POST['woocommerce_faqs']) and $UFAQ_Full_Version == "Yes") {update_option('EWD_UFAQ_WooCommerce_FAQs',  sanitize_text_field($_POST['woocommerce_faqs']));}
    if (isset($_POST['use_product']) and $UFAQ_Full_Version == "Yes") {update_option('EWD_UFAQ_Use_Product',  sanitize_text_field($_POST['use_product']));}
    if (isset($_POST['reveal_effect']) and $UFAQ_Full_Version == "Yes") {update_option('EWD_UFAQ_Reveal_Effect', sanitize_text_field($_POST['reveal_effect']));}
    if (isset($_POST['pretty_permalinks']) and $UFAQ_Full_Version == "Yes") {update_option('EWD_UFAQ_Pretty_Permalinks', sanitize_text_field($_POST['pretty_permalinks']));}
    if (isset($_POST['allow_proposed_answer']) and $UFAQ_Full_Version == "Yes") {update_option('EWD_UFAQ_Allow_Proposed_Answer',  sanitize_text_field($_POST['allow_proposed_answer']));}
    if (isset($_POST['submit_custom_fields']) and $UFAQ_Full_Version == "Yes") {update_option('EWD_UFAQ_Submit_Custom_Fields',  sanitize_text_field($_POST['submit_custom_fields']));}
    if (isset($_POST['submit_question_captcha']) and $UFAQ_Full_Version == "Yes") {update_option('EWD_UFAQ_Submit_Question_Captcha',  sanitize_text_field($_POST['submit_question_captcha']));}
    if (isset($_POST['admin_question_notification']) and $UFAQ_Full_Version == "Yes") {update_option('EWD_UFAQ_Admin_Question_Notification', sanitize_text_field($_POST['admin_question_notification']));}
    if (isset($_POST['Options_Submit']) and $UFAQ_Full_Version == "Yes") {update_option('EWD_UFAQ_Admin_Notification_Email', sanitize_text_field($_POST['admin_notification_email']));}
    if (isset($_POST['submit_faq_email']) and $UFAQ_Full_Version == "Yes") {update_option('EWD_UFAQ_Submit_FAQ_Email', sanitize_text_field($_POST['submit_faq_email']));}
    if (isset($_POST['faq_auto_complete_titles']) and $UFAQ_Full_Version == "Yes") {update_option('EWD_UFAQ_Auto_Complete_Titles', sanitize_text_field($_POST['faq_auto_complete_titles']));}
    if (isset($_POST['slug_base']) and $UFAQ_Full_Version == "Yes") {update_option('EWD_UFAQ_Slug_Base', $_POST['slug_base']);}
    if (isset($_POST['Socialmedia']) and $UFAQ_Full_Version == "Yes") {update_option('EWD_UFAQ_Social_Media',  $Social_Media);}

    $FAQ_Elements = array();
    for ($i=0; $i<=9; $i++) {
        $FAQ_Elements[] = $_POST['Element_' . $i];
    }
    if (isset($_POST['Options_Submit'])) {update_option('EWD_UFAQ_FAQ_Elements', $FAQ_Elements);}

    if (isset($_POST['group_by_category'])) {update_option('EWD_UFAQ_Group_By_Category', sanitize_text_field($_POST['group_by_category']));}
    if (isset($_POST['group_by_category_count'])) {update_option('EWD_UFAQ_Group_By_Category_Count', sanitize_text_field($_POST['group_by_category_count']));}
    if (isset($_POST['group_by_order_by'])) {update_option('EWD_UFAQ_Group_By_Order_By', sanitize_text_field($_POST['group_by_order_by']));}
    if (isset($_POST['group_by_order'])) {update_option('EWD_UFAQ_Group_By_Order', sanitize_text_field($_POST['group_by_order']));}
    if (isset($_POST['order_by_setting'])) {update_option('EWD_UFAQ_Order_By', sanitize_text_field($_POST['order_by_setting']));}
    if (isset($_POST['order_setting'])) {update_option('EWD_UFAQ_Order', sanitize_text_field($_POST['order_setting']));}

    $Counter = 0;
    $Custom_Fields = array();
    while ($Counter < 30) {
        if (isset($_POST['Custom_Field_' . $Counter . '_Name'])) {
            $Prefix = 'Custom_Field_' . $Counter;

            $Custom_Field_Item['FieldID'] = sanitize_text_field($_POST[$Prefix . '_ID']);
            $Custom_Field_Item['FieldName'] = sanitize_text_field($_POST[$Prefix . '_Name']);
            $Custom_Field_Item['FieldType'] = sanitize_text_field($_POST[$Prefix . '_Type']);
            $Custom_Field_Item['FieldValues'] = sanitize_text_field($_POST[$Prefix . '_Values']);

            $Custom_Fields[] = $Custom_Field_Item;
            unset($Custom_Field_Item);
        }
        $Counter++;
    }

    if (isset($_POST['Options_Submit'])) {update_option('EWD_UFAQ_FAQ_Fields', $Custom_Fields);}
    if (isset($_POST['hide_blank_fields'])) {update_option('EWD_UFAQ_Hide_Blank_Fields', sanitize_text_field($_POST['hide_blank_fields']));}


    if (isset($_POST['posted_label'])) {update_option('EWD_UFAQ_Posted_Label',  sanitize_text_field($_POST['posted_label']));}
    if (isset($_POST['by_label'])) {update_option('EWD_UFAQ_By_Label',  sanitize_text_field($_POST['by_label']));}
    if (isset($_POST['on_label'])) {update_option('EWD_UFAQ_On_Label',  sanitize_text_field($_POST['on_label']));}
    if (isset($_POST['category_label'])) {update_option('EWD_UFAQ_Category_Label',  sanitize_text_field($_POST['category_label']));}
    if (isset($_POST['tag_label'])) {update_option('EWD_UFAQ_Tag_Label',  sanitize_text_field($_POST['tag_label']));}
    if (isset($_POST['enter_question_label'])) {update_option('EWD_UFAQ_Enter_Question_Label',  sanitize_text_field($_POST['enter_question_label']));}
    if (isset($_POST['search_label'])) {update_option('EWD_UFAQ_Search_Label',  sanitize_text_field($_POST['search_label']));}
    if (isset($_POST['permalink_label'])) {update_option('EWD_UFAQ_Permalink_Label',  sanitize_text_field($_POST['permalink_label']));}
    if (isset($_POST['back_to_top_label'])) {update_option('EWD_UFAQ_Back_To_Top_Label',  sanitize_text_field($_POST['back_to_top_label']));}
    if (isset($_POST['woocommerce_tab_label'])) {update_option('EWD_UFAQ_WooCommerce_Tab_Label',  sanitize_text_field($_POST['woocommerce_tab_label']));}

    if (isset($_POST['thank_you_submit_label'])) {update_option('EWD_UFAQ_Thank_You_Submit_Label',  sanitize_text_field($_POST['thank_you_submit_label']));}
    if (isset($_POST['submit_question_label'])) {update_option('EWD_UFAQ_Submit_Question_Label',  sanitize_text_field($_POST['submit_question_label']));}
    if (isset($_POST['please_fill_form_below_label'])) {update_option('EWD_UFAQ_Please_Fill_Form_Below_Label',  sanitize_text_field($_POST['please_fill_form_below_label']));}
    if (isset($_POST['send_question_label'])) {update_option('EWD_UFAQ_Send_Question_Label',  sanitize_text_field($_POST['send_question_label']));}
    if (isset($_POST['question_title_label'])) {update_option('EWD_UFAQ_Question_Title_Label',  sanitize_text_field($_POST['question_title_label']));}
    if (isset($_POST['what_question_being_answered_label'])) {update_option('EWD_UFAQ_What_Question_Being_Answered_Label',  sanitize_text_field($_POST['what_question_being_answered_label']));}
    if (isset($_POST['proposed_answer_label'])) {update_option('EWD_UFAQ_Proposed_Answer_Label',  sanitize_text_field($_POST['proposed_answer_label']));}
    if (isset($_POST['review_author_label'])) {update_option('EWD_UFAQ_Review_Author_Label',  sanitize_text_field($_POST['review_author_label']));}
    if (isset($_POST['what_name_with_review_label'])) {update_option('EWD_UFAQ_What_Name_With_Review_Label',  sanitize_text_field($_POST['what_name_with_review_label']));}
    if (isset($_POST['retrieving_results'])) {update_option('EWD_UFAQ_Retrieving_Results',  sanitize_text_field($_POST['retrieving_results']));}
    if (isset($_POST['no_results_found_text'])) {update_option('EWD_UFAQ_No_Results_Found_Text',  sanitize_text_field($_POST['no_results_found_text']));}

    if (isset($_POST['ufaq_styling_default_bg_color'])) {update_option('EWD_UFAQ_Styling_Default_Bg_Color',  sanitize_hex_color($_POST['ufaq_styling_default_bg_color']));}
    if (isset($_POST['ufaq_styling_default_font_color'])) {update_option('EWD_UFAQ_Styling_Default_Font_Color',  sanitize_hex_color($_POST['ufaq_styling_default_font_color']));}
    if (isset($_POST['ufaq_styling_default_border_size'])) {update_option('EWD_UFAQ_Styling_Default_Border_Size',  sanitize_text_field($_POST['ufaq_styling_default_border_size']));}
    if (isset($_POST['ufaq_styling_default_border_color'])) {update_option('EWD_UFAQ_Styling_Default_Border_Color',  sanitize_hex_color($_POST['ufaq_styling_default_border_color']));}
    if (isset($_POST['ufaq_styling_default_border_radius'])) {update_option('EWD_UFAQ_Styling_Default_Border_Radius',  sanitize_text_field($_POST['ufaq_styling_default_border_radius']));}
    if (isset($_POST['ufaq_styling_toggle_symbol_size'])) {update_option('EWD_UFAQ_Styling_Toggle_Symbol_Size',  sanitize_text_field($_POST['ufaq_styling_toggle_symbol_size']));}
    if (isset($_POST['ufaq_styling_block_bg_color'])) {update_option('EWD_UFAQ_Styling_Block_Bg_Color',  sanitize_hex_color($_POST['ufaq_styling_block_bg_color']));}
    if (isset($_POST['ufaq_styling_block_font_color'])) {update_option('EWD_UFAQ_Styling_Block_Font_Color',  sanitize_hex_color($_POST['ufaq_styling_block_font_color']));}
    if (isset($_POST['ufaq_styling_list_font'])) {update_option('EWD_UFAQ_Styling_List_Font',  sanitize_text_field($_POST['ufaq_styling_list_font']));}
    if (isset($_POST['ufaq_styling_list_font_size'])) {update_option('EWD_UFAQ_Styling_List_Font_Size',  sanitize_text_field($_POST['ufaq_styling_list_font_size']));}
    if (isset($_POST['ufaq_styling_list_font_color'])) {update_option('EWD_UFAQ_Styling_List_Font_Color',  sanitize_hex_color($_POST['ufaq_styling_list_font_color']));}
    if (isset($_POST['ufaq_styling_list_margin'])) {update_option('EWD_UFAQ_Styling_List_Margin',  sanitize_text_field($_POST['ufaq_styling_list_margin']));}
    if (isset($_POST['ufaq_styling_list_padding'])) {update_option('EWD_UFAQ_Styling_List_Padding',  sanitize_text_field($_POST['ufaq_styling_list_padding']));}

    if (isset($_POST['ufaq_styling_question_font'])) {update_option('EWD_UFAQ_Styling_Question_Font',  sanitize_text_field($_POST['ufaq_styling_question_font']));}
    if (isset($_POST['ufaq_styling_question_font_size'])) {update_option('EWD_UFAQ_Styling_Question_Font_Size',  sanitize_text_field($_POST['ufaq_styling_question_font_size']));}
    if (isset($_POST['ufaq_styling_question_font_color'])) {update_option('EWD_UFAQ_Styling_Question_Font_Color',  sanitize_hex_color($_POST['ufaq_styling_question_font_color']));}
    if (isset($_POST['ufaq_styling_question_margin'])) {update_option('EWD_UFAQ_Styling_Question_Margin',  sanitize_text_field($_POST['ufaq_styling_question_margin']));}
    if (isset($_POST['ufaq_styling_question_padding'])) {update_option('EWD_UFAQ_Styling_Question_Padding',  sanitize_text_field($_POST['ufaq_styling_question_padding']));}
    if (isset($_POST['ufaq_styling_question_icon_top_margin'])) {update_option('EWD_UFAQ_Styling_Question_Icon_Top_Margin',  sanitize_text_field($_POST['ufaq_styling_question_icon_top_margin']));}
    if (isset($_POST['ufaq_styling_answer_font'])) {update_option('EWD_UFAQ_Styling_Answer_Font',  sanitize_text_field($_POST['ufaq_styling_answer_font']));}
    if (isset($_POST['ufaq_styling_answer_font_size'])) {update_option('EWD_UFAQ_Styling_Answer_Font_Size',  sanitize_text_field($_POST['ufaq_styling_answer_font_size']));}
    if (isset($_POST['ufaq_styling_answer_font_color'])) {update_option('EWD_UFAQ_Styling_Answer_Font_Color',  sanitize_hex_color($_POST['ufaq_styling_answer_font_color']));}
    if (isset($_POST['ufaq_styling_answer_margin'])) {update_option('EWD_UFAQ_Styling_Answer_Margin',  sanitize_text_field($_POST['ufaq_styling_answer_margin']));}
    if (isset($_POST['ufaq_styling_answer_padding'])) {update_option('EWD_UFAQ_Styling_Answer_Padding',  sanitize_text_field($_POST['ufaq_styling_answer_padding']));}
    if (isset($_POST['ufaq_styling_postdate_font'])) {update_option('EWD_UFAQ_Styling_Postdate_Font',  sanitize_text_field($_POST['ufaq_styling_postdate_font']));}
    if (isset($_POST['ufaq_styling_postdate_font_size'])) {update_option('EWD_UFAQ_Styling_Postdate_Font_Size',  sanitize_text_field($_POST['ufaq_styling_postdate_font_size']));}
    if (isset($_POST['ufaq_styling_postdate_font_color'])) {update_option('EWD_UFAQ_Styling_Postdate_Font_Color',  sanitize_hex_color($_POST['ufaq_styling_postdate_font_color']));}
    if (isset($_POST['ufaq_styling_postdate_margin'])) {update_option('EWD_UFAQ_Styling_Postdate_Margin',  sanitize_text_field($_POST['ufaq_styling_postdate_margin']));}
    if (isset($_POST['ufaq_styling_postdate_padding'])) {update_option('EWD_UFAQ_Styling_Postdate_Padding',  sanitize_text_field($_POST['ufaq_styling_postdate_padding']));}
    if (isset($_POST['ufaq_styling_category_font'])) {update_option('EWD_UFAQ_Styling_Category_Font',  sanitize_text_field($_POST['ufaq_styling_category_font']));}
    if (isset($_POST['ufaq_styling_category_font_size'])) {update_option('EWD_UFAQ_Styling_Category_Font_Size',  sanitize_text_field($_POST['ufaq_styling_category_font_size']));}
    if (isset($_POST['ufaq_styling_category_font_color'])) {update_option('EWD_UFAQ_Styling_Category_Font_Color',  sanitize_hex_color($_POST['ufaq_styling_category_font_color']));}
    if (isset($_POST['ufaq_styling_category_margin'])) {update_option('EWD_UFAQ_Styling_Category_Margin',  sanitize_text_field($_POST['ufaq_styling_category_margin']));}
    if (isset($_POST['ufaq_styling_category_padding'])) {update_option('EWD_UFAQ_Styling_Category_Padding',  sanitize_text_field($_POST['ufaq_styling_category_padding']));}

    if (isset($_POST['ufaq_styling_category_heading_type'])) {update_option('EWD_UFAQ_Styling_Category_Heading_Type',  sanitize_text_field($_POST['ufaq_styling_category_heading_type']));}
    if (isset($_POST['ufaq_styling_faq_heading_type'])) {update_option('EWD_UFAQ_Styling_FAQ_Heading_Type',  sanitize_text_field($_POST['ufaq_styling_faq_heading_type']));}
    if (isset($_POST['toggle_symbol'])) {update_option('EWD_UFAQ_Toggle_Symbol',  sanitize_text_field($_POST['toggle_symbol']));}

    if (isset($_POST['Pretty_Permalinks']) and $_POST['Pretty_Permalinks'] == "Yes") {
         update_option("EWD_UFAQ_Rewrite_Rules", "Yes");
    }
}

function EWD_UFAQ_Validate_CSS($CSS) {
    require_once( EWD_UFAQ_CD_PLUGIN_PATH . 'css/CSSTidy/class.csstidy.php' );

    $CSSTidy = new csstidy();

    $CSSTidy->set_cfg( 'remove_bslash', false );
    $CSSTidy->set_cfg( 'compress_colors', false );
    $CSSTidy->set_cfg( 'compress_font-weight', false );
    $CSSTidy->set_cfg( 'optimise_shorthands', 0 );
    $CSSTidy->set_cfg( 'remove_last_;', false );
    $CSSTidy->set_cfg( 'case_properties', false );
    $CSSTidy->set_cfg( 'discard_invalid_properties', false );
    $CSSTidy->set_cfg( 'css_level', 'CSS3.0' );
    $CSSTidy->set_cfg( 'preserve_css', true );
    
    $CSS = preg_replace( '/\\\\([0-9a-fA-F]{4})/', '\\\\\\\\$1', $CSS );

    $CSS = str_replace( '<=', '&lt;=', $CSS );
    $CSS = wp_kses_split($CSS, array(), array());
    $CSS = str_replace( '&gt;', '>', $CSS );
    $CSS = strip_tags( $CSS );

    $CSSTidy->parse( $CSS );
    return $CSSTidy->print->plain();
}
?>
