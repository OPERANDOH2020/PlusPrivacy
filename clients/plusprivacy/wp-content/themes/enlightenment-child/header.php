<!DOCTYPE html>
<html <?php language_attributes(); ?>>
<head>
    <?php enlightenment_head(); ?>
    <?php if( ! function_exists( '_wp_render_title_tag' ) ) : ?>
        <title><?php wp_title( '&raquo;', true, 'right' ); ?></title>
    <?php endif; ?>
    <?php wp_head(); ?>
    <link rel="chrome-webstore-item" href="https://chrome.google.com/webstore/detail/boagbmhcbemflaclmnbeebgbfhbegekc">
    <?php if ($_SERVER['SERVER_NAME']=="plusprivacy.com"):?>
    	<script>
      (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
      (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
      m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
      })(window,document,'script','https://www.google-analytics.com/analytics.js','ga');

      ga('create', 'UA-92882724-1', 'auto');
      ga('send', 'pageview');
    </script>
    <?php endif; ?>
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