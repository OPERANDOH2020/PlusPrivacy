<?php
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


// REMOVE WP EMOJI
remove_action('wp_head', 'print_emoji_detection_script', 7);
remove_action('wp_print_styles', 'print_emoji_styles');

remove_action( 'admin_print_scripts', 'print_emoji_detection_script' );
remove_action( 'admin_print_styles', 'print_emoji_styles' );
?>

