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


(function($){
    $.fn.hasAttr = function(name) {
        return this.attr(name) !== undefined;
    };

})(jQuery);


var containerClassName = ".HICA4c";
var wizardContainer = jQuery("<div class='pp_wizard_container'><div class='pp_logo'></div></div>");
var stepsContainer = jQuery("<div class='activity_controls_steps'></div>");
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
    renderWizard();
});

function renderWizard(){

    prepareWizard();
    changeIndex(0);
}

function changeIndex(index){
    jQuery(".pp_wizard_item.active").removeClass("active");
    jQuery(containerClassName).addClass("pp_item_overlay");
    jQuery(jQuery(containerClassName)[index]).removeClass("pp_item_overlay");
    jQuery(jQuery(containerClassName)[index]).goTo();
}

function prepareWizard(){
    steps.forEach(function(step){
        var stepContainer = jQuery("<div class='pp_wizard_item'><div class='step_index'>"+step.index+"</div><div class='step_name'>"+step.name+"</div></div>");
        stepContainer.click(function(){
            changeIndex(step.index);
            stepContainer.addClass("active");
        });
        stepsContainer.append(stepContainer);
    });

    var nextBtn = jQuery("<button>Next</button>");
    var prevBtn = jQuery("<button>Previous</button>");
    var finishBtn = jQuery("<button>Finish</button>");
    var controllers = jQuery("<div class='pp_controller'></div>");

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

    controllers.append(prevBtn);
    controllers.append(nextBtn);
    controllers.append(finishBtn);
    stepsContainer.append(controllers);
}

wizardContainer.append(stepsContainer);
$("body").append(wizardContainer);
jQuery(".FaV4Jb").addClass("pp_global_overlay");
jQuery(containerClassName).addClass("pp_item_overlay");

