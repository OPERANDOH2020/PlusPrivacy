/**
 * Created by ciprian on 11/3/17.
 */


/*
    This script updates the number of identities in the analytics table.
    It was written in order to change field hasAltIdentities in nrOfAltIdentities
 */


var mysql = require('mysql');
var fs = require('fs');
var etcConfig = JSON.parse(fs.readFileSync(__dirname+"/../etc/operando"));

var connectionSettings = {
    host     : etcConfig.Core.mysqlHost,
    port     : etcConfig.Core.mysqlPort,
    user     : 'root',
    password : etcConfig.Core.mysqlDatabasePassword,
    database : etcConfig.Core.mysqlDatabaseName
};
var mysqlConnection = mysql.createConnection(connectionSettings);


var countIdentitiesQuery = "select count(*) as nr_identities, userId from Identity Group By userId";

function updateUserAnalytics(userId,nrOfIdentitites){
    return "UPDATE  UserAnalytics " +
        "set nrOfAltIdentities = "+nrOfIdentitites+" " +
        "where userId = '"+userId+"';";
}
mysqlConnection.query(countIdentitiesQuery,function(err,result){
    if(err){
        throw err;
    }else{
        var remaining = result.length;
        result.forEach(function(res){
            mysqlConnection.query(updateUserAnalytics(res.userId,res.nr_identities-1),function(err,res){
                if(err){
                    console.error(err);
                }
                remaining--;
                if(remaining==0){
                    mysqlConnection.end();
                }
            });
        })
    }
});



