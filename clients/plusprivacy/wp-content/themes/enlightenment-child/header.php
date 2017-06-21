<!DOCTYPE html>
<html <?php language_attributes(); ?>>
<head>
    <?php enlightenment_head(); ?>
    <?php if( ! function_exists( '_wp_render_title_tag' ) ) : ?>
        <title><?php wp_title( '&raquo;', true, 'right' ); ?></title>
    <?php endif; ?>
    <?php wp_head(); ?>
</head>

<body <?php body_class() ?> <?php enlightenment_body_extra_atts(); ?>>
<?php enlightenment_before_page(); ?>
<div id="page" class="site">
    <?php enlightenment_before_header(); ?>
    <header id="masthead" <?php enlightenment_header_class(); ?> <?php enlightenment_header_extra_atts(); ?>>

        <div class="container">
            <?php enlightenment_header(); ?>
            <?php do_action("plusprivacy_head");?>
        </div>
    </header>
    <?php enlightenment_after_header(); ?>
    <?php get_sidebar( 'full-screen' ); ?>
    <?php get_sidebar( 'header' ); ?>
<?php get_sidebar( 'header-secondary' ); ?>