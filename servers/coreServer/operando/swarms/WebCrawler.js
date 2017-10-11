/**
 * Created by ciprian on 4/20/17.
 */




var webCrawlingSwarming = {
    getChanges:function(page){
        this.page = page;
        this.swarm('get')
    },
    get:{
        node:"CrawlerAdapter",
        code:function(){
            var self = this;
            getChangeDetails(this.page,S(function(err,result){
                console.log(arguments);
                if(err){
                    self.err = err.message;
                    self.home('failed');
                }else{
                    self.home("success");
                }
            }))
        }
    },
    markFalsePositive:function(page){
        this.page = page;
        this.swarm('mark');
    },
    mark:{
        node:"CrawlerAdapter",
        code:function(){
            var self = this;
            markFalsePositive(this.page,S(function(err,result){
                if(err){
                    self.err = err.message;
                    self.home('failed');
                }else{
                    self.files = result;
                    self.home("success");
                }
            }))
        }
    },
    runCrawler:function(){
        this.swarm('run');
    },
    run:{
        node:"CrawlerAdapter",
        code:function(){
            var self = this;
            startCrawler(S(function(err,result){
                if(err){
                    self.err = err.message;
                    self.home('failed');
                }else{
                    self.home("success");
                }
            }))
        }
    }
};

webCrawlingSwarming;

