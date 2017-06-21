angular.module('UIComponent').
    directive("uiLoader", function () {
        return {
            restrict: 'E',
            replace: true,
            scope: {status: "=?"},
            templateUrl: '/operando/tpl/ui/loader.html',
            controller: function ($scope) {
                if (angular.isDefined($scope.status)) {
                    switch ($scope.status) {
                        case "pending":
                            break;
                        case "completed":
                            break;
                        default:
                            $scope.status = "pending";
                    }

                } else {
                    $scope.status = "pending";
                }
            }

        }
    })
    .directive("copyToClipboard", function () {
        return {
            restrict: "E",
            replace: true,
            scope: {
                data : "="
            },
            templateUrl: "/operando/tpl/ui/copy-to-clipboard.html",
            link: function ($scope, element) {

                var last_clicked_el = null;

                function tipsyToolTipText() {
                    if (this === last_clicked_el) {
                        last_clicked_el = null;
                        return this.getAttribute('data-copied-hint');
                    } else {
                        return this.getAttribute('original-title');
                    }
                }


                // Setup tooltips
                $(function () {
                    $(element).tipsy({
                        fade: true,
                        gravity: 's',
                        title: tipsyToolTipText
                    });
                });


                // Click hander for button
                $(element).click(function (e) {
                    last_clicked_el = e.delegateTarget;
                    $(element).tipsy("hide");
                    $(element).tipsy("show");

                    var handleCopyFn = function(e) {
                        var textToPutOnClipboard = $scope.data;
                        e.clipboardData.setData('text/plain', textToPutOnClipboard);
                        e.preventDefault();
                    }

                    document.addEventListener('copy', handleCopyFn);
                    document.execCommand("copy", false, null);
                    document.removeEventListener("copy", handleCopyFn)

                });
            },
            controller: function ($scope) {


            }
        }
    });
