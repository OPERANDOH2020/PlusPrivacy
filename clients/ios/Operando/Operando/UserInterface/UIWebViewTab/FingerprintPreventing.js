 (function () {
  
  //courtesy of https://stackoverflow.com/a/43638942
  if (window.CanvasRenderingContext2D) {
  const gid = CanvasRenderingContext2D.prototype.getImageData;
  CanvasRenderingContext2D.prototype.getImageData = function (x, y, w, h) {
  var data = gid.bind(this)(x, y, w, h);
  data.data.fill(0);  // fill with zero
  alert('Did use getImageData');
  return data;
  }
  // Token way to avoid JS from finding out that you have overwritten the prototype overwrite
  // the toString method as well (note ctx.getImageData.toString.toString() will
  // still show you have changed the prototype but over writing Object.toSting is not worth the problems)
  CanvasRenderingContext2D.prototype.getImageData.toString = function () {
  return "function getImageData() { [native code] }";
  }
  }
  
  
  navigator.userAgent = "Mozilla/5.0 (Windows NT 6.1; rv:52.0) Gecko/20100101 Firefox/52.0";
  navigator.vendor = "";
  navigator.productSub = "20100101";
  navigator.appVersion = "5.0 (Windows)"
  navigator.language = "en-US";
  
  Date.prototype.getTimezoneOffset = function() {
  return 0;
  };
  
  }());
