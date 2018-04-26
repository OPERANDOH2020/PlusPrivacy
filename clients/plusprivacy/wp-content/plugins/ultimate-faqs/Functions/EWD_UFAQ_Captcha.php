<?php
function EWD_UFAQ_Validate_Captcha() {
	$ModifiedCode = $_POST['ewd_ufaq_modified_captcha'];
	$UserCode = $_POST['ewd_ufaq_captcha'];

	$Code = EWD_UFAQ_Decrypt_Catpcha_Code($ModifiedCode);

	if ($Code == $UserCode) {$Validate_Captcha = "Yes";}
	else {$Validate_Captcha = "No";}

	return $Validate_Captcha;
}

function EWD_UFAQ_Encrypt_Captcha_Code($Code) {
	$ModifiedCode = ($Code + 5) * 3;

	return $ModifiedCode;
}

function EWD_UFAQ_Decrypt_Catpcha_Code($ModifiedCode) {
	$Code = ($ModifiedCode / 3) - 5;

	return $Code;
}
?>
