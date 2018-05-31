(function () {


    htmlContent = document.getElementsByTagName('html')[0].innerHTML;

//    console.log(htmlContent);
//    var sig_regex = /<input type=\"hidden\" name=\"csrfToken\" value=\"ajax:([0-9]*)\">/;
//    var sig_regex = /<a href=\"https:\/\/www\.linkedin\.com\/uas\/logout\?session_full_logout=&amp;csrfToken=ajax%3A([0-9]*)&amp;trk=nav_account_sub_nav_signout\" title=\"Sign out\">Sign out<\/a>/;
    var sig_regex = /<a href=\"https:\/\/www\.linkedin\.com\/uas\/logout\?session_full_logout=&amp;csrfToken=ajax%3A([0-9]*)&amp;trk=nav_account_sub_nav_signout\" title=\"(.*)\">(.*)<\/a>/;
    var match;
    if ((match = sig_regex.exec(htmlContent)) !== null) {
        if (match.index === sig_regex.lastIndex) {
            sig_regex.lastIndex++;
        }
    }

    //match for connected apps
    var apps_regex = /<form class=\"simple-form\" id=\"permitted-services-form\" method=\"POST\">/;
    var apps_match;
    if ((apps_match = apps_regex.exec(htmlContent)) !== null) {
        if (apps_match.index === apps_regex.lastIndex) {
            apps_regex.lastIndex++;
        }
    }

    console.log("cookies", document.cookie);
    console.log("li_at", readCookie('liap'));

    if ( readCookie('liap') || apps_match || (match && match[1]) ) {
        Android.isLogged(1);
    } else {
        Android.isLogged(0);
    }



    function readCookie(name) {
        var nameEQ = name + "=";
        var ca = document.cookie.split(';');
        for(var i=0;i < ca.length;i++) {
            var c = ca[i];
            while (c.charAt(0)==' ') c = c.substring(1,c.length);
            if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
        }
        return null;
    }


})();