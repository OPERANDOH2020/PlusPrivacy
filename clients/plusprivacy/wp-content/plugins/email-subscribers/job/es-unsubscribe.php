<?php

// Exit if accessed directly
if ( ! defined( 'ABSPATH' ) ) {
	exit; 
}

if( (isset($_GET['es'])) && ($_GET['es'] == "unsubscribe") ) {

	$blogname = get_option('blogname');
	$noerror = true;
	$home_url = home_url('/');
	?>
	<html>
	<head>
		<title><?php echo $blogname; ?></title>
		<meta http-equiv="refresh" content="10; url=<?php echo $home_url; ?>" charset="<?php echo esc_attr( get_option( 'blog_charset' ) ); ?>" />
		<?php do_action( 'es_message_head' ); ?>
	</head>
	<body>
		<div class="es_successfully_unsubscribed">
			<?php
			// Load query string
			$form = array();
			$form['db'] = isset($_GET['db']) ? $_GET['db'] : '';
			$form['email'] = isset($_GET['email']) ? $_GET['email'] : '';
			$form['guid'] = isset($_GET['guid']) ? $_GET['guid'] : '';

			// Check errors in the query string
			if ( $form['db'] == '' || $form['email'] == '' || $form['guid'] == '' ) {
				$noerror = false;
			} else {
				if(!is_numeric($form['db'])) {
					$noerror = false;
				}

				if (!filter_var($form['email'], FILTER_VALIDATE_EMAIL)) {
					$noerror = false;
				}
			}

			// Load default message
			$data = array();
			$data = es_cls_settings::es_setting_select(1);
			
			if($noerror) {
				$result = es_cls_dbquery::es_view_subscriber_job("Unsubscribed", $form['db'], $form['guid'], $form['email']);
				if($result) {
					$message = esc_html(stripslashes($data['es_c_unsubhtml']));
					$message = str_replace("\r\n", "<br />", $message);
				} else {
					$message = esc_html(stripslashes($data['es_c_message2']));
				}
				if($message == "") {
					$message = __( 'Oops.. We are getting some technical error. Please try again or contact admin.', ES_TDOMAIN );
				}
				echo $message;
			} else {
				$message = esc_html(stripslashes($data['es_c_message2']));
				$message = str_replace("\r\n", "<br />", $message);
				if($message == "") {
					$message = __( 'Oops.. We are getting some technical error. Please try again or contact admin.', ES_TDOMAIN );
				}
				echo $message;
			}
			?>
		</div>
	</body>
	</html>
	<?php
}
die();