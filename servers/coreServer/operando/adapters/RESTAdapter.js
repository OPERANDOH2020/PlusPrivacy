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
thisAdapter = core.createAdapter("RESTAdapter");
var http = require("http");

var myCfg = getMyConfig("RESTAdapter");
var serverPort = 7001;

if (myCfg.port != undefined) {
    serverPort = myCfg.port;
}


var server = http.createServer(handler);
server.listen(serverPort);

console.log("RESTAdapter is listening at ", serverPort);


function handler(request, response) {

    dispatch_request(request, response);

    //TODO prepare response;

    response.writeHead(200, {"Content-Type": "application/json"});
    response.write(JSON.stringify({status: "success"}));
    response.end();
}

function dispatch_request(request, response) {

    //TODO start swarming

}


handleSuccessRequest = function (response) {
    //TODO to be implemented
}


handleError = function (response) {
    //TODO to be implemented
}

