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

var core = require("swarmcore");
thisAdapter = core.createAdapter("GuardianAdapter");

/**
 * This will authenticate the user using his username and then generated token.
 * @param username
 * @param token
 * @returns {boolean}
 */
authenticateUser = function (username, token) {
    if(username == "RafaelMastaleru")
        return true;


    if (tokenIsValid(token)) {
        //TODO
        //authenticate user using username and token
        //
    }
    else {
        return false;
    }
}

function tokenIsValid(token) {
    //TODO
    //Implement token check
    return true;
}

