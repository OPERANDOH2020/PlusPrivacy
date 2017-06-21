<?php

function enlightenment_settings_text( $args, $echo = true ) {
	$defaults = array(
		'text' => '',
	);
	$args = wp_parse_args( $args, $defaults );
	$output = strip_tags( $args['text'], '<h4><p><img><a><abbr>' );
	$output = apply_filters( 'enlightenment_settings_text', $output, $args );
	if( ! $echo )
		return $output;
	echo $output;
}

function enlightenment_hidden_input( $args, $echo = true ) {
	$defaults = array(
		'class' => '',
		'id' => '',
		'value' => '',
	);
	$args = wp_parse_args( $args, $defaults );
	$args = apply_filters( 'enlightenment_hidden_input_args', $args );
	if( ! isset( $args['name'] ) || empty( $args['name'] ) ) {
		_doing_it_wrong( __FUNCTION__, __( 'Please specify a name attribute for your hidden input.', 'enlightenment' ), '' );
		return;
	}
	$output = '<input ';
	$output .= 'name="' . apply_filters( 'enlightenment_hidden_input_name', esc_attr( $args['name'] ) ) . '"';
	$output .= enlightenment_class( $args['class'] );
	$output .= enlightenment_id( $args['id'] ) . ' ';
	$output .= 'value="' . esc_attr( $args['value'] ) . '" ';
	$output .= 'type="hidden" ';
	$output .= '/>';
	$output = apply_filters( 'enlightenment_hidden_input', $output, $args );
	if( ! $echo )
		return $output;
	echo $output;
}

function enlightenment_hidden_inputs( $args, $echo = true ) {
	$defaults = array(
		'class' => '',
		'inputs' => array(),
	);
	$args = wp_parse_args( $args, $defaults );
	$output = '';
	foreach( $args['inputs'] as $input ) {
		$output .= enlightenment_hidden_input( $input, false );
	}
	$output = apply_filters( 'enlightenment_hidden_inputs', $output, $args );
	if( ! $echo )
		return $output;
	echo $output;
}

function enlightenment_text_input( $args, $echo = true ) {
	$defaults = array(
		'label' => '',
		'class' => '',
		'id' => '',
		'value' => '',
		'placeholder' => '',
		'size' => '',
		'readonly' => false,
		'description' => '',
	);
	$args = wp_parse_args( $args, $defaults );
	$args = apply_filters( 'enlightenment_text_input_args', $args );
	if( ! isset( $args['name'] ) || empty( $args['name'] ) ) {
		_doing_it_wrong( __FUNCTION__, __( 'Please specify a name attribute for your text field.', 'enlightenment' ), '' );
		return;
	}
	$output = '';
	if( ! empty( $args['label'] ) ) {
		$output .= '<label ';
		$output .= empty( $args['id'] ) ? '' : 'for="' . esc_attr( $args['id'] ) . '"';
		$output .= enlightenment_class( $args['class'] . '-label' );
		$output .= enlightenment_id( $args['id'] . '-label' );
		$output .= '>';
		$output .= strip_tags( $args['label'], '<a><abbr><img>' );
		$output .= '<br />' . "\n";
	}
	$output .= '<input ';
	$output .= 'name="' . apply_filters( 'enlightenment_text_input_name', esc_attr( $args['name'] ) ) . '"';
	$output .= enlightenment_class( $args['class'] );
	$output .= enlightenment_id( $args['id'] ) . ' ';
	$output .= 'value="' . esc_attr( $args['value'] ) . '" ';
	$output .= 'type="text" ';
	$output .= empty( $args['placeholder'] ) ? '' : ' placeholder="' . esc_attr( $args['placeholder'] ) . '" ';
	$output .= empty( $args['size'] ) ? '' : ' size="' . esc_attr( $args['size'] ) . '" ';
	$output .= $args['readonly'] ? 'readonly' : '';
	$output .= '/>';
	if( ! empty( $args['label'] ) )
		$output .= '</label>';
	$output .= empty( $args['description'] ) ? '' : '<p class="description">' . strip_tags( $args['description'], '<a><abbr><img>' ) . '</p>';
	$output = apply_filters( 'enlightenment_text_input', $output, $args );
	if( ! $echo )
		return $output;
	echo $output;
}

function enlightenment_checkbox( $args, $echo = true ) {
	$defaults = array(
		'class' => '',
		'id' => '',
		'value' => true,
		'checked' => false,
		'description' => '',
	);
	$args = wp_parse_args( $args, $defaults );
	$args = apply_filters( 'enlightenment_checkbox_args', $args );
	$output = '';
	if( ! isset( $args['name'] ) || empty( $args['name'] ) ) {
		_doing_it_wrong( __FUNCTION__, __( 'Please specify a name attribute for your checkbox.', 'enlightenment' ), '' );
		return;
	}
	if( ! isset( $args['label'] ) || empty( $args['label'] ) ) {
		_doing_it_wrong( __FUNCTION__, __( 'Please specify a label for your checkbox.', 'enlightenment' ), '' );
		return;
	}
	$output .= '<label ';
	$output .= empty( $args['id'] ) ? '' : 'for="' . esc_attr( $args['id'] ) . '"';
	$output .= enlightenment_class( $args['class'] . '-label' );
	$output .= enlightenment_id( $args['id'] . '-label' );
	$output .= '>';
	$output .= '<input ';
	$output .= 'name="' . apply_filters( 'enlightenment_checkbox_name', esc_attr( $args['name'] ) ) . '"';
	$output .= enlightenment_class( $args['class'] );
	$output .= enlightenment_id( $args['id'] ) . ' ';
	$output .= 'value="' . esc_attr( $args['value'] ) . '" ';
	$output .= 'type="checkbox" ';
	$output .= checked( $args['checked'], true, false );
	$output .= ' /> ';
	$output .= strip_tags( $args['label'], '<a><abbr><img>' );
	$output .= '</label>';
	$output .= empty( $args['description'] ) ? '' : '<p class="description">' . strip_tags( $args['description'], '<a><abbr><img><strong><br>' ) . '</p>';
	$output = apply_filters( 'enlightenment_checkbox', $output, $args );
	if( ! $echo )
		return $output;
	echo $output;
}

function enlightenment_checkboxes( $args, $echo = true ) {
	$defaults = array(
		'class' => '',
		'boxes' => array(),
		'description' => '',
	);
	$args = wp_parse_args( $args, $defaults );
	$output = '<fieldset>';
	foreach( $args['boxes'] as $checkbox ) {
		$checkbox = wp_parse_args( $checkbox, $args );
		unset( $checkbox['description'] );
		$output .= enlightenment_checkbox( $checkbox, false );
		$values = array_values( $args['boxes'] );
		if( $checkbox != end(  $values ) )
			$output .= '<br />';
	}
	$output .= '</fieldset>';
	$output .= empty( $args['description'] ) ? '' : '<p class="description">' . strip_tags( $args['description'], '<a><abbr><img>' ) . '</p>';
	$output = apply_filters( 'enlightenment_checkboxes', $output, $args );
	if( ! $echo )
		return $output;
	echo $output;
}

function enlightenment_radio_buttons( $args, $echo = true ) {
	$defaults = array(
		'class' => '',
		'value' => '',
		'buttons' => array(),
		'description' => '',
	);
	$args = wp_parse_args( $args, $defaults );
	$args = apply_filters( 'enlightenment_radio_buttons_args', $args );
	if( ! isset( $args['name'] ) || empty( $args['name'] ) ) {
		_doing_it_wrong( __FUNCTION__, __( 'Please specify a name attribute for your radio buttons.', 'enlightenment' ), '' );
		return;
	}
	$output = '<fieldset>';
	foreach( $args['buttons'] as $button ) {
		if( ! isset( $button['label'] ) || empty( $button['label'] ) ) {
			_doing_it_wrong( __FUNCTION__, __( 'Please specify a label for your radio button.', 'enlightenment' ), '' );
			return;
		}
		if( ! isset( $button['value'] ) || empty( $button['value'] ) ) {
			_doing_it_wrong( __FUNCTION__, __( 'Please specify a value attribute for your radio button.', 'enlightenment' ), '' );
			return;
		}
		$output .= '<label ';
		$output .= empty( $button['id'] ) ? '' : 'for="' . esc_attr( $button['id'] ) . '"';
		$output .= enlightenment_class( $args['class'] . '-label' );
		if( isset( $button['id'] ) )
			$output .= enlightenment_id( $button['id'] . '-label' );
		$output .= '>';
		$output .= '<input ';
		$output .= 'name="' . apply_filters( 'enlightenment_radio_buttons_name', esc_attr( $args['name'] ) ) . '"';
		$output .= enlightenment_class( $args['class'] );
		if( isset( $button['id'] ) )
			$output .= enlightenment_id( $button['id'] ) . ' ';
		$output .= 'value="' . esc_attr( $button['value'] ) . '" ';
		$output .= 'type="radio" ';
		$output .= checked( $args['value'], $button['value'], false );
		$output .= ' /> ';
		$output .= strip_tags( $button['label'], '<a><abbr><img>' );
		$output .= '</label>';
		if( $button != end( $args['buttons'] ) )
			$output .= '<br />';
	}
	$output .= '</fieldset>';
	$output .= empty( $args['description'] ) ? '' : '<p class="description">' . strip_tags( $args['description'], '<a><abbr><img>' ) . '</p>';
	$output = apply_filters( 'enlightenment_radio_buttons', $output, $args );
	if( ! $echo )
		return $output;
	echo $output;
}

function enlightenment_select_box( $args, $echo = true ) {
	$defaults = array(
		'class' => '',
		'id' => '',
		'value' => '',
		'multiple' => false,
		'options' => array(),
		'description' => '',
	);
	$args = wp_parse_args( $args, $defaults );
	$args = apply_filters( 'enlightenment_select_box_args', $args );
	if( ! isset( $args['name'] ) || empty( $args['name'] ) ) {
		_doing_it_wrong( __FUNCTION__, __( 'Please specify a name attribute for your radio buttons.', 'enlightenment' ), '' );
		return;
	}
	$output = '';
	if( ! empty( $args['options'] ) ) {
		if( ! empty( $args['label'] ) ) {
			$output .= '<label ';
			$output .= empty( $args['id'] ) ? '' : 'for="' . esc_attr( $args['id'] ) . '"';
			$output .= enlightenment_class( $args['class'] . '-label' );
			$output .= enlightenment_id( $args['id'] . '-label' );
			$output .= '>';
			$output .= strip_tags( $args['label'], '<a><abbr><img>' );
			$output .= '<br />' . "\n";
		}
		$output .= '<select ';
		$output .= 'name="' . apply_filters( 'enlightenment_select_box_name', esc_attr( $args['name'] ) ) . ( $args['multiple'] ? '[]' : '' ) . '"';
		$output .= enlightenment_class( $args['class'] );
		$output .= enlightenment_id( $args['id'] );
		if( $args['multiple'] )
			$output .= ' multiple="multiple"';
		$output .= '>';
		foreach( $args['options'] as $value => $label ) {
			$output .= '<option ';
			$output .= 'value="' . esc_attr( $value ) . '"';
			$output .= selected( $args['value'], $value, false );
			$output .= '>';
			$output .= strip_tags( $label );
			$output .= '</option>';
		}
		$output .= '</select>';
		if( ! empty( $args['label'] ) )
			$output .= '</label>';
	}
	$output .= empty( $args['description'] ) ? '' : '<p class="description">' . strip_tags( $args['description'], '<strong><a><abbr><img>' ) . '</p>';
	$output = apply_filters( 'enlightenment_select_box', $output, $args );
	if( ! $echo )
		return $output;
	echo $output;
}

function enlightenment_textarea( $args, $echo = true ) {
	$defaults = array(
		'class' => '',
		'id' => '',
		'cols' => '',
		'rows' => '',
		'value' => '',
		'description' => '',
	);
	$args = wp_parse_args( $args, $defaults );
	$args = apply_filters( 'enlightenment_textarea_args', $args );
	if( ! isset( $args['name'] ) || empty( $args['name'] ) ) {
		_doing_it_wrong( __FUNCTION__, __( 'Please specify a name attribute for your textarea.', 'enlightenment' ), '' );
		return;
	}
	$output = '';
	if( ! empty( $args['label'] ) ) {
		$output .= '<label ';
		$output .= empty( $args['id'] ) ? '' : 'for="' . esc_attr( $args['id'] ) . '"';
		$output .= enlightenment_class( $args['class'] . '-label' );
		$output .= enlightenment_id( $args['id'] . '-label' );
		$output .= '>';
		$output .= strip_tags( $args['label'], '<a><abbr><img>' );
		$output .= '<br />' . "\n";
	}
	$output .= '<textarea ';
	$output .= 'name="' . apply_filters( 'enlightenment_textarea_name', esc_attr( $args['name'] ) ) . '"';
	$output .= enlightenment_class( $args['class'] );
	$output .= enlightenment_id( $args['id'] ) . ' ';
	$output .= empty( $args['cols'] ) ? '' : ' cols="' . esc_attr( $args['cols'] ) . '" ';
	$output .= empty( $args['rows'] ) ? '' : ' rows="' . esc_attr( $args['rows'] ) . '" ';
	$output .= '>';
	$output .= esc_textarea( $args['value'] );
	$output .= '</textarea>';
	$output .= empty( $args['description'] ) ? '' : '<p class="description">' . strip_tags( $args['description'], '<a><abbr><img>' ) . '</p>';
	$output = apply_filters( 'enlightenment_textarea', $output, $args );
	if( ! $echo )
		return $output;
	echo $output;
}

function enlightenment_upload_media( $args, $echo = true ) {
	$defaults = array(
		'class' => '',
		'id' => '',
		'description' => '',
		'upload_button_text' => __( 'Choose Media', 'enlightenment' ),
		'uploader_title' => __( 'Insert Media', 'enlightenment' ),
		'uploader_button_text' => __( 'Select', 'enlightenment' ),
		'remove_button_text' => __( 'Remove Media', 'enlightenment' ),
		'mime_type' => 'image',
		'multiple' => false,
		'thumbnail' => 'thumbnail',
		'value' => '',
	);
	$args = wp_parse_args( $args, $defaults );
	$args = apply_filters( 'enlightenment_upload_media_args', $args );
	if( ! isset( $args['name'] ) || empty( $args['name'] ) ) {
		_doing_it_wrong( __FUNCTION__, __( 'Please specify a name attribute for your upload field.', 'enlightenment' ), '' );
		return;
	}
	wp_enqueue_media();
	$args['class'] .= ' button upload-media-button';
	$output = '<input ';
	$output .= enlightenment_class( $args['class'] );
	$output .= enlightenment_id( $args['id'] ) . ' ';
	$output .= 'value="' . esc_attr( $args['upload_button_text'] ) . '" ';
	$output .= 'type="button" ';
	$output .= 'data-uploader-title="' . esc_attr( $args['uploader_title'] ) . '" ';
	$output .= 'data-uploader-button-text="' . esc_attr( $args['uploader_button_text'] ) . '" ';
	$output .= 'data-mime-type="' . esc_attr( $args['mime_type'] ) . '" ';
	$output .= 'data-multiple="' . esc_attr( $args['multiple'] ) . '" ';
	$output .= 'data-thumbnail="' . esc_attr( $args['thumbnail'] ) . '" ';
	$output .= '/>';
	$media = $args['value'];
	if( '' != $args['remove_button_text'] )
		$output .= '<input class="button remove-media-button" value="' . esc_attr( $args['remove_button_text'] ) . '" type="button"' . ( empty( $media ) ? ' style="display:none"' : '' ) . ' />';
	if( null != $args['thumbnail'] ) {
		$output .= enlightenment_open_tag( 'div', 'preview-media' );
		if( ! empty( $media ) ) {
			$attachment_id = intval( $media );
			if( wp_attachment_is_image( $attachment_id ) )
				$attachment = wp_get_attachment_image( $attachment_id, $args['thumbnail'] );
			else
				$attachment = '<a href="' . wp_get_attachment_url( $attachment_id ) . '">' . get_the_title( $attachment_id ) . '</a>';
			$output .= $attachment;
		}
		$output .= enlightenment_close_tag();
	}
	$output .= enlightenment_hidden_input( $args, false );
	$output .= empty( $args['description'] ) ? '' : '<p class="description">' . strip_tags( $args['description'], '<a><abbr><img>' ) . '</p>';
	$output = apply_filters( 'enlightenment_upload_media', $output, $args );
	if( ! $echo )
		return $output;
	echo $output;
}

add_action( 'wp_ajax_enlightenment_media_preview', 'enlightenment_attached_media_src' );

function enlightenment_attached_media_src() {
	$id = intval( $_POST['id'] );
	$size = esc_attr( $_POST['size'] );
	$mime_type = esc_attr( $_POST['mime_type'] );
	if( 'image' == $mime_type )
		echo wp_get_attachment_image( $id, $size );
	else
		echo '<a href="' . wp_get_attachment_url( $id ) . '">' . get_the_title( $id ) . '</a>';
	die();
}

function enlightenment_color_picker( $args, $echo = true ) {
	$defaults = array(
		'transparent' => false,
		'alpha' => false,
		'class' => '',
		'id' => '',
		'description' => '',
	);
	$args = wp_parse_args( $args, $defaults );
	if( ! isset( $args['name'] ) || empty( $args['name'] ) ) {
		_doing_it_wrong( __FUNCTION__, __( 'Please specify a name attribute for your color picker.', 'enlightenment' ), '' );
		return;
	}
	
	$description = $args['description'];
	unset( $args['description'] );
	
	$picker_args = $args;
	
	if( $args['transparent'] || $args['alpha'] ) {
		$picker_args['name'] .= '[hex]';
		$picker_args['value'] = $args['value']['hex'];
	}
	
	$picker_args['class'] .= ' wp-color-picker';
	wp_enqueue_style( 'wp-color-picker' );
	wp_enqueue_script( 'wp-color-picker' );
	$output = enlightenment_text_input( $picker_args, false );
	
	if( $args['transparent'] || $args['alpha'] ) {
		if( $args['alpha'] ) {
			wp_enqueue_script( 'jquery-ui-slider' );
			$alpha_args = $args;
			$alpha_args['name']  .= '[alpha]';
			$alpha_args['value'] = $args['value']['alpha'];
			$alpha_args['size'] = 3;
			$alpha_args['readonly'] = true;
			$output .= ' <br />';
			$output .= enlightenment_open_tag( 'div', 'enlightenment-opacity-slider' );
			$output .= enlightenment_open_tag( 'div', 'enlightenment-jquery-ui-slider' );
			$output .= enlightenment_close_tag( 'div' );
			$output .= __( 'Opacity:', 'enlightenment' );
			$output .= ' ';
			$output .= enlightenment_text_input( $alpha_args, false );
			$output .= enlightenment_close_tag( 'div' );
			$args['name'] = str_replace( '[alpha]', '', $args['name'] );
		}
		
		if( $args['transparent'] ) {
			$transparent_args = $args;
			$transparent_args['name'] .= '[transparent]';
			$transparent_args['checked'] = $transparent_args['value']['transparent'];
			$transparent_args['label'] = __( 'Transparent', 'enlightenment' );
			$transparent_args['value'] = 1;
			$output .= ' <br />';
			$output .= enlightenment_checkbox( $transparent_args, false );
		}
		
		$output .= '<br />';
	}
	
	$output .= empty( $description ) ? '' : '<p class="description">' . strip_tags( $description, '<a><abbr><img>' ) . '</p>';
	
	$output = apply_filters( 'enlightenment_color_picker', $output, $args );
	
	if( ! $echo )
		return $output;
	echo $output;
}

function enlightenment_background_options( $args, $echo = true ) {
	$defaults = array(
		'class' => '',
		'id' => '',
		'description' => '',
	);
	
	$args = wp_parse_args( $args, $defaults );
	
	if( ! isset( $args['name'] ) || empty( $args['name'] ) ) {
		_doing_it_wrong( __FUNCTION__, __( 'Please specify a name attribute for your background options.', 'enlightenment' ), '1.1.0' );
		return;
	}
	
	$description = $args['description'];
	unset( $args['description'] );
	
	$option = enlightenment_theme_option( $args['name'] );
	
	$color_picker_args = array(
		'name'  => $args['name'] . '[color]',
		'value' => isset( $args['value']['color'] ) ? $args['value']['color'] : $option['color'],
		'transparent' => true,
		'alpha' => true,
		'class' => 'background_color' . ( ! empty( $args['class'] ) ? ' ' . $args['class'] . '_background_color' : '' ),
		'id'    => ! empty( $args['id'] ) ? $args['id'] . '_background_color' : '',
	);
	
	$image_uploader_args = array(
		'name'  => $args['name'] . '[image]',
		'value' => isset( $args['value']['image'] ) ? $args['value']['image'] : $option['image'],
		'class' => 'background_image' . ( ! empty( $args['class'] ) ? ' ' . $args['class'] . '_background_image' : '' ),
		'id' => ! empty( $args['id'] ) ? $args['id'] . '_background_image' : '',
		'upload_button_text' => __( 'Choose Image', 'enlightenment' ),
		'uploader_title' => __( 'Select Image', 'enlightenment' ),
		'uploader_button_text' => __( 'Use Image', 'enlightenment' ),
		'remove_button_text' => __( 'Remove Image', 'enlightenment' ),
		'mime_type' => 'image',
		'thumbnail' => 'thumbnail',
	);
	
	$position_args = array(
		'name'  => $args['name'] . '[position]',
		'value' => isset( $args['value']['position'] ) ? $args['value']['position'] : $option['position'],
		'class' => 'background_position' . ( ! empty( $args['class'] ) ? ' ' . $args['class'] . '_background_position' : '' ),
		'id' => ! empty( $args['id'] ) ? $args['id'] . '_background_position' : '',
		'options' => array(
			'center'        => __( 'Center', 'enlightenment' ),
			'center-top'    => __( 'Center Top', 'enlightenment' ),
			'center-bottom' => __( 'Center Bottom', 'enlightenment' ),
			'left-top'      => __( 'Left Top', 'enlightenment' ),
			'left-center'   => __( 'Left Center', 'enlightenment' ),
			'left-bottm'    => __( 'Left Bottom', 'enlightenment' ),
			'right-top'     => __( 'Right Top', 'enlightenment' ),
			'right-center'  => __( 'Right Center', 'enlightenment' ),
			'right-bottom'  => __( 'Right Bottom', 'enlightenment' ),
		),
	);
	
	$repeat_args = array(
		'name'  => $args['name'] . '[repeat]',
		'value' => isset( $args['value']['repeat'] ) ? $args['value']['repeat'] : $option['repeat'],
		'class' => 'background_repeat' . ( ! empty( $args['class'] ) ? ' ' . $args['class'] . '_background_repeat' : '' ),
		'id' => ! empty( $args['id'] ) ? $args['id'] . '_background_repeat' : '',
		'options' => array(
			'no-repeat'  => __( 'No Repeat', 'enlightenment' ),
			'repeat'     => __( 'Tiled', 'enlightenment' ),
			'repeat-x'   => __( 'Tiled Horizontally', 'enlightenment' ),
			'repeat-y'   => __( 'Tiled Vertically', 'enlightenment' ),
		),
	);
	
	$size_args = array(
		'name'  => $args['name'] . '[size]',
		'value' => isset( $args['value']['size'] ) ? $args['value']['size'] : $option['size'],
		'class' => 'background_size' . ( ! empty( $args['class'] ) ? ' ' . $args['class'] . '_background_size' : '' ),
		'id' => ! empty( $args['id'] ) ? $args['id'] . '_background_size' : '',
		'options' => array(
			'auto'    => __( 'Scaled', 'enlightenment' ),
			'cover'   => __( 'Cover', 'enlightenment' ),
			'contain' => __( 'Contained', 'enlightenment' ),
		),
	);
	
	$scroll_args = array(
		'name'  => $args['name'] . '[scroll]',
		'value' => isset( $args['value']['scroll'] ) ? $args['value']['scroll'] : $option['scroll'],
		'class' => 'background_scroll' . ( ! empty( $args['class'] ) ? ' ' . $args['class'] . '_background_scroll' : '' ),
		'id' => ! empty( $args['id'] ) ? $args['id'] . '_background_scroll' : '',
		'options' => array(
			'scroll'   => __( 'Scroll', 'enlightenment' ),
			'fixed'    => __( 'Fixed', 'enlightenment' ),
			'parallax' => __( 'Parallax', 'enlightenment' ),
		),
	);
	
	$output = enlightenment_open_tag( 'fieldset', 'background-options' );
	$output .= enlightenment_color_picker( $color_picker_args, false );
	$output .= enlightenment_upload_media( $image_uploader_args, false );
	$output .= enlightenment_select_box( $position_args, false );
	$output .= enlightenment_select_box( $repeat_args, false );
	$output .= enlightenment_select_box( $size_args, false );
	$output .= enlightenment_select_box( $scroll_args, false );
	$output .= enlightenment_close_tag( 'fieldset' );
	$output .= empty( $description ) ? '' : '<p class="description">' . strip_tags( $description, '<a><abbr><img>' ) . '</p>';
	
	$output = apply_filters( 'enlightenment_background_options', $output, $args );
	
	if( ! $echo ) {
		return $output;
	}
	
	echo $output;
}

function enlightenment_font_options( $args, $echo = true ) {
	$defaults = array(
		'class' => '',
		'id' => '',
		'description' => '',
	);
	$args = wp_parse_args( $args, $defaults );
	if( ! isset( $args['name'] ) || empty( $args['name'] ) ) {
		_doing_it_wrong( __FUNCTION__, __( 'Please specify a name attribute for your font options.', 'enlightenment' ), '' );
		return;
	}
	$fonts = enlightenment_available_fonts();
	$font_family_args = array(
		'name' => $args['name'] . '_font_family',
		'class' => 'font_family' . ( ! empty( $args['class'] ) ? ' ' . $args['class'] . '_font_family' : '' ),
		'id' => ! empty( $args['id'] ) ? $args['id'] . '_font_family' : '',
		'options' => array(),
	);
	foreach( $fonts as $name => $font ) {
		// $font_family_args['options'][$name] = ( isset( $font['family'] ) ? str_replace( '"', '', $font['family'] ) : $name ) . ', ' . $font['category'];
		$font_family_args['options'][$name] = str_replace( '"', '', $font['family'] ) . ', ' . $font['category'];
	}
	$font_size_args = array(
		'name' => $args['name'] . '_font_size',
		'class' => 'font_size' . ( ! empty( $args['class'] ) ? ' ' . $args['class'] . '_font_size' : '' ),
		'id' => ! empty( $args['id'] ) ? $args['id'] . '_font_size' : '',
		'options' => array(),
	);
	$min_font_size = apply_filters( 'enlightenment_min_font_size', 10 );
	$max_font_size = apply_filters( 'enlightenment_max_font_size', 48 );
	$font_size_inc = apply_filters( 'enlightenment_font_size_inc', 1 );
	$font_size_unit = apply_filters( 'enlightenment_font_size_unit', 'px' );
	for( $i = $min_font_size; $i <= $max_font_size; $i = $i + $font_size_inc ) {
		$font_size_args['options'][$i] = intval( $i ) . ' ' . esc_attr( $font_size_unit );
	}
	$font_style_args = array(
		'name' => $args['name'] . '_font_style',
		'class' => 'font_style' . ( ! empty( $args['class'] ) ? ' ' . $args['class'] . '_font_style' : '' ),
		'id' => ! empty( $args['id'] ) ? $args['id'] . '_font_style' : '',
		'options' => enlightenment_font_styles(),
	);
	$color_picker_args = array(
		'name' => $args['name'] . '_font_color',
		'class' => 'font_color' . ( ! empty( $args['class'] ) ? ' ' . $args['class'] . '_font_color' : '' ),
		'id' => ! empty( $args['id'] ) ? $args['id'] . '_font_color' : '',
	);
	$output = enlightenment_open_tag( 'fieldset', 'font-options' );
	$output .= enlightenment_select_box( $font_family_args, false );
	$output .= enlightenment_select_box( $font_size_args, false );
	$output .= enlightenment_select_box( $font_style_args, false );
	$output .= enlightenment_color_picker( $color_picker_args, false );
	$output .= enlightenment_close_tag( 'fieldset' );
	$output .= empty( $args['description'] ) ? '' : '<p class="description">' . strip_tags( $args['description'], '<a><abbr><img>' ) . '</p>';
	$output = apply_filters( 'enlightenment_font_options', $output, $args );
	if( ! $echo )
		return $output;
	echo $output;
}

function enlightenment_font_styles() {
	$styles = array(
		'300' => __( 'Light', 'enlightenment' ),
		'300italic' => __( 'Light Italic', 'enlightenment' ),
		'400' => __( 'Regular', 'enlightenment' ),
		'italic' => __( 'Italic', 'enlightenment' ),
		'500' => __( 'Medium', 'enlightenment' ),
		'500italic' => __( 'Medium Italic', 'enlightenment' ),
		'600' => __( 'Semi-Bold', 'enlightenment' ),
		'600italic' => __( 'Semi-Bold Italic', 'enlightenment' ),
		'700' => __( 'Bold', 'enlightenment' ),
		'700italic' => __( 'Bold Italic', 'enlightenment' ),
	);
	return apply_filters( 'enlightenment_font_styles', $styles );
}

function enlightenment_image_radio_buttons( $args, $echo = true ) {
	$defaults = array(
		'class' => '',
		'buttons' => array(),
		'description' => '',
	);
	$args = wp_parse_args( $args, $defaults );
	$args['class'] .= ' image-radio-button';
	if( ! isset( $args['name'] ) || empty( $args['name'] ) ) {
		_doing_it_wrong( __FUNCTION__, __( 'Please specify a name attribute for your image radio buttons.', 'enlightenment' ), '' );
		return;
	}
	foreach( $args['buttons'] as $key => $button ) {
		if( ! isset( $button['image'] ) || empty( $button['image'] ) ) {
			_doing_it_wrong( __FUNCTION__, __( 'Please specify an image for your image radio button.', 'enlightenment' ), '' );
			return;
		}
		if( ! isset( $button['label'] ) )
			$button['label'] = '';
		$args['buttons'][$key]['label'] = '<img src="' . esc_url( $button['image'] ) . '" alt="' . esc_attr( $button['label'] ) . '" />';
	}
	$output = enlightenment_radio_buttons( $args, false );
	$output = str_replace( '<br />', '', $output );
	$output = apply_filters( 'enlightenment_image_radio_buttons', $output, $args );
	if( ! $echo )
		return $output;
	echo $output;
}

function enlightenment_custom_css( $args, $echo = true ) {
	$defaults = array(
		'class' => '',
		'id' => '',
		'description' => '',
	);
	$args = wp_parse_args( $args, $defaults );
	$args['class'] .= ' custom-css';
	$output = enlightenment_textarea( $args, false );
	$output = apply_filters( 'enlightenment_custom_css', $output, $args );
	if( ! $echo )
		return $output;
	echo $output;
}

function enlightenment_submit_button( $args, $echo = true ) {
	$defaults = array(
		'name' => '',
		'class' => 'button',
		'id' => '',
		'value' => '',
	);
	$args = wp_parse_args( $args, $defaults );
	$args = apply_filters( 'enlightenment_submit_button_args', $args );
	$output = '';
	$output .= '<input ';
	$output .= 'name="' . apply_filters( 'enlightenment_submit_button_name', esc_attr( $args['name'] ) ) . '"';
	$output .= enlightenment_class( $args['class'] );
	$output .= enlightenment_id( $args['id'] ) . ' ';
	$output .= 'value="' . esc_attr( $args['value'] ) . '" ';
	$output .= 'type="submit" ';
	$output .= '/>';
	$output = apply_filters( 'enlightenment_submit_button', $output, $args );
	if( ! $echo )
		return $output;
	echo $output;
}




