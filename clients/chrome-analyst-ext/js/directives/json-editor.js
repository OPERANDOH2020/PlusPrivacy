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
            var differences = jsondiffpatch.formatters.html.format(delta, scope.untouchedJson);
            if(differences){
                document.getElementById('json-visual').innerHTML = differences;
            }else{
                document.getElementById('json-visual').innerHTML = "No differences";
            }


        });

    },
    templateUrl: "/templates/directives/json-editor.html"

}
}]);
