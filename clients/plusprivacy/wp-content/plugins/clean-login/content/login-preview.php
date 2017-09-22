<?php
	if ( ! defined( 'ABSPATH' ) ) exit; 
	$login_url = clean_login_get_translated_option_page( 'cl_login_url','');
	$current_user = wp_get_current_user();
	$edit_url = clean_login_get_translated_option_page( 'cl_edit_url', '');
	
	$show_user_information = get_option( 'cl_hideuser' ) == 'on' ? false : true;
?>

<div class="cleanlogin-container" >
	<div class="cleanlogin-preview">
		<div class="cleanlogin-preview-top">
			<a href="<?php echo esc_url( add_query_arg( 'action', 'logout', $login_url) ); ?>" class="cleanlogin-preview-logout-link"><?php echo __( 'Log out', 'clean-login' ); ?></a>	
			<?php if ( $edit_url != '' )
				echo "<a href='$edit_url' class='cleanlogin-preview-edit-link'>". __( 'Edit my profile', 'clean-login' ) ."</a>";
			?>
		</div>
		
		<?php echo get_avatar( $current_user->ID, 128 ); ?>

		<?php // Since 1.1 (show username or not) ?>

		<h4>
			<?php
				if ( $show_user_information ) echo $current_user->user_login;
			 ?>
			<small><?php echo $current_user->user_firstname . ' ' . $current_user->user_lastname; ?></small>
		</h4>
	</div>		
</div>