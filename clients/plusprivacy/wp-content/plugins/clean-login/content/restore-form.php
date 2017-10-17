<?php
	if ( ! defined( 'ABSPATH' ) ) exit; 
?>

<div class="cleanlogin-container">
	<form class="cleanlogin-form" method="post" action="#">

		<fieldset>
		
			<div class="cleanlogin-field">
				<input class="cleanlogin-field-username" type="text" name="username" value="" placeholder="<?php echo __( 'Username (or E-mail)', 'clean-login' ) ; ?>">
			</div>

			<div class="cleanlogin-field-website">
				<label for='website'>Website</label>
	    		<input type='text' name='website' value=".">
	    	</div>
		
		</fieldset>
		
		<div>	
			<input type="submit" value="<?php echo __( 'Restore password', 'clean-login' ); ?>" name="submit">
			<input type="hidden" name="action" value="restore">		
		</div>

	</form>
</div>