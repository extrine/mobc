<?php

$formats_all = [
	'apng',
	'bmp',
	'gif',
	'jfif',
	'jpeg',
	'jpg',
	'mp3',
	'mp4',
	'mpeg',
	'mpg',
	'ogg',
	'ogv',
	'png',
	'webm',
	'webp',
	'gifv',
];

$formats_should_copy = '~(mpg|mpeg|mp4|webm|ogv|webp|apng)$~i';
$formats_video = ['mpg', 'mpeg', 'mp4', 'webm', 'ogv'];

/*
$image = /\.(png|apng|jpg|jpeg|gif|svg|webp|jfif)/gi
$audio = /\.(wav|mp3|m4a|ogg)/gi
*/
