document.getElementsByTagName('html')[0].classList.add("hideContent");
var iframe = document.createElement("iframe");
var hostname = window.location.hostname;
var socialNetwork;

switch (true) {
    case hostname.indexOf("google.com") > 0:
        socialNetwork = "Google";
        break;
    case hostname.indexOf("facebook.com") > 0:
        socialNetwork = "Facebook";
        break;
    case hostname.indexOf("twitter.com") > 0:
        socialNetwork = "Twitter";
        break;
    case hostname.indexOf("linkedin.com") > 0:
        socialNetwork = "Linkedin";
        break;
}

var dataToPassInPopup = {
    notificationId : notificationId,
    originUrl : document.referrer,
    socialNetwork: socialNetwork
};

var datab64 = btoa(JSON.stringify(dataToPassInPopup));
iframe.src ="chrome-extension://"+extensionId+"/operando/modules/pfb/modal/allow_social_network_modal.html#"+datab64;
iframe.className="plusprivacyIframe";
document.getElementsByTagName('html')[0].appendChild(iframe);
