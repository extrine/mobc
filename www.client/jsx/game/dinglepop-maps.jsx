function GameBubblesMapGenerator() {
	var seed =
		window.room && window.room.round && window.room.round.seed ? window.room.round.seed : Date.now()

	function random() {
		var x = Math.sin(seed++) * 10000
		return x - Math.floor(x)
	}

	function random_number(bottom, top) {
		return Math.floor(random() * (1 + top - bottom)) + bottom
	}

	function maybe(percent) {
		return random() <= percent / 100 ? true : false
	}

	function bubble(number) {
		switch (number) {
			case 0:
				return '_'
			case 1:
				return 'a'
			case 2:
				return 'b'
			case 3:
				return 'c'
			case 4:
				return 'd'
			case 5:
				return 'e'
			case 6:
				return 'f'
		}
	}

	function dinglepop_map() {
		var max_rows = random_number(5, 8)
		var max_cols = 9
		var likehood = 75
		var antilikehood = 24
		var map = []

		map[0] = []
		for (var ii = 0; ii < max_cols; ii++) {
			if (maybe(90)) map[0][ii] = random_number(1, 5)
			else map[0][ii] = 0
		}

		for (var jj = 1; jj < max_rows; jj++) {
			map[jj] = []
			for (var kk = 0; kk < max_cols; kk++) {
				if (jj % 2 == 0) {
					// 9 columns
					if (kk == max_cols - 1) {
						if (maybe(likehood - antilikehood) && map[jj - 1][kk - 1] > 0) {
							map[jj][kk] = random_number(1, 5)
						} else {
							map[jj][kk] = 0
						}
					} else if (kk == 0) {
						if (maybe(likehood - antilikehood) && map[jj - 1][kk] > 0) {
							map[jj][kk] = random_number(1, 5)
						} else {
							map[jj][kk] = 0
						}
					} else {
						if (maybe(likehood) && (map[jj - 1][kk] > 0 || map[jj - 1][kk + 1] > 0)) {
							if (maybe(15)) {
								map[jj][kk] = random_number(1, 6)
							} else {
								map[jj][kk] = random_number(1, 5)
							}
						} else {
							map[jj][kk] = 0
						}
					}
				} else {
					// 8 columns
					if (kk == max_cols - 1) {
						if (
							maybe(likehood - antilikehood) &&
							(map[jj - 1][kk] > 0 || map[jj - 1][kk - 1] > 0)
						) {
							map[jj][kk] = random_number(1, 5)
						} else {
							map[jj][kk] = 0
						}
					} else if (kk == 0 && maybe(30)) {
						if (
							maybe(likehood - antilikehood) &&
							(map[jj - 1][kk] > 0 || map[jj - 1][kk + 1] > 0)
						) {
							map[jj][kk] = random_number(1, 5)
						} else {
							map[jj][kk] = 0
						}
					} else {
						if (
							maybe(likehood + antilikehood) &&
							(map[jj - 1][kk] > 0 || map[jj - 1][kk + 1] > 0)
						) {
							if (maybe(15)) {
								map[jj][kk] = random_number(1, 6)
							} else {
								map[jj][kk] = random_number(1, 5)
							}
						} else {
							map[jj][kk] = 0
						}
					}
				}
			}
		}

		var result = ''
		for (var row in map) {
			var col = map[row].slice(0, 4)
			var reversed = col.slice()
			reversed.reverse()
			if (row % 2 == 0) {
				col.push(random_number(0, 6))
			}
			col = col.concat(reversed)
			map[row] = col
			for (var col in map[row]) {
				result += bubble(map[row][col]) + ' '
			}
			result = result.replace(/ $/, '')
			result += '\n'
		}
		return [result.trim().split('\n')]
	}
	return dinglepop_map()
}

var bubbles_current_maps = []
var bubbles_current_maps_regular = []
var bubbles_maps = [
	[
		'c e d _ _ _ d e c',
		'_ a a a a a a _',
		'_ a f f f f f a _',
		'_ a b _ _ b a _',
		'f d c c f c c d f',
		'_ _ _ e e _ _ _',
		'_ _ _ _ _ _ _ _ _',
		'_ _ _ _ _ _ _ _',
		'_ _ _ _ _ _ _ _ _',
	],
	[
		'a _ _ b _ _ c _ _',
		'b _ e a _ b e _',
		'_ c d _ b c _ d _',
		'_ a _ _ a _ _ a',
		'_ _ _ _ _ _ _ _ _',
		'_ _ _ _ _ _ _ _',
		'_ _ _ _ _ _ _ _ _',
		'_ _ _ _ _ _ _ _',
		'_ _ _ _ _ _ _ _ _',
	],

	[
		'e e b e b e e b e',
		'a c c c c a b e',
		'b e c c c e b d e',
		'b d f f d b d e',
		'a a e d e a a b b',
		'a a b b a a b b',
		'_ _ _ _ _ _ _ _ _',
		'_ _ _ _ _ _ _ _',
		'_ _ _ _ _ _ _ _ _',
	],

	[
		'_ _ c _ e _ c _ _',
		'_ c a e e a c _',
		'c c f a _ a f c c',
		'_ f f _ _ f f _',
		'_ a b a _ a b a _',
		'b _ _ c c _ _ b',
		'_ d d _ b _ d d _',
		'd e _ c c _ e d',
		'e _ a _ _ a _ _ e',
	],
	[
		'_ _ e _ a _ e _ _',
		'e e e a a e e e',
		'_ _ e a a a e _ _',
		'c c b c c b c c',
		'_ _ _ a a a _ _ _',
		'c c b b b b c c',
		'_ _ _ e e e _ _ _',
		'b _ b d d b _ b',
		'_ b b _ c _ b b _',
	],
	[
		'b c _ _ d _ _ b c',
		'b c _ d d _ b c',
		'_ b c d c d b c _',
		'_ e a b b a e _',
		'_ _ b _ a _ b _ _',
		'_ a e b b e a _',
		'_ b c d c d b c _',
		'b c _ d d _ b c',
		'b c _ _ d _ _ b c',
	],
	[
		'e e e b b b e e e',
		'd a d a a c a c',
		'd a a d a c a a c',
		'c b c b b d b d',
		'a a a b d b a a a',
		'c c c b b d d d',
		'_ c c _ e _ d d _',
		'a c _ _ _ _ d a',
		'a _ _ _ _ _ _ _ a',
	],
	[
		'a a _ c _ c _ a a',
		'c b b _ _ b b c',
		'c c a a _ a a c c',
		'e e c c d d e e',
		'e b e b _ b e c e',
		'e e c c d d e e',
		'_ _ a a _ c c _ _',
		'_ b b _ _ b b _',
		'a a _ _ _ _ _ a a',
	],

	[
		'c d d c d c d d c',
		'b e b a a b e b',
		'e b b a d a b b e',
		'a a c _ _ c a a',
		'_ c _ _ _ _ _ c _',
		'd d _ _ _ _ d d',
		'd b d _ _ _ d b d',
		'd d e _ _ e d d',
		'c b e c _ c e b c',
	],

	[
		'a _ a b _ b a _ a',
		'b b _ a a _ b b',
		'_ c _ c _ d _ d _',
		'_ b b e e b b _',
		'd _ d e a e c _ c',
		'c c _ e e _ d d',
		'_ a _ a _ b _ b _',
		'd b b _ _ a a d',
		'd _ _ _ _ _ _ _ d',
	],
	[
		'a c d a b a d c a',
		'e d c b b c d e',
		'c d c b d b c d c',
		'd a b d d b a d',
		'a c b d f d b c a',
		'c b b b b b b c',
		'a a d e _ e d a a',
		'a d e _ _ e d a',
		'_ e _ _ _ _ _ e _',
	],

	[
		'_ _ b a a a d _ _',
		'_ a b e e d a _',
		'_ a e b e d e a _',
		'a e e b d e e a',
		'c c c c a b b b b',
		'a e e d c e e a',
		'_ a e d e c e a _',
		'_ a d e e c a _',
		'_ _ d a a a c _ _',
	],

	[
		'_ _ e d e d e _ _',
		'_ c d b b d a _',
		'_ c c b d b a a _',
		'c c c b b a a a',
		'a e e a e c e e c',
		'e a e b b e c e',
		'_ e e b d b e e _',
		'_ a d b b d c _',
		'_ _ d e e e d _ _',
	],
	[
		'b d c d d d b c d',
		'b c e d d a b d',
		'_ d _ e d a _ c _',
		'c b _ e a _ d b',
		'c d b _ f _ d c b',
		'b c _ a e _ a d',
		'_ d _ a d e _ e _',
		'c b a d d e b a',
		'c d b d d d b c a',
	],

	[
		'd c c e e e e a a',
		'f a e f f a e f',
		'b d c d b d c d a',
		'c a c b c a c a',
		'_ _ _ _ _ _ _ _ _',
		'_ _ _ _ _ _ _ _',
		'_ _ _ _ _ _ _ _ _',
		'_ _ _ _ _ _ _ _',
		'_ _ _ _ _ _ _ _ _',
	],

	[
		'_ _ _ _ c _ _ _ _',
		'_ _ _ d d _ _ _',
		'_ _ _ a b e _ _ _',
		'_ _ a a e e _ _',
		'_ _ d b c b d _ _',
		'_ d d c c d d _',
		'_ b b a f a b b _',
		'e b c f f c b e',
		'e e c c a c c e e',
	],
	[
		'a b _ _ _ _ _ b a',
		'_ a _ _ _ _ a _',
		'_ _ e _ _ _ e _ _',
		'_ _ d _ _ d _ _',
		'_ _ _ a e a _ _ _',
		'_ c a d c a c _',
		'_ _ _ a _ a _ _ _',
		'_ _ b _ _ b _ _',
		'_ _ a _ _ _ a _ _',
	],
	[
		'_ b _ _ _ _ _ b _',
		'_ c _ _ _ _ c _',
		'_ _ e a b a e _ _',
		'b a d a a c a b',
		'_ _ e a b a e _ _',
		'_ c _ c c _ c _',
		'_ b _ _ b _ _ b _',
		'_ _ _ _ _ _ _ _',
		'_ _ _ _ _ _ _ _ _',
	],
	[
		'_ a b a _ a b a _',
		'_ d d _ _ d d _',
		'_ f e f e f e f _',
		'c _ _ d d _ _ c',
		'b b _ a a a _ b b',
		'_ _ _ _ _ _ _ _',
		'_ _ _ _ _ _ _ _ _',
		'_ _ _ _ _ _ _ _',
		'_ _ _ _ _ _ _ _ _',
	],
	[
		'a c a f d f c a c',
		'a a _ f f _ c c',
		'_ a _ _ d _ _ c _',
		'c b _ d d _ d a',
		'c d b e f e d b a',
		'c b _ _ _ _ d a',
		'd e d _ _ _ b e b',
		'd d _ _ _ _ b b',
		'_ d _ _ _ _ _ b _',
	],
	[
		'b a b _ _ _ b a b',
		'c _ e _ _ e _ c',
		'_ c _ d _ d _ c _',
		'_ e _ d d _ e _',
		'_ _ e _ a _ e _ _',
		'_ _ c _ _ b _ _',
		'_ _ _ b _ c _ _ _',
		'_ _ _ a a _ _ _',
		'_ _ _ _ a _ _ _ _',
	],
	[
		'a _ c d _ e a _ c',
		'a c _ d e _ a c',
		'_ b _ _ d _ _ b _',
		'c b _ a c _ b a',
		'c _ b a _ c b _ a',
		'c b _ a c _ b a',
		'_ a _ _ d _ _ c _',
		'a c _ d e _ a c',
		'a _ c d _ e a _ c',
	],
	[
		'c d b d d d b d c',
		'd b a c c e b d',
		'_ b a c d c e b _',
		'_ a c f f c e _',
		'_ e b d f d b a _',
		'c e b d d b a c',
		'd c e b b b a c d',
		'd c d d d d c d',
		'_ _ _ _ _ _ _ _ _',
	],

	[
		'b e d d b d d e b',
		'd d b c c b d d',
		'c e e a a a e e c',
		'c e a c c a e c',
		'a c a b f b a c a',
		'a c a c c a c a',
		'b b b a a a b b b',
		'e e d b b d e e',
		'c c _ _ _ _ _ c c',
	],
	[
		'c d c b d b c d c',
		'c c e b b e c c',
		'e d e e d e e d e',
		'e c c c a a a e',
		'_ e d d f d d e _',
		'_ c a _ _ a c _',
		'c b c _ _ _ c b c',
		'b b _ _ _ _ b b',
		'_ c _ _ _ _ _ c _',
	],
	[
		'a b c a b c a b c',
		'a b c a b c a b',
		'd d _ _ _ _ _ d d',
		'c b a c b a c b',
		'c b a c b a c b a',
		'e e e d d e e e',
		'_ a b c c c b a _',
		'a _ b c c b _ a',
		'a _ _ _ _ _ _ _ a',
	],
	[
		'_ c _ _ f _ _ c _',
		'b _ _ a a _ _ b',
		'b a _ c _ c _ a b',
		'a _ c _ _ c _ a',
		'a e c _ _ _ c e a',
		'e b a a a a b e',
		'a c _ _ _ _ _ c a',
		'c _ _ _ _ _ _ c',
		'd _ _ _ _ _ _ _ a',
	],
	[
		'_ _ a _ _ a _ _ _',
		'e a d _ d a e _',
		'e a c e e c a e _',
		'b c e a e c b _',
		'b f b c c b f b _',
		'b c e a e c b _',
		'd a c e e c a d _',
		'd a d _ d a d _',
		'_ _ a _ _ a _ _ _',
	],

	[
		'_ b e e e e e b _',
		'b a a a a a a b',
		'b c d d d d d c b',
		'c e b b b b e c',
		'c e a c c c a e c',
		'e a b f f b a e',
		'e a b f f f b a e',
		'_ _ _ _ _ _ _ _',
		'_ _ _ _ _ _ _ _ _',
	],

	[
		'a c a _ _ _ a c a',
		'_ b _ _ _ _ b _',
		'_ _ b _ _ _ b _ _',
		'_ _ f f f f _ _',
		'_ _ d c d c d _ _',
		'_ d c d d c d _',
		'_ _ e e c e e _ _',
		'_ _ _ c c _ _ _',
		'_ _ _ c f c _ _ _',
	],

	[
		'd d d d _ d d d d',
		'f c e f f c e f',
		'a b a b a b a b _',
		'a b a b a b a b',
		'_ a b a b a b a b',
		'e c e c e c e c',
		'a a b b a a b b _',
		'_ _ _ _ _ _ _ _',
		'_ _ _ _ _ _ _ _ _',
	],

	[
		'e d c a e a c d e',
		'c d e e d c a e a',
		'e d c a e a c d e',
		'c d e e d c a e a',
		'e d c a e a c d e',
		'e d c a e a c d e',
		'c d e e d c a e a',
	],

	[
		'_ a a _ _ _ a a _',
		'e c _ _ _ _ d b',
		'_ b e b _ b a c _',
		'_ _ _ a d _ _ _',
		'_ _ _ _ c _ _ _ _',
		'_ _ _ b e _ _ _',
		'_ _ a c _ d a _ _',
		'_ c a b b a c _',
		'_ _ c d _ d c _ _',
	],

	[
		'a a b b a b b a a',
		'_ b b _ _ b b _',
		'_ d d d _ e e e _',
		'_ f f _ _ f f _',
		'_ _ _ f _ f _ _ _',
		'_ _ _ a a _ _ _',
		'_ _ c c c c c _ _',
		'_ _ b c c b _ _',
	],

	[
		'_ b b b _ b b b _',
		'd c c a a c c d',
		'd c a c a c a c d',
		'd e e a a e e d',
		'_ d e a f a e d _',
		'_ _ b c c b _ _',
		'e e e b b b e e e',
		'_ a _ d d _ a _',
		'_ a _ d d d _ a _',
	],
	[
		'c d c e f e c d e',
		'd b b b b b b d',
		'c f f a a a f f e',
		'd d f d e f d d',
		'c _ _ _ _ _ _ _ e',
		'_ _ _ _ _ _ _ _',
		'_ _ _ _ _ _ _ _ _',
		'_ _ _ _ _ _ _ _',
		'_ _ _ _ _ _ _ _ _',
	],
	[
		'_ a _ a _ a _ a _',
		'b c e d d e c b',
		'_ d f b _ b f d _',
		'_ e c _ _ c e _',
		'_ _ a _ e _ a _ _',
		'e c _ d d _ c e',
		'd f b _ e _ b f d',
		'a a _ _ _ _ a a',
		'_ _ _ _ _ _ _ _ _',
	],
	[
		'_ _ a _ e _ d _ b',
		'_ d _ c _ b _ c',
		'_ e _ d _ a _ d _',
		'b _ b _ e _ e _',
		'c _ a _ d _ a _ _',
	],

	[
		'e c c c e d d d e',
		'a c c a b d d b',
		'c e f e f e f e d',
		'd a a c d b b c',
		'_ _ e _ _ _ e _ _',
		'_ _ _ _ _ _ _ _',
		'_ _ _ _ _ _ _ _ _',
		'_ _ _ _ _ _ _ _',
		'_ _ _ _ _ _ _ _ _',
	],

	[
		'b _ c _ _ _ c _ b',
		'b c _ _ _ _ c b',
		'_ b a a a a a b _',
		'e d _ _ _ _ e d',
		'e c d d f e e c d',
		'e d _ _ _ _ e d',
		'_ b e e _ d d b _',
		'b b _ _ _ _ b b',
		'b _ b a a a b _ b',
	],

	[
		'b _ _ _ d _ _ _ b',
		'b _ _ d d _ _ b',
		'_ b _ d a d _ b _',
		'_ b d a a d b _',
		'_ _ c a e a c _ _',
		'_ b d a a d b _',
		'_ b _ d a d _ b _',
		'b _ _ d d _ _ b',
		'b _ _ _ d _ _ _ b',
	],
	[
		'b b b b e b b b b',
		'e _ c _ _ d _ e',
		'_ f c _ e _ d f _',
		'_ c _ _ _ _ d _',
		'_ c _ _ e _ _ d _',
		'c d c d c d c d',
		'a e a e a e a e a',
		'c b c b c b c b',
		'_ _ _ _ _ _ _ _ _',
	],

	[
		'_ _ b b _ b b _ _',
		'_ a f e e f a _',
		'_ a d a f a d a _',
		'_ d d e e d d _',
		'_ _ d e f e d _ _',
		'_ _ a e e a _ _',
		'_ _ _ a b a _ _ _',
		'_ _ _ a a _ _ _',
		'_ _ _ _ e _ _ _ _',
	],

	[
		'd c e b d e a b d',
		'a a a a c c c c',
		'd d c c e e a a _',
		'f _ f _ f _ f _',
		'c c e e a a b b _',
		'f _ f _ f _ f _',
		'_ d d _ b b _ a a',
		'_ f _ _ f _ _ f',
		'_ _ _ _ _ _ _ _ _',
	],

	[
		'_ a _ a _ a _ a _',
		'b c e d d e c b',
		'_ d f b _ b f d _',
		'_ e c _ _ c e _',
		'_ _ a _ e _ a _ _',
		'e c _ d d _ c e',
		'd f b _ e _ b f d',
		'a a _ _ _ _ a a',
		'_ _ _ _ _ _ _ _ _',
	],
	[
		'a _ _ _ d _ _ _ a',
		'a _ _ d d _ _ a',
		'e a f d _ d f a e',
		'f a d _ _ d a f',
		'e e e e f e e e e',
		'f a _ f f _ a f',
		'e e e e f e e e e',
		'd a c _ _ c a d',
		'd _ _ c _ c _ _ d',
	],
	[
		'a _ _ _ b _ _ _ b',
		'b _ _ a a _ _ c',
		'e c a b _ b a c e',
		'_ a _ c c _ a _',
		'_ _ _ d _ d _ _ _',
		'_ _ e _ _ e _ _',
		'_ _ _ _ _ _ _ _ _',
		'_ _ _ _ _ _ _ _',
		'_ _ _ _ _ _ _ _ _',
	],
	[
		'b d d d c c c c a',
		'_ b d d d c a _',
		'_ _ _ b e a e _ _',
		'_ _ _ a b _ _ _',
		'c e a c e c b e c',
		'a _ _ _ _ _ _ b',
		'_ _ _ _ _ _ _ _ _',
		'_ _ _ _ _ _ _ _',
		'_ _ _ _ _ _ _ _ _',
	],
	[
		'c c _ _ a _ _ c c',
		'_ b _ a a _ b _',
		'd f b f f f b f d',
		'_ b _ e e _ b _',
		'_ b _ d a d _ b _',
		'e _ _ b b _ _ d',
		'd e d _ f _ e d e',
		'_ e c b b c d _',
		'_ _ _ _ _ _ _ _ _',
	],
	[
		'b b b b b b b b b',
		'c f c f c f c c',
		'e e f e f e f e e',
		'f _ c c c c _ f',
		'f f c _ c _ c f f',
		'_ e _ e e _ e _',
		'_ a _ a f a _ a _',
		'd _ d f f d _ d',
		'b _ b _ f _ b _ b',
	],

	[
		'a e e a b c e e c',
		'd c d _ _ d c d',
		'_ a b _ _ _ b a _',
		'e c d _ _ d c e',
		'd b b a e a b b d',
	],

	['e d c b a b c d e', 'c b _ c c _ b c', 'a b c d e d c b a'],

	[
		'e d c a e a c d e',
		'c d e e d c a e a',
		'e _ _ _ _ _ _ _ e',
		'c d e e d c a e a',
		'e _ _ _ _ _ _ _ e',
		'c d e e d c a e a',
		'e _ _ _ _ _ _ _ e',
		'c d e e d c a e a',
		'e d c a e a c d e',
	],
	[
		'e d c a e a c d e',
		'e _ _ _ d _ _ _ a',
		'e _ _ _ c _ _ _ c',
		'e _ _ _ b _ _ _ b',
		'e _ _ _ _ _ _ _ c',
		'e _ _ _ _ _ _ _ a',
		'e _ _ _ _ _ _ _ e',
		'e d c a e a c d e',
	],
	[
		'e d c a e a c d e',
		'_ _ _ b b _ _ _',
		'e d c a e a c d e',
		'_ _ _ a d _ _ _ _',
		'e d c a e a c d e',
		'_ _ _ b c _ _ _',
		'e d c a e a c d e',
		'_ _ _ e a _ _ _ _',
		'e d c a e a c d e',
	],

	['e d c a e a c d e', '_ b _ c _ c _ d e', '_ a _ e _ d _ a e', '_ c _ a _ e _ d e'],

	[
		'_ _ _ a b d _ _ _',
		'_ a c a d a c _',
		'_ d _ _ e _ _ d _',
		'a _ _ a a _ _ _ a',
		'b _ b _ c _ b _ b',
		'_ _ _ a a _ _ _ _',
		'_ c _ _ e _ _ _ _',
		'_ e _ c c _ e _ _',
		'_ _ c b a b c _ _',
	],

	['_ a b d _ b d e _', 'b _ c a a c _ a', 'c _ a _ c _ d _ c'],

	[
		'_ e _ c _ e _ a _',
		'a _ b _ c _ d _',
		'd _ c _ b _ a _ _',
		'_ a _ e _ c _ _',
		'_ d _ c _ b _ _ _',
	],
	[
		'e c e _ b _ d c d',
		'b _ d a a e _ b',
		'_ d c e _ c a e _',
		'_ e b c e b d _',
		'_ e _ a _ a _ d _',
		'_ c b _ _ b c _',
	],
	[
		'b d e a c d a b d',
		'e _ d e a b _ a',
		'a _ _ a c e _ _ e',
		'b c b _ _ d a d',
		'_ d d _ _ _ b b _',
		'_ c _ _ _ _ a _',
	],
	[
		'a e d e c a b a e',
		'b c _ d b _ c d',
		'_ a _ _ c _ _ e _',
		'_ b d e a b d _',
		'_ _ a b c d e _ _',
		'_ d _ _ _ _ b _',
		'_ c _ _ _ _ _ c _',
		'_ e _ _ _ _ e _',
	],

	[
		'd d _ _ e _ _ c c',
		'a a _ e e _ b b',
		'b b b e _ e a a a',
		'a d b e e a d c',
		'c b d c b c d a b',
		'd a _ d d _ c d',
		'b c c d a d b b a',
	],

	[
		'a e a _ d _ b d b',
		'c a _ d a _ b a',
		'c e c _ a _ a d a',
		'a c _ c b _ a b',
		'a e a _ c _ b d b',
		'c a _ a b _ b a',
		'c e c _ b _ a d a',
		'a c _ e e _ a b',
	],

	[
		'a a a b b b c c c',
		'd d e d d e d d',
		'_ a e e a e e a _',
		'_ c c e e c c _',
		'_ _ b d e d b _ _',
		'_ _ b d d b _ _',
		'_ _ _ c c c _ _ _',
		'_ _ _ a a _ _ _',
		'_ _ _ _ a _ _ _ _',
	],

	[
		'd _ a _ _ _ e _ b',
		'd _ a _ _ e _ b',
		'_ c _ a _ e _ c _',
		'_ c _ a e _ c _',
		'b b b _ f _ d d d',
		'_ _ b _ _ d _ _',
		'_ _ _ e _ e _ _',
		'_ _ _ e e _ _ _',
		'c c c c f a a a a',
	],

	[
		'b c d _ _ _ a d a',
		'b c d _ _ a d a',
		'_ a e e e e e b _',
		'_ a c c c c b _',
		'_ b e e e e e a _',
		'b d a _ _ d c a',
		'a d a _ _ _ d c b',
		'a d _ _ _ _ c b',
		'_ _ _ _ _ _ _ _ _',
	],

	[
		'e e c a e c d e e',
		'_ c e a c e d _',
		'_ _ c a _ c d _ _',
		'_ d d _ _ a a _',
		'_ b e b _ b e b _',
		'_ b b _ _ b b _',
		'_ _ a c _ d c _ _',
		'_ a e c d e c _',
		'_ _ a c _ d c _ _',
	],

	[
		'e e a a e c c e e',
		'e a e a c e c e',
		'_ e a a _ c c e _',
		'_ d d _ _ a a _',
		'_ d e d _ a e a _',
		'_ d d _ _ a a _',
		'_ _ c c _ d d _ _',
		'_ c e c d e d _',
		'_ _ c c _ d d _ _',
	],

	[
		'd d b e d b e d d',
		'_ b d e b d e _',
		'_ _ b e _ b e _ _',
		'd c _ a a _ d c',
		'd b c a e a d a c',
		'd c _ a a _ d c',
		'_ _ b e _ b e _ _',
		'_ b d e b d e _',
		'_ _ b e _ b e _ _',
	],

	[
		'a a e b b b e a a',
		'_ _ d e e d _ _ _',
		'_ _ d d a d d _ _',
		'_ b d a a d b _ _',
		'_ b e a a a e b _',
		'_ _ c c c c _ _ _',
		'_ _ _ c c c _ _ _',
		'_ _ _ e e _ _ _ _',
		'_ _ _ _ d _ _ _ _',
		'_ _ _ _ _ _ _ _ _',
	],

	[
		'd b b _ _ _ b b d',
		'_ _ a d d a _ _',
		'c c b e e e b c c',
		'_ b _ e e _ b _',
		'_ a _ _ e _ _ a _',
		'b e d b b d e b',
		'_ b a b b b a b _',
		'_ c c _ _ c c _',
		'_ _ _ c _ c _ _ _',
		'_ _ _ _ _ _ _ _',
	],
	[
		'_ b d a c a b d _',
		'c _ _ _ _ _ _ c',
		'_ b b e c e d d _',
		'c _ _ _ _ _ _ c',
		'_ b b e c e d d _',
		'c _ _ _ _ _ _ c',
		'_ b d a c a b d _',
		'_ _ _ _ _ _ _ _',
		'_ _ _ _ _ _ _ _ _',
		'_ _ _ _ _ _ _ _',
	],
	[
		'_ c b b c b b c _',
		'_ c d a a e c _',
		'_ _ b d a e b _ _',
		'_ _ b d e b _ _',
		'_ _ _ a b a _ _ _',
		'_ _ c e d c _ _',
		'_ _ c e _ d c _ _',
		'_ b e _ _ d b _',
		'_ b c c b c c b _',
		'_ _ _ _ _ _ _ _',
	],

	[
		'd d b e d b e d d',
		'_ b d e b d e _',
		'_ _ b e _ b e _ _',
		'c c _ a a _ d d',
		'c b c a e a d a d',
		'c c _ a a _ d d',
		'_ _ b e _ b e _ _',
		'_ b d e b d e _',
		'_ _ b e _ b e _ _',
	],

	[
		'b _ _ c _ c _ _ b',
		'b _ c a a c _ b',
		'_ a c _ a _ c a _',
		'_ d _ _ _ _ d _',
		'_ a b d f d b a _',
		'a _ b c c b _ a',
		'_ _ d d e a a _ _',
		'e d _ c c _ a e',
		'e _ _ _ e _ _ _ e',
	],
]

var bubbles_maps_regular = [
	[
		'a e e a b c e e c',
		'd c d _ _ d c d',
		'_ a b _ _ _ b a _',
		'e c d _ _ d c e',
		'd b b a e a b b d',
	],

	['e d c b a b c d e', 'c b _ c c _ b c', 'a b c d e d c b a'],

	/*
	IC DOES NOT LIKE THIS ONE XD
	[
			'e d c a e a c d e',
			'_ _ _ b b _ _ _',
			'_ _ _ a d _ _ _ _',
			'_ _ _ b c _ _ _',
			'_ _ _ e a _ _ _ _',
			'_ _ _ b c _ _ _',
			'_ _ _ d d _ _ _ _',
			'_ _ _ e e _ _ _',
		],
*/
	['_ a b d _ b d e _', 'b _ c a a c _ a', 'c _ a _ c _ d _ c'],

	[
		'_ e _ c _ e _ a _',
		'a _ b _ c _ d _',
		'd _ c _ b _ a _ _',
		'_ a _ e _ c _ _',
		'_ d _ c _ b _ _ _',
	],

	[
		'e c e _ b _ d c d',
		'b _ d a a e _ b',
		'_ d c e _ c a e _',
		'_ e b c e b d _',
		'_ e _ a _ a _ d _',
		'_ c b _ _ b c _',
	],

	[
		'b d e a c d a b d',
		'e _ d e a b _ a',
		'a _ _ a c e _ _ e',
		'b c b _ _ d a d',
		'_ d d _ _ _ b b _',
		'_ c _ _ _ _ a _',
	],

	[
		'a e d e c a b a e',
		'b c _ d b _ c d',
		'_ a _ _ c _ _ e _',
		'_ b d e a b d _',
		'_ _ a b c d e _ _',
		'_ d _ _ _ _ b _',
		'_ c _ _ _ _ _ c _',
		'_ e _ _ _ _ e _',
	],
]

function GameBubblesMap() {
	function user_maps() {
		if (window.room.round.id % 4 === 0) {
			return GameBubblesMapGenerator()
		} else {
			var seed = window.room && window.room.id ? u.hash_code(window.room.id) : Date.now()

			function random() {
				var x = Math.sin(seed) * 10000
				return x - Math.floor(x)
			}
			bubbles_current_maps = u.shuffle(JSON.parse(JSON.stringify(bubbles_maps)), random)
			var map = [
				bubbles_current_maps[Math.floor(window.room.round.id % bubbles_current_maps.length)],
			]
			return map
		}
	}
	function regular_maps() {
		var seed = window.room && window.room.id ? u.hash_code(window.room.id) : Date.now()

		function random() {
			var x = Math.sin(seed) * 10000
			return x - Math.floor(x)
		}
		bubbles_current_maps_regular = u.shuffle(
			JSON.parse(JSON.stringify(bubbles_maps_regular)),
			random,
		)
		var map = [
			bubbles_current_maps_regular[
				Math.floor(window.room.round.id % bubbles_current_maps_regular.length)
			],
		]
		return map
	}
	return window.room.game == 'bubblesni' ? regular_maps() : user_maps()
}
