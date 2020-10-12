function callback(cmd) {
	if (cmd.noempty && cmd.stdout.trim() == '' && cmd.stderr.trim() == '') {
		return
	}

	if (cmd.norepeat && cmd.last == cmd.stdout + cmd.stderr) {
		return
	}
	cmd.last = cmd.stdout + cmd.stderr

	hr()
	log_green('\n' + cmd.time)
	if (cmd.stdout) {
		log_blue('\n' + cmd.stdout)
	}
	if (cmd.stderr && !cmd.nostderr && cmd.stderr !== cmd.stdout) {
		log_blue('\n' + cmd.stderr)
	}
	hr()
}
var should_restart_nginx = false

module.exports = {
	outdated: [
		{
			title: 'packages installed ',
			cwd: 'compile/',
			command: ['npm', 'list', '--depth=0'],
			callback: callback,
		},
		{
			title: 'packages outdated',
			cwd: 'compile/',
			command: ['npm', 'outdated'],
			callback: callback,
			noempty: true,
		},
		{
			title: 'packages installed ',
			cwd: 'www.socket/',
			command: ['npm', 'list', '--depth=0'],
			callback: callback,
		},
		{
			title: 'packages outdated',
			cwd: 'www.socket/',
			command: ['npm', 'outdated'],
			callback: callback,
			noempty: true,
		},
	],

	save: [
		{
			title: 'pre save',
			command: async function() {
				if (await exists('www.web/restart')) {
					should_restart_nginx = true
					await remove('www.web/restart')
				}
				await remove('compile/package-lock.json')
				await remove('www.socket/package-lock.json')
				await remove('diff.diff')
				await remove('log.diff')
				await remove('client.error')
			},
			sync: true,
			noempty: true,
		},
		{
			title: 'add files',
			command: ['git', 'add', '--all', './*'],
			sync: true,
			callback: callback,
			noempty: true,
		},
		{
			title: 'commit',
			command: [
				'git',
				'commit',
				'--author="u <u@u>"',
				'--all',
				'-m',
				'"' + date.version_readable + '"',
			],
			sync: true,
			callback: callback,
			noempty: true,
		},
	],

	pull: [
		{
			title: 'pull',
			command: ['git', 'pull', '--all'],
			sync: true,
			callback: callback,
		},
	],
	reset: [
		{
			title: 'reset ',
			command: ['git', 'reset', '--hard'],
			sync: true,
			callback: callback,
		},
	],
	push: [
		{
			title: 'push',
			command: ['git', 'push', '--all', '--porcelain'],
			sync: true,
			callback: callback,
			nostderr: true,
		},
		{
			title: 'restart nginx ',
			command: async function() {
				if (should_restart_nginx) {
					should_restart_nginx = false
					log('Restarting nginx, configuration or php changed')
					return await ssh(
						'service nginx restart && service nginx reload && service nginx restart && systemctl restart php-fpm && service nginx status',
					)
				}
			},
			sync: true,
			noempty: true,
		},
	],
	status: [
		{
			title: 'status site',
			command: ['git', 'status', '-s'],
			noempty: true,
			norepeat: true,
			sync: true,

			callback: callback,
			last: '',
		},
	],
	log: [
		{
			title: 'pre log',
			command: async function() {
				remove('log.diff')
				await write('data/tmp/log.diff')
			},
			sync: true,
		},
		{
			title: 'get last 5 changes ',
			command: ['git log -n 5 -p --decorate --no-color', './*', '>', 'data/tmp/log.diff'],
			sync: true,
			noempty: true,
		},
		{
			title: 'show log',
			command: function() {
				return read('data/tmp/log.diff').then(
					function(c) {
						if (c !== '') {
							return spawn({ command: [is_osx() ? 'open' : 'start', 'data/tmp/log.diff'] })
						} else {
							log('No changes to show')
						}
					}.bind(this),
				)
			},
			noempty: true,
		},
	],
	changes: [
		{
			title: 'pre changes',
			command: async function() {
				remove('diff.diff')
				await write('data/tmp/changes.diff')
			},
			sync: true,
		},
		{
			title: 'get diff',
			command: ['git diff -w --diff-algorithm=patience', './*', '>', 'data/tmp/changes.diff'],
			sync: true,
		},
		{
			title: 'show diff',
			command: function() {
				return read('data/tmp/changes.diff').then(
					function(c) {
						if (c !== '') {
							return spawn({ command: [is_osx() ? 'open' : 'start', 'data/tmp/changes.diff'] })
						} else {
							log('No changes to show')
						}
					}.bind(this),
				)
			},
			noempty: true,
		},
	],
	server_logs: [
		{
			title: 'pre server logs',
			command: async function() {
				remove('client.error')
				remove('data/tmp/client.error')
				await write('data/tmp/client.error.txt')
			},
			sync: true,
		},
		{
			title: 'node logs',
			command: function() {
				return ssh('cat /w/' + config.domain + '/data/log/node')
			},
		},
		{
			title: 'nginx logs',
			command: function() {
				return ssh('cat /w/' + config.domain + '/data/log/web')
			},
		},
		{
			title: 'client logs',
			command: function() {
				return ssh(
					'cat /w/' + config.domain + '/data/log/client',
					function(data) {
						data = data.trim()
						if (data !== '') {
							data = data.replace(/f\.js\?h[^"]+"/g, 'f.js"')
							data = data.replace(/js\/external\//g, '')
							data = data.replace(/www.client\//g, '')

							write('data/tmp/client.error.txt', data)

							var list = {}
							var hidden = 0
							var errors = data.split('\n\n')
							for (var report of errors) {
								try {
									report = JSON.parse(
										report
											.replace(/\n+/g, '')
											.replace(/\s+/g, ' ')
											.replace(/^[^{]+{/, '{'),
									)
								} catch (e) {
									console.log(report, e)
									continue
								}

								// clean it
								var stack = []

								for (var id in report.stack) {
									if (
										report.stack[id].file &&
										(report.stack[id].file.indexOf('react-dom') !== -1 ||
											report.stack[id].file.indexOf('react-with-addons') !== -1 ||
											report.stack[id].file.indexOf('socket.slim.js') !== -1 ||
											report.stack[id].file.indexOf('chrome-extension://') !== -1 ||
											report.stack[id].source.indexOf('chrome-extension://') !== -1 ||
											report.stack[id].file.indexOf('errors.js') !== -1 ||
											report.stack[id].file.indexOf('jquery.min.js') !== -1 ||
											report.stack[id].source.indexOf('at console.error') !== -1 ||
											false)
									) {
										continue
									}

									if (
										!report.stack[id].file &&
										(report.stack[id] === '' ||
											report.stack[id].indexOf('__reactInternalInstance') !== -1 ||
											false)
									) {
										continue
									}

									if (report.stack[id].source) {
										report.stack[id].source = report.stack[id].source
											.trim()
											.replace(/https:\/\/omgmobc\.com\/m\/f\.js\?h.+$/g, '')
											.replace(/https:\/\/omgmobc\.com\/m\/f\.js/g, '')
											.replace(/\?h.+/g, '')
											.replace(/^at Object\./g, '')
											.replace(/<\/<@/g, '')
											.replace(/\/<@/g, '')
											.replace(/@/g, '')
											.replace(/ \(/g, '')
											.replace(/^at /g, '')
									}
									stack.push(report.stack[id])
								}
								report.stack = stack

								if (report.message && report.message.indexOf('__reactInternalInstance') !== -1) {
									delete report.message
								}
								if (
									report.file &&
									(report.file.indexOf('react-dom') !== -1 ||
										report.file.indexOf('react-with-addons') !== -1 ||
										report.file.indexOf('errors.js') !== -1 ||
										report.file.indexOf('client-autoreload') !== -1 ||
										false)
								) {
									delete report.file
								}
								// end of clean it

								if (report.stack.length === 0) {
									report.hidden = true
									hidden++
								}
								// key it
								var k = JSON.stringify(stack).replace(/\s/g, '')
								if (!list[k]) {
									list[k] = []
								}

								list[k].push(report)
							}
							for (var k in list) {
								var min = 15806600483020000
								var max = 0
								for (var id in list[k]) {
									list[k][id].date = date.pretty(list[k][id].time)
									list[k][id].version = date.pretty(list[k][id].version)
									if (list[k][id].time > max) {
										max = list[k][id].time
									}
									if (list[k][id].time < min) {
										min = list[k][id].time
									}
								}
								list[k].min = date.pretty(min)
								list[k].max = date.pretty(max)
							}

							var txt =
								'Showing ' + Object.keys(list).length + ' different errors, ' + hidden + ' hidden'

							for (var id in list) {
								txt +=
									'\n\nAppears ' +
									list[id].length +
									' times, first seen ' +
									list[id].min +
									', last seen ' +
									list[id].max +
									'\n\n'
								txt += JSON.stringify(list[id][list[id].length - 1], null, 2)
							}

							return write('data/tmp/client.errors.txt', txt).then(
								function(c) {
									return spawn({ command: [is_osx() ? 'open' : 'start', 'data/tmp/client.errors.txt'] })
								}.bind(this),
							)
						}
					}.bind(this),
				)
			},
		},
	],
	clear_logs: [
		{
			title: 'clear logs',
			command: function() {
				return ssh(
					"echo '' > /w/" +
						config.domain +
						"/data/log/node && echo '' > /w/" +
						config.domain +
						"/data/log/web && echo '' > /w/" +
						config.domain +
						'/data/log/client   ',
				)
			},
		},
	],
}
