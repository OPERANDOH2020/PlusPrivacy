<?php
/* The function that creates the HTML on the front-end, based on the parameters
* supplied in the product-catalog shortcode */
function Display_Top_Rated_FAQs($atts) {
    extract( shortcode_atts( array(
                'no_comments' => "",
                'post_count'=>5),
            $atts
        )
    );
    $ReturnString = do_shortcode("[ultimate-faqs post_count=".$post_count." no_comments='" . $no_comments . "' orderby='top_rated']");

		return $ReturnString;
}
add_shortcode("top-rated-faqs", "Display_Top_Rated_FAQs");

?>