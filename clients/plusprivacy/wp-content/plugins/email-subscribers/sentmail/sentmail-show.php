<?php

// Exit if accessed directly
if ( ! defined( 'ABSPATH' ) ) {
	exit; 
}

// Form submitted, check the data
if (isset($_POST['frm_es_display']) && $_POST['frm_es_display'] == 'yes') {
	$did = isset($_GET['did']) ? $_GET['did'] : '0';
	es_cls_security::es_check_number($did);

	$es_success = '';
	$es_success_msg = FALSE;

	if (isset($_POST['frm_es_bulkaction']) && $_POST['frm_es_bulkaction'] != 'delete') {
		// First check if ID exist with requested ID
		$result = es_cls_sentmail::es_sentmail_count($did);
		if ($result != '1') {
			?><div class="error fade">
				<p><strong>
					<?php echo __( 'Oops, selected details does not exists.', ES_TDOMAIN ); ?>
				</strong></p>
			</div><?php
		} else {
			// Form submitted, check the action
			if (isset($_GET['ac']) && $_GET['ac'] == 'del' && isset($_GET['did']) && $_GET['did'] != '') {
				//	Just security thingy that wordpress offers us
				check_admin_referer('es_form_show');

				//	Delete selected record from the table
				es_cls_sentmail::es_sentmail_delete($did);

				//	Set success message
				$es_success_msg = TRUE;
				$es_success = __( 'Selected record deleted.', ES_TDOMAIN );
			}
		}
	} else {
		check_admin_referer('es_form_show');
		es_cls_optimize::es_optimize_setdetails();
		$es_success_msg = TRUE;
		$es_success = __( 'Successfully deleted all reports except latest 10.', ES_TDOMAIN );
	}	
	if ($es_success_msg == TRUE) {
		?><div class="notice notice-success is-dismissible">
			<p><strong>
				<?php echo $es_success; ?>
			</strong></p>
		</div><?php
	}
}

?>

<style>
	.page-numbers {
		background: none repeat scroll 0 0 rgba(0, 0, 0, 0.05);
		border-color: #CCCCCC;
		color: #555555;
		padding: 5px;
		text-decoration:none;
		margin-left:2px;
		margin-right:2px;
	}
	.current {
		background: none repeat scroll 0 0 #BBBBBB;
	}
</style>

<?php
	$pagenum = isset( $_GET['pagenum'] ) ? absint( $_GET['pagenum'] ) : 1;
	es_cls_security::es_check_number($pagenum);
	$limit = 15;
	$offset = ($pagenum - 1) * $limit;
	$total = es_cls_sentmail::es_sentmail_count(0);
	$fulltotal = $total;
	$total = ceil( $total / $limit );

	$myData = array();
	$myData = es_cls_sentmail::es_sentmail_select(0, $offset, $limit);

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
		<?php echo __( 'Reports', ES_TDOMAIN ); ?>
		<a class="add-new-h2" target="_blank" href="<?php echo ES_FAV; ?>"><?php echo __( 'Help', ES_TDOMAIN ); ?></a>
	</h2>
	<p class="description">
		<?php echo __( 'It will show reports for all Newsletters & Post Notification emails sent.', ES_TDOMAIN ); ?>
	</p>
	<div class="tablenav">
		<div class="alignright" style="padding-bottom:10px;"><?php echo $page_links; ?></div>
	</div>
	<div class="tool-box">
		<form name="frm_es_display" method="post" onsubmit="return _es_bulkaction()">
			<table width="100%" class="widefat" id="straymanage">
				<thead>
					<tr>
						<th scope="col"><?php echo __( 'View Reports', ES_TDOMAIN ); ?></th>
						<th scope="col"><?php echo __( 'Preview', ES_TDOMAIN ); ?></th>
						<th scope="col"><?php echo __( 'Type', ES_TDOMAIN ); ?></th>
						<th scope="col"><?php echo __( 'Status', ES_TDOMAIN ); ?></th>
						<th scope="col"><?php echo __( 'Sent', ES_TDOMAIN ); ?></th>
						<th scope="col"><?php echo __( 'Start Date', ES_TDOMAIN ); ?></th>
						<th scope="col"><?php echo __( 'End Date', ES_TDOMAIN ); ?></th>
						<th scope="col"><?php echo __( 'Total', ES_TDOMAIN ); ?></th>
						<th scope="col"><?php echo __( 'Action', ES_TDOMAIN ); ?></th>
					</tr>
				</thead>
				<tfoot>
					<tr>
						<th scope="col"><?php echo __( 'View Reports', ES_TDOMAIN ); ?></th>
						<th scope="col"><?php echo __( 'Preview', ES_TDOMAIN ); ?></th>
						<th scope="col"><?php echo __( 'Type', ES_TDOMAIN ); ?></th>
						<th scope="col"><?php echo __( 'Status', ES_TDOMAIN ); ?></th>
						<th scope="col"><?php echo __( 'Sent', ES_TDOMAIN ); ?></th>
						<th scope="col"><?php echo __( 'Start Date', ES_TDOMAIN ); ?></th>
						<th scope="col"><?php echo __( 'End Date', ES_TDOMAIN ); ?></th>
						<th scope="col"><?php echo __( 'Total', ES_TDOMAIN ); ?></th>
						<th scope="col"><?php echo __( 'Action', ES_TDOMAIN ); ?></th>
					</tr>
				</tfoot>
				<tbody>
					<?php 
					$i = 0;
					if(count($myData) > 0) {
						$i = 1;
						foreach ($myData as $data) {
							?>
							<tr class="<?php if ($i&1) { echo 'alternate'; } else { echo ''; } ?>">
								<td>
									<a title="Click For Report" href="<?php echo ES_ADMINURL; ?>?page=es-sentmail&amp;ac=delivery&amp;sentguid=<?php echo $data['es_sent_guid']; ?>">
									<?php echo $data['es_sent_guid']; ?>
									</a>
								</td>
								<td>
									<a title="Mail Preview" href="<?php echo ES_ADMINURL; ?>?page=es-sentmail&amp;ac=preview&amp;did=<?php echo $data['es_sent_id']; ?>&amp;pagenum=<?php echo $pagenum; ?>">
										<img alt="Delete" src="<?php echo ES_URL; ?>images/preview.gif" />
									</a>
								</td>
								<td><?php echo $data['es_sent_source']; ?></td>
								<td><?php echo es_cls_common::es_disp_status($data['es_sent_status']); ?></td>
								<td><?php echo es_cls_common::es_disp_status($data['es_sent_type']); ?></td>
								<td>
									<?php
										if ( $data['es_sent_starttime'] != '0000-00-00 00:00:00' ) {
											echo get_date_from_gmt($data['es_sent_starttime'],'Y-m-d H:i:s');
										} else {
											echo $data['es_sent_starttime'];
										}
									?>
								</td>
								<td>
									<?php
										if ( $data['es_sent_endtime'] != '0000-00-00 00:00:00' ) {
											echo get_date_from_gmt($data['es_sent_endtime'],'Y-m-d H:i:s');
										} else {
											echo $data['es_sent_endtime'];
										}
									?>
								</td>
								<td><?php echo $data['es_sent_count']; ?></td>
								<td>
									<a title="Delete Record" onClick="javascript:_es_delete('<?php echo $data['es_sent_id']; ?>')" href="javascript:void(0);">
									<img alt="Delete" src="<?php echo ES_URL; ?>images/delete.gif" /></a>
								</td>
							</tr>
							<?php
								$i = $i+1;
						}
					} else {
						?><tr><td colspan="9" align="center"><?php echo __( 'No records available.', ES_TDOMAIN ); ?></td></tr><?php 
					}
					?>
				</tbody>
			</table>
			<?php wp_nonce_field('es_form_show'); ?>
			<input type="hidden" name="frm_es_display" value="yes"/>
			<div class="tablenav" style="padding-top:10px;">
				<div class="alignleft">
					<input type="hidden" name="action" id="action" value="optimize-table">
					<input type="submit" value="<?php echo __( 'Optimize Table & Delete Records', ES_TDOMAIN ); ?>" class="button-primary action" id="doaction" name="">
				</div>
				<div class="alignright"><?php echo $page_links; ?></div>
			</div>
			<input type="hidden" name="frm_es_bulkaction" value=""/>
		</form>
		<?php if ( $fulltotal > 30 ) { ?>
			<div class="error fade">
				<p>
					<?php echo __( 'Note: Please click on <strong>Optimize Table & Delete Records</strong> button to delete all reports except latest 10.', ES_TDOMAIN ); ?>
				</p>
			</div>
		<?php } ?>
	</div>
	<div style="height:10px;"></div>
	<p class="description"><?php echo ES_OFFICIAL; ?></p>
</div>