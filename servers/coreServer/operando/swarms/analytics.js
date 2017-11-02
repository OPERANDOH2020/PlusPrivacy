/**
 * Created by ciprian on 8/1/17.
 */

var analyticsSwarming = {
    addRegistration: function (userEmail,userId) {
        this.userEmail = userEmail;
        this.userId = userId;
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
    },

    getUserAnalytics:function(){
        this.swarm('getAnalytics');
    },
    getAnalytics:{
        node:"AnalyticsAdapter",
        code:function(){
            var self = this;
            getUsersSummary(S(function(err,userData){
                if(err){
                    self.err = err.message;
                    self.swarm('failed');
                }else{
                    self.userAnalytics = userData;
                    self.home('gotUserAnalytics');
                }
            }))
        }
    },

    getAllFilters:function(){
        this.swarm('getFilters');
    },
    getFilters:{
        node:'AnalyticsAdapter',
        code:function(){
            var self = this;
            getExistingFilters(S(function (err, filters) {
                if (err) {
                    self.err = err.message;
                    self.home('failed');
                } else {
                    self.filters = filters.map(function(filter){
                        delete filter.__meta;
                        return filter;
                    })
                    self.home('gotFilters');
                }
            }))
        }
    },

    registerNewFilter:function(newFilter){
        this.filter = newFilter;
        this.swarm('registerFilter');
    },
    registerFilter:{
        node:"AnalyticsAdapter",
        code:function(){
            var self = this;
            registerFilter(this.filter,S(function(err,result){
                if(err){
                    self.err = err.message;
                    self.home('failed');
                }else{
                    self.home('filterRegistered');
                }
            }))
        }
    },

    getFilterRecords:function(filterName){
        this.filterName = filterName;
        this.swarm("getRecords");
    },
    getRecords:{
        node:"AnalyticsAdapter",
        code:function(){
            var self = this;
            getRecords(self.filterName, S(function (err, records) {
                if (err) {
                    self.err = err.message;
                    self.home('failed');
                } else {
                    self.records = records;
                    self.home('gotRecords');
                }
            }))
                
        }
    },

    executeAnalyticsFilter:function(filter){
        this.filter = filter;
        this.swarm('executeFilter');
    },
    executeFilter:{
        node:'AnalyticsAdapter',
        code:function(){
            var self = this;
            executeFilter(this.filter,S(function(err,filteredData){
                if(err){
                    self.err = err.message;
                    self.home('failed');
                }else{
                    self.filterResult = filteredData[0].value;
                    self.home('filterExecuted');
                }
            }))
        }
    }
};
analyticsSwarming;
