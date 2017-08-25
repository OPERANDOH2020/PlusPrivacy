privacyPlusApp.controller("uninstallController", function ($scope, connectionService) {
    var deviceId = getParameterByName("deviceId");
    connectionService.sendUninstallEvent(deviceId);
});
angular.element(document).ready(function() {
    angular.bootstrap(document.getElementById('device_removed'), ['plusprivacy']);
});