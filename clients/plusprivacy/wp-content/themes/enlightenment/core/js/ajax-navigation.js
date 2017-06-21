(function ($) {
	var defaults = {
		type: 'GET',
		next: '.next a, a.next',
		data: {
			action: 'enlightenment_ajax_load',
		},
		content: '#content',
		item: '.hentry',
		label: 'Load more posts',
		loading: 'Loading&#8230;',
		image: 'http://localhost:8888/enlightenment/wp-content/themes/enlightenment/core/img/colorbox/loading.gif',
		complete: '',
	};
	$.fn.ajaxload = function(options) {
		var settings = $.extend(defaults, options );
		var container = this;
		var ajaxurl = $(settings.next, container).attr('href');
		var next = $(settings.next, container);
		if(next.length) {
			container.hide();
			var image = '';
			if(settings.image != '')
				image = '<img src="' + settings.image + '" />';
			container.after('<a class="ajax-nav" href="' + next.attr('href') + '">' + image + '<span>' + settings.label + '</span></a>');
			var ajax_link = container.next('.ajax-nav');
			$('img', ajax_link).hide();
			ajax_link.click(function() {
				$.ajax({
					type: settings.type,
					url: ajaxurl,
					data: settings.data,
					beforeSend: function() {
						$('img', ajax_link).show();
						$('span', ajax_link).html(settings.loading);
					},
					complete: function() {
						$('img', ajax_link).hide();
						$('span', ajax_link).html(settings.label);
					},
				}).done(function(response) {
					var helper = document.createElement('div');
					helper = $(helper);
					helper.html(response);
					if(settings.type == 'GET')
						var content = $(settings.content, helper);
					else if(settings.type == 'POST')
						var content = helper;
					var items = $(settings.item, content);
					items.each(function() {
						var item = $(this);
						var content = $(settings.content);
						var last_item = $(settings.item, content).last();
						last_item.after(item);
					});
					var selector = container.selector;
					var posts_nav = $(selector, helper);
					var next = $(settings.next, posts_nav).attr('href');
					if(typeof next !== 'undefined') {
						ajaxurl = next;
						$(settings.next, container).attr('href', next);
						ajax_link.attr('href', next);
					} else {
						ajax_link.hide();
					}
					if( typeof settings.complete == 'function' ) {
						settings.complete(items);
					}
				});
				return false;
			});
		}
	};
}(jQuery));


