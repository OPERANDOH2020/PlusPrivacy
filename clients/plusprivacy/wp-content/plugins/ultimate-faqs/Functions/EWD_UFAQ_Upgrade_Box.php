<?php

function EWD_UFAQ_Upgrade_Box() {
?>
	<div id="side-sortables" class="metabox-holder ">
	<div id="upcp_pro" class="postbox " >
		<div class="handlediv" title="Click to toggle"></div><h3 class='hndle'><span><?php _e("Full Version", 'ultimate-faqs') ?></span></h3>
		<div class="inside">
			<ul><li><a href="http://www.etoilewebdesign.com/plugins/ultimate-faq/"><?php _e("Upgrade to the full version ", 'ultimate-faqs'); ?></a><?php _e("to take advantage of all the available features of the Ultimate FAQs for Wordpress!", 'ultimate-faqs'); ?></li></ul>
			<h3 class='hndle'><span><?php _e("What you get by upgrading:", 'EWD_URP') ?></span></h3>
				<ul>
					<li>Ability to add a unique FAQ tab to each WooCommerce product page.</li>
					<li>Premium shortcodes to accept questions from users and insert an AJAX FAQ search.</li>
					<li>Additional FAQ style skins, dozens of styling and labeling options and much more!</li>
					<li>Access to e-mail support.</li>
				</ul>
			<div class="full-version-form-div">
				<form action="edit.php?post_type=ufaq" method="post">
					<div class="form-field form-required">
						<label for="Key"><?php _e("Product Key", 'ultimate-faqs') ?></label>
						<input name="Key" type="text" value="" size="40" />
					</div>							
					<input type="submit" name="Upgrade_To_Full" value="<?php _e('Upgrade', 'ultimate-faqs') ?>">
				</form>
			</div>
		</div>
	</div>
	</div>

<?php
}

function EWD_UFAQ_Upgrade_Notice() {
?>
	<div id="side-sortables" class="metabox-holder ">
	<div id="upcp_pro" class="postbox " >
		<div class="handlediv" title="Click to toggle"></div><h3 class='hndle'><span><?php _e("Upgrade Complete!", 'ultimate-faqs') ?></span></h3>
		<div class="inside">
			<ul><li><?php _E("Thanks for upgrading!", 'ultimate-faqs'); ?></li></ul>
		</div>
	</div>
	</div>

<?php
}
?>