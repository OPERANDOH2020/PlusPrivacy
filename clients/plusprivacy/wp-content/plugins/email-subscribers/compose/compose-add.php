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
		'es_templ_heading' => '',
		'es_templ_body' => '',
		'es_templ_status' => '',
		'es_email_type' => ''
	);

	// Form submitted, check the data
	if (isset($_POST['es_form_submit']) && $_POST['es_form_submit'] == 'yes') {
		//	Just security thingy that wordpress offers us
		check_admin_referer('es_form_add');

		$form['es_templ_heading'] = isset($_POST['es_templ_heading']) ? $_POST['es_templ_heading'] : '';
		if ($form['es_templ_heading'] == '') {
			$es_errors[] = __( 'Please enter template heading.', ES_TDOMAIN );
			$es_error_found = TRUE;
		}
		$form['es_templ_body'] = isset($_POST['es_templ_body']) ? $_POST['es_templ_body'] : '';
		$form['es_templ_status'] = isset($_POST['es_templ_status']) ? $_POST['es_templ_status'] : '';
		$form['es_email_type'] = isset($_POST['es_email_type']) ? $_POST['es_email_type'] : '';

		//	No errors found, we can add this Group to the table
		if ($es_error_found == FALSE) {
			$action = false;
			$action = es_cls_compose::es_template_ins($form, $action = "insert");
			if($action) {
				$es_success = __( 'Template successfully created. ', ES_TDOMAIN );
			}

			// Reset the form fields
			$form = array(
				'es_templ_heading' => '',
				'es_templ_body' => '',
				'es_templ_status' => '',
				'es_email_type' => ''
			);
		}
	}

	if ($es_error_found == TRUE && isset($es_errors[0]) == TRUE) {
		?><div class="error fade"><p><strong><?php echo $es_errors[0]; ?></strong></p></div><?php
	}

	if ($es_error_found == FALSE && strlen($es_success) > 0) {
		?>
		<div class="notice notice-success is-dismissible">
			<p><strong>
				<?php echo $es_success; ?>
			</strong></p>
		</div>
		<?php
	}

	?>

	<div class="form-wrap">
		<h2>
			<?php echo __( 'Add new Email', ES_TDOMAIN ); ?>
			<a class="add-new-h2" target="_blank" href="<?php echo ES_FAV; ?>"><?php echo __( 'Help', ES_TDOMAIN ); ?></a>
		</h2>
		<form name="es_form" method="post" action="#" onsubmit="return _es_submit()">
			<label for="tag-link"><?php echo __( 'Select your Mail Template', ES_TDOMAIN ); ?></label>
			<select name="es_email_type" id="es_email_type">
				<option value='Newsletter' selected="selected"><?php echo __( 'Newsletter', ES_TDOMAIN ); ?></option>
				<option value='Post Notification'><?php echo __( 'Post Notification', ES_TDOMAIN ); ?></option>
			</select>
			<p></p>

			<label for="tag-link"><?php echo __( 'Enter your Email Subject', ES_TDOMAIN ); ?></label>
			<input name="es_templ_heading" type="text" id="es_templ_heading" value="" size="80" maxlength="225" />
			<p><?php echo __( 'Keyword: ###POSTTITLE###', ES_TDOMAIN ); ?></p>

			<label for="tag-link"><?php echo __( 'Enter Content for your Email', ES_TDOMAIN ); ?></label>
			<?php $settings_body = array( 'textarea_rows' => 25 ); ?>
			<?php wp_editor("", "es_templ_body", $settings_body);?>
			<p>
				<?php echo sprintf(__( '%s : ###NAME###, ###EMAIL###, ###DATE###, ###POSTTITLE###, ###POSTLINK###, ###POSTLINK-WITHTITLE###, ###POSTLINK-ONLY###, ###POSTIMAGE###, ###POSTDESC###, ###POSTFULL###', ES_TDOMAIN ), '<a href="http://www.icegram.com/documentation/es-what-are-static-templates-and-dynamic-templates/" target="_blank">' . __( 'Available Keywords', ES_TDOMAIN ) . '</a>' ); ?><br />
			</p>

			<div class="template_status" style="display:none;">
				<label for="tag-link"><?php echo __( 'Status', ES_TDOMAIN ); ?></label>
				<select name="es_templ_status" id="es_templ_status">
					<option value='Published' <?php if( $form['es_templ_status'] == 'Published' ) { echo 'selected="selected"' ; } ?>><?php echo __( 'Published', ES_TDOMAIN ); ?></option>
				</select>
				<p><?php echo __( 'Please select your mail status', ES_TDOMAIN ); ?></p>
			</div>
			<input type="hidden" name="es_form_submit" value="yes"/>
			<p class="submit">
				<input type="submit" class="button-primary" value="<?php echo __( 'Save', ES_TDOMAIN ); ?>" />
			</p>
			<?php wp_nonce_field('es_form_add'); ?>
		</form>
	</div>
	<p class="description"><?php echo ES_OFFICIAL; ?></p>
</div>