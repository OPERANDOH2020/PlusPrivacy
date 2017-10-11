<?php

// Exit if accessed directly
if ( ! defined( 'ABSPATH' ) ) {
	exit; 
}

$home_url = home_url('/');

// All Subscribers
$cnt_all_subscribers = 0;
$cnt_all_subscribers = es_cls_dbquery::es_view_subscriber_count(0);

// Total Active Subscribers (Confirmed & Single Opt In)
$cnt_active_subscribers = 0;
$cnt_active_subscribers = es_cls_dbquery::es_active_subscribers();

// Inactive Subscribers (unconfirmed & Unsubscribed)
$cnt_inactive_subscribers = 0;
$cnt_inactive_subscribers = es_cls_dbquery::es_inactive_subscribers();

// WordPress Registered Users
$cnt_users = 0;
$cnt_users = $wpdb->get_var( "SELECT count(DISTINCT user_email) FROM ". $wpdb->prefix . "users" );

// Users who comments on blog posts
$cnt_comment_author = 0;
$cnt_comment_author = $wpdb->get_var( "SELECT count(DISTINCT comment_author_email) FROM ". $wpdb->prefix . "comments WHERE comment_author_email != ''" );

?>

<div class="wrap">
	<h2 style="margin-bottom:1em;">
		<?php echo __( 'Export Email Addresses', ES_TDOMAIN ); ?>
		<a class="add-new-h2" href="<?php echo ES_ADMINURL; ?>?page=es-view-subscribers&amp;ac=add"><?php echo __( 'Add New Subscriber', ES_TDOMAIN ); ?></a>
		<a class="add-new-h2" href="<?php echo ES_ADMINURL; ?>?page=es-view-subscribers&amp;ac=import"><?php echo __( 'Import', ES_TDOMAIN ); ?></a>
		<a class="add-new-h2" href="<?php echo ES_ADMINURL; ?>?page=es-view-subscribers&amp;ac=sync"><?php echo __( 'Sync', ES_TDOMAIN ); ?></a>
		<a class="add-new-h2" target="_blank" href="<?php echo ES_FAV; ?>"><?php echo __( 'Help', ES_TDOMAIN ); ?></a>
	</h2>
	<div class="tool-box">
		<form name="frm_es_subscriberexport" method="post">
			<table width="100%" class="widefat" id="straymanage">
				<thead>
					<tr>
						<th scope="col"><?php echo __( 'Sno', ES_TDOMAIN ); ?></th>
						<th scope="col"><?php echo __( 'Type of List to Export', ES_TDOMAIN ); ?></th>
						<th scope="col"><?php echo __( 'Total Emails Count', ES_TDOMAIN ); ?></th>
						<th scope="col"><?php echo __( 'Action', ES_TDOMAIN ); ?></th>
					</tr>
				</thead>
				<tfoot>
					<tr>
						<th scope="col"><?php echo __( 'Sno', ES_TDOMAIN ); ?></th>
						<th scope="col"><?php echo __( 'Type of List to Export', ES_TDOMAIN ); ?></th>
						<th scope="col"><?php echo __( 'Total Emails Count', ES_TDOMAIN ); ?></th>
						<th scope="col"><?php echo __( 'Action', ES_TDOMAIN ); ?></th>
					</tr>
				</tfoot>
				<tbody>
					<tr>
						<td><?php echo __( '1', ES_TDOMAIN ); ?></td>
						<td><?php echo __( 'All Subscribers', ES_TDOMAIN ); ?></td>
						<td><?php echo $cnt_all_subscribers; ?></td>
						<td><a onClick="javascript:_es_exportcsv('<?php echo $home_url. "?es=export"; ?>', 'view_all_subscribers')" href="javascript:void(0);"><?php echo __( 'Click to Export in CSV', ES_TDOMAIN ); ?></a></td>
					</tr>
					<tr class="alternate">
						<td><?php echo __( '2', ES_TDOMAIN ); ?></td>
						<td><?php echo __( 'Active Subscribers (Status: Confirmed & Single Opt In)', ES_TDOMAIN ); ?></td>
						<td><?php echo $cnt_active_subscribers; ?></td>
						<td><a onClick="javascript:_es_exportcsv('<?php echo $home_url. "?es=export"; ?>', 'view_active_subscribers')" href="javascript:void(0);"><?php echo __( 'Click to Export in CSV', ES_TDOMAIN ); ?></a></td>
					</tr>
					<tr>
						<td><?php echo __( '3', ES_TDOMAIN ); ?></td>
						<td><?php echo __( 'Inactive Subscribers (Status: Unconfirmed & Unsubscribed)', ES_TDOMAIN ); ?></td>
						<td><?php echo $cnt_inactive_subscribers; ?></td>
						<td><a onClick="javascript:_es_exportcsv('<?php echo $home_url. "?es=export"; ?>', 'view_inactive_subscribers')" href="javascript:void(0);"><?php echo __( 'Click to Export in CSV', ES_TDOMAIN ); ?></a></td>
					</tr>
					<tr class="alternate">
						<td><?php echo __( '4', ES_TDOMAIN ); ?></td>
						<td><?php echo __( 'WordPress Registered Users', ES_TDOMAIN ); ?></td>
						<td><?php echo $cnt_users; ?></td>
						<td><a onClick="javascript:_es_exportcsv('<?php echo $home_url. "?es=export"; ?>', 'registered_user')" href="javascript:void(0);"><?php echo __( 'Click to Export in CSV', ES_TDOMAIN ); ?></a></td>
					</tr>
					<tr>
						<td><?php echo __( '5', ES_TDOMAIN ); ?></td>
						<td><?php echo __( 'Commented Authors', ES_TDOMAIN ); ?></td>
						<td><?php echo $cnt_comment_author; ?></td>
						<td><a onClick="javascript:_es_exportcsv('<?php echo $home_url. "?es=export"; ?>', 'commentposed_user')" href="javascript:void(0);"><?php echo __( 'Click to Export in CSV', ES_TDOMAIN ); ?></a></td>
					</tr>
				</tbody>
			</table>
		</form>
	</div>
</div>