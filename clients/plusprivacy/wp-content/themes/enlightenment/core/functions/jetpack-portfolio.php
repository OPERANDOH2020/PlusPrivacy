<?php

function enlightenment_project_types( $args = null ) {
	if ( 'jetpack-portfolio' != get_post_type() ) {
		return;
	}
	
	$defaults = array(
		'container' => 'span',
		'container_class' => 'project-types',
		'before' => '',
		'after' => '',
		'format' => '%s',
		'sep' => ', ',
		'echo' => true,
	);
	$defaults = apply_filters( 'enlightenment_project_types_args', $defaults );
	$args = wp_parse_args( $args, $defaults );
	
	$output = '';
	$project_types = get_the_term_list( get_the_ID(), 'jetpack-portfolio-type', $args['before'], $args['sep'], $args['after'] );
	if( ! empty( $project_types ) ) {
		$output .= enlightenment_open_tag( $args['container'], $args['container_class'] );
		$output .= $args['before'];
		$output .= sprintf( $args['format'], $project_types );
		$output .= $args['after'];
		$output .= enlightenment_close_tag( $args['container'] );
	}
	$output = apply_filters( 'enlightenment_project_types', $output, $args );
	
	if( ! $args['echo'] ) {
		return $output;
	}
	
	echo $output;
}

function enlightenment_project_types_filter( $args = null ) {
	$args = array(
		'container' => 'ul',
		'container_class' => 'project-types-filter',
		'term_tag' => 'li',
		'term_class' => 'project-type',
		'current_term_class' => 'current-project-type',
		'sep' => '',
		'echo' => true,
	);
	$args = apply_filters( 'enlightenment_project_types_filter_args', $args );
	
	$terms = get_terms( 'jetpack-portfolio-type' );
	$output = '';
	if( ! empty( $terms ) ) {
		$output .= enlightenment_open_tag( $args['container'], $args['container_class'] );
		if( is_tax( 'jetpack-portfolio-type' ) ) {
			$output .= enlightenment_open_tag( $args['term_tag'], $args['term_class'] );
			$output .= sprintf( '<a href="%1$s" rel="%2$s">%3$s</a>', get_post_type_archive_link( 'jetpack-portfolio' ), 'jetpack-portfolio-type', __( 'All', 'enlightenment' ) );
			$output .= enlightenment_close_tag( $args['term_tag'] );
		}
		foreach( $terms as $term ) {
			$class = $args['term_class'];
			$link = get_term_link( $term, $term->taxonomy );
			$current_url = sprintf( '%1$s%2$s%3$s', is_ssl() ? 'https://' : 'http://', $_SERVER['HTTP_HOST'], $_SERVER['REQUEST_URI'] );
			if( $link == $current_url ) {
				$class .= ' ' . $args['current_term_class'];
			}
			$output .= enlightenment_open_tag( $args['term_tag'], $class );
			$output .= sprintf( '<a href="%1$s" rel="%2$s">%3$s</a>', $link, $term->taxonomy, $term->name );
			$output .= enlightenment_close_tag( $args['term_tag'] );
		}
		$output .= enlightenment_close_tag( $args['container'] );
	}
	
	$output = apply_filters( 'enlightenment_project_types_filter', $output );
	if( ! $args['echo'] )
		return $output;
	echo $output;
}

add_filter( 'enlightenment_archive_grids', 'enlightenment_portfolio_archive_grid' );

function enlightenment_portfolio_archive_grid( $grids ) {
	$grids['jetpack-portfolio'] = array(
		'grid' => 'threecol',
		'lead_posts' => 0,
	);
	$grids['jetpack-portfolio-type'] = array(
		'grid' => 'threecol',
		'lead_posts' => 0,
	);
	$grids['jetpack-portfolio-tag'] = array(
		'grid' => 'threecol',
		'lead_posts' => 0,
	);
	return $grids;
}

add_filter( 'enlightenment_content_hooks', 'enlightenment_portfolio_content_hooks' );

function enlightenment_portfolio_content_hooks( $hooks ) {
	$hooks['enlightenment_content']['functions'][] = 'enlightenment_project_types_filter';
	return $hooks;
}

add_filter( 'enlightenment_template_functions', 'enlightenment_portfolio_template_functions' );

function enlightenment_portfolio_template_functions( $functions ) {
	$functions['enlightenment_project_types_filter'] = __( 'Project Types Filter', 'enlightenment' );
	return $functions;
}