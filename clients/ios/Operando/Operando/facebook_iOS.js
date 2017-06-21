 (function()
  {
  
  window.console = {};
  window.console.log = function(message)
  {
  alert(message);
  };
  
  Object.prototype.formStringToObject = function()
  {
  if(!(this instanceof String))
  {
  console.log('typeof this is not a string, its ' + (typeof this) + ' and its ');
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
  
  console.log('Returning form string ' + formString);
  
  return formString;
  };
  
  
  function hijackNextPOSTRequestWithTemplate(template, callback)
  {
  console.log('will hijack next POST request');
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
   console.log('hijacked a send request with body ' + body);
   if(this.lastRequestMethod === "POST")
   {
   if(body)
   {
   console.log('hijacked a send call with body ' + JSON.stringify(body));
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
   console.log('Found a template with data ' + JSON.stringify(template));
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
  
  
  var privacySettings =
  [
   {
   name: "Who can see your future posts?",
   page: "https://www.facebook.com/settings?tab=privacy&section=composer&view",
   url: "https://www.facebook.com/privacy/selector/update/?privacy_fbid=0&post_param=291667064279714&render_location=22&is_saved_on_select=true&should_return_tooltip=true&prefix_tooltip_with_app_privacy=false&replace_on_select=false&ent_id=0&tag_expansion_button=friends_of_tagged&__pc=EXP1%3ADEFAULT",
   data:{
   
   }
   },
   {
   name:"Who can contact me?",
   page:"https://www.facebook.com/settings?tab=privacy&section=canfriend&view",
   url:"https://www.facebook.com/privacy/selector/update/?privacy_fbid=8787540733&post_param=275425949243301&render_location=11&is_saved_on_select=true&should_return_tooltip=false&prefix_tooltip_with_app_privacy=false&replace_on_select=false&ent_id=0&tag_expansion_button=friends_of_tagged&__pc=EXP1%3ADEFAULT",
   data:{
   
   }
   
   },
   {
   name:"Who can look me up by email address",
   page:"https://www.facebook.com/settings?tab=privacy&section=findemail&view",
   url:"https://www.facebook.com/privacy/selector/update/?privacy_fbid=8787820733&post_param=291667064279714&render_location=11&is_saved_on_select=true&should_return_tooltip=false&prefix_tooltip_with_app_privacy=false&replace_on_select=false&ent_id=0&tag_expansion_button=friends_of_tagged&__pc=EXP1%3ADEFAULT",
   data:{
   
   }
   },
   {
   name:"Who can look me up by phone",
   page:"https://www.facebook.com/settings?tab=privacy&section=findphone&view",
   url:"https://www.facebook.com/privacy/selector/update/?privacy_fbid=8787815733&post_param=291667064279714&render_location=11&is_saved_on_select=true&should_return_tooltip=false&prefix_tooltip_with_app_privacy=false&replace_on_select=false&ent_id=0&tag_expansion_button=friends_of_tagged&__pc=EXP1%3ADEFAULT",
   data:{
   
   }
   },
   {
   name:"Who can look me up by search engines",
   page:"https://www.facebook.com/settings?tab=privacy&section=search&view",
   url:"https://www.facebook.com/ajax/settings_page/search_filters.php?__pc=EXP1%3ADEFAULT",
   data:{
   "el":"search_filter_public",
   "public":0,
   }
   },
   {
   name:"Who can post on my timeline",
   page:"https://www.facebook.com/settings?tab=timeline&section=posting&view",
   url:"https://www.facebook.com/ajax/settings/timeline/posting.php?__pc=EXP1%3ADEFAULT",
   data:{
   audience:10,
   }
   },
   {
   name:"Who can see posts you've been tagged in on your timeline",
   page:"https://www.facebook.com/settings?tab=timeline&section=tagging&view",
   url:"https://www.facebook.com/privacy/selector/update/?privacy_fbid=8787530733&post_param=286958161406148&render_location=11&is_saved_on_select=true&should_return_tooltip=false&prefix_tooltip_with_app_privacy=false&replace_on_select=false&ent_id=0&tag_expansion_button=friends_of_tagged&__pc=EXP1%3ADEFAULT",
   data:{
   
   }
   },
   {   name:"Review tags people add to your own posts before the tags appear on Facebook",
   page:"https://www.facebook.com/settings?tab=timeline&section=tagreview&view",
   url:"https://www.facebook.com/ajax/settings/tagging/review.php?__pc=EXP1%3ADEFAULT",
   data:{
   tag_review_enabled:1,
   }
   },
   {   name:"Who can follow me",
   page:"https://www.facebook.com/settings?tab=followers",
   url:"https://www.facebook.com/ajax/follow/enable_follow.php?__pc=EXP1%3ADEFAULT",
   data:{
   location:44,
   hideable_ids:["#following_plugin_item","#following_editor_item"],
   should_inject:'',
   allow_subscribers:"disallow"
   }
   },
   {
   name:"Apps Others Use",
   page:"https://www.facebook.com/settings?tab=applications",
   url:"https://www.facebook.com/settings/applications/platform_friends_share/submit/?__pc=EXP1%3ADEFAULT",
   data:{
   fields:''
   }
   },
   {
   name:"Old Versions of Facebook for Mobile",
   page:"https://www.facebook.com/settings?tab=applications",
   url:"https://www.facebook.com/ajax/privacy/simple_save.php?__pc=EXP1%3ADEFAULT",
   data:{
   id:8787700733,
   audience_json:JSON.stringify({"8787700733":{"value":10}}),
   source:'privacy_settings_page'
   }
   },
   {
   name:"Interest-based ads from Facebook",
   page:"https://www.facebook.com/settings?tab=ads&section=oba&view",
   url:"https://www.facebook.com/ads/preferences/oba/?__pc=EXP1%3ADEFAULT",
   data:{
   is_opted_out:1
   }
   },
   {
   name:"Ads with my social actions",
   page:"https://www.facebook.com/settings?tab=ads&section=socialcontext&view",
   url:"https://www.facebook.com/ajax/settings/ads/socialcontext.php?__pc=EXP1%3ADEFAULT",
   data:{
   opt_out:1
   }
   }
   
   ];
  
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
                                          
                                          var headers = {
                                          "accept" : "*/*",
                                          "accept-language" : "en-US,en;q=0.8",
                                          "content-type" : "application/x-www-form-urlencoded; charset=UTF-8",
                                          "origin" : "https://www.facebook.com",
                                          "X-Alt-Referer" : settings.page
                                          };
                                          
                                          makePOSTRequest(settings.url, settings.page, headers, data, function(){
                                                          console.log('Did secure for url ' + settings.page);
                                                          resolve("Done");
                                                          }, function(){
                                                          console.log('Error for page ' + settings.page);
                                                          reject("Error");
                                                          });
                                          
                                          return;
                                          });
                           });
                     }
                     
                     });
  
  }
  
  function makePOSTRequest(url, cookiesURLSource, headers, dataInJSON, onSuccess, onError)
  {
  var request = {
  "cookiesURLSource" : cookiesURLSource,
  "url" : url,
  "headers" : headers,
  "dataInJSON" : dataInJSON
  };
  
  var xmlHttp = new XMLHttpRequest();
  xmlHttp.onreadystatechange = function ()
  {
  switch (xmlHttp.readyState) {
  case 0: // UNINITIALIZED
  case 1: // LOADING
  case 2: // LOADED
  case 3: // INTERACTIVE
  break;
  case 4:        { // COMPLETED
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
  
  console.log('Making a request with data: ' + JSON.stringify(dataInJSON));
  
  
  return;
  
  //using the UIWebView
  var jsonString = JSON.stringify(request);
  window["didPreparePOSTInfo"] = jsonString;
  var iframeSrc = "didPreparePOSTInfo:";
  
  
  window.onFinishedPOST = function()
  {
  if(window["lastRequestStatus"] && window["lastRequestStatus"] === 'finished')
  {
  onSuccess();
  }
  else
  {
  onError();
  }
  };
  
  var iframe = document.createElement("IFRAME");
  iframe.setAttribute("src", iframeSrc);
  document.documentElement.appendChild(iframe);
  iframe.parentNode.removeChild(iframe);
  iframe = null;
  
  return;
  
  // the WKUIDelegate will intercept this and continue the execution after the request has finished/ terminated
  alert(JSON.stringify(request));
  
  //At this point, the request should be finished
  if(window["lastRequestStatus"] && window["lastRequestStatus"] === 'finished')
  {
  onSuccess();
  }
  else
  {
  onError();
  }
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
  
  
  function extractHeaders(content, callback)
  {
  
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
                     data["fb_dtsg"] = window.fbdata.fb_dtsg;
                     data["ttstamp"] = window.fbdata.ttstamp;
                     }
                     
                     //__rev
                     if ((match = revisionReg.exec(content)) !== null) {
                     if (match.index === revisionReg.lastIndex) {
                     revisionReg.lastIndex++;
                     }
                     }
                     
                     if(match[1]){
                     data['__rev'] = match[1];
                     }
                     //__user
                     if ((match = userIdReg.exec(content)) !== null) {
                     if (match.index === userIdReg.lastIndex) {
                     userIdReg.lastIndex++;
                     }
                     }
                     
                     if(match[1]){
                     data['__user'] = match[1];
                     }
                     
                     data['__a']=1;
                     data['__dyn'] = window.fbdata.__dyn;
                     data['__req'] = (++ window.fbdata.__req).toString(36);
                     
                     callback(data);
                     }
                     
                     }
                     
                     )();
