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

	// First check if ID exist with requested ID
	$result = es_cls_notification::es_notification_count($did);
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
			es_cls_notification::es_notification_delete($did);

			//	Set success message
			$es_success_msg = TRUE;
			$es_success = __( 'Selected record deleted.', ES_TDOMAIN );
		}
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

<div class="wrap">
	<h2>
		<?php echo __( 'Post Notifications', ES_TDOMAIN ); ?>  
		<a class="add-new-h2" href="<?php echo ES_ADMINURL; ?>?page=es-notification&amp;ac=add"><?php echo __( 'Add New', ES_TDOMAIN ); ?></a>
		<a class="add-new-h2" target="_blank" href="<?php echo ES_FAV; ?>"><?php echo __( 'Help', ES_TDOMAIN ); ?></a>
	</h2>
	<p class="description"  style="margin-bottom:1em;">
		<?php echo __( 'Use this to setup and send notification emails to your subscribers when a new post is published in your blog.', ES_TDOMAIN ); ?>
	</p>
	<div class="tool-box">
		<?php
		$myData = array();
		$myData = es_cls_notification::es_notification_select(0);
		?>
		<form name="frm_es_display" method="post">
			<table width="100%" class="widefat" id="straymanage">
				<thead>
					<tr>
						<th scope="col"><?php echo __( 'Email Subject', ES_TDOMAIN ); ?></th>
						<th scope="col"><?php echo __( 'Subscribers Group', ES_TDOMAIN ); ?></th>
						<th scope="col"><?php echo __( 'Post Categories / Custom Post Types', ES_TDOMAIN ); ?></th>
						<th scope="col"><?php echo __( 'Notification Status', ES_TDOMAIN ); ?></th>
					</tr>
				</thead>
				<tfoot>
					<tr>
						<th scope="col"><?php echo __( 'Email Subject', ES_TDOMAIN ); ?></th>
						<th scope="col"><?php echo __( 'Subscribers Group', ES_TDOMAIN ); ?></th>
						<th scope="col"><?php echo __( 'Post Categories / Custom Post Types', ES_TDOMAIN ); ?></th>
						<th scope="col"><?php echo __( 'Notification Status', ES_TDOMAIN ); ?></th>
					</tr>
				</tfoot>
				<tbody>
					<?php
					$i = 0;
					$displayisthere = FALSE;
					if(count($myData) > 0) {
						$i = 1;
						foreach ($myData as $data) {
							?>
							<tr class="<?php if ($i&1) { echo 'alternate'; } else { echo ''; } ?>">
								<td>
									<?php
									$template = es_cls_compose::es_template_select($data['es_note_templ']);
									if (count($template) > 0) {
										echo $template['es_templ_heading'];
									}
									?>
									<div class="row-actions">
										<span class="edit">
											<a title="Edit" href="<?php echo ES_ADMINURL; ?>?page=es-notification&amp;ac=edit&amp;did=<?php echo $data['es_note_id']; ?>"><?php echo __( 'Edit', ES_TDOMAIN ); ?></a> 
										</span>
										<span class="trash">
											| <a onClick="javascript:_es_delete('<?php echo $data['es_note_id']; ?>')" href="javascript:void(0);"><?php echo __( 'Delete', ES_TDOMAIN ); ?></a>
										</span>
									</div>
								</td>
								<td>
									<?php echo stripslashes($data['es_note_group']); ?>
								</td>
								<td>
									<?php 
									$es_note_cat = str_replace("## -- ##", ", ", stripslashes($data['es_note_cat']));
									$es_note_cat = str_replace("##", "", $es_note_cat);
									$es_note_cat = str_replace("{T}", "", $es_note_cat);
									$j = 0;
									$category_display = explode(",", $es_note_cat);
									if(count($category_display) > 0) {
										for($j = 0; $j < count($category_display); $j++) {
											echo $category_display[$j] . ", ";
											if (($j > 0) && ($j % 3 == 0)) {
												echo "<br>";
											}
										}
									}
									?>
								</td>
								<td>
									<?php 
									if ($data['es_note_status'] == "Enable") {
										echo __( 'Send email immediately', ES_TDOMAIN );
									} elseif ($data['es_note_status'] == "Cron") {
										echo __( 'Add to cron and send email via cron job', ES_TDOMAIN );
									} else {
										echo es_cls_common::es_disp_status($data['es_note_status']);
									}
									?>
								</td>
							</tr>
							<?php
							$i = $i+1;
						}
					} else {
						?><tr><td colspan="4" align="center"><?php echo __( 'No records available.', ES_TDOMAIN ); ?></td></tr><?php 
					}
					?>
				</tbody>
			</table>
			<?php wp_nonce_field('es_form_show'); ?>
			<input type="hidden" name="frm_es_display" value="yes"/>
		</form>
	</div>
	<div style="height:10px;"></div>
	<p class="description"><?php echo ES_OFFICIAL; ?></p>
</div>