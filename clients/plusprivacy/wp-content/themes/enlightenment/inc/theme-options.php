<?php

add_filter( 'enlightenment_theme_options_page_tabs', 'enlightenment_theme_options_tabs' );

function enlightenment_theme_options_tabs( $tabs ) {
	$tabs['design']     = __( 'Design', 'enlightenment' );
	$tabs['typography'] = __( 'Typography', 'enlightenment' );
	$tabs['seo']        = __( 'SEO', 'enlightenment' );
	return $tabs;
}

add_action( 'enlightenment_general_settings_sections', 'enlightenment_general_settings' );

function enlightenment_general_settings() {
	add_settings_section(
		'navbar', // Unique identifier for the settings section
		__( 'Navbar', 'enlightenment' ), // Section title
		'__return_false', // Section callback (we don't want anything)
		'enlightenment_theme_options' // Menu slug, used to uniquely identify the page
	);
	add_settings_section(
		'page_header', // Unique identifier for the settings section
		__( 'Page Header', 'enlightenment' ), // Section title
		'__return_false', // Section callback (we don't want anything)
		'enlightenment_theme_options' // Menu slug, used to uniquely identify the page
	);
	add_settings_section(
		'post_thumbnails', // Unique identifier for the settings section
		__( 'Post Thumbnails', 'enlightenment' ), // Section title
		'__return_false', // Section callback (we don't want anything)
		'enlightenment_theme_options' // Menu slug, used to uniquely identify the page
	);
	add_settings_section(
		'entry_meta', // Unique identifier for the settings section
		__( 'Entry Meta', 'enlightenment' ), // Section title
		'__return_false', // Section callback (we don't want anything)
		'enlightenment_theme_options' // Menu slug, used to uniquely identify the page
	);
	add_settings_section(
		'lightbox', // Unique identifier for the settings section
		__( 'Lightbox', 'enlightenment' ), // Section title
		'__return_false', // Section callback (we don't want anything)
		'enlightenment_theme_options' // Menu slug, used to uniquely identify the page
	);
	add_settings_section(
		'posts_nav', // Unique identifier for the settings section
		__( 'Posts Navigation', 'enlightenment' ), // Section title
		'__return_false', // Section callback (we don't want anything)
		'enlightenment_theme_options' // Menu slug, used to uniquely identify the page
	);
	add_settings_section(
		'footer', // Unique identifier for the settings section
		__( 'Footer', 'enlightenment' ), // Section title
		'__return_false', // Section callback (we don't want anything)
		'enlightenment_theme_options' // Menu slug, used to uniquely identify the page
	);
	add_settings_field(
		'navbar_position',  // Unique identifier for the field for this section
		__( 'Navbar Position', 'enlightenment' ), // Setting field label
		'enlightenment_select_box', // Function that renders the settings field
		'enlightenment_theme_options', // Menu slug, used to uniquely identify the page
		'navbar', // Settings section. Same as the first argument in the add_settings_section() above
		array(
			'name' => 'navbar_position',
			'options' => array(
				'fixed-top' => 'Fixed on Top',
				'static-top' => 'Static',
			),
		)
	);
	add_settings_field(
		'navbar_background',  // Unique identifier for the field for this section
		__( 'Navbar Background Color', 'enlightenment' ), // Setting field label
		'enlightenment_select_box', // Function that renders the settings field
		'enlightenment_theme_options', // Menu slug, used to uniquely identify the page
		'navbar', // Settings section. Same as the first argument in the add_settings_section() above
		array(
			'name' => 'navbar_background',
			'options' => array(
				'default'     => 'Light',
				'inverse'     => 'Dark',
			),
		)
	);
	add_settings_field(
		'navbar_size',  // Unique identifier for the field for this section
		__( 'Navbar Size', 'enlightenment' ), // Setting field label
		'enlightenment_select_box', // Function that renders the settings field
		'enlightenment_theme_options', // Menu slug, used to uniquely identify the page
		'navbar', // Settings section. Same as the first argument in the add_settings_section() above
		array(
			'name' => 'navbar_size',
			'options' => array(
				'small' => 'Small',
				'large' => 'Large',
			),
			'description' => __( 'Menu Item Descriptions are hidden in the small Navbar.', 'enlightenment' ),
		)
	);
	add_settings_field(
		'shrink_navbar',  // Unique identifier for the field for this section
		__( 'Shrink Navbar', 'enlightenment' ), // Setting field label
		'enlightenment_checkbox', // Function that renders the settings field
		'enlightenment_theme_options', // Menu slug, used to uniquely identify the page
		'navbar', // Settings section. Same as the first argument in the add_settings_section() above
		array(
			'name' => 'shrink_navbar',
			'label' => __( 'Shrink Fixed Navbar when scrolling', 'enlightenment' ),
		)
	);
	add_settings_field(
		'blog_header_text',  // Unique identifier for the field for this section
		__( 'Blog Pages Header Text', 'enlightenment' ), // Setting field label
		'enlightenment_text_input', // Function that renders the settings field
		'enlightenment_theme_options', // Menu slug, used to uniquely identify the page
		'page_header', // Settings section. Same as the first argument in the add_settings_section() above
		array(
			'name'  => 'blog_header_text',
		)
	);
	add_settings_field(
		'blog_header_description',  // Unique identifier for the field for this section
		__( 'Blog Pages Description', 'enlightenment' ), // Setting field label
		'enlightenment_textarea', // Function that renders the settings field
		'enlightenment_theme_options', // Menu slug, used to uniquely identify the page
		'page_header', // Settings section. Same as the first argument in the add_settings_section() above
		array(
			'name'  => 'blog_header_description',
		)
	);
	add_settings_field(
		'thumbnail_header_image',  // Unique identifier for the field for this section
		__( 'Thumbnail Header Image', 'enlightenment' ), // Setting field label
		'enlightenment_checkbox', // Function that renders the settings field
		'enlightenment_theme_options', // Menu slug, used to uniquely identify the page
		'page_header', // Settings section. Same as the first argument in the add_settings_section() above
		array(
			'name'  => 'thumbnail_header_image',
			'label' => __( 'Display post thumbnail as header image on single posts', 'enlightenment' ),
		)
	);
	add_settings_field(
		'thumbnails_crop_flag',  // Unique identifier for the field for this section
		__( 'Crop Thumbnails', 'enlightenment' ), // Setting field label
		'enlightenment_checkbox', // Function that renders the settings field
		'enlightenment_theme_options', // Menu slug, used to uniquely identify the page
		'post_thumbnails', // Settings section. Same as the first argument in the add_settings_section() above
		array(
			'name' => 'thumbnails_crop_flag',
			'label' => __( 'Hard crop post thumbnails', 'enlightenment' ),
			'description' => sprintf( __( 'After changing this option, it is recommended to recreate your thumbnails using a plugin like <a href="%s">AJAX Thumbnail Rebuild</a>', 'enlightenment' ), esc_url( 'http://wordpress.org/extend/plugins/ajax-thumbnail-rebuild/' ) ),
		)
	);
	add_settings_field(
		'thumbnails_size',  // Unique identifier for the field for this section
		__( 'Thumbnails Size', 'enlightenment' ), // Setting field label
		'enlightenment_select_box', // Function that renders the settings field
		'enlightenment_theme_options', // Menu slug, used to uniquely identify the page
		'post_thumbnails', // Settings section. Same as the first argument in the add_settings_section() above
		array(
			'name' => 'thumbnails_size',
			'options' => array(
				'small' => 'Small',
				'large' => 'Large',
			),
		)
	);
	$post_meta = enlightenment_theme_option( 'post_meta' );
	add_settings_field(
		'post_meta',  // Unique identifier for the field for this section
		__( 'Post Meta', 'enlightenment' ), // Setting field label
		'enlightenment_checkboxes', // Function that renders the settings field
		'enlightenment_theme_options', // Menu slug, used to uniquely identify the page
		'entry_meta', // Settings section. Same as the first argument in the add_settings_section() above
		array(
			'boxes' => array(
				array(
					'name' => 'post_meta[author]',
					'label' => __( 'Author', 'enlightenment' ),
					'checked' => $post_meta['author'],
				),
				array(
					'name' => 'post_meta[date]',
					'label' => __( 'Date', 'enlightenment' ),
					'checked' => $post_meta['date'],
				),
				array(
					'name' => 'post_meta[category]',
					'label' => __( 'Category', 'enlightenment' ),
					'checked' => $post_meta['category'],
				),
				array(
					'name' => 'post_meta[comments]',
					'label' => __( 'Comments', 'enlightenment' ),
					'checked' => $post_meta['comments'],
				),
				array(
					'name' => 'post_meta[edit_link]',
					'label' => __( 'Edit Post Link', 'enlightenment' ),
					'checked' => $post_meta['edit_link'],
				),
			),
		)
	);
	if( class_exists( 'Jetpack' ) && in_array( 'custom-content-types', Jetpack::get_active_modules() ) ) {
		$post_meta = enlightenment_theme_option( 'portfolio_meta' );
		add_settings_field(
			'portfolio_meta',  // Unique identifier for the field for this section
			__( 'Portfolio Meta', 'enlightenment' ), // Setting field label
			'enlightenment_checkboxes', // Function that renders the settings field
			'enlightenment_theme_options', // Menu slug, used to uniquely identify the page
			'entry_meta', // Settings section. Same as the first argument in the add_settings_section() above
			array(
				'boxes' => array(
					array(
						'name' => 'portfolio_meta[author]',
						'label' => __( 'Author', 'enlightenment' ),
						'checked' => $post_meta['author'],
					),
					array(
						'name' => 'portfolio_meta[date]',
						'label' => __( 'Date', 'enlightenment' ),
						'checked' => $post_meta['date'],
					),
					array(
						'name' => 'portfolio_meta[project_type]',
						'label' => __( 'Project Type', 'enlightenment' ),
						'checked' => $post_meta['project_type'],
					),
					array(
						'name' => 'portfolio_meta[comments]',
						'label' => __( 'Comments', 'enlightenment' ),
						'checked' => $post_meta['comments'],
					),
					array(
						'name' => 'portfolio_meta[edit_link]',
						'label' => __( 'Edit Project Link', 'enlightenment' ),
						'checked' => $post_meta['edit_link'],
					),
				),
			)
		);
	}
	add_settings_field(
		'enable_lightbox',  // Unique identifier for the field for this section
		__( 'Enable Lightbox', 'enlightenment' ), // Setting field label
		'enlightenment_checkbox', // Function that renders the settings field
		'enlightenment_theme_options', // Menu slug, used to uniquely identify the page
		'lightbox', // Settings section. Same as the first argument in the add_settings_section() above
		array(
			'name' => 'enable_lightbox',
			'label' => __( 'Open image links in a lightbox', 'enlightenment' ),
		)
	);
	add_settings_field(
		'lightbox_script',  // Unique identifier for the field for this section
		__( 'Lightbox Script', 'enlightenment' ), // Setting field label
		'enlightenment_select_box', // Function that renders the settings field
		'enlightenment_theme_options', // Menu slug, used to uniquely identify the page
		'lightbox', // Settings section. Same as the first argument in the add_settings_section() above
		array(
			'name' => 'lightbox_script',
			'options' => array(
				'colorbox'        => __( 'Colorbox', 'enlightenment' ),
				'fluidbox'        => __( 'Fluidbox', 'enlightenment' ),
				'imagelightbox' => __( 'ImageLightbox.js', 'enlightenment' ),
			),
		)
	);
	add_settings_field(
		'posts_nav_style',  // Unique identifier for the field for this section
		__( 'Posts Navigation Style', 'enlightenment' ), // Setting field label
		'enlightenment_select_box', // Function that renders the settings field
		'enlightenment_theme_options', // Menu slug, used to uniquely identify the page
		'posts_nav', // Settings section. Same as the first argument in the add_settings_section() above
		array(
			'name' => 'posts_nav_style',
			'options' => array(
				'static' => __( 'Static Links', 'enlightenment' ),
				'ajax' => 'AJAX Links',
				'infinite' => 'Infinite Scroll',
			),
		)
	);
	add_settings_field(
		'posts_nav_labels',  // Unique identifier for the field for this section
		__( 'Static Links Labels', 'enlightenment' ), // Setting field label
		'enlightenment_select_box', // Function that renders the settings field
		'enlightenment_theme_options', // Menu slug, used to uniquely identify the page
		'posts_nav', // Settings section. Same as the first argument in the add_settings_section() above
		array(
			'name' => 'posts_nav_labels',
			'options' => array(
				'next/prev'     => __( 'Next Page / Previous Page', 'enlightenment' ),
				'older/newer'   => __( 'Older Posts / Newer Posts', 'enlightenment' ),
				'earlier/later' => __( 'Earlier Posts / Later Posts', 'enlightenment' ),
				'numbered'      => __( 'Numbered Pagination', 'enlightenment' ),
			),
		)
	);
	add_settings_field(
		'copyright_notice',  // Unique identifier for the field for this section
		__( 'Copyright Notice', 'enlightenment' ), // Setting field label
		'enlightenment_text_input', // Function that renders the settings field
		'enlightenment_theme_options', // Menu slug, used to uniquely identify the page
		'footer', // Settings section. Same as the first argument in the add_settings_section() above
		array(
			'name'  => 'copyright_notice',
			'description' => __( '%year% = Current Year, %sitename% = Website Name', 'enlightenment' ),
		)
	);
	add_settings_field(
		'credit_links',  // Unique identifier for the field for this section
		__( 'Credit Links', 'enlightenment' ), // Setting field label
		'enlightenment_checkboxes', // Function that renders the settings field
		'enlightenment_theme_options', // Menu slug, used to uniquely identify the page
		'footer', // Settings section. Same as the first argument in the add_settings_section() above
		array(
			'boxes' => array(
				array(
					'name' => 'theme_credit_link',
					'label' => 'Theme Credit Link',
				),
				array(
					'name' => 'author_credit_link',
					'label' => 'Theme Author Credit Link',
				),
				array(
					'name' => 'wordpress_credit_link',
					'label' => 'WordPress Credit Link',
				),
			),
		)
	);
}

add_action( 'enlightenment_design_settings_sections', 'enlightenment_design_settings' );

function enlightenment_design_settings() {
	add_settings_section(
		'page_design', // Unique identifier for the settings section
		__( 'Page Design', 'enlightenment' ), // Section title
		'__return_false', // Section callback (we don't want anything)
		'enlightenment_theme_options' // Menu slug, used to uniquely identify the page
	);
	add_settings_section(
		'custom_css', // Unique identifier for the settings section
		__( 'Custom CSS', 'enlightenment' ), // Section title
		'__return_false', // Section callback (we don't want anything)
		'enlightenment_theme_options' // Menu slug, used to uniquely identify the page
	);
	add_settings_field(
		'page_design',  // Unique identifier for the field for this section
		__( 'Select Default Page Design', 'enlightenment' ), // Setting field label
		'enlightenment_image_radio_buttons', // Function that renders the settings field
		'enlightenment_theme_options', // Menu slug, used to uniquely identify the page
		'page_design', // Settings section. Same as the first argument in the add_settings_section() above
		array(
			'name' => 'page_design',
			'buttons' => array(
				array(
					'image' => get_template_directory_uri() . '/images/design-boxed.png',
					'id' => 'boxed',
					'value' => 'boxed',
				),
				array(
					'image' => get_template_directory_uri() . '/images/design-full-screen.png',
					'id' => 'full-screen',
					'value' => 'full-screen',
				),
			),
		)
	);
	add_settings_field(
		'custom_css',  // Unique identifier for the field for this section
		__( 'Enter your custom CSS Rules', 'enlightenment' ), // Setting field label
		'enlightenment_custom_css', // Function that renders the settings field
		'enlightenment_theme_options', // Menu slug, used to uniquely identify the page
		'custom_css', // Settings section. Same as the first argument in the add_settings_section() above
		array(
			'name'  => 'custom_css',
		)
	);
}

add_action( 'enlightenment_typography_settings_sections', 'enlightenment_typography_settings' );

function enlightenment_typography_settings() {
	add_settings_section(
		'links', // Unique identifier for the settings section
		__( 'Links', 'enlightenment' ), // Section title
		'__return_false', // Section callback (we don't want anything)
		'enlightenment_theme_options' // Menu slug, used to uniquely identify the page
	);
	add_settings_section(
		'navbar', // Unique identifier for the settings section
		__( 'Navbar', 'enlightenment' ), // Section title
		'__return_false', // Section callback (we don't want anything)
		'enlightenment_theme_options' // Menu slug, used to uniquely identify the page
	);
	add_settings_section(
		'page_header', // Unique identifier for the settings section
		__( 'Page Header', 'enlightenment' ), // Section title
		'__return_false', // Section callback (we don't want anything)
		'enlightenment_theme_options' // Menu slug, used to uniquely identify the page
	);
	add_settings_section(
		'posts', // Unique identifier for the settings section
		__( 'Posts', 'enlightenment' ), // Section title
		'__return_false', // Section callback (we don't want anything)
		'enlightenment_theme_options' // Menu slug, used to uniquely identify the page
	);
	add_settings_section(
		'widgets', // Unique identifier for the settings section
		__( 'Widgets', 'enlightenment' ), // Section title
		'__return_false', // Section callback (we don't want anything)
		'enlightenment_theme_options' // Menu slug, used to uniquely identify the page
	);
	add_settings_section(
		'footer', // Unique identifier for the settings section
		__( 'Footer', 'enlightenment' ), // Section title
		'__return_false', // Section callback (we don't want anything)
		'enlightenment_theme_options' // Menu slug, used to uniquely identify the page
	);
	add_settings_field(
		'link_color',  // Unique identifier for the field for this section
		__( 'Link Color', 'enlightenment' ), // Setting field label
		'enlightenment_color_picker', // Function that renders the settings field
		'enlightenment_theme_options', // Menu slug, used to uniquely identify the page
		'links', // Settings section. Same as the first argument in the add_settings_section() above
		array(
			'name'  => 'link_color',
		)
	);
	add_settings_field(
		'link_hover_color',  // Unique identifier for the field for this section
		__( 'Link Hover Color', 'enlightenment' ), // Setting field label
		'enlightenment_color_picker', // Function that renders the settings field
		'enlightenment_theme_options', // Menu slug, used to uniquely identify the page
		'links', // Settings section. Same as the first argument in the add_settings_section() above
		array(
			'name'  => 'link_hover_color',
		)
	);
	add_settings_field(
		'brand',  // Unique identifier for the field for this section
		__( 'Site Title', 'enlightenment' ), // Setting field label
		'enlightenment_font_options', // Function that renders the settings field
		'enlightenment_theme_options', // Menu slug, used to uniquely identify the page
		'navbar', // Settings section. Same as the first argument in the add_settings_section() above
		array(
			'name'  => 'brand',
		)
	);
	add_settings_field(
		'brand_hover_color',  // Unique identifier for the field for this section
		__( 'Site Title Hover Color', 'enlightenment' ), // Setting field label
		'enlightenment_color_picker', // Function that renders the settings field
		'enlightenment_theme_options', // Menu slug, used to uniquely identify the page
		'navbar', // Settings section. Same as the first argument in the add_settings_section() above
		array(
			'name'  => 'brand_hover_color',
		)
	);
	add_settings_field(
		'menu_items',  // Unique identifier for the field for this section
		__( 'Menu Items', 'enlightenment' ), // Setting field label
		'enlightenment_font_options', // Function that renders the settings field
		'enlightenment_theme_options', // Menu slug, used to uniquely identify the page
		'navbar', // Settings section. Same as the first argument in the add_settings_section() above
		array(
			'name'  => 'menu_items',
		)
	);
	add_settings_field(
		'menu_items_hover_color',  // Unique identifier for the field for this section
		__( 'Menu Items Hover Color', 'enlightenment' ), // Setting field label
		'enlightenment_color_picker', // Function that renders the settings field
		'enlightenment_theme_options', // Menu slug, used to uniquely identify the page
		'navbar', // Settings section. Same as the first argument in the add_settings_section() above
		array(
			'name'  => 'menu_items_hover_color',
		)
	);
	add_settings_field(
		'page_header',  // Unique identifier for the field for this section
		__( 'Page Header', 'enlightenment' ), // Setting field label
		'enlightenment_font_options', // Function that renders the settings field
		'enlightenment_theme_options', // Menu slug, used to uniquely identify the page
		'page_header', // Settings section. Same as the first argument in the add_settings_section() above
		array(
			'name'  => 'page_header',
		)
	);
	add_settings_field(
		'entry_title',  // Unique identifier for the field for this section
		__( 'Post Titles', 'enlightenment' ), // Setting field label
		'enlightenment_font_options', // Function that renders the settings field
		'enlightenment_theme_options', // Menu slug, used to uniquely identify the page
		'posts', // Settings section. Same as the first argument in the add_settings_section() above
		array(
			'name'  => 'entry_title',
		)
	);
	add_settings_field(
		'teaser_entry_title',  // Unique identifier for the field for this section
		__( 'Teaser Post Titles', 'enlightenment' ), // Setting field label
		'enlightenment_font_options', // Function that renders the settings field
		'enlightenment_theme_options', // Menu slug, used to uniquely identify the page
		'posts', // Settings section. Same as the first argument in the add_settings_section() above
		array(
			'name'  => 'teaser_entry_title',
		)
	);
	add_settings_field(
		'single_entry_title',  // Unique identifier for the field for this section
		__( 'Single Post Title', 'enlightenment' ), // Setting field label
		'enlightenment_font_options', // Function that renders the settings field
		'enlightenment_theme_options', // Menu slug, used to uniquely identify the page
		'posts', // Settings section. Same as the first argument in the add_settings_section() above
		array(
			'name'  => 'single_entry_title',
		)
	);
	add_settings_field(
		'entry_title_hover_color',  // Unique identifier for the field for this section
		__( 'Post Titles Hover Color', 'enlightenment' ), // Setting field label
		'enlightenment_color_picker', // Function that renders the settings field
		'enlightenment_theme_options', // Menu slug, used to uniquely identify the page
		'posts', // Settings section. Same as the first argument in the add_settings_section() above
		array(
			'name'  => 'entry_title_hover_color',
		)
	);
	add_settings_field(
		'entry_meta',  // Unique identifier for the field for this section
		__( 'Post Meta', 'enlightenment' ), // Setting field label
		'enlightenment_font_options', // Function that renders the settings field
		'enlightenment_theme_options', // Menu slug, used to uniquely identify the page
		'posts', // Settings section. Same as the first argument in the add_settings_section() above
		array(
			'name'  => 'entry_meta',
		)
	);
	add_settings_field(
		'entry_meta_link_color',  // Unique identifier for the field for this section
		__( 'Post Meta Links Color', 'enlightenment' ), // Setting field label
		'enlightenment_color_picker', // Function that renders the settings field
		'enlightenment_theme_options', // Menu slug, used to uniquely identify the page
		'posts', // Settings section. Same as the first argument in the add_settings_section() above
		array(
			'name'  => 'entry_meta_link_color',
		)
	);
	add_settings_field(
		'entry_meta_link_hover_color',  // Unique identifier for the field for this section
		__( 'Post Meta Links Hover Color', 'enlightenment' ), // Setting field label
		'enlightenment_color_picker', // Function that renders the settings field
		'enlightenment_theme_options', // Menu slug, used to uniquely identify the page
		'posts', // Settings section. Same as the first argument in the add_settings_section() above
		array(
			'name'  => 'entry_meta_link_hover_color',
		)
	);
	add_settings_field(
		'entry_content',  // Unique identifier for the field for this section
		__( 'Body Copy', 'enlightenment' ), // Setting field label
		'enlightenment_font_options', // Function that renders the settings field
		'enlightenment_theme_options', // Menu slug, used to uniquely identify the page
		'posts', // Settings section. Same as the first argument in the add_settings_section() above
		array(
			'name'  => 'entry_content',
		)
	);
	add_settings_field(
		'entry_summary',  // Unique identifier for the field for this section
		__( 'Excerpts', 'enlightenment' ), // Setting field label
		'enlightenment_font_options', // Function that renders the settings field
		'enlightenment_theme_options', // Menu slug, used to uniquely identify the page
		'posts', // Settings section. Same as the first argument in the add_settings_section() above
		array(
			'name'  => 'entry_summary',
		)
	);
	add_settings_field(
		'widget_title',  // Unique identifier for the field for this section
		__( 'Widget Titles', 'enlightenment' ), // Setting field label
		'enlightenment_font_options', // Function that renders the settings field
		'enlightenment_theme_options', // Menu slug, used to uniquely identify the page
		'widgets', // Settings section. Same as the first argument in the add_settings_section() above
		array(
			'name'  => 'widget_title',
		)
	);
	add_settings_field(
		'widget_content',  // Unique identifier for the field for this section
		__( 'Widget Content', 'enlightenment' ), // Setting field label
		'enlightenment_font_options', // Function that renders the settings field
		'enlightenment_theme_options', // Menu slug, used to uniquely identify the page
		'widgets', // Settings section. Same as the first argument in the add_settings_section() above
		array(
			'name'  => 'widget_content',
		)
	);
	add_settings_field(
		'widget_link_color',  // Unique identifier for the field for this section
		__( 'Widgets Link Color', 'enlightenment' ), // Setting field label
		'enlightenment_color_picker', // Function that renders the settings field
		'enlightenment_theme_options', // Menu slug, used to uniquely identify the page
		'widgets', // Settings section. Same as the first argument in the add_settings_section() above
		array(
			'name'  => 'widget_link_color',
		)
	);
	add_settings_field(
		'widget_link_hover_color',  // Unique identifier for the field for this section
		__( 'Widgets Link Hover Color', 'enlightenment' ), // Setting field label
		'enlightenment_color_picker', // Function that renders the settings field
		'enlightenment_theme_options', // Menu slug, used to uniquely identify the page
		'widgets', // Settings section. Same as the first argument in the add_settings_section() above
		array(
			'name'  => 'widget_link_hover_color',
		)
	);
	add_settings_field(
		'footer_text',  // Unique identifier for the field for this section
		__( 'Footer Text', 'enlightenment' ), // Setting field label
		'enlightenment_font_options', // Function that renders the settings field
		'enlightenment_theme_options', // Menu slug, used to uniquely identify the page
		'footer', // Settings section. Same as the first argument in the add_settings_section() above
		array(
			'name'  => 'footer_text',
		)
	);
	add_settings_field(
		'footer_link_color',  // Unique identifier for the field for this section
		__( 'Footer Link Color', 'enlightenment' ), // Setting field label
		'enlightenment_color_picker', // Function that renders the settings field
		'enlightenment_theme_options', // Menu slug, used to uniquely identify the page
		'footer', // Settings section. Same as the first argument in the add_settings_section() above
		array(
			'name'  => 'footer_link_color',
		)
	);
	add_settings_field(
		'footer_link_hover_color',  // Unique identifier for the field for this section
		__( 'Footer Link Hover Color', 'enlightenment' ), // Setting field label
		'enlightenment_color_picker', // Function that renders the settings field
		'enlightenment_theme_options', // Menu slug, used to uniquely identify the page
		'footer', // Settings section. Same as the first argument in the add_settings_section() above
		array(
			'name'  => 'footer_link_hover_color',
		)
	);
}

add_action( 'enlightenment_seo_settings_sections', 'enlightenment_seo_settings' );

function enlightenment_seo_settings() {
	add_settings_section(
		'page_header', // Unique identifier for the settings section
		__( 'Page Header', 'enlightenment' ), // Section title
		'__return_false', // Section callback (we don't want anything)
		'enlightenment_theme_options' // Menu slug, used to uniquely identify the page
	);
	add_settings_section(
		'post_titles', // Unique identifier for the settings section
		__( 'Post Titles', 'enlightenment' ), // Section title
		'__return_false', // Section callback (we don't want anything)
		'enlightenment_theme_options' // Menu slug, used to uniquely identify the page
	);
	add_settings_section(
		'comments', // Unique identifier for the settings section
		__( 'Comments', 'enlightenment' ), // Section title
		'__return_false', // Section callback (we don't want anything)
		'enlightenment_theme_options' // Menu slug, used to uniquely identify the page
	);
	add_settings_section(
		'widget_titles', // Unique identifier for the settings section
		__( 'Widget Titles', 'enlightenment' ), // Section title
		'__return_false', // Section callback (we don't want anything)
		'enlightenment_theme_options' // Menu slug, used to uniquely identify the page
	);
	$options = array(
		'h1' => 'h1',
		'h2' => 'h2',
		'h3' => 'h3',
		'h4' => 'h4',
		'p' => 'p',
		'div' => 'div',
	);
	add_settings_field(
		'page_header_tag',  // Unique identifier for the field for this section
		__( 'Page Header Tag on Archive Pages', 'enlightenment' ), // Setting field label
		'enlightenment_select_box', // Function that renders the settings field
		'enlightenment_theme_options', // Menu slug, used to uniquely identify the page
		'page_header', // Settings section. Same as the first argument in the add_settings_section() above
		array(
			'name' => 'page_header_tag',
			'options' => $options,
		)
	);
	add_settings_field(
		'single_page_header_tag',  // Unique identifier for the field for this section
		__( 'Page Header Tag on Single Posts', 'enlightenment' ), // Setting field label
		'enlightenment_select_box', // Function that renders the settings field
		'enlightenment_theme_options', // Menu slug, used to uniquely identify the page
		'page_header', // Settings section. Same as the first argument in the add_settings_section() above
		array(
			'name' => 'single_page_header_tag',
			'options' => $options,
		)
	);
	add_settings_field(
		'entry_title_tag',  // Unique identifier for the field for this section
		__( 'Post Title Tag', 'enlightenment' ), // Setting field label
		'enlightenment_select_box', // Function that renders the settings field
		'enlightenment_theme_options', // Menu slug, used to uniquely identify the page
		'post_titles', // Settings section. Same as the first argument in the add_settings_section() above
		array(
			'name' => 'entry_title_tag',
			'options' => $options,
		)
	);
	add_settings_field(
		'teaser_entry_title_tag',  // Unique identifier for the field for this section
		__( 'Teaser Post Title Tag', 'enlightenment' ), // Setting field label
		'enlightenment_select_box', // Function that renders the settings field
		'enlightenment_theme_options', // Menu slug, used to uniquely identify the page
		'post_titles', // Settings section. Same as the first argument in the add_settings_section() above
		array(
			'name' => 'teaser_entry_title_tag',
			'options' => $options,
		)
	);
	add_settings_field(
		'single_entry_title_tag',  // Unique identifier for the field for this section
		__( 'Single Post Title Tag', 'enlightenment' ), // Setting field label
		'enlightenment_select_box', // Function that renders the settings field
		'enlightenment_theme_options', // Menu slug, used to uniquely identify the page
		'post_titles', // Settings section. Same as the first argument in the add_settings_section() above
		array(
			'name' => 'single_entry_title_tag',
			'options' => $options,
		)
	);
	add_settings_field(
		'comments_title_tag',  // Unique identifier for the field for this section
		__( 'Comments Title Tag', 'enlightenment' ), // Setting field label
		'enlightenment_select_box', // Function that renders the settings field
		'enlightenment_theme_options', // Menu slug, used to uniquely identify the page
		'comments', // Settings section. Same as the first argument in the add_settings_section() above
		array(
			'name' => 'comments_title_tag',
			'options' => $options,
		)
	);
	add_settings_field(
		'widget_title_tag',  // Unique identifier for the field for this section
		__( 'Widget Title Tag', 'enlightenment' ), // Setting field label
		'enlightenment_select_box', // Function that renders the settings field
		'enlightenment_theme_options', // Menu slug, used to uniquely identify the page
		'widget_titles', // Settings section. Same as the first argument in the add_settings_section() above
		array(
			'name' => 'widget_title_tag',
			'options' => $options,
		)
	);
}



