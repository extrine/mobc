'use strict'

function u() {
	this.update_now = this.update_now.bind(this)

	setInterval(this.update_now, 500).unref()
}

u.prototype.update_now = function() {
	this.now = Date.now()
}
u.prototype.now = Date.now()

u.prototype.value = function(s, length) {
	return String(s || '')
		.replace(this.valueLineSingle, ' ')
		.substr(0, length || 100)
		.trim()
}

u.prototype.valueMultiline = function(s, length) {
	return String(s || '')
		.replace(this.valueMultilineRegExp, '\n')
		.replace(this.valueMultilineMultipleRegExp, '\n\n')
		.replace(this.valueMultilineCtrl, ' ')
		.replace(this.valueMultilineChars, ' ')
		.substr(0, length || 1000)
}

u.prototype.valueBool = function(s) {
	return s !== '0' && s !== 'false' && s !== 0 && s !== false ? true : false
}

u.prototype.valueInt = function(s, min, max, def) {
	s = Math.round(+s)
	if (!isNaN(s) && s >= min && s <= max) return s
	else return def
}

u.prototype.escapeRegExp = function(s) {
	return s.replace(this.escapeRegExpRegExp, '\\$&')
}

u.prototype.isFloat = function(n) {
	return n === Number(n) && n % 1 !== 0
}

u.prototype.date = function(time) {
	var date
	if (time) date = new Date(time)
	else date = new Date()

	return (
		date.getFullYear() +
		'.' +
		(date.getMonth() < 9 ? '0' : '') +
		(date.getMonth() + 1) +
		'.' +
		(date.getDate() < 10 ? '0' : '') +
		date.getDate() +
		' ' +
		(date.getHours() < 10 ? '0' : '') +
		date.getHours() +
		':' +
		(date.getMinutes() < 10 ? '0' : '') +
		date.getMinutes() +
		':' +
		(date.getSeconds() < 10 ? '0' : '') +
		date.getSeconds()
	)
}

u.prototype.backup_date = function() {
	var date = new Date()
	return (
		date.getFullYear() +
		'.' +
		(date.getMonth() < 9 ? '0' : '') +
		(date.getMonth() + 1) +
		'.' +
		(date.getDate() < 10 ? '0' : '') +
		date.getDate()
	)
}

u.prototype.time = function() {
	var date = new Date()
	return (
		(date.getHours() < 10 ? '0' : '') +
		date.getHours() +
		':' +
		(date.getMinutes() < 10 ? '0' : '') +
		date.getMinutes() +
		':' +
		(date.getSeconds() < 10 ? '0' : '') +
		date.getSeconds()
	)
}

u.prototype.minute = function() {
	var date = new Date()
	return date.getMinutes()
}

u.prototype.today = function(time) {
	var today = new Date(time || Date.now())
	return today.getDate()
}

u.prototype.hour = function() {
	var date = new Date()
	return (date.getHours() < 10 ? '0' : '') + date.getHours()
}

u.prototype.isIPPublic = function(i) {
	switch (i) {
		case undefined:
		case null:
		case false:
		case 0:
		case '':
		case '::1':
		case '::ffff:':
		case 'undefined':
		case '127.0.0.1': {
			return false
		}

		default: {
			if (String(i).indexOf(':') !== -1) return String(i).replace(this.isIPPublicRegExp, '')
			i = String(i)
				.replace(this.isIPPublicRegExp, '')
				.split('.')
			if (i.length == 4) {
				if (
					i[0] === '10' ||
					i[0] === '127' ||
					i[0] + '.' + i[1] === '192.168' ||
					i[0] + '.' + i[1] === '169.254'
				)
					return false
				if (i[0] === '172' && (i[1] >= 16 && i[1] <= 31)) return false
			}

			i = i.join('.')
			if (i.indexOf('.') === -1 && i.indexOf(':') === -1) return false
			else return i
		}
	}
}

u.prototype.randomNumber = function(bottom, top) {
	return Math.floor(Math.random() * (1 + top - bottom)) + bottom
}

u.prototype.removeValueFromArray = function(a, v) {
	var i = a.indexOf(v)
	if (i !== -1) a.splice(i, 1)
}

u.prototype.colorGenerate = function(color) {
	if (!color)
		color = [this.randomNumber(45, 155), this.randomNumber(45, 155), this.randomNumber(45, 155)] // blend
	var red = this.randomNumber(0, 255)
	var green = this.randomNumber(0, 255)
	var blue = this.randomNumber(0, 255)

	if (color) {
		red = (red + color[0]) >> 1
		green = (green + color[1]) >> 1
		blue = (blue + color[2]) >> 1
	}

	return '#' + this.color2Hex(red) + '' + this.color2Hex(green) + '' + this.color2Hex(blue)
}

u.prototype.djb2 = function(str) {
	var hash = 5381
	for (var i = 0; i < str.length; i++) {
		hash = (hash << 5) + hash + str.charCodeAt(i) /* hash * 33 + c */
	}

	return hash
}

u.prototype.shuffle = function(a) {
	var i = a.length,
		t,
		ri

	while (0 !== i) {
		ri = Math.floor(Math.random() * i)
		i -= 1

		t = a[i]
		a[i] = a[ri]
		a[ri] = t
	}

	return a
}

u.prototype.colorGenerateFromString = function(str) {
	var hash = this.djb2(str)
	var r = (hash & 0xff0000) >> 16
	var g = (hash & 0x00ff00) >> 8
	var b = hash & 0x0000ff
	return (
		'#' +
		('0' + r.toString(16)).substr(-2) +
		('0' + g.toString(16)).substr(-2) +
		('0' + b.toString(16)).substr(-2)
	)
}

u.prototype.color2Hex = function(n) {
	n = parseInt(n, 10)
	if (isNaN(n)) return '00'
	n = Math.max(0, Math.min(n, 255))
	return '0123456789ABCDEF'.charAt((n - (n % 16)) / 16) + '0123456789ABCDEF'.charAt(n % 16)
}

u.prototype.maybe = function(percent) {
	return Math.random() <= percent / 100 ? true : false
}

u.prototype.arrayUnique = function(b) {
	var a = []
	for (var i = 0, l = b.length; i < l; i++) {
		if (a.indexOf(b[i]) === -1) a.push(b[i])
	}

	return a
}
u.prototype.array_keep_last = function(a, number) {
	a.splice(0, a.length - number)
	return a
}
u.prototype.array_keep_first = function(a, number) {
	a.splice(number)
	return a
}
u.prototype.isValidColor = function(s) {
	s = String(s || '')
	this.isValidColorRegExp1.lastIndex = 0
	this.isValidColorRegExp2.lastIndex = 0
	return s !== '' && (this.isValidColorRegExp1.test(s) || this.isValidColorRegExp2.test(s))
}

/* broken */
u.prototype.hash_broken = function(s) {
	return u.md5_broken(u.sha_broken(u.crypto_password_broken + '-' + s))
}

u.prototype.sha_broken = function(s) {
	return this.crypto
		.createHmac('sha512', this.crypto_password_plain)
		.update(s)
		.digest('hex')
}

u.prototype.md5_broken = function(s) {
	return this.crypto
		.createHmac('md5', this.crypto_password_plain)
		.update(s)
		.digest('hex')
}

/* good */
u.prototype.hash = function(s) {
	return u.md5(u.sha(u.crypto_password + '-' + s))
}

u.prototype.sha = function(s) {
	return this.crypto
		.createHash('sha512')
		.update(s, 'binary')
		.digest('hex')
}
u.prototype.sha_file = function(file, cb) {
	this.fs
		.createReadStream(file)
		.pipe(this.crypto.createHash('sha1').setEncoding('hex'))
		.on('finish', function() {
			cb(this.read())
		})
}
u.prototype.md5 = function(s) {
	return this.crypto
		.createHash('md5')
		.update(s, 'binary')
		.digest('hex')
}

u.prototype.id = function() {
	return Math.random()
		.toString(36)
		.substr(2, 10)
}

u.prototype.escape = function(s) {
	return String(s || '').replace(/[&<>"'\/]/g, function(c) {
		return u.entityMap[c]
	})
}

u.prototype.decodeURI = function(s) {
	try {
		return decodeURIComponent(s)
	} catch (e) {
		return s
	}
}

u.prototype.run_functions_delayed = function(fns, on_done) {
	var fn = fns.shift()
	if (fn) {
		setTimeout(function() {
			fn()
			u.run_functions_delayed(fns, on_done)
		}, 10)
	} else if (on_done) {
		on_done()
	}
}

u = new u()
u.fs = require('fs')
u.local = __dirname.indexOf('/w/') === -1
u.project = u.local ? __dirname + '/../' : __dirname + '/../../'
u.crypto = require('crypto')
u.crypto_password_plain =
	'4pih53 ´jbo4´jbtbt40jbt4 wef wef ewfe n 56n 65 n56 nwf34 43g 0jbteóbtewójbeój b'
u.crypto_password = u.md5(u.sha(u.crypto_password_plain))
u.crypto_password_broken = u.md5_broken(u.sha_broken(u.crypto_password_plain))

u.util = require('util')

u.valueCtrl = /[\cA\cB\cC\cD\cE\cF\cG\cH\cI\cJ\cK\cL\cM\cN\cO\cP\cQ\cR\cS\cT\cU\cV\cW\cX\cY\cZ]/gim
u.valueChars = /[\b\f\n\r\t\v\0]/gim
u.valueCharsMultiline = /\s+/g

// u.valueC + u.valueChars + u.valueCharsMultiline
u.valueLineSingle = /[\cA\cB\cC\cD\cE\cF\cG\cH\cI\cJ\cK\cL\cM\cN\cO\cP\cQ\cR\cS\cT\cU\cV\cW\cX\cY\cZ\b\f\n\r\t\v\0\s]+/gim

u.valueMultilineRegExp = /[\t ]*\n/g
u.valueMultilineMultipleRegExp = /\n\n+/g
u.isIPPublicRegExp = /^\:\:ffff\:/
u.valueMultilineCtrl = /[\cA\cB\cC\cD\cE\cF\cG\cH\cI\cK\cL\cM\cN\cO\cP\cQ\cR\cS\cT\cU\cV\cW\cX\cY\cZ]/gim
u.valueMultilineChars = /[\b\f\r\t\v\0]/gim
u.escapeRegExpRegExp = /[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g

u.isValidColorRegExp1 = /^rgba?\((\d+),\s*(\d+),\s*(\d+)(?:,\s*(\d*(?:\.\d+)?))?\)$/i
u.isValidColorRegExp2 = /^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$/i
u.entityMap = {
	'&': '&amp;',
	'<': '&lt;',
	'>': '&gt;',
	'"': '&quot;',
	"'": '&#39;',
	'/': '&#x2F;',
}

module.exports = {
	u: u,
}
