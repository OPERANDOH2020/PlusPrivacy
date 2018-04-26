<?php
function EWD_UFAQ_Add_Modified_Styles() {
	$StylesString = "<style>";
	$StylesString .=".ewd-ufaq-post-margin-symbol { ";
		if (get_option("EWD_UFAQ_Styling_Default_Bg_Color") != "") {$StylesString .= "background-color:" .  get_option("EWD_UFAQ_Styling_Default_Bg_Color") . " !important;";}
		if (get_option("EWD_UFAQ_Styling_Default_Font_Color") != "") {$StylesString .="color:" . get_option("EWD_UFAQ_Styling_Default_Font_Color") . " !important;";}
		if (get_option("EWD_UFAQ_Styling_Default_Border_Size") != "") {$StylesString .= "border-width:" . get_option("EWD_UFAQ_Styling_Default_Border_Size") . " !important; border-style: solid;";}
		if (get_option("EWD_UFAQ_Styling_Default_Border_Color") != "") {$StylesString .= "border-color:" . get_option("EWD_UFAQ_Styling_Default_Border_Color") . " !important;";}
		if (get_option("EWD_UFAQ_Styling_Default_Border_Radius") != "") {$StylesString .= "border-radius:" . get_option("EWD_UFAQ_Styling_Default_Border_Radius") . " !important;";}
		if (get_option("EWD_UFAQ_Styling_Toggle_Symbol_Size") != "") {$StylesString .= "font-size:" . get_option("EWD_UFAQ_Styling_Toggle_Symbol_Size") . " !important;";}
		$StylesString .="}\n";
	$StylesString .=".ewd-ufaq-post-margin-symbol span { ";
		if (get_option("EWD_UFAQ_Styling_Toggle_Symbol_Size") != "") {$StylesString .= "font-size:" . get_option("EWD_UFAQ_Styling_Toggle_Symbol_Size") . " !important;";}
		$StylesString .="}\n";
	$StylesString .=".ufaq-faq-display-style-Block.ewd-ufaq-post-active, .ufaq-faq-display-style-Block.ewd-ufaq-post-active a,.ufaq-faq-display-style-Block:hover, .ufaq-faq-display-style-Block:hover a, .ufaq-faq-display-style-Block:hover h4 { ";
		if (get_option("EWD_UFAQ_Styling_Block_Bg_Color") != "") {$StylesString .= "background-color:" .  get_option("EWD_UFAQ_Styling_Block_Bg_Color") . " !important;";}
		if (get_option("EWD_UFAQ_Styling_Block_Font_Color") != "") {$StylesString .="color:" . get_option("EWD_UFAQ_Styling_Block_Font_Color") . " !important;";}
		$StylesString .="}\n";
	$StylesString .=".ufaq-faq-header-title a{ ";
		if (get_option("EWD_UFAQ_Styling_List_Font") != "") {$StylesString .= "font-family:" .  get_option("EWD_UFAQ_Styling_List_Font") . " !important;";}
		if (get_option("EWD_UFAQ_Styling_List_Font_Size") != "") {$StylesString .="font-size:" . get_option("EWD_UFAQ_Styling_List_Font_Size") . " !important;";}
		if (get_option("EWD_UFAQ_Styling_List_Font_Color") != "") {$StylesString .= "color:" . get_option("EWD_UFAQ_Styling_List_Font_Color") . " !important;";}
		if (get_option("EWD_UFAQ_Styling_List_Margin") != "") {$StylesString .= "margin:" . get_option("EWD_UFAQ_Styling_List_Margin") . " !important;";}
		if (get_option("EWD_UFAQ_Styling_List_Padding") != "") {$StylesString .= "padding:" . get_option("EWD_UFAQ_Styling_List_Padding") . " !important;";}
		$StylesString .="}\n";
	$StylesString .="div.ufaq-faq-title h4 { ";
		if (get_option("EWD_UFAQ_Styling_Question_Font") != "") {$StylesString .= "font-family:" .  get_option("EWD_UFAQ_Styling_Question_Font") . " !important;";}
		if (get_option("EWD_UFAQ_Styling_Question_Font_Size") != "") {$StylesString .="font-size:" . get_option("EWD_UFAQ_Styling_Question_Font_Size") . " !important;";}
		if (get_option("EWD_UFAQ_Styling_Question_Font_Color") != "") {$StylesString .= "color:" . get_option("EWD_UFAQ_Styling_Question_Font_Color") . " !important;";}
		if (get_option("EWD_UFAQ_Styling_Question_Margin") != "") {$StylesString .= "margin:" . get_option("EWD_UFAQ_Styling_Question_Margin") . " !important;";}
		if (get_option("EWD_UFAQ_Styling_Question_Padding") != "") {$StylesString .= "padding:" . get_option("EWD_UFAQ_Styling_Question_Padding") . " !important;";}
		$StylesString .="}\n";
	$StylesString .=".ewd-ufaq-post-margin-symbol { ";
		if (get_option("EWD_UFAQ_Styling_Question_Icon_Top_Margin") != "") {$StylesString .= "margin-top:" . get_option("EWD_UFAQ_Styling_Question_Icon_Top_Margin") . " !important;";}
		$StylesString .="}\n";
	$StylesString .="div.ufaq-faq-post p { ";
		if (get_option("EWD_UFAQ_Styling_Answer_Font") != "") {$StylesString .= "font-family:" .  get_option("EWD_UFAQ_Styling_Answer_Font") . " !important;";}
		if (get_option("EWD_UFAQ_Styling_Answer_Font_Size") != "") {$StylesString .="font-size:" . get_option("EWD_UFAQ_Styling_Answer_Font_Size") . " !important;";}
		if (get_option("EWD_UFAQ_Styling_Answer_Font_Color") != "") {$StylesString .= "color:" . get_option("EWD_UFAQ_Styling_Answer_Font_Color") . " !important;";}
		if (get_option("EWD_UFAQ_Styling_Answer_Margin") != "") {$StylesString .= "margin:" . get_option("EWD_UFAQ_Styling_Answer_Margin") . " !important;";}
		if (get_option("EWD_UFAQ_Styling_Answer_Padding") != "") {$StylesString .= "padding:" . get_option("EWD_UFAQ_Styling_Answer_Padding") . " !important;";}
		$StylesString .="}\n";
	$StylesString .="div.ewd-ufaq-author-date { ";
		if (get_option("EWD_UFAQ_Styling_Postdate_Font") != "") {$StylesString .= "font-family:" .  get_option("EWD_UFAQ_Styling_Postdate_Font") . " !important;";}
		if (get_option("EWD_UFAQ_Styling_Postdate_Font_Size") != "") {$StylesString .="font-size:" . get_option("EWD_UFAQ_Styling_Postdate_Font_Size") . " !important;";}
		if (get_option("EWD_UFAQ_Styling_Postdate_Font_Color") != "") {$StylesString .= "color:" . get_option("EWD_UFAQ_Styling_Postdate_Font_Color") . " !important;";}
		if (get_option("EWD_UFAQ_Styling_Postdate_Margin") != "") {$StylesString .= "margin:" . get_option("EWD_UFAQ_Styling_Postdate_Margin") . " !important;";}
		if (get_option("EWD_UFAQ_Styling_Postdate_Padding") != "") {$StylesString .= "padding:" . get_option("EWD_UFAQ_Styling_Postdate_Padding") . " !important;";}
		$StylesString .="}\n";
	$StylesString .="div.ufaq-faq-categories, div.ufaq-faq-tags { ";
		if (get_option("EWD_UFAQ_Styling_Category_Font") != "") {$StylesString .= "font-family:" .  get_option("EWD_UFAQ_Styling_Category_Font") . " !important;";}
		if (get_option("EWD_UFAQ_Styling_Category_Font_Size") != "") {$StylesString .="font-size:" . get_option("EWD_UFAQ_Styling_Category_Font_Size") . " !important;";}
		if (get_option("EWD_UFAQ_Styling_Category_Font_Color") != "") {$StylesString .= "color:" . get_option("EWD_UFAQ_Styling_Category_Font_Color") . " !important;";}
		if (get_option("EWD_UFAQ_Styling_Category_Margin") != "") {$StylesString .= "margin:" . get_option("EWD_UFAQ_Styling_Category_Margin") . " !important;";}
		if (get_option("EWD_UFAQ_Styling_Category_Padding") != "") {$StylesString .= "padding:" . get_option("EWD_UFAQ_Styling_Category_Padding") . " !important;";}
		$StylesString .="}\n";
	$StylesString .= "</style>";

	return $StylesString;
}
