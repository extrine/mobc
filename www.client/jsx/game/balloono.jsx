var GameBalloono = React.createClass({
	mixins: [React.addons.PureRenderMixin],

	getInitialState: function () {
		// it works2
		this.version = 102
		window.swf = this
		this._url = 'swf/loader.swf'
		u.download(
			this._url,
			function (percent) {
				if (percent == 100) {
					u.download(
						this.url(),
						function (percent) {
							if (percent == 100) {
								if (this.mounted) this.setState({ percent: percent, loaded: true })
							} else {
								if (this.mounted) this.setState({ percent: percent })
							}
						}.bind(this),
					)
				} else {
					if (this.mounted) this.setState({ percent: percent })
				}
			}.bind(this),
		)
		return {
			percent: 0,
			loaded: false,
		}
	},
	render: function () {
		return (
			<div className="game-swf">
				{this.state.loaded === false ? (
					<div className="game-swf-object">
						<Waiting room={this.props.room} />
						<WaitingStatus>Downloading Game {this.state.percent}%</WaitingStatus>
					</div>
				) : null}
				{this.state.loaded === true &&
				(!this.props.room.started || this.me().game_status == GAME_STATUS_WAITING) ? (
					<div className="game-swf-object">
						<Waiting room={this.props.room} />
						<WaitingStatus>
							{window.room.started ? 'Game In Progress, ' : ''}
							You Are Waiting To{' '}
							{window.room &&
							window.room.game === 'pool' &&
							window.room.users &&
							window.room.users.some(function (user) {
								return user.username == 'Roxann' && window.user.username != 'Roxann'
							})
								? 'Lose'
								: 'Play'}
						</WaitingStatus>
					</div>
				) : null}

				{this.state.loaded === true &&
				this.props.room.started &&
				(this.me().game_status == GAME_STATUS_PLAYING ||
					this.me().game_status == GAME_STATUS_SPECTATING) ? (
					<div className="game-swf-object">
						<SWFObject name={this.name()} url={this._url} />
						{this.me().game_status == GAME_STATUS_SPECTATING ? (
							<WaitingStatus>You Are Spectating</WaitingStatus>
						) : null}
					</div>
				) : null}
			</div>
		)
	},
	name: function () {
		return 'balloono'
	},

	url: function () {
		return 'swf/balloono/game-local.swf?' + this.version
	},
	seed: function () {
		return window.room.round.seed
	},
	background_image: function () {
		return 'https://omgmobc.com/img/background/games-balloonoclassic-readybg.jpg'
	},
	players: function () {
		var players = []
		var users = window.room.users
		for (var id in users) {
			if (users[id].game_status == GAME_STATUS_PLAYING) {
				var o = u.copy(users[id])
				o.image = profile_picture_static(o.image)

				players.push(o)
			}
		}
		return players.slice(0, 6)
	},
	me: function () {
		var users = window.room.users
		for (var id in users) {
			if (users[id].username == window.user.username) {
				var o = u.copy(users[id])
				o.image = profile_picture_static(o.image)
				return o
			}
		}
		return {}
	},
	user: function () {
		return window.user
	},
	room: function () {
		return window.room
	},
	is_muted: function () {
		var o = storage.get()
		return o.muted ? true : false
	},
	is_host: function () {
		return (
			window.room &&
			window.room.users &&
			window.room.users[0] &&
			window.room.users[0].username == window.user.username
		)
	},
	start: function () {
		if (this.is_host() || window.user.mod || window.user.pu || local) {
			emit({
				id: 'room update',
				started: true,
			})
		}
	},
	stop: function () {
		if (this.is_host() || local) {
			emit({
				id: 'room update',
				started: false,
			})
		} else if (window.user.mod || window.user.pu) {
			CONFIRM('Are you Sure?', function () {
				emit({
					id: 'room update',
					started: false,
				})
			})
		}
	},
	componentWillUnmount: function () {
		this.mounted = false
	},
	componentDidMount: function () {
		this.mounted = true
	},
	componentDidUpdate: function () {
		window.embed = document.getElementById('game-swf')
	},
})
