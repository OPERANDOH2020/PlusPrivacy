<?php

add_filter( 'woocommerce_product_tabs', 'EWD_UFAQ_Woo_FAQ_Tab' );
function EWD_UFAQ_Woo_FAQ_Tab( $tabs ) {
	global $product;

	$Use_Product = get_option("EWD_UFAQ_Use_Product");

	$WooCommerce_FAQs = get_option("EWD_UFAQ_WooCommerce_FAQs");

	$WooCommerce_Tab_Label = get_option("EWD_UFAQ_WooCommerce_Tab_Label");
	if ($WooCommerce_Tab_Label == "") {$WooCommerce_Tab_Label = __( 'FAQs', 'EWD_UFAQ' );}

	if ($Use_Product == "Yes" and is_object($product)) {$Product_Post = get_post($product->get_id());}
	else {$Product_Post = get_post(get_the_id());}

	$UFAQ_Product_Category = get_term_by('name', $Product_Post->post_title, 'ufaq-category');

	$WC_Cats = get_the_terms($Product_Post, 'product_cat');
	$UFAQ_WCCat_Category = false;
	if ($WC_Cats) {
		foreach ($WC_Cats as $WC_Cat) {
			if (get_term_by('name', $WC_Cat->name, 'ufaq-category')) {$UFAQ_WCCat_Category = true;}
		}
	}

	$Current_FAQs = get_post_meta($Product_Post->ID, 'EWD_UFAQ_WC_Selected_FAQs', true );
	if (!is_array($Current_FAQs)) {$Current_FAQs = array();}

	if (($UFAQ_Product_Category or $UFAQ_WCCat_Category or !empty($Current_FAQs)) and $WooCommerce_FAQs == "Yes") {
		$tabs['faq_tab'] = array(
			'title' 	=> $WooCommerce_Tab_Label,
			'priority' 	=> 50,
			'callback' 	=> 'EWD_UFAQ_Woo_FAQ_Tab_Content'
		);

		return $tabs;
	}

}

function EWD_UFAQ_Woo_FAQ_Tab_Content() {
	global $product;

	$Use_Product = get_option("EWD_UFAQ_Use_Product");

	$WooCommerce_Tab_Label = get_option("EWD_UFAQ_WooCommerce_Tab_Label");
	if ($WooCommerce_Tab_Label == "") {$WooCommerce_Tab_Label = __( 'FAQs', 'EWD_UFAQ' );}

	if ($Use_Product == "Yes") {$Product_Post = get_post($product->get_id());}
	else {$Product_Post = get_post(get_the_id());}
	$UFAQ_Product_Category = get_term_by('name', $Product_Post->post_title, 'ufaq-category');

	echo '<h2>' . $WooCommerce_Tab_Label . '</h2>';

	$Current_FAQs = get_post_meta($Product_Post->ID, 'EWD_UFAQ_WC_Selected_FAQs', true );
	if (!is_array($Current_FAQs)) {$Current_FAQs = array();}

	if (!empty($Current_FAQs)) {
		$FAQ_List = implode(",", $Current_FAQs);
		echo do_shortcode("[ultimate-faqs post__in_string='". $FAQ_List . "']");
	}
	else {
		$WC_Cats = get_the_terms($Product_Post, 'product_cat');
		$UFAQ_WC_Category_List = "";
		if ($WC_Cats) {
			foreach ($WC_Cats as $WC_Cat) {
				$UFAQ_WC_Category = get_term_by('name', $WC_Cat->name, 'ufaq-category');
				if ($UFAQ_WC_Category) {$UFAQ_WC_Category_List .= "," . $UFAQ_WC_Category->slug;}
			}
		}
		echo do_shortcode("[ultimate-faqs include_category='". $UFAQ_Product_Category->slug . $UFAQ_WC_Category_List . "']");
	}
}

function EWD_UFAQ_Add_FAQs_Product_Tab($array) {
	$Add_Tab = array(
						'label' => __('FAQs', 'ultimate-faqs'),
						'target' => 'ewd_ufaq_faqs',
						'class' => array()
		);

	$array['faqs'] = $Add_Tab;

	return $array;
}
add_filter( 'woocommerce_product_data_tabs', 'EWD_UFAQ_Add_FAQs_Product_Tab', 10, 1 );

function EWD_UFAQ_WooCommerce_Product_Page_FAQs() {
	global $post, $thepostid;

	$WooCommerce_FAQs = get_option("EWD_UFAQ_WooCommerce_FAQs");
	if ($WooCommerce_FAQs != "Yes") {return;}

	$Current_FAQs = get_post_meta($thepostid, 'EWD_UFAQ_WC_Selected_FAQs', true );
	if (!is_array($Current_FAQs)) {$Current_FAQs = array();}

	$All_FAQs = get_posts(array("numberposts" => -1, "post_type" => 'ufaq'));
	$Categories = get_terms(array('taxonomy' => 'ufaq-category'));

	echo "<div id='ewd_ufaq_faqs' class='panel woocommerce_options_panel'>";

	echo "<div class='ewd-ufaq-explanation'>";
	echo __("You can use the form below to select which FAQs to display for this product, or leave it blank to use the default category naming system.", 'ultimate-faqs');
	echo "</div>";

	echo "<div id='ewd-ufaq-add-delete-faq-form-container'>";
	echo "<div id='ewd-ufaq-add-faq-form-div'>";
	echo "<form id='ewd-ufaq-add-faq-form'>";
	echo "<select class='ewd-ufaq-category-filter' name='ewd-ufaq-category-filter'>";
	echo "<option value=''>" . __("All Categories", 'ultimate-faqs') . "</option>";
	foreach ($Categories as $Category) {echo "<option value='" . $Category->term_id . "'>" . $Category->name . "</option>";}
	echo "</select>";
	echo "<table class='form-table ewd-ufaq-faq-add-table'>";
	echo "<tr>";
	echo "<th>" . __("Add?", 'ultimate-faqs') . "</th>";
	echo "<th>" . __("FAQ", 'ultimate-faqs') . "</th>";
	echo "</tr>";
	foreach ($All_FAQs as $FAQ) {
		echo "<tr class='ewd-ufaq-faq-row' data-faqid='" . $FAQ->ID . "'>";
		echo "<td><input type='checkbox' class='ewd-ufaq-add-faq' name='Add_FAQs[]' value='" . $FAQ->ID . "'/></td>";
		echo "<td>" . $FAQ->post_title . "</td>";
		echo "</tr>";
	}
	echo "</table>";
	echo "</form>";
	echo "<button class='ewd-ufaq-add-faq-button'>" . __('Add FAQs', 'ultimate-faqs') . "</button>";
	echo "</div>"; // ewd-ufaq-add-faq-form-div

	echo "<div id='ewd-ufaq-delete-faq-form-div'>";
	echo "<form id='ewd-ufaq-delete-faq-form'>";
	echo "<input type='hidden' id='ewd-ufaq-post-id' value='" . $thepostid . "' />";
	echo "<table class='form-table ewd-ufaq-delete-table'>";
	echo "<tr>";
	echo "<th>" . __("Delete?", 'ultimate-faqs') . "</th>";
	echo "<th>" . __("FAQ", 'ultimate-faqs') . "</th>";
	echo "</tr>";
	foreach ($Current_FAQs as $FAQ_ID) {
		$FAQ = get_post($FAQ_ID);

		echo "<tr class='ewd-ufaq-faq-row ewd-ufaq-delete-faq-row' data-faqid='" . $FAQ_ID . "'>";
		echo "<td><input type='checkbox' class='ewd-ufaq-delete-faq' name='Delete_FAQs[]' value='" . $FAQ_ID . "'/></td>";
		echo "<td>" . $FAQ->post_title . "</td>";
		echo "</tr>";
	}
	echo "</table>";
	echo "</form>";
	echo "<button class='ewd-ufaq-delete-faq-button'>" . __('Delete FAQs', 'ultimate-faqs') . "</button>";
	echo "</div>"; // ewd-ufaq-delete-faq-form-div
	echo "</div>"; // ewd-ufaq-add-delete-faq-form-container
	echo "</div>";
}

add_action('woocommerce_product_data_panels', 'EWD_UFAQ_WooCommerce_Product_Page_FAQs');

?>
