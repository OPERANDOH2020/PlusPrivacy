/**
 * Created by ciprian on 11/3/17.
 */
/*
    Update lastUse field with the max(

 */

var mysql = require('mysql');
var fs = require('fs');
var etcConfig = JSON.parse(fs.readFileSync(__dirname+"/../etc/operando"));
var uuid = require('node-uuid');

var connectionSettings = {
    host     : etcConfig.Core.mysqlHost,
    port     : etcConfig.Core.mysqlPort,
    user     : 'root',
    password : etcConfig.Core.mysqlDatabasePassword,
    database : etcConfig.Core.mysqlDatabaseName
};

var mysqlConnection = mysql.createConnection(connectionSettings);

var getUsersByDate = "SELECT userId,lastLoginIniOS,lastLoginInAndroid,lastLoginInChrome,lastLoginInPlusPrivacyWebsite FROM operando.UserAnalytics; ";

mysqlConnection.query(getUsersByDate,function(err,result){
    if(err){
        throw err;
    }else{
        var remaining = result.length;

        result.forEach(function (result) {
            var d1 = new Date(result.lastLoginIniOS),d2 = new Date(result.lastLoginInAndroid),d3 = new Date(result.lastLoginInChrome),max;
            if(d1>d2 && d1>d3){
                max = d1;
            }else if(d2>d1&&d2>d3){
                max = d2;
            }else{
                max=d3;
            }

            if(max> new Date(null)){
                var query = "UPDATE  UserAnalytics set lastUse = '"+max.toISOString().slice(0, 19).replace('T', ' ')+"' where userId = '"+result.userId+"';";
                mysqlConnection.query(query,function(err,result){
                    if(err){
                        console.log(err);
                    }
                    remaining--;
                    if(remaining===0){
                        mysqlConnection.end();
                    }
                })
            }else{
                remaining--;
            }
        })
    }
})
