<?php


function arrayContainsElement($arr, $element){
    foreach($arr as $el){
        if($el == $element){
            return true;
        }
    }
    return false;
}

?>