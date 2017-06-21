<?php
global $wp_version;
global $wpdb;

$action_updated = null;
$action_response = __("Settings Saved", 'duplicator');

//SAVE RESULTS
if (isset($_POST['action']) && $_POST['action'] == 'save') {
	
	//Nonce Check
	if (! isset( $_POST['dup_settings_save_nonce_field'] ) || ! wp_verify_nonce( $_POST['dup_settings_save_nonce_field'], 'dup_settings_save' ) ) 
	{
		die('Invalid token permissions to perform this request.');
	}
	
    //General Tab
    //Plugin
    DUP_Settings::Set('uninstall_settings', isset($_POST['uninstall_settings']) ? "1" : "0");
    DUP_Settings::Set('uninstall_files', isset($_POST['uninstall_files']) ? "1" : "0");
    DUP_Settings::Set('uninstall_tables', isset($_POST['uninstall_tables']) ? "1" : "0");
    DUP_Settings::Set('storage_htaccess_off', isset($_POST['storage_htaccess_off']) ? "1" : "0");

    //Package
	$enable_mysqldump = isset($_POST['package_dbmode']) && $_POST['package_dbmode'] == 'mysql' ? "1" : "0";
    DUP_Settings::Set('package_debug', isset($_POST['package_debug']) ? "1" : "0");
    DUP_Settings::Set('package_zip_flush', isset($_POST['package_zip_flush']) ? "1" : "0");
	DUP_Settings::Set('package_mysqldump', $enable_mysqldump ? "1" : "0");
	DUP_Settings::Set('package_phpdump_qrylimit', isset($_POST['package_phpdump_qrylimit']) ? $_POST['package_phpdump_qrylimit'] : "100");
    DUP_Settings::Set('package_mysqldump_path', trim(esc_sql(strip_tags($_POST['package_mysqldump_path']))));

    //WPFront
    DUP_Settings::Set('wpfront_integrate', isset($_POST['wpfront_integrate']) ? "1" : "0");
    
    $action_updated = DUP_Settings::Save();
    DUP_Util::InitSnapshotDirectory();
}

$uninstall_settings = DUP_Settings::Get('uninstall_settings');
$uninstall_files = DUP_Settings::Get('uninstall_files');
$uninstall_tables = DUP_Settings::Get('uninstall_tables');
$storage_htaccess_off = DUP_Settings::Get('storage_htaccess_off');

$package_debug = DUP_Settings::Get('package_debug');
$package_zip_flush = DUP_Settings::Get('package_zip_flush');

$phpdump_chunkopts = array("20", "100", "500", "1000", "2000");

$package_phpdump_qrylimit = DUP_Settings::Get('package_phpdump_qrylimit');
$package_mysqldump = DUP_Settings::Get('package_mysqldump');
$package_mysqldump_path = trim(DUP_Settings::Get('package_mysqldump_path'));

$wpfront_integrate = DUP_Settings::Get('wpfront_integrate');
$wpfront_ready = apply_filters('wpfront_user_role_editor_duplicator_integration_ready', false);

$mysqlDumpPath = DUP_Database::GetMySqlDumpPath();
$mysqlDumpFound = ($mysqlDumpPath) ? true : false;


?>

<style>
    form#dup-settings-form input[type=text] {width: 400px; }
    input#package_mysqldump_path_found {margin-top:5px}
    div.dup-feature-found {padding:3px; border:1px solid silver; background: #f7fcfe; border-radius: 3px; width:400px; font-size: 12px}
    div.dup-feature-notfound {padding:3px; border:1px solid silver; background: #fcf3ef; border-radius: 3px; width:400px; font-size: 12px}
</style>

<form id="dup-settings-form" action="<?php echo admin_url('admin.php?page=duplicator-settings&tab=general'); ?>" method="post">

    <?php wp_nonce_field('dup_settings_save', 'dup_settings_save_nonce_field'); ?>
    <input type="hidden" name="action" value="save">
    <input type="hidden" name="page"   value="duplicator-settings">

    <?php if ($action_updated) : ?>
        <div id="message" class="updated below-h2"><p><?php echo $action_response; ?></p></div>
    <?php endif; ?>	


    <!-- ===============================
    PLUG-IN SETTINGS -->
    <h3 class="title"><?php _e("Plugin", 'duplicator') ?> </h3>
    <hr size="1" />
    <table class="form-table">
        <tr valign="top">
            <th scope="row"><label><?php _e("Version", 'duplicator'); ?></label></th>
            <td><?php echo DUPLICATOR_VERSION ?></td>
        </tr>	
        <tr valign="top">
            <th scope="row"><label><?php _e("Uninstall", 'duplicator'); ?></label></th>
            <td>
                <input type="checkbox" name="uninstall_settings" id="uninstall_settings" <?php echo ($uninstall_settings) ? 'checked="checked"' : ''; ?> /> 
                <label for="uninstall_settings"><?php _e("Delete Plugin Settings", 'duplicator') ?> </label><br/>

                <input type="checkbox" name="uninstall_files" id="uninstall_files" <?php echo ($uninstall_files) ? 'checked="checked"' : ''; ?> /> 
                <label for="uninstall_files"><?php _e("Delete Entire Storage Directory", 'duplicator') ?></label><br/>

            </td>
        </tr>
        <tr valign="top">
            <th scope="row"><label><?php _e("Storage", 'duplicator'); ?></label></th>
            <td>
                <?php _e("Full Path", 'duplicator'); ?>: 
                <?php echo DUP_Util::SafePath(DUPLICATOR_SSDIR_PATH); ?><br/><br/>
                <input type="checkbox" name="storage_htaccess_off" id="storage_htaccess_off" <?php echo ($storage_htaccess_off) ? 'checked="checked"' : ''; ?> /> 
                <label for="storage_htaccess_off"><?php _e("Disable .htaccess File In Storage Directory", 'duplicator') ?> </label>
                <p class="description">
                    <?php _e("Disable if issues occur when downloading installer/archive files.", 'duplicator'); ?>
                </p>
            </td>
        </tr>	
    </table>


    <!-- ===============================
    PACKAGE SETTINGS -->
    <h3 class="title"><?php _e("Package", 'duplicator') ?> </h3>
    <hr size="1" />
    <table class="form-table">
        <tr>
            <th scope="row"><label><?php _e("Archive Flush", 'duplicator'); ?></label></th>
            <td>
                <input type="checkbox" name="package_zip_flush" id="package_zip_flush" <?php echo ($package_zip_flush) ? 'checked="checked"' : ''; ?> />
                <label for="package_zip_flush"><?php _e("Attempt Network Keep Alive", 'duplicator'); ?></label>
                <i style="font-size:12px">(<?php _e("recommended only for large archives", 'duplicator'); ?>)</i> 
                <p class="description">
                    <?php _e("This will attempt to keep a network connection established for large archives.", 'duplicator'); ?>
                </p>
            </td>
        </tr>		
        <tr>
            <th scope="row"><label><?php _e("Database Build", 'duplicator'); ?></label></th>
            <td>
				<input type="radio" name="package_dbmode" id="package_phpdump" value="php" <?php echo (! $package_mysqldump) ? 'checked="checked"' : ''; ?> />
                <label for="package_phpdump"><?php _e("Use PHP", 'duplicator'); ?></label> &nbsp;
				
				<div style="margin:5px 0px 0px 25px">
					<label for="package_phpdump_qrylimit"><?php _e("Query Limit Size", 'duplicator'); ?></label> &nbsp;
					<select name="package_phpdump_qrylimit" id="package_phpdump_qrylimit">
						<?php 
							foreach($phpdump_chunkopts as $value) {
								$selected = ( $package_phpdump_qrylimit == $value ? "selected='selected'" : '' );
								echo "<option {$selected} value='{$value}'>" . number_format($value)  . '</option>';
							}
						?>
					</select>
					 <i style="font-size:12px">(<?php _e("higher values speed up build times but uses more memory", 'duplicator'); ?>)</i> 
					
				</div><br/>

                <?php if (!DUP_Util::IsShellExecAvailable()) : ?>
                    <p class="description">
                        <?php
                        _e("This server does not have shell_exec configured to run.", 'duplicator');
                        echo '<br/>';
                        _e("Please contact the server administrator to enable this feature.", 'duplicator');
                        ?>
                    </p>
                <?php else : ?>
                    <input type="radio" name="package_dbmode" value="mysql" id="package_mysqldump" <?php echo ($package_mysqldump) ? 'checked="checked"' : ''; ?> />
                    <label for="package_mysqldump"><?php _e("Use mysqldump", 'duplicator'); ?></label> &nbsp;
                    <i style="font-size:12px">(<?php _e("recommended for large databases", 'duplicator'); ?>)</i> <br/>
					
						<div style="padding:2px 0 0 40px">
							<small>
								<i style="cursor: pointer" 
									data-tooltip-title="<?php _e("Host Recommendation:", 'duplicator'); ?>" 
									data-tooltip="<?php _e('Duplicator recommends going with the high performance pro plan or better from Bluehost.com', 'duplicator'); ?>">
								<i class="fa fa-lightbulb-o" aria-hidden="true"></i>
									<?php
										printf("%s <a target='_blank' href='//www.bluehost.com/track/snapcreek/?page=wordpress'>%s</a> %s",
											__("Duplicator recommends ", 'duplicator'), 
											__("Bluehost", 'duplicator'),
											__("for reliable access to mysqldump", 'duplicator'));
									?>
								</i>
							</small>
						</div>
					<br/>

                    <div style="margin:5px 0px 0px 25px">
                        <?php if ($mysqlDumpFound) : ?>
                            <div class="dup-feature-found">
                                <?php _e("Working Path:", 'duplicator'); ?> &nbsp;
                                <i><?php echo $mysqlDumpPath ?></i>
                            </div><br/>
                        <?php else : ?>
                            <div class="dup-feature-notfound">
                                <?php
									_e('Mysqldump was not found at its default location or the location provided.  Please enter a path to a valid location where mysqldump can run.  If the problem persist contact your server administrator.', 'duplicator');
                                ?>
                            </div><br/>
                        <?php endif; ?>

                        <label><?php _e("Add Custom Path:", 'duplicator'); ?></label><br/>
                        <input type="text" name="package_mysqldump_path" id="package_mysqldump_path" value="<?php echo $package_mysqldump_path; ?> " />
                        <p class="description">
                            <?php
                            _e("This is the path to your mysqldump program.", 'duplicator');
                            ?>
                        </p>
                    </div>

                <?php endif; ?>
            </td>
        </tr>	
        <tr>
            <th scope="row"><label><?php _e("Package Debug", 'duplicator'); ?></label></th>
            <td>
                <input type="checkbox" name="package_debug" id="package_debug" <?php echo ($package_debug) ? 'checked="checked"' : ''; ?> />
                <label for="package_debug"><?php _e("Show Package Debug Status in Packages Screen", 'duplicator'); ?></label>
            </td>
        </tr>	

    </table>

    <!-- ===============================
    WPFRONT SETTINGS -->
    <h3 class="title"><?php _e("Roles & Capabilities", 'duplicator') ?> </h3>
    <hr size="1" />

    <table class="form-table">
        <tr>
            <th scope="row"><label><?php _e("Custom Roles", 'duplicator'); ?></label></th>
            <td>
                <input type="checkbox" name="wpfront_integrate" id="wpfront_integrate" <?php echo ($wpfront_integrate) ? 'checked="checked"' : ''; ?> <?php echo $wpfront_ready ? '' : 'disabled'; ?> />
                <label for="wpfront_integrate"><?php _e("Enable User Role Editor Plugin Integration", 'duplicator'); ?></label>
				
				<div style="margin:15px 0px 0px 25px">
					<p class="description">
						<?php printf('%s <a href="https://wordpress.org/plugins/wpfront-user-role-editor/" target="_blank">%s</a> %s'
									 . ' <a href="https://wpfront.com/user-role-editor-pro/?ref=3" target="_blank">%s</a> %s ' 
									 . ' <a href="https://wpfront.com/integrations/duplicator-integration/" target="_blank">%s</a>',
								__('The User Role Editor Plugin', 'duplicator'),
								__('Free', 'duplicator'),
								__('or', 'duplicator'),
								__('Professional', 'duplicator'),
								__('must be installed to use', 'duplicator'),
								__('this feature.', 'duplicator')
								); 
						?> 
					</p>
				</div>
            </td>
        </tr>	

    </table><br/>

    <p class="submit" style="margin: 20px 0px 0xp 5px;">
		<br/>
		<input type="submit" name="submit" id="submit" class="button-primary" value="<?php _e("Save Settings", 'duplicator') ?>" style="display: inline-block;" />
	</p>
	
</form>