<?php
	if( post_password_required() ) {
		enlightenment_comments_require_password();
		return;
	}
?>

<?php enlightenment_before_comments(); ?>

<?php if( have_comments() ) : ?>
	<section id="comments" class="comments-area">
		<?php enlightenment_comments(); ?>
	</section>
<?php else : ?>
	<?php enlightenment_no_comments(); ?>
<?php endif; ?>

<?php enlightenment_after_comments(); ?>