var version = 77 // if this version does not match client the client gonna keep refreshing thats index.js and server.js till both versions are the same

var has_flash = false
;(function() {
	try {
		has_flash = Boolean(new ActiveXObject('ShockwaveFlash.ShockwaveFlash'))
	} catch (e) {
		has_flash = 'undefined' != typeof navigator.mimeTypes['application/x-shockwave-flash']
	}
})()

var ios

// http to https
if (!local && location.href.indexOf('https') === -1) location.replace('https://' + location.host)

// remove any non sense query string
if (!local && location.search && location.search != '?booga') {
	location.replace('https://omgmobc.com/index.html?booga#')
}

// confirmation of accounts
if (location.hash && location.hash.indexOf('c/') != -1) {
	if (
		/firefox/i.test(window.navigator.userAgent) &&
		+navigator.userAgent.replace(/^.*firefox\//i, '').replace(/\..*$/i, '') < 79
	) {
	} else {
		var cc = location.hash.split('c/')[1]
	}
}

var body = {}
$(function() {
	body = $('body')
})
$(document).ready(function() {
	body = $('body')
})
$(document).on('load', function() {
	body = $('body')
})
requestAnimationFrame(function() {
	body = $('body')
})
document.addEventListener('DOMContentLoaded', function(event) {
	body = $('body')
})

var isMobile = /mobile|iphone|ipod|ios|ipad|android/i.test(window.navigator.userAgent)
// edge does not have window.screen.orientation
if (!window.screen.orientation) {
	window.screen.orientation = { type: 'landscape-primary' }
}
var mobileOrientation = window.screen.orientation.type.split('-')[0]
window.mobileOrientationCallbacks = []
var lastWidth = window.screen.width

window.addEventListener('orientationchange', () => {
	if (lastWidth === window.screen.width) return
	lastWidth = window.screen.width
	mobileOrientation = window.screen.orientation.type.split('-')[0]
	body = $('body')
	body.attr('data-orientation', mobileOrientation)
	for (var id in window.mobileOrientationCallbacks) {
		window.mobileOrientationCallbacks[id](mobileOrientation)
	}
})
window.onUserLogin = []

var storage = new Storage()

var u = new Utils()

var socket = new Socket()
var asset = {}

window.onhashchange = function() {}

function stopEvent(e) {
	e.stopPropagation()
	e.preventDefault()
}
function stopPropagation(e) {
	e.stopPropagation()
}

const GAME_STATUS_PLAYING = 1
const GAME_STATUS_WAITING = 2
const GAME_STATUS_SPECTATING = 3

var fq = 0

function sha1(s) {
	return Rusha.createHash()
		.update(s)
		.digest('hex')
}
$(function() {
	if (!local) u.soundIfMutedSilence('lowding')

	body = $('body')
	body.attr('data-is-mobile', isMobile)
	body.attr('data-orientation', mobileOrientation)
	$(window).resize(function() {
		isMobile = /mobile|iphone|ipod|ios|ipad|android/i.test(window.navigator.userAgent)
		body.attr('data-is-mobile', isMobile)
	})
	if (local) body.attr('data-local', true)
	$('.header h1 a').text('MOBC')
	//	$('title').text('OMGMOBC - Social Games')
	$('.draw-and-guess').attr('target', '_blank')

	socket.load()

	if (cc) {
		emit({
			id: 'confirm',
			c: cc,
		})
		cc = false
		location.replace('#')
	}

	window.onhashchange = function() {
		var hash = u.getHash()
		if (hash.indexOf('u/') === 0) {
			openProfile(hash.replace(/^u\//, ''))
		} else if (hash.indexOf('m/') === 0 && (!window.room || hash != 'm/' + window.room.id)) {
			pageUnmount()

			emit({
				id: 'room join',
				room_id: hash.replace(/^m\//, ''),
			})
		} else if (hash.indexOf('m/') === 0 && window.room && hash === 'm/' + window.room.id) {
			pageUnmount()
		} else if (hash.indexOf('p/') === 0) {
			openPage(hash.replace(/^p\//, ''))
		} else {
			pageUnmount()

			if (window.room !== false) {
				emit({
					id: 'room join',
					room_id: '',
				})
			}
		}
	}
	var hash = u.getHash()
	if (hash.indexOf('m/') !== 0) window.onhashchange()
})

function the_room() {
	return window.room
}

function nothing() {}
u.getAssets(`

__ASSETS_POOL__

`)
