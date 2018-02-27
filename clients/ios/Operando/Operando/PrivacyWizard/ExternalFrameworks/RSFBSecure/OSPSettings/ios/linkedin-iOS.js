 (function(privacySettingsJsonString) {
 
  var kMessageTypeKey = "messageType";
  var kLogMessageTypeContentKey = "logContent";
  var kLogMessageType = "log";
  
  var kStatusMessageMessageType = "statusMessageType";
  var kStatusMessageContentKey = "statusMessageContent";
  
  var webkitSendMessage  = function(message) {
  alert(message);
  };
  
 window.console = {};
 window.console.log = function(logMessage) {
 var webkitMessage = {};
 webkitMessage[kMessageTypeKey] = kLogMessageType;
 webkitMessage[kLogMessageTypeContentKey] = logMessage;
 
 webkitSendMessage(JSON.stringify(webkitMessage));
 };
 
 var sendStatusMessage = function(settingName) {
 var webkitMessage = {};
 webkitMessage[kMessageTypeKey] = kStatusMessageMessageType;
 webkitMessage[kStatusMessageContentKey] = settingName;
 webkitSendMessage(JSON.stringify(webkitMessage));
 };
 
var privacySettings = JSON.parse(privacySettingsJsonString);

function postToLinkedIn(settings, item, total) {
    
    
    return new Promise(function (resolve, reject) {
                       
                       
                       if (settings.page) {
                       
                       doGET(settings.page, function (response) {
                             
                             var headers = extractHeaders(response);
                             var data = {};
                             
                             if(!data.hasOwnProperty("topLevelNodeId")) {
                                data["topLevelNodeId"] = "root";
                             }
                             
                             for (var prop in settings.data) {
                             data[prop] = settings.data[prop];
                             }
                             
                             
                             for (var param in settings.params) {
                                if (settings.params[param].type && settings.params[param].type === "dynamic") {
                                    if (headers[param]) {
                                        settings.url = settings.url.replace("{" + settings.params[param].placeholder + "}", headers[param]);
                                    }
                                }
                             }
                             
                             if (settings.type == "application/json") {
                             $.ajax({
                                    type: "POST",
                                    url: settings.url,
                                    data: JSON.stringify(data),
                                    contentType: 'application/json; charset=utf-8',
                                    dataType: "json",
                                    beforeSend: function (request) {
                                    if (settings.headers) {
                                    for (var i = 0; i < settings.headers.length; i++) {
                                    var header = settings.headers[i];
                                    request.setRequestHeader(header.name, header.value);
                                    }
                                    }
                                    
                                    request.setRequestHeader("accept", "application/json, text/javascript, */*; q=0.01");
                                    request.setRequestHeader("accept-language", "en-US,en;q=0.8");
                                    request.setRequestHeader("X-Alt-Referer", settings.page);
                                    
                                    },
                                    success: function (result) {
                                    resolve(result);
                                    },
                                    statusCode:{
                                    500: function(){
                                    console.log("Sunt in 500");
                                    }
                                    },
                                    error: function (a, b, c) {
                                    reject(b);
                                    },
                                    complete: function (request, status) {
                                    }
                                    
                                    });
                             }
                             else {
                             
                             var formData = new FormData();
                             for (var p in headers) {
                             formData.append(p, headers[p]);
                             }
                             
                             for (var prop in data) {
                             formData.append(prop, data[prop]);
                             }
                             $.ajax({
                                    type: "POST",
                                    url: settings.url,
                                    data: formData,
                                    contentType: false,
                                    processData: false,
                                    
                                    beforeSend: function (request) {
                                    request.setRequestHeader("accept", "*/*");
                                    request.setRequestHeader("accept-language", "en-US,en;q=0.8");
                                    request.setRequestHeader("X-Alt-Referer", settings.page);
                                    },
                                    success: function (result) {
                                    setTimeout(function(){
                                               resolve(result);
                                               },0);
                                    },
                                    statusCode:{
                                    500: function(){
                                    console.log("Sunt in 500");
                                    },
                                    400: function(a, b) {
                                    console.log(a.responseText);
                                    }
                                    },
                                    error: function (a, b, c) {
                                    reject(c);
                                    },
                                    complete: function (request, status) {
                                    console.log(request.responseText);
                                    }
                                    
                                    });
                             }
                             
                             })
                       }
                       
                       });
    
}

function secureAccount(callback) {
    var total = privacySettings.length;
    var sequence = Promise.resolve();
    privacySettings.forEach(function (settings, index) {
                            sequence = sequence.then(function () {
                                                     return postToLinkedIn(settings, index, total);
                                                     }).then(function (result) {
                                                             }).catch(function (err) {
                                                                      console.log(err);
                                                                      });
                            });
    
    sequence = sequence.then(function (result) {
                             sendStatusMessage("Done")
                             });
    
    sequence = sequence.then(function (result) {
                             callback();
                             });
    
    
}

function doGET(page, callback){
    $.ajax({
           url: page,
           success: callback,
           dataType: 'html'
           });
}


function extractHeaders(content) {
    var csrfToken = /<meta name="lnkd-track-error" content\=\"\/lite\/ua\/error\?csrfToken=(ajax%3A[0-9]*)\">/;
    var data = {};
    var match;
    
    if ((match = csrfToken.exec(content)) !== null) {
        if (match.index === csrfToken.lastIndex) {
            csrfToken.lastIndex++;
        }
    }
    data['csrfToken'] = decodeURIComponent(match[1]);
    return data;
    
}
  secureAccount(function() {
                console.log("finished");
                });
  })(RS_PARAM_PLACEHOLDER)
