<?php
	include('../shared/shared.php');

	$lastRequestDate = $_GET['lastRequestDate'];
	$username        = $_GET['username'];

	$messages = loadAllMessagesForUsername($username);

	if ($messages !== FALSE) {
		$outputMessages = array();
		foreach ($messages as $message) {
			if ($message->ts > $lastRequestDate) {
				$outputMessages[] = $message;
			}
		}

		header('Content-Type: application/json');
		print(json_encode($outputMessages));
	} else {
		header("Status: 404 Not Found");
	}

?>