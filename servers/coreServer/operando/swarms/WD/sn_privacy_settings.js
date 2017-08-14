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
var privacy_settings_swarming = {


    savePrivacySetting: function(snPrivacySetting){
        if (snPrivacySetting) {
            this.sn_privacy_settings=snPrivacySetting;
            this.swarm("saveSNPrivacySettings");
        }
    },
    saveSNPrivacySettings:{
        node:"WatchDogAdapter",
        code:function(){
            var self = this;
            savePrivacySettings(this.sn_privacy_settings, S(function(err, succeed){
                if(err){
                    self.err = err.message;
                    self.home("error");
                }
                else{
                    delete self.sn_privacy_settings;
                    self.home("success");
                }
            }));
        }
    }
};
privacy_settings_swarming;