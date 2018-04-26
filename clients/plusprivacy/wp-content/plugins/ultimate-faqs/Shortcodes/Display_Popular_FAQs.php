<?php
/* The function that creates the HTML on the front-end, based on the parameters
* supplied in the product-catalog shortcode */
function Display_Popular_FAQs($atts) {
    extract( shortcode_atts( array(
                'no_comments' => "",
                'post_count'=>5),
            $atts
        )
    );
    $ReturnString = do_shortcode("[ultimate-faqs post_count=".$post_count." no_comments='" . $no_comments . "' orderby='popular']");

		return $ReturnString;
}
add_shortcode("popular-faqs", "Display_Popular_FAQs");
