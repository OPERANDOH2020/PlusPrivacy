<?php 
		$Custom_CSS = get_option("EWD_UFAQ_Custom_CSS");
?>
<div class="wrap">

	<div class="ewd-ufaq-import-export-container">

		<div id="icon-options-general" class="icon32"><br /></div><h2>Import</h2>

		<?php if ($UFAQ_Full_Version != "Yes") { ?>
			<div class='ewd-ufaq-upgrade notice'>Upgrade to the premium version to use some of these features</div>
		<?php } ?>

		<h4>Import FAQs from Plugin</h4>
		<p>Import all of your FAQ posts and categories from the plugin "Q and A FAQ and Knowledge Base for WordPress"</p>
		<form method="post" action="admin.php?page=EWD-UFAQ-Options&DisplayPage=ImportPosts&Action=EWD_UFAQ_ImportFaqs">
		<table class="form-table">
		</table>


		<p class="submit"><input type="submit" name="Export_Submit" id="submit" class="button button-primary" value="Import Plugin FAQs"  /></p></form>

		<h4>Import FAQs from a spreadsheet</h4>
		<form method="post" action="admin.php?page=EWD-UFAQ-Options&DisplayPage=ImportPosts&Action=EWD_UFAQ_ImportFaqsFromSpreadsheet" enctype="multipart/form-data">
		<div class="form-field form-required">
				<label for="FAQs_Spreadsheet"><?php _e("Spreadsheet Containing FAQs", 'ultimate-faqs') ?></label><br />
				<input name="FAQs_Spreadsheet" id="FAQs_Spreadsheet" type="file" value=""/>
		</div>


		<p class="submit"><input type="submit" name="Export_Submit" id="submit" class="button button-primary" value="Import Spreadsheet FAQs"  <?php if ($UFAQ_Full_Version != "Yes") {echo "disabled";} ?>/></p></form>

	</div> <!--ewd-ufaq-import-export-container-->

</div> <!--wrap-->