(function () {

    htmlContent = document.getElementsByTagName('html')[0].innerHTML;
//    console.log(htmlContent);

    var sig_regex = /{\"USER_ID\":\"(.*?)\",/g;
    var m;
    if ((m = sig_regex.exec(htmlContent)) !== null) {
        if (m.index === sig_regex.lastIndex) {
            sig_regex.lastIndex++;
        }
    }

    Android.showToast("here " +  typeof(m[1]) + " " + m[1]);
    if (m && m[1] && m[1] !== "0") {
        Android.isLogged(1);
    } else {
        Android.isLogged(0);
    }


})();