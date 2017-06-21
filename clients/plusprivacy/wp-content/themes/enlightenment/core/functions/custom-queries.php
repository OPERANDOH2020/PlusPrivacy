<?php

add_action( 'admin_enqueue_scripts', 'enlightenment_custom_queries_scripts' );

function enlightenment_custom_queries_scripts( $page_hook ) {
	 if( 'widgets.php' == $page_hook ) 
		wp_enqueue_style( 'enlightenment_theme_options_style', enlightenment_styles_directory_uri() . '/settings.css' );
}

function enlightenment_custom_queries() {
	$queries = array(
		'sticky_posts' => array(
			'name' => __( 'Sticky Posts', 'enlightenment' ),
			'args' => array( 'post__in' => get_option( 'sticky_posts' ) ),
		),
		'post_type_archive' => array(
			'name' => __( 'Post Type Archive', 'enlightenment' ),
			'args' => array( 'post_type' => null ),
		),
		'post_type' => array(
			'name' => __( 'Single Post Type', 'enlightenment' ),
			'args' => array( 'p' => null, 'post_type' => null ),
		),
		'page' => array(
			'name' => __( 'Single Page', 'enlightenment' ),
			'args' => array( 'page_id' => null ),
		),
		'pages' => array(
			'name' => __( 'Multiple Pages', 'enlightenment' ),
			'args' => array( 'post__in' => null, 'post_type' => 'page' ),
		),
		'gallery' => array(
			'name' => __( 'Image Gallery', 'enlightenment' ),
			'args' => array( 'post_type' => 'attachment', 'post_status' => 'any', 'post__in' => null ),
		),
		'author' => array(
			'name' => __( 'Author Archive', 'enlightenment' ),
			'args' => array( 'author' => null ),
		),
		'taxonomy' => array(
			'name' => __( 'Taxonomy', 'enlightenment' ),
			'args' => array( '%taxonomy%' => null ),
		),
	);
	return apply_filters( 'enlightenment_custom_queries', $queries );
}

function enlightenment_custom_post_types() {
	$queries = array();
	$post_types = get_post_types( array( 'publicly_queryable' => true ), 'objects' );
	unset( $post_types['attachment'] );
	foreach( $post_types as $name => $post_type )
		$queries[$name] = array(
			'name' => $post_type->labels->singular_name,
			'args' => array( 'p' => null, 'post_type' => $name ),
		);
	return apply_filters( 'enlightenment_custom_post_types', $queries );
}

function enlightenment_custom_taxonomies() {
	$queries = array();
	$taxonomies = get_taxonomies( array( 'public' => true ), 'objects' );
	foreach( $taxonomies as $name => $taxonomy ) {
		if( 'post_format' == $name )
			$taxonomy->labels->singular_name = __( 'Post Format', 'enlightenment' );
		$queries[$name] = array(
			'name' => $taxonomy->labels->singular_name,
			'args' => array( $name => null ),
		);
	}
	return apply_filters( 'enlightenment_custom_taxonomies', $queries );
}

add_action( 'wp_ajax_enlightenment_ajax_get_post_types', 'enlightenment_ajax_get_post_types' );

function enlightenment_ajax_get_post_types() {
	echo enlightenment_open_tag( 'p', 'post-type show' );
	$posts = get_posts( array(
		'post_type' => esc_attr( $_POST['post_type'] ),
		'posts_per_page' => -1,
	) );
	$options = array();
	foreach ( $posts as $post )
		$options[$post->ID] = get_the_title( $post->ID );
	enlightenment_select_box( array(
		'label' => __( 'Post:', 'enlightenment' ),
		'name' => $_POST['name'],
		'class' => 'widefat',
		'id' => $_POST['id'],
		'options' => $options,
		'value' => $_POST['value'],
	) );
	echo enlightenment_close_tag( 'p' );
	die();
}

add_action( 'wp_ajax_enlightenment_ajax_get_terms', 'enlightenment_ajax_get_terms' );

function enlightenment_ajax_get_terms() {
	echo enlightenment_open_tag( 'p', 'term show' );
	$terms = get_terms( esc_attr( $_POST['taxonomy'] ) );
	$options = array();
	foreach ( $terms as $term )
		$options[$term->slug] = $term->name;
	enlightenment_select_box( array(
		'label' => __( 'Term:', 'enlightenment' ),
		'name' => $_POST['name'],
		'class' => 'widefat',
		'id' => $_POST['id'],
		'options' => $options,
		'value' => $_POST['value'],
	) );
	echo enlightenment_close_tag( 'p' );
	die();
}

add_action( 'enlightenment_before_custom_loop', 'enlightenment_custom_query_widget_hooks' );

function enlightenment_custom_query_widget_hooks( $query_name ) {
	if( 0 === strpos( $query_name, 'custom_query_widget_' ) ) {
		global $enlightenment_custom_widget_instance, $enlightenment_custom_lead_posts;

		if( current_theme_supports( 'enlightenment-bootstrap' ) && current_theme_supports( 'enlightenment-grid-loop' ) ) {
			global $enlightenment_custom_grid;
			$grid = enlightenment_get_grid( $enlightenment_custom_grid );
			if( 1 < $grid['content_columns'] && 'slider' != $enlightenment_custom_widget_instance['type'] && 'carousel' != $enlightenment_custom_widget_instance['type'] ) {
				add_action( 'enlightenment_custom_before_entries_list', 'enlightenment_open_row' );
				add_action( 'enlightenment_custom_after_entries_list', 'enlightenment_close_container' );
			}
		}
		if( 'slider' == $enlightenment_custom_widget_instance['type'] || 'carousel' == $enlightenment_custom_widget_instance['type'] ) {
			add_action( 'enlightenment_custom_before_entries_list', 'enlightenment_open_slides_container' );
			add_action( 'enlightenment_custom_after_entries_list', 'enlightenment_close_slides_container' );
		}
		add_filter( 'enlightenment_custom_post_class', 'enlightenment_custom_query_widget_post_class' );
		for( $i = 1; $i <= $enlightenment_custom_lead_posts; $i++) {
			add_filter( 'enlightenment_custom_post_class-count-' . $i, 'enlightenment_custom_query_widget_lead_post_class' );
		}
		for($i; $i <= $enlightenment_custom_widget_instance['posts_per_page']; $i++) {
			remove_filter( 'enlightenment_custom_post_class-count-' . $i, 'enlightenment_custom_query_widget_lead_post_class' );
		}
		if( 'gallery' == $enlightenment_custom_widget_instance['query'] ) {
			add_filter( 'enlightenment_custom_query_widget_image_size', 'enlightenment_custom_query_post_thumbnail_size' );
			add_action( 'enlightenment_custom_entry_content', 'enlightenment_custom_query_widget_image_link' );
		} else {
			if( 'custom_query_widget_list' == $query_name ) {
				if( 'page' != $enlightenment_custom_widget_instance['query'] && 'pages' != $enlightenment_custom_widget_instance['query'] ) {
					add_filter( 'post_thumbnail_size', 'enlightenment_custom_query_post_thumbnail_size' );
					add_action( 'enlightenment_custom_entry_header', 'the_post_thumbnail' );
					add_action( 'enlightenment_custom_entry_header', 'the_title', 10, 2 );
				}
				add_action( 'enlightenment_custom_before_entry', 'enlightenment_custom_query_widget_add_meta' );
				add_action( 'enlightenment_custom_entry_meta', 'the_time' );
				if( 'post_type' == $enlightenment_custom_widget_instance['query'] || 'page' == $enlightenment_custom_widget_instance['query'] || 'pages' == $enlightenment_custom_widget_instance['query'] )
					add_action( 'enlightenment_custom_entry_content', 'the_content' );
				else
					add_action( 'enlightenment_custom_entry_content', 'the_excerpt' );
				add_action( 'enlightenment_custom_before_entry', 'enlightenment_custom_query_widget_content_switcher' );
			} elseif( 'custom_query_widget_slider' == $query_name ) {
				add_action( 'enlightenment_custom_before_entry_header', 'enlightenment_custom_query_widget_open_slide_container' );
				if( 'page' != $enlightenment_custom_widget_instance['query'] && 'pages' != $enlightenment_custom_widget_instance['query'] )
					add_action( 'enlightenment_custom_entry_header', 'the_title', 10, 2 );
				add_action( 'enlightenment_custom_entry_meta', 'the_time' );
				if( 'post_type' == $enlightenment_custom_widget_instance['query'] || 'page' == $enlightenment_custom_widget_instance['query'] || 'pages' == $enlightenment_custom_widget_instance['query'] )
					add_action( 'enlightenment_custom_entry_content', 'the_content' );
				add_action( 'enlightenment_custom_after_entry_content', 'enlightenment_close_container' );
			} elseif( 'custom_query_widget_carousel' == $query_name ) {
				add_action( 'enlightenment_custom_entry_header', 'the_post_thumbnail' );
			}
		}
		add_action( 'enlightenment_custom_after_entry_content', 'enlightenment_clearfix' );
		
	}
}

add_filter( 'enlightenment_custom_post_extra_atts', 'enlightenment_custom_query_add_slider_background_image' );

function enlightenment_custom_query_add_slider_background_image( $atts ) {
	global $enlightenment_custom_widget_instance;
	if( 'slider' == $enlightenment_custom_widget_instance['type'] && has_post_thumbnail() ) {
		$thumbnail = wp_get_attachment_image_src( get_post_thumbnail_id(), 'full' );
		$atts .= sprintf( ' style="background-image: url(%s);"', $thumbnail[0] );
	}
	
	return $atts;
}

add_action( 'enlightenment_after_custom_loop', 'enlightenment_custom_query_remove_thumbnail_size' );

function enlightenment_custom_query_remove_thumbnail_size() {
	remove_filter( 'post_thumbnail_size', 'enlightenment_custom_query_post_thumbnail_size' );
	remove_filter( 'enlightenment_custom_query_widget_image_size', 'enlightenment_custom_query_post_thumbnail_size' );
}

function enlightenment_custom_query_post_thumbnail_size( $size ) {
	global $enlightenment_custom_widget_instance, $enlightenment_custom_lead_posts, $enlightenment_custom_post_counter;
	if( 'list' == $enlightenment_custom_widget_instance['type'] || 'gallery' == $enlightenment_custom_widget_instance['type'] ) {
		if( $enlightenment_custom_post_counter > $enlightenment_custom_lead_posts ) {
			return 'enlightenment-custom-query-small-thumb';
		}
	}
	
	return $size;
}

add_action( 'init', 'enlightenment_custom_query_add_post_thumbnail_sizes' );

function enlightenment_custom_query_add_post_thumbnail_sizes() {
	add_image_size( 'enlightenment-custom-query-small-thumb', 75, 75, 1 );
}

add_action( 'wp_enqueue_scripts', 'enlightenment_enqueue_flexslider_style' );

function enlightenment_enqueue_flexslider_style() {
	if( is_active_widget( false, false, 'enlightenment-custom-query' ) ) {
		wp_enqueue_style( 'flexslider' );
	}
}

add_action( 'wp_enqueue_scripts', 'enlightenment_enqueue_flexslider_script' );

function enlightenment_enqueue_flexslider_script() {
	if( is_active_widget( false, false, 'enlightenment-custom-query' ) ) {
		wp_enqueue_script( 'flexslider' );
		$args = array(
			'selector'       => '.custom-query-slider',
			'controlNav'     => false,
			'fadeFirstSlide' => false,
		);
		wp_localize_script( 'flexslider', 'enlightenment_slider_args', $args );
		$args = array(
			'selector'      => '.custom-query-carousel',
			'controlNav'    => false,
			'animation'     => 'slide',
			'animationLoop' => false,
			'slideshow'     => false,
			'itemWidth'     => 155,
			'itemMargin'    => 30,
			'minItems'      => 6,
			'maxItems'      => 6,
			'move'          => 1,
		);
		wp_localize_script( 'flexslider', 'enlightenment_carousel_args', $args );
	}
}

add_filter( 'enlightenment_call_js', 'enlightenment_call_flexslider_script' );

function enlightenment_call_flexslider_script( $deps ) {
	if( is_active_widget( false, false, 'enlightenment-custom-query' ) )
		$deps[] = 'flexslider';
	
	return $deps;
}

function enlightenment_open_slides_container() {
	echo enlightenment_open_tag( 'ul', 'slides' );
}

function enlightenment_close_slides_container() {
	echo enlightenment_close_tag( 'ul' );
}

function enlightenment_custom_query_widget_open_slide_container() {
	echo enlightenment_open_tag( 'div', 'slide-container' );
}

add_action( 'enlightenment_before_custom_loop', 'enlightenment_custom_query_slider_add_parallax_background', 1 );

function enlightenment_custom_query_slider_add_parallax_background( $query_name ) {
	if( 'custom_query_widget_slider' == $query_name ) {
		add_action( 'enlightenment_custom_before_entry_header', 'enlightenment_custom_query_slider_parallax_background' );
	}
}

add_action( 'enlightenment_after_custom_loop', 'enlightenment_custom_query_slider_remove_parallax_background', 999 );

function enlightenment_custom_query_slider_remove_parallax_background( $query_name ) {
	if( 'custom_query_widget_slider' == $query_name ) {
		remove_action( 'enlightenment_custom_before_entry_header', 'enlightenment_custom_query_slider_parallax_background' );
	}
}

function enlightenment_custom_query_slider_parallax_background() {
	global $enlightenment_custom_widget_instance;
	$atts = '';
	if( 'slider' == $enlightenment_custom_widget_instance['type'] && has_post_thumbnail() ) {
		$thumbnail = wp_get_attachment_image_src( get_post_thumbnail_id(), 'full' );
		$atts .= sprintf( ' style="background-image: url(%s);"', $thumbnail[0] );
	}
	echo enlightenment_open_tag( 'div', 'background-parallax', '', $atts );
	echo enlightenment_close_tag();
}

function enlightenment_custom_query_widget_post_class( $class ) {
	global $enlightenment_custom_widget_instance;
	if( 'slider' == $enlightenment_custom_widget_instance['type'] || 'carousel' == $enlightenment_custom_widget_instance['type'] ) {
		$class .= ' custom-entry-lead';
	}
	elseif( current_theme_supports( 'enlightenment-grid-loop' ) ) {
		global $enlightenment_custom_grid;
		$grid = enlightenment_get_grid( $enlightenment_custom_grid );
		$class .= ' ' . $grid['entry_class'];
	}
	if( current_theme_supports( 'post-thumbnails' ) && has_post_thumbnail() )
		$class .= ' custom-entry-has-thumbnail';
	
	$class .= ' custom-post-type-' . get_post_type();
	return $class;
}

function enlightenment_custom_query_widget_lead_post_class( $class ) {
	global $enlightenment_custom_post_counter;
	$class .= ' custom-entry-lead';
	return $class;
}

function enlightenment_custom_query_widget_image_link() {
	$post = get_post( get_the_ID() );
	if( 'attachment' != $post->post_type )
		return;
	
	$size = apply_filters( 'enlightenment_custom_query_widget_image_size', 'full' );
	echo wp_get_attachment_link( get_the_ID(), $size );
}

function enlightenment_custom_query_widget_add_meta() {
	global $post;
	if( 'post' == $post->post_type )
		add_action( 'enlightenment_custom_entry_header', 'enlightenment_custom_entry_meta' );
}

function enlightenment_custom_query_widget_content_switcher() {
	global $enlightenment_custom_widget_instance, $enlightenment_custom_query_name, $enlightenment_custom_post_counter;
	if( 'custom_query_widget_list' == $enlightenment_custom_query_name ) {
		if( $enlightenment_custom_post_counter > enlightenment_custom_query_widget_lead_posts() ) {
			if( 'pages' == $enlightenment_custom_widget_instance['query'] ) {
				remove_action( 'enlightenment_custom_entry_content', 'the_content' );
				add_action( 'enlightenment_custom_entry_content', 'the_excerpt' );
			} else
				remove_action( 'enlightenment_custom_entry_content', 'the_excerpt' );
		}
	}
}

add_filter( 'excerpt_length', 'enlightenment_custom_query_widget_excerpt_length' );

function enlightenment_custom_query_widget_excerpt_length( $length ) {
	global $enlightenment_custom_query_name;
	if( isset( $enlightenment_custom_query_name ) && 'custom_query_widget_list' == $enlightenment_custom_query_name ) {
		return apply_filters( 'enlightenment_custom_query_widget_excerpt_length', 24 );
	}
	return $length;
}

function enlightenment_custom_query_widget_lead_posts() {
	global $enlightenment_custom_lead_posts;
	if( isset( $enlightenment_custom_lead_posts ) )
		return $enlightenment_custom_lead_posts;
	return false;
}

add_filter( 'enlightenment_custom_query_widget_tagline', 'wpautop' );
add_filter( 'enlightenment_custom_query_widget_tagline', 'do_shortcode' );

class Enlightenment_Custom_Query extends WP_Widget {

	/**
	 * Register widget with WordPress.
	 */
	public function __construct() {
		parent::__construct(
			'enlightenment-custom-query', // Base ID
			__('Custom Query', 'enlightenment'), // Name
			array( 'description' => __( 'Display a custom query of content', 'enlightenment' ), ) // Args
		);
	}

	/**
	 * Front-end display of widget.
	 *
	 * @see WP_Widget::widget()
	 *
	 * @param array $args     Widget arguments.
	 * @param array $instance Saved values from database.
	 */
	public function widget( $args, $instance ) {
		$title = apply_filters( 'widget_title', $instance['title'] );
		$tagline = apply_filters( 'enlightenment_custom_query_widget_tagline', $instance['tagline'] );

		echo $args['before_widget'];
		if ( ! empty( $title ) )
			echo $args['before_title'] . $title . $args['after_title'];
		if ( ! empty( $tagline ) )
			echo enlightenment_open_tag( 'div', 'tagline' ) . wpautop( $tagline ) . enlightenment_close_tag( 'div' );
		$query = array();
		if( 'sticky_posts' == $instance['query'] ) {
			$query['post__in'] = get_option( 'sticky_posts' );
		} elseif( 'post_type_archive' == $instance['query'] ) {
			$query['post_type'] = $instance['post_type'];
			$query['posts_per_page'] = $instance['posts_per_page'];
		} elseif( 'post_type' == $instance['query'] ) {
			$query['post_type'] = $instance['post_type'];
			$query['p'] = $instance['p'];
		} elseif( 'page' == $instance['query'] ) {
			$query['post_type'] = 'page';
			$query['page_id'] = $instance['page_id'];
		} elseif( 'pages' == $instance['query'] ) {
			$query['post_type'] = 'page';
			$query['post__in'] = $instance['pages'];
			$query['posts_per_page'] = -1;
		} elseif( 'gallery' == $instance['query'] ) {
			$query['post_type'] = 'attachment';
			$query['post_mime_type'] = 'image';
			$query['post__in'] = $instance['images'];
			$query['post_status'] = 'inherit';
			$query['posts_per_page'] = -1;
		} elseif( 'author' == $instance['query'] ) {
			$query['author'] = $instance['author'];
			$query['posts_per_page'] = $instance['posts_per_page'];
		} elseif( 'taxonomy' == $instance['query'] ) {
			if( 'category' == $instance['taxonomy'] )
				$instance['taxonomy'] = 'category_name';
			elseif( 'post_tag' == $instance['taxonomy'] )
				$instance['taxonomy'] = 'tag';
			$query[$instance['taxonomy']] = $instance['term'];
			$query['posts_per_page'] = $instance['posts_per_page'];
		}
		$query['ignore_sticky_posts'] = true;
		global $enlightenment_custom_widget_instance, $enlightenment_custom_lead_posts, $enlightenment_custom_grid;
		$enlightenment_custom_widget_instance = $instance;
		$enlightenment_custom_lead_posts = $instance['leading_posts'];
		$enlightenment_custom_grid = $instance['grid'];
		echo enlightenment_open_tag( 'div', 'custom-query-' . $instance['type'] . ' custom-query-' . $instance['query'] . ( 'slider' == $instance['type'] || 'carousel' == $instance['type'] ? ' flexslider' : '' ) );
		$loop_args = array(
			'query_name' => 'custom_query_widget_' . $instance['type'],
			'query_args' => $query,
			'container_class' => 'custom-entry',
		);
		if( 'slider' == $instance['type'] || 'carousel' == $instance['type'] ) {
			$loop_args['container'] = 'li';
			$loop_args['container_class'] .= ' slide';
		}
		echo enlightenment_custom_loop( $loop_args );
		enlightenment_clearfix();
		echo enlightenment_close_tag( 'div' );
		unset( $GLOBALS['enlightenment_custom_widget_instance'] );
		unset( $GLOBALS['enlightenment_custom_lead_posts'] );
		unset( $GLOBALS['enlightenment_custom_grid'] );
		if( $instance['link_to_archive'] ) {
			if( 'post_type_archive' == $instance['query'] ) {
				if( 'post' == $instance['post_type'] ) {
					if( 'posts' == get_option( 'show_on_front' ) )
						$link = home_url( '/' );
					else
						$link = get_permalink( get_option( 'page_for_posts' ) );
				} else
					$link = get_post_type_archive_link( $instance['post_type'] );
			} elseif( 'author' == $instance['query'] ) {
				$link = get_author_posts_url( $instance['author'] );
			} elseif( 'taxonomy' == $instance['query'] ) {
				$link = get_term_link( $instance['term'], $instance['taxonomy'] );
			}
			if( isset( $link ) )
				echo '<a class="custom-archive-permalink" href="' . esc_url( $link ) . '">' . esc_attr( $instance['link_to_archive_label'] ) . '</a>';
		}
		echo $args['after_widget'];
	}

	/**
	 * Back-end widget form.
	 *
	 * @see WP_Widget::form()
	 *
	 * @param array $instance Previously saved values from database.
	 */
	public function form( $instance ) {
		$defaults = array(
			'title' => '',
			'tagline' => '',
			'type' => 'list',
			'grid' => 'onecol',
			'query' => 'sticky_posts',
			'post_type' => 'post',
			'p' => null,
			'page_id' => null,
			'pages' => array(),
			'images' => array(),
			'author' => null,
			'taxonomy' => 'category',
			'term' => null,
			'posts_per_page' => 5,
			'leading_posts' => 1,
			'link_to_archive' => false,
			'link_to_archive_label' => __( 'See all posts &rarr;', 'enlightenment' ),

		);
		$instance = wp_parse_args( $instance, $defaults );

		echo enlightenment_open_tag( 'p' );
		enlightenment_text_input( array(
			'label' => __( 'Title:', 'enlightenment' ),
			'name' => $this->get_field_name( 'title' ),
			'class' => 'widefat',
			'id' => $this->get_field_id( 'title' ),
			'value' => $instance['title'],
		) );
		echo enlightenment_close_tag( 'p' );

		echo enlightenment_open_tag( 'p' );
		enlightenment_textarea( array(
			'label' => __( 'Tagline:', 'enlightenment' ),
			'name' => $this->get_field_name( 'tagline' ),
			'class' => 'widefat',
			'id' => $this->get_field_id( 'tagline' ),
			'value' => $instance['tagline'],
		) );
		echo enlightenment_close_tag( 'p' );

		echo enlightenment_open_tag( 'p', 'type' );
		$options = array(
			'list' => __( 'List', 'enlightenment' ),
			'gallery' => __( 'Gallery', 'enlightenment' ),
			'slider' => __( 'Slider', 'enlightenment' ),
			'carousel' => __( 'Carousel', 'enlightenment' ),
		);
		enlightenment_select_box( array(
			'label' => __( 'Type:', 'enlightenment' ),
			'name' => $this->get_field_name( 'type' ),
			'class' => 'widefat',
			'id' => $this->get_field_id( 'type' ),
			'options' => $options,
			'value' => $instance['type'],
		) );
		echo enlightenment_close_tag( 'p' );

		if( current_theme_supports( 'enlightenment-grid-loop' ) ) {
			echo enlightenment_open_tag( 'p', 'grid' );
			$options = array();
			foreach( enlightenment_grid_columns() as $grid => $atts )
				$options[$grid] = $atts['name'];
			enlightenment_select_box( array(
				'label' => __( 'Grid:', 'enlightenment' ),
				'name' => $this->get_field_name( 'grid' ),
				'class' => 'widefat',
				'id' => $this->get_field_id( 'grid' ),
				'options' => $options,
				'value' => $instance['grid'],
			) );
			echo enlightenment_close_tag( 'p' );
		}

		echo enlightenment_open_tag( 'p', 'query' );
		$queries = enlightenment_custom_queries();
		$options = array();
		foreach ( $queries as $query => $atts )
			$options[$query] = $atts['name'];
		enlightenment_select_box( array(
			'label' => __( 'Query:', 'enlightenment' ),
			'name' => $this->get_field_name( 'query' ),
			'class' => 'widefat',
			'id' => $this->get_field_id( 'query' ),
			'options' => $options,
			'value' => $instance['query'],
		) );
		echo enlightenment_close_tag( 'p' );

		echo enlightenment_open_tag( 'p', 'post-types' . ( 'post_type_archive' == $instance['query'] || 'post_type' == $instance['query'] ? ' show' : '' ) );
		$options = array();
		$post_types = enlightenment_custom_post_types();
		foreach ( $post_types as $post_type => $atts )
			$options[$post_type] = $atts['name'];
		enlightenment_select_box( array(
			'label' => __( 'Post Type:', 'enlightenment' ),
			'name' => $this->get_field_name( 'post_type' ),
			'class' => 'widefat',
			'id' => $this->get_field_id( 'post_type' ),
			'options' => $options,
			'value' => $instance['post_type'],
		) );
		echo enlightenment_close_tag( 'p' );

		echo enlightenment_open_tag( 'p', 'post-type' . ( 'post_type' == $instance['query'] ? ' show' : '' ) );
		$posts = get_posts( array(
			'post_type' => esc_attr( $instance['post_type'] ),
			'posts_per_page' => -1,
		) );
		$options = array();
		foreach ( $posts as $post )
			$options[$post->ID] = get_the_title( $post->ID );
		enlightenment_select_box( array(
			'label' => __( 'Post:', 'enlightenment' ),
			'name' => $this->get_field_name( 'p' ),
			'class' => 'widefat',
			'id' => $this->get_field_id( 'p' ),
			'options' => $options,
			'value' => $instance['p'],
		) );
		echo enlightenment_close_tag( 'p' );

		echo enlightenment_open_tag( 'p', 'page' . ( 'page' == $instance['query'] ? ' show' : '' ) );
		$posts = get_posts( array(
			'posts_per_page' => -1,
			'post_type' => 'page',
		) );
		$options = array();
		foreach ( $posts as $post )
			$options[$post->ID] = get_the_title( $post->ID );
		enlightenment_select_box( array(
			'label' => __( 'Page:', 'enlightenment' ),
			'name' => $this->get_field_name( 'page_id' ),
			'class' => 'widefat',
			'id' => $this->get_field_id( 'page_id' ),
			'options' => $options,
			'value' => $instance['page_id'],
		) );
		echo enlightenment_close_tag( 'p' );

		echo enlightenment_open_tag( 'div', 'pages' . ( 'pages' == $instance['query'] ? ' show' : '' ) );
		$posts = get_posts( array(
			'posts_per_page' => -1,
			'post_type' => 'page',
		) );
		$boxes = array();
		$i = 0;
		foreach ( $posts as $post ) {
			$boxes[$i] = array();
			$boxes[$i]['label'] = get_the_title( $post->ID );
			$boxes[$i]['name'] = $this->get_field_name( 'pages' ) . '[' . $post->ID . ']';
			$boxes[$i]['checked'] = in_array( $post->ID, $instance['pages'] );
			$i++;
		}
		echo '<label>' . __( 'Select Pages:', 'enlightenment' ) . '</label><br />';
		echo enlightenment_open_tag( 'div', 'pages-inner' );
		enlightenment_checkboxes( array(
			'boxes' => $boxes,
			'value' => $instance['p'],
		) );
		echo enlightenment_close_tag( 'div' );
		echo enlightenment_close_tag( 'div' );

		echo enlightenment_open_tag( 'p', 'image-gallery' . ( 'gallery' == $instance['query'] ? ' show' : '' ) );
		enlightenment_upload_media( array(
			'name' => $this->get_field_name( 'images' ),
			'upload_button_text' => __( 'Choose Images', 'enlightenment' ),
			'uploader_title' => __( 'Insert Images', 'enlightenment' ),
			'uploader_button_text' => __( 'Select', 'enlightenment' ),
			'remove_button_text' => '',
			'mime_type' => 'image',
			'multiple' => true,
			'thumbnail' => null,
			'value' => implode( ',', $instance['images'] ),
		) );
		echo enlightenment_close_tag( 'p' );

		echo enlightenment_open_tag( 'p', 'author' . ( 'author' == $instance['query'] ? ' show' : '' ) );
		$authors = get_users( array(
			'who' => 'authors',
		) );
		$options = array();
		foreach ( $authors as $author )
			$options[$author->ID] = $author->display_name;
		enlightenment_select_box( array(
			'label' => __( 'Select Author:', 'enlightenment' ),
			'name' => $this->get_field_name( 'author' ),
			'class' => 'widefat',
			'id' => $this->get_field_id( 'author' ),
			'options' => $options,
			'value' => $instance['author'],
		) );
		echo enlightenment_close_tag( 'p' );
		
		echo enlightenment_open_tag( 'p', 'taxonomy' . ( 'taxonomy' == $instance['query'] ? ' show' : '' ) );
		$taxonomies = get_taxonomies( array( 'public' => true ), 'objects' );
		$options = array();
		foreach ( $taxonomies as $name => $taxonomy ) {
			if( 'post_format' == $name )
				$taxonomy->labels->singular_name = __( 'Post Format', 'enlightenment' );
			$options[$name] = $taxonomy->labels->singular_name;
		}
		enlightenment_select_box( array(
			'label' => __( 'Taxonomy:', 'enlightenment' ),
			'name' => $this->get_field_name( 'taxonomy' ),
			'class' => 'widefat',
			'id' => $this->get_field_id( 'taxonomy' ),
			'options' => $options,
			'value' => $instance['taxonomy'],
		) );
		echo enlightenment_close_tag( 'p' );
		
		echo enlightenment_open_tag( 'p', 'term' . ( 'taxonomy' == $instance['query'] ? ' show' : '' ) );
		$terms = get_terms( $instance['taxonomy'] );
		$options = array();
		foreach ( $terms as $term )
			$options[$term->slug] = $term->name;
		enlightenment_select_box( array(
			'label' => __( 'Term:', 'enlightenment' ),
			'name' => $this->get_field_name( 'term' ),
			'class' => 'widefat',
			'id' => $this->get_field_id( 'term' ),
			'options' => $options,
			'value' => $instance['term'],
		) );
		echo enlightenment_close_tag( 'p' );

		echo enlightenment_open_tag( 'p', 'posts-count' . ( 'post_type_archive' == $instance['query'] || 'author' == $instance['query'] || 'taxonomy' == $instance['query'] ? ' show' : '' ) );
		enlightenment_text_input( array(
			'label' => __( 'Total number of entries:', 'enlightenment' ),
			'name' => $this->get_field_name( 'posts_per_page' ),
			'id' => $this->get_field_id( 'posts_per_page' ),
			'value' => $instance['posts_per_page'],
			'size' => 3,
		) );
		echo enlightenment_close_tag( 'p' );

		echo enlightenment_open_tag( 'p', 'lead-posts' . ( ( 'slider' != $instance['type'] && 'carousel' != $instance['type'] ) && ( 'sticky_posts' == $instance['query'] || 'post_type_archive' == $instance['query'] || 'pages' == $instance['query'] || 'gallery' == $instance['query'] || 'author' == $instance['query'] || 'taxonomy' == $instance['query'] ) ? ' show' : '' ) );
		enlightenment_text_input( array(
			'label' => __( 'Number of leading entries:', 'enlightenment' ),
			'name' => $this->get_field_name( 'leading_posts' ),
			'id' => $this->get_field_id( 'leading_posts' ),
			'value' => $instance['leading_posts'],
			'size' => 3,
		) );
		echo enlightenment_close_tag( 'p' );

		echo enlightenment_open_tag( 'p', 'archive-link' . ( 'post_type_archive' == $instance['query'] || 'author' == $instance['query'] || 'taxonomy' == $instance['query'] ? ' show' : '' ) );
		enlightenment_checkbox( array(
			'label' => __( 'Show Link to Archive', 'enlightenment' ),
			'name' => $this->get_field_name( 'link_to_archive' ),
			'id' => $this->get_field_id( 'link_to_archive' ),
			'checked' => $instance['link_to_archive'],
		) );
		echo enlightenment_close_tag( 'p' );

		echo enlightenment_open_tag( 'p', 'archive-link-label' . ( ( 'post_type_archive' == $instance['query'] || 'author' == $instance['query'] || 'taxonomy' == $instance['query'] ) && $instance['link_to_archive'] ? ' show' : '' ) );
		enlightenment_text_input( array(
			'label' => __( 'Link to Archive Label:', 'enlightenment' ),
			'name' => $this->get_field_name( 'link_to_archive_label' ),
			'class' => 'widefat',
			'id' => $this->get_field_id( 'link_to_archive_label' ),
			'value' => $instance['link_to_archive_label'],
		) );
		echo enlightenment_close_tag( 'p' );
		?>
		<script>
			jQuery(document).ready(function($) {
				$('.type select').change(function() {
					var container = $(this).closest('.widget-content');
					var val = $(this).val();
					if(val == 'slider' || val == 'carousel')
						$('.lead-posts', container).hide();
					else {
						var query = $('.query select', container).val();
						if(query == 'post_type' || query == 'page')
							$('.lead-posts', container).hide();
						else
							$('.lead-posts', container).show();
					}
				});
				$('.query select').change(function() {
					var container = $(this).closest('.widget-content');
					var val = $(this).val();
					var type = $('.type select', container).val();
					if(val == 'sticky_posts') {
						$('.post-types', container).hide();
						$('.post-type', container).hide();
						$('.page', container).hide();
						$('.pages', container).hide();
						$('.image-gallery', container).hide();
						$('.author', container).hide();
						$('.taxonomy', container).hide();
						$('.term', container).hide();
						$('.posts-count', container).hide();
						if(type != 'slider' && type != 'carousel')
							$('.lead-posts', container).show();
						$('.archive-link', container).hide();
						$('.archive-link-label', container).hide();
					} else if(val == 'post_type_archive') {
						$('.post-types', container).show();
						$('.post-type', container).hide();
						$('.page', container).hide();
						$('.pages', container).hide();
						$('.image-gallery', container).hide();
						$('.author', container).hide();
						$('.taxonomy', container).hide();
						$('.term', container).hide();
						$('.posts-count', container).show();
						if(type != 'slider' && type != 'carousel')
							$('.lead-posts', container).show();
						$('.archive-link', container).show();
						if($('.archive-link', container).is(':checked'))
							$('.archive-link-label', container).show();
					} else if(val == 'post_type') {
						$('.post-types', container).show();
						$('.post-type', container).show();
						$('.page', container).hide();
						$('.pages', container).hide();
						$('.image-gallery', container).hide();
						$('.author', container).hide();
						$('.taxonomy', container).hide();
						$('.term', container).hide();
						$('.posts-count', container).hide();
						$('.lead-posts', container).hide();
						$('.archive-link', container).hide();
						$('.archive-link-label', container).hide();
					} else if(val == 'page') {
						$('.post-types', container).hide();
						$('.post-type', container).hide();
						$('.page', container).show();
						$('.pages', container).hide();
						$('.image-gallery', container).hide();
						$('.author', container).hide();
						$('.taxonomy', container).hide();
						$('.term', container).hide();
						$('.posts-count', container).hide();
						$('.lead-posts', container).hide();
						$('.archive-link', container).hide();
						$('.archive-link-label', container).hide();
					} else if(val == 'pages') {
						$('.post-types', container).hide();
						$('.post-type', container).hide();
						$('.page', container).hide();
						$('.pages', container).show();
						$('.image-gallery', container).hide();
						$('.author', container).hide();
						$('.taxonomy', container).hide();
						$('.term', container).hide();
						$('.posts-count', container).hide();
						if(type != 'slider' && type != 'carousel')
							$('.lead-posts', container).show();
						$('.archive-link', container).hide();
						$('.archive-link-label', container).hide();
					} else if(val == 'gallery') {
						$('.post-types', container).hide();
						$('.post-type', container).hide();
						$('.page', container).hide();
						$('.pages', container).hide();
						$('.image-gallery', container).show();
						$('.author', container).hide();
						$('.taxonomy', container).hide();
						$('.term', container).hide();
						$('.posts-count', container).hide();
						if(type != 'slider' && type != 'carousel')
							$('.lead-posts', container).show();
						$('.archive-link', container).hide();
						$('.archive-link-label', container).hide();
					} else if(val == 'author') {
						$('.post-types', container).hide();
						$('.post-type', container).hide();
						$('.page', container).hide();
						$('.pages', container).hide();
						$('.image-gallery', container).hide();
						$('.author', container).show();
						$('.taxonomy', container).hide();
						$('.term', container).hide();
						$('.posts-count', container).show();
						if(type != 'slider' && type != 'carousel')
							$('.lead-posts', container).show();
						$('.archive-link', container).show();
						if($('.archive-link', container).is(':checked'))
							$('.archive-link-label', container).show();
					} else if(val == 'taxonomy') {
						$('.post-types', container).hide();
						$('.post-type', container).hide();
						$('.page', container).hide();
						$('.pages', container).hide();
						$('.image-gallery', container).hide();
						$('.author', container).hide();
						$('.taxonomy', container).show();
						$('.term', container).show();
						$('.posts-count', container).show();
						if(type != 'slider' && type != 'carousel')
							$('.lead-posts', container).show();
						$('.archive-link', container).show();
						if($('.archive-link', container).is(':checked'))
							$('.archive-link-label', container).show();
					}
				});
				$('.post-types select').change(function() {
					var container = $(this).closest('.widget-content');
					var data = {
						action: 'enlightenment_ajax_get_post_types',
						post_type: $('.post-types select', container).val(),
						name: '<?php echo $this->get_field_name( 'p' ); ?>',
						id: '<?php echo $this->get_field_id( 'p' ); ?>',
						value: '<?php echo $instance['p']; ?>',
					}
					$.post(ajaxurl, data, function(r) {
						var html = document.createElement( 'div' );
						$(html).html(r);
						$('.post-type select', container).html($('select', $(html)).html());
					});
				});
				$('.taxonomy select').change(function() {
					var container = $(this).closest('.widget-content');
					var data = {
						action: 'enlightenment_ajax_get_terms',
						taxonomy: $('.taxonomy select', container).val(),
						name: '<?php echo $this->get_field_name( 'term' ); ?>',
						id: '<?php echo $this->get_field_id( 'term' ); ?>',
						value: '<?php echo $instance['term']; ?>',
					}
					$.post(ajaxurl, data, function(r) {
						var html = document.createElement( 'div' );
						$(html).html(r);
						$('.term', container).remove();
						$('.taxonomy', container).after($(html).html());
					});
				});
				$('.archive-link input').each(function() {
					var container = $(this).closest('.widget-content');
					var query = $('.query select', container).val();
					if( query == 'post_type_archive' || query == 'author' || query == 'taxonomy' ) {
						if($(this).is(':checked'))
							$('.archive-link-label', container).show();
						else
							$('.archive-link-label', container).hide();
					}
				});
				$('.archive-link input').change(function() {
					var container = $(this).closest('.widget-content');
					if($(this).is(':checked'))
						$('.archive-link-label', container).show();
					else
						$('.archive-link-label', container).hide();
				});
			});
		</script>
		<?php
	}

	/**
	 * Sanitize widget form values as they are saved.
	 *
	 * @see WP_Widget::update()
	 *
	 * @param array $new_instance Values just sent to be saved.
	 * @param array $old_instance Previously saved values from database.
	 *
	 * @return array Updated safe values to be saved.
	 */
	public function update( $new_instance, $old_instance ) {
		$instance = array();
		$instance['title'] = ! empty( $new_instance['title'] ) ? strip_tags( $new_instance['title'] ) : '';
		$instance['tagline'] = ! empty( $new_instance['tagline'] ) ? strip_tags( $new_instance['tagline'], '<p><a><img>' ) : '';
		$types = array( 'list', 'gallery', 'slider', 'carousel' );
		$instance['type'] = in_array( $new_instance['type'], $types ) ? $new_instance['type'] : $old_instance['type'];
		if( current_theme_supports( 'enlightenment-grid-loop' ) )
			$instance['grid'] = array_key_exists( $new_instance['grid'], enlightenment_grid_columns() ) ? $new_instance['grid'] : $old_instance['grid'];
				$options[$grid] = $atts['name'];
		$queries = array( 'sticky_posts', 'post_type_archive', 'post_type', 'page', 'pages', 'gallery', 'author', 'taxonomy' );
		$instance['query'] = in_array( $new_instance['query'], $queries ) ? $new_instance['query'] : $old_instance['query'];
		$post_types = enlightenment_custom_post_types();
		$instance['post_type'] = array_key_exists( $new_instance['post_type'], $post_types ) ? $new_instance['post_type'] : $old_instance['post_type'];
		$post = get_post( $new_instance['p'] );
		$instance['p'] = $post->post_type == $instance['post_type'] ? $new_instance['p'] : $old_instance['p'];
		$page = get_post( $new_instance['page_id'] );
		$instance['page_id'] = 'page' == $page->post_type ? $new_instance['page_id'] : $old_instance['page_id'];
		if( empty( $new_instance['pages'] ) )
			$instance['pages'] = array();
		else {
			$post__in = array();
			foreach( $new_instance['pages'] as $post_id => $bool )
				$post__in[] = $post_id;
			$posts = get_posts( array( 'post__in' => $post__in, 'post_type' => 'page', 'posts_per_page' => -1 ) );
			$instance['pages'] = array();
			foreach ( $posts as $post )
				$instance['pages'][] = $post->ID;
		}
		if( empty( $new_instance['images'] ) )
			$instance['images'] = array();
		else {
			$post__in = explode( ',', $new_instance['images'] );
			$posts = get_posts( array( 'post__in' => $post__in, 'post_type' => 'attachment', 'post_mime_type' => 'image', 'posts_per_page' => -1, 'post_status' => 'inherit' ) );
			foreach ( $posts as $post )
				$instance['images'][] = $post->ID;
		}
		$authors = get_users( array(
			'who' => 'authors',
		) );
		$valid = false;
		foreach ( $authors as $author ) {
			if( $author->ID == $new_instance['author'] )
				$valid = true;
		}
		$instance['author'] = $valid ? $new_instance['author'] : $old_instance['author'];
		$instance['taxonomy'] = taxonomy_exists( $new_instance['taxonomy'] ) ? $new_instance['taxonomy'] : $old_instance['taxonomy'];
		$instance['term'] = term_exists( $new_instance['term'], $instance['taxonomy'] ) ? $new_instance['term'] : $old_instance['term'];
		$instance['posts_per_page'] = ! empty( $new_instance['posts_per_page'] ) ? intval( $new_instance['posts_per_page'] ) : $old_instance['posts_per_page'];
		$instance['leading_posts'] = ! empty( $new_instance['leading_posts'] ) ? intval( $new_instance['leading_posts'] ) : $old_instance['leading_posts'];
		$instance['link_to_archive'] = isset( $new_instance['link_to_archive'] );
		$instance['link_to_archive_label'] = ! empty( $new_instance['link_to_archive_label'] ) ? strip_tags( $new_instance['link_to_archive_label'] ) : '';
		return $instance;
	}

} // class Enlightenment_Custom_Query

add_action( 'widgets_init', 'enlightenment_custom_query_register_widget' );

// register Enlightenment_Custom_Query widget
function enlightenment_custom_query_register_widget() {
	register_widget( 'Enlightenment_Custom_Query' );
}