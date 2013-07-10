<?php	
	require_once('ga.php');
	require_once('yandex_captcha.php');
	$yc = new Yandex_CAPTCHA('test.gif', 'ann.data', 6);
	print $yc->parse();	
?>