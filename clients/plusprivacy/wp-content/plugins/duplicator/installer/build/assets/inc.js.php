<?php
	// Exit if accessed directly
	if (! defined('DUPLICATOR_INIT')) {
		$_baseURL = "http://" . strlen($_SERVER['SERVER_NAME']) ? $_SERVER['SERVER_NAME'] : $_SERVER['HTTP_HOST'];
		header("HTTP/1.1 301 Moved Permanently");
		header("Location: $_baseURL");
		exit; 
	}
?>

<script type="text/javascript">
	//Unique namespace
	Duplicator = new Object();

	Duplicator.showProgressBar = function () {
		Duplicator.animateProgressBar('progress-bar');
		$('#ajaxerr-area').hide();
		$('#progress-area').show();
	}
	Duplicator.hideProgressBar = function () {
		$('#progress-area').hide(100);
		$('#ajaxerr-area').fadeIn(400);
	}
	Duplicator.animateProgressBar = function(id) {
		//Create Progress Bar
		var $mainbar   = $("#" + id);
		$mainbar.progressbar({ value: 100 });
		$mainbar.height(25);
		runAnimation($mainbar);

		function runAnimation($pb) {
			$pb.css({ "padding-left": "0%", "padding-right": "90%" });
			$pb.progressbar("option", "value", 100);
			$pb.animate({ paddingLeft: "90%", paddingRight: "0%" }, 3500, "linear", function () { runAnimation($pb); });
		}
	}

	
	Duplicator.toggleMetaBox = function() {
		var $title = jQuery(this);
		var $panel = $title.parent().find('.dup-box-panel');
		var $arrow = $title.parent().find('.dup-box-arrow');
		var value = $panel.is(":visible") ? 0 : 1;
		$panel.toggle();
		(value) ? $arrow.html('-') : $arrow.html('+');
	}	
	
	$(document).ready(function() {
		//ATTACHED EVENTS
		$('#dup-hlp-lnk').change(function() {
			if ($(this).val() != "null") 
				window.open($(this).val())
		});
		
		//Init: Toggle MetaBoxes
		$('div.dup-box div.dup-box-title').each(function() { 
			var $title = $(this);
			var $panel = $title.parent().find('.dup-box-panel');
			var $arrow = $title.find('.dup-box-arrow');
			$title.click(Duplicator.toggleMetaBox); 
			($panel.is(":visible")) ? $arrow.html('-') : $arrow.html('+');
		});
		
	});
</script>
