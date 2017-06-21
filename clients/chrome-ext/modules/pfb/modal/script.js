$('#myModal').modal();


console.log(window.location.href);
var notificationId = window.location.href.substring(window.location.href.indexOf("#")+1);
var port = chrome.runtime.connect({name: "allowSocialNetworkPopup"});

var registerWithSid = document.getElementById("registerWithSid");
var loginWithSocialNetwork = document.getElementById("loginWithSocialNetwork");

registerWithSid.addEventListener("click",function(){
    port.postMessage({action: "allowSocialNetworkPopup", data: {status:"disallow", notificationId:notificationId}});
});
loginWithSocialNetwork.addEventListener("click",function(){
    port.postMessage({action: "allowSocialNetworkPopup", data: {status:"allow",notificationId:notificationId}});
});
