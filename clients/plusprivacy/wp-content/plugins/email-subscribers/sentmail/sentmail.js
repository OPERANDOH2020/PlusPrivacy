function _es_delete(id) {
	if(confirm(es_sentmail_notices.es_sentmail_delete)) {
		document.frm_es_display.action="admin.php?page=es-sentmail&ac=del&did="+id;
		document.frm_es_display.submit();
	}
}

function _es_bulkaction() {
	if(document.frm_es_display.action.value == "optimize-table") {
		if(confirm(es_sentmail_notices.es_sentmail_delete_all)) {
			document.frm_es_display.frm_es_bulkaction.value = 'delete';
			document.frm_es_display.action="admin.php?page=es-sentmail&bulkaction=delete";
			document.frm_es_display.submit();
		} else {
			return false;	
		}
	} else {
		return false;	
	}
}