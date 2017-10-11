<?php

// Exit if accessed directly
if ( ! defined( 'ABSPATH' ) ) {
	exit; 
}

$did = isset($_GET['did']) ? $_GET['did'] : '0';
es_cls_security::es_check_number($did);
$pagenum = isset($_GET['pagenum']) ? $_GET['pagenum'] : 1;
es_cls_security::es_check_number($pagenum);

// First check if ID exist with requested ID
$result = es_cls_sentmail::es_sentmail_count($did);
if ($result != '1') {
	?><div class="error fade">
		<p><strong>
			<?php echo __( 'Oops, selected details does not exists.', ES_TDOMAIN ); ?>
		</strong></p>
	</div><?php
}

?>

<div class="wrap">
	<h2 style="margin-bottom:1em;">
		<?php echo __( 'Preview Email', ES_TDOMAIN ); ?>
		<a class="add-new-h2" target="_blank" href="<?php echo ES_FAV; ?>"><?php echo __( 'Help', ES_TDOMAIN ); ?></a>
	</h2>
	<p>
		<?php echo __( 'This is how the email you sent may look. <br>Note: Different email services (like gmail, yahoo etc) display email content differently. So there could be a slight variation on how your customer will view the email content.', ES_TDOMAIN ); ?>
	</p>
	<div class="tool-box">
		<div style="padding:15px;background-color:#FFFFFF;">
		<?php
			$preview = array();
			$preview = es_cls_sentmail::es_sentmail_select($did, 0, 0);
			$preview = str_replace("###NAME###", "Username", $preview);
			$preview = str_replace("###EMAIL###", "Useremail", $preview);

			$es_email_type = get_option( 'ig_es_emailtype' );	// Not the ideal way. Email type can differ while previewing sent email.

			if ( $es_email_type == "WP HTML MAIL" || $es_email_type == "PHP HTML MAIL" ) {
				$temp_content = $preview['es_sent_preview'];
				$temp_content =  convert_chars(convert_smilies( wptexturize( $temp_content )));
				if(isset($GLOBALS['wp_embed'])) {
					$temp_content = $GLOBALS['wp_embed']->autoembed($temp_content);
				}
				$temp_content = wpautop( $temp_content );
				// $temp_content = do_shortcode( shortcode_unautop( $temp_content ) );
				$preview['es_sent_preview'] = $temp_content;
			} else {
				$preview['es_sent_preview'] = str_replace("<br />", "\r\n", $preview['es_sent_preview']);
				$preview['es_sent_preview'] = str_replace("<br>", "\r\n", $preview['es_sent_preview']);
			}

			echo stripslashes($preview['es_sent_preview']);
		?>
		</div>
		<div class="tablenav">
			<h2>
				<a class="button-primary" href="<?php echo ES_ADMINURL; ?>?page=es-sentmail&pagenum=<?php echo $pagenum; ?>"><?php echo __( 'Back', ES_TDOMAIN ); ?></a>
			</h2>
		</div>
	</div>
</div>