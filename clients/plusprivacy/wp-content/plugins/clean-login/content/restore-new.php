<?php
	$new_password = sanitize_text_field( $_GET['pass'] );
	$login_url = get_translated_option_page( 'cl_login_url','');
?>

<div class="cleanlogin-container">
	<form class="cleanlogin-form">
		
		<fieldset>
			<div class="cleanlogin-field">
				<label><?php echo __( 'Your new password is', 'cleanlogin' ); ?></label>
				<input type="text" name="pass" value="<?php echo $new_password; ?>">
			</div>
		
		</fieldset>
		
		<div class="cleanlogin-form-bottom">
				
			<?php if ( $login_url != '' )
				echo "<a href='$login_url' class='cleanlogin-form-login-link'>". __( 'Log in', 'cleanlogin') ."</a>";
			?>
						
		</div>
	</form>
</div>