jQuery(document).ready(function(){
    jQuery("#download_extension").on("click", function(){
        var self = this;
            jQuery(self).attr("href","https://chrome.google.com/webstore/detail/boagbmhcbemflaclmnbeebgbfhbegekc");
            jQuery(self).attr("target","_blank");
            jQuery(self).click();
    });
});