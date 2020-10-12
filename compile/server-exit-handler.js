module.exports = {
	callback: async function() {},
}
var exiting = false

function on_exit(who) {
	if (!exiting) {
		exiting = true
		console.log(Date() + ' EXITING BY ' + who)
		if (who == 'SIGHUP' || who == 'SIGBREAK' || who == 'SHUTDOWN') {
			process.exit(0)
		} else {
			return module.exports.callback().then(function() {
				process.send('RESTART')
				process.exit(0)
			})
		}
	}
}

process.on('SIGTERM', () => on_exit('SIGTERM'))
process.on('SIGINT', () => on_exit('SIGINT'))
process.on('SIGUSR2', () => on_exit('SIGUSR2'))
process.on('SIGBREAK', () => on_exit('SIGBREAK'))
process.on('SIGHUP', () => on_exit('SIGHUP'))
//process.on('SIGKILL', () => on_exit('SIGKILL')) THIS MAKE IT CRASH ON LINUX! eehh

//process.on('exit', () => on_exit('exit'))
process.on('message', m => {
	if (m && (m == 'RESTART' || m == 'SHUTDOWN' || m == 'shutdown')) {
		on_exit(m)
	}
})
