<?php
	include('../shared/shared.php');

	$password = $_POST['password'];
	$username = $_POST['username'];

	if (validateAccount($username, $password)) {
		http_response_code(204);
	} else {
		http_response_code(409);
	}
?>