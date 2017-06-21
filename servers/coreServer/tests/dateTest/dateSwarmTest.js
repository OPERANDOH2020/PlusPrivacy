
var adapterPort         = 3000;
var adapterHost         = "localhost";
globalVerbosity = false;
var assert              = require('double-check').assert;


var util       = require("swarmcore");
var client     = util.createClient(adapterHost, adapterPort, "testExtension", "ok","testTenant", "testCtor");

assert.callback("dateSwarmTest", function(callback){
    var date = new Date();
    client.startSwarm("dateSwarmTest.js","testDate", date);

    swarmHub.on("dateSwarmTest.js","success", function(swarm){
        assert.equal(date.getTime(), swarm.date);
        client.logout();
    });

});
