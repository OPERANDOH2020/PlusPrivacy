(function($) {
    $.fn.goTo = function() {
        var windowHeight = jQuery(window).height();

        var itemHeight = $(this).height();
        $('html, body').animate({
            scrollTop: $(this).offset().top-(windowHeight-itemHeight)/2 + 'px'
        }, 500);
        return this;
    }
})(jQuery);


(function($){
    $.fn.hasAttr = function(name) {
        return this.attr(name) !== undefined;
    };

})(jQuery);

var containerClassName = ".HICA4c";
var arrowImage = jQuery('<img width="24px" height="24px" src="data:image/svg+xml;utf8;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iaXNvLTg4NTktMSI/Pgo8IS0tIEdlbmVyYXRvcjogQWRvYmUgSWxsdXN0cmF0b3IgMTguMC4wLCBTVkcgRXhwb3J0IFBsdWctSW4gLiBTVkcgVmVyc2lvbjogNi4wMCBCdWlsZCAwKSAgLS0+CjwhRE9DVFlQRSBzdmcgUFVCTElDICItLy9XM0MvL0RURCBTVkcgMS4xLy9FTiIgImh0dHA6Ly93d3cudzMub3JnL0dyYXBoaWNzL1NWRy8xLjEvRFREL3N2ZzExLmR0ZCI+CjxzdmcgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiB4bWxuczp4bGluaz0iaHR0cDovL3d3dy53My5vcmcvMTk5OS94bGluayIgdmVyc2lvbj0iMS4xIiBpZD0iQ2FwYV8xIiB4PSIwcHgiIHk9IjBweCIgdmlld0JveD0iMCAwIDMwOS4xNDMgMzA5LjE0MyIgc3R5bGU9ImVuYWJsZS1iYWNrZ3JvdW5kOm5ldyAwIDAgMzA5LjE0MyAzMDkuMTQzOyIgeG1sOnNwYWNlPSJwcmVzZXJ2ZSIgd2lkdGg9IjUxMnB4IiBoZWlnaHQ9IjUxMnB4Ij4KPHBhdGggZD0iTTI0MC40ODEsMTQ5LjI2OEw5My40MSwyLjE5N2MtMi45MjktMi45MjktNy42NzgtMi45MjktMTAuNjA2LDBMNjguNjYxLDE2LjM0ICBjLTEuNDA3LDEuNDA2LTIuMTk3LDMuMzE0LTIuMTk3LDUuMzAzYzAsMS45ODksMC43OSwzLjg5NywyLjE5Nyw1LjMwM2wxMjcuNjI2LDEyNy42MjVMNjguNjYxLDI4Mi4xOTcgIGMtMS40MDcsMS40MDYtMi4xOTcsMy4zMTQtMi4xOTcsNS4zMDNjMCwxLjk4OSwwLjc5LDMuODk3LDIuMTk3LDUuMzAzbDE0LjE0MywxNC4xNDNjMS40NjQsMS40NjQsMy4zODQsMi4xOTcsNS4zMDMsMi4xOTcgIGMxLjkxOSwwLDMuODM5LTAuNzMyLDUuMzAzLTIuMTk3bDE0Ny4wNzEtMTQ3LjA3MUMyNDMuNDExLDE1Ni45NDYsMjQzLjQxMSwxNTIuMTk3LDI0MC40ODEsMTQ5LjI2OHoiIGZpbGw9IiNmZmI0MDAiLz4KPGc+CjwvZz4KPGc+CjwvZz4KPGc+CjwvZz4KPGc+CjwvZz4KPGc+CjwvZz4KPGc+CjwvZz4KPGc+CjwvZz4KPGc+CjwvZz4KPGc+CjwvZz4KPGc+CjwvZz4KPGc+CjwvZz4KPGc+CjwvZz4KPGc+CjwvZz4KPGc+CjwvZz4KPGc+CjwvZz4KPC9zdmc+Cg==" />');
var arrowElementDisable = jQuery('<div class="downArrow bounce"></div>');
var checkForPopup;
var enableDisablePopupCheckInterval;
var arrowElementEnable = jQuery('<div class="downArrow bounce"></div>');

arrowElementDisable.append(jQuery("<span>Click to disable </span>"));
arrowElementDisable.append(arrowImage);
arrowElementEnable.append(jQuery("<span>Click to enable </span>"));
$(arrowImage).clone().appendTo(arrowElementEnable);


var steps = [];
var currentIndex = 0;
var port = chrome.runtime.connect({name: "googleActivityControls"});
port.postMessage({action: "waitingGoogleActivityCommand", data: {status:"waitingGoogleActivityCommand"}});

port.onMessage.addListener(function (msg) {

    msg.settings.forEach(function(setting, index){
        steps.push({
            name:setting.name,
            index:index,
            data:setting.data.setting
        });
    });


    watchCurrentSettings();

});


function watchCurrentSettings(){
    detectCurrentSettings();
    var changeIsNeeded = false;
    for(var i = 0; i<steps.length; i++){
        if(steps[i]['current_setting'] != steps[i]['data']){
            currentIndex = i;
            changeIsNeeded = true;
            changeIndex(currentIndex);
            break;
        }
    }
    if(changeIsNeeded == false){
        port.postMessage({action: "waitingGoogleActivityCommand", data: {status:"wizardFinished"}});
    }
}


function detectCurrentSettings(){
    jQuery(containerClassName).each(function(index, element){

        if($(element).find(".N2RpBe").length>0){
            steps[index]['current_setting']="on";
        }
        else{
            steps[index]['current_setting']="off";

        }
    })
}

function detectCurrentSetting(element){

    if($(element).find(".N2RpBe").length>0){
        var toggleElement = $(element).find(".N2RpBe")[0];
        $(toggleElement).parent().css("position","relative");
            $(toggleElement).parent().prepend(arrowElementDisable[0]);
    }
    else{
        var toggleElement = $(element).find(".LsSwGf.PciPcd")[0];
        $(toggleElement).parent().css("position","relative");
        $(toggleElement).parent().prepend(arrowElementEnable[0]);
    }
}

function changeIndex(index){

    detectCurrentSetting(jQuery(containerClassName)[index]);
    jQuery(containerClassName).addClass("pp_item_overlay");

    jQuery(jQuery(containerClassName)[index]).removeClass("pp_item_overlay");
    jQuery(jQuery(containerClassName)[index]).goTo();
    port.postMessage({action: "waitingGoogleActivityCommand", data: {status:"currentIndex", index:index}});
}


setInterval(function(){
    if(jQuery(".pp_item_overlay").length == 0){

          watchCurrentSettings();
    }
},200);


function enableDisablePopupCheckIntervalFn(){
    enableDisablePopupCheckInterval = setInterval(function(){
        if($("div[jsaction='JIbuQc:Wh8OAb']").length>0){
            if(steps[currentIndex]['current_setting']=="on"){
                $("div[jsaction='JIbuQc:Wh8OAb']").append(arrowElementDisable[0]);
            }
            else{
                $("div[jsaction='JIbuQc:Wh8OAb']").append(arrowElementEnable[0]);
            }
            clearInterval(enableDisablePopupCheckInterval);
            checkForPopupFn();
        }
    },300);
}

function checkForPopupFn(){
    checkForPopup = setInterval(function(){
        if($("div[jsaction='JIbuQc:Wh8OAb']").length ===0){
            enableDisablePopupCheckIntervalFn();
            clearInterval(checkForPopup);
        }
    },300);
}

enableDisablePopupCheckIntervalFn();

jQuery(".FaV4Jb").addClass("pp_global_overlay");
jQuery(containerClassName).addClass("pp_item_overlay");

