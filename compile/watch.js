require('./lib.js')

hr()

var processes = [
	{
		script: 'server.js',
		cwd: 'www.socket/',
		watch: ['www.socket/'],
		url: 'http://localhost:' + config.port,
	},
	{
		script: 'compile/compile.js',
		cwd: './',
		watch: ['compile.js', '.prettierrc.js', 'compile/'],
	},
]

processes.forEach(function(item) {
	var fork = false

	// watch
	item.watch.forEach(function(file) {
		watch(file, restart, 1000, true)
	})

	// restarts
	function _fork() {
		hr()
		log('Started ' + item.script)
		hr()
		fork = cp.fork(item.script, { cwd: item.cwd })
		fork.on('error', function() {
			_fork()
		})
		fork.exiting = false
	}
	function restart() {
		if (fork.on) {
			if (!fork.exiting) {
				fork.exiting = true
				hr()
				log('Exiting ' + item.script)

				if (!fork.on_shutdown) {
					fork.on_shutdown = true
					fork.on('message', function(m) {
						if (m == 'RESTART') {
							_fork()
						}
					})
				}
				fork.send('RESTART')
			}
		} else {
			_fork()
		}
	}
	restart()

	// kill - for closing the cmd window that is watching as soon as possible
	;[/*'uncaughtException',*/ 'SIGTERM', 'SIGINT', 'SIGUSR2', /*'exit', */ 'SIGBREAK'].forEach(
		function(m) {
			process.on(m, function() {
				if (item.script !== 'compile/compile.js') {
					fork.send('SHUTDOWN')
				} else {
					process.exit()
				}
			})
		},
	)

	if (item.url) {
		setTimeout(function() {
			if (process.platform == 'darwin') {
				exec('open -a "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" ' + item.url)
			} else {
				exec('chrome ' + item.url)
			}
		}, 2000)
	}
})
