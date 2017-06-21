function DropDown(el) {
    this.dd = el;
    this.placeholder = this.dd.children('.current');
    this.opts = this.dd.find('ul.dropdown > li > a');
    this.val = '';
    this.index = -1;
    this.initEvents();
}
DropDown.prototype = {
    initEvents : function() {
        var obj = this;
        obj.dd.on('click', function(event){
			event.preventDefault();
            jQuery(this).toggleClass('active');
        });

		obj.opts.on('click',function(event){
			event.preventDefault();
			var opt = jQuery(this);
			obj.val = opt.html();
			obj.index = opt.index();
			jQuery(this).closest('.wrapper-dropdown').children('.current').html(obj.val);
			jQuery(this).closest('.wrapper-dropdown').next('.edit-menu-item-icon').val(jQuery(this).data('icon'));
		});
    },
	getValue : function() {
		return this.val;
	},
	getIndex : function() {
		return this.index;
	}
}

jQuery(function() {

	jQuery(document).click(function(event) {
		if(jQuery(event.target).attr('class') == "wrapper-dropdown" || jQuery(event.target).attr('class') == "wrapper-dropdown active")
			return;
		// all dropdowns
		jQuery('.wrapper-dropdown').removeClass('active');
	});

});