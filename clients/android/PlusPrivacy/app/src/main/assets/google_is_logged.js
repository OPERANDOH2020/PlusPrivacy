(function () {

    htmlContent = document.getElementsByTagName('html')[0].innerHTML;
    console.log(htmlContent);

    var sig_regex = /<a class=\"gb_Ea gb_Wf gb_4f gb_Le gb_Jb\" id=\"gb_71\" href=\"https:\/\/accounts.google.com\/Logout\" target=\"_top\">Sign out<\/a>/;
    var match;
    if ((match = sig_regex.exec(htmlContent)) !== null) {
        if (match.index === sig_regex.lastIndex) {
            sig_regex.lastIndex++;
        }
    }

    Android.showToast("here " +  typeof(match) + " " + match);
    if (match != null) {
        Android.isLogged(1);
    } else {
        Android.isLogged(0);
    }

})();