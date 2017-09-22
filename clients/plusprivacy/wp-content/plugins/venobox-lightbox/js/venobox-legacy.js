jQuery(document).ready(function($){

        $('a[data-type="youtube"]').removeAttr( "data-type", "youtube" ).attr("data-vbtype","video");
        $('a[data-type="vimeo"]').removeAttr( "data-type", "vimeo" ).attr("data-vbtype","video");
        $('a[data-type="iframe"]').removeAttr( "data-type", "iframe" ).attr("data-vbtype","iframe");
        $('a[data-type="inline"]').removeAttr( "data-type", "inline" ).attr("data-vbtype","inline");
        $('a[data-type="ajax"]').removeAttr( "data-type", "ajax" ).attr("data-vbtype","ajax");



// data-type="youtube"
// data-type="vimeo"
// data-type="iframe"
// data-type="inline"
// data-type="ajax"


});
