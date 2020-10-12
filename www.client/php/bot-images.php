<?php

include 'cors.php';

error_reporting(0);

$root = '/w/omgmobc.com/data/';

function jail($source)
{
	if (
		preg_match('~jpg$~i', $source) ||
		preg_match('~jpeg$~i', $source) ||
		preg_match('~jfif$~i', $source)
	) {
		$im = @imagecreatefromjpeg($source);
	} elseif (preg_match('~gif$~i', $source)) {
		$im = @imagecreatefromgif($source);
	} elseif (preg_match('~png$~i', $source)) {
		$im = @imagecreatefrompng($source);
	} elseif (preg_match('~bmp$~i', $source)) {
		$im = @imagecreatefromwbmp($source);
	}

	switch ($_GET['kind']) {
		case 'jail':
			$kind = 'jail';
			break;
		case 'handcuff':
		case 'handfuck':
		case 'cuff':
			$kind = 'handcuff';
			break;
		case 'cream':
			$kind = 'cream';
			break;
		case 'kick':
		case 'boot':
			$kind = 'kick';
			break;
		case 'toasty':
			$kind = 'toasty';
			break;
		case 'punch':
			$kind = 'punch';
			break;
		case 'twerk':
			$kind = 'twerk';
			break;
		case 'pie':
			$kind = 'pie';
			break;
		case 'spank':
			$kind = 'spank';
			break;
		case 'cake':
		case 'bday':
			$kind = 'cake';
			break;
		default:
			$kind = 'jail';
			break;
	}

	$mask = imagecreatefrompng('/w/omgmobc.com/site/www.client/img/bot/' . $kind . '.png');

	imagealphablending($im, 1);
	imagealphablending($mask, 1);

	imagecopy($im, $mask, 0, 0, 0, 0, 310, 310);

	Header('Content-type: image/png');
	imagepng($im);
}

if (
	isset($_GET['url']) and
	preg_match('~^[a-z0-9]+\.[a-z]+$~i', $_GET['url']) and
	file_exists($root . 'profile/' . $_GET['url'])
) {
	jail($root . 'profile/' . $_GET['url']);
}
