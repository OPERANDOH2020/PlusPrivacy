<?php

function enlightenment_the_loop( $args = null ) {
	$defaults = array(
		'container' => 'article',
		'container_class' => '',
		'container_id' => 'post-' . is_404() ? '0' : get_the_ID(),
		'container_extra_atts' => '',
		'header_tag' => 'header',
		'header_class' => 'entry-header',
		'echo' => true,
	);
	$defaults = apply_filters( 'enlightenment_the_loop_args', $defaults );
	$args = wp_parse_args( $args, $defaults );
	if( ! $args['echo'] )
		ob_start();
	if( have_posts() ) {
		global $enlightenment_post_counter;
		$enlightenment_post_counter = 0;
		do_action( 'enlightenment_before_entries_list' );
		while( have_posts() ) {
			the_post();
			$enlightenment_post_counter++;
			do_action( 'enlightenment_before_entry' );
			$post_class = implode( ' ', get_post_class() ) . ' ' . $args['container_class'];
			$post_class = apply_filters( 'enlightenment_post_class-count-' . $enlightenment_post_counter, $post_class );
			echo enlightenment_open_tag( $args['container'], $post_class, $args['container_id'], $args['container_extra_atts'] );
				do_action( 'enlightenment_before_entry_header' );
				if( has_action( 'enlightenment_entry_header' ) ) {
					echo enlightenment_open_tag( $args['header_tag'], $args['header_class'] );
					do_action_ref_array( 'enlightenment_entry_header', enlightenment_the_title_args() );
					echo enlightenment_close_tag( $args['header_tag'] );
				}
				do_action( 'enlightenment_after_entry_header' );
				do_action( 'enlightenment_before_entry_content' );
				do_action( 'enlightenment_entry_content', '(more&hellip;)' );
				do_action( 'enlightenment_after_entry_content' );
				do_action( 'enlightenment_before_entry_footer' );
				do_action( 'enlightenment_entry_footer' );
				do_action( 'enlightenment_after_entry_footer' );
			echo enlightenment_close_tag( $args['container'] );
			do_action( 'enlightenment_after_entry' );
		}
		do_action( 'enlightenment_after_entries_list' );
		unset( $GLOBALS['enlightenment_post_counter'] );
	} else {
		do_action( 'enlightenment_no_entries' );
	}
	do_action( 'enlightenment_after_the_loop' );
	if( ! $args['echo'] ) {
		$output = ob_get_clean();
		return $output;
	}
}

function enightenment_clear_entry_hooks() {
	if( ! is_singular() ) {
		remove_all_actions( 'enlightenment_entry_header', 10 );
		remove_all_actions( 'enlightenment_after_entry_header', 10 );
		remove_all_actions( 'enlightenment_before_entry_content', 10 );
		remove_all_actions( 'enlightenment_entry_content', 10 );
		remove_all_actions( 'enlightenment_after_entry_content', 10 );
		remove_all_actions( 'enlightenment_before_entry_footer', 10 );
		remove_all_actions( 'enlightenment_entry_footer', 10 );
	}
}

function enlightenment_custom_loop( $args = null ) {
	$defaults = array(
		'query_name' => null,
		'query_args' => null,
		'container' => 'article',
		'container_class' => '',
		'default_post_class' => false,
		'container_id' => '',
		'container_extra_atts' => '',
		'header_tag' => 'header',
		'header_class' => 'entry-header',
		'echo' => true,
	);
	$defaults = apply_filters( 'enlightenment_custom_loop_args', $defaults );
	$args = wp_parse_args( $args, $defaults );
	if( empty( $args['query_name'] ) ) {
		_doing_it_wrong( __FUNCTION__, 'The \'query_name\' argument is required.', '' );
		return;
	}
	if( empty( $args['query_args'] ) )
		return;
	$query = new WP_Query( $args['query_args'] );
	if( ! $args['echo'] )
		ob_start();
	global $enlightenment_custom_query_name;
	$enlightenment_custom_query_name = $args['query_name'];
	do_action( 'enlightenment_before_custom_loop', $args['query_name'] );
	if( $query->have_posts() ) {
		do_action( 'enlightenment_custom_before_entries_list' );
		global $enlightenment_custom_post_counter;
		$enlightenment_custom_post_counter = 0;
		while( $query->have_posts() ) {
			$query->the_post();
			$enlightenment_custom_post_counter++;
			do_action( 'enlightenment_custom_before_entry' );
			$post_class = ( $args['default_post_class'] ? implode( ' ', get_post_class() ) . ' ' : '' ) . $args['container_class'];
			$post_class = apply_filters( 'enlightenment_custom_post_class', $post_class );
			$post_class = apply_filters( 'enlightenment_custom_post_class-count-' . $enlightenment_custom_post_counter, $post_class );
			
			$post_id = apply_filters( 'enlightenment_custom_post_id', $args['container_id'] );
			$post_id = apply_filters( 'enlightenment_custom_post_id-count-' . $enlightenment_custom_post_counter, $post_id );
			
			$post_extra_atts = apply_filters( 'enlightenment_custom_post_extra_atts', $args['container_extra_atts'] );
			$post_extra_atts = apply_filters( 'enlightenment_custom_post_extra_atts-count-' . $enlightenment_custom_post_counter, $post_extra_atts );
			
			echo enlightenment_open_tag( $args['container'], $post_class, $post_id, $post_extra_atts );
				do_action( 'enlightenment_custom_before_entry_header' );
				if( has_action( 'enlightenment_custom_entry_header' ) ) {
					echo enlightenment_open_tag( $args['header_tag'], $args['header_class'] );
					do_action_ref_array( 'enlightenment_custom_entry_header', enlightenment_the_title_custom_args() );
					echo enlightenment_close_tag( $args['header_tag'] );
				}
				do_action( 'enlightenment_custom_after_entry_header' );
				do_action( 'enlightenment_custom_before_entry_content' );
				do_action( 'enlightenment_custom_entry_content', '(more&hellip;)' );
				do_action( 'enlightenment_custom_after_entry_content' );
				do_action( 'enlightenment_custom_before_entry_footer' );
				do_action( 'enlightenment_custom_entry_footer' );
				do_action( 'enlightenment_custom_after_entry_footer' );
			echo enlightenment_close_tag( $args['container'] );
			do_action( 'enlightenment_custom_after_entry' );
		}
		do_action( 'enlightenment_custom_after_entries_list' );
		wp_reset_postdata();
		unset( $GLOBALS['enlightenment_custom_post_counter'] );
	} else {
		do_action( 'enlightenment_custom_no_entries' );
	}
	do_action( 'enlightenment_after_custom_loop', $args['query_name'] );
	unset( $GLOBALS['enlightenment_custom_query_name'] );
	if( ! $args['echo'] ) {
		$output = ob_get_clean();
		return $output;
	}
}

add_action( 'enlightenment_after_custom_loop', 'enlightenment_remove_custom_loop_hooks', 999 );

function enlightenment_remove_custom_loop_hooks() {
	remove_all_actions( 'enlightenment_custom_before_entries_list' );
	remove_all_actions( 'enlightenment_custom_before_entry' );
	remove_all_actions( 'enlightenment_custom_before_entry_header' );
	remove_all_actions( 'enlightenment_custom_entry_header' );
	remove_all_actions( 'enlightenment_custom_entry_meta' );
	remove_all_actions( 'enlightenment_custom_after_entry_header' );
	remove_all_actions( 'enlightenment_custom_before_entry_content' );
	remove_all_actions( 'enlightenment_custom_entry_content' );
	remove_all_actions( 'enlightenment_custom_after_entry_content' );
	remove_all_actions( 'enlightenment_custom_after_entry' );
	remove_all_actions( 'enlightenment_custom_after_entries_list' );
	remove_all_actions( 'enlightenment_custom_no_entries' );
	remove_all_actions( 'enlightenment_custom_before_entry_footer' );
	remove_all_actions( 'enlightenment_custom_entry_footer' );
	remove_all_actions( 'enlightenment_custom_after_entry_footer' );
}

function enlightenment_the_title_args( $args = null ) {
	$defaults = array(
		'title_tag' => is_singular() ? 'h1' : 'h2',
		'title_class' => 'entry-title',
		'title_extra_atts' => '',
		'before' => is_singular() ? '' : '<a href="' . apply_filters( 'the_permalink', get_permalink() ) . '" title="' . the_title_attribute( array( 'echo' => 0 ) ) . '" rel="bookmark">',
		'after' => is_singular() ? '' : '</a>',
	);
	$defaults = apply_filters( 'enlightenment_the_title_args', $defaults );
	$args = wp_parse_args( $args, $defaults );
	$args['before'] = enlightenment_open_tag( $args['title_tag'], $args['title_class'], '', $args['title_extra_atts'] ) . $args['before'];
	$args['after'] .= enlightenment_close_tag( $args['title_tag'] );
	return array( 'before' => $args['before'], 'after' => $args['after'] );
}

function enlightenment_the_title_custom_args( $args = null ) {
	$defaults = array(
		'title_tag' => 'h3',
		'title_class' => 'entry-title',
		'title_extra_atts' => '',
		'before' => '<a href="' . get_permalink() . '" title="' . the_title_attribute( array( 'echo' => 0 ) ) . '" rel="bookmark">',
		'after' => '</a>',
	);
	$defaults = apply_filters( 'enlightenment_the_title_custom_args', $defaults );
	$args = wp_parse_args( $args, $defaults );
	$args['before'] = enlightenment_open_tag( $args['title_tag'], $args['title_class'], '', $args['title_extra_atts'] ) . $args['before'];
	$args['after'] .= enlightenment_close_tag( $args['title_tag'] );
	return array( 'before' => $args['before'], 'after' => $args['after'] );
}

add_filter( 'wp_get_attachment_image_attributes', 'enlightenment_clean_attachment_image_attributes' );

function enlightenment_clean_attachment_image_attributes( $atts ) {
	foreach( $atts as $attr => $val ) {
		if( false !== strpos( $attr, '<' ) ) {
			unset( $atts[ $attr ] );
		} else {
			$atts[ $attr ] = esc_attr( $val );
		}
	}
	return $atts;
}

function enlightenment_author_posts_link( $args = null ) {
	$defaults = array(
		'container' => 'span',
		'container_class' => 'entry-author',
		'author_container' => 'span',
		'author_class' => 'author vcard',
		'author_extra_atts' => '',
		'before' => '',
		'after' => '',
		'format' => '%s',
		'author_link_extra_atts' => ' href="%1$s" title="%2$s" rel="author"',
		'echo' => true,
	);
	$defaults = apply_filters( 'enlightenment_author_posts_link_args', $defaults );
	$args = wp_parse_args( $args, $defaults );
	
	$post_author  = enlightenment_open_tag( $args['author_container'], $args['author_class'], '', $args['author_extra_atts'] );
	$post_author .= enlightenment_open_tag(
		'a',
		'url fn n',
		'',
		sprintf(
			$args['author_link_extra_atts'],
			esc_url( get_author_posts_url( get_the_author_meta( 'ID' ) ) ),
			esc_attr( sprintf( __( 'Posts by %s', 'enlightenment' ), get_the_author() ) )
		)
	);
	$post_author .= esc_html( get_the_author() );
	$post_author .= enlightenment_close_tag( 'a' );
	$post_author .= enlightenment_close_tag( $args['author_container'] );
	
	$output  = enlightenment_open_tag( $args['container'], $args['container_class'] );
	$output .= sprintf( $args['format'], $post_author );
	$output .= enlightenment_close_tag( $args['container'] );
	
	$output = apply_filters( 'enlightenment_author_posts_link', $output, $args );
	
	if( ! $args['echo'] ) {
		return $output;
	}
	
	echo $output;
}

function enlightenment_author_avatar( $args = null ) {
	$defaults = array(
		'container' => '',
		'container_class' => 'author-avatar',
		'avatar_size' => 48,
		'echo' => true,
	);
	$defaults = apply_filters( 'enlightenment_author_avatar_args', $defaults );
	$args = wp_parse_args( $args, $defaults );
	
	$output = '';
	if( $args['avatar_size']  ) {
		$output .= get_avatar( get_the_author_meta( 'user_email' ), $args['avatar_size'] );
	}
	
	$output = apply_filters( 'enlightenment_author_avatar', $output, $args );
	
	if( ! $args['echo'] ) {
		return $output;
	}
	
	echo $output;
}

function enlightenment_entry_date( $args = null ) {
	$defaults = array(
		'container' => 'span',
		'container_class' => 'entry-date',
		'before' => '',
		'after' => '',
		'format' => '%s',
		'published_time_extra_atts' => '',
		'wrap_permalink' => is_singular() ? false : true,
		'echo' => true,
	);
	$defaults = apply_filters( 'enlightenment_entry_date_args', $defaults );
	$args = wp_parse_args( $args, $defaults );
	
	$time_string = '<time class="published updated" datetime="%1$s"%5$s>%2$s</time>';
	if( get_the_time( 'U' ) !== get_the_modified_time( 'U' ) ) {
		$time_string = '<time class="published" datetime="%1$s"%5$s>%2$s</time> <time class="updated" datetime="%3$s">%4$s</time>';
	}
	
	$time_string = sprintf( $time_string,
		esc_attr( get_the_date( 'c' ) ),
		esc_html( get_the_date() ),
		esc_attr( get_the_modified_date( 'c' ) ),
		esc_html( get_the_modified_date() ),
		$args['published_time_extra_atts']
	);
	
	$post_date = $time_string;
	
	if( $args['wrap_permalink'] ) {
		$post_date = sprintf( '<a href="%1$s" rel="bookmark">%2$s</a>', esc_url( get_permalink() ), $post_date );
	}
	
	$output  = enlightenment_open_tag( $args['container'], $args['container_class'] );
	$output .= sprintf( $args['format'], $post_date );
	$output .= enlightenment_close_tag( $args['container'] );
	
	$output = apply_filters( 'enlightenment_entry_date', $output, $args );
	
	if( ! $args['echo'] ) {
		return $output;
	}
	
	echo $output;
}

function enlightenment_categories_list( $args = null ) {
	if ( 'post' != get_post_type() || ! enlightenment_categorized_blog() ) {
		// Hide category text for pages.
		return;
	}
	
	$defaults = array(
		'container' => 'span',
		'container_class' => 'entry-category',
		'before' => '',
		'after' => '',
		'format' => '%s',
		'sep' => ', ',
		'echo' => true,
	);
	$defaults = apply_filters( 'enlightenment_categories_list_args', $defaults );
	$args = wp_parse_args( $args, $defaults );
	
	$output = '';
	$categories_list = get_the_category_list( $args['sep'] );
	if( ! empty( $categories_list ) ) {
		$output .= enlightenment_open_tag( $args['container'], $args['container_class'] );
		$output .= $args['before'];
		$output .= sprintf( $args['format'], $categories_list );
		$output .= $args['after'];
		$output .= enlightenment_close_tag( $args['container'] );
	}
	$output = apply_filters( 'enlightenment_categories_list', $output, $args );
	
	if( ! $args['echo'] ) {
		return $output;
	}
	
	echo $output;
}


function enlightenment_tags_list( $args = null ) {
	if ( 'post' != get_post_type() ) {
		// Hide tags text for pages.
		return;
	}
	
	$defaults = array(
		'container' => 'span',
		'container_class' => 'entry-tags',
		'before' => '',
		'after' => '',
		'format' => '%s',
		'sep' => ', ',
		'echo' => true,
	);
	$defaults = apply_filters( 'enlightenment_tags_list_args', $defaults );
	$args = wp_parse_args( $args, $defaults );
	
	$output = '';
	$tags_list = get_the_tag_list( '', $args['sep'] );
	if( ! empty( $tags_list ) ) {
		$output .= enlightenment_open_tag( $args['container'], $args['container_class'] );
		$output .= $args['before'];
		$output .= sprintf( $args['format'], $tags_list );
		$output .= $args['after'];
		$output .= enlightenment_close_tag( $args['container'] );
	}
	$output = apply_filters( 'enlightenment_tags_list', $output, $args );
	
	if( ! $args['echo'] ) {
		return $output;
	}
	
	echo $output;
}

/**
 * Returns true if a blog has more than 1 category.
 *
 * @return bool
**/
function enlightenment_categorized_blog() {
	if ( false === ( $all_the_cool_cats = get_transient( 'enlightenment_categories' ) ) ) {
		// Create an array of all the categories that are attached to posts.
		$all_the_cool_cats = get_categories( array(
			'fields'     => 'ids',
			'hide_empty' => 1,
			
			// We only need to know if there is more than one category.
			'number'     => 2,
		) );
		
		// Count the number of categories that are attached to the posts.
		$all_the_cool_cats = count( $all_the_cool_cats );
		
		set_transient( 'enlightenment_categories', $all_the_cool_cats );
	}
	
	if ( $all_the_cool_cats > 1 ) {
		// This blog has more than 1 category so _s_categorized_blog should return true.
		return true;
	} else {
		// This blog has only 1 category so _s_categorized_blog should return false.
		return false;
	}
}


add_action( 'edit_category', 'enlightenment_category_transient_flusher' );
add_action( 'save_post',     'enlightenment_category_transient_flusher' );

/**
 * Flush out the transients used in _s_categorized_blog.
**/
function enlightenment_category_transient_flusher() {
	if ( defined( 'DOING_AUTOSAVE' ) && DOING_AUTOSAVE ) {
		return;
	}
	// Like, beat it. Dig?
	delete_transient( 'enlightenment_categories' );
}

function enlightenment_meta_image_size( $args = null ) {
	if( ! wp_attachment_is_image() )
		return '';
	$defaults = array(
		'container' => 'span',
		'container_class' => 'entry-image-size',
		'before' => '',
		'after' => '',
		'format' => __( 'Original image: %s pixels', 'enlightenment' ),
		'echo' => true,
	);
	$defaults = apply_filters( 'enlightenment_meta_image_size_args', $defaults );
	$args = wp_parse_args( $args, $defaults );
	$metadata = wp_get_attachment_metadata();
	$link  = '<a href="' . wp_get_attachment_url() . '" title="' . __( 'Link to full-size image', 'enlightenment' ) . '">';
	$link .= $metadata['width'] . '&times;' . $metadata['height'];
	$link .= '</a>';
	$output = enlightenment_open_tag( $args['container'], $args['container_class'] );
	$output .= $args['before'];
	$output .= sprintf( $args['format'], $link );
	$output .= $args['after'];
	$output .= enlightenment_close_tag( $args['container'] );
	$output = apply_filters( 'enlightenment_meta_image_size', $output, $args );
	if( ! $args['echo'] )
		return $output;
	echo $output;
}

function enlightenment_comments_link( $args = null ) {
	if ( post_password_required() || ! ( comments_open() || get_comments_number() ) ) {
		return;
	}

	$defaults = array(
		'container' => 'span',
		'container_class' => 'entry-comments',
		'before' => '',
		'after' => '',
		'format' => array(
			'zero' => __( 'no comments', 'enlightenment' ),
			'one'  => __( '1 Comment', 'enlightenment' ),
			'more' => __( '% Comments', 'enlightenment' ),
		),
		'sep' => ', ',
		'echo' => true,
	);
	$defaults = apply_filters( 'enlightenment_comments_link_args', $defaults );
	$args = wp_parse_args( $args, $defaults );
	
	list( $zero, $one, $more ) = array_values( $args['format'] );
	ob_start();
	comments_popup_link( $zero, $one, $more );
	$comments_link = ob_get_clean();
	
	$output = enlightenment_open_tag( $args['container'], $args['container_class'] );
	$output .= $args['before'];
	$output .= $comments_link;
	$output .= $args['after'];
	$output .= enlightenment_close_tag( $args['container'] );
	$output = apply_filters( 'enlightenment_comments_link', $output, $args );
	
	if( ! $args['echo'] ) {
		return $output;
	}
	
	echo $output;
}

function enlightenment_edit_post_link( $args = null ) {

	$defaults = array(
		'container' => 'span',
		'container_class' => 'entry-edit-link',
		'before' => '',
		'after' => '',
		'format' => __( 'Edit', 'enlightenment' ),
		'echo' => true,
	);
	$defaults = apply_filters( 'enlightenment_edit_post_link_args', $defaults );
	$args = wp_parse_args( $args, $defaults );
	
	ob_start();
	edit_post_link(
		$args['format'],
		sprintf( '<%s class="%s">', esc_attr( $args['container'] ), esc_attr( $args['container_class'] ) ),
		sprintf( '</%s>', esc_attr( $args['container'] ) )
	);
	$output = ob_get_clean();
	
	$output = apply_filters( 'enlightenment_edit_post_link', $output, $args );
	
	if( ! $args['echo'] ) {
		return $output;
	}
	
	echo $output;
}

function enlightenment_entry_meta( $args = null ) {
	$defaults = array(
		'container' => 'div',
		'container_class' => 'entry-meta',
		'format' => __( 'Posted by %1$s on %2$s in %3$s with %5$s', 'enlightenment' ),
		'echo' => true,
	);
	$defaults = apply_filters( 'enlightenment_entry_meta_args', $defaults );
	$args = wp_parse_args( $args, $defaults );
	
	$post_author = enlightenment_author_posts_link( array( 'echo' => false ) );
	
	$post_date = enlightenment_entry_date( array( 'echo' => false ) );
	
	$categories_list = enlightenment_categories_list( array( 'echo' => false ) );
	
	$tags_list = enlightenment_tags_list( array( 'echo' => false ) );
	
	$comments_link = enlightenment_comments_link( array( 'echo' => false ) );
	
	$edit_post_link = enlightenment_edit_post_link( array( 'echo' => false ) );
	
	$image_size = enlightenment_meta_image_size( array( 'echo' => false ) );
	
	$author_avatar = enlightenment_author_avatar( array( 'echo' => false ) );
	
	$author_description = apply_filters( 'the_author_description', get_the_author_meta( 'description' ), false );
	
	$output  = enlightenment_open_tag( $args['container'], $args['container_class'] );
	$output .= sprintf(
		$args['format'],
		$post_author,
		$post_date,
		$categories_list,
		$tags_list,
		$comments_link,
		$edit_post_link,
		$image_size,
		$author_avatar,
		$author_description
	);
	$output .= enlightenment_close_tag( $args['container'] );
		
	$output = apply_filters( 'enlightenment_entry_meta_output', $output, $args );
	
	if( ! $args['echo'] ) {
		return $output;
	}
	
	echo $output;
}

function enlightenment_custom_entry_meta( $args = null ) {
	$defaults = array(
		'container' => 'div',
		'container_class' => 'byline byline-top entry-meta',
		'echo' => true,
	);
	$defaults = apply_filters( 'enlightenment_custom_entry_meta_args', $defaults );
	$args = wp_parse_args( $args, $defaults );
	$output = '';
	if( has_action( 'enlightenment_custom_entry_meta' ) ) {
		ob_start();
		echo enlightenment_open_tag( $args['container'], $args['container_class'] );
		do_action( 'enlightenment_custom_entry_meta', '0' );
		echo enlightenment_close_tag( $args['container'] );
		$output .= ob_get_clean();
	}
	$output = apply_filters( 'enlightenment_custom_entry_meta_output', $output, $args );
	if( ! $args['echo'] )
		return $output;
	echo $output;
}

add_filter( 'enlightenment_entry_meta_args', 'enlightenment_entry_meta_args' );
add_filter( 'enlightenment_custom_entry_meta_args', 'enlightenment_entry_meta_args' );

function enlightenment_entry_meta_args( $args ) {
	if( doing_action( 'enlightenment_entry_footer' ) )
		$args['container'] = 'footer';
	return $args;
}

function enlightenment_entry_utility( $args = null ) {
	$defaults = array(
		'container' => 'footer',
		'container_class' => 'byline byline-bottom entry-utility',
		'echo' => true,
	);
	$defaults = apply_filters( 'enlightenment_entry_utility_args', $defaults );
	$args = wp_parse_args( $args, $defaults );
	$output = '';
	if( has_action( 'enlightenment_entry_utility' ) ) {
		ob_start();
		echo enlightenment_open_tag( $args['container'], $args['container_class'] );;
		do_action( 'enlightenment_entry_utility' );
		echo enlightenment_close_tag( $args['container'] );
		$output .= ob_get_clean();
	}
	$output = apply_filters( 'enlightenment_entry_utility_output', $output, $args );
	if( ! $args['echo'] )
		return $output;
	echo $output;
}

function enlightenment_excerpt_wrap( $excerpt, $args = null ) {
	$defaults = array(
		'container' => 'div',
		'container_class' => 'entry-summary',
		'extra_atts' => '',
	);
	$defaults = apply_filters( 'enlightenment_excerpt_wrap_args', $defaults );
	$args = wp_parse_args( $args, $defaults );
	if( '' != $excerpt ) {
		$output = enlightenment_open_tag( $args['container'], $args['container_class'], '', $args['extra_atts'] );
		$output .= $excerpt . "\n";
		$output .= enlightenment_close_tag( $args['container'] );
		return $output;
	}
	return $excerpt;
}

add_filter( 'excerpt_more', 'enlightenment_excerpt_more' );

function enlightenment_excerpt_more($more) {
	return ' &#8230;';
}

add_filter( 'the_content_more_link', 'enlightenment_more_link_text', 10, 2 );

function enlightenment_more_link_text( $more_link, $more_link_text ) {
	return str_replace( $more_link_text, __( 'Keep reading &rarr;', 'enlightenment' ), $more_link );
}

function enlightenment_content_link_pages( $content ) {
	return $content . "\n" . wp_link_pages( array( 'echo' => false ) );
}

function enlightenment_content_wrap( $content, $args = null ) {
	$defaults = array(
		'container' => 'div',
		'container_class' => 'entry-content',
		'extra_atts' => '',
	);
	$defaults = apply_filters( 'enlightenment_content_wrap_args', $defaults );
	$args = wp_parse_args( $args, $defaults );
	$output = enlightenment_open_tag( $args['container'], $args['container_class'], '', $args['extra_atts'] );
	$output .= $content . "\n";
	$output .= enlightenment_close_tag( $args['container'] );
	return $output;
}

function enlightenment_content_clearfix( $content ) {
	return $content . "\n" . enlightenment_clearfix( array( 'echo' => false ) );
}

function enlightenment_strip_hashtag_link( $more_link ) {
	$more_link = preg_replace( '|#more-[0-9]+|', '', $more_link );
	return $more_link;
}

function enlightenment_autor_hcard( $args = null ) {
	$defaults = array(
		'container' => 'aside',
		'container_class' => 'entry-author-info',
		'title_container' => 'h4',
		'avatar_size' => 96,
		'title_class' => 'author vcard',
		'title_prefix' => __( 'Written by', 'enlightenment' ),
		'author_name_container' => 'span',
		'author_name_class' => 'fn',
		'bio_container' => 'div',
		'bio_class' => 'author-bio',
		'echo' => true,
	);
	$defaults = apply_filters( 'enlightenment_autor_hcard_args', $defaults );
	$args = wp_parse_args( $args, $defaults );
	global $authordata;
	if ( ! is_object( $authordata ) )
		return false;
	$output = enlightenment_open_tag( $args['container'], $args['container_class'] );
	if( $args['avatar_size']  ) {
		$avatar = get_avatar( get_the_author_meta( 'user_email' ), $args['avatar_size'] );
		$output .= apply_filters( 'enlightenment_autor_hcard_avatar', $avatar, $args );
	}
	$output .= enlightenment_open_tag( $args['title_container'], $args['title_class'] );
	if( '' != $args['title_prefix'] )
		$output .= esc_attr( $args['title_prefix'] ) . ' ';
	$output .= enlightenment_open_tag( $args['author_name_container'], $args['author_name_class'] );
	$output .= sprintf(
		'<a href="%1$s" title="%2$s" rel="author">%3$s</a>',
		esc_url( get_author_posts_url( $authordata->ID, $authordata->user_nicename ) ),
		esc_attr( sprintf( __( 'Posts by %s', 'enlightenment' ), get_the_author() ) ),
		get_the_author()
	);
	$output .= enlightenment_close_tag( $args['author_name_container'] );
	$output .= enlightenment_close_tag( $args['title_container'] );
	
	$description  = enlightenment_open_tag( $args['bio_container'], $args['bio_class'] );
	$description .= apply_filters( 'the_author_description', get_the_author_meta( 'description' ), false );
	$description .= enlightenment_close_tag( $args['bio_container'] );
	$output .= apply_filters( 'enlightenment_author_bio', $description, $args );
	
	$output .= enlightenment_clearfix( array( 'echo' => false ) );
	$output .= enlightenment_close_tag( $args['container'] );
	$output = apply_filters( 'enlightenment_autor_hcard', $output, $args );
	if( ! $args['echo'] )
		return $output;
	echo $output;
}

add_filter( 'the_author_description', 'wpautop' );



