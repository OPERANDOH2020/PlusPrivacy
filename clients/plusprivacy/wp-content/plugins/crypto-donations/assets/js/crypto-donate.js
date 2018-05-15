$(document).ready(function(){
    $(".copy_hash").click(function(){
        console.log($(".address_hash:visible"));
        $(".address_hash:visible").select();
        document.execCommand("Copy");
    })

});

