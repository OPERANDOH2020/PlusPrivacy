(function($) {
    $.fn.goTo = function() {
        $('html, body').animate({
            scrollTop: $(this).offset().top + 'px'
        }, 'fast');
        return this; // for chaining...
    }
})(jQuery);


var containerClassName = "HICA4c";

var steps = [
    {
        name: "Web & App Activity",
        index: 0
    },
    {
        name: "Location History",
        index: 1
    },
    {
        name: "Device Information",
        index: 2
    },
    {
        name: "Voice & Audio Activity",
        index: 3
    },
    {
        name: "Youtube Search History",
        index: 4
    },
    {
        name: "Youtube Watch History",
        index: 5
    }
];




var stepsContainer = jQuery("<div class='activity_controls_steps'></div>");



var changeIndex = function(index){
jQuery(".HICA4c").addClass("pp_item_overlay");
jQuery(jQuery(".HICA4c")[index]).removeClass("pp_item_overlay");
    jQuery(jQuery(".HICA4c")[index]).goTo();
};


steps.forEach(function(step){
var stepContainer = jQuery("<button>"+step.name+"</button>");
    stepContainer.click(function(){
        changeIndex(step.index);
    });
    stepsContainer.append(stepContainer);
});

$("body").append(stepsContainer);





jQuery(".FaV4Jb").addClass("pp_global_overlay");
jQuery(".pp_item_overlay").addClass("pp_item_overlay");