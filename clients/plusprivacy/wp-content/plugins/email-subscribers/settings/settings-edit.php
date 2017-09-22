<?php

// Exit if accessed directly
if ( ! defined( 'ABSPATH' ) ) {
	exit;
}

if ( ! class_exists( 'ES_Settings' ) ) {

	class ES_Settings {

		public $nav_tabs, $form = array();

		public function __construct() {
			$this->nav_tabs = $this->es_get_tabs_list();
			$this->es_display_nav_tabs();
			$this->form = $this->es_process_settings_data();
			$this->es_display_settings();
		}

		public function es_get_tabs_list() {
			$tabs = array(
				'admin'				  => __( 'Admin', ES_TDOMAIN ),
				'signup-confirmation' => __( 'Signup Confirmation', ES_TDOMAIN ),
				'cron'	 			  => __( 'Cron', ES_TDOMAIN ),
				'roles' 			  => __( 'User Roles', ES_TDOMAIN ),
			);

			return apply_filters( 'es_settings_tabs', $tabs );
		}

		public function es_display_nav_tabs() {
			?>
			<style>
				.form-table th {
					width: 450px;
				}
			</style>

			<div class="wrap">
				<h2>
					<?php echo __( 'Settings', ES_TDOMAIN ); ?>
					<a class="add-new-h2" target="_blank" href="<?php echo ES_FAV; ?>"><?php echo __( 'Help', ES_TDOMAIN ); ?></a>
				</h2>
				<div id="icon-options-general" class="icon32"><br /></div>
				<h2 id="es-tabs" class="nav-tab-wrapper">
				<?php foreach ( $this->nav_tabs as $tab => $name ) { ?>
					<a class="nav-tab" id=<?php echo $tab; ?> href='#'><?php echo $name; ?></a>
				<?php } ?>
				</h2>
				<?php
		}

		public function es_display_settings() {
			?>
			<form name="es_form" id="es_form" method="post" action="#">
				<table class="es-settings form-table">
					<tbody>
						<?php $this->display_admin_settings(); ?>
						<?php $this->display_signup_confirmation_settings(); ?>
						<?php $this->display_roles_setting(); ?>
						<?php $this->display_cron_settings(); ?>
					</tbody>
				</table>
				<input type="hidden" name="es_form_submit" value="yes"/>
				<p style="padding-top:10px;">
					<input type="submit" name="publish" id="es-save-settings" class="button-primary" value="<?php echo __( 'Save Settings', ES_TDOMAIN ); ?>" />
				</p>
				<?php wp_nonce_field('es_form_edit'); ?>
			</form>
			<?php
		}

		public function display_admin_settings() {
			?>
			<tr class="es-admin active-settings">
				<th scope="row">
					<label for="elp"><?php echo __( 'Sender of Notifications', ES_TDOMAIN ); ?>
						<p class="description"><?php echo __( 'Choose a FROM name and FROM email address for all the emails to be sent from this plugin.', ES_TDOMAIN ); ?></p>
					</label>
				</th>
				<td>
					<input name="es_c_fromname" type="text" id="es_c_fromname" value="<?php echo stripslashes($this->form['ig_es_fromname']); ?>" maxlength="225" />
					<input name="es_c_fromemail" type="text" id="es_c_fromemail" value="<?php echo stripslashes($this->form['ig_es_fromemail']); ?>" size="35" maxlength="225" />
				</td>
			</tr>
			<tr class="es-admin active-settings">
				<th scope="row">
					<label for="elp"><?php echo __( 'Email Type', ES_TDOMAIN ); ?>
					<p class="description"><?php echo __( 'Option 1 & 2 is to send emails with default Wordpress method wp_mail(). Option 3 & 4 is to send emails with PHP method mail().', ES_TDOMAIN ); ?></p></label>
				</th>
				<td>
					<select name="es_c_mailtype" id="es_c_mailtype">
						<option value='WP HTML MAIL' <?php if($this->form['ig_es_emailtype'] == 'WP HTML MAIL') { echo 'selected' ; } ?>><?php echo __( '1. WP HTML MAIL', ES_TDOMAIN ); ?></option>
						<option value='WP PLAINTEXT MAIL' <?php if($this->form['ig_es_emailtype'] == 'WP PLAINTEXT MAIL') { echo 'selected' ; } ?>><?php echo __( '2. WP PLAINTEXT MAIL', ES_TDOMAIN ); ?></option>
						<option value='PHP HTML MAIL' <?php if($this->form['ig_es_emailtype'] == 'PHP HTML MAIL') { echo 'selected' ; } ?>><?php echo __( '3. PHP HTML MAIL', ES_TDOMAIN ); ?></option>
						<option value='PHP PLAINTEXT MAIL' <?php if($this->form['ig_es_emailtype'] == 'PHP PLAINTEXT MAIL') { echo 'selected' ; } ?>><?php echo __( '4. PHP PLAINTEXT MAIL', ES_TDOMAIN ); ?></option>
					</select>
				</td>
			</tr>
			<!-------------------------------------------------------------------------------->
			<tr class="es-admin active-settings">
				<th scope="row">
					<label for="elp"><?php echo __( 'Opt-In Type', ES_TDOMAIN ); ?>
					<p class="description"><?php echo __( 'Double Opt-In : In this type, the subscriber is sent an activation link as soon as they subscribe to your list. They have to confirm their subscription by clicking on the activation link.<br />Single Opt-In : In this type, the subscriber is not asked to confirm their email address. They are subscribed directly in the list.', ES_TDOMAIN ); ?></p></label>
				</th>
				<td>
					<select name="es_c_optinoption" id="es_c_optinoption">
						<option value='Double Opt In' <?php if($this->form['ig_es_optintype'] == 'Double Opt In') { echo 'selected' ; } ?>><?php echo __( 'Double Opt In', ES_TDOMAIN ); ?></option>
						<option value='Single Opt In' <?php if($this->form['ig_es_optintype'] == 'Single Opt In') { echo 'selected' ; } ?>><?php echo __( 'Single Opt In', ES_TDOMAIN ); ?></option>
					</select>
				</td>
			</tr>
			<tr class="es-admin active-settings">
				<th scope="row">
					<label for="elp"><?php echo __( 'Image Size', ES_TDOMAIN ); ?>
					<p class="description"><?php echo __( 'Select image size for ###POSTIMAGE### to be shown in the Post Notification Emails.', ES_TDOMAIN ); ?></p></label>
				</th>
				<td>
					<select name="es_c_post_image_size" id="es_c_post_image_size">
						<option value='full' <?php if($this->form['ig_es_post_image_size'] == 'full') { echo 'selected' ; } ?>><?php echo __( 'Full Size', ES_TDOMAIN ); ?></option>
						<option value='medium' <?php if($this->form['ig_es_post_image_size'] == 'medium') { echo 'selected' ; } ?>><?php echo __( 'Medium Size', ES_TDOMAIN ); ?></option>
						<option value='thumbnail' <?php if($this->form['ig_es_post_image_size'] == 'thumbnail') { echo 'selected' ; } ?>><?php echo __( 'Thumbnail', ES_TDOMAIN ); ?></option>
					</select>
				</td>
			</tr>
			<tr class="es-admin active-settings">
				<th scope="row">
					<label for="elp"><?php echo __( 'Admin Email Addresses', ES_TDOMAIN ); ?>
					<p class="description"><?php echo __( 'Enter the admin email addresses that should receive notifications (separated by comma).', ES_TDOMAIN ); ?></p></label>
				</th>
				<td><input name="es_c_adminemail" type="text" id="es_c_adminemail" value="<?php echo esc_html(stripslashes($this->form['ig_es_adminemail'])); ?>" size="60" maxlength="225" /></td>
			</tr>
			<tr class="es-admin active-settings">
				<th scope="row">
					<label for="elp"><?php echo __( 'Notify Admin when a new subscriber signs up', ES_TDOMAIN ); ?>
						<p class="description"><?php echo __( 'To send admin email notifications for the new subscriber. This option must be set to YES.', ES_TDOMAIN ); ?></p>
					</label>
				</th>
				<td>
				<select name="es_c_adminmailoption" id="es_c_adminmailoption">
					<option value='YES' <?php if($this->form['ig_es_notifyadmin'] == 'YES') { echo 'selected' ; } ?>><?php echo __( 'YES', ES_TDOMAIN ); ?></option>
					<option value='NO' <?php if($this->form['ig_es_notifyadmin'] == 'NO') { echo 'selected' ; } ?>><?php echo __( 'NO', ES_TDOMAIN ); ?></option>
				</select>
				</td>
			</tr>
			<tr class="es-admin active-settings">
				<th scope="row">
					<label for="elp"><?php echo __( 'Admin Email Subject on new subscriber sign up', ES_TDOMAIN ); ?>
					<p class="description"><?php echo __( 'Subject for the admin email whenever a new subscriber signs up and is confirmed.', ES_TDOMAIN ); ?></p></label>
				</th>
				<td><input name="es_c_adminmailsubject" type="text" id="es_c_adminmailsubject" value="<?php echo esc_html(stripslashes($this->form['ig_es_admin_new_sub_subject'])); ?>" size="60" maxlength="225" /></td>
			</tr>
			<tr class="es-admin active-settings">
				<th scope="row">
					<label for="elp"><?php echo __( 'Admin Email Content on new subscriber signs up', ES_TDOMAIN ); ?>
					<p class="description"><?php echo __( 'Content for the admin email whenever a new subscriber signs up and is confirmed.<br />(Available Keywords: ###NAME###, ###EMAIL###, ###GROUP###)', ES_TDOMAIN ); ?></p></label>
				</th>
				<td><textarea size="100" id="es_c_adminmailcontant" rows="10" cols="58" name="es_c_adminmailcontant"><?php echo esc_html(stripslashes($this->form['ig_es_admin_new_sub_content'])); ?></textarea></td>
			</tr>
			<!-------------------------------------------------------------------------------->
			<tr class="es-admin active-settings">
				<th scope="row">
					<label for="elp"><?php echo __( 'Sent Report Subject', ES_TDOMAIN ); ?>
					<p class="description"><?php echo __( 'Subject for the email report which will be sent to admin.', ES_TDOMAIN ); ?></p></label>
				</th>
				<td><input name="es_c_sentreport_subject" type="text" id="es_c_sentreport_subject" value="<?php echo esc_html(stripslashes($this->form['ig_es_sentreport_subject'])); ?>" size="60" maxlength="225" /></td>
			</tr>
			<tr class="es-admin active-settings">
				<th scope="row">
					<label for="elp"><?php echo __( 'Sent Report Content', ES_TDOMAIN ); ?>
					<p class="description"><?php echo __( 'Content for the email report which will be sent to admin.<br />(Available Keywords: ###COUNT###, ###UNIQUE###, ###STARTTIME###, ###ENDTIME###)', ES_TDOMAIN ); ?></p></label>
				</th>
				<td><textarea size="100" id="es_c_sentreport" rows="8" cols="58" name="es_c_sentreport"><?php echo esc_html(stripslashes($this->form['ig_es_sentreport'])); ?></textarea></td>
			</tr>
			<?php
		}

		public function display_signup_confirmation_settings() {
			?>
			<tr class="es-signup-confirmation hidden">
				<th scope="row">
					<label for="elp"><?php echo __( 'Double Opt-In Email Subject (Confirmation Email)', ES_TDOMAIN ); ?>
					<p class="description"><?php echo __( 'Subject for the confirmation email to be sent for Double Opt-In whenever a subscriber signs up.', ES_TDOMAIN ); ?></p></label>
				</th>
				<td><input name="es_c_optinsubject" type="text" id="es_c_optinsubject" value="<?php echo esc_html(stripslashes($this->form['ig_es_confirmsubject'])); ?>" size="60" maxlength="225" /></td>
			</tr>
			<tr class="es-signup-confirmation hidden">
				<th scope="row">
					<label for="elp"><?php echo __('Double Opt-In Email Content (Confirmation Email)', ES_TDOMAIN); ?>
					<p class="description"><?php echo __( 'Content for the confirmation email to be sent for Double Opt-In whenever a subscriber signs up.<br />(Available Keywords: ###NAME###, ###LINK###)', ES_TDOMAIN ); ?></p></label>
				</th>
				<td><textarea size="100" id="es_c_optincontent" rows="10" cols="58" name="es_c_optincontent"><?php echo esc_html(stripslashes($this->form['ig_es_confirmcontent'])); ?></textarea></td>
			</tr>
			<tr class="es-signup-confirmation hidden">
				<th scope="row">
					<label for="elp"><?php echo __( 'Double Opt-In Confirmation Link', ES_TDOMAIN ); ?><p class="description">
					<?php echo __( 'It is a readonly field and you are advised not to modify it.', ES_TDOMAIN ); ?></p></label>
				</th>
				<td><input name="es_c_optinlink" type="text" id="es_c_optinlink" value="<?php echo esc_html(stripslashes($this->form['ig_es_optinlink'])); ?>" size="60" maxlength="225" readonly /></td>
			</tr>
			<tr class="es-signup-confirmation hidden">
				<th scope="row">
					<label for="elp"><?php echo __( 'Text to display after an email address is successfully subscribed from Double Opt-In (Confirmation) Email', ES_TDOMAIN ); ?>
					<p class="description"><?php echo __( 'This text will be displayed once user clicks on email confirmation link from the Double Opt In (confirmation) Email.', ES_TDOMAIN ); ?></p></label>
				</th>
				<td><textarea size="100" id="es_c_subhtml" rows="4" cols="58" name="es_c_subhtml"><?php echo esc_html(stripslashes($this->form['ig_es_successmsg'])); ?></textarea></td>
			</tr>
			<!-------------------------------------------------------------------------------->
			<tr class="es-signup-confirmation hidden">
				<th scope="row">
					<label for="elp"><?php echo __( 'Send Welcome Email to New Subscribers after Sign Up?', ES_TDOMAIN ); ?>
					<p class="description"><?php echo __( 'To send welcome email to subscriber after successful signup. This option must be set to YES.', ES_TDOMAIN ); ?></p></label>
				</th>
				<td>
				<select name="es_c_usermailoption" id="es_c_usermailoption">
					<option value='YES' <?php if($this->form['ig_es_welcomeemail'] == 'YES') { echo 'selected' ; } ?>><?php echo __( 'YES', ES_TDOMAIN ); ?></option>
					<option value='NO' <?php if($this->form['ig_es_welcomeemail'] == 'NO') { echo 'selected' ; } ?>><?php echo __( 'NO', ES_TDOMAIN ); ?></option>
				</select>
				</td>
			</tr>
			<tr class="es-signup-confirmation hidden">
				<th scope="row">
					<label for="elp"><?php echo __( 'Subject for Welcome Email', ES_TDOMAIN ); ?>
					<p class="description"><?php echo __( 'Subject for the subscriber welcome email. This will be sent whenever a user\'s email is either confirmed (if Double Opt-In) / subscribed (if Single Opt-In) successfully.', ES_TDOMAIN ); ?></p></label>
				</th>
				<td><input name="es_c_usermailsubject" type="text" id="es_c_usermailsubject" value="<?php echo esc_html(stripslashes($this->form['ig_es_welcomesubject'])); ?>" size="60" maxlength="225" /></td>
			</tr>
			<tr class="es-signup-confirmation hidden">
				<th scope="row">
					<label for="elp"><?php echo __( 'Email Content for Welcome Email', ES_TDOMAIN ); ?>
					<p class="description"><?php echo __( 'Content for the subscriber welcome email whenever a user\'s email is either confirmed (if Double Opt In) / subscribed (if Single Opt In) successfully.<br />(Available Keywords: ###NAME###, ###GROUP###, ###LINK###)', ES_TDOMAIN ); ?></p>
				</label>
				</th>
				<td><textarea size="100" id="es_c_usermailcontant" rows="10" cols="58" name="es_c_usermailcontant"><?php echo esc_html(stripslashes($this->form['ig_es_welcomecontent'])); ?></textarea></td>
			</tr>
			<!-------------------------------------------------------------------------------->
			<tr class="es-signup-confirmation hidden">
				<th scope="row">
					<label for="elp"><?php echo __( 'Unsubscribe Link', ES_TDOMAIN ); ?>
					<p class="description"><?php echo __( 'This unsubscribe link is automatically added to all the emails that are sent from this plugin. It is a readonly field and you are advised not to modify it.', ES_TDOMAIN ); ?></p></label>
				</th>
				<td><input name="es_c_unsublink" type="text" id="es_c_unsublink" value="<?php echo esc_html(stripslashes($this->form['ig_es_unsublink'])); ?>" size="60" maxlength="225" readonly /></td>
			</tr>
			<tr class="es-signup-confirmation hidden">
				<th scope="row">
					<label for="elp"><?php echo __( 'Unsubscribe Text in Email', ES_TDOMAIN ); ?>
					<p class="description"><?php echo __( 'The text for the unsubscribe link. This text is automatically added with unsubscribe link in the emails.<br />(Available Keyword: ###LINK###)', ES_TDOMAIN ); ?></p></label>
				</th>
				<td><textarea size="100" id="es_c_unsubtext" rows="4" cols="58" name="es_c_unsubtext"><?php echo esc_html(stripslashes($this->form['ig_es_unsubcontent'])); ?></textarea></td>
			</tr>
			<tr class="es-signup-confirmation hidden">
				<th scope="row">
					<label for="elp"><?php echo __( 'Text to display after an email address is unsubscribed', ES_TDOMAIN ); ?>
					<p class="description"><?php echo __( 'This text will be displayed once user clicks on unsubscribe link from the email.', ES_TDOMAIN ); ?></p></label>
				</th>
				<td><textarea size="100" id="es_c_unsubhtml" rows="4" cols="58" name="es_c_unsubhtml"><?php echo esc_html(stripslashes($this->form['ig_es_unsubtext'])); ?></textarea></td>
			</tr>
			<!-------------------------------------------------------------------------------->
			<tr class="es-signup-confirmation hidden">
				<th scope="row">
					<label for="elp"><?php echo __( 'Error in the Subscribe / Confirmation Link', ES_TDOMAIN ); ?>
					<p class="description"><?php echo __( 'Default message to display if there is any issue while clicking on subscribe / confirmation link from the Double Opt-In (Confirmation) emails.', ES_TDOMAIN ); ?></p></label>
				</th>
				<td><textarea size="100" id="es_c_message1" rows="4" cols="58" name="es_c_message1"><?php echo esc_html(stripslashes($this->form['ig_es_suberror'])); ?></textarea></td>
			</tr>
			<tr class="es-signup-confirmation hidden">
				<th scope="row">
					<label for="elp"><?php echo __( 'Error in the Unsubscribe Link', ES_TDOMAIN ); ?>
					<p class="description"><?php echo __( 'Default message to display if there is any issue while clicking on unsubscribe link from the emails.', ES_TDOMAIN ); ?></p></label>
				</th>
				<td><textarea size="100" id="es_c_message2" rows="4" cols="58" name="es_c_message2"><?php echo esc_html(stripslashes($this->form['ig_es_unsuberror'])); ?></textarea></td>
			</tr>
			<?php
		}

		public function display_roles_setting() {
			?>
			<tr class="es-roles hidden">
				<td colspan=2>
					<p class="description">
						<?php echo __( 'Select user roles who can access following menus. Only Admin can change this.', ES_TDOMAIN ); ?>
					</p>
				</td>
			</tr>
			<tr class="es-roles hidden">
				<th scope="row">
					<label for="tag-image"><?php echo __( 'Subscribers Menu', ES_TDOMAIN ); ?></label>
				</th>
				<td>
					<select name="es_roles_subscriber" id="es_roles_subscriber">
						<option value='manage_options' <?php if($this->form['es_roles_subscriber'] == 'manage_options') { echo "selected='selected'" ; } ?>><?php echo __( 'Administrator Only', ES_TDOMAIN ); ?></option>
						<option value='edit_others_pages' <?php if($this->form['es_roles_subscriber'] == 'edit_others_pages') { echo "selected='selected'" ; } ?>><?php echo __( 'Administrator/Editor', ES_TDOMAIN ); ?></option>
						<option value='edit_posts' <?php if($this->form['es_roles_subscriber'] == 'edit_posts') { echo "selected='selected'" ; } ?>><?php echo __( 'Administrator/Editor/Author/Contributor', ES_TDOMAIN ); ?></option>
					</select>
				</td>
			</tr>
			<tr class="es-roles hidden">
				<th scope="row">
					<label for="tag-image"><?php echo __( 'Compose Menu', ES_TDOMAIN ); ?></label>
				</th>
				<td>
					<select name="es_roles_mail" id="es_roles_mail">
						<option value='manage_options' <?php if($this->form['es_roles_mail'] == 'manage_options') { echo "selected='selected'" ; } ?>><?php echo __( 'Administrator Only', ES_TDOMAIN ); ?></option>
						<option value='edit_others_pages' <?php if($this->form['es_roles_mail'] == 'edit_others_pages') { echo "selected='selected'" ; } ?>><?php echo __( 'Administrator/Editor', ES_TDOMAIN ); ?></option>
						<option value='edit_posts' <?php if($this->form['es_roles_mail'] == 'edit_posts') { echo "selected='selected'" ; } ?>><?php echo __( 'Administrator/Editor/Author/Contributor', ES_TDOMAIN ); ?></option>
					</select>
				</td>
			</tr>
			<tr class="es-roles hidden">
				<th scope="row">
					<label for="tag-image"><?php echo __( 'Post Notifications Menu', ES_TDOMAIN ); ?></label>
				</th>
				<td>
					<select name="es_roles_notification" id="es_roles_notification">
						<option value='manage_options' <?php if($this->form['es_roles_notification'] == 'manage_options') { echo "selected='selected'" ; } ?>><?php echo __( 'Administrator Only', ES_TDOMAIN ); ?></option>
						<option value='edit_others_pages' <?php if($this->form['es_roles_notification'] == 'edit_others_pages') { echo "selected='selected'" ; } ?>><?php echo __( 'Administrator/Editor', ES_TDOMAIN ); ?></option>
						<option value='edit_posts' <?php if($this->form['es_roles_notification'] == 'edit_posts') { echo "selected='selected'" ; } ?>><?php echo __( 'Administrator/Editor/Author/Contributor', ES_TDOMAIN ); ?></option>
					</select>
				</td>
			</tr>
			<tr class="es-roles hidden">
				<th scope="row">
					<label for="tag-image"><?php echo __( 'Newsletters', ES_TDOMAIN ); ?></label>
				</th>
				<td>
					<select name="es_roles_sendmail" id="es_roles_sendmail">
						<option value='manage_options' <?php if($this->form['es_roles_sendmail'] == 'manage_options') { echo "selected='selected'" ; } ?>><?php echo __( 'Administrator Only', ES_TDOMAIN ); ?></option>
						<option value='edit_others_pages' <?php if($this->form['es_roles_sendmail'] == 'edit_others_pages') { echo "selected='selected'" ; } ?>><?php echo __( 'Administrator/Editor', ES_TDOMAIN ); ?></option>
						<option value='edit_posts' <?php if($this->form['es_roles_sendmail'] == 'edit_posts') { echo "selected='selected'" ; } ?>><?php echo __( 'Administrator/Editor/Author/Contributor', ES_TDOMAIN ); ?></option>
					</select>
				</td>
			</tr>
			<tr class="es-roles hidden">
				<th scope="row">
					<label for="tag-image"><?php echo __( 'Reports Menu', ES_TDOMAIN ); ?></label>
				</th>
				<td>
					<select name="es_roles_sentmail" id="es_roles_sentmail">
						<option value='manage_options' <?php if($this->form['es_roles_sentmail'] == 'manage_options') { echo "selected='selected'" ; } ?>><?php echo __( 'Administrator Only', ES_TDOMAIN ); ?></option>
						<option value='edit_others_pages' <?php if($this->form['es_roles_sentmail'] == 'edit_others_pages') { echo "selected='selected'" ; } ?>><?php echo __( 'Administrator/Editor', ES_TDOMAIN ); ?></option>
						<option value='edit_posts' <?php if($this->form['es_roles_sentmail'] == 'edit_posts') { echo "selected='selected'" ; } ?>><?php echo __( 'Administrator/Editor/Author/Contributor', ES_TDOMAIN ); ?></option>
					</select>
				</td>
			</tr>
			<?php
		}

		public function display_cron_settings() {
			?>
			<tr class="es-cron hidden">
				<th scope="row">
					<label for="tag-image"><?php echo __( 'Cron job URL', ES_TDOMAIN ); ?>
						<p class="description"><?php echo __( 'This is your Cron Job URL. It is a readonly field and you are advised not to modify it.', ES_TDOMAIN ); ?></p>
					</label>
				</th>
				<td>
					<input type="text" name="es_cron_url" id="es_cron_url" value="<?php echo $this->form['ig_es_cronurl']; ?>" size="68" readonly />
				</td>
			</tr>
			<tr class="es-cron hidden">
				<th scope="row">
					<label for="tag-image"><?php echo __( 'Email Count', ES_TDOMAIN ); ?>
						<p class="description"><?php echo __( 'Number of emails that you want to trigger per hour.', ES_TDOMAIN ); ?></p>
					</label>
				</th>
				<td>
					<input type="number" name="es_cron_mailcount" id="es_cron_mailcount" value="<?php echo $this->form['ig_es_cron_mailcount']; ?>" maxlength="3" />
					<p class="description"><?php echo __( '(Your web host has limits. We suggest 50 emails per hour to be safe.)', ES_TDOMAIN ) ?></p>
				</td>
			</tr>
			<tr class="es-cron hidden">
				<th scope="row">
					<label for="tag-image"><?php echo __( 'Cron Report', ES_TDOMAIN ); ?>
						<p class="description"><?php echo __( 'Email to admin whenever a cron URL is triggered from your server. (Available Keywords: ###DATE###, ###SUBJECT###, ###COUNT###)', ES_TDOMAIN ); ?></p>
					</label>
				</th>
				<td>
					<textarea size="100" id="es_cron_adminmail" rows="7" cols="72" name="es_cron_adminmail"><?php echo esc_html(stripslashes($this->form['ig_es_cron_adminmail'])); ?></textarea>
				</td>
			</tr>
			<tr class="es-cron hidden">
				<td colspan=2>
					<div class="tool-box">
						<h3><?php echo __( 'What is Cron (auto emails) and how to setup Cron Job?', ES_TDOMAIN ); ?></h3>
						<li><?php echo __( '<a target="_blank" href="https://www.icegram.com/documentation/es-how-to-schedule-cron-emails/?utm_source=es&utm_medium=in_app&utm_campaign=view_docs_help_page">What is Cron?</a>', ES_TDOMAIN ); ?></li>
						<li><?php echo __( '<a target="_blank" href="https://www.icegram.com/documentation/es-how-to-schedule-cron-emails-in-cpanel/?utm_source=es&utm_medium=in_app&utm_campaign=view_docs_help_page">Setup cron job in cPanel</a>', ES_TDOMAIN ); ?></li>
						<li><?php echo __( '<a target="_blank" href="https://www.icegram.com/documentation/es-how-to-schedule-cron-emails-in-parallels-plesk/?utm_source=es&utm_medium=in_app&utm_campaign=view_docs_help_page">Setup cron job in Plesk</a>', ES_TDOMAIN ); ?></li>
						<li><?php echo __( '<a target="_blank" href="https://www.icegram.com/documentation/es-what-to-do-if-hosting-doesnt-support-cron-jobs/?utm_source=es&utm_medium=in_app&utm_campaign=view_docs_help_page">Hosting does not support cron jobs?</a>', ES_TDOMAIN ); ?></li><br>
					</div>
				</td>
			</tr>
			<?php
		}

		public function es_process_settings_data() {

			$es_errors = array();
			$es_success = '';
			$es_error_found = FALSE;

			$form = array();

			// Admin Settings
			$form['ig_es_fromname'] = get_option( 'ig_es_fromname' );
			$form['ig_es_fromemail'] = get_option( 'ig_es_fromemail' );
			$form['ig_es_emailtype'] = get_option( 'ig_es_emailtype' );

			$es_c_post_image_size = get_option( 'ig_es_post_image_size', 'nosize' );
			if( $es_c_post_image_size == 'nosize' ) {
				$es_post_image_size = 'full';
				add_option( 'ig_es_post_image_size', $es_post_image_size );
				$es_c_post_image_size = $es_post_image_size;
			}

			$form['ig_es_post_image_size'] = $es_c_post_image_size;
			$form['ig_es_adminemail'] = get_option( 'ig_es_adminemail' );
			$form['ig_es_notifyadmin'] = get_option( 'ig_es_notifyadmin' );
			$form['ig_es_admin_new_sub_subject'] = get_option( 'ig_es_admin_new_sub_subject' );
			$form['ig_es_admin_new_sub_content'] = get_option( 'ig_es_admin_new_sub_content' );

			$es_c_sentreport = get_option('ig_es_sentreport', 'nooptionexists');
			if($es_c_sentreport == "nooptionexists") {
				$es_sent_report_plain = es_cls_common::es_sent_report_plain();
				add_option('ig_es_sentreport', $es_sent_report_plain);
				$es_c_sentreport = $es_sent_report_plain;
			}
			$form['ig_es_sentreport'] = $es_c_sentreport;

			$es_c_sentreport_subject = get_option('ig_es_sentreport_subject', 'nosubjectexists');
			if($es_c_sentreport_subject == "nosubjectexists") {
				$es_sent_report_subject = es_cls_common::es_sent_report_subject();
				add_option('ig_es_sentreport_subject', $es_sent_report_subject);
				$es_c_sentreport_subject = $es_sent_report_subject;
			}
			$form['ig_es_sentreport_subject'] = $es_c_sentreport_subject;

			// Signup Configuration Settings
			$form['ig_es_welcomeemail'] = get_option( 'ig_es_welcomeemail' );
			$form['ig_es_welcomesubject'] = get_option( 'ig_es_welcomesubject' );
			$form['ig_es_welcomecontent'] = get_option( 'ig_es_welcomecontent' );
			$form['ig_es_optintype'] = get_option( 'ig_es_optintype' );
			$form['ig_es_confirmsubject'] = get_option( 'ig_es_confirmsubject' );
			$form['ig_es_confirmcontent'] = get_option( 'ig_es_confirmcontent' );
			$form['ig_es_optinlink'] = get_option( 'ig_es_optinlink' );
			$form['ig_es_unsublink'] = get_option( 'ig_es_unsublink' );
			$form['ig_es_unsubcontent'] = get_option( 'ig_es_unsubcontent' );
			$form['ig_es_unsubtext'] = get_option( 'ig_es_unsubtext' );
			$form['ig_es_successmsg'] = get_option( 'ig_es_successmsg' );
			$form['ig_es_suberror'] = get_option( 'ig_es_suberror' );
			$form['ig_es_unsuberror'] = get_option( 'ig_es_unsuberror' );

			// Roles Settings
			$form['es_roles_subscriber'] = '';
			$form['es_roles_mail'] = '';
			$form['es_roles_notification'] = '';
			$form['es_roles_sendmail'] = '';
			$form['es_roles_sentmail'] = '';

			$es_c_rolesandcapabilities = get_option('ig_es_rolesandcapabilities', 'norecord');
			if($es_c_rolesandcapabilities <> 'norecord' && $es_c_rolesandcapabilities <> "") {
				$form['es_roles_subscriber'] = $es_c_rolesandcapabilities['es_roles_subscriber'];
				$form['es_roles_mail'] = $es_c_rolesandcapabilities['es_roles_mail'];
				$form['es_roles_notification'] = $es_c_rolesandcapabilities['es_roles_notification'];
				$form['es_roles_sendmail'] = $es_c_rolesandcapabilities['es_roles_sendmail'];
				$form['es_roles_sentmail'] = $es_c_rolesandcapabilities['es_roles_sentmail'];
			}

			// Cron Settings
			$es_cron_url = get_option('ig_es_cronurl', 'nocronurl');
			if($es_cron_url == "nocronurl") {
				$guid = es_cls_common::es_generate_guid(60);
				$home_url = home_url('/');
				$cronurl = $home_url . "?es=cron&guid=". $guid;
				add_option('ig_es_cronurl', $cronurl);
				$es_cron_url = get_option('ig_es_cronurl');
			}
			$form['ig_es_cronurl'] = $es_cron_url;

			$es_cron_mailcount = get_option('ig_es_cron_mailcount', '0');
			if($es_cron_mailcount == "0") {
				add_option('ig_es_cron_mailcount', "50");
				$es_cron_mailcount = get_option('ig_es_cron_mailcount');
			}
			$form['ig_es_cron_mailcount'] = $es_cron_mailcount;

			$blogname = get_option('blogname');
			$es_cron_adminmail = get_option('ig_es_cron_adminmail', '');
			if($es_cron_adminmail == "") {
				add_option('ig_es_cron_adminmail', "Hi Admin,\r\n\r\nCron URL has been triggered successfully on ###DATE### for the email ###SUBJECT###. And it sent email to ###COUNT### recipient(s).\r\n\r\nBest,\r\n".$blogname."");
				$es_cron_adminmail = get_option('ig_es_cron_adminmail');
			}
			$form['ig_es_cron_adminmail'] = $es_cron_adminmail;

			// Form submitted, check & update the data in options table
			if (isset($_POST['es_form_submit']) && $_POST['es_form_submit'] == 'yes') {
				// Just security thingy that wordpress offers us
				check_admin_referer('es_form_edit');

				// Fetch submitted Admin Data
				$form['ig_es_fromname'] = isset($_POST['es_c_fromname']) ? $_POST['es_c_fromname'] : '';
				$form['ig_es_fromname'] = stripslashes($form['ig_es_fromname']);
				if ($form['ig_es_fromname'] == '') {
					$es_errors[] = __( 'Please enter sender of notifications from name.', ES_TDOMAIN );
					$es_error_found = TRUE;
				}
				$form['ig_es_fromemail'] = isset($_POST['es_c_fromemail']) ? $_POST['es_c_fromemail'] : '';
				if ($form['ig_es_fromemail'] == '') {
					$es_errors[] = __( 'Please enter sender of notifications from email.', ES_TDOMAIN );
					$es_error_found = TRUE;
				}
				$form['ig_es_emailtype'] = isset($_POST['es_c_mailtype']) ? $_POST['es_c_mailtype'] : '';
				$form['ig_es_post_image_size'] = isset($_POST['es_c_post_image_size']) ? $_POST['es_c_post_image_size'] : '';
				$form['ig_es_adminemail'] = isset($_POST['es_c_adminemail']) ? $_POST['es_c_adminemail'] : '';
				$form['ig_es_notifyadmin'] = isset($_POST['es_c_adminmailoption']) ? $_POST['es_c_adminmailoption'] : '';
				$form['ig_es_admin_new_sub_subject'] = isset($_POST['es_c_adminmailsubject']) ? $_POST['es_c_adminmailsubject'] : '';
				$form['ig_es_admin_new_sub_content'] = isset($_POST['es_c_adminmailcontant']) ? $_POST['es_c_adminmailcontant'] : '';
				$form['ig_es_sentreport'] = isset($_POST['es_c_sentreport']) ? $_POST['es_c_sentreport'] : '';
				$form['ig_es_sentreport_subject'] = isset($_POST['es_c_sentreport_subject']) ? $_POST['es_c_sentreport_subject'] : '';

				// Fetch submitted Signup Configuration data
				$form['ig_es_welcomeemail'] = isset($_POST['es_c_usermailoption']) ? $_POST['es_c_usermailoption'] : '';
				$form['ig_es_welcomesubject'] = isset($_POST['es_c_usermailsubject']) ? $_POST['es_c_usermailsubject'] : '';
				$form['ig_es_welcomecontent'] = isset($_POST['es_c_usermailcontant']) ? $_POST['es_c_usermailcontant'] : '';
				$form['ig_es_optintype'] = isset($_POST['es_c_optinoption']) ? $_POST['es_c_optinoption'] : '';
				$form['ig_es_confirmsubject'] = isset($_POST['es_c_optinsubject']) ? $_POST['es_c_optinsubject'] : '';
				$form['ig_es_confirmcontent'] = isset($_POST['es_c_optincontent']) ? $_POST['es_c_optincontent'] : '';

				$home_url = home_url('/');

				$optinlink = $home_url . "?es=optin&db=###DBID###&email=###EMAIL###&guid=###GUID###";
				$form['ig_es_optinlink'] = $optinlink;

				$unsublink = $home_url . "?es=unsubscribe&db=###DBID###&email=###EMAIL###&guid=###GUID###";
				$form['ig_es_unsublink'] = $unsublink;

				$form['ig_es_unsubcontent'] = isset($_POST['es_c_unsubtext']) ? $_POST['es_c_unsubtext'] : '';
				$form['ig_es_unsubtext'] = isset($_POST['es_c_unsubhtml']) ? $_POST['es_c_unsubhtml'] : '';
				$form['ig_es_successmsg'] = isset($_POST['es_c_subhtml']) ? $_POST['es_c_subhtml'] : '';
				$form['ig_es_suberror'] = isset($_POST['es_c_message1']) ? $_POST['es_c_message1'] : '';
				$form['ig_es_unsuberror'] = isset($_POST['es_c_message2']) ? $_POST['es_c_message2'] : '';

				// Fetch submitted Roles Data
				$form['es_roles_subscriber'] = $roles['es_roles_subscriber'] = isset($_POST['es_roles_subscriber']) ? $_POST['es_roles_subscriber'] : '';
				$form['es_roles_mail'] = $roles['es_roles_mail'] = isset($_POST['es_roles_mail']) ? $_POST['es_roles_mail'] : '';
				$form['es_roles_notification'] = $roles['es_roles_notification'] = isset($_POST['es_roles_notification']) ? $_POST['es_roles_notification'] : '';
				$form['es_roles_sendmail'] = $roles['es_roles_sendmail'] = isset($_POST['es_roles_sendmail']) ? $_POST['es_roles_sendmail'] : '';
				$form['es_roles_sentmail'] = $roles['es_roles_sentmail'] = isset($_POST['es_roles_sentmail']) ? $_POST['es_roles_sentmail'] : '';

				// Fetch submitted Cron Data
				$es_cron_mailcount = isset($_POST['es_cron_mailcount']) ? $_POST['es_cron_mailcount'] : '';
				if( $es_cron_mailcount == "0" && strlen ($es_cron_mailcount) > 0  ) {
					$es_errors[] = __('Please enter valid mail count.', 'email-subscribers');
					$es_error_found = TRUE;
				} else {
					$form['ig_es_cron_mailcount'] = $es_cron_mailcount;
				}

				$form['ig_es_cron_adminmail'] = isset($_POST['es_cron_adminmail']) ? $_POST['es_cron_adminmail'] : '';

				//	No errors found, we can add the settings to tehe options
				if ($es_error_found == FALSE) {
					$action = "";
					$action = $this->es_settings_update( $form, $roles );
					if($action == "sus") {
						$es_success = __( 'Settings Saved.', ES_TDOMAIN );
					} else {
						$es_error_found == TRUE;
						$es_errors[] = __( 'Oops, unable to update.', ES_TDOMAIN );
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

			if ($es_error_found == FALSE && strlen($es_success) > 0) {
				?><div class="notice notice-success is-dismissible">
					<p><strong>
						<?php echo $es_success; ?>
					</strong></p>
				</div><?php
			}

			return $form;
		}

		public function es_settings_update( $form = '', $roles = '' ) {
			if ( ! empty( $form ) ) {
				foreach ( $form as $key => $value ) {
					update_option( $key, $value );
				}
			}
			if ( ! empty( $roles ) ) {
				update_option( 'ig_es_rolesandcapabilities', $roles );
			}

			return 'sus';
		}
	}
}

new ES_Settings();