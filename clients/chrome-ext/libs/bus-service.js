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


var busActions = {};

var bus = exports.bus = {

    registerAction: function(key, callback){
        if(busActions[key]){
            console.log("Error occurred! An action with ",key+" is already registered!");
        }

        else{
            busActions[key] = callback;
        }
    },

    registerService: function(service){
        var self = this;
        Object.keys(service).forEach(function(key){
            self.registerAction(key, service[key]);
        })
    },

    hasAction: function (actionName) {
        if (busActions[actionName]) {
            return true;
        }
        return false;
    },
    getAction:function(actionName){
        return busActions[actionName];
    }
}
