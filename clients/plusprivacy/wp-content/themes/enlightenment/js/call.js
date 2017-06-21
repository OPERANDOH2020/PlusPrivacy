jQuery(document).ready(function($) {
	var raf = requestAnimationFrame || mozRequestAnimationFrame || webkitRequestAnimationFrame || msRequestAnimationFrame;
	
	if( $('.navbar-nav.navbar-right').length ) {
		var $navbar = $('#masthead');
		var $nav = $('.navbar-nav', $navbar);
		var $body = $('body');
		
		function enlightenment_fix_nav_position() {
			nav_tick = false;
			
			if( $(window).width() >= 768 ) {
				if( ( $nav.offset().top - $navbar.offset().top - parseInt( $navbar.css('padding-top') ) > 0 ) ) {
					$nav.removeClass('navbar-right');
					$body.css('margin-top', $navbar.outerHeight());
				} else if( ( $nav.offset().top - $navbar.offset().top - parseInt( $navbar.css('padding-top') ) == 0 ) ) {
					$nav.addClass('navbar-right');
					$body.css('margin-top', '');
				}
			} else {
				$body.css('margin-top', '');
			}
		}
		
		if( raf ) {
			raf(enlightenment_fix_nav_position);
		} else {
			enlightenment_fix_nav_position();
		}
		
		var nav_tick = false;
		
		$(window).resize(function() {
			
			if( ! nav_tick && raf ) {
				raf(enlightenment_fix_nav_position);
			} else if( ! raf ) {
				enlightenment_fix_nav_position();
			}
			
			nav_tick = true;
		});
	}
	
	$('.searchform-dropdown').on('shown.bs.dropdown', function() {
		$('#s').focus();
	});
	
	var navbar_offset = $('#masthead').offset().top;
	if($('.subnav').length) {
		var subnav_offset = $('.subnav').offset().top - 70;
	}
	
	if( $('.navbar-transparent').length ) {
		var offset = $('.navbar').outerHeight() + 30;
		var tick = false;
		var lastScrollTop = 0;
		
		function enlightenment_stick_navbar() {
			tick = false;
			var st = window.scrollY;
			
			if( st > offset && st > lastScrollTop ) {
				$('.navbar').removeClass('navbar-inverse');
				$('.navbar').addClass('navbar-default');
			} else if( st <= 20 ) {
				$('.navbar').removeClass('navbar-default');
				$('.navbar').addClass('navbar-inverse');
			}
		}
		
		window.addEventListener('scroll', function() {
			if( ! tick && raf ) {
				raf(enlightenment_stick_navbar);
			}
			tick = true;
		});
	}
	
	$(document).scroll(function() {
		if($('.subnav').length) {
			if( document.body && document.body.scrollTop > subnav_offset ) {
				$('.subnav').addClass('subnav-fixed');
				$('#page').addClass('page-subnav-offset');
			} else {
				$('.subnav').removeClass('subnav-fixed');
				$('#page').removeClass('page-subnav-offset');
			}
		}
	});
	
	var offset = $('.navbar').outerHeight() + 30;
	var ticker = false;
	
	function enlightenment_shrink_navbar() {
		ticker = false;
		var st = window.scrollY;
		
		if( typeof enlightenment_theme_call_js != 'undefined' && 1 == enlightenment_theme_call_js.shrink_navbar ) {
			if( st > offset ) {
				$('#masthead').removeClass('navbar-large');
			}
			
			if( st <= 20 ) {
				$('#masthead').addClass('navbar-large');
			}
		}
	}
	
	window.addEventListener('scroll', function() {
		if( ! ticker && raf ) {
			raf(enlightenment_shrink_navbar);
		}
		ticker = true;
	});
	
	function enlightenment_scroll_to_content(target) {
		$('html, body').animate({
	        scrollTop: $(target).offset().top - 59
	    }, 250);
	}
	
	$('.scroll-to-content a').click(function(event) {
		event.preventDefault();
		var target = $(this).attr('href');
		
		
		if( raf ) {
			raf(function() {
				enlightenment_scroll_to_content(target);
			});
		} else {
			$('html, body').scrollTop( $(target).offset().top - 59 );
		}
	});
	
	$('.nav > .dropdown > a:first-child').each(function() {
		if($(this).attr('href').substr(0,1) != '#') {
			$('li:first-child', $(this).parent()).not($('ul ul li', $(this).parent())).before('<li class="menu-item">' + $('<div>').append($(this).clone()).remove().html() + '</li>');
			$('li:first-child > a > .caret', $(this).parent()).remove();
		}
		$(this).attr('href', '#' + $(this).parent().attr('id'));
		$(this).addClass('dropdown-toggle');
		$(this).attr('data-toggle', 'dropdown');
	});
	$('.gallery-item').hover(function() {
		var top = $(this).position().top;
		var left = $(this).position().left;
		var width = $(this).width();
		var height = $(this).height() + 1;
		var marginLeft = $(this).width() + parseInt($(this).css('marginLeft')) * 2 + parseInt($(this).css('marginRight'));
		var nexttop = $(this).next().position().top;
		var nextleft = $(this).next().position().left;
		$(this).css({
			position: 'absolute',
			top: top,
			left: left,
		});
		$(this).after('<figure class="gallery-item dummy"></figure>')
		$(this).next('.dummy').css({
			width: width,
			height: height,
		});
		$('.gallery-caption', this).css({
			padding: '10px',
			height: 'auto',
		});
	}, function() {
		$('.gallery-caption', this).css({
			padding: 0,
			height: 0,
		});
		$(this).css({
			position: 'static',
		});
		$(this).next('.dummy').remove();
	});
	if( $.fn.tooltip ) {
		$('.custom-query-gallery .entry-media a').tooltip();
	}
});