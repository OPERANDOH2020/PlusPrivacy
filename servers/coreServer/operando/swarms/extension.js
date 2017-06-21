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

var extensionSwarming = {

    meta: {
        name: "extension.js"
    },


    vars: {
        isAuthenticated: null,
        resources: [],
        requestIsPossible: false,
        action: null,
        processedResponse: null,
        result: null,
        request:null,
        username:null,
        requestWasFullfilled:null
    },

    start: function () {
        console.log("Swarm extension started");
    },

    registerRequest: function(request, username, token){
        console.log("Request received");
        //TODO processrequest
        this.request = request;
        this.token=token;
        this.username=username;
        this.action="read";
        this.resources="privacySettings";

        this.swarm("authenticate");
    },

    authenticate: {
        node: "GuardianAdapter",
        code: function () {
            this.isAuthenticated = authenticateUser(this.username, this.token);
            if(this.isAuthenticated){
                console.log("User is authenticated. Proceed to authorization");
                this.swarm("authorization");
            }else{
                this.swarm("sendFailure");
            }

        }
    },
    authorization: {
        node: "AuthorizationAdapter",
        code: function () {
            if (this.action != null && this.resources.length > 0) {
                this.requestIsPossible = authorizateAction(this.user, this.resources, this.action);

                if (this.requestIsPossible) {
                    console.log("Action is granted. Proceed to action!")
                    this.swarm("processRequest");
                }

                else {
                    this.swarm("unauthorizeRequest");
                }
            }
        }
    },

    processRequest: {
        node: "PAAdapter",
        code: function () {
            console.log("Ready to process ...");
            this.processedResponse = processAction(this.user, this.resources, this.action);
            if (this.processedResponse.status == "success") {
                this.swarm("sendResponse");
            }
            else {
                this.swarm("sendFailure")
            }
        }
    },

    unauthorizeRequest: {
        node: "AuthorizationAdapter",
        code: function () {
            rejectRequest(403);
            this.swarm('end');
        }
    },

    sendResponse: {
        node: "RESTAdapter",
        code: function () {
            this.requestWasFullfilled = true;
            handleSuccessRequest(this.processedResponse);
            this.swarm("end");
        }
    },

    sendFailure: {
        node: "RESTAdapter",
        code: function () {
            this.requestWasFullfilled = false;
            handleError(this.processedResponse);
            this.swarm("end");
        }
    },

    end: {
        node: "Core",
        code: function () {
            console.log("The end... To be continued...");
            this.home("onClient");

        }
    }

}

extensionSwarming;