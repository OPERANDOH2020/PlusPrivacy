<?php
/* The function that creates the HTML on the front-end, based on the parameters
* supplied in the product-catalog shortcode */
function Display_FAQs($atts) {
	$Custom_CSS = get_option("EWD_UFAQ_Custom_CSS");
	$FAQ_Toggle = get_option("EWD_UFAQ_Toggle");
	$Category_Toggle = get_option("EWD_UFAQ_Category_Toggle");
	$Category_Accordion = get_option("EWD_UFAQ_Category_Accordion");
	$Expand_Collapse_All = get_option("EWD_UFAQ_Expand_Collapse_All");
	$FAQ_Accordion = get_option("EWD_UFAQ_FAQ_Accordion");
	$Hide_Categories = get_option("EWD_UFAQ_Hide_Categories");
	$Hide_Tags = get_option("EWD_UFAQ_Hide_Tags");
	$Scroll_To_Top = get_option("EWD_UFAQ_Scroll_To_Top");
	$Display_Author = get_option("EWD_UFAQ_Display_Author");
    $Display_Date = get_option("EWD_UFAQ_Display_Date");
    $Display_Back_To_Top = get_option("EWD_UFAQ_Display_Back_To_Top");
    $Include_Permalink = get_option("EWD_UFAQ_Include_Permalink");
	$Permalink_Type = get_option("EWD_UFAQ_Permalink_Type");
	$Comments_On = get_option("EWD_UFAQ_Comments_On");

	$Display_Style = get_option("EWD_UFAQ_Display_Style");
	$Color_Block_Shape = get_option("EWD_UFAQ_Color_Block_Shape");
	$FAQ_Ratings = get_option("EWD_UFAQ_FAQ_Ratings");
	$Reveal_Effect = get_option("EWD_UFAQ_Reveal_Effect");
	$Pretty_Permalinks = get_option("EWD_UFAQ_Pretty_Permalinks");
	$Display_All_Answers = get_option("EWD_UFAQ_Display_All_Answers");
    $Socialmedia_String = get_option("EWD_UFAQ_Social_Media");
    $Socialmedia = explode(",", $Socialmedia_String);
    $FAQ_Elements = get_option("EWD_UFAQ_FAQ_Elements");
    if (!is_array($FAQ_Elements)) {$FAQ_Elements = array();}

    $Group_By_Category = get_option("EWD_UFAQ_Group_By_Category");
    $Group_By_Category_Count = get_option("EWD_UFAQ_Group_By_Category_Count");
	$Group_By_Order_By = get_option("EWD_UFAQ_Group_By_Order_By");
	$Group_By_Order = get_option("EWD_UFAQ_Group_By_Order");
	$Order_By_Setting = get_option("EWD_UFAQ_Order_By");
	$Order_Setting = get_option("EWD_UFAQ_Order");

	$FAQ_Fields_Array = get_option("EWD_UFAQ_FAQ_Fields");
	if (!is_array($FAQ_Fields_Array)) {$FAQ_Fields_Array = array();}
	$Hide_Blank_Fields = get_option("EWD_UFAQ_Hide_Blank_Fields");

	$Posted_Label = get_option("EWD_UFAQ_Posted_Label");
		if ($Posted_Label == "") {$Posted_Label = __("Posted ", 'ultimate-faqs');}
	$By_Label = get_option("EWD_UFAQ_By_Label");
		if ($By_Label == "") {$By_Label = __("by ", 'ultimate-faqs');}
	$On_Label = get_option("EWD_UFAQ_On_Label");
		if ($On_Label == "") {$On_Label = __("on ", 'ultimate-faqs');}
	$Category_Label = get_option("EWD_UFAQ_Category_Label");
	$Tag_Label = get_option("EWD_UFAQ_Tag_Label");
	$Back_To_Top_Label = get_option("EWD_UFAQ_Back_To_Top_Label");
		if ($Back_To_Top_Label == "") {$Back_To_Top_Label = __("Back to Top", 'ultimate-faqs');}
	$Permalink_Label = get_option("EWD_UFAQ_Permalink_Label");
		if ($Permalink_Label == "") {$Permalink_Label = __("Permalink", 'ultimate-faqs');}
	$No_Results_Found_Text = get_option("EWD_UFAQ_No_Results_Found_Text");
		if ($No_Results_Found_Text == "") {$No_Results_Found_Text = __("No result FAQ's contained the term '%s'", 'ultimate-faqs');}

	$UFAQ_Styling_Category_Heading_Type = get_option("EWD_UFAQ_Styling_Category_Heading_Type");
	$UFAQ_Styling_FAQ_Heading_Type = get_option("EWD_UFAQ_Styling_FAQ_Heading_Type");

	$Toggle_Symbol = get_option("EWD_UFAQ_Toggle_Symbol");
	if ($Toggle_Symbol == "") {$Toggle_Symbol = 'A';}

	if ($Display_Style != "Color_Block") {$Color_Block_Shape = "";}
	else {$Color_Block_Shape = "ewd-ufaq-" . $Color_Block_Shape;}

	$Unique_ID = EWD_UFAQ_Rand_Chars(3);
	EWD_UFAQ_Enqueue_Scripts_In_Shortcode();

	$ReturnString = "";
	$HeaderString = "";
	$TitlesArray = array();

	// Get the attributes passed by the shortcode, and store them in new variables for processing
	extract( shortcode_atts( array(
			'search_string' => "",
			'post__in' => "",
			'post__in_string' => "",
			'include_category' => "",
			'exclude_category' => "",
			'include_category_ids' => "",
			'exclude_category_ids' => "",
			'include_category_children' => "Yes",
			'no_comments' => "",
			'orderby' => "",
			'order' => "",
			'ajax' => "No",
			'current_url' => "",
			'only_titles' => "No",
			'display_all_answers' => "",
            'post_count'=>-1),
			$atts
		)
	);

	if ($current_url == "") {$current_url = $_SERVER['REQUEST_URI'];}
	if (strpos($current_url,'faq-tag') !== false) {$current_url = substr($current_url,0,strpos($current_url,'faq-tag'));}
    if (strpos($current_url,'faq-category') !== false) {$current_url = substr($current_url,0,strpos($current_url,'faq-category'));}
    if (strpos($current_url,'?include_tag') !== false) {$current_url = substr($current_url,0,strpos($current_url,'?include_tag'));}
    if (strpos($current_url,'?include_category') !== false) {$current_url = substr($current_url,0,strpos($current_url,'?include_category'));}

	if (strpos($No_Results_Found_Text, "%s")) {$No_Results_Found_Text = str_replace("%s", $search_string, $No_Results_Found_Text);}

	$search_string = strtolower($search_string);

	if ($display_all_answers != "") {$Display_All_Answers = $display_all_answers;}

	if ($post__in != "") {
		$post_id_array = json_decode(str_replace(array("&lsqb;", "&rsqb;"), array("[", "]"), $post__in));
		$post_id_array[] = 0;
	}
	elseif ($post__in_string != "") {$post_id_array = explode(",", $post__in_string);}
	else {$post_id_array = "";}

	if ($orderby == "") {$orderby = $Order_By_Setting;}
	if ($orderby == "popular" or $orderby == "set_order" or $orderby == "top_rated") {
		$orig_order_setting = $orderby;
		$orderby = "meta_value_num";
	}
	else {$orig_order_setting = "";}

	if ($order == "") {$order = $Order_Setting;}
	if ($orig_order_setting == "popular") {$order = "DESC";}
	if ($orig_order_setting == "top_rated") {$order = "DESC";}
	if ($orig_order_setting == "set_order") {$order = "ASC";}

	if ($Group_By_Category == "Yes") {
		  $Category_Array = get_terms('ufaq-category', array('orderby' => $Group_By_Order_By, 'order' => $Group_By_Order));
	}
	else {
			$Category_Array = array("EWD_UFAQ_ALL_CATEGORIES");
	}

	if ($post__in != "" and $Category_Array[0] != "EWD_UFAQ_ALL_CATEGORIES") {$Category_Array[] = "uncategorized";}

	if (isset($_GET['include_category'])) {$include_category = $_GET['include_category'];}
	if ($include_category_children == "No") {$include_children = false;}
	else {$include_children = true;}
	if (get_query_var('ufaq_category_slug') != "") {$include_category = get_query_var('ufaq_category_slug');}
	if ($include_category_ids != "" ) {$include_category_ids_array = explode(",", $include_category_ids);}
	if ($include_category_ids != "") {
		foreach ($include_category_ids_array as $Category_ID) {
			$Term = get_term_by('id', $Category_ID, 'ufaq-category');
			$include_category .= $Term->slug . ",";
		}
		$include_category = substr($include_category, 0, -1);
	}
	if ($include_category != "" ) {$include_category_array = explode(",", $include_category);}
	else {$include_category_array = array();}
	if (sizeOf($include_category_array) > 0) {
		$include_category_filter_array = array( 'taxonomy' => 'ufaq-category',
								'field' => 'slug',
								'terms' => $include_category_array,
								'include_children' => $include_children
		);
	}
	if ($exclude_category_ids != "" ) {$exclude_category_ids_array = explode(",", $exclude_category_ids);}
	if ($exclude_category_ids != "") {
		foreach ($exclude_category_ids_array as $Category_ID) {
			$Term = get_term_by('id', $Category_ID, 'ufaq-category');
			$exclude_category .= $Term->slug . ",";
		}
		$exclude_category = substr($exclude_category, 0, -1);
	}
	if ($exclude_category != "" ) {$exclude_category_array = explode(",", $exclude_category);}
	else {$exclude_category_array = array();}
	if (sizeOf($exclude_category_array) > 0) {
		$exclude_category_filter_array = array( 'taxonomy' => 'ufaq-category',
								'field' => 'slug',
								'terms' => $exclude_category_array,
								'operator' => 'NOT IN',
								'include_children' => $include_children
		);
	}

	if (isset($_GET['include_tag'])) {$include_tag = $_GET['include_tag'];}
	if (get_query_var('ufaq_tag_slug') != "") {$include_tag = get_query_var('ufaq_tag_slug');}
	if (isset($include_tag) and $include_tag != "" ) {$include_tag_array = explode(",", $include_tag);}
	else {$include_tag_array = array();}
	if (sizeOf($include_tag_array) > 0) {
		$include_tag_filter_array = array( 'taxonomy' => 'ufaq-tag',
								'field' => 'slug',
								'terms' => $include_tag_array
		);
	}

	$Page_Permalink = get_the_permalink();

	$ReturnString .= "<div class='ufaq-faq-list' id='ufaq-faq-list'>";
	$HeaderString .= "<div class='ufaq-faq-header'>";

	if (get_query_var('single_faq') != "") {
		$FAQ = get_page_by_path(get_query_var('single_faq'),OBJECT,'ufaq');
		$ReturnString .= "<script>var Display_FAQ_ID = '" . $FAQ->ID . "-%Counter_Placeholder%';</script>";
		$Display_FAQ_ID = $FAQ->ID;
	}
	elseif (isset($_GET['Display_FAQ'])) {
		$ReturnString .= "<script>var Display_FAQ_ID = '" . $_GET['Display_FAQ'] . "-%Counter_Placeholder%';</script>";
		$Display_FAQ_ID = $_GET['Display_FAQ'];
	}
	else {$Display_FAQ_ID = "";}

	if ($Custom_CSS != "") {$ReturnString .= "<style>" . $Custom_CSS . "</style>";}
	$ReturnString .= EWD_UFAQ_Add_Modified_Styles();

	$ReturnString .= "<script language='JavaScript' type='text/javascript'>";
	if ($FAQ_Accordion == "Yes") {$ReturnString .= "var faq_accordion = true;";}
	else {$ReturnString .= "var faq_accordion = false;";}
	if ($Scroll_To_Top == "Yes") {$ReturnString .= "var faq_scroll = true;";}
	else {$ReturnString .= "var faq_scroll = false;";}
	$ReturnString .= "var reveal_effect = '" . $Reveal_Effect . "';";
	$ReturnString .= "</script>";

	if ($Expand_Collapse_All == "Yes") {
		$ReturnString .= "<div class='ewd-ufaq-expand-collapse-div'><a>";
		$ReturnString .= "<span class='ewd-ufaq-expand-all'><span class='ewd-ufaq-toggle-all-symbol'>c</span> " . __("Expand All", 'ultimate-faqs') . "</span>";
		$ReturnString .= "<span class='ewd-ufaq-collapse-all ewd-ufaq-hidden'><span class='ewd-ufaq-toggle-all-symbol'>C</span> " . __("Collapse All", 'ultimate-faqs') . "</span>";
		$ReturnString .= "</div></a>";
	}

	if ($Display_Style == "List") {
		$ReturnString .= "%LIST_HEADER_PLACEHOLDER%";
	}

	$Counter = 0;
	$All_Categories = array();
	foreach ($Category_Array as $Category) {

		if ($Category != "EWD_UFAQ_ALL_CATEGORIES" and $Category != "uncategorized") {
			if (!EWD_UFAQ_Category_Matches($Category, $include_category_array, $exclude_category_array)) {continue;}

			$category_array = array( 'taxonomy' => 'ufaq-category',
						 				'field' => 'slug',
										'terms' => $Category->slug
			);

			$All_Categories[] = $Category->slug;
		}
		elseif ($Category == "uncategorized") {
			$category_array = array( 'taxonomy' => 'ufaq-category',
						 				'field' => 'slug',
										'terms' => $All_Categories,
										'operator' => 'NOT IN'
			);
		}

		$tax_query_array = array('relation' => 'AND');
		if (isset($include_category_filter_array)) {$tax_query_array[] = $include_category_filter_array;}
		if (isset($exclude_category_filter_array)) {$tax_query_array[] = $exclude_category_filter_array;}
		if (isset($include_tag_filter_array)) {$tax_query_array[] = $include_tag_filter_array;}
		if (isset($category_array)) {$tax_query_array[] = $category_array;}

		$params = array('posts_per_page' => $post_count,
						'post_status' => 'publish',
						'post_type' => 'ufaq',
						'tax_query' => $tax_query_array,
						'orderby' => $orderby,
						'order' => $order,
						'suppress_filters' => false
				);
		unset($tax_query_array);

		if ($search_string != "") {$params['s'] = $search_string;}
		if (is_array($post_id_array)) {$params['post__in'] = $post_id_array;}
		if ($orig_order_setting == "popular") {$params['meta_key'] = 'ufaq_view_count';}
		if ($orig_order_setting == "top_rated") {$params['meta_key'] = 'FAQ_Total_Score';}
		if ($orig_order_setting == "set_order") {$params['meta_key'] = 'ufaq_order';}
		$FAQ_Query = new WP_Query($params);

		if ($Category != "EWD_UFAQ_ALL_CATEGORIES" and $Category != 'uncategorized' and $FAQ_Query->post_count > 0) {
			$ReturnString .= "<div class='ufaq-faq-category'>";
			$ReturnString .= "<div class='ufaq-faq-category-title" . ($Category_Toggle == "Yes" ? " ufaq-faq-category-title-toggle" : "") . ($Category_Accordion == "Yes" ? " ufaq-faq-category-title-accordion" : "") . "' data-categoryid='" . $Category->term_id . "-" . $Unique_ID . "'>";
			$ReturnString .= "<" . $UFAQ_Styling_Category_Heading_Type . ">" . $Category->name . ($Group_By_Category_Count == "Yes" ? " <span>(" . $FAQ_Query->post_count . ")" : "") . "</span></" . $UFAQ_Styling_Category_Heading_Type . ">";
			$ReturnString .= "</div>";
			$ReturnString .= "<div class='ufaq-faq-category-inner";
			if ($Category_Toggle == "Yes") {$ReturnString .= " ufaq-faq-category-body-hidden";}
			$ReturnString .= "' id='ufaq-faq-category-body-" . $Category->term_id . "-" . $Unique_ID . "'>";

			$HeaderString .= "<div class='ufaq-faq-header-category'>";
			$HeaderString .= "<div class='ufaq-faq-header-category-title' data-categoryid='" . $Category->term_id . "-" . $Unique_ID . "'>";
			$HeaderString .= "<" . $UFAQ_Styling_Category_Heading_Type . ">" . $Category->name . "</" . $UFAQ_Styling_Category_Heading_Type . ">";
			$HeaderString .= "</div>";
	    }

	    while ( $FAQ_Query->have_posts() ): $FAQ_Query->the_post(); global $post;
	    		$faq = get_post();
				$Category_Terms = wp_get_post_terms($faq->ID, 'ufaq-category');
				$Tag_Terms = wp_get_post_terms($faq->ID, 'ufaq-tag');

				if (is_array($post_id_array)) {
					if (($key = array_search($faq->ID, $post_id_array)) !== false) {unset($post_id_array[$key]);}
				}

				if ($Permalink_Type == "IndividualPage") {
					$FAQ_Permalink = get_permalink($faq->ID);
				}
				else {
					if ($Pretty_Permalinks == "Yes") {$FAQ_Permalink = $Page_Permalink . "single-faq/" . $faq->post_name;}
					else {$FAQ_Permalink = $Page_Permalink . "?Display_FAQ=" . $faq->ID;}
				}

				if ($Display_FAQ_ID == $faq->ID) {
					$ReturnString = str_replace("%Counter_Placeholder%", $Counter, $ReturnString);
					$Display_FAQ_ID = "";
				}

				$TitlesArray[] = json_encode($faq->post_title);
				$HeaderString .= "<div class='ufaq-faq-header-title'><a href='' class='ufaq-faq-header-link'  data-postid='" . $Unique_ID . "-" . $faq->ID . "-" . $Counter  . "'>" . apply_filters('the_title', $faq->post_title, $faq->ID) . "</a></div>";

				$ReturnString .= "<div class='ufaq-faq-div ufaq-faq-display-style-" . $Display_Style . "' id='ufaq-post-" . $Unique_ID . "-" . $faq->ID . "-" . $Counter  . "' data-postid='" . $Unique_ID . "-" . $faq->ID . "-" . $Counter . "' itemscope itemtype='http://schema.org/Question'>";

				$ReturnString .= "<div class='ufaq-faq-title";
				if ($FAQ_Toggle != "No") {$ReturnString .= " ufaq-faq-toggle";}
				$ReturnString .= "' id='ufaq-title-" . $faq->ID . "' data-postid='" . $Unique_ID . "-" . $faq->ID . "-" . $Counter  . "'>";
				$ReturnString .= "<a class='ewd-ufaq-post-margin'  href='" . get_permalink($faq->ID) . "'><div class='ewd-ufaq-post-margin-symbol " . $Color_Block_Shape . "' id='ewd-ufaq-post-margin-symbol-" . $Unique_ID . "-" . $faq->ID . "-" . $Counter  . "'><span id='ewd-ufaq-post-symbol-" . $Unique_ID . "-" . $faq->ID . "-" . $Counter;
				if ($Display_All_Answers == "Yes") {$ReturnString .= "'>" . $Toggle_Symbol . "</span></div>";}
				else {$ReturnString .= "'>" . strtolower($Toggle_Symbol) . "</span></div>";}
				$ReturnString .= "<div class='ufaq-faq-title-text'><" . $UFAQ_Styling_FAQ_Heading_Type . " itemprop='name'>" . apply_filters('the_title', $faq->post_title, $faq->ID) . "</" . $UFAQ_Styling_FAQ_Heading_Type . "></div><div class='ewd-ufaq-clear'></div></a>";
				$ReturnString .= "</div>";

				if (strlen($faq->post_excerpt) > 0) {$ReturnString .= "<div class='ufaq-faq-excerpt' id='ufaq-excerpt-" . $faq->ID . "'>" . apply_filters('the_content', html_entity_decode($faq->post_excerpt)) . "</div>";}
				$ReturnString .= "<div class='ufaq-faq-body ufaq-body-" . $faq->ID;
				if ($Display_All_Answers != "Yes") {$ReturnString .= " ewd-ufaq-hidden";}
				$ReturnString .= "' id='ufaq-body-" . $Unique_ID . "-" . $faq->ID . "-" . $Counter . "' itemprop='suggestedAnswer acceptedAnswer' itemscope itemtype='http://schema.org/Answer'>";

				foreach ($FAQ_Elements as $FAQ_Element) {
					if ($FAQ_Element == "Author_Date" and ($Display_Author == "Yes"  or $Display_Date == "Yes")) {
						$Display_Author_Value = get_post_meta($faq->ID, "EWD_UFAQ_Post_Author", true);
						$Display_Date_Value = get_the_date("", $faq->ID);
						$ReturnString .= "<div class='ewd-ufaq-author-date' itemprop='author' itemscope itemtype='http://schema.org/Person'>";
						$ReturnString .= $Posted_Label . " " ;
						if ($Display_Author == "Yes" and $Display_Author_Value != "") {$ReturnString .= $By_Label . " <span class='ewd-ufaq-author' itemprop='name'>" . $Display_Author_Value . "</span> ";}
						if ($Display_Date == "Yes") {$ReturnString .= $On_Label . " <span class='ewd-ufaq-date'>" . $Display_Date_Value . "</span> ";}
						$ReturnString .= "</div>";
					}

					if ($FAQ_Element == "Body") {
						$ReturnString .= "<div class='ewd-ufaq-post-margin ufaq-faq-post' id='ufaq-post-" . $faq->ID . "' itemprop='text'>" . apply_filters('the_content', html_entity_decode($faq->post_content)) . "</div>";
					}

					if ($FAQ_Element == "Custom_Fields" and sizeOf($FAQ_Fields_Array) > 0) {
						$ReturnString .= "<div class='ufaq-faq-custom-fields' id='ufaq-custom-fields-" . $faq->ID . "'>";
						foreach ($FAQ_Fields_Array  as $FAQ_Field_Item) {
							$Value = get_post_meta($faq->ID, "Custom_Field_" . $FAQ_Field_Item['FieldID'], true);
							if ($Hide_Blank_Fields != "Yes" or $Value != "") {
								$ReturnString .= "<div class='ufaq-custom-field-label'>" . $FAQ_Field_Item['FieldName'] . ": </div>";
								$ReturnString .= "<div class='ufaq-custom-field-value'>&nbsp;";
								if ($FAQ_Field_Item['FieldType'] == "file") {$ReturnString .= "<a href='" . $Value . "'>" . substr($Value, strrpos($Value, "/"+1)) . "</a>";}
								elseif ($FAQ_Field_Item['FieldType'] == "link") {$ReturnString .= "<a href='" . $Value . "' target='_blank'>" . $Value ."</a>";}
								else {$ReturnString .= $Value;}
								$ReturnString .= "</div>";
								$ReturnString .= "<div class='ewd-ufaq-clear'></div>";
							}
							unset($Value);
						}
						$ReturnString .= "</div>";
					}

					if ($FAQ_Element == "Categories" and $Hide_Categories == "No" and sizeOf($Category_Terms) > 0) {
						$ReturnString .= "<div class='ufaq-faq-categories' id='ufaq-categories-" . $faq->ID . "'>";
						if ($Category_Label == ""){
							if (sizeOf($Category_Terms) > 1) {$ReturnString .= __("Categories: ", 'ultimate-faqs');}
							else {$ReturnString .= __("Category: ", 'ultimate-faqs');}
						}
						else {$ReturnString .= $Category_Label . ": ";}
						foreach ($Category_Terms as $Category_Term) {
							if ($Pretty_Permalinks == "Yes") {$Category_URL = $current_url . "faq-category/" . $Category_Term->slug . "/";}
							else {$Category_URL = $current_url . "?include_category=" . $Category_Term->slug;}
							$ReturnString .= "<a  href='" . $Category_URL ."'>" .$Category_Term->name . "</a>, ";
						}
						$ReturnString = substr($ReturnString, 0, strlen($ReturnString)-2);
						$ReturnString .= "</div>";
					}

					if ($FAQ_Element == "Tags" and $Hide_Tags == "No" and sizeOf($Tag_Terms) > 0) {
						$ReturnString .= "<div class='ufaq-faq-tags' id='ufaq-tags-" . $faq->ID . "'>";
						if ($Tag_Label == ""){
							if (sizeOf($Tag_Terms) > 1) {$ReturnString .= "Tags: ";}
							else {$ReturnString .= "Tag: ";}
						}
						else {$ReturnString .= $Tag_Label . ": ";}
						foreach ($Tag_Terms as $Tag_Term) {
							if ($Pretty_Permalinks == "Yes") {$Tag_URL = $current_url . "faq-tag/" . $Tag_Term->slug . "/";}
							else {$Tag_URL = $current_url . "?include_tag=" . $Tag_Term->slug;}
							$ReturnString .= "<a  href='" . $Tag_URL . "'>" .$Tag_Term->name . "</a>, ";
						}
						$ReturnString = substr($ReturnString, 0, strlen($ReturnString)-2);
						$ReturnString .= "</div>";
					}

					if ($FAQ_Element == "Ratings" and $FAQ_Ratings == "Yes") {
						$Up_Votes = get_post_meta($faq->ID, "FAQ_Up_Votes", true);
						if ($Up_Votes == "") {$Up_Votes = 0;}
						$Down_Votes = get_post_meta($faq->ID, "FAQ_Down_Votes", true);
						if ($Down_Votes == "") {$Down_Votes = 0;}

						$ReturnString .= "<div class='ewd-ufaq-ratings'>";
						$ReturnString .= "<div class='ewd-ufaq-ratings-label'>";
						$ReturnString .= __("Did you find this FAQ helpful?", 'ultimate-faqs');
						$ReturnString .= "</div>";
						$ReturnString .= "<div class='ewd-ufaq-rating-button ewd-ufaq-up-vote' data-ratingfaqid='" . $faq->ID . "' itemprop='upvoteCount'>" . $Up_Votes . "</div>";
						$ReturnString .= "<div class='ewd-ufaq-rating-button ewd-ufaq-down-vote' data-ratingfaqid='" . $faq->ID . "' itemprop='downvoteCount'>" . $Down_Votes . "</div>";
						$ReturnString .= "</div>";
						$ReturnString .= "<div class='ewd-ufaq-clear'></div>";
					}

					if ($FAQ_Element == "Social_Media") {
						if ($Socialmedia[0] != "Blank" and $Socialmedia[0] != "") {
							$ReturnString .= "<div class='ufaq-social-links'>Share: ";
							$ReturnString .= "<ul class='rrssb-buttons'>";
						}
						if(in_array("Facebook", $Socialmedia)) {$ReturnString .= EWD_UFAQ_Add_Social_Media_Buttons("Facebook", get_permalink($faq->ID), $faq->post_title);}
						if(in_array("Google", $Socialmedia)) {$ReturnString .= EWD_UFAQ_Add_Social_Media_Buttons("Google", $FAQ_Permalink, $faq->post_title);}
						if(in_array("Twitter", $Socialmedia)) {$ReturnString .= EWD_UFAQ_Add_Social_Media_Buttons("Twitter", $FAQ_Permalink, $faq->post_title);}
						if(in_array("Linkedin", $Socialmedia)) {$ReturnString .= EWD_UFAQ_Add_Social_Media_Buttons("Linkedin", $FAQ_Permalink, $faq->post_title);}
						if(in_array("Pinterest", $Socialmedia)) {$ReturnString .= EWD_UFAQ_Add_Social_Media_Buttons("Pinterest", $FAQ_Permalink, $faq->post_title);}
						if(in_array("Email", $Socialmedia)) {$ReturnString .= EWD_UFAQ_Add_Social_Media_Buttons("Email", $FAQ_Permalink, $faq->post_title);}
						if ($Socialmedia[0] != "Blank" and $Socialmedia[0] != "") {
							$ReturnString .= "</ul>";
							$ReturnString .= "</div>";
						}
					}

			    	if ($FAQ_Element == "Permalink" and $Include_Permalink == "Yes" and $ajax == "No") {
			    		$ReturnString .= "<div class='ufaq-permalink'>" . $Permalink_Label;
						$ReturnString .= "<a href='" . $FAQ_Permalink . "'>";
						$ReturnString .= "<div class='ufaq-permalink-image'></div>";
						$ReturnString .= "</a>";
						$ReturnString .= "</div>";
			    	}

			    	if ($FAQ_Element == "Comments" and comments_open($faq->ID) and $no_comments != "Yes" and $Comments_On == "Yes") {
			    		ob_start();
						$Comments = get_comments(array('post_id' => $faq->ID));
						wp_list_comments(array(), $Comments);
						comment_form(array(), $faq->ID);
						$ReturnString .= ob_get_contents();
						ob_end_clean();
			    	}

					if ($FAQ_Element == "Back_To_Top" and $Display_Back_To_Top == "Yes") {
						$ReturnString .= "<div class='ufaq-back-to-top'>";
						$ReturnString .= "<a class='ufaq-back-to-top-link'>";
						$ReturnString .= $Back_To_Top_Label;
						$ReturnString .= "</a>";
						$ReturnString .= "</div>";
					}
				}

				$ReturnString .= "</div>";
				$ReturnString .= "</div>";

			$Counter++;
		endwhile;

		if ($Category != "EWD_UFAQ_ALL_CATEGORIES" and $Category != "uncategorized" and $FAQ_Query->post_count > 0) {
			$ReturnString .= "</div>";
			$ReturnString .= "</div>";
			$HeaderString .= "</div>";
		}
	}

	if ($Counter == 0 and $search_string != "") {
		$ReturnString .= "<div class='ewd-ufaq-no-results'>" . $No_Results_Found_Text . "</div>";
	}

	$ReturnString .= "</div>";
	$HeaderString .= "</div>";

	$ReturnString = str_replace("%LIST_HEADER_PLACEHOLDER%", $HeaderString, $ReturnString);

	wp_reset_postdata();

	if ($only_titles == "Yes") {
		$UniqueTitles = array_unique($TitlesArray);
		$TitlesString = "";
		foreach ($UniqueTitles as $Title) {
			$TitlesString .= $Title . ",";
		}
		if ($TitlesString != "") {$TitlesString = substr($TitlesString, 0, -1);}
		return $TitlesString;
	}

	return $ReturnString;
}
add_shortcode("ultimate-faqs", "Display_FAQs");

function EWD_UFAQ_Category_Matches($Category, $include_category_array, $exclude_category_array) {
	$Excluded = EWD_UFAQ_Excluded_Category_Check($Category, $exclude_category_array);
	$Included = EWD_UFAQ_Included_Category_Check($Category, $include_category_array);

	if ($Included and !$Excluded) {
		return true;
	}
	else {
		return false;
	}
}

function EWD_UFAQ_Excluded_Category_Check($Category, $exclude_category_array) {
	if (sizeof($exclude_category_array) == 0) {return false;}

	if (in_array($Category->slug, $exclude_category_array)) {return true;}
	elseif ($Category->parent == 0) {return false;}
	else {
		$Parent_Category = get_term($Category->parent, 'ufaq-category');
		return EWD_UFAQ_Excluded_Category_Check($Parent_Category, $exclude_category_array);
	}
}

function EWD_UFAQ_Included_Category_Check($Category, $include_category_array) {
	if (sizeof($include_category_array) == 0) {return true;}

	if (in_array($Category->slug, $include_category_array)) {return true;}
	elseif ($Category->parent == 0) {return false;}
	else {
		$Parent_Category = get_term($Category->parent, 'ufaq-category');
		return EWD_UFAQ_Included_Category_Check($Parent_Category, $include_category_array);
	}
}

function EWD_UFAQ_Enqueue_Scripts_In_Shortcode() {
	wp_enqueue_script('ewd-ufaq-js');

	wp_enqueue_script("jquery-ui-core");
	wp_enqueue_script("jquery-effects-core");
	wp_enqueue_script('jquery-ui-autocomplete');

	$Reveal_Effect = get_option("EWD_UFAQ_Reveal_Effect");

	if ($Reveal_Effect == "blind") {wp_enqueue_script("jquery-effects-blind");}
	if ($Reveal_Effect == "bounce") {wp_enqueue_script("jquery-effects-bounce");}
	if ($Reveal_Effect == "clip") {wp_enqueue_script("jquery-effects-clip");}
	if ($Reveal_Effect == "drop") {wp_enqueue_script("jquery-effects-drop");}
	if ($Reveal_Effect == "explode") {wp_enqueue_script("jquery-effects-explode");}
	if ($Reveal_Effect == "fade") {wp_enqueue_script("jquery-effects-fade");}
	if ($Reveal_Effect == "fold") {wp_enqueue_script("jquery-effects-fold");}
	if ($Reveal_Effect == "highlight") {wp_enqueue_script("jquery-effects-highlight");}
	if ($Reveal_Effect == "pulsate") {wp_enqueue_script("jquery-effects-pulsate");}
	wp_enqueue_script("jquery-effects-scale");
	if ($Reveal_Effect == "shake") {wp_enqueue_script("jquery-effects-shake");}
	if ($Reveal_Effect == "slide") {wp_enqueue_script("jquery-effects-slide");}
	wp_enqueue_script("jquery-effects-transfer");
}

function EWD_UFAQ_Rand_Chars($CharLength = 10) {
	$characters = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
    $randstring = '';
    for ($i = 0; $i < $CharLength; $i++) {
        $randstring .= $characters[rand(0, strlen($characters)-1)];
    }
    return $randstring;
}
