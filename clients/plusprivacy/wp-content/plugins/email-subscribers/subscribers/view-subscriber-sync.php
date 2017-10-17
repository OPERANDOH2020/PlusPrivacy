<?php

// Exit if accessed directly
if ( ! defined( 'ABSPATH' ) ) {
	exit;
}

?>

<div class="wrap">
	<?php

	$es_errors = array();
	$es_success = '';
	$es_error_found = FALSE;

	$es_registered = "";
	$es_registered_group = "";

	// Preset the form fields
	$form = array(
		'es_registered' => '',
		'es_registered_group' => ''
	);

	// Form submitted, check the data
	if (isset($_POST['es_form_submit']) && $_POST['es_form_submit'] == 'yes') {

		// Just security thingy that wordpress offers us
		check_admin_referer('es_form_add');

		$form['es_registered'] = isset($_POST['es_registered']) ? $_POST['es_registered'] : '';
		$form['es_registered_group'] = isset($_POST['es_registered_group']) ? $_POST['es_registered_group'] : '';

		if ($form['es_registered_group'] == '' && $form['es_registered'] == "YES") {
			$es_errors[] = __( 'Please select default group to newly registered user.', ES_TDOMAIN );
			$es_error_found = TRUE;
		}

		//	No errors found, we can add this Group to the table
		if ($es_error_found == FALSE) {
			update_option( 'ig_es_sync_wp_users', $form );	// what will happent to option??

			// Reset the form fields
			$form = array(
				'es_registered' => '',
				'es_registered_group' => ''
			);

			$es_success = __( 'Emails Successfully Synced.', ES_TDOMAIN );
		}
	}

	$es_c_emailsubscribers = get_option( 'ig_es_sync_wp_users', 'norecord' );
	if($es_c_emailsubscribers != 'norecord' && $es_c_emailsubscribers != "") {

		$es_sync_unserialized_data = maybe_unserialize($es_c_emailsubscribers);
		$es_registered = $es_sync_unserialized_data['es_registered'];
		$es_registered_group = $es_sync_unserialized_data['es_registered_group'];
	}

	if ($es_error_found == TRUE && isset($es_errors[0]) == TRUE) {
		?><div class="error fade">
			<p><strong>
				<?php echo $es_errors[0]; ?>
			</strong></p>
		</div><?php
	}

	if ($es_error_found == FALSE && isset($es_success[0]) == TRUE) {
		?>
		<div class="notice notice-success is-dismissible">
			<p><strong><?php echo $es_success; ?></strong></p>
		</div>
		<?php
	}

	?>

	<style type="text/css">
		.form-table th {
			width:350px;
		}
	</style>

	<div class="wrap">
		<h2>
			<?php echo __( 'Sync Email', ES_TDOMAIN ); ?>
			<a class="add-new-h2" href="<?php echo ES_ADMINURL; ?>?page=es-view-subscribers&amp;ac=add"><?php echo __( 'Add New Subscriber', ES_TDOMAIN ); ?></a>
			<a class="add-new-h2" href="<?php echo ES_ADMINURL; ?>?page=es-view-subscribers&amp;ac=import"><?php echo __( 'Import', ES_TDOMAIN ); ?></a>
			<a class="add-new-h2" href="<?php echo ES_ADMINURL; ?>?page=es-view-subscribers&amp;ac=export"><?php echo __( 'Export', ES_TDOMAIN ); ?></a>
			<a class="add-new-h2" target="_blank" href="<?php echo ES_FAV; ?>"><?php echo __( 'Help', ES_TDOMAIN ); ?></a>
		</h2>
		<form name="form_addemail" method="post" action="#" onsubmit="return _es_addemail()">
			<div class="tool-box">
				<table class="form-table">
					<tbody>
						<tr>
							<th scope="row">
								<label for="tag-image">
									<?php echo __( 'Sync newly registered users to subscribers list', ES_TDOMAIN ); ?>
								</label>
							</th>
							<td>
								<select name="es_registered" id="es_email_status">
									<option value='NO' <?php if($es_registered == 'NO') { echo "selected='selected'" ; } ?>><?php echo __( 'NO', ES_TDOMAIN ); ?></option>
									<option value='YES' <?php if($es_registered == 'YES') { echo "selected='selected'" ; } ?>><?php echo __( 'YES', ES_TDOMAIN ); ?></option>
								</select>
							</td>
						</tr>
						<tr>
							<th>
								<label for="tag-display-status">
									<?php echo __( 'Select group to add newly registered users to', ES_TDOMAIN ); ?>
								</label>
							</th>
							<td>
								<select name="es_registered_group" id="es_email_group">
									<option value=''><?php echo __( 'Select', ES_TDOMAIN ); ?></option>
									<?php
									$thisselected = "";
									$groups = array();
									$groups = es_cls_dbquery::es_view_subscriber_group();
									if(count($groups) > 0) {
										$i = 1;
										foreach ($groups as $group) {
											if($group["es_email_group"] == $es_registered_group) {
												$thisselected = "selected='selected'" ;
											}
											?><option value='<?php echo $group["es_email_group"]; ?>' <?php echo $thisselected; ?>><?php echo $group["es_email_group"]; ?></option><?php
											$thisselected = "";
										}
									}
									?>
								</select>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<input type="hidden" name="es_form_submit" value="yes"/>
			<p style="padding-top:5px;">
				<input type="submit" class="button-primary" value="<?php echo __( 'Sync', ES_TDOMAIN ); ?>" />
			</p>
			<?php wp_nonce_field('es_form_add'); ?>
		</form>
	</div>
</div>