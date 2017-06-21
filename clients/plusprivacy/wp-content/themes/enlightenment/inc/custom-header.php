<?php 

function enlightenment_header_style() {
	if( '' != get_header_image() ) {
		add_filter( 'enlightenment_archive_location_args', 'enlightenment_custom_header_archive_location_args' );
		add_action( 'enlightenment_after_header', 'enlightenment_entry_header_background', 1 );
	}
	
	if( '' != get_header_image() || 'blank' == get_header_textcolor() || get_header_textcolor() != get_theme_support( 'custom-header', 'default-text-color' ) ) : ?>
<style type="text/css">
<?php if( '' != get_header_image() ) : ?>
.archive-header .background-parallax {
	background-image: url(<?php header_image(); ?>);
}
<?php endif;

if( ! is_singular() && get_header_textcolor() != get_theme_support( 'custom-header', 'default-text-color' ) && 'blank' != get_header_textcolor() ) : ?>
.archive-title {
	color: #<?php header_textcolor(); ?>;
}
<?php endif; ?>

<?php if( is_singular() && current_theme_supports( 'enlightenment-post-thumbnail-header' ) ) : ?>
@media (min-width: 768px) {
	.single .site-content,
	.page .site-content {
		margin-top: 0;
	}
}
<?php endif; ?>
</style>
	<?php endif;
}

function enlightenment_custom_header_archive_location_args( $args ) {
	$args['before'] = enlightenment_open_tag( 'div', 'background-parallax' ) . enlightenment_close_tag( 'div' ) . $args['before'];
	return $args;
}

function enlightenment_entry_header_background() {
	if( is_singular() && current_theme_supports( 'enlightenment-post-thumbnail-header' ) ) {
		echo enlightenment_open_tag( 'div', 'archive-header page-header' );
		echo enlightenment_open_tag( 'div', 'background-parallax' ) . enlightenment_close_tag( 'div' );
		echo enlightenment_close_tag( 'div' );
	}
}