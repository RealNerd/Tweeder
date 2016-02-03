<?php

	function accountFilenameForUsername($username) {

		// use the md5 of the username to avoid cases where weird characters in username could create filesystem trouble
		return '/home/hollys11/tmp/data/' . md5($username);
	}

	function messageFilenameForUsername($username) {

		return '/home/hollys11/tmp/data/' . md5($username) . '.messages';
	}

	function accountExists($username) {

		return file_exists(accountFilenameForUsername($username));
	}

	function createAccount($username, $password) {

		if (accountExists($username)) {
			return FALSE;
		}

		$accountData = array('password' => $password, 'ts' => time());
		file_put_contents(accountFilenameForUsername($username), json_encode(($accountData)));

		return TRUE;
	}

	function validateAccount($username, $password) {

		if (accountExists($username)) {
			$data = file_get_contents(accountFilenameForUsername($username));
			$accountData = json_decode($data);
			if ($accountData->password == $password) {
				return TRUE;
			}
		}

		return FALSE;
	}

	function loadAllMessagesForUsername($username) {

		if (!accountExists($username)) {
			return FALSE;
		}

		$messagesFileName = messageFilenameForUsername($username);
		if (file_exists($messagesFileName)) {
			$jsonData = file_get_contents($messagesFileName);
			$messagesData = json_decode($jsonData);

			return $messagesData;
		} else {

			return array();
		}
	}

	function addMessageForUser($username, $message) {

		$currentMessages = loadAllMessagesForUsername($username);
		$newMessageObject = array('message' => $message, 'ts' => time());
		array_unshift($currentMessages, $newMessageObject); // php has an odd way of prepending to an array
		return file_put_contents(messagesFileName($username), $currentMessages);
	}
?>