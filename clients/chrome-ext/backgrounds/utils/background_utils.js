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
        dependencies.reverse();
        var currentDep = dependencies.pop();
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

function getDomainFromUrl(url){
    return new URL(url).hostname;
}