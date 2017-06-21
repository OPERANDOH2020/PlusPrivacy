angular.module("settingEditor", ['ng']).directive("settingEditor", ["$rootScope", function ($rootScope) {

    return {
        restrict: "E",
        replace: true,
        scope: {
            settingKey: "=",
            setting: "="
        },
        controller: ["$scope", function ($scope) {
            $scope.setting.tags = ["Public", "Visibility"];
            $scope.availableTags = ["Privacy","Personal Data","Public", "Visibility"];
            $scope.jqueryElementTypes=["attrValue","checkbox","inner","classname","radio","selected","length"];

            $scope.editMode = false;
            $scope.newOption = {};
            $scope.addNewOptionIsVisible=false;

            $scope.toggleAddNewOption = function(){
                $scope.addNewOptionIsVisible = !$scope.addNewOptionIsVisible;
            }
            $scope.edit = function () {
                $rootScope.$broadcast('closeEditMode');
                $scope.editMode = true;
            }

            $scope.removeReadOption = function(option){
                if($scope.setting.read.availableSettings[option]){
                    delete $scope.setting.read.availableSettings[option];
                }
            }

            $scope.insertReadOption = function(){
                if($scope.newOption.key && !$scope.setting.read.availableSettings[$scope.newOption.key]){
                    $scope.setting.read.availableSettings[$scope.newOption.key] = {
                        name: $scope.newOption.name
                    }
                    $scope.newOption = {};
                }
            }

            $scope.$on('closeEditMode', function (event) {
                $scope.editMode = false;
            });


        }],
        templateUrl: "/operando/tpl/settings-editor/edit-setting.html"
    }
}]);
