/*
 * Copyright (c) 2016 ROMSOFT.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the The MIT License (MIT).
 * which accompanies this distribution, and is available at
 * http://opensource.org/licenses/MIT
 *
 * Contributors:
 *    RAFAEL MASTALERU (ROMSOFT)
 * Initially developed in the context of OPERANDO EU project www.operando.eu
 */

var core = require("swarmcore");
thisAdapter = core.createAdapter("CreditAdapter");

var container = require('safebox').container;
var apersistence = require('apersistence');
var uuid = require('node-uuid');
var persistence = undefined;
var flow = require('callflow');


function registerModels(callback){
    var models = [
        {
            modelName:"Account",
            dataModel : {
                owner:{
                    type: "string",
                    length:255,
                    index:true,
                    pk:true
                },
                type:{
                    type: "string",
                    length:255,
                    default:'user'
                },
                amount:{
                    type:"float",
                    default:0.00
                }
            }
        },
        {
            modelName:"Transaction",
            dataModel:{
                id:{
                    type:"string",
                    pk:true,
                    length:255
                },
                source:{
                    type:"string",
                    length:255
                },
                target:{
                    type:"string",
                    length:255
                },
                amount:{
                    type:"float"
                },
                formalType:{
                    type:"string",
                    length:255
                },
                description:{
                    type:"string",
                    length:255
                },
                transactionTime:{
                    type:"datetime"
                }
            }
        }
    ];

    flow.create("registerModels",{
        begin:function(){
            this.errs = [];
            var self = this;
            models.forEach(function(model){
                persistence.registerModel(model.modelName,model.dataModel,self.continue("registerDone"));
            });

        },
        registerDone:function(err,result){
            if(err) {
                this.errs.push(err);
            }
        },
        end:{
            join:"registerDone",
            code:function(){
                if(callback && this.errs.length>0){
                    callback(this.errs);
                }else{
                    callback(null);
                }
            }
        }
    })()
}

container.declareDependency("UDEAdapter",['mysqlPersistence'],function(outOfService,mysqlPersistence){
    if (!outOfService) {
        persistence = mysqlPersistence;
        registerModels(function(errs){
            if(errs){
                console.error(errs);
            }else{
                console.log("UDE adapter available");
            }
        })
    } else {
        console.log("Disabling UDEAdapter...");
    }
});

createAccount = function(userId,callback){
    persistence.lookup("Account",userId,function (err,account) {
        if(err){
            callback(err)
        }
        {
            if(account.__meta.freshRawObject){
                persistence.save(account,callback)
            }else{
                callback(null,account)
            }
        }
    })
};

getFunds = function(userId,callback){
    persistence.lookup("Account",userId,function (err,account) {
        if(err){
            callback(err)
        }else
        {
            if(account.__meta.freshRawObject){
                persistence.save(account,function(err,result){
                    if(err){
                        callback(err);
                    }else{
                        callback(null,account.amount);
                    }
                })
            }else {
                callback(undefined, account.amount)
            }
        }
    })
};

createTransaction = function(from,to,amount,formalType,description,callback){
    flow.create('createTransaction',{
        begin:function(){
            persistence.lookup('Account',from,this.continue('gotAccount'));
            persistence.lookup('Account',to,this.continue('gotAccount'));
            this.getTransaction();

        },
        gotAccount:function (err,account) {
            if(err){
                throw err
            }else{
                this[account.owner] = account
            }
        },
        getTransaction:function(){
            persistence.lookup('Transaction',uuid.v1(),this.continue('gotTransaction'));
        },
        gotTransaction:function(err,transaction){
            if(err){
                throw err
            }else if(!transaction.__meta.freshRawObject){
                this.getTransaction();  //loop here if by some chance the id already used
            }else{
                this.transaction = transaction;
            }
        },

        performTransaction: {
            join: "gotAccount,gotTransaction",
            code: function () {
                if (this[from].amount < amount) {
                    callback(new Error("The sender does not have sufficient funds"));
                } else {
                    this.transaction.source = from;
                    this.transaction.target = to;
                    this.transaction.amount = amount;
                    this.transaction.description = description;
                    this.transaction.formalType = formalType;
                    this.transaction.transactionTime = new Date();
                    persistence.save(this.transaction, this.continue('updateAccounts'));
                }
            }
        },
        updateAccounts:function(err,transaction){
            if(err){
                throw err;
            }else {
                this[from].amount   = Number(this[from].amount)-Number(amount);
                this[to].amount     = Number(this[to].amount)+Number(amount);
                persistence.save(this[to], this.continue('accountUpdated'));
                persistence.save(this[from], this.continue('accountUpdated'));
            }
        },
        accountUpdated:function(err,account){
            if(err){
                throw err
                //here one might want to reverse the transaction... if one was so inclined
            }
        },
        transactionFinished:{
            join:"accountUpdated",
            code:function(){
                callback(null,this.transaction)
            }
        },
        error:function(err){
            console.error('Error '+err.message+' occured',err.stack);
            callback(err);
        }
    })()
};

getTransactions = function(userId,callback){
    flow.create('getTransactions', {
        begin: function () {
            this.transactions = [];
            persistence.filter("Transaction",{"target":userId},this.continue('gotSomeTransactions'));
            persistence.filter("Transaction",{"source":userId},this.continue('gotSomeTransactions'));

        },
        gotSomeTransactions: function (err, transactions) {
            if (err) {
                throw err
            } else {
                this.transactions = this.transactions.concat(transactions)
            }
        },
        gotTransactions: {
            join:"gotSomeTransactions",
            code:function () {
                callback(null,this.transactions)

            },
        },
        error:function(err){
            console.error("Error "+err.message+" occured");
            callback(err);
        }
    })()
};