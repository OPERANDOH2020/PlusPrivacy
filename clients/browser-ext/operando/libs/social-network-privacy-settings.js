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


var observer={
    privacy_setting_saved:{
        success:[],
        error:[]
    }
}


swarmHub.on("sn_privacy_settngs.js", "stored_social_network_success", function (swarm) {
    while (observer.privacy_setting_saved.success.length > 0) {
        var c = observer.privacy_setting_saved.success.pop();
        c();
    }
});


var socialNetworkService = exports.socialNetworkService = {

    saveSocialNetworkSetting: function (sn_setting, success_callback, error_callback) {
        swarmHub.startSwarm('sn_privacy_settngs.js', 'savePrivacySetting', sn_setting);
        observer.privacy_setting_saved.success.push(success_callback);
        observer.privacy_setting_saved.error.push(error_callback);
    }

}