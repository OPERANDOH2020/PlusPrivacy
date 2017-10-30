/*
* Created by ciprian on 3/31/17.
*/


var core = require("swarmcore");
var imageDiff = require('image-diff');
var fs = require('fs');
var spawn = require('child_process').spawn;
var crawlerConfig = getMyConfig("CrawlerAdapter");
var path = require('path');
thisAdapter = core.createAdapter("CrawlerAdapter");
process.env.phantomJsPath = thisAdapter.config.Core.phantomJsPath;
//process.env.phantomJsPath = "/home/ciprian/phantomjs-2.1.1-linux-x86_64/bin/";


var adapterPath  = process.env.SWARM_PATH+"/operando/adapters/WebCrawler/";

if(crawlerConfig){
    var crawlerPath = process.env.SWARM_PATH+"/"+crawlerConfig.crawlerPath+"/";
}
else{
    var crawlerPath = adapterPath;
}


if(!process.env.phantomJsPath){
    console.error("The environment of the crawling adaptor must contain the path towards phantomJs!");
}else{
    periodicallyScan();
}

function periodicallyScan(){
    startCrawling(false, compareSscreenshots);
    setTimeout(periodicallyScan,1000*3600*24); //run daily
}

function startCrawling(progressWanted, callback) {

    function processTargetedData(data){
       if(progressWanted === true){
           callback(null, data);
       }
    }

    console.log("Running the web crawler");
    var crawler = spawn(process.env.phantomJsPath+"phantomjs", ["--web-security=false","--ssl-protocol=tlsv1","--ignore-ssl-errors=true",adapterPath+"phantomCrawler.js"]);  //the args are to avoid "SSL handshake fail" errors

    crawler.stdout.on('data',function(data){
        var data = data.toString();
        try{
            var targetedData = JSON.parse(data);
            processTargetedData(targetedData);
        }
        catch(e){
        }
    });

    crawler.on("message", function(data){
        console.log(data);
    });

    crawler.stderr.on('data', function (data) {
        console.log("[X]Crawling.stderr:\n", data.toString())
    });

    crawler.on("error", function (err) {
        console.log("[X]Crawling.error:\n", err);
        callback(err);
    });

    crawler.on("exit", function (data) {
        console.log("Crawling done",arguments);
        callback(null, {status:"completed"});
    });
}

function compareSscreenshots(){
    var config = JSON.parse(fs.readFileSync( crawlerPath+"urls.json"));
    var urls = {};
    for(var network in config){
        config[network].forEach(function(crawlStep){
            if(crawlStep.name){
                urls[crawlStep.name] = crawlStep.url;
            }
        })
    }

    var newScreenshots = fs.readdirSync(crawlerPath).filter(function(path){
        return path.endsWith(".png") && !path.endsWith(".old.png") && !path.match('diff');
    });

    console.log("Comparing screenshots");
    newScreenshots.forEach(function(newScreenshot){

        var root = crawlerPath+"/"+newScreenshot.split('.png')[0];
        var oldScreenShot = root+".old.png";

        if(!fs.existsSync(oldScreenShot)){
            fs.rename(crawlerPath+"/"+newScreenshot,oldScreenShot,function(err,result){
                if(err){
                    console.error(err);
                }
            });
        }else{
            imageDiff({
                    actualImage:crawlerPath+newScreenshot,
                    expectedImage:oldScreenShot,
                    diffImage:root+'diff.png'},
                function(err,areTheSame){
                    if(err){
                        console.log(err);
                    }
                    else if(areTheSame){
                        fs.rename(crawlerPath+"/"+newScreenshot,oldScreenShot,function(err,result){
                            if(err){
                                console.error(err);
                            }
                        });
                        fs.unlink(root+"diff.png");
                    }else{
                        checkForFalsePositives(root,function(err,isFalsePositive){
                            if(!err && !isFalsePositive){
                                root = root.split("/").pop();
                                console.log("A change occured in " + root,urls[root]);

                                if (root.endsWith('Eula')) {
                                    startSwarm("notification.js", 'EULAChange',urls[root],root);
                                } else {
                                    startSwarm("notification.js", 'SettingsChange',urls[root],root);
                                }

                            }else{
                                fs.rename(crawlerPath+"/"+newScreenshot,oldScreenShot,function(err,result){
                                    if(err){
                                        console.error(err);
                                    }
                                });
                                fs.unlink(root+"diff.png");
                            }
                        })
                    }
                })
        }
    });
}

function checkForFalsePositives(diffImage,callback){
    /*
     Compare the detected difference with all the possible differences that are known to be false positives.
     If the current difference is the same as some other previously observed and dismissed difference it means that this is a false positive.
     */
    fs.readdir(crawlerPath+"/KnownFalsePositives/",function(err,files){
        if(err){
            callback(err);
        }else{
            var targetPage = diffImage.split("/").pop().split(".png");
            targetPage.pop();
            targetPage = targetPage.pop();

            var relevantFalsePositives = files.filter(function(file){
                return file.match(targetPage);
            });
            var leftToCheck = relevantFalsePositives.length;
            if(leftToCheck===0){
                callback(null,false)
            }else{
                var isFalsePositive = false;
                relevantFalsePositives.forEach(function(file){
                    imageDiff({
                        actualImage:diffImage+"diff.png",
                        expectedImage:crawlerPath+"/KnownFalsePositives/"+file
                    },function(err,sameDifference){
                        leftToCheck --;
                        if(!err && sameDifference){
                            isFalsePositive = true;
                        }
                        if(leftToCheck === 0){
                            callback(null,isFalsePositive);
                        }
                    })
                })
            }
        }
    })
}

startCrawler = function(callback){
    startCrawling(true, callback);
}

markFalsePositive = function(page,callback){
    fs.readdir(crawlerPath,function(err,files){
        if(err){
            callback(err);
        }
        else{
            files.forEach(function(file){
                if(file.match(page+".png")) {
                    fs.unlinkSync(crawlerPath + file);
                }
            });
            files.forEach(function(file){
                if(file.match(page+"diff")) {
                    fs.rename(crawlerPath+file,crawlerPath+"/KnownFalsePositives/"+page+new Date().toISOString()+".png",callback);
                }
            });
        }
    })
};

getChangeDetails = function(page,callback){
    fs.readdir(crawlerPath,function(err,files){
        if(err){
            callback(err);
        }
        else{
            var changedFiles = files.filter(function(file){
                return file.match(page);
            });

            changedFiles = changedFiles.map(function(file){
                return crawlerPath+file;
            });


            var imageFiles = changedFiles.map(function(changedFile){
                var image = fs.readFileSync(changedFile);
                var extensionName = path.extname(changedFile).split('.').pop();
                var base64Image = new Buffer(image, 'binary').toString('base64');
                var imgSrcString = "data:image/"+extensionName+";base64,"+base64Image;
                return imgSrcString;
            });

            callback(null,imageFiles);
        }
    })
};

getAvailablePages = function(callback){
    var pages = JSON.parse(fs.readFileSync( crawlerPath+"urls.json"));
    for(var osp in pages){
        pages[osp] = pages[osp].filter(function(page){
            if(page["takeScreenshot"] != false){
                if(!page['exec']){
                    if(page['name']){
                        return true;
                    }
                }
            }
        })
    }
    callback(null,pages);
}


