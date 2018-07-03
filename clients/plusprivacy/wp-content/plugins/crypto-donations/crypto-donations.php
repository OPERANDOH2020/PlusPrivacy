<?php
/**
 * Plugin Name: Crypto Donations
 * Plugin URI: http://plusprivacy.com
 * Description: Plugin for receiving cryptoDonations
 * Version: 1.0.0
 * Author: Rafael Mastaleru
 * License: MIT
 */


include("classes/class-crypto-currency-service.php");


add_shortcode('crypto-donation-button', 'crypto_donation_button');

wp_register_script( 'crypto-donate-js', plugins_url( '/assets/js/crypto-donate.js', __FILE__ ));


function crypto_donation_button($atts)
{
    wp_enqueue_script( 'crypto-donate-js' );
    $cryptoCurrencyService = new CryptoCurrencyService();

    if ($atts['cryptocurrency']) {
        if ($cryptoCurrencyService->hasCryptoCurrency($atts['cryptocurrency'])) {
            $cryptoCurrency = $cryptoCurrencyService->getCryptoCurrency($atts['cryptocurrency']);
            $modalId = "modal-".md5(uniqid(rand(), true));
            ob_start();
            include("assets/templates/coin-template.php");
            $template_content = ob_get_clean();
            return $template_content;
        } else {
            return "Cryptocurrency ".$atts['cryptocurrency']." is not supported!";
        }
    } else {
        return "Cryptocurrency should be defined";
    }

}

?>