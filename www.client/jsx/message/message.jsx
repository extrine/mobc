var Messages = React.createClass({
	mixins: [React.addons.PureRenderMixin],

	getInitialState: function () {
		ios.on(
			'a',
			function (data) {
				if (data.id == 'messages') {
					if (
						(data.type == 'system' && !window.user) ||
						(window.user && window.user.block && !window.user.block[data.user]) ||
						data.user == 'omgmobc.com'
					)
						this.incoming(data)
				}
			}.bind(this),
		)

		window.message = function (type, message, no_sound) {
			this.incoming({
				id: 'messages',
				type: type,
				message: message,
				no_sound: no_sound,
			})
		}.bind(this)

		return {
			items: [],
			duplicates: [],
		}
	},
	incoming: function (data) {
		if (this.state.duplicates.indexOf(data.message) === -1) {
			if (data.type == 'error' || data.type == 'system') {
				if (!document.hidden) u.soundAlways('error')
			} else {
				u.soundAlways('clink')
			}
			if (data.type == 'system') var timeout = 20000
			else var timeout = 10000

			var items = this.state.items.concat(data)
			var duplicates = []
			for (var id in items) duplicates.push(items[id].message)
			this.setState({
				items: items,
				duplicates: duplicates,
			})
			$(window).resize()

			setTimeout(
				function () {
					var items = this.state.items.slice()
					items.shift()
					var duplicates = []
					for (var id in items) duplicates.push(items[id].message)
					this.setState({
						items: items,
						duplicates: duplicates,
					})
				}.bind(this),
				timeout,
			)
		}
	},
	render: function () {
		return (
			<div className="messages">
				{this.state.items.map(
					function (item, id) {
						if (item.type == 'system')
							var s = <span dangerouslySetInnerHTML={{ __html: u.linkyNoScroll(item.message) }} />
						else var s = item.message
						return (
							<div key={id} className={item.type + ' message break'}>
								{s}
							</div>
						)
					}.bind(this),
				)}

				{this.state.items.length ? <hr /> : null}
			</div>
		)
	},
})
