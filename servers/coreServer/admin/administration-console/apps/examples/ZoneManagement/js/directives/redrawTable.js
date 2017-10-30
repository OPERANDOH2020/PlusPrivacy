angular.module('app')
	.directive('redrawTable', function() {
		return function(scope, element, attrs) {
			var table = $("#zonesTable");
			table[0].style.visibility = "hidden";

			if (scope.$last){
				table.trigger('footable_redraw');
				table[0].style.visibility = "visible";

				table.footable().bind({
					'footable_paging' : function(e) {
						scope.$root.$broadcast("pageChanged", e.page)
						//return confirm('Do you want to goto page: ' + e.page);
					}
				});

			}

		};
	});