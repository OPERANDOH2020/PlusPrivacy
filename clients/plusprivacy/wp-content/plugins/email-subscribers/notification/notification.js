function _es_submit() {
	if(document.es_form.es_note_group.value == "") {
		alert(es_notification_notices.es_notification_select_group);
		document.es_form.es_note_group.focus();
		return false;
	} else if(document.es_form.es_note_templ.value == "") {
		alert(es_notification_notices.es_notification_mail_subject);
		document.es_form.es_note_templ.focus();
		return false;
	} else if(document.es_form.es_note_status.value == "") {
		alert(es_notification_notices.es_notification_status);
		document.es_form.es_note_status.focus();
		return false;
	}
}

function _es_checkall(FormName, FieldName, CheckValue) {
	if(!document.forms[FormName])
		return;
	var objCheckBoxes = document.forms[FormName].elements[FieldName];
	if(!objCheckBoxes)
		return;
	var countCheckBoxes = objCheckBoxes.length;
	if(!countCheckBoxes)
		objCheckBoxes.checked = CheckValue;
	else
		// set the check value for all check boxes
		for(var i = 0; i < countCheckBoxes; i++)
			objCheckBoxes[i].checked = CheckValue;
}

function _es_delete(id) {
	if(confirm(es_notification_notices.es_notification_delete_record)) {
		document.frm_es_display.action="admin.php?page=es-notification&ac=del&did="+id;
		document.frm_es_display.submit();
	}
}