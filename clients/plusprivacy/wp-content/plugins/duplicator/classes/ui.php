<?php
if ( ! defined('DUPLICATOR_VERSION') ) exit; // Exit if accessed directly

/**
 * Helper Class for UI internactions
 * @package Dupicator\classes
 */
class DUP_UI {
	
	/**
	 * The key used in the wp_options table
	 * @var string 
	 */
	private static $OptionsTableKey = 'duplicator_ui_view_state';
	
	/** 
     * Save the view state of UI elements
	 * @param string $key A unique key to define the ui element
	 * @param string $value A generic value to use for the view state
     */
	public static function SaveViewState($key, $value) {
	   
		$view_state = array();
		$view_state = get_option(self::$OptionsTableKey);
		$view_state[$key] =  $value;
		$success = update_option(self::$OptionsTableKey, $view_state);
		
		return $success;
    }
	
	
    /** 
     * Saves the state of a UI element via post params
	 * @return json result string
	 * <code>
	 * //JavaScript Ajax Request
	 * Duplicator.UI.SaveViewStateByPost('dup-pack-archive-panel', 1);
	 * 
	 * //Call PHP Code
	 * $view_state       = DUP_UI::GetViewStateValue('dup-pack-archive-panel');
	 * $ui_css_archive   = ($view_state == 1)   ? 'display:block' : 'display:none';
	 * </code>
     */
    public static function SaveViewStateByPost() {
		
		DUP_Util::CheckPermissions('read');
		
		$post  = stripslashes_deep($_POST);
		$key   = esc_html($post['key']);
		$value = esc_html($post['value']);
		$success = self::SaveViewState($key, $value);
		
		//Show Results as JSON
		$json = array();
		$json['key']    = $key;
		$json['value']  = $value;
		$json['update-success'] = $success;
		die(json_encode($json));
    }
	
	
	/** 
     *	Gets all the values from the settings array
	 *  @return array Returns and array of all the values stored in the settings array
     */
    public static function GetViewStateArray() {
		return get_option(self::$OptionsTableKey);
	}
	
	 /** 
	  * Return the value of the of view state item
	  * @param type $searchKey The key to search on
	  * @return string Returns the value of the key searched or null if key is not found
	  */
    public static function GetViewStateValue($searchKey) {
		$view_state = get_option(self::$OptionsTableKey);
		if (is_array($view_state)) {
			foreach ($view_state as $key => $value) {
				if ($key == $searchKey) {
					return $value;	
				}
			}
		} 
		return null;
	}
	
	/**
	 * Shows a display message in the wp-admin if any researved files are found
	 * @return type void
	 */
	public static function ShowReservedFilesNotice() 
	{
		//Show only on Duplicator pages and Dashboard when plugin is active
		$dup_active = is_plugin_active('duplicator/duplicator.php');
		$dup_perm   = current_user_can( 'manage_options' );
		if (! $dup_active || ! $dup_perm) 
			return;

		if (DUP_Server::InstallerFilesFound()) 
		{
			$screen = get_current_screen();
			$on_active_tab =  isset($_GET['tab']) && $_GET['tab'] == 'cleanup' ? true : false;
			
			echo '<div class="error" id="dup-global-error-reserved-files"><p>';
			if ($screen->id == 'duplicator_page_duplicator-tools' && $on_active_tab) 
			{
				_e('Reserved Duplicator install files have been detected in the root directory.  Please delete these reserved files to avoid security issues.', 'duplicator');
			}
			else 
			{
				$duplicator_nonce = wp_create_nonce('duplicator_cleanup_page');
				_e('Reserved Duplicator install files have been detected in the root directory.  Please delete these reserved files to avoid security issues.', 'duplicator');
				@printf("<br/><a href='admin.php?page=duplicator-tools&tab=cleanup&_wpnonce=%s'>%s</a>", $duplicator_nonce, __('Take me to the cleanup page!', 'duplicator'));
			}			
			echo "</p></div>";
		} 
	}
	
}
?>
