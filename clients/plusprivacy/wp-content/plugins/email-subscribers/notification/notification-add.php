<?php

// Exit if accessed directly
if ( ! defined( 'ABSPATH' ) ) {
	exit; 
}

?>

<div class="wrap">
	<?php
	$es_errors = array();
	$es_success = '';
	$es_error_found = FALSE;

	// Preset the form fields
	$form = array(
		'es_note_id' => '',
		'es_note_cat' => '',
		'es_note_group' => '',
		'es_note_templ' => '',
		'es_note_status' => ''
	);

	// Form submitted, check the data
	if (isset($_POST['es_form_submit']) && $_POST['es_form_submit'] == 'yes') {

		//	Just security thingy that wordpress offers us
		check_admin_referer('es_form_add');

		$form['es_note_group'] = isset($_POST['es_note_group']) ? $_POST['es_note_group'] : '';
		if ($form['es_note_group'] == '') {
			$es_errors[] = __( 'Please select subscribers group.', ES_TDOMAIN );
			$es_error_found = TRUE;
		}

		$form['es_note_status'] = isset($_POST['es_note_status']) ? $_POST['es_note_status'] : '';
		if ($form['es_note_status'] == '') {
			$es_errors[] = __( 'Please select notification status.', ES_TDOMAIN );
			$es_error_found = TRUE;
		}

		$form['es_note_templ'] = isset($_POST['es_note_templ']) ? $_POST['es_note_templ'] : '';
		if ($form['es_note_templ'] == '') {
			$es_errors[] = __( 'Please select notification mail subject. Use compose menu to create new.', ES_TDOMAIN );
			$es_error_found = TRUE;
		}

		$es_note_cat = isset($_POST['es_note_cat']) ? $_POST['es_note_cat'] : '';
		if ($es_note_cat == '') {
			$es_errors[] = __( 'Please select post categories.', ES_TDOMAIN );
			$es_error_found = TRUE;
		}

		//	No errors found, we can add this Group to the table
		if ($es_error_found == FALSE) {
			$action = false;
			$listcategory = "";
			$total = count($es_note_cat);
			if( $total > 0 ) {
				for($i = 0; $i < $total; $i++) {
					$listcategory = $listcategory . " ##" . wp_specialchars_decode(stripslashes($es_note_cat[$i]),ENT_QUOTES) . "## ";
					if($i != ($total - 1)) {
						$listcategory = $listcategory .  "--";
					}
				}
			}
			$form['es_note_cat'] = $listcategory;
			$action = es_cls_notification::es_notification_ins($form, $action = "insert");
			if($action) {
				$es_success = __( 'Notification successfully created. ', ES_TDOMAIN );
			}

			// Reset the form fields
			$form = array(
				'es_note_id' => '',
				'es_note_cat' => '',
				'es_note_group' => '',
				'es_note_templ' => '',
				'es_note_status' => ''
			);
		}
	}

	if ($es_error_found == TRUE && isset($es_errors[0]) == TRUE) {
		?><div class="error fade">
			<p><strong>
				<?php echo $es_errors[0]; ?>
			</strong></p>
		</div><?php
	}

	if ($es_error_found == FALSE && strlen($es_success) > 0) {
		?>
		<div class="notice notice-success is-dismissible">
			<p><strong>
				<?php echo $es_success; ?>
			</strong></p>
		</div>
		<?php
	}
	?>

	<style>
		.form-table th {
			width: 250px;
		}
	</style>

	<div class="wrap">
		<h2>
			<?php echo __( 'Add Notification', ES_TDOMAIN ); ?>
			<a class="add-new-h2" target="_blank" href="<?php echo ES_FAV; ?>"><?php echo __( 'Help', ES_TDOMAIN ); ?></a>
		</h2>
		<form name="es_form" method="post" action="#" onsubmit="return _es_submit()">
			<table class="form-table">
				<tbody>
					<tr>
						<th scope="row">
							<label for="tag-link"><?php echo __( 'Select Subscribers Group', ES_TDOMAIN ); ?></label>
						</th>
						<td>
							<select name="es_note_group" id="es_note_group">
								<option value=''><?php echo __( 'Select', ES_TDOMAIN ); ?></option>
								<?php
								$groups = array();
								$groups = es_cls_dbquery::es_view_subscriber_group();
								if(count($groups) > 0) {
									$i = 1;
									foreach ($groups as $group) {
										?>
										<option value="<?php echo stripslashes($group["es_email_group"]); ?>"><?php echo stripslashes($group["es_email_group"]); ?></option>
										<?php
									}
								}
								?>
							</select>
						</td>
					</tr>
					<tr>
						<th scope="row">
	 						<label for="tag-link"><?php echo __( 'Select Notification Email Subject', ES_TDOMAIN ); ?>
								<p class="description"><?php echo __( '(Use compose menu to create new)', ES_TDOMAIN ); ?></p>
	 						</label>
	 					</th>
	 					<td>
							<select name="es_note_templ" id="es_note_templ">
								<option value=''><?php echo __( 'Select', ES_TDOMAIN ); ?></option>
								<?php
								$subject = array();
								$subject = es_cls_compose::es_template_select_type($type = "Post Notification");
								$thisselected = "";
								if(count($subject) > 0) {
									$i = 1;
									foreach ($subject as $sub) {
										?>
										<option value='<?php echo $sub["es_templ_id"]; ?>'><?php echo $sub["es_templ_heading"]; ?></option>
										<?php
									}
								}
								?>
							</select>
						</td>
					</tr>
	 				<tr>
	 					<th scope="row">
							<label for="tag-link"><?php echo __( 'Select Post Categories', ES_TDOMAIN ); ?></label>
						</th>
						<td>
							<?php
							$args = array( 'hide_empty' => 0, 'orderby' => 'name', 'order' => 'ASC' );
							$categories = get_categories($args);
							$count = 0;
							$col = 3;
							echo "<table border='0' cellspacing='0'><tr>"; 
							foreach($categories as $category) {
								echo "<td style='padding-top:4px;padding-bottom:4px;padding-right:10px;'>";
								?>
								<input type="checkbox" value="<?php echo htmlspecialchars($category->cat_name, ENT_QUOTES); ?>" id="es_note_cat[]" name="es_note_cat[]">
								<?php
								echo $category->cat_name;
								if($col > 1) {
									$col = $col-1;
									echo "</td><td>"; 
								} elseif($col = 1) {
									$col = $col-1;
									echo "</td></tr><tr>";;
									$col = 3;
								}
								$count = $count + 1;
							}
							echo "</tr></table>";
							?>
							<p class="select_all" style="margin-left: 0.7em;">
								<input type="button" name="CheckAll" class="button add-new-h2" value="<?php echo __( 'Check All', ES_TDOMAIN ); ?>" onClick="_es_checkall('es_form', 'es_note_cat[]', true);">
								<input type="button" name="UnCheckAll" class="button add-new-h2" value="<?php echo __( 'Uncheck All', ES_TDOMAIN ); ?>" onClick="_es_checkall('es_form', 'es_note_cat[]', false);">
							</p>
						</td>
					</tr>
	 				<tr>
		 				<th scope="row">
							<label for="tag-link"><?php echo __( 'Select your Custom Post Type', ES_TDOMAIN ); ?>
								<p class="description"><?php echo __( '(Optional)', ES_TDOMAIN ); ?></p>
							</label>
						</th>
						<td>
							<?php
							$args=array('public'=> true, 'exclude_from_search'=> false, '_builtin' => false); 
							$output = 'names';
							$operator = 'and';
							$post_types=get_post_types($args,$output,$operator);
							if( !empty( $post_types ) ) {
								$col = 3;
								echo "<table border='0' cellspacing='0'><tr>"; 
								foreach($post_types as $post_type) {     
									echo "<td style='padding-top:4px;padding-bottom:4px;padding-right:10px;'>";
									?>
									<input type="checkbox" value='{T}<?php echo $post_type; ?>{T}' id="es_note_cat[]" name="es_note_cat[]">
									<?php echo $post_type;
									if($col > 1) {
										$col = $col-1;
										echo "</td><td>"; 
									} elseif($col = 1) {
										$col = $col-1;
										echo "</td></tr><tr>";;
										$col = 3;
									}
									$count = $count + 1;
								}
								echo "</tr></table>";
							} else {
								echo __( 'No Custom Post Types Available', ES_TDOMAIN );
							}
							?>
						</td>
	 				</tr>
					<tr>
						<th scope="row">
							<label for="tag-link"><?php echo __( 'Select Notification Status when a new post is published', ES_TDOMAIN ); ?></label>
						</th>
						<td>
							<select name="es_note_status" id="es_note_status">
								<option value='Enable' selected="selected"><?php echo __( 'Send email immediately', ES_TDOMAIN ); ?></option>
								<option value='Cron'><?php echo __( 'Add to cron and send email via cron job', ES_TDOMAIN );?></option>
								<option value='Disable'><?php echo __( 'Disable email notification', ES_TDOMAIN ); ?></option>
							</select>
						</td>
					</tr>
				</tbody>
			</table>
			<input type="hidden" name="es_form_submit" value="yes"/>
			<p class="submit">
				<input type="submit" class="button-primary" value="<?php echo __( 'Save', ES_TDOMAIN ); ?>" />
			</p>
		  <?php wp_nonce_field('es_form_add'); ?>
	    </form>
	</div>
	<p class="description"><?php echo ES_OFFICIAL; ?></p>
</div>