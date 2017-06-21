var privacyPlusApp = window.privacyPlusApp = angular.module("plusprivacy", ['angularModalService', 'ui-notification',
    'sharedService','mgcrea.ngStrap']);
privacyPlusApp.config(function (NotificationProvider) {
    NotificationProvider.setOptions({
        delay: 10000,
        startTop: 20,
        startRight: 10,
        verticalSpacing: 20,
        horizontalSpacing: 20,
        positionX: 'left',
        positionY: 'bottom'
    })
});

privacyPlusApp.filter('timeAgo', [function() {
    return function(object)
    {
        return timeSince(new Date(object));
    }
}]);


privacyPlusApp.filter('timestampToDateFormat', [function() {
    return function(object) {
        var d = new Date(object);
        var datestring = ("0" + d.getDate()).slice(-2) + "-" + ("0"+(d.getMonth()+1)).slice(-2) + "-" +
            d.getFullYear();
        return datestring;
    }
}]);

privacyPlusApp.filter('isEmpty', [function() {
    return function(object) {
        return angular.equals({}, object);
    }
}]);

