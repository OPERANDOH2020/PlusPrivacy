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
thisAdapter = core.createAdapter("AnalyticsAdapter");

var container = require('safebox').container;
var mysql = require('mysql');
var mysqlPool = undefined;
var mysqlPersistence = undefined;
var uuid = require('node-uuid');
var flow = require('callflow');
var apersistence = require('apersistence');

function setupTables(callback){
    var models = [{
        modelName:"AnalyticsFilter",
        structure:{
            filterName:{
                type:"string",
                pk:true,
                length:255
            },
            conditions:{
                type:"JSON"
            }
        }
    },{
        modelName:"FilterRecord",
        structure:{
            filterName:{
                type:"string",
                length:255
            },
            date:{
                type:"datetime"
            },
            id:{
                type:"string",
                length:255,
                pk:true
            },
            value:{
                type:"int"
            }
        }
    }];

    flow.create("registerModels",{
        begin:function(){
            this.errs = [];
            var self = this;
            models.forEach(function(model){
                mysqlPersistence.registerModel(model.modelName,model.structure,self.continue("registerDone"));
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

container.declareDependency('userAnalytics',['mysqlConnection','mysqlPersistence','redisClient'],function(outOfService,mysqlConnection,persistence){
    if(!outOfService){
        mysqlPool = mysqlConnection;
        mysqlPersistence = persistence;
        setupTables(function(err,result){
            if(err){
                console.error("Could not setup the analytics filters\nError: ",err)
            }else{
                registerFilter({filterName:"Total number of users",conditions:{}},function(err,result){
                    /*
                    Always register the number of users in a separate filter.
                     */
                    runFiltersPeriodically();
                });
            }
        })
    }
});

packAnalyticsForDownload = function(callback){
    var fs = require('fs');
    var archiver = require('archiver');
    var toArchive = [
        {
            table:"UserAnalytics",
            file:"userAnalytics.csv"
        },
        {
            table:"DeviceAnalytics",
            file:"deviceAnalytics.csv"
        }
    ];
    var outputFile = "/analytics/"+uuid.v1()+".zip";
    var output = fs.createWriteStream(thisAdapter.config.Core.analyticsArchivesDir+outputFile);
    var archive = archiver('zip',{zlib:{level:9}});
    archive.pipe(output);
    var numTables = toArchive.length;

    toArchive.forEach(addTableToArchive);

    function addTableToArchive(toArchive){
        var tableFields =[];
        var tmpStream = fs.createWriteStream("/tmp/"+toArchive.file);
        var q = mysqlPool.query("SELECT * FROM " +toArchive.table+ ";");
        q.on('fields',extractFields).on('result',extractRawData).on('error',callback).on('end',function(){
            archive.append(fs.createReadStream("/tmp/"+toArchive.file),{name:toArchive.file});
            fs.unlinkSync("/tmp/"+toArchive.file);
            numTables--;
            if(numTables===0){
                archive.finalize();
                callback(undefined,thisAdapter.config.Core.operandoHost+outputFile);
            }
        });

        function extractFields(fields){
            for(var f in fields){
                if(fields[f].name) {
                    tableFields.push(fields[f].name)
                }
            }
            var toAppend = tableFields.reduce(function(prev,current){return prev+'"'+current+'",';},"")+"\n";
            tmpStream.write(toAppend,{name:toArchive.file});
        }

        function extractRawData(data){
            tmpStream.write(tableFields.reduce(function(prev,current){return prev+"\""+data[current]+"\""+",";},"")+"\n",{name:toArchive.file});
        }
    }
};

getUsersSummary = function(callback) {
    var requiredFields = [
        'email',
        'usesChrome',
        'usesiOS',
        'usesAndroid',
        'signupDate',
        'lastUse',
        'nrOfAltIdentities',
        'filledFeedback',
        'Facebook',
        'LinkedIn',
        'GooglePlus',
        'Youtube',
        'Twitter'
    ];
    mysqlPersistence.filter("UserAnalytics", {"REQUIRED_FIELDS": requiredFields}, callback);
};

registerFilter = function(filter,callback){
    try {
        //validate filters before registration
        filterToQuery(filter);
        var obj = apersistence.createRawObject('AnalyticsFilter', filter.filterName);
        obj.conditions = filter.conditions;
        mysqlPersistence.save(obj, callback);
    }catch(e){
        callback(e);
    }
};

getExistingFilters = function(callback){
    mysqlPersistence.filter('AnalyticsFilter',{"REQUIRED_FIELDS":['filterName','conditions']},callback);
};

function filterToQuery(filter){
    //throw error if the filter is not valid
    var availableFields = apersistence.modelUtilities.getModel('UserAnalytics').persistentProperties;
    var sqlConditions = []
    var query = "SELECT COUNT(*) as value from UserAnalytics ";
    for(var condition in filter.conditions){
        if(!filter.conditions[condition]){
            continue; //skip false,null --- treat them as 'any'
        }

        var field;
        if(filter.conditions[condition] === true){
            field=  condition;
            sqlConditions.push(field+" = "+filter.conditions[condition]);
        }

        //e.g. minIdentities, signupAfter
        if(condition.match('min')) {
            field = condition.split('min')[1]
            sqlConditions.push(field + " >= '" + filter.conditions[condition] + "'");
        }

        if(condition.match('max')){
            field = condition.split('max')[1]
            sqlConditions.push(field + " <= '" + filter.conditions[condition] + "'");

        }

        if(condition.match('After')){
            field = condition.split('After')[0];
            var d = new Date(filter.conditions[condition]);
            sqlConditions.push(field + " >= '" + d.getFullYear()+"-"+(d.getMonth()+1)+"-"+d.getDate() + "'");
        }

        if(condition.match('Before')){
            field= condition.split('Before')[0];
            var d = new Date(filter.conditions[condition]);
            sqlConditions.push(field + " <= '" + d.getFullYear()+"-"+(d.getMonth()+1)+"-"+d.getDate() + " 23:59:59'");
        }


        if(!availableFields.some(function(availableField){return field === availableField})){
            throw new Error("Field "+condition+" in not supported... yet");
        }

    }

    if(sqlConditions.length>0){
        query += sqlConditions.reduce(function(prev,current){
            return prev+current+" AND ";
        },"WHERE ").slice(0,-4)
    }

    query+=";";

    return query;
}

executeFilter = function(filter,callback){
    try{
        //throws error if filter is not valid
        var q = filterToQuery(filter);
        mysqlPool.query(q,function(err,result){
            if(err){
                callback(err);
            }else{
                if(filter.filterName!=='customFilter') {
                    onFilterResult(filter.filterName, result[0].value);
                }
                callback(err,result);
            }
        });
    }catch(e){
        console.error("An error occured while executing filter "+filter,e);
        callback(e);
    }
};

function runFiltersPeriodically(){
    getExistingFilters(function(err,filters){
        if(err){
            console.error("Error occured while retrieving filters from database at timestamp "+new Date().toISOString()+"\nError: "+err);
        }else{
            filters.forEach(function(filter){
                executeFilter(filter,function(err,result){
                    if(err){
                        console.error("Error occured while executing filter "+ filter+" at timestamp "+new Date().toISOString()+"\nError: "+err);
                    }
                })
            })
        }
    });
    setTimeout(runFiltersPeriodically,1000*60*60*24); //run daily
}

function onFilterResult(filterName,value){
    var record = apersistence.createRawObject('FilterRecord', uuid.v1());
    mysqlPersistence.externalUpdate(record,{"date":new Date(),"filterName":filterName,"value":value})
    mysqlPersistence.save(record, function(err,result){
        if(err){
            console.error("Error occured while recording result "+result+" for filter "+result,err);
        }
    });
}

getRecords = function(filterName,callback){
    mysqlPersistence.filter('FilterRecord',{
        "REQUIRED_FIELDS":["date","value"],
        "filterName":filterName,
        "ORDER":{field:"date",type:"ASC"}},callback)
};