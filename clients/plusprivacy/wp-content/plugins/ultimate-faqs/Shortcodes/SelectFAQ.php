<?php
/* The function that creates the HTML on the front-end, based on the parameters
* supplied in the product-catalog shortcode */
function Display_Select_FAQs($atts) {
	$ReturnString = "";

	extract( shortcode_atts( array(
									'faq_name' => "",
									'faq_slug' => "",
									'faq_id' => "",
									'no_comments' => ""),
									$atts
		)
	);

	if ($faq_name != "") {$name_array = explode(",", $faq_name);}
	else {$name_array = array();}
	if ($faq_slug != "") {$slug_array = explode(",", $faq_slug);}
	else {$slug_array = array();}
	if ($faq_id != "") {$id_array = explode(",", $faq_id);}
	else {$id_array = array();}

	$post_id_array = array();

	foreach ($name_array as $post_name) {
		$single_post = get_page_by_title($post_name, "OBJECT", "ufaq");
		$post_id_array[] = $single_post->ID;
	}

	foreach ($slug_array as $post_slug) {
		$single_post = get_page_by_path($post_slug, "OBJECT", "ufaq");
		$post_id_array[] = $single_post->ID;
	}

	foreach ($id_array as $post_id) {
		$post_id_array[] = (int) $post_id;
	}
	
	$json_ids = str_replace(array("[", "]"), array("&lsqb;", "&rsqb;"), json_encode($post_id_array));
	if (!empty($post_id_array)) {$ReturnString = do_shortcode("[ultimate-faqs post__in='" . $json_ids . "' no_comments='" . $no_comments . "']");}

	return $ReturnString;
}
add_shortcode("select-faq", "Display_Select_FAQs");