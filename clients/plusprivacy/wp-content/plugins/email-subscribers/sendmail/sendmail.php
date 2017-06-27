<?php

// Exit if accessed directly
if ( ! defined( 'ABSPATH' ) ) {
	exit; 
}

if ( ! empty( $_POST ) && ! wp_verify_nonce( $_REQUEST['wp_create_nonce'], 'sendmail-nonce' ) ) {
	die('<p>Security check failed.</p>');
}

$es_c_email_subscribers_ver = get_option( 'email-subscribers' );
if ($es_c_email_subscribers_ver != "2.9") {
	?>
	<div class="error fade">
		<p>
		Note: You have recently upgraded the plugin and your tables are not sync. 
		Please <a title="Sync plugin tables." href="<?php echo ES_ADMINURL; ?>?page=es-settings&amp;ac=sync"><?php echo __( 'Click Here', ES_TDOMAIN ); ?></a> to sync the table. 
		This is mandatory and it will not affect your data.
		</p>
	</div>
	<?php
}

$es_errors = array();
$es_success = '';
$es_error_found = FALSE;

$es_templ_heading = isset($_POST['es_templ_heading']) ? $_POST['es_templ_heading'] : '';
$es_sent_type = isset($_POST['es_sent_type']) ? $_POST['es_sent_type'] : '';
$es_email_group = isset($_POST['es_email_group']) ? $_POST['es_email_group'] : '';
$sendmailsubmit = isset($_POST['sendmailsubmit']) ? $_POST['sendmailsubmit'] : 'no';

if ($sendmailsubmit == 'yes') {

	check_admin_referer('es_form_submit');

	$form['es_templ_heading'] = isset($_POST['es_templ_heading']) ? $_POST['es_templ_heading'] : '';
	if ( $form['es_templ_heading'] == '' ) {
		$es_errors[] = __( 'Please select your mail subject.', ES_TDOMAIN );
		$es_error_found = TRUE;
	}

	$form['es_sent_type'] = isset($_POST['es_sent_type']) ? $_POST['es_sent_type'] : '';
	if ( $form['es_sent_type'] == '' ) {
		$es_errors[] = __( 'Please select your mail type.', ES_TDOMAIN );
		$es_error_found = TRUE;
	}

	$form['es_email_group'] = isset($_POST['es_email_group']) ? $_POST['es_email_group'] : '';
	if( $form['es_email_group'] == '' ) {
		$es_errors[] = __( 'Please select your group.', ES_TDOMAIN );
		$es_error_found = TRUE;
	}

	if ($es_error_found == FALSE) {
		es_cls_sendmail::es_prepare_newsletter_manual( $es_templ_heading, $es_sent_type, $es_email_group );
		$es_success_msg = TRUE;
		$es_success = __( 'Mail sent successfully. ', ES_TDOMAIN );
		if ($es_success_msg == TRUE) {
			?><div class="notice notice-success is-dismissible">
				<p><strong>
			  		<?php echo $es_success; ?><a href="<?php echo ES_ADMINURL; ?>?page=es-sentmail"><?php echo __( 'Click here to check Statistics', ES_TDOMAIN ); ?></a>
				</strong></p>
			</div><?php
		} else {
			?><div class="error fade">
				<p><strong>
					<?php echo __( 'Oops.. We are getting some error. mail not sending.', ES_TDOMAIN ); ?>
				</strong></p>
			</div><?php
		}
	}
}

if ($es_error_found == TRUE && isset($es_errors[0]) == TRUE) {
	?><div class="error fade">
		<p><strong>
			<?php echo $es_errors[0]; ?>
		</strong></p>
	</div><?php
}
?>

<style>
.form-table th {
    width: 300px;
}
</style>

<div class="wrap">
	<h2>
		<?php echo __( 'Newsletters', ES_TDOMAIN ); ?>
		<a class="add-new-h2" target="_blank" href="<?php echo ES_FAV; ?>"><?php echo __( 'Help', ES_TDOMAIN ); ?></a>
	</h2>
	<p class="description">
		<?php echo __( 'Use this to send newsletter emails to your subscribers.', ES_TDOMAIN ); ?>
	</p>
	<form name="es_form" method="post" action="#" onsubmit="return _es_submit()">
		<table class="form-table">
			<tbody>
				<tr>
					<th scope="row">
						<label for="tag-image">
							<?php echo __( 'Select Email Subject from available list', ES_TDOMAIN ); ?>
						</label>
					</th>
					<td>
						<select name="es_templ_heading" id="es_templ_heading">
							<option value=''><?php echo __( 'Select', ES_TDOMAIN ); ?></option>
							<?php
								$subject = array();
								$subject = es_cls_compose::es_template_select_type($type = "Newsletter");
								$thisselected = "";
								if(count($subject) > 0) {
									$i = 1;
									foreach ($subject as $sub) {
										if($sub["es_templ_id"] == $es_templ_heading) { 
											$thisselected = "selected='selected'" ; 
										}
										?><option value='<?php echo $sub["es_templ_id"]; ?>' <?php echo $thisselected; ?>><?php echo esc_html(stripslashes($sub["es_templ_heading"])); ?></option><?php
										$thisselected = "";
									}
								}
							?>
						</select>
					</td>
				</tr>
				<tr>
					<th scope="row">
						<label for="tag-image">
							<?php echo __( 'Select Email Type', ES_TDOMAIN ); ?>
						</label>
					</th>
					<td>
						<select name="es_sent_type" id="es_sent_type">
							<option value=''><?php echo __( 'Select', ES_TDOMAIN ); ?></option>
							<option value='Immediately' <?php if($es_sent_type == 'Immediately') { echo "selected='selected'" ; } ?>><?php echo __( 'Send email immediately', ES_TDOMAIN ); ?></option>
							<option value='Cron' <?php if($es_sent_type == 'Cron') { echo "selected='selected'" ; } ?>><?php echo __( 'Send email via cron job', ES_TDOMAIN ); ?></option>
						</select>
					</td>
				</tr>
				<tr>
					<th scope="row">
						<label for="tag-image">
							<?php echo __( 'Select Subscribers group to Send Email', ES_TDOMAIN ); ?>
						</label>
					</th>
					<td>
						<select name="es_email_group" id="es_email_group" onChange="_es_mailgroup(this.options[this.selectedIndex].value)">
							<option value=''><?php echo __( 'Select', ES_TDOMAIN ); ?></option>
							<?php
								$groups = array();
								$thisselected = "";
								$groups = es_cls_dbquery::es_view_subscriber_group();
								if(count($groups) > 0) {
									$i = 1;
									foreach ($groups as $group) {
										if(stripslashes($group["es_email_group"]) == stripslashes($es_email_group)) { 
											$thisselected = "selected='selected'" ; 
										}
										?><option value="<?php echo esc_html($group["es_email_group"]); ?>" <?php echo $thisselected; ?>><?php echo stripslashes($group["es_email_group"]); ?></option><?php
										$thisselected = "";
									}
								}
							?>
						</select>
					</td>
				</tr>
				<tr>
					<th scope="row">
					</th>
					<td>
						<?php
							$subscribers_count = array();
							$subscribers_count = es_cls_dbquery::es_subscriber_count_in_group($es_email_group);
							if( $subscribers_count == '0' ) {
								echo __( 'Recipients : 0 ', ES_TDOMAIN );
							} else {
								echo sprintf(__( 'Recipients : %s', ES_TDOMAIN ), $subscribers_count );
							}
							if( $subscribers_count > '100' && $es_sent_type == 'Immediately' ) {
								echo __( '<br><br><strong>Your Recipients count is above 100.<br>We strongly recommend that you change above Mail Type to Cron and Send Mail via Cron Job.</strong><br>Click on Help for more information.', ES_TDOMAIN );
							}
						?>
					</td>
				</tr>
			</tbody>
		</table>
		<?php $nonce = wp_create_nonce( 'sendmail-nonce' ); ?>
		<input type="hidden" name="sendmailsubmit" id="sendmailsubmit" value=""/>
		<input type="hidden" name="wp_create_nonce" id="wp_create_nonce" value="<?php echo $nonce; ?>"/>
		<?php if( $subscribers_count != 0 ) { ?>
			<input type="submit" name="Submit" class="send button-primary" style="width:160px;" value="<?php echo __( 'Send Email', ES_TDOMAIN ); ?>" />&nbsp;
		<?php } else { ?>
			<input type="submit" name="Submit" disabled="disabled" class="send button add-new-h2" style="width:160px;" value="<?php echo __( 'Send Email', ES_TDOMAIN ); ?>" />&nbsp;
		<?php } ?>
		<?php wp_nonce_field('es_form_submit'); ?>
		<input type="button" class="button-primary" onclick="_es_redirect()" value="<?php echo __( 'Reset', ES_TDOMAIN ); ?>" />
	</form>
	<div style="padding-top:10px;"></div>
	<p class="description"><?php echo ES_OFFICIAL; ?></p>
</div>