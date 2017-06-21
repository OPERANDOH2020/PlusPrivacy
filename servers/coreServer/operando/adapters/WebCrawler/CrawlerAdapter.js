/**
 * Created by ciprian on 3/31/17.
 */


var core = require("swarmcore");
var imageDiff = require('image-diff');
var fs = require('fs');
var spawn = require('child_process').spawn;


thisAdapter = core.createAdapter("CrawlerAdapter");
process.env.phantomJsPath = thisAdapter.config.Core.phantomJsPath;


var crawlerPath = process.env.SWARM_PATH+"/operando/adapters/WebCrawler/";

if(!process.env.phantomJsPath){
    console.error("The environment of the crawling adaptor must contain the path towards phantomJs!");
}else{
    periodicallyScan();
}

function periodicallyScan(){
    startCrawling(compareSscreenshots);
    setTimeout(periodicallyScan,1000*3600*24); //run daily
}

function startCrawling(callback) {
    console.log("Running the web crawler");
    var crawler = spawn(process.env.phantomJsPath+"phantomjs", [crawlerPath+"phantomCrawler.js"]);

    crawler.stderr.on('data', function (data) {
        console.log("[X]Crawling.stderr:\n", data.toString())
    });



    crawler.on("error", function (err) {
        console.log("[X]Crawling.error:\n", err);
        callback(err);
    });

    crawler.on("exit", function () {
        console.log("Crawling done");
        callback();
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
                actualImage:crawlerPath+"/"+newScreenshot,
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
                    root = root.split("/").pop();
                    console.log("A change occured in " + root,urls[root]);
                    if (root.endsWith('Eula')) {
                        startSwarm("notification.js", 'EULAChange',urls[root]);
                    } else {
                        startSwarm("notification.js", 'SettingsChange',urls[root]);
                    }
                }
            })
        }
    });
}