<?php

include 'cors.php';

error_reporting(0);

$root = '/w/omgmobc.com/data/tmp/';

$interval = strtotime('-7 days');
$deleted = 0;
foreach (glob($root . '*') as $file) {
	if (fileatime($file) <= $interval) {
		$deleted++;
		@unlink($file);
	}
}
echo $deleted;
