<?php
	if ( ! defined( 'ABSPATH' ) ) exit; 
	$new_password = sanitize_text_field( $_GET['pass'] );
	$login_url = clean_login_get_translated_option_page( 'cl_login_url','');
?>

<div class="cleanlogin-container">
	<form class="cleanlogin-form">
		
		<fieldset>
			<div class="cleanlogin-field">
				<label><?php echo __( 'Your new password is', 'clean-login' ); ?></label>
				<input type="text" name="pass" value="<?php echo $new_password; ?>">
			</div>
		
		</fieldset>
		
		<div class="cleanlogin-form-bottom">
				
			<?php if ( $login_url != '' )
				echo "<a href='$login_url' class='cleanlogin-form-login-link'>". __( 'Log in', 'clean-login') ."</a>";
			?>
						
		</div>
	</form>
</div>