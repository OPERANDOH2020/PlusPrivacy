(function () {


    htmlContent = document.getElementsByTagName('html')[0].innerHTML;

    console.log(htmlContent);
//    var sig_regex = /<input type=\"hidden\" name=\"csrfToken\" value=\"ajax:([0-9]*)\">/;
    var sig_regex = /<a href=\"https:\/\/www\.linkedin\.com\/uas\/logout\?session_full_logout=&amp;csrfToken=ajax%3A([0-9]*)&amp;trk=nav_account_sub_nav_signout\" title=\"Sign out\">Sign out<\/a>/;
    var match;
    if ((match = sig_regex.exec(htmlContent)) !== null) {
        if (match.index === sig_regex.lastIndex) {
            sig_regex.lastIndex++;
        }
    }

    Android.showToast("here " +  typeof(match) + " " + match);
    Android.showToast("here " +  typeof(match[1]) + " " + match[1]);
    if (match && match[1]) {
        console.log("here match[1]", match[1]);
        Android.isLogged(1);
    } else {
        Android.isLogged(0);
    }

})();