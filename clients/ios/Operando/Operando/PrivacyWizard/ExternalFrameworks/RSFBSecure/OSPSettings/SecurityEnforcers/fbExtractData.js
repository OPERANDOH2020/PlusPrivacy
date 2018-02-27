(function (content, fbDataString)
{
  var fbdata = JSON.parse(fbDataString);
  var csrfToken = /\[\"DTSGInitialData\",\[\],\{"token":"([a-zA-Z0-9]*)"\},[0-9]*\]/;
  var revisionReg = /\{\"revision\":([0-9]*),/;
  var userIdReg = /\{\"USER_ID\":\"([0-9]*)\"/;
                       
                       
  var match;
  var data = {};
                
  if((match = csrfToken.exec(content)) !== null)
    {
       if (match.index === csrfToken.lastIndex)
          {
            csrfToken.lastIndex++;
          }
    }
                       
  if(match && match[1])
    {
       data['fb_dtsg'] = match[1];

       var x = '';
                     
       for (var y = 0; y < data['fb_dtsg'].length; y++)
        {
            x += data['fb_dtsg'].charCodeAt(y);
        }
                     
        data["ttstamp"] = '2' + x;
                     
    }
  else
    {
        data["fb_dtsg"] = fbdata["fb_dtsg"];
        data["ttstamp"] = fbdata["ttstamp"];
    }
     
    //return JSON.stringify(data);
 
    //__rev
    //match = revisionReg.exec(content);
    //var revRegLastIndex = revisionReg.lastIndex;
                     
//    if (match)
//    {
//        if (match.index === revRegLastIndex)
//           {
//               //revisionReg.lastIndex = 0;
//           }
//    }
                     
    if(match[1])
    {
       data['__rev'] = match[1];
    }
                       //__user
    if ((match = userIdReg.exec(content)) !== null)
    {
       if (match.index === userIdReg.lastIndex)
        {
            userIdReg.lastIndex++;
        }
    }
                       
    if(match[1])
    {
        data['__user'] = match[1];
    }
                       
    data['__a']=1;
    data['__dyn'] = fbdata['__dyn'];
    data['__req'] = (++ fbdata['__req']).toString(36);
                       
                       
    result = {};
    result["data"] = data;
    result["fbdata"] = fbdata;
                       
    return JSON.stringify(result);
})