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
		<p><strong>\
			<?php echo __( 'Oops, selected details does not exists.', ES_TDOMAIN ); ?>
		</strong></p>
	</div><?php
}

?>

<div class="wrap">
	<h2 style="margin-bottom:1em;">
		<?php echo __( 'Preview Mail', ES_TDOMAIN ); ?>
		<a class="add-new-h2" target="_blank" href="<?php echo ES_FAV; ?>"><?php echo __( 'Help', ES_TDOMAIN ); ?></a>
	</h2>
	<div class="tool-box">
		<div style="padding:15px;background-color:#FFFFFF;">
		<?php
			$preview = array();
			$preview = es_cls_sentmail::es_sentmail_select($did, 0, 0);
			$preview = str_replace('###NAME###', "Username", $preview);
			$preview = str_replace('###EMAIL###', "Useremail", $preview);
			echo stripslashes($preview['es_sent_preview']);
		?>
		</div>
		<div class="tablenav">
			<h2>
				<a class="button-primary" href="<?php echo ES_ADMINURL; ?>?page=es-sentmail&pagenum=<?php echo $pagenum; ?>"><?php echo __( 'Back', ES_TDOMAIN ); ?></a>
			</h2>
		</div>
		<div style="height:10px;"></div>
		<p class="description"><?php echo ES_OFFICIAL; ?></p>
	</div>
</div>