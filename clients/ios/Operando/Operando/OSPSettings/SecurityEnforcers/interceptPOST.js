 (function(open, send)
{
  
  XMLHttpRequest.prototype.open = function(method, url, async, user, pass)
  {
  // Do some magic
  this.lastRequestMethod = method;

  open.call(this, method, url, async, user, pass);
  };
  
  XMLHttpRequest.prototype.send = function(body)
  {
  if(this.lastRequestMethod === "POST")
  {
    var template = {
    "__req": null,
    "__dyn": null,
    "__a": null,
    "fb_dtsg": null,
    "__user": null,
    "ttstamp": null,
    "__rev": null
                };
  
        alert(body);
  };
  
   send.call(this, body);
  };
  
  })(XMLHttpRequest.prototype.open, XMLHttpRequest.prototype.send);