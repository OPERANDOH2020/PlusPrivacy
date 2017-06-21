document.getElementsByTagName('html')[0].classList.add("hideContent");
var iframe = document.createElement("iframe");
iframe.src ="chrome-extension://"+extensionId+"/operando/modules/pfb/modal/allow_social_network_modal.html#"+notificationId;
iframe.className="plusprivacyIframe";
document.getElementsByTagName('html')[0].appendChild(iframe);
