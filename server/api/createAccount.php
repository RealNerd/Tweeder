<?php
	include('../shared/shared.php');

	$password = $_POST['password'];
	$username = $_POST['username'];

	if (createAccount($username, $password)) {
		header("Status: 204 No Data");
	} else {
		header("Status: 409 Conflict");
	}
?>