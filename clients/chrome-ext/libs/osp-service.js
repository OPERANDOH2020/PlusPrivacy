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

var desiredOrder = ["google", "facebook","linkedin","twitter"];

var bus = require("bus-service").bus;

var ospService = exports.ospService = {
    getOSPSettings: function (success_callback) {



        function requestListener(){
            console.log();

            if(this.responseText){
                var ospSettings = JSON.parse(this.responseText);
                var orderedOspSettings = {};
                desiredOrder.forEach(function(ospName){
                    if(ospSettings[ospName]){
                        orderedOspSettings[ospName] = ospSettings[ospName];
                    }
                });
                success_callback(orderedOspSettings);
            }
            else{
                console.error("Failed retrieving privacy settings!");
            }

        }

        var xhrReq = new XMLHttpRequest();
        xhrReq.addEventListener("load",requestListener);
        var resourceURI = ExtensionConfig.SERVER_HOST_PROTOCOL+"://"+ExtensionConfig.OPERANDO_SERVER_HOST + ":" + ExtensionConfig.OPERANDO_SERVER_PORT+"/social-networks/privacy-settings"
        xhrReq.open("GET",resourceURI);
        xhrReq.send();


        /*var getOSPSettingsHandler = swarmHub.startSwarm('PrivacyWizardSwarm.js', 'getOSPSettings');
        getOSPSettingsHandler.onResponse("gotOSPSettings",function(swarm){

        });*/
    }
}

bus.registerService(ospService);

