(function(privacySettingsJsonString)
 {
 
 
 //
 var privacySettings = JSON.parse(privacySettingsJsonString);
 //
 var kMessageTypeKey = "messageType";
 var kLogMessageTypeContentKey = "logContent";
 var kLogMessageType = "log";
 
 var kStatusMessageMessageType = "statusMessageType";
 var kStatusMessageContentKey = "statusMessageContent";
 
 var webkitSendMessage  = function(message)
 {
 alert(message);
 };
 
 window.console = {};
 window.console.log = function(logMessage)
 {
 var webkitMessage = {};
 webkitMessage[kMessageTypeKey] = kLogMessageType;
 webkitMessage[kLogMessageTypeContentKey] = logMessage;
 
 webkitSendMessage(JSON.stringify(webkitMessage));
 
 };
 
 var sendStatusMessage = function(settingName)
 {
 var webkitMessage = {};
 webkitMessage[kMessageTypeKey] = kStatusMessageMessageType;
 webkitMessage[kStatusMessageContentKey] = settingName;
 webkitSendMessage(JSON.stringify(webkitMessage));
 };
 
 
 Object.prototype.formStringToObject = function()
 {
 if(!(this instanceof String))
 {
 console.log('typeof this is not a string, its ' + (JSON.stringify(this)) + ' and its ');
 var fakeData = {};
 return fakeData;
 }
 
 var array = this.split('&');
 var resultData = {};
 array.forEach(function(currentValue, index, array)
               {
               var splitAgain = currentValue.split('=');
               resultData[splitAgain[0]] = decodeURIComponent(splitAgain[1]);
               });
 return resultData;
 };
 
 Object.prototype.toFormObject = function()
 {
 var formData = new FormData();
 var keys = Object.keys(this);
 for(var i=0; i<keys.length; i++)
 {
 formData.append(keys[i], this[keys[i]]);
 }
 
 return formData;
 };
 
 
 Object.prototype.toFormString = function()
 {
 var formString = "";
 var keys = Object.keys(this);
 for(var i=0; i<keys.length; i++)
 {
 var key = keys[i];
 if(key === 'formStringToObject' || key === 'toFormObject' || key === 'toFormString')
 {
 continue;
 }
 var value = encodeURIComponent(this[key]);
 formString += key + "=" + value;
 if(i < keys.length - 1)
 {
 formString += "&";
 }
 }
 
 
 
 return formString;
 };
 
 
 function hijackNextPOSTRequestWithTemplate(template, callback)
 {
 
 (function(open, send)
  {
  var unalteredOpen = open;
  var unalteredSend = send;
  
  XMLHttpRequest.prototype.open = function(method, url, async, user, pass)
  {
  console.log('opened a ' + method + ' to ' + url);
  this.lastRequestMethod = method;
  open.call(this, method, url, async, user, pass);
  };
  
  XMLHttpRequest.prototype.send = function(body)
  {
  
  console.log("FOR LAST REQUEST METHOD " + this.lastRequestMethod);
  console.log("BODY IS " + body);
  
  if(this.lastRequestMethod === "POST" || this.lastRequestMethod === "post")
  {
  if(body)
  {
  
  var formData = body.formStringToObject();
  var atLeastOneFound = false;
  for (var prop in template)
  {
  
  if (formData[prop])
  {
  atLeastOneFound = true;
  if(formData[prop] instanceof Array)
  {
  template[prop] = formData[prop][0];
  }
  else
  {
  template[prop.toString()] = formData[prop];
  }
  }
  }
  
  if(atLeastOneFound)
  {
  
  XMLHttpRequest.prototype.open = unalteredOpen;
  XMLHttpRequest.prototype.send = unalteredSend;
  callback(template);
  }
  
  }
  };
  
  send.call(this, body);
  };
  
  })(XMLHttpRequest.prototype.open, XMLHttpRequest.prototype.send);
 }

 function postToFacebook(settings, item, total) {
 
 return new Promise(function (resolve, reject) {
                    
                    if (settings.page) {
                    doGET(settings.page, function (response) {
                          
                          extractHeaders(response, function (response)
                                         {
                                         
                                         var data = response;
                                         for(var prop in settings.data)
                                         {
                                         data[prop] = settings.data[prop];
                                         }
                                         
                                         console.log( "WE ARE SECURING FOR URL " + settings.url + JSON.stringify(data));
                                         makePOSTRequest(settings.url, settings.page, data, function()
                                                         {
                                                         
                                                         resolve("Done");
                                                         }, function(){
                                                         console.log('Error for page ' + settings.page);
                                                         reject("Error");
                                                         });
                                         
                                         return;

                                         jQuery.ajax({
                                                type: "POST",
                                                url: settings.url,
                                                data: data,
                                                dataType: "text",
                                                beforeSend: function (request) {
                                                console.log("BEFORE SEND IN AJAX");
                                                if (settings.headers) {
                                                for (var i = 0; i < settings.headers.length; i++) {
                                                var header = settings.headers[i];
                                                request.setRequestHeader(header.name, header.value);
                                                }
                                                }
                                                request.setRequestHeader("accept", "*/*");
                                                request.setRequestHeader("accept-language", "en-US,en;q=0.8");
                                                request.setRequestHeader("content-type", "application/x-javascript; charset=utf-8");
                                                request.setRequestHeader("X-Alt-Referer", settings.page);
                                                
                                                },
                                                success: function (result) {
                                                resolve(result);
                                                },
                                                error: function (a, b, c) {
                                                console.log(a,b,c);
                                                reject(b);
                                                },
                                                complete: function (request, status) {
                                                console.log("Request completed...");
                                                }
                                                
                                                });
                                         });
                          });
                    }
                    
                    });
 
 }
 
 function makePOSTRequest(url, cookiesURLSource, dataInJSON, onSuccess, onError)
 {
 
 
 var xmlHttp = new XMLHttpRequest();
 xmlHttp.onreadystatechange = function ()
 {
 switch (xmlHttp.readyState) {
 case 0: // UNINITIALIZED
 case 1: // LOADING
 case 2: // LOADED
 break;
 case 3: {// INTERACTIVE
 console.log("CASA 3");
 console.log(xmlHttp.status);
 console.log(xmlHttp.responseText);
 }
 case 4:        { // COMPLETED
  console.log("CASA 4");
 console.log(xmlHttp.status);
 console.log(xmlHttp.responseText);
 onSuccess();
 }
 break;
 default: onError();
 
 }
 };
 xmlHttp.open("POST", url, true);
 
 xmlHttp.setRequestHeader("accept", "*/*");
 xmlHttp.setRequestHeader("accept-language", "en-US,en;q=0.8");
 xmlHttp.setRequestHeader("content-type", "application/x-www-form-urlencoded; charset=UTF-8");
 xmlHttp.setRequestHeader("X-Alt-Referer", cookiesURLSource);
 
 xmlHttp.send(dataInJSON.toFormString());
 return;
 }
 
 function secureAccount(callback)
 {
 console.log('Will begin securing account');
 var fbdata = {
 "__req": null,
 "__dyn": null,
 "__a": null,
 "fb_dtsg": null,
 "__user": null,
 "ttstamp": null,
 "__rev": null
 };
 
 hijackNextPOSTRequestWithTemplate(fbdata, function(filledData)
                                   {
                                   filledData.__req = parseInt(filledData.__req, 36);
                                   window.fbdata = filledData;
                                   var total = privacySettings.length;
                                   var sequence = Promise.resolve();
                                   privacySettings.forEach(function (settings, index) {
                                                           sequence = sequence.then(function () {
                                                                                    return postToFacebook(settings, index, total);
                                                                                    }).then(function (result) {
                                                                                            console.log(result);
                                                                                            }).catch(function (err) {
                                                                                                     console.log(err)
                                                                                                     });
                                                           });
                                   
                                   sequence = sequence.then(function (result) {
                                                            callback();
                                                            });
                                   
                                   });
 }
 
 secureAccount(function(){
               console.log('Done securing account!');
               sendStatusMessage("Done");
               });
 
 
 function doGET(page, callback) {
 
 var xmlHttp = new XMLHttpRequest();
 xmlHttp.onreadystatechange = function () {
 if (xmlHttp.readyState == 4 && xmlHttp.status == 200)
 callback(xmlHttp.responseText);
 }
 xmlHttp.open("GET", page, true);
 xmlHttp.send(null);
 }
 
 
 function extractHeaders(content, callback) {
 var csrfToken = /\[\"DTSGInitialData\",\[\],\{"token":"([a-zA-Z0-9]*)"\},[0-9]*\]/;
                    var revisionReg = /\{\"revision\":([0-9]*),/;
                    var userIdReg = /\{\"USER_ID\":\"([0-9]*)\"/;
                    
                    
                    var match;
                    var data = {};
                    
                    if ((match = csrfToken.exec(content)) !== null) {
                    if (match.index === csrfToken.lastIndex) {
                    csrfToken.lastIndex++;
                    }
                    }
                    
                    if(match && match[1]){
                    data['fb_dtsg'] = match[1];
                    
                    /**
                     * Taken from Facebook
                     * @type {string}
                     */
                    
                    var x = '';
                    for (var y = 0; y < data['fb_dtsg'].length; y++) {
                    x += data['fb_dtsg'].charCodeAt(y);
                    }
                    data["ttstamp"] = '2' + x;
                    }
                    else{
                    data["fb_dtsg"] = fbdata.fb_dtsg;
                    data["ttstamp"] = fbdata.ttstamp;
                    }
                    
                    //__rev
                    if ((match = revisionReg.exec(content)) !== null) {
                    if (match.index === revisionReg.lastIndex) {
                    revisionReg.lastIndex++;
                    }
                    }
                    
                    if(match && match[1]){
                    data['__rev'] = match[1];
                    }
                    //__user
                    if ((match = userIdReg.exec(content)) !== null) {
                    if (match.index === userIdReg.lastIndex) {
                    userIdReg.lastIndex++;
                    }
                    }
                    
                    if(match && match[1]){
                    data['__user'] = match[1];
                    }
                    
                    data['__a']=1;
                    data['__dyn'] = fbdata.__dyn;
                    data['__req'] = (++ fbdata.__req).toString(36);
                    
                    callback(data);
                    }
 }
                    )(RS_PARAM_PLACEHOLDER);
