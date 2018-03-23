//window.__META_DATA__ = {"env":"prod","isLoggedIn":false,"isRTL":false};
(function () {

    Android.showToast("here: " + window.__META_DATA__.isLoggedIn);
    console.log(window.__META_DATA__.isLoggedIn);

    if(window.__META_DATA__.isLoggedIn){
        Android.isLogged(1);
    } else {
        Android.isLogged(0);
    }


})();