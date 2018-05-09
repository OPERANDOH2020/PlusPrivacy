var port = chrome.runtime.connect({name: "getSNSettings"});
port.postMessage({status: "waitingCommand"});
port.onMessage.addListener(function (msg) {
    if (msg.command == "scan") {
        var jquery_selector = msg.setting.jquery_selector;
        var setting = null;

        switch (jquery_selector.valueType){
            case "attrValue": setting = jQuery(jquery_selector.element).attr(jquery_selector.attrValue); break;
            case "checkbox": setting = jQuery(jquery_selector.element).attr("checked")?true:false; break;
            case "inner": setting = jQuery(jquery_selector.element).text(); break;
            case "classname": setting = jQuery(jquery_selector.element).hasClass(jquery_selector.attrValue); break;
            case "radio" :setting = jQuery(jquery_selector.element + ":checked").attr("value"); break;
            case "selected": setting = jQuery(jquery_selector.element).attr("value"); break;
            case "length": setting = jQuery(jquery_selector.element).length?jQuery(jquery_selector.element).length:0; break;
            default: setting = null;
        }
        if(setting == undefined || setting == null || setting ===""){
            setting = "Not available";
        }

        console.log(msg.setting.settingKey, setting);
        console.log(msg.setting.settingKey, setting);
        port.postMessage({status: "finishedCommand", settingKey:msg.setting.settingKey, settingValue:setting});
    }
});


