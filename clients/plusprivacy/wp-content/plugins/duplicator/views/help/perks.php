<?php
DUP_Util::CheckPermissions('read');

require_once(DUPLICATOR_PLUGIN_PATH . '/assets/js/javascript.php');
require_once(DUPLICATOR_PLUGIN_PATH . '/views/inc.header.php');
$_GET['a'] = isset($_GET['a']) ? $_GET['a'] : -1;

?>
<style>
    div.dup-perks-all {font-size:13px; line-height:20px}
    div.dup-perks-hlp-area {width:315px; height:160px; float:left; border:1px solid #dfdfdf; border-radius:8px; margin:20px 30px 10px 40px;box-shadow: 0 8px 6px -6px #ccc; background: #fff}
    div.dup-perks-hlp-hdrs {
        font-weight:bold; font-size:17px; height: 25px; padding:10px 0 5px 0; text-align: center;
		background: #eeeeee;
		background: -moz-linear-gradient(top,  #eeeeee 0%, #cccccc 100%);
		background: -webkit-linear-gradient(top,  #eeeeee 0%,#cccccc 100%);
		background: linear-gradient(to bottom,  #eeeeee 0%,#cccccc 100%);
		filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#eeeeee', endColorstr='#cccccc',GradientType=0 );
    }
    div.dup-perks-txt{padding:10px 4px 4px 4px; text-align:center; font-size:16px; font-weight: bold}
	div.dup-active-item {font-weight: bold; font-style: italic}
	div.dup-active-item div.dup-perks-hlp-hdrs{ color:#fff; border-top-right-radius: 8px; border-top-left-radius: 8px;
		background: #4c4c4c;
		background: -moz-linear-gradient(top,  #4c4c4c 0%, #595959 12%, #666666 25%, #474747 39%, #2c2c2c 50%, #000000 51%, #111111 60%, #2b2b2b 76%, #1c1c1c 91%, #131313 100%);
		background: -webkit-linear-gradient(top,  #4c4c4c 0%,#595959 12%,#666666 25%,#474747 39%,#2c2c2c 50%,#000000 51%,#111111 60%,#2b2b2b 76%,#1c1c1c 91%,#131313 100%);
		background: linear-gradient(to bottom,  #4c4c4c 0%,#595959 12%,#666666 25%,#474747 39%,#2c2c2c 50%,#000000 51%,#111111 60%,#2b2b2b 76%,#1c1c1c 91%,#131313 100%);
		filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#4c4c4c', endColorstr='#131313',GradientType=0 );
	}
</style>

<div class="wrap dup-wrap dup-perks-all">
	
    <?php duplicator_header(__("Perks", 'duplicator')) ?>
    <hr size="1" />

    <div style="width:800px; margin:auto; margin-top:10px;">
		<div style="text-align: center; font-size:18px; line-height: 24px">
			<b><?php _e("Get Great Deals and Amazing Products!", 'duplicator');	?></b><br/>
			<i><?php _e("While helping to support Duplicator...", 'duplicator');	?></i>
		</div>

		<!-- ==========================================================
		ROW 1  -->
		<!-- BLUEHOST -->
        <div class="dup-perks-hlp-area" id="bluehost">
            <div class="dup-perks-hlp-hdrs">
                <i class="fa fa-th fa-1x"></i> <?php _e('Bluehost', 'duplicator') ?>
            </div>
            <div class="dup-perks-txt">
				<a href="https://snapcreek.com/visit/bluehost" target="_blank">
					<img src="<?php echo DUPLICATOR_PLUGIN_URL ?>assets/img/perks_bluehost.png" style="padding:10px 0 15px 0" /><br/>
					<?php _e('50% Off Normal Price!', 'duplicator') ?>
				</a>
            </div>
        </div>
		
        <!-- INMOTION -->
        <div class="dup-perks-hlp-area" id="inmotion">
            <div class="dup-perks-hlp-hdrs">
				<i class="fa fa-cube fa-1x"></i> <?php _e('InMotion', 'duplicator') ?>
			</div>
            <div class="dup-perks-txt">
				<a href="https://snapcreek.com/visit/inmotion" target="_blank">
					<img src="<?php echo DUPLICATOR_PLUGIN_URL ?>assets/img/perks_inmotion.png" style="padding:10px 0 5px 0" /><br/>
					<?php _e('Up to 25% Off - With FREE SSDs', 'duplicator') ?>
				</a>
            </div>
        </div>

		<!-- ==========================================================
		ROW 2  -->
        <!-- ELEGANT THEMES -->
        <div class="dup-perks-hlp-area" id="ethemes">
            <div class="dup-perks-hlp-hdrs">
                <i class="fa fa-asterisk fa-1x"></i> <?php _e('Elegant Themes', 'duplicator') ?>
            </div>
            <div class="dup-perks-txt">
				<a href="https://snapcreek.com/visit/elegantthemes" target="_blank">
					<img src="<?php echo DUPLICATOR_PLUGIN_URL ?>assets/img/perks_ethemes.png" style="padding:0 0 5px 0" /><br/>
					<?php _e('10% Off Lifetime Access!', 'duplicator') ?>
				</a>
            </div>
        </div>
		
		<!-- MAX CDN -->
        <div class="dup-perks-hlp-area" id="maxcdn">
            <div class="dup-perks-hlp-hdrs">
                <i class="fa fa-maxcdn fa-1x"></i> <?php _e('MaxCDN', 'duplicator') ?>
            </div>
            <div class="dup-perks-txt">
				<a href="https://snapcreek.com/visit/maxcdn" target="_blank">
					<img src="<?php echo DUPLICATOR_PLUGIN_URL ?>assets/img/perks_maxcdn.png" style="padding:5px 0 10px 0" /><br/>
					<?php _e('Get 25% Off With Duplicator', 'duplicator') ?>
				</a>
            </div>
        </div>
	

		<!-- ==========================================================
		ROW 3  -->
		<!-- MANAGE WP -->
        <div class="dup-perks-hlp-area" id="managewp">
            <div class="dup-perks-hlp-hdrs">
                <i class="fa fa-sitemap fa-1x"></i> <?php _e('ManageWP', 'duplicator') ?>
            </div>
            <div class="dup-perks-txt">
				<a href="https://snapcreek.com/visit/managewp" target="_blank">
					<img src="<?php echo DUPLICATOR_PLUGIN_URL ?>assets/img/perks_managewp.png" style="padding:5px 0 10px 0" /><br/>
					<?php _e('Exclusive 10% Off Deal!', 'duplicator') ?>
				</a>
            </div>
        </div>
		
		<!-- DUPLICATOR PRO -->
        <div class="dup-perks-hlp-area" id="dpro">
            <div class="dup-perks-hlp-hdrs">
                <i class="fa fa-share-alt fa-1x"></i> <?php _e('Duplicator Pro', 'duplicator') ?>
            </div>
            <div class="dup-perks-txt">
				<a href="https://snapcreek.com/visit/managewp" target="_blank">
					<img src="<?php echo DUPLICATOR_PLUGIN_URL ?>assets/img/logo-dpro-300x50-nosnap.png" style="padding:10px 0 10px 0; width:250px" /><br/>
					<?php _e('Go Professional!', 'duplicator') ?>
				</a>
            </div>
        </div>		
        
		<!-- ==========================================================
		ROW 4  -->
		<!-- NINJA FORMS 
        <div class="dup-perks-hlp-area">
            <div class="dup-perks-hlp-hdrs">
                <i class="fa fa-check-square-o fa-1x"></i> <?php _e('Ninja Forms', 'duplicator') ?>
            </div>
            <div class="dup-perks-txt">
				<a href="https://snapcreek.com/visit/ninjaforms" target="_blank">
					<img src="<?php echo DUPLICATOR_PLUGIN_URL ?>assets/img/perks_ninjaforms.png" style="padding:5px 0 10px 0; " /><br/>
					<?php _e('Power Manage It All!', 'duplicator') ?>
				</a>
            </div>
        </div>	-->
		
		<!-- OPTIN MONSTER
        <div class="dup-perks-hlp-area">
            <div class="dup-perks-hlp-hdrs">
                <i class="fa fa-envelope fa-1x"></i> <?php _e('OptinMonster', 'duplicator') ?>
            </div>
            <div class="dup-perks-txt">
				<a href="https://snapcreek.com/visit/managewp" target="_blank">
					<img src="<?php echo DUPLICATOR_PLUGIN_URL ?>assets/img/perks_optinmonster.png" style="padding:5px 0 10px 0" /><br/>
					<?php _e('Power Manage It All!', 'duplicator') ?>
				</a>
            </div>
        </div> -->

		<br style="clear:both"/>
	
		<div style="margin:60px 20px; text-align: center"><small>Some promotions may change</small></div>
	
    </div>
</div>
<br/><br/><br/><br/>

<script type="text/javascript">
    jQuery(document).ready(function($) 
	{
        //ATTACHED EVENTS
        jQuery('#dup-perks-kb-lnks').change(function() {
            if (jQuery(this).val() != "null")
                window.open(jQuery(this).val())
        });

		<?php
			switch ($_GET['a']) 
			{
				case "0" : echo "$('#bluehost').addClass('dup-active-item');"; break;
				case "1" : echo "$('#inmotion').addClass('dup-active-item');"; break;
				case "2" : echo "$('#ethemes').addClass('dup-active-item');"; break;
				case "3" : echo "$('#managewp').addClass('dup-active-item');"; break;
				case "4" : echo "$('#maxcdn').addClass('dup-active-item');"; break;
			}
		?>
    });
</script>