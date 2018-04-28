<?php 
function EWD_UFAQ_Version_Reversion() {
	if (get_option("EWD_UFAQ_Trial_Happening") != "Yes" or time() < get_option("EWD_UFAQ_Trial_Expiry_Time")) {return;}

	update_option("EWD_UFAQ_Display_Style", "Default");
	update_option("EWD_UFAQ_Color_Block_Shape", "Square");
	update_option("EWD_UFAQ_FAQ_Ratings", "No");
	update_option("EWD_UFAQ_WooCommerce_FAQs", "No");
	update_option("EWD_UFAQ_Use_Product", "Yes");
	update_option("EWD_UFAQ_Reveal_Effect", "none");
	update_option("EWD_UFAQ_Pretty_Permalinks", "No");
	update_option("EWD_UFAQ_Allow_Proposed_Answer", "No");
	update_option("EWD_UFAQ_Admin_Question_Notification", "No");
	update_option("EWD_UFAQ_Auto_Complete_Titles", "Yes");
	update_option("EWD_UFAQ_Slug_Base", "ufaqs");

    update_option("EWD_UFAQ_Order_By", "date");

	update_option("EWD_UFAQ_FAQ_Fields", array());

	update_option("EWD_UFAQ_Posted_Label", "");
	update_option("EWD_UFAQ_By_Label", "");
	update_option("EWD_UFAQ_On_Label", "");
	update_option("EWD_UFAQ_Category_Label", "");
	update_option("EWD_UFAQ_Tag_Label", "");
	update_option("EWD_UFAQ_Enter_Question_Label", "");
	update_option("EWD_UFAQ_Search_Label", "");
	update_option("EWD_UFAQ_Permalink_Label", "");
	update_option("EWD_UFAQ_Back_To_Top_Label", "");
	
	update_option("EWD_UFAQ_Thank_You_Submit_Label", "");
	update_option("EWD_UFAQ_Submit_Question_Label", "");
	update_option("EWD_UFAQ_Please_Fill_Form_Below_Label", "");
	update_option("EWD_UFAQ_Send_Question_Label", "");
	update_option("EWD_UFAQ_Question_Title_Label", "");
	update_option("EWD_UFAQ_What_Question_Being_Answered_Label", "");
	update_option("EWD_UFAQ_Proposed_Answer_Label", "");
	update_option("EWD_UFAQ_Review_Author_Label", "");
	update_option("EWD_UFAQ_What_Name_With_Review_Label", "");
	update_option("EWD_UFAQ_Retrieving_Results", "");
	update_option("EWD_UFAQ_No_Results_Found_Text", "");

	update_option("EWD_UFAQ_Styling_Default_Bg_Color", "");
	update_option("EWD_UFAQ_Styling_Default_Font_Color", "");
	update_option("EWD_UFAQ_Styling_Default_Border", "");
	update_option("EWD_UFAQ_Styling_Default_Border_Radius", "");
	update_option("EWD_UFAQ_Styling_Block_Bg_Color", "");
	update_option("EWD_UFAQ_Styling_Block_Font_Color", "");
	update_option("EWD_UFAQ_Styling_List_Font", "");
	update_option("EWD_UFAQ_Styling_List_Font_Size", "");
	update_option("EWD_UFAQ_Styling_List_Font_Color", "");
	update_option("EWD_UFAQ_Styling_List_Margin", "");
	update_option("EWD_UFAQ_Styling_List_Padding", "");

	update_option("EWD_UFAQ_Styling_Question_Font", "");
	update_option("EWD_UFAQ_Styling_Question_Font_Size", "");
	update_option("EWD_UFAQ_Styling_Question_Font_Color", "");
	update_option("EWD_UFAQ_Styling_Question_Margin", "");
	update_option("EWD_UFAQ_Styling_Question_Padding", "");
	update_option("EWD_UFAQ_Styling_Question_Icon_Top_Margin", "");
	update_option("EWD_UFAQ_Styling_Answer_Font", "");
	update_option("EWD_UFAQ_Styling_Answer_Font_Size", "");
	update_option("EWD_UFAQ_Styling_Answer_Font_Color", "");
	update_option("EWD_UFAQ_Styling_Answer_Margin", "");
	update_option("EWD_UFAQ_Styling_Answer_Padding", "");
	update_option("EWD_UFAQ_Styling_Postdate_Font", "");
	update_option("EWD_UFAQ_Styling_Postdate_Font_Size", "");
	update_option("EWD_UFAQ_Styling_Postdate_Font_Color", "");
	update_option("EWD_UFAQ_Styling_Postdate_Margin", "");
	update_option("EWD_UFAQ_Styling_Postdate_Padding", "");
	update_option("EWD_UFAQ_Styling_Category_Font", "");
	update_option("EWD_UFAQ_Styling_Category_Font_Size", "");
	update_option("EWD_UFAQ_Styling_Category_Font_Color", "");
	update_option("EWD_UFAQ_Styling_Category_Margin", "");
	update_option("EWD_UFAQ_Styling_Category_Padding", "");
	
	update_option("EWD_UFAQ_Styling_Category_Heading_Type", "h4");
	update_option("EWD_UFAQ_Styling_FAQ_Heading_Type", "h4");
	update_option("EWD_UFAQ_Toggle_Symbol", "A");

	update_option("EWD_UFAQ_Full_Version", "No");
	update_option("EWD_UFAQ_Trial_Happening", "No");
	delete_option("EWD_UFAQ_Trial_Expiry_Time");
}
add_action('admin_init', 'EWD_UFAQ_Version_Reversion');

?>