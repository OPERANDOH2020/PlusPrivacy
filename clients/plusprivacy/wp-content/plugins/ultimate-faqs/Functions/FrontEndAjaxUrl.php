<?php
function ewd_ufaq_frontend_ajaxurl() {
    ?>
    <script type="text/javascript">
        var ajaxurl = '<?php echo admin_url('admin-ajax.php'); ?>';
    </script>
<?php
}
add_action('wp_head','ewd_ufaq_frontend_ajaxurl');
?>