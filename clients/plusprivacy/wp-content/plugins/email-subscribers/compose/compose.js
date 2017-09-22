function _es_submit() {
	if(document.es_form.es_templ_heading.value=="") {
		alert(es_compose_notices.es_configuration_name);
		document.es_form.es_templ_heading.focus();
		return false;
	}
}

function _es_delete(id) {
	if(confirm(es_compose_notices.es_compose_delete_record)) {
		document.frm_es_display.action="admin.php?page=es-compose&ac=del&did="+id;
		document.frm_es_display.submit();
	}
}