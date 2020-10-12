var Socket = function () {
	ios = io
	this.now = Date.now()
	var opts = {
		reconnectionAttempts: 60,
		reconnectionDelay: 1000,
		reconnectionDelayMax: 20 * 1000,
		rememberUpgrade: true,
		transports: ['websocket'],
	}
	this.reasons = ['', 'forced close', 'io server disconnect']

	if (location.host.indexOf('omgmobc.com') !== -1)
		ios = io.connect('wss://s.omgmobc.com:8080', opts)
	else ios = io.connect(location.host, opts)

	this.didDisconnect = false

	this.tang = this.tang.bind(this)
	this.tong = this.tong.bind(this)
	setInterval(this.tang, 20000)
	setTimeout(this.tang, 1000)
	setTimeout(this.tang, 3000)
	window.addEventListener(
		'beforeunload',
		function (event) {
			this.dontReconnect = true
			this.disconnect()
		}.bind(this),
	)
}

Socket.prototype.tang_time = 0
Socket.prototype.tang_sent = 0
// table

Socket.prototype.tang = function () {
	var now = Date.now()
	this.tang_sent = now
	emit({
		id: 'tang',
		d: this.tang_time,
	})
}
Socket.prototype.reconnect = function () {
	if (!this.dontReconnect) {
		pageUnmount()

		clearInterval(this.reconnecting_timeout)
		this.reconnecting_timeout = setInterval(function () {
			socket.connect()
		}, 1000)
	}
}

Socket.prototype.tong = function () {
	this.tang_time = Math.round((Date.now() - this.tang_sent) * 0.5)
}

Socket.prototype.disconnect = function () {
	this.didDisconnect = true
	ios.sendBuffer = []
	ios.disconnect()
}
Socket.prototype.connect = function () {
	if (!this.dontReconnect) {
		//this.disconnect()

		this.didDisconnect = false
		ios.sendBuffer = []

		//pageUnmount()
		if (ios.io.readyState !== 'opening' && ios.io.readyState !== 'open') {
			ios.connect()
		}
		var room = window.room && window.room.id

		clearInterval(this.reconnecting_timeout)
		window.login(null, function () {
			if (room && room != '') {
				emit({
					id: 'room join',
					room_id: room,
					boobs: true,
				})
			} else {
				emit({
					id: 'room leave',
				})
			}
			setTimeout(function () {
				emit({ id: 'boobs' })
			}, 600)
			/*window.incoming({
				un: 'MOBC',
				ui: 1,
				m: 'Internet boo boo',
			})*/
		})
	}
}
Socket.prototype.load = function () {
	ios.on('connect', function () {
		clearInterval(this.reconnecting_timeout)
		body.attr('data-status', 'connected')
	})

	ios.on('reconnect', function (a, b) {
		clearInterval(this.reconnecting_timeout)
		body.attr('data-status', 'connected')
		ios.sendBuffer = []
	})
	if (ios.connected) body.attr('data-status', 'connected')

	ios.on('reconnecting', function (a, b) {
		body.attr('data-status', 'connecting')
	})
	ios.on('reconnect_attempt', function (a, b) {
		body.attr('data-status', 'connecting')
	})

	ios.on(
		'reconnect_error',
		function (a, b) {
			body.attr('data-status', 'disconnected')
			socket.disconnect()
			this.reconnect()
		}.bind(this),
	)
	ios.on(
		'reconnect_failed',
		function (a, b) {
			body.attr('data-status', 'disconnected')
			socket.disconnect()
			this.reconnect()
		}.bind(this),
	)
	ios.on(
		'connect_error',
		function (a, b) {
			body.attr('data-status', 'disconnected')
			socket.disconnect()
			this.reconnect()
		}.bind(this),
	)
	ios.on(
		'error',
		function (reason, a, b) {
			if (socket.reasons.indexOf(reason) !== -1) {
				socket.dontReconnect = true
			}
			socket.disconnect()
			this.reconnect()
		}.bind(this),
	)

	ios.on(
		'disconnect',
		function (reason, a, b) {
			body.attr('data-status', 'disconnected')
			if (socket.reasons.indexOf(reason) !== -1) {
				socket.dontReconnect = true
			}
			socket.disconnect()
			this.reconnect()
		}.bind(this),
	)
	ios.on(
		'close',
		function (a, b) {
			body.attr('data-status', 'disconnected')
			socket.disconnect()
			this.reconnect()
		}.bind(this),
	)
	ios.on(
		'connect_timeout',
		function (a, b) {
			body.attr('data-status', 'disconnected')
			socket.disconnect()
			this.reconnect()
		}.bind(this),
	)

	ios.on('r', function () {
		u.reload()
	})
	ios.on('g', function (data) {
		location.href = data
	})
	ios.on('gr', function (data) {
		location.replace(data)
	})
	ios.on('gb', function (data) {
		history.back()
	})
	ios.on('cp', function (data) {
		pageUnmount()
	})
	ios.on('tong', this.tong)
}
