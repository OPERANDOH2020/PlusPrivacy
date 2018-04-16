(function () {


    var googleApps = [];
    var permissionsRegex = /<div[^>]+role="listitem"[^>]*>([^<]+).*?<\/div>/;
    function extractPermissionsFromRawGroup(rawData) {
        Android.showToast("google_apps.js injected0");
        return RegexUtils.findAllOccurrencesByRegex(self.key, "Permissions in Group", permissionsRegex.source, 1, rawData,
            function (value) {
                return value.trim().unescapeHtmlChars();
            }
        );
    };

    function getApps(page) {

        var isLearnMoreRegex = /<div[^>]+role="listitem"[^>]*>[^<]*<a/;
        var permissionGroupRegex = /<div[^>]+?role="listitem"[^>]*>[^<]*<div[^<]+<span[^<]+<img[^>]+src="([^"]+)"[^<]+<\/span>[^<]*<\/div>[^<]*<div[^>]+>([^<]+)<div[^<]+(<div[\s\S]+?<\/div>)[^<]*<\/div>[^<]*<\/div>[^<]*<\/div>/;
        var permissionGroupIconlessRegex = /<div[^>]+?role="listitem"[^>]*>[^<]*<div[^<]+<span[^<]+<\/span>[^<]*<\/div>[^<]*<div[^>]+>([^<]+)<div[^<]+(<div[\s\S]+?<\/div>)[^<]*<\/div>[^<]*<\/div>[^<]*<\/div>/;
        var additionalPermissionGroupRegex = /<div[^>]+?role="listitem"[^>]*>[^<]*<div[^>]+>[^<]+<div[^<]+(<div[\s\S]+?<\/div>)[^<]*<\/div>[^<]*<\/div>[^<]*<\/div>/;

        var rawAppsRegex = 'jscontroller[^<]+data-id[^<]+role="listitem".*?role="row".*?role="rowheader".*?role="gridcell".*?<\/div><\/div><\/div><\/div><\/div><\/content>';
        var rawAppsList = RegexUtils.findAllOccurrencesByRegex(self.key, 'List of Raw Apps', rawAppsRegex, 0, page);
        var appIdRegex = '<div class="CMEZce">([^"]+)</div>';
        var iconUrlRegex = '<div class="ShbWnb" aria-hidden="true"><img src="([^"]+)"';


        googleApps = rawAppsList
            .map(function (rawAppData) {
                var appId = RegexUtils.findValueByRegex(self.key, 'App Id+Name', appIdRegex, 1, rawAppData, true).trim().unescapeHtmlChars();
                var name = appId;

                var iconUrl = RegexUtils.findValueByRegex(self.key, 'App Icon', iconUrlRegex, 1, rawAppData, true).unescapeHtmlChars();

                /* TODO: This condition is probably not even relevant anymore */
                if ((iconUrl.indexOf("google.com") > -1 && iconUrl.indexOf("android") > -1) ||
                    (iconUrl.indexOf("gstatic.com") > -1 && iconUrl.indexOf("ios_icon") > -1)) {
                    /* Skip apps for Android and iOS. They have custom names so we can only know by the icon. */
                    return false;
                }

                var rawPermissionGroups = RegexUtils.findAllOccurrencesByRegex(self.key, "Permission Groups", permissionGroupRegex.source, 0, rawAppData,
                    function (value) {
                        return value.trim().unescapeHtmlChars();
                    }
                );

                permissionGroups = [];
                var permissionIconGroups = rawPermissionGroups.map(function (rawGroup) {
                    var groupData = RegexUtils.findMultiValuesByRegex(self.key, "Permission Group", permissionGroupRegex, [1, 2, 3], rawGroup, true);

                    var group = {
                        iconUrl: groupData[0].trim().unescapeHtmlChars(),
                        name: groupData[1].trim().unescapeHtmlChars()
                    };

                    var rawGroupContent = groupData[2];

                    Android.showToast("google_apps.js injected1");

                    if (!rawGroupContent.match(isLearnMoreRegex)) {
                        group.permissions = extractPermissionsFromRawGroup(rawGroupContent);
                    } else {
                        group.permissions = [group.name];
                    }

                    Android.showToast("google_apps.js injected2");

                    return group;
                });

                if (permissionIconGroups) {
                    permissionGroups = permissionGroups.concat(permissionIconGroups);
                }

                var rawPermissionIconlessGroups = RegexUtils.findAllOccurrencesByRegex(self.key, "Permission Groups", permissionGroupIconlessRegex.source, 0, rawAppData,
                    function (value) {
                        return value.trim().unescapeHtmlChars();
                    });

                var permissionIconlessGroups = rawPermissionIconlessGroups.map(function (rawGroup) {
                    var groupData = RegexUtils.findMultiValuesByRegex(self.key, "Permission Group", permissionGroupIconlessRegex, [1, 2], rawGroup, true);


                    var group = {
                        name: groupData[0].trim().unescapeHtmlChars()
                    };

                    var rawGroupContent = groupData[1];

                    if (!rawGroupContent.match(isLearnMoreRegex)) {
                        group.permissions = extractPermissionsFromRawGroup(rawGroupContent);
                    } else {
                        group.permissions = [group.name];
                    }

                    return group;
                });

                if (permissionIconlessGroups) {
                    permissionGroups = permissionGroups.concat(permissionIconlessGroups);
                }


                /* Additional permissions that don't have a group. See example #3 above */
                var rawAdditionalPermissionsGroup = RegexUtils.findValueByRegex(self.key, "Permission Group", additionalPermissionGroupRegex, 1, rawAppData, false);

                if (rawAdditionalPermissionsGroup) {
                    var additionalPermissions = extractPermissionsFromRawGroup(rawAdditionalPermissionsGroup);

                    permissionGroups.push({
                        permissions: additionalPermissions
                    });
                }

                return {
                    appId: appId,
                    iconUrl: iconUrl,
                    name: name,
                    permissionGroups: permissionGroups
                };
            });

        Android.onFinishedLoadingCallback(JSON.stringify(googleApps));

    }


    getApps(document.getElementsByTagName('html')[0].innerHTML);


//    doGetRequest("https://myaccount.google.com/permissions", getApps);
})();
