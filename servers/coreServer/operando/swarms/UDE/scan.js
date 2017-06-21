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

var scanSwarming = {
    meta: {
        name: "scan.js"
    },

    vars: {
        scanResults: [],
        apps: null
    },

    scan: function (apps) {
        this.apps = apps;
        this.swarm("scanApps");
    },

    scanApps: {
        node: "Core",
        code: function () {
            for(var i = 0; i<this.apps.length; i++){
                var app = this.apps[i];
                //dummy scan
                var isThread = Math.random() < 0.5 ? false : true
                app['isThread'] = isThread;
                this.scanResults.push(app);
            }
            this.home("success");
        }
    }

}
scanSwarming;

