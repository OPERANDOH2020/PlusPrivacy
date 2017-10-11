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
	$csv = array();

	// Preset the form fields
	$form = array(
		'es_email_name' => '',
		'es_email_status' => '',
		'es_email_group' => '',
		'es_email_mail' => ''
	);

	// Form submitted, check the data
	if (isset($_POST['es_form_submit']) && $_POST['es_form_submit'] == 'yes') {

		//	Just security thingy that wordpress offers us
		check_admin_referer('es_form_add');

		$extension = pathinfo( $_FILES['es_csv_name']['name'], PATHINFO_EXTENSION );

		$tmpname = $_FILES['es_csv_name']['tmp_name'];
		
		$es_email_status = isset($_POST['es_email_status']) ? $_POST['es_email_status'] : '';
		$es_email_group = isset($_POST['es_email_group']) ? $_POST['es_email_group'] : '';
		if ($es_email_group == '') {
			$es_email_group = isset($_POST['es_email_group_txt']) ? $_POST['es_email_group_txt'] : '';
		}

		if($es_email_group <> "") {
			$special_letters = es_cls_common::es_special_letters();
			if (preg_match($special_letters, $es_email_group)) {
				$es_errors[] = __( 'Error: Special characters ([\'^$%&*()}{@#~?><>,|=_+\"]) are not allowed in the Group name.', ES_TDOMAIN );
				$es_error_found = TRUE;
			}
		}

		if ( $es_email_status == '' ) {
			$es_email_status = "Confirmed";
		}

		if ( $es_email_group == '' ) {
			$es_email_group = "Public";
		}

		if( $extension === 'csv' ) {
			$csv = es_cls_common::es_readcsv($tmpname);
		}

		//	No errors found, we can add this Group to the table
		if ( $es_error_found == FALSE ) {
			if(count($csv) > 0) {
				$inserted = 0;
				$duplicate = 0;
				$invalid = 0;
				for ($i = 1; $i < count($csv) - 1; $i++) {
					$form["es_email_mail"] = trim($csv[$i][0]);
					$form["es_email_name"] = trim($csv[$i][1]);
					$form["es_email_group"] = $es_email_group;
					$form["es_email_status"] = $es_email_status;
					$action = es_cls_dbquery::es_view_subscriber_ins($form, "insert");
					if( $action == "sus" ) {
						$inserted = $inserted + 1;
					} elseif( $action == "ext" ) {
						$duplicate = $duplicate + 1;
					} elseif( $action == "invalid" ) {
						$invalid = $invalid + 1;
					}

					// Reset the form fields
					$form = array(
						'es_email_name' => '',
						'es_email_status' => '',
						'es_email_group' => '',
						'es_email_mail' => ''
					);
				}

				?>
				<div class="notice notice-success is-dismissible">
					<p><strong><?php echo $inserted; ?> <?php echo __( 'email imported.', ES_TDOMAIN ); ?></strong></p>
					<p><strong><?php echo $duplicate; ?> <?php echo __( 'email already exists.', ES_TDOMAIN ); ?></strong></p>
					<p><strong><?php echo $invalid; ?> <?php echo __( 'email are invalid.', ES_TDOMAIN ); ?></strong></p>
					<p><strong>
							<a href="<?php echo ES_ADMINURL; ?>?page=es-view-subscribers">
							<?php echo __( 'Click here', ES_TDOMAIN ); ?></a> <?php echo __(' to view details.', ES_TDOMAIN ); ?>
					</strong></p>
				</div>
				<?php
			} else {
				?>
				<div class="error fade">
					<p><strong>
						<?php echo __( 'File Upload Failed.', ES_TDOMAIN ); ?>
					</strong></p>
				</div>
				<?php
			}
		}
	}

	if ($es_error_found == TRUE && isset($es_errors[0]) == TRUE) {
		?>
		<div class="error fade">
			<p><strong><?php echo $es_errors[0]; ?></strong></p>
		</div>
		<?php
	}

	if ($es_error_found == FALSE && isset($es_success[0]) == TRUE) {
		?>
		<div class="notice notice-success is-dismissible">
			<p><strong>
				<?php echo $es_success; ?><a href="<?php echo ES_ADMINURL; ?>?page=es-view-subscribers">
				<?php echo __( 'Click here', ES_TDOMAIN ); ?></a> <?php echo __( ' to view details.', ES_TDOMAIN ); ?>
			</strong></p>
		</div>
		<?php
	}

	?>

	<style type="text/css">
		.form-table th {
			width:300px;
		}
	</style>

	<div class="wrap">
		<h2>
			<?php echo __( 'Import Email Addresses', ES_TDOMAIN ); ?>
			<a class="add-new-h2" href="<?php echo ES_ADMINURL; ?>?page=es-view-subscribers&amp;ac=add"><?php echo __( 'Add New Subscriber', ES_TDOMAIN ); ?></a>
			<a class="add-new-h2" href="<?php echo ES_ADMINURL; ?>?page=es-view-subscribers&amp;ac=export"><?php echo __( 'Export', ES_TDOMAIN ); ?></a>
			<a class="add-new-h2" href="<?php echo ES_ADMINURL; ?>?page=es-view-subscribers&amp;ac=sync"><?php echo __( 'Sync', ES_TDOMAIN ); ?></a>
			<a class="add-new-h2" target="_blank" href="<?php echo ES_FAV; ?>"><?php echo __( 'Help', ES_TDOMAIN ); ?></a>
		</h2>
		<div class="tool-box">
			<form name="form_addemail" id="form_addemail" method="post" action="#" onsubmit="return _es_importemail()" enctype="multipart/form-data">
				<table class="form-table">
					<tbody>
						<tr>
							<th scope="row">
								<label for="tag-image">
									<?php echo __( 'Select CSV file', ES_TDOMAIN ); ?>
									<p class="description">
										<?php echo __( 'Check CSV structure ', ES_TDOMAIN ); ?>
										<a target="_blank" href="https://www.icegram.com/documentation/es-how-to-import-or-export-email-addresses/?utm_source=es&utm_medium=in_app&utm_campaign=view_docs_help_page"><?php echo __( 'from here', ES_TDOMAIN ); ?></a>
									</p>
								</label>
							</th>
							<td>
								<input type="file" name="es_csv_name" id="es_csv_name" />
							</td>
						</tr>
						<tr>
							<th scope="row">
								<label for="tag-email-status">
									<?php echo __( 'Select Subscribers Email Status', ES_TDOMAIN ); ?>
									<p><?php echo __( '', ES_TDOMAIN ); ?></p>
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
								<label for="tag-email-group">
									<?php echo __( 'Select (or) Create Group for Subscribers', ES_TDOMAIN ); ?>
								</label>
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
											?><option value='<?php echo $group["es_email_group"]; ?>'><?php echo $group["es_email_group"]; ?></option><?php
										}
									}
									?>
								</select>
								<?php echo __( '(or)', ES_TDOMAIN ); ?>
								<input name="es_email_group_txt" type="text" id="es_email_group_txt" value="" maxlength="225" />
							</td>
						</tr>
					</tbody>
				</table>
				<input type="hidden" name="es_form_submit" value="yes"/>
				<p style="padding-top:10px;">
					<input type="submit" class="button-primary" value="<?php echo __( 'Import', ES_TDOMAIN ); ?>" />
				</p>
				<?php wp_nonce_field('es_form_add'); ?>
			</form>
		</div>
	</div>
</div>