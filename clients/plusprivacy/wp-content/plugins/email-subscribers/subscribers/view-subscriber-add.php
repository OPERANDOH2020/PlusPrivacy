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

	// Preset the form fields
	$form = array(
		'es_email_name' => '',
		'es_email_status' => '',
		'es_email_group' => '',
		'es_email_mail' => ''
	);

	// Form submitted, check the data
	if (isset($_POST['es_form_submit']) && $_POST['es_form_submit'] == 'yes') {

		// Just security thingy that wordpress offers us
		check_admin_referer('es_form_add');

		$form['es_email_status'] = isset($_POST['es_email_status']) ? $_POST['es_email_status'] : '';
		$form['es_email_name'] = isset($_POST['es_email_name']) ? $_POST['es_email_name'] : '';

		$form['es_email_mail'] = isset($_POST['es_email_mail']) ? $_POST['es_email_mail'] : '';
		if ($form['es_email_mail'] == '') {
			$es_errors[] = __( 'Please enter subscriber email address.', ES_TDOMAIN );
			$es_error_found = TRUE;
		}

		$es_email_group = isset($_POST['es_email_group']) ? $_POST['es_email_group'] : '';
		if ($es_email_group == '') {
			$es_email_group = isset($_POST['es_email_group_txt']) ? $_POST['es_email_group_txt'] : '';
			$form['es_email_group'] = $es_email_group;
		} else {
			$form['es_email_group'] = $es_email_group;
		}

		if ($form['es_email_group'] == '') {
			$es_errors[] = __( 'Please select or create your group for this email.', ES_TDOMAIN );
			$es_error_found = TRUE;
		}

		if($form['es_email_group'] != "") {
			$special_letters = es_cls_common::es_special_letters();
			if (preg_match($special_letters, $form['es_email_group'])) {
				$es_errors[] = __( 'Error: Special characters ([\'^$%&*()}{@#~?><>,|=_+\"]) are not allowed in the group name.', ES_TDOMAIN );
				$es_error_found = TRUE;
			}
		}

		//	No errors found, we can add this Group to the table
		if ($es_error_found == FALSE) {
			$action = "";
			$action = es_cls_dbquery::es_view_subscriber_ins($form, "insert");
			if($action == "sus") {
				$es_success = __( 'Subscriber has been saved.', ES_TDOMAIN );
			} elseif($action == "ext") {
				$es_errors[] = __( 'Subscriber already exists.', ES_TDOMAIN );
				$es_error_found = TRUE;
			} elseif($action == "invalid") {
				$es_errors[] = __( 'Invalid Email.', ES_TDOMAIN );
				$es_error_found = TRUE;
			}

			// Reset the form fields
			$form = array(
				'es_email_name' => '',
				'es_email_status' => '',
				'es_email_group' => '',
				'es_email_mail' => ''
			);
		}
	}

	if ($es_error_found == TRUE && isset($es_errors[0]) == TRUE) {
		?><div class="error fade">
			<p><strong>
				<?php echo $es_errors[0]; ?>
			</strong></p>
		</div><?php
	}
	if ($es_error_found == FALSE && isset($es_success[0]) == TRUE) {
		?><div class="notice notice-success is-dismissible">
			<p><strong>
				<?php echo $es_success; ?>
			</strong></p>
		</div><?php
	}

	?>

	<style type="text/css">
		.form-table th {
			width:260px;
		}
	</style>

	<div class="wrap">
		<h2>
			<?php echo __( 'Add New Subscriber', ES_TDOMAIN ); ?>
			<a class="add-new-h2" href="<?php echo ES_ADMINURL; ?>?page=es-view-subscribers&amp;ac=import"><?php echo __( 'Import', ES_TDOMAIN ); ?></a>
			<a class="add-new-h2" href="<?php echo ES_ADMINURL; ?>?page=es-view-subscribers&amp;ac=export"><?php echo __( 'Export', ES_TDOMAIN ); ?></a>
			<a class="add-new-h2" href="<?php echo ES_ADMINURL; ?>?page=es-view-subscribers&amp;ac=sync"><?php echo __( 'Sync', ES_TDOMAIN ); ?></a>
			<a class="add-new-h2" target="_blank" href="<?php echo ES_FAV; ?>"><?php echo __( 'Help', ES_TDOMAIN ); ?></a>
		</h2>
		<form name="form_addemail" method="post" action="#" onsubmit="return _es_addemail()">
			<div class="tool-box">
				<table class="form-table">
					<tbody>
						<tr>
							<th scope="row">
								<label for="tag-image">
									<?php echo __( 'Enter Subscriber\'s Full name', ES_TDOMAIN ); ?>
								</label>						
							</th>
							<td>
								<input name="es_email_name" type="text" id="es_email_name" value="" maxlength="225" size="30" />
							</td>
						</tr>
						<tr>
							<th>
								<label for="tag-image">
									<?php echo __( 'Enter Subscriber\'s Email Address', ES_TDOMAIN ); ?>
								</label>
							</th>
							<td>
								<input name="es_email_mail" type="text" id="es_email_mail" value="" maxlength="225" size="30" />
							</td>
						</tr>
						<tr>
							<th>
								<label for="tag-display-status">
									<?php echo __( 'Select Subscriber\'s Status', ES_TDOMAIN ); ?>
								</label>
							</th>
							<td>
								<select name="es_email_status" id="es_email_status">
									<option value='Confirmed' selected="selected"><?php echo __( 'Confirmed', ES_TDOMAIN ); ?></option>
									<option value='Unconfirmed'><?php echo __( 'Unconfirmed', ES_TDOMAIN ); ?></option>
									<option value='Unsubscribed'><?php echo __( 'Unsubscribed', ES_TDOMAIN ); ?></option>
									<option value='Single Opt In'><?php echo __( 'Single Opt In', ES_TDOMAIN ); ?></option>
								</select>
							</td>
						</tr>
						<tr>
							<th>
								<label for="tag-display-status">
									<?php echo __( 'Select (or) Create Group for Subscriber', ES_TDOMAIN ); ?></label>
							</th>
							<td>
								<select name="es_email_group" id="es_email_group">
									<option value=''><?php echo __( 'Select', ES_TDOMAIN ); ?></option>
									<?php
									$groups = array();
									$groups = es_cls_dbquery::es_view_subscriber_group();
									if(count($groups) > 0) {
										$i = 1;
										foreach ($groups as $group) {
											?><option value="<?php echo stripslashes($group["es_email_group"]); ?>"><?php echo stripslashes($group["es_email_group"]); ?></option><?php
										}
									}
									?>
								</select>
								<?php echo __('(or)', ES_TDOMAIN );?>
								<input name="es_email_group_txt" type="text" id="es_email_group_txt" value="" maxlength="225" />
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<input type="hidden" name="es_form_submit" value="yes"/>
			<p style="padding-top:5px;">
				<input type="submit" class="button-primary" value="<?php echo __( 'Add Subscriber', ES_TDOMAIN ); ?>" />
			</p>
			<?php wp_nonce_field('es_form_add'); ?>
		</form>
	</div>
</div>