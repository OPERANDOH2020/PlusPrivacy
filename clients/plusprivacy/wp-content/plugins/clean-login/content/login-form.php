<?php
	if ( ! defined( 'ABSPATH' ) ) exit; 
	$login_url = clean_login_get_translated_option_page( 'cl_login_url','');
	$register_url = clean_login_get_translated_option_page( 'cl_register_url', '');
	$restore_url = clean_login_get_translated_option_page( 'cl_restore_url', '');
?>
<div class="cleanlogin-container">		

	<form class="cleanlogin-form" method="post" action="<?php echo $login_url;?>">
			
		<fieldset>
			<div class="cleanlogin-field">
				<input class="cleanlogin-field-username" type="text" name="log" placeholder="<?php echo __( 'Username', 'clean-login' ); ?>">
			</div>
			
			<div class="cleanlogin-field">
				<input class="cleanlogin-field-password" type="password" name="pwd" placeholder="<?php echo __( 'Password', 'clean-login' ); ?>">
			</div>
		</fieldset>
		
		<fieldset>
			<input class="cleanlogin-field" type="submit" value="<?php echo __( 'Log in', 'clean-login' ); ?>" name="submit">
			<input type="hidden" name="action" value="login">
			
			<div class="cleanlogin-field cleanlogin-field-remember">
				<input type="checkbox" name="rememberme" value="forever">
				<label><?php echo __( 'Remember?', 'clean-login' ); ?></label>
			</div>
		</fieldset>
		
		<?php echo do_shortcode( apply_filters( 'cl_login_form', '') ); ?>

		<div class="cleanlogin-form-bottom">
			
			<?php if ( $restore_url != '' )
				echo "<a href='$restore_url' class='cleanlogin-form-pwd-link'>". __( 'Lost password?', 'clean-login' ) ."</a>";
			?>

			<?php if ( $register_url != '' )
				echo "<a href='$register_url' class='cleanlogin-form-register-link'>". __( 'Register', 'clean-login' ) ."</a>";
			?>
						
		</div>
		
	</form>

</div>
