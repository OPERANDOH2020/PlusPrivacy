<?php

// Exit if accessed directly
if ( ! defined( 'ABSPATH' ) ) {
	exit; 
}

?>

<div class="about_wrap">

	<style>
		.about_wrap {
			right: 1.3em;
			background-color: transparent;
			margin: 25px 40px 0 20px;
			box-shadow: none;
			-webkit-box-shadow: none;
		}
		.about_header .wrap .button-hero {
			color: #FFFFFF!important;
			border-color: #03a025!important;
			background: #03a025 !important;
			box-shadow: 0 1px 0 #03a025;
			font-weight: bold;
			height: 2em;
			line-height: 1em;
		}
		.about_header .wrap .button-hero:hover {
			color: #FFF!important;
			background: #0AAB2E!important;
			border-color: #0AAB2E!important;
		}
		.about_header {
			background-color: #FFF;
			padding: 1em 1em 0.5em 1em;
			-webkit-box-shadow: 0 0 7px 0 rgba(0, 0, 0, .2);
			box-shadow: 0 0 7px 0 rgba(0, 0, 0, .2);
		}

		.es-ltr {
			width: 20em;
		}
	</style>

	<div class="about_header">
		<h1><?php echo __( 'Welcome to Email Subscribers!', ES_TDOMAIN ); ?></h1>
		<div><?php echo __( 'Thanks for installing and we hope you will enjoy using Email Subscribers.', ES_TDOMAIN ); ?></div>
		<div class="wrap">
			<table class="form-table">
				<tr>
					<th scope="row"><?php echo __( 'For more help and tips...', ES_TDOMAIN ); ?></th>
					<td>
						<form name="klawoo_subscribe" action="#" method="POST" accept-charset="utf-8">
							<input class="es-ltr" type="text" name="email" id="email" placeholder="Email" />
							<input type="hidden" name="list" value="hN8OkYzujUlKgDgfCTEcIA"/>
							<input type="submit" name="submit" id="submit" class="button button-hero" value="Subscribe">
							<br/>
							<div id="klawoo_response"></div>
						</form>
					</td>
				</tr>
			</table>
		</div>
	</div>
	<div class="wrap" style="text-align:right;">
		<?php echo sprintf(__( 'Like Email Subscribers? Please consider %s.', ES_TDOMAIN ), '<a href="https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=CPTHCDC382KVA" target="_blank">' . __( 'contributing to us', ES_TDOMAIN ) .'</a>' ); ?>
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

	<br/>
    <h1><?php echo __( 'Frequently Asked Questions', ES_TDOMAIN ); ?></h1>
</div>

<div class="wrap about-wrap">
	<style>
		.es_faq_list {
			margin-left: 1em;
		}
		.es_faq {
			margin-bottom: 1.3em;
			font-weight: 700;
		}
		
	</style>

	<?php $subbox_code = esc_html( '<?php es_subbox( $namefield = "YES", $desc = "", $group = "Public" ); ?>' ); ?>

	<ol class="es_faq_list">
		<li class="es_faq">
			<?php echo sprintf(__( '%s', ES_TDOMAIN ), '<a href="http://www.icegram.com/documentation/es-how-to-add-subscription-box-to-website/" target="_blank">' . __( 'How to Add Subscription box to website?', ES_TDOMAIN ) . '</a>' ); ?>
			<p style="line-height: 1.7em;">
				<?php echo __( 'Use any of the following 3 methods to add subscription form to your website :<br>
							a) Use shortcode in any page/post : <strong>[email-subscribers namefield="YES" desc="" group="Public"]</strong> <i>Or</i><br>
							b) Go to Dashboard->Appearance->Widgets. Click on widget Email subscribers and click Add Widget button or drag it to the sidebar on the right <i>Or</i><br>
							c) Copy and past this php code to your desired template location : <strong>'. $subbox_code .'</strong>', ES_TDOMAIN ); ?>
			</p>
		</li>
		<li class="es_faq">
			<?php echo sprintf(__( '%s', ES_TDOMAIN ), '<a href="http://www.icegram.com/documentation/es-general-plugin-settings/" target="_blank">' . __( 'General Plugin Settings', ES_TDOMAIN ) . '</a>' . __( ' (How to modify the existing email content like Confirmation email, Welcome email, Admin emails)', ES_TDOMAIN ) ); ?>
		</li>
		<li class="es_faq">
			<?php echo sprintf(__( '%s', ES_TDOMAIN ), '<a href="http://www.icegram.com/documentation/es-how-to-import-or-export-email-addresses/" target="_blank">' . __( 'How to Import or Export Email Addresses?', ES_TDOMAIN ) . '</a>' ); ?>
		</li>
		<li class="es_faq">
			<?php echo sprintf(__( '%s', ES_TDOMAIN ), '<a href="http://www.icegram.com/documentation/es-how-to-change-update-translate-any-texts-from-email-subscribers/" target="_blank">' . __( 'How to change/update/translate any texts from Email Subscribers?', ES_TDOMAIN ) . '</a>' ); ?>
		</li>
		<li class="es_faq">
			<?php echo sprintf(__( '%s', ES_TDOMAIN ), '<a href="http://www.icegram.com/documentation/es-how-to-add-unsubscribe-link-in-emails/" target="_blank">' . __( 'How to add Unsubscribe link in emails?', ES_TDOMAIN ) . '</a>' ); ?>
		</li>
		<li class="es_faq">
			<?php echo sprintf(__( '%s', ES_TDOMAIN ), '<a href="http://www.icegram.com/documentation/es-what-are-static-templates-and-dynamic-templates/" target="_blank">' . __( 'What are Static Templates and Dynamic Templates?', ES_TDOMAIN ) . '</a>' ); ?>
		</li>
		<li class="es_faq">
			<?php echo sprintf(__( '%s', ES_TDOMAIN ), '<a href="http://www.icegram.com/documentation/es-how-to-compose-and-send-static-newsletter-mails/" target="_blank">' . __( 'How to Compose and Send Newsletter Emails?', ES_TDOMAIN ) . '</a>' ); ?>
		</li>
		<li class="es_faq">
			<?php echo sprintf(__( '%s', ES_TDOMAIN ), '<a href="http://www.icegram.com/documentation/es-how-to-configure-and-send-notification-emails-to-subscribers-when-new-posts-are-published/" target="_blank">' . __( 'How to Configure and Send Post Notification emails to subscribers when new posts are published?', ES_TDOMAIN ) . '</a>' ); ?>
		</li>
		<li class="es_faq">
			<?php echo sprintf(__( '%s', ES_TDOMAIN ), '<a href="http://www.icegram.com/documentation/es-how-to-send-a-sample-new-post-notification-email-to-testgroup-myself/" target="_blank">' . __( 'How to Send a sample new post notification email to testgroup/myself?', ES_TDOMAIN ) . '</a>' ); ?>
		</li>
		<li class="es_faq">
			<?php echo sprintf(__( '%s', ES_TDOMAIN ), '<a href="http://www.icegram.com/documentation/es-how-to-check-sent-emails/" target="_blank">' . __( 'How to check Sent emails reports?', ES_TDOMAIN ) . '</a>' ); ?>
		</li>
		<li class="es_faq">
			<?php echo sprintf(__( '%s', ES_TDOMAIN ), '<a href="http://www.icegram.com/documentation/es-how-to-add-update-existing-subscribers-group/" target="_blank">' . __( 'How to Add/Update Existing Subscribers Group?', ES_TDOMAIN ) . '</a>' ); ?>
		</li>
		<li class="es_faq">
			<?php echo sprintf(__( '%s', ES_TDOMAIN ), '<a href="http://www.icegram.com/documentation/es-subscribers-are-not-receiving-emails/" target="_blank">' . __( 'Subscribers are not receiving Emails?', ES_TDOMAIN ) . '</a>' ); ?>
		</li>
		<li class="es_faq">
			<?php echo sprintf(__( '%s', ES_TDOMAIN ), '<a href="http://www.icegram.com/documentation/es-how-to-show-subscribe-form-inside-a-popup/" target="_blank">' . __( 'How to show subscribe form inside a popup?', ES_TDOMAIN ) . '</a>' ); ?>
		</li>
		<li class="es_faq">
			<?php echo sprintf(__( '%s', ES_TDOMAIN ), '<a href="http://www.icegram.com/documentation/es-how-to-use-rainmakers-form-in-email-subscribers/" target="_blank">' . __( 'How to use Rainmaker’s form in Email Subscribers?', ES_TDOMAIN ) . '</a>' ); ?>
		</li>
		<li class="es_faq">
			<?php echo sprintf(__( '%s', ES_TDOMAIN ), '<a href="http://www.icegram.com/documentation/es-how-to-schedule-cron-emails/" target="_blank">' . __( 'How to Schedule Cron Mails?', ES_TDOMAIN ) . '</a>' ); ?>
		</li>
		<li class="es_faq">
			<?php echo sprintf(__( '%s', ES_TDOMAIN ), '<a href="http://www.icegram.com/documentation/es-how-to-schedule-cron-emails-in-cpanel/" target="_blank">' . __( 'How to Schedule Cron Emails in cPanel?', ES_TDOMAIN ) . '</a>' ); ?>
		</li>
		<li class="es_faq">
			<?php echo sprintf(__( '%s', ES_TDOMAIN ), '<a href="http://www.icegram.com/documentation/es-how-to-schedule-cron-emails-in-parallels-plesk/" target="_blank">' . __( 'How to Schedule Cron Emails in Parallels Plesk?', ES_TDOMAIN ) . '</a>' ); ?>
		</li>
		<li class="es_faq">
			<?php echo sprintf(__( '%s', ES_TDOMAIN ), '<a href="http://www.icegram.com/documentation/es-what-to-do-if-hosting-doesnt-support-cron-jobs/" target="_blank">' . __( 'What to do if Hosting doesn’t support Cron Jobs?', ES_TDOMAIN ) . '</a>' ); ?>
		</li>
		<li class="es_faq">
			<?php echo sprintf(__( '%s', ES_TDOMAIN ), '<a href="http://www.icegram.com/documentation/es-css-help/" target="_blank">' . __( 'CSS Help', ES_TDOMAIN ) . '</a>' ); ?>
		<li class="es_faq">
			<?php echo sprintf(__( '%s', ES_TDOMAIN ), '<a href="http://www.icegram.com/documentation/es-faq/" target="_blank">' . __( 'Commonly Asked Questions', ES_TDOMAIN ) . '</a>' ); ?>
		</li>
	</ol>
</div>