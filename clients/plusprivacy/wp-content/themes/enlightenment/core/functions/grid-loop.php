<?php

function enlightenment_grid_columns() {
	$columns = array(
		'onecol' => array(
			'name' => __( '1 Column', 'enlightenment' ),
			'content_columns' => 1,
			'body_class' => '',
			'content_class' => '',
			'entry_class' => '',
			'full_width_class' => '',
			'image' => enlightenment_images_directory_uri() . '/onecol.png',
		),
		'twocol' => array(
			'name' => sprintf( __( '%d Columns', 'enlightenment' ), 2 ),
			'content_columns' => 2,
			'body_class' => 'content-columns-2',
			'content_class' => 'grid-columns-2',
			'entry_class' => '',
			'full_width_class' => '',
			'image' => enlightenment_images_directory_uri() . '/twocol.png',
		),
		'threecol' => array(
			'name' => sprintf( __( '%d Columns', 'enlightenment' ), 3 ),
			'content_columns' => 3,
			'body_class' => 'content-columns-3',
			'content_class' => 'grid-columns-3',
			'entry_class' => '',
			'full_width_class' => '',
			'image' => enlightenment_images_directory_uri() . '/threecol.png',
		),
		'fourcol' => array(
			'name' => sprintf( __( '%d Columns', 'enlightenment' ), 4 ),
			'content_columns' => 4,
			'body_class' => 'content-columns-4',
			'content_class' => 'grid-columns-4',
			'entry_class' => '',
			'full_width_class' => '',
			'image' => enlightenment_images_directory_uri() . '/fourcol.png',
		),
	);
	return apply_filters( 'enlightenment_grid_columns', $columns );
}

function enlightenment_archive_grids() {
	$grids = array(
		'search'   => array(
			'grid' => enlightenment_default_grid(),
			'lead_posts' => 0,
		),
		'post'   => array(
			'grid' => enlightenment_default_grid(),
			'lead_posts' => 0,
		),
		'author' => array(
			'grid' => enlightenment_default_grid(),
			'lead_posts' => 0,
		),
		'date'   => array(
			'grid' => enlightenment_default_grid(),
			'lead_posts' => 0,
		),
	);
	$post_types = get_post_types( array( 'has_archive' => true ) );
	foreach( $post_types as $post_type )
		$grids[$post_type] = array(
			'grid' => enlightenment_default_grid(),
			'lead_posts' => 0,
		);
	$taxonomies = get_taxonomies( array( 'public' => true ) );
	foreach( $taxonomies as $taxonomy )
		$grids[$taxonomy] = array(
			'grid' => enlightenment_default_grid(),
			'lead_posts' => 0,
		);
	return apply_filters( 'enlightenment_archive_grids', $grids );
}

function enlightenment_default_grid() {
	return apply_filters( 'enlightenment_default_grid', 'onecol' );
}

add_filter( 'enlightenment_archive_grids', 'enlightenment_archive_grids_merge_theme_options', 30 );

function enlightenment_archive_grids_merge_theme_options( $grids ) {
	$options = enlightenment_theme_option( 'grids' );
	if( ! is_array( $options ) )
		$options = array();
	return array_merge( $grids, $options );
}

function enlightenment_current_grid() {
	$grids = enlightenment_archive_grids();
	if( is_home() && ! is_page() )
		$grid = $grids['post']['grid'];
	elseif( is_author() )
		$grid = $grids['author']['grid'];
	elseif( is_date() )
		$grid = $grids['date']['grid'];
	elseif( is_post_type_archive() )
		$grid = $grids[ get_query_var( 'post_type' ) ]['grid'];
	elseif( is_category() )
		$grid = $grids['category']['grid'];
	elseif( is_tag() )
		$grid = $grids['post_tag']['grid'];
	elseif( is_tax() )
		$grid = $grids[ get_queried_object()->taxonomy ]['grid'];
	elseif( is_search() )
		$grid = $grids['search']['grid'];
	else
		$grid = 'onecol';
	return apply_filters( 'enlightenment_current_grid', $grid );
}

function enlightenment_current_lead_posts() {
	$grids = enlightenment_archive_grids();
	$grid = enlightenment_get_grid( enlightenment_current_grid() );
	if( 1 == $grid['content_columns'] )
		$lead_posts = get_option( 'posts_per_page' );
	elseif( is_home() && ! is_page() )
		$lead_posts = $grids['post']['lead_posts'];
	elseif( is_author() )
		$lead_posts = $grids['author']['lead_posts'];
	elseif( is_date() )
		$lead_posts = $grids['date']['lead_posts'];
	elseif( is_post_type_archive() )
		$lead_posts = $grids[ get_query_var( 'post_type' ) ]['lead_posts'];
	elseif( is_category() )
		$lead_posts = $grids['category']['lead_posts'];
	elseif( is_tag() )
		$lead_posts = $grids['post_tag']['lead_posts'];
	elseif( is_tax( 'post_format' ) )
		$lead_posts = $grids['post']['lead_posts'];
	elseif( is_tax() )
		$lead_posts = $grids[ get_queried_object()->taxonomy ]['lead_posts'];
	elseif( is_search() )
		$lead_posts = $grids['post']['lead_posts'];
	return apply_filters( 'enlightenment_current_lead_posts', $lead_posts );
}

function enlightenment_get_grid( $grid ) {
	$grids = enlightenment_grid_columns();
	if( isset( $grids[$grid] ) )
		return $grids[$grid];
	return false;
}

add_filter( 'body_class', 'enlightenment_set_grid_body_class' );

function enlightenment_set_grid_body_class( $classes ) {
	if( is_singular() || is_404() )
		return $classes;
	$grid = enlightenment_get_grid( enlightenment_current_grid() );
	if( ! empty( $grid['body_class'] ) )
		$classes[] = $grid['body_class'];
	return $classes;
}

add_filter( 'enlightenment_content_class_args', 'enlightenment_set_grid_content_class' );

function enlightenment_set_grid_content_class( $args ) {
	if( is_singular() || is_404() )
		return $args;
	$grid = enlightenment_get_grid( enlightenment_current_grid() );
	if( ! empty( $grid['content_class'] ) )
		$args['class'] .= ' ' . $grid['content_class'];
	return $args;
}

add_filter( 'post_class', 'enlightenment_set_grid_entry_class' );

function enlightenment_set_grid_entry_class( $classes ) {
	if( is_singular() || is_404() )
		return $classes;
	$grid = enlightenment_get_grid( enlightenment_current_grid() );
	if( enlightenment_is_lead_post() && ! empty( $grid['full_width_class'] ) ) {
		$classes[] = $grid['full_width_class'];
		return $classes;
	}
	if( ! empty( $grid['entry_class'] ) )
		$classes[] = $grid['entry_class'];
	return $classes;
}

function enlightenment_is_lead_post() {
	if( is_admin() ) {
		$is_lead_post = false;
	} elseif( is_singular() ) {
		$is_lead_post = true;
	} else {
		$grid = enlightenment_get_grid( enlightenment_current_grid() );
		if( 1 == $grid['content_columns'] )
			return true;
		
		global $enlightenment_post_counter;
		if( ! isset( $enlightenment_post_counter ) ) {
			_doing_it_wrong( __FUNCTION__, 'This function can only be called inside The Loop', '' );
			return;
		}
		$lead_posts = enlightenment_current_lead_posts();
		$is_lead_post = ! is_paged() && $lead_posts >= $enlightenment_post_counter;
	}
	return apply_filters( 'enlightenment_is_lead_post', $is_lead_post );
}

add_filter( 'body_class', 'enlightenment_grid_body_class' );

function enlightenment_grid_body_class( $classes ) {
	if( is_singular() || is_404() )
		return $classes;
	$grid = enlightenment_get_grid( enlightenment_current_grid() );
	if( 1 < $grid['content_columns'] )
		$classes[] = apply_filters( 'enlightenment_grid_body_class', 'grid-active' );
	return $classes;
}

add_filter( 'post_class', 'enlightenment_grid_post_class' );

function enlightenment_grid_post_class( $classes ) {
	if( is_singular() || is_404() )
		return $classes;
	$grid = enlightenment_get_grid( enlightenment_current_grid() );
	if( enlightenment_is_lead_post() )
		$classes[] = apply_filters( 'enlightenment_lead_post_class', 'entry-lead' );
	elseif( 1 < $grid['content_columns'] ) {
		$classes[] = apply_filters( 'enlightenment_teaser_post_class', 'entry-teaser' );
		global $enlightenment_post_counter;
		$teaser_count = $enlightenment_post_counter - enlightenment_current_lead_posts();
		if( 0 == $teaser_count % 2 )
			$classes[] = apply_filters( 'enlightenment_teaser_even_class', 'teaser-even' );
		else
			$classes[] = apply_filters( 'enlightenment_teaser_odd_class', 'teaser-odd' );
		$teaser_row_position = $teaser_count % $grid['content_columns'];
		if( 0 == $teaser_row_position )
			$teaser_row_position = $grid['content_columns'];
		$classes[] = apply_filters( 'enlightenment_teaser_row_count_class', 'teaser-row-pos-' . $teaser_row_position );

	}
	return $classes;
}

add_action( 'wp_enqueue_scripts', 'enlightenment_enqueue_masonry_script' );

function enlightenment_enqueue_masonry_script() {
	if( is_singular() || is_404() )
		return;
	$grid = enlightenment_get_grid( enlightenment_current_grid() );
	if( 1 == $grid['content_columns'] )
		return;
	$entry_class = explode( ' ', $grid['entry_class'] );
	$column_width = '.' . $entry_class[0];
	$defaults = array(
		'masonry' => true,
		'masonry_args' => array(
			'container'    => '#primary',
			'columnWidth'  => '#primary .' . $entry_class[0],
			'itemSelector' => '#primary .hentry',
			'transitionDuration' => '0.7s',
		),
	);
	$args = get_theme_support( 'enlightenment-grid-loop' );
	if( is_array( $args ) )
		$args = array_shift( $args );
	else
		$args = array();
	$args = apply_filters( 'enlightenment_masonry_script_args', $args );
	$args = wp_parse_args( $args, $defaults );
	if( $args['masonry'] ) {
		wp_enqueue_script( 'masonry' );
		wp_localize_script( 'masonry', 'enlightenment_masonry_args', $args['masonry_args'] );
	}
}

add_filter( 'enlightenment_call_js', 'enlightenment_call_masonry_script' );

function enlightenment_call_masonry_script( $deps ) {
	$deps[] = 'masonry';
	return $deps;
}




