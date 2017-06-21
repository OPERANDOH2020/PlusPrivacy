<?php

add_action( 'enlightenment_after_entry_content', 'enlightenment_allow_comments_template', 8 );

function enlightenment_allow_comments_template() {
	global $withcomments;
	$withcomments = true;
}

function enlightenment_comments_password_notice( $args = null ) {
	$defaults = array(
		'container' => 'aside',
		'container_id' => 'comments',
		'container_class' => '',
		'notice_tag' => 'p',
		'notice_class' => 'nocomments',
		'notice_text' => __( 'This post is password protected. Enter the password to view comments.', 'enlightenment' ),
		'only_on_pages_with_coments' => true,
		'echo' => true,
	);
	$defaults = apply_filters( 'enlightenment_comments_password_notice_args', $defaults );
	$args = wp_parse_args( $args, $defaults );
	if ( $args['only_on_pages_with_coments'] && ! have_comments() )
		return false;
	$output = enlightenment_open_tag( $args['container'], $args['container_id'], $args['container_class'] );
	$output .= enlightenment_open_tag( $args['notice_tag'], $args['notice_class'] );
	$output .= esc_attr( $args['notice_text'] );
	$output .= enlightenment_close_tag( $args['notice_tag'] );
	$output .= enlightenment_close_tag( $args['container'] );
	$output = apply_filters( 'enlightenment_comments_password_notice', $output, $args );
	if( ! $args['echo'] )
		return $output;
	echo $output;
}

function enlightenment_comments_number( $args = null ) {
	$defaults = array(
		'container' => 'h3',
		'container_class' => 'comments-title',
		'container_id' => '',
		'format' => __( '%1$s for &ldquo;%2$s&rdquo;', 'enlightenment' ),
		'zero' => __( 'No Comments', 'enlightenment' ),
		'one' => __( '1 Comment', 'enlightenment' ),
		'more' => __( '% Comments', 'enlightenment' ),
		'echo' => true,
	);
	$defaults = apply_filters( 'enlightenment_comments_number_args', $defaults );
	$args = wp_parse_args( $args, $defaults );
	
	$comments_number = get_comments_number_text( $args['zero'], $args['one'], $args['more'] );
	
	$output  = enlightenment_open_tag( $args['container'], $args['container_class'], $args['container_id'] );
	$output .= sprintf( $args['format'], $comments_number, get_the_title() );
	$output .= enlightenment_close_tag( $args['container'] );
	
	$output = apply_filters( 'enlightenment_comments_number', $output, $args );
	
	if( ! $args['echo'] ) {
		return $output;
	}
	
	echo $output;
}

class Enlightenment_Walker_Comment extends Walker_Comment {

	function start_lvl( &$output, $depth = 0, $args = array() ) {
		$GLOBALS['comment_depth'] = $depth + 1;
		
		switch ( $args['style'] ) {
			case 'ol':
				$output .= '<ol class="children">' . "\n";
				break;
			case 'ul':
				$output .= '<ul class="children">' . "\n";
				break;
			case 'div':
			default:
				break;
		}
	}

	function end_lvl( &$output, $depth = 0, $args = array() ) {
		$GLOBALS['comment_depth'] = $depth + 1;
		
		switch ( $args['style'] ) {
			case 'ol':
				$output .= "</ol>\n";
				break;
			case 'ul':
				$output .= "</ul>\n";
				break;
			case 'div':
			default:
				break;
		}
	}

	function end_el( &$output, $comment, $depth = 0, $args = array() ) {
		if ( ! empty( $args['end-callback'] ) ) {
			ob_start();
			call_user_func( $args['end-callback'], $comment, $args, $depth );
			$output .= ob_get_clean();
			return;
		}
		$output .= apply_filters( 'enlightenment_after_comment', '', $comment, $args );
		if( 'ul' == $args['style'] || 'ol' == $args['style'] )
			$output .= "</li>\n";
		else
			$output .= current_theme_supports( 'html5', 'comment-list' ) ? "</article>\n" : "</div>\n";
	}

}

function enlightenment_list_comments_args( $args = null ) {
	$defaults = array(
		'walker' => new Enlightenment_Walker_Comment,
		'style' => '',
		'class' => 'commentlist',
		'avatar_size' => 64,
		'callback' => 'enlightenment_comment',
		'echo' => true,
	);
	$defaults = apply_filters( 'enlightenment_list_comments_args', $defaults );
	$args = wp_parse_args( $args, $defaults );
	return $args;
}

add_action( 'enlightenment_comments', 'enlightenment_list_comments_open_wrap', 8 );

function enlightenment_list_comments_open_wrap( $args = null ) {
	do_action( 'enlightenment_before_comments_list' );
	echo enlightenment_open_tag( $args['style'], $args['class'] );
}

add_action( 'enlightenment_comments', 'enlightenment_list_comments_close_wrap', 32 );

function enlightenment_list_comments_close_wrap( $args = null ) {
	echo enlightenment_close_tag( $args['style'] );
	do_action( 'enlightenment_after_comments_list' );
}

function enlightenment_comment( $comment, $args, $depth ) {
	$defaults = array(
		'comment_class' => 'comment-body' . ( empty( $args['has_children'] ) ? '' : ' parent' ),
		'comment_id' => 'comment-' . get_comment_ID(),
		'comment_extra_atts' => '',
		'header_tag' => current_theme_supports( 'html5', 'comment-list' ) ? 'header' : 'div',
		'header_class' => 'comment-header',
		'comment_content_tag' => 'div',
		'comment_content_class' => 'comment-content',
		'comment_content_extra_atts' => '',
		'echo' => true,
	);
	$defaults = apply_filters( 'enlightenment_comment_args', $defaults );
	$comment_reply_link_defaults = array(
		'add_below' => 'comment',
		'depth' => $depth,
		'max_depth' => $args['max_depth'],
		'before' => '<div class="reply">',
		'after' => '</div>',
	);
	$comment_reply_link_defaults = apply_filters( 'enlightenment_comment_reply_link_args', $comment_reply_link_defaults );
	$defaults = wp_parse_args( $comment_reply_link_defaults, $defaults );
	$args = wp_parse_args( $args, $defaults );

	$GLOBALS['comment'] = $comment;
	extract($args, EXTR_SKIP);

	if( 'ul' == $args['style'] || 'ol' == $args['style'] )
		$args['style'] = 'li';
	else
		$args['style'] = current_theme_supports( 'html5', 'comment-list' ) ? 'article' : 'div';

	do_action( 'enlightenment_before_comment', $comment, $args );
	echo enlightenment_open_tag( $args['style'], join( ' ', get_comment_class( $args['comment_class'] ) ), $args['comment_id'], $args['comment_extra_atts'] );
	
	do_action( 'enlightenment_before_comment_header', $comment, $args );
	if( has_action( 'enlightenment_comment_header' ) ) {
		echo enlightenment_open_tag( $args['header_tag'], $args['header_class'] );
		do_action( 'enlightenment_comment_header', $comment, $args );
		echo enlightenment_close_tag( $args['header_tag'] );
	}
	do_action( 'enlightenment_after_comment_header', $comment, $args );

	do_action( 'enlightenment_before_comment_content', $comment, $args );
	if( has_action( 'enlightenment_comment_content' ) ) {
		echo enlightenment_open_tag( $args['comment_content_tag'], $args['comment_content_class'], '', $args['comment_content_extra_atts'] );
		do_action( 'enlightenment_comment_content', $comment, $args );
		echo enlightenment_close_tag( $args['comment_content_tag'] );
	}
	do_action( 'enlightenment_after_comment_content', $args, $comment );
}

function enlightenment_comment_author_avatar( $comment, $args ) {
	$defaults = array(
		'avatar_container' => 'span',
		'avatar_container_class' => 'comment-author-avatar',
		'avatar_size' => 64,
		'echo' => true,
	);
	$defaults = apply_filters( 'enlightenment_comment_author_avatar_args', $defaults );
	$args = wp_parse_args( $args, $defaults );
	if( $args['avatar_size'] != 0) {
		$output = enlightenment_open_tag( $args['avatar_container'], $args['avatar_container_class'] );
		$output .= get_avatar( $comment, $args['avatar_size'] );
		$output .= enlightenment_close_tag( $args['avatar_container'] );
		$output = apply_filters( 'enlightenment_comment_author_avatar', $output, $args );
		if( ! $args['echo'] )
			return $output;
		echo $output;
	} else
		return false;
}

function enlightenment_comment_author( $comment, $args = null ) {
	$defaults = array(
		'container' => 'h4',
		'container_class' => 'comment-author vcard',
		'container_extra_atts' => '',
		'author_name_tag' => 'cite',
		'author_name_class' => 'fn',
		'author_name_extra_atts' => '',
		'before' => '',
		'after' => ' <span class="says">' . __( 'says:', 'enlightenment' ) . '</span>',
		'echo' => true,
	);
	$defaults = apply_filters( 'enlightenment_comment_author_args', $defaults );
	$args = wp_parse_args( $args, $defaults );
	$output = $args['before'];
	$output .= enlightenment_open_tag( $args['container'], $args['container_class'], '', $args['container_extra_atts'] );
	$output .= enlightenment_open_tag( $args['author_name_tag'], $args['author_name_class'], '', $args['author_name_extra_atts'] );
	$output .= get_comment_author_link();
	$output .= enlightenment_close_tag( $args['author_name_tag'] );
	$output .= enlightenment_close_tag( $args['container'] );
	$output .= $args['after'];
	$output = apply_filters( 'enlightenment_comment_author', $output );
	if( ! $args['echo'] )
		return $output;
	echo $output;
}

function enlightenment_comment_awaiting_moderation( $comment, $args = null ) {
	$defaults = array(
		'container' => 'em',
		'container_class' => 'comment-awaiting-moderation',
		'text' => __( 'Your comment is awaiting moderation.', 'enlightenment' ),
		'before' => '',
		'after' => '<br />',
		'echo' => true,
	);
	$defaults = apply_filters( 'enlightenment_comment_awaiting_moderation_args', $defaults );
	$args = wp_parse_args( $args, $defaults );
	if( $comment->comment_approved == '0' ) {
		$output = $args['before'];
		$output .= enlightenment_open_tag( $args['container'], $args['container_class'] );
		$output .= strip_tags( $args['text'] );
		$output .= enlightenment_close_tag( $args['container'] );
		$output .= $args['after'];
		$output = apply_filters( 'enlightenment_comment_awaiting_moderation', $output );
		if( ! $args['echo'] )
			return $output;
		echo $output;
	}
}

function enlightenment_comment_time( $comment, $args = null ) {
	$defaults = array(
		'comment' => 0,
		'container' => 'span',
		'container_class' => 'comment-time',
		'time_extra_atts' => '',
		'before' => '',
		'after' => '',
		'text_format' => __( '%1$s at %2$s', 'enlightenment' ),
		'echo' => true,
	);
	$defaults = apply_filters( 'enlightenment_comment_time_args', $defaults );
	$args = wp_parse_args( $args, $defaults );
	$time = '<time datetime="' . get_comment_date('Y-m-d') . '"' . $args['time_extra_atts'] . '>' . sprintf( $args['text_format'], get_comment_date(),  get_comment_time() ) . '</time>';
	$output = enlightenment_open_tag( $args['container'], $args['container_class'] );
	$output .= $args['before'] . '<a href="' . htmlspecialchars( get_comment_link( $comment->comment_ID ) ) . '">' . $time . '</a>';
	$output .= enlightenment_close_tag( $args['container'] );
	$output = apply_filters( 'enlightenment_comment_time', $output, $args );
	if( ! $args['echo'] )
		return $output;
	echo $output;
}

function enlightenment_comment_meta( $comment, $args = null ) {
	$defaults = array(
		'container' => current_theme_supports( 'html5', 'comment-list' ) ? 'aside' : 'div',
		'container_class' => 'comment-meta commentmetadata',
		'echo' => true,
	);
	$defaults = apply_filters( 'enlightenment_comment_meta_args', $defaults );
	$args = wp_parse_args( $args, $defaults );
	if( has_action( 'enlightenment_comment_meta' ) ) {
		ob_start();
		echo enlightenment_open_tag( $args['container'], $args['container_class'] );
		do_action( 'enlightenment_comment_meta', $comment );
		echo enlightenment_close_tag( $args['container'] );
		$output = ob_get_clean();
	}
	if( ! $args['echo'] )
		return $output;
	echo $output;
}

function enlightenment_comment_form_fields( $fields ) {
	$commenter = wp_get_current_commenter();
	$req = get_option( 'require_name_email' );
	$aria_req = ( $req ? " aria-required='true'" : '' );
	$args = array(
		'author_container' => 'p',
		'author_container_class' => 'comment-form-author',
		'author_label_class' => '',
		'author_class' => '',
		'author_id' => 'author',
		'author_size' => 30,
		'before_author_label' => '',
		'after_author_label' => $req ? ' <span class="required">*</span>' : '',
		'email_container' => 'p',
		'email_container_class' => 'comment-form-email',
		'email_label_class' => '',
		'email_class' => '',
		'email_id' => 'email',
		'email_size' => 30,
		'before_email_label' => '',
		'after_email_label' => $req ? ' <span class="required">*</span>' : '',
		'url_container' => 'p',
		'url_container_class' => 'comment-form-url',
		'url_label_class' => '',
		'url_class' => '',
		'url_id' => 'url',
		'url_size' => 30,
		'before_url_label' => '',
		'after_url_label' => '',
	);
	$args = apply_filters( 'enlightenment_comment_form_fields_args', $args );
	$fields = array(
		'author' => enlightenment_open_tag( $args['author_container'], $args['author_container_class'] ) .
						'<label' . ( '' != $args['author_id'] ? ' for="' . $args['author_id'] . '"' : '' ) . enlightenment_class( $args['author_label_class'] ) . '>' . $args['before_author_label'] . __( 'Name', 'enlightenment' ) . $args['after_author_label'] . '</label> ' .
						'<input' . enlightenment_id( $args['author_id'] ) . enlightenment_class( $args['author_class'] ) . ' name="author" type="text" value="' . esc_attr( $commenter['comment_author'] ) . '" size="' . intval( $args['author_size'] ) . '"' . $aria_req . ' />' .
					enlightenment_close_tag( $args['author_container'] ),
		'email' => enlightenment_open_tag( $args['email_container'], $args['email_container_class'] ) .
						'<label' . ( '' != $args['email_id'] ? ' for="' . $args['email_id'] . '"' : '' ) . enlightenment_class( $args['email_label_class'] ) . '>' . $args['before_email_label'] . __( 'Email', 'enlightenment' ) . $args['after_email_label'] . '</label> ' .
						'<input' . enlightenment_id( $args['email_id'] ) . enlightenment_class( $args['email_class'] ) . ' name="email" type="text" value="' . esc_attr( $commenter['comment_author_email'] ) . '" size="' . intval( $args['email_size'] ) . '"' . $aria_req . ' />' .
					enlightenment_close_tag( $args['email_container'] ),
		'url' => enlightenment_open_tag( $args['url_container'], $args['url_container_class'] ) .
						'<label' . ( '' != $args['url_id'] ? ' for="' . $args['url_id'] . '"' : '' ) . enlightenment_class( $args['url_label_class'] ) . '>' . $args['before_url_label'] . __( 'Website', 'enlightenment' ) . $args['after_url_label'] . '</label> ' .
						'<input' . enlightenment_id( $args['url_id'] ) . enlightenment_class( $args['url_class'] ) . ' name="url" type="text" value="' . esc_attr( $commenter['comment_author_url'] ) . '" size="' . intval( $args['url_size'] ) . '" />' .
					enlightenment_close_tag( $args['url_container'] ),
	);
	return $fields;
}

function enlightenment_comment_form_defaults( $defaults ) {
	$args = array(
		'container' => 'p',
		'container_class' => 'comment-form-comment',
		'label_class' => '',
		'textarea_class' => '',
		'textarea_id' => 'comment',
		'cols' => 45,
		'rows' => 8,
		'before_label' => '',
		'after_label' => '',
	);
	$args = apply_filters( 'enlightenment_comment_form_defaults_args', $args );
	$defaults['comment_field'] = enlightenment_open_tag( $args['container'], $args['container_class'] ) .
									'<label' . ( '' != $args['textarea_id'] ? ' for="' . $args['textarea_id'] . '"' : '' ) . enlightenment_class( $args['label_class'] ) . '>' . $args['before_label'] . _x( 'Comment', 'noun', 'enlightenment' ) . '</label>' .
									'<textarea' . enlightenment_id( $args['textarea_id'] ) . enlightenment_class( $args['textarea_class'] ) . ' name="comment" cols="' . intval( $args['cols'] ) . '" rows="' . intval( $args['rows'] ) . '" aria-required="true"></textarea>' .
								 enlightenment_close_tag( $args['container'] );
	return $defaults;
}

function enlightenment_comments_closed_notice( $args = null ) {
	$defaults = array(
		'container' => 'aside',
		'container_id' => 'respond',
		'container_class' => 'comment-respond',
		'notice_tag' => 'p',
		'notice_class' => 'comments-closed',
		'notice_text' => __( 'Comments are closed.', 'enlightenment' ),
		'only_on_entries_with_comments' => true,
		'echo' => true,
	);
	$defaults = apply_filters( 'enlightenment_comments_closed_notice_args', $defaults );
	$args = wp_parse_args( $args, $defaults );
	if ( $args['only_on_entries_with_comments'] && ! have_comments() )
		return false;
	$output = enlightenment_open_tag( $args['container'], $args['container_class'], $args['container_id'] );
	$output .= enlightenment_open_tag( $args['notice_tag'], $args['notice_class'] );
	$output .= strip_tags( $args['notice_text'] );
	$output .= enlightenment_close_tag( $args['notice_tag'] );
	$output .= enlightenment_close_tag( $args['container'] );
	$output = apply_filters( 'enlightenment_comments_closed_notice', $output );
	if( ! $args['echo'] )
		return $output;
	echo $output;
}

if( false ) {
	comments_template();
	wp_list_comments();
	comment_form();
}




