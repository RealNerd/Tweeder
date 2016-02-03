<?php
	include('../shared/shared.php');

	$password = $_POST['password'];
	$username = $_POST['username'];

	if (validateAccount($username, $password)) {
		header("Status: 204 No Data");
	} else {
		header("Status: 404 Not Found");
	}
?>