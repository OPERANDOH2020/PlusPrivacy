<?php

include("class-crypto-currency.php");

class CryptoCurrencyService
{

    private $crypto_hashes = array(
        "bitcoin" => "hash_bictoin",
        "monero" => "hash_monero",
        "ether" => "hash_ether",
        "bitcoin_cash" => "hash_bitcoin_cash",
        "litecoin" => "hash_litecoin"
    );


    private $availableCryptoCurrencies = array();

    function __construct()
    {
        $bitcoin = new CryptoCurrency("bitcoin", "Bitcoin", $this->getCryptoIcon("bitcoin"), $this->getCryptoQRCode("bitcoin"), $this->crypto_hashes['bitcoin']);
        $monero = new CryptoCurrency("monero", "Monero", $this->getCryptoIcon("monero"), $this->getCryptoQRCode("monero"), $this->crypto_hashes['monero']);
        $ether = new CryptoCurrency("ether", "Ether", $this->getCryptoIcon("ether"), $this->getCryptoQRCode("ether"), $this->crypto_hashes['ether']);
        $bitcoin_cash = new CryptoCurrency("bitcoin_cash","Bitcoin Cash", $this->getCryptoIcon("bitcoin_cash"), $this->getCryptoQRCode("bitcoin_cash"), $this->crypto_hashes['bitcoin_cash']);
        $litecoin = new CryptoCurrency("litecoin","Litecoin", $this->getCryptoIcon("litecoin"), $this->getCryptoQRCode("litecoin"), $this->crypto_hashes['litecoin']);
        array_push($this->availableCryptoCurrencies, $bitcoin, $monero, $ether, $bitcoin_cash, $litecoin);
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
        if($this->crypto_hashes[$name]){
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