console.log("activity_controls_script");
console.log("activity_controls_script2");
Android.dismissDialog();
console.log("activity_controls_script3");
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
            scrollTop: $(this).offset().top - (windowHeight - itemHeight) / 2 + 'px'
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

console.log("log smth1");
var arrowImage = jQuery('<img class="bounce" width="16px" height="16px" src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAGAAAABgCAYAAADimHc4AAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAU5SURBVHhe7ZtLqFVlFMevme/ykdoDpAiiyARTwx43IywziYqyJw2aOGngqEGTRk0kiJCIQAcFJRUlaZE9iOhhWVbXHIjRICIIelipmZlp5/r79rf2xWv3PPf6ztnnnP8P/qzDPt/3X+tbC/Tcs/cZEEIIIYQQQgghhBBCCCGEEEIIIYQQosMMDw+Pr1Qq84nn26W+h15MpicLiXPsUhpIcjv6mUQZvN6BLra3+xLOvxb9ZS0JPdmMzra3/cB0DapYnhG4tA8tsmV9A0cfx7nXxy6Mhut7Cefa0uJgOGbzc3jrd8ISW97zcNbQ/Kezw1eB932GgFHN5p/EAZZdadt6Fs4Zmr8hHrk2rCs2BAwabX4GSw+iQdvec3DE8AHk2XjaxmB9a0NgY1PNz2HLIbTMbHoGjhaa/0I8ZXOwr7khsPhuNjXd/By2HkbLza7r4Uih+S/F07UG+/egaWZZHdbOYGH4T7UQeIQhrDTbroWjTOQcr8ZTFQOfdWZbHRatsPWFwesIWmXWXQdHCM3fEk9THLx2mXV1WHSDrXcBv6PoNrPvGqh5EnrTjuECfkNmXx0WTUcHbY8L+IUh3GkpSg+1TkFvW/lu4Pm4pagNC+9Bx22fC/gdC76WorRQ6lTqfC9W7Qeeu9F0S1MfFj+AvIdwPPhaitJBbdMo88NYrR/4fk1o/os6Nt4fmhZtfAh+6EFLURqoKfzTu93KdAPPXWi2pWkeNt+HvIfwH1pjKToOJYWP3jtidX7gOYTOsjStg8m9yHsIgYcsRceglFnU8UWsypWv0CxLUxzMwl/HxzJrJ7IRVCprLUXbIfdsNGTleOLb/ByKvQv9G3P4gF/gYUvRNsg5F+22MtzA80vCTEvjDwlWI9chBPB8xFIkh1znoD2W2g08dxJmWJp0kCgM4WhM6weej1qKZJDjPPSNpXQDz88J6ZufQ8I7UIohPGYp3MF7HvrWUrmB52eE9jU/h8ThJn2KIdT/1rBJ8LwAfWcp3MDzU0L7m59DAbeiFEN4wlIUBq8L0fdm7Qaen6DGv15IBUWkGsJThHGWpiXwuAj9EB39wHM7OtPSdB6KuQWlGMIzhJaGwN5L0I/RyQ88y9X8HIpahf6xOt3AcyPhNEvTEOy5FP0UHfzA82PCGZamfFDgzehILNcPPJ8jjLc0NWHtAvRL3OkHnh+h+vd1Ow1FphrCJkLNIfD+5azbl21wBM8PCFMtTfmh4JXo71i+H3i+TDjd0oyC60t4v/ADBafSdc3PofCb0OF4DD/w3EyYaGkyuLYU7Y8r/MDzfUL3NT+H4m9MNITXCdkQeD3I6wPZG47gG25Ndm/zczjI8kRD2IZWoD/tkht4vkvo/ubncKAkQ0hBaD6aYqX3Dpzt+rIPgfre6cnm53C469DIL0rKBHWFZ4EmW6m9Cwddhg7FY5cD6nkLTbISe58yDYE6thFGfaztCzj0tRze/RNMM5A/PP/Zf83PoQGDyPVZ1EYh7xuE/m1+Do24hka4/yFVC3JuJaj5OTTkahrSliGQKzzzr+afCo25isYkHQI5XiOo+dWgQUtpUJIh4P2/L/HEGNCoK5DrN5v4hd95TbAUoh40K3y3/0fWveK8gsa8hyBqQNM8hqDmF4EBLEYt3eViX7h71tB9ZFEDGrkI/Rbb2hisf5Gg5ntBMxu+2c66TQQ13xsau7DeENT8xNgQfo3tHg3Xnyeo+amh0ZehkcfMeR1+9PckL9X8dkGzJ9D08ChKeDB4nl0WQgghhBBCCCGEEEIIIYQQQghxMgMDJwBeaHN2d+f1UAAAAABJRU5ErkJggg==">');
var arrowElementDisable = jQuery('<div class="downArrow"></div>');
var arrowElementEnable = jQuery('<div class="downArrow off"></div>');
console.log("log smth2");

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

    Android.setProgressBar(index);

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
            if (steps[currentIndex]['current_setting'] == "on") {
                $("div[jsaction='JIbuQc:Wh8OAb']").append(arrowRightElementDisable[0]);
            }
            else {
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