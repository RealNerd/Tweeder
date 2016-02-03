<?php
	include('../shared/shared.php');

	$message  = $_POST['message'];
	$username = $_POST['username'];

	if (addMessageForUser($username, $message)) {
		header("Status: 204 No Data");
	} else {
		header("Status: 500 Server Error");
	}
?>