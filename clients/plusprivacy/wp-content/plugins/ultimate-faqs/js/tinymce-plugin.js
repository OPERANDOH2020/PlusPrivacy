(function() {
    tinymce.PluginManager.add('UFAQ_Shortcodes', function( editor, url ) {
        //editor.on('init', function(args){EWD_UFAQ_Disable_Non_Premium();});
        editor.addButton( 'UFAQ_Shortcodes', {
            title: 'FAQ Shortcodes',
            text: 'FAQs',
            type: 'menubutton',
            icon: 'wp_code',
            menu: [{
            	text: 'Display FAQs',
            	value: 'ultimate-faqs',
            	onclick: function() {
				    var win = editor.windowManager.open( {
				        title: 'Insert Ultimate FAQs Shortcode',
				        body: [{
            				type: 'listbox',
            				name: 'post_count',
            				label: '# of FAQs:',
				            'values': [
            				    {text: 'All', value: '-1'},
            				    {text: '1', value: '1'},
            				    {text: '2', value: '2'},
            				    {text: '3', value: '3'},
            				    {text: '4', value: '4'},
            				    {text: '5', value: '5'}
            				]
				        },
				        {
            				type: 'listbox',
            				name: 'include_category',
            				label: 'Category to include:',
				            'values': EWD_UFAQ_Create_Category_List('All')
				        },
				        {
            				type: 'listbox',
            				name: 'exclude_category',
            				label: 'Category to exclude:',
				            'values': EWD_UFAQ_Create_Category_List('None')
				        }],
				        onsubmit: function( e ) {
				            if (e.data.post_count != -1) {var post_text = "post_count='" + e.data.post_count + "'";}
				            else {var post_text = "";}
				            if (e.data.include_category != -1) {var inc_cat_text = "include_category='" + e.data.include_category + "'";}
				            else {var inc_cat_text = "";}
				            if (e.data.exclude_category != -1) {var excl_cat_text = "exclude_category='" + e.data.exclude_category + "'";}
				            else {var excl_cat_text = "";}

				            editor.insertContent( '[ultimate-faqs '+post_text+' '+inc_cat_text+' '+excl_cat_text+']');
				        }
				    });
				}
			},
			{
            	text: 'Search FAQs',
            	onPostRender: function() {EWD_UFAQ_Search_Non_Premium();},
            	value: 'ultimate-faq-search',
            	id: 'faq-search',
            	onclick: function() {
				    var premium = EWD_UFAQ_Is_Premium();
				    if (!premium) {return;}

				    var win = editor.windowManager.open( {
				        title: 'Insert Ultimate FAQs Shortcode',
				        body: [{
            				type: 'listbox',
            				name: 'include_category',
            				label: 'Category to include:',
				            'values': EWD_UFAQ_Create_Category_List('All')
				        },
				        {
            				type: 'listbox',
            				name: 'exclude_category',
            				label: 'Category to exclude:',
				            'values': EWD_UFAQ_Create_Category_List('None')
				        },
				        {
            				type: 'checkbox',
            				name: 'show_on_load',
            				label: 'Show all FAQs on pageload:'
				        }],
				        onsubmit: function( e ) {
				            if (e.data.include_category != -1) {var inc_cat_text = "include_category='" + e.data.include_category + "'";}
				            else {var inc_cat_text = "";}
				            if (e.data.exclude_category != -1) {var excl_cat_text = "exclude_category='" + e.data.exclude_category + "'";}
				            else {var excl_cat_text = "";}
				            if (e.data.show_on_load) {var show_on_load_text = "show_on_load='Yes'";}
				            else {var show_on_load_text = "";}

				            editor.insertContent( '[ultimate-faq-search '+inc_cat_text+' '+excl_cat_text+' '+show_on_load_text+']');
				        }
				    });
				}
			},
			{
            	text: 'Submit FAQ',
            	value: 'submit-question',
            	onPostRender: function() {EWD_UFAQ_Submit_Non_Premium();},
            	id: 'faq-question',
            	onclick: function() {
				    var premium = EWD_UFAQ_Is_Premium();
				    if (!premium) {return;}

				    editor.insertContent( '[submit-question]' );
				}
			},
			{
            	text: 'Recent FAQs',
            	value: 'recent-faqs',
            	onclick: function() {
				    var win = editor.windowManager.open( {
				        title: 'Insert Ultimate FAQs Shortcode',
				        body: [{
            				type: 'listbox',
            				name: 'post_count',
            				label: '# of FAQs:',
				            'values': [
            				    {text: 'All', value: '-1'},
            				    {text: '1', value: '1'},
            				    {text: '2', value: '2'},
            				    {text: '3', value: '3'},
            				    {text: '4', value: '4'},
            				    {text: '5', value: '5'}
            				]
				        }],
				        onsubmit: function( e ) {
				            if (e.data.post_count != -1) {var post_text = "post_count='" + e.data.post_count + "'";}
				            else {var post_text = "";}

				            editor.insertContent( '[recent-faqs '+post_text+']');
				        }
				    });
				}
			},
			{
            	text: 'Popular FAQs',
            	value: 'popular-faqs',
            	onclick: function() {
				    var win = editor.windowManager.open( {
				        title: 'Insert Ultimate FAQs Shortcode',
				        body: [{
            				type: 'listbox',
            				name: 'post_count',
            				label: '# of FAQs:',
				            'values': [
            				    {text: 'All', value: '-1'},
            				    {text: '1', value: '1'},
            				    {text: '2', value: '2'},
            				    {text: '3', value: '3'},
            				    {text: '4', value: '4'},
            				    {text: '5', value: '5'}
            				]
				        }],
				        onsubmit: function( e ) {
				            if (e.data.post_count != -1) {var post_text = "post_count='" + e.data.post_count + "'";}
				            else {var post_text = "";}

				            editor.insertContent( '[popular-faqs '+post_text+']');
				        }
				    });
				}
			}],
        });
    });
})();


function EWD_UFAQ_Create_Category_List(initial) {
	if (initial == "All") {var result = [{text: 'All', value: '-1'}];}
	else {var result = [{text: 'None', value: '-1'}];}
    var d = {};

	jQuery(ufaq_categories).each(function(index, el) {
		var d = {};
		console.log(el);
		d['text'] = el.name;
		d['value'] = el.slug;
		console.log(d);
		result.push(d)
		console.log(result);
	});

    return result;
}

function EWD_UFAQ_Search_Non_Premium() {
	var premium = EWD_UFAQ_Is_Premium();

	if (!premium) {
		jQuery('#faq-search').css('opacity', '0.5');
		jQuery('#faq-search').css('cursor', 'default');
	}
}

function EWD_UFAQ_Submit_Non_Premium() {
	var premium = EWD_UFAQ_Is_Premium();

	if (!premium) {
		jQuery('#faq-question').css('opacity', '0.5');
		jQuery('#faq-question').css('cursor', 'default');
	}
}

function EWD_UFAQ_Is_Premium() {
	if (ufaq_premium == "Yes") {return true;}
	
	return false;
}
