<?php 
		$Custom_CSS = get_option("EWD_UFAQ_Custom_CSS");
?>
<div class="wrap">

	<div class="ewd-ufaq-import-export-container">

		<div id="icon-options-general" class="icon32"><br /></div><h2>Export</h2>

		<?php if ($UFAQ_Full_Version != "Yes") { ?>
			<div class='ewd-ufaq-upgrade notice'>Upgrade to the premium version to use these features</div>
		<?php } ?>

		<form method="post" action="admin.php?page=EWD-UFAQ-Options&DisplayPage=Export&Action=EWD_UFAQ_ExportToPDF">
		<table class="form-table">
		</table>


		<p class="submit"><input type="submit" name="Export_Submit" id="submit" class="button button-primary" value="Export to PDF" <?php if ($UFAQ_Full_Version != "Yes") {echo "disabled";} ?> /></p></form>

		<form method="post" action="admin.php?page=EWD-UFAQ-Options&DisplayPage=Export&Action=EWD_UFAQ_ExportToSpreadsheet">
		<table class="form-table">
		</table>


		<p class="submit"><input type="submit" name="Export_Submit" id="submit" class="button button-primary" value="Export to Spreadsheet" <?php if ($UFAQ_Full_Version != "Yes") {echo "disabled";} ?> /></p></form>

	</div> <!--ewd-ufaq-import-export-container-->

</div>