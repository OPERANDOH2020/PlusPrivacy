angular.module("app").directive("jsonEditor", ["$rootScope", function ($rootScope) {
return {
    restrict: "E",
    replace: true,
    scope: {
        untouchedJson:"=",
        actualJson: "="
    },
    link:function(scope){

        scope.$watch('actualJson', function() {
            var delta = jsondiffpatch.diff(scope.untouchedJson, scope.actualJson);
            document.getElementById('json-visual').innerHTML = jsondiffpatch.formatters.html.format(delta, scope.untouchedJson);
        });

    },
    templateUrl: "/templates/directives/json-editor.html"

}
}]);
