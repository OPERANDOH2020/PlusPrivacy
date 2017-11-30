<?php
/**
 * iWorks_Rate - Dashboard Notification module.
 *
 * @version 1.0.1
 * @author  iworks (Marcin Pietrzak)
 * @author  Incsub (Philipp Stracker)
 *
 * Based on:
 *
 * WPMUDEV iworks - Free Dashboard Notification module.
 * Used by wordpress.org hosted plugins.
 *
 */
if ( ! class_exists( 'iworks_rate' ) ) {
	class iworks_rate {

		/**
		 * This class version.
		 *
		 * @since 1.0.1
		 * @var   string
		 */
		private $version = '1.0.1';

		/**
		 * $wpdb->options field name.
		 *
		 * @since 1.0.0
		 * @var   string
		 */
		protected $option_name = 'iworks_rate';

		/**
		 * List of all registered plugins.
		 *
		 * @since 1.0.0
		 * @var   array
		 */
		protected $plugins = array();

		/**
		 * Module options that are stored in database.
		 * Timestamps are stored here.
		 *
		 * Note that this option is stored in site-meta for multisite installs.
		 *
		 * @since 1.0.0
		 * @var   array
		 */
		protected $stored = array();

		/**
		 * Initializes and returns the singleton instance.
		 *
		 * @since  1.0.0
		 */
		static public function instance() {
			static $Inst = null;

			if ( null === $Inst ) {
				$Inst = new iworks_rate();
			}

			return $Inst;
		}

		/**
		 * Set up the iworks_rate module. Private singleton constructor.
		 *
		 * @since  1.0.0
		 */
		private function __construct() {
			$this->read_stored_data();

			$this->add_action( 'iworks-register-plugin', 5 );
			$this->add_action( 'load-index.php' );

			$this->add_action( 'wp_ajax_iworks_act' );
			$this->add_action( 'wp_ajax_iworks_dismiss' );
		}

		/**
		 * Load persistent module-data from the WP Database.
		 *
		 * @since  1.0.0
		 */
		protected function read_stored_data() {
			$data = get_site_option( $this->option_name, false, false );

			if ( ! is_array( $data ) ) {
				$data = array();
			}

			// A list of all plugins with timestamp of first registration.
			if ( ! isset( $data['plugins'] ) || ! is_array( $data['plugins'] ) ) {
				$data['plugins'] = array();
			}

			// A list with pending messages and earliest timestamp for display.
			if ( ! isset( $data['queue'] ) || ! is_array( $data['queue'] ) ) {
				$data['queue'] = array();
			}

			// A list with all messages that were handles already.
			if ( ! isset( $data['done'] ) || ! is_array( $data['done'] ) ) {
				$data['done'] = array();
			}

			$this->stored = $data;
		}

		/**
		 * Save persistent module-data to the WP database.
		 *
		 * @since  1.0.0
		 */
		protected function store_data() {
			update_site_option( $this->option_name, $this->stored );
		}

		/**
		 * Action handler for 'iworks-register-plugin'
		 * Register an active plugin.
		 *
		 * @since  1.0.0
		 * @param  string $plugin_id WordPress plugin-ID (see: plugin_basename).
		 * @param  string $title Plugin name for display.
		 * @param  string $slug the plugin slug on wp.org
		 */
		public function iworks_register_plugin( $plugin_id, $title, $slug ) {
			// Ignore incorrectly registered plugins to avoid errors later.
			if ( empty( $plugin_id ) ) { return; }
			if ( empty( $title ) ) { return; }
			if ( empty( $slug ) ) { return; }

			$this->plugins[ $plugin_id ] = (object) array(
				'id' => $plugin_id,
				'title' => $title,
				'slug' => $slug,
			);

			/*
			 * When the plugin is registered the first time we store some infos
			 * in the persistent module-data that help us later to find out
			 * if/which message should be displayed.
			 */
			if ( empty( $this->stored['plugins'][ $plugin_id ] ) ) {
				// First register the plugin permanently.
				$this->stored['plugins'][ $plugin_id ] = time();

				$hash = md5( $plugin_id . '-rate' );
				$this->stored['queue'][ $hash ] = array(
					'plugin' => $plugin_id,
					'show_at' => time() + 7 * DAY_IN_SECONDS,
				);

				// Finally save the details.
				$this->store_data();
			}
		}

		/**
		 * Ajax handler called when the user chooses the CTA button.
		 *
		 * @since  1.0.0
		 */
		public function wp_ajax_iworks_act() {
			$plugin = $_POST['plugin_id'];
			$this->mark_as_done( $plugin, 'ok' );
			wp_send_json_success();
		}

		/**
		 * Ajax handler called when the user chooses the dismiss button.
		 *
		 * @since  1.0.0
		 */
		public function wp_ajax_iworks_dismiss() {
			$plugin = $_POST['plugin_id'];
			$this->mark_as_done( $plugin, 'ignore' );
			wp_send_json_success();
		}

		/**
		 * Action handler for 'load-index.php'
		 * Set-up the Dashboard notification.
		 *
		 * @since  1.0.0
		 */
		public function load_index_php() {
			if ( is_super_admin() ) {
				$this->add_action( 'all_admin_notices' );
				wp_enqueue_style(
					__CLASS__,
					plugin_dir_url( __FILE__ ) . 'admin.css',
					array(),
					$this->version
				);
				wp_enqueue_script(
					__CLASS__,
					plugin_dir_url( __FILE__ ) . 'admin.js',
					array(),
					$this->version,
					true
				);
			}
		}

		/**
		 * Action handler for 'admin_notices'
		 * Display the Dashboard notification.
		 *
		 * @since  1.0.0
		 */
		public function all_admin_notices() {
			$info = $this->choose_message();
			if ( ! $info ) { return; }

			$this->render_message( $info );
		}

		/**
		 * Check to see if there is a pending message to display and returns
		 * the message details if there is.
		 *
		 * Note that this function is only called on the main Dashboard screen
		 * and only when logged in as super-admin.
		 *
		 * @since  1.0.0
		 * @return object|false
		 *         string $plugin WordPress plugin ID?
		 */
		protected function choose_message() {
			$obj = false;
			$chosen = false;
			$earliest = false;

			$now = time();

			// The "current" time can be changed via $_GET to test the module.
			if ( defined( 'WP_DEBUG' ) && WP_DEBUG && ! empty( $_GET['time'] ) ) {
				$custom_time = $_GET['time'];
				if ( ' ' == $custom_time[0] ) { $custom_time[0] = '+'; }
				if ( $custom_time ) { $now = strtotime( $custom_time ); }
				if ( ! $now ) { $now = time(); }
			}

			$tomorrow = $now + DAY_IN_SECONDS;

			foreach ( $this->stored['queue'] as $hash => $item ) {
				$show_at = intval( $item['show_at'] );
				$is_sticky = ! empty( $item['sticky'] );

				if ( ! isset( $this->plugins[ $item['plugin'] ] ) ) {
					// Deactivated plugin before the message was displayed.
					continue;
				}
				$plugin = $this->plugins[ $item['plugin'] ];

				$can_display = true;
				if ( wp_is_mobile() ) {
					$can_display = false;
				}
				if ( $now < $show_at ) {
					// Do not display messages that are not due yet.
					$can_display = false;
				}

				if ( ! $can_display ) { continue; }

				if ( $is_sticky ) {
					// If sticky item is present then choose it!
					$chosen = $hash;
					break;
				} elseif ( ! $earliest || $earliest < $show_at ) {
					$earliest = $show_at;
					$chosen = $hash;
					// Don't use `break` because a sticky item might follow...
					// Find the item with the earliest schedule.
				}
			}

			if ( $chosen ) {
				// Make the chosen item sticky.
				$this->stored['queue'][ $chosen ]['sticky'] = true;

				// Re-schedule other messages that are due today.
				foreach ( $this->stored['queue'] as $hash => $item ) {
					$show_at = intval( $item['show_at'] );

					if ( empty( $item['sticky'] ) && $tomorrow > $show_at ) {
						$this->stored['queue'][ $hash ]['show_at'] = $tomorrow;
					}
				}

				// Save the changes.
				$this->store_data();

				$obj = (object) $this->stored['queue'][ $chosen ];
			}

			return $obj;
		}

		/**
		 * Moves a message from the queue to the done list.
		 *
		 * @since  1.0.0
		 * @param  string $plugin Plugin ID.
		 * @param  string $state [ok|ignore] Button clicked.
		 */
		protected function mark_as_done( $plugin, $state ) {
			$done_item = false;

			foreach ( $this->stored['queue'] as $hash => $item ) {
				unset( $this->stored['queue'][ $hash ]['sticky'] );

				if ( $item['plugin'] == $plugin  ) {
					$done_item = $item;
					unset( $this->stored['queue'][ $hash ] );
				}
			}

			if ( $done_item ) {
				$done_item['state'] = $state;
				$done_item['hash'] = $hash;
				$done_item['handled_at'] = time();
				unset( $done_item['sticky'] );

				$this->stored['done'][] = $done_item;
				$this->store_data();
			}
		}

		/**
		 * Renders the actual Notification message.
		 *
		 * @since  1.0.0
		 */
		protected function render_message( $info ) {
			$plugin = $this->plugins[ $info->plugin ];
			do_action( 'iworks_rate_css' );
			?>
			<div class="notice iworks-notice iworks-notice-rate iworks-notice-<?php echo esc_attr( dirname( $info->plugin ) ); ?>" style="display:none">
				<input type="hidden" name="plugin_id" value="<?php echo esc_attr( $info->plugin ); ?>" />
				<input type="hidden" name="slug" value="<?php echo esc_attr( $plugin->slug ); ?>" />
				<?php
					$this->render_rate_message( $plugin );
				?>
			</div>
			<?php
		}

		/**
		 * Output the contents of the rate-this-plugin message.
		 * No return value. The code is directly output.
		 *
		 * @since  1.0.0
		 */
		protected function render_rate_message( $plugin ) {
			$user = wp_get_current_user();
			$user_name = $user->display_name;

			$msg = __( "Hey %s, you've been using %s for a while now, and we hope you're happy with it.", 'og' ) . '<br />'. __( "We've spent countless hours developing this free plugin for you, and we would really appreciate it if you dropped us a quick rating!", 'og' );
			$msg = apply_filters( 'iworks-rating-message-' . $plugin->id, $msg );

			?>
			<div class="iworks-notice-logo"><span></span></div>
				<div class="iworks-notice-message">
					<?php
					printf(
						$msg,
						'<strong>' . $user_name . '</strong>',
						'<strong>' . $plugin->title . '</strong>'
					);
					?>
				</div>
				<div class="iworks-notice-cta">
					<button class="iworks-notice-act button-primary" data-msg="<?php _e( 'Thanks :)', 'og' ); ?>">
						<?php
						printf(
							__( 'Rate %s', 'og' ),
							esc_html( $plugin->title )
						); ?>
					</button>
					<button class="iworks-notice-dismiss" data-msg="<?php _e( 'Saving', 'og' ); ?>">
						<?php _e( 'No thanks', 'og' ); ?>
					</button>
				</div>
			<?php
		}

		/**
		 * Registers a new action handler. The callback function has the same
		 * name as the action hook.
		 *
		 * @since 1.0.0
		 */
		protected function add_action( $hook, $params = 1 ) {
			$method_name = strtolower( $hook );
			$method_name = preg_replace( '/[^a-z0-9]/', '_', $method_name );
			$handler = array( $this, $method_name );
			add_action( $hook, $handler, 5, $params );
		}
	}

	// Initialize the module.
	iworks_rate::instance();
}
