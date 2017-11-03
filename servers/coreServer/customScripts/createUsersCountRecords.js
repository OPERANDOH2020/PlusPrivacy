/**
 * Created by ciprian on 11/3/17.
 */
/*
 This script creates records for the history of users count leveraging the signUpDate field in the UserAnalytics table.
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

var getUsersByDate =
    "SELECT count(*) as nrUsers, date(signupDate) as signupDate FROM operando.UserAnalytics " +
    "Group by date(signupDate) " +
    "ORDER BY signupDate ASC ;";

var totalUsersByDay = 0;
mysqlConnection.query(getUsersByDate,function(err,usersPerDay){
    if(err){
        throw err;
    }

    var remaining = usersPerDay.length;
    usersPerDay.forEach(function(users){
        totalUsersByDay+=users.nrUsers;

        var updateQuery = "REPLACE INTO FilterRecord (filterName,date,id,value) " +
            "VALUES ('Total nr of users','"+new Date(users.signupDate).toISOString().split('T')[0]+"','"+uuid.v1()+"',"+totalUsersByDay+");";


        mysqlConnection.query(updateQuery,function(err,result) {
            if (err) {
                console.error(err);
            }
            remaining--;
            if (remaining == 0) {
                mysqlConnection.end();
            }
        });
    })
});

