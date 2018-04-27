<?php
$ModifiedCode = $_GET['Code'];
$Code = EWD_UFAQ_Decrypt_Catpcha_Code($ModifiedCode);
$im = imagecreatetruecolor(50, 24);
$bg = imagecolorallocate($im, 22, 86, 165);  
$fg = imagecolorallocate($im, 255, 255, 255); 
imagefill($im, 0, 0, $bg);
imagestring($im, 5, 5, 5,  $Code, $fg);
header("Cache-Control: no-cache, must-revalidate");
header('Content-type: image/png');
imagepng($im);
imagedestroy($im);


function EWD_UFAQ_Decrypt_Catpcha_Code($ModifiedCode) {
	$Code = ($ModifiedCode / 3) - 5;

	return $Code;
}
?>