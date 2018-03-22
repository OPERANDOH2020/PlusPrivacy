//
var kMessageTypeKey = "messageType";
var kLogMessageTypeContentKey = "logContent";
var kLogMessageType = "log";

var kStatusMessageMessageType = "statusMessageType";
var kStatusMessageContentKey = "statusMessageContent";

var webkitSendMessage = function(message) {
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

console.log("PREFS FILE");

var googleParams = {};

getGoogleData(function (response) {

  googleParams = response;
  // console.log("google params" + googleParams);

  secureAccount(RS_PARAM_PLACEHOLDER);
});

function doGetRequest(url, callback) {


  //console.log("doGetRequest")
  var oReq = new XMLHttpRequest();
  oReq.onreadystatechange = function () {
    if (oReq.readyState == XMLHttpRequest.DONE) {

      callback(oReq.responseText, true);
    }
  };
  oReq.open("GET", url);
  oReq.send();
}


if (!String.prototype.unescapeHtmlChars) {
  String.prototype.unescapeHtmlChars = function () {
    var value = this;

    value = value.replace(/&amp;/g, "&");
    value = value.replace(/&quot;/g, "\"");
    value = value.replace(/&apos;/g, "'");
    value = value.replace(/&nbsp;/g, " ");
    value = value.replace(/&gt;/g, ">");
    value = value.replace(/&lt;/g, "<");
    value = value.replace(/&rlm;/g, "");

    value = value.replace(/&#(\d+);/g, function (match, number) {
      return String.fromCharCode(parseInt(number, 10));
    });

    value = value.replace(/&#x([0-9a-fA-F]+);/g, function (match, hex) {
      return String.fromCharCode(parseInt(hex, 16));
    });
    return value;
  };
}


RegexUtils = {
  findValueByRegex: function findValueByRegex(serviceKey, label, regex, index, data, must) {
    var value = this.findMultiValuesByRegex(serviceKey, label, regex, [index], data, must)[0];
    return RegexUtils.cleanAndPretty(value);
  },

  findMultiValuesByRegex: function findMultiValuesByRegex(serviceKey, label, regex, indices, data) {
    var rawValues = data.match(regex);

    var values = [];
    
    if (!rawValues) {
      return values;
    }
    
    for (var i = 0; i < indices.length; i++) {
      values[values.length] = rawValues[indices[i]];
    }
    
    
    return values;
  },

  findAllOccurrencesByRegex: function findAllOccurrencesByRegex(serviceKey, label, regex, index, data, processor) {
    var rawValues = data.match(new RegExp(regex, 'g'));
    
    var values = [];
    if (!rawValues) {

      return values;
    }
    
    for (var i = 0; i < rawValues.length; i++) {
      var valueToProcess = ('' + rawValues[i]).match(regex)[index];

      if (processor)
        values[values.length] = processor(valueToProcess);
      else
        values[values.length] = valueToProcess;
    }
    
    return values;
  },

  clean: function (value) {
    if (value) {
      value = value.replace(/<[^>]*>/g, '');
    }
    return value;
  },

  prettify: function (value) {
    if (value) {
      value = value.trim();
      value = value.replace(/\s+/g, ' ');
      value = value.unescapeHtmlChars();
    }
    return value;
  },

  cleanAndPretty: function (value) {
    return RegexUtils.prettify(RegexUtils.clean(value));
  },

  findValueByRegex_CleanAndPretty: function findValueByRegex_CleanAndPretty(serviceKey, label, regex, index, data, must) {
    var value = RegexUtils.findValueByRegex(serviceKey, label, regex, index, data, must);
    
    return RegexUtils.cleanAndPretty(value);
  },

  findValueByRegex_Pretty: function findValueByRegex_Pretty(serviceKey, label, regex, index, data, must) {
    var value = RegexUtils.findValueByRegex(serviceKey, label, regex, index, data, must);
    return RegexUtils.prettify(value);
  }
};


function getGoogleData(callback) {

  function getData(pageData) {
    var match;
    var sid;


    paramsOption1 = "\\\[.*,\\\'([\\\w-]+:[\\\w\\\d]+)\\\',.*\\\]\\\s.*(?=(\\\,\\\s*)+\\\].*window\\\.IJ_valuesCb \\\&\\\&)";
    match = RegexUtils.findMultiValuesByRegex(self.key, 'Revoke Params', paramsOption1, [1], pageData, true);

    var sidRegex = 'WIZ_global_data.+{[^}]*?:\\\"([-\\\d]+?)\\\"[^:\\\"]+';
    sid = RegexUtils.findValueByRegex(self.key, 'f.sid', sidRegex, 1, pageData, true);
    var at = match[0];

    var data = {
      'at': at,
      'f_sid': sid
    };

    //console.log("DATA = " + data);

    callback(data);
  }

  doGetRequest("https://myaccount.google.com/permissions?hl=en", getData);
}

function secureAccount(privacySettingsJsonString) {

  //console.log("BEFORE RASPUNS")
  //console.log("RASPUNS" + privacySettingsJsonString);

  try{
    var privacySettings = JSON.parse(privacySettingsJsonString);
//console.log("AFWTER PARSE")
  }catch(e){
    //console.log("in catch")
    setTimeout(function(){
    console.log(e);
    },2000);
  }
  var total = privacySettings.length;
  privacySettings = privacySettings.reverse();


//console.log("PRIVACYSETTINGS ")
//console.log(privacySettings)

  var sequence = Promise.resolve();
  privacySettings.forEach(function (settings, index) {
    sequence = sequence.then(function () {

      return postToGoogle(settings, index, total);
    }).then(function (result) {
      //console.log("result " + result);

    }).catch(function (err) {
      console.log("err " + err);
    });
  });

  sequence = sequence.then(function (result) {
   sendStatusMessage("DONE-POST");
 });
}

function sendPostRequest(settings, resolve, reject) {

  var data = {};

    //        var cookies = "";
    //        for (var i = 0; i < response.length; i++) {
    //            cookies += response[i].name + "=" + response[i].value + "; ";
    //        }
    
    for (var prop in settings.data) {
      data[prop] = settings.data[prop];
    }
    
    // //console.log("settings.url 0" + settings.url);
    
//    for (var param in settings.params) {
//        if (settings.params[param].type && settings.params[param].type === "dynamic") {
//            if (headers[param]) {
//                settings.url = settings.url.replace("{" + settings.params[param].placeholder + "}", headers[param]);
//            }
//        }
//    }
//
var _body = "";

Object.keys(settings.data).forEach(function (item, index) {
 if (index !== 0) {
   _body += "&";
 }

 _body += item + "=" + settings.data[item];
});

_body += "&at=" + googleParams['at'];



var now = new Date();
var req_id = 3600 * now.getHours() + 60 * now.getMinutes() + now.getSeconds() + 1E5;
// //console.log("settings.url 1" + settings.url);
settings.url = settings.url.replace("{SID}", googleParams['f_sid']);
// //console.log("settings.url 2" + settings.url);
settings.url = settings.url.replace("{REQID}", req_id);
// //console.log("settings.url 3" + settings.url);
//console.log("BODY"+ _body)
$.ajax({
 type: "POST",
 url: settings.url,
 data: _body,
 dataType: "text",

 beforeSend: function (request) {

   if (settings.headers) {
     for (var i = 0; i < settings.headers.length; i++) {
       var header = settings.headers[i];
       request.setRequestHeader(header.name, header.value);
     }
   }
   request.setRequestHeader("accept", "*/*");
   request.setRequestHeader("accept-language", "en-US,en;q=0.8");
   request.setRequestHeader("X-Alt-Referer", settings.page);
 },
 success: function (result) {
   
   //console.log("success")
 },
 statusCode: {
   500: function () {
     console.log("500 error");
     // reject();
   }
 },
 error: function (a, b, c) {
   console.log("error ->" + a + b + c);
   reject(b);
 },
 complete: function (request, status) {
   resolve();
   console.log("complete")
 },
 timeout: 1000

});

}

function postToGoogle(settings, item, total) {

  return new Promise(function (resolve, reject) {


   if (settings.page) {
     if(settings.method_type === "GET"){

      sendGetRequest(settings,resolve,reject);
    }
    else{

      sendPostRequest(settings,resolve,reject);
    }

  }
});
}

function sendGetRequest(settings, resolve, reject){


  var getSIGValue = function(callback){
    doGET(settings.page,function(htmlContent){

      // //console.log(settings.page);
      var sig_regex = /<input value="(.*?)" name="sig" type="hidden">/g;
      var m;
      if((m = sig_regex.exec(htmlContent)) !== null) {
        if (m.index === sig_regex.lastIndex) {
          sig_regex.lastIndex++;
        }
      }
      if(m && m[1]){
        // //console.log("CEVAA"+ m[1]);
        callback(m[1]);
      }
      else{
        reject("no sig found");
      }
    })
  };

  console.log("BEFORE SIG " + settings.url + "\n\n");

  getSIGValue(function(sigValue){
    var url = settings.url.replace("{SIG}",sigValue);
    
    console.log("AFTER SIG " + url + "\n\n");

    doGET(url, resolve);

  })
}

function doGET(page, callback, reject) {

   console.log("GETpage " + page);

/*
   function reqListener (evt) {
    //console.log("MMMMM");
  //console.log(this.responseText);
}
  
  function transferFailed (evt) {
    //console.log("An error occurred while transferring the file.");
  }

var oReq = new XMLHttpRequest();
oReq.addEventListener("load", reqListener);
oReq.addEventListener("error", transferFailed);

oReq.onreadystatechange = function (oEvent) {
//console.log("RAF"+location.hostname);  
    if (oReq.readyState === 4) {  
        if (oReq.status === 200) {  
          //console.log("RESPONSE 200 = " + oReq.responseText)  
        } else {  
           //console.log("EERROORRR = " + arguments.length);  
        }  
    }  
}; 


oReq.open("GET", "https://myaccount.google.com");
oReq.send();*/





  $.ajax({
    type: "GET",
    url: "http://google.com",
    success: callback,
    xhrFields: {
      withCredentials: true
    },
    dataType: 'html',
    error: function (request, textStatus, errorThrown) {

      console.log("textStatus: " + textStatus + " errorThrown " + errorThrown);
      console.log("status "+ request.status);
      reject("reject")
    }
  });
}
