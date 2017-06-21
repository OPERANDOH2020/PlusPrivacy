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

var core = require("swarmcore");
core.createAdapter("DateAdapter");
var apersistence = require('apersistence');
var container = require("safebox").container;
var flow = require("callflow");
var uuid = require('uuid');

apersistence.registerModel("DateTest", "Redis", {
        dateId:{
            type: "string",
            index: true,
            pk:true
        },
        date: {
            type: "date"
        }
    },
    function (err, model) {
        if (err) {
            console.log(err);
        } else {
        }
    }
);

container.declareDependency("DateTest", ["redisPersistence"], function (outOfService, redisPersistence) {
    if (!outOfService) {
        console.log("Enabling persistence...", redisPersistence);
    } else {
        console.log("Disabling persistence...");
    }
});

addDate = function(date, callback){

    redisPersistence.findById("DateTest",uuid.v1().split("-").join(""), function(err, dateTest){
        dateTest = new Date(date);
        redisPersistence.saveObject(dateTest, callback);
    });

};