<?php
include 'cors.php';

error_reporting(0);

$root = '/w/omgmobc.com/data/';

function download($url, $download_to, $again = false)
{
	$f = curl_init();
	curl_setopt($f, CURLOPT_URL, $url);
	curl_setopt($f, CURLOPT_HEADER, 0);
	curl_setopt($f, CURLOPT_POST, 0);
	curl_setopt($f, CURLOPT_RETURNTRANSFER, 1);
	if ($again) {
		curl_setopt(
			$f,
			CURLOPT_USERAGENT,
			'Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.84 Safari/537.36'
		);
	} else {
		curl_setopt($f, CURLOPT_USERAGENT, $_SERVER['HTTP_USER_AGENT']);
	}

	curl_setopt($f, CURLOPT_SSL_VERIFYHOST, 2);
	curl_setopt($f, CURLOPT_SSL_VERIFYPEER, false);

	curl_setopt($f, CURLOPT_VERBOSE, 0);
	curl_setopt($f, CURLOPT_CONNECTTIMEOUT, 40);
	curl_setopt($f, CURLOPT_TIMEOUT, 40);
	curl_setopt($f, CURLOPT_MAXREDIRS, 10);
	curl_setopt($f, CURLOPT_FOLLOWLOCATION, true);

	if ($again) {
		curl_setopt($f, CURLOPT_REFERER, 'https://omgmobc.com/index.html');
	} else {
		curl_setopt($f, CURLOPT_REFERER, $url);
	}

	curl_setopt($f, CURLOPT_HTTPHEADER, array(
		'accept: image/*,video/*,audio/*,*/*;q=0.8',
		//'accept-encoding: gzip, deflate, br',
		'dnt: 1',
		'upgrade-insecure-requests: 1',
	));

	$fp = fopen($download_to, 'w+');
	curl_setopt($f, CURLOPT_FILE, $fp);
	$c = curl_exec($f);
	fclose($fp);

	if (curl_errno($f) and !$again) {
		return download($url, $download_to, true);
	} else {
		return @curl_getinfo($f, CURLINFO_CONTENT_TYPE);
	}
}

$path = 'tmp/';

if (isset($_GET['url'])) {
	if (
		(strpos($_GET['url'], 'https://') === 0 or strpos($_GET['url'], 'http://') === 0) and
		strpos($_GET['url'], 'https://omgmobc.com/php/image') === false
	) {
		$ext = strtolower(pathinfo(preg_replace('~[?].*$~', '', $_GET['url']), PATHINFO_EXTENSION));

		if (!in_array($ext, $formats_all)) {
			$ext = 'txt';
		}

		$url = $path . md5($_GET['url']) . '.' . $ext;
		$filename = $root . $url;

		$a = 0;
		while (@file_exists($filename . '.lock')) {
			$a++;
			usleep(900000);
			if ($a > 40) {
				break;
			}
		}
		if (!file_exists($filename) or filesize($filename) < 1) {
			touch($filename . '.lock');
			touch($filename);
			download($_GET['url'], $filename);
			if (!filesize($filename)) {
				file_put_contents($filename, file_get_contents($_GET['url']));
			}
			unlink($filename . '.lock');

			if (filesize($filename) < 1) {
				unlink($filename);
			}
		} else {
			touch($filename);
		}

		header('Location: https://omgmobc.com/' . $url);
	}
}
