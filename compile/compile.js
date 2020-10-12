require('./lib.js')

actions = require('./actions.js')
;(function restart_listener() {
	process.on('SIGTERM', () => on_exit('SIGTERM'))
	process.on('SIGINT', () => on_exit('SIGINT'))
	process.on('SIGUSR2', () => on_exit('SIGUSR2'))
	process.on('SIGBREAK', () => on_exit('SIGBREAK'))
	// process.on('SIGKILL', () => on_exit('SIGKILL')) UNCOMMENTED MAKE IT CRASH!
	process.on('SIGHUP', () => on_exit('SIGHUP'))
	process.on('exit', () => on_exit('exit'))
	process.on('message', m => {
		if (m && (m == 'RESTART' || m == 'SHUTDOWN')) {
			on_exit(m)
		}
	})

	var exiting = false
	on_exit = function(who) {
		if (!exiting) {
			exiting = true
			if (who == 'SIGHUP' || who == 'SIGBREAK' || who == 'SHUTDOWN') {
				process.exit(0)
			} else {
				process.send('RESTART')
				process.exit(0)
			}
		}
	}
})()

// auto update libraries
;(function autoupdate_libraries() {
	const request = require('request')

	if (config.autoupdate) {
		for (var id in config.autoupdate) {
			let url = config.autoupdate[id][0]
			let file = config.autoupdate[id][1]
			hash_file(file).then(function(_hash) {
				request(url, (err, res, body) => {
					if (!err) {
						if (_hash != hash(body) && body.indexOf('Rate exceeded') !== 0) {
							log_green('autoupdated ' + path.basename(file))
							write(file, body)
						}
					}
				})
			})
		}
	}
})()

// autoreload browser tabs
;(function autoreload() {
	const WebSocket = require('ws')
	const wss = new WebSocket.Server({ port: config.port - 1 })

	var hash = ''
	async function reload() {
		var _hash = await hash_file('www.client/index.html')
		if (_hash != hash) {
			hash = _hash
			wss.clients.forEach(function(client) {
				client.send('refresh')
			})
		}
	}
	watch(
		'www.client/index.html',
		function(a, b) {
			reload()
		},
		100,
	)
	setTimeout(function() {
		reload()
	}, 4000)
})()

// update git status in the console everytime the folder changes
var display_status = true
;(function update_git_status() {
	watch(
		'./',
		function(action, f) {
			if (!optimizating_images && display_status) {
				run_action(actions.status)
			}
		},
		3000,
		true,
	)
})()

// command line input
;(function command_line_input() {
	const readline = require('readline')
	const rl = readline.createInterface({
		input: process.stdin,
	})

	function ask() {
		rl.question('', async function do_action(result, retrying) {
			display_status = false
			try {
				switch (+result) {
					// changes
					case 1: {
						hr(true)
						await run_action(actions.changes)
						hr(true)
						break
					}
					// save
					case 2: {
						hr(true)
						await compiler.compile(true)
						await run_action(actions.save)
						log('Saved changes!')
						hr(true)
						break
					}
					// push
					case 3: {
						hr(true)
						var now = Date.now()
						log('Updating live site.. (add, commit, pull, compile, add, commit, push)')

						await compiler.compile(true)
						await run_action(actions.save)
						try {
							await run_action(actions.push)
						} catch (e) {
							await run_action(actions.pull)
							await compiler.compile(true)
							await run_action(actions.save)
							await run_action(actions.push)
						}

						log('Site updated in ' + enlapsed(now) + ' seconds')
						hr(true)
						break
					}
					// npm shit
					case 4: {
						hr(true)
						await run_action(actions.outdated)
						break
					}
					// open local site
					case 5: {
						hr(true)
						if (process.platform == 'darwin') {
							exec(
								'open -a "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" http://localhost:' +
									config.port,
							)
						} else {
							exec('chrome http://localhost:' + config.port)
						}
						break
					}
					// git log changes
					case 6: {
						hr(true)
						await run_action(actions.log)
						break
					}
					// merge
					case 7: {
						hr(true)
						var now = Date.now()
						log('Download (add, commit, pull, compile, add, commit)')
						await compiler.compile(true)
						await run_action(actions.save)
						await run_action(actions.pull)
						await compiler.compile(true)
						await run_action(actions.save)
						log('Download done in ' + enlapsed(now) + ' seconds')
						hr(true)

						break
					}
					// server_logs
					case 8: {
						hr(true)
						await run_action(actions.server_logs)
						break
					}
					// clear_logs
					case 9: {
						hr(true)
						await run_action(actions.clear_logs)
						break
					}
					// reset
					case 11: {
						hr(true)
						await run_action(actions.reset)
						break
					}
				}
			} catch (e) {
				if (!retrying) {
					await sleep(1)
					console.log(e)
					log_error('Retrying last action due to an error..')
					do_action(result, true)
				} else {
					console.log(e)
				}
			}
			ask()
			display_status = true
		})
	}
	ask()
})()

// magic

process.title =
	config.domain +
	': [1] Changes - [2] Save - [3] Upload - [4] NPM - [5] Open Localhost - [6] Latest 5 Changes - [7] Download - [8] Server Logs - [9] Clear Logs - [11] Reset'

console.log(process.title.replace(/\[/g, '\n  [').replace(/- \n/g, '\n'))
compiler = new Compiler()
var optimizating_images = false
var did_optimizating_images_run = false

hr_error()
log_error(
	`    | DOWNLOAD regularly so you work over a fresh copy of the work of others.     |\n     | UPLOAD regularly so you let others work over a fresh copy of your own work. | `,
)
hr_error()
;(async function optimize_images() {
	if (!did_optimizating_images_run) {
		did_optimizating_images_run = true
		log('Checking optimization of images')
		await files('www.client/').then(async function(files) {
			var start = Date.now()
			for (var f of files) {
				await process_image(f)
			}
			log('Checked ' + files.length + ' images in ' + enlapsed(start) + ' seconds')
		})
		optimizating_images = false
		watch(
			'www.client/',
			function(action, f) {
				process_image(f)
			},
			1000,
		)
	}
})()
