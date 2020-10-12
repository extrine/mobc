'use strict'

function network() {}

network.prototype.io = function() {
	var fs = require('fs')
	var path = require('path')

	var express = require('express')
	var app = express()

	var server
	if (this.local) server = this.http.createServer(app)
	else
		server = this.https.createServer(
			{
				cert: fs.readFileSync('/etc/letsencrypt/live/s.omgmobc.com/fullchain.pem'),
				key: fs.readFileSync('/etc/letsencrypt/live/s.omgmobc.com/privkey.pem'),
			},
			app,
		)

	var opts = {
		origins: '*:*',
		transports: ['websocket'],
		cookie: false,
		pingTimeout: 1000 * 60,
		pingInterval: 1000 * 25,
		perMessageDeflate: false,
	}

	if (this.local) opts.origins = '*:*'
	else opts.origins = 'omgmobc.com:* s.omgmobc.com:*'

	app.disable('x-powered-by')
	app.disable('server')
	app.disable('via')

	if (this.local) {
		app.use(express['static'](path.resolve(this.project + 'www.client/')))
	}

	var io = require('socket.io')(server, opts)

	if (this.local) server.listen(process.env.port)
	else server.listen(8080)

	return io
}

network.prototype.fetch = function(u, callback) {
	var http
	if (u.indexOf('https') === 0) http = this.https
	else http = this.http

	u = this.url.parse(u)
	var called = false

	function aCallback(body) {
		if (!called) {
			called = true
			if (callback) callback(u.href, String(body || ''))
		}
	}

	var options = {
		hostname: u.hostname,
		port: u.port || (u.href.indexOf('https') === 0 ? 443 : 80),
		path: u.path || '/',
		method: 'GET',
		encoding: null,
		headers: {
			Accept: 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
			'Accept-Encoding': 'gzip, deflate, sdch',
			'Accept-Language': 'en-GB,en;q=0.8,es;q=0.6',
			Connection: 'keep-alive',
			'User-Agent':
				'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.87 Safari/537.36',
		},
	}
	var req = http.get(options, function(res) {
		var data = []
		res.on('data', function(c) {
			data.push(c)
		})
		res.on('end', function() {
			var buffer = Buffer.concat(data)
			var e = res.headers['content-encoding'] || ''
			if (e == 'gzip') {
				network.zlib.gunzip(buffer, function(err, decoded) {
					if (err) aCallback('')
					else aCallback(decoded && decoded.toString())
				})
			} else if (e == 'deflate') {
				network.zlib.inflate(buffer, function(err, decoded) {
					if (err) aCallback('')
					else aCallback(decoded && decoded.toString())
				})
			} else aCallback(buffer.toString('utf-8'))
		})
	})
	req.on('socket', function(socket) {
		socket.setTimeout(30000)
		socket.on('timeout', function() {
			req.abort()
			aCallback('')
		})
	})
	req.on('error', function() {
		aCallback('')
	})
}

network.prototype.IPLocation = function(v) {
	return [this.ip2country(v), this.ip2network(v)]
}

network.prototype.maxmind = require('maxmind')

network.prototype._ip2country = network.prototype.maxmind.openSync(
	__dirname + '/maxmind/GeoLite2-Country.mmdb',
)
network.prototype._ip2country = network.prototype._ip2country.get.bind(
	network.prototype._ip2country,
)
network.prototype.ip2country = function(v) {
	var d = this._ip2country(v)
	return d && d.country && d.country.iso_code ? d.country.iso_code : 'NA'
}

network.prototype._ip2network = network.prototype.maxmind.openSync(
	__dirname + '/maxmind/GeoLite2-ASN.mmdb',
)
network.prototype._ip2network = network.prototype._ip2network.get.bind(
	network.prototype._ip2network,
)
network.prototype.ip2network = function(v) {
	var d = this._ip2network(v)
	return d && d.autonomous_system_organization
		? d.autonomous_system_organization.replace(/[,.]/g, '')
		: 'NA'
}

network = new network()
network.local = __dirname.indexOf('/w/') === -1
network.project = network.local ? __dirname + '/../' : __dirname + '/../../'
network.http = require('http')
network.https = require('https')
network.url = require('url')
network.zlib = require('zlib')

module.exports = {
	network: network,
}
