var core = require ("swarmcore");
core.createAdapter("FeedbackAdapter");
var persistence = undefined;
var  container = require("safebox").container;
var flow = require("callflow");
var uuid = require('uuid');
var apersistence = require('apersistence');
var fs = require('fs');
var readline = require('readline');
var google = require('googleapis');
var googleAuth = require('google-auth-library');

var SCOPES = ['https://www.googleapis.com/auth/spreadsheets'];
var TOKEN_DIR = process.env.SWARM_PATH + "/" + getMyConfig("Google_APIS").location + '/.credentials/';
var TOKEN_PATH = TOKEN_DIR + 'plusprivacy-feedback.json';
var oauth2Client = null;
var sheets = google.sheets('v4');
var spreadsheetId = getMyConfig("Google_APIS").spreadsheetId;


var initOAuthMechanism = function(){

    flow.create("authorize app",{
        begin:function(){
            var feedback_secret_file = process.env.SWARM_PATH + "/" + getMyConfig("Google_APIS").FEEDBACK_CLIENT;

            fs.readFile(feedback_secret_file, this.continue('processClientSecrets'));
        },
        processClientSecrets:function(err, credentials){
            if (err) {
                console.log('Error loading client secret file: ' + err);
                return;
            }
            // Authorize a client with the loaded credentials, then call the
            // Google Sheets API.
            this.next("extractCredentials",undefined, JSON.parse(credentials));

        },
        extractCredentials:function(credentials){
            var clientSecret = credentials.installed.client_secret;
            var clientId = credentials.installed.client_id;
            var redirectUrl = credentials.installed.redirect_uris[0];
            var auth = new googleAuth();
            oauth2Client = new auth.OAuth2(clientId, clientSecret, redirectUrl);
            fs.readFile(TOKEN_PATH, this.continue("authorize"));
        },
        authorize:function(err, token){
            if (err) {
                this.next("getNewToken");
            } else {
                oauth2Client.credentials = JSON.parse(token);
            }
        },
        getNewToken:function(){
            var self = this;
            var authUrl = oauth2Client.generateAuthUrl({
                access_type: 'offline',
                scope: SCOPES
            });
            console.log('Authorize this app by visiting this url: ', authUrl);
            var rl = readline.createInterface({
                input: process.stdin,
                output: process.stdout
            });
            rl.question('Enter the code from that page here: ', function(code) {
                rl.close();
                oauth2Client.getToken(code, function(err, token) {
                    if (err) {
                        console.log('Error while trying to retrieve access token', err);
                        return;
                    }
                    oauth2Client.credentials = token;
                    self.next("storeToken", undefined, token);

                });
            });
        },
        storeToken:function(token) {
            try {
                fs.mkdirSync(TOKEN_DIR);
            } catch (err) {
                if (err.code != 'EEXIST') {
                    throw err;
                }
            }
            fs.writeFile(TOKEN_PATH, JSON.stringify(token));
            console.log('Token stored to ' + TOKEN_PATH);

        }

    })();
};

container.declareDependency("FeedbackAdapter", ["mysqlPersistence"], function (outOfService, mysqlPersistence) {
    if (!outOfService) {
        persistence = mysqlPersistence;
        setTimeout(initOAuthMechanism,3000);

        var test = function(){
            var requests = [];
            // Change the name of sheet ID '0' (the default first sheet on every
            // spreadsheet)

            var d = new Date();
            var date = d.getMonth()+1+"/"+ d.getDate()+"/"+ d.getFullYear()+" "+ d.getHours().toString()+":"+ d.getMinutes()+":"+ d.getSeconds();

            var fnRandom = function(){
                return Math.floor(Math.random() * 5) + 1
            };

            var body = {
                "range": "Form Responses 1",
                majorDimension: "ROWS",
                "values": [
                    [date, fnRandom(), fnRandom(), fnRandom(),fnRandom(),fnRandom(),fnRandom(),fnRandom(),fnRandom()],
                    [date, fnRandom(), fnRandom(), fnRandom(),fnRandom(),fnRandom(),fnRandom(),fnRandom(),fnRandom()],
                    [date, fnRandom(), fnRandom(), fnRandom(),fnRandom(),fnRandom(),fnRandom(),fnRandom(),fnRandom()],
                    [date, fnRandom(), fnRandom(), fnRandom(),fnRandom(),fnRandom(),fnRandom(),fnRandom(),fnRandom()],[date, fnRandom(), fnRandom(), fnRandom(),fnRandom(),fnRandom(),fnRandom(),fnRandom(),fnRandom()]
                ]
            };

            request={
                spreadsheetId:spreadsheetId,
                range:"Form Responses 1",
                valueInputOption: "USER_ENTERED",
                insertDataOption:"INSERT_ROWS",
                auth:oauth2Client,
                resource: body

            };


            sheets.spreadsheets.values.append(request, function(err, res) {
                if(err){
                    console.log(err);
                    return;
                }
                console.log(res);
                return;
            });

            /*sheets.spreadsheets.batchUpdate({
                auth:oauth2Client,
                key: "AIzaSyC5MInU3sEOsb9CdPuyWK93biw6ygvsLp8",
                spreadsheetId: spreadsheetId,
                resource: batchUpdateRequest
            }, function(err, response) {
                console.log(response);
                if(err) {
                    // Handle error
                    console.log(err);
                }
            });*/

        };
        setTimeout(test,6000);

    } else {
        console.log("Disabling persistence...");
    }
});

