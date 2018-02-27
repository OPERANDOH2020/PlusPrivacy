console.log("activity_controls_script");

Android.dismissDialog();
showModal();


function showModal() {

    var modal = $('<div class="modal"></div>');
    var modal_content = $('<div class="modal-content"></div>');

    var header = $('<div class="modal-header"><h2>PlusPrivacy Wizard</h2></header>');

    var closeModal = function () {
        $(modal_content).animate({
            opacity: 0, // animate slideUp
            marginTop: '600px'
        }, 'fast', 'linear', function () {
            $(modal).remove();
        });
    };

    modal_content.append(header);

    var modal_body = $('<div class="modal-body"><p>PlusPrivacy needs you to do some clicks to optimize your Google privacy settings</p></div>');
    var letsDoItBtn = $("<button class='orange'>OK, let's do it</button>");
    letsDoItBtn.click(closeModal);
    modal_body.append(letsDoItBtn);
    modal_content.append(modal_body);


    var modal_footer = $('<div class="modal-footer"></div>');
    modal_content.append(modal_footer);

    modal.append(modal_content);
    $("body").append(modal);

    $(modal).css("display", "block");

    var checkModalClick = function (event) {
        if (event.target == modal.get(0)) {

            closeModal();
            window.removeEventListener("click", checkModalClick);
        }
    };
    window.addEventListener("click", checkModalClick);

}


(function ($) {
    $.fn.goTo = function () {
        var windowHeight = jQuery(window).height();

        var itemHeight = $(this).height();
        $('html, body').animate({
            scrollTop: $(this).offset().top-(windowHeight-itemHeight)/2 + 'px'
        }, 500);
        return this;
    }
})(jQuery);


(function ($) {
    console.log("$.fn.hasAttr = function(name) {");
    $.fn.hasAttr = function (name) {
        return this.attr(name) !== undefined;
    };

})($);


var steps = [];
var currentIndex = 0;
var checkForPopup;
var enableDisablePopupCheckInterval;

var containerClassName = ".HICA4c";

var arrowImage = jQuery('<img class="bounce" width="16px" height="16px" src="data:image/png;base64,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">');
var arrowElementDisable = jQuery('<div class="downArrow"></div>');
var arrowElementEnable = jQuery('<div class="downArrow off"></div>');

arrowElementDisable.append(jQuery("<span>Click to pause (recommended) </span>"));
arrowElementDisable.append(arrowImage);
arrowElementEnable.append(jQuery("<span>Click to turn on</span>"));
$(arrowImage).clone().appendTo(arrowElementEnable);

var bounceOverlayEnable = jQuery('<div class="bounceOverlay"></div>');
var bounceOverlayDisable = bounceOverlayEnable.clone();
bounceOverlayEnable.append(arrowElementEnable[0]);
bounceOverlayDisable.append(arrowElementDisable[0]);


var arrowRightImage = jQuery('<img width="16px" height="16px" src="data:image/svg+xml;utf8;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iaXNvLTg4NTktMSI/Pgo8IS0tIEdlbmVyYXRvcjogQWRvYmUgSWxsdXN0cmF0b3IgMTguMC4wLCBTVkcgRXhwb3J0IFBsdWctSW4gLiBTVkcgVmVyc2lvbjogNi4wMCBCdWlsZCAwKSAgLS0+CjwhRE9DVFlQRSBzdmcgUFVCTElDICItLy9XM0MvL0RURCBTVkcgMS4xLy9FTiIgImh0dHA6Ly93d3cudzMub3JnL0dyYXBoaWNzL1NWRy8xLjEvRFREL3N2ZzExLmR0ZCI+CjxzdmcgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiB4bWxuczp4bGluaz0iaHR0cDovL3d3dy53My5vcmcvMTk5OS94bGluayIgdmVyc2lvbj0iMS4xIiBpZD0iQ2FwYV8xIiB4PSIwcHgiIHk9IjBweCIgdmlld0JveD0iMCAwIDMwOS4xNDMgMzA5LjE0MyIgc3R5bGU9ImVuYWJsZS1iYWNrZ3JvdW5kOm5ldyAwIDAgMzA5LjE0MyAzMDkuMTQzOyIgeG1sOnNwYWNlPSJwcmVzZXJ2ZSIgd2lkdGg9IjUxMnB4IiBoZWlnaHQ9IjUxMnB4Ij4KPHBhdGggZD0iTTI0MC40ODEsMTQ5LjI2OEw5My40MSwyLjE5N2MtMi45MjktMi45MjktNy42NzgtMi45MjktMTAuNjA2LDBMNjguNjYxLDE2LjM0ICBjLTEuNDA3LDEuNDA2LTIuMTk3LDMuMzE0LTIuMTk3LDUuMzAzYzAsMS45ODksMC43OSwzLjg5NywyLjE5Nyw1LjMwM2wxMjcuNjI2LDEyNy42MjVMNjguNjYxLDI4Mi4xOTcgIGMtMS40MDcsMS40MDYtMi4xOTcsMy4zMTQtMi4xOTcsNS4zMDNjMCwxLjk4OSwwLjc5LDMuODk3LDIuMTk3LDUuMzAzbDE0LjE0MywxNC4xNDNjMS40NjQsMS40NjQsMy4zODQsMi4xOTcsNS4zMDMsMi4xOTcgIGMxLjkxOSwwLDMuODM5LTAuNzMyLDUuMzAzLTIuMTk3bDE0Ny4wNzEtMTQ3LjA3MUMyNDMuNDExLDE1Ni45NDYsMjQzLjQxMSwxNTIuMTk3LDI0MC40ODEsMTQ5LjI2OHoiIGZpbGw9IiNmZmI0MDAiLz4KPGc+CjwvZz4KPGc+CjwvZz4KPGc+CjwvZz4KPGc+CjwvZz4KPGc+CjwvZz4KPGc+CjwvZz4KPGc+CjwvZz4KPGc+CjwvZz4KPGc+CjwvZz4KPGc+CjwvZz4KPGc+CjwvZz4KPGc+CjwvZz4KPGc+CjwvZz4KPGc+CjwvZz4KPGc+CjwvZz4KPC9zdmc+Cg==" />');
var arrowRightElementDisable = jQuery('<div class="downArrowAfterClick bounceX"></div>');
var arrowRightElementEnable = jQuery('<div class="downArrowAfterClick bounceX off"></div>');

arrowRightElementDisable.append(jQuery("<span>Click to pause (recommended) </span>"));
arrowRightElementDisable.append(arrowRightImage);
arrowRightElementEnable.append(jQuery("<span>Click to turn on</span>"));
$(arrowRightImage).clone().appendTo(arrowRightElementEnable);


applyActivityControlSettings(Android.getActivityControlsSettings());


function applyActivityControlSettings(privacySettingsJsonString) {

    var settings = JSON.parse(privacySettingsJsonString);
    console.log("activityControlsSettings", settings);

    settings.forEach(function (setting, index) {
        steps.push({
            name: setting.name,
            index: index,
            data: setting.data.setting
        });
    });

    watchCurrentSettings();
}


function watchCurrentSettings() {
    detectCurrentSettings();
    var changeIsNeeded = false;
    for (var i = 0; i < steps.length; i++) {
        if (steps[i]['current_setting'] != steps[i]['data']) {
            currentIndex = i;
            changeIsNeeded = true;
            changeIndex(currentIndex);
            break;
        }
    }
    if (changeIsNeeded == false) {
        console.log("changeIsNeeded", changeIsNeeded);
        Android.onFinishedLoadingCallback();
        // port.postMessage({action: "waitingGoogleActivityCommand", data: {status:"wizardFinished"}});
    }
}


function detectCurrentSettings() {

    jQuery(containerClassName).each(function (index, element) {

        if ($(element).find(".N2RpBe").length > 0) {
            steps[index]['current_setting'] = "on";
        }
        else {
            steps[index]['current_setting'] = "off";
        }
    })
}

function detectCurrentSetting(element) {

    console.log("detectCurrentSetting");

    if ($(element).find(".N2RpBe").length > 0) {
        var toggleElement = $(element).find(".N2RpBe")[0];
        $(toggleElement).parent().css("position", "relative");

        // bounceOverlayEnable.append(arrowElementDisable[0]);
        console.log("hyMrOd  iJaZXd", $(toggleElement).parent().parent().parent().parent().parent().parent().children(".M0CMRc"));
        $(toggleElement).parent().parent().parent().parent().parent().parent().children(".M0CMRc").append(bounceOverlayDisable);

    }
    else {
        var toggleElement = $(element).find(".LsSwGf.PciPcd")[0];
        $(toggleElement).parent().css("position", "relative");
        // $(toggleElement).parent().prepend(arrowElementEnable[0]);
        // bounceOverlay.append(arrowElementEnable[0]);
        console.log("hyMrOd  iJaZXd", $(toggleElement).parent().parent().parent().parent().parent().parent().children(".M0CMRc"));
        $(toggleElement).parent().parent().parent().parent().parent().parent().children(".M0CMRc").append(bounceOverlayEnable);
    }
}

function changeIndex(index) {

    console.log("changeIndex", $(containerClassName)[index]);
    detectCurrentSetting($(containerClassName)[index]);
    $(containerClassName).addClass("pp_item_overlay");

    $($(containerClassName)[index]).removeClass("pp_item_overlay");
    $($(containerClassName)[index]).goTo();

    Android.setProgressBar(index, $(containerClassName).length);

    // port.postMessage({action: "waitingGoogleActivityCommand", data: {status:"currentIndex", index:index}});
}


setInterval(function () {
    if ($(".pp_item_overlay").length == 0) {

        watchCurrentSettings();
    }
}, 200);


function enableDisablePopupCheckIntervalFn() {
    var checkItOnce = false;
    enableDisablePopupCheckInterval = setInterval(function () {
        if ($("div[jsaction='JIbuQc:Wh8OAb']").length > 0) {
            if(steps[currentIndex]['current_setting']=="on"){
                $("div[jsaction='JIbuQc:Wh8OAb']").append(arrowRightElementDisable[0]);
            }
            else{
                $("div[jsaction='JIbuQc:Wh8OAb']").append(arrowRightElementEnable[0]);
            }
            clearInterval(enableDisablePopupCheckInterval);
            checkForPopupFn();
        }
        else {
            if (checkItOnce == false) {
                watchCurrentSettings();
            }
            checkItOnce = true;
        }
    }, 200);
}

function checkForPopupFn() {
    checkForPopup = setInterval(function () {
        if ($("div[jsaction='JIbuQc:Wh8OAb']").length === 0) {
            enableDisablePopupCheckIntervalFn();
            clearInterval(checkForPopup);
        }
    }, 300);
}

enableDisablePopupCheckIntervalFn();

// $(".FaV4Jb").addClass("pp_global_overlay");
$(containerClassName).addClass("pp_item_overlay");