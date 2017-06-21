<?php enlightenment_before_sidebar(); ?>
<?php if( is_active_sidebar( enlightenment_dynamic_sidebar() ) ) : ?>
	<div id="sidebar-alt" <?php enlightenment_sidebar_class(); ?> <?php enlightenment_sidebar_extra_atts(); ?>>
		<?php enlightenment_before_widgets(); ?>
		<?php dynamic_sidebar( enlightenment_dynamic_sidebar() ); ?>
		<?php enlightenment_after_widgets(); ?>
	</div>
<?php endif; ?>
<?php enlightenment_after_sidebar(); ?>