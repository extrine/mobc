;(function () {
	var map = false
	$.ajax({
		type: 'GET',
		url: '/m/f.js.map?v' + version_time,
		success: function (data) {
			map = new sourceMap.SourceMapConsumer(data)
		}.bind(this),
	})

	if (
		//	!local &&
		window.navigator.userAgent.indexOf('Trident') === -1 &&
		window.navigator.userAgent.indexOf('Edge') === -1
	) {
		var reported = []
		var to_report = []
		// fucking react fakes the errors

		function report() {
			if (map && typeof emit !== 'undefined' && to_report.length) {
				for (var id in to_report) {
					var report = to_report[id]
					try {
						var _map = map.originalPositionFor({
							line: report.line,
							column: report.col,
						})

						report.file = _map.source + ':' + _map.line + ':' + _map.column

						delete report.line
						delete report.col

						if (report.stack) {
							var stack = []

							for (var id in report.stack) {
								report.stack[id] = report.stack[id].replace(/\)$/g, '')
								if (/[0-9]+:[0-9]+$/.test(report.stack[id])) {
									var info = report.stack[id].split(':').reverse().splice(0, 2)
									var _map = map.originalPositionFor({
										line: info[1],
										column: info[0],
									})
									report.stack[id] = {
										file: _map.source + ':' + _map.line + ':' + _map.column,
										source: report.stack[id].trim(),
									}
								}
								// skipping non sense
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
						}
						/*if (report.stack.length === 0) {
							continue
						}*/
						emit({
							id: 'client error',
							d: report,
						})
					} catch (e) {
						report.cant = e
						emit({
							id: 'client error',
							d: report,
						})
					}
				}
				to_report = []
			}
		}

		window.onerror = function (message, source, linenumber, colnumber, error) {
			if (
				message &&
				// youtube shit
				message.indexOf('YT is not defined') === -1 &&
				message.indexOf("Cannot read property 'loadVideoById'") === -1 &&
				message.indexOf('YT.Player is not a constructor') === -1 &&
				message.indexOf('this.player.loadVideoById') === -1 &&
				message.indexOf("property 'video_id' of undefined") === -1 &&
				message.indexOf("Uncaught TypeError: Cannot read property 'seekTo' of null") === -1 &&
				// flash shit
				// chrome
				message.indexOf('An invalid exception was thrown') === -1 &&
				// firefox
				message.indexOf('Error calling method on NPObject') === -1 &&
				// edge
				message != 'Unspecified error.' &&
				// safari | chrome
				message != 'Script error.' &&
				// react breaking because of flash
				message.indexOf('Expected flush transaction') === -1 &&
				// no idea
				message.indexOf('ResizeObserver loop limit exceeded') === -1 &&
				message.indexOf("Cannot set property 'install' of undefined") === -1 &&
				// antivirus
				message.indexOf('_avast_submit') === -1 &&
				// react spamming
				//message.indexOf('You are binding a component method to the component') === -1 &&
				// && message.indexOf('Minified React error #124') === -1
				true
			) {
				error = String(error && error.stack ? error.stack : error)

				var o = {
					message: message,
					file: source,
					line: linenumber,
					col: colnumber,
					browser: window.navigator.userAgent,
					stack: error.split('\n'),
					version: version_time,
					username: window.user ? window.user.username : '',
				}
				var os = JSON.stringify(o)
				if (reported[os] === undefined) {
					reported[os] = null
					o.url = window.location.href
					o.time = Date.now()
					to_report.push(o)
					setTimeout(report, 0)
				}
			}
		}
		setInterval(report, 5000)
		;(function (proxied) {
			console.error = function () {
				proxied(...arguments)
				if (arguments.length == 1) {
					var error = JSON.stringify(arguments[0])
				} else {
					var error = JSON.stringify(arguments)
				}

				try {
					throw new Error()
				} catch (e) {
					window.onerror(error, '', 1, 1, e.stack)
				}
			}
		})(console.error)
	}
})()
