<?php

// Exit if accessed directly
if ( ! defined( 'ABSPATH' ) ) {
	exit; 
}

?>

<div class="wrap">
	<?php
		// Form submitted, check the data
		if (isset($_POST['es_form_submit']) && $_POST['es_form_submit'] == 'yes') {
			check_admin_referer('es_form_sync');

			$es_success = __( 'Table sync completed successfully.', ES_TDOMAIN );
			es_cls_registerhook::es_synctables();
			?><div class="notice notice-success is-dismissible">
				<p><strong>
					<?php echo $es_success; ?>
				</strong></p>
			</div><?php
		}
	?>
	<div class="form-wrap">
		<div id="icon-plugins" class="icon32"></div>
		<h2><?php echo __( ES_PLUGIN_DISPLAY, ES_TDOMAIN ); ?></h2>
		<form name="form_addemail" method="post" action="#" onsubmit="return _es_addemail()"  >
			<h3 class="title"><?php echo __( 'Sync plugin tables', ES_TDOMAIN ); ?></h3>
			<input type="hidden" name="es_form_submit" value="yes"/>
			<div style="padding-top:5px;"></div>
			<p>
				<input type="submit" name="publish" lang="publish" class="button-primary" value="<?php echo __( 'Click to sync tables', ES_TDOMAIN ); ?>" />
			</p>
			<?php wp_nonce_field('es_form_sync'); ?>
		</form>
	</div>
</div>