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

    if (m && m[1] && m[1] !== "0") {
        return "true";
    } else {
        return "false";
    }


})();
