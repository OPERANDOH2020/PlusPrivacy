angular.module("app").directive("settingEditor", ["$rootScope", function ($rootScope) {

    return {
        restrict: "E",
        replace: true,
        scope: {
            settingKey: "=",
            setting: "="
        },
        controller: ["$scope", function ($scope) {
            $scope.availableTags = ["exposure","contact","discovery", "control", "personal data", "applications", "advertising", "profiling"];
            $scope.jqueryElementTypes=["attrValue","checkbox","inner","classname","radio","selected","length"];

            $scope.editMode = false;
            $scope.newOption = {};
            $scope.addNewOptionIsVisible=false;

            $scope.toggleAddNewOption = function(){
                $scope.addNewOptionIsVisible = !$scope.addNewOptionIsVisible;
            };
            $scope.edit = function () {
                $rootScope.$broadcast('closeEditMode');
                $scope.editMode = true;
            };

            $scope.deleteSetting = function () {
                $rootScope.$broadcast('deleteSNSetting',$scope.setting.id);
            };

            $scope.toggleActivation = function(){
                if(typeof $scope.setting.isActive != "undefined"){
                    $scope.setting.isActive = !$scope.setting.isActive;
                }
                else{
                    $scope.setting.isActive = false;
                }
            };

            $scope.removeReadOption = function(option){
                if($scope.setting.read.availableSettings[option]){
                    delete $scope.setting.read.availableSettings[option];
                }
            };

            $scope.insertReadOption = function(){
                if($scope.newOption.key && !$scope.setting.read.availableSettings[$scope.newOption.key]){
                    $scope.setting.read.availableSettings[$scope.newOption.key] = {
                        name: $scope.newOption.name
                    };
                    $scope.newOption = {};
                }
            };

            $scope.$on('closeEditMode', function (event) {
                $scope.editMode = false;
            });


        }],
        templateUrl: "/templates/directives/edit-setting.html"
    }
}]);
