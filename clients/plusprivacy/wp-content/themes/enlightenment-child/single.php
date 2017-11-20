<?php
get_header();?>
	<div id="content" class="site-content">
		<?php get_sidebar( 'main' ); ?>
		<?php get_sidebar( 'main-secondary' ); ?>
		<?php enlightenment_before_content(); ?>
		<main id="primary" <?php enlightenment_content_class(); ?> <?php enlightenment_content_extra_atts(); ?>>
			<?php get_sidebar( 'content' ); ?>
			<?php get_sidebar( 'content-secondary' ); ?>
			<?php //enlightenment_content(); ?>

			<div class="content-wrapper">

			<header class="entry-header">
            <h1 class="entry-title" itemprop="headline">
            <?php the_title(); ?>
            </h1>
            <div class="entry-meta">
              <?php
                 	enlightenment_entry_date();

              ?>
            </header>

            <?php

            		while( have_posts() ) {
            			the_post();
            			$enlightenment_post_counter++;
            			do_action( 'enlightenment_before_entry' );
            			$post_class = implode( ' ', get_post_class() ) . ' ' . $args['container_class'];
            			$post_class = apply_filters( 'enlightenment_post_class-count-' . $enlightenment_post_counter, $post_class );
            			echo enlightenment_open_tag( $args['container'], $post_class, $args['container_id'], $args['container_extra_atts'] );

            				do_action( 'enlightenment_entry_content', '(more&hellip;)' );
            				do_action( 'enlightenment_after_entry_content' );
            				do_action( 'enlightenment_before_entry_footer' );
            			echo enlightenment_close_tag( $args['container'] );
            			do_action( 'enlightenment_after_entry' );
            		}

            ?>

			</div>
			<?php get_sidebar( 'after-content' ); ?>
			<?php get_sidebar( 'after-content-secondary' ); ?>
		</main>
		<?php enlightenment_after_content(); ?>
		<?php get_sidebar( 'after-main' ); ?>
		<?php get_sidebar( 'after-main-secondary' ); ?>
	</div>
<?php get_footer(); ?>