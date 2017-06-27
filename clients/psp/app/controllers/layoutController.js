pspApp.controller("layoutController", function ($scope, $location) {
    $scope.pagename = function () {
        return $location.path();
    };
});
