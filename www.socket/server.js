'use strict'

const exit_handler = require('../compile/server-exit-handler.js')

var version = 77 // if this version does not match client the client gonna keep refreshing thats index.js and server.js till both versions are the same
var TIME_TO_BLOCK = 0.5

process.env.NODE_ENV = 'production'
var util = require('util')

var u = require('./utils.js').u
var project = u.project
var _spawn = require('child_process').spawn

var fs = require('fs')
var os = require('os')
var noop = function() {}

var nodemailer = require('nodemailer')
const pako = require('pako')

var fetch = require('node-fetch')

function compress(s) {
	return pako.deflate(JSON.stringify(s), { level: 3, to: 'string' })
}
function uncompress(s) {
	return JSON.parse(pako.inflate(s, { to: 'string' }))
}

const Fast = (function() {
	let fastProto = null

	// Creates an object with permanently fast properties in V8. See Toon Verwaest's
	// post https://medium.com/@tverwaes/setting-up-prototypes-in-v8-ec9c9491dfe2#5f62
	// for more details. Use %HasFastProperties(object) and the Node.js flag
	// --allow-natives-syntax to check whether an object has fast properties.
	function FastObject(o) {
		// A prototype object will have "fast properties" enabled once it is checked
		// against the inline property cache of a function, e.g. fastProto.property:
		// https://github.com/v8/v8/blob/6.0.122/test/mjsunit/fast-prototype.js#L48-L63
		if (fastProto !== null && typeof fastProto.property) {
			const result = fastProto
			fastProto = FastObject.prototype = null
			return result
		}
		fastProto = FastObject.prototype = o == null ? Object.create(null) : o
		return new FastObject()
	}

	// Initialize the inline property cache of FastObject
	FastObject()

	return function toFastproperties(o) {
		return FastObject(o)
	}
})()

const wall = require('./wall.js')
const youtube = require('./youtube.js')

function mem() {
	var m = process.memoryUsage()
	return (
		u.date() +
		' Online ' +
		(io ? Object.keys(io.sockets.sockets).length : '0') +
		' Rooms ' +
		(rooms ? Object.keys(rooms).length : '0') +
		' | CPU ' +
		(os.loadavg()[0] * 100).toFixed(2) +
		'% Mem Site ' +
		(m.rss / 1024 / 1024).toFixed(2) +
		' Mem Server ' +
		((os.totalmem() - os.freemem()) / 1024 / 1024).toFixed(2) +
		' Mem Free ' +
		(os.freemem() / 1024 / 1024).toFixed(2)
	)
}

setImmediate(function() {
	require('blocked-at')(
		function(ms, stack) {
			stack = Stack(stack.join('<br>\n'))
			if (stack && stack.indexOf('run_functions_delayed') == -1) {
				ms = (ms | 0) / 1000
				if (ms > TIME_TO_BLOCK) {
					LOG('• Server Blocked For ' + ms.toFixed(2) + ' seconds on -- ' + stack)
				}
			}
		},
		{
			threshold: 200,
			trimFalsePositives: false,
		},
	)
})

function L(socket, s) {
	if (s !== undefined) {
		console.log(socket.B, socket.B2, socket.IP, socket.u.username, socket.ID, socket.IDU, s)
	} else if (typeof socket == 'string') {
		console.log(socket)
	} else {
		console.log(
			u.util.inspect(socket, {
				depth: 4,
			}),
		)
	}
}

function LM(socket, m) {
	if (socket) {
		LOG(
			'<span title="' +
				u.escape(socket.B2) +
				'">' +
				u.escape(socket.B) +
				'</span> | ' +
				Socket.mod_update_link_ip(socket.IP) +
				' | ' +
				Socket.mod_update_link_id(socket.ID) +
				' | ' +
				Socket.mod_update_link_id(socket.IDU) +
				' | ' +
				Socket.mod_update_link_user(socket.u.username) +
				(socket.ROOM && socket.ROOM != '' ? ' | ' + Socket.mod_update_link_room(socket.ROOM) : '') +
				'<br>• ' +
				m,
		)
	} else {
		LOG(mem() + '<br>• ' + m)
	}
}

function Stack(e) {
	e = e
		.replace(/\\/g, '/')
		.replace(/\/+/g, '/')
		.split('\n')
	var r = ''
	for (var id in e) {
		if (e[id].indexOf('www.socket/') !== -1 && e[id].indexOf('node_modules') === -1) {
			r += '-- ' + e[id].replace(/\([^()]+socket\//, '(') + '\n'
		}
	}
	if (r != '') {
		return '\n-- ' + e[0].trim() + '\n' + r
	}
	return r
}

function T(e) {
	var s = Stack(e.stack)

	LOG(
		'ERROR:<br>• ' +
			u
				.escape(s.trim())
				.trim()
				.replace(/\n/g, '\n<br>'),
	)
	console.log(s)
}
process.on('uncaughtException', T)

const GAME_STATUS_PLAYING = 1
const GAME_STATUS_WAITING = 2
const GAME_STATUS_SPECTATING = 3

var _matchNames = [
	'#name# Boiler Room xD',
	'#name# Boutique :)',
	'#name# does the thingy :P',
	'#name# drank your juice >D',
	'#name# drank your milkshake >D',
	'#name# eats babies. Silver included. .me.',
	"#name# got it at the gettin' place",
	'#name# House of Pain .boo.',
	'#name# is a major drawesomer ',
	"#name# is steady killin' fools",
	'#name# is the new black',
	'#name# is the new green. ET is that you?',
	'#name# is the new red',
	'#name# Major Pwnage',
	'Good news everyone ! ',
	'Good news everyone .. ! ',
	'Bite my shiny metal ... ',
	'#name# milkshake brings all the boys to the yard.',
	'#name# milkshake brings all the girls to the yard.',
	'#name# much?',
	'#name# on top. You on the bottom.',
	"#name# pitchin', you catchin '",
	'#name# Pleasure Palace',
	"#name#'s Rule",
	'#name# Washy-washy',
	'#name#. Kid tested, mother approved.',
	'#name#. Mothers does not approve.',
	'#name#. Quacking loud.',
	'#name#? Really?',
	'#name#izzle, my nizzle',
	"#name#'s party room. its lit!",
	'Aliens ate my flowers',
	'All the pizzas belong to her',
	'All your #name# are belong to us',
	'Did you know #name# had a blog?',
	'Do you have love for #name#??',
	'Do you mooo?',
	'Doggy is a major super hero',
	'YOU do not talk about #name# Club… ',
	'For a good time, call #name#',
	"Girl you know it's true, #name# loves you.",
	'Good times with #name#',
	'Have you ever heard of #name#?',
	'Holy cow we here',
	'I can has #name#?',
	"You can't has #name#!",
	'I read books',
	'I dont read books',
	'In the octagon with #name#',
	'Is #name# awesome (Y/y)',
	'Team Vish in this room only',
	'Team Pa Clubhouse',
	'Madness?… THIS… IS… #name#!!!',
	'Milanesa con ketchup',
	'What the cow is going on',
	'Moar moar games',
	'Corn conr cnr cnor crnor',
	'Simple duck in a complex world',
	'Moar moar arrows',
	'What the bacon is going on',
	'Not enough cheese',
	'Quacking',
	'Duckeland',
	'Startup founder, #name#',
	'Such madness… ',
	'Stay classy, #name#.',
	'Stay sassy, #name#.',
	"It wasn't me!… I swear",
	'This is your brain on #name#',
	'Watch out ET is coming',
	'Whose house? #name# house!',
	'#name#, Bankruptcy expert',
	'Whats dangydoots!?',
	'I wanna dangydoot',
	'Whos weba!?',
	'Burritos',
	'Wheres my golden medals!?',
	'I drive a fitito',
	'PONIES ARE THE BEST',
	'QUACK QUACK QUACK',
	'Enchiladas!',
	'Not enough coins',
	'To lazy to write a title',
	'Me gusta la vaca',
	'goober dudes win',
	'I DID IT! WHAT U GONNA DO ABOUT IT?',
	'Tiny but lovely',
	'I like this!',
	'Friendly game',
	'Moar moar titles',
	'Default titles rocks!',
	'I CHALLENGE YOU!!',
	'all you need is  ツ',
	'all you need is シツ',
	'#name# mayor dangydooter',
	'Peek-a-boo',
	'Bae Bae Baes',
	'Writing titles is so boring :P',
	'Dangydoots dangydoots dangydoots',
	'Boo boo boos',
	'mad as cat after shower?',
	'HOW MANY MORE!?',
	'Science not my thingy, play me here...',
	'#name# ra ra ra',
	'Touching the sky!',
	'I used diskettes..',
	'Lucky or skills..?',
	'Good luck -- #name#',
	'This Is My Happy Place! SHHHHH',
	'Smile... no time for other stuff',
	'noona neomu yeppeo~~~~',
	'The Best People Are In This Room',
	'Booga Booga',
	'wubalubadubdub',
	"Mario & Luigi's Room ",
	'Chilling',
	'Im deaded',
	'Slow as turtle',
	'Boom clap! ',
]
var _poolStartNames = [
	'RACK UM',
	'Balls Being Racked',
	'Racking It',
	'Chalking The Stick',
	'Chalk Up',
	'Turn To Rack',
	'Ur Turn To Rack',
	'Preparing Stuff',
	'Get Set Ready..',
	'Whatever Just Wait..',
	'Good Luck..',
	'Get Ready..',
	'Good Luck you Two!',
	'good lucky poo poop poop pi do',
	'good luck, dont plop!',
]
var _recordNames = [
	'Yay! ',
	'Wow! ',
	'Woooot! ',
	'Moooo! ',
	'Pew Pew You!! ',
	'Fasteeer! ',
	'Madness! ',
	'Unevalieleuve! ',
	'I Want Replay! ',
	'Whoaa! ',
	'Speechlesessss! ',
	'Wohooo! ',
	'Astonishing! ',
	'Unspelleable! ',
	'Super! ',
	'Supra! ',
	'You cook today! ',
	'Dangydoots! ',
	'Boom clap! ',
	'Dilly Dilly! ',
	'Oh my lantern! ',
	'Oh my laundry!! ',
	'The hype is real! ',
]
var _welcomeMessages = [
	'Meow! Welcome to OMGMOBC !',
	'Meow! Welcome to OMGMOBC ! ',
	'Meow! Welcome to MOBC !',
	'Meowwwww! Welcome to OMGMOBC !',
	'Meowwwww! Welcome to OMGMOBC ! ',
	'Meowwwww! Welcome to MOBC !',
	'Welcome to OMGMOBC ! :)',
	'Welcome to OMGMOBC ! :D',
	'Welcome to OMGMOBC ! B)',
	'Welcome to OMGMOBC ! Meow',
	'Welcome to OMGMOBC ! Meowwwww',
	'Welcome to MOBC ! :)',
	'Welcome to MOBC ! :D',
	'Welcome to MOBC ! B)',
	'Welcome to MOBC ! Meow',
	'Welcome to MOBC ! Meowwwww',
]

var _welcomeToMobcMessages = ['username joined']

var wtf = false

var users_online = {}

setInterval(function() {
	if (Socket && Socket.update_online) Socket.update_online()
}, 1000 * 20)

try {
	var users = JSON.parse(fs.readFileSync(project + '/data/users.json', 'utf8'))
} catch (e) {
	console.log(e)
	wtf = true
	var users = {}
}

try {
	var users_banned = JSON.parse(fs.readFileSync(project + '/data/users.banned.json', 'utf8'))
} catch (e) {
	console.log(e)
	wtf = true
	var users_banned = {}
}

if (!users_banned.user_id) users_banned.user_id = 1

if (!users['omg@omgmobc.com']) {
	wtf = true
}

if (!users_banned.ban) users_banned.ban = {}

if (!users_banned.signup) users_banned.signup = {}
if (!users_banned.lobby) users_banned.lobby = {}

if (!users_banned.ranking) users_banned.ranking = {}

if (!users_banned.once_mail) users_banned.once_mail = {}
if (!users_banned.once_likes) users_banned.once_likes = {}

if (!users_banned.mod_logs) users_banned.mod_logs = []
if (!users_banned.lobby_messages) users_banned.lobby_messages = []

var LAST_LOG = ''
function LOG(s) {
	if (s != LAST_LOG) {
		LAST_LOG = s
		users_banned.mod_logs.push('<div>' + s + '</div>\n')
		if (users_banned.mod_logs.length > 200) {
			u.array_keep_last(users_banned.mod_logs, 200)
		}
	}
}

if (!users_banned.white) users_banned.white = {}

if (!users_banned.pus) users_banned.pus = {}

if (!users_banned.pu) users_banned.pu = {}
if (!users_banned.taken_renamed_usernames) users_banned.taken_renamed_usernames = {}

if (!users_banned.tickets) users_banned.tickets = []
if (!users_banned.marketing) users_banned.marketing = {}

if (!users_banned.cant_stop_matches)
	users_banned.cant_stop_matches = {
		troy_warrior: true,
		'165.166.21.126': true,
	}

var mods = {}

var a = [
	'Wade',
	'SuGaR+SpIcE',
	'Kilo',
	'nooby',
	'Daphne',
	'Sophia',
	'dragonfly',
	'FOXYlady',
	//'00:00',
	'francisco.toro',
	'Carina',

	'Lavender',
	'omgmobc.com',
	'Huge Heart',
	'Hrisistar',
	'Tito',
	'Selle',
	'Raeshad',
]

function is_public_mod(u) {
	return 'omgmobc.com' === u || 'Issue Tracker' === u
}

function is_hidden_mod(u) {
	return mods[u] && !is_public_mod(u)
}

a.forEach(function(item) {
	if (item) mods[item] = true
})

a = null

var usernames = {},
	usernames_lower = {}

if (!users_banned.trace) users_banned.trace = {}

function multiple_account_trace(id, idu, ip, username) {
	if (username.indexOf('Lame Guest') !== 0) {
		if (id && id != '') {
			if (!users_banned.trace[id]) {
				users_banned.trace[id] = {}
			}
			users_banned.trace[id][username] = u.now
		}
		if (idu && idu != '') {
			if (!users_banned.trace[idu]) {
				users_banned.trace[idu] = {}
			}
			users_banned.trace[idu][username] = u.now
		}

		if (!users_banned.trace[ip]) {
			users_banned.trace[ip] = {}
		}
		users_banned.trace[ip][username] = u.now
	}
}

var games = [
	'pool',
	'9ball',
	'swapples',
	'loonobum',
	'skypigs',
	'cuacka',
	'dinglepop',
	'bubbles',
	'bubblesni',
	'blockles',
	'blocklesmulti',
	'gemmers',
	'tonk3',
	'test',
	'balloono',
	'balloonoboot',
	'checkers',
	'watchtogether',
	//'poker',
]
var games_only_test = ['test']
var rooms = {}

var lock = {}
if (!users_banned.YTCache) {
	users_banned.YTCache = {}
}
function reset_user(user, keep_password) {
	var id
	delete user.image
	delete user.status
	delete user.plink

	delete user.color
	delete user.ccolor
	delete user.border
	delete user.scolor
	delete user.waitingbg
	delete user.waitingbg2
	delete user.waitingbg3
	delete user.emojihue
	delete user.chathistory
	delete user.profileviews
	delete user.lastseen
	delete user.tags
	delete user.smcolor
	delete user.sidebar
	delete user.wall
	delete user.sky
	delete user.underline
	delete user.cover
	delete user.pool
	delete user.block
	delete user.unread
	delete user.arcade
	user.arcade = {}

	user.arcade.r = 0
	delete user.likes
	delete user.opponents
	delete user.gallery
	delete user.nohd
	delete user.nospectate
	delete user.nogif
	delete user.cblind
	delete user.nocam

	delete user.nty
	delete user.ntyw
	delete user.ntyc
	delete user.ntycl

	delete user.nologin
	delete user.noarcade
	delete user.noopp
	delete user.nofriend
	//delete user.friend
	delete user.wallf
	delete user.wallfo
	delete user.fq
	delete user.fps
	delete user.fswap
	delete user.noinline
	delete user.nocolor
	delete user.private
	delete user.nonotify
	delete user.record
	delete user.recordvideo
	delete user.soapbox

	/*for (var un in usernames) {
		if (usernames[un].followers && usernames[un].followers[user.username])
			delete usernames[un].followers[user.username]
		if (usernames[un].friend && usernames[un].friend[user.username])
			delete usernames[un].friend[user.username]
	}*/

	/*delete user.friend
	delete user.followers*/

	for (id in user.groups) {
		if (users_banned.groups[user.groups[id]]) {
			u.removeValueFromArray(users_banned.groups[user.groups[id]].u, user.username)
			users_banned.groups[user.groups[id]].m.push({
				id: u.now,
				u: 'MOBC',
				m: user.username + ' left the group',
				s: 1,
			})
		}

		if (
			!users_banned.groups[user.groups[id]] ||
			!users_banned.groups[user.groups[id]].u ||
			users_banned.groups[user.groups[id]].u.length === 0
		) {
			delete users_banned.groups[user.groups[id]]
		}
	}

	delete user.groups
	if (!keep_password) delete user.password

	wall.delete_by_username_all_except_mobc({
		username: user.username,
	})
}

users_banned.mail_providers = [
	'@abv.bg',
	'@aim.com',
	'@aol.',
	'@atravelagency.ca',
	'@att.',
	'@bellsouth.',
	'@birminghampr.co.uk',
	'@bk.ru',
	'@bluewin.ch',
	'@bournemouth.com',
	'@btinternet.com',
	'@charter.net',
	'@cleves85.freeserve.co.uk',
	'@comcast.',
	'@cox.net',
	'@drtel.net',
	'@excite.com',
	'@frontier.com',
	'@gmail.',
	'@gmx.',
	'@googlemail.',
	'@hawaii.edu',
	'@hotmail.',
	'@i.softbank.',
	'@icloud.',
	'@india.com',
	'@laposte.net',
	'@libero.it',
	'@live.',
	'@mail.bg',
	'@mail.com',
	'@mail.de',
	'@mail.ru',
	'@mh.lunitidal.de',
	'@msn.',
	'@mynet.com',
	'@o2.pl',
	'@omgmobc.com',
	'@onet.pl',
	'@op.pl',
	'@outlook.',
	'@pobroadband.co.uk',
	'@rediffmail.com',
	'@rocketmail.com',
	'@rogers.com',
	'@sbcglobal.net',
	'@scryptmail.',
	'@spoko.pl ',
	'@verizon.net',
	'@web.de',
	'@windowslive.',
	'@wp.pl',
	'@yahoo.',
	'@yandex.',
	'@ymail.',
]

var transporter = nodemailer.createTransport({
	host: 'smtp.fastmail.com',
	port: 465,
	secure: true,
	auth: {
		user: 'omg@omgmobc.com',
		pass: 'g97n69z8vvv5sbfr',
	},
})

function sendmail(o) {
	transporter.sendMail(
		{
			from: {
				name: 'OMGMOBC',
				address: 'omg@omgmobc.com',
			},
			to: {
				name: o.user,
				address: o.email,
			},
			subject: o.subject,
			text:
				'Hey ' +
				o.user +
				',\n\n' +
				o.body +
				'\n\n\nHappy Playing!\nOMGMOBC: Games with our friends\nhttps://omgmobc.com/index.html\n-- \nOMGMOBC Team\n',
		},
		function(err, info) {
			if (!info) {
				setTimeout(function() {
					transporter.sendMail(
						{
							from: {
								name: 'OMGMOBC',
								address: 'omg@omgmobc.com',
							},
							to: {
								name: o.user,
								address: o.email,
							},
							subject: o.subject,
							text:
								'Hey ' +
								o.user +
								',\n\n' +
								o.body +
								'\n\n\nHappy Playing!\nOMGMOBC: Games with our friends\nhttps://omgmobc.com/index.html\n-- \nOMGMOBC Team\n',
						},
						function(err, info) {
							var msg = u.escape(
								o.subject + ':' + o.user + ':' + o.email + ':' + (err ? err : info.response),
							)
							if (err) {
								//LM(null, 'MAIL failed ' + msg)
							}
						},
					)
				}, 15000)
			} else {
				var msg = u.escape(
					o.subject + ':' + o.user + ':' + o.email + ':' + (err ? err : info.response),
				)
				if (err) {
					//LM(null, 'MAIL failed ' + msg)
				}
			}
		},
	)
}

function is_valid_email(email) {
	for (var i = 0, l = users_banned.mail_providers.length; i < l; i++) {
		if (email.indexOf(users_banned.mail_providers[i]) !== -1) return true
	}

	return false
}

function did_i_block_user(me, user) {
	if (user == 'omgmobc.com') {
		return false
	}
	if (
		usernames[me].block &&
		usernames[me].friend &&
		!usernames[me].block[user] &&
		usernames[me].friend[user]
	) {
		return false
	}
	if (me != user && usernames[me].block) {
		if (usernames[me].block[user]) {
			return true
		}

		var blocked = Object.keys(usernames[me].block)
		if (!blocked.length) {
			return false
		}

		var ids = {}

		var idsu = {}

		var ips = {}

		var id, idx
		for (id in blocked) {
			if (!usernames[blocked[id]]) continue
			if (usernames[blocked[id]].ids) {
				for (idx in usernames[blocked[id]].ids) {
					ids[usernames[blocked[id]].ids[idx]] = true
				}
			}

			if (usernames[blocked[id]].idsu) {
				for (idx in usernames[blocked[id]].idsu) {
					idsu[usernames[blocked[id]].idsu[idx]] = true
				}
			}

			if (usernames[blocked[id]].ips) {
				for (idx in usernames[blocked[id]].ips) {
					ips[usernames[blocked[id]].ips[idx]] = true
				}
			}
		}

		if (usernames[user].ips) {
			for (id in usernames[user].ips) {
				if (ips[usernames[user].ips[id]]) {
					return true
				}
			}
		}

		if (usernames[user].idsu) {
			for (id in usernames[user].idsu) {
				if (idsu[usernames[user].idsu[id]]) {
					return true
				}
			}
		}

		if (usernames[user].ids) {
			for (id in usernames[user].ids) {
				if (ids[usernames[user].ids[id]]) {
					return true
				}
			}
		}
	}

	return false
}

var to_confirm_users = []

function sleep(ms) {
	return new Promise(resolve => setTimeout(resolve, ms))
}

async function delayed_confirm_emails() {
	if (!local) {
		var user = true
		while (user) {
			user = to_confirm_users.pop()

			if (user) {
				if (
					usernames[user.username].confirmed !== true &&
					!usernames[user.username].confirmation_sent
				) {
					usernames[user.username].confirmation_sent = true
					await sleep(60000)

					usernames[user.username].confirmed = u.hash(user.username + '-' + user.email)

					sendmail({
						user: user.username,
						email: user.email,
						subject: 'Confirm Your Account',
						body:
							'Someone or you created an account on OMGMOBC with ID "' +
							user.username +
							'". In order to use the newly created account you must confirm you have access to this email address. \nYou cannot use the account till its confirmed. You may confirm the account by opening the following link https://omgmobc.com/index.html#c/' +
							encodeURIComponent(user.email) +
							'/' +
							usernames[user.username].confirmed,
					})
				}
			}
		}
	}
}

function Socket() {
	this.chat_room_mobc_last_message = ''

	Fast(users)
	Fast(usernames)
	Fast(usernames_lower)
	Fast(users_banned)
	Fast(rooms)

	var ID = 1
	for (var id in users) {
		Fast(users[id])

		if (users[id].username) {
			if (!local) {
				// send the confirmation again when the server starts to people that didnt confirm
				if (
					users[id].confirmed !== true &&
					!users_banned.ban[users[id].username] &&
					!users[id].confirmation_sent &&
					is_valid_email(users[id].email)
				) {
					to_confirm_users.push({
						username: users[id].username,
						email: users[id].email,
					})
				}
				/*
				// I dont remember this
				if (users[id] && users[id].color && !users[id].border) {
					users[id].border = users[id].color
				}*/

				/*
				// fill trace information
				if (!users_banned.trace[users[id].sip]) users_banned.trace[users[id].sip] = {}

				users_banned.trace[users[id].sip][users[id].username] = users[id].login || u.now
				if (users[id].ips) {
					for (var idx in users[id].ips) {
						if (!users_banned.trace[users[id].ips[idx]]) users_banned.trace[users[id].ips[idx]] = {}

						users_banned.trace[users[id].ips[idx]][users[id].username] = users[id].login || u.now
					}
				}

				if (users[id].ids) {
					for (var idx in users[id].ids) {
						if (!users_banned.trace[users[id].ids[idx]]) users_banned.trace[users[id].ids[idx]] = {}

						users_banned.trace[users[id].ids[idx]][users[id].username] = users[id].login || u.now
					}
				}

				if (users[id].idsu) {
					for (var idx in users[id].idsu) {
						if (!users_banned.trace[users[id].idsu[idx]])
							users_banned.trace[users[id].idsu[idx]] = {}

						users_banned.trace[users[id].idsu[idx]][users[id].username] = users[id].login || u.now
					}
				}*/
			}
			// index the usernames and also in lower case
			usernames[users[id].username] = usernames_lower[users[id].username.toLowerCase()] = users[id]
		}
	}

	for (var id in users_banned) {
		Fast(users_banned[id])
	}

	delayed_confirm_emails()

	this.marketing()

	if (!users_banned.youtube_imported) {
		users_banned.youtube_imported = true
		for (var id in users_banned.YTCache) {
			if (id.indexOf('related') != -1) {
				youtube.insert_related({
					related: id.replace('related.', ''),
					result: JSON.stringify(users_banned.YTCache[id]),
					date: u.now,
				})
			} else {
				youtube.insert_search({
					search: id,
					result: JSON.stringify(users_banned.YTCache[id]),
					date: u.now,
				})
			}
		}
	}
}

Socket.prototype.marketing = function() {
	if (!local) {
		// marketing list
		/*if (!users_banned.marketing.sending) {
			users_banned.marketing.sending = {}
			for (var id of Object.keys(users)) {
				var user = users[id]
				if (user && user.email.indexOf('@') !== -1) {
					users_banned.marketing.sending[user.email] = user.username
				}
			}
			for (var email of Object.keys(users_banned.marketing.list)) {
				if (email.indexOf('@') !== -1 && !users_banned.marketing.sending[email]) {
					users_banned.marketing.sending[email] = users_banned.marketing.list[email]
				}
			}
		}*/
		var keys = Object.keys(users_banned.marketing.sending)
		if (keys.length) {
			LM(null, 'about to send ' + keys.length + ' emails')
			if (!users_banned.sent) {
				users_banned.sent = 0
			}
			var sending = false
			sending = setInterval(function() {
				if (!keys.length) {
					clearInterval(sending)
					return
				}
				var email = keys.shift()
				var username = users_banned.marketing.sending[email]
				delete users_banned.marketing.sending[email]

				sendmail({
					user: username,
					email: email,
					subject: 'Almost 4 Years! Last One For Flash On All Major Web Browsers',
					body: `It has been a while since we wrote you! Ha!
Anyway, people are still around, you may want to check it out!

It looks like this is the last year that flash games will run on the browser. We will find a way so dont worry.
However, we have youtube rooms which will survive after the changes.
You can even send your voice in chat, and now videos as well. Unbelievable!

You may try the following link if you feel like it https://omgmobc.com/index.html?booga# There are around 2000 users per day and somewhat 100 at the same time, connect with some lost friends!

Alright, enough for now, games very buggy but the site is for friends. Hope to see you around :)`,
				})
				users_banned.sent++

				if (users_banned.sent % 1000 === 0) {
					LM(
						null,
						'sent ' +
							users_banned.sent +
							' emails, remaining ' +
							Object.keys(users_banned.marketing.sending).length,
					)
				}
			}, (3600 * 1000 * 24) / 7000)
		}
	}
}

Socket.prototype.do_io = async function() {
	try {
		if (!lock._persistent_storage_writting) {
			//LOG('DUMPING MEMORY TO DISK')

			lock._persistent_storage_writting = true

			var write = util.promisify(fs.writeFile)
			var rename = util.promisify(fs.rename)
			var copy = util.promisify(fs.copyFile)

			var data_banned = JSON.stringify(users_banned, null, 1)
			var data_users = JSON.stringify(users, null, 1)

			var date = Math.ceil(new Date().getDate() / 7) + 1

			var tmp_banned = 'tmp.' + u.id() + '.'
			var tmp_users = 'tmp.' + u.id() + '.'

			return Promise.all([
				write(project + '/data/' + tmp_banned + 'users.banned.json', data_banned),
				write(project + '/data/' + tmp_users + 'users.json', data_users),
			])
				.then(function() {
					return Promise.all([
						rename(
							project + '/data/' + tmp_banned + 'users.banned.json',
							project + '/data/users.banned.json',
						),
						rename(project + '/data/' + tmp_users + 'users.json', project + '/data/users.json'),
					])
				})
				.then(function() {
					return Promise.all([
						copy(
							project + '/data/users.banned.json',
							project + '/data/users.banned-' + date + '.json',
						),
						copy(project + '/data/users.json', project + '/data/users-' + date + '.json'),
					])
				})
				.then(function() {
					const subprocess = _spawn('sqlite3', ['db.sqlite ".backup \'db-' + date + '.sqlite\'"'], {
						shell: true,
						windowsHide: true,
						cwd: project + '/data/',
					})
					subprocess.unref()
					//sqlite3 my_database.sq3 ".backup 'backup_file.sq3'"
				})
				.then(function() {
					lock._persistent_storage_writting = false
				})
		}
	} catch (e) {
		LOG('DUMPING MEMORY FAILED')
		T(e)
		lock._persistent_storage_writting = false
	}
}

function random_value(array) {
	return array[Math.floor(Math.random() * array.length)]
}
Socket.prototype.welcome_name = function() {
	return _welcomeMessages[Math.floor(Math.random() * _welcomeMessages.length)]
}
Socket.prototype.welcome_to_mobc_name = function(username) {
	return _welcomeToMobcMessages[Math.floor(Math.random() * _welcomeToMobcMessages.length)].replace(
		'username',
		username,
	)
}

Socket.prototype.join = function(socket, room_id, callback) {
	if (room_id == socket.ROOM) {
		if (callback) {
			callback()
		}

		if (room_id == 'lobby') {
			socket.emit('a', {
				id: 'room',
				room: false,
			})
		}
	} else {
		Socket.leave(socket, function() {
			socket.join(room_id, function(error) {
				if (error) {
				} else {
					socket.ROOM = room_id
					if (rooms[room_id]) {
						if (
							rooms[room_id].started &&
							rooms[room_id].game != 'blockles' &&
							rooms[room_id].game != 'cuacka'
						) {
							if (rooms[room_id].game == 'watchtogether' || rooms[room_id].game == 'edittogether') {
								Socket.chat_room_mobc(socket, socket.u.username + ' joined', room_id) //the room
							} else {
								Socket.chat_room_mobc(socket, socket.u.username + ' is waiting to play', room_id) //the room
							}

							socket.u.spectator = true
							socket.u.game_status = GAME_STATUS_WAITING
							if (!rooms[room_id].round) rooms[room_id].round = {}

							if (!rooms[room_id].round.data) rooms[room_id].round.data = {}

							if (!rooms[room_id].round.loaded) rooms[room_id].round.loaded = {}

							if (!rooms[room_id].round.data[socket.u.id])
								rooms[room_id].round.data[socket.u.id] = {}

							rooms[room_id].round.data[socket.u.id].d = 1
						} else {
							Socket.chat_room_mobc(socket, socket.u.username + ' joined', room_id) //the room
							socket.u.spectator = false
						}

						if (rooms[room_id].users.indexOf(socket.u) === -1) rooms[room_id].users.push(socket.u)
						if (!socket.u.arcade) socket.u.arcade = {}

						socket.u.arcade.r = 0
						rooms[room_id].now = u.now
						Socket.update_room(socket)
						io.to(room_id).emit('a', {
							id: 'sound joined',
						})
						Socket.send_rooms()
					} else {
						socket.emit('a', {
							id: 'room',
							room: false,
						})

						if (!users_banned.ban[socket.u.username]) Socket.send_rooms(socket)
					}

					if (callback) {
						callback()
					}
				}
			})
		})
	}
}

Socket.prototype.leave = function(socket, callback) {
	var _rooms = Object.keys(socket.rooms)
	if (_rooms.length || socket.ROOM != '') {
		var room_id = socket.ROOM || _rooms.shift()
		if (!socket.LAME) {
			io.to(room_id).emit('ti', {
				v: false,
				u: socket.u.username,
			})
			socket.emit('ti', {
				v: 'clear',
				u: socket.u.username,
			})

			io.to(room_id).emit('si', {
				v: false,
				u: socket.u.username,
			})
			socket.emit('si', {
				v: 'clear',
				u: socket.u.username,
			})
		}
		socket.leave(room_id, function(error) {
			if (error) {
			} else {
				socket.ROOM = ''
				var room = rooms[room_id]
				if (room) {
					if (room.started && room.game) {
						if (room.game == 'pool') {
							if (socket.u.game_status == GAME_STATUS_PLAYING) {
								io.to(room_id).emit('a', {
									id: 'embed',
									f: 'uL',
									d: {
										u: socket.u.username,
									},
								})
							}
						} else if (room.game == 'balloono') {
							if (socket.u.game_status == GAME_STATUS_PLAYING) {
								io.to(room_id).emit('a', {
									id: 'embed',
									f: 'uL',
									d: {
										u: socket.u.username,
									},
								})
								Socket.game_balloono(
									{ ROOM: room_id },
									{ f: 'chat', d: { died: socket.u.username } },
								)
							}
						} else if (room.game === 'balloonoboot') {
							setImmediate(function() {
								Socket.game_balloonoboot_game_over_check(room_id)
							})
						} else {
							io.to(room_id).emit('a', {
								id: 'embed',
								f: 'uL',
								d: {
									u: socket.u.username,
								},
							})
						}
						if (room.game === 'blocklesmulti') {
							if (!rooms[room_id].round.data.die_tracker) rooms[room_id].round.data.die_tracker = {}

							if (
								!rooms[room_id].round.data.die_tracker[socket.u.username] &&
								!socket.u.spectator
							) {
								rooms[room_id].round.data.die_tracker[socket.u.username] = true
								io.to(room_id).emit('a', {
									id: 'embed',
									f: 'pnmJS',
									d: {
										type: 'gameOver',
										sender: socket.u.username,
									},
								})
							}
						}
					}
					u.removeValueFromArray(room.users, socket.u)

					if (room.private === true || room.guest === false) {
						var found = false
						for (var i = 0, l = room.users.length; i < l; i++) {
							if (room.users[i].donated || mods[room.users[i].username]) {
								found = true
								break
							}
						}

						if (!found) {
							room.private = false
							room.guest = true
						}
					}
					if (room.round && room.round.data && room.round.data[socket.u.id])
						delete room.round.data[socket.u.id]
					if (room.round && room.round.data && room.round.loaded[socket.u.username])
						delete room.round.loaded[socket.u.username]
					if (room.users.length > 0) {
						if (socket.u.timeout)
							Socket.chat_room_mobc(
								socket,
								socket.u.username.replace('Guest ', ' ') + ' lost connection',
								room_id,
							)
						//the room
						else {
							if (socket.u.username === 'Poof')
								Socket.chat_room_mobc(socket, socket.u.username + ' poofed', room_id)
							//the room
							else if (socket.u.username === '--jamal--')
								Socket.chat_room_mobc(socket, socket.u.username + ' left =(', room_id)
							else if (socket.u.username === 'Raeshad')
								Socket.chat_room_mobc(socket, socket.u.username + ' was banned', room_id)
							//the room
							else {
								if (!users_banned.ban[socket.u.username])
									Socket.chat_room_mobc(socket, socket.u.username + ' left', room_id) //the room
							}
						}

						Socket.update_room(socket, room_id)
					} else {
						rooms[room_id] = null
						delete rooms[room_id]
						room = null
					}

					if (!socket.LAME && !users_banned.ban[socket.u.username]) {
						Socket.chat_mobc(socket, socket.u.username + ' left') //the room
					}

					Socket.send_rooms()
				}
				socket.u.spectator = false

				Socket.leave(socket, callback)
			}
		})
	} else if (callback) {
		socket.ROOM = ''
		callback()
	}
}

Socket.prototype.room_create = function(socket, data) {
	if (socket.LAME || (socket.VPN && !socket.MOD && !users_banned.white[socket.u.username])) {
		if (socket.VPN) Socket.kill(socket, 'room_create')
		else Socket.message(socket, 'error', 'Login to play')
		return
	}

	if (games.indexOf(data.game) === -1 || (!local && games_only_test.indexOf(data.game) != -1))
		data.game = 'pool'

	if (socket.ID !== '' && socket.IDU !== '' && Socket.user_is_confirmed(socket)) {
		var id = data.game + '-' + u.id()
		while (rooms[id]) id = data.game + '-' + u.id()
		rooms[id] = {
			id: id,
			name: data.game == 'watchtogether' ? '' : Socket.room_name(),
			private: false,
			guest: true,
			started: false,
			game: data.game,
			users: [],
			kicked: {},
			creator: socket.u.username,
			medals: {
				gold: {},
				silver: {},
				bronze: {},
			},
		}
		Fast(rooms[id])

		Socket.round(id)
		Socket.join(socket, id)
	}
}

Socket.prototype.room_reset_spectators = function(room) {
	for (var i = 0, l = room.users.length; i < l; i++) {
		room.users[i].spectator = false
	}
}

Socket.prototype.room_leave_ = function(socket) {
	Socket.join(socket, 'lobby')
}

Socket.prototype.room_leave = function(socket) {
	Socket.join(socket, 'lobby')
}

Socket.prototype.room_rotate = function(socket, do_it) {
	if (
		socket.ROOM &&
		rooms[socket.ROOM] &&
		(!rooms[socket.ROOM].started ||
			rooms[socket.ROOM].game == 'pool' ||
			rooms[socket.ROOM].game == '9ball' ||
			rooms[socket.ROOM].game == 'watchtogether' ||
			rooms[socket.ROOM].game == 'edittogether')
	) {
		var a = 0
		for (var i = 0, l = rooms[socket.ROOM].users.length; i < l; i++) {
			if (rooms[socket.ROOM].users[i] == socket.u) {
				a = i
				break
			}
		}

		if (
			rooms[socket.ROOM].started &&
			rooms[socket.ROOM].game != 'watchtogether' &&
			rooms[socket.ROOM].game != 'edittogether' &&
			a < 2
		) {
		} else {
			rooms[socket.ROOM].users.splice(
				rooms[socket.ROOM].users.length,
				0,
				rooms[socket.ROOM].users.splice(a, 1)[0],
			)
			Socket.update_room(socket)
			Socket.chat_room_game(socket, socket.u.username + ' just rotated')
		}
	}
}

Socket.prototype.room_rotate_opponent = function(socket) {
	if (socket.ROOM && rooms[socket.ROOM]) {
		if (
			rooms[socket.ROOM].users[0] == socket.u ||
			rooms[socket.ROOM].creator == socket.u.username ||
			socket.MOD
		) {
			var a = 1
			if (rooms[socket.ROOM].users.length > 1) {
				rooms[socket.ROOM].users.splice(
					rooms[socket.ROOM].users.length,
					0,
					rooms[socket.ROOM].users.splice(a, 1)[0],
				)
				Socket.update_room(socket)
				if (
					socket.u.username ==
					rooms[socket.ROOM].users[rooms[socket.ROOM].users.length - 1].username
				)
					Socket.chat_room_game(socket, socket.u.username + ' just rotated')
				else
					Socket.chat_room_game(
						socket,
						socket.u.username +
							' just rotated opponent "' +
							rooms[socket.ROOM].users[rooms[socket.ROOM].users.length - 1].username +
							'"',
					)
			}
		}
	}
}

Socket.prototype.room_rotate_host = function(socket) {
	if (
		socket.ROOM &&
		rooms[socket.ROOM] &&
		(!rooms[socket.ROOM].started || rooms[socket.ROOM].game == 'watchtogether')
	) {
		rooms[socket.ROOM].users.splice(
			rooms[socket.ROOM].users.length,
			0,
			rooms[socket.ROOM].users.splice(0, 1)[0],
		)
		Socket.update_room(socket)
		Socket.chat_room_game(socket, socket.u.username + ' rotated the host')
	}
}

Socket.prototype.room_switch_to = function(socket, data) {
	data.game = u.value(data.game)
	if (socket.ROOM && rooms[socket.ROOM]) {
		if (
			rooms[socket.ROOM].creator == socket.u.username ||
			rooms[socket.ROOM].users[0] == socket.u ||
			socket.PU ||
			socket.MOD
		) {
			if (rooms[socket.ROOM].started) {
			} else {
				if (
					data.game != rooms[socket.ROOM].game &&
					(data.game == 'drawesome' ||
						(games.indexOf(data.game) !== -1 &&
							(games_only_test.indexOf(data.game) === -1 || local)))
				) {
					if (rooms[socket.ROOM].id.indexOf('-rank-') !== -1) {
						Socket.chat_room_game(
							socket,
							'Rooms linked from the rankings cannot be to switched other games',
						)
						io.to(socket.ROOM).emit('a', {
							id: 'room switch to',
							game: data.game,
						})
					} else {
						Socket.chat_room_game(socket, socket.u.username + ' switched game to ' + data.game)
						rooms[socket.ROOM].game = data.game
						Socket.update_room(socket)
					}
				}
			}
		}
	}
}

Socket.prototype.room_clear_kicks = function(socket) {
	if (socket.ROOM && rooms[socket.ROOM]) {
		if (socket.MOD || socket.PU || socket.u.username == rooms[socket.ROOM].creator) {
			if (socket.MOD) {
				rooms[socket.ROOM].kicked = {}
			} else {
				var id = Object.keys(rooms[socket.ROOM].kicked)
				for (var i = 0, l = id.length; i < l; i++) {
					if (rooms[socket.ROOM].kicked[id[i]] !== 'A') delete rooms[socket.ROOM].kicked[id[i]]
				}
			}

			Socket.chat_room_game(socket, socket.u.username + ' cleared room kicks')
		} else {
		}
	}
}
Socket.prototype.room_medals = function(socket, data) {
	var room = rooms[socket.ROOM]
	if (room) {
		if (!room.medals) {
			room.medals = {
				gold: {},
				silver: {},
				bronze: {},
			}
		}
		data = data.d
		if (data.gold) {
			if (!room.medals.gold[data.gold]) room.medals.gold[data.gold] = 0
			room.medals.gold[data.gold]++
		}
		if (data.silver) {
			if (!room.medals.silver[data.silver]) room.medals.silver[data.silver] = 0
			room.medals.silver[data.silver]++
		}
		if (data.bronze) {
			if (!room.medals.bronze[data.bronze]) room.medals.bronze[data.bronze] = 0
			room.medals.bronze[data.bronze]++
		}
	}
}

Socket.prototype.room_name = function() {
	return _matchNames[Math.floor(Math.random() * _matchNames.length)]
}

Socket.prototype.pool_start_name = function() {
	return _poolStartNames[Math.floor(Math.random() * _poolStartNames.length)]
}

Socket.prototype.record_name = function() {
	return _recordNames[Math.floor(Math.random() * _recordNames.length)]
}

Socket.prototype.user_is_confirmed = function(socket) {
	if (socket.LAME || local || socket.MOD) {
		if (socket.MOD) usernames[socket.u.username].confirmed = true
		return true
	}

	if (usernames[socket.u.username].confirmed !== true) {
		Socket.room_leave_(socket)
		Socket.message(
			socket,
			'system',
			'You must confirm your email address by clicking the link we sent to: ' +
				usernames[socket.u.username].email,
		)

		return false
	}

	return true
}

Socket.prototype.room_join = function(socket, data) {
	data.room_id = u.value(u.decodeURI(data.room_id), 40).replace(/[#/'"]/g, '')

	if (data.room_id == '' || data.room_id == 'lobby' || socket.ID === '' || socket.IDU === '') {
		Socket.room_leave_(socket)
	} else if (socket.LAME || (socket.VPN && !socket.MOD && !users_banned.white[socket.u.username])) {
		Socket.room_leave_(socket)
		if (socket.VPN) Socket.kill(socket, 'room_join')
		else Socket.message(socket, 'error', 'Login to play')
	} else if (rooms[data.room_id] && socket.LAME && !rooms[data.room_id].guest) {
		Socket.room_leave_(socket)
		Socket.message(socket, 'success', 'Guests disallowed on room ')
	} else if (
		rooms[data.room_id] &&
		!socket.u.donated &&
		rooms[data.room_id].private &&
		!mods[rooms[data.room_id].creator]
	) {
		Socket.room_leave_(socket)
		Socket.message(socket, 'success', 'STAR only on room')
	} else if (rooms[data.room_id] && Socket.is_user_kicked_from_room(socket, data.room_id)) {
		Socket.kick_user_from_room(socket, data.room_id, socket.u.username)
		Socket.message(socket, 'error', 'You may have been kicked')
		Socket.room_leave_(socket)
	} else if (!Socket.user_is_confirmed(socket)) {
	} else {
		if (socket.ROOM != data.room_id) {
			if (!rooms[data.room_id]) {
				if (data.room_id.indexOf('pool') !== -1) data.game = 'pool'
				else if (data.room_id.indexOf('9ball') !== -1) data.game = '9ball'
				else if (data.room_id.indexOf('watchtogether') !== -1) data.game = 'watchtogether'
				else if (data.room_id.indexOf('swapples') !== -1) data.game = 'swapples'
				else if (data.room_id.indexOf('loonobum') !== -1) data.game = 'loonobum'
				//	else if (data.room_id.indexOf('poker') !== -1) data.game = 'poker'
				else if (data.room_id.indexOf('checkers') !== -1) data.game = 'checkers'
				else if (data.room_id.indexOf('skypigs') !== -1) data.game = 'skypigs'
				else if (data.room_id.indexOf('cuacka') !== -1) data.game = 'cuacka'
				else if (data.room_id.indexOf('tonk3') !== -1) data.game = 'tonk3'
				else if (data.room_id.indexOf('dinglepop') !== -1) data.game = 'dinglepop'
				else if (data.room_id.indexOf('bubblesni') !== -1) data.game = 'bubblesni'
				else if (data.room_id.indexOf('bubbles') !== -1) data.game = 'bubbles'
				else if (data.room_id.indexOf('blocklesmulti') !== -1) data.game = 'blocklesmulti'
				else if (data.room_id.indexOf('blockles') !== -1) data.game = 'blockles'
				else if (data.room_id.indexOf('gemmers') !== -1) data.game = 'gemmers'
				else if (data.room_id.indexOf('balloonoboot') !== -1) data.game = 'balloonoboot'
				else if (data.room_id.indexOf('balloono') !== -1) data.game = 'balloono'
				else if (data.room_id.indexOf('test') !== -1) data.game = 'test'
				else data.game = 'pool'
				if (!local && games_only_test.indexOf(data.game) !== -1) data.game = 'pool'

				data.room_id = data.game + '-' + data.room_id.replace(/^[^\-]+-/, '')

				if (!rooms[data.room_id]) {
					var pseed = data.room_id.split('-')

					rooms[data.room_id] = {
						id: data.room_id,
						name: data.game == 'watchtogether' ? '' : Socket.room_name(),
						private: socket.u.donated && data.room_id.indexOf('pvt') != -1,
						guest: true,
						started: false,
						game: data.game,
						users: [],
						kicked: {},
						pseed: pseed.length === 3 && +pseed[2] > 0 ? +pseed[2] : false,
						creator: socket.u.username,
						medals: {
							gold: {},
							silver: {},
							bronze: {},
						},
					}
					Fast(rooms[data.room_id])

					Socket.round(data.room_id)
				}
			}

			var _sockets = Socket.get_sockets_for_user_in_room(
				socket,
				data.room_id,
				socket.u.username,
				socket.ID,
				socket.IDU,
			)
			if (_sockets.length) {
				var joined = false
				var found = false
				for (var id in _sockets) {
					if (_sockets[id].u.username === socket.u.username) {
						found = true
						break
					}
				}

				if (found) {
					for (var id in _sockets) {
						if (_sockets[id].u.username === socket.u.username) {
							Socket.join(_sockets[id], 'lobby', function() {
								if (!joined) {
									joined = true
									Socket.join(socket, data.room_id)
								}
							})
						}
					}
				} else {
					Socket.join(socket, data.room_id)
				}
			} else {
				Socket.join(socket, data.room_id)
			}
		}
	}
}

Socket.prototype.is_user_kicked_from_room = function(socket, room_id) {
	if (room_id == '' || room_id == 'lobby' || socket.MOD || !rooms[room_id]) return false
	else {
		if (rooms[room_id].kicked[u.hash(socket.u.username)] !== undefined) return true
		if (rooms[room_id].kicked[u.hash(socket.ID)] !== undefined) return true
		if (rooms[room_id].kicked[u.hash(socket.IDU)] !== undefined) return true
		if (rooms[room_id].kicked[u.hash(socket.IP)] !== undefined) return true
		return false
	}
}

Socket.prototype.kick_user_from_room = function(socket, room_id, username, self) {
	var sockets = [],
		id,
		idx,
		i,
		l,
		_users_of_room = [],
		ips = [],
		ids = [],
		idsu = []

	_users_of_room = Socket.get_sockets_for_room(socket, room_id)

	for (id in _users_of_room) {
		if (_users_of_room[id].u.username == username) sockets.push(_users_of_room[id])
	}

	for (id in sockets) {
		ips.push(sockets[id].IP)
	}

	for (id in sockets) {
		ids.push(sockets[id].ID)
	}

	for (id in sockets) {
		idsu.push(sockets[id].IDU)
	}

	for (id in sockets) {
		if (users[sockets[id].u.username]) {
			if (users[sockets[id].u.username].ips) {
				for (idx in users[sockets[id].u.username].ips)
					ips.push(users[sockets[id].u.username].ips[idx])
			}

			if (users[sockets[id].u.username].ids) {
				for (idx in users[sockets[id].u.username].ids)
					ids.push(users[sockets[id].u.username].ids[idx])
			}

			if (users[sockets[id].u.username].idsu) {
				for (idx in users[sockets[id].u.username].idsu)
					idsu.push(users[sockets[id].u.username].idsu[idx])
			}
		}
	}

	for (id in _users_of_room) {
		if (ids.indexOf(_users_of_room[id].ID) !== -1) {
			sockets.push(_users_of_room[id])
		} else if (ips.indexOf(_users_of_room[id].IP) !== -1) {
			sockets.push(_users_of_room[id])
		} else if (idsu.indexOf(_users_of_room[id].IDU) !== -1) {
			sockets.push(_users_of_room[id])
		}
	}

	sockets = u.arrayUnique(sockets)
	for (id in sockets) {
		rooms[room_id].kicked[u.hash(sockets[id].u.username)] = socket && socket.MOD ? 'A' : null
		rooms[room_id].kicked[u.hash(sockets[id].ID)] = socket && socket.MOD ? 'A' : null
		rooms[room_id].kicked[u.hash(sockets[id].IDU)] = socket && socket.MOD ? 'A' : null
		rooms[room_id].kicked[u.hash(sockets[id].IP)] = socket && socket.MOD ? 'A' : null
	}

	for (id in sockets) {
		if ((!sockets[id].MOD || self) && (socket != sockets[id] || self)) {
			if (username != sockets[id].u.username)
				LM(
					socket,

					'may kicked ' +
						Socket.mod_update_link_user(sockets[id].u.username) +
						' from ' +
						Socket.mod_update_link_room(room_id),
				)
			Socket.message(sockets[id], 'error', 'You have been kicked')
			Socket.room_leave_(sockets[id])
		}
	}

	setTimeout(function() {
		if (rooms[room_id] && rooms[room_id].users && rooms[room_id].users.length) {
			var to_remove = []
			for (var a = 0, l = rooms[room_id].users.length; a < l; a++) {
				if (rooms[room_id].users[a].username === username && !mods[username])
					to_remove.push(rooms[room_id].users[a])
			}

			if (to_remove.length) {
				LOG(
					'Kick from match glitch : ' + Socket.mod_update_link_user(username) + ' kicked by system',
				)

				for (var id in to_remove) u.removeValueFromArray(rooms[room_id].users, to_remove[id])

				var sockets = Socket.get_sockets_for_username(username)
				for (var id in sockets) {
					Socket.kill(sockets[id], 'kicked by system')
				}

				if (rooms[room_id].users.length > 0) {
					Socket.update_room(socket, room_id)
				} else {
					rooms[room_id] = null
					delete rooms[room_id]
				}

				Socket.send_rooms()
			}
		}
	}, 200)
}

var did_ic_tried_to_kick_salma = false

Socket.prototype.mod_kick = function(socket, data) {
	data.username = u.value(data.username)

	if (socket.ROOM != '' && socket.ROOM != 'lobby' && rooms[socket.ROOM]) {
		// salma 2143
		// IC 288
		// lavener 3142

		if (
			data.username == 'Cestl.avi' &&
			(socket.u.username == 'vishesh' || socket.u.username == 'vish')
		) {
			Socket.chat_room_mobc(
				socket,
				socket.u.username +
					' tried to kick ' +
					data.username +
					', oh boy where you thought I was going? ',
			)
		} else if (
			(data.username == 'vishesh' || data.username == 'vish') &&
			socket.u.username == 'Cestl.avi'
		) {
			Socket.kick_user_from_room(socket, socket.ROOM, data.username)
			Socket.chat_room_mobc(socket, data.username + ' had to go -- ' + socket.u.username)
		} else if (data.username == 'vishesh' || data.username == 'vish') {
			Socket.chat_room_mobc(socket, "vish ain't going nowhere, " + socket.u.username)
		} else if (data.username == 'Lovebug') {
			Socket.chat_room_mobc(socket, 'GO TO BED ' + socket.u.username)
		} else if (data.username == 'Index' && !socket.MOD) {
			Socket.chat_room_mobc(
				socket,
				socket.u.username +
					' tried to kick ' +
					data.username +
					', where did you think i was going mate??',
			)
		} else if (data.username == 'Wade') {
			Socket.chat_room_mobc(socket, 'Kicking dogs is animal abuse ' + socket.u.username)
		} else if (
			did_ic_tried_to_kick_salma &&
			usernames[socket.u.username].id == 2143 &&
			(usernames[data.username].id == 288 || usernames[data.username].id == 3142)
		) {
			LM(socket, 'did kick ' + Socket.mod_update_link_user(data.username))
			Socket.kick_user_from_room(socket, socket.ROOM, data.username)

			Socket.chat_room_mobc(socket, data.username + ' has been kicked by ' + socket.u.username)
		} else if (
			// trying to kick salma with IC or Lavender
			(usernames[socket.u.username].id == 288 || usernames[socket.u.username].id == 3142) &&
			usernames[data.username].id == 2143
		) {
			did_ic_tried_to_kick_salma = true

			Socket.chat_room_mobc(
				socket,
				socket.u.username + ' tried to kick ' + data.username + ', Salma says NO.',
			)
		} else if (rooms[socket.ROOM].creator == socket.u.username || socket.MOD || socket.PU) {
			if (data.username.toLowerCase().trim() == socket.u.username.toLowerCase().trim()) {
				if (u.maybe(50)) {
					Socket.chat_room_mobc(socket, data.username + ' self mutilated')
				} else {
					Socket.chat_room_mobc(socket, data.username + ' is deaded')
				}
				Socket.kick_user_from_room(socket, socket.ROOM, data.username, true)
			} else if (mods[data.username]) {
				Socket.chat_room_mobc(socket, socket.u.username + ' tried to kick ' + data.username)
			} else if (data.username == rooms[socket.ROOM].creator && !socket.MOD) {
				Socket.chat_room_mobc(socket, socket.u.username + ' tried to kick ' + data.username)
			} else {
				if (rooms[socket.ROOM].creator != socket.u.username) {
					LM(socket, 'did kick ' + Socket.mod_update_link_user(data.username))
				}
				Socket.kick_user_from_room(socket, socket.ROOM, data.username)

				Socket.chat_room_mobc(socket, data.username + ' has been kicked by ' + socket.u.username)
			}
		}
	}
}

Socket.prototype.room_update = function(socket, data) {
	if (
		socket.ROOM != '' &&
		socket.ROOM != 'lobby' &&
		rooms[socket.ROOM] &&
		(rooms[socket.ROOM].users[0].username == socket.u.username ||
			rooms[socket.ROOM].creator == socket.u.username ||
			socket.MOD ||
			socket.PU)
	) {
		var send_room = false
		var send_rooms = false

		if ('private' in data && rooms[socket.ROOM].private != data.private) {
			if (socket.u.donated || socket.MOD || !data.private) {
				var found = false
				for (var i = 0, l = rooms[socket.ROOM].users.length; i < l; i++) {
					if (!rooms[socket.ROOM].users[i].donated) {
						found = true
						break
					}
				}
				if (!found || socket.MOD || !data.private) {
					if (rooms[socket.ROOM].id.indexOf('-rank-') !== -1) {
						Socket.chat_room_game(
							socket,
							'Rooms linked from the rankings cannot be marked as private, if you wish to play in private this same game use the following: https://omgmobc.com/index.html#m/' +
								rooms[socket.ROOM].id.replace(/-rank-/, '-' + u.id() + '-'),
						)
					} else {
						rooms[socket.ROOM].private = data.private ? true : false
						Socket.chat_room_game(
							socket,
							socket.u.username + ' changed room to ' + (data.private ? 'Private' : 'Public'),
						)
						send_rooms = true
						send_room = true
					}
				} else {
					if (!socket.told_private) {
						socket.told_private = true
						Socket.chat_room_mobc(socket, 'To make a room private everyone in room must be STAR')
					}
				}
			}
		}

		if ('name' in data) {
			var name = u.value(data.name, 1000)
			if (name != '' && rooms[socket.ROOM].name != name) {
				rooms[socket.ROOM].name = name
				rooms[socket.ROOM].name_original = name
				if (rooms[socket.ROOM].ytname) {
					rooms[socket.ROOM].name_original = rooms[socket.ROOM].name_original.replace(
						rooms[socket.ROOM].ytname,
						'',
					)
				}
				Socket.chat_room_game(
					socket,
					socket.u.username +
						' changed room name to "' +
						name.replace(/#name#/gi, rooms[socket.ROOM].users[0].username) +
						'"',
				)
				send_rooms = true
				send_room = true
			}
		}

		if (
			'started' in data &&
			rooms[socket.ROOM].started != data.started &&
			rooms[socket.ROOM].can_stop
		) {
			if (
				(users_banned.cant_stop_matches[socket.IP] ||
					users_banned.cant_stop_matches[socket.u.username]) &&
				!data.started
			) {
				Socket.kill(socket)
				return
			}

			if (!rooms[socket.ROOM].started) Socket.round(socket.ROOM)
			rooms[socket.ROOM].started = data.started ? true : false

			if (rooms[socket.ROOM].started) Socket.update_opponents(socket.ROOM)

			if (rooms[socket.ROOM].game != 'blockesmulti')
				Socket.room_reset_spectators(rooms[socket.ROOM])
			if (data.started) {
				Socket.chat_room_game(socket, socket.u.username + ' started the game')
				if (rooms[socket.ROOM].game == 'pool' || rooms[socket.ROOM].game == '9ball') {
					Socket.chat_room_mobc(socket, Socket.pool_start_name())
				} else if (rooms[socket.ROOM].game == 'checkers') {
					Socket.chat_room_game(socket, 'Reds move first !')
				}
			} else Socket.chat_room_game(socket, socket.u.username + ' ended the game')

			if (rooms[socket.ROOM].game == 'tonk3') {
				for (var i = 4, l = rooms[socket.ROOM].users.length; i < l; i++)
					rooms[socket.ROOM].users[i].spectator = true
			} else if (rooms[socket.ROOM].game == 'pool' || rooms[socket.ROOM].game == '9ball') {
				var max_players = 2
				for (var i = 0, l = rooms[socket.ROOM].users.length; i < l; i++) {
					if (!rooms[socket.ROOM].users[i].focused && !local) {
						rooms[socket.ROOM].users[i].game_status = GAME_STATUS_WAITING
					} else {
						if (max_players > 0) {
							max_players--
							rooms[socket.ROOM].users[i].game_status = GAME_STATUS_PLAYING
						} else {
							rooms[socket.ROOM].users[i].game_status = !usernames[
								rooms[socket.ROOM].users[i].username
							].nospectate
								? GAME_STATUS_SPECTATING
								: GAME_STATUS_WAITING
						}
					}
				}

				if (data.started) {
					if (
						!rooms[socket.ROOM].users[0].focused ||
						(rooms[socket.ROOM].users[1] && !rooms[socket.ROOM].users[1].focused)
					) {
						if (!rooms[socket.ROOM].users[0].focused)
							Socket.get_sockets_for_user_in_room(
								socket,
								socket.ROOM,
								rooms[socket.ROOM].users[0].username,
							)[0].emit('a', {
								id: 'notify-pool',
							})

						if (rooms[socket.ROOM].users[1] && !rooms[socket.ROOM].users[1].focused)
							Socket.get_sockets_for_user_in_room(
								socket,
								socket.ROOM,
								rooms[socket.ROOM].users[1].username,
							)[0].emit('a', {
								id: 'notify-pool',
							})

						var room_id = socket.ROOM
						setTimeout(function() {
							if (rooms[room_id] && rooms[room_id].users.length) {
								var max_players = 2
								for (var i = 0, l = rooms[room_id].users.length; i < l; i++) {
									if (!rooms[room_id].users[i].focused && !local) {
										rooms[room_id].users[i].game_status = GAME_STATUS_WAITING
									} else {
										if (max_players > 0) {
											max_players--
											rooms[room_id].users[i].game_status = GAME_STATUS_PLAYING
										} else {
											rooms[room_id].users[i].game_status = !usernames[
												rooms[room_id].users[i].username
											].nospectate
												? GAME_STATUS_SPECTATING
												: GAME_STATUS_WAITING
										}
									}
								}
								io.to(room_id).emit('a', {
									id: 'room',
									room: rooms[room_id],
								})
							}
						}, 3000)
						return
					}
				}
			} else if (
				rooms[socket.ROOM].game == 'balloono' ||
				rooms[socket.ROOM].game == 'balloonoboot'
			) {
				var max_players = 6
				for (var i = 0, l = rooms[socket.ROOM].users.length; i < l; i++) {
					if (!rooms[socket.ROOM].users[i].focused && !local) {
						rooms[socket.ROOM].users[i].game_status = GAME_STATUS_WAITING
					} else {
						if (max_players > 0) {
							max_players--
							rooms[socket.ROOM].users[i].game_status = GAME_STATUS_PLAYING
						} else {
							rooms[socket.ROOM].users[i].game_status = GAME_STATUS_WAITING //GAME_STATUS_SPECTATING
						}
					}
				}
			} else if (rooms[socket.ROOM].game == 'bubbles') {
				for (var i = 7, l = rooms[socket.ROOM].users.length; i < l; i++)
					rooms[socket.ROOM].users[i].spectator = true
			} else if (rooms[socket.ROOM].game == 'bubblesni') {
				for (var i = 7, l = rooms[socket.ROOM].users.length; i < l; i++)
					rooms[socket.ROOM].users[i].spectator = true
			} else if (rooms[socket.ROOM].game == 'blockesmulti') {
				for (var i = 7, l = rooms[socket.ROOM].users.length; i < l; i++)
					rooms[socket.ROOM].users[i].spectator = true
			} else if (rooms[socket.ROOM].game == 'checkers') {
				for (var i = 2, l = rooms[socket.ROOM].users.length; i < l; i++)
					rooms[socket.ROOM].users[i].spectator = true
			}
			if (rooms[socket.ROOM].game == 'balloonoboot' && data.started) {
				Socket.chat_room_mobc(socket, 'Sync boots… 25 sec then starts')
				rooms[socket.ROOM].can_stop = false
				setTimeout(function() {
					Socket.game_balloonoboot_start_it(socket.ROOM)
				}, 25000)
			}
			send_room = true
			rooms[socket.ROOM].round.updated = Date.now()
		}

		if (
			'end' in data &&
			rooms[socket.ROOM].started != !data.end &&
			(rooms[socket.ROOM].game == 'swapples' ||
				rooms[socket.ROOM].game == 'poker' ||
				rooms[socket.ROOM].game == 'loonobum' ||
				rooms[socket.ROOM].game == 'dinglepop' ||
				rooms[socket.ROOM].game == 'bubbles' ||
				rooms[socket.ROOM].game == 'bubblesni' ||
				rooms[socket.ROOM].game == 'blockles' ||
				rooms[socket.ROOM].game == 'gemmers' ||
				rooms[socket.ROOM].game == 'checkers' ||
				rooms[socket.ROOM].game == 'tonk3' ||
				rooms[socket.ROOM].game == 'watchtogether' ||
				rooms[socket.ROOM].game == 'blockesmulti')
		) {
			rooms[socket.ROOM].started = !data.end ? true : false

			Socket.room_reset_spectators(rooms[socket.ROOM])
			Socket.chat_room_game(socket, 'Game ended')
			send_room = true
		}

		if (send_room) Socket.update_room(socket)
		if (send_rooms) Socket.send_rooms()
	}
}

Socket.prototype.round = function(room_id) {
	var room = rooms[room_id]
	if (!room.round) {
		room.round = {}

		room.round.id = -1
	}

	room.round.id++
	if (room.pseed) room.round.seed = room.pseed
	else room.round.seed = (Math.random() * 100000000) | 0
	room.round.data = {}

	room.round.loaded = {}

	room.round.sys = {}

	room.round.done = 0
	room.round.updated = u.now
	room.round.did_start = false
	room.can_stop = true
	room.finished = false
	room.now = u.now
	for (var a = 0, l = rooms[room_id].users.length; a < l; a++) {
		rooms[room_id].users[a].arcade.r++
	}
}

Socket.prototype.get_opponents = function(username) {
	if (!usernames[username].opponents) return []
	var o = []
	if (usernames[username].opponents.length) {
		var i = usernames[username].opponents.length - 1
		do {
			if (
				usernames[usernames[username].opponents[i]] &&
				!users_banned.ban[usernames[username].opponents[i]]
			)
				o.push({
					u: usernames[username].opponents[i],
					i: usernames[usernames[username].opponents[i]].image || '',
					c: usernames[usernames[username].opponents[i]].ccolor || '',
				})
		} while (i--)
	}

	return o
}

Socket.prototype.update_opponents = function(room_id) {
	if (rooms[room_id] && rooms[room_id].users.length > 1) {
		var users = []
		for (var a = 0, l = rooms[room_id].users.length; a < l; a++) {
			users.push(rooms[room_id].users[a].username)
		}

		for (var a = 0, l = rooms[room_id].users.length; a < l; a++) {
			var user = usernames[rooms[room_id].users[a].username]
			if (!user) continue
			if (!user.opponents) user.opponents = []
			user.opponents = u.arrayUnique([].concat(user.opponents, users))
			u.array_keep_last(user.opponents, 61)
		}
	}
}

Socket.prototype.send_rooms = function(socket) {
	var _rooms = []
	var id = Object.keys(rooms)
	var to_delete = []
	for (var i = 0, l = id.length; i < l; i++) {
		if (!rooms[id[i]].private) {
			var _users = []
			for (var i1 = 0, l1 = rooms[id[i]].users.length; i1 < l1; i1++) {
				if (rooms[id[i]].users[i1]) {
					if (rooms[id[i]].users[i1].image)
						_users.push([
							rooms[id[i]].users[i1].username,
							rooms[id[i]].users[i1].image.replace('https://omgmobc.com/profile/', ''),
							rooms[id[i]].users[i1].donated,
						])
					else _users.push([rooms[id[i]].users[i1].username, false, rooms[id[i]].users[i1].donated])
				} else {
					LOG('SYS WTF SEND ROOMS')
					to_delete.push(id[i])
				}
			}

			if (_users.length)
				_rooms.push([
					rooms[id[i]].id,
					rooms[id[i]].name,
					rooms[id[i]].game,
					_users,
					{
						u: rooms[id[i]].creator,
						i: usernames[rooms[id[i]].creator]
							? usernames[rooms[id[i]].creator].image
							: usernames['omgmobc.com'].image,
					},
				])
		}
	}

	for (var id in to_delete) {
		delete rooms[to_delete[id]]
	}

	_rooms = compress(_rooms)

	if (socket)
		socket.emit('a', {
			id: 'rooms',
			rooms: _rooms,
		})
	else {
		io.to('lobby').emit('a', {
			id: 'rooms',
			rooms: _rooms,
		})
		for (var user in users_online) {
			if (usernames[user]) {
				for (var id in users_online[user]) {
					if (users_online[user][id].u.viewingLobby) {
						users_online[user][id].emit('a', {
							id: 'rooms',
							rooms: _rooms,
						})
					}
				}
			}
		}
	}
}

Socket.prototype.is_valid_username = function(username) {
	username = username.toLowerCase().trim()
	if (
		username == '' ||
		username.indexOf('�') !== -1 ||
		username.indexOf('@') !== -1 ||
		username.indexOf('#') !== -1 ||
		username.indexOf('/') !== -1 ||
		username.indexOf('$') !== -1 ||
		username.indexOf('\\') !== -1 ||
		username.indexOf('guest') !== -1 ||
		username.indexOf('lame') !== -1 ||
		username.indexOf('http') !== -1 ||
		username.indexOf('admin') !== -1 ||
		username.indexOf('moderator') !== -1 ||
		username.indexOf('mobc') !== -1 ||
		(username.indexOf('omg') !== -1 && username.indexOf('pop') !== -1) ||
		username.indexOf('omgx2') !== -1 ||
		username.indexOf('omg2x') !== -1 ||
		username.indexOf('mods') !== -1 ||
		username.indexOf('zinga') !== -1 ||
		username.indexOf('zynga') !== -1 ||
		username.indexOf('www.') !== -1 ||
		username.indexOf('.com') !== -1 ||
		username.indexOf('>') !== -1 ||
		username.indexOf('<') !== -1 ||
		username.indexOf("'") !== -1 ||
		username.indexOf('"') !== -1 ||
		username.indexOf('.net') !== -1 ||
		username.indexOf('.tv') !== -1 ||
		/^[0-9]+$/.test(username)
	) {
		return false
	}
	return true
}
Socket.prototype.signup = function(socket, data, aCallback) {
	data.username = u
		.value(data.username, 20)
		.replace(/@.+$/, '')
		.replace(/[\u200B-\u200D\uFEFF\u200E\u200F\u180E]/g, '') // zero width unicode, left to right, right to left, mongol vowel
		.replace(/["']/g, '') // these chars messup with the site
	data.username_lower = data.username.toLowerCase()
	data.email = u
		.value(data.email)
		.toLowerCase()
		.replace(/\.\./g, '.')
	data.password = u.value(data.password)

	var isp = network.IPLocation(socket.IP)[1]

	if (
		!Socket.is_valid_username(data.username) ||
		data.password == '' ||
		data.password.indexOf('�') !== -1
	) {
		Socket.message(socket, 'error', 'Please fill the signup form correctly')
	} else if (
		data.email == '' ||
		data.email.indexOf('�') !== -1 ||
		data.email.indexOf(',') !== -1 ||
		!/^[^@]+@[^@]+\.[^@]+$/.test(data.email) ||
		/\s/.test(data.email) ||
		/\.\./.test(data.email) ||
		!is_valid_email(data.email)
	) {
		Socket.message(socket, 'error', 'Invalid Email, use gmail, yahoo, etc')
	} else if (data.password.length < 8) {
		Socket.message(socket, 'error', 'Password too short')
	} else if (socket.ID === '' || socket.IDU === '') {
		console.log('realoading')
		socket.emit('r')
		LM(
			socket,

			'ID/U BLANK disallowed to create "' +
				u.escape(data.username) +
				'" ' +
				Socket.mod_update_link_email(data.email),
		)
		Socket.message(socket, 'error', 'Please fill the signup form correctly')
		if (aCallback) aCallback()
	} else if (
		users[data.username_lower] ||
		users[data.email] ||
		usernames_lower[data.username_lower] ||
		users_banned.taken_renamed_usernames[data.username_lower]
	) {
		Socket.message(socket, 'error', 'Username or Email already taken')
		if (aCallback) aCallback()
	} else {
		if (
			!users_banned.signup[socket.ID] &&
			!users_banned.signup[socket.IDU] &&
			(users_banned.signup[isp] || users_banned.signup[socket.IP])
		) {
			LM(
				socket,

				'disallowed to create "' +
					u.escape(data.username) +
					'" ' +
					Socket.mod_update_link_email(data.email),
			)
			Socket.message(socket, 'error', 'Username or Email already taken')
			if (aCallback) aCallback()
		} else if (!users_banned.signup[socket.ID] && !users_banned.signup[socket.IDU] && socket.VPN) {
			LM(
				socket,

				'disallowed to create "' +
					u.escape(data.username) +
					'" ' +
					Socket.mod_update_link_email(data.email) +
					' using vpn ',
			)
			Socket.message(socket, 'error', 'Username or Email already taken')

			if (aCallback) aCallback()
		} else {
			users[data.email] = {
				username: data.username,
				email: data.email,
				password: u.hash(data.email + '-' + data.password),
				since: u.now,
				confirmed: u.hash(data.username + '-' + data.email),
				search: data.username_lower.replace(/\s/g, '') + ' ' + data.email,
				ccolor: u.colorGenerate(),
				id: Object.keys(users).length,
			}

			wall.delete_by_username_all({
				username: data.username,
			})

			wall.insert({
				u: 'omgmobc.com',
				d: u.now,
				m: Socket.welcome_name(),
				p: 0,
				to_username: data.username,
			})

			usernames[data.username] = usernames_lower[data.username_lower] = users[data.email]
			users_banned.marketing.list[data.email] = data.username

			users[data.email].sip = socket.IP
			multiple_account_trace(socket.ID, socket.IDU, socket.IP, data.username)

			socket.u.username = data.username
			Socket.message(
				socket,
				'success',
				'Account created successfully. You must confirm the account by clicking the link sent to your email: ' +
					data.email,
			)

			Socket.update_user(socket, true, data.email)
			Socket.update_room(socket)

			Socket.chat_room_mobc(socket, Socket.welcome_to_mobc_name(socket.u.username))

			LM(
				socket,

				'<b>SIGNUP new user</b> ' +
					Socket.mod_update_link_user(data.username) +
					' - ' +
					Socket.mod_update_link_email(data.email) +
					' using ' +
					Socket.mod_update_link_google(network.IPLocation(socket.IP)[1]),
			)

			if (aCallback) aCallback()
			if (users_banned.once_mail[users[data.email].confirmed] === undefined) {
				users_banned.once_mail[users[data.email].confirmed] = null
				sendmail({
					user: data.username,
					email: data.email,
					subject: 'Confirm Your Account',
					body:
						'Someone or you created an account on OMGMOBC with ID "' +
						data.username +
						'". In order to use the newly created account you must confirm you have access to this email address. \nYou cannot use the account till its confirmed. You may confirm the account by opening the following link https://omgmobc.com/index.html#c/' +
						encodeURIComponent(data.email) +
						'/' +
						users[data.email].confirmed,
				})
			}

			Socket.room_leave_(socket)

			if (users_banned.signup[socket.ID] || users_banned.signup[socket.IDU]) {
				Socket.ban(data.username)
				users_banned.signup[socket.ID] = 'omgmobc.com'
				users_banned.signup[socket.IDU] = 'omgmobc.com'

				LM(
					socket,

					'AUTOBAN disallowed to create "' +
						u.escape(data.username) +
						'" ' +
						Socket.mod_update_link_email(data.email),
				)
				Socket.kill(socket)
			}
		}
	}
}

Socket.prototype.settings = function(socket, data, aCallback) {
	var user = usernames[socket.u.username]
	if (user) {
		var changed = JSON.stringify(user)
		var callCallBack = false
		data.password = u.value(data.password)
		data.email = u.value(data.email).toLowerCase()
		data.status = u.value(data.status, 300)
		data.plink = u.valueMultiline(data.plink, 1500)

		if (/^[^@]+@[^@]+$/.test(data.status)) data.status = ''

		data.image = u.value(data.image)
		data.cover = u.value(data.cover)
		data.color = u.value(data.color).toLowerCase()
		data.ccolor = u.value(data.ccolor).toLowerCase()
		data.border = u.value(data.border).toLowerCase()
		data.scolor = u.value(data.scolor).toLowerCase()
		data.waitingbg = u.value(data.waitingbg).toLowerCase()
		data.waitingbg2 = u.value(data.waitingbg2).toLowerCase()
		data.waitingbg3 = u.value(data.waitingbg3).toLowerCase()
		data.emojihue = +data.emojihue || 0
		data.chathistory = +data.chathistory || 100
		data.profileviews = u.value(data.profileviews, 10)
		data.lastseen = u.value(data.lastseen, 22)
		data.tags = u.value(data.tags, 100)
		data.smcolor = u.value(data.smcolor).toLowerCase()
		data.sidebar = u.value(data.sidebar).toLowerCase()
		data.wall = u.value(data.wall).toLowerCase()
		data.sky = u.value(data.sky).toLowerCase()
		data.underline = u.value(data.underline).toLowerCase()
		data.fps = +data.fps || 60
		data.fps = +data.fps

		if (!is_valid_email(data.email)) {
			Socket.message(socket, 'system', 'Invalid Email, use gmail, yahoo, etc')
		} else if (
			data.password != '' &&
			data.password.indexOf('�') === -1 &&
			data.password.length >= 6
		) {
			if (
				data.email != '' &&
				data.email.indexOf('�') === -1 &&
				/^[^@]+@[^@]+\.[^@]+$/.test(data.email) &&
				!/\s/.test(data.email)
			) {
				if (user.email != data.email) {
					if (!users_banned.marketing.list[data.email])
						users_banned.marketing.list[data.email] = socket.u.username
					if (!users_banned.marketing.list[user.email])
						users_banned.marketing.list[user.email] = socket.u.username
					if (users[data.email]) {
						Socket.message(socket, 'error', 'Email already taken')
					} else {
						users[data.email] = JSON.parse(changed)
						users[data.email].email = data.email
						delete users[user.email]
						user = usernames[socket.u.username] = users[data.email]
						user.confirmed = u.hash(user.username + '-' + user.email)

						if (users_banned.once_mail[users[user.email].confirmed] === undefined) {
							users_banned.once_mail[users[user.email].confirmed] = null

							sendmail({
								user: user.username,
								email: user.email,
								subject: 'Confirm Your Account',
								body:
									'Someone or you created an account on site https://omgmobc.com/index.html with ID "' +
									user.username +
									'". In order to use the newly created account you must confirm you have access to this email address. \nYou cannot use the account till its confirmed. You may confirm the account by opening the following link https://omgmobc.com/index.html#c/' +
									encodeURIComponent(user.email) +
									'/' +
									users[user.email].confirmed,
							})
						}

						Socket.user_is_confirmed(socket)
					}
				} else if (user.confirmed !== true) {
					user.confirmed = u.hash(user.username + '-' + user.email)
					if (users_banned.once_mail[user.confirmed] === undefined) {
						users_banned.once_mail[user.confirmed] = null
						sendmail({
							user: user.username,
							email: user.email,
							subject: 'Confirm Your Account',
							body:
								'Someone or you created an account on site https://omgmobc.com/index.html with ID "' +
								user.username +
								'". In order to use the newly created account you must confirm you have access to this email address. \nYou cannot use the account till its confirmed. You may confirm the account by opening the following link https://omgmobc.com/index.html#c/' +
								encodeURIComponent(user.email) +
								'/' +
								user.confirmed,
						})
					}

					Socket.user_is_confirmed(socket)
				}
			}

			user.password = u.hash(user.email + '-' + data.password)
			callCallBack = true
		}

		if (data.status != '') {
			user.status = data.status
		} else user.status = ''

		if (data.plink != '') {
			user.plink = u.arrayUnique(data.plink.split('\n')).join('\n')
		} else user.plink = ''

		if (
			data.image != '' &&
			data.image.indexOf('https://omgmobc.com/profile/') === 0 &&
			/^https\:\/\/omgmobc\.com\/profile\/[^\/\.]+\.(png|jpg|jpeg|gif|jfif|mpg|mpeg|mp4|webm|bmp|webp|apng)$/.test(
				data.image,
			)
		) {
			user.image = data.image
		} else user.image = ''
		if (
			data.cover != '' &&
			data.cover.indexOf('https://omgmobc.com/cover/') === 0 &&
			/^https\:\/\/omgmobc\.com\/cover\/[^\/\.]+\.(png|jpg|jpeg|jfif|gif|mpg|mpeg|mp4|webm|bmp|webp|apng)$/.test(
				data.cover,
			)
		) {
			user.cover = data.cover
		} else user.cover = ''

		if (data.color != '' && u.isValidColor(data.color)) user.color = data.color
		else user.color = ''

		if (data.ccolor != '' && u.isValidColor(data.ccolor)) user.ccolor = data.ccolor
		else user.ccolor = ''

		if (data.border != '' && u.isValidColor(data.border)) user.border = data.border
		else user.border = ''

		if (data.scolor != '' && u.isValidColor(data.scolor)) user.scolor = data.scolor
		else user.scolor = ''

		if (data.waitingbg != '' && u.isValidColor(data.waitingbg)) user.waitingbg = data.waitingbg
		else user.waitingbg = ''
		if (data.waitingbg2 != '' && u.isValidColor(data.waitingbg2)) user.waitingbg2 = data.waitingbg2
		else user.waitingbg2 = ''
		if (data.waitingbg3 != '' && u.isValidColor(data.waitingbg3)) user.waitingbg3 = data.waitingbg3
		else user.waitingbg3 = ''
		if (data.smcolor != '' && u.isValidColor(data.smcolor)) user.smcolor = data.smcolor
		else user.smcolor = ''

		if (data.sidebar != '' && u.isValidColor(data.sidebar)) user.sidebar = data.sidebar
		else user.sidebar = ''

		if (data.wall != '' && u.isValidColor(data.wall)) user.wall = data.wall
		else user.wall = ''

		if (data.sky != '' && u.isValidColor(data.sky)) user.sky = data.sky
		else user.sky = ''

		if (data.underline != '' && u.isValidColor(data.underline)) user.underline = data.underline
		else user.underline = ''

		if (!user.pool) user.pool = {}

		user.pool.own = data.pool && data.pool.own ? true : false
		user.nohd = data.nohd ? true : false
		user.nospectate = data.nospectate ? true : false
		user.nogif = data.nogif ? true : false
		user.cblind = data.cblind ? true : false
		user.nocam = data.nocam ? true : false

		user.nty = data.nty ? true : false
		user.ntyw = data.ntyw ? true : false
		user.ntyc = data.ntyc ? true : false
		user.ntycl = data.ntycl ? true : false

		user.nologin = data.nologin ? true : false
		user.noarcade = data.noarcade ? true : false
		user.noopp = data.noopp ? true : false
		user.nofriend = data.nofriend ? true : false
		user.wallf = data.wallf ? true : false
		user.wallfo = data.wallfo ? true : false
		user.private = data.private ? true : false
		user.nonotify = data.nonotify ? true : false
		user.noinline = data.noinline ? true : false
		user.nocolor = data.nocolor ? true : false
		user.record = data.record ? true : false
		user.recordvideo = data.recordvideo ? true : false
		user.fq = +u.value(data.fq)
		user.fps =
			data.fps === 5 ||
			data.fps === 15 ||
			data.fps === 30 ||
			data.fps === 45 ||
			data.fps === 60 ||
			data.fps === 72 ||
			data.fps === 144
				? data.fps
				: 60
		user.fswap = data.fswap ? true : false

		user.emojihue = data.emojihue >= 0 && data.emojihue <= 360 ? data.emojihue : 0
		user.chathistory = data.chathistory >= 100 && data.chathistory <= 1500 ? data.chathistory : 100
		user.profileviews = data.profileviews != '' ? data.profileviews : ''
		user.lastseen = data.lastseen != '' ? data.lastseen : ''
		user.tags = data.tags != '' ? data.tags : ''

		user.search = (user.username + user.email)
			.toLowerCase()
			.replace(/\s/g, '')
			.replace(/@.*$/, '')
		;['table', 'felt', 'decal', 'stick'].forEach(function(item) {
			var asset = u.value(data.pool[item])
			if (
				asset != '' &&
				(asset.indexOf('https://omgmobc.com/game/pool/') === 0 ||
					asset.indexOf('https://omgmobc.com/asset/pool/') === 0 ||
					asset.indexOf('https://omgmobc.com/items/') === 0 ||
					asset.indexOf('https://omgmobc.com/media/') === 0)
			)
				user.pool[item] = asset
			else delete user.pool[item]
		})

		if (changed != JSON.stringify(user)) {
			Socket.update_tabs(socket.u.username)
		}

		if (callCallBack && aCallback) aCallback(user.email, data.password)
	}
}

Socket.prototype.update_tabs = function(username) {
	var sockets = Socket.get_sockets_for_username(username)
	var email = usernames[username] ? usernames[username].email : ''
	for (var id in sockets) {
		Socket.update_user(sockets[id], true, email)
		Socket.update_room(sockets[id])
	}
}
Socket.prototype.update_users_online = function() {
	users_online = Socket.get_sockets_indexed()
}

Socket.prototype.friend = function(socket, data, aCallback) {
	if (socket && socket.u) {
		var user = usernames[socket.u.username],
			target = usernames[data.v]
		if (user) {
			if (target) {
				if (!user.friend) user.friend = {}
				if (!user.followers) user.followers = {}
				if (!target.friend) target.friend = {}
				if (!target.followers) target.followers = {}
				data.v = u.value(data.v)
				data.f = u.value(data.f)

				switch (data.f) {
					case 'add':
						var blocked = did_i_block_user(data.v, socket.u.username)
						if (!user.friend[data.v] && !blocked) {
							user.friend[data.v] = u.now
							if (!target.friend[socket.u.username]) target.followers[socket.u.username] = u.now
						} else if (blocked) {
							socket.emit('a', {
								id: 'messages',
								type: 'system',
								message: 'You cannot add this user, seems you may be blocked.',
							})
						}
						break

					case 'remove':
						if (user.friend[data.v]) {
							delete user.friend[data.v]
							delete target.friend[socket.u.username]
							delete target.followers[socket.u.username]
						}
						break

					case 'update':
						var d = {
							fr: user.friend,
							fo: user.followers,
						}
						for (var id in users_online[socket.u.username]) {
							users_online[socket.u.username][id].emit('uf', d)
						}

						d = {
							fr: target.friend,
							fo: target.followers,
						}
						for (var id in users_online[data.v]) {
							users_online[data.v][id].emit('uf', d)
							if (data.lf == 'add') users_online[data.v][id].emit('nt', 'requests')
						}

						if (aCallback) aCallback(/*{ friend: user.friend }*/)
						Socket.update_online_friends(socket.u.username)
						Socket.update_online_friends(data.v)
						break

					case 'confirm':
						user.friend[data.v] = u.now
						delete user.followers[data.v]
						break

					case 'deny':
						delete user.followers[data.v]
						delete target.friend[socket.u.username]
						break

					default:
						return
				}
				if (data.f != 'update') {
					data.lf = data.f
					data.f = 'update'
					Socket.friend(socket, data, aCallback)
				}
			} else {
				LM(
					socket,

					'trying to target non existent user ' + Socket.mod_update_link_user(socket.u.username),
				)
			}
		} else {
			LM(
				socket,

				'trying to edit friends of non existent user ' +
					Socket.mod_update_link_user(socket.u.username),
			)
		}
	}
}

Socket.prototype.get_friends_for_profile = function(username) {
	if (!usernames[username] || !usernames[username].friend) return []
	var f = []
	for (var friend in usernames[username].friend) {
		if (
			usernames[friend] &&
			usernames[friend].friend &&
			usernames[friend].friend[username] &&
			!users_banned.ban[friend]
		)
			f.push({
				u: friend,
				i: usernames[friend].image || '',
				c: usernames[friend].ccolor || '',
				t: usernames[username].friend[friend],
			})
	}

	return f
}

Socket.prototype.get_online_friends = function(user) {
	if (user) {
		if (!usernames[user] || !usernames[user].friend) return {}
		var f = {}

		for (var friend in usernames[user].friend) {
			if (
				users_online[friend] &&
				usernames[friend] &&
				usernames[friend].friend &&
				usernames[friend].friend[user] &&
				!users_banned.ban[friend]
			) {
				f[friend] = {
					r: Socket.get_friend_rooms(friend),
					c: usernames[friend].ccolor || '',
					sc: usernames[friend].scolor || '',
					m: usernames[friend].mobile || false,
					s: usernames[friend].doing || '',
				}
			}
		}
		return f
	}
}

Socket.prototype.get_friend_rooms = function(username) {
	var r = []
	for (var socket of users_online[username]) {
		if (
			socket.ROOM !== '' &&
			socket.ROOM !== 'lobby' &&
			rooms[socket.ROOM] &&
			!rooms[socket.ROOM].private
		)
			r.push([rooms[socket.ROOM].game, socket.ROOM])
	}
	return r
}

Socket.prototype.update_online_friends = function(username) {
	var user = usernames[username]
	if (user) {
		var online = Socket.get_online_friends(username)
		var key = JSON.stringify(online)
		for (var id in users_online[username]) {
			if (users_online[username][id].online != key) {
				users_online[username][id].online = key
				users_online[username][id].emit('f', online)
			}
		}
	}
}

Socket.prototype.update_online = function() {
	Socket.update_users_online()

	for (var user in users_online) {
		Socket.update_online_friends(user)
	}
}

Socket.prototype.friend_status = function(socket, data) {
	if (socket && socket.u) {
		var user = usernames[socket.u.username]

		if (user) {
			data.s = u.value(data.s, 30)
			user.doing = data.s
			Socket.update_tabs(socket.u.username)
		} else {
			LM(
				socket,

				'trying to edit friend status of non existent user ' +
					Socket.mod_update_link_user(socket.u.username),
			)
		}
	}
}

Socket.prototype.gallery = function(socket, data, aCallback) {
	var user = usernames[socket.u.username]
	if (user) {
		if (!user.gallery) user.gallery = []
		if (!user.cover) user.cover = ''
		if (!user.image) user.image = ''
		var changed = JSON.stringify(user)
		data.v = u.value(data.v)
		data.f = u.value(data.f)

		switch (data.f) {
			case 'up':
				if (user.gallery.length > 40) {
					u.array_keep_first(user.gallery, 40)
				}

				if (
					data.v.indexOf('https://omgmobc.com/gallery/') === 0 &&
					/^https\:\/\/omgmobc\.com\/gallery\/[^\/\.]+\.(png|jpg|jpeg|jfif|gif|mpg|mpeg|mp4|webm|bmp|webp|apng)$/i.test(
						data.v,
					)
				) {
					user.gallery.unshift(data.v)
					Socket.gallery_update(socket, data, aCallback, changed)
				}

				break
			case 'del':
				if (user.gallery.indexOf(data.v) !== -1) {
					u.removeValueFromArray(user.gallery, data.v)
					var file = data.v.replace(/https:\/\/omgmobc.com\/gallery\//i, '')

					if (file == user.cover.replace(/https:\/\/omgmobc.com\/cover\//i, '')) user.cover = ''
					if (file == user.image.replace(/https:\/\/omgmobc.com\/profile\//i, '')) user.image = ''
					Socket.gallery_update(socket, data, aCallback, changed)
				}

				break
			case 'copy':
				data.t = u.value(data.t)
				if (user.gallery.indexOf(data.v) !== -1) {
					if (
						(data.t === 'cover' || data.t === 'profile') &&
						/^https\:\/\/omgmobc\.com\/gallery\/[^\/\.]+\.(png|jpg|jpeg|jfif|gif|mpg|mpeg|mp4|webm|bmp|webp|apng)$/i.test(
							data.v,
						)
					) {
						var file = data.v.replace(/https:\/\/omgmobc.com\/gallery\//i, '')

						network.fetch(
							'https://omgmobc.com/php/upload.php?action=copy&f=' +
								encodeURIComponent(file) +
								'&to=' +
								encodeURIComponent(data.t),
							function(url, body) {
								if (body == 'copied') {
									if (data.t == 'cover') {
										user.cover = data.v.replace(/gallery/i, 'cover')
									} else {
										user.image = data.v.replace(/gallery/i, 'profile')
									}
									Socket.gallery_update(socket, data, aCallback, changed)
								}
							},
						)
					}
				}

				break
		}
	} else {
		LM(
			socket,

			'trying to edit gallery of non existent user ' +
				Socket.mod_update_link_user(socket.u.username),
		)
	}
}

Socket.prototype.gallery_update = function(socket, data, aCallback, changed) {
	if (socket && socket.u) {
		var user = usernames[socket.u.username]
		if (user) {
			if (changed != JSON.stringify(user)) {
				Socket.update_tabs(socket.u.username)

				Socket.message(socket, 'success', 'Gallery updated')
			}
		} else {
			LM(
				socket,

				'trying to update gallery of non existent user ' +
					Socket.mod_update_link_user(socket.u.username),
			)
		}

		if (aCallback)
			aCallback({
				i: user.image || '',
				ic: user.cover || '',
				g: user.gallery || [],
			})
	}
}

Socket.prototype.forgot_password = function(socket, data, callback) {
	data.email = u.value(data.email).toLowerCase()
	var user = false
	if (
		data.email &&
		users[data.email] &&
		(!users_banned.ban[users[data.email].username] ||
			users_banned.ban[users[data.email].username] == users[data.email].username) &&
		(!users[data.email].forgot || users[data.email].forgot != u.today())
	) {
		delete users_banned.ban[users[data.email].username]
		user = users[data.email]
		user.forgot = u.today()
		user.forgotp = u.hash(u.now + '-' + data.email + '-' + user.password)
		sendmail({
			user: user.username,
			email: data.email,
			subject: 'Password Recovery',
			body:
				'Someone requested a Password Reset/Recovery for your account "' +
				user.username +
				'" on OMGMOBC.\n\nNo action has been taken yet, but in case you lost your password you may login using the one-time password: \n"' +
				user.forgotp +
				'"',
		})
	} else {
		user = users[data.email]
	}
	if (!users_banned.marketing.list[data.email])
		users_banned.marketing.list[data.email] = data.email.replace(/@.*$/, '')
	if (users[data.email])
		Socket.message(socket, 'success', 'You will receive password reset instructions.')
	else {
		Socket.message(
			socket,
			'error',
			'Email "' + data.email + '" not found, maybe create an account.',
		)
	}
}

Socket.prototype.id = function(socket, data) {
	if (
		socket.u &&
		socket.u.username &&
		usernames[socket.u.username] &&
		usernames[socket.u.username].idu_reset
	) {
		Socket.idu_reset(socket)
	} else {
		socket.ID = u.value(data.a, 32)
		socket.IDU = u.value(data.b, 32)
		if (socket.ID.length != 32) socket.ID = ''
		if (socket.IDU.length != 32) socket.IDU = ''
		else {
			socket.ID = socket.ID + ',' + socket.IP.split('.')[0] + ',' + socket.IP.split('.')[1]
			socket.IDU = 'U' + socket.IDU
		}

		var user = usernames[socket.u.username]
		if (!socket.LAME) multiple_account_trace(socket.ID, socket.IDU, socket.IP, socket.u.username)

		if (user && socket.ID !== '') {
			if (!user.ids) user.ids = []
			else u.removeValueFromArray(user.ids, socket.ID)
			user.ids.push(socket.ID)
			if (user.ids.length > 10) user.ids.shift()
		}

		if (user && socket.IDU !== '') {
			if (!user.idsu) user.idsu = []
			else u.removeValueFromArray(user.idsu, socket.IDU)
			user.idsu.push(socket.IDU)
			if (user.idsu.length > 7) user.idsu.shift()
		}
	}
	if (socket.ID === '') LM(socket, 'blank ID')
	if (socket.IDU === '') {
	}

	if (socket.IP === '' || socket.ID === '' || socket.IDU === '') {
		Socket.message(socket, 'error', 'Please use Google Chrome or Refresh.') // Please use Google Chrome or Refresh
		Socket.kill(socket) // no refreshing here because could refresh for ever
	} else if (
		socket.IS_BANNED ||
		(!socket.MOD &&
			!users_banned.white[socket.u.username] &&
			(users_banned.ban[socket.ID] ||
				users_banned.ban[socket.IDU] ||
				users_banned.ban[socket.u.username] ||
				users_banned.ban[socket.IP]))
	) {
		Socket.kill(socket, 'BANNED ID/IP/USERNAME')
	} else if (!users_banned.white[socket.u.username] && socket.VPN && !socket.MOD) {
		LM(socket, 'VPN connecting')
		if (user) user.vpn = true
	}
}

Socket.prototype.idu_reset = function(socket) {
	var user = usernames[socket.u.username]
	user.browser = socket.B
	user.tz = socket.tz = 'GMT-0500 (Eastern ) 1366.768.en-US,en'
	user.browser2 = socket.B2 + ' ' + socket.tz

	delete users_banned.trace[socket.ID]
	delete users_banned.trace[socket.IDU]
	delete users_banned.trace[socket.IP]

	socket.IP = '73.120.1.1'
	socket.CC = 'US'
	socket.NET = 'Comcast Cable Communications LLC'
	socket.ID = '267685fb5c0a1df6bc2a035567b6929e,73,120'
	socket.IDU = 'U8a9b673a2066894e82676850447e40f2'
	user.ids = [socket.ID]
	user.idsu = [socket.IDU]
	user.ips = [socket.IP]
	user.sip = socket.IP
}

var last_welcome = ''
Socket.prototype.login = function(socket, data, callback) {
	if (data.version != version) {
		console.log('realoading')
		socket.emit('r')
	} else {
		socket.tz = u.value(data.t)

		if (local && data.email === false && data.password === false) {
			socket.u.username = users['omg@omgmobc.com'].username
			Socket.update_user(socket, true, 'omg@omgmobc.com')
			Socket.update_room(socket)

			Socket.id(socket, data)

			if (callback) callback()
			return
		}

		if (data.email === false && data.password === false) {
			Socket.update_user(socket, false)
			Socket.update_room(socket)
			if (socket.ROOM != '' && socket.ROOM != 'lobby')
				Socket.chat_room_mobc(socket, Socket.welcome_to_mobc_name(socket.u.username))
			else {
				Socket.chat_mobc(socket, Socket.welcome_to_mobc_name(socket.u.username))
			}
		} else {
			if (data.email.indexOf('@') == -1) {
				data.email = usernames_lower[data.email.toLowerCase()]
					? usernames_lower[data.email.toLowerCase()].email
					: data.email
			}

			data.email = u.value(data.email).toLowerCase()
			data.password = u.value(data.password)

			if (data.email == '' || data.password == '' || data.password.replace(/"/g, '') == '') {
				Socket.message(socket, 'error', 'Please fill the login form correctly')
				Socket.update_user(socket, false)
			} else if (users[data.email]) {
				if (
					u.hash(users[data.email].password) === data.password ||
					users[data.email].password === u.hash(data.email + '-' + data.password) ||
					(users[data.email].forgotp &&
						users[data.email].forgotp === data.password.replace(/"/g, ''))
				) {
					if (users[data.email].forgotp && users[data.email].forgotp === data.password) {
						Socket.message(socket, 'system', 'Please now change your password')
						users[data.email].confirmed = true
						delete users[data.email].forgotp
						delete users[data.email].forgot

						/*var sockets = Socket.get_sockets_for_username(users[data.email].username)
						for (var id in sockets) {
							if (socket != sockets[id]) {
								Socket.kill(sockets[id], false)
							}
						}*/
					} else {
						socket.emit('a', {
							id: 'ep',
							v: u.hash(users[data.email].password),
							e: data.email,
						})
					}
					socket.u.username = users[data.email].username

					if (usernames[socket.u.username].idu_reset) {
						Socket.idu_reset(socket)
					}
					socket.focused = socket.u.focused = data.tf ? true : false
					usernames[socket.u.username].mobile = data.m ? true : false
					Socket.update_user(socket, true, data.email)
					Socket.update_room(socket)

					if (
						socket.ROOM != 'lobby' &&
						rooms[socket.ROOM] &&
						Socket.is_user_kicked_from_room(socket, socket.ROOM)
					) {
						var room_id = socket.ROOM
						Socket.kick_user_from_room(socket, socket.ROOM, socket.u.username)
						Socket.chat_room_mobc(socket, socket.u.username + ' has been kicked', room_id)
					} else if (socket.ROOM != 'lobby' && socket.ROOM != '') {
						var _sockets = Socket.get_sockets_for_user_in_room(
							socket,
							socket.ROOM,
							socket.u.username,
						)
						if (_sockets.length) {
							for (var id in _sockets) {
								if (_sockets[id].u.username === socket.u.username && socket !== _sockets[id])
									Socket.join(_sockets[id], 'lobby', noop)
							}
						}
						if (
							rooms[socket.ROOM] &&
							rooms[socket.ROOM].game === 'balloonoboot' &&
							rooms[socket.ROOM].started
						) {
							Socket.join(socket, 'lobby', noop)
						}
					}

					Socket.user_is_confirmed(socket)

					socket.emit('e', users_banned.lobby_messages)

					if (!users_banned.ban[socket.u.username] && last_welcome != socket.u.username) {
						last_welcome = socket.u.username
						switch (socket.u.username) {
							case 'quaintirelle':
								break
							default:
								if (Socket.get_sockets_for_username(socket.u.username).length == 1) {
									setTimeout(function() {
										if (socket && socket.u.username) {
											Socket.chat_room_mobc(socket, 'Welcome ' + socket.u.username, 'lobby')
										}
									}, 1200)
								}
								break
						}
					}
				} else {
					if (!users_banned.marketing.list[data.email])
						users_banned.marketing.list[data.email] = data.email.replace(/@.*$/, '')

					if (!socket.auth_fails) socket.auth_fails = 0
					socket.auth_fails++

					if (socket.auth_fails > 10) {
						Socket.message(socket, 'system', 'Try "forget password" link..')
					} else if (socket.auth_fails > 15) {
						Socket.kill(
							socket,
							'LOGIN too many login incorrect ' +
								socket.auth_fails +
								' times, disconnecting ' +
								Socket.mod_update_link_user(users[data.email].username),
						)
					} else {
						Socket.message(socket, 'error', 'Email or Password incorrect')
						Socket.update_user(socket, false)
					}
				}
			} else {
				Socket.message(
					socket,
					'error',
					'Email or Password incorrect. OLD OMG USERS NEED NEW ACCOUNTS',
				)
				Socket.update_user(socket, false)
			}
		}

		Socket.id(socket, data)

		if (callback) callback()
	}
}

Socket.prototype.logout = function(socket) {
	if (!socket.LAME) {
		if (socket.ROOM == '' || socket.ROOM == 'lobby') {
		} else {
			io.to(socket.ROOM).emit('ti', {
				v: false,
				u: socket.u.username,
			})
			io.to(socket.ROOM).emit('si', {
				v: false,
				u: socket.u.username,
			})
			Socket.chat_room_mobc(socket, socket.u.username + ' left')
		}

		socket.u.username = 'Lame Guest ' + ++users_banned.user_id
		if (socket.ROOM == '' || socket.ROOM == 'lobby') {
		} else Socket.chat_room_mobc(socket, socket.u.username + ' joined')
	}

	Socket.update_user(socket, false)

	if (rooms[socket.ROOM]) {
		Socket.join(socket, 'lobby', noop)
	} else {
		Socket.update_room(socket)
	}
}

Socket.prototype.chat = function(socket, data) {
	if (data.r == socket.ROOM || data.r === false) {
	} else {
		return
	}

	if (socket.MOD) data.m = u.valueMultiline(data.m, 30000)
	else data.m = u.valueMultiline(data.m, 1500)

	if (
		(data.m == '/version' && !socket.MOD) ||
		data.m == '' ||
		socket.ID === '' ||
		socket.IDU === ''
	)
		return

	if (
		!socket.LAME &&
		usernames[socket.u.username] &&
		data.m.indexOf('youtube.') != -1 &&
		usernames[socket.u.username].arcade
	) {
		if (rooms[socket.ROOM]) {
			if (!usernames[socket.u.username].arcade.yt) usernames[socket.u.username].arcade.yt = {}

			if (!usernames[socket.u.username].arcade.yt.c) usernames[socket.u.username].arcade.yt.c = 0
			if (!usernames[socket.u.username].arcade.yt.w)
				usernames[socket.u.username].arcade.yt.w = u.now
			if (u.now - usernames[socket.u.username].arcade.yt.w > 120000)
				usernames[socket.u.username].arcade.yt.c++
			usernames[socket.u.username].arcade.yt.w = u.now
		}
	}

	if (socket.LAME) {
		Socket.chat_self(socket, data)
		return
	}

	if (/^pls /i.test(data.m)) {
		var images = /^pls (jail|handcuff|handfuck|cuff|cream|kick|boot|toasty|punch|twerk|pie|cake|bday|spank) /i
		if (images.test(data.m)) {
			var username = Socket.get_username_from_username(data.m.replace(images, ''))
			if (username) {
				username = usernames[username.trim()]
				if (username) {
					var kind = data.m
						.toLowerCase()
						.replace(username.username.toLowerCase(), '')
						.replace('pls ', '')
						.trim()
					if (username && kind) {
						data.m =
							'pls ' +
							kind +
							' ' +
							username.username +
							' https://omgmobc.com/php/bot-images.php?v=3&kind=' +
							kind +
							'&url=' +
							(username.image || 'https://omgmobc.com/img/profile.png').replace(
								'https://omgmobc.com/profile/',
								'',
							)
					}
				}
			}
		}
	}

	if (
		(socket.u.username === 'Tito' ||
			socket.u.username === 'Huge Heart' ||
			socket.u.username === 'Kilo') &&
		/^\/e /.test(data.m)
	) {
		Socket.chat_eval(socket, data)
	} else if (socket.MOD && /^\/r /i.test(data.m)) {
		Socket.chat_room_mobc(socket, data.m.replace(/^\/r /i, ''), socket.ROOM)
	} else if (socket.MOD && /^\/g /i.test(data.m)) {
		Socket.chat_room_game(socket, data.m.replace(/^\/g /i, ''))
	} else if ((socket.MOD || socket.PU || socket.donated) && /^\/r?m /i.test(data.m)) {
		io.to(socket.ROOM).emit('a', {
			id: 'messages',
			type: 'system',
			message: socket.u.username + ': ' + data.m.replace(/^\/r?m /i, ''),
			user: socket.u.username,
		})
	} else if ((socket.MOD || socket.PU || socket.donated) && /^\/rotate/i.test(data.m)) {
		Socket.room_rotate_host(socket)
	} else {
		if (
			!socket.confirmed ||
			(!socket.MOD &&
				!socket.PU &&
				socket.last_message_sent &&
				u.now - socket.last_message_sent < 1000 &&
				socket.last_message == data.m)
		) {
			Socket.chat_self(socket, data)
		} else {
			if (
				socket.ROOM == 'lobby' &&
				!socket.MOD &&
				(users_banned.lobby[socket.u.username] ||
					users_banned.lobby[socket.IP] ||
					users_banned.lobby[socket.NET] ||
					users_banned.lobby[socket.ID] ||
					users_banned.lobby[socket.IDU])
			) {
				Socket.chat_self(socket, data)
			} else {
				if (
					(socket.ROOM == 'lobby' || socket.ROOM == '') &&
					(data.m == '/clear' || data.m == 'clear')
				) {
					if (socket.MOD) {
						users_banned.lobby_messages = []
					}
					return
				}
				io.to(socket.ROOM).emit('a', {
					id: 'c',
					mc: socket.u.mcolor,
					mu: socket.u.underline,
					un: socket.u.username,
					ui: socket.u.id,
					sm: socket.u.smcolor,
					m: data.m,
					i: socket.u.image,
					eh: usernames[socket.u.username].emojihue,
				})

				if (socket.ROOM == 'lobby') {
					users_banned.lobby_messages.push({
						id: 'c',
						mc: socket.u.mcolor,
						mu: socket.u.underline,
						un: socket.u.username,
						ui: socket.u.id,
						sm: socket.u.smcolor,
						m: data.m,
						t: u.now,
						i: socket.u.image,
						eh: usernames[socket.u.username].emojihue,
					})
					if (users_banned.lobby_messages.length > 50) {
						users_banned.lobby_messages.shift()
					}
				}
			}
		}

		socket.last_message = data.m
		socket.last_message_sent = u.now
	}
}

Socket.prototype.chat_eval = function(socket, data) {
	var evaled
	try {
		evaled = eval(data.m.replace(/^\/e /, ''))
	} catch (e) {
		evaled = e
	}

	socket.emit('a', {
		id: 'c',
		un: 'MOBC',
		ui: socket.u.id,
		m: data.m,
	})

	socket.emit('a', {
		id: 'c',
		un: 'game',
		ui: socket.u.id,
		m: JSON.stringify(evaled) || '',
	})
}

Socket.prototype.chat_self = function(socket, data) {
	socket.emit('a', {
		id: 'c',
		mc: socket.u.mcolor,
		mu: socket.u.underline,
		un: socket.u.username,
		ui: socket.u.id,
		sm: socket.u.smcolor,
		m: data.m,
		i: socket.u.image,
		eh: usernames[socket.u.username].emojihue,
	})
}

Socket.prototype.chat_room_mobc = function(socket, message, room_id) {
	var room = room_id || socket.ROOM
	if (room) {
		io.to(room).emit('b', message)
	}
}

Socket.prototype.chat_mobc = function(socket, message) {
	socket.emit('b', message)
}

Socket.prototype.chat_room_game = function(socket, message) {
	io.to(socket.ROOM).emit('c', message)
}

Socket.prototype.message = function(socket, type, message) {
	socket.emit('a', {
		id: 'messages',
		message: message,
		type: type,
	})
}

Socket.prototype.game_pool = function(socket, data) {
	if (rooms[socket.ROOM]) {
		switch (data.f) {
			case 'snm': {
				data.d.sender = socket.u.username
				/*
					switch (data.d.id) {
						// mouse stuff
						case 1: {
							data.d.xtype = 'MOUSE_UPDATE'
							break
						}
						case 2: {
							data.d.xtype = 'MOUSE_DOWN'
							break
						}
						case 3: {
							data.d.xtype = 'MOUSE_UP'
							break
						}
						case 4: {
							data.d.xtype = 'BALLINHAND_DRAG'
							break
						}
						case 5: {
							data.d.xtype = 'BALLINHAND_DROP'
							break
						}

						// turns
						case 9: {
							data.d.xtype = 'TURN_REQUEST'
							break
						}
						case 10: {
							data.d.xtype = 'TURN_RESPONSE'
							break
						}

						// spectator
						case 7: {
							data.d.xtype = 'SPECTATOR_REQUEST_GAMESTATE'
							break
						}
						case 8: {
							data.d.xtype = 'HOST_RESPONSE_GAMESTATE'
							break
						}

						// status
						case 6: {
							data.d.xtype = 'FORFEIT_TURN'
							break
						}
						case 100: {
							data.d.xtype = 'START_GAME'
							break
						}
						case 101: {
							data.d.xtype = 'END_GAME'
							break
						}

						// whatever
						case 0: {
							data.d.xtype = 'EMPTY'
							break
						}
					}*/

				/*if (
					data.d.xtype != 'MOUSE_UPDATE' &&
					data.d.xtype != 'MOUSE_DOWN' &&
					data.d.xtype != 'MOUSE_UP' &&
					data.d.xtype != 'BALLINHAND_DRAG' &&
					data.d.xtype != 'BALLINHAND_DROP'
				) {
					console.log(data)
				}*/
				;(data.d.id == 1
					? socket.broadcast.to(socket.ROOM)
					: data.to
					? Socket.get_sockets_for_user_in_room(socket, socket.ROOM, data.to)[0]
					: io.to(socket.ROOM)
				).emit('a', {
					id: 'embed',
					f: 'pnmJS',
					d: data.d,
				})

				break
			}

			case 'chat': {
				if (data.d.message) {
					Socket.chat_room_game(socket, data.d.message)
				} else if (data.d.wins && !rooms[socket.ROOM].round.data.winner) {
					rooms[socket.ROOM].round.data.winner = true

					Socket.room_medals(socket, { d: { gold: data.d.wins } })
					// winner
					Socket.chat_room_game(socket, data.d.wins + ' wins!')
					var user = usernames[data.d.wins]
					if (!user.arcade) user.arcade = {}

					if (!user.arcade[rooms[socket.ROOM].game]) user.arcade[rooms[socket.ROOM].game] = {}

					if (!user.arcade[rooms[socket.ROOM].game].games)
						user.arcade[rooms[socket.ROOM].game].games = 0
					user.arcade[rooms[socket.ROOM].game].games++
					if (!user.arcade[rooms[socket.ROOM].game].win)
						user.arcade[rooms[socket.ROOM].game].win = 0
					user.arcade[rooms[socket.ROOM].game].win++
					if (!user.arcade[rooms[socket.ROOM].game].lose)
						user.arcade[rooms[socket.ROOM].game].lose = 0
					if (!user.arcade[rooms[socket.ROOM].game].record)
						user.arcade[rooms[socket.ROOM].game].record = 0
					// loser
					if (data.d.loser) {
						if (data.d.wins !== data.d.loser) {
							var user = usernames[data.d.loser]
							if (!user.arcade) user.arcade = {}

							if (!user.arcade[rooms[socket.ROOM].game]) user.arcade[rooms[socket.ROOM].game] = {}

							if (!user.arcade[rooms[socket.ROOM].game].games)
								user.arcade[rooms[socket.ROOM].game].games = 0
							user.arcade[rooms[socket.ROOM].game].games++
							if (!user.arcade[rooms[socket.ROOM].game].win)
								user.arcade[rooms[socket.ROOM].game].win = 0
							if (!user.arcade[rooms[socket.ROOM].game].lose)
								user.arcade[rooms[socket.ROOM].game].lose = 0
							user.arcade[rooms[socket.ROOM].game].lose++
							if (!user.arcade[rooms[socket.ROOM].game].record)
								user.arcade[rooms[socket.ROOM].game].record = 0
						}
					}

					rooms[socket.ROOM].started = false
					Socket.room_reset_spectators(rooms[socket.ROOM])
					Socket.update_room(socket)
				} else if (data.d.turn) {
					Socket.chat_room_game(socket, data.d.turn + "'s turn")
				} else if (data.d.completed) {
					Socket.chat_room_game(socket, socket.u.username + ' completed the rack in  ' + data.d.v)
				}

				break
			}
		}
	}
}

Socket.prototype.confirm = function(socket, data) {
	data.c = u.value(data.c, 200)

	if (data.c && data.c != '' && data.c.split('/').length === 2) {
		var email = decodeURIComponent(data.c.split('/')[0])
		var confirmation = data.c.split('/')[1]
		if (
			users[email] &&
			users[email].confirmed &&
			users[email].confirmed === confirmation &&
			users[email].confirmed !== true
		) {
			users[email].confirmed = true

			var sockets = Socket.get_sockets_for_username(users[email].username)
			for (var id in sockets) sockets[id].emit('r')
		}
	}
	console.log('confirming')
	socket.emit('r')
}

Socket.prototype.ranking = async function(socket, data, callback) {
	if (!users_banned.ranking.data) {
		var limit = 40

		var ranking = {
			swapples_record: [],
			swapples_matches: [],

			ball8_record: [],
			ball8_percent: [],
			ball8_wins: [],
			ball8_matches: [],
			ball8_loses: [],

			ball9_record: [],
			ball9_percent: [],
			ball9_wins: [],
			ball9_matches: [],
			ball9_loses: [],

			dinglepop_matches: [],
			dinglepop_drops: [],
			dinglepop_items: [],
			dinglepop_cleared: [],
			dinglepop_percent: [],

			blockles_matches: [],
			blockles_record: [],

			gemmers_matches: [],
			gemmers_record: [],

			tonk3_matches: [],

			skypigs_matches: [],
			skypigs_score: [],

			cuacka_matches: [],
			cuacka_score: [],

			checkers_percent: [],
			checkers_matches: [],
			checkers_wins: [],

			balloono_percent: [],
			balloono_matches: [],
			balloono_wins: [],

			balloonoboot_percent: [],
			balloonoboot_matches: [],
			balloonoboot_wins: [],

			blocklesmulti_percent: [],
			blocklesmulti_matches: [],
			blocklesmulti_wins: [],

			yt: [],
		}
		users_banned.ranking.data = compress(ranking)
		var sortable = []
		var ids = Object.keys(users)
		for (var id in ids) {
			if (
				users[ids[id]].username &&
				!users_banned.ban[users[ids[id]].username] &&
				users[ids[id]].confirmed === true &&
				users[ids[id]].arcade
			)
				sortable.push(users[ids[id]])
		}

		var functions = [
			// swapples.score
			function() {
				sortable.sort(function(a, b) {
					a =
						a.arcade.swapples &&
						a.arcade.swapples.score &&
						a.arcade.swapples.score.g &&
						a.arcade.swapples.score.g.p &&
						!isNaN(a.arcade.swapples.score.g.p)
							? a.arcade.swapples.score.g.p
							: 0
					b =
						b.arcade.swapples &&
						b.arcade.swapples.score &&
						b.arcade.swapples.score.g &&
						b.arcade.swapples.score.g.p &&
						!isNaN(b.arcade.swapples.score.g.p)
							? b.arcade.swapples.score.g.p
							: 0

					return b - a
				})
			},

			function() {
				for (var id in sortable) {
					var value = sortable[id].arcade.swapples.score.g.p
					if (!value) break

					ranking.swapples_record.push({
						u: sortable[id].username,
						v: value,
						m: sortable[id].arcade.swapples.score.g.m,
						t: sortable[id].arcade.swapples.score.g.t,
						r: sortable[id].arcade.swapples.score.g.r,
						d: sortable[id].donated,
					})

					if (ranking.swapples_record.length == limit * 4) break
				}
			},

			function() {
				// swapples.games
				sortable.sort(function(a, b) {
					try {
						a = a.arcade.swapples.games
						if (!a || isNaN(a)) a = 0
					} catch (e) {
						a = 0
					}

					try {
						b = b.arcade.swapples.games
						if (!b || isNaN(b)) b = 0
					} catch (e) {
						b = 0
					}

					return b - a
				})
			},

			function() {
				for (var id in sortable) {
					try {
						var value = sortable[id].arcade.swapples.games
						if (!value || isNaN(value)) value = 0
					} catch (e) {
						var value = 0
					}

					if (!value) break
					ranking.swapples_matches.push({
						u: sortable[id].username,
						v: value,
						d: sortable[id].donated,
					})

					if (ranking.swapples_matches.length == limit * 2) break
				}
			},

			function() {
				// swapples.games
				sortable.sort(function(a, b) {
					try {
						a = a.arcade.skypigs.games
						if (!a || isNaN(a)) a = 0
					} catch (e) {
						a = 0
					}

					try {
						b = b.arcade.skypigs.games
						if (!b || isNaN(b)) b = 0
					} catch (e) {
						b = 0
					}

					return b - a
				})
			},

			function() {
				for (var id in sortable) {
					try {
						var value = sortable[id].arcade.skypigs.games
						if (!value || isNaN(value)) value = 0
					} catch (e) {
						var value = 0
					}

					if (!value) break
					ranking.skypigs_matches.push({
						u: sortable[id].username,
						v: value,
						d: sortable[id].donated,
					})

					if (ranking.skypigs_matches.length == limit * 2) break
				}
			},

			function() {
				sortable.sort(function(a, b) {
					try {
						a = a.arcade.skypigs.score
						if (!a || isNaN(a)) a = 0
					} catch (e) {
						a = 0
					}

					try {
						b = b.arcade.skypigs.score
						if (!b || isNaN(b)) b = 0
					} catch (e) {
						b = 0
					}

					return b - a
				})
			},

			function() {
				for (var id in sortable) {
					try {
						var value = sortable[id].arcade.skypigs.score
						if (!value || isNaN(value)) value = 0
					} catch (e) {
						var value = 0
					}

					if (!value) break
					ranking.skypigs_score.push({
						u: sortable[id].username,
						v: value,
						d: sortable[id].donated,
					})

					if (ranking.skypigs_score.length == limit * 2) break
				}
			},

			function() {
				// cuacka.games
				sortable.sort(function(a, b) {
					try {
						a = a.arcade.cuacka.games
						if (!a || isNaN(a)) a = 0
					} catch (e) {
						a = 0
					}

					try {
						b = b.arcade.cuacka.games
						if (!b || isNaN(b)) b = 0
					} catch (e) {
						b = 0
					}

					return b - a
				})
			},

			function() {
				for (var id in sortable) {
					try {
						var value = sortable[id].arcade.cuacka.games
						if (!value || isNaN(value)) value = 0
					} catch (e) {
						var value = 0
					}

					if (!value) break
					ranking.cuacka_matches.push({
						u: sortable[id].username,
						v: value,
						d: sortable[id].donated,
					})

					if (ranking.cuacka_matches.length == limit * 2) break
				}
			},

			function() {
				sortable.sort(function(a, b) {
					try {
						a = a.arcade.cuacka.score
						if (!a || isNaN(a)) a = 0
					} catch (e) {
						a = 0
					}

					try {
						b = b.arcade.cuacka.score
						if (!b || isNaN(b)) b = 0
					} catch (e) {
						b = 0
					}

					return b - a
				})
			},

			function() {
				for (var id in sortable) {
					try {
						var value = sortable[id].arcade.cuacka.score
						if (!value || isNaN(value)) value = 0
					} catch (e) {
						var value = 0
					}

					if (!value) break
					ranking.cuacka_score.push({
						u: sortable[id].username,
						v: value,
						d: sortable[id].donated,
					})

					if (ranking.cuacka_score.length == limit * 2) break
				}
			},

			function() {
				// tonk3.games
				sortable.sort(function(a, b) {
					try {
						a = a.arcade.tonk3.games
						if (!a || isNaN(a)) a = 0
					} catch (e) {
						a = 0
					}

					try {
						b = b.arcade.tonk3.games
						if (!b || isNaN(b)) b = 0
					} catch (e) {
						b = 0
					}

					return b - a
				})
			},

			function() {
				for (var id in sortable) {
					try {
						var value = sortable[id].arcade.tonk3.games
						if (!value || isNaN(value)) value = 0
					} catch (e) {
						var value = 0
					}

					if (!value) break
					ranking.tonk3_matches.push({
						u: sortable[id].username,
						v: value,
						d: sortable[id].donated,
					})

					if (ranking.tonk3_matches.length == limit * 2) break
				}
			},

			function() {
				// dinglepop.games
				sortable.sort(function(a, b) {
					try {
						a = a.arcade.dinglepop.games
						if (!a || isNaN(a)) a = 0
					} catch (e) {
						a = 0
					}

					try {
						b = b.arcade.dinglepop.games
						if (!b || isNaN(b)) b = 0
					} catch (e) {
						b = 0
					}

					return b - a
				})
			},

			function() {
				for (var id in sortable) {
					try {
						var value = sortable[id].arcade.dinglepop.games
						if (!value || isNaN(value)) value = 0
					} catch (e) {
						var value = 0
					}

					if (!value) break
					ranking.dinglepop_matches.push({
						u: sortable[id].username,
						v: value,
						d: sortable[id].donated,
					})

					if (ranking.dinglepop_matches.length == limit) break
				}
			},

			function() {
				// dinglepop.cleared
				sortable.sort(function(a, b) {
					try {
						a = a.arcade.dinglepop.cleared
						if (!a || isNaN(a)) a = 0
					} catch (e) {
						a = 0
					}

					try {
						b = b.arcade.dinglepop.cleared
						if (!b || isNaN(b)) b = 0
					} catch (e) {
						b = 0
					}

					return b - a
				})
			},

			function() {
				for (var id in sortable) {
					try {
						var value = sortable[id].arcade.dinglepop.cleared
						if (!value || isNaN(value)) value = 0
					} catch (e) {
						var value = 0
					}

					if (!value) break

					ranking.dinglepop_cleared.push({
						u: sortable[id].username,
						v: value,
						d: sortable[id].donated,
					})

					if (ranking.dinglepop_cleared.length == limit) break
				}
			},

			function() {
				// dinglepop.items
				sortable.sort(function(a, b) {
					try {
						a = a.arcade.dinglepop.items
						if (!a || isNaN(a)) a = 0
					} catch (e) {
						a = 0
					}

					try {
						b = b.arcade.dinglepop.items
						if (!b || isNaN(b)) b = 0
					} catch (e) {
						b = 0
					}

					return b - a
				})
			},

			function() {
				for (var id in sortable) {
					try {
						var value = sortable[id].arcade.dinglepop.items
						if (!value || isNaN(value)) value = 0
					} catch (e) {
						var value = 0
					}

					if (!value) break

					ranking.dinglepop_items.push({
						u: sortable[id].username,
						v: value,
						d: sortable[id].donated,
					})

					if (ranking.dinglepop_items.length == limit) break
				}
			},

			function() {
				// dinglepop.drops
				sortable.sort(function(a, b) {
					try {
						a = a.arcade.dinglepop.drops
						if (!a || isNaN(a)) a = 0
					} catch (e) {
						a = 0
					}

					try {
						b = b.arcade.dinglepop.drops
						if (!b || isNaN(b)) b = 0
					} catch (e) {
						b = 0
					}

					return b - a
				})
			},

			function() {
				for (var id in sortable) {
					try {
						var value = sortable[id].arcade.dinglepop.drops
						if (!value || isNaN(value)) value = 0
					} catch (e) {
						var value = 0
					}

					if (!value) break
					ranking.dinglepop_drops.push({
						u: sortable[id].username,
						v: value,
						d: sortable[id].donated,
					})

					if (ranking.dinglepop_drops.length == limit) break
				}
			},

			function() {
				// blockles.games
				sortable.sort(function(a, b) {
					try {
						a = a.arcade.blockles.games
						if (!a || isNaN(a)) a = 0
					} catch (e) {
						a = 0
					}

					try {
						b = b.arcade.blockles.games
						if (!b || isNaN(b)) b = 0
					} catch (e) {
						b = 0
					}

					return b - a
				})
			},

			function() {
				for (var id in sortable) {
					try {
						var value = sortable[id].arcade.blockles.games
						if (!value || isNaN(value)) value = 0
					} catch (e) {
						var value = 0
					}

					if (!value) break
					ranking.blockles_matches.push({
						u: sortable[id].username,
						v: value,
						d: sortable[id].donated,
					})

					if (ranking.blockles_matches.length == limit) break
				}
			},

			function() {
				// blockles.score
				sortable.sort(function(a, b) {
					try {
						a = a.arcade.blockles.score
						if (!a || isNaN(a)) a = 0
					} catch (e) {
						a = 0
					}

					try {
						b = b.arcade.blockles.score
						if (!b || isNaN(b)) b = 0
					} catch (e) {
						b = 0
					}

					return b - a
				})
			},

			function() {
				for (var id in sortable) {
					try {
						var value = sortable[id].arcade.blockles.score
						if (!value || isNaN(value)) value = 0
					} catch (e) {
						var value = 0
					}

					if (!value) break
					ranking.blockles_record.push({
						u: sortable[id].username,
						v: value,
						d: sortable[id].donated,
					})

					if (ranking.blockles_record.length == limit) break
				}
			},

			function() {
				// gemmers.games
				sortable.sort(function(a, b) {
					try {
						a = a.arcade.gemmers.games
						if (!a || isNaN(a)) a = 0
					} catch (e) {
						a = 0
					}

					try {
						b = b.arcade.gemmers.games
						if (!b || isNaN(b)) b = 0
					} catch (e) {
						b = 0
					}

					return b - a
				})
			},

			function() {
				for (var id in sortable) {
					try {
						var value = sortable[id].arcade.gemmers.games
						if (!value || isNaN(value)) value = 0
					} catch (e) {
						var value = 0
					}

					if (!value) break
					ranking.gemmers_matches.push({
						u: sortable[id].username,
						v: value,
						d: sortable[id].donated,
					})

					if (ranking.gemmers_matches.length == limit) break
				}
			},

			function() {
				// gemmers.score
				sortable.sort(function(a, b) {
					try {
						a = a.arcade.gemmers.score
						if (!a || isNaN(a)) a = 0
					} catch (e) {
						a = 0
					}

					try {
						b = b.arcade.gemmers.score
						if (!b || isNaN(b)) b = 0
					} catch (e) {
						b = 0
					}

					return b - a
				})
			},

			function() {
				for (var id in sortable) {
					try {
						var value = sortable[id].arcade.gemmers.score
						if (!value || isNaN(value)) value = 0
					} catch (e) {
						var value = 0
					}

					if (!value) break
					ranking.gemmers_record.push({
						u: sortable[id].username,
						v: value,
						d: sortable[id].donated,
					})

					if (ranking.gemmers_record.length == limit) break
				}
			},

			function() {
				// pool.games
				sortable.sort(function(a, b) {
					try {
						a = a.arcade.pool.games
						if (!a || isNaN(a)) a = 0
					} catch (e) {
						a = 0
					}

					try {
						b = b.arcade.pool.games
						if (!b || isNaN(b)) b = 0
					} catch (e) {
						b = 0
					}

					return b - a
				})
			},

			function() {
				for (var id in sortable) {
					try {
						var value = sortable[id].arcade.pool.games
						if (!value || isNaN(value)) value = 0
					} catch (e) {
						var value = 0
					}

					if (!value) break
					ranking.ball8_matches.push({
						u: sortable[id].username,
						v: value,
						d: sortable[id].donated,
					})

					if (ranking.ball8_matches.length == limit) break
				}
			},

			function() {
				// checkers.games
				sortable.sort(function(a, b) {
					try {
						a = a.arcade.checkers.games
						if (!a || isNaN(a)) a = 0
					} catch (e) {
						a = 0
					}

					try {
						b = b.arcade.checkers.games
						if (!b || isNaN(b)) b = 0
					} catch (e) {
						b = 0
					}

					return b - a
				})
			},

			function() {
				for (var id in sortable) {
					try {
						var value = sortable[id].arcade.checkers.games
						if (!value || isNaN(value)) value = 0
					} catch (e) {
						var value = 0
					}

					if (!value) break
					ranking.checkers_matches.push({
						u: sortable[id].username,
						v: value,
						d: sortable[id].donated,
					})

					if (ranking.checkers_matches.length == limit) break
				}
			},

			function() {
				// checkers.games
				sortable.sort(function(a, b) {
					try {
						a = a.arcade.balloono.games
						if (!a || isNaN(a)) a = 0
					} catch (e) {
						a = 0
					}

					try {
						b = b.arcade.balloono.games
						if (!b || isNaN(b)) b = 0
					} catch (e) {
						b = 0
					}

					return b - a
				})
			},

			function() {
				for (var id in sortable) {
					try {
						var value = sortable[id].arcade.balloono.games
						if (!value || isNaN(value)) value = 0
					} catch (e) {
						var value = 0
					}

					if (!value) break
					ranking.balloono_matches.push({
						u: sortable[id].username,
						v: value,
						d: sortable[id].donated,
					})

					if (ranking.balloono_matches.length == limit) break
				}
			},

			function() {
				// balloono_percent
				sortable.sort(function(a, b) {
					try {
						a = +(a.arcade.balloono.win / (a.arcade.balloono.games / 100)).toFixed(4)
						if (!a || isNaN(a)) a = 0
					} catch (e) {
						a = 0
					}

					try {
						b = +(b.arcade.balloono.win / (b.arcade.balloono.games / 100)).toFixed(4)
						if (!b || isNaN(b)) b = 0
					} catch (e) {
						b = 0
					}

					return b - a
				})
			},

			function() {
				for (var id in sortable) {
					try {
						if (sortable[id].arcade.balloono.games < 500) continue
					} catch (e) {
						continue
					}

					try {
						var value = +(
							sortable[id].arcade.balloono.win /
							(sortable[id].arcade.balloono.games / 100)
						).toFixed(4)
						if (!value || isNaN(value)) value = 0
					} catch (e) {
						var value = 0
					}

					if (!value) break
					ranking.balloono_percent.push({
						u: sortable[id].username,
						v: value,
						d: sortable[id].donated,
					})

					if (ranking.balloono_percent.length == limit) break
				}
			},

			function() {
				// balloono.win
				sortable.sort(function(a, b) {
					try {
						a = a.arcade.balloono.win
						if (!a || isNaN(a)) a = 0
					} catch (e) {
						a = 0
					}

					try {
						b = b.arcade.balloono.win
						if (!b || isNaN(b)) b = 0
					} catch (e) {
						b = 0
					}

					return b - a
				})
			},

			function() {
				for (var id in sortable) {
					try {
						var value = sortable[id].arcade.balloono.win
						if (!value || isNaN(value)) value = 0
					} catch (e) {
						var value = 0
					}

					if (!value) break
					ranking.balloono_wins.push({
						u: sortable[id].username,
						v: value,
						d: sortable[id].donated,
					})
					if (ranking.balloono_wins.length == limit) break
				}
			},

			function() {
				// checkers.games
				sortable.sort(function(a, b) {
					try {
						a = a.arcade.balloonoboot.games
						if (!a || isNaN(a)) a = 0
					} catch (e) {
						a = 0
					}

					try {
						b = b.arcade.balloonoboot.games
						if (!b || isNaN(b)) b = 0
					} catch (e) {
						b = 0
					}

					return b - a
				})
			},

			function() {
				for (var id in sortable) {
					try {
						var value = sortable[id].arcade.balloonoboot.games
						if (!value || isNaN(value)) value = 0
					} catch (e) {
						var value = 0
					}

					if (!value) break
					ranking.balloonoboot_matches.push({
						u: sortable[id].username,
						v: value,
						d: sortable[id].donated,
					})

					if (ranking.balloonoboot_matches.length == limit) break
				}
			},

			function() {
				// balloonoboot_percent
				sortable.sort(function(a, b) {
					try {
						a = +(a.arcade.balloonoboot.win / (a.arcade.balloonoboot.games / 100)).toFixed(4)
						if (!a || isNaN(a)) a = 0
					} catch (e) {
						a = 0
					}

					try {
						b = +(b.arcade.balloonoboot.win / (b.arcade.balloonoboot.games / 100)).toFixed(4)
						if (!b || isNaN(b)) b = 0
					} catch (e) {
						b = 0
					}

					return b - a
				})
			},

			function() {
				for (var id in sortable) {
					try {
						if (sortable[id].arcade.balloonoboot.games < 500) continue
					} catch (e) {
						continue
					}

					try {
						var value = +(
							sortable[id].arcade.balloonoboot.win /
							(sortable[id].arcade.balloonoboot.games / 100)
						).toFixed(4)
						if (!value || isNaN(value)) value = 0
					} catch (e) {
						var value = 0
					}

					if (!value) break
					ranking.balloonoboot_percent.push({
						u: sortable[id].username,
						v: value,
						d: sortable[id].donated,
					})

					if (ranking.balloonoboot_percent.length == limit) break
				}
			},

			function() {
				// balloonoboot.win
				sortable.sort(function(a, b) {
					try {
						a = a.arcade.balloonoboot.win
						if (!a || isNaN(a)) a = 0
					} catch (e) {
						a = 0
					}

					try {
						b = b.arcade.balloonoboot.win
						if (!b || isNaN(b)) b = 0
					} catch (e) {
						b = 0
					}

					return b - a
				})
			},

			function() {
				for (var id in sortable) {
					try {
						var value = sortable[id].arcade.balloonoboot.win
						if (!value || isNaN(value)) value = 0
					} catch (e) {
						var value = 0
					}

					if (!value) break
					ranking.balloonoboot_wins.push({
						u: sortable[id].username,
						v: value,
						d: sortable[id].donated,
					})
					if (ranking.balloonoboot_wins.length == limit) break
				}
			},

			function() {
				// checkers.games
				sortable.sort(function(a, b) {
					try {
						a = a.arcade.blocklesmulti.games
						if (!a || isNaN(a)) a = 0
					} catch (e) {
						a = 0
					}

					try {
						b = b.arcade.blocklesmulti.games
						if (!b || isNaN(b)) b = 0
					} catch (e) {
						b = 0
					}

					return b - a
				})
			},

			function() {
				for (var id in sortable) {
					try {
						var value = sortable[id].arcade.blocklesmulti.games
						if (!value || isNaN(value)) value = 0
					} catch (e) {
						var value = 0
					}

					if (!value) break
					ranking.blocklesmulti_matches.push({
						u: sortable[id].username,
						v: value,
						d: sortable[id].donated,
					})

					if (ranking.blocklesmulti_matches.length == limit) break
				}
			},

			function() {
				// blocklesmulti_percent
				sortable.sort(function(a, b) {
					try {
						a = +(a.arcade.blocklesmulti.win / (a.arcade.blocklesmulti.games / 100)).toFixed(4)
						if (!a || isNaN(a)) a = 0
					} catch (e) {
						a = 0
					}

					try {
						b = +(b.arcade.blocklesmulti.win / (b.arcade.blocklesmulti.games / 100)).toFixed(4)
						if (!b || isNaN(b)) b = 0
					} catch (e) {
						b = 0
					}

					return b - a
				})
			},

			function() {
				for (var id in sortable) {
					try {
						if (sortable[id].arcade.blocklesmulti.games < 250) continue
					} catch (e) {
						continue
					}

					try {
						var value = +(
							sortable[id].arcade.blocklesmulti.win /
							(sortable[id].arcade.blocklesmulti.games / 100)
						).toFixed(4)
						if (!value || isNaN(value)) value = 0
					} catch (e) {
						var value = 0
					}

					if (!value) break
					ranking.blocklesmulti_percent.push({
						u: sortable[id].username,
						v: value,
						d: sortable[id].donated,
					})

					if (ranking.blocklesmulti_percent.length == limit) break
				}
			},

			function() {
				// blocklesmulti.win
				sortable.sort(function(a, b) {
					try {
						a = a.arcade.blocklesmulti.win
						if (!a || isNaN(a)) a = 0
					} catch (e) {
						a = 0
					}

					try {
						b = b.arcade.blocklesmulti.win
						if (!b || isNaN(b)) b = 0
					} catch (e) {
						b = 0
					}

					return b - a
				})
			},

			function() {
				for (var id in sortable) {
					try {
						var value = sortable[id].arcade.blocklesmulti.win
						if (!value || isNaN(value)) value = 0
					} catch (e) {
						var value = 0
					}

					if (!value) break
					ranking.blocklesmulti_wins.push({
						u: sortable[id].username,
						v: value,
						d: sortable[id].donated,
					})
					if (ranking.blocklesmulti_wins.length == limit) break
				}
			},

			function() {
				// checkers_percent
				sortable.sort(function(a, b) {
					try {
						a = +(a.arcade.checkers.win / (a.arcade.checkers.games / 100)).toFixed(4)
						if (!a || isNaN(a)) a = 0
					} catch (e) {
						a = 0
					}

					try {
						b = +(b.arcade.checkers.win / (b.arcade.checkers.games / 100)).toFixed(4)
						if (!b || isNaN(b)) b = 0
					} catch (e) {
						b = 0
					}

					return b - a
				})
			},

			function() {
				for (var id in sortable) {
					try {
						if (sortable[id].arcade.checkers.games < 100) continue
					} catch (e) {
						continue
					}

					try {
						var value = +(
							sortable[id].arcade.checkers.win /
							(sortable[id].arcade.checkers.games / 100)
						).toFixed(4)
						if (!value || isNaN(value)) value = 0
					} catch (e) {
						var value = 0
					}

					if (!value) break
					ranking.checkers_percent.push({
						u: sortable[id].username,
						v: value,
						d: sortable[id].donated,
					})

					if (ranking.checkers_percent.length == limit) break
				}
			},

			function() {
				// checkers.win
				sortable.sort(function(a, b) {
					try {
						a = a.arcade.checkers.win
						if (!a || isNaN(a)) a = 0
					} catch (e) {
						a = 0
					}

					try {
						b = b.arcade.checkers.win
						if (!b || isNaN(b)) b = 0
					} catch (e) {
						b = 0
					}

					return b - a
				})
			},

			function() {
				for (var id in sortable) {
					try {
						var value = sortable[id].arcade.checkers.win
						if (!value || isNaN(value)) value = 0
					} catch (e) {
						var value = 0
					}

					if (!value) break
					ranking.checkers_wins.push({
						u: sortable[id].username,
						v: value,
						d: sortable[id].donated,
					})
					if (ranking.checkers_wins.length == limit) break
				}
			},

			function() {
				// pool.win
				sortable.sort(function(a, b) {
					try {
						a = a.arcade.pool.win
						if (!a || isNaN(a)) a = 0
					} catch (e) {
						a = 0
					}

					try {
						b = b.arcade.pool.win
						if (!b || isNaN(b)) b = 0
					} catch (e) {
						b = 0
					}

					return b - a
				})
			},

			function() {
				for (var id in sortable) {
					try {
						var value = sortable[id].arcade.pool.win
						if (!value || isNaN(value)) value = 0
					} catch (e) {
						var value = 0
					}

					if (!value) break
					ranking.ball8_wins.push({
						u: sortable[id].username,
						v: value,
						d: sortable[id].donated,
					})

					if (ranking.ball8_wins.length == limit) break
				}
			},

			function() {
				// pool.record
				sortable.sort(function(a, b) {
					try {
						a = +a.arcade.pool.record.replace(/[^0-9]/g, '').trim()
						if (!a || isNaN(a)) a = 0
					} catch (e) {
						a = 0
					}

					try {
						b = +b.arcade.pool.record.replace(/[^0-9]/g, '').trim()
						if (!b || isNaN(b)) b = 0
					} catch (e) {
						b = 0
					}

					return a - b
				})
			},

			function() {
				for (var id in sortable) {
					try {
						var value = +sortable[id].arcade.pool.record.replace(/[^0-9]/g, '').trim()
						if (!value || isNaN(value)) value = 0
					} catch (e) {
						var value = 0
					}

					if (value === 0) continue
					ranking.ball8_record.push({
						u: sortable[id].username,
						v: sortable[id].arcade.pool.record,
						d: sortable[id].donated,
					})

					if (ranking.ball8_record.length == limit) break
				}
			},

			function() {
				// ball8_loses
				sortable.sort(function(a, b) {
					try {
						a = a.arcade.pool.games - a.arcade.pool.win
						if (!a || isNaN(a)) a = 0
					} catch (e) {
						a = 0
					}

					try {
						b = b.arcade.pool.games - b.arcade.pool.win
						if (!b || isNaN(b)) b = 0
					} catch (e) {
						b = 0
					}

					return b - a
				})
			},

			function() {
				for (var id in sortable) {
					try {
						var value = sortable[id].arcade.pool.games - sortable[id].arcade.pool.win
						if (!value || isNaN(value)) value = 0
					} catch (e) {
						var value = 0
					}

					if (!value) break
					ranking.ball8_loses.push({
						u: sortable[id].username,
						v: value,
						d: sortable[id].donated,
					})

					if (ranking.ball8_loses.length == limit) break
				}
			},

			function() {
				// ball8_percent
				sortable.sort(function(a, b) {
					try {
						a = +(a.arcade.pool.win / (a.arcade.pool.games / 100)).toFixed(4)
						if (!a || isNaN(a)) a = 0
					} catch (e) {
						a = 0
					}

					try {
						b = +(b.arcade.pool.win / (b.arcade.pool.games / 100)).toFixed(4)
						if (!b || isNaN(b)) b = 0
					} catch (e) {
						b = 0
					}

					return b - a
				})
			},

			function() {
				for (var id in sortable) {
					try {
						if (sortable[id].arcade.pool.games < 500) continue
					} catch (e) {
						continue
					}

					try {
						var value = +(
							sortable[id].arcade.pool.win /
							(sortable[id].arcade.pool.games / 100)
						).toFixed(4)
						if (!value || isNaN(value)) value = 0
					} catch (e) {
						var value = 0
					}

					if (!value) break
					ranking.ball8_percent.push({
						u: sortable[id].username,
						v: value,
						d: sortable[id].donated,
					})

					if (ranking.ball8_percent.length == limit) break
				}
			},

			function() {
				// dinglepop_cleared percent
				sortable.sort(function(a, b) {
					try {
						a = +(a.arcade.dinglepop.cleared / (a.arcade.dinglepop.games / 100)).toFixed(4)
						if (!a || isNaN(a)) a = 0
					} catch (e) {
						a = 0
					}

					try {
						b = +(b.arcade.dinglepop.cleared / (b.arcade.dinglepop.games / 100)).toFixed(4)
						if (!b || isNaN(b)) b = 0
					} catch (e) {
						b = 0
					}

					return b - a
				})
			},

			function() {
				for (var id in sortable) {
					try {
						if (sortable[id].arcade.dinglepop.games < 250) continue
					} catch (e) {
						continue
					}

					try {
						var value = +(
							sortable[id].arcade.dinglepop.cleared /
							(sortable[id].arcade.dinglepop.games / 100)
						).toFixed(4)
						if (!value || isNaN(value)) value = 0
					} catch (e) {
						var value = 0
					}

					if (!value) break
					ranking.dinglepop_percent.push({
						u: sortable[id].username,
						v: value,
						d: sortable[id].donated,
					})

					if (ranking.dinglepop_percent.length == limit) break
				}
			},

			function() {
				// 9ball'].games
				sortable.sort(function(a, b) {
					try {
						a = a.arcade['9ball'].games
						if (!a || isNaN(a)) a = 0
					} catch (e) {
						a = 0
					}

					try {
						b = b.arcade['9ball'].games
						if (!b || isNaN(b)) b = 0
					} catch (e) {
						b = 0
					}

					return b - a
				})
			},

			function() {
				for (var id in sortable) {
					try {
						var value = sortable[id].arcade['9ball'].games
						if (!value || isNaN(value)) value = 0
					} catch (e) {
						var value = 0
					}

					if (!value) break
					ranking.ball9_matches.push({
						u: sortable[id].username,
						v: value,
						d: sortable[id].donated,
					})

					if (ranking.ball9_matches.length == limit) break
				}
			},

			function() {
				// ball9_wins
				sortable.sort(function(a, b) {
					try {
						a = a.arcade['9ball'].win
						if (!a || isNaN(a)) a = 0
					} catch (e) {
						a = 0
					}

					try {
						b = b.arcade['9ball'].win
						if (!b || isNaN(b)) b = 0
					} catch (e) {
						b = 0
					}

					return b - a
				})
			},

			function() {
				for (var id in sortable) {
					try {
						var value = sortable[id].arcade['9ball'].win
						if (!value || isNaN(value)) value = 0
					} catch (e) {
						var value = 0
					}

					if (!value) break
					ranking.ball9_wins.push({
						u: sortable[id].username,
						v: value,
						d: sortable[id].donated,
					})

					if (ranking.ball9_wins.length == limit) break
				}
			},

			function() {
				// ball9_record
				sortable.sort(function(a, b) {
					try {
						a = +a.arcade['9ball'].record.replace(/[^0-9]/g, '').trim()
						if (!a || isNaN(a)) a = 0
					} catch (e) {
						a = 0
					}

					try {
						b = +b.arcade['9ball'].record.replace(/[^0-9]/g, '').trim()
						if (!b || isNaN(b)) b = 0
					} catch (e) {
						b = 0
					}

					return a - b
				})
			},

			function() {
				for (var id in sortable) {
					try {
						var value = +sortable[id].arcade['9ball'].record.replace(/[^0-9]/g, '').trim()
						if (!value || isNaN(value)) value = 0
					} catch (e) {
						var value = 0
					}

					if (value === 0) continue
					ranking.ball9_record.push({
						u: sortable[id].username,
						v: sortable[id].arcade['9ball'].record,
						d: sortable[id].donated,
					})

					if (ranking.ball9_record.length == limit) break
				}
			},

			function() {
				// ball9_loses
				sortable.sort(function(a, b) {
					try {
						a = a.arcade['9ball'].games - a.arcade['9ball'].win
						if (!a || isNaN(a)) a = 0
					} catch (e) {
						a = 0
					}

					try {
						b = b.arcade['9ball'].games - b.arcade['9ball'].win
						if (!b || isNaN(b)) b = 0
					} catch (e) {
						b = 0
					}

					return b - a
				})
			},

			function() {
				for (var id in sortable) {
					try {
						var value = sortable[id].arcade['9ball'].games - sortable[id].arcade['9ball'].win
						if (!value || isNaN(value)) value = 0
					} catch (e) {
						var value = 0
					}

					if (!value) break
					ranking.ball9_loses.push({
						u: sortable[id].username,
						v: value,
						d: sortable[id].donated,
					})

					if (ranking.ball9_loses.length == limit) break
				}
			},

			function() {
				// ball9_percent
				sortable.sort(function(a, b) {
					try {
						a = +(a.arcade['9ball'].win / (a.arcade['9ball'].games / 100)).toFixed(4)
						if (!a || isNaN(a)) a = 0
					} catch (e) {
						a = 0
					}

					try {
						b = +(b.arcade['9ball'].win / (b.arcade['9ball'].games / 100)).toFixed(4)
						if (!b || isNaN(b)) b = 0
					} catch (e) {
						b = 0
					}

					return b - a
				})
			},

			function() {
				for (var id in sortable) {
					try {
						if (sortable[id].arcade['9ball'].games < 250) continue
					} catch (e) {
						continue
					}

					try {
						var value = +(
							sortable[id].arcade['9ball'].win /
							(sortable[id].arcade['9ball'].games / 100)
						).toFixed(4)
						if (!value || isNaN(value)) value = 0
					} catch (e) {
						var value = 0
					}

					if (!value) break
					ranking.ball9_percent.push({
						u: sortable[id].username,
						v: value,
						d: sortable[id].donated,
					})

					if (ranking.ball9_percent.length == limit) break
				}
			},

			function() {
				// youtube
				sortable.sort(function(a, b) {
					try {
						a = a.arcade.yt.c
						if (!a || isNaN(a)) a = 0
					} catch (e) {
						a = 0
					}

					try {
						b = b.arcade.yt.c
						if (!b || isNaN(b)) b = 0
					} catch (e) {
						b = 0
					}

					return b - a
				})
			},

			function() {
				for (var id in sortable) {
					try {
						var value = sortable[id].arcade.yt.c
						if (!value || isNaN(value)) value = 0
					} catch (e) {
						var value = 0
					}

					if (!value) break
					ranking.yt.push({
						u: sortable[id].username,
						v: value,
						d: sortable[id].donated,
					})

					if (ranking.yt.length > 108) break
				}
				users_banned.ranking.data = compress(ranking)
			},
		]

		u.run_functions_delayed(functions)
	} else {
		if (callback) callback(users_banned.ranking.data)
	}
}

Socket.prototype.get_sockets_for_username = function(username) {
	var sockets = []
	var id = Object.keys(io.sockets.connected)
	for (var i = 0, l = id.length; i < l; i++) {
		if (io.sockets.connected[id[i]].u.username === username) {
			sockets.push(io.sockets.connected[id[i]])
		}
	}

	return sockets
}
Socket.prototype.get_sockets_indexed = function() {
	if (!io) return {}
	else {
		var sockets = {}
		var id = Object.keys(io.sockets.connected)
		for (var i = 0, l = id.length; i < l; i++) {
			if (!sockets[io.sockets.connected[id[i]].u.username]) {
				sockets[io.sockets.connected[id[i]].u.username] = []
			}
			sockets[io.sockets.connected[id[i]].u.username].push(io.sockets.connected[id[i]])
		}
		return sockets
	}
}

Socket.prototype.get_sockets_for_ip = function(socket, ip) {
	var sockets = []
	var id = Object.keys(io.sockets.connected)
	for (var i = 0, l = id.length; i < l; i++) {
		if (io.sockets.connected[id[i]].IP === ip) {
			sockets.push(io.sockets.connected[id[i]])
		}
	}

	return sockets
}

Socket.prototype.get_sockets_for_id = function(socket, id) {
	var sockets = []
	var id = Object.keys(io.sockets.connected)
	for (var i = 0, l = id.length; i < l; i++) {
		if (io.sockets.connected[id[i]].ID === id) {
			sockets.push(io.sockets.connected[id[i]])
		}
	}

	return sockets
}

Socket.prototype.get_sockets_for_room = function(socket, room_id) {
	var sockets = []
	var id = Object.keys(io.sockets.connected)
	for (var i = 0, l = id.length; i < l; i++) {
		if (io.sockets.connected[id[i]].ROOM == room_id) {
			sockets.push(io.sockets.connected[id[i]])
		}
	}

	return sockets
}

Socket.prototype.get_sockets_for_user_in_room = function(socket, room_id, username, id, idu) {
	var sockets = []
	var _sockets = Socket.get_sockets_for_room(socket, room_id)
	for (var id in _sockets) {
		if (_sockets[id].u.username == username) sockets.push(_sockets[id])
		else if (id && _sockets[id].ID == id) sockets.push(_sockets[id])
		else if (idu && _sockets[id].IDU == idu) sockets.push(_sockets[id])
	}

	return sockets
}

Socket.prototype.get_sockets_for_ip_or_id_or_username = function(socket, v) {
	var sockets = []
	var id = Object.keys(io.sockets.connected)
	for (var i = 0, l = id.length; i < l; i++) {
		if (
			io.sockets.connected[id[i]].u.username === v ||
			io.sockets.connected[id[i]].ID === v ||
			io.sockets.connected[id[i]].IDU === v ||
			io.sockets.connected[id[i]].IP === v
		)
			sockets.push(io.sockets.connected[id[i]])
	}

	return sockets
}

Socket.prototype.game_swapples = function(socket, data) {
	if (rooms[socket.ROOM]) {
		if (!rooms[socket.ROOM].round.data[socket.u.id]) rooms[socket.ROOM].round.data[socket.u.id] = {}

		switch (data.f) {
			case 's': {
				if (!rooms[socket.ROOM].round.data[socket.u.id].s)
					rooms[socket.ROOM].round.data[socket.u.id].s = 0
				rooms[socket.ROOM].round.data[socket.u.id].s += +data.d
				if (u.now - rooms[socket.ROOM].round.updated > 500) {
					rooms[socket.ROOM].round.updated = u.now
					io.to(socket.ROOM).emit('a', {
						id: 'rd',
						data: rooms[socket.ROOM].round.data,
					})
				}

				break
			}

			case 'sr': {
				rooms[socket.ROOM].round.data[socket.u.id].s = 0
				delete rooms[socket.ROOM].round.data[socket.u.id].d

				rooms[socket.ROOM].round.updated = u.now
				io.to(socket.ROOM).emit('a', {
					id: 'rd',
					data: rooms[socket.ROOM].round.data,
				})

				break
			}

			case 'd':
				{
					if (!rooms[socket.ROOM].round.data[socket.u.id].d) {
						if (!rooms[socket.ROOM].round.data[socket.u.id].s)
							rooms[socket.ROOM].round.data[socket.u.id].s = 0
						rooms[socket.ROOM].round.data[socket.u.id].d = 1
						io.to(socket.ROOM).emit('a', {
							id: 'rd',
							data: rooms[socket.ROOM].round.data,
						})
						if (usernames[socket.u.username]) {
							var user = usernames[socket.u.username]
							if (!user.arcade) user.arcade = {}

							if (!user.arcade.swapples) user.arcade.swapples = {}

							if (!user.arcade.swapples.games) user.arcade.swapples.games = 0
							user.arcade.swapples.games++
							if (!user.arcade.swapples.score) user.arcade.swapples.score = {}

							if (!user.arcade.swapples.score.g) user.arcade.swapples.score.g = {}

							if (!user.arcade.swapples.score.g.p) user.arcade.swapples.score.g.p = 0
							if (+data.s != rooms[socket.ROOM].round.data[socket.u.id].s) {
							} else {
								if (user.arcade.swapples.score.g.p < rooms[socket.ROOM].round.data[socket.u.id].s) {
									user.arcade.swapples.score.g.p = rooms[socket.ROOM].round.data[socket.u.id].s
									user.arcade.swapples.score.g.r = rooms[socket.ROOM].round.seed
									user.arcade.swapples.score.g.t = +data.t
									user.arcade.swapples.score.g.m = +data.m

									Socket.chat_room_mobc(
										socket,
										Socket.record_name() + ' Record ' + +data.s + ' ' + socket.u.username + '!',
									)
								}
							}
						}
					}
				}

				break
		}
	}
}

Socket.prototype.game_loonobum = function(socket, data) {
	if (rooms[socket.ROOM]) {
		socket.broadcast.to(socket.ROOM).emit('a', {
			id: 'lb',
			data: data,
		})
	}
}

var Poker = require('pokersolver').Hand

/*
	var hand1 = Hand.solve(['Ad', 'As', 'Jc', 'Th', '2d', '3c', 'Kd']);
	var hand2 = Hand.solve(['Ad', 'As', 'Jc', 'Th', '2d', 'Qs', 'Qd']);
	var winner = Hand.winners([hand1, hand2]); // hand2
	var hand = Hand.solve(['Ad', 'As', 'Jc', 'Th', '2d', 'Qs', 'Qd']);

console.log(hand.name); // Two Pair
console.log(hand.descr); // Two Pair, A's & Q's

*/

var deck = [
	'10c',
	'10d',
	'10h',
	'10s',
	'2c',
	'2d',
	'2h',
	'2s',
	'3c',
	'3d',
	'3h',
	'3s',
	'4c',
	'4d',
	'4h',
	'4s',
	'5c',
	'5d',
	'5h',
	'5s',
	'6c',
	'6d',
	'6h',
	'6s',
	'7c',
	'7d',
	'7h',
	'7s',
	'8c',
	'8d',
	'8h',
	'8s',
	'9c',
	'9d',
	'9h',
	'9s',
	'Ac',
	'Ad',
	'Ah',
	'As',
	'Jc',
	'Jd',
	'Jh',
	'Js',
	'Kc',
	'Kd',
	'Kh',
	'Ks',
	'Qc',
	'Qd',
	'Qh',
	'Qs',
	/*'back',
'back@2x',
'black_joker',
'red_joker'*/
]
var POKER = {
	room_id: {
		users: { Tito: { cards: ['2c', '2d'] }, 'SuGaR+SpIcE': { cards: ['2c', '2d'] } },
		turn: 'Tito',
		blinds: 200, // * 2
		table: ['2c', '2d', '2d', '2d', '2d'],
	},
}
Socket.prototype.game_poker = function(socket, data) {
	if (rooms[socket.ROOM]) {
		if (!POKER[socket.ROOM]) {
			POKER[socket.ROOM] = { blinds: 100, turnfor: 0 }
		}
		var room = rooms[socket.ROOM]
		var poker = POKER[socket.ROOM]

		if (!poker.table) {
			Socket.chat_room_mobc(socket, 'Good Luck!')

			poker.users = {}
			// shuffle
			var deck = u.shuffle([...deck])

			// draw
			room.users.forEach(function(user) {
				if (!user.spectator) {
					poker.users[user.username] = { cards: [deck.pop(), deck.pop()] }

					var sockets = Socket.get_sockets_for_user_in_room(socket, socket.ROOM, user.username)
					for (var id in sockets) {
						sockets[id].emit('a', {
							id: 'pkcards',
							data: poker.users[user.username].cards,
						})
					}
				}
			})

			poker.table = [deck.pop(), deck.pop(), deck.pop()]
			deck.pop()
			poker.table.push(deck.pop())
			deck.pop()
			poker.table.push(deck.pop())
		}

		// should bet?
	}
	/*
		switch (data.f) {
			case 's': {
				if (!rooms[socket.ROOM].round.data[socket.u.id].s)
					rooms[socket.ROOM].round.data[socket.u.id].s = 0
				rooms[socket.ROOM].round.data[socket.u.id].s += +data.d
				if (u.now - rooms[socket.ROOM].round.updated > 500) {
					rooms[socket.ROOM].round.updated = u.now
					io.to(socket.ROOM).emit('a', {
						id: 'rd',
						data: rooms[socket.ROOM].round.data,
					})
				}

				break
			}
		}*/
}

Socket.prototype.game_cuacka = function(socket, data) {
	if (rooms[socket.ROOM]) {
		if (!rooms[socket.ROOM].round.data[socket.u.id]) rooms[socket.ROOM].round.data[socket.u.id] = {}

		switch (data.f) {
			case 's': {
				delete rooms[socket.ROOM].round.data[socket.u.id].d
				if (!rooms[socket.ROOM].round.data[socket.u.id].s)
					rooms[socket.ROOM].round.data[socket.u.id].s = 0
				rooms[socket.ROOM].round.data[socket.u.id].s = +data.s
				if (u.now - rooms[socket.ROOM].round.updated > 850) {
					rooms[socket.ROOM].round.updated = u.now
					io.to(socket.ROOM).emit('a', {
						id: 'rd',
						data: rooms[socket.ROOM].round.data,
					})
				}

				break
			}

			case 'sr': {
				rooms[socket.ROOM].round.data[socket.u.id].s = 0
				delete rooms[socket.ROOM].round.data[socket.u.id].d

				io.to(socket.ROOM).emit('a', {
					id: 'rd',
					data: rooms[socket.ROOM].round.data,
				})

				break
			}

			case 'd':
				{
					if (!rooms[socket.ROOM].round.data[socket.u.id].d) {
						data.s = +data.s
						if (!rooms[socket.ROOM].round.data[socket.u.id].s)
							rooms[socket.ROOM].round.data[socket.u.id].s = 0
						rooms[socket.ROOM].round.data[socket.u.id].s = data.s
						rooms[socket.ROOM].round.data[socket.u.id].d = 1
						io.to(socket.ROOM).emit('a', {
							id: 'rd',
							data: rooms[socket.ROOM].round.data,
						})
						if (usernames[socket.u.username]) {
							var user = usernames[socket.u.username]
							if (!user.arcade) user.arcade = {}

							if (!user.arcade.cuacka) user.arcade.cuacka = {}

							if (!user.arcade.cuacka.games) user.arcade.cuacka.games = 0
							user.arcade.cuacka.games++
							if (!user.arcade.cuacka.score) user.arcade.cuacka.score = 0

							if (user.arcade.cuacka.score < data.s) {
								user.arcade.cuacka.score = data.s
								Socket.chat_room_mobc(
									socket,
									Socket.record_name() + ' Record Score ' + data.s + ' ' + socket.u.username + '!',
								)
							}
						}
					}
				}

				break
		}
	}
}

Socket.prototype.game_gemmers = function(socket, data) {
	if (rooms[socket.ROOM]) {
		if (!rooms[socket.ROOM].round.data[socket.u.id]) rooms[socket.ROOM].round.data[socket.u.id] = {}

		switch (data.f) {
			case 's': {
				if (!rooms[socket.ROOM].round.data[socket.u.id].s)
					rooms[socket.ROOM].round.data[socket.u.id].s = 0
				rooms[socket.ROOM].round.data[socket.u.id].s += +data.d
				if (u.now - rooms[socket.ROOM].round.updated > 850) {
					rooms[socket.ROOM].round.updated = u.now
					io.to(socket.ROOM).emit('a', {
						id: 'rd',
						data: rooms[socket.ROOM].round.data,
					})
				}

				break
			}

			case 'd': {
				if (!rooms[socket.ROOM].round.data[socket.u.id].d) {
					if (!rooms[socket.ROOM].round.data[socket.u.id].s)
						rooms[socket.ROOM].round.data[socket.u.id].s = 0
					rooms[socket.ROOM].round.data[socket.u.id].d = 1
					io.to(socket.ROOM).emit('a', {
						id: 'rd',
						data: rooms[socket.ROOM].round.data,
					})
					if (usernames[socket.u.username]) {
						var user = usernames[socket.u.username]
						if (!user.arcade) user.arcade = {}

						if (!user.arcade.gemmers) user.arcade.gemmers = {}

						if (!user.arcade.gemmers.games) user.arcade.gemmers.games = 0
						user.arcade.gemmers.games++
						if (!user.arcade.gemmers.score) user.arcade.gemmers.score = 0
						if (user.arcade.gemmers.score < rooms[socket.ROOM].round.data[socket.u.id].s) {
							user.arcade.gemmers.score = rooms[socket.ROOM].round.data[socket.u.id].s
							Socket.chat_room_mobc(
								socket,
								Socket.record_name() + ' Record Score ' + socket.u.username + '!',
							)
						}
					}
				}

				break
			}
		}
	}
}
// project https://console.developers.google.com/apis/library/youtube.googleapis.com
// screen https://omgmobc.com/php/image.php?url=https%3A%2F%2Fs.draw.uy%2F58f5352477.png

Socket.prototype.youtube_requests = 1
Socket.prototype.youtube_keys_original = [
	// wade
	'AIzaSyD1htKsjzYgi5fwu8vfC9ih3hIEzf7dIXw',
	// emz
	'AIzaSyB1xKNvceqlcAsd-CKDLQ7Wt0WnoAuYbvA',
	// tito
	'AIzaSyC_klVtXTEffwhbk7Xx0PNf7etbiSUgqIY',
	// mobc
	'AIzaSyAfjHV6dvgdd6ztatklluKA3y5oFtK_nNg',
	// foxy
	'AIzaSyA9-32LdaJHcx8UWKT5bdUidken2o0bA7Y',
	// draw
	'AIzaSyAWYNGffz8xCkOITtN4ugfg8HVRb_tyYRY',
	// tao
	'AIzaSyCk15tJMHGLqS2Jo53slK-JwVATzG8O1Cs',
	// tornado
	'AIzaSyCfYyitt8l4o5ArE6WizR64MTTmZ6aXPfw',
	//tesd
	'AIzaSyATtZFPXG8uwMuLqJu9eiKGT6jzCD_A5ao',
	// adri
	'AIzaSyBn40Cz1qE59xkljXpruP2UXEyOFSJADxA',
]
Socket.prototype.youtube_keys = JSON.parse(JSON.stringify(Socket.prototype.youtube_keys_original))
Socket.prototype.youtube_api_key = function() {
	this.youtube_requests++
	return this.youtube_keys[Math.floor(this.youtube_requests % this.youtube_keys.length)]
}

Socket.prototype.game_wts = function(socket, data, aCallback) {
	if (rooms[socket.ROOM]) {
		data.s = u.value(data.s).toLowerCase()

		if (users_banned.YTCache[data.s]) {
			aCallback(users_banned.YTCache[data.s])
			youtube.update_search({
				search: data.s,
				date: u.now,
			})
		} else {
			function search(term) {
				var key = Socket.youtube_api_key()
				if (key) {
					fetch(
						'https://www.googleapis.com/youtube/v3/search?part=snippet&videoEmbeddable=true&type=video&maxResults=20&fields=items(id,snippet(title,thumbnails(default(url))))&key=' +
							key +
							(term.indexOf('long') !== -1 ? '&videoDuration=long' : '') +
							'&q=' +
							encodeURIComponent(term.indexOf('long') !== -1 ? term.replace(/long/, '') : term),
					)
						.then(function(res) {
							if (res.status == 403) {
								u.removeValueFromArray(Socket.youtube_keys, key)
								search(term)
							} else {
								res.json().then(function(body) {
									try {
										youtube.insert_search({
											search: term,
											result: JSON.stringify(body.items),
											date: u.now,
										})
									} catch (e) {}
									if (term.length < 30) {
										users_banned.YTCache[term] = body.items
										aCallback(users_banned.YTCache[term])
									} else {
										aCallback(body.items)
									}
								})
							}
						})
						.catch(function(res) {
							if (res.status == 403) {
								u.removeValueFromArray(Socket.youtube_keys, key)
								search(term)
							} else {
								search(term)
							}
						})
				}
			}
			var r = youtube.select_search({
				search: data.s,
			})

			if (r.length) {
				users_banned.YTCache[data.s] = JSON.parse(r[0].result)
				aCallback(users_banned.YTCache[data.s])
				youtube.update_search({
					search: data.s,
					date: u.now,
				})
			} else {
				search(data.s)
			}
		}
	}
}

Socket.prototype.game_wt = function(socket, data) {
	if (rooms[socket.ROOM]) {
		if (rooms[socket.ROOM].users[0] == socket.u) {
			if (data.d.s !== 0 && data.d.s !== 1) data.d.s = 1

			data.d.n = u.value(data.d.n)
			data.d.v = u.value(data.d.v)
			data.d.t = +data.d.t
			data.d.p = +data.d.p
			data.d.c = u.now

			if (!rooms[socket.ROOM].round.data) rooms[socket.ROOM].round.data = {}

			rooms[socket.ROOM].round.data[data.d.p] = data.d
			rooms[socket.ROOM].now = u.now

			if (data.d.s === 0) {
			} else if (data.d.s === 1) {
				if (rooms[socket.ROOM].round.data.last_video != data.d.n) {
					rooms[socket.ROOM].round.data.last_video = data.d.n
					Socket.chat_room_game(socket, socket.u.username + '@' + data.d.n)
				}

				rooms[socket.ROOM].name = rooms[socket.ROOM].name_original
					? rooms[socket.ROOM].name_original + '' + data.d.n
					: data.d.n

				rooms[socket.ROOM].ytname = data.d.n

				if (!socket.LAME && usernames[socket.u.username]) {
					if (!usernames[socket.u.username].arcade) usernames[socket.u.username].arcade = {}

					if (!usernames[socket.u.username].arcade.yt) usernames[socket.u.username].arcade.yt = {}

					if (!usernames[socket.u.username].arcade.yt.c)
						usernames[socket.u.username].arcade.yt.c = 0
					if (!usernames[socket.u.username].arcade.yt.w)
						usernames[socket.u.username].arcade.yt.w = u.now
					if (u.now - usernames[socket.u.username].arcade.yt.w > 120000)
						usernames[socket.u.username].arcade.yt.c++
					usernames[socket.u.username].arcade.yt.w = u.now
				}
			}

			if (users_banned.YTCache['related.' + data.d.v]) {
				rooms[socket.ROOM].round.data[data.d.p].related =
					users_banned.YTCache['related.' + data.d.v]
				youtube.update_related({
					related: data.d.v,
					date: u.now,
				})
			} else {
				function related(term) {
					var key = Socket.youtube_api_key()
					if (key) {
						fetch(
							'https://www.googleapis.com/youtube/v3/search?part=snippet&videoEmbeddable=true&type=video&maxResults=20&topicId=/m/04rlf&fields=items(id,snippet(title,thumbnails(default(url))))&relatedToVideoId=' +
								encodeURIComponent(term) +
								'&key=' +
								key,
						)
							.then(function(res) {
								if (res.status == 403) {
									u.removeValueFromArray(Socket.youtube_keys, key)
									related(term)
								} else {
									res.json().then(function(body) {
										youtube.insert_related({
											related: term,
											result: JSON.stringify(body.items),
											date: u.now,
										})
										if (socket && socket.ROOM && rooms[socket.ROOM]) {
											users_banned.YTCache['related.' + term] = body.items
											rooms[socket.ROOM].round.data[data.d.p].related =
												users_banned.YTCache['related.' + term]
											io.to(socket.ROOM).emit('a', {
												id: 'room',
												room: rooms[socket.ROOM],
											})
										}
									})
								}
							})
							.catch(function(res) {
								if (res.status == 403) {
									u.removeValueFromArray(Socket.youtube_keys, key)
									related(term)
								} else {
									related(term)
								}
							})
					}
				}
				var r = youtube.select_related({
					related: data.d.v,
				})

				if (r.length) {
					users_banned.YTCache['related.' + data.d.v] = JSON.parse(r[0].result)
					rooms[socket.ROOM].round.data[data.d.p].related =
						users_banned.YTCache['related.' + data.d.v]
					youtube.update_related({
						related: data.d.v,
						date: u.now,
					})
				} else {
					related(data.d.v)
				}
			}

			io.to(socket.ROOM).emit('a', {
				id: 'room',
				room: rooms[socket.ROOM],
			})
		}
	}
}

Socket.prototype.game_tonk3 = function(socket, data) {
	if (rooms[socket.ROOM]) {
		if (!rooms[socket.ROOM].round.data[socket.u.id]) rooms[socket.ROOM].round.data[socket.u.id] = {}

		switch (data.f) {
			case 'snm': {
				data.d.u = socket.u.username
				socket.broadcast.to(socket.ROOM).emit('a', {
					id: 'embed',
					f: 'pnmJS',
					d: data.d,
				})
				break
			}

			case 'd': {
				if (!rooms[socket.ROOM].round.data[socket.u.id].d) {
					rooms[socket.ROOM].round.data[socket.u.id].d = 1

					if (usernames[socket.u.username]) {
						var user = usernames[socket.u.username]
						if (!user.arcade) user.arcade = {}

						if (!user.arcade.tonk3) user.arcade.tonk3 = {}

						if (!user.arcade.tonk3.games) user.arcade.tonk3.games = 0
						user.arcade.tonk3.games++
					}

					if (rooms[socket.ROOM].users[0] == socket.u) {
						Socket.chat_room_game(socket, 'Game ended')
						var room_id = socket.ROOM
						setTimeout(function() {
							if (rooms[room_id]) {
								rooms[room_id].started = false

								Socket.room_reset_spectators(rooms[room_id])
								io.to(room_id).emit('a', {
									id: 'room',
									room: rooms[room_id],
								})
							}
						}, 6000)
					}
				}

				break
			}
		}
	}
}

Socket.prototype.game_skypigs = function(socket, data) {
	if (rooms[socket.ROOM]) {
		if (!rooms[socket.ROOM].round.data[socket.u.id]) rooms[socket.ROOM].round.data[socket.u.id] = {}

		switch (data.f) {
			case 'snm': {
				data.d.u = socket.u.username

				if (data.d.data.type == 'distraction') {
					io.to(socket.ROOM).emit('a', {
						id: 'embed',
						f: 'pnmJS',
						d: data.d,
					})
				} else {
					socket.broadcast.to(socket.ROOM).emit('a', {
						id: 'embed',
						f: 'pnmJS',
						d: data.d,
					})
					if (data.d.data.type == 'finished') {
						rooms[socket.ROOM].round.data[socket.u.id].d = 1

						if (usernames[socket.u.username]) {
							var user = usernames[socket.u.username]
							if (!user.arcade) user.arcade = {}

							if (!user.arcade.skypigs) user.arcade.skypigs = {}

							if (!user.arcade.skypigs.games) user.arcade.skypigs.games = 0
							if (!user.arcade.skypigs.score) user.arcade.skypigs.score = 0

							Socket.chat_room_mobc(
								socket,
								socket.u.username + ' Traveled ' + data.d.data.score + ' feet',
							)

							if (user.arcade.skypigs.score < data.d.data.score) {
								user.arcade.skypigs.score = +data.d.data.score
								Socket.chat_room_mobc(
									socket,
									Socket.record_name() + ' Record Score ' + socket.u.username + '!',
								)
							}
						}

						var alive = false
						for (var id in rooms[socket.ROOM].round.data) {
							if (!rooms[socket.ROOM].round.data[id].d) {
								alive = true
								break
							}
						}

						if (!alive) {
							Socket.chat_room_game(socket, 'Game ended')
							var room_id = socket.ROOM
							setTimeout(function() {
								if (rooms[room_id]) {
									rooms[room_id].started = false
									Socket.room_reset_spectators(rooms[room_id])
									for (var i = 0, l = rooms[room_id].users.length; i < l; i++) {
										if (usernames[rooms[room_id].users[i].username]) {
											if (!usernames[rooms[room_id].users[i].username].arcade)
												usernames[rooms[room_id].users[i].username].arcade = {}

											if (!usernames[rooms[room_id].users[i].username].arcade.skypigs)
												usernames[rooms[room_id].users[i].username].arcade.skypigs = {}

											if (!usernames[rooms[room_id].users[i].username].arcade.skypigs.games)
												usernames[rooms[room_id].users[i].username].arcade.skypigs.games = 0
											usernames[rooms[room_id].users[i].username].arcade.skypigs.games++
										}
									}

									io.to(room_id).emit('a', {
										id: 'room',
										room: rooms[room_id],
									})
								}
							}, 4000)
						}
					} else if (data.d.data.type == 'alive') {
						delete rooms[socket.ROOM].round.data[socket.u.id].d
					}
				}

				break
			}
		}
	}
}

Socket.prototype.game_blockles = function(socket, data) {
	if (rooms[socket.ROOM]) {
		if (!rooms[socket.ROOM].round.data[socket.u.id]) rooms[socket.ROOM].round.data[socket.u.id] = {}

		switch (data.f) {
			case 's': {
				if (!rooms[socket.ROOM].round.data[socket.u.id].s)
					rooms[socket.ROOM].round.data[socket.u.id].s = 0

				if (+data.d === 4) data.d = 6
				else if (+data.d === 3) data.d = 4

				rooms[socket.ROOM].round.data[socket.u.id].s += +data.d
				if (u.now - rooms[socket.ROOM].round.updated > 850) {
					rooms[socket.ROOM].round.updated = u.now
					io.to(socket.ROOM).emit('a', {
						id: 'rd',
						data: rooms[socket.ROOM].round.data,
					})
				}

				break
			}

			case 'sr': {
				delete rooms[socket.ROOM].round.data[socket.u.id].d
				rooms[socket.ROOM].round.data[socket.u.id].s = 0

				if (u.now - rooms[socket.ROOM].round.updated > 850) {
					rooms[socket.ROOM].round.updated = u.now
					io.to(socket.ROOM).emit('a', {
						id: 'rd',
						data: rooms[socket.ROOM].round.data,
					})
				}

				break
			}

			case 'd': {
				if (!rooms[socket.ROOM].round.data[socket.u.id].d) {
					if (!rooms[socket.ROOM].round.data[socket.u.id].s)
						rooms[socket.ROOM].round.data[socket.u.id].s = 0
					rooms[socket.ROOM].round.data[socket.u.id].d = 1
					io.to(socket.ROOM).emit('a', {
						id: 'rd',
						data: rooms[socket.ROOM].round.data,
					})
					if (usernames[socket.u.username]) {
						var user = usernames[socket.u.username]
						if (!user.arcade) user.arcade = {}

						if (!user.arcade.blockles) user.arcade.blockles = {}

						if (!user.arcade.blockles.games) user.arcade.blockles.games = 0
						user.arcade.blockles.games++
						if (!user.arcade.blockles.score) user.arcade.blockles.score = 0
						if (user.arcade.blockles.score < rooms[socket.ROOM].round.data[socket.u.id].s) {
							user.arcade.blockles.score = rooms[socket.ROOM].round.data[socket.u.id].s
							Socket.chat_room_mobc(
								socket,
								Socket.record_name() +
									' Record  Score ' +
									user.arcade.blockles.score +
									', ' +
									socket.u.username +
									'!',
							)
						}
					}
				}

				break
			}
		}
	}
}

Socket.prototype.game_blocklesmulti = function(socket, data) {
	if (rooms[socket.ROOM]) {
		if (!rooms[socket.ROOM].round.data[socket.u.id]) rooms[socket.ROOM].round.data[socket.u.id] = {}

		switch (data.f) {
			case 'd': {
				data.d.sender = socket.u.username
				socket.broadcast.to(socket.ROOM).emit('a', {
					id: 'embed',
					f: 'pnmJS',
					d: data.d,
				})

				if (data.d.type && (data.d.type == 'matchOver' || data.d.type == 'gameOver')) {
					var room_id = socket.ROOM

					if (data.d.type == 'gameOver') {
						var user = usernames[socket.u.username]
						if (user) {
							if (!user.arcade) user.arcade = {}

							if (!user.arcade.blocklesmulti) user.arcade.blocklesmulti = {}

							if (!user.arcade.blocklesmulti.games) user.arcade.blocklesmulti.games = 0
							user.arcade.blocklesmulti.games++
							if (!user.arcade.blocklesmulti.win) user.arcade.blocklesmulti.win = 0
						}
					}

					/*	Socket.chat_room_game(
						{
							ROOM: room_id
						},
						socket.u.username + ' is Game Over'
					)*/

					if (!rooms[room_id].round.data.die_tracker) rooms[room_id].round.data.die_tracker = {}

					rooms[room_id].round.data.die_tracker[socket.u.username] = true

					var everyone_died = true // we assume everyone died unless proven different
					for (var i = 0, l = rooms[room_id].users.length; i < l; i++) {
						if (
							!rooms[room_id].users[i].spectator &&
							!rooms[room_id].round.data.die_tracker[rooms[room_id].users[i].username]
						) {
							everyone_died = false
						}
					}

					if (rooms[room_id] && rooms[room_id].started && everyone_died) {
						setTimeout(function() {
							if (rooms[room_id] && rooms[room_id].started) {
								rooms[room_id].started = false

								Socket.room_reset_spectators(rooms[room_id])
								io.to(room_id).emit('a', {
									id: 'room',
									room: rooms[room_id],
								})
							}
						}, 4000)
					}
				}

				if (data.d.type && data.d.type == 'matchOverWins') {
					var room_id = socket.ROOM

					var user = usernames[data.d.name]
					if (user) {
						if (!user.arcade) user.arcade = {}

						if (!user.arcade.blocklesmulti) user.arcade.blocklesmulti = {}

						if (!user.arcade.blocklesmulti.games) user.arcade.blocklesmulti.games = 0
						user.arcade.blocklesmulti.games++
						if (!user.arcade.blocklesmulti.win) user.arcade.blocklesmulti.win = 0
						user.arcade.blocklesmulti.win++
					}

					// this is the autorotation
					if (rooms[room_id].users.length > 7) {
						var rotate = rooms[room_id].users.length - 7
						for (var a = 0; a < rotate; a++) {
							rooms[room_id].users.splice(
								rooms[room_id].users.length,
								0,
								rooms[room_id].users.splice(0, 1)[0],
							)
						}
					}

					Socket.chat_room_game(
						{
							ROOM: socket.ROOM,
						},
						data.d.name + ' wins!',
					)

					/*Socket.room_reset_spectators(rooms[room_id])
					io.to(room_id).emit('a', {
						id: 'room',
						room: rooms[room_id]
					})*/

					// when someone wins we also stop the match
					if (rooms[room_id] && rooms[room_id].started) {
						setTimeout(function() {
							if (rooms[room_id] && rooms[room_id].started) {
								rooms[room_id].started = false

								Socket.room_reset_spectators(rooms[room_id])
								io.to(room_id).emit('a', {
									id: 'room',
									room: rooms[room_id],
								})
							}
						}, 4000)
					}
				}

				break
			}
		}
	}
}

Socket.prototype.room_playing = function(socket) {
	return rooms[socket.ROOM].users.reduce(function(acumulator, user) {
		if (user.game_status === GAME_STATUS_PLAYING) acumulator += 1
		return acumulator
	}, 0)
}
Socket.prototype.game_balloono = function(socket, data) {
	if (rooms[socket.ROOM]) {
		switch (data.f) {
			case 'snm': {
				for (var id in data.d) {
					data.d[id].sender = socket.u.username
				}

				io.to(socket.ROOM).emit('a', {
					id: 'embed',
					f: 'pnmJS',
					d: data.d,
				})

				break
			}

			case 'chat': {
				if (!rooms[socket.ROOM].round.data.died) rooms[socket.ROOM].round.data.died = {}
				if (!rooms[socket.ROOM].round.data.deaded) rooms[socket.ROOM].round.data.deaded = []

				if (
					data.d.died &&
					!rooms[socket.ROOM].round.data.died[data.d.died] &&
					!rooms[socket.ROOM].round.data.gameover
				) {
					rooms[socket.ROOM].round.data.died[data.d.died] = 1
					rooms[socket.ROOM].round.data.deaded.push(data.d.died)
					var died = random_value([
						'¡x.X!',
						'¡X.x!',
						'¡x.x!',
						'¡r.P!',
						'¡R.p!',
						'¡x_X!',
						'¡X_X!',
						'¡x_x!',
						'¡X_x!',
						'¡P_P!',
						'¡P_P!',
						'¡PoP!',
					])
					Socket.chat_room_game(socket, data.d.died + ' ' + died)
					// if the player is not playing alone
					var playing = Socket.room_playing(socket)
					if (playing > 1 && usernames[data.d.died]) {
						var user = usernames[data.d.died]
						if (!user.arcade) user.arcade = {}

						if (!user.arcade[rooms[socket.ROOM].game]) user.arcade[rooms[socket.ROOM].game] = {}

						if (!user.arcade[rooms[socket.ROOM].game].games)
							user.arcade[rooms[socket.ROOM].game].games = 0
						user.arcade[rooms[socket.ROOM].game].games++
						if (!user.arcade[rooms[socket.ROOM].game].win)
							user.arcade[rooms[socket.ROOM].game].win = 0
						if (!user.arcade[rooms[socket.ROOM].game].lose)
							user.arcade[rooms[socket.ROOM].game].lose = 0
						user.arcade[rooms[socket.ROOM].game].lose++
					}
					if (playing < 3) {
						Socket.game_balloono(socket, { d: { gameover: 1 }, f: 'chat' })
					}
				} else if (data.d.gameover && !rooms[socket.ROOM].round.data.gameover) {
					rooms[socket.ROOM].round.data.gameover = true

					var winners = []
					for (var id in rooms[socket.ROOM].users) {
						if (
							rooms[socket.ROOM].round.data.died[rooms[socket.ROOM].users[id].username] ||
							rooms[socket.ROOM].users[id].game_status != GAME_STATUS_PLAYING
						) {
							continue
						}
						winners.push(rooms[socket.ROOM].users[id].username)
						break
					}

					while (winners.length < 3 && rooms[socket.ROOM].round.data.deaded.length) {
						winners.push(rooms[socket.ROOM].round.data.deaded.shift())
					}

					if (winners[0] && !rooms[socket.ROOM].round.data.died[winners[0]]) {
						Socket.chat_room_game(socket, winners[0] + ' wins!')
						Socket.room_medals(socket, { d: { gold: winners[0] } })
						var user = usernames[winners[0]]
						if (!user.arcade) user.arcade = {}

						if (!user.arcade[rooms[socket.ROOM].game]) user.arcade[rooms[socket.ROOM].game] = {}

						if (!user.arcade[rooms[socket.ROOM].game].games)
							user.arcade[rooms[socket.ROOM].game].games = 0
						user.arcade[rooms[socket.ROOM].game].games++
						if (!user.arcade[rooms[socket.ROOM].game].win)
							user.arcade[rooms[socket.ROOM].game].win = 0
						user.arcade[rooms[socket.ROOM].game].win++
						if (!user.arcade[rooms[socket.ROOM].game].lose)
							user.arcade[rooms[socket.ROOM].game].lose = 0
					}
					if (winners[1]) {
						Socket.room_medals(socket, { d: { silver: winners[1] } })
					}
					if (winners[2]) {
						Socket.room_medals(socket, { d: { bronze: winners[2] } })
					}

					if (rooms[socket.ROOM].users.length > 6) {
						for (var a = 0; a < rooms[socket.ROOM].users.length - 6; a++) {
							rooms[socket.ROOM].users.splice(
								rooms[socket.ROOM].users.length,
								0,
								rooms[socket.ROOM].users.splice(0, 1)[0],
							)
						}
					}

					Socket.chat_room_game(socket, 'Game over!')
					var room_id = socket.ROOM
					setTimeout(function() {
						if (rooms[room_id]) {
							rooms[room_id].started = false
							Socket.room_reset_spectators(rooms[room_id])
							io.to(room_id).emit('a', {
								id: 'room',
								room: rooms[room_id],
							})
						}
					}, 6000)
				}

				break
			}
		}
	}
}

Socket.prototype.game_balloonoboot = function(socket, data) {
	if (rooms[socket.ROOM]) {
		if (!rooms[socket.ROOM].round.data[socket.u.id]) rooms[socket.ROOM].round.data[socket.u.id] = {}

		switch (data.f) {
			case 'snm': {
				if (data.d.pdc) {
					rooms[socket.ROOM].round.data[socket.u.id].d = 1
					Socket.chat_room_game(socket, socket.u.username + '  ¡x.X!')
					var room_id = socket.ROOM
					setTimeout(function() {
						Socket.game_balloonoboot_game_over_check(room_id)
					}, 1300)
					if (usernames[socket.u.username]) {
						var user = usernames[socket.u.username]
						if (!user.arcade) user.arcade = {}

						if (!user.arcade.balloonoboot) user.arcade.balloonoboot = {}

						if (!user.arcade.balloonoboot.games) user.arcade.balloonoboot.games = 0
						user.arcade.balloonoboot.games++
					}
				}

				data.d.u = socket.u.username
				socket.broadcast.to(socket.ROOM).emit('a', {
					id: 'embed',
					f: 'pnmJS',
					d: data.d,
				})

				break
			}

			case 'gl': {
				if (data.t === undefined || data.v !== 2) {
					Socket.chat_room_mobc(socket, socket.u.username + ' using old version of game, refresh.')
				} else {
					Socket.chat_room_game(
						socket,
						socket.u.username.replace(/^Lame /, '') + ' loaded v' + data.g,
					)

					rooms[socket.ROOM].round.loaded[socket.u.username] = true

					var all_loaded = true,
						i = 0,
						l
					for (l = rooms[socket.ROOM].users.length; i < l && i < 6; i++) {
						if (!rooms[socket.ROOM].round.loaded[rooms[socket.ROOM].users[i].username]) {
							all_loaded = false
							break
						}
					}

					if (all_loaded && rooms[socket.ROOM].started) {
						Socket.game_balloonoboot_start_it(socket.ROOM)
					}
				}

				break
			}
		}
	}
}
Socket.prototype.game_balloonoboot_start_it = function(room_id) {
	if (rooms[room_id] && rooms[room_id].started && rooms[room_id].round.did_start === false) {
		rooms[room_id].can_stop = true
		rooms[room_id].round.did_start = true
		var i, l
		for (i = 0, l = rooms[room_id].users.length; i < l; i++) {
			if (!rooms[room_id].round.loaded[rooms[room_id].users[i].username])
				rooms[room_id].users[i].spectator = true
		}

		var new_users = []
		for (i = 0, l = rooms[room_id].users.length; i < l; i++) {
			if (!rooms[room_id].users[i].spectator) new_users.push(rooms[room_id].users[i])
		}

		for (i = 0, l = rooms[room_id].users.length; i < l; i++) {
			if (rooms[room_id].users[i].spectator) new_users.push(rooms[room_id].users[i])
		}

		rooms[room_id].users = new_users
		rooms[room_id].round.startTime = u.now
		Socket.update_room(null, room_id)

		io.to(room_id).emit('a', {
			id: 'embed',
			f: 'startBalloono',
		})
	}
}

Socket.prototype.game_balloonoboot_game_over_check = function(room_id) {
	if (rooms[room_id]) {
		var not_done = 0
		var username = ''
		for (var a = 0, l = rooms[room_id].users.length; a < l; a++) {
			if (
				!rooms[room_id].users[a].spectator &&
				(!rooms[room_id].round.data[rooms[room_id].users[a].id] ||
					!rooms[room_id].round.data[rooms[room_id].users[a].id].d)
			) {
				not_done++
				username = rooms[room_id].users[a].username
			}
		}

		if (not_done <= 1) {
			if (!rooms[room_id].finished) {
				rooms[room_id].finished = true
				Socket.chat_room_game(
					{
						ROOM: room_id,
					},
					'Game ended',
				)
				if (username != '') {
					Socket.chat_room_game(
						{
							ROOM: room_id,
						},
						username + ' Wins!',
					)
					if (usernames[username]) {
						var user = usernames[username]
						if (!user.arcade) user.arcade = {}

						if (!user.arcade.balloonoboot) user.arcade.balloonoboot = {}

						if (!user.arcade.balloonoboot.games) user.arcade.balloonoboot.games = 0
						user.arcade.balloonoboot.games++
						if (!user.arcade.balloonoboot.win) user.arcade.balloonoboot.win = 0
						user.arcade.balloonoboot.win++
					}
				}

				if (rooms[room_id].users.length > 6) {
					var rotate = rooms[room_id].users.length - 6
					for (var a = 0; a < rotate; a++) {
						rooms[room_id].users.splice(
							rooms[room_id].users.length,
							0,
							rooms[room_id].users.splice(0, 1)[0],
						)
					}
				}

				setTimeout(function() {
					if (rooms[room_id]) {
						rooms[room_id].started = false
						Socket.room_reset_spectators(rooms[room_id])
						io.to(room_id).emit('a', {
							id: 'room',
							room: rooms[room_id],
						})
					}
				}, 4000)
			}
		}
	}
}

Socket.prototype.game_dinglepop = function(socket, data) {
	if (rooms[socket.ROOM]) {
		if (!rooms[socket.ROOM].round.data[socket.u.id]) rooms[socket.ROOM].round.data[socket.u.id] = {}

		switch (data.f) {
			case 's': {
				if (/^[0-9,]+$/.test(data.d)) {
					rooms[socket.ROOM].round.data[socket.u.id].s = data.d
					if (u.now - rooms[socket.ROOM].round.updated > 850) {
						rooms[socket.ROOM].round.updated = u.now
						io.to(socket.ROOM).emit('a', {
							id: 'rd',
							data: rooms[socket.ROOM].round.data,
						})
					}
				}

				break
			}

			case 'd': {
				if (!rooms[socket.ROOM].round.data[socket.u.id].d) {
					rooms[socket.ROOM].round.data[socket.u.id].d = 1
					rooms[socket.ROOM].round.done++

					if (usernames[socket.u.username]) {
						var user = usernames[socket.u.username]
						if (!user.arcade) user.arcade = {}

						if (!user.arcade.dinglepop) user.arcade.dinglepop = {}

						if (!user.arcade.dinglepop.games) user.arcade.dinglepop.games = 0
						user.arcade.dinglepop.games++
					}

					io.to(socket.ROOM).emit('a', {
						id: 'rd',
						data: rooms[socket.ROOM].round.data,
					})
				}

				break
			}

			case 'c': {
				if (!rooms[socket.ROOM].round.data[socket.u.id].c) {
					rooms[socket.ROOM].round.data[socket.u.id].c = u.now
					if (usernames[socket.u.username]) {
						var user = usernames[socket.u.username]
						if (!user.arcade) user.arcade = {}

						if (!user.arcade.dinglepop) user.arcade.dinglepop = {}

						if (!user.arcade.dinglepop.cleared) user.arcade.dinglepop.cleared = 0
						user.arcade.dinglepop.cleared++
						if (!rooms[socket.ROOM].round.data[socket.u.id].d) {
							if (!user.arcade.dinglepop.games) user.arcade.dinglepop.games = 0
							user.arcade.dinglepop.games++
						}
					}

					if (!rooms[socket.ROOM].round.data[socket.u.id].d) {
						rooms[socket.ROOM].round.data[socket.u.id].d = 1
						rooms[socket.ROOM].round.done++
					}

					io.to(socket.ROOM).emit('a', {
						id: 'rd',
						data: rooms[socket.ROOM].round.data,
					})
					Socket.chat_room_game(socket, socket.u.username + ' Cleared !'.replace(/Guest/g, ''))
				}

				break
			}

			case 'i': {
				if (usernames[socket.u.username]) {
					var user = usernames[socket.u.username]
					if (!user.arcade) user.arcade = {}

					if (!user.arcade.dinglepop) user.arcade.dinglepop = {}

					if (!user.arcade.dinglepop.items) user.arcade.dinglepop.items = 0
					user.arcade.dinglepop.items++
				}

				io.to(socket.ROOM).emit('a', {
					id: 'embedUser',
					f: 'iJS',
					p: data.p,
					d: data.i,
				})
				if (socket.u.username == data.p) {
					Socket.chat_room_game(
						socket,
						(socket.u.username + ' used ' + data.i.name).replace(/Guest/g, ''),
					)
				} else {
					Socket.chat_room_game(
						socket,
						(socket.u.username + ' used ' + data.i.name + ' on ' + data.p).replace(/Guest/g, ''),
					)
				}

				break
			}

			case 'gi': {
				if (usernames[socket.u.username]) {
					var user = usernames[socket.u.username]
					if (!user.arcade) user.arcade = {}

					if (!user.arcade.dinglepop) user.arcade.dinglepop = {}

					if (!user.arcade.dinglepop.drops) user.arcade.dinglepop.drops = 0
					user.arcade.dinglepop.drops++
				}

				break
			}

			case 'gb': {
				if (rooms[socket.ROOM].users.length == 2) {
					socket.broadcast.to(socket.ROOM).emit('a', {
						id: 'embed',
						f: 'igbJS',
						d: {
							d: data.d,
							g: data.g,
						},
					})
				} else if (rooms[socket.ROOM].users.length > 1) {
					var send_before_hand = 3

					if (!rooms[socket.ROOM].round.sys.sd) {
						rooms[socket.ROOM].round.sys.sd = 0
						rooms[socket.ROOM].round.sys.sg = 0
						rooms[socket.ROOM].round.sys.d = 0
						rooms[socket.ROOM].round.sys.g = 0
						rooms[socket.ROOM].round.sys.td = 0
						rooms[socket.ROOM].round.sys.tg = 0
					}

					var for_players = rooms[socket.ROOM].users.length - rooms[socket.ROOM].round.done - 1
					for_players = for_players ? for_players : 0
					if (data.d != 0) {
						data.dd = 0
						rooms[socket.ROOM].round.sys.sd += data.d
						rooms[socket.ROOM].round.sys.td += data.d
						if (rooms[socket.ROOM].round.sys.td >= for_players) {
							data.dd = send_before_hand
							rooms[socket.ROOM].round.sys.td -= for_players * send_before_hand
						}

						rooms[socket.ROOM].round.sys.d += for_players * data.dd
					}

					if (data.g != 0) {
						data.gg = 0
						rooms[socket.ROOM].round.sys.sg += data.g
						rooms[socket.ROOM].round.sys.tg += data.g
						if (rooms[socket.ROOM].round.sys.tg >= for_players) {
							data.gg = send_before_hand
							rooms[socket.ROOM].round.sys.tg -= for_players * send_before_hand
						}

						rooms[socket.ROOM].round.sys.g += for_players * data.gg
					}

					if (data.dd || data.gg) {
						socket.broadcast.to(socket.ROOM).emit('a', {
							id: 'embed',
							f: 'igbJS',
							d: {
								d: data.dd || 0,
								g: data.gg || 0,
							},
						})
					}
				}

				break
			}
		}
	}
}

Socket.prototype.game_dinglepop2 = function(socket, data) {
	if (rooms[socket.ROOM]) {
		if (!rooms[socket.ROOM].round.data[socket.u.id]) rooms[socket.ROOM].round.data[socket.u.id] = {}

		switch (data.f) {
			case 'snm': {
				data.d.sender = socket.u.username

				socket.broadcast.to(socket.ROOM).emit('a', {
					id: 'embed',
					f: 'pnmJS',
					d: data.d,
				})

				break
			}

			case 'd': {
				Socket.room_reset_spectators(rooms[socket.ROOM])

				if (rooms[socket.ROOM].users.length > 7) {
					var rotate = rooms[socket.ROOM].users.length - 7
					for (var a = 0; a < rotate; a++) {
						rooms[socket.ROOM].users.splice(
							rooms[socket.ROOM].users.length,
							0,
							rooms[socket.ROOM].users.splice(0, 1)[0],
						)
					}
				}

				rooms[socket.ROOM].started = false
				Socket.update_room(socket)
				Socket.chat_room_game(socket, 'Game Over')

				break
			}

			case 'c': {
				Socket.chat_room_game(socket, data.m.replace(/Guest /, ''))
				break
			}
		}
	}
}

Socket.prototype.game_checkers = function(socket, data) {
	if (rooms[socket.ROOM]) {
		if (!rooms[socket.ROOM].round.data[socket.u.id]) rooms[socket.ROOM].round.data[socket.u.id] = {}

		switch (data.f) {
			case 'snm': {
				data.d.sender = socket.u.username
				socket.broadcast.to(socket.ROOM).emit('a', {
					id: 'embed',
					f: 'pnmJS',
					d: data.d,
				})
				break
			}

			case 'c': {
				if (data.m.indexOf('wins!') !== -1 && rooms[socket.ROOM].started) {
					if (rooms[socket.ROOM].users[0] && usernames[rooms[socket.ROOM].users[0].username]) {
						var user = usernames[rooms[socket.ROOM].users[0].username]
						if (!user.arcade) user.arcade = {}

						if (!user.arcade[rooms[socket.ROOM].game]) user.arcade[rooms[socket.ROOM].game] = {}

						if (!user.arcade[rooms[socket.ROOM].game].games)
							user.arcade[rooms[socket.ROOM].game].games = 0
						user.arcade[rooms[socket.ROOM].game].games++
						if (!user.arcade[rooms[socket.ROOM].game].win)
							user.arcade[rooms[socket.ROOM].game].win = 0
						if (data.m == user.username + ' wins!') user.arcade[rooms[socket.ROOM].game].win++
					}

					if (
						rooms[socket.ROOM].users[1] &&
						usernames[rooms[socket.ROOM].users[1].username] &&
						!rooms[socket.ROOM].users[1].spectator
					) {
						var user = usernames[rooms[socket.ROOM].users[1].username]
						if (!user.arcade) user.arcade = {}

						if (!user.arcade[rooms[socket.ROOM].game]) user.arcade[rooms[socket.ROOM].game] = {}

						if (!user.arcade[rooms[socket.ROOM].game].games)
							user.arcade[rooms[socket.ROOM].game].games = 0
						user.arcade[rooms[socket.ROOM].game].games++
						if (!user.arcade[rooms[socket.ROOM].game].win)
							user.arcade[rooms[socket.ROOM].game].win = 0
						if (data.m == user.username + ' wins!') user.arcade[rooms[socket.ROOM].game].win++
					}

					rooms[socket.ROOM].started = false

					Socket.chat_room_game(socket, data.m.replace(/Guest /, ''))
					var room_id = socket.ROOM
					setTimeout(function() {
						if (rooms[room_id]) {
							Socket.room_reset_spectators(rooms[room_id])
							io.to(room_id).emit('a', {
								id: 'room',
								room: rooms[room_id],
							})
						}
					}, 4000)
				}

				break
			}

			case 'd': {
				if (rooms[socket.ROOM].started) {
					var room_id = socket.ROOM

					setTimeout(function() {
						if (rooms[room_id] && rooms[room_id].started) {
							rooms[room_id].started = false

							Socket.chat_room_game(
								{
									ROOM: room_id,
								},
								'Game Over',
							)

							Socket.room_reset_spectators(rooms[room_id])
							io.to(room_id).emit('a', {
								id: 'room',
								room: rooms[room_id],
							})
						}
					}, 4000)
				}

				break
			}
		}
	}
}

Socket.prototype.get_username_from_username = function(username) {
	username = u.value(username)
	if (usernames[username]) return username
	else if (usernames_lower[username.toLowerCase()])
		return usernames_lower[username.toLowerCase()].username
	else if (username === '') return 'Lame Guest'
	else if (/^[0-9]+$/.test(username)) return 'Lame Guest ' + username
	else return username.replace(/^Lame Guest/i, 'Lame Guest')
}

function profile_can_read(socket, user, m) {
	return !socket.MOD &&
		(is_public_mod(user.username) || is_public_mod(m.u)) &&
		u.now - m.d > 3600 * 1000 * 24 * 7
		? false // cannot read anymore after a week
		: (socket.MOD && (is_public_mod(user.username) || is_public_mod(m.u))) ||
				m.u === socket.u.username ||
				user.username === socket.u.username ||
				(!user.private && m.p === 0)
}

Socket.prototype.profile_post_soapbox = function(socket, data, aCallback) {
	var user = usernames[socket.u.username]
	if (user) {
		user.soapbox = u.valueMultiline(data.v, 4000)
		if (aCallback) aCallback()
	}
}

Socket.prototype.profile_reset_password = function(socket, data) {
	data.u = Socket.get_username_from_username(data.u)
	if (socket.MOD && data.u != '' && usernames[data.u]) {
		var user = usernames[data.u]
		if (!mods[user.username]) {
			user.password = u.hash(user.email + '-omgmobc.com')
			LM(socket, 'reset password of ' + Socket.mod_update_link_user(user.username))
			Socket.message(socket, 'success', 'Did reset password of "' + user.username + '"')
		} else {
			LM(
				socket,

				'disallowed to reset password of ' + Socket.mod_update_link_user(user.username),
			)
		}
	} else {
		LM(socket, 'trying to reset password of ' + Socket.mod_update_link_user(data.u))
	}
}

Socket.prototype.profile_rename = function(socket, data, aCallback) {
	data.u = Socket.get_username_from_username(data.u)
	if (socket.MOD && data.u != '' && data.u != 'Lame Guest' && usernames[data.u]) {
		data.to = u.value(data.to, 20).replace(/@.+$/, '')
		if (data.u !== data.to && Socket.is_valid_username(data.to)) {
			var _from = data.u
			var _to = data.to
			var user = usernames[data.u]
			if (
				!mods[user.username] &&
				!mods[data.to] &&
				(!usernames_lower[_to.toLowerCase()] ||
					(_from.toLowerCase() == _to.toLowerCase() && _from != _to))
			) {
				wall.rename_user_to({
					rename_from: _from,
					rename_to: _to,
				})
				wall.rename_user_from({
					rename_from: _from,
					rename_to: _to,
				})

				users_banned.taken_renamed_usernames[_from.toLowerCase()] = _to
				delete users_banned.taken_renamed_usernames[_to.toLowerCase()]
				// we copy because a case change will delete the original username
				var _copy = JSON.parse(JSON.stringify(user))

				delete usernames[_from]
				delete usernames_lower[_from.toLowerCase()]

				usernames[_to] = usernames_lower[_to.toLowerCase()] = users[_copy.email] = _copy
				usernames[_to].username = _to
				usernames[_to].search = (usernames[_to].username + usernames[_to].email)
					.toLowerCase()
					.replace(/\s/g, '')
					.replace(/@.*$/, '')

				if (users_banned.pu[_from]) users_banned.pu[_to] = 'omgmobc.com'

				delete users_banned.pu[_from]

				var groups = Object.keys(users_banned.groups)
				for (var id in groups) {
					var group = users_banned.groups[groups[id]]
					var updated = false
					for (var idx in group.u) {
						if (group.u[idx] == _from) {
							group.u[idx] = _to
							updated = true
						}
					}

					for (var idx in group.m) {
						if (group.m[idx].u == _from) {
							group.m[idx].u = _to
							updated = true
						}
					}
					if (updated) {
						Socket.group_update(group)
					}
				}

				for (var un in usernames) {
					if (usernames[un].followers && usernames[un].followers[_from]) {
						var f = usernames[un].followers[_from]
						delete usernames[un].followers[_from]
						usernames[un].followers[_to] = f
						for (var id in users_online[un]) {
							users_online[un][id].emit('uf', {
								fr: usernames[un].friend,
								fo: usernames[un].followers,
							})
						}
					}
					if (usernames[un].friend && usernames[un].friend[_from]) {
						var f = usernames[un].friend[_from]
						delete usernames[un].friend[_from]
						usernames[un].friend[_to] = f
						for (var id in users_online[un]) {
							users_online[un][id].emit('uf', {
								fr: usernames[un].friend,
								fo: usernames[un].followers,
							})
						}
					}
				}

				var sockets = Socket.get_sockets_for_username(_from)
				for (var id in sockets) {
					sockets[id].emit('r')
				}

				LM(
					socket,

					'renamed user from "' +
						Socket.mod_update_link_user(_from) +
						'" to "' +
						Socket.mod_update_link_user(_to) +
						'"',
				)
				Socket.message(socket, 'success', 'Did rename user')
				aCallback(_to)
			} else {
				Socket.message(socket, 'error', 'Didnt rename user, target user may exists')

				LM(
					socket,

					'disallowed to rename "' +
						Socket.mod_update_link_user(user.username) +
						'" to ' +
						Socket.mod_update_link_user(data.to) +
						'"',
				)
			}
		}
	} else {
		LM(socket, 'trying to rename ' + Socket.mod_update_link_user(data.u))
	}
}

Socket.prototype.profile_remove_unreadable = function(m) {
	var mm = []
	for (var id in m) {
		if (
			!usernames[m[id].u] ||
			users_banned.ban[m[id].u] ||
			(usernames[m[id].u].cleared && m[id].d < usernames[m[id].u].cleared)
		) {
			wall.delete_by_id({ id: m[id].id })
		} else mm.push(m[id])
	}
	return mm
}
Socket.prototype.profile = function(socket, data, aCallback) {
	if (!usernames[data.u] && users_banned.taken_renamed_usernames[data.u.toLowerCase()]) {
		socket.emit(
			'gr',
			'#u/' + encodeURIComponent(users_banned.taken_renamed_usernames[data.u.toLowerCase()]),
		)
		return
	}
	if (data.u == 'Issue Tracker') {
		socket.emit('gr', '#p/Issues')
		return
	}
	if (/^[0-9]+$/.test(data.u)) {
		for (var id in users) {
			if (users[id].id == data.u) {
				socket.emit('gr', '#u/' + encodeURIComponent(users[id].username))
				return
			}
		}
	}

	// if (socket.LAME) return

	data.u = Socket.get_username_from_username(data.u)

	if (data.u.indexOf('Lame Guest') === 0) data.u = 'Lame Guest'
	var user = usernames[data.u]
	if (!user) user = usernames['Lame Guest']
	if (!user.likes) user.likes = 0

	if (user.username != socket.u.username) {
		if (socket.LAME) {
		} else {
			if (
				users_banned.once_likes[user.username + '_' + socket.u.username] !== undefined ||
				users_banned.once_likes[user.username + '_' + socket.IP] !== undefined
			) {
			} else {
				users_banned.once_likes[user.username + '_' + socket.u.username] = null
				users_banned.once_likes[user.username + '_' + socket.IP] = null

				user.likes++
			}
		}
	} else {
		var sockets = Socket.get_sockets_for_username(user.username)
		user.unread = 0
		for (var id in sockets) {
			sockets[id].emit('a', {
				id: 'unread',
				d: 0,
			})
		}
	}

	var m = wall.select({ to_username: user.username })

	var mm = []
	for (var id in m) {
		if (profile_can_read(socket, user, m[id]) && usernames[m[id].u]) {
			m[id].c = usernames[m[id].u].color || ''
			m[id].i = usernames[m[id].u].image || ''
			m[id].b = usernames[m[id].u].cover || ''
			m[id].t = usernames[m[id].u].ccolor || ''

			m[id].ud = usernames[m[id].u].donated || ''
			mm.push(m[id])
		}
	}

	Socket.profile_callback(socket, mm, user, aCallback)
}
Socket.prototype.profile_post = function(socket, data, aCallback) {
	if (socket.MOD) data.v = u.valueMultiline(data.v, 50000)
	else data.v = u.valueMultiline(data.v, 4000)

	data.u = Socket.get_username_from_username(data.u)

	if (
		!socket.LAME &&
		data.v != '' &&
		socket.ID != '' &&
		socket.IDU != '' &&
		usernames[socket.u.username] &&
		!users_banned.ban[data.u]
	) {
		if (data.u.indexOf('Lame Guest') === 0) data.u = 'Lame Guest'
		var user = usernames[data.u]
		if (!user) user = usernames['Lame Guest']
		if (!is_public_mod(user.username)) {
			if (!Socket.user_is_confirmed(socket)) return
		}

		if (socket.u.username === 'omgmobc.com') {
		} else {
			if (!user.block) user.block = {}

			if (users_banned.ban[user.username]) {
				socket.emit('a', {
					id: 'messages',
					type: 'system',
					message: 'You cannot post on this profile.',
				})
				return
			}

			if (did_i_block_user(user.username, socket.u.username)) {
				socket.emit('a', {
					id: 'messages',
					type: 'system',
					message: 'You cannot post on this profile, this user blocked you.',
				})
				return
			}
		}

		if (socket.u.username === 'omgmobc.com' || user.username == socket.u.username) {
		} else {
			if (!user.friend) {
				user.friend = {}
			}

			if (
				!user.wallf ||
				user.username == 'omgmobc.com' ||
				(socket.MOD && mods[user.username]) ||
				(user.wallf && user.friend[socket.u.username])
			) {
				// nothing
			} else {
				socket.emit('a', {
					id: 'messages',
					type: 'system',
					message: 'Wall is writable by friends only.',
				})
				return
			}
		}
		if (
			socket.VPN &&
			!socket.MOD &&
			!users_banned.white[socket.u.username] &&
			user.username !== 'omgmobc.com'
		) {
		} else {
			wall.insert({
				u: socket.u.username,
				d: u.now,
				m: data.v,
				p: is_public_mod(user.username) || data.p ? 1 : 0,
				to_username: user.username,
			})
		}

		var m = wall.select({ to_username: user.username })

		var mm = []
		for (var id in m) {
			if (profile_can_read(socket, user, m[id])) {
				m[id].c = usernames[m[id].u].color || ''
				m[id].i = usernames[m[id].u].image || ''
				m[id].b = usernames[m[id].u].cover || ''
				m[id].t = usernames[m[id].u].ccolor || ''

				m[id].ud = usernames[m[id].u].donated || ''
				mm.push(m[id])
			}
		}

		Socket.profile_callback(socket, mm, user, aCallback)

		if (user.username != 'Lame Guest' && user.username !== socket.u.username) {
			var sockets = Socket.get_sockets_for_username(user.username)
			if (user.unread) user.unread++
			else user.unread = 1
			if (
				sockets.length &&
				sockets.every(function(socket) {
					return !socket.focused
				})
			) {
				sockets[0].emit('a', {
					id: 'notify-wall',
					u: socket.u.username,
					b: data.v,
					i: socket.u.image,
				})
			}

			for (var id in sockets) {
				sockets[id].emit('a', {
					id: 'unread',
					d: user.unread,
				})
			}
		}
	}
}
Socket.prototype.profile_post_as_mobc = function(socket, data, aCallback) {
	if (!socket.MOD) return

	if (socket.MOD) data.v = u.valueMultiline(data.v, 50000)
	else data.v = u.valueMultiline(data.v, 4000)

	data.u = Socket.get_username_from_username(data.u)

	if (
		!socket.LAME &&
		data.v != '' &&
		socket.ID != '' &&
		socket.IDU != '' &&
		usernames[socket.u.username] &&
		!users_banned.ban[data.u]
	) {
		if (data.u.indexOf('Lame Guest') === 0) data.u = 'Lame Guest'
		var user = usernames[data.u]
		if (!user) user = usernames['Lame Guest']
		if (!is_public_mod(user.username)) {
			if (!Socket.user_is_confirmed(socket)) return
		}

		if (socket.u.username === 'omgmobc.com') {
		} else {
			/*if (!user.block) user.block = {}

			if (users_banned.ban[user.username]) {
				socket.emit('a', {
					id: 'messages',
					type: 'system',
					message: 'You cannot post on this profile.',
				})
				return
			}

			if (did_i_block_user(user.username, socket.u.username)) {
				socket.emit('a', {
					id: 'messages',
					type: 'system',
					message: 'You cannot post on this profile, this user blocked you.',
				})
				return
			}*/
		}

		if (socket.u.username === 'omgmobc.com' || user.username == socket.u.username) {
		} else {
			/*if (!user.friend) {
				user.friend = {}
			}

			if (
				!user.wallf ||
				user.username == 'omgmobc.com' ||
				(socket.MOD && mods[user.username]) ||
				(user.wallf && user.friend[socket.u.username])
			) {
				// nothing
			} else {
				socket.emit('a', {
					id: 'messages',
					type: 'system',
					message: 'Wall is writable by friends only.',
				})
				return
			}*/
		}
		/*	if (
			socket.VPN &&
			!socket.MOD &&
			!users_banned.white[socket.u.username] &&
			user.username !== 'omgmobc.com'
		) {
		} else {*/
		wall.insert({
			u: 'omgmobc.com',
			d: u.now,
			m: data.v,
			p: 1,
			to_username: user.username,
		})
		/*}*/

		var m = wall.select({ to_username: user.username })

		var mm = []
		for (var id in m) {
			if (profile_can_read(socket, user, m[id])) {
				m[id].c = usernames[m[id].u].color || ''
				m[id].i = usernames[m[id].u].image || ''
				m[id].b = usernames[m[id].u].cover || ''
				m[id].t = usernames[m[id].u].ccolor || ''

				m[id].ud = usernames[m[id].u].donated || ''
				mm.push(m[id])
			}
		}

		Socket.profile_callback(socket, mm, user, aCallback)

		if (user.username != 'Lame Guest' && user.username !== socket.u.username) {
			var sockets = Socket.get_sockets_for_username(user.username)
			if (user.unread) user.unread++
			else user.unread = 1
			if (
				sockets.length &&
				sockets.every(function(socket) {
					return !socket.focused
				})
			) {
				sockets[0].emit('a', {
					id: 'notify-wall',
					u: 'omgmobc.com',
					b: data.v,
					i: usernames['omgmobc.com'].image,
				})
			}

			for (var id in sockets) {
				sockets[id].emit('a', {
					id: 'unread',
					d: user.unread,
				})
			}
		}
	}
}

Socket.prototype.profile_remove = function(socket, data, aCallback) {
	data.v = u.value(data.v)
	if (!socket.LAME && data.v != '') {
		data.u = Socket.get_username_from_username(data.u)
		if (data.u.indexOf('Lame Guest') === 0) data.u = 'Lame Guest'
		var user = usernames[data.u]
		if (!user) user = usernames['Lame Guest']

		var m = wall.select({ to_username: user.username })

		for (var id in m) {
			if (
				m[id].d == data.v &&
				((user.username === 'omgmobc.com' && socket.MOD) ||
					user.username === socket.u.username ||
					m[id].u === socket.u.username ||
					(socket.MOD && !mods[user.username]))
			) {
				if ((is_public_mod(user.username) || is_public_mod(m[id].u)) && !socket.MOD) {
				} else {
					// DELETE FROM DB
					wall.delete_by_id({ id: m[id].id })
					u.removeValueFromArray(m, m[id])
				}

				break
			}
		}

		var mm = []
		for (var id in m) {
			if (profile_can_read(socket, user, m[id])) {
				m[id].c = usernames[m[id].u].color || ''
				m[id].i = usernames[m[id].u].image || ''
				m[id].b = usernames[m[id].u].cover || ''
				m[id].t = usernames[m[id].u].ccolor || ''

				m[id].ud = usernames[m[id].u].donated || ''
				mm.push(m[id])
			}
		}

		Socket.profile_callback(socket, mm, user, aCallback)
	}
}

Socket.prototype.profile_clear_wall = function(socket, data, aCallback) {
	data.u = Socket.get_username_from_username(data.u)

	if (!socket.LAME && data.u === socket.u.username && usernames[data.u]) {
		var user = usernames[data.u]

		if (socket.MOD) {
			wall.delete_by_username_all({
				username: user.username,
			})
		} else {
			wall.delete_by_username_all_except_mobc({
				username: user.username,
			})
		}

		var mm = []
		Socket.profile_callback(socket, mm, user, aCallback)
	} else {
		LM(socket, 'trying to clear the wall of ' + Socket.mod_update_link_user(data.u))
	}
}

Socket.prototype.profile_remove_block = function(socket, data, aCallback) {
	data.v = u.value(data.v)
	data.u = Socket.get_username_from_username(data.u)
	if (
		!socket.LAME &&
		data.v != '' &&
		((!is_hidden_mod(data.u) && socket.MOD) || data.u === socket.u.username) &&
		usernames[data.u]
	) {
		var user = usernames[data.u]

		var m = wall.select({ to_username: user.username })

		var to_remove = []
		var user_to_remove = ''
		for (var id in m) {
			if (m[id].d == data.v && m[id].u !== socket.u.username) {
				user_to_remove = m[id].u
				if (!user.block) user.block = {}

				user.block[user_to_remove] = true
				wall.delete_to_username_by_username({
					to_username: user.username,
					by_username: user_to_remove,
				})

				break
			}
		}

		m = wall.select({ to_username: user.username })

		var mm = []
		for (var id in m) {
			if (profile_can_read(socket, user, m[id])) {
				m[id].c = usernames[m[id].u].color || ''
				m[id].i = usernames[m[id].u].image || ''
				m[id].b = usernames[m[id].u].cover || ''
				m[id].t = usernames[m[id].u].ccolor || ''

				m[id].ud = usernames[m[id].u].donated || ''
				mm.push(m[id])
			}
		}

		Socket.profile_callback(socket, mm, user, aCallback)
		Socket.update_tabs(user.username)
	}
}

Socket.prototype.profile_remove_all_by = function(socket, data, aCallback) {
	data.v = u.value(data.v)
	data.u = Socket.get_username_from_username(data.u)
	if (
		!socket.LAME &&
		data.v != '' &&
		((!is_hidden_mod(data.u) && socket.MOD) || data.u === socket.u.username) &&
		usernames[data.u]
	) {
		var user = usernames[data.u]

		var m = wall.select({ to_username: user.username })

		var to_remove = []
		var user_to_remove = ''
		for (var id in m) {
			if (m[id].d == data.v /*&& m[id].u !== socket.u.username*/) {
				user_to_remove = m[id].u

				wall.delete_to_username_by_username({
					to_username: user.username,
					by_username: user_to_remove,
				})
				break
			}
		}

		m = wall.select({ to_username: user.username })

		var mm = []
		for (var id in m) {
			if (profile_can_read(socket, user, m[id])) {
				m[id].c = usernames[m[id].u].color || ''
				m[id].i = usernames[m[id].u].image || ''
				m[id].b = usernames[m[id].u].cover || ''
				m[id].t = usernames[m[id].u].ccolor || ''

				m[id].ud = usernames[m[id].u].donated || ''
				mm.push(m[id])
			}
		}

		Socket.profile_callback(socket, mm, user, aCallback)
	}
}

Socket.prototype.profile_callback = function(socket, m, user, aCallback) {
	if (aCallback) {
		if (!user.block) user.block = {}

		var can_write =
			!users_banned.ban[user.username] &&
			!user.block[socket.u.username] &&
			(!user.wallfo ||
				(usernames[user.username] &&
					usernames[user.username].friend &&
					usernames[user.username].friend[socket.u.username]))

		var can_write_friends =
			!user.block[socket.u.username] &&
			(!user.wallf ||
				(usernames[user.username] &&
					usernames[user.username].friend &&
					usernames[user.username].friend[socket.u.username]))

		var is_mod = socket.MOD
		// var is_mod = socket.u.username == 'omgmobc.com' // just for testing
		var can_read = is_mod || user.username == socket.u.username || can_write

		aCallback({
			id: user.id,
			pu: users_banned.pu[user.username],
			ba:
				users_banned.ban[user.username] == user.username
					? 1
					: users_banned.ban[user.username]
					? 2
					: 0,
			u: user.username,
			pl: user.plink,
			c: user.color || '',
			s: user.status || '',
			i: user.image || '',
			ic: can_read ? user.cover || '' : '',
			l: user.likes || 1,
			m: can_read ? compress(m) : compress([]),
			o:
				(can_read && !user.noopp) || is_mod || user.username == socket.u.username
					? Socket.get_opponents(user.username)
					: [],
			d: u.now,
			a:
				(can_read && !user.noarcade) || is_mod || user.username == socket.u.username
					? user.arcade || {}
					: {},
			b: user.donated || false,
			border: user.border,
			sidebar: user.sidebar,
			wall: user.wall,
			sky: user.sky,
			t: can_read || is_mod || user.username == socket.u.username ? user.soapbox || '' : '',
			cw: (can_write_friends && can_write) || user.username == socket.u.username,
			ul:
				user.login && !user.nologin
					? is_public_mod(user.username)
						? u.now
						: can_read
						? user.login
						: 'Unknown'
					: 'Unknown',
			ls: user.lastseen || '',
			pv: user.profileviews || '',
			us: user.since || u.now,
			g: can_read ? user.gallery || [] : [],
			f:
				(can_read && !user.nofriend) || is_mod || user.username == socket.u.username
					? Socket.get_friends_for_profile(user.username)
					: [],
		})
	}
}

Socket.prototype.profile_clear_blocklist = function(socket, data) {
	data.u = Socket.get_username_from_username(data.u)

	if (!socket.LAME && data.u === socket.u.username && usernames[data.u]) {
		usernames[data.u].block = {}
	} else {
		LM(socket, 'trying to clearing the blocklist of ' + Socket.mod_update_link_user(data.u))
	}
}

Socket.prototype.profile_block = function(socket, data, aCallback) {
	if (socket && socket.u && socket.u.username != data.v) {
		var user = usernames[socket.u.username]
		data.f = u.value(data.f)
		data.v = u.value(data.v)

		switch (data.f) {
			case 'add':
				if (!user.block) user.block = {}
				user.block[data.v] = true
				break
			case 'remove':
				delete user.block[data.v]
				break
		}
		Socket.update_tabs(user.username)

		if (data.f == 'add') {
			wall.delete_to_username_by_username({
				to_username: user.username,
				by_username: data.v,
			})
		}

		if (aCallback) aCallback({ block: user.block })
	}
}

Socket.prototype.ban = function(username) {
	var user = usernames[username]
	if (user) {
		if (!users_banned.ban[username]) {
			users_banned.ban[username] = 'omgmobc.com'
			reset_user(user)
		}
	}
}
Socket.prototype.mod_donation_toggle = function(socket, data) {
	data.u = Socket.get_username_from_username(data.u)
	if (socket.MOD && data.u != '' && usernames[data.u]) {
		if (usernames[data.u].donated) usernames[data.u].donated = false
		else usernames[data.u].donated = true

		var sockets = Socket.get_sockets_for_username(data.u)
		for (var id in sockets) {
			sockets[id].u.donated = true
		}
		Socket.update_tabs(data.u)
		Socket.message(
			socket,
			'success',
			'Marked "' + data.u + '" as ' + (usernames[data.u].donated ? 'Donor' : ' Not Donor') + '',
		)
		LM(
			socket,
			' marked ' +
				Socket.mod_update_link_user(data.u) +
				' as ' +
				(usernames[data.u].donated ? 'Donor' : ' Not Donor'),
		)
	} else {
		LM(socket, 'trying to toggle donation on' + Socket.mod_update_link_user(data.u))
	}
}

Socket.prototype.mod_pu_toggle = function(socket, data) {
	data.u = Socket.get_username_from_username(data.u)
	if (socket.MOD && data.u != '' && usernames[data.u]) {
		if (users_banned.pu[data.u]) {
			delete users_banned.pu[data.u]
		} else {
			users_banned.pu[data.u] = 'omgmobc.com'
		}

		var sockets = Socket.get_sockets_for_username(data.u)
		for (var id in sockets) {
			sockets[id].PU = true
		}
		Socket.update_tabs(data.u)
		Socket.message(
			socket,
			'success',
			'Marked "' + data.u + '" as ' + (users_banned.pu[data.u] ? 'PU' : ' Not PU') + '',
		)
		LM(
			socket,

			' marked ' +
				Socket.mod_update_link_user(data.u) +
				' as ' +
				(users_banned.pu[data.u] ? 'PU' : ' Not PU'),
		)
	} else {
		LM(socket, ' trying to toggle pu on' + Socket.mod_update_link_user(data.u))
	}
}

Socket.prototype.mod_disconnect = function(socket, data) {
	if (socket.MOD && data.u != '') {
		if (!mods[data.u] && usernames[data.u].id != 2143) {
			var sockets = Socket.get_sockets_for_username(data.u)
			for (var id in sockets) Socket.kill(sockets[id], false)
			LM(socket, 'disconnected ' + Socket.mod_update_link_user(data.u))
		} else {
			LM(socket, 'disallowed to disconnect ' + Socket.mod_update_link_user(data.u))
		}
	} else if (!socket.MOD) {
		LM(socket, 'trying to disconnect' + Socket.mod_update_link_user(data.u))
	}
}

Socket.prototype.mod_send_message_site_chat = function(socket, data) {
	data.v = u.value(data.v, 4000)
	if (socket.MOD && data.v != '') {
		io.emit('a', {
			id: 'c',
			mc: '',
			un: 'omgmobc.com',
			ui: u.now,
			m: data.v,
		})

		LM(socket, 'to complete site chat: ' + u.escape(data.v.replace(/^\/m /i, '')))
	}
}

Socket.prototype.profile_reset = function(socket, data) {
	data.u = Socket.get_username_from_username(data.u)
	if (socket.MOD && data.u != '' && data.u != 'Lame Guest' && usernames[data.u]) {
		var user = usernames[data.u]
		if (!mods[user.username]) {
			reset_user(user, true)

			Socket.update_tabs(user.username)

			LM(socket, 'reset profile ' + Socket.mod_update_link_user(user.username))
			Socket.message(socket, 'success', 'Did reset profile for user "' + user.username + '"')
		} else {
			LM(socket, 'disallowed to reset ' + Socket.mod_update_link_user(user.username))
		}
	} else {
		LM(socket, 'trying to reset profile for ' + Socket.mod_update_link_user(data.u))
	}
}
Socket.prototype.user_reset_profile = function(socket, data) {
	if (!socket.LAME && usernames[socket.u.username]) {
		var user = usernames[socket.u.username]
		reset_user(user, true)
		Socket.update_tabs(user.username)

		Socket.message(socket, 'success', 'Did Reset Profile')
	}
}
Socket.prototype.user_reset_stats = function(socket, data) {
	if (!socket.LAME && usernames[socket.u.username]) {
		var user = usernames[socket.u.username]
		user.arcade = {}
		Socket.update_tabs(user.username)

		Socket.message(socket, 'success', 'Did Reset Stats')
	}
}

Socket.prototype.user_close_profile = function(socket, data) {
	data.u = Socket.get_username_from_username(data.u)
	if (
		!socket.LAME &&
		data.u != '' &&
		data.u != 'Lame Guest' &&
		usernames[data.u] &&
		socket.u.username === data.u
	) {
		var user = usernames[data.u]
		reset_user(user)

		users_banned.ban[user.username] = user.username

		Socket.message(socket, 'success', 'Did Close Profile')

		var sockets = Socket.get_sockets_for_username(data.u)
		for (var id in sockets) Socket.kill(sockets[id], false)
	} else {
		LM(socket, 'trying to close profile for ' + Socket.mod_update_link_user(data.u))
	}
}

Socket.prototype.mod_log = function(socket, data, aCallback) {
	if (socket.MOD) {
		if (aCallback)
			aCallback(
				'<h1>FORBIDDEN TO SHARE THE INFORMATION SHOWN BELOW:<br/><span class="red underline">DO NOT SHOW/SHARE SCREENCAPTURES OF THIS</span></h1><hr/><h2>Logs</h2>' +
					mem() +
					'<br><br>',
				users_banned.mod_logs,
			)
	} else {
		LM(socket, 'trying to read logs ')
	}
}

Socket.prototype.mod_log_connected = function(socket, data, aCallback) {
	if (socket.MOD) {
		var lobby = []
		var _socket
		var id = Object.keys(io.sockets.connected)
		for (var i = 0, l = id.length; i < l; i++) {
			_socket = io.sockets.connected[id[i]]
			if (_socket.ROOM == 'lobby' || _socket.ROOM == '') {
				lobby.push(
					'<div>' +
						Socket.mod_update_link_ip(_socket.IP) +
						' : ' +
						Socket.mod_update_link_user(_socket.u.username) +
						' : ' +
						(u
							.escape(_socket.tz)
							.replace(/GMT/g, '')
							.replace('Standard Time', '')
							.replace('Daylight Time', '')
							.trim() +
							' : ') +
						Socket.mod_update_link_id(_socket.ID) +
						' | ' +
						Socket.mod_update_link_id(_socket.IDU) +
						' | <span title="' +
						u.escape(_socket.B2) +
						'">' +
						u.escape(_socket.B) +
						'</span>  ' +
						'</div>\n',
				)
			}
		}

		lobby.sort()
		lobby.unshift('<hr/><div><b>In Lobby:</b></div>')

		var _rooms = []

		for (var i = 0, l = id.length; i < l; i++) {
			_socket = io.sockets.connected[id[i]]
			if (_socket.ROOM != 'lobby' && _socket.ROOM != '') {
				if (rooms[_socket.ROOM] && mods[_socket.u.username] && rooms[_socket.ROOM].private) {
					continue
				} else {
					if (rooms[_socket.ROOM] && rooms[_socket.ROOM].private && socket.u.username != 'Wade')
						continue
					_rooms.push(
						'<div>' +
							(rooms[_socket.ROOM] && rooms[_socket.ROOM].private ? 'PVT' : '') +
							Socket.mod_update_link_ip(_socket.IP) +
							' : ' +
							Socket.mod_update_link_user(_socket.u.username) +
							' : ' +
							(u
								.escape(_socket.tz)
								.replace(/GMT/g, '')
								.replace('Standard Time', '')
								.replace('Daylight Time', '')
								.trim() +
								' : ') +
							'R:' +
							u.hash(_socket.ROOM).substr(0, 9) +
							' : ' +
							Socket.mod_update_link_id(_socket.ID) +
							' | ' +
							Socket.mod_update_link_id(_socket.IDU) +
							' | <span title="' +
							u.escape(_socket.B2) +
							'">' +
							u.escape(_socket.B) +
							'</span>  ' +
							'</div>\n',
					)
				}
			}
		}

		_rooms.sort()
		_rooms.unshift('<hr/><div><b>In Rooms:</b></div>')

		if (aCallback)
			aCallback(
				'<h1>FORBIDDEN TO SHARE THE INFORMATION SHOWN BELOW:<br/><span class="red underline">DO NOT SHOW/SHARE SCREENCAPTURES OF THIS</span></h1><hr/><h2>CONNECTED PEOPLE</h2>' +
					mem() +
					'<br><br>' +
					[].concat(lobby, _rooms).join('\n'),
			)
	} else {
		LM(socket, 'trying to read logs connected ')
	}
}

Socket.prototype.mod_stats = function(socket, data, aCallback) {
	if (socket.MOD) {
		//LM(socket,  'Users')

		var stats =
			'<h1>FORBIDDEN TO SHARE THE INFORMATION SHOWN BELOW:<br/><span class="red underline">DO NOT SHOW/SHARE SCREENCAPTURES OF THIS</span></h1><hr/><h2>USERS</h2>'

		var confirmed = 0
		var unconfirmed = 0
		var ids = Object.keys(users)
		var id
		var idx
		var _users = []
		var values = []

		for (id in ids) {
			if (users[ids[id]].username) {
				if (users[ids[id]].confirmed === true) confirmed++
				else unconfirmed++
			}
		}

		stats += '<br/><b>Registered Users</b>: ' + Object.keys(users).length + '<br/>'
		stats += '<br/><b>Registered Confirmed Users</b>: ' + confirmed + '<br/>'
		stats += '<br/><b>Registered Unconfirmed Users</b>: ' + unconfirmed + '<br/>'
		stats += '<br/><b>Admins</b><ul class="column">'
		ids = Object.keys(mods)
		ids.sort()
		for (id in ids) {
			stats += '<li>' + this.mod_update_link_user(ids[id])
		}

		stats += '</ul>'

		if (aCallback) aCallback(stats)
	} else {
		LM(socket, 'trying to read stats ')
	}
}

Socket.prototype.mod_search = function(socket, data, aCallback) {
	data.v = u
		.value(data.v)
		.toLowerCase()
		.replace(/\s/g, '')
	if (socket.MOD && data.v != '') {
		var stats =
			'<h1>FORBIDDEN TO SHARE THE INFORMATION SHOWN BELOW:<br/><span class="red underline">DO NOT SHOW/SHARE SCREENCAPTURES OF THIS</span></h1><hr/><h2>MOD SEARCH (user, email, ip, id)</h2>'

		var ids = Object.keys(users)
		stats +=
			'<br/>Searching ' +
			ids.length +
			' users, on username, email, ip or id for "' +
			u.escape(data.v) +
			'"<ul class="column">'
		var _users = []
		var found = false
		var max = 200
		var results = 0
		for (var id in ids) {
			found = false
			if (users[ids[id]].username) {
				if (users[ids[id]].search && users[ids[id]].search.indexOf(data.v) !== -1) {
					_users.push(users[ids[id]].username.toLowerCase())
					found = true
					results++
				}

				if (found) continue
				if (users[ids[id]].ip && users[ids[id]].ip.indexOf(data.v) !== -1) {
					_users.push(users[ids[id]].username.toLowerCase())
					found = true
					results++
				}

				if (found) continue
				if (users[ids[id]].ips) {
					for (var id2 in users[ids[id]].ips) {
						if (users[ids[id]].ips[id2].indexOf(data.v) !== -1) {
							_users.push(users[ids[id]].username.toLowerCase())
							found = true
							results++
							break
						}
					}
				}

				if (found) continue
				if (users[ids[id]].ids) {
					for (var id2 in users[ids[id]].ids) {
						if (users[ids[id]].ids[id2].indexOf(data.v) !== -1) {
							_users.push(users[ids[id]].username.toLowerCase())
							found = true
							results++
							break
						}
					}
				}

				if (found) continue
				if (users[ids[id]].idsu) {
					for (var id2 in users[ids[id]].idsu) {
						if (users[ids[id]].idsu[id2].indexOf(data.v) !== -1) {
							_users.push(users[ids[id]].username.toLowerCase())
							found = true
							results++
							break
						}
					}
				}
			}
			if (results > 400) break
		}

		_users = u.arrayUnique(_users)
		_users.sort()
		for (var id in _users) stats += '<li>' + Socket.mod_update_link_user(_users[id])
		stats += '</ul>'
		if (aCallback) aCallback(stats)
	} else if (!socket.MOD) {
		LM(socket, 'trying to read power search ')
	}
}

var search_chunk = 400

Socket.prototype.search = function(socket, data, aCallback) {
	if (socket.VPN && !socket.MOD && !users_banned.white[socket.u.username]) return

	data.v = u
		.value(data.v, 20)
		.toLowerCase()
		.replace(/\s/g, '')
	if (data.v != '' && aCallback) {
		var _users = []
		var results = { results: 0, checked: 0 }

		function search(ids, users, results, reply, search_for) {
			var id
			var user
			while (ids.length) {
				results.checked++
				id = ids.shift()
				user = users[id]

				if (user && user.search && user.search.indexOf(search_for) !== -1) {
					_users.push({
						u: user.username,
						c: user.color,
						i: user.image,
						s: user.status,
					})
					results.results++
					if (results.results > 40) {
						setImmediate(reply)
						break
					}
				}
				if (results.checked % search_chunk == 0) {
					setImmediate(search)
					break
				}
			}
			if (!ids.length) {
				setImmediate(reply)
			}
		}
		search = search.bind(null, Object.keys(users), users, results, reply, data.v)

		function reply() {
			var _exact = Socket.get_username_from_username(data.v)
			if (_exact) {
				var user = usernames[_exact]
				if (user)
					_users.unshift({
						u: user.username,
						c: user.color,
						i: user.image,
						s: user.status,
					})
			}

			aCallback(
				_users.filter(function(item) {
					return usernames[item.u] && !users_banned.ban[item.u]
				}),
			)
		}

		setImmediate(search)
	} else if (aCallback) {
		aCallback([])
	}
}

Socket.prototype.mod_trace = function(socket, data, aCallback) {
	data.u = this.get_username_from_username(data.u)
	if (socket.MOD && data.u != '') {
		//LM(socket,  'Trace')

		var trace = []
		trace.push(
			'<h1>FORBIDDEN TO SHARE THE INFORMATION SHOWN BELOW:<br/><span class="red underline">DO NOT SHOW/SHARE SCREENCAPTURES OF THIS</span></h1><hr/><h2>TRACE</h2><input type="text" onchange="u.filterable(this)" onkeyup="u.filterable(this)" onkeypress="u.filterable(this)" onblur="u.filterable(this)" placeholder="Search..." class="r"/>',
		)

		var ip = ''
		var sip = ''
		var e = ''
		var ids = []
		var idsu = []
		var ips = []
		var tmp = []
		var user = false
		var id,
			i,
			b = '',
			b2 = ''
		var isps = []
		var isp = ''

		if (data.u.indexOf('Lame Guest') === 0) {
			var sockets = this.get_sockets_for_username(data.u)
			for (id in sockets) {
				if (sockets[id].ID != '') ids[sockets[id].ID] = true
				if (sockets[id].IDU != '') idsu[sockets[id].IDU] = true
				if (sockets[id].IP != '') ips[sockets[id].IP] = true

				ip = sockets[id].IP
				b = sockets[id].B
				b2 = sockets[id].B2
			}
		} else {
			user = usernames[data.u]
			if (user) {
				e = user.email
				ip = user.ip || ''
				sip = user.sip || ''
				b = user.browser || ''
				b2 = user.browser2 || ''

				if (user.ips) {
					for (id in user.ips) {
						ips[user.ips[id]] = true
					}
				}

				if (user.ip) ips[user.ip] = true
				if (user.sip) ips[user.sip] = true

				if (user.ids) {
					for (id in user.ids) {
						ids[user.ids[id]] = true
					}
				}

				if (user.idsu) {
					for (id in user.idsu) {
						idsu[user.idsu[id]] = true
					}
				}
			}
		}

		trace.push(
			'"<b>' +
				u.escape(data.u) +
				'</b>" |  ' +
				this.mod_update_link_ip(ip) +
				(sip ? ' SIP ' + this.mod_update_link_ip(sip) : '') +
				' <br> <span title="' +
				u.escape(b2) +
				'">' +
				u.escape(b) +
				'</span> | ' +
				(user && user.since ? u.date(user.since) : '') +
				' | ' +
				(user && user.login2 ? user.login2 : '') +
				' | ' +
				(user && user.confirmed === true ? 'CONF' : 'UNCONF') +
				'<br/><br/>',
		)

		if (data.u.indexOf('Lame Guest') !== 0) {
			trace.push(this.mod_trace_print_username(socket, data.u))
		}

		if (ip != '') {
			isp = network.IPLocation(ip)[1]
			if (isp && isp != '') {
				trace.push(this.mod_trace_print_isp(socket, isp))
				isps[isp] = true
			}

			trace.push(this.mod_trace_print_ip(ip))
		}

		tmp = Object.keys(ips)
		for (id in tmp) {
			isp = network.IPLocation(tmp[id])[1]
			if (isp && isp != '' && !isps[isp]) {
				trace.push(this.mod_trace_print_isp(socket, isp))
				isps[isp] = true
			}
		}

		for (id in tmp) {
			if (ip != tmp[id]) trace.push(this.mod_trace_print_ip(tmp[id]))
		}

		tmp = Object.keys(ids)
		for (id in tmp) trace.push(this.mod_trace_print_id(tmp[id]))

		tmp = Object.keys(idsu)
		for (id in tmp) trace.push(this.mod_trace_print_id(tmp[id]))

		var _trace_ids = []
			.concat(Object.keys(ips))
			.concat(Object.keys(ids))
			.concat(Object.keys(idsu))
		var _trace_users = []
		for (var id in _trace_ids) {
			if (users_banned.trace[_trace_ids[id]])
				_trace_users = _trace_users.concat(Object.keys(users_banned.trace[_trace_ids[id]]))
		}

		_trace_users = u.arrayUnique(_trace_users)

		var _users = {}

		_users[data.u] = true
		var matched
		for (var idx in _trace_users) {
			matched = usernames[_trace_users[idx]]
			if (!matched) continue
			if (matched.username && !_users[matched.username]) {
				_users[matched.username] = true

				if (usernames[matched.username].idu_reset) continue

				trace.push(
					'<br/>"<b>' +
						u.escape(matched.username) +
						'</b>"  | ' +
						(this.mod_update_link_ip(matched.ip) || '') +
						(matched.sip ? ' SIP ' + this.mod_update_link_ip(matched.sip || '') : '') +
						' <br> <span title="' +
						u.escape(matched.browser2 || '') +
						'">' +
						u.escape(matched.browser || '') +
						'</span> | ' +
						u.date(matched.since || '') +
						' | ' +
						(matched.login2 || '') +
						' | ' +
						(matched && matched.confirmed === true ? 'CONF' : 'UNCONF') +
						' <br/><br/>',
				)
				trace.push(this.mod_trace_print_username(socket, matched.username))

				if (matched.ip) {
					isp = network.IPLocation(matched.ip)[1]
					if (isp && isp != '' && !isps[isp]) {
						trace.push(this.mod_trace_print_isp(socket, isp))
						isps[isp] = true
					}

					trace.push(this.mod_trace_print_ip(matched.ip))
					ips[matched.ip] = true
				}

				if (matched.ips) {
					for (id in matched.ips) {
						isp = network.IPLocation(matched.ips[id])[1]
						if (isp && isp != '' && !isps[isp]) {
							trace.push(this.mod_trace_print_isp(socket, isp))

							isps[isp] = true
						}
					}

					for (id in matched.ips) {
						trace.push(this.mod_trace_print_ip(matched.ips[id]))
						ips[matched.ips[id]] = true
					}
				}

				if (matched.ids) {
					for (id in matched.ids) {
						trace.push(this.mod_trace_print_id(matched.ids[id]))
						ids[matched.ids[id]] = true
					}
				}

				if (matched.idsu) {
					for (id in matched.idsu) {
						trace.push(this.mod_trace_print_id(matched.idsu[id]))
						idsu[matched.idsu[id]] = true
					}
				}
			}
		}

		trace.push('<br/>')
		if (aCallback) aCallback(trace.join(''))
	} else {
		LM(socket, 'trying to read TRACE')
	}
}

Socket.prototype.mod_trace_print_id = function(v) {
	return (
		'<li class="filterable">' +
		this.mod_update_input('ban', v) +
		this.mod_update_input('signup', v) +
		this.mod_update_input('lobby', v) +
		this.mod_update_input('del', v) +
		this.mod_update_input('white', v, true) +
		' ' +
		this.mod_update_link_id(v) +
		' - <span class="cgray">' +
		u.escape(Object.keys(users_banned.trace[v] || []).join(', ')) +
		'</li>'
	)
}

Socket.prototype.mod_trace_print_ip = function(v) {
	return (
		'<li class="filterable">' +
		this.mod_update_input('ban', v) +
		this.mod_update_input('signup', v) +
		this.mod_update_input('lobby', v) +
		this.mod_update_input('del', v) +
		this.mod_update_input('white', v, true) +
		' ' +
		this.mod_update_link_ip(v) +
		' - <span class="cgray">' +
		u.escape(Object.keys(users_banned.trace[v] || []).join(', ')) +
		'</span></li>'
	)
}

Socket.prototype.mod_trace_print_isp = function(socket, v) {
	return (
		'<li class="filterable">' +
		this.mod_update_input('ban', v, socket.u.username != 'Tito') +
		this.mod_update_input('signup', v, socket.u.username != 'Tito') +
		this.mod_update_input('lobby', v, socket.u.username != 'Tito') +
		this.mod_update_input('del', v, true) +
		this.mod_update_input('white', v, socket.u.username != 'Tito') +
		' ' +
		this.mod_update_link_google(v) +
		'</li>'
	)
}

Socket.prototype.mod_trace_print_username = function(socket, v) {
	return (
		'<li class="filterable">' +
		this.mod_update_input('ban', v) +
		this.mod_update_input('signup', v, true) +
		this.mod_update_input('lobby', v) +
		this.mod_update_input('del', v, true) +
		this.mod_update_input('white', v) +
		' ' +
		this.mod_update_link_user(v) +
		'</li>'
	)
}
var deleted_pictures = 0

Socket.prototype.update_today_delete_pictures = function() {
	var used_pictures = {}
	for (var id in users) {
		if (users[id].username) {
			if (users[id].image && users[id].image != '') {
				used_pictures[
					users[id].image
						.split('/')
						.pop()
						.replace(/\.[^\.]+$/, '')
				] = true
			}
			if (users[id].cover && users[id].cover != '') {
				used_pictures[
					users[id].cover
						.split('/')
						.pop()
						.replace(/\.[^\.]+$/, '')
				] = true
			}
			if (users[id].gallery) {
				for (var a in users[id].gallery) {
					used_pictures[
						users[id].gallery[a]
							.split('/')
							.pop()
							.replace(/\.[^\.]+$/, '')
					] = true
				}
			}
		}
	}

	network.fetch('https://omgmobc.com/php/upload.php?action=list', function(url, body) {
		body = u.arrayUnique(
			body
				.replace(/thumb_/g, '')
				.trim()
				.split('\n'),
		)
		var root = '/w/omgmobc.com/data/'

		var formats = [
			'gif',
			'jpeg',
			'jpg',
			'jfif',
			'mp4',
			'mp3',
			'mpeg',
			'bmp',
			'mpg',
			'png',
			'webm',
			'webp',
			'apng',
		]

		Socket.delete_pictures_paths = []

		while (body.length) {
			var to_delete = body.pop().trim()
			if (
				!used_pictures[to_delete] &&
				to_delete != '' &&
				to_delete != 'lame.jpg' &&
				to_delete != 'user.jpg' &&
				to_delete != 'lame' &&
				to_delete != 'user' &&
				to_delete != '.htaccess'
			) {
				deleted_pictures++
				for (var id in formats) {
					Socket.delete_pictures_paths.push(root + 'gallery/' + to_delete + '.' + formats[id])
					Socket.delete_pictures_paths.push(root + 'gallery/thumb_' + to_delete + '.' + formats[id])
					Socket.delete_pictures_paths.push(root + 'cover/' + to_delete + '.' + formats[id])
					Socket.delete_pictures_paths.push(root + 'profile/' + to_delete + '.' + formats[id])
					Socket.delete_pictures_paths.push(root + 'profile/thumb_' + to_delete + '.' + formats[id])
				}
			}
		}
		Socket.update_today_delete_pictures_async()
	})
}

Socket.prototype.update_today_delete_pictures_async = function() {
	if (Socket.delete_pictures_paths.length) {
		var path = Socket.delete_pictures_paths.pop()
		setTimeout(function() {
			fs.unlink(path, err => {})
			Socket.update_today_delete_pictures_async()
		}, 200)
	} else {
		LM(null, 'deleted ' + deleted_pictures + ' pictures')
		deleted_pictures = 0
	}
}
Socket.prototype.update_today = function() {
	if (local) return
	var today = u.today(u.now - 28800000)
	var hour = u.hour()

	if (users_banned.today != today) {
		users_banned.once_likes = {}
		users_banned.discord_videos = {}

		Socket.youtube_keys = JSON.parse(JSON.stringify(Socket.youtube_keys_original))

		var start = u.now

		io.emit('b', 'Daily Maintenance, Lag Time! 🤪')

		users_banned.today = today

		users_banned.once_mail = {}
		var _stuff = {}

		var functions = [
			function() {
				if (users_banned.today % 7 === 0) {
					io.emit('b', 'Updating ranking')

					users_banned.ranking = {}
					Socket.ranking()
				}
			},

			function() {
				if (users_banned.today % 2 === 0) {
					for (var id in users) {
						if (users[id].username) {
							if (users[id].ips && users[id].ips.length) {
								for (var a = 0, l = users[id].ips.length; a < l; a++) {
									_stuff[users[id].ips[a]] = true
								}
							}
							if (users[id].ids && users[id].ids.length) {
								for (var idx in users[id].ids) {
									_stuff[users[id].ids[idx]] = true
								}
							}
							if (users[id].idsu && users[id].idsu.length) {
								for (var idx in users[id].idsu) {
									_stuff[users[id].idsu[idx]] = true
								}
							}
							_stuff[users[id].username] = true
							_stuff[users[id].ip] = true
						}
					}
					var id = Object.keys(users_banned.ban)
					for (var i = 0, l = id.length; i < l; i++) {
						if (!_stuff[id[i]] && id[i].length > 20) delete users_banned.ban[id[i]]
					}

					var id = Object.keys(users_banned.signup)
					for (var i = 0, l = id.length; i < l; i++) {
						if (!_stuff[id[i]] && id[i].length > 20) delete users_banned.signup[id[i]]
					}

					var id = Object.keys(users_banned.white)
					for (var i = 0, l = id.length; i < l; i++) {
						if (!_stuff[id[i]] && id[i].length > 20) delete users_banned.white[id[i]]
					}
				}

				_stuff = null
			},
			function() {
				// clean up trace data of more than 31 days

				if (users_banned.today % 10 === 0) {
					var id = Object.keys(users_banned.trace)
					for (var i = 0, l = id.length; i < l; i++) {
						var k = Object.keys(users_banned.trace[id[i]])
						for (var a = 0, l1 = k.length; a < l1; a++) {
							if (u.now - users_banned.trace[id[i]][k[a]] > 3600 * 1000 * 24 * 31)
								delete users_banned.trace[id[i]][k[a]]
						}

						if (Object.keys(users_banned.trace[id[i]]).length > 0) {
						} else {
							delete users_banned.trace[id[i]]
						}
					}
				}
			},
			function() {
				// reset youtube - TODO change to something lower
				if (users_banned.today % 9 === 0) {
					users_banned.YTCache = {}
				}
				// remove unused pictures
				if (users_banned.today % 3 === 0) {
					if (!local) {
						Socket.update_today_delete_pictures()
					}
				}
			},
			/*function() {
				// remove banned people from groups

				var groups = Object.keys(users_banned.groups)
				for (var id in groups) {
					var group = users_banned.groups[groups[id]]
					for (var idx in group.u) {
						var user = usernames[group.u[idx]]
						if (
							users_banned.ban[user.username] ||
							!user.groups ||
							user.groups.indexOf(group.id) === -1
						) {
							u.removeValueFromArray(group.u, user.username)
							group.m.push({
								id: u.now,
								u: 'MOBC',
								m: user.username + ' left the group',
								s: 1,
							})
						}
					}

					if (!group.u || group.u.length === 0) {
						delete users_banned.groups[group.id]
					}
				}
			},*/
			function() {
				/*for (var user in usernames) {
					if (!usernames[user]) {
						continue
					}
					if (!usernames[user].friend) continue
					for (var friend in usernames[user].friend) {
						if (!usernames[friend]) {
							delete usernames[user].friend[friend]
						}
					}
				}*/
			},
			function() {
				network.fetch('https://omgmobc.com/php/delete.php', function(url, body) {
					if (body != '0') {
						LM(null, 'deleted ' + body + ' tmp media')
					}
				})
			},
			function() {
				wall.delete_older_mobc({ date: u.now - 3600 * 1000 * 24 * 4 })
			},
			function() {
				if (global.gc) global.gc()
			},
		]
		u.run_functions_delayed(functions, function() {
			LM(null, 'daily update done in ' + +((u.now - start) / 1000).toFixed(2))
			io.emit('b', 'Daily Maintenance Done! 🤪')
		})
	}

	// garbage collect

	if (users_banned.hour != hour) {
		users_banned.hour = hour
		if (global.gc) global.gc()
	}
}

Socket.prototype.mod_update_input = function(name, v, disabled) {
	var description = ''
	if (disabled) {
	} else {
		switch (name) {
			case 'ban': {
				description = 'Prevent "' + v + '" from connecting to the site. CANNOT use site.'
				break
			}

			case 'signup': {
				description = 'Prevent ALL signup for "' + v + '".'
				break
			}

			case 'lobby': {
				description = 'Prevent ALL lobby chat for "' + v + '".'
				break
			}

			case 'del': {
				description = 'Delete "' + v + '" from the system.'
				break
			}

			case 'white': {
				description =
					'White-list "' + v + '", if any BAN matches "' + v + '", the ban will NOT be applied.'
				break
			}

			default: {
				description = 'No description'
				break
			}
		}
	}

	return (
		'<label title="' +
		(users_banned[name][v] ? 'Applied by ' + u.escape(users_banned[name][v]) + ' • ' : '') +
		u.escape(description) +
		'" class="' +
		(disabled ? ' disabled ' : '') +
		(users_banned[name][v] ? ' selected ' : '') +
		' "><input type="checkbox" value="true" data-name="' +
		name +
		'" data-value="' +
		u.escape(v) +
		'" ' +
		(users_banned[name][v] ? ' checked ' : '') +
		' ' +
		(disabled ? ' disabled ' : '') +
		'> ' +
		name.toUpperCase() +
		'</label>'
	)
}

Socket.prototype.mod_update_link_user = function(v) {
	if (usernames_lower[v]) v = usernames_lower[v].username
	return (
		'<a class="link" title="Open ' +
		u.escape('"' + v + '"') +
		' Profile" href="#u/' +
		encodeURIComponent(v) +
		'">• ' +
		u.escape(v).replace(/^Lame Guest/, 'LG') +
		(users_banned.pu[v] ? ' (PU)' : '') +
		'</a> '
	)
}

Socket.prototype.mod_update_link_ip = function(v) {
	if (v === '') return ''
	var location = network.IPLocation(v)
	return (
		'<a class="link" target="_blank" rel="noopener" title="' +
		u.escape(location[0]) +
		'\n' +
		u.escape(location[1]) +
		'\n' +
		Socket.mod_update_link_ip_link_title(v) +
		'\n' +
		u.escape(Object.keys(users_banned.trace[v] || []).join(', ')) +
		'" href="http://viewdns.info/whois/?domain=' +
		encodeURIComponent(v) +
		'"><span title="' +
		u.escape(location[0]) +
		'">' +
		location[0] +
		'</span> ' +
		u.escape(v) +
		Socket.mod_update_link_ip_link_description(v) +
		'</a> '
	)
}

Socket.prototype.mod_update_link_google = function(v) {
	return (
		'<a class="link" target="_blank" rel="noopener" title="Google Search ' +
		u.escape('"' + v + '"') +
		'" href="https://www.google.com/search?q=' +
		encodeURIComponent(v) +
		'"><b>' +
		u.escape(v).substr(0, 25) +
		'</b></a>'
	)
}

Socket.prototype.mod_update_link_id = function(v) {
	return (
		'<span title="' +
		u.escape(v) +
		'\n' +
		u.escape(Object.keys(users_banned.trace[v] || []).join(', ')) +
		' ">' +
		u.escape(v).substr(0, 8) +
		'</span>'
	)
}

Socket.prototype.mod_update_link_ip_link_title = function(v) {
	var ip = network.IPLocation(v)
	var isp = ip[1]
	if (users_banned.white[isp])
		return 'VPN nope, manually white-listed by ' + users_banned.white[isp]
	else if (users_banned.ban[isp])
		return 'VPN 100%, manually black-listed by ' + users_banned.ban[isp]
	else if (ip[0] === 'A1') return 'VPN '

	return 'VPN unknown '
}

Socket.prototype.mod_update_link_ip_link_description = function(v) {
	var ip = network.IPLocation(v)
	var isp = ip[1]
	if (users_banned.white[isp]) return ''
	else if (users_banned.ban[isp] || ip[0] === 'A1') return ' <b class="red">VPN</b>'

	return ''
}

Socket.prototype.mod_ip_is_vpn = function(v) {
	var ip = network.IPLocation(v)
	var isp = ip[1]
	if (users_banned.white[isp]) return false
	else if (users_banned.ban[isp] || ip[0] === 'A1') return true
	else return false
}

Socket.prototype.mod_update_link_email = function(v) {
	return ''
}

Socket.prototype.mod_update_link_room = function(v) {
	if (rooms[v] && rooms[v].private) {
		return u.hash(v).substr(0, 9)
	} else {
		return (
			'#m/' +
			u.escape(v) +
			(rooms[v] && rooms[v].creator ? '@' + Socket.mod_update_link_user(rooms[v].creator) : '')
		)
	}
}

Socket.prototype.mod_update = function(socket, data) {
	if (socket.MOD) {
		if (!data.o && users_banned[data.n] && users_banned[data.n][data.v]) {
			delete users_banned[data.n][data.v]
			if (users_banned.trace[data.v]) {
				delete users_banned.trace[data.v]
			}
		} else if (data.o) {
			if (!users_banned[data.n]) users_banned[data.n] = {}

			if (!mods[data.v]) {
				users_banned[data.n][data.v] = 'omgmobc.com'
				if (data.n === 'ban' && usernames[data.v]) {
					Socket.ban(data.v)
				}
			}
		}

		if (data.n === 'del') {
			for (var id in users) {
				if (users[id].ids) u.removeValueFromArray(users[id].ids, data.v)
				if (users[id].idsu) u.removeValueFromArray(users[id].idsu, data.v)
				if (users[id].ips) u.removeValueFromArray(users[id].ips, data.v)
			}

			if (users_banned.trace[data.v]) delete users_banned.trace[data.v]
		}

		if (data.n == 'ban') {
			var sockets = Socket.get_sockets_for_ip_or_id_or_username(socket, data.v)
			for (var id in sockets) {
				if (!mods[sockets[id].u.username]) {
					Socket.kill(sockets[id], 'BANNED')
				}
			}
		}

		var description = data.n
		if (description == 'ban') description = 'BANNED'
		else if (description == 'signup') description = 'NO SIGNUP'
		else if (description == 'lobby') description = 'NO LOBBY'
		else if (description == 'del') description = 'DELETED'
		else if (description == 'white') description = 'WHITELISTED'

		LM(
			socket,

			'updated ' +
				u.escape(description) +
				' for ' +
				u.escape(data.v).substr(0, 15) +
				' to ' +
				(data.o ? 'TRUE' : 'FALSE') +
				'  looking at ' +
				Socket.mod_update_link_user(data.u),
		)
	} else {
		LM(socket, 'trying to use MOD BAN functions:' + u.escape(JSON.stringify(data)))
	}
}

Socket.prototype.update_room = function(socket, room_id) {
	if (socket && socket.ROOM != 'lobby' && socket.ROOM != '')
		io.to(socket.ROOM).emit('a', {
			id: 'room',
			room: rooms[socket.ROOM],
		})
	else if (room_id)
		io.to(room_id).emit('a', {
			id: 'room',
			room: rooms[room_id],
		})
}

Socket.prototype.GROUPS_PER_USER_MAX = 20
Socket.prototype.GROUP_USERS_MAX = 250
Socket.prototype.GROUP_MSG_BUFFER = 50
Socket.prototype.group_new = function(socket, data, aCallback) {
	if (socket.VPN && !socket.MOD && !users_banned.white[socket.u.username]) {
		return
	}
	if (socket.LAME) {
		socket.emit('a', {
			id: 'messages',
			type: 'system',
			message: 'Login for creating private chat groups.',
		})
	} else {
		if (!usernames[socket.u.username].groups) usernames[socket.u.username].groups = []

		if (usernames[socket.u.username].groups.length > Socket.GROUPS_PER_USER_MAX && !socket.MOD) {
			socket.emit('a', {
				id: 'messages',
				type: 'system',
				message: 'Too many Chat Groups, Leave some group.',
			})
		} else {
			var id = u.hash(u.id() + ',' + u.now)
			while (users_banned.groups[id]) {
				id = u.hash(u.id() + ',' + u.now)
			}

			usernames[socket.u.username].groups.push(id)

			users_banned.groups[id] = {
				id: id,
				u: [socket.u.username],
				t: u.now,
				m: [
					{
						id: u.now,
						u: socket.u.username,
						i: socket.u.image || '',
						c: socket.u.mcolor || '',
						mu: socket.u.underline,
						m: 'Created the group',
						s: 1,
					},
				],
			}

			Socket.group_update(users_banned.groups[id])

			if (aCallback) aCallback({ g: id })
		}
	}
}

Socket.prototype.group_update = function(group) {
	var users = []
	if (group.u.length) {
		var i = group.u.length - 1
		do {
			if (usernames[group.u[i]] && !users_banned.ban[group.u[i]])
				users.push({
					u: group.u[i],
					i: usernames[group.u[i]].image || '',
					c: usernames[group.u[i]].color || '',
				})
		} while (i--)
	}

	var group_update = {
		id: 'group update',
		g: compress({
			id: group.id,
			u: users,
			m: group.m,
		}),
	}

	if (group.u.length) {
		var i = group.u.length - 1
		var sockets = Socket.get_sockets_indexed()
		do {
			if (usernames[group.u[i]] && !users_banned.ban[group.u[i]]) {
				if (sockets[group.u[i]]) {
					for (var id in sockets[group.u[i]]) {
						sockets[group.u[i]][id].emit('a', group_update)
					}
				}
			}
		} while (i--)
	}
}

Socket.prototype.groups_update = function(socket, all) {
	if (socket.VPN && !socket.MOD && !users_banned.white[socket.u.username]) {
		return
	}
	if (
		!socket.LAME &&
		usernames[socket.u.username] &&
		!users_banned.ban[socket.u.username] &&
		usernames[socket.u.username].groups
	) {
		var groups = [],
			id
		for (id in usernames[socket.u.username].groups) {
			var group_id = usernames[socket.u.username].groups[id]
			if (users_banned.groups[group_id]) {
				var users = []
				if (users_banned.groups[group_id].u.length) {
					var i = users_banned.groups[group_id].u.length - 1
					do {
						if (
							usernames[users_banned.groups[group_id].u[i]] &&
							!users_banned.ban[users_banned.groups[group_id].u[i]]
						)
							users.push({
								u: users_banned.groups[group_id].u[i],
								i: usernames[users_banned.groups[group_id].u[i]].image || '',
								c: usernames[users_banned.groups[group_id].u[i]].color || '',
							})
					} while (i--)
				}

				groups.push({
					id: users_banned.groups[group_id].id,
					u: users,
					m: users_banned.groups[group_id].m,
				})
			}
		}

		if (!all)
			socket.emit('a', {
				id: 'groups update',
				g: compress(groups),
			})
		else {
			var sockets = Socket.get_sockets_for_username(socket.u.username)
			for (id in sockets) {
				sockets[id].emit('a', {
					id: 'groups update',
					g: compress(groups),
				})
			}
		}
	} else {
		socket.emit('a', {
			id: 'groups update',
			g: compress([]),
		})
	}
}

Socket.prototype.group_invite = function(socket, data, aCallback) {
	if (socket.VPN && !socket.MOD && !users_banned.white[socket.u.username]) {
		return
	}
	data.g = u.value(data.g)
	data.u = this.get_username_from_username(u.value(data.u))

	if (
		data.u != 'Lame Guest' &&
		!socket.LAME &&
		usernames[socket.u.username] &&
		usernames[socket.u.username].groups &&
		usernames[socket.u.username].groups.indexOf(data.g) !== -1 &&
		users_banned.groups[data.g] &&
		usernames[data.u] &&
		usernames[data.u].confirmed === true &&
		!users_banned.ban[data.u] &&
		users_banned.groups[data.g].u.indexOf(data.u) === -1 &&
		(!usernames[data.u].wallf ||
			(usernames[data.u].friend && usernames[data.u].friend[socket.u.username]))
	) {
		if (did_i_block_user(data.u, socket.u.username)) {
			socket.emit('a', {
				id: 'messages',
				type: 'system',
				message: 'You cannot invite, this user blocked you.',
			})
			/*LM(
				socket,

				'GROUP CHAT INVITE BLOCK ' +
					Socket.mod_update_link_user(socket.u.username) +
					' blocked from inviting ' +
					Socket.mod_update_link_user(data.u)
			)*/
			return
		}

		if (!usernames[data.u].groups) usernames[data.u].groups = []

		if (
			!socket.MOD &&
			usernames[data.u].groups.length > Socket.GROUPS_PER_USER_MAX &&
			!mods[data.u]
		)
			socket.emit('a', {
				id: 'messages',
				type: 'system',
				message: 'This user is on too many groups.',
			})
		else if (
			users_banned.groups[data.g].u.length > Socket.GROUP_USERS_MAX &&
			!socket.MOD &&
			!mods[data.u]
		)
			socket.emit('a', {
				id: 'messages',
				type: 'system',
				message: 'This group has already too many users.',
			})
		else {
			users_banned.groups[data.g].u.push(data.u)
			users_banned.groups[data.g].m.push({
				id: u.now,
				u: 'MOBC',
				m: socket.u.username + ' Invited ' + data.u,
				s: 1,
			})

			usernames[data.u].groups.push(data.g)
			Socket.group_update(users_banned.groups[data.g])
			if (aCallback) aCallback()
		}
	} else {
		if (!usernames[data.u]) {
			socket.emit('a', {
				id: 'messages',
				type: 'system',
				message: 'The user does not exists.',
			})
		} else {
			socket.emit('a', {
				id: 'messages',
				type: 'system',
				message: 'Cannot invite for one of too many reasons.',
			})
		}
	}
}

Socket.prototype.group_leave = function(socket, data) {
	if (socket.VPN && !socket.MOD && !users_banned.white[socket.u.username]) {
		return
	}
	data.g = u.value(data.g)
	if (
		!socket.LAME &&
		usernames[socket.u.username] &&
		usernames[socket.u.username].groups &&
		usernames[socket.u.username].groups.length
	) {
		u.removeValueFromArray(usernames[socket.u.username].groups, data.g)
		if (users_banned.groups[data.g]) {
			u.removeValueFromArray(users_banned.groups[data.g].u, socket.u.username)

			if (users_banned.groups[data.g].u.length === 0) {
				delete users_banned.groups[data.g]
			} else {
				users_banned.groups[data.g].m.push({
					id: u.now,
					u: 'MOBC',
					m: socket.u.username + ' left the group',
					s: 1,
				})

				this.group_update(users_banned.groups[data.g])
			}

			this.groups_update(socket, true)
		}
	}
}

Socket.prototype.group_chat_message = function(socket, data) {
	if (socket.VPN && !socket.MOD && !users_banned.white[socket.u.username]) {
		return
	}
	data.g = u.value(data.g)

	if (socket.MOD) data.m = u.valueMultiline(data.m, 30000)
	else data.m = u.valueMultiline(data.m, 1500)

	if (
		!socket.LAME &&
		usernames[socket.u.username] &&
		usernames[socket.u.username].groups &&
		usernames[socket.u.username].groups.length &&
		usernames[socket.u.username].groups.indexOf(data.g) !== -1 &&
		users_banned.groups[data.g]
	) {
		var group = users_banned.groups[data.g]
		if (/^\/add /.test(data.m)) {
			Socket.group_invite(socket, {
				g: data.g,
				u: data.m.replace(/^\/add +/, ''),
			})
			return
		} else if (/^\/remove /.test(data.m)) {
			if (users_banned.groups[data.g].u[0] === socket.u.username || socket.MOD) {
				var user = this.get_username_from_username(data.m.replace(/^\/remove +/, ''))

				if (usernames[user]) {
					u.removeValueFromArray(usernames[user].groups, data.g)
					if (users_banned.groups[data.g]) {
						u.removeValueFromArray(users_banned.groups[data.g].u, user)

						if (users_banned.groups[data.g].u.length === 0) {
							delete users_banned.groups[data.g]
						} else {
							users_banned.groups[data.g].m.push({
								id: u.now,
								u: 'MOBC',
								m: user + ' has been removed from the group by ' + socket.u.username,
								s: 1,
							})

							this.group_update(users_banned.groups[data.g])
						}

						this.groups_update(socket, true)
						var sockets = Socket.get_sockets_for_username(user)
						if (sockets[0]) this.groups_update(sockets[0], true)
					}
				}
			}
			return
		} else if (data.m == '/list') {
			data.m = users_banned.groups[data.g].u.join(', ')
			var m = {
				id: u.now,
				u: socket.u.username,
				i: socket.u.image || '',
				c: socket.u.mcolor || '',
				mu: socket.u.underline,
				m: data.m,
			}
			socket.emit('a', {
				id: 'pc',
				m: m,
				g: group.id,
			})
			return
		} else if (data.m == '/clear') {
			group.m = []
			var m = {
				id: u.now,
				u: socket.u.username,
				i: socket.u.image || '',
				c: socket.u.mcolor || '',
				mu: socket.u.underline,
				m: 'Cleared the messages',
			}
			group.m.push(m)
			this.group_update(users_banned.groups[data.g])
			return
		} else {
			var m = {
				id: u.now,
				u: socket.u.username,
				i: socket.u.image || '',
				c: socket.u.mcolor || '',
				mu: socket.u.underline,
				m: data.m,
			}
		}

		var gm = {
			id: 'pc',
			m: m,
			g: group.id,
		}

		group.m.push(m)

		while (group.m.length > Socket.GROUP_MSG_BUFFER) {
			group.m.shift()
		}

		if (group.u.length) {
			var i = group.u.length - 1
			var sockets = Socket.get_sockets_indexed()
			do {
				if (usernames[group.u[i]] && !users_banned.ban[group.u[i]]) {
					if (sockets[group.u[i]]) {
						for (var id in sockets[group.u[i]]) {
							sockets[group.u[i]][id].emit('a', gm)
						}
					}
				}
			} while (i--)
		}
	}
}

Socket.prototype.update_user = function(socket, logged, email) {
	var user = users[email]
	if (!user) {
		user = {
			email: '',

			image: '',
			cover: '',
			status: '',
			color: '',
			ccolor: '',
			underline: '',
			pool: {},
			ip: socket.IP,
			unread: 0,
			confirmed: false,
			nohd: false,
			nospectate: false,
			nogif: false,
			cblind: false,
			nocam: false,

			nty: false,
			ntyw: false,
			ntyc: false,
			ntycl: false,

			fq: 0,
			fps: 60,
			fswap: false,
			nologin: false,
			noarcade: false,
			noopp: false,
			nofriend: false,
			wallf: false,
			wallfo: false,
			private: false,
			nonotify: false,
			noinline: false,
			nocolor: false,
			record: false,
			recordvideo: false,
			friend: {},
			followers: {},
			block: {},
			doing: '',
		}
	} else {
		user.login = u.now
		user.login2 = u.date()
		user.ip = socket.IP
		if (!user.sip && !socket.VPN) user.sip = socket.IP
		user.browser = socket.B
		user.browser2 = socket.B2 + ' ' + socket.tz
		user.tz = socket.tz

		if (socket.IP != '') {
			if (!user.ips) user.ips = []
			else u.removeValueFromArray(user.ips, socket.IP)
			user.ips.push(socket.IP)
			if (user.ips.length > 10) user.ips.shift()
		}

		if (socket.ID !== '') {
			if (!user.ids) user.ids = []
			else u.removeValueFromArray(user.ids, socket.ID)
			user.ids.push(socket.ID)
			if (user.ids.length > 10) user.ids.shift()
		}

		if (socket.IDU !== '') {
			if (!user.idsu) user.idsu = []
			else u.removeValueFromArray(user.idsu, socket.IDU)
			user.idsu.push(socket.IDU)
			if (user.idsu.length > 10) user.idsu.shift()
		}
	}

	socket.MOD = mods[socket.u.username] ? true : false
	socket.PU = users_banned.pu[socket.u.username] ? true : false

	socket.LAME = logged ? false : true

	user.image = user.image ? user.image : ''
	socket.u.image = user.image
	socket.confirmed = user.confirmed === true
	if (!socket.LAME && (!socket.u.image || socket.u.image == '')) {
		socket.u.image = 'https://omgmobc.com/img/profile.png'
	}

	socket.u.cover = user.cover ? user.cover : ''
	socket.u.status = user.status ? user.status : ''
	socket.u.color = user.color ? user.color : ''
	if (socket.LAME) {
		socket.u.bcolor = u.colorGenerate()
	} else {
		delete socket.u.bcolor
		if (socket.u.image == 'https://omgmobc.com/img/profile.png') socket.u.ccolor = u.colorGenerate()
		else delete socket.u.ccolor
	}

	socket.u.mcolor = user.ccolor || u.colorGenerate()
	socket.u.underline = user.underline || ''

	socket.u.mccolor = user.scolor

	socket.u.waitingbg = user.waitingbg
	socket.u.waitingbg2 = user.waitingbg2
	socket.u.waitingbg3 = user.waitingbg3
	socket.u.plink = user.plink ? user.plink.split('\n')[0] : ''
	socket.u.smcolor = user.smcolor

	socket.u.pool = user.pool ? user.pool : {}

	socket.u.donated = user.donated ? true : false
	if (!user.arcade) user.arcade = {}

	socket.u.arcade = user.arcade

	if (!socket.LAME) {
		multiple_account_trace(socket.ID, socket.IDU, socket.IP, socket.u.username)
	}

	if (
		!socket.MOD &&
		!users_banned.white[socket.u.username] &&
		(socket.IP === '' || users_banned.ban[socket.u.username] || users_banned.ban[socket.IP])
	) {
		socket.IS_BANNED = true
		setTimeout(function() {
			if (socket) {
				Socket.kill(socket, 'BANNED')
			}
		}, 1000)
	} else {
		socket.emit('a', {
			id: 'login',
			u: {
				id: socket.u.id,
				username: socket.u.username,
				email: user.email,

				image: socket.u.image,
				cover: socket.u.cover,
				status: socket.u.status,
				plink: user.plink,
				color: socket.u.color,
				ccolor: user.ccolor || '',

				border: user.border || '',
				scolor: user.scolor || '',
				waitingbg: user.waitingbg || '',
				waitingbg2: user.waitingbg2 || '',
				waitingbg3: user.waitingbg3 || '',
				emojihue: user.emojihue || 0,
				chathistory: user.chathistory || 100,
				profileviews: user.profileviews || '',
				lastseen: user.lastseen || '',
				tags: user.tags || '',
				smcolor: user.smcolor || '',
				sidebar: user.sidebar || '',
				wall: user.wall || '',
				sky: user.sky || '',
				underline: user.underline || '',

				bcolor: socket.u.bcolor,
				pool: socket.u.pool,

				mod: socket.MOD ? true : false,
				pu: socket.PU ? true : false,

				nohd: user.nohd ? true : false,
				nospectate: user.nospectate ? true : false,
				nogif: user.nogif ? true : false,

				cblind: user.cblind ? true : false,
				nocam: user.nocam ? true : false,

				nty: user.nty === undefined || user.nty ? true : false,
				ntyw: user.ntyw === undefined || user.ntyw ? true : false,
				ntyc: user.ntyc === undefined || user.ntyc ? true : false,
				ntycl: user.ntycl === undefined || user.ntycl ? true : false,

				fps: user.fps ? user.fps : 60,
				fswap: user.fswap ? true : false,
				fq: user.fq ? +user.fq : 0,
				nologin: user.nologin ? true : false,
				noarcade: user.noarcade ? true : false,
				noopp: user.noopp ? true : false,
				nofriend: user.nofriend ? true : false,
				wallf: user.wallf ? true : false,
				wallfo: user.wallfo ? true : false,
				private: user.private ? true : false,
				nonotify: user.nonotify ? true : false,
				noinline: user.noinline ? true : false,
				nocolor: user.nocolor ? true : false,
				record: user.record ? true : false,
				recordvideo: user.recordvideo ? true : false,

				donated: user.donated ? true : false,
				confirmed: user.confirmed === true,
				friend: user.friend || {},
				followers: user.followers || {},
				block: user.block,
				doing: user.doing || '',
			},
			unread: user.unread ? user.unread : 0,
			logged: logged,
		})

		this.groups_update(socket)

		if (socket.notified_online != socket.u.username) {
			socket.notified_online = socket.u.username

			Socket.update_users_online()

			for (var user in users_online) {
				if (
					usernames[user] &&
					usernames[socket.u.username] &&
					usernames[user].friend &&
					usernames[socket.u.username].friend &&
					usernames[user].friend[socket.u.username] &&
					usernames[socket.u.username].friend[user]
				) {
					var online = Socket.get_online_friends(user)
					var key = JSON.stringify(online)
					for (var id in users_online[user]) {
						if (users_online[user][id].online != key) {
							users_online[user][id].online = key
							users_online[user][id].emit('f', online)
						}
					}
				}
			}
			Socket.update_online_friends(socket.u.username)
		}
	}
}

Socket.prototype.user_viewing_lobby = function(socket, data, callback) {
	socket.u.viewingLobby = data.v ? true : false

	if (socket.u.viewingLobby) Socket.send_rooms(socket)
}

Socket.prototype.chat_indicate = function(socket, data, callback) {
	if (socket.LAME) {
		return
	}
	if (data.r || data.g === undefined) {
		data.r = data.r || 'lobby'
		if (data.r != socket.ROOM) {
			return
		}
		if (data.r == 'lobby' && users_banned.lobby[socket.u.username]) {
		} else {
			io.to(data.r).emit('ti', {
				v: data.v ? true : false,
				u: socket.u.username,
			})
		}
	} else {
		data.g = u.value(data.g)

		var group = users_banned.groups[data.g]

		if (group && group.u && group.u.length) {
			var data = {
				v: data.v ? true : false,
				u: socket.u.username,
				g: data.g,
			}
			var i = group.u.length - 1
			var sockets = Socket.get_sockets_indexed()
			do {
				if (usernames[group.u[i]] && !users_banned.ban[group.u[i]]) {
					if (sockets[group.u[i]]) {
						for (var id in sockets[group.u[i]]) {
							sockets[group.u[i]][id].emit('ti', data)
						}
					}
				}
			} while (i--)
		}
	}
}

Socket.prototype.singing_indicate = function(socket, data, callback) {
	if (socket.LAME) {
		return
	}
	if (data.r || data.g === undefined) {
		data.r = data.r || 'lobby'
		if (data.r != socket.ROOM) {
			return
		}
		if (data.r == 'lobby' && users_banned.lobby[socket.u.username]) {
		} else {
			io.to(data.r).emit('si', {
				v: data.v ? true : false,
				u: socket.u.username,
			})
		}
	} else {
		data.g = u.value(data.g)

		var group = users_banned.groups[data.g]

		if (group && group.u && group.u.length) {
			var data = {
				v: data.v ? true : false,
				u: socket.u.username,
				g: data.g,
			}
			var i = group.u.length - 1
			var sockets = Socket.get_sockets_indexed()
			do {
				if (usernames[group.u[i]] && !users_banned.ban[group.u[i]]) {
					if (sockets[group.u[i]]) {
						for (var id in sockets[group.u[i]]) {
							sockets[group.u[i]][id].emit('si', data)
						}
					}
				}
			} while (i--)
		}
	}
}

Socket.prototype.ticket = function(socket, data, callback) {
	if (socket.LAME && data.type !== 'update') {
		return
	}
	if (data.tid) data.tid = +data.tid
	switch (data.type) {
		case 'update':
			socket.emit('tsup', compress(users_banned.tickets))
			break
		case 'update_t':
			socket.emit('tup', users_banned.tickets[data.tid])
			break
		case 'open':
			data.t.status = u.value(data.t.status)
			data.t.title = u.value(data.t.title, 200)
			data.t.type = +data.t.type
			data.t.category = +data.t.category
			data.t.m[0].u = socket.u.username
			data.t.m[0].i = usernames[socket.u.username].image || ''
			data.t.m[0].m = u.valueMultiline(data.t.m[0].m, 10000)
			data.t.m[0].t = u.now
			data.t.id = users_banned.tickets.length
			data.t.s = { [socket.u.username]: true, 'omgmobc.com': true }
			users_banned.tickets.push(data.t)
			var id = users_banned.tickets.length - 1
			socket.emit('tup', data.t)
			if (socket.u.username !== 'omgmobc.com')
				profile_post_ticket_sub({
					u: 'omgmobc.com',
					v: `New ticket https://omgmobc.com/index.html#p/Issues/${id} from ${
						socket.u.username
					}\n${'> ' +
						data.t.title
							.trim()
							.split('\n')
							.join('\n> ')}`,
				})
			break
		case 'close':
			if (mods[socket.u.username]) {
				data.m.u = socket.u.username
				data.m.a = u.value(data.m.a)
				data.m.t = u.now
				users_banned.tickets[data.tid].status = 'closed'
				users_banned.tickets[data.tid].m.push(data.m)
				socket.emit('tup', users_banned.tickets[data.tid])
			} else {
				LM(
					socket,

					'trying to close ticket ' + Socket.mod_update_link_user(socket.u.username),
				)
			}
			break
		case 'reopen':
			if (mods[socket.u.username]) {
				data.m.u = socket.u.username
				data.m.a = u.value(data.m.a)
				data.m.t = u.now
				users_banned.tickets[data.tid].status = 'open'
				users_banned.tickets[data.tid].m.push(data.m)
				socket.emit('tup', users_banned.tickets[data.tid])
			} else {
				LM(
					socket,

					'trying to reopen ticket ' + Socket.mod_update_link_user(socket.u.username),
				)
			}
			break
		case 'add_c':
			data.m.u = socket.u.username
			if (data.m.m) {
				data.m.m = u.valueMultiline(data.m.m, 10000)
				data.m.i = usernames[socket.u.username].image || ''
			}
			if (data.m.a) data.m.a = u.value(data.m.a)
			data.m.t = u.now
			var ticket = users_banned.tickets[data.tid]
			if (ticket.s[socket.u.username] !== true) ticket.s[socket.u.username] = true
			ticket.m.push(data.m)
			socket.emit('tup', ticket)
			if (data.m.m && ticket.s) {
				Object.keys(ticket.s).forEach(sub => {
					if (sub !== socket.u.username)
						profile_post_ticket_sub({
							u: sub,
							v: `New comment on https://omgmobc.com/index.html#p/Issues/${data.tid} from ${
								data.m.u
							}\n${'> ' +
								data.m.m
									.trim()
									.split('\n')
									.join('\n> ')}`,
						})
				})
			}
			break
		case 'rename':
			if (mods[socket.u.username]) {
				if (users_banned.tickets[data.tid].category) {
					data.m.u = socket.u.username
					data.m.a = u.value(data.m.a)
					data.m.t = u.now
					users_banned.tickets[data.tid].m.push(data.m)
				}
				data.t = u.value(data.t, 200)
				users_banned.tickets[data.tid].title = data.t
				socket.emit('tup', users_banned.tickets[data.tid])
			} else {
				LM(
					socket,

					'trying to rename ticket ' + Socket.mod_update_link_user(socket.u.username),
				)
			}
			break
		case 'hide':
			if (mods[socket.u.username]) {
				data.m.u = socket.u.username
				data.m.a = u.value(data.m.a)
				data.m.t = u.now
				users_banned.tickets[data.tid].m.push(data.m)
				users_banned.tickets[data.tid].hidden = true
				users_banned.tickets[data.tid].status = 'closed'
				socket.emit('tup', users_banned.tickets[data.tid])
			} else {
				LM(
					socket,

					'trying to hide ticket ' + Socket.mod_update_link_user(socket.u.username),
				)
			}
			break
		case 'clear':
			if (mods[socket.u.username]) {
				users_banned.tickets = []
				socket.emit('tsup', users_banned.tickets)
			} else {
				LM(
					socket,

					'trying to clear tickets ' + Socket.mod_update_link_user(socket.u.username),
				)
			}
			break
		case 'toggle-sub':
			var ticket = users_banned.tickets[data.tid]
			if (ticket.s == undefined) ticket.s = {}
			if (ticket.s[socket.u.username] == true) ticket.s[socket.u.username] = undefined
			else ticket.s[socket.u.username] = true
			socket.emit('tup', ticket)
			break
		case 'edit-comment':
			data.cid = +data.cid
			if (users_banned.tickets[data.tid].m[data.cid].u === socket.u.username) {
				data.m = u.valueMultiline(data.m)
				users_banned.tickets[data.tid].m[data.cid].m = data.m
				users_banned.tickets[data.tid].m[data.cid].e = u.now
				socket.emit('tup', users_banned.tickets[data.tid])
			} else {
				LM(
					socket,

					'trying to edit unowned ticket comment ' + Socket.mod_update_link_user(socket.u.username),
				)
			}
			break
		case 'toggle-like':
			var ticket = users_banned.tickets[data.tid]
			if (!ticket.h) ticket.h = {}
			if (ticket.h[socket.u.username] == true) ticket.h[socket.u.username] = undefined
			else {
				ticket.h[socket.u.username] = true
				if (ticket.s[socket.u.username] !== true) ticket.s[socket.u.username] = true
			}
			socket.emit('tup', ticket)
			break
		case 'set-type':
			if (mods[socket.u.username]) {
				var ticket = users_banned.tickets[data.tid]
				if (ticket.type != undefined && ticket.status === 'open') {
					data.m.u = socket.u.username
					data.m.a = u.value(data.m.a)
					data.m.t = u.now
					ticket.m.push(data.m)
				}
				ticket.type = +data.ty
				socket.emit('tup', ticket)
			} else {
				LM(
					socket,

					'trying to set type on ticket ' + Socket.mod_update_link_user(socket.u.username),
				)
			}
			break
		case 'set-category':
			if (mods[socket.u.username]) {
				var ticket = users_banned.tickets[data.tid]
				if (ticket.category != undefined && ticket.status === 'open') {
					data.m.u = socket.u.username
					data.m.a = u.value(data.m.a)
					data.m.t = u.now
					ticket.m.push(data.m)
				}
				ticket.category = +data.c
				socket.emit('tup', ticket)
			} else {
				LM(
					socket,

					'trying to set category on ticket ' + Socket.mod_update_link_user(socket.u.username),
				)
			}
			break
		default:
			return
	}
}

function profile_post_ticket_sub(data) {
	Socket.profile_post(
		{
			ID: 1,
			IDU: 1,
			MOD: true,
			LAME: false,
			emit: function() {},
			u: {
				username: 'Issue Tracker',
				image: usernames['Issue Tracker'].image,
			},
		},
		{
			u: data.u,
			v: data.v,
			p: true,
		},
	)
}

Socket.prototype.action = function(socket, data, callback) {
	if (data.id == 'tang') {
		if (socket.u) {
			socket.u.tang = +data.d
			socket.emit('tong')
			return
		}
	}

	if (data.id != 'skp') socket.REQUESTS++

	if (socket.REQUESTS % 40000 === 0) {
		Socket.kill(socket, 'warning requests: ' + socket.REQUESTS)
		LM(socket, 'warning requests: ' + socket.REQUESTS)
		console.log(
			'warning requests: ' +
				socket.REQUESTS +
				':' +
				socket.u.username +
				':' +
				socket.IP +
				':' +
				JSON.stringify(data, null, 2),
		)
	}

	// update last seen
	if (!socket.LAME && usernames[socket.u.username] && data.id != 'wt') {
		usernames[socket.u.username].login = u.now
	}

	var hrstart = process.hrtime()
	switch (data.id) {
		case 'c': {
			this.chat(socket, data)
			break
		}

		case 'tf': {
			if (socket.u) socket.focused = socket.u.focused = data.v ? true : false
			else socket.focused = data.v ? true : false
			break
		}

		case 'pool': {
			this.game_pool(socket, data)
			break
		}

		case 'sw': {
			this.game_swapples(socket, data)
			break
		}
		case 'lb': {
			this.game_loonobum(socket, data)
			break
		}
		case 'pk': {
			this.game_poker(socket, data)
			break
		}

		case 'atest': {
			this.game_atest(socket, data)
			break
		}

		case 'pm': {
			this.game_cuacka(socket, data)
			break
		}

		case 'dp': {
			this.game_dinglepop(socket, data)
			break
		}

		case 'dp2': {
			this.game_dinglepop2(socket, data)
			break
		}

		case 'checkers': {
			this.game_checkers(socket, data)
			break
		}

		case 'bl': {
			this.game_blockles(socket, data)
			break
		}

		case 'blm': {
			this.game_blocklesmulti(socket, data)
			break
		}

		case 'blc': {
			if (rooms[socket.ROOM] && rooms[socket.ROOM].game) {
				if (rooms[socket.ROOM].game == 'balloonoboot') {
					this.game_balloonoboot(socket, data)
				} else {
					this.game_balloono(socket, data)
				}
			}
			break
		}

		case 'gm': {
			this.game_gemmers(socket, data)
			break
		}

		case 'wt': {
			this.game_wt(socket, data)
			break
		}

		case 'wts': {
			this.game_wts(socket, data, callback)
			break
		}

		case 'tk3': {
			this.game_tonk3(socket, data)
			break
		}

		case 'skp': {
			this.game_skypigs(socket, data)
			break
		}

		case 'login': {
			this.login(socket, data, callback)
			break
		}

		case 'logout': {
			this.logout(socket, data)
			break
		}

		case 'settings': {
			this.settings(socket, data, callback)
			break
		}

		case 'profile block': {
			this.profile_block(socket, data, callback)
			break
		}

		case 'friend': {
			Socket.update_users_online()
			this.friend(socket, data)
			break
		}

		case 'friend status': {
			this.friend_status(socket, data, callback)
		}

		case 'gallery': {
			this.gallery(socket, data, callback)
			break
		}

		case 'room create': {
			this.room_create(socket, data)
			break
		}

		case 'room leave': {
			this.room_leave(socket, data)
			break
		}

		case 'room join': {
			this.room_join(socket, data)

			break
		}
		case 'boobs': {
			if (socket.ROOM && socket.ROOM != 'lobby' && socket.ROOM != '') {
				io.to(socket.ROOM).emit('b', socket.u.username + ' boo boo')
			}
			break
		}
		case 'loaded': {
			io.to(socket.ROOM).emit('b', socket.u.username + ' loaded')
			break
		}

		case 'room rotate': {
			this.room_rotate(socket, data)
			break
		}

		case 'room switch to': {
			this.room_switch_to(socket, data)
			break
		}

		case 'room rotate opponent': {
			this.room_rotate_opponent(socket, data)
			break
		}

		case 'room clear kicks': {
			this.room_clear_kicks(socket, data)
			break
		}
		case 'rmed': {
			this.room_medals(socket, data)
			break
		}

		case 'forgot': {
			this.forgot_password(socket, data)
			break
		}

		case 'signup': {
			this.signup(socket, data, callback)
			break
		}

		case 'profile': {
			this.profile(socket, data, callback)
			break
		}

		case 'profile remove block': {
			this.profile_remove_block(socket, data, callback)
			break
		}

		case 'profile remove': {
			this.profile_remove(socket, data, callback)
			break
		}
		case 'profile remove all by': {
			this.profile_remove_all_by(socket, data, callback)
			break
		}

		case 'profile post': {
			this.profile_post(socket, data, callback)
			break
		}
		case 'profile post as mobc': {
			this.profile_post_as_mobc(socket, data, callback)
			break
		}
		case 'profile post soapbox': {
			this.profile_post_soapbox(socket, data, callback)
			break
		}

		case 'profile reset password': {
			this.profile_reset_password(socket, data, callback)
			break
		}

		case 'profile reset profile': {
			this.profile_reset(socket, data, callback)
			break
		}
		case 'profile rename': {
			this.profile_rename(socket, data, callback)
			break
		}

		case 'profile clear wall': {
			this.profile_clear_wall(socket, data, callback)
			break
		}

		case 'profile clear blocklist': {
			this.profile_clear_blocklist(socket, data)
			break
		}
		case 'user close profile': {
			this.user_close_profile(socket, data, callback)
			break
		}
		case 'user reset profile': {
			this.user_reset_profile(socket, data, callback)
			break
		}
		case 'user reset stats': {
			this.user_reset_stats(socket, data, callback)
			break
		}
		case 'mod kick': {
			this.mod_kick(socket, data)
			break
		}
		case 'search': {
			this.search(socket, data, callback)
			break
		}

		case 'room update': {
			this.room_update(socket, data)
			break
		}

		case 'mod update': {
			this.mod_update(socket, data)
			break
		}

		case 'mod stats': {
			this.mod_stats(socket, data, callback)
			break
		}

		case 'mod log': {
			this.mod_log(socket, data, callback)
			break
		}

		case 'mod log iii': {
			this.mod_log_connected(socket, data, callback)
			break
		}

		case 'mod trace': {
			this.mod_trace(socket, data, callback)
			break
		}

		case 'mod send message site': {
			this.mod_send_message_site(socket, data, callback)
			break
		}

		case 'mod send message site chat': {
			this.mod_send_message_site_chat(socket, data, callback)
			break
		}

		case 'mod search': {
			this.mod_search(socket, data, callback)
			break
		}

		case 'mod donation toggle': {
			this.mod_donation_toggle(socket, data)
			break
		}

		case 'mod pu toggle': {
			this.mod_pu_toggle(socket, data)
			break
		}

		case 'mod disconnect': {
			this.mod_disconnect(socket, data)
			break
		}

		case 'ranking': {
			this.ranking(socket, data, callback)
			break
		}

		case 'confirm': {
			this.confirm(socket, data)
			break
		}

		case 'group new': {
			this.group_new(socket, data, callback)
			break
		}

		case 'group search': {
			this.group_search(socket, data, callback)
			break
		}

		case 'group invite': {
			this.group_invite(socket, data, callback)
			break
		}

		case 'group leave': {
			this.group_leave(socket, data, callback)
			break
		}

		case 'pc': {
			this.group_chat_message(socket, data, callback)
			break
		}

		case 'user viewing lobby': {
			this.user_viewing_lobby(socket, data, callback)
			break
		}

		case 'ti': {
			this.chat_indicate(socket, data, callback)
			break
		}
		case 'si': {
			this.singing_indicate(socket, data, callback)
			break
		}
		case 'ticket': {
			this.ticket(socket, data, callback)
			break
		}
		case 'client error': {
			fs.appendFile(
				project + '/data/log/client',
				'\n\n' +
					(socket.u && socket.u.username ? socket.u.username : '') +
					' ' +
					JSON.stringify(data.d, null, 2),
				'utf8',
				function() {},
			)

			break
		}

		default: {
			LM(socket, '  GARBAGE received from user ')

			console.log(data)
			break
		}
	}

	var hrend = process.hrtime(hrstart)
	var time = (hrend[0] * 1e9 + hrend[1]) / 1000000000
	if (time > TIME_TO_BLOCK) {
		LM(socket, 'Server Blocked For ' + time.toFixed(2) + ' seconds on ' + data.id)
	}
}

Socket.prototype.error = function(socket, e) {
	L(socket, 'SOCKET ERROR')
	if (e) T(e)
}

Socket.prototype.close = function(socket, reason) {
	L(socket, 'SOCKET CLOSE')
	if (reason) L(socket, reason)
	this.gc(socket)
}

Socket.prototype.disconnect = function(socket, reason, callback) {
	if (reason && reason.indexOf('timeout') !== -1) socket.u.timeout = true

	this.gc(socket, callback)
}

Socket.prototype.kill = function(socket, message, callback) {
	if (message && !socket.killed) LM(socket, 'disconnecting : ' + message)
	if (socket) socket.killed = true
	this.disconnect(socket, message, function() {
		socket.disconnect(true)
		if (callback) callback()
	})
}

Socket.prototype.gc = function(socket, callback) {
	this.leave(socket, function() {
		if (callback) callback()
	})
}

function inspectSocket() {
	return '{socket}'
}

function on_error(data) {
	Socket.error(this, data)
}

function on_close(data) {
	Socket.close(this, data)
}

function on_disconnect(data) {
	Socket.disconnect(this, data)
}

function on_a(data, callback) {
	Socket.action(this, data, callback)
}

if (wtf) {
	console.log('json parsing failed, crashing')
} else {
	var network = require('./network.js').network
	var local = network.local

	LOG('<br>• INIT ')

	Socket = new Socket()

	var io = network.io()

	Socket.update_today()
	io.use(function(socket, next) {
		socket.inspect = inspectSocket

		socket.REQUESTS = 2

		if (users_banned.user_id > 250000) {
			users_banned.user_id = 1
		}

		socket.u = {
			username: 'Lame Guest ' + ++users_banned.user_id,
			id: users_banned.user_id,
			l: true,
		}
		socket.ID = ''
		socket.IDU = ''
		socket.B = ''
		socket.RN = 0
		socket.LAME = true

		var ip
		socket.IP = []

		/*
		they can cheat their ip address if we enabled this and we are not using a proxy to connect here
		if ((ip = u.isIPPublic(socket.client.request.headers['x-forwarded-for']))) socket.IP.push(ip)
		else */ if (
			(ip = u.isIPPublic(socket.client.conn.remoteAddress))
		)
			socket.IP.push(ip)
		else if ((ip = u.isIPPublic(socket.handshake.address))) socket.IP.push(ip)
		else if ((ip = u.isIPPublic(socket.request.socket.remoteAddress))) socket.IP.push(ip)
		socket.IP.sort()
		socket.IP = u.arrayUnique(socket.IP)

		socket.IP = socket.IP.length !== 1 ? '' : socket.IP.join('')
		if (socket.IP === '' && local) socket.IP = '127.0.0.1'
		socket.VPN = Socket.mod_ip_is_vpn(socket.IP)
		socket.CC = network.IPLocation(socket.IP)[0]
		socket.NET = network.IPLocation(socket.IP)[1]

		var browser = socket.client.request.headers['user-agent'] || ''
		browser = browser.toLowerCase()
		if (browser.indexOf('edge') !== -1) socket.B = 'Edge'
		else if (browser.indexOf('maxthon') !== -1) socket.B = 'Maxton'
		else if (browser.indexOf('chrome/') !== -1)
			socket.B = browser.replace(/.*(chrome\/[0-9]+).*/, '$1')
		else if (browser.indexOf('fox/') !== -1) socket.B = 'Firefox'
		else if (browser.indexOf('safari/') !== -1) socket.B = 'Safari'
		else if (browser.indexOf('msie') !== -1) socket.B = 'IE'
		else if (browser.indexOf('opr/') !== -1 || browser.indexOf('opera/') !== -1) socket.B = 'Opera'
		else if (browser.indexOf('trident') !== -1) socket.B = 'Trident'
		else if (
			browser.indexOf('iphone') !== -1 ||
			browser.indexOf('ipad') !== -1 ||
			browser.indexOf('os x') !== -1
		)
			socket.B = 'iOSX'
		else socket.B = (browser || '').trim()
		socket.B2 = socket.client.request.headers['user-agent'] || ''

		Fast(socket)
		Fast(socket.u)
		if (socket.B === '') {
			LM(socket, 'BAN bot browser/ip refreshing ' + Socket.mod_update_link_ip(socket.IP))
			return next(new Error(''))
		} else {
			return next()
		}
	})

	io.on('connection', function(socket) {
		socket.ROOM = ''

		socket.client.request.headers = socket.handshake.headers = socket.request.headers = socket.request.rawHeaders = null

		socket.on('error', on_error)
		socket.on('close', on_close)
		socket.on('disconnect', on_disconnect)
		socket.on('a', on_a)
	})

	function save() {
		async function on_exit() {
			// when isnt local we should always save the database!
			if (!local) {
				return Socket.do_io()
			} else {
				try {
					if (require('../localhost.json').save_database_on_exit) {
						return Socket.do_io()
					}
				} catch (e) {
					return Socket.do_io()
				}
			}
		}

		exit_handler.callback = on_exit

		setInterval(function() {
			Socket.do_io()
		}, 3600 * 1000 * 12)
	}
	save()

	setInterval(function() {
		Socket.update_today()
	}, 3600 * 1000 * 1) // every hour
}
