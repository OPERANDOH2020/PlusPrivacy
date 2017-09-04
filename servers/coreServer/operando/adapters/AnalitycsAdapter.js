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

var mysql = require('mysql');
var uuid = require('node-uuid');
var archiver = require('archiver');
var fs = require('fs');

packAnalyticsForDownload = function(callback){
    var connectionSettings = {
        connectionLimit:10,
        host     : thisAdapter.config.Core.mysqlHost,
        port     : thisAdapter.config.Core.mysqlPort,
        user     : 'root',
        password : thisAdapter.config.Core.mysqlDatabasePassword,
        database : thisAdapter.config.Core.mysqlDatabaseName
    };
    var toArchive = [
        {
            table:"UserAnalytics",
            file:"userAnalytics.csv"
        },
        {
            table:"UserDevice",
            file:"deviceAnalytics.csv"
        }
    ];

    var mysqlPool = mysql.createPool(connectionSettings);
    var outputFile = "/analytics/"+uuid.v1()+".zip";
    var output = fs.createWriteStream(thisAdapter.config.Core.analyticsArchivesDir+outputFile);
    var archive = archiver('zip',{zlib:{level:9}});
    archive.pipe(output);
    var numTables = toArchive.length;

    toArchive.forEach(addTableToArchive);


    function addTableToArchive(toArchive){
        var tableFields =[];
        var tmpStream = fs.createWriteStream("./tmp-"+toArchive.file);
        var q = mysqlPool.query("SELECT * FROM " +toArchive.table+ ";");
        q.on('fields',extractFields).on('result',extractRawData).on('error',callback).on('end',function(){
            archive.append(fs.createReadStream("./tmp-"+toArchive.file),{name:toArchive.file});
            fs.unlinkSync("./tmp-"+toArchive.file,function(err){
                if(err){
                    console.error("Could nor unlink temp file",err);
                }
            })
            numTables--;
            if(numTables===0){
                archive.finalize();
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
    callback(undefined,this.thisAdapter.config.Core.operandoHost+outputFile);
};