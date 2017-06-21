<?php
/*
Plugin Name: Header and Footer Scripts
Plugin URI: http://www.blogsynthesis.com/plugins/header-and-footer-scripts/
Description: Allows you to insert code or text in the header or footer of your WordPress blog
Version: 1.3.4
Author: Anand Kumar
Author URI: http://www.blogsynthesis.com
License: GPLv2 or later

jQuery Smooth Scroll
Copyright (C) 2013-16, Anand Kumar <anand@anandkumar.net>
*/

/*
This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License, version 2, as 
published by the Free Software Foundation.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

Credits: WPBeginner (http://bit.ly/wpb-ihf) and Farinspace (http://bit.ly/1m9NzM9)
*/

define('SHFS_PLUGIN_DIR',str_replace('\\','/',dirname(__FILE__)));

if ( !class_exists( 'HeaderAndFooterScripts' ) ) {
	
	class HeaderAndFooterScripts {

		function __construct() {
		
			add_action( 'init', array( &$this, 'init' ) );
			add_action( 'admin_init', array( &$this, 'admin_init' ) );
			add_action( 'admin_menu', array( &$this, 'admin_menu' ) );
			add_action( 'wp_head', array( &$this, 'wp_head' ) );
			add_action( 'wp_footer', array( &$this, 'wp_footer' ) );
		
		}
		
	
		function init() {
			load_plugin_textdomain( 'insert-headers-and-footers', false, dirname( plugin_basename ( __FILE__ ) ).'/lang' );
		}
	
		function admin_init() {
			register_setting( 'insert-headers-and-footers', 'shfs_insert_header', 'trim' );
			register_setting( 'insert-headers-and-footers', 'shfs_insert_footer', 'trim' );

			foreach (array('post','page') as $type) 
			{
				add_meta_box('shfs_all_post_meta', 'Insert Script to &lt;head&gt;', 'shfs_meta_setup', $type, 'normal', 'high');
			}
			
			add_action('save_post','shfs_post_meta_save');
		}
	
		function admin_menu() {
			$page = add_submenu_page( 'options-general.php', 'Header and Footer Scripts', 'Header and Footer Scripts', 'manage_options', __FILE__, array( &$this, 'shfs_options_panel' ) );
			}
	
		function wp_head() {
			$meta = get_option( 'shfs_insert_header', '' );
				if ( $meta != '' ) {
					echo $meta, "\n";
				}

			$shfs_post_meta = get_post_meta( get_the_ID(), '_inpost_head_script' , TRUE );
				if ( $shfs_post_meta != '' ) {
					echo $shfs_post_meta['synth_header_script'], "\n";
				}
			
		}
	
		function wp_footer() {
			if ( !is_admin() && !is_feed() && !is_robots() && !is_trackback() ) {
				$text = get_option( 'shfs_insert_footer', '' );
				$text = convert_smilies( $text );
				$text = do_shortcode( $text );
			
			if ( $text != '' ) {
				echo $text, "\n";
			}
			}
		}

			
		function fetch_rss_items( $num, $feed ) {
			include_once( ABSPATH . WPINC . '/feed.php' );
			$rss = fetch_feed( $feed );

			// Bail if feed doesn't work
			if ( !$rss || is_wp_error( $rss ) )
			return false;

			$rss_items = $rss->get_items( 0, $rss->get_item_quantity( $num ) );

			// If the feed was erroneous 
			if ( !$rss_items ) {
				$md5 = md5( $feed );
				delete_transient( 'feed_' . $md5 );
				delete_transient( 'feed_mod_' . $md5 );
				$rss = fetch_feed( $feed );
				$rss_items = $rss->get_items( 0, $rss->get_item_quantity( $num ) );
			}

			return $rss_items;
		}
		   
				
		function shfs_options_panel() { ?>
			<div id="fb-root"></div>
			<div id="shfs-wrap">
				<div class="wrap">
				<?php screen_icon(); ?>
					<h2>Header and Footer Scripts - Options</h2>
					<hr />
					<div class="shfs-wrap" style="width: auto;float: left;margin-right: 2rem;">
						
						<div class="shfs-follow">
							<strong style="line-height:3;">Follow:</strong>&nbsp; &nbsp; &nbsp;
							<!-- Place this tag where you want the widget to render. -->
							<div class="g-follow" data-annotation="none" data-height="20" data-href="//plus.google.com/106432349913858405478" data-rel="author"></div>
						
							<div class="fb-like" data-href="https://www.facebook.com/BlogSynthesis" data-layout="button_count" data-action="like" data-show-faces="false" data-share="false"></div>
						</div><hr />
					
						<form name="dofollow" action="options.php" method="post">
						
							<?php settings_fields( 'insert-headers-and-footers' ); ?>
                        	
							<h3 class="shfs-labels" for="shfs_insert_header">Scripts in header:</h3>
                            <textarea rows="5" cols="57" id="insert_header" name="shfs_insert_header"><?php echo esc_html( get_option( 'shfs_insert_header' ) ); ?></textarea><br />
						These scripts will be printed to the <code>&lt;head&gt;</code> section. 
                        
							<h3 class="shfs-labels footerlabel" for="shfs_insert_footer">Scripts in footer:</h3>
							<textarea rows="5" cols="57" id="shfs_insert_footer" name="shfs_insert_footer"><?php echo esc_html( get_option( 'shfs_insert_footer' ) ); ?></textarea><br />
						These scripts will be printed to the <code>&lt;footer&gt;</code> section.

						<p class="submit">
							<input class="button button-primary" type="submit" name="Submit" value="Save settings" /> 
						</p>

						</form>
					</div>
					
					
					<div class="shfs-sidebar" style="max-width: 270px;float: left;">
						<div class="shfs-improve-site" style="padding: 1rem; background: rgba(0, 0, 0, .02);">
							<h2>Improve Your Site!</h2>
							<p>Want to take your site to the next level? Look behind the scenes of BlogSynthesis to see what you can do!</p>
							<p><a href="http://www.blogsynthesis.com/go/shfs-plugin/" class="button" target="_blank">BlogSynthesis's Blueprint &raquo;</a></p>
						</div>
						<div class="shfs-support" style="padding: 1rem; background: rgba(0, 0, 0, .02);">
							<h2>Need Support?</h2>
							<p>For any help visit our <br /><strong><a href="http://www.blogsynthesis.com/plugins/header-and-footer-scripts/" target="_blank">Plugin Page</a></strong> or<br /><strong><a href="http://www.blogsynthesis.com/support/" target="_blank">Support Page</a></strong></p>
						</div>
						<div class="shfs-donate" style="padding: 1rem; background: rgba(0, 0, 0, .02);">
							<h3>Contribute or Donate!</h3>
							<p>Want to help make this plugin even better? All donations are used to improve this plugin, so donate $10, $20 or $50 now!</p>
							<p><a href="http://www.blogsynthesis.com/go/donate" target="_blank"><img src="<?php  echo plugin_dir_url( __FILE__ ); ?>images/paypal-donate.gif" alt="Subscribe to our Blog" style="margin: 0 5px 0 0; vertical-align: top; line-height: 18px;"/> Donate!</a></p>
						</div>
						<div class="shfs-wpb-recent" style="padding: 1rem; background: rgba(0, 0, 0, .02);">
						<h2>Latest From BlogSynthesis</h2>
							<?php
							$rss_items = $this->fetch_rss_items( 3, 'http://feeds.feedburner.com/blogsynthesis' );
							$content = '<ul>';
							if ( !$rss_items ) {
								$content .= '<li class="shfs-list">No news items, feed might be broken...</li>';
							} else {
								foreach ( $rss_items as $item ) {
									$url = preg_replace( '/#.*/', '', esc_url( $item->get_permalink(), null, 'display' ) );
									$content .= '<li class="shfs-list">';
									$content .= '<a href="' . $url . '#utm_source=wpadmin&utm_medium=sidebarwidget&utm_term=newsitem&utm_campaign=shfs" target="_blank">' . esc_html( $item->get_title() ) . '</a> ';
									$content .= '</li>';
								}}
								$content .= '<li class="facebook"><a href="https://www.facebook.com/blogsynthesis" target="_blank">Like BlogSynthesis on Facebook</a></li>';
								$content .= '<li class="twitter"><a href="http://twitter.com/blogsynthesis"target="_blank">Follow BlogSynthesis on Twitter</a></li>';
								$content .= '<li class="googleplus"><a href="https://plus.google.com/+BlogSynthesis/posts" target="_blank">Circle BlogSynthesis on Google+</a></li>';
								$content .= '<li class="email"><a href="http://www.blogsynthesis.com/newsletter/" target="_blank">Subscribe by email</a></li>';
								$content .= '</ul>';
								echo $content;
								?>
						</div>
					</div>
				
				</div>
				</div>
				
				<!-- Place this tag after the last widget tag. -->
				<script type="text/javascript">
				  (function() {
					var po = document.createElement('script'); po.type = 'text/javascript'; po.async = true;
					po.src = 'https://apis.google.com/js/platform.js';
					var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(po, s);
				  })();
				</script>

				
				<script>(function(d, s, id) {
				  var js, fjs = d.getElementsByTagName(s)[0];
				  if (d.getElementById(id)) return;
				  js = d.createElement(s); js.id = id;
				  js.src = "//connect.facebook.net/en_US/all.js#xfbml=1&appId=383137358414970";
				  fjs.parentNode.insertBefore(js, fjs);
				}(document, 'script', 'facebook-jssdk'));</script>
			
				<?php
		}
	}

	function shfs_meta_setup()
	{
		global $post;
	 
		// using an underscore, prevents the meta variable
		// from showing up in the custom fields section
		$meta = get_post_meta($post->ID,'_inpost_head_script',TRUE);
	 
		// instead of writing HTML here, lets do an include
		include(SHFS_PLUGIN_DIR . '/meta.php');
	 
		// create a custom nonce for submit verification later
		echo '<input type="hidden" name="shfs_post_meta_noncename" value="' . wp_create_nonce(__FILE__) . '" />';
	}
	 
	function shfs_post_meta_save($post_id) 
	{
		// authentication checks

		// make sure data came from our meta box
		if ( ! isset( $_POST['shfs_post_meta_noncename'] )
			|| !wp_verify_nonce($_POST['shfs_post_meta_noncename'],__FILE__)) return $post_id;
			
		// check user permissions
		if ($_POST['post_type'] == 'page') 
		{
			if (!current_user_can('edit_page', $post_id)) return $post_id;
		}
		else 
		{
			if (!current_user_can('edit_post', $post_id)) return $post_id;
		}

		$current_data = get_post_meta($post_id, '_inpost_head_script', TRUE);	
	 
		$new_data = $_POST['_inpost_head_script'];

		shfs_post_meta_clean($new_data);
		
		if ($current_data) 
		{
			if (is_null($new_data)) delete_post_meta($post_id,'_inpost_head_script');
			else update_post_meta($post_id,'_inpost_head_script',$new_data);
		}
		elseif (!is_null($new_data))
		{
			add_post_meta($post_id,'_inpost_head_script',$new_data,TRUE);
		}

		return $post_id;
	}

	function shfs_post_meta_clean(&$arr)
	{
		if (is_array($arr))
		{
			foreach ($arr as $i => $v)
			{
				if (is_array($arr[$i])) 
				{
					shfs_post_meta_clean($arr[$i]);

					if (!count($arr[$i])) 
					{
						unset($arr[$i]);
					}
				}
				else 
				{
					if (trim($arr[$i]) == '') 
					{
						unset($arr[$i]);
					}
				}
			}

			if (!count($arr)) 
			{
				$arr = NULL;
			}
		}
	}


	add_action('wp_dashboard_setup', 'shfs_dashboard_widgets');

	function shfs_dashboard_widgets() {
  		global $wp_meta_boxes;
		wp_add_dashboard_widget('blogsynthesisshfswidget', 'Latest from BlogSynthesis', 'shfs_widget');
	}		

		function shfs_widget() {		
			include_once( ABSPATH . WPINC . '/feed.php' );
			
			$rss = fetch_feed( 'http://feeds2.feedburner.com/blogsynthesis' );
			
			if ( ! is_wp_error( $rss ) ) :

				// Figure out how many total items there are, but limit it to 10. 
				$maxitems = $rss->get_item_quantity( 10 ); 

				// Build an array of all the items, starting with element 0 (first element).
				$rss_items = $rss->get_items( 0, $maxitems );

			endif; 
			
			{ ?>
				<div class="rss-widget">
                	<a href="http://www.blogsynthesis.com/#utm_source=wpadmin&utm_medium=dashboardwidget&utm_term=newsitemlogo&utm_campaign=shfs" title="BlogSynthesis - For Bloggers" target="_blank"><img src="<?php  echo plugin_dir_url( __FILE__ ); ?>images/blogsynthesis-100px.png"  class="alignright" alt="BlogSynthesis"/></a>			
					<ul>
						<?php if ( $maxitems == 0 ) : ?>
							<li><?php _e( 'No items', 'shfs-text-domain' ); ?></li>
						<?php else : ?>
							<?php // Loop through each feed item and display each item as a hyperlink. ?>
							<?php foreach ( $rss_items as $item ) : ?>
								<li>
									<a href="<?php echo esc_url( $item->get_permalink() ); ?>#utm_source=wpadmin&utm_medium=dashboardwidget&utm_term=newsitem&utm_campaign=shfs"
										title="<?php printf( __( 'Posted %s', 'shfs-text-domain' ), $item->get_date('j F Y | g:i a') ); ?>" target="_blank">
										<?php echo esc_html( $item->get_title() ); ?>
									</a>
								</li>
							<?php endforeach; ?>
						<?php endif; ?>
					</ul>
					<div style="border-top: 1px solid #ddd; padding-top: 10px; text-align:center;">
						<span class="addthis_toolbox addthis_default_style" style="float:left;">
						<a class="addthis_button_facebook_follow" addthis:userid="blogsynthesis"></a>
						<a class="addthis_button_twitter_follow" addthis:userid="blogsynthesis"></a>
						<a class="addthis_button_google_follow" addthis:userid="+BlogSynthesis"></a>
						<a class="addthis_button_rss_follow" addthis:userid="http://feeds2.feedburner.com/blogsynthesis"></a>
						</span>
						&nbsp; &nbsp; &nbsp;
						<a href="http://www.blogsynthesis.com/newsletter/"><img src="<?php  echo plugin_dir_url( __FILE__ ); ?>images/email-16px.png" alt="Subscribe via Email"/> Subscribe by email</a>
                		&nbsp; &nbsp; &nbsp;
						<script type="text/javascript" src="//s7.addthis.com/js/300/addthis_widget.js#pubid=ra-525ab1d176544441"></script>
					</div>
				</div>
		<?php }
		
	}
	
$shfs_header_and_footer_scripts = new HeaderAndFooterScripts();

}


