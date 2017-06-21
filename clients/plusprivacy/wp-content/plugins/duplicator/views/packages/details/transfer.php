<style>
	h3 {margin:10px 0 5px 0}
	div.transfer-panel {padding: 20px 5px 10px 10px;}
	div.transfer-hdr { border-bottom: 0px solid #dfdfdf; margin: -15px 0 0 0}
</style>

<div class="transfer-panel">
	<div class="transfer-hdr">
		<h2><i class="fa fa-arrow-circle-right"></i> <?php _e('Manual Transfer', 'duplicator'); ?></h2>
	</div>
	<br/>
	
	<div style="font-size:16px; text-align: center; line-height: 30px">
		<img src="<?php echo DUPLICATOR_PLUGIN_URL ?>assets/img/logo-dpro-300x50.png"  /> 
		<?php 		
			echo '<h2>' .  __('This option is available only in Duplicator Professional.', 'duplicator')  . '</h2>';
			_e('Manual transfer lets you copy a package to Amazon S3, Dropbox, Google Drive, FTP or another directory.', 'duplicator');
			echo '<br/>';
			_e('Simply choose your destination and hit the transfer button.', 'duplicator');
		?>
	</div>
	<p style="text-align:center">
		<a href="https://snapcreek.com/duplicator/?utm_source=duplicator_free&utm_medium=wordpress_plugin&utm_content=free_manual_transfer&utm_campaign=duplicator_pro" target="_blank" class="button button-primary button-large dup-check-it-btn" >
			<?php _e('Learn More', 'duplicator') ?>
		</a>
	</p>
</div>
