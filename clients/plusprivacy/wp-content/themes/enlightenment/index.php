<?php
get_header();?>

	<div id="content" class="site-content">
		<?php get_sidebar( 'main' ); ?>
		<?php get_sidebar( 'main-secondary' ); ?>
		<?php enlightenment_before_content(); ?>
		<main id="primary" <?php enlightenment_content_class(); ?> <?php enlightenment_content_extra_atts(); ?>>
			<?php get_sidebar( 'content' ); ?>
			<?php get_sidebar( 'content-secondary' ); ?>
			<?php enlightenment_content(); ?>
			<?php get_sidebar( 'after-content' ); ?>
			<?php get_sidebar( 'after-content-secondary' ); ?>
		</main>
		<?php enlightenment_after_content(); ?>
		<?php get_sidebar( 'after-main' ); ?>
		<?php get_sidebar( 'after-main-secondary' ); ?>
	</div>
<?php get_footer(); ?>