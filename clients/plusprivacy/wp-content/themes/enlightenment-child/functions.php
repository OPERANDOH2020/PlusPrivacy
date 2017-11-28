<?php
//add_action( 'wp_enqueue_scripts', 'plus_privacy_enqueue_styles' );
/*function plus_privacy_enqueue_styles() {
    wp_enqueue_style( 'parent-style', get_template_directory_uri() . '/style.css' );

    wp_enqueue_style( 'child-style',
        get_stylesheet_directory_uri() . '/style.css',
        array( 'parent-style' ),
        wp_get_theme()->get('Version')
    );
}*/

function install_plusprivacy() {
    wp_register_script('install_plusprivacy', get_stylesheet_directory_uri() . '/js/installPlusPrivacy.js', array('jquery'),'2.2.1', true);
    wp_enqueue_script('install_plusprivacy');
}

add_action( 'wp_enqueue_scripts', 'install_plusprivacy', 999 );


function remove_web_fonts( $html, $handle, $href, $media ){
    if($handle=="enlightenment-web-fonts"){
    return ;
    }
    else{
    return $html;
    }
}

add_filter( 'style_loader_tag',  'remove_web_fonts', 10, 4 );

function the_excerpt_more_link( $excerpt ){
    $post = get_post();
    $excerpt = substr($excerpt,0, -5);
    $excerpt .= ' <a href="'. get_permalink($post->ID) . '">(Read more)</a></p>';
    return $excerpt;
}
add_filter( 'the_excerpt', 'the_excerpt_more_link', 21 );

?>

