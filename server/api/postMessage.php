<?php
	include('../shared/shared.php');

	$message  = $_POST['message'];
	$username = $_POST['username'];

	if (addMessageForUser($username, $message)) {
		// return 204
		http_response_code(204);
	} else {
		http_response_code(500);
	}
?>