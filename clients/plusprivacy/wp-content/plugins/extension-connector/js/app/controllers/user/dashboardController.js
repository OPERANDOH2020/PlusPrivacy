privacyPlusApp.controller("dashboardController", function ($scope, userService,SharedService,connectionService, Notification) {
    userService.getUser(function(user){
        $scope.currentUser = user.email;
        $scope.$apply();
    });

    $scope.goToDashboard = function(){
        messengerService.send("goToDashboard", function(response){
            if(response.data === "sendMeAuthenticationToken"){
                connectionService.generateAuthenticationToken(function(userId,authenticationToken){
                        messengerService.send("authenticateUserInExtension", {
                            userId: userId,
                            authenticationToken: authenticationToken
                        }, function(){});
                },
                function(errorMessage){
                    Notification.error({
                        message: errorMessage +'\nAn error occurred! Please try again or refresh this page!',
                        positionY: 'bottom',
                        positionX: 'center',
                        delay: 2000
                    });
                });
            }
        });
    };

    SharedService.setLocation("userDashboard");
});
angular.element(document).ready(function() {
    angular.bootstrap(document.getElementById('user_dashboard'), ['plusprivacy']);
});