<?php

// Exit if accessed directly
if ( ! defined( 'ABSPATH' ) ) {
	exit; 
}

$es_c_email_subscribers_ver = get_option('email-subscribers');
if ($es_c_email_subscribers_ver != "2.9") {
	?>
	<div class="error fade">
		<p>
		Note: You have recently upgraded the plugin and your tables are not sync. 
		Please <a title="Sync plugin tables." href="<?php echo ES_ADMINURL; ?>?page=es-settings&amp;ac=sync"><?php echo __( 'Click Here', ES_TDOMAIN ); ?></a> to sync the table. This is mandatory and it will not affect your data.
		</p>
	</div>
	<?php
}

// Form submitted, check the data
if (isset($_POST['frm_es_display']) && $_POST['frm_es_display'] == 'yes') {
	$did = isset($_GET['did']) ? $_GET['did'] : '0';
	es_cls_security::es_check_number($did);

	$es_success = '';
	$es_success_msg = FALSE;

	// First check if ID exist with requested ID
	$result = es_cls_compose::es_template_count($did);
	if ($result != '1') {
		?><div class="error fade">
			<p><strong>
				<?php echo __( 'Oops, selected details does not exists.', ES_TDOMAIN ); ?>
			</strong></p>
		</div><?php
	} else {
		// Form submitted, check the action
		if (isset($_GET['ac']) && $_GET['ac'] == 'del' && isset($_GET['did']) && $_GET['did'] != '') {
			//	Just security thingy that wordpress offers us
			check_admin_referer('es_form_show');

			//	Delete selected record from the table
			es_cls_compose::es_template_delete($did);

			//	Set success message
			$es_success_msg = TRUE;
			$es_success = __( 'Selected record deleted.', ES_TDOMAIN );
		}
	}
	
	if ($es_success_msg == TRUE) {
		?><div class="notice notice-success is-dismissible">
			<p><strong>
				<?php echo $es_success; ?>
			</strong></p>
		</div><?php
	}
}

?>

<div class="wrap">
	<h2 style="margin-bottom:1em;">
		<?php echo __( 'Compose', ES_TDOMAIN ); ?>  
		<a class="add-new-h2" href="<?php echo ES_ADMINURL; ?>?page=es-compose&amp;ac=add"><?php echo __( 'Add New', ES_TDOMAIN ); ?></a>
		<a class="add-new-h2" target="_blank" href="<?php echo ES_FAV; ?>"><?php echo __( 'Help', ES_TDOMAIN ); ?></a>
	</h2>
	<div class="tool-box">
		<?php
			$myData = array();
			$myData = es_cls_compose::es_template_select(0);
		?>
		<form name="frm_es_display" method="post">
			<table width="100%" class="widefat" id="straymanage">
				<thead>
					<tr>
						<th scope="col"><?php echo __( 'Email Subject', ES_TDOMAIN ); ?></th>
						<th scope="col"><?php echo __( 'Email Template', ES_TDOMAIN ); ?></th>
						<th scope="col"><?php echo __( 'Actions', ES_TDOMAIN ); ?></th>
					</tr>
				</thead>
				<tfoot>
					<tr>
						<th scope="col"><?php echo __( 'Email Subject', ES_TDOMAIN ); ?></th>
						<th scope="col"><?php echo __( 'Email Template', ES_TDOMAIN ); ?></th>
						<th scope="col"><?php echo __( 'Actions', ES_TDOMAIN ); ?></th>
					</tr>
				</tfoot>
				<tbody>
					<?php 
						$i = 0;
						$displayisthere = FALSE;
						if(count($myData) > 0) {
							$i = 1;
							foreach ($myData as $data) {
							?>
								<tr class="<?php if ($i&1) { echo'alternate'; } else { echo ''; }?>">
									<td><?php echo esc_html(stripslashes($data['es_templ_heading'])); ?></td>
									<td><?php echo $data['es_email_type']; ?></td>
									<td>
										<a title="Edit" href="<?php echo ES_ADMINURL; ?>?page=es-compose&amp;ac=edit&amp;did=<?php echo $data['es_templ_id']; ?>"><?php echo __( 'Edit', ES_TDOMAIN ); ?></a> 
										| <a onClick="javascript:_es_delete('<?php echo $data['es_templ_id']; ?>')" href="javascript:void(0);"><?php echo __( 'Delete', ES_TDOMAIN ); ?></a>
										| <a title="Preview" href="<?php echo ES_ADMINURL; ?>?page=es-compose&amp;ac=preview&amp;did=<?php echo $data['es_templ_id']; ?>"><?php echo __( 'Preview', ES_TDOMAIN ); ?></a>
									</td>
								</tr>
							<?php
								$i = $i+1;
							}
						} else {
							?><tr>
								<td colspan="3" align="center"><?php echo __( 'No records available.', ES_TDOMAIN ); ?></td>
							</tr><?php 
						}
					?>
				</tbody>
			</table>
			<?php wp_nonce_field('es_form_show'); ?>
			<input type="hidden" name="frm_es_display" value="yes"/>
		</form>
	</div>
	<div style="height:10px;"></div>
	<p class="description"><?php echo ES_OFFICIAL; ?></p>
</div>