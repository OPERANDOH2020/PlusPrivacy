<?php
function EWD_UFAQ_Version_Update() {
	global $EWD_UFAQ_Version;

	$params = array(
		'post_type' => 'ufaq',
		'posts_per_page' => -1,
	);
	$FAQs = get_posts($params);

	if (is_array($FAQs)) {
		foreach ($FAQs as $FAQ) {
			$Current_Order = get_post_meta($FAQ->ID, "ufaq_order", true);
			if ($Current_Order == "") {
				update_post_meta($FAQ->ID, 'ufaq_order', 999);
			}
		}
	}

	if (is_array($FAQs)) {
		foreach ($FAQs as $FAQ) {
			$Current_Order = get_post_meta($FAQ->ID, "FAQ_Total_Score", true);
			if ($Current_Order == "") {
				update_post_meta($FAQ->ID, 'FAQ_Total_Score', 0);
			}
		}
	}

	if (get_option("EWD_UFAQ_FAQ_Elements") == "") {
		$FAQ_Elements = array();
		$FAQ_Elements[0] = "Author_Date";
		$FAQ_Elements[1] = "Body";
		$FAQ_Elements[2] = "Custom_Fields";
		$FAQ_Elements[3] = "Categories";
		$FAQ_Elements[4] = "Tags";
		$FAQ_Elements[5] = "Ratings";
		$FAQ_Elements[6] = "Social_Media";
		$FAQ_Elements[7] = "Permalink";
		$FAQ_Elements[8] = "Comments";
		$FAQ_Elements[9] = "Back_To_Top";

		update_option("EWD_UFAQ_FAQ_Elements", $FAQ_Elements);
	}

	if (get_option("EWD_UFAQ_Toggle") == "") {update_option("EWD_UFAQ_Toggle", "Yes");}
	if (get_option("EWD_UFAQ_Display_Back_To_Top") == "") {update_option("EWD_UFAQ_Display_Back_To_Top", "No");}
	if (get_option("EWD_UFAQ_Comments_On") == "") {update_option("EWD_UFAQ_Comments_On", "No");}
	if (get_option("EWD_UFAQ_Display_Style") == "") {update_option("EWD_UFAQ_Display_Style", "Default");}
	if (get_option("EWD_UFAQ_FAQ_Ratings") == "") {update_option("EWD_UFAQ_FAQ_Ratings", "No");}
	if (get_option("EWD_UFAQ_WooCommerce_FAQs") == "") {update_option("EWD_UFAQ_WooCommerce_FAQs", "No");}
	if (get_option("EWD_UFAQ_Use_Product") == "") {update_option("EWD_UFAQ_Use_Product", "Yes");}
	if (get_option("EWD_UFAQ_Color_Block_Shape") == "") {update_option("EWD_UFAQ_Color_Block_Shape", "Square");}
	if (get_option("FAQ_Auto_Complete_Titles") == "") {update_option("FAQ_Auto_Complete_Titles", "Yes");}
	if (get_option("EWD_UFAQ_Permalink_Type") == "") {update_option("EWD_UFAQ_Permalink_Type", "SamePage");}
	if (get_option("EWD_UFAQ_Slug_Base") == "") {update_option("EWD_UFAQ_Slug_Base", "ufaqs");}

	if (get_option("EWD_UFAQ_Hide_Blank_Fields") == "") {update_option("EWD_UFAQ_Hide_Blank_Fields", "Yes");}

	if (get_option("EWD_UFAQ_Styling_Category_Heading_Type") == "") {update_option("EWD_UFAQ_Styling_Category_Heading_Type", "h4");}
	if (get_option("EWD_UFAQ_Styling_FAQ_Heading_Type") == "") {update_option("EWD_UFAQ_Styling_FAQ_Heading_Type", "h4");}

	if (get_option("EWD_UFAQ_Install_Time") == "") {update_option("EWD_UFAQ_Install_Time", time() - 3600*24*4);}

	update_option('EWD_UFAQ_Version', $EWD_UFAQ_Version);
}

add_filter('upgrader_pre_install', 'EWD_UFAQ_SetUpdateOption');
function EWD_UFAQ_SetUpdateOption() {
	update_option('EWD_UFAQ_Update_Flag', "Yes");
}

if (isset($_GET['post_type']) and $_GET['post_type'] == 'ufaq' and get_option('EWD_UFAQ_Update_Flag') != "Yes") {add_action("admin_notices", "EWD_UFAQ_Version_Update_Box");}

function EWD_UFAQ_Version_Update_Box() { /*
?>
	<div id="side-sortables" class="metabox-holder ">
		<div id="EWD_UFAQ_pro" class="postbox " >
			<div class="handlediv" title="Click to toggle"></div>
			<h3 class='hndle'><span><?php _e("Thank You!", 'ultimate-faqs') ?></span></h3>
		 	<div class="inside">
				<?php  if (get_option("EWD_UFAQ_Install_Flag") == "Yes") { ?><ul><li><?php _e("Thanks for installing the Ultimate FAQs plugin.", 'ultimate-faqs'); ?><br> <a href='https://www.youtube.com/channel/UCZPuaoetCJB1vZOmpnMxJNw'><?php _e("Subscribe to our YouTube channel ", 'ultimate-faqs'); ?></a> <?php _e("for tutorial videos on this and our other plugins!", 'ultimate-faqs');?> </li></ul>
				<?php } else { ?><ul><li><?php _e("Thanks for upgrading to version 1.4.1!", 'ultimate-faqs'); ?><br> <a href='https://wordpress.org/support/view/plugin-reviews/ultimate-faqs?filter=5'><?php _e("Please rate our plugin", 'ultimate-faqs'); ?></a> <?php _e("if you find Ultimate FAQs useful!", 'ultimate-faqs');?> </li></ul><?php } ?>
											
				<?php /* if (get_option("EWD_UFAQ_Install_Flag") == "Yes") { ?><ul><li><?php _e("Thanks for installing the Ultimate Product Catalogue Plugin.", 'ultimate-faqs'); ?><br> <a href='http://www.facebook.com/EtoileWebDesign'><?php _e("Follow us on Facebook", 'ultimate-faqs'); ?></a> <?php _e("to suggest new features or hear about upcoming ones!", 'ultimate-faqs');?> </li></ul>
				<?php } else { ?><ul><li><?php _e("Thanks for upgrading to version 2.2.9!", 'ultimate-faqs'); ?><br> <a href='http://www.facebook.com/EtoileWebDesign'><?php _e("Follow us on Facebook", 'ultimate-faqs'); ?></a> <?php _e("to suggest new features or hear about upcoming ones!", 'ultimate-faqs');?> </li></ul><?php } */ ?>
											
				<?php /* if (get_option("EWD_UFAQ_Install_Flag") == "Yes") { ?><ul><li><?php _e("Thanks for installing the Ultimate Product Catalogue Plugin.", 'ultimate-faqs'); ?><br> <a href='http://www.facebook.com/EtoileWebDesign'><?php _e("Follow us on Facebook", 'ultimate-faqs'); ?></a> <?php _e("to suggest new features or hear about upcoming ones!", 'ultimate-faqs');?>  </li></ul>
				<?php } else { ?><ul><li><?php _e("Thanks for upgrading to version 3.0.16!", 'ultimate-faqs'); ?><br> <a href='http://wordpress.org/support/view/plugin-reviews/ultimate-product-catalogue'><?php _e("Please rate our plugin", 'ultimate-faqs'); ?></a> <?php _e("if you find the Ultimate Product Catalogue Plugin useful!", 'ultimate-faqs');?> </li></ul><?php } */ ?>
											
				<?php /* if (get_option("EWD_UFAQ_Install_Flag") == "Yes") { ?><ul><li><?php _e("Thanks for installing the Ultimate Product Catalogue Plugin.", 'ultimate-faqs'); ?><br> <a href='http://www.facebook.com/EtoileWebDesign'><?php _e("Follow us on Facebook", 'ultimate-faqs'); ?></a> <?php _e("to suggest new features or hear about upcoming ones!", 'ultimate-faqs');?>  </li></ul>
				<?php } else { ?><ul><li><?php _e("Thanks for upgrading to version 3.4.8!", 'ultimate-faqs'); ?><br> <a href='http://wordpress.org/plugins/order-tracking/'><?php _e("Try out order tracking plugin ", 'ultimate-faqs'); ?></a> <?php _e("if you ship orders and find the Ultimate Product Catalogue Plugin useful!", 'ultimate-faqs');?> </li></ul><?php } */ ?>

				<?php /* if (get_option("EWD_UFAQ_Install_Flag") == "Yes") { ?><ul><li><?php _e("Thanks for installing the Ultimate Product Catalogue Plugin.", 'ultimate-faqs'); ?><br> <a href='http://www.facebook.com/EtoileWebDesign'><?php _e("Follow us on Facebook", 'ultimate-faqs'); ?></a> <?php _e("to suggest new features or hear about upcoming ones!", 'ultimate-faqs');?>  </li></ul>
				<?php } else { ?><ul><li><?php _e("Thanks for upgrading to version 2.3.9!", 'ultimate-faqs'); ?><br> <a href='http://wordpress.org/support/topic/error-hunt'><?php _e("Please let us know about any small display/functionality errors. ", 'ultimate-faqs'); ?></a> <?php _e("We've noticed a couple, and would like to eliminate as many as possible.", 'ultimate-faqs');?> </li></ul><?php } */ ?>
											
				<?php /* if (get_option("EWD_UFAQ_Install_Flag") == "Yes") { ?><ul><li><?php _e("Thanks for installing the Ultimate Product Catalogue Plugin.", 'ultimate-faqs'); ?><br> <a href='https://www.youtube.com/channel/UCZPuaoetCJB1vZOmpnMxJNw'><?php _e("Check out our YouTube channel ", 'ultimate-faqs'); ?></a> <?php _e("for tutorial videos on this and our other plugins!", 'ultimate-faqs');?> </li></ul>
				<?php } elseif ($Full_Version == "Yes") { ?><ul><li><?php _e("Thanks for upgrading to version 3.5.0!", 'ultimate-faqs'); ?><br> <a href='http://www.facebook.com/EtoileWebDesign'><?php _e("Follow us on Facebook", 'ultimate-faqs'); ?></a> <?php _e("to suggest new features or hear about upcoming ones!", 'ultimate-faqs');?> </li></ul>
				<?php } else { ?><ul><li><?php _e("Thanks for upgrading to version 3.4!", 'ultimate-faqs'); ?><br> <?php _e("Love the plugin but don't need the premium version? Help us speed up product support and development by donating. Thanks for using the plugin!", 'ultimate-faqs');?>
						<form action="https://www.paypal.com/cgi-bin/webscr" method="post" target="_top">
						<input type="hidden" name="cmd" value="_s-xclick">
						<input type="hidden" name="hosted_button_id" value="AQLMJFJ62GEFJ">
						<input type="image" src="https://www.paypalobjects.com/en_US/i/btn/btn_donate_SM.gif" border="0" name="submit" alt="PayPal - The safer, easier way to pay online!">
						<img alt="" border="0" src="https://www.paypalobjects.com/en_US/i/scr/pixel.gif" width="1" height="1">
						</form>
						</li></ul>
				<?php }  ?>

			</div>
		</div>
	</div>

<?php 
update_option("EWD_UFAQ_Update_Flag", "No");
update_option("EWD_UFAQ_Install_Flag", "No"); */
}

?>