jQuery(document).ready(function(){
    jQuery("#download_extension").on("click", function(){
        var self = this;
        if (document.getElementById('plusprivacy-extension-is-installed')) {
            jQuery(self).attr("href","https://chrome.google.com/webstore/detail/boagbmhcbemflaclmnbeebgbfhbegekc");
            jQuery(self).attr("target","_blank");
            jQuery(self).click();
        }
        else{
            if(window.chrome){
                chrome.webstore.install("https://chrome.google.com/webstore/detail/boagbmhcbemflaclmnbeebgbfhbegekc", function(){
                }, function(error){
                });
            }
            else{
                checkInstallation();
            }

        }
    });
});