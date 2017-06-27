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
	$cron_adminmail = "";

	// Form submitted, check the data
	if (isset($_POST['es_form_submit']) && $_POST['es_form_submit'] == 'yes') {
		//	Just security thingy that wordpress offers us
		check_admin_referer('es_form_add');

		$es_cron_mailcount = isset($_POST['es_cron_mailcount']) ? $_POST['es_cron_mailcount'] : '';
		if($es_cron_mailcount == "0" && strlen ($es_cron_mailcount) > 0) {
			$es_errors[] = __('Please enter valid mail count.', 'email-subscribers');
			$es_error_found = TRUE;
		}

		$es_cron_adminmail = isset($_POST['es_cron_adminmail']) ? $_POST['es_cron_adminmail'] : '';

		//	No errors found, we can add this Group to the table
		if ($es_error_found == FALSE) {
			update_option('es_cron_mailcount', $es_cron_mailcount );
			update_option('es_cron_adminmail', $es_cron_adminmail );
			$es_success = __( 'Successfully updated.', ES_TDOMAIN );
		}
	}

	$es_cron_url = get_option('es_c_cronurl', 'nocronurl');
	if($es_cron_url == "nocronurl") {
		$guid = es_cls_common::es_generate_guid(60);
		$home_url = home_url('/');
		$cronurl = $home_url . "?es=cron&guid=". $guid;
		add_option('es_c_cronurl', $cronurl);
		$es_cron_url = get_option('es_c_cronurl');
	}

	$es_cron_mailcount = get_option('es_cron_mailcount', '0');
	if($es_cron_mailcount == "0") {
		add_option('es_cron_mailcount', "50");
		$es_cron_mailcount = get_option('es_cron_mailcount');
	}

	$es_cron_adminmail = get_option('es_cron_adminmail', '');
	if($es_cron_adminmail == "") {
		add_option('es_cron_adminmail', "Hi Admin, \r\n\r\nCron URL has been triggered successfully on ###DATE### for the email ###SUBJECT###. And it sent email to ###COUNT### recipient. \r\n\r\nThank You");
		$es_cron_adminmail = get_option('es_cron_adminmail');
	}

	if ($es_error_found == TRUE && isset($es_errors[0]) == TRUE) {
		?><div class="error fade"><p><strong><?php echo $es_errors[0]; ?></strong></p></div><?php
	}
	if ($es_error_found == FALSE && strlen($es_success) > 0) {
		?>
		<div class="notice notice-success is-dismissible">
			<p><strong><?php echo $es_success; ?></strong></p>
		</div>
		<?php
	}
	?>

	<style>
		.form-table th {
			width: 50%;
		}
	</style>

	<div class="wrap">
		<h2>
			<?php echo __( 'Cron Settings', ES_TDOMAIN ); ?>
			<a class="add-new-h2" target="_blank" type="button" href="<?php echo ES_FAV; ?>"><?php echo __( 'Help', ES_TDOMAIN ); ?></a>
		</h2>
		<form name="es_form" method="post" action="#" onsubmit="return _es_submit()">
			<table class="form-table">
				<tbody>
					<tr>
						<th scope="row">
							<label for="tag-image"><?php echo __( 'Cron job URL', ES_TDOMAIN ); ?>
								<p class="description"><?php echo __( 'This is your Cron Job URL. It is a readonly field and you are advised not to modify it.', ES_TDOMAIN ); ?></p>
							</label>
						</th>
						<td>
							<input type="text" name="es_cron_url" id="es_cron_url" value="<?php echo $es_cron_url; ?>" size="68" readonly />
						</td>
					</tr>
					<tr>
						<th scope="row">
							<label for="tag-image"><?php echo __( 'Email Count', ES_TDOMAIN ); ?>								
								<p class="description"><?php echo __( 'Number of emails that you want to trigger per hour.', ES_TDOMAIN ); ?></p>
							</label>
						</th>
						<td>
							<input type="number" name="es_cron_mailcount" id="es_cron_mailcount" value="<?php echo $es_cron_mailcount; ?>" maxlength="3" />
							<p class="description"><?php echo __( '(Your web host has limits. We suggest 50 emails per hour to be safe)', ES_TDOMAIN ) ?></p>
						</td>
					</tr>
					<tr>
						<th scope="row">
							<label for="tag-image"><?php echo __( 'Admin Report', ES_TDOMAIN ); ?>
								<p class="description"><?php echo __( 'Email to admin whenever cron URL is triggered from your server. (Keywords: ###DATE###, ###SUBJECT###, ###COUNT###)', ES_TDOMAIN ); ?></p>
							</label>
						</th>
						<td>
							<textarea size="100" id="es_cron_adminmail" rows="7" cols="72" name="es_cron_adminmail"><?php echo esc_html(stripslashes($es_cron_adminmail)); ?></textarea>
						</td>
					</tr>
				</tbody>
			</table>			
			<input type="hidden" name="es_form_submit" value="yes"/>
			<p class="submit">
				<input type="submit" name="publish" lang="publish" class="button-primary" value="<?php echo __( 'Save', ES_TDOMAIN ); ?>" />
			</p>
			<?php wp_nonce_field('es_form_add'); ?>
		</form>
	</div>
	<div class="tool-box">
		<h3><?php echo __( 'What is Cron (auto emails) and how to setup Cron Job?', ES_TDOMAIN ); ?></h3>
		<li><?php echo __( '<a target="_blank" href="http://www.icegram.com/documentation/es-how-to-schedule-cron-emails/">What is Cron?</a>', ES_TDOMAIN ); ?></li>
		<li><?php echo __( '<a target="_blank" href="http://www.icegram.com/documentation/es-how-to-schedule-cron-emails-in-parallels-plesk/">Setup cron job in Plesk</a>', ES_TDOMAIN ); ?></li>
		<li><?php echo __( '<a target="_blank" href="http://www.icegram.com/documentation/es-how-to-schedule-cron-emails-in-cpanel/">Setup cron job in cPanal</a>', ES_TDOMAIN ); ?></li>
		<li><?php echo __( '<a target="_blank" href="http://www.icegram.com/documentation/es-what-to-do-if-hosting-doesnt-support-cron-jobs/">Hosting does not support cron jobs?</a>', ES_TDOMAIN ); ?></li><br>
	</div>
	<p class="description"><?php echo ES_OFFICIAL; ?></p>
</div>