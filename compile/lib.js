require('events').EventEmitter.prototype.defaultMaxListeners = 0
require('events').EventEmitter.prototype.setMaxListeners(0)
process.setMaxListeners(0)

process.env.NODE_ENV = process.env.BUILD = 'production'

Promise.sync = async function(promises) {
	for (let i = 0; i < promises.length; i++) {
		await promises[i]()
	}
}
// globals

fs = require('fs')
path = require('path')

cp = require('child_process')
exec = require('child_process').exec
_spawn = require('child_process').spawn

util = require('util')
crypto = require('crypto')

glob = require('glob')
Concat = require('concat-with-sourcemaps')

config = require('../compile.js')

normalize = function(f) {
	f = path
		.resolve(f)
		.replace(/\\/g, '/')
		.replace((path.resolve(__dirname + '/../') + '/').replace(/\\/g, '/'), '')
	return f
}

project = normalize('www.client') + '/'

babel = require('@babel/core')
rollup = require('rollup')
rollup_babel = require('@rollup/plugin-babel').default || require('@rollup/plugin-babel')
rollup_nodeResolve =
	require('@rollup/plugin-node-resolve').default || require('@rollup/plugin-node-resolve')
rollup_multi = require('@rollup/plugin-multi-entry')
rollup_alias = require('@rollup/plugin-alias')

babel_config = require('./babel.js')
babel_mobx_config = require('./babel.mobx.js')
postcss = require('postcss')([
	require('postcss-preset-env')({ browsers: 'last 2 versions' }),
	require('cssnano'),
])
prettier = require('prettier')
disparity = require('disparity')

imagemin = require('imagemin')
imageminOptipng = require('imagemin-optipng')
imageminGifsicle = require('imagemin-gifsicle')
imageminJpegtran = require('imagemin-jpegtran')

process.env.port = config.port

is_osx = function() {
	return process.platform == 'darwin'
}
// log
var hr_last = false

log = function(args) {
	hr_last = false
	try {
		if (arguments.length === 1 && args.indexOf('\n') === -1) {
			console.log('\x1b[32m-> \x1b[0m' + args)
		} else {
			console.log(...arguments)
		}
	} catch (e) {
		console.log('errored', arguments)
	}
}

log_green = function(args) {
	hr_last = false
	if (arguments.length === 1 && args.indexOf('\n') === -1) {
		console.log('\x1b[32m' + args + '\x1b[0m')
	} else {
		console.log('\x1b[32m', ...arguments, '\x1b[0m')
	}
}

log_blue = function(args) {
	hr_last = false
	if (arguments.length === 1 && args.indexOf('\n') === -1) {
		console.log('\x1b[36m' + args + '\x1b[0m')
	} else {
		console.log('\x1b[36m', ...arguments, '\x1b[0m')
	}
}
log_error = function(args) {
	hr_last = false
	if (arguments.length === 1 && args.indexOf('\n') === -1) {
		console.log('\x1b[31m' + args + '\x1b[0m')
	} else {
		console.log('\x1b[31m', ...arguments, '\x1b[0m')
	}
}
hr = function(display) {
	if (!hr_last || display) {
		console.log('\x1b[32m' + '-'.repeat(90) + '\x1b[0m')
	}
	hr_last = true
}
hr_error = function() {
	console.log('\x1b[31m' + '-'.repeat(90) + '\x1b[0m')
}

// catch errors

stack = function(e) {
	console.log(e)
	if (e.stack && e.stack.indexOf(__dirname) === -1) {
		return e.stack
	} else if (e.stack) {
		e.stack = e.stack.split('\n')
		for (var id in e.stack) {
			if (
				e.stack[id].indexOf('    at ') === 0 &&
				(e.stack[id].indexOf('node_modules') !== -1 || e.stack[id].indexOf(__dirname) === -1)
			)
				e.stack[id] = ''
		}
		return e.stack
			.join('\n')
			.replace(/\n+\s+/g, '\n')
			.trim()
	}
	return e
}
stack_print = function(e) {
	console.log(e.stderr || e)
	//e = stack(e.stderr || e).split('\n')
	/*for (var id in e) {
		log(e[id])
	}*/
}
process.on('uncaughtException', stack_print)
process.on('unhandledRejection', stack_print)

require('blocked-at')((time, stack) => {
	if (time > 6000) log(`Blocked for ${time | 0}ms`, '\n', stack)
})

noop = function() {}
on_error = function(e) {
	console.error(e)
}

// utils
date = {
	pretty: function(now) {
		var date = new Date(now || Date.now())

		return (
			(date.getUTCMonth() < 9 ? '0' : '') +
			(date.getUTCMonth() + 1) +
			'/' +
			(date.getUTCDate() < 10 ? '0' : '') +
			date.getUTCDate() +
			' ' +
			(date.getUTCHours() < 10 ? '0' : '') +
			date.getUTCHours() +
			':' +
			(date.getUTCMinutes() < 10 ? '0' : '') +
			date.getUTCMinutes()
		)
	},
	now: function(now) {
		var date = new Date(now || Date.now())

		return (
			date.getUTCFullYear() +
			'' +
			(date.getUTCMonth() < 9 ? '0' : '') +
			(date.getUTCMonth() + 1) +
			'' +
			(date.getUTCDate() < 10 ? '0' : '') +
			date.getUTCDate() +
			'.' +
			(date.getUTCHours() < 10 ? '0' : '') +
			date.getUTCHours() +
			'' +
			(date.getUTCMinutes() < 10 ? '0' : '') +
			date.getUTCMinutes() +
			'' +
			(date.getUTCSeconds() < 10 ? '0' : '') +
			date.getUTCSeconds()
		).substr(2)
	},
	hour: function(now) {
		if (now) var date = new Date(+now)
		else var date = new Date()
		return (
			(date.getHours() < 10 ? '0' : '') +
			date.getHours() +
			'.' +
			(date.getMinutes() < 10 ? '0' : '') +
			date.getMinutes() +
			'.' +
			(date.getSeconds() < 10 ? '0' : '') +
			date.getSeconds()
		)
	},
	get version_readable() {
		// todo
		return this.now()
	},
	get version_short() {
		return this.now().replace(/\..*$/, '') // TODO
	},
}

version_time = Date.now()

title = function(s) {
	return s
		.split(' ')
		.map(function(word) {
			return word.charAt(0).toUpperCase() + word.slice(1)
		})
		.join(' ')
		.trim()
}
fixed = function(v) {
	return +v.toFixed(2)
}
enlapsed = function(v) {
	return fixed((Date.now() - v) / 1000)
}
unique = function(b) {
	var a = []
	for (var i = 0, l = b.length; i < l; i++) {
		if (a.indexOf(b[i]) === -1) a.push(b[i])
	}
	return a
}

sleep = function(seconds) {
	return new Promise(function(resolve, reject) {
		setTimeout(
			function() {
				resolve()
			}.bind(this),
			seconds * 1000,
		)
	})
}

// FILES

_read = util.promisify(fs.readFile)
_write = util.promisify(fs.writeFile)
_remove = util.promisify(fs.unlink)
_mkdir = util.promisify(fs.mkdir)

remove = function(f) {
	return _remove(f).catch(function() {
		//log('cannot delete ' + f)
	})
}
read = function(f) {
	return _read(f, 'utf8').catch(function() {
		return ''
	})
}
read_bin = function(f) {
	return _read(f)
}

write = function(f, c) {
	return _mkdir(path.dirname(f), { recursive: true }).then(function() {
		return _write(f, c || '', 'utf8')
	})
}
write_bin = function(f, c) {
	return _mkdir(path.dirname(f), { recursive: true }).then(function() {
		return _write(f, c)
	})
}

exists = function(f) {
	return new Promise(function(resolve) {
		fs.access(f, fs.constants ? fs.constants.F_OK : fs.F_OK, err => {
			resolve(err ? false : true)
		})
	})
}

diff = function(a, b) {
	var diff = disparity.unified(a, b, {
		paths: ['a', 'b'],
	})
	if (diff && diff != '') {
		console.log(diff)
	}
}

var hash_cache = {}
hash = function(s, cache) {
	if (hash_cache[s]) return hash_cache[s]

	var h = crypto
		.createHash('md5')
		.update(s)
		.digest('hex')
	if (cache) {
		hash_cache[s] = h
	}
	return h
}
hash_file = function(f, cache) {
	return read(f).then(function(c) {
		return hash(c, cache)
	})
}
files = function(f) {
	return new Promise(function(resolve, reject) {
		if (is_directory(f)) {
			return glob(
				f + '/**',
				{
					nodir: true,
					dot: true,
				},
				function(err, f) {
					if (err) resolve([])
					else resolve(f)
				},
			)
		} else {
			return resolve([f])
		}
	})
}

var watch_timeouts = {}
watch = function(w, cb, time, dont_notify_each_individual_file) {
	var k = hash(w + cb.toString())
	var as_directory = false
	function _(a, f) {
		if (f) {
			if (as_directory) {
				f = normalize(w + '/' + f)
			} else {
				f = w
			}
			if (
				f.indexOf('.cache') === -1 &&
				f.indexOf('.git') === -1 &&
				f.indexOf('/restart') === -1 &&
				f.indexOf('data.json') === -1 &&
				f.indexOf('data/') === -1 &&
				f.indexOf('node_modules') === -1 &&
				f.indexOf('package-lock.json') === -1
			) {
				clearTimeout(watch_timeouts[k + (dont_notify_each_individual_file ? '' : f)])
				watch_timeouts[k + (dont_notify_each_individual_file ? '' : f)] = setTimeout(function() {
					cb(a, f)
				}, time || 200)
			}
		}
	}

	w = normalize(w)
	if (is_directory(w)) {
		as_directory = true
		fs.watch(w, { recursive: true }, _)
	} else {
		fs.watch(w, _)
	}
}

is_directory = function(f) {
	return fs.lstatSync(f).isDirectory()
}

// processes

spawn = function(cmd) {
	return new Promise(function(resolve, reject) {
		if (cmd.running && cmd.sync) {
			log(cmd)
			throw new Error('SPAWN: IS RUNNING ALREADY?')
		}
		if (!cmd.command) {
			log(cmd)
			throw new Error('SPAWN: COMMAND IS NOT DEFINED?')
		}
		if (!cmd.cwd) {
			cmd.cwd = './'
		}

		cmd.running = true
		cmd.start = Date.now()

		spawn_command(resolve, reject, cmd)
	})
}

spawn_command = function(resolve, reject, cmd) {
	cmd.stdout = ''
	cmd.stderr = ''
	cmd.code = ''

	const subprocess = _spawn(cmd.command[0], cmd.command.slice(1), {
		shell: true,
		windowsHide: true,
		cwd: cmd.cwd,
	})
	subprocess.unref()

	subprocess.stdout.on('data', data => {
		if (data instanceof Buffer) {
			data = data.toString()
		}
		cmd.stdout += data
	})

	subprocess.stderr.on('data', data => {
		if (data instanceof Buffer) {
			data = data.toString()
		}
		if (
			data.indexOf('remote:') === 0 ||
			data.indexOf('Auto packing') === 0 ||
			(data.indexOf('From ') == 0 && /origin\/master\n$/.test(data))
		) {
		} else {
			cmd.stderr += data
		}
	})
	subprocess.on('error', data => {
		if (data instanceof Buffer) {
			data = data.toString()
		}
		if (
			data.indexOf('remote:') === 0 ||
			data.indexOf('Auto packing') === 0 ||
			(data.indexOf('From ') == 0 && /origin\/master\n$/.test(data))
		) {
		} else {
			cmd.stderr += data
		}
	})

	var closed = false

	function on_close(code) {
		exit(code)
	}
	function on_exit(code) {
		exit(code)
	}
	function on_disconnect() {
		exit(0)
	}
	function exit(code) {
		if (!closed) {
			closed = true

			cmd.code = code

			cmd.end = Date.now()
			cmd.running = false

			cmd.time = cmd.cwd + ' ' + cmd.command.join(' ') + ' in ' + enlapsed(cmd.start) + ' seconds'

			if (cmd.callback) {
				cmd.callback(cmd)
			}
			if (cmd.stderr) {
				reject(cmd)
			} else {
				resolve(cmd)
			}
		}
	}

	subprocess.on('close', on_close)
	subprocess.on('exit', on_exit)
	subprocess.on('disconnect', on_disconnect)
}

// ACTIONS

run_action = function(action) {
	return new Promise(async function(resolve, reject) {
		try {
			var promises = []

			for (var i = 0; i < action.length; i++) {
				if (action[i].sync) {
					await Promise.all(promises)
					await run_action_command(action[i])
				} else {
					promises.push(run_action_command(action[i]))
				}
			}

			await Promise.all(promises)
			resolve()
		} catch (e) {
			reject(e)
		}
	})
}

run_action_command = function(command) {
	if (typeof command.command == 'function') {
		return command.command(command)
	} else {
		return spawn(command)
	}
}

// memoize
class Cache {
	constructor() {
		this.timeout = false
		this.write = this.write.bind(this)
		this.version = 2
		try {
			this.data = require('./data.json')
			if (this.data.version != this.version) {
				throw new Error('')
			}
		} catch (e) {
			this.data = { version: this.version }
		}
	}
	add(k, v) {
		k = hash(k, true)

		this.data[k] = { d: Date.now(), v: v }
		this.save()

		return v
	}
	get(k) {
		k = hash(k, true)
		if (this.data[k]) {
			this.data[k].d = Date.now()
			this.save()
		}
		return this.data[k] ? this.data[k].v : undefined
	}

	save() {
		clearTimeout(this.timeout)
		this.timeout = setTimeout(this.write, 20000)
	}
	write() {
		if (this.running) {
			this.save()
		} else {
			this.running = true

			for (var id in this.data) {
				if (this.data[id].d < Date.now() - 3600 * 1000 * 24) {
					delete this.data[id]
				}
			}
			return write('compile/data.json', JSON.stringify(this.data)).then(
				function() {
					this.running = false
				}.bind(this),
			)
		}
	}
}
cache = new Cache()

serialize = function(o) {
	return JSON.stringify(o, this._serialize)
}
_serialize = function(k, v) {
	if (typeof v == 'function') {
		return v.name
	} else {
		return v
	}
}
is_primitive = function(o) {
	if (!o) return true

	switch (typeof o) {
		case 'string':
		case 'boolean':
		case 'number': {
			return true
		}
		default: {
			return false
		}
	}
}
memopromise = function(fn) {
	if (!fn) {
		console.error('function to memoize is undefined')
	}
	const k = fn.name + fn.toString()

	return async function(fn, k, serialize, is_primitive, ...args) {
		k = k + (args.length == 1 && is_primitive(args[0]) ? args[0] : serialize(args))
		var d = cache.get(k)
		if (d !== undefined) {
			return d
		} else {
			return cache.add(k, await fn(...args))
		}
	}.bind(null, fn, k, serialize, is_primitive)
}

memo = function(fn) {
	if (!fn) {
		console.error('function to memoize is undefined')
	}
	const k = fn.name + fn.toString()
	return function(fn, k, serialize, is_primitive, ...args) {
		k = k + (args.length == 1 && is_primitive(args[0]) ? args[0] : serialize(args))

		var d = cache.get(k)
		if (d !== undefined) {
			return d
		} else {
			return cache.add(k, fn(...args))
		}
	}.bind(null, fn, k, serialize, is_primitive)
}

// process

is_min = function(f) {
	return /(-|\.)(min|dev|development|umd)(-|\.)/.test(f)
}
prettify = function(f, code) {
	if (!is_min(f)) {
		try {
			var r = prettier.format(code, { ...require('../.prettierrc.js'), filepath: f })
			if (r != code) {
				return write(f, r)
			}
		} catch (e) {}
	}
}
process_js = function(f, code) {
	if (f.indexOf('mobx') !== -1) {
		return new Promise((resolve, reject) => {
			resolve('')
		})
	}
	return _process_js(
		f,
		code,
		f.indexOf('mobx') !== -1 ? babel_mobx_config : babel_config,
		require('./package.json'),
	)
}
process_css = function(f, code) {
	return _process_css(f, code, require('./package.json'))
}
_process_js = memopromise(function(f, code, options) {
	return new Promise((resolve, reject) => {
		if (is_min(f)) {
			resolve(code)
		} else {
			var start = Date.now()
			babel.transform(code, { ...options, filename: f }, function(err, result) {
				log(f + ' in ' + enlapsed(start) + ' seconds')
				if (err) {
					log_blue(err.toString().replace(/ at Object.*$/))
				}
				resolve(result ? result.code : '')
			})
		}
	})
})

_process_css = memopromise(function(f, code) {
	return new Promise((resolve, reject) => {
		if (is_min(f)) {
			resolve(code)
		} else {
			var start = Date.now()
			postcss
				.process(code, { from: f, map: { inline: true } })
				.then(
					function(result) {
						log(f + ' in ' + enlapsed(start) + ' seconds')
						resolve(result.css)
					}.bind(this),
				)
				.catch(function(err) {
					log_blue(err.toString().replace(/ at Object.*$/))
					resolve('')
				})
		}
	})
})

process_image_options = {
	imageminOptipng: { optimizationLevel: 4 },
	imageminGifsicle: { interlaced: true, optimizationLevel: 3 },
	imageminJpegtran: { progressive: true },
}
process_image_options_h = hash(JSON.stringify(process_image_options)).substr(0, 6)

process_image = async function(f) {
	if (/\.(png|jpg|jpeg|gif)$/i.test(f)) {
		var h = (await hash_file(f)) + process_image_options_h
		var cache = 'compile/.cache/' + h[0] + '/' + h
		if (await exists(cache)) {
			// already optimized
		} else {
			var start = Date.now()

			const original = await read_bin(f)
			const optimized = await imagemin.buffer(original, {
				plugins: [
					imageminOptipng(process_image_options.imageminOptipng),
					imageminGifsicle(process_image_options.imageminGifsicle),
					imageminJpegtran(process_image_options.imageminJpegtran),
				],
			})
			if (optimized.length > 2 && optimized.length < original.length) {
				await write_bin(f, optimized)
				var h = (await hash_file(f)) + process_image_options_h
				await write('compile/.cache/' + h[0] + '/' + h)
				log(
					f +
						' in ' +
						enlapsed(start) +
						' seconds, saved ' +
						fixed((original.length - optimized.length) / 1024) +
						'kb',
				)
			} else {
				await write(cache)
			}
		}
	}
}
ssh = function(command, callback) {
	return new Promise(function(resolve, reject) {
		var Client = require('ssh2').Client
		var conn = new Client()
		var data = ''
		conn
			.on('ready', function() {
				conn.exec(command, function(err, stream) {
					if (err) throw err
					stream
						.on('close', function(code, signal) {
							conn.end()
							log('$ ' + command + '\n')
							if (!callback) {
								log_blue(data)
								hr()
							}
							if (callback) {
								callback(data)
							}
							resolve(data)
						})
						.on('data', function(d) {
							d = d.toString().trim()
							if (d != '') {
								data += d + '\n'
							}
						})
						.stderr.on('data', function(d) {
							d = d.toString().trim()
							if (d != '') {
								data += d + '\n'
							}
						})
				})
			})
			.connect({
				host: config.ip,
				port: 22,
				username: 'root',
				privateKey: require('fs').readFileSync('www.web/id_rsa'),
			})
	})
}

// watch

Compiler = class Compiler {
	constructor() {
		this.write_js = this.write_js.bind(this)
		this.write_css = this.write_css.bind(this)
		this.compile = this.compile.bind(this)
		this.nginx_on_change = this.nginx_on_change.bind(this)
		this.on_compile = this.on_compile.bind(this)
		this.files = this.files.bind(this)

		this.paths = []
		this.watcher = {}
		this.setup()
	}
	async setup() {
		watch(
			'watch.conf',
			function() {
				this.files().then(
					function() {
						this.compile()
					}.bind(this),
				)
			}.bind(this),
		)
		watch(
			'www.client/index.template',
			function() {
				this.compile(true)
			}.bind(this),
		)

		watch('www.web/', this.nginx_on_change, 100, true)

		if (!(await exists('www.client/m/'))) {
			write('www.client/m/f.min.js')
		}

		this.files()
	}
	nginx_on_change(a, b) {
		if (b != 'restart') {
			write('www.web/restart', '1')
		}
	}
	files() {
		return read('watch.conf').then(
			async function(_paths) {
				this.running = true

				var paths = []

				_paths = _paths.trim().split('\n')
				for (let f of _paths) {
					f = f.trim()
					if (
						f != '' &&
						f.indexOf('//') === -1 &&
						f.indexOf('#') === -1 &&
						f.indexOf('webworker') === -1
					) {
						f = normalize(project + f)
						if (await exists(f)) {
							if (is_directory(f)) {
								this.add(f, this.files)
							}

							var file = await files(f)
							for (f of file) {
								// not webworker and also file not included already
								if (f.indexOf('webworker') === -1 && paths.indexOf(f) === -1) {
									paths.push(f)
								}
							}
						} else {
							log_error('the file', f, ' listed on watch.conf does not exists on file system')
						}
					}
				}

				paths.unshift(normalize(__dirname + '/client-autoreload.js'))
				for (let f of paths) {
					this.add(f)
				}

				this.paths = paths
				this.running = false
			}.bind(this),
		)
	}
	add(f, cb) {
		if (!this.watcher[f]) {
			this.watcher[f] = {
				f: f,
			}
			watch(
				f,
				async function() {
					cb && (await cb())
					this.on_change(f)
				}.bind(this),
				100,
			)
			this.on_change(f)
		}
	}

	on_change(f) {
		if (/\.jsx?$/.test(f)) {
			return read(f).then(
				function(code) {
					if (!this.start_js) {
						this.start_js = Date.now()
					}
					return (
						// prettify(f, code) ||
						process_js(f, code).then(
							function(result) {
								this.watcher[f].result = result
								this.compile()
							}.bind(this),
						)
					)
				}.bind(this),
			)
		} else if (/\.css$/.test(f)) {
			return read(f).then(
				function(code) {
					if (!this.start_css) {
						this.start_css = Date.now()
					}
					return (
						// prettify(f, code) ||
						process_css(f, code).then(
							function(result) {
								this.watcher[f].result = result
								this.compile()
							}.bind(this),
						)
					)
				}.bind(this),
			)
		}
	}
	compile(write_index) {
		version_time = Date.now()
		return Promise.all([this.write_js(), this.write_css()]).then(
			async function(r) {
				if (r && r[0] && r[1]) {
					if (r[0].wrote || r[1].wrote || write_index) {
						await this.on_compile()
					}
					var js = r[0].code || r[0].source_maps
					var css = r[1].code || r[1].source_maps
					log_green(
						'-> Compile done in ' + fixed(js + css) + ', JS done in ' + js + ', CSS done in ' + css,
					)
				} else if (write_index) {
					await this.on_compile()
				}
			}.bind(this),
		)
	}

	async write_js() {
		while (this.running_js || this.running) {
			await sleep(0.05)
		}

		this.running_js = true

		var start = Date.now()

		var map = new Concat(true, 'f.js', '')

		for (var f of this.paths) {
			if (/\.jsx?$/.test(f)) {
				if (this.watcher[f].result === undefined) {
					this.running_js = false
					return
				}
				var source = this.watcher[f].result.split(
					'\n//# sourceMappingURL=data:application/json;charset=utf-8;base64,',
				)
				map.add(
					f,
					source[0].trim() + '\n',
					source[1] ? Buffer.from(source[1].replace(/ \*\/$/, ''), 'base64').toString() : null,
				)
			}
		}

		var code = await read('compile/modules.js')
		for (var f of this.paths) {
			if (f.indexOf('mobx') != -1) {
				code += '\n' + (await read(f))
			}
		}
		await write('www.client/m/fm.js', code)

		var bundle = await rollup.rollup({
			input: 'www.client/m/fm.js',
			plugins: [
				rollup_nodeResolve(),
				rollup_alias({
					entries: [
						{ find: 'mobx', replacement: __dirname + '/node_modules/mobx' },
						{ find: 'mobx-jsx', replacement: __dirname + '/node_modules/mobx-jsx' },
					],
				}),
				rollup_babel(require('./babel.mobx.js')),
				rollup_multi(),
			],
		})
		var b = await bundle.generate({
			minifyInternalExports: true,
			strict: true,
			compact: true,
		})
		var source =
			map.content + '\n' + b.output[0].code + '//# sourceMappingURL=/m/f.js.map?v' + version_time
		var map = map.sourceMap //.replace(/www\.client\//g, '')

		var wrote = false
		return read('www.client/m/f.min.js')
			.then(function(c) {
				if (c.replace(/\/m\/f\.js\.map.*$/, '') != source.replace(/\/m\/f\.js\.map.*$/, '')) {
					wrote = true

					return Promise.all([
						write('www.client/m/f.min.js', source),
						write('www.client/m/f.js.map', map),
					])
				}
			})
			.then(
				function() {
					var source_maps = enlapsed(start)
					if (this.start_js) {
						var code = fixed(enlapsed(this.start_js) - source_maps)
					}
					this.start_js = false
					this.running_js = false
					return { wrote: wrote, code: code, source_maps: source_maps }
				}.bind(this),
			)
	}

	async write_css() {
		while (this.running_css || this.running) {
			await sleep(0.05)
		}
		this.running_css = true

		var start = Date.now()

		var map = new Concat(true, 'f.css', '')

		for (var f of this.paths) {
			if (/\.css$/.test(f)) {
				if (this.watcher[f].result === undefined) {
					this.running_css = false
					return
				}
				var source = this.watcher[f].result.split(
					'\n/*# sourceMappingURL=data:application/json;base64,',
				)
				map.add(
					f,
					source[0].trim() + '\n',
					source[1] ? Buffer.from(source[1].replace(/ \*\/$/, ''), 'base64').toString() : null,
				)
			}
		}

		var source = map.content + '/*# sourceMappingURL=/m/f.css.map?v' + version_time + ' */'
		var map = map.sourceMap //.replace(/www\.client\//g, '')

		var wrote = false
		return read('www.client/m/f.css')
			.then(function(c) {
				if (c.replace(/\/m\/f\.css\.map.*$/, '') != source.replace(/\/m\/f\.css\.map.*$/, '')) {
					wrote = true

					return Promise.all([
						write('www.client/m/f.css', source),
						write('www.client/m/f.css.map', map),
					])
				}
			})
			.then(
				function() {
					var source_maps = enlapsed(start)
					if (this.start_css) {
						var code = fixed(enlapsed(this.start_css) - source_maps)
					}
					this.start_css = false
					this.running_css = false
					return { wrote: wrote, code: code, source_maps: source_maps }
				}.bind(this),
			)
	}

	async on_compile() {
		if (config.on_compile) {
			while (config.on_compile.running) {
				await sleep(0.05)
			}
			config.on_compile.running = true
			var r
			try {
				r = await config.on_compile()
			} catch (e) {
				await sleep(1)
				try {
					r = await config.on_compile()
				} catch (e) {
					console.log('writting index failed', e)
					// nothing
				}
			}
			config.on_compile.running = false
			return r
		}
	}
}
