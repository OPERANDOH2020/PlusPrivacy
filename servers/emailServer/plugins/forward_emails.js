
/*
 * Copyright (c) 2016 ROMSOFT.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the The MIT License (MIT).
 * which accompanies this distribution, and is available at
 * http://opensource.org/licenses/MIT
 *
 * Contributors:
 *    Ciprian Tălmăcel (ROMSOFT)
 * Initially developed in the context of OPERANDO EU project
 www.operando.eu
 */

function SwarmConnector(){
    var gotConnection  = false;
    var adapterPort    = 3000;
    var adapterHost    = "localhost";
    var util           = require("swarmcore");
    var client	       = util.createClient(adapterHost, adapterPort, "emailServer", "haraka","BroadcastTest", "emailLoginCtor");
    var uuid           = require('node-uuid');

    this.getRealEmail=function(userAlias,callback){

        var swarmHandler = client.startSwarm("identity.js","getRealEmail",userAlias);
        swarmHandler.onResponse(function(swarm){
            if(swarm.realEmail){
                plugin.loginfo("\n\n\n\n"+userAlias+" --- "+swarm.realEmail+"\n\n\n");
                callback(undefined,swarm.realEmail);
            }else{
                callback(swarm.error);
            }
        });
    };

    client.addListener("close",function(){
        plugin.loginfo("Swarm connection was closed");
        gotConnection = false;
    });

    client.addListener('open',function(){
        gotConnection = true;
        plugin.loginfo("Swarm connection was opened");
    });

    this.connected = function(){
        return gotConnection;
    }
}
var swarmConnection = new SwarmConnector();
var address = require("address-rfc2821").Address;
var fs = require('fs');
var jwt = require('jsonwebtoken');
var cfg;
var host;
var encriptionKey;
var plugin = undefined;


function readConfig(){
    cfg = plugin.config.get('operando.ini',readConfig);
    encriptionKey = fs.readFileSync(cfg.main.encriptionKey);
    host = cfg.main.host;
    plugin.loginfo("Operando configuration: ",cfg);

}

exports.register = function(){
    this.register_hook("rcpt","decide_action");
    this.register_hook("data","clean_body");
    this.register_hook("data_post","perform_action");
    plugin = this;
    readConfig();
};




exports.decide_action = function (next,connection) {
    var alias = connection.transaction.rcpt_to[0].user+"@"+connection.transaction.rcpt_to[0].host;
    var sender = connection.transaction.mail_from.original.slice(1,connection.transaction.mail_from.original.length-1)
    connection.relaying = false;
    jwt.verify(connection.transaction.rcpt_to[0].user.split("reply_anonymously_to_sender_")[1], encriptionKey, ['HS256'], function (err, conversation) {
        if (!err) {
            var to = conversation.sender;
            var from = conversation.alias;

            connection.results.add(plugin, {
                "action":"relayOutside",
                "to": to,
                "from": from,
                "replyTo": from
            });
            connection.relaying = true;
            next()
        } else if(!swarmConnection.connected()){
            next(DENYSOFT)
        } else{
            swarmConnection.getRealEmail(alias.toLowerCase(), function (err, realEmail) {
                if (realEmail) {

                    var conversation = {
                        "alias": alias,
                        "sender": sender
                    };

                    if(alias.toLowerCase().match('support@'+host)||alias.toLowerCase().match('contact@'+host)||alias.toLowerCase().match('pressrelease@'+host)){
                        plugin.loginfo('Forward email');
                        connection.results.add(plugin, {
                            "action":"forwardEmail",
                            "to": realEmail,
                            "conversation":conversation
                        });
                    }else if(conversation.sender.toLocaleLowerCase().match('apache@'+host)){
                        plugin.loginfo('wordpress email');
                        connection.results.add(plugin,{
                            "action":"sendWordpressEmail",
                            "to":realEmail,
                            "from":"pressrelease@"+host,
                            "replyTo": "contact@"+host
                        })
                    }else{
                        plugin.loginfo("Delivering to user");
                        var token = jwt.sign(JSON.stringify(conversation), encriptionKey, {algorithm: "HS256"});
                        var newSender = sender.split("@").join("_at_") + "_via_plusprivacy@"+host; //needs to come from plusprivacy so that we can perform DKIM signing
                        connection.results.add(plugin, {
                            "action":"relayToUser",
                            "to": realEmail,
                            "from": newSender,
                            "replyTo": "reply_anonymously_to_sender_"+token+"@"+host
                        });
                    }

                    connection.relaying = true;
                    next()
                }else {
                    next(DENYDISCONNECT)
                }

            })
        }
    })
}

exports.clean_body = function (next, connection) {
    var plugin = this;
    var decision = connection.results.get('forward_emails');
    if (decision.action==="relayOutside") {
        plugin.loginfo("Filtering the body");
        connection.transaction.add_body_filter('text/html',function(content_type,encoding,body_buffer){
	        var body = body_buffer.toString();
	        var originalFrom = connection.transaction.mail_from.user+"@"+connection.transaction.mail_from.host
            var filteredBody = body.split(originalFrom).join(decision.from);
            return Buffer.from(filteredBody,"utf8");
        })
	    connection.transaction.add_body_filter('text/plain',function(content_type,encoding,body_buffer){
            var body = body_buffer.toString();
            var originalFrom = connection.transaction.mail_from.user+"@"+connection.transaction.mail_from.host
            var filteredBody = body.split(originalFrom).join(decision.from);
            return Buffer.from(filteredBody,"utf8");
        })
    }
    next();
};

exports.perform_action = function (next, connection) {
    var plugin = this;
    var decision = connection.results.get('forward_emails');

    plugin.loginfo("Decision:",JSON.stringify(decision));

    switch(decision.action){
        case "relayOutside":
            changeTo(decision.to);
            changeFrom(decision.from);
            removeHeaders();
            addReplyTo(decision.replyTo);
            break;
        case "relayToUser":
            changeTo(decision.to);
            changeFrom(decision.from,true);
            removeHeaders();
            addReplyTo(decision.replyTo);
            break;
        case "forwardEmail":
            changeTo(decision.to,true);
            var conversation = decision.conversation;
            plugin.loginfo("\n\n\n\nSender1:"+conversation.sender);
            if(connection.transaction.header.get_all("Reply-To").length>0){
                plugin.loginfo("HEADDERR\n\n\n\n"+connection.transaction.header.get_all("Reply-To")[0]);
                conversation.sender = connection.transaction.header.get_all("Reply-To")[0].split("<").join("").split("\n").join("")
            }
            plugin.loginfo("\n\n\n\nSender2:"+conversation.sender);
            var reply_to_token = jwt.sign(JSON.stringify(conversation),encriptionKey,{algorithm:"HS256"});
            addReplyTo("reply_anonymously_to_sender_"+reply_to_token+"@"+host);
            break;
        case "sendWordpressEmail":
            changeTo(decision.to,true);
            addReplyTo(decision.replyTo);
            break;
    }

    next();

    function changeTo(newTo,keepHeader) {
        plugin.loginfo("NewTo"+newTo);
        connection.transaction.rcpt_to.pop();
        if (Array.isArray(newTo)){
            newTo.forEach(function(t){
                connection.transaction.rcpt_to.push(new address('<' + t + '>'));
            })
        }else{
            connection.transaction.rcpt_to.push(new address('<' + newTo + '>'));
        }

        if(!keepHeader) {
            connection.transaction.header.remove('to');
            if (Array.isArray(newTo)) {
                newTo.forEach(function (t) {
                    connection.transaction.header.add('to', t);
                })
            } else {
                connection.transaction.header.add('to', newTo);
            }
        }
    }


    function changeFrom(newFrom,displayOriginal) {
        var original = connection.transaction.mail_from.user+"@"+connection.transaction.mail_from.host;
        connection.transaction.mail_from.original = '<' + newFrom + '>';
        connection.transaction.mail_from.user = newFrom.split('@')[0];
        connection.transaction.mail_from.host = newFrom.split('@')[1];

        connection.transaction.remove_header('sender');
        connection.transaction.remove_header('From');
        if(!displayOriginal || connection.transaction.header.get('to').match('yahoo')) {
            connection.transaction.add_header('From', newFrom);
        }else{
            var fromMessage = original+" via "+host+" <"+newFrom+">";
            plugin.loginfo(fromMessage);
            connection.transaction.add_header('From',fromMessage );
        }
    }

    function addReplyTo(replyTo) {
        connection.transaction.header.remove("Reply-To");
        connection.transaction.header.add("Reply-To", "<"+replyTo+">"); //the user will send the reply to this address
    }

    function removeHeaders(){
        connection.transaction.header.remove('Received');
        connection.transaction.header.remove('X-Sender');
        connection.transaction.header.remove('DKIM-Signature');
        connection.transaction.header.remove('DomainKey-Signature');
        connection.transaction.header.remove('Message-ID');
    }
};




