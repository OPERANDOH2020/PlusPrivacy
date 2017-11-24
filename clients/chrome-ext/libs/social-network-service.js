var bus = require("bus-service").bus;


var socialNetworkEmailAddressMap = {
    "facebook": {
        type: "email",
        url: "https://www.facebook.com/settings?tab=account",
        regex: '<span class="fbSettingsListItemContent fcg">.*?: <strong>(.*?)<\/strong>'
    },
    "twitter": {
        type: "username",
        url: "https://twitter.com/settings/account",
        regex: '<span class="username u-dir" dir="ltr">@<b class="u-linkComplex-target">(.*?)<\/b><\/span>'
    },
    "linkedin": {
        type: "email",
        url: "https://www.linkedin.com/psettings/email",
        regex: '<div class="address-details"><p class="email-address">(.*?)<\/p><\/div><div class="actions"><span class="is-primary">.*?<\/span><\/div>'
    },
    "google": {
        type: "email",
        url: "https://myaccount.google.com/email",
        regex: '<div class="WAITcd"><h3 class="pYJXie">.*?<\/h3><div class="HrlX8c"><div class="n83bO"><div class="fHYswf"><div class="ia4Bx"><span class="kI49Jc">(.*?)<\/span><\/div><\/div><\/div><div class="Gyrjpb">.*?<\/div><\/div><\/div>',
        group: 1
    },
    "dropbox":{
        type:"email",
        url:"https://www.dropbox.com/account",
        regex:'"email": "(.*?)"'
    }
};

var socialNetworkService = exports.socialNetworkService = {
    getSocialNetworkEmailHandler : function(socialNetwork, callback){
        if(socialNetworkEmailAddressMap[socialNetwork]){
            callback(socialNetworkEmailAddressMap[socialNetwork]);
        }
        else{
            console.error("No such social network!");
        }
    }
};


