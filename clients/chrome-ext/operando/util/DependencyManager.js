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

var DependencyManager = exports.DependencyManager = {
    dependencyRepository : [
        {
            name:"FeedbackProgress",
            path:"/util/FeedbackProgress.js"
        },
        {
            name:"jQuery",
            path:"/ui-libs/jquery-2.1.4.min.js"
        },
        {
            name:"Tooltipster",
            path:"/ui-libs/tooltipster/tooltipster.bundle.min.js"
        },
        {
            name:"UserPrefs",
            path:"/modules/UserPrefs.js"
        },
        {
            name:"DOMElementProvider",
            path:"/modules/DOMElementProvider.js"
        }
    ],

    resolveDependency : function(dependency, resolve){
        var dependencyFound = false;
        for (var i = 0; i < this.dependencyRepository.length; i++) {
            if (this.dependencyRepository[i].name == dependency) {
                dependencyFound = true;
                break;
            }
        }

        if (dependencyFound == true) {
            resolve(this.dependencyRepository[i].path);
        }
        else {
            console.error("Could not load dependency ", dependency);
        }
    }
}


