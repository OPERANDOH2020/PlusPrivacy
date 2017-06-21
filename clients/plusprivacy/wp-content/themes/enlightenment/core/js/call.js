jQuery(window).load(function() {
	if( typeof enlightenment_slider_args != 'undefined' ) {
		var selector = enlightenment_slider_args.selector;
		delete enlightenment_slider_args['selector'];
		jQuery(selector).flexslider(enlightenment_slider_args);
	}
	if( typeof enlightenment_carousel_args != 'undefined' ) {
		var selector = enlightenment_carousel_args.selector;
		delete enlightenment_carousel_args['selector'];
		jQuery(selector).flexslider(enlightenment_carousel_args);
	}
});

jQuery(document).ready(function($) {
	if( typeof enlightenment_masonry_args != 'undefined' ) {
		var $container = $(enlightenment_masonry_args.container);
		$container.imagesLoaded( function() {
			$container.masonry(enlightenment_masonry_args);
		});
	}
	if( typeof enlightenment_fluidbox_args != 'undefined' ) {
		$(enlightenment_fluidbox_args.selector).fluidbox();
	} else if( typeof enlightenment_colorbox_args != 'undefined' ) {
		$(enlightenment_colorbox_args.selector).colorbox(enlightenment_colorbox_args);
	} else if( typeof enlightenment_imagelightbox_args != 'undefined' ) {
		$(enlightenment_imagelightbox_args.selector).imageLightbox();
	}
	if( $.fn.fitVids )
		$('.entry-attachment, .entry-content').fitVids({
			customSelector: "embed[src*='wordpress.com'], embed[src*='wordpress.tv'], iframe[src*='wordpress.com'], iframe[src*='wordpress.tv'], iframe[src*='www.dailymotion.com'], iframe[src*='blip.tv'], iframe[src*='www.viddler.com']",
		});
	if( typeof enlightenment_ajax_navigation_args != 'undefined' ) {
		var selector = enlightenment_ajax_navigation_args.selector;
		delete enlightenment_ajax_navigation_args['selector'];
		enlightenment_ajax_navigation_args['complete'] = function(items) {
			if( typeof enlightenment_masonry_args != 'undefined' ) {
				var $container = $(enlightenment_masonry_args.container);
				$container.imagesLoaded( function() {
					$container.masonry('appended', items);
				});
			}
			if( typeof $.fn.fitVids != 'undefined' )
				$('.entry-attachment, .entry-content').fitVids({
					customSelector: "embed[src*='wordpress.com'], embed[src*='wordpress.tv'], iframe[src*='wordpress.com'], iframe[src*='wordpress.tv'], iframe[src*='www.dailymotion.com'], iframe[src*='blip.tv'], iframe[src*='www.viddler.com']",
				});
			$('.wp-audio-shortcode, .wp-video-shortcode').css('visibility', 'visible');
		}
		$(selector).ajaxload(enlightenment_ajax_navigation_args);
	}
	if( typeof enlightenment_infinite_scroll_args != 'undefined' ) {
		$(enlightenment_infinite_scroll_args.contentSelector).infinitescroll(enlightenment_infinite_scroll_args, function(items) {
			if( typeof enlightenment_masonry_args != 'undefined' ) {
				var $container = $(enlightenment_masonry_args.container);
				$container.imagesLoaded( function() {
					$container.masonry('appended', items);
				});
			}
			if( typeof $.fn.fitVids != 'undefined' )
				$('.entry-attachment, .entry-content').fitVids({
					customSelector: "embed[src*='wordpress.com'], embed[src*='wordpress.tv'], iframe[src*='wordpress.com'], iframe[src*='wordpress.tv'], iframe[src*='www.dailymotion.com'], iframe[src*='blip.tv'], iframe[src*='www.viddler.com']",
				});
			$('.wp-audio-shortcode, .wp-video-shortcode').css('visibility', 'visible');
		});
		$(enlightenment_infinite_scroll_args.navSelector).hide();
	}
	
	if( $('.background-parallax').length && document.documentElement.clientWidth >= 1200 ) {
		var offset = 0;
		var navbarOffset = 0;
		var windowHeight = $(window).height();
		if( $('.navbar-fixed-top').length ) {
			navbarOffset = $('.navbar-fixed-top').outerHeight();
		}
		$('.background-parallax').each(function() {
			$this = $(this);
			$parent = $this.parent();
			if( $parent.offset().top > 0 ) {
				offset = -Math.min($parent.offset().top - navbarOffset, windowHeight - navbarOffset) / 4;
			}
			if( 0 !== offset ) {
				$this.css('margin-top', offset);
			}
		});
		
		var raf = requestAnimationFrame || mozRequestAnimationFrame || webkitRequestAnimationFrame || msRequestAnimationFrame;
		var ticking = false;
		var $items = $('.background-parallax');
		
		function enlightenment_parallax_background() {
			ticking = false;
			var st = window.scrollY;
			var translateY = 0;
			$items.each(function() {
				var $this = $(this);
				var $parent = $this.parent();
				var vh = document.documentElement.clientHeight;
				var ph = $parent.outerHeight();
				var ot = $parent.offset().top;
				if( st > Math.max( 0, ot - vh ) && st < ot + ph ) {
					translateY = st / 4;
					if( ot > vh ) {
						translateY = ( st - ot + vh ) / 4;
					}
					$this.css('transform', 'translate3d(0, ' + translateY + 'px, 0)');
				} else {
					$this.css('transform', 'translate3d(0, 0, 0)');
				}
			});
		}
		
		window.addEventListener('scroll', function() {
			if( ! ticking && raf ) {
				raf(enlightenment_parallax_background);
			}
			ticking = true;
		});
	}
});