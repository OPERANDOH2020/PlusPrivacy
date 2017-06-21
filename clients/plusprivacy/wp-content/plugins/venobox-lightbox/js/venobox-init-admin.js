jQuery(document).ready(function($){

    /* default settings */
    $('.venobox').venobox({
      border: '0',
      // framewidth: '1600px',        // default: ''
      // frameheight: '1000px',       // default: ''
      // bgcolor: '#5dff5e',
      numeratio: true,            // default: false
      infinigall: true           // default: false

    });


    /* custom settings */
    $('.venobox_custom').venobox({
        framewidth: '400px',        // default: ''
        frameheight: '300px',       // default: ''
        border: '10px',             // default: '0'
        bgcolor: '#5dff5e',         // default: '#fff'
        titleattr: 'data-title',    // default: 'title'
        numeratio: true,            // default: false
        infinigall: true            // default: false
    });

    /* auto-open #firstlink on page load */
    // $("#firstlink").venobox().trigger('click');
});
