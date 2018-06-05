document.getElementsByTagName('html')[0].classList.add("hideContent");
var iframe = null;
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
    notificationId: notificationId,
    originUrl: document.referrer,
    socialNetwork: socialNetwork
};

var datab64 = btoa(JSON.stringify(dataToPassInPopup));

if (document.getElementsByClassName('plusprivacyIframe')[0]) {
    iframe = document.getElementsByClassName('plusprivacyIframe')[0];
    iframe.src = modalSrc + "#" + datab64;
    iframe.parentNode.replaceChild(iframe.cloneNode(), iframe);
}
else {
    var iframe = document.createElement("iframe");
    iframe.className = "plusprivacyIframe";
    document.getElementsByTagName('html')[0].appendChild(iframe);
    iframe.src = modalSrc + "#" + datab64;
}


