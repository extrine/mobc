function emit(o, f) {
	if (f) ios.emit('a', o, f)
	else ios.emit('a', o)
}

var ef = ''
function emitd(o, f) {
	var k = JSON.stringify(o)
	if (k != ef) {
		ef = k
		emit(o, f)
	}
}
