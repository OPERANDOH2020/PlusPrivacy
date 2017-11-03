/**
 * Created by ciprian on 8/25/17.
 */

var container = require("safebox").container;
var rulesRegistered = false;
var persistence;
var geolocator = require('geoip-lite');
var flow = require('callflow');
var analyticRules = [
    {
        "swarmName":"analytics.js",
        "swarmConstructor":"registrationWithIp",
        "analytics":onRegistration,
        "toBeLogged":function(meta,args){
            return "register with "+args[0]; //return email
        }
    },
    {
        "swarmName":"login.js",
        "swarmConstructor":"userLogin",
        "argumentPatterns": function(meta,args){
            return args[0]!="guest@operando.eu"; //all logins but the logins of guest...
        },
        "analytics":onLogin,
        "toBeLogged":function(meta,args){
            return "login with "+args[0]; //return email
        }
    },
    {
        "swarmName":"login.js",
        "swarmConstructor":"logout",
        "argumentPatterns":function(meta,args){
            return args[0]!="guest@operando.eu";
        },
        "analytics":onLogout,
        "toBeLogged":function(meta,args){
            return "logged out with "+meta.userId; 
        }
    },


    {
        "swarmName":"identity.js",
        "swarmConstructor":"createIdentity",
        "analytics":incField('nrOfAltIdentities',1),
        "toBeLogged":function(meta,args){
            return "User "+meta.userId+" created an identity";
        }
    },
    {
        "swarmName":"identity.js",
        "swarmConstructor":"removeIdentity",
        "analytics":incField('nrOfAltIdentities',-1),
        "toBeLogged":function(meta,args){
            return "User "+meta.userId+" removed an identity";
        }
    },


    {
        "swarmName":"UserPreferences.js",
        "swarmConstructor":"removePreferences",
        "analytics":setField('didSingleClickPrivacy'),
        "toBeLogged":function(meta,args){
            return "User "+meta.userId+" removed preferences";
        }
    },
    {
        "swarmName":"UserPreferences.js",
        "swarmConstructor":"removePreferences",
        "analytics":updateSocialNetworks(),
        "toBeLogged":function(meta,args){
            return "User "+meta.userId+" userd PP to update SN "+args[0];
        }
    },

    {
        "swarmName":"UserPreferences.js",
        "swarmConstructor":"saveOrUpdatePreferences",
        "argumentPatterns":function(meta,args){
            return args[0] === 'abp-settings'
        },
        "analytics": setField('changedABSettings')        ,
        "toBeLogged":function(meta,args){
            return "User "+meta.userId+" changed AB settings";
        }
    },
    {
        "swarmName":"UserPreferences.js",
        "swarmConstructor":"saveOrUpdatePreferences",
        "argumentPatterns":function(meta,args){
            return args[0] !== 'abp-settings'
        },
        "analytics": setField('manuallyChangedSNSettings'),
        "toBeLogged":function(meta,args){
            return "User "+meta.userId+" manually changed SN settings";
        }
    },
    {
        "swarmName":"UserPreferences.js",
        "swarmConstructor":"saveOrUpdatePreferences",
        "argumentPatterns":function(meta,args){
            return args[0] !== 'abp-settings'
        },
        "analytics": updateSocialNetworks('reset'),
        "toBeLogged":function(meta,args){
            return "User "+meta.userId+" manually changed "+args[0]+" settings";
        }
    },
    {
        "swarmName":"analytics.js",
        "swarmConstructor":"actionPerformed",
        "argumentPatterns":function(meta,args){
            return args[0] === "changedAppsOrExtensions"
        },
        "analytics": setField('changedAppsOrExtensions'),
        "toBeLogged":function(meta,args){
            return "User "+meta.userId+" changed apps or extensions";
        }
    },
    {
        "swarmName":"notification.js",
        "swarmConstructor":"registerInZone",
        "argumentPatterns":function(meta,args){
            return args[0] === "FEEDBACK_SUBMITTED"
        },
        "analytics": setField('filledFeedback'),
        "toBeLogged":function(meta,args){
            return "User "+meta.userId+" submitted feedback";
        }
    },
    {
        "swarmName":"UDESwarm.js",
        "swarmConstructor":"registerDeviceId",
        "argumentPatterns":function(meta,args){
            return args[1] !== true;  //a device is registered when a user logs in on that device
        },
        "analytics": onDeviceRegistration,
        "toBeLogged":function(meta,args){
            return "User "+meta.userId+" logged in device "+args[0]+" of type "+tenantPlatformAnalyticsMap[meta.tenantId].name;
        }
    },
    {
        "swarmName":"UDESwarm.js",
        "swarmConstructor":"uninstalledOnDevice",
        "analytics": onUninstall,
        "toBeLogged":function(meta,args){
            return "Plusprivacy uninstalled on device "+args[0];
        }
    }
];

const tenantPlatformAnalyticsMap = {
    'chromeBrowserExtension':{
        name:"ChromeExtension",
        loggedIn:"loggedInChrome",
        uses:"usesChrome",
        lastLogin:"lastLoginInChrome",
        totalLoginLength:"totalLoginLengthInChrome",
        lastLoginLength:"lastLoginLengthInChrome"
    },
    "ios":{
        name:"iOS",
        loggedIn:"loggedIniOS",
        uses:"usesiOS",
        lastLogin:"lastLoginIniOS",
        totalLoginLength:"totalLoginLengthIniOS",
        lastLoginLength:"lastLoginLengthIniOS"
    },
    "androidApp":{
        name:"Android",
        loggedIn:"loggedInAndroid",
        uses:"usesAndroid",
        lastLogin:"lastLoginInAndroid",
        totalLoginLength:"totalLoginLengthInAndroid",
        lastLoginLength:"lastLoginLengthInAndroid"
    }
};
const preferenceKeyToSN = { //    When GooglePlus and Youtube are available you need to add those too!
    "linkedin":"LinkedIn",
    'facebook':'Facebook',
    'twitter':"Twitter"
}

container.declareDependency("rulesRegistered",['mysqlPersistence','analytics'],function(outOfService,mysqlPersistence){
    if(!outOfService && !rulesRegistered){
        rulesRegistered = true;
        persistence = mysqlPersistence;
        setupTables(function(err,result){
            if(err){
                console.error("Could not setup the analytics rules.Error: ",err)
            }else{
                analyticRules.forEach(registerAnalyticsRule);
            }
        })
    }
});

function setupTables(callback){
    var models = [{
        modelName:"UserAnalytics",
        structure:{
            userId:{
                type:"string",
                pk:true,
                length:255
            },
            email:{
                type:"string",
                length:255
            },
            country: {
                type: "string",
                length: 255,
                default: 'UNKNOWN'
            },
            signupDate:{
                type:"datetime"
            },
            usesiOS:{
                type:"boolean",
                default:false
            },
            loggedIniOS:{
                type:"boolean",
                default:false
            },
            totalLoginLengthIniOS:{
                type:"int",
                default:0
            },
            lastLoginIniOS:{
                type:"datetime"
            },
            lastLoginLengthIniOS:{
                type:"int",
                default:0
            },
            usesAndroid:{
                type:"boolean",
                default:false
            },
            loggedInAndroid:{
                type:"boolean",
                default:false
            },
            totalLoginLengthInAndroid:{
                type:"int",
                default:0
            },
            lastLoginInAndroid:{
                type:"datetime"
            },
            lastLoginLengthInAndroid:{
                type:"int",
                default:0
            },
            usesChrome:{
                type:"boolean",
                default:false
            },
            loggedInChrome:{
                type:"boolean",
                default:false
            },
            totalLoginLengthInChrome:{
                type:"int",
                default:0
            },
            lastLoginInChrome:{
                type:"datetime"
            },
            lastLoginLengthInChrome:{
                type:"int",
                default:0
            },


            didSingleClickPrivacy:{
                type:"boolean",
                default:false
            },
            manuallyChangedSNSettings:{
                type:"boolean",
                default:false
            },
            Facebook:{
                type:"boolean",
                default:false
            },
            LinkedIn:{
                type:"boolean",
                default:false
            },
            Twitter:{
                type:"boolean",
                default:false
            },
            GooglePlus:{
                type:"boolean",
                default:false
            },
            Youtube:{
                type:"boolean",
                default:false
            },

            filledFeedback:{
                type:"boolean",
                default:false
            },
            nrOfAltIdentities:{
                type:"int",
                default:0
            },
            changedABSettings:{
                type:"boolean",
                default:false
            },
            changedAppsOrExtensions:{
                type:"boolean",
                default:false
            },
            lastUse:{
                type:'datetime'
            }
        }
    },{
        modelName:"DeviceAnalytics",
        structure:{
            deviceId:{
                type:"string",
                pk:true,
                length:255
            },
            deviceType:{
                type:"string",
                length:30 // "Android", "iOS", "Extension"
            },
            uninstalled:{
                type:"boolean",
                default:false
            },
            lastLogin:{
                type:"datetime"
            },
            numberOfLogins:{
                type:"int",
                default:1
            }
        }
    }];
    flow.create("registerModels",{
        begin:function(){
            this.errs = [];
            var self = this;
            models.forEach(function(model){
                persistence.registerModel(model.modelName,model.structure,self.continue("registerDone"));
            });

        },
        registerDone:function(err,result){
            if(err) {
                this.errs.push(err);
            }
        },
        end:{
            join:"registerDone",
            code:function(){
                if(callback && this.errs.length>0){
                    callback(this.errs);
                }else{
                    callback(null);
                }
            }
        }
    })()
}

function onLogin(meta,args){
    var platform = tenantPlatformAnalyticsMap[meta.tenantId];
    var query = "UPDATE UserAnalytics SET "
        +platform.lastLogin+"='"+new Date().toISOString().slice(0, 19).replace('T', ' ')+"', "
        +"lastUse='"+new Date().toISOString().slice(0, 19).replace('T', ' ')+"', "
        +platform.loggedIn+"=true, "
        +platform.uses+"=true "
        +"WHERE email='"+args[0]+"';";

    persistence.query(query,logError)
}

function onLogout(meta,args){
    var platform = tenantPlatformAnalyticsMap[meta.tenantId];

    persistence.query("select userId,"+platform.lastLogin+" from UserAnalytics where userId='"+meta.userId+"';",function(err,result){
        if(err || result.length===0){
            console.error("Analytics error: ",result.length===0?new Error("Logout user not registered"):err)
        }
        else if(result[0][platform.lastLogin]!==null){
            var lastLoginLengthInSeconds = (new Date(new Date().toISOString().slice(0, 19).replace('T', ' ')) - new Date(result[0][platform.lastLogin]))/1000;

            var query = "UPDATE UserAnalytics SET "
                +platform.loggedIn+"=false, "
                +platform.totalLoginLength+"="+platform.totalLoginLength+"+"+lastLoginLengthInSeconds+","
                +platform.lastLoginLength+"="+lastLoginLengthInSeconds+" "
                +"WHERE userId='"+result[0].userId+"';";

            persistence.query(query,logError);
        }
    });
}

function onRegistration(meta,args){
    var geolocation = geolocator.lookup(args[0]);
    var country;
    if(geolocation && geolocation.country){
        country = geolocation.country
    }else{
        country = "UNKNOWN";
    }

    var query = "INSERT INTO UserAnalytics (userId,email,country,signupDate) VALUES ('"+args[1]+"','"+args[2]+"','"+country+"','"+new Date().toISOString().slice(0, 19).replace('T', ' ')+"');";
    persistence.query(query,logError)
}

function onDeviceRegistration(meta,args){
    var query = "INSERT INTO DeviceAnalytics " +
        "(deviceId,deviceType,uninstalled,lastLogin) " +
        "VALUES ('"+args[0]+"','"+tenantPlatformAnalyticsMap[meta.tenantId].name+"',"+false+",'"+new Date().toISOString().slice(0, 19).replace('T', ' ')+"')" +
        "ON DUPLICATE KEY UPDATE lastLogin='"+new Date().toISOString().slice(0, 19).replace('T', ' ')+"' ,numberOfLogins=numberOfLogins+1, uninstalled=false;";
    
    persistence.query(query,logError);
}

function onUninstall(meta,args){
    var query = "UPDATE DeviceAnalytics SET uninstalled=true WHERE deviceId='" + args[0] + "';";
    persistence.query(query, logError)
}

function setField(field){
    //might be able to merge setField and incField...
    return function(meta,args) {
        var query = "UPDATE UserAnalytics SET "+
            field+"=true, "+
            "lastUse='"+ new Date().toISOString().slice(0, 19).replace('T', ' ')+"' "+
            "WHERE userId='" + meta.userId + "';";
        persistence.query(query, logError)
    }
}

function incField(field,quantity){
    return function(meta,args) {
        var query = "UPDATE UserAnalytics SET " +
            field+"="+field+"+"+quantity+
            ", lastUse='"+ new Date().toISOString().slice(0, 19).replace('T', ' ')+
            "' WHERE userId='" + meta.userId + "';";
        
        persistence.query(query, logError)
    }
}

function updateSocialNetworks(reset){
    /*
    Either set or reset the field
     */
    return function(meta,args){
        if(!preferenceKeyToSN[args[0]]){
            throw new Error("You need to register "+args[0]+" in the analytics rules")  //just to make sure somebody sees this problem
        }else {
            var query = "UPDATE UserAnalytics SET " +
            preferenceKeyToSN[args[0]] + "=" + (reset ? "false" : "true" ) +", "+
                "lastUse='"+new Date().toISOString().slice(0, 19).replace('T', ' ') +
                "' WHERE userId='" + meta.userId + "';";

            persistence.query(query, logError)
        }
    }
}

function logError(err,result){
    if(err){
        console.error("Analytics error: ",err);
    }
}