/**
 * Created by ciprian on 26.09.2016.
 */

var core = require("swarmcore");
thisAdapter = core.createAdapter("EmailAdapter");

var emailPort = process.argv.indexOf("-port");
if(emailPort===-1){
    emailPort = 25;
}else{
    emailPort = process.argv[emailPort+1];
}

var emailHost = process.argv.indexOf("-host");
if(emailPort===-1){
    emailHost = "localhost";
}else{
    emailHost = process.argv[emailHost+1];
}
const mailer = require('nodemailer');
var smtpTransport = require('nodemailer-smtp-transport');
var transporter = mailer.createTransport(smtpTransport({host:emailHost, port: emailPort, ignoreTLS:true}));
var jwt = require('jsonwebtoken');
var fs = require('fs');
var encryptionKey = fs.readFileSync(thisAdapter.config.Core.emailEncryptionKey).toString();



sendEmail = function(from,to,subject,text,callback){
    to = jwt.sign(JSON.stringify({
        "alias":from,
        "sender":to
    }),encryptionKey,{algorithm: "HS256"});
    transporter.sendMail({
        "from": from,
        "to": "reply_anonymously_to_sender_"+to+"@"+thisAdapter.config.Core.operandoHost,
        "subject": subject,
        "text": text
    }, callback)
};

sendContactEmail = function(subject, text, replyToAddress,callback){
    to = jwt.sign(JSON.stringify({
        "alias":"feedback@" + thisAdapter.config.Core.operandoHost,
        "sender":"contact@" + thisAdapter.config.Core.operandoHost
    }),encryptionKey,{algorithm: "HS256"});

    transporter.sendMail({
        "from": "feedback@" + thisAdapter.config.Core.operandoHost,
        "to": "reply_anonymously_to_sender_"+to+"@"+thisAdapter.config.Core.operandoHost,
        "subject": subject,
        "text": text,
        "replyTo": replyToAddress
    }, callback);
}


