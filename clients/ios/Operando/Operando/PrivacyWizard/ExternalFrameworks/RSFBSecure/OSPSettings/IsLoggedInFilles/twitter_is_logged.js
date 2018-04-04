//window.__META_DATA__ = {"env":"prod","isLoggedIn":false,"isRTL":false};
(function () {


    console.log(window.__META_DATA__.isLoggedIn);

    if(window.__META_DATA__.isLoggedIn){
        return "true";
    } else {
        return "false";
    }


})();
