<!-- Upgrade to pro link box -->
<!-- TOP BOX-->

<?php
	global $wpdb;
	$Slug_Base = get_option("EWD_UFAQ_Slug_Base");
	
	//start review box
	if (isset($_POST['hide_ufaq_review_box_hidden'])) {update_option('EWD_UFAQ_Hide_Dash_Review_Ask', sanitize_text_field($_POST['hide_ufaq_review_box_hidden']));}
	$hideReview = get_option('EWD_UFAQ_Hide_Dash_Review_Ask');
	$Ask_Review_Date = get_option('EWD_UFAQ_Ask_Review_Date');
	if ($Ask_Review_Date == "") {$Ask_Review_Date = get_option("EWD_UFAQ_Install_Time") + 3600*24*4;}

	//end review box
?>





<!-- START NEW DASHBOARD -->

<div id="ewd-ufaq-dashboard-content-area">

	<div id="ewd-ufaq-dashboard-content-left">

		<?php if ($UFAQ_Full_Version != "Yes" or get_option("EWD_UFAQ_Trial_Happening") == "Yes") { ?>
			<div class="ewd-ufaq-dashboard-new-widget-box ewd-widget-box-full">
				<div class="ewd-ufaq-dashboard-new-widget-box-top">
					<form method="post" action="admin.php?page=EWD-UFAQ-Options" class="ewd-ufaq-dashboard-key-widget">
						<input class="ewd-ufaq-dashboard-key-widget-input" name="Key" type="text" placeholder="<?php _e('Enter Product Key Here', 'ultimate-faqs'); ?>">
						<input class="ewd-ufaq-dashboard-key-widget-submit" name="EWD_UFAQ_Upgrade_To_Full" type="submit" value="<?php _e('UNLOCK PREMIUM', 'ultimate-faqs'); ?>">
						<div class="ewd-ufaq-dashboard-key-widget-text">Don't have a key? Use the <a href="http://www.etoilewebdesign.com/plugins/ultimate-faq/#buy" target="_blank">Upgrade Now</a> button above to purchase and unlock all premium features.</div>
					</form>
				</div>
			</div>
		<?php } ?>

		<div class="ewd-ufaq-dashboard-new-widget-box ewd-widget-box-full" id="ewd-ufaq-dashboard-support-widget-box">
			<div class="ewd-ufaq-dashboard-new-widget-box-top">Get Support<span id="ewd-ufaq-dash-mobile-support-down-caret">&nbsp;&nbsp;&#9660;</span><span id="ewd-ufaq-dash-mobile-support-up-caret">&nbsp;&nbsp;&#9650;</span></div>
			<div class="ewd-ufaq-dashboard-new-widget-box-bottom">
				<ul class="ewd-ufaq-dashboard-support-widgets">
					<li>
						<a href="https://www.youtube.com/playlist?list=PLEndQUuhlvSrNdfu5FKa1uGHsaKZxgdWt" target="_blank">
							<img src="<?php echo plugins_url( '../images/ewd-support-icon-youtube.png', __FILE__ ); ?>">
							<div class="ewd-ufaq-dashboard-support-widgets-text">YouTube Tutorials</div>
						</a>
					</li>
					<li>
						<a href="https://wordpress.org/plugins/ultimate-faqs/#faq" target="_blank">
							<img src="<?php echo plugins_url( '../images/ewd-support-icon-faqs.png', __FILE__ ); ?>">
							<div class="ewd-ufaq-dashboard-support-widgets-text">Plugin FAQs</div>
						</a>
					</li>
					<li>
						<a href="https://wordpress.org/support/plugin/ultimate-faqs" target="_blank">
							<img src="<?php echo plugins_url( '../images/ewd-support-icon-forum.png', __FILE__ ); ?>">
							<div class="ewd-ufaq-dashboard-support-widgets-text">Support Forum</div>
						</a>
					</li>
					<li>
						<a href="https://www.etoilewebdesign.com/plugins/ultimate-faq/documentation-ultimate-faq/" target="_blank">
							<img src="<?php echo plugins_url( '../images/ewd-support-icon-documentation.png', __FILE__ ); ?>">
							<div class="ewd-ufaq-dashboard-support-widgets-text">Documentation</div>
						</a>
					</li>
				</ul>
			</div>
		</div>

		<div class="ewd-ufaq-dashboard-new-widget-box ewd-widget-box-full" id="ewd-ufaq-dashboard-optional-table">
			<div class="ewd-ufaq-dashboard-new-widget-box-top">FAQ Summary<span id="ewd-ufaq-dash-optional-table-down-caret">&nbsp;&nbsp;&#9660;</span><span id="ewd-ufaq-dash-optional-table-up-caret">&nbsp;&nbsp;&#9650;</span></div>
			<div class="ewd-ufaq-dashboard-new-widget-box-bottom">
				<table class='ewd-ufaq-overview-table wp-list-table widefat fixed striped posts'>
					<thead>
						<tr>
							<th><?php _e("Title", 'EWD_ABCO'); ?></th>
							<th><?php _e("Views", 'EWD_ABCO'); ?></th>
							<th><?php _e("Categories", 'EWD_ABCO'); ?></th>
						</tr>
					</thead>
					<tbody>
						<?php
							$args = array(
								'post_type' => 'ufaq',
								'orderby' => 'meta_value_num',
								'meta_key' => 'ufaq_view_count',
								'posts_per_page' => 10
							);

							$Dashboard_FAQs_Query = new WP_Query($args);
							$Dashboard_FAQs = $Dashboard_FAQs_Query->get_posts();

							if (sizeOf($Dashboard_FAQs) == 0) {echo "<tr><td colspan='3'>" . __("No FAQs to display yet. Create an FAQ and then view it for it to be displayed here.", 'ultimate-faqs') . "</td></tr>";}
							else {
								foreach ($Dashboard_FAQs as $Dashboard_FAQ) { ?>
									<tr>
										<td><a href='post.php?post=<?php echo $Dashboard_FAQ->ID;?>&action=edit'><?php echo $Dashboard_FAQ->post_title; ?></a></td>
										<td><?php echo get_post_meta($Dashboard_FAQ->ID, 'ufaq_view_count', true); ?></td>
										<td><?php echo EWD_UFAQ_Get_Categories($Dashboard_FAQ->ID); ?></td>
									</tr>
								<?php }
							}
						?>
					</tbody>
				</table>
			</div>
		</div>

		<div class="ewd-ufaq-dashboard-new-widget-box <?php echo ( ($hideReview != 'Yes' and $Ask_Review_Date < time()) ? 'ewd-widget-box-two-thirds' : 'ewd-widget-box-full' ); ?>">
			<div class="ewd-ufaq-dashboard-new-widget-box-top">What People Are Saying</div>
			<div class="ewd-ufaq-dashboard-new-widget-box-bottom">
				<ul class="ewd-ufaq-dashboard-testimonials">
					<?php $randomTestimonial = rand(0,2);
					if($randomTestimonial == 0){ ?>
						<li id="ewd-ufaq-dashboard-testimonial-one">
							<img src="<?php echo plugins_url( '../images/dash-asset-stars.png', __FILE__ ); ?>">
							<div class="ewd-ufaq-dashboard-testimonial-title">"Awesome. Just Awesome."</div>
							<div class="ewd-ufaq-dashboard-testimonial-author">- @shizart</div>
							<div class="ewd-ufaq-dashboard-testimonial-text">Thanks for this very well-made plugin. This works so well out of the box, I barely had to do ANYTHING to create an amazing FAQ accordion display... <a href="https://wordpress.org/support/topic/awesome-just-awesome-11/" target="_blank">read more</a></div>
						</li>
					<?php }
					if($randomTestimonial == 1){ ?>
						<li id="ewd-ufaq-dashboard-testimonial-two">
							<img src="<?php echo plugins_url( '../images/dash-asset-stars.png', __FILE__ ); ?>">
							<div class="ewd-ufaq-dashboard-testimonial-title">"Absolutely perfect with great support"</div>
							<div class="ewd-ufaq-dashboard-testimonial-author">- @isaac85</div>
							<div class="ewd-ufaq-dashboard-testimonial-text">I tried several different FAQ plugins and this is by far the prettiest and easiest to use... <a href="https://wordpress.org/support/topic/absolutely-perfect-with-great-support/" target="_blank">read more</a></div>
						</li>
					<?php }
					if($randomTestimonial == 2){ ?>
						<li id="ewd-ufaq-dashboard-testimonial-three">
							<img src="<?php echo plugins_url( '../images/dash-asset-stars.png', __FILE__ ); ?>">
							<div class="ewd-ufaq-dashboard-testimonial-title">"Perfect FAQ Plugin"</div>
							<div class="ewd-ufaq-dashboard-testimonial-author">- @muti-wp</div>
							<div class="ewd-ufaq-dashboard-testimonial-text">Works great! Easy to configure and to use. Thanks! <a href="https://wordpress.org/support/topic/perfect-faq-plugin/" target="_blank">read more</a></div>
						</li>
					<?php } ?>
				</ul>
			</div>
		</div>

		<?php if($hideReview != 'Yes' and $Ask_Review_Date < time()){ ?>
			<div class="ewd-ufaq-dashboard-new-widget-box ewd-widget-box-one-third">
				<div class="ewd-ufaq-dashboard-new-widget-box-top">Leave a review</div>
				<div class="ewd-ufaq-dashboard-new-widget-box-bottom">
					<div class="ewd-ufaq-dashboard-review-ask">
						<img src="<?php echo plugins_url( '../images/dash-asset-stars.png', __FILE__ ); ?>">
						<div class="ewd-ufaq-dashboard-review-ask-text">If you enjoy this plugin and have a minute, please consider leaving a 5-star review. Thank you!</div>
						<a href="https://wordpress.org/plugins/ultimate-faqs/#reviews" class="ewd-ufaq-dashboard-review-ask-button">LEAVE A REVIEW</a>
						<form action="admin.php?page=EWD-UFAQ-Options" method="post">
							<input type="hidden" name="hide_ufaq_review_box_hidden" value="Yes">
							<input type="submit" name="hide_ufaq_review_box_submit" class="ewd-ufaq-dashboard-review-ask-dismiss" value="I've already left a review">
						</form>
					</div>
				</div>
			</div>
		<?php } ?>

		<?php if ($UFAQ_Full_Version != "Yes" or get_option("EWD_UFAQ_Trial_Happening") == "Yes") { ?>
			<div class="ewd-ufaq-dashboard-new-widget-box ewd-widget-box-full" id="ewd-ufaq-dashboard-guarantee-widget-box">
				<div class="ewd-ufaq-dashboard-new-widget-box-top">
					<div class="ewd-ufaq-dashboard-guarantee">
						<div class="ewd-ufaq-dashboard-guarantee-title">14-Day 100% Money-Back Guarantee</div>
						<div class="ewd-ufaq-dashboard-guarantee-text">If you're not 100% satisfied with the premium version of our plugin - no problem. You have 14 days to receive a FULL REFUND. We're certain you won't need it, though. Lorem ipsum dolor sitamet, consectetuer adipiscing elit.</div>
					</div>
				</div>
			</div>
		<?php } ?>

	</div> <!-- left -->

	<div id="ewd-ufaq-dashboard-content-right">

		<?php if ($UFAQ_Full_Version != "Yes" or get_option("EWD_UFAQ_Trial_Happening") == "Yes") { ?>
			<div class="ewd-ufaq-dashboard-new-widget-box ewd-widget-box-full" id="ewd-ufaq-dashboard-get-premium-widget-box">
				<div class="ewd-ufaq-dashboard-new-widget-box-top">Get Premium</div>
				<?php if(get_option("EWD_UFAQ_Trial_Happening") == "Yes"){ 
					$trialExpireTime = get_option("EWD_UFAQ_Trial_Expiry_Time");
					$currentTime = time();
					$trialTimeLeft = $trialExpireTime - $currentTime;
					$trialTimeLeftDays = ( date("d", $trialTimeLeft) ) - 1;
					$trialTimeLeftHours = date("H", $trialTimeLeft);
					?>
					<div class="ewd-ufaq-dashboard-new-widget-box-bottom">
						<div class="ewd-ufaq-dashboard-get-premium-widget-trial-time">
							<div class="ewd-ufaq-dashboard-get-premium-widget-trial-days"><?php echo $trialTimeLeftDays; ?><span>days</span></div>
							<div class="ewd-ufaq-dashboard-get-premium-widget-trial-hours"><?php echo $trialTimeLeftHours; ?><span>hours</span></div>
						</div>
						<div class="ewd-ufaq-dashboard-get-premium-widget-trial-time-left">LEFT IN TRIAL</div>
					</div>
				<?php } ?>
				<div class="ewd-ufaq-dashboard-new-widget-box-bottom">
					<div class="ewd-ufaq-dashboard-get-premium-widget-features-title"<?php echo ( get_option("EWD_UFAQ_Trial_Happening") == "Yes" ? "style='padding-top: 20px;'" : ""); ?>>GET FULL ACCESS WITH OUR PREMIUM VERSION AND GET:</div>
					<ul class="ewd-ufaq-dashboard-get-premium-widget-features">
						<li>Unlimited FAQs</li>
						<li>Advanced Styling Options</li>
						<li>Social Sharing</li>
						<li>SEO-Friendly Permalinks</li>
						<li>+ More</li>
					</ul>
					<a href="http://www.etoilewebdesign.com/plugins/ultimate-faq/#buy" class="ewd-ufaq-dashboard-get-premium-widget-button" target="_blank">UPGRADE NOW</a>
					<?php if (!get_option("EWD_UFAQ_Trial_Happening")) { ?>
						<form method="post" action="admin.php?page=EWD-UFAQ-Options">
							<input name="Key" type="hidden" value='EWD Trial'>
							<input name="EWD_UFAQ_Upgrade_To_Full" type="hidden" value='EWD_UFAQ_Upgrade_To_Full'>
							<button class="ewd-ufaq-dashboard-get-premium-widget-button ewd-ufaq-dashboard-new-trial-button">GET FREE 7-DAY TRIAL</button>
						</form>
					<?php } ?>
		</div>
			</div>
		<?php } ?>

		<div class="ewd-ufaq-dashboard-new-widget-box ewd-widget-box-full">
			<div class="ewd-ufaq-dashboard-new-widget-box-top">Other Plugins by Etoile</div>
			<div class="ewd-ufaq-dashboard-new-widget-box-bottom">
				<ul class="ewd-ufaq-dashboard-other-plugins">
					<li>
						<a href="https://wordpress.org/plugins/ultimate-product-catalogue/" target="_blank"><img src="<?php echo plugins_url( '../images/ewd-upcp-icon.png', __FILE__ ); ?>"></a>
						<div class="ewd-ufaq-dashboard-other-plugins-text">
							<div class="ewd-ufaq-dashboard-other-plugins-title">Product Catalog</div>
							<div class="ewd-ufaq-dashboard-other-plugins-blurb">Enables you to display your business's products in a clean and efficient manner.</div>
						</div>
					</li>
					<li>
						<a href="https://wordpress.org/plugins/ultimate-reviews/" target="_blank"><img src="<?php echo plugins_url( '../images/ewd-urp-icon.png', __FILE__ ); ?>"></a>
						<div class="ewd-ufaq-dashboard-other-plugins-text">
							<div class="ewd-ufaq-dashboard-other-plugins-title">Ultimate Reviews</div>
							<div class="ewd-ufaq-dashboard-other-plugins-blurb">Let visitors submit reviews and display them right in the tabbed page layout!</div>
						</div>
					</li>
				</ul>
			</div>
		</div>

	</div> <!-- right -->	

</div> <!-- ewd-ufaq-dashboard-content-area -->

<?php if ($UFAQ_Full_Version != "Yes" or get_option("EWD_UFAQ_Trial_Happening") == "Yes") { ?>
	<div id="ewd-ufaq-dashboard-new-footer-one">
		<div class="ewd-ufaq-dashboard-new-footer-one-inside">
			<div class="ewd-ufaq-dashboard-new-footer-one-left">
				<div class="ewd-ufaq-dashboard-new-footer-one-title">What's Included in Our Premium Version?</div>
				<ul class="ewd-ufaq-dashboard-new-footer-one-benefits">
					<li>Unlimited FAQs</li>
					<li>FAQ Search</li>
					<li>Custom Fields</li>
					<li>WooCommerce FAQs</li>
					<li>15 Different Icon Sets</li>
					<li>Import/Export FAQs</li>
					<li>Advanced Styling Options</li>
					<li>Social Sharing</li>
					<li>Email Support</li>
				</ul>
			</div>
			<div class="ewd-ufaq-dashboard-new-footer-one-buttons">
				<a class="ewd-ufaq-dashboard-new-upgrade-button" href="http://www.etoilewebdesign.com/plugins/ultimate-faq/#buy" target="_blank">UPGRADE NOW</a>
			</div>
		</div>
	</div> <!-- ewd-ufaq-dashboard-new-footer-one -->
<?php } ?>	
<div id="ewd-ufaq-dashboard-new-footer-two">
	<div class="ewd-ufaq-dashboard-new-footer-two-inside">
		<img src="<?php echo plugins_url( '../images/ewd-logo-white.png', __FILE__ ); ?>" class="ewd-ufaq-dashboard-new-footer-two-icon">
		<div class="ewd-ufaq-dashboard-new-footer-two-blurb">
			At Etoile Web Design, we build reliable, easy-to-use WordPress plugins with a modern look. Rich in features, highly customizable and responsive, plugins by Etoile Web Design can be used as out-of-the-box solutions and can also be adapted to your specific requirements.
		</div>
		<ul class="ewd-ufaq-dashboard-new-footer-two-menu">
			<li>SOCIAL</li>
			<li><a href="https://www.facebook.com/EtoileWebDesign/" target="_blank">Facebook</a></li>
			<li><a href="https://twitter.com/EtoileWebDesign" target="_blank">Twitter</a></li>
			<li><a href="https://www.etoilewebdesign.com/blog/" target="_blank">Blog</a></li>
		</ul>
		<ul class="ewd-ufaq-dashboard-new-footer-two-menu">
			<li>SUPPORT</li>
			<li><a href="https://www.youtube.com/playlist?list=PLEndQUuhlvSrNdfu5FKa1uGHsaKZxgdWt" target="_blank">YouTube Tutorials</a></li>
			<li><a href="https://wordpress.org/support/plugin/ultimate-faqs" target="_blank">Forums</a></li>
			<li><a href="http://www.etoilewebdesign.com/plugins/ultimate-faq/documentation-ultimate-faq/" target="_blank">Documentation</a></li>
			<li><a href="https://wordpress.org/plugins/ultimate-faqs/#faq" target="_blank">FAQs</a></li>
		</ul>
	</div>
</div> <!-- ewd-ufaq-dashboard-new-footer-two -->

<!-- END NEW DASHBOARD -->
