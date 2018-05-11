<?php

class CryptoCurrency
{

    public $icon;
    public $key;
    public $name;
    private $qr_code;
    private $hash;

    public function getQrCode()
    {
        return $this->qr_code;
    }

    public function getHash()
    {
        return $this->hash;
    }

    function __construct($_key, $_name, $_icon, $_qr_code, $_hash)
    {
        $this->key = $_key;
        $this->icon = $_icon;
        $this->name = $_name;
        $this->qr_code = $_qr_code;
        $this->hash = $_hash;
    }

}

?>