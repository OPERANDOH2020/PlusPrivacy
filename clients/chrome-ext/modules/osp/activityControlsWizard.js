(function($) {
    $.fn.goTo = function() {
        var windowHeight = jQuery(window).height();

        var itemHeight = $(this).height();
        $('html, body').animate({
            scrollTop: $(this).offset().top-(windowHeight-itemHeight)/2 + 'px'
        }, 300);
        return this;
    }
})(jQuery);


(function($){
    $.fn.hasAttr = function(name) {
        return this.attr(name) !== undefined;
    };

})(jQuery);

var containerClassName = ".HICA4c";
var arrowImage =jQuery('<img width="24px" height="24px" src="data:image/svg+xml;utf8;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iaXNvLTg4NTktMSI/Pgo8IS0tIEdlbmVyYXRvcjogQWRvYmUgSWxsdXN0cmF0b3IgMTguMC4wLCBTVkcgRXhwb3J0IFBsdWctSW4gLiBTVkcgVmVyc2lvbjogNi4wMCBCdWlsZCAwKSAgLS0+CjwhRE9DVFlQRSBzdmcgUFVCTElDICItLy9XM0MvL0RURCBTVkcgMS4xLy9FTiIgImh0dHA6Ly93d3cudzMub3JnL0dyYXBoaWNzL1NWRy8xLjEvRFREL3N2ZzExLmR0ZCI+CjxzdmcgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiB4bWxuczp4bGluaz0iaHR0cDovL3d3dy53My5vcmcvMTk5OS94bGluayIgdmVyc2lvbj0iMS4xIiBpZD0iQ2FwYV8xIiB4PSIwcHgiIHk9IjBweCIgdmlld0JveD0iMCAwIDMwOS4xNDMgMzA5LjE0MyIgc3R5bGU9ImVuYWJsZS1iYWNrZ3JvdW5kOm5ldyAwIDAgMzA5LjE0MyAzMDkuMTQzOyIgeG1sOnNwYWNlPSJwcmVzZXJ2ZSIgd2lkdGg9IjUxMnB4IiBoZWlnaHQ9IjUxMnB4Ij4KPHBhdGggZD0iTTI0MC40ODEsMTQ5LjI2OEw5My40MSwyLjE5N2MtMi45MjktMi45MjktNy42NzgtMi45MjktMTAuNjA2LDBMNjguNjYxLDE2LjM0ICBjLTEuNDA3LDEuNDA2LTIuMTk3LDMuMzE0LTIuMTk3LDUuMzAzYzAsMS45ODksMC43OSwzLjg5NywyLjE5Nyw1LjMwM2wxMjcuNjI2LDEyNy42MjVMNjguNjYxLDI4Mi4xOTcgIGMtMS40MDcsMS40MDYtMi4xOTcsMy4zMTQtMi4xOTcsNS4zMDNjMCwxLjk4OSwwLjc5LDMuODk3LDIuMTk3LDUuMzAzbDE0LjE0MywxNC4xNDNjMS40NjQsMS40NjQsMy4zODQsMi4xOTcsNS4zMDMsMi4xOTcgIGMxLjkxOSwwLDMuODM5LTAuNzMyLDUuMzAzLTIuMTk3bDE0Ny4wNzEtMTQ3LjA3MUMyNDMuNDExLDE1Ni45NDYsMjQzLjQxMSwxNTIuMTk3LDI0MC40ODEsMTQ5LjI2OHoiIGZpbGw9IiNmZmI0MDAiLz4KPGc+CjwvZz4KPGc+CjwvZz4KPGc+CjwvZz4KPGc+CjwvZz4KPGc+CjwvZz4KPGc+CjwvZz4KPGc+CjwvZz4KPGc+CjwvZz4KPGc+CjwvZz4KPGc+CjwvZz4KPGc+CjwvZz4KPGc+CjwvZz4KPGc+CjwvZz4KPGc+CjwvZz4KPGc+CjwvZz4KPC9zdmc+Cg==" />');
var arrowElement = jQuery('<div class="downArrow bounce"></div>');
arrowElement.append(jQuery("<span>Click to disable </span>"));
arrowElement.append(arrowImage);

var safeSettingFeedback = $('<div class="pp_safe_setting"><span>This setting is privacy friendly</span><svg xmlns="http://www.w3.org/2000/svg" width="26" height="26" viewBox="-263.5 236.5 26 26"><g class="svg-success"><circle cx="-250.5" cy="249.5" r="12"/><path d="M-256.46 249.65l3.9 3.74 8.02-7.8"/></g></svg></div>');

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

/*function renderWizard(){

    prepareWizard();
    changeIndex(0);
}*/

function detectCurrentSetting(element){

    if($(element).find(".N2RpBe").length>0){
        var toggleElement = $(element).find(".N2RpBe")[0];
        $(toggleElement).parent().css("position","relative");
            $(toggleElement).parent().prepend(arrowElement[0]);

    }
    else{

        var toggleElement = $(element).find(".LsSwGf.PciPcd")[0];

        $(toggleElement).parent().css("position","relative");
        $(toggleElement).parent().prepend(safeSettingFeedback);

    }
}



function changeIndex(index){

    detectCurrentSetting(jQuery(containerClassName)[index]);
    jQuery(containerClassName).addClass("pp_item_overlay");

    jQuery(".item_checked").removeClass("item_checked");
    for(var i = 0; i < index; i++){
        jQuery(".pp_wizard_item_"+i).addClass("item_checked");
    }

    jQuery(jQuery(containerClassName)[index]).removeClass("pp_item_overlay");
    jQuery(jQuery(containerClassName)[index]).goTo();

    port.postMessage({action: "waitingGoogleActivityCommand", data: {status:"currentIndex", index:index}});
}


setInterval(function(){
    if(jQuery(".pp_item_overlay").length == 0){

          watchCurrentSettings();
    }
},200);

/*function prepareWizard(){
    steps.forEach(function(step){
        var stepContainer = jQuery("<div class='pp_wizard_item pp_wizard_item_"+step.index+"'><div class='step_index'>&nbsp;</div><div class='step_name'>"+step.name+"</div></div>");
        stepContainer.click(function(){
            changeIndex(step.index);
        });
        stepsItems.append(stepContainer);
    });


    prevBtn.click(function(){
        currentIndex --;
        changeIndex(currentIndex);

        if(currentIndex === 0){
            $(this).attr("disabled","disabled");
        }

        if($(nextBtn).hasAttr("disabled")){
            $(nextBtn).removeAttr("disabled");
        }
    });

    nextBtn.click(function(){
        currentIndex ++;
        changeIndex(currentIndex);
        if(currentIndex === steps.length-1){
            $(this).attr("disabled","disabled");
        }
        if($(prevBtn).hasAttr("disabled")){
            $(prevBtn).removeAttr("disabled");
        }
    });

    finishBtn.click(function(){
        port.postMessage({action: "waitingGoogleActivityCommand", data: {status:"wizardFinished"}});
    })


}*/
/*stepsContainer.append(stepsItems);
wizardContainer.append(stepsContainer);*/
jQuery(".FaV4Jb").addClass("pp_global_overlay");
jQuery(containerClassName).addClass("pp_item_overlay");

