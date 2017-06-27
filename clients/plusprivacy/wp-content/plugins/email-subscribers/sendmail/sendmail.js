function _es_redirect() {
	window.location = "admin.php?page=es-sendemail";
}

function _es_mailgroup(es_email_group) {
	document.getElementById("es_templ_heading").value = document.es_form.es_templ_heading.value;
	document.getElementById("es_sent_type").value = document.es_form.es_sent_type.value;
	document.getElementById("es_email_group").value = es_email_group;
	document.getElementById("sendmailsubmit").value = "no";
	document.getElementById("wp_create_nonce").value = document.es_form.wp_create_nonce.value;
	document.es_form.action="admin.php?page=es-sendemail";
	document.es_form.submit();
}

function _es_submit() {
	if(document.es_form.es_templ_heading.value=="") {
		alert(es_sendmail_notices.es_sendmail_subject);
		document.es_form.es_templ_heading.focus();
		return false;
	}
	if(document.es_form.es_sent_type.value=="") {
		alert(es_sendmail_notices.es_sendmail_status);
		document.es_form.es_sent_type.focus();
		return false;
	}
	
	if(confirm(es_sendmail_notices.es_sendmail_confirm)) {
		document.getElementById("es_templ_heading").value = document.es_form.es_templ_heading.value;
		document.getElementById("es_sent_type").value = document.es_form.es_sent_type.value;
		document.getElementById("es_email_group").value = document.es_form.es_email_group.value;
		document.getElementById("wp_create_nonce").value = document.es_form.wp_create_nonce.value;
		document.getElementById("sendmailsubmit").value = "yes";
		document.es_form.submit();
	} else {
		return false;
	}
}