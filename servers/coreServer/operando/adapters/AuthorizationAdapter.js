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
var HttpStatus = require("http-status-codes");
thisAdapter = core.createAdapter("AuthorizationAdapter");


authorizateAction = function(user_id, resource, action){

    //TODO implement this
    //var authorizationService = loockupForAuthorizationService(user_id, resource, action);
    //return authorizationService.userHasAccess();
    return true;
}

rejectRequest = function(res, statusCode){
    var httpStatusCode = matchStatusCode(statusCode);
    res.status(httpStatusCode);
    res.send({
        error:HttpStatus.getStatusText(httpStatusCode)
    });
}

function matchStatusCode(statusCode){
    //TODO
    //match and return the proper httpStatus
    return httpStatusCode;
}

function loockupForAuthorizationService(user_id, resource, action){
    var properService;
    //TODO
    //find the service which can handle the permissions for the pair (resource, action)

    return properService;
}
