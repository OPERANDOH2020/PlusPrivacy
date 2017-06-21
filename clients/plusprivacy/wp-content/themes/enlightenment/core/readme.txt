=== Enlightenment Framework ===
Contributors: Daniel Tara
Requires at least: 3.9
Tested up to: 4.3beta1
Stable tag: 1.1.4

== License ==

Unless otherwise specified, all the theme files, scripts and images
are licensed under GNU General Public Licemse version 2, see file license.txt.
The exceptions to this license are as follows:
* Bootstrap is licensed under MIT
* Colorbox is licensed under MIT
* Fluidbox is licensed under MIT
* ImageLightbox.js is licensed under MIT
* FlexSlider is licensed under GPL v2
* FitVids is licensed under WTFPL
* Infinite Scroll is licensed under MIT
* Respond.js is licensed under MIT
* HTML5 Shiv is dual-licensed under MIT & GPL v2

== Frequently Asked Questions ==

To be added

== Additional Notes ==

The framework is released for free under the terms of the GNU General Public License version 2
and some parts under their respective licenses.
In general words, feel free and encouraged to use, modify and redistribute this code library however you like.

== Changelog ==

= 1.1.4 =

* Fixed resetting sidebars when hitting Preview Changes button
* Fixed transparent background option getting reset when saving sidebars

= 1.1.3 =

* Fixed change template select box bug
* Fixed web fonts localize script args function bug
* Fixed sidebar show sidebar title & description options

= 1.1.2 =

* Fixed sidebars deleting on save settings
* Fixed broken translation file

= 1.1.1 =

* Added html escaping to sidebar title and description
* Fixed add new sidebar bug

= 1.1.0 =

* Added new setting for background options
* Added new options for description, grid container, background and color to custom sidebars
* Added support for Devangari, Khmer and Telugu subsets for web fonts
* Added more fonts to default list of supported web fonts
* Added background and color options for custom sidebars
* Added parallax background to custom query slider
* Added comments_number() wrapper function
* Added class 'menu-item-has-icon' to menu items with icons
* Added schema markup to post thumbnails
* Added option for full width or contained widgets inside custom sidebars
* Added special classes to <body> tag when custom header options are active
* Improved output of enlightenment_post_meta() function
* Updated Bootstrap to version 3.3.4
* Updated Flexslider to version 2.4.0
* Updated Fluidbox to version 1.4.4
* Fixed full list of web fonts not loading from Google Fonts Directory
* Fixed infinite scroll bugs
* Fixed output of enlightenment_close_tag() function with empty parameter
* Fixed Jetpack Portfolio project types filter
* Fixed output of custom menu widget

= 1.0.14 =

* Fixed Bootlint errors

= 1.0.13 =

* Fixed menu icons preview not displaying

= 1.0.12 =

* Updated incomplete translation strings
* Removed Navbar Brand wrapper for Bootstrap

= 1.0.11 =

* Fixed Colorbox image paths in CSS
* Fixed blockquote character encoding for DOMDocument

= 1.0.10 =

* Updated Bootstrap to version 3.3.1
* Updated Colorbox to version 1.5.14
* Updated FlexSlider to version 2.2.2
* Updated Fluidbox to version 1.4.2
* Updated Infinite Scroll to version 2.1.0
* Added support and backwards compatibility for WP 4.1 document title

= 1.0.9 =

* Added callbacks for FitVids.js and video shortcodes for AJAX navigation
* Added Jetpack Project Types Filter function to Template Editor
* Fixed blockquote output for quote post formats
* Fixed blank sidebars bug for new posts

= 1.0.8 =

* Fixed reset theme settings bug

= 1.0.7 =

* Fixed reset theme settings bug

= 1.0.6 =

* Moved 'enlightenment_register_core_styles' and 'enlightenment_register_core_scripts' functions to 'wp_enqueue_scripts' hook
* Fixed custom sidebars post meta validation bug
* Fixed PHP Strict Standards errors
* Removed 'wp_title' hook to 'enlightenment_head' as Theme Check now requires it to be hard coded in header.php
* Removed functions 'enlightenment_wp_title_args' and 'enlightenment_wrap_title_tag' as they are now obsolete

= 1.0.5 =

* Fixed schema markup array to string conversion

= 1.0.4 =

* Allow 'action' attribute for form elements
* Existing fonts enqueued using 'enlightenment_enqueue_font' get new styles appended
* Added edit post link to entry meta
* Fixed page separator showing up in empty archive title
* Fixed schema markup array to string conversion
* Fixed font style validation bug

= 1.0.3 =

* Added support for Jetpack Portfolio custom post type

= 1.0.2 =

* Fixed icons preview not displaying in menu editor

= 1.0.1 =

* Added compatibility scripts for IE8
* Added support for Fluidbox and ImageLightbox.js scripts
* Added function to escape attributes for image tags
* Fixed relative image paths in flexslider.css
* Fixed relative image paths in colorbox.css
* Fixed bug with standard post format in template editor

= 1.0.0 =

* Initial Release