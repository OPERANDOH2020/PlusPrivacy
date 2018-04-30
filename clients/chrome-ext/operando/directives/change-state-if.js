/**
 * credit to https://stackoverflow.com/questions/25600071/how-to-achieve-that-ui-sref-be-conditionally-executed/25636705
 */
angular.module('UIComponent').directive('changeStateIf', ['$parse', '$rootScope',"$state",
    function($parse, $rootScope, $state) {
        return {
            // this ensure eatClickIf be compiled before ngClick
            priority: 100,
            restrict: 'A',
            compile: function($element, attr) {
                var fn = $parse(attr.changeStateIf);
                return {
                    pre: function link(scope, element) {
                        var eventName = 'click';
                        element.on(eventName, function(event) {
                            var callback = function() {
                                var changedState = fn(scope, {$event: event});
                                if (changedState.condition) {
                                    $state.go(changedState.state);
                                    // prevents ng-click to be executed
                                    event.stopImmediatePropagation();
                                    // prevents href
                                    event.preventDefault();
                                    return false;
                                }
                            };
                            if ($rootScope.$$phase) {
                                scope.$evalAsync(callback);
                            } else {
                                scope.$apply(callback);
                            }
                        });
                    },
                    post: function() {}
                }
            }
        }
    }
]);
