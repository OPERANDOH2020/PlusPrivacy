<?php

// Exit if accessed directly
if ( ! defined( 'ABSPATH' ) ) {
	exit; 
}

class es_cls_widget {
	public static function load_subscription($arr) {
		$es_name = trim($arr['es_name']);
		$es_desc = trim($arr['es_desc']);
		$es_group = trim($arr['es_group']);
		$url = "'" . home_url() . "'";
		$es = "";

		global $es_includes;
		if (!isset($es_includes) || $es_includes !== true) {
			$es_includes = true;
		}

		$es .= '<div>';
		$es .= '<form class="es_shortcode_form" data-es_form_id="es_shortcode_form">';

		if( $es_desc != "" ) {
			$es .= '<div class="es_caption">'.$es_desc.'</div>';
		}
		if( $es_name == "YES" ) {
			$es .= '<div class="es_lablebox"><label class="es_shortcode_form_name">'.__( 'Name', ES_TDOMAIN ).'</label></div>';
			$es .= '<div class="es_textbox">';
				$es .= '<input type="text" id="es_txt_name_pg" class="es_textbox_class" name="es_txt_name_pg" value="" maxlength="225">';
			$es .= '</div>';
		}
		$es .= '<div class="es_lablebox"><label class="es_shortcode_form_email">'.__( 'Email *', ES_TDOMAIN ).'</label></div>';
		$es .= '<div class="es_textbox">';
			$es .= '<input type="text" id="es_txt_email_pg" class="es_textbox_class" name="es_txt_email_pg" onkeypress="if(event.keyCode==13) es_submit_pages(event, '.$url.')" value="" maxlength="225">';
		$es .= '</div>';
		$es .= '<div class="es_button">';
			$es .= '<input type="button" id="es_txt_button_pg" class="es_textbox_button es_submit_button" name="es_txt_button_pg" onClick="return es_submit_pages(event, '.$url.')" value="'.__( 'Subscribe', ES_TDOMAIN ).'">';
		$es .= '</div>';
		$es .= '<div class="es_msg" id="es_shortcode_msg"><span id="es_msg_pg"></span></div>';
		if( $es_name != "YES" ) {
			$es .= '<input type="hidden" id="es_txt_name_pg" name="es_txt_name_pg" value="">';
		}
		$es .= '<input type="hidden" id="es_txt_group_pg" name="es_txt_group_pg" value="'.$es_group.'">';

		$es .= '</form>';
		$es .= '</div>';
		return $es;
	}
}

function es_shortcode( $atts ) {
	if ( ! is_array( $atts ) ) {
		return '';
	}

	$es_name = isset($atts['namefield']) ? $atts['namefield'] : 'YES';
	$es_desc = isset($atts['desc']) ? $atts['desc'] : '';
	$es_group = isset($atts['group']) ? $atts['group'] : '';

	$arr = array();
	$arr["es_title"] 	= "";
	$arr["es_desc"] 	= $es_desc;
	$arr["es_name"] 	= $es_name;
	$arr["es_group"] 	= $es_group;
	return es_cls_widget::load_subscription($arr);
}

function es_subbox( $namefield = "YES", $desc = "", $group = "" ) {
	$arr = array();
	$arr["es_title"] 	= "";
	$arr["es_desc"] 	= $desc;
	$arr["es_name"] 	= $namefield;
	$arr["es_group"] 	= $group;
	echo es_cls_widget::load_subscription($arr);
}