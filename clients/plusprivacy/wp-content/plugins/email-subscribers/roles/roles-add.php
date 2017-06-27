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

		$es_roles_subscriber = "";
		$es_roles_mail = "";
		$es_roles_notification = "";
		$es_roles_sendmail = "";
		$es_roles_setting = "";
		$es_roles_sentmail = "";
		$es_roles_help = "";

		// Preset the form fields
		$form = array(
			'es_roles_subscriber' => '',
			'es_roles_mail' => '',
			'es_roles_notification' => '',
			'es_roles_sendmail' => '',
			'es_roles_setting' => '',
			'es_roles_sentmail' => '',
			'es_roles_help' => ''
		);

		// Form submitted, check the data
		if (isset($_POST['es_form_submit']) && $_POST['es_form_submit'] == 'yes') {
			//	Just security thingy that wordpress offers us
			check_admin_referer('es_roles_add');

			$form['es_roles_subscriber'] = isset($_POST['es_roles_subscriber']) ? $_POST['es_roles_subscriber'] : '';
			$form['es_roles_mail'] = isset($_POST['es_roles_mail']) ? $_POST['es_roles_mail'] : '';
			$form['es_roles_notification'] = isset($_POST['es_roles_notification']) ? $_POST['es_roles_notification'] : '';
			$form['es_roles_sendmail'] = isset($_POST['es_roles_sendmail']) ? $_POST['es_roles_sendmail'] : '';
			$form['es_roles_setting'] = isset($_POST['es_roles_setting']) ? $_POST['es_roles_setting'] : '';
			$form['es_roles_sentmail'] = isset($_POST['es_roles_sentmail']) ? $_POST['es_roles_sentmail'] : '';
			$form['es_roles_help'] = isset($_POST['es_roles_help']) ? $_POST['es_roles_help'] : '';
		
			//	No errors found, we can add this Group to the table
			if ($es_error_found == FALSE) {
				$action = false;
				$action = update_option( 'es_c_rolesandcapabilities', $form );
				if($action) {
					$es_success = __( 'Role Updated. ', ES_TDOMAIN );
				}
				
	
				// Reset the form fields
				$form = array(
					'es_roles_subscriber' => '',
					'es_roles_mail' => '',
					'es_roles_notification' => '',
					'es_roles_sendmail' => '',
					'es_roles_setting' => '',
					'es_roles_sentmail' => '',
					'es_roles_help' => ''
				);
			}
		}

		$es_c_rolesandcapabilities = get_option('es_c_rolesandcapabilities', 'norecord');
		if($es_c_rolesandcapabilities <> 'norecord' && $es_c_rolesandcapabilities <> "") {
			$es_roles_subscriber = $es_c_rolesandcapabilities['es_roles_subscriber'];
			$es_roles_mail = $es_c_rolesandcapabilities['es_roles_mail'];
			$es_roles_notification = $es_c_rolesandcapabilities['es_roles_notification'];
			$es_roles_sendmail = $es_c_rolesandcapabilities['es_roles_sendmail'];
			$es_roles_setting = $es_c_rolesandcapabilities['es_roles_setting'];
			$es_roles_sentmail = $es_c_rolesandcapabilities['es_roles_sentmail'];
			$es_roles_help = $es_c_rolesandcapabilities['es_roles_help'];
		}

		if ($es_error_found == TRUE && isset($es_errors[0]) == TRUE) {
			?>
			<div class="error fade">
				<p><strong>
				<?php echo $es_errors[0]; ?>
			</strong></p>
			</div>
			<?php
		}

		if ($es_error_found == FALSE && isset($es_success[0]) == TRUE) {
			?>
			<div class="notice notice-success is-dismissible">
				<p><strong>
					<?php echo $es_success; ?>
				</strong></p>
			</div>
			<?php
		}
	?>

	<style>
		.form-table th {
			width: 250px;
		}
	</style>

	<div class="wrap">
		<h2>
			<?php echo __( 'User Roles', ES_TDOMAIN ); ?>
			<a class="add-new-h2" target="_blank" type="button" href="<?php echo ES_FAV; ?>"><?php echo __( 'Help', ES_TDOMAIN ); ?></a>
		</h2>
		<p class="description">
			<?php echo __( 'Select user roles who can access following menus. Only Admin can change this.', ES_TDOMAIN ); ?>
		</p>
		<form name="form_roles" method="post" action="#">
			<table class="form-table">
				<tbody>
					<tr>
						<th scope="row">
							<label for="tag-image"><?php echo __( 'Subscribers Menu', ES_TDOMAIN ); ?></label>
						</th>
						<td>
							<select name="es_roles_subscriber" id="es_roles_subscriber">
								<option value='manage_options' <?php if($es_roles_subscriber == 'manage_options') { echo "selected='selected'" ; } ?>><?php echo __( 'Administrator Only', ES_TDOMAIN ); ?></option>
								<option value='edit_others_pages' <?php if($es_roles_subscriber == 'edit_others_pages') { echo "selected='selected'" ; } ?>><?php echo __( 'Administrator/Editor', ES_TDOMAIN ); ?></option>
								<option value='edit_posts' <?php if($es_roles_subscriber == 'edit_posts') { echo "selected='selected'" ; } ?>><?php echo __( 'Administrator/Editor/Author/Contributor', ES_TDOMAIN ); ?></option>
							</select>
						</td>
					</tr>
					<tr>
						<th scope="row">
							<label for="tag-image"><?php echo __( 'Compose Menu', ES_TDOMAIN ); ?></label>
						</th>
						<td>
							<select name="es_roles_mail" id="es_roles_mail">
								<option value='manage_options' <?php if($es_roles_mail == 'manage_options') { echo "selected='selected'" ; } ?>><?php echo __( 'Administrator Only', ES_TDOMAIN ); ?></option>
								<option value='edit_others_pages' <?php if($es_roles_mail == 'edit_others_pages') { echo "selected='selected'" ; } ?>><?php echo __( 'Administrator/Editor', ES_TDOMAIN ); ?></option>
								<option value='edit_posts' <?php if($es_roles_mail == 'edit_posts') { echo "selected='selected'" ; } ?>><?php echo __( 'Administrator/Editor/Author/Contributor', ES_TDOMAIN ); ?></option>
							</select>
						</td>
					</tr>
					<tr>
						<th scope="row">
							<label for="tag-image"><?php echo __( 'Post Notifications Menu', ES_TDOMAIN ); ?></label>
						</th>
						<td>
							<select name="es_roles_notification" id="es_roles_notification">
								<option value='manage_options' <?php if($es_roles_notification == 'manage_options') { echo "selected='selected'" ; } ?>><?php echo __( 'Administrator Only', ES_TDOMAIN ); ?></option>
								<option value='edit_others_pages' <?php if($es_roles_notification == 'edit_others_pages') { echo "selected='selected'" ; } ?>><?php echo __( 'Administrator/Editor', ES_TDOMAIN ); ?></option>
								<option value='edit_posts' <?php if($es_roles_notification == 'edit_posts') { echo "selected='selected'" ; } ?>><?php echo __( 'Administrator/Editor/Author/Contributor', ES_TDOMAIN ); ?></option>
							</select>
						</td>
					</tr>
					<tr>
						<th scope="row">
							<label for="tag-image"><?php echo __( 'Newsletters + Cron Settings Menu', ES_TDOMAIN ); ?></label>
						</th>
						<td>
							<select name="es_roles_sendmail" id="es_roles_sendmail">
								<option value='manage_options' <?php if($es_roles_sendmail == 'manage_options') { echo "selected='selected'" ; } ?>><?php echo __( 'Administrator Only', ES_TDOMAIN ); ?></option>
								<option value='edit_others_pages' <?php if($es_roles_sendmail == 'edit_others_pages') { echo "selected='selected'" ; } ?>><?php echo __( 'Administrator/Editor', ES_TDOMAIN ); ?></option>
								<option value='edit_posts' <?php if($es_roles_sendmail == 'edit_posts') { echo "selected='selected'" ; } ?>><?php echo __( 'Administrator/Editor/Author/Contributor', ES_TDOMAIN ); ?></option>
							</select>
						</td>
					</tr>
					<tr>
						<th scope="row">
							<label for="tag-image"><?php echo __( 'Email Settings Menu', ES_TDOMAIN ); ?></label>
						</th>
						<td>
							<select name="es_roles_setting" id="es_roles_setting">
								<option value='manage_options' <?php if($es_roles_setting == 'manage_options') { echo "selected='selected'" ; } ?>><?php echo __( 'Administrator Only', ES_TDOMAIN ); ?></option>
								<option value='edit_others_pages' <?php if($es_roles_setting == 'edit_others_pages') { echo "selected='selected'" ; } ?>><?php echo __( 'Administrator/Editor', ES_TDOMAIN ); ?></option>
								<option value='edit_posts' <?php if($es_roles_setting == 'edit_posts') { echo "selected='selected'" ; } ?>><?php echo __( 'Administrator/Editor/Author/Contributor', ES_TDOMAIN ); ?></option>
							</select>
						</td>
					</tr>
					<tr>
						<th scope="row">
							<label for="tag-image"><?php echo __( 'Reports Menu', ES_TDOMAIN ); ?></label>
						</th>
						<td>
							<select name="es_roles_sentmail" id="es_roles_sentmail">
								<option value='manage_options' <?php if($es_roles_sentmail == 'manage_options') { echo "selected='selected'" ; } ?>><?php echo __( 'Administrator Only', ES_TDOMAIN ); ?></option>
								<option value='edit_others_pages' <?php if($es_roles_sentmail == 'edit_others_pages') { echo "selected='selected'" ; } ?>><?php echo __( 'Administrator/Editor', ES_TDOMAIN ); ?></option>
								<option value='edit_posts' <?php if($es_roles_sentmail == 'edit_posts') { echo "selected='selected'" ; } ?>><?php echo __( 'Administrator/Editor/Author/Contributor', ES_TDOMAIN ); ?></option>
							</select>
						</td>
					</tr>
					<tr>
						<th scope="row">
							<label for="tag-image"><?php echo __( 'Help & Info Menu', ES_TDOMAIN ); ?></label>
						</th>
						<td>
							<select name="es_roles_help" id="es_roles_help">
								<option value='manage_options' <?php if($es_roles_help == 'manage_options') { echo "selected='selected'" ; } ?>><?php echo __( 'Administrator Only', ES_TDOMAIN ); ?></option>
								<option value='edit_others_pages' <?php if($es_roles_help == 'edit_others_pages') { echo "selected='selected'" ; } ?>><?php echo __( 'Administrator/Editor', ES_TDOMAIN ); ?></option>
								<option value='edit_posts' <?php if($es_roles_help == 'edit_posts') { echo "selected='selected'" ; } ?>><?php echo __( 'Administrator/Editor/Author/Contributor', ES_TDOMAIN ); ?></option>
							</select>
						</td>
					</tr>
				</tbody>
			</table>
			<input type="hidden" name="es_form_submit" value="yes"/>
			<p style="padding-top:5px;">
				<input type="submit" name="publish" lang="publish" class="button-primary" value="<?php echo __( 'Save', ES_TDOMAIN ); ?>" />
			</p>
			<div style="height:10px;"></div>
	  		<?php wp_nonce_field('es_roles_add'); ?>
		</form>
	</div>
	<p class="description"><?php echo ES_OFFICIAL; ?></p>
</div>