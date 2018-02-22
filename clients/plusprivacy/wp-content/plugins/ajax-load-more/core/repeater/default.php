<?php if(has_category('news')==true) :?>
<li class="news_item">
	<div class="news_date">
    	<span class="date-day-month"><?php the_time("F d");?></span>
    	<span class="date-year"><?php the_time("Y");?></span>
	</div>
	<h3><a href="<?php the_permalink(); ?>"><?php the_title(); ?></a></h3>
    <?php the_excerpt(); ?>
</li>
<?php elseif(has_category('blog')==true):?>
<li<?php if (! has_post_thumbnail() ) { echo ' class="no-img"'; } ?>>
	<?php
   	if ( has_post_thumbnail() ) {
   		the_post_thumbnail('alm-thumbnail');
   	}
	?>
	<h3><a href="<?php the_permalink(); ?>"><?php the_title(); ?></a></h3>
	<p class="entry-meta">
		<?php the_time("F d, Y");?>
	</p>
	<?php the_excerpt(); ?>
</li>
<?php endif;?>