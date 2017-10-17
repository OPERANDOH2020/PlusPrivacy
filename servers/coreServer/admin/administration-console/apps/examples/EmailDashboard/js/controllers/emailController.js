'use strict';
app.controller('emailController', ['$scope','ModalService','swarmHubService',
    function ($scope,ModalService,swarmHubService) {

        var swarmHub = swarmHubService.hub;

        $scope.email = {};
        $scope.emailDeliveryUnsuccessful = false;
        $scope.errorOccured = false;
        $scope.host = "";
        $scope.hostRegex = ".+@"+$scope.host+"$";

        $scope.fromIsValid = function(){
            try {
                return $scope.email.from.endsWith($scope.host);
            }catch(e){
                return false;
            }
        }

        swarmHub.startSwarm("zones.js","getAllZones");
        swarmHub.startSwarm("emails.js","getEmailHost");

        $scope.add = function() {
            var f = document.getElementById('file').files[0];
            var r = new FileReader();

            r.onloadend = function(e) {
                $scope.email.users = e.target.result.split(new RegExp("\",\ ")).filter(function (user) {
                    return user.length>1;
                });
                delete $scope.email.zone;
            };
            r.readAsText(f);
        };

        $scope.sendEmail = function(){
            if($scope.email.zone){
                $scope.email.to = $scope.email.zone;
            }else{
                $scope.email.to = $scope.email.users;
            }

            $scope.emailWasSent = false;
            $scope.errorOccured = false;

            ModalService.showModal({
                templateUrl: "tpl/modals/previewEmail.html",
                controller: "previewEmailController",
                inputs:{
                    "email":$scope.email
                }
            }).then(function(modal) {
                modal.element.modal();
                modal.close.then(function(email) {
                    swarmHub.startSwarm("emails.js","sendMultipleEmails",email.from,email.to,email.subject,email.content);
                });
            });
        };

        swarmHub.on("emails.js","emailDeliverySuccessful",function(swarm){
            $scope.emailDeliveryUnsuccessful = true;
            $scope.email = {};
            $scope.$apply();
        });

        swarmHub.on("emails.js","emailDeliveryUnsuccessful",function(swarm){
            $scope.errorOccured = true;
            console.log("Error "+swarm.err+" occured")
        });

        swarmHub.on("zones.js","gotAllZones",function(swarm){
            $scope.zones = swarm.zones;
            $scope.$apply();
        });

        swarmHub.on("emails.js","gotEmailHost",function(swarm){
            $scope.host = swarm.host;
            $scope.hostRegex = ".+@"+$scope.host+"$";
            $scope.$apply();
        })

    }]);

app.controller('previewEmailController', ['$scope',"email","$element",'close', function($scope,email,$element, close) {
    var template={
        "subject":"Subject: ",
        "to":"To: ",
        "from":"From: ",
        "content":"Content: "
    }

    $scope.previewEmail = {};
    for(var field in template){
        if(email[field]) {
            $scope.previewEmail[field] = template[field] + email[field];
            if($scope.previewEmail[field].length>500){
                $scope.previewEmail[field] = $scope.previewEmail[field].slice(0,497)+"...";
            }
        }
    }

    $scope.send = function(){
        $element.modal('hide');
        close(email,500);
    }
}]);
