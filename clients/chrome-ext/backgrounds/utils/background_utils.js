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


function insertJavascriptFile(id, file, callback){
    chrome.tabs.executeScript(id, {
        file: file,
        allFrames:true
    }, function () {
        if (chrome.runtime.lastError) {
            console.error(chrome.runtime.lastError.message);
        }
        else {
            if (callback) {
               callback();
            }
        }
    });
}

function insertCSS(id, file){
    chrome.tabs.insertCSS(id, {
        file: file,
        allFrames:true
    });
}

function injectScript(id, file, dependencies, callback) {
    if (dependencies.length > 0) {
        var currentDep = dependencies[0];
        dependencies.splice(0,1);
        DependencyManager.resolveDependency(currentDep, function (depFile) {
            insertJavascriptFile(id, depFile, function () {
                injectScript(id, file, dependencies, callback);
            });
        });
    }
    else {
        insertJavascriptFile(id, file, callback);
    }
}

function domainFromUrl(url) {
    var result;
    var match;
    if (match = url.match(/^(?:https?:\/\/)?(?:[^@\n]+@)?(?:www\.)?([^:\/\n\?\=]+)/im)) {
        result = match[1]
        if (match = result.match(/^[^\.]+\.(.+\..+)$/)) {
            result = match[1];
        }
    }
    return result;
}

function isAllowedToInsertScripts(url) {
    var forbiddenAddresses = ["plusprivacy", "facebook", "twitter", "linkedin", "google"];
    var domain = domainFromUrl(url);
    if (domain == undefined) {
        return false;
    }
    else if (domain.indexOf(".") > 0) {
        domain = domain.substr(0, domain.indexOf("."));
        if (forbiddenAddresses.indexOf(domain) >= 0) {
            return false;
        } else {
            return true;
        }
    } else {
        return false;
    }
}