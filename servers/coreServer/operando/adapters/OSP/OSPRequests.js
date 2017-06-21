var core = require("swarmcore");
core.createAdapter("OSPRequests");
var persistence = undefined;
var container = require("safebox").container;
var flow = require("callflow");
var url = require('url');


function registerModels(callback){
    var models = [
        {
            modelName:"OspRequest",
            dataModel : {
                userId: {
                    type: "string",
                    index: true,
                    pk: true,
                    length:254
                },
                name: {
                    type: "string",
                    length:254
                },
                phone: {
                    type: "string",
                    length:30
                },
                website: {
                    type: "string",
                    index: true,
                    length:128
                },
                deals_description: {
                    type: "string",
                    length:2048
                },
                request_time:{
                    type:"datetime"
                }
            }
        }
    ];

    flow.create("registerModels",{
        begin:function(){
            this.errs = [];
            var self = this;
            models.forEach(function(model){
                persistence.registerModel(model.modelName,model.dataModel,self.continue("registerDone"));
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
    })();
}

container.declareDependency("OSPRequestAdapter", ["mysqlPersistence"], function (outOfService, mysqlPersistence) {
    if (!outOfService) {
        persistence = mysqlPersistence;
        registerModels(function(errs){
            if(errs){
                console.error(errs);
            }
        })

    } else {
        console.log("Disabling persistence...");
    }
});



registerNewOSPRequest = function (userId, ospDetailsData, callback) {
    flow.create("register new OSP request", {
        begin: function () {
            persistence.lookup.async("OspRequest", userId, this.continue("createOSPRequest"));
        },
        createOSPRequest: function (err, ospRequestDetails) {
            if (err) {
                callback(err, null);
            }
            else if (!persistence.isFresh(ospRequestDetails)) {
                callback(new Error("OspAlreadyRegistered"), null);
            }
            else {
                ospRequestDetails['request_time'] = new Date();

                var protocolPatt = /^http[s]?:\/\//g;
                if(protocolPatt.test(ospDetailsData['website']) === false){
                    ospDetailsData['website'] = "http://"+ospDetailsData['website'];
                }
                ospDetailsData['website'] = url.parse(ospDetailsData['website']).hostname;
                if (ospDetailsData['website'].indexOf("www.") > -1) {
                    ospDetailsData['website'] = ospDetailsData['website'].split('www.')[1];
                }

                persistence.externalUpdate(ospRequestDetails, ospDetailsData);
                persistence.saveObject(ospRequestDetails, callback);
            }
        }
    })();
};

getOSPRequests = function (callback) {
    flow.create("getAllOSPRequests", {
        begin: function () {
            persistence.filter("OspRequest", {}, callback);
        }
    })();
};

getOSPRequest = function(userId,callback){
    flow.create("getOspRequestData", {
        begin:function(){
            persistence.filter("OspRequest", {userId:userId}, callback);
        }
    })();
};

removeOSPRequest = function (userId, callback) {
    flow.create("getUserRequest", {
        begin: function () {
            if (!userId) {
                callback(new Error("userIdRequired"));
            }
            else {
                persistence.findById("OspRequest", userId, this.continue("deleteRequest"));
            }
        },

        deleteRequest: function (err, request) {
            if(request === null){
                callback(new Error("ospRequestNotFound"));
            }
            else{
                persistence.deleteById("OspRequest", userId, callback);
            }
        }
    })();
};