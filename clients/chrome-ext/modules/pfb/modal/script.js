$('#myModal').modal();


console.log(window.location.href);
var base64data = window.location.href.substring(window.location.href.indexOf("#") + 1);
var data = JSON.parse(atob(base64data));
console.log(data);
var offer;
var parentTab;
var cancelShowOffer = false;
document.body.innerHTML = document.body.innerHTML.split("{{SOCIAL_NETWORK}}").join(data.socialNetwork);

var port = chrome.runtime.connect({name: "allowSocialNetworkPopup"});

var registerWithSid = document.getElementById("registerWithSid");
var loginWithSocialNetwork = document.getElementById("loginWithSocialNetwork");

registerWithSid.addEventListener("click", function () {

    port.postMessage({
        action: "allowSocialNetworkPopup",
        data: {
            status: "disallow",
            notificationId: data.notificationId
        }
    });
});
loginWithSocialNetwork.addEventListener("click", function () {
    port.postMessage({
        action: "allowSocialNetworkPopup", data: {
            status: "allow",
            notificationId: data.notificationId,
            offerId: offer?offer.offerId:parentTab
        }
    });
    port.postMessage({action: "acceptPfbDeal", data: offer.offerId});
});

port.postMessage({action: "getLastVisitedUrl", data: data.notificationId});


function checkForOffers(message) {
    parentTab = message.data;
    port.postMessage({action: "getWebsiteDeal", data: {tabUrl: message.data}});
}

function getWebsiteDeal(message) {
    console.log(message);
    if (message.status === "success") {
        offer = message.data;
        checkOffer(offer.offerId);
    }
    else {
        $("#loginWithSocialNetwork").removeAttr("disabled");

        setTimeout(function(){
            if(offer === undefined){
                cancelShowOffer = true;
                $("#loader").hide();
                $("#info_noOffers").show();
                $("#loginWithSocialNetwork").removeAttr("disabled");
            }
        },2000);

    }
}

function showOffer(offer) {

    $("#loader").hide();
    $($("offerName")[0]).text(offer.name);
    $($("offerDescription")[0]).text(offer.description);
    $("#offer_logo").attr("src", "data:image/png;base64," + offer.logo);

    $("#info_hasOffers").show();
    $("#offerDetails").show();

    $("#accept_offer").change(function () {
        if (this.checked) {
            $("#loginWithSocialNetwork").removeAttr("disabled");
        }
        else {
            $("#loginWithSocialNetwork").attr("disabled", "disabled");
        }
    });
}

function checkOffer(offerId) {
    port.postMessage({action: "offerIsAccepted", data: offerId});
}

function checkOfferResponse(response) {
    if (response.data === true) {
        port.postMessage({
            action: "allowSocialNetworkPopup", data: {
                status: "allow",
                notificationId: data.notificationId,
                offerId: offer.offerId
            }
        });
    }
    else {

        if(cancelShowOffer === false){
            showOffer(offer);
        }

    }
}

port.onMessage.addListener(function (data) {
    console.log(data);
    switch (data.action) {
        case "getLastVisitedUrl":
            checkForOffers(data.message);
            break;
        case "getWebsiteDeal":
            getWebsiteDeal(data.message);
            break;
        case "offerIsAccepted":
            checkOfferResponse(data.message);
            break;
    }
});