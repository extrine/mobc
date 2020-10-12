<?php

include 'cors.php';

error_reporting(0);

$root = '/w/omgmobc.com/data/';

function thumb($source, $destination, $w = 100, $h = 100, $tiny = false)
{
	if (preg_match($formats_should_copy, $source) or preg_match('~(gif)$~i', $source) and !$tiny) {
		if ($source != $destination) {
			copy($source, $destination);
		}
		return;
	}

	$small = @imagecreatetruecolor($w, $h);

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
		@imagealphablending($small, false);
	} elseif (preg_match('~bmp$~i', $source)) {
		$im = @imagecreatefromwbmp($source);
	} else {
		if ($source != $destination) {
			copy($source, $destination);
		}
		return;
	}

	$exif = @exif_read_data($source);

	$orientation = $exif['Orientation'];
	if ($exif && isset($exif['Orientation'])) {
		if ($orientation != 1) {
			$deg = 0;
			switch ($orientation) {
				case 3:
					$deg = 180;
					break;
				case 6:
					$deg = 270;
					break;
				case 8:
					$deg = 90;
					break;
			}
			if ($deg) {
				$im = imagerotate($im, $deg, 0);
			}
		}
	}

	$O_X = @imagesx($im);
	$O_Y = @imagesy($im);

	$OriginalX = $O_X;
	$OriginalY = $O_Y;
	if ($OriginalX < $OriginalY) {
		$OriginalY = floor(($h * $OriginalX) / $w);
		@imagecopyresampled(
			$small,
			$im,
			0,
			0,
			0,
			ceil(($O_Y - $OriginalY) / 2),
			$w,
			$h,
			$OriginalX,
			$OriginalY
		);
	} else {
		$OriginalX = floor(($w * $OriginalY) / $h);
		@imagecopyresampled(
			$small,
			$im,
			0,
			0,
			ceil(($O_X - $OriginalX) / 2),
			0,
			$w,
			$h,
			$OriginalX,
			$OriginalY
		);
	}
	@imageinterlace($small, 1);

	if (
		preg_match('~jpg$~i', $source) ||
		preg_match('~jpeg$~i', $source) ||
		preg_match('~jfif$~i', $source)
	) {
		$im = @imagejpeg($small, $destination, 90);
	} elseif (preg_match('~gif$~i', $source)) {
		@imagesavealpha($small, true);
		$im = @imagepng($small, $destination, 6, PNG_ALL_FILTERS);
	} elseif (preg_match('~png$~i', $source)) {
		@imagesavealpha($small, true);
		$im = @imagepng($small, $destination, 6, PNG_ALL_FILTERS);
	} elseif (preg_match('~bmp$~i', $source)) {
		$im = @imagejpeg($small, $destination, 90);
	}
}
if (isset($_GET['action'])) {
	$_GET['action'] = trim($_GET['action']);
	switch ($_GET['action']) {
		case 'copy':
			if (isset($_GET['f'])) {
				$_GET['f'] = str_replace('/', '', str_replace('\\', '', trim($_GET['f'])));
				if (isset($_GET['to'])) {
					$_GET['to'] = trim($_GET['to']);
					if ($_GET['to'] == 'profile' or $_GET['to'] == 'cover') {
						$from = $root . 'gallery/' . $_GET['f'];
						$to = $root . '' . $_GET['to'] . '/' . $_GET['f'];
						if (file_exists($from)) {
							if ($_GET['to'] == 'profile') {
								thumb($from, $to, 310, 310);
								$extension = @strtolower(@end(@explode('.', $from)));

								if (in_array($extension, $formats_video)) {
									shell_exec(
										'/bin/ffmpeg -i "' .
											$from .
											'" -vframes 1 "' .
											$from .
											'.tmp.png" 2>&1'
									);
									thumb(
										$from . '.tmp.png',
										$root .
											'' .
											$_GET['to'] .
											'/thumb_' .
											str_replace('.' . $extension, '', $_GET['f']) .
											'.png',
										60,
										60,

										true
									);
									@unlink($from . '.tmp.png');
								} else {
									thumb(
										$from,
										$root . '' . $_GET['to'] . '/thumb_' . $_GET['f'],
										60,
										60,

										true
									);
								}
								echo 'copied';
							} elseif ($_GET['to'] == 'cover') {
								thumb($from, $to, 1500, 1125);
								echo 'copied';
							} else {
								copy($from, $to);
								echo 'copied';
							}
						} else {
							echo 'File not found: ' . $from;
						}
					} else {
						echo 'Missing destination!';
					}
				} else {
					echo 'Missing destination!';
				}
			} else {
				echo 'Missing filename!';
			}
			break;

		case 'list':
			$paths = array($root . 'gallery/', $root . 'cover/', $root . 'profile/');
			foreach ($paths as $path) {
				foreach (glob($path . '*') as $file) {
					echo preg_replace('/\.[^\.]+$/', '', basename($file)) . "\n";
				}
			}
			break;

		case 'upload':
			if (isset($_GET['type'])) {
				$_GET['type'] = trim($_GET['type']);
				switch ($_GET['type']) {
					case 'profile':
						$folder = 'profile';
						$w = 310;
						$h = 310;

						break;
					case 'cover':
						$folder = 'cover';
						$w = 1500;
						$h = 1125;

						break;
					case 'gallery':
						$folder = 'gallery';
						$w = 0;
						$h = 0;

						break;
					case 'tmp':
						$folder = 'tmp';
						$w = 0;
						$h = 0;

						break;
					default:
						die('Please select an image..!');
						break;
				}
			} else {
				die('Reload the page and try again..!');
			}

			$host = 'https://omgmobc.com/' . $folder . '/';

			$folderpath = $root . '' . $folder . '/';

			$name = $_FILES['file']['name'];

			$size = $_FILES['file']['size'];

			if (strlen($name)) {
				$extension = @strtolower(@end(@explode('.', $name)));

				if (in_array($extension, $formats_all)) {
					$size_ = 1024 * 1024 * 50;

					if ($size < $size_) {
						$tmp = $_FILES['file']['tmp_name'];

						$hash = sha1_file($tmp);
						$imagename = $hash . '.' . $extension;

						$path = $folderpath . $imagename;
						if (move_uploaded_file($tmp, $path)) {
							$destination_thumb = $folderpath . 'thumb_' . $imagename;
							if ($folder == 'gallery') {
								if (in_array($extension, $formats_video)) {
									if (!file_exists($folderpath . 'thumb_' . $hash . '.png')) {
										shell_exec(
											'/bin/ffmpeg -i "' .
												$path .
												'" -vframes 1 "' .
												$folderpath .
												'thumb_' .
												$hash .
												'.tmp.png" 2>&1'
										);
										thumb(
											$folderpath . 'thumb_' . $hash . '.tmp.png',
											$folderpath . 'thumb_' . $hash . '.png',
											60,
											60,
											true
										);
										@unlink($folderpath . 'thumb_' . $hash . '.tmp.png');
									}
								} else {
									thumb($path, $destination_thumb, 60, 60, true);
								}
							} elseif ($folder == 'profile') {
								if (in_array($extension, $formats_video)) {
									if (!file_exists($folderpath . 'thumb_' . $hash . '.png')) {
										shell_exec(
											'/bin/ffmpeg -i "' .
												$path .
												'" -vframes 1 "' .
												$folderpath .
												'thumb_' .
												$hash .
												'.tmp.png" 2>&1'
										);
										thumb(
											$folderpath . 'thumb_' . $hash . '.tmp.png',
											$folderpath . 'thumb_' . $hash . '.png',
											60,
											60,
											true
										);
										@unlink($folderpath . 'thumb_' . $hash . '.tmp.png');
									}
								} else {
									thumb($path, $destination_thumb, 60, 60, true);
								}
								thumb($path, $path, $w, $h);
							} else {
								// cover image
								thumb($path, $path, $w, $h);
							}
							echo $host . $hash . '.' . $extension;
						} else {
							echo 'Error please try again in a few seconds.';
						}
					} else {
						echo 'Image too big, max size of videos/gifs 4Mb for pictures 20Mb. Tip: Make a video from gifs using https://ezgif.com/gif-to-mp4 !';
					}
				} else {
					echo 'Image format invalid, please select one of: ' .
						implode(', ', $formats_all);
				}
			} else {
				echo 'Please select an image..!';
			}
			break;
	}
}
