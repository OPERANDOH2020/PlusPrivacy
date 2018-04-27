<?php
add_action( 'init', 'EWD_UFAQ_Create_Posttype' );
function EWD_UFAQ_Create_Posttype() {
		$Slug_Base = get_option("EWD_UFAQ_Slug_Base");
		if ($Slug_Base == '') {$Slug_Base = 'ufaqs';}
		
		$labels = array(
				'name' => __('FAQs', 'ultimate-faqs'),
				'singular_name' => __('FAQ', 'ultimate-faqs'),
				'menu_name' => __('FAQs', 'ultimate-faqs'),
				'add_new' => __('Add New', 'ultimate-faqs'),
				'add_new_item' => __('Add New FAQ', 'ultimate-faqs'),
				'edit_item' => __('Edit FAQ', 'ultimate-faqs'),
				'new_item' => __('New FAQ', 'ultimate-faqs'),
				'view_item' => __('View FAQ', 'ultimate-faqs'),
				'search_items' => __('Search FAQs', 'ultimate-faqs'),
				'not_found' =>  __('Nothing found', 'ultimate-faqs'),
				'not_found_in_trash' => __('Nothing found in Trash', 'ultimate-faqs'),
				'parent_item_colon' => ''
		);

		$args = array(
				'labels' => $labels,
				'public' => true,
				'publicly_queryable' => true,
				'show_ui' => true,
				'query_var' => true,
				'has_archive' => true,
				'menu_icon' => null,
				'rewrite' => array('slug' => $Slug_Base),
				'capability_type' => 'post',
				'menu_position' => null,
				'menu_icon' => 'dashicons-format-status',
				'supports' => array('title','editor','author','excerpt','comments')
	  ); 

	register_post_type( 'ufaq' , $args );
}

function EWD_UFAQ_Create_Category_Taxonomy() {

	register_taxonomy('ufaq-category', 'ufaq', array(
		// Hierarchical taxonomy (like categories)
		'hierarchical' => true,
		// This array of options controls the labels displayed in the WordPress Admin UI
		'labels' => array(
			'name' => __('FAQ Categories', 'ultimate-faqs'),
			'singular_name' => __('FAQ Category', 'ultimate-faqs'),
			'search_items' =>  __('Search FAQ Categories', 'ultimate-faqs'),
			'all_items' => __('All FAQ Categories', 'ultimate-faqs'),
			'parent_item' => __('Parent FAQ Category', 'ultimate-faqs'),
			'parent_item_colon' => __('Parent FAQ Category:', 'ultimate-faqs'),
			'edit_item' => __('Edit FAQ Category', 'ultimate-faqs'),
			'update_item' => __('Update FAQ Category', 'ultimate-faqs'),
			'add_new_item' => __('Add New FAQ Category', 'ultimate-faqs'),
			'new_item_name' => __('New FAQ Category Name', 'ultimate-faqs'),
			'menu_name' => __('FAQ Categories', 'ultimate-faqs'),
		),
		'query_var' => true
	));

	register_taxonomy('ufaq-tag', 'ufaq', array(
		// Hierarchical taxonomy (like categories)
		'hierarchical' => false,
		// This array of options controls the labels displayed in the WordPress Admin UI
		'labels' => array(
			'name' => __('FAQ Tags', 'ultimate-faqs'),
			'singular_name' => __('FAQ Tag', 'ultimate-faqs'),
			'search_items' =>  __('Search FAQ Tags', 'ultimate-faqs'),
			'all_items' => __('All FAQ Tags', 'ultimate-faqs'),
			'parent_item' => __('Parent FAQ Tag', 'ultimate-faqs'),
			'parent_item_colon' => __('Parent FAQ Tag:', 'ultimate-faqs'),
			'edit_item' => __('Edit FAQ Tag', 'ultimate-faqs'),
			'update_item' => __('Update FAQ Tag', 'ultimate-faqs'),
			'add_new_item' => __('Add New FAQ Tag', 'ultimate-faqs'),
			'new_item_name' => __('New FAQ Tag Name', 'ultimate-faqs'),
			'menu_name' => __('FAQ Tags', 'ultimate-faqs'),
		)
	));
}
add_action( 'init', 'EWD_UFAQ_Create_Category_Taxonomy', 0 );

?>
