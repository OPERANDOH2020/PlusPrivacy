<?php     namespace ng_venobox;

/*
Plugin Name: VenoBox Lightbox
Plugin URI: http://wpbeaches.com/
Description: VenoBox Lightbox - responsive lightbox for video, iframe and images
Author: Neil Gee
Version: 1.4.1
Author URI: http://wpbeaches.com
License: GPL-2.0+
License URI: http://www.gnu.org/licenses/gpl-2.0.txt
Text Domain: venobox-lightbox
Domain Path: /languages/
*/


  // If called direct, refuse
  if ( ! defined( 'ABSPATH' ) ) {
          die;
  }


/**
 * Register our text domain.
 *
 * @since 1.0.0
 */
function load_textdomain() {
  load_plugin_textdomain( 'venobox-lightbox', false, basename( dirname( __FILE__ ) ) . '/languages' );
}
add_action( 'plugins_loaded', __NAMESPACE__ . '\\load_textdomain' );

/**
 * Register and Enqueue Scripts and Styles
 *
 * @since 1.0.0
 *
 * Conditionally load scripts only if metabox _venobox_check is unchecked
 * @since 1.6.1
 */

//Script-tac-ulous -> All the Scripts and Styles Registered and Enqueued
function scripts_styles() {

$options = get_option( 'venobox_settings' );

/* Get the current post ID. */
$post_id = get_the_ID();
$is_venobox_checked = get_post_meta( $post_id, '_venobox_check', true );

if ( !$is_venobox_checked ) {
  // wp_register_script( 'venobox-js' , plugins_url( '/js/venobox.js',  __FILE__ ), array( 'jquery' ), '1.8.2', false );
  wp_register_script( 'venobox-js' , plugins_url( '/js/venobox.min.js',  __FILE__ ), array( 'jquery' ), '1.8.2', false );
  // wp_register_style( 'venobox-css' , plugins_url( '/css/venobox.css',  __FILE__ ), '' , '1.8.2', 'all' );
  wp_register_style( 'venobox-css' , plugins_url( '/css/venobox.min.css',  __FILE__ ), '' , '1.8.2', 'all' );
  wp_register_script( 'venobox-init' , plugins_url( '/js/venobox-init.js',  __FILE__ ), array( 'venobox-js' ), '1.4.1', false );
  wp_register_script( 'legacy-js' , plugins_url( '/js/venobox-legacy.js',  __FILE__ ), array( 'jquery' ), '1.4.1', true );

  }

// Add new plugin options defaults here, set them to blank, this will avoid PHP notices of undefined, if new options are introduced to the plugin and are not saved or udated then the setting will be defined.
$options_default = array(

    'ng_numeratio'          => '',
    'ng_numeratio_position' => 'top',
    'ng_infinigall'         => '',
    'ng_all_images'         => '',
    'ng_all_lightbox'       => '',
    'ng_title_select'       => 1,
    'ng_title_position'     => 'top',
    //'ng_border_width'     => 0,
   // 'ng_border_color'     => '',
    'ng_all_videos'         => '',
    'ng_autoplay'           => false,
    'ng_preloader'          => 'double-bounce',
    'ng_nav_elements'       => '#fff',
    'ng_vb_legacy_markup'       => '',

);
$options = wp_parse_args( $options, $options_default );


  wp_enqueue_script( 'venobox-js' );
  wp_enqueue_style( 'venobox-css' );
  /* Only enque leagcy data attributes mark up change if checked */
  if( $options['ng_vb_legacy_markup'] == true ) {
          wp_enqueue_script( 'legacy-js');
  }

     // Creating our jQuery variables here from our database options, these will be passed to jQuery init script via wp_localize_script
     $data = array (

      'ng_venobox' => array(
        'ng_numeratio'          => (bool)$options['ng_numeratio'],
        'ng_numeratio_position' => $options['ng_numeratio_position'],
        'ng_infinigall'         => (bool)$options['ng_infinigall'],
        'ng_all_images'         => (bool)$options['ng_all_images'],
        'ng_all_lightbox'       => (bool)$options['ng_all_lightbox'],
        'ng_title_select'       => (int)$options['ng_title_select'],
        'ng_title_position'     => $options['ng_title_position'],
       // 'ng_border_width'     => (int)$options['ng_border_width'],
       // 'ng_border_color'     => $options['ng_border_color'],
        'ng_all_videos'         => (bool)$options['ng_all_videos'],
        'ng_autoplay'           => (bool)$options['ng_autoplay'],
        'ng_overlay'            => $options['ng_overlay'],
        'ng_nav_elements'       => $options['ng_nav_elements'],
        'ng_preloader'          => $options['ng_preloader'],
        'ng_vb_legacy_markup'   => (bool)$options['ng_vb_legacy_markup'],

      ),
  );

     // Add filter
    $data = apply_filters( 'ng_venoboxVars', $data );

    // Pass PHP variables to jQuery script
    wp_localize_script( 'venobox-init', 'venoboxVars', $data );
    // Access jQuery variable using venoboxVars.ng_venobox

    wp_enqueue_script( 'venobox-init' );

}

add_action( 'wp_enqueue_scripts', __NAMESPACE__ . '\\scripts_styles' );

/**
 * Add scripts in back-end for demo purpose.
 *
 * @since 1.0.0
 */
function admin_venobox($hook) {
    if ( 'settings_page_venobox' != $hook ) {
        return;
    }

    wp_enqueue_script( 'venobox-js' , plugins_url( '/js/venobox.min.js',  __FILE__ ), array( 'jquery' ), '1.8.2', false );
    // wp_enqueue_script( 'venobox-js' , plugins_url( '/js/venobox.js',  __FILE__ ), array( 'jquery' ), '1.8.2', false );
    // wp_enqueue_style( 'venobox-css' , plugins_url( '/css/venobox.css',  __FILE__ ), '' , '1.8.2', 'all' );
    wp_enqueue_style( 'venobox-css' , plugins_url( '/css/venobox.min.css',  __FILE__ ), '' , '1.8.2', 'all' );
    wp_enqueue_script( 'venobox-init-admin' , plugins_url( '/js/venobox-init-admin.js',  __FILE__ ), array( 'venobox-js' ), '1.8.2', false );
    wp_enqueue_style( 'wp-color-picker' );
    wp_enqueue_script( 'wp-color-picker-alpha', plugins_url( '/js/wp-color-picker-alpha.min.js',  __FILE__ ), array( 'wp-color-picker' ), '1.3.0', true );
}
add_action( 'admin_enqueue_scripts',  __NAMESPACE__ . '\\admin_venobox' );

/**
 * Create the plugin option page.
 *
 * @since 1.0.0
 */

function plugin_page() {

    /*
     * Use the add options_page function
     * add_options_page( $page_title, $menu_title, $capability, $menu-slug, $function )
     */

     add_options_page(
        __( 'VenoBox Lightbox Plugin','venobox-lightbox' ), //$page_title
        __( 'VenoBox Lightbox', 'venobox-lightbox' ), //$menu_title
        'manage_options', //$capability
        'venobox', //$menu-slug
        __NAMESPACE__ . '\\plugin_options_page' //$function
      );
}
add_action( 'admin_menu', __NAMESPACE__ . '\\plugin_page' );

/**
 * Include the plugin option page.
 *
 * @since 1.0.0
 */

function plugin_options_page() {

    if( !current_user_can( 'manage_options' ) ) {

      wp_die( "Hall and Oates 'Say No Go'" );
    }

   require( 'inc/options-page-wrapper.php' );
}

/**
 * Register our option fields
 *
 * @since 1.0.0
 */
// Check validation
function plugin_settings() {
  register_setting(
        'ng_settings_group', //option name
        'venobox_settings'// option group setting name and option name
     //  __NAMESPACE__ . '\\venobox_validate_input' //sanitize the inputs
  );

  add_settings_section(
        'ng_venobox_section', //declare the section id
        'VenoBox Settings', //page title
         __NAMESPACE__ . '\\ng_venobox_section_callback', //callback function below
        'venobox' //page that it appears on
  );

  add_settings_field(
        'ng_all_images', //unique id of field
        'Add All Linked Images To LightBox', //title
         __NAMESPACE__ . '\\ng_all_images_callback', //callback function below
        'venobox', //page that it appears on
        'ng_venobox_section' //settings section declared in add_settings_section
  );

  add_settings_field(
        'ng_all_lightbox', //unique id of field
        'Display Previous/Next Icons', //title
         __NAMESPACE__ . '\\ng_all_lightbox_callback', //callback function below
        'venobox', //page that it appears on
        'ng_venobox_section' //settings section declared in add_settings_section
  );

  add_settings_field(
        'ng_title_select', //unique id of field
        'Choose which Title text to use in LightBox', //title
         __NAMESPACE__ . '\\ng_title_select_callback', //callback function below
        'venobox', //page that it appears on
        'ng_venobox_section' //settings section declared in add_settings_section
  );

  add_settings_field(
        'ng_title_position', //unique id of field
        'Position the title - Top or Bottom', //title
         __NAMESPACE__ . '\\ng_title_position_callback', //callback function below
        'venobox', //page that it appears on
        'ng_venobox_section' //settings section declared in add_settings_section
  );

  add_settings_field(
        'ng_numeratio', //unique id of field
        'Display Pagination', //title
         __NAMESPACE__ . '\\ng_numeratio_callback', //callback function below
        'venobox', //page that it appears on
        'ng_venobox_section' //settings section declared in add_settings_section
  );

  add_settings_field(
        'ng_numeratio_position', //unique id of field
        'Position Pagination on Top or Bottom', //title
         __NAMESPACE__ . '\\ng_numeratio_position_callback', //callback function below
        'venobox', //page that it appears on
        'ng_venobox_section' //settings section declared in add_settings_section
  );

  add_settings_field(
        'ng_infinigall', //unique id of field
        'Infinite Gallery', //title
         __NAMESPACE__ . '\\ng_infinigall_callback', //callback function below
        'venobox', //page that it appears on
        'ng_venobox_section' //settings section declared in add_settings_section
  );

  add_settings_field(
      'ng_overlay', //unique id of field
      'Default Overlay Background', //title
       __NAMESPACE__ . '\\ng_overlay_callback', //callback function below
      'venobox', //page that it appears on
      'ng_venobox_section' //settings section declared in add_settings_section
  );

  add_settings_field(
      'ng_nav_elements', //unique id of field
      'Default Navigation & Title Color', //title
       __NAMESPACE__ . '\\ng_nav_elements_callback', //callback function below
      'venobox', //page that it appears on
      'ng_venobox_section' //settings section declared in add_settings_section
  );

  add_settings_field(
      'ng_inline_background', //unique id of field
      'Default Inline Background Color', //title
       __NAMESPACE__ . '\\ng_inline_background_callback', //callback function below
      'venobox', //page that it appears on
      'ng_venobox_section' //settings section declared in add_settings_section
  );

  add_settings_field(
      'ng_border_width', //unique id of field
      'Frame Border Width - Images', //title
       __NAMESPACE__ . '\\ng_border_width_callback', //callback function below
      'venobox', //page that it appears on
      'ng_venobox_section' //settings section declared in add_settings_section
  );

  add_settings_field(
      'ng_border_color', //unique id of field
      'Frame Border Color - Images', //title
       __NAMESPACE__ . '\\ng_border_color_callback', //callback function below
      'venobox', //page that it appears on
      'ng_venobox_section' //settings section declared in add_settings_section
  );

  add_settings_field(
        'ng_all_videos', //unique id of field
        'Add YouTube and Vimeo videos To LightBox', //title
         __NAMESPACE__ . '\\ng_all_videos_callback', //callback function below
        'venobox', //page that it appears on
        'ng_venobox_section' //settings section declared in add_settings_section
  );

  add_settings_field(
         'ng_autoplay', //unique id of field
         'Autoplay videos', //title
          __NAMESPACE__ . '\\ng_autoplay_callback', //callback function below
         'venobox', //page that it appears on
         'ng_venobox_section' //settings section declared in add_settings_section
  );

  add_settings_field(
         'ng_preloader', //unique id of field
         'Preloader Icon', //title
          __NAMESPACE__ . '\\ng_preloader_callback', //callback function below
         'venobox', //page that it appears on
         'ng_venobox_section' //settings section declared in add_settings_section
  );

  add_settings_field(
        'ng_vb_legacy_markup', //unique id of field
        'Update Legacy Attributes', //title
        __NAMESPACE__ . '\\ng_vb_legacy_markup_callback', //callback function below
        'venobox', //page that it appears on
        'ng_venobox_section' //settings section declared in add_settings_section
);

}





add_action('admin_init', __NAMESPACE__ . '\\plugin_settings');

/**
 * Register our section call back
 * (not much happening here)
 * @since 1.0.0
 */

function ng_venobox_section_callback() {

}

/**
 *  Add Lightbox for all images and galleries
 *
 * @since 1.1.0
 */

function ng_all_images_callback() {
$options = get_option( 'venobox_settings' );

if( !isset( $options['ng_all_images'] ) ) $options['ng_all_images'] = '';

?>
  <fieldset>
  	<label for="ng_all_images">
  		<input name="venobox_settings[ng_all_images]" type="checkbox" id="ng_all_images" value="1"<?php checked( 1, $options['ng_all_images'], true ); ?> />
  		<span><?php esc_attr_e( 'Add Lightbox for all linked images & galleries', 'venobox-lightbox' ); ?></span>
  	</label>
  </fieldset>
<?php
}


/**
 *  Add Lightbox for all videos
 *
 * @since 1.3.5
 */

function ng_all_videos_callback() {
$options = get_option( 'venobox_settings' );

if( !isset( $options['ng_all_videos'] ) ) $options['ng_all_videos'] = '';

?>
  <fieldset>
  	<label for="ng_all_videos">
  		<input name="venobox_settings[ng_all_videos]" type="checkbox" id="ng_all_videos" value="1"<?php checked( 1, $options['ng_all_videos'], true ); ?> />
  		<span><?php esc_attr_e( 'Add Lightbox for all YouTube and Vimeo videos', 'venobox-lightbox' ); ?></span>
  	</label>
  </fieldset>
<?php
}

/**
 * Add Option to autoplay videos
 * Credit @codibit - @link https://github.com/codibit
 * @link https://github.com/neilgee/venobox/pull/1/commits/52319bbd7612752428ca5766fb359d14e0439b28
 *
 * @since 1.4.0
 */

function ng_autoplay_callback() {
 $options = get_option( 'venobox_settings' );

if( !isset( $options['ng_autoplay'] ) ) $options['ng_autoplay'] = '';

?>
   <fieldset>
     <label for="ng_autoplay">
       <input name="venobox_settings[ng_autoplay]" type="checkbox" id="ng_autoplay" value="1"<?php checked( 1, $options['ng_autoplay'], true ); ?> />
       <span><?php esc_attr_e( 'Autoplay all videos', 'venobox-lightbox' ); ?></span>
     </label>
    </fieldset>
 <?php
}

/**
 *  Add Previous & Next icons in Lightbox
 *
 * @since 1.1.0
 */

function ng_all_lightbox_callback() {
$options = get_option( 'venobox_settings' );

if( !isset( $options['ng_all_lightbox'] ) ) $options['ng_all_lightbox'] = '';

?>
  <fieldset>
  	<label for="ng_all_lightbox">
  		<input name="venobox_settings[ng_all_lightbox]" type="checkbox" id="ng_all_lightbox" value="1"<?php checked( 1, $options['ng_all_lightbox'], true ); ?> />
  		<span><?php esc_attr_e( 'Add Previous & Next icons in Lightbox, to navigate multiple items, (Galleries do this by default)', 'venobox-lightbox' ); ?></span>
  	</label>
  </fieldset>
<?php
}


/**
 *  Choose either alt or title attribute or caption value for lightbox title value
 *
 * @since 1.2.1
 */

function ng_title_select_callback() {
$options = get_option( 'venobox_settings' );

if( !isset( $options['ng_title_select'] ) ) $options['ng_title_select'] = 1;

?>
<fieldset>
	<label title='g:i a'>
		<input type="radio" name="venobox_settings[ng_title_select]" value="1"<?php checked( 1, $options['ng_title_select'], true ); ?> />
		<span><?php esc_attr_e( 'ALT text value', 'venobox-lightbox' ); ?></span>
	</label><br>
  <label title='g:i a'>
		<input type="radio" name="venobox_settings[ng_title_select]" value="2"<?php checked( 2, $options['ng_title_select'], true ); ?> />
		<span><?php esc_attr_e( 'Title text value', 'venobox-lightbox' ); ?></span>
	</label><br>
  <label title='g:i a'>
		<input type="radio" name="venobox_settings[ng_title_select]" value="3"<?php checked( 3, $options['ng_title_select'], true ); ?> />
		<span><?php esc_attr_e( 'Caption text value', 'venobox-lightbox' ); ?></span>
	</label><br>
  <label title='g:i a'>
		<input type="radio" name="venobox_settings[ng_title_select]" value="4"<?php checked( 4, $options['ng_title_select'], true ); ?> />
		<span><?php esc_attr_e( 'None', 'venobox-lightbox' ); ?></span>
	</label>

</fieldset>
<?php
}

/**
 *  Position title - top or bottom
 *
 *
 * @since 1.4.0
 */
function ng_title_position_callback() {
  $options = get_option( 'venobox_settings' );

if( !isset( $options['ng_title_position'] ) ) $options['ng_title_position'] = 'top';

?>
<select name="venobox_settings[ng_title_position]" id="ng_title_position">
	<option value="top"<?php selected($options['ng_title_position'], 'top'); ?> >top</option>
	<option value="bottom"<?php selected ($options['ng_title_position'], 'bottom'); ?> >bottom</option>
</select>
<?php
}

/**
 *  Add Pagination to Lightbox Head for multiple items on page
 *
 * @since 1.0.0
 */

function ng_numeratio_callback() {
$options = get_option( 'venobox_settings' );

if( !isset( $options['ng_numeratio'] ) ) $options['ng_numeratio'] = '';

?>
  <fieldset>
  	<label for="ng_numeratio">
  		<input name="venobox_settings[ng_numeratio]" type="checkbox" id="ng_numeratio" value="1"<?php checked( 1, $options['ng_numeratio'], true ); ?> />
  		<span><?php esc_attr_e( 'Show Pagination of Multiple Items', 'venobox-lightbox' ); ?></span>
  	</label>
  </fieldset>
<?php
}


/**
 *  Position Pagination - top or bottom
 *
 *
 * @since 1.4.0
 */
function ng_numeratio_position_callback() {
  $options = get_option( 'venobox_settings' );

if( !isset( $options['ng_numeratio_position'] ) ) $options['ng_numeratio_position'] = 'top';

?>
<select name="venobox_settings[ng_numeratio_position]" id="ng_numeratio_position">
	<option value="top"<?php selected($options['ng_numeratio_position'], 'top'); ?> >top</option>
	<option value="bottom"<?php selected ($options['ng_numeratio_position'], 'bottom'); ?> >bottom</option>
</select>
<?php
}


/**
 *  Add Infinite gallery previous and next to Lightbox Head for multiple items on page
 *
 * @since 1.0.0
 */

function ng_infinigall_callback() {
$options = get_option( 'venobox_settings' );

if( !isset( $options['ng_infinigall'] ) ) $options['ng_infinigall'] = '';

?>
  <fieldset>
  	<label for="ng_infinigall">
  		<input name="venobox_settings[ng_infinigall]" type="checkbox" id="ng_infinigall" value="1"<?php checked( 1, $options['ng_infinigall'], true ); ?> />
  		<span><?php esc_attr_e( 'Add Infinite gallery, which allows continous toggling of items on page in lightbox mode', 'venobox-lightbox' ); ?></span>
  	</label>
  </fieldset>
<?php
}

/**
 *  Add default rgba overlay color
 *
 * @link https://github.com/23r9i0/wp-color-picker-alpha/blob/master/dist/wp-color-picker-alpha.min.js
 *
 * @since 1.3.0
 */

function ng_overlay_callback() {
$options = get_option( 'venobox_settings' );

if( !isset( $options['ng_overlay'] ) ) $options['ng_overlay'] = 'rgba(0,0,0,0.85)';

echo '<input type="text" class="color-picker" data-alpha="true" data-default-color="rgba(0,0,0,0.85)" name="venobox_settings[ng_overlay]" value="' . sanitize_text_field($options['ng_overlay']) . '"/>';

}

/**
 *  Add Navigation & Title color
 *
 *
 * @since 1.4.0
 */

function ng_nav_elements_callback() {
$options = get_option( 'venobox_settings' );

if( !isset( $options['ng_nav_elements'] ) ) $options['ng_nav_elements'] = 'rgba(255,255,255,1)';

echo '<input type="text" class="color-picker" data-alpha="true" data-default-color="rgba(255,255,255,1)" name="venobox_settings[ng_nav_elements]" value="' . sanitize_text_field($options['ng_nav_elements']) . '"/>';

}

/**
 *  Add default inline background color
 *
 *
 * @since 1.3.6
 */

function ng_inline_background_callback() {
$options = get_option( 'venobox_settings' );

if( !isset( $options['ng_inline_background'] ) ) $options['ng_inline_background'] = '#fff';

echo '<input type="text" class="color-picker" data-alpha="true" data-default-color="#fff" name="venobox_settings[ng_inline_background]" value="' . sanitize_text_field($options['ng_inline_background']) . '"/>';

}


/**
 *  Add default border width for content
 *
 *
 * @since 1.3.2
 */

function ng_border_width_callback() {
$options = get_option( 'venobox_settings' );

if( !isset( $options['ng_border_width'] ) ) $options['ng_border_width'] = 0;

echo '<input type="number" class="regular-text" name="venobox_settings[ng_border_width]" value="' . sanitize_text_field($options['ng_border_width']) . '"/>';

}

/**
 *  Add default border color for content
 *
 * @link https://github.com/23r9i0/wp-color-picker-alpha/blob/master/dist/wp-color-picker-alpha.min.js
 *
 * @since 1.3.2
 */

function ng_border_color_callback() {
$options = get_option( 'venobox_settings' );

if( !isset( $options['ng_border_color'] ) ) $options['ng_border_color'] = 'rgba(0,0,0,0.85)';

echo '<input type="text" class="color-picker" data-alpha="true" data-default-color="rgba(0,0,0,0.85)" name="venobox_settings[ng_border_color]" value="' . sanitize_text_field($options['ng_border_color']) . '"/>';

}

/**
 *  Add Preloader Icon
 *
 *
 * @since 1.4.0
 */
function ng_preloader_callback() {
  $options = get_option( 'venobox_settings' );

if( !isset( $options['ng_preloader'] ) ) $options['ng_preloader'] = 'double-bounce';

?>
<select name="venobox_settings[ng_preloader]" id="ng_preloader">
        <option value="none"<?php selected($options['ng_preloader'], 'none'); ?> >none</option>
	<option value="double-bounce"<?php selected($options['ng_preloader'], 'double-bounce'); ?> >double-bounce</option>
	<option value="rotating-plane"<?php selected ($options['ng_preloader'], 'rotating-plane'); ?> >rotating-plane</option>
        <option value="wave"<?php selected ($options['ng_preloader'], 'wave'); ?> >wave</option>
        <option value="wandering-cubes"<?php selected ($options['ng_preloader'], 'wandering-cubes'); ?> >wandering-cubes</option>
        <option value="spinner-pulse"<?php selected ($options['ng_preloader'], 'spinner-pulse'); ?> >spinner-pulse</option>
        <option value="three-bounce"<?php selected ($options['ng_preloader'], 'three-bounce'); ?> >three-bounce</option>
        <option value="cube-grid"<?php selected ($options['ng_preloader'], 'cube-grid'); ?> >cube-grid</option>
</select>
<?php
}

/**
* Update legacy ,markup for data attributes
*
*
* @since 1.4.0
*/

function ng_vb_legacy_markup_callback() {
$options = get_option( 'venobox_settings' );
if( !isset( $options['ng_vb_legacy_markup'] ) ) $options['ng_vb_legacy_markup'] = '';

?>
 <fieldset>
     <label for="ng_vb_legacy_markup">
             <input name="venobox_settings[ng_vb_legacy_markup]" type="checkbox" id="ng_vb_legacy_markup" value="1"<?php checked( 1, $options['ng_vb_legacy_markup'], true ); ?> />
             <span><?php esc_attr_e( 'Update legacy Data Attributes', 'venobox_settings' ); ?></span>
     </label>
 </fieldset>
<?php
}




add_action('post_submitbox_misc_actions',  __NAMESPACE__ . '\\vbmeta_create');
/**
 * Create VenoBox Meta
 * @since 1.4.1
 * @link https://gist.github.com/emilysnothere/943ea6274dc160cec271
 *
 */
function vbmeta_create() {
    $post_id = get_the_ID();

    // if (get_post_type($post_id) != 'post') {
    //     return;
    // }

    $value = get_post_meta( $post_id, '_venobox_check', true );
    wp_nonce_field( 'venobox_nonce_' . $post_id, 'venobox_nonce' );
    ?>
    <div class="misc-pub-section misc-pub-section-last">
        <label><input type="checkbox" value="1" <?php checked( $value, true, true ); ?> name="_venobox_check" /><?php _e( 'Disable VenoBox', 'venobox' ); ?></label>
    </div>
    <?php

}

add_action( 'save_post', __NAMESPACE__ . '\\vbmeta_save' );
/**
 * Save VenoBox Meta
 * @since 1.4.1
 *
 */

function vbmeta_save($post_id) {

    if ( defined( 'DOING_AUTOSAVE' ) && DOING_AUTOSAVE ) {
        return;
    }

    if (
        !isset( $_POST['venobox_nonce'] ) ||
        !wp_verify_nonce( $_POST['venobox_nonce'], 'venobox_nonce_' . $post_id )
    ) {
        return;
    }

    if ( !current_user_can( 'edit_post', $post_id ) ) {
        return;
    }

    if ( isset( $_POST['_venobox_check'] )) {
        update_post_meta( $post_id, '_venobox_check', $_POST['_venobox_check'] );
    } else {
        delete_post_meta( $post_id, '_venobox_check' );
    }

}


/**
 *  Adding inline CSS
 *
 *
 * @since 1.3.0
 */
function inline_veno() {

      $options = get_option('venobox_settings');

      $options_default = array(
         'ng_overlay'           => '',
         'ng_inline_background' => '#fff',
         'ng_border_color'      => '',
         'ng_border_width'      => '',


      );

      $options = wp_parse_args( $options, $options_default );

       $ng_overlay           = $options['ng_overlay'];
       $ng_inline_background = $options['ng_inline_background'];
       $ng_overlay           = $options['ng_overlay'];
       $ng_border_color      = $options['ng_border_color'];
       $ng_border_width      = $options['ng_border_width'];



        // Inline CSS & close image call
        $venobox_custom_css = "
        /*.vbox-overlay,
        .vbox-num,
        .vbox-title,
        .vbox-close {
                background: {$ng_overlay} !important;
        }*/
        .vbox-inline {
                background-color: {$ng_inline_background} !important;
                padding: 2%;
    	}
    	.vbox-content > img{
                background-color: {$ng_border_color} !important;
                padding: {$ng_border_width}px !important;
    	}
        ";

  //add the above custom CSS via wp_add_inline_style
  wp_add_inline_style( 'venobox-css', $venobox_custom_css );
}

add_action( 'wp_enqueue_scripts', __NAMESPACE__ . '\\inline_veno' );
