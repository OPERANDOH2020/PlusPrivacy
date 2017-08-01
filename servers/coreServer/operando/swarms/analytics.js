/**
 * Created by ciprian on 8/1/17.
 */

var analyticsSwarming = {
    addRegistration: function (userEmail,userId) {
        this.userEmail = userEmail;
        this.userId = userId
        this.swarm("getIp",this.getEntryAdapter())
    },

    getIp: {
        node: "EntryPoint",
        code: function () {
            var outlet = sessionsRegistry.getTemporarily(this.meta.outletId);
            enableOutlet(this);
            var aux =outlet.getClientIp().split(":");
            this.ip = aux[aux.length-1]
            this.swarm("createRegistrationAnalytic");
        }
    },
    createRegistrationAnalytic:{
        node:"AnalyticsAdapter",
        code:function(){

            var self = this;
            addRegistration(this.userId,this.userEmail,this.ip,S(function(err,result){

                console.log("ADD REGISTRATION ANALYTIC",result);

                if(err){
                    self.err = err.message;
                    self.home('failed');
                }else{
                    self.home('registrationAnalyticCreated');
                }
            }))
        }
    },

    addLogin:function(userId){
        this.userId = userId;
        this.swarm("createLoginAnalytic");
    },

    createLoginAnalytic:{
        node:"AnalyticsAdapter",
        code:function(){
            var self = this;
            addLogin(this.userId,S(function(err,result){
                if(err){
                    self.err = err.message;
                    self.home('failed');
                }else{
                    self.home('loginAnalyticCreated');
                }
            }))
        }
    }
};
analyticsSwarming;
