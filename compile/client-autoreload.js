;(function () {
	if (location.host.indexOf('localhost') !== -1) {
		;(function autoreload() {
			let socket = new WebSocket(
				'ws://localhost:' + (parseInt(location.host.replace(/[^0-9]/g, '')) - 1),
			)
			socket.onmessage = function (e) {
				location.reload()
			}

			var timeout = false
			socket.onclose = socket.onerror = function (event) {
				clearTimeout(timeout)
				timeout = setTimeout(autoreload, 1000)
			}
		})()
	}
})()
