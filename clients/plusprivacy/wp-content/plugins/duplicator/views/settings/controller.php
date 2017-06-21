<?php

DUP_Util::CheckPermissions('manage_options');

global $wpdb;

//COMMON HEADER DISPLAY
require_once(DUPLICATOR_PLUGIN_PATH . '/assets/js/javascript.php');
require_once(DUPLICATOR_PLUGIN_PATH . '/views/inc.header.php');
$current_tab = isset($_REQUEST['tab']) ? esc_html($_REQUEST['tab']) : 'general';
?>

<style>

</style>

<div class="wrap">
	
    <?php duplicator_header(__("Settings", 'duplicator')) ?>	

    <?php
    switch ($current_tab) {
        case 'general': include('general.php');
            break;
    }
    ?>
</div>
