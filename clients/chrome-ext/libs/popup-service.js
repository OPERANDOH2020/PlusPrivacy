/*
 * Copyright (c) 2017 ROMSOFT.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the The MIT License (MIT).
 * which accompanies this distribution, and is available at
 * http://opensource.org/licenses/MIT
 *
 * Contributors:
 *    RAFAEL MASTALERU (ROMSOFT)
 * Initially developed in the context of OPERANDO EU project www.operando.eu
 */

var bus = require("bus-service").bus;

var stateData = {};
var popupService = exports.popupService = {

    updatePopupStateData : function(data){
        stateData = data;
        console.log(data.user);
    },
    getPopupStateData : function(callback){
        callback(stateData);
        console.log(stateData);
    }

};

bus.registerService(popupService);
