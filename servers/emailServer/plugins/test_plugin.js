/**
 * Created by ciprian on 8/3/17.
 */



var plugin;
var testEmail;
var testAlias;
var testDirectory = __dirname+"/../tests";
var fs = require('fs');

function readConfig(){
    var testCfg = plugin.config.get("test.ini",readConfig);
    plugin.loginfo(testCfg);
    testEmail = testCfg.main.testEmail;
    testAlias = testCfg.main.testAlias
}


exports.register = function(){
    this.register_hook("rcpt","performForwardingTest");
    plugin = this;
    readConfig();
};

exports.performForwardingTest = function (next,connection) {
    if(connection.transaction.rcpt_to[0].user+"@"+connection.transaction.rcpt_to[0].host===testAlias){
        fs.writeFileSync(testDirectory+"/email_received_at_"+new Date().toISOString());
        next();
    }
    else if(connection.transaction.rcpt_to[0].user+"@"+connection.transaction.rcpt_to[0].host===testEmail){
        fs.writeFileSync(testDirectory+"/email_forwarded_at_"+new Date().toISOString());
        next(DENYDISCONNECT)
    }else{
        next()
    }
}
