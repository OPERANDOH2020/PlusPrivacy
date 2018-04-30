/*
 * Copyright (c) 2016 ROMSOFT.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the The MIT License (MIT).
 * which accompanies this distribution, and is available at
 * http://opensource.org/licenses/MIT
 *
 * Contributors:
 *    RAFAEL MASTALERU (ROMSOFT)
 * Initially developed in the context of OPERANDO EU project www.operando.eu
 */

(function () {

    var popupIsDismissed = false;
    var loginIsVisible = false;
    var pfbDeal = null;
    var visibilityWatcherInterval = null;

    chrome.runtime.onMessage.addListener(
        function (request, sender, sendResponse) {
            if (request.pfbDeal) {
                pfbDeal = request.pfbDeal;
                pfbDeal.sendResponse = sendResponse;
                visibilityWatcherInterval = setInterval(function () {
                        visibilityWatcher();
                    }, 300
                );
            }
            return true;
        });

    var visibilityWatcher = function () {

        jQuery(pfbDeal.identifier).each(function (i, element) {

            var self = element;
            if ((jQuery(self).visible()) == true) {
                loginIsVisible = true;
                if (popupIsDismissed == false) {
                    createPfBPopup(self);
                    clearInterval(visibilityWatcherInterval);
                }

            } else {

                var visibleButtons = 0;

                jQuery(pfbDeal.identifier).each(function (i, element) {
                    if (jQuery(element).visible() == true) {
                        visibleButtons++;
                    }
                });

                if (visibleButtons == 0) {
                    loginIsVisible = false;
                    popupIsDismissed = false;
                }
            }
        });
    };


    function createPfBPopup(element) {

        var elementOffset = jQuery(element).offset();
        var elementWidth = jQuery(element).width();
        var elementHeight = jQuery(element).height();

        var offsetLeft = elementOffset.left + elementWidth;
        var offsetTop = elementOffset.top + elementHeight;

        var placement = "right";
        if (offsetLeft + 400 > jQuery(document).width()) {
            placement = "left";
        }
        console.log(pfbDeal);
        var settings = {
            trigger: 'sticky',
            title: 'Privacy for Benefits ',
            content: "<div><h5>"+ pfbDeal.benefit+ "</h5><p>"
            + pfbDeal.description
            + '</p>'
            + '</div>',
            multi: true,
            closeable: true,
            dismissible: true,
            delay: 100,
            padding: true,
            backdrop: true,
            width: 400,
            animation: 'pop',
            placement: placement,
            onAccept:function(element){
                pfbDeal.sendResponse("Deal accepted");
            },

            onHide: function (element) {
                popupIsDismissed = true;
                visibilityWatcherInterval = setInterval(visibilityWatcher, 300);
            }
        };

        jQuery(element).webuiPopover('destroy').webuiPopover(settings);

    }

})();





