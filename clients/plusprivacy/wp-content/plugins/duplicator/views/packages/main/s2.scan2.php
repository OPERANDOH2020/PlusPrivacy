<!-- ================================================================
SERVER  -->
<div class="details-title">
	<i class="fa fa-hdd-o"></i> <?php _e("Server", 'duplicator');	?>
	<div class="dup-more-details" title="<?php _e('Show Diagnostics', 'duplicator');?>">
		<a href="?page=duplicator-tools&tab=diagnostics" target="_blank"><i class="fa fa-microchip"></i></a>
	</div>
</div>

<!-- ============
PHP SETTINGS -->
<div class="scan-item">
	<div class='title' onclick="Duplicator.Pack.toggleScanItem(this);">
		<div class="text"><i class="fa fa-caret-right"></i> <?php _e('Setup', 'duplicator');?></div>
		<div id="data-srv-php-all"></div>
	</div>
	<div class="info">
	<?php
		//WEB SERVER
		$web_servers = implode(', ', $GLOBALS['DUPLICATOR_SERVER_LIST']);
		echo '<span id="data-srv-php-websrv"></span>&nbsp;<b>' . __('Web Server', 'duplicator') . ":</b>&nbsp; '{$_SERVER['SERVER_SOFTWARE']}' <br/>";
		_e("Supported web servers: ", 'duplicator');
		echo "<i>{$web_servers}</i>";

		//PHP VERSION
		echo '<hr size="1" /><span id="data-srv-php-version"></span>&nbsp;<b>' . __('PHP Version', 'duplicator') . "</b> <br/>";
		_e('The minimum PHP version supported by Duplicator is 5.2.9. It is highly recommended to use PHP 5.3+ for improved stability.  For international language support please use PHP 7.0+.', 'duplicator');
		
		//OPEN_BASEDIR
		$test = ini_get("open_basedir");
		$test = ($test) ? 'ON' : 'OFF';
		echo '<hr size="1" /><span id="data-srv-php-openbase"></span>&nbsp;<b>' . __('PHP Open Base Dir', 'duplicator') . ":</b>&nbsp; '{$test}' <br/>";
		_e('Issues might occur when [open_basedir] is enabled. Work with your server admin to disable this value in the php.ini file if you’re having issues building a package.', 'duplicator');
		echo "&nbsp;<i><a href='http://www.php.net/manual/en/ini.core.php#ini.open-basedir' target='_blank'>[" . __('details', 'duplicator') . "]</a></i><br/>";

		//MAX_EXECUTION_TIME
		$test = (@set_time_limit(0)) ? 0 : ini_get("max_execution_time");
		echo '<hr size="1" /><span id="data-srv-php-maxtime"></span>&nbsp;<b>' . __('PHP Max Execution Time', 'duplicator') . ":</b>&nbsp; '{$test}' <br/>";
		_e('Timeouts may occur for larger packages when [max_execution_time] time in the php.ini is too low.  A value of 0 (recommended) indicates that PHP has no time limits. '
			. 'An attempt is made to override this value if the server allows it.', 'duplicator');
		echo '<br/><br/>';
		_e('Note: Timeouts can also be set at the web server layer, so if the PHP max timeout passes and you still see a build timeout messages, then your web server could be killing '
			. 'the process.   If you are on a budget host and limited on processing time, consider using the database or file filters to shrink the size of your overall package.   '
			. 'However use caution as excluding the wrong resources can cause your install to not work properly.', 'duplicator');
		echo "&nbsp;<i><a href='http://www.php.net/manual/en/info.configuration.php#ini.max-execution-time' target='_blank'>[" . __('details', 'duplicator')  . "]</a></i>";

		if ($zip_check != null) {
			echo '<br/><br/>';
			echo '<span style="font-weight:bold">';
			_e('Get faster builds with Duplicator Pro with access to shell_exec zip.', 'duplicator');
			echo '</span>';
			echo "&nbsp;<i><a href='https://snapcreek.com/duplicator/?utm_source=duplicator_free&utm_medium=wordpress_plugin&utm_content=free_max_execution_time_warn&utm_campaign=duplicator_pro' target='_blank'>[" . __('details', 'duplicator') . "]</a></i>";
		}
	?>
	</div>
</div>

<!-- ============
WP SETTINGS -->
<div class="scan-item scan-item-last">
	<div class="title" onclick="Duplicator.Pack.toggleScanItem(this);">
		<div class="text"><i class="fa fa-caret-right"></i> <?php _e('WordPress', 'duplicator');?></div>
		<div id="data-srv-wp-all"></div>
	</div>
	<div class="info">
		<?php
		//VERSION CHECK
		echo '<span id="data-srv-wp-version"></span>&nbsp;<b>' . __('WordPress Version', 'duplicator') . ":</b>&nbsp; '{$wp_version}' <br/>";
		printf(__('It is recommended to have a version of WordPress that is greater than %1$s.  Older version of WordPress can lead to migration issues and are a security risk. '
			. 'If possible please update your WordPress site to the latest version.', 'duplicator'), DUPLICATOR_SCAN_MIN_WP);

		//CORE FILES
		echo '<hr size="1" /><span id="data-srv-wp-core"></span>&nbsp;<b>' . __('Core Files', 'duplicator') . "</b> <br/>";
		_e("If the scanner is unable to locate the wp-config.php file in the root directory, then you will need to manually copy it to its new location.", 'duplicator');

		//CACHE DIR
		$cache_path = $cache_path = DUP_Util::safePath(WP_CONTENT_DIR) . '/cache';
		$cache_size = DUP_Util::byteSize(DUP_Util::getDirectorySize($cache_path));
		echo '<hr size="1" /><span id="data-srv-wp-cache"></span>&nbsp;<b>' . __('Cache Path', 'duplicator') . ":</b>&nbsp; '{$cache_path}' ({$cache_size}) <br/>";
		_e("Cached data will lead to issues at install time and increases your archive size. Empty your cache directory before building the package by using  "
			. "your cache plugins clear cache feature.  Use caution if manually removing files the cache folder. The cache "
			. "size minimum threshold that triggers this warning is currently set at ", 'duplicator');
		echo DUP_Util::byteSize(DUPLICATOR_SCAN_CACHESIZE) . '.';

		//MU SITE
		if (is_multisite()) {
			echo '<hr size="1" /><span><div class="scan-warn"><i class="fa fa-exclamation-triangle"></i></div></span>&nbsp;<b>' . __('Multisite: Unsupported', 'duplicator') . "</b> <br/>";
			_e('Duplicator does not officially support Multisite. However, Duplicator Pro supports duplication of a full Multisite network and also has the ability to install a Multisite subsite as a standalone site.', 'duplicator');
			echo "&nbsp;<i><a href='https://snapcreek.com/duplicator/?utm_source=duplicator_free&utm_medium=wordpress_plugin&utm_content=free_is_mu_warn&utm_campaign=duplicator_pro' target='_blank'>[" . __('details', 'duplicator') . "]</a></i>";
		} else {
			echo '<hr size="1" /><span><div class="scan-good"><i class="fa fa-check"></i></div></span>&nbsp;<b>' . __('Multisite: N/A', 'duplicator') . "</b> <br/>";
			_e('This is not a Multisite install so duplication will proceed without issue.  Duplicator does not officially support Multisite. However, Duplicator Pro supports duplication of a full Multisite network and also has the ability to install a Multisite subsite as a standalone site.', 'duplicator');
			echo "&nbsp;<i><a href='https://snapcreek.com/duplicator/?utm_source=duplicator_free&utm_medium=wordpress_plugin&utm_content=free_is_mu_warn&utm_campaign=duplicator_pro' target='_blank'>[" . __('details', 'duplicator') . "]</a></i>";
		}
		?>
	</div>
</div>

<script>
(function($){

	//Ints the various server data responses from the scan results
	Duplicator.Pack.intServerData= function(data)
	{
		$('#data-srv-php-websrv').html(Duplicator.Pack.setScanStatus(data.SRV.PHP.websrv));
		$('#data-srv-php-openbase').html(Duplicator.Pack.setScanStatus(data.SRV.PHP.openbase));
		$('#data-srv-php-maxtime').html(Duplicator.Pack.setScanStatus(data.SRV.PHP.maxtime));
		$('#data-srv-php-version').html(Duplicator.Pack.setScanStatus(data.SRV.PHP.version));
		$('#data-srv-php-openssl').html(Duplicator.Pack.setScanStatus(data.SRV.PHP.openssl));
		$('#data-srv-php-all').html(Duplicator.Pack.setScanStatus(data.SRV.PHP.ALL));

		$('#data-srv-wp-version').html(Duplicator.Pack.setScanStatus(data.SRV.WP.version));
		$('#data-srv-wp-core').html(Duplicator.Pack.setScanStatus(data.SRV.WP.core));
		$('#data-srv-wp-cache').html(Duplicator.Pack.setScanStatus(data.SRV.WP.cache));
		$('#data-srv-wp-all').html(Duplicator.Pack.setScanStatus(data.SRV.WP.ALL));
	}
	
})(jQuery);
</script>