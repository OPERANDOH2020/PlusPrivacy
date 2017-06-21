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
var privacy_settings = {

    meta: {
        name: "sn_privacy_settngs.js"
    },

    vars: {
        userId: null,
        sn_privacy_settings:null
    },

    start: function () {

    },

    savePrivacySetting: function(snPrivacySetting){
        if (snPrivacySetting) {
            this.sn_privacy_settings=snPrivacySetting;
            console.log(this.sn_privacy_settings);
        }
    }
}