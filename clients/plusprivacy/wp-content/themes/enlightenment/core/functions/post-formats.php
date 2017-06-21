<?php

add_action( 'enlightenment_before_entry', 'enlightenment_post_format_hooks', 4 );

function enlightenment_post_format_hooks() {
	if( ! is_singular() ) {
		enightenment_clear_entry_hooks();
		if( has_post_format( 'gallery' ) ) {
			add_action( 'enlightenment_entry_header', 'the_title', 10, 2 );
			add_action( 'enlightenment_entry_header', 'enlightenment_entry_meta' );
			add_action( 'enlightenment_entry_content', 'enlightenment_entry_gallery' );
			add_action( 'enlightenment_entry_content', 'the_excerpt' );
		} elseif( has_post_format( 'image' ) ) {
			add_action( 'enlightenment_entry_header', 'the_title', 10, 2 );
			add_action( 'enlightenment_entry_header', 'enlightenment_entry_meta' );
			add_action( 'enlightenment_entry_content', 'enlightenment_entry_image' );
			add_action( 'enlightenment_entry_content', 'the_excerpt' );
		} elseif( has_post_format( 'video' ) ) {
			add_action( 'enlightenment_entry_header', 'the_title', 10, 2 );
			add_action( 'enlightenment_entry_header', 'enlightenment_entry_meta' );
			add_action( 'enlightenment_entry_content', 'enlightenment_entry_video' );
			add_action( 'enlightenment_entry_content', 'the_excerpt' );
		} elseif( has_post_format( 'audio' ) ) {
			add_action( 'enlightenment_entry_header', 'the_title', 10, 2 );
			add_action( 'enlightenment_entry_header', 'enlightenment_entry_meta' );
			add_action( 'enlightenment_entry_content', 'enlightenment_entry_audio' );
			add_action( 'enlightenment_entry_content', 'the_excerpt' );
		} elseif( has_post_format( 'aside' ) ) {
			add_action( 'enlightenment_entry_content', 'the_content' );
			add_action( 'enlightenment_entry_footer', 'enlightenment_entry_meta' );
		} elseif( has_post_format( 'link' ) ) {
			add_action( 'enlightenment_entry_header', 'the_title', 10, 2 );
			add_action( 'enlightenment_entry_header', 'enlightenment_entry_meta' );
			add_action( 'enlightenment_entry_content', 'the_excerpt' );
		} elseif( has_post_format( 'quote' ) ) {
			add_action( 'enlightenment_entry_header', 'enlightenment_entry_blockquote' );
			add_action( 'enlightenment_entry_footer', 'enlightenment_entry_meta' );
		} elseif( has_post_format( 'status' ) ) {
			add_action( 'enlightenment_entry_content', 'enlightenment_entry_author_avatar' );
			add_action( 'enlightenment_entry_content', 'the_content' );
			add_action( 'enlightenment_entry_footer', 'enlightenment_entry_meta' );
		} elseif( has_post_format( 'chat' ) ) {
			add_action( 'enlightenment_entry_header', 'the_title', 10, 2 );
			add_action( 'enlightenment_entry_header', 'enlightenment_entry_meta' );
			add_action( 'enlightenment_entry_content', 'the_content' );
		} else {
			enlightenment_lead_entry_hooks();
		}
	}
}

add_action( 'enlightenment_before_entry', 'enlightenment_teaser_post_format_hooks', 6 );

function enlightenment_teaser_post_format_hooks() {
	if( current_theme_supports( 'enlightenment-grid-loop' ) && ! enlightenment_is_lead_post() && ! is_singular() && '' != get_post_format() ) {
		enightenment_clear_entry_hooks();
		if( has_post_format( 'gallery' ) ) {
			add_action( 'enlightenment_entry_header', 'enlightenment_entry_gallery' );
			add_action( 'enlightenment_entry_header', 'the_title', 10, 2 );
			add_action( 'enlightenment_entry_footer', 'enlightenment_entry_meta' );
		} elseif( has_post_format( 'image' ) ) {
			add_action( 'enlightenment_entry_header', 'enlightenment_entry_image' );
			add_action( 'enlightenment_entry_header', 'the_title', 10, 2 );
			add_action( 'enlightenment_entry_footer', 'enlightenment_entry_meta' );
		} elseif( has_post_format( 'video' ) ) {
			add_action( 'enlightenment_entry_header', 'enlightenment_entry_video' );
			add_action( 'enlightenment_entry_header', 'the_title', 10, 2 );
			add_action( 'enlightenment_entry_footer', 'enlightenment_entry_meta' );
		} elseif( has_post_format( 'audio' ) ) {
			add_action( 'enlightenment_entry_header', 'the_post_thumbnail' );
			add_action( 'enlightenment_entry_header', 'enlightenment_entry_audio' );
			add_action( 'enlightenment_entry_header', 'the_title', 10, 2 );
			add_action( 'enlightenment_entry_footer', 'enlightenment_entry_meta' );
		} elseif( has_post_format( 'aside' ) ) {
			add_action( 'enlightenment_entry_content', 'the_content' );
			add_action( 'enlightenment_entry_footer', 'enlightenment_entry_meta' );
		} elseif( has_post_format( 'link' ) ) {
			add_action( 'enlightenment_entry_header', 'the_title', 10, 2 );
			add_action( 'enlightenment_entry_footer', 'enlightenment_entry_meta' );
		} elseif( has_post_format( 'quote' ) ) {
			add_action( 'enlightenment_entry_header', 'enlightenment_entry_blockquote' );
			add_action( 'enlightenment_entry_footer', 'enlightenment_entry_meta' );
		} elseif( has_post_format( 'status' ) ) {
			add_action( 'enlightenment_entry_content', 'enlightenment_entry_author_avatar' );
			add_action( 'enlightenment_entry_content', 'the_content' );
			add_action( 'enlightenment_entry_footer', 'enlightenment_entry_meta' );
		} elseif( has_post_format( 'chat' ) ) {
			add_action( 'enlightenment_entry_header', 'the_title', 10, 2 );
			add_action( 'enlightenment_entry_content', 'the_content' );
			add_action( 'enlightenment_entry_footer', 'enlightenment_entry_meta' );
		}
	}
}

function enlightenment_entry_gallery( $args = null ) {
	$defaults = array(
		'container' => 'div',
		'container_class' => 'entry-gallery',
		'echo' => true,
	);
	$defaults = apply_filters( 'enlightenment_entry_gallery_args', $defaults );
	$args = wp_parse_args( $args, $defaults );
	global $more;
	$more = true;
	$content = get_the_content();
	$more = false;
	$output = enlightenment_open_tag( $args['container'], $args['container_class'] );
	if( preg_match( '/\[(\[?)(gallery)(?![\w-])([^\]\/]*(?:\/(?!\])[^\]\/]*)*?)(?:(\/)\]|\](?:([^\[]*+(?:\[(?!\/\2\])[^\[]*+)*+)\[\/\2\])?)(\]?)/s', $content, $matches ) )
		$output .= do_shortcode( $matches[0] );
	$output .= enlightenment_close_tag( $args['container'] );
	$output = apply_filters( 'enlightenment_entry_gallery', $output, $args );
	if( ! $args['echo'] )
		return $output;
	echo $output;
}

function enlightenment_entry_image( $args = null ) {
	$defaults = array(
		'container' => 'figure',
		'container_class' => 'entry-media',
		'caption_tag' => 'figcaption',
		'caption_class' => 'entry-media-caption',
		'echo' => true,
	);
	$defaults = apply_filters( 'enlightenment_entry_gallery_args', $defaults );
	$args = wp_parse_args( $args, $defaults );
	$output = enlightenment_open_tag( $args['container'], $args['container_class'] );
	if( has_post_thumbnail() ) {
		$attachment = get_post( get_post_thumbnail_id() );
		$image = wp_get_attachment_image_src( get_post_thumbnail_id(), 'full' ); 
		$output .= '<a href="' . esc_url( $image[0] ) . '" title="' . the_title_attribute( array( 'echo' => false ) ) . '" rel="attachment">';
		$output .= wp_get_attachment_image( $attachment->ID, apply_filters( 'post_thumbnail_size', 'post-thumbnail' ), false );//, $attr );
		$output .= '</a>';
	} else {
		// Retrieve the last image attached to the post
		$attachments = get_posts( array(
			'numberposts' => 1,
			'post_type' => 'attachment',
			'post_mime_type' => 'image',
			'post_parent' => get_the_ID()
		) );
		if( false !== enlightenment_get_first_caption() ) {
			$output .= enlightenment_get_first_caption();
		} elseif( count( $attachments ) ) {
			$attachment = $attachments[0];
			if( isset( $attachment ) && ! post_password_required() ) {
				$image = wp_get_attachment_image_src( $attachment->ID, 'full' );
				$output .= '<a href="' . esc_url( $image[0] ) . '" title="' . the_title_attribute( array( 'echo' => false ) ) . '"  rel="attachment">';
				$output .= wp_get_attachment_image( $attachment->ID, apply_filters( 'post_thumbnail_size', 'post-thumbnail' ) );
				$output .= '</a>';
				if( '' != $attachment->post_excerpt ) {
					$output .= enlightenment_open_tag( $args['caption_tag'], $args['caption_class'] );
					$output .= $attachment->post_excerpt;
					$output .= enlightenment_close_tag( $args['caption_tag'] );
				}
			}
		} elseif( false !== enlightenment_get_first_image() ) {
			$image = enlightenment_get_first_image();
			if( false === $image[1] )
				$image[1] = 580;
			if( false === $image[2] )
				$image[2] = 360;
			$output .= '<a href="' . esc_url( $image[0] ) . '" title="' . the_title_attribute( array( 'echo' => false ) ) . '"  rel="attachment">';
			$output .= '<img src="' . esc_url( $image[0] ) . '" alt="' . the_title_attribute( array( 'echo' => false ) ) . '" width="' . esc_attr( $image[1] ) . '" height="' . esc_attr( $image[2] ) . '" />';
			$output .= '</a>';
		}
	}
	$output .= enlightenment_close_tag( $args['container'] );
	$output = apply_filters( 'enlightenment_entry_image', $output, $args );
	if( ! $args['echo'] )
		return $output;
	echo $output;
}

function enlightenment_get_first_caption() {
	$document = new DOMDocument();
	global $more;
	$more = true;
	$content = apply_filters( 'the_content', get_the_content( '', true ) );
	$more = false;
	if( '' != $content ) {
		libxml_use_internal_errors( true );
		$document->loadHTML( $content );
		libxml_clear_errors();
		$finder = new DomXPath($document);
		$classname = 'wp-caption';
		$images = $finder->query( "//*[contains(concat(' ', normalize-space(@class), ' '), ' $classname ')]" );
		for( $i = 0; $i < $images->length; $i++ ) {
			$image = $images->item($i);
			$document = new DOMDocument();
			$document->appendChild( $document->importNode( $image, true ) );
			return $document->saveHTML();
		}
	}
	return false;
}

function enlightenment_get_first_image() {
	$document = new DOMDocument();
	global $more;
	$more = true;
	$content = apply_filters( 'the_content', get_the_content( '', true ) );
	$more = false;
	if( '' != $content ) {
		libxml_use_internal_errors( true );
		$document->loadHTML( $content );
		libxml_clear_errors();
		$images = $document->getElementsByTagName( 'img' );
		$document = new DOMDocument();
		if( $images->length ) {
			$image= $images->item( $images->length - 1 );
			$src = $image->getAttribute( 'src' );
			$width = ( $image->hasAttribute( 'width' ) ? $image->getAttribute( 'width' ) : false );
			$height = ( $image->hasAttribute( 'height' ) ? $image->getAttribute( 'height' ) : false );
			return array( $src, $width, $height );
		}
	}
	return false;
}

add_filter( 'the_permalink', 'enlightenment_entry_link' );

function enlightenment_entry_link( $src ) {
	if( has_post_format( 'link' ) ) {
		$document = new DOMDocument();
		global $more;
		$more = true;
		$content = apply_filters( 'the_content', get_the_content( '', true ) );
		$more = false;
		if( '' != $content ) {
			libxml_use_internal_errors( true );
			$document->loadHTML( $content );
			libxml_clear_errors();
			$links = $document->getElementsByTagName( 'a' );
			for( $i = 0; $i < $links->length; $i++ ) {
				$link = $links->item($i);
				$document = new DOMDocument();
				$document->appendChild( $document->importNode( $link, true ) );
				$src = $link->getAttribute('href');
			}
		}
	}
	return $src;
}

function enlightenment_entry_blockquote( $args = null ) {
	$defaults = array(
		'container' => 'div',
		'container_class' => 'entry-media',
		'echo' => true,
	);
	$defaults = apply_filters( 'enlightenment_entry_blockquote_args', $defaults );
	$args = wp_parse_args( $args, $defaults );
	$output = enlightenment_open_tag( $args['container'], $args['container_class'] );
	$document = new DOMDocument();
	global $more;
	$more = true;
	$content = apply_filters( 'the_content', get_the_content( '', true ) );
	$more = false;
	if( '' != $content ) {
		libxml_use_internal_errors( true );
		$document->loadHTML( mb_convert_encoding( $content, 'html-entities', 'utf-8' ) );
		libxml_clear_errors();
		$blockquotes = $document->getElementsByTagName( 'blockquote' );
		if( ! empty( $blockquotes ) ) {
			$blockquote = $blockquotes->item(0);
			$document = new DOMDocument();
			$document->appendChild( $document->importNode( $blockquote, true ) );
			$output .= $document->saveHTML();
		}
	}
	$output .= enlightenment_close_tag( $args['container'] );
	$output = apply_filters( 'enlightenment_entry_blockquote', $output, $args );
	if( ! $args['echo'] )
		return $output;
	echo $output;
}

function enlightenment_entry_author_avatar( $args = null ) {
	$defaults = array(
		'container' => 'figure',
		'container_class' => 'entry-author',
		'archive_link' => true,
		'echo' => true,
	);
	$defaults = apply_filters( 'enlightenment_entry_blockquote_args', $defaults );
	$args = wp_parse_args( $args, $defaults );
	$output = enlightenment_open_tag( $args['container'], $args['container_class'] );
	if( $args['archive_link'] )
		$output .= '<a href="' . get_author_posts_url( get_the_author_meta( 'ID' ) ) . '">';
	$output .= get_avatar( get_the_author_meta( 'ID' ), 78 );
	if( $args['archive_link'] )
		$output .= '</a>';
	$output .= enlightenment_close_tag( $args['container'] );
	$output = apply_filters( 'enlightenment_entry_blockquote', $output, $args );
	if( ! $args['echo'] )
		return $output;
	echo $output;
}

function enlightenment_get_first_embed() {
	$document = new DOMDocument();
	global $more;
	$more = true;
	$content = apply_filters( 'the_content', get_the_content( '', true ) );
	$more = false;
	if( '' != $content ) {
		libxml_use_internal_errors( true );
		$document->loadHTML( $content );
		libxml_clear_errors();
		$iframes = $document->getElementsByTagName( 'iframe' );
		$objects = $document->getElementsByTagName( 'object' );
		$embeds = $document->getElementsByTagName( 'embed' );
		$document = new DOMDocument();
		if( $iframes->length ) {
			$iframe= $iframes->item( $iframes->length - 1 );
			$document->appendChild( $document->importNode( $iframe, true ) );
		} elseif( $objects->length ) {
			$object= $objects->item( $objects->length - 1 );
			$document->appendChild( $document->importNode( $object, true ) );
		} elseif( $embeds->length ) {
			$embed= $embeds->item( $embeds->length - 1 );
			$document->appendChild( $document->importNode( $embed, true ) );
		}
		return $document->saveHTML();
	}
	return false;
}

function enlightenment_entry_video( $args = null ) {
	$defaults = array(
		'container' => 'div',
		'container_class' => 'entry-attachment',
		'echo' => true,
	);
	$defaults = apply_filters( 'enlightenment_entry_video_args', $defaults );
	$args = wp_parse_args( $args, $defaults );
	global $more;
	$more = true;
	$content = get_the_content();
	$more = false;
	$output = enlightenment_open_tag( $args['container'], $args['container_class'] );
	if( preg_match( '/\[(\[?)(video)(?![\w-])([^\]\/]*(?:\/(?!\])[^\]\/]*)*?)(?:(\/)\]|\](?:([^\[]*+(?:\[(?!\/\2\])[^\[]*+)*+)\[\/\2\])?)(\]?)/s', $content, $matches ) ) {
		$output .= do_shortcode( $matches[0] );
	} else {
		$output .= enlightenment_get_first_embed();
	}
	$output .= enlightenment_close_tag( $args['container'] );
	$output = apply_filters( 'enlightenment_entry_video', $output, $args );
	if( ! $args['echo'] )
		return $output;
	echo $output;
}

function enlightenment_entry_audio( $args = null ) {
	$defaults = array(
		'container' => 'div',
		'container_class' => 'entry-attachment',
		'echo' => true,
	);
	$defaults = apply_filters( 'enlightenment_entry_audio_args', $defaults );
	$args = wp_parse_args( $args, $defaults );
	global $more;
	$more = true;
	$content = get_the_content();
	$more = false;
	$output = enlightenment_open_tag( $args['container'], $args['container_class'] );
	if( preg_match( '/\[(\[?)(audio)(?![\w-])([^\]\/]*(?:\/(?!\])[^\]\/]*)*?)(?:(\/)\]|\](?:([^\[]*+(?:\[(?!\/\2\])[^\[]*+)*+)\[\/\2\])?)(\]?)/s', $content, $matches ) )
		$output .= do_shortcode( $matches[0] );
	else
		$output .= enlightenment_get_first_embed();
	$output .= enlightenment_close_tag( $args['container'] );
	$output = apply_filters( 'enlightenment_entry_audio', $output, $args );
	if( ! $args['echo'] )
		return $output;
	echo $output;
}



