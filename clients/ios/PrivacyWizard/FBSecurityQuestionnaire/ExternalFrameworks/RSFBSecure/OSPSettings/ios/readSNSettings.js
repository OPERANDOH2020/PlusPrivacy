 window.readSettings =  function (settingJSONString)
{
    var obj = {};
    
    try
    {
   if (typeof jQuery == 'undefined') {
          return "JQUERY IS NOT LOADED OMG";
      } 

      
  var setting = JSON.parse(settingJSONString);
  var jquery_selector = setting.jquery_selector;
  var settingName = setting.name;
      
  switch (jquery_selector.valueType){
  case "attrValue": setting = jQuery(jquery_selector.element).attr(jquery_selector.attrValue); break;
  case "checkbox": setting = jQuery(jquery_selector.element).attr("checked")?true:false; break;
  case "inner": setting = jQuery(jquery_selector.element).text(); break;
  case "classname": setting = jQuery(jquery_selector.element).hasClass(jquery_selector.attrValue); break;
  case "radio" :setting = jQuery(jquery_selector.element + ":checked").attr("value"); break;
  case "selected": setting = jQuery(jquery_selector.element).attr("value"); break;
  case "length": setting = jQuery(jquery_selector.element).length?jQuery(jquery_selector.element).length:0; break;
      default: setting = {"notFound" : "true"};
  }
  
      obj[settingName] = setting;
    }catch(e)
    {
        obj["Exception"] = e;
    }
    
  return JSON.stringify(obj);
  };