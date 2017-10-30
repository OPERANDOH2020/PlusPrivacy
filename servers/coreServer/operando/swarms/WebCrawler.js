/**
 * Created by ciprian on 4/20/17.
 */


var webCrawlingSwarming = {

    getPages:function(){
      this.swarm("getAvailablePages");
    },
    getChanges:function(page){
        this.page = page;
        this.swarm('get')
    },
    get:{
        node:"CrawlerAdapter",
        code:function(){
            var self = this;
            getChangeDetails(this.page,S(function(err,result){
                if(err){
                    self.err = err.message;
                    self.home('failed');
                }else{
                    self.base64Images = result;
                    self.home("gotChanges");
                }
            }))
        }
    },
    markFalsePositive:function(page){
        this.page = page;
        this.swarm('mark');
    },

    getAvailablePages:{
      node:"CrawlerAdapter",
      code:function(){
          var self = this;
          getAvailablePages(S(function(err,pages){
            self.pages = pages;
            self.home("gotAvailablePages");
          }));
      }
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
                    if(result.status!=="completed"){
                        console.log(result.status);
                        self.swarmToUser(self.meta.userId,"gotCrawlerResult");
                        self.result = result;
                    }
                    else{
                        self.swarmToUser(self.meta.userId,"crawlingCompleted");
                    }
                }
            }))
        }
    }
};

webCrawlingSwarming;

