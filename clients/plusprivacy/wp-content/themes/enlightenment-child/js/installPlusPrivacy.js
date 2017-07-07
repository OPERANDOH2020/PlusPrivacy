jQuery(document).ready(function(){
    jQuery("#download_extension").on("click", function(){
        var self = this;
        if(chrome.app.isInstalled){
            jQuery(self).attr("href","https://chrome.google.com/webstore/detail/boagbmhcbemflaclmnbeebgbfhbegekc");
            jQuery(self).attr("target","_blank");
            jQuery(self).click();
        }
        else{
            chrome.webstore.install("https://chrome.google.com/webstore/detail/boagbmhcbemflaclmnbeebgbfhbegekc", function(){

            }, function(error){

            });
        }
    });
});