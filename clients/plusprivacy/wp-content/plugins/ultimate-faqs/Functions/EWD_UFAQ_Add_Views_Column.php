<?php
// Add in a new column option for the UFAQ post type
function EWD_UFAQ_Columns_Head($defaults) {
	$defaults['number_of_views'] = __('# of Views', 'ultimate-faqs');
	$defaults['ufaq_categories'] = __('Categories', 'ultimate-faqs');
	$defaults['ufaq_ID'] = __('Post ID', 'ultimate-faqs');

	return $defaults;
}
 
// Show the number of times the FAQ post has been clicked
function EWD_UFAQ_Columns_Content($column_name, $post_ID) {
	if ($column_name == 'number_of_views') {
		$num_views = EWD_UFAQ_Get_Views($post_ID);
		echo $num_views;
	}

	if ($column_name == 'ufaq_categories') {
		$categories = EWD_UFAQ_Get_Categories($post_ID);
		echo $categories;
	}

	if ($column_name == 'ufaq_ID') {
		echo $post_ID;
	}
}

function EWD_UFAQ_Register_Post_Column_Sortables( $column ) {
    $column['number_of_views'] = 'number_of_views';
    $column['ufaq_categories'] = 'ufaq_categories';
    return $column;
}

function EWD_UFAQ_Sort_Views_Column( $vars ) 
{
    if ( isset( $vars['orderby'] ) && 'number_of_views' == $vars['orderby'] ) {
        $vars = array_merge( $vars, array(
            'meta_key' => 'ufaq_view_count', //Custom field key
            'orderby' => 'meta_value_num') //Custom field value (number)
        );
    }

    return $vars;
}

function mbe_sort_custom_column($clauses, $wp_query){
	global $wpdb;
	if(isset($wp_query->query['orderby']) && $wp_query->query['orderby'] == 'ufaq_categories'){
		$clauses['join'] .= <<<SQL
LEFT OUTER JOIN {$wpdb->term_relationships} ON {$wpdb->posts}.ID={$wpdb->term_relationships}.object_id
LEFT OUTER JOIN {$wpdb->term_taxonomy} USING (term_taxonomy_id)
LEFT OUTER JOIN {$wpdb->terms} USING (term_id)
SQL;
		$clauses['where'] .= "AND (taxonomy = 'ufaq-category' OR taxonomy IS NULL)";
		$clauses['groupby'] = "object_id";
		$clauses['orderby'] = "GROUP_CONCAT({$wpdb->terms}.name ORDER BY name ASC)";
		if(strtoupper($wp_query->get('order')) == 'ASC'){
		    $clauses['orderby'] .= 'ASC';
		} else{
		    $clauses['orderby'] .= 'DESC';
		}
	}
	return $clauses;
}

// Get the number of times the FAQ post has been clicked
function EWD_UFAQ_Get_Views($post_ID) {
	$UFAQ_View_Count = get_post_meta($post_ID, 'ufaq_view_count', true);
	if ($UFAQ_View_Count != "") {
		return $UFAQ_View_Count;
	}
	else {
		return 0;
	}
}

function EWD_UFAQ_Get_Categories($post_id) {
	echo get_the_term_list($post_id, 'ufaq-category', '', ', ', '').PHP_EOL;
}

add_action('restrict_manage_posts','EWD_UFAQ_Restrict_By_Category');
function EWD_UFAQ_Restrict_By_Category() {
    global $typenow;
    global $wp_query;
    if ($typenow=='ufaq') {
        $taxonomy = 'ufaq-category';
        $faq_taxonomy = get_taxonomy($taxonomy);
        if (!isset($wp_query->query['term'])) {$wp_query->query['term'] = '';}
        wp_dropdown_categories(array(
            'show_option_all' =>  __("Show All {$faq_taxonomy->label}"),
            'taxonomy'        =>  $taxonomy,
            'name'            =>  'ufaq-category',
            'orderby'         =>  'name',
            'selected'        =>  $wp_query->query['term'],
            'hierarchical'    =>  true,
            'depth'           =>  3,
            'show_count'      =>  true, // Show # listings in parens
            'hide_empty'      =>  true,
        ));
    }
}

add_filter('parse_query','Convert_UFAQ_Category_To_Taxonomy_Term_In_Query');
function Convert_UFAQ_Category_To_Taxonomy_Term_In_Query($query) {
    global $pagenow;
    $post_type = 'ufaq'; // change HERE
    $taxonomy = 'ufaq-category'; // change HERE
    $q_vars = &$query->query_vars;
    if ($pagenow == 'edit.php' && isset($q_vars['post_type']) && $q_vars['post_type'] == $post_type && isset($q_vars[$taxonomy]) && is_numeric($q_vars[$taxonomy]) && $q_vars[$taxonomy] != 0) {
        $term = get_term_by('id', $q_vars[$taxonomy], $taxonomy);
        $q_vars[$taxonomy] = $term->slug;
    }
}

add_filter('manage_ufaq_posts_columns', 'EWD_UFAQ_Columns_Head');
add_action('manage_ufaq_posts_custom_column', 'EWD_UFAQ_Columns_Content', 10, 2);

add_filter( 'manage_edit-ufaq_sortable_columns', 'EWD_UFAQ_Register_Post_Column_Sortables' );
add_filter('posts_clauses', 'mbe_sort_custom_column', 10, 2);
add_filter( 'request', 'EWD_UFAQ_Sort_Views_Column' );

?>