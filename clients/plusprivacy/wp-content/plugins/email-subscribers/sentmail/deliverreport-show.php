<?php

// Exit if accessed directly
if ( ! defined( 'ABSPATH' ) ) {
	exit; 
}

$sentguid = isset($_GET['sentguid']) ? $_GET['sentguid'] : '';
es_cls_security::es_check_guid($sentguid);

if ($sentguid == '') {
	?><div class="error fade">
		<p><strong>
			<?php echo __( 'Oops.. Unexpected error occurred. Please try again.', ES_TDOMAIN ); ?>
		</strong></p>
	</div><?php
}

?>

<style>
	.page-numbers {
		background: none repeat scroll 0 0 #E0E0E0;
		border-color: #CCCCCC;
		color: #555555;
		padding: 5px;
		text-decoration:none;
		margin-left:2px;
		margin-right:2px;
	}
</style>

<?php
	$pagenum = isset( $_GET['pagenum'] ) ? absint( $_GET['pagenum'] ) : 1;
	es_cls_security::es_check_number($pagenum);
	$limit = 100;
	$offset = ($pagenum - 1) * $limit;
	$total = es_cls_delivery::es_delivery_count($sentguid);
	$fulltotal = $total;
	$total = ceil( $total / $limit );
	$myData = array();
	$myData = es_cls_delivery::es_delivery_select($sentguid, $offset, $limit);

	$page_links = paginate_links( array(
		'base' => add_query_arg( 'pagenum', '%#%' ),
		'format' => '',
		'prev_text' => __( ' &lt;&lt; ' ),
		'next_text' => __( ' &gt;&gt; ' ),
		'total' => $total,
		'show_all' => False,
		'current' => $pagenum
	) );
?>

<div class="wrap">
	<h2>
		<?php echo __( 'Delivery Report', ES_TDOMAIN ); ?>
		<a class="add-new-h2" target="_blank" href="<?php echo ES_FAV; ?>"><?php echo __( 'Help', ES_TDOMAIN ); ?></a>
	</h2>
	<div class="tablenav">
		<div class="alignright" style="padding-bottom:10px;"><?php echo $page_links; ?></div>
	</div>
	<div class="tool-box">
		<form name="frm_es_display" method="post" onsubmit="return _es_bulkaction()">
			<table width="100%" class="widefat" id="straymanage">
				<thead>
					<tr>
						<th width="3%" scope="col"><?php echo __( 'Sno', ES_TDOMAIN ); ?></th>
						<th scope="col"><?php echo __( 'Email', ES_TDOMAIN ); ?></th>
						<th scope="col"><?php echo __( 'Status', ES_TDOMAIN ); ?></th>
						<th scope="col"><?php echo __( 'Sent', ES_TDOMAIN ); ?></th>
						<th scope="col"><?php echo __( 'Sent Date', ES_TDOMAIN ); ?></th>
						<th scope="col"><?php echo __( 'Viewed Status', ES_TDOMAIN ); ?></th>
						<th scope="col"><?php echo __( 'Viewed Date', ES_TDOMAIN ); ?></th>
					</tr>
				</thead>
				<tfoot>
					<tr>
						<th width="3%" scope="col"><?php echo __( 'Sno', ES_TDOMAIN ); ?></th>
						<th scope="col"><?php echo __( 'Email', ES_TDOMAIN ); ?></th>
						<th scope="col"><?php echo __( 'Status', ES_TDOMAIN ); ?></th>
						<th scope="col"><?php echo __( 'Sent', ES_TDOMAIN ); ?></th>
						<th scope="col"><?php echo __( 'Sent Date', ES_TDOMAIN ); ?></th>
						<th scope="col"><?php echo __( 'Viewed Status', ES_TDOMAIN ); ?></th>
						<th scope="col"><?php echo __( 'Viewed Date', ES_TDOMAIN ); ?></th>
					</tr>
				</tfoot>
				<tbody>
					<?php 
						$i = 0;
						if(count($myData) > 0) {
							$i = 1;
							foreach ($myData as $data) {
								?>
								<tr class="<?php if ($i&1) { echo 'alternate'; } else { echo ''; }?>">
									<td align="left"><?php echo $i; ?></td>
									<td><?php echo $data['es_deliver_emailmail']; ?></td>
									<td><?php echo es_cls_common::es_disp_status($data['es_deliver_sentstatus']); ?></td>
									<td><?php echo es_cls_common::es_disp_status($data['es_deliver_senttype']); ?></td>
									<td>
										<?php
											if ( $data['es_deliver_sentdate'] != '0000-00-00 00:00:00' ) {
												echo get_date_from_gmt($data['es_deliver_sentdate'],'Y-m-d H:i:s');
											} else {
												echo $data['es_deliver_sentdate'];
											}
										?>
									</td>
									<td><?php echo es_cls_common::es_disp_status($data['es_deliver_status']); ?></td>
									<td>
										<?php
											if ( $data['es_deliver_viewdate'] != '0000-00-00 00:00:00' ) {
												echo get_date_from_gmt($data['es_deliver_viewdate'],'Y-m-d H:i:s');
											} else {
												echo $data['es_deliver_viewdate'];											
											}
										?>
									</td>
								</tr>
								<?php
									$i = $i+1;
							}
						} else {
							?><tr><td colspan="8" align="center"><?php echo __( 'No records available.', ES_TDOMAIN ); ?></td></tr><?php 
						}
					?>
				</tbody>
			</table>
			<?php wp_nonce_field('es_form_show'); ?>
			<input type="hidden" name="frm_es_display" value="yes"/>
			<div class="tablenav">
				<div class="alignright">
					<?php echo $page_links; ?>
				</div>
			</div>
		</form>
	</div>
</div>