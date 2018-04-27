<?php

function UFAQ_Return_Pointers() {
  $pointers = array();

  $pointers['tutorial-one'] = array(
    'title'     => "<h3>" . 'Ultimate FAQ Intro' . "</h3>",
    'content'   => "<div><p>Thanks for installing UFAQ! These 6 slides will help get you started using the plugin.</p></div><div class='ufaq-pointer-count'><p>1 of 6</p></div>",
    'anchor_id' => '.Header',
    'edge'      => 'top',
    'align'     => 'left',
    'nextTab'   => 'Products',
    'width'     => '320',
    'where'     => array( 'toplevel_page_EWD-UFAQ-Options') // <-- Please note this
  );

  $pointers['tutorial-two'] = array(
    'title'     => "<h3>" . 'Create FAQs' . "</h3>",
    'content'   => "<div><p>Click 'Add New' to create FAQs for your visitors to view. Enter the FAQ question in the title area and the FAQ answer in the main post content area. Set the author name using the 'Author Display Name' field under the main post content area. Select and/or create FAQ categories and FAQ tags in the right-side menu.</p></div><div class='ufaq-pointer-count'><p>2 of 6</p></div>",
    'anchor_id' => '#FAQs_Menu',
    'edge'      => 'top',
    'align'     => 'left',
    'nextTab'   => 'Categories',
    'width'     => '320',
    'where'     => array( 'toplevel_page_EWD-UFAQ-Options') // <-- Please note this
  );

  $pointers['tutorial-three'] = array(
    'title'     => "<h3>" . 'Set Up Categories' . "</h3>",
    'content'   => "<div><p>Categories help organize your FAQs. You can assign FAQs to categories and optionally choose to group your FAQ page by category.</p></div><div class='ufaq-pointer-count'><p>3 of 6</p></div>",
    'anchor_id' => '#FAQ_Categories_Menu',
    'edge'      => 'top',
    'align'     => 'left',
    'nextTab'   => 'Catalogues',
    'width'     => '320',
    'where'     => array( 'toplevel_page_EWD-UFAQ-Options') // <-- Please note this
  );

  $pointers['tutorial-four'] = array(
    'title'     => "<h3>" . 'Display FAQs' . "</h3>",
    'content'   => "<div><p>Place the [ultimate-faqs] shortcode in the content area of any page you've created and it will display your FAQs</p></div><div class='ufaq-pointer-count'><p>4 of 6</p></div>",
    'anchor_id' => '#menu-pages',
    'edge'      => 'top',
    'align'     => 'left',
    'nextTab'   => 'Options',
    'width'     => '320',
    'where'     => array( 'toplevel_page_EWD-UFAQ-Options') // <-- Please note this
  );

  $pointers['tutorial-five'] = array(
    'title'     => "<h3>" . 'Customize Options' . "</h3>",
    'content'   => "<div><p>The FAQ settings area has options to help customize the plugin perfectly for your site, including:</p><ul><li>Toggle and accordion modes</li><li>FAQ comments</li><li>Many styling options and more!</li></ul></div><div class='ufaq-pointer-count'><p>5 of 6</p></div>",
    'anchor_id' => '#Options_Menu',
    'edge'      => 'top',
    'align'     => 'left',
    'nextTab'   => 'Dashboard',
    'width'     => '320',
    'where'     => array( 'toplevel_page_EWD-UFAQ-Options') // <-- Please note this
  );

  $pointers['tutorial-six'] = array(
    'title'     => "<h3>" . 'Need More Help?' . "</h3>",
    'content'   => "<div><p><a href='https://wordpress.org/support/view/plugin-reviews/ultimate-faqs?filter=5'>Help us spread the word with a 5 star rating!</a><br><br>We've got a number of videos on how to use the plugin:<br /><iframe width='560' height='315' src='https://www.youtube.com/embed/zf-tYLqHpRs?list=PLEndQUuhlvSrNdfu5FKa1uGHsaKZxgdWt' frameborder='0' allowfullscreen></iframe></p></div><div class='ufaq-pointer-count'><p>6 of 6</p></div>",
    'anchor_id' => '#wp-admin-bar-site-name',
    'edge'      => 'top',
    'align'     => 'left',
    'nextTab'   => 'Dashboard',
    'width'     => '600',
    'where'     => array( 'toplevel_page_EWD-UFAQ-Options') // <-- Please note this
  );

  return $pointers;
}

?>
