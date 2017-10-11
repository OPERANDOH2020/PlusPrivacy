<?php

// Exit if accessed directly
if ( ! defined( 'ABSPATH' ) ) {
	exit; 
}

?>

<div class="wrap about-wrap es">

	<style>
		.wrap.about-wrap {
			background-color: transparent;
			position: relative;
			margin: 25px 40px 0 20px;
			box-shadow: none;
			-webkit-box-shadow: none;
		}
		.about-wrap.es {
			max-width: 100%
		}
		.about-header .wrap .button-hero {
			color: #FFFFFF!important;
			border-color: #03a025!important;
			background: #03a025 !important;
			box-shadow: 0 1px 0 #03a025;
			font-weight: bold;
			height: 2em;
			line-height: 1em;
		}
		.about-header .wrap .button-hero:hover {
			color: #FFF!important;
			background: #0AAB2E!important;
			border-color: #0AAB2E!important;
		}
		.about-header {
			background-color: #FFF;
			padding: 1em 1em 2.5em 1em;
			-webkit-box-shadow: 0 0 7px 0 rgba(0, 0, 0, .2);
			box-shadow: 0 0 7px 0 rgba(0, 0, 0, .2);
		}
		.wrap.klawoo-form {
			margin: 20px 20px 0 2px;
		}
		.es-ltr {
			width: 20em;
			height: 2em;
		}
		.es-about-text {
			margin: 0;
			font-size: 1.3em;
			padding-top: 1em;
		}
		.wrap.about-wrap h1 {
			font-size: 2.5em;
			line-height: 0.9em;
		}
		.feature-section.col>div {
			position: relative;
			width: 29.95%;
			margin-right: 4.999999999%;
			float: left
		}
		.feature-section.col.two-col>div {
			width: 45.95%
		}
		.feature-section.col img {
			width: 150px;
			border: none;
		}
		.feature-section.col p {
			margin-bottom: 1.5em
		}
		.about-wrap .feature-section h4 {
			margin-top: .4em
		}
		.about-wrap.es .feature-section {
			display: block!important
		}
		.about-wrap [class$=col] .last-feature {
			margin-right: 0
		}
		.about-wrap .es-badge,.es-support {
			position: absolute;
			top: 0;
		}
		.about-wrap .es-badge {
			right: 1.3em;
			color: #E1564B;
			background-color: transparent;
			padding-top: 100px;
			box-shadow: none;
			-webkit-box-shadow: none;
			background-image: url(../wp-content/plugins/email-subscribers/images/es-logo-64x64.png);
		}
		.es-badge {
			background: url(../wp-content/plugins/email-subscribers/images/es-logo-64x64.png) center no-repeat;
			color: #FFF;
			font-size: 12px;
			text-align: center;
			font-weight: 600;
			margin: 5px 0 0;
			padding-top: 110px;
			height: 24px;
			display: inline-block;
			width: 150px;
			text-rendering: optimizeLegibility;
			box-shadow: 0 1px 3px rgba(0, 0, 0, .2);
			-moz-box-shadow: 0 1px 3px rgba(0, 0, 0, .2);
			-webkit-box-shadow: 0 1px 3px rgba(0, 0, 0, .2);
		}
		.es-support {
			color: #000;
			margin: 178px 0 0;
			height: 10px;
			width: 180px;
			text-rendering: optimizeLegibility;
			text-align: right;
			right: 0;
			margin-top: 140px;
			padding-right: 1em;
		}
		.es-contact-us {
			font-size: 20px;
			line-height: 1.5em;
			font-weight: 800;
			margin-right: 20px;
		}
		.es-contact-us a {
			color: #E1564B;
		}
		.es-donate-link {
			text-align: right;
			font-size: 0.8em;
			margin-top: 1em;
		}
		.es-esaf-integration {
			width: 75% !important;
		}
		.es-ig-integration {
			width: 100% !important;
		}
		.es-rm-integration {
			width: 79% !important;
		}
		.es-integration-guide {
			text-align:justify;
		}

		.es_feature, .es_summary {
			line-height: 1.7em!important;
		}
		.es_summary {
			margin-left: 0em!important;
		}
		.es_feature_list, .es_faq_list {
			list-style-type:disc;
			margin-left: 1.5em!important;
		}
		.es_faq {
			margin-bottom: 1em;
			font-weight: 700;
		}
	</style>

	<?php
		$es_plugin_data = get_plugin_data( WP_PLUGIN_DIR.'/email-subscribers/email-subscribers.php' );
		$es_current_version = $es_plugin_data['Version'];
	?>

	<div class="about-header">
		<h1><?php echo __( 'Welcome to Email Subscribers!', ES_TDOMAIN ); ?></h1>
		<div class="es-about-text"><?php echo __( 'Thanks for installing and we hope you will enjoy using Email Subscribers.', ES_TDOMAIN ); ?></div>
		<div class="wrap klawoo-form">
			<table class="form-table">
				<tr>
					<th scope="row"><?php echo __( 'Get more help and tips...', ES_TDOMAIN ); ?></th>
					<td>
						<form name="klawoo_subscribe" action="#" method="POST" accept-charset="utf-8">
							<input class="es-ltr" type="text" name="email" id="email" placeholder="Your Email" />
							<input type="hidden" name="list" value="hN8OkYzujUlKgDgfCTEcIA"/>
							<input type="submit" name="submit" id="submit" class="button button-hero" value="<?php echo __( 'Subscribe', ES_TDOMAIN ); ?>">
							<br/>
							<div id="klawoo_response"></div>
						</form>
					</td>
				</tr>
			</table>
		</div>
		<div class="es-badge">
			<?php echo sprintf(__( "Version: %s", ES_TDOMAIN ), $es_current_version ); ?>
		</div>
		<div class="es-support">
			<?php echo __( 'Questions? Need Help?', ES_TDOMAIN ); ?>
			<div id="es-contact-us" class="es-contact-us"><a href="https://wordpress.org/support/plugin/email-subscribers" target="_blank"><?php echo __( "Contact Us", ES_TDOMAIN ); ?></a>
			</div>
		</div>
	</div>
	<div class="es-donate-link">
		<?php echo sprintf(__( 'Like Email Subscribers? If yes, then consider %s to support further developments.', ES_TDOMAIN ), '<a href="https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=CPTHCDC382KVA" target="_blank">' . __( 'donating to us', ES_TDOMAIN ) .'</a>' ); ?>
	</div>

    <script type="text/javascript">
        jQuery(function () {
            jQuery("form[name=klawoo_subscribe]").submit(function (e) {
                e.preventDefault();
                
                jQuery('#klawoo_response').html('');
                params = jQuery("form[name=klawoo_subscribe]").serializeArray();
                params.push( {name: 'action', value: 'es_klawoo_subscribe' });
                
                jQuery.ajax({
                    method: 'POST',
                    type: 'text',
                    url: "<?php echo admin_url( 'admin-ajax.php' ); ?>",
                    async: false,
                    data: params,
                    success: function(response) {

                        if (response != '') {
                            jQuery('#klawoo_response').html(response);
                        } else {
                            jQuery('#klawoo_response').html('error!');
                        }
                    }
                });
            });
        });
    </script>

	<?php $subbox_code = esc_html( '<?php es_subbox($namefield = "YES", $desc = "", $group = "Public"); ?>' ); ?>

	<div class="feature-section col two-col">
		<div class="col">
			<h3><?php echo __( 'Description', ES_TDOMAIN ); ?></h3>
			<p class="es_summary">
				<?php echo __( 'Email Subscribers is a complete newsletter plugin which lets you collect leads, send automated new blog post notification emails, create & send newsletters and manage all this in one single place.', ES_TDOMAIN ); ?>
			</p>
			<h3><?php echo __( 'Feature Overview', ES_TDOMAIN ); ?></h3>
			<ul class="es_feature_list">
				<li class="es_feature">
					<?php echo __( 'Collect customer emails by adding a subscription box (Widget/Shortcode/PHP Code).', ES_TDOMAIN ); ?>
				</li>
				<li class="es_feature">
					<?php echo __( 'Configure double Opt-In and Single Opt-In facility for subscribers.', ES_TDOMAIN ); ?>
				</li>
				<li class="es_feature">
					<?php echo __( 'Send automatic welcome email to subscribers.', ES_TDOMAIN ); ?>
				</li>
				<li class="es_feature">
					<?php echo __( 'Send new post notification emails to subscribers when new posts are published on your website.', ES_TDOMAIN ); ?>
				</li>
				<li class="es_feature">
					<?php echo __( 'Schedule email (Cron job) or send them manually.', ES_TDOMAIN ); ?>
				</li>
				<li class="es_feature">
					<?php echo __( 'Send email notification to admin when a new user signs up.', ES_TDOMAIN ); ?>
				</li>
				<li class="es_feature">
					<?php echo __( 'Automatically add Unsubscribe link in the email.', ES_TDOMAIN ); ?>
				</li>
				<li class="es_feature">
					<?php echo __( 'Easily migrate subscribers from another app using Import & Export.', ES_TDOMAIN ); ?>
				</li>
				<li class="es_feature">
					<?php echo __( 'Use HTML editor to compose newsletters and post notifications.', ES_TDOMAIN ); ?>
				</li>
				<li class="es_feature">
					<?php echo __( 'Send newsletters to different groups.', ES_TDOMAIN ); ?>
				</li>
				<li class="es_feature">
					<?php echo __( 'Get detailed sent email reports.', ES_TDOMAIN ); ?>
				</li>
				<li class="es_feature">
					<?php echo __( 'Control user access (User Roles and Capabilities).', ES_TDOMAIN ); ?>
				</li>
				<li class="es_feature">
					<?php echo __( 'Supports localization and internationalization.', ES_TDOMAIN ); ?>
				</li>
			</ul>
		</div>

		<div class="col last-feature">
			<div class="es-form-setup">
				<h3><?php echo __( 'Add Subscribe form', ES_TDOMAIN ); ?></h3>
				<p class="es_faq" style="margin-left: 0em!important;">
					<?php echo sprintf(__( '%s', ES_TDOMAIN ), '<a href="https://www.icegram.com/documentation/es-how-to-add-subscription-box-to-website/?utm_source=es&utm_medium=in_app&utm_campaign=view_docs_help_page" target="_blank">' . __( 'How to Add Subscription box to website?', ES_TDOMAIN ) . '</a>' ); ?>
				</p>
				<p style="line-height: 1.7em;font-size: 0.8em;margin-left: 0em!important;">
					<?php echo sprintf(__( 'Use any of the following 3 methods :<br>
								a) Shortcode in any page/post : <strong>[email-subscribers namefield="YES" desc="" group="Public"]</strong> <i>Or</i><br>
								b) Go to Appearance -> Widgets. Click on widget Email subscribers and drag it to the sidebar on the right <i>Or</i><br>
								c) Copy and past this php code to your desired template location : <strong>%s</strong>', ES_TDOMAIN ), esc_html( '<?php es_subbox($namefield = "YES", $desc = "", $group = "Public"); ?>' ) ); ?>
				</p>
				<h4> <?php echo __( 'Additional form settings', ES_TDOMAIN ); ?></h4>
				<ul class="es_faq_list">
					<li class="es_faq">
						<?php echo sprintf(__( '%s', ES_TDOMAIN ), '<a href="https://www.icegram.com/documentation/es-how-to-redirect-subscribers-to-a-new-page-url-after-successful-sign-up/?utm_source=es&utm_medium=in_app&utm_campaign=view_docs_help_page" target="_blank">' . __( 'How to Redirect Subscribers to a new page/url after successful sign up?', ES_TDOMAIN ) . '</a>' ); ?>
					</li>
					<li class="es_faq">
						<?php echo sprintf(__( '%s', ES_TDOMAIN ), '<a href="https://www.icegram.com/documentation/es-how-to-add-captcha-in-subscribe-form-of-email-subscribers/?utm_source=es&utm_medium=in_app&utm_campaign=view_docs_help_page" target="_blank">' . __( 'How to add captcha in Subscribe form of Email Subscribers?', ES_TDOMAIN ) . '</a>' ); ?>
					</li>
				</ul>
			</div>
			<br />
			<div class="es-setting">
				<h3><?php echo __( 'General Plugin Settings', ES_TDOMAIN ); ?></h3>
				<ul class="es_faq_list">
					<li class="es_faq">
						<?php echo sprintf(__( 'Modify %s', ES_TDOMAIN ), '<a href="https://www.icegram.com/documentation/es-general-plugin-settings/?utm_source=es&utm_medium=in_app&utm_campaign=view_docs_help_page" target="_blank">' . __( 'default text, email contents', ES_TDOMAIN ) . '</a>' . __( ' (like Confirmation, Welcome, Admin emails), Cron Settings and Assign User Roles', ES_TDOMAIN ) ); ?>
					</li>
					<li class="es_faq">
						<?php echo sprintf(__( '%s', ES_TDOMAIN ), '<a href="https://www.icegram.com/documentation/es-how-to-import-or-export-email-addresses/?utm_source=es&utm_medium=in_app&utm_campaign=view_docs_help_page" target="_blank">' . __( 'How to Import or Export Email Addresses?', ES_TDOMAIN ) . '</a>' ); ?>
					</li>
					<li class="es_faq">
						<?php echo sprintf(__( '%s', ES_TDOMAIN ), '<a href="https://www.icegram.com/documentation/es-how-to-add-update-existing-subscribers-group/?utm_source=es&utm_medium=in_app&utm_campaign=view_docs_help_page" target="_blank">' . __( 'How to Add/Update Existing Subscribers Group & Status?', ES_TDOMAIN ) . '</a>' ); ?>
					</li>
					<li class="es_faq">
						<?php echo sprintf(__( '%s', ES_TDOMAIN ), '<a href="https://www.icegram.com/documentation/es-how-to-change-update-translate-any-texts-from-email-subscribers/?utm_source=es&utm_medium=in_app&utm_campaign=view_docs_help_page" target="_blank">' . __( 'How to change/update/translate any texts from the plugin?', ES_TDOMAIN ) . '</a>' ); ?>
					</li>
					<li class="es_faq">
						<?php echo sprintf(__( '%s', ES_TDOMAIN ), '<a href="https://www.icegram.com/documentation/es-how-to-add-unsubscribe-link-in-emails/?utm_source=es&utm_medium=in_app&utm_campaign=view_docs_help_page" target="_blank">' . __( 'How to add Unsubscribe link in emails?', ES_TDOMAIN ) . '</a>' ); ?>
					</li>
				</ul>
			</div>
		</div>
	</div>
	<hr />
	<div class="feature-section col three-col">
		<div class="col-1">
			<div class="es-usage">
				<h3><?php echo __( 'Usage', ES_TDOMAIN ); ?></h3>
				<ul class="es_faq_list">
					<li class="es_faq">
						<?php echo sprintf(__( '%s', ES_TDOMAIN ), '<a href="https://www.icegram.com/documentation/es-how-to-compose-and-send-newsletter-emails/?utm_source=es&utm_medium=in_app&utm_campaign=view_docs_help_page" target="_blank">' . __( 'Compose and Send Newsletter Emails', ES_TDOMAIN ) . '</a>' ); ?>
					</li>
					<li class="es_faq">
						<?php echo sprintf(__( '%s', ES_TDOMAIN ), '<a href="https://www.icegram.com/documentation/es-how-to-configure-and-send-notification-emails-to-subscribers-when-new-posts-are-published/?utm_source=es&utm_medium=in_app&utm_campaign=view_docs_help_page" target="_blank">' . __( 'Compose and Send Post Notification Emails when new posts are published', ES_TDOMAIN ) . '</a>' ); ?>
					</li>
					<li class="es_faq">
						<?php echo sprintf(__( '%s', ES_TDOMAIN ), '<a href="https://www.icegram.com/documentation/es-what-are-the-available-keywords-in-the-post-notifications/?utm_source=es&utm_medium=in_app&utm_campaign=view_docs_help_page" target="_blank">' . __( 'Keywords in the Post Notifications', ES_TDOMAIN ) . '</a>' ); ?>
					</li>
					<li class="es_faq">
						<?php echo sprintf(__( '%s', ES_TDOMAIN ), '<a href="https://www.icegram.com/documentation/es-how-to-send-a-sample-new-post-notification-email-to-testgroup-myself/?utm_source=es&utm_medium=in_app&utm_campaign=view_docs_help_page" target="_blank">' . __( 'Send a test post notification email to myself/testgroup', ES_TDOMAIN ) . '</a>' ); ?>
					</li>
					<li class="es_faq">
						<?php echo sprintf(__( '%s', ES_TDOMAIN ), '<a href="https://www.icegram.com/documentation/es-how-to-check-sent-emails/?utm_source=es&utm_medium=in_app&utm_campaign=view_docs_help_page" target="_blank">' . __( 'Check sent emails', ES_TDOMAIN ) . '</a>' ); ?>
					</li>
				</ul>
			</div>
		</div>
		<div class="col-2">
			<div class="es-cron-job">
				<h3><?php echo __( 'Cron Job Setup', ES_TDOMAIN ); ?></h3>
				<ul class="es_faq_list">
					<li class="es_faq">
						<?php echo sprintf(__( '%s', ES_TDOMAIN ), '<a href="https://www.icegram.com/documentation/es-how-to-schedule-cron-emails/?utm_source=es&utm_medium=in_app&utm_campaign=view_docs_help_page" target="_blank">' . __( 'How to Schedule Cron Emails?', ES_TDOMAIN ) . '</a>' ); ?>
					</li>
					<li class="es_faq">
						<?php echo sprintf(__( '%s', ES_TDOMAIN ), '<a href="https://www.icegram.com/documentation/es-how-to-schedule-cron-emails-in-cpanel/?utm_source=es&utm_medium=in_app&utm_campaign=view_docs_help_page" target="_blank">' . __( 'Schedule Cron Emails in cPanel', ES_TDOMAIN ) . '</a>' ); ?>
					</li>
					<li class="es_faq">
						<?php echo sprintf(__( '%s', ES_TDOMAIN ), '<a href="https://www.icegram.com/documentation/es-how-to-schedule-cron-emails-in-parallels-plesk/?utm_source=es&utm_medium=in_app&utm_campaign=view_docs_help_page" target="_blank">' . __( 'Schedule Cron Emails in Parallels Plesk', ES_TDOMAIN ) . '</a>' ); ?>
					</li>
					<li class="es_faq">
						<?php echo sprintf(__( '%s', ES_TDOMAIN ), '<a href="https://www.icegram.com/documentation/es-what-to-do-if-hosting-doesnt-support-cron-jobs/?utm_source=es&utm_medium=in_app&utm_campaign=view_docs_help_page" target="_blank">' . __( 'Hosting doesn’t support Cron Jobs?', ES_TDOMAIN ) . '</a>' ); ?>
					</li>
				</ul>
			</div>
		</div>
		<div class="col-3 last-feature">
			<div class="es-troubleshooting-steps">
				<h3><?php echo __( 'Troubleshooting Steps', ES_TDOMAIN ); ?></h3>
				<ul class="es_faq_list">
					<li class="es_faq">
						<?php echo sprintf(__( '%s', ES_TDOMAIN ), '<a href="https://www.icegram.com/documentation/es-subscribers-are-not-receiving-emails/?utm_source=es&utm_medium=in_app&utm_campaign=view_docs_help_page" target="_blank">' . __( 'Subscribers are not receiving Emails?', ES_TDOMAIN ) . '</a>' ); ?>
					</li>
					<li class="es_faq">
						<?php echo sprintf(__( '%s', ES_TDOMAIN ), '<a href="https://www.icegram.com/documentation/es-css-help/?utm_source=es&utm_medium=in_app&utm_campaign=view_docs_help_page" target="_blank">' . __( 'CSS Help', ES_TDOMAIN ) . '</a>' ); ?>
					<li class="es_faq">
						<?php echo sprintf(__( '%s', ES_TDOMAIN ), '<a href="https://www.icegram.com/documentation/es-faq/?utm_source=es&utm_medium=in_app&utm_campaign=view_docs_help_page" target="_blank">' . __( 'FAQ\'s', ES_TDOMAIN ) . '</a>' ); ?>
					</li>
				</ul>
			</div>
		</div>
	</div>
	<hr />
	<h2><?php echo __( 'Want to do more? Here\'s how..', ES_TDOMAIN ); ?></h2>
	<div class="feature-section col three-col">
		<div class="col-1">
			<h3 style="text-align:left;"><?php echo __( 'Allow Subscribers to get subscribed to any group', ES_TDOMAIN ); ?></h3>
			<div>
				<img class="es-esaf-integration" alt="Group Selector" src="<?php echo ES_URL; ?>images/es-esaf-integration.png" />
			</div>
			<p class="es-integration-guide">
				<?php echo __( 'Using our free ', ES_TDOMAIN ); ?>
				<a target="_blank" href="https://wordpress.org/plugins/email-subscribers-advanced-form/"><?php echo __( 'Group Selector', ES_TDOMAIN ); ?></a>
				<?php echo __( 'plugin, you can extend Email Subscribers Form functionality by providing an grouping option right next to the form.', ES_TDOMAIN ); ?>
			</p>
			<p class="es-integration-guide">
				<?php echo __( 'The user can then subscribe to whichever group most appeals to them.', ES_TDOMAIN ); ?>
			</p>
			<p class="es-integration-guide">
				<?php echo __( 'For example: Subscribe either to Updates or to Offers.', ES_TDOMAIN ); ?>
			</p>
		</div>
		<div class="col-2">
			<h3 style="text-align:left;"><?php echo __( 'Show your subscribe form inside attractive popups', ES_TDOMAIN ); ?></h3>
			<div>
				<img class="es-ig-integration" alt="Icegram" src="<?php echo ES_URL; ?>images/es-ig-integration.png" />
			</div>
			<p class="es-integration-guide">
				<?php echo __( 'Don\'t limit your subscriber form to a widget. Embed it within popups, hello bars, slide-ins, sidebars, full screen popups etc.', ES_TDOMAIN ); ?>
			</p>
			<p class="es-integration-guide">
				<?php echo __( 'Using Email Subscribers you can achieve this easily with our free plugin ', ES_TDOMAIN ); ?>
				<a target="_blank" href="https://wordpress.org/plugins/icegram/"><?php echo __( 'Icegram', ES_TDOMAIN ); ?></a>
			</p>
			<p class="es-integration-guide">
				<?php echo __( 'Icegram\'s beautiful designs instantly capture user attention and help increase sign-ups to your WordPress website.', ES_TDOMAIN ); ?>
			</p>
			<p class="es_faq es-integration-guide">
				<?php echo sprintf(__( 'How to %s', ES_TDOMAIN ), '<a href="https://www.icegram.com/documentation/es-how-to-show-subscribe-form-inside-a-popup/?utm_source=es&utm_medium=in_app&utm_campaign=view_docs_help_page" target="_blank">' . __( 'show subscribe form inside a popup', ES_TDOMAIN ) . '</a>' ); ?>
			</p>
		</div>
		<div class="col-3 last-feature">
			<h3 style="text-align:left;"><?php echo __( 'Get beautiful and elegant form styles', ES_TDOMAIN ); ?></h3>

			<div>
				<img class="es-rm-integration" alt="Rainmaker" src="<?php echo ES_URL; ?>images/es-rm-integration.png" />
			</div>
			<p class="es-integration-guide">
				<?php echo __( 'Email subscribers easily integrates with another free plugin ', ES_TDOMAIN ); ?>
				<a target="_blank" href="https://wordpress.org/plugins/icegram-rainmaker/"><?php echo __( 'Rainmaker', ES_TDOMAIN ); ?></a>
			</p>
			<p class="es-integration-guide">
				<?php echo __( 'Rainmaker extends the core features of Email Subscribers and provides elegant form styles.', ES_TDOMAIN ); ?>
			</p>
			<p>
				<?php echo __( 'These styles are well designed and beautify your subscription form making it more appealing.', ES_TDOMAIN ); ?>
			</p>
			<p class="es_faq es-integration-guide">
				<?php echo sprintf(__( 'How to %s', ES_TDOMAIN ), '<a href="https://www.icegram.com/documentation/es-how-to-use-rainmakers-form-in-email-subscribers/?utm_source=es&utm_medium=in_app&utm_campaign=view_docs_help_page" target="_blank">' . __( 'add Rainmaker’s form in Email Subscribers', ES_TDOMAIN ) . '</a>' ); ?>
			</p>
		</div>
	</div>
</div>