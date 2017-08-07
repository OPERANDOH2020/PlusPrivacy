/**
 * Created by ciprian on 8/3/17.
 */


var fs = require('fs');
var emailPort = 25;
var emailHost = "localhost";
const mailer = require('nodemailer');
var smtpTransport = require('nodemailer-smtp-transport');
var ini = require('ini');



process.on("uncaughtException",function(err){
        console.error(err);
        process.exit(3);
})

var cfg = ini.parse(fs.readFileSync(__dirname+"/../config/test.ini","utf-8"))


var warning_minutes = 2;
if(process.argv.indexOf("-w")!==-1){
        warning_minutes = parseInt(process.argv(process.argv.indexOf("-w")+1))
}
var critical_minutes = 5;
if(process.argv.indexOf("-c")!==-1){
        critical_minutes = parseInt(process.argv(process.argv.indexOf("-w")+1))
}



var receivedTime = undefined;
var forwardedTime = undefined;
var receivedFileName = undefined;
var forwardedFileName = undefined;



fs.watch(__dirname,function(type,file){
        if(type == 'rename'){
                if(file.match("email_received_at_")){
                        receivedFileName = file;
                        receivedTime = new Date(file.split("email_received_at_").join(""));
                }
                else if(file.match("email_forwarded_at_")){
                        forwardedFileName = file;
                        forwardedTime = new Date(file.split("email_forwarded_at_").join(""));

                        if((forwardedTime - receivedTime)/1000/60 < warning_minutes){
                                console.log("[SUCCESS] Forwarding was successful")

                                fs.unlinkSync(__dirname+"/"+receivedFileName);
                                fs.unlinkSync(__dirname+"/"+forwardedFileName);
                                fs.unwatchFile(__dirname)
                                process.exit(0)
                        }else{
                                console.log("[WARNING] Forwarding took more than "+warning_minutes+" minutes");
                                fs.unwatchFile(__dirname)
                                process.exit(1);
                        }
                }
        }
})


mailer.createTransport(smtpTransport({host:emailHost, port: emailPort, ignoreTLS:true})).sendMail({
        "from": "test@plusprivacy.com",
        "to": cfg.testAlias,
        "subject": "Test subject",
        "text": "Test text"
})


var stop_time = 1000*60*critical_minutes;
setTimeout(function(){
        console.log("[FAILED] Forwarding took more than "+critical_minutes+" minutes")
        fs.unwatchFile(__dirname)
        process.exit(2)
},stop_time)







