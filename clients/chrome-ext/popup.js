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
    var handleClick = function () {
        var abpCtn = document.getElementById("wrapperabp");
        var expandIcon = document.getElementById("expand_abp");
        var apbExpanderBtn = document.getElementById("abp_expand");
        apbExpanderBtn.addEventListener("click", function () {
            abpCtn.classList.toggle('visible');
            expandIcon.classList.toggle('expanded');
        });
    }

    function init() {
        handleClick();
        //close icon
        document.getElementById("close_popup").addEventListener("click", function () {
            window.close();
        });

        function updateI18n(element, i18nkey, stats) {
            i18n.setElementText(element, i18nkey, stats);
        }

        var operandoABP = document.getElementById("operando_abp");
        jQuery(operandoABP).find("span[class^='i18n_']").each(function (index, item) {
            var classList = Array.from(item.classList);
            var i18nClass = classList.find(function (item) {
                return item.substr(0, 5) === "i18n_";
            });
            updateI18n(item, i18nClass.substr(5));
        })
    }

    window.addEventListener("PopupDOMContentLoaded", init, false);

})();