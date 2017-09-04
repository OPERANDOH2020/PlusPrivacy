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
            this.ip = aux[aux.length-1];
            performAnalytics(this.meta.userId,"analytics.js","registrationWithIp",this.meta,[this.ip,this.userId,this.userEmail])
        }
    },
    actionPerformed:function(){
        /*
        This constructor receives as sole argument the name of the field to be set in the analytics database.
         */
    },
    getDownloadUrl:function(){
        this.swarm("getLink");
    },
    getLink:{
        node:"AnalyticsAdapter",
        code:function(){
            var self = this;
            packAnalyticsForDownload(S(function(err,downloadLink){
                if(err){
                    self.err = err;
                    self.home('failed');
                }else{
                    self.link = downloadLink;
                    self.home('gotDownloadUrl');
                }
            }))
        }
    }
};
analyticsSwarming;
