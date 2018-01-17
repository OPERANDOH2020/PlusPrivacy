(function($) {
    $.fn.goTo = function() {
        var windowHeight = jQuery(window).height();

        var itemHeight = $(this).height();
        $('html, body').animate({
            scrollTop: $(this).offset().top-(windowHeight-itemHeight)/2 + 'px'
        }, 400);
        return this;
    }
})(jQuery);


var containerClassName = ".HICA4c";
var stepsContainer = jQuery("<div class='activity_controls_steps'></div>");
var steps = [];
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
    renderWizard();
});

function renderWizard(){
    var changeIndex = function(index){
        jQuery(containerClassName).addClass("pp_item_overlay");
        jQuery(jQuery(containerClassName)[index]).removeClass("pp_item_overlay");
        jQuery(jQuery(containerClassName)[index]).goTo();
    };

    steps.forEach(function(step){
        var stepContainer = jQuery("<button>"+step.name+"</button>");
        stepContainer.click(function(){
            changeIndex(step.index);
        });
        stepsContainer.append(stepContainer);
    });
}

$("body").append(stepsContainer);
jQuery(".FaV4Jb").addClass("pp_global_overlay");
jQuery(containerClassName).addClass("pp_item_overlay");