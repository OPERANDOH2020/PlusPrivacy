<?php

include("class-crypto-currency.php");
include("util/functions.php");

class CryptoCurrencyService
{

    private $availableCryptoCurrencies = array();
    private $existingCryptoCurrencies = array();

    function __construct()
    {
        $string = file_get_contents(plugins_url('../config/cryptocurrencies.json', __FILE__));
        $crypto_currencies_json = json_decode($string, true);

        foreach ($crypto_currencies_json as $crypto_currency => $crypto_raw) {
            $crypto_key = $crypto_raw['key'];
            $crypto_name = $crypto_raw['name'];
            $crypto_address = $crypto_raw['address'];
            $crypto_icon = $this->getCryptoIcon($crypto_key);
            $crypto_qr_code = $this->getCryptoQRCode($crypto_key);
            $new_crypto_currency =  new  CryptoCurrency($crypto_key,$crypto_name,$crypto_icon,$crypto_qr_code,$crypto_address);
            array_push($this->availableCryptoCurrencies, $new_crypto_currency);
            array_push($this->existingCryptoCurrencies, $crypto_key);
        }

    }

    private function getCryptoIcon($crypto)
    {
        return plugins_url('../images/icons/' . $crypto . '.png', __FILE__);
    }

    private function getCryptoQRCode($crypto)
    {
        return plugins_url('../images/qr_codes/' . $crypto . '.png', __FILE__);
    }

    public function hasCryptoCurrency($name){

        if(arrayContainsElement($this->existingCryptoCurrencies,$name)){
            return true;
        }
        return false;
    }

    public function getCryptoCurrency($name)
    {
        foreach($this->availableCryptoCurrencies as $crypto_currency){
            if($crypto_currency->key === $name){
                return $crypto_currency;
            }
        }
        return null;
    }

}

?>