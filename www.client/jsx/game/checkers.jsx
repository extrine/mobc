var GameCheckers = React.createClass({
	mixins: [React.addons.PureRenderMixin],

	getInitialState: function () {
		window.swf = this
		this.url = 'swf/checkers/game.swf?4'
		u.download(
			this.url,
			function (percent) {
				if (percent == 100) {
					if (this.mounted) this.setState({ percent: percent, loaded: true })
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

				{this.state.loaded === true && (!this.props.room.started || this.meRoom().spectator) ? (
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

				{this.state.loaded === true && this.props.room.started && !this.meRoom().spectator ? (
					<div className="game-swf-object">
						<SWFObject name={this.name()} url={this.url} /> {/*color="#8dc8eb"*/}
					</div>
				) : null}
			</div>
		)
	},
	restart: function () {
		this.setState({
			loaded: false,
		})
		setTimeout(
			function () {
				if (this.mounted)
					this.setState({
						loaded: true,
					})
			}.bind(this),
			0,
		)
	},
	name: function () {
		return 'checkers'
	},
	background_image: function () {
		return 'https://omgmobc.com/img/background/games-checkers-readybg.jpg'
	},
	componentWillUnmount: function () {
		this.mounted = false
	},
	componentDidMount: function () {
		this.mounted = true
	},
	seed: function () {
		return window.room.round.seed
	},
	muted: function () {
		var o = storage.get()
		return o.muted ? true : false
	},
	getUsers: function () {
		var users = []
		for (var id in window.room.users) {
			if (!window.room.users[id].spectator) users.push(window.room.users[id])
		}
		var oa = []

		for (var id in users) {
			var o = u.copy(users[id])
			if (is_video(o.image)) o.image = profile_picture(o.image).replace(/\.[^\.]+$/, '.png')
			else o.image = profile_picture(o.image)
			oa[id] = o
		}
		return oa.slice(0, 2)
	},
	spectator: function () {
		return window.room.started
	},
	host: function () {
		return (
			window.room &&
			window.room.users &&
			window.room.users[0] &&
			window.room.users[0].id == window.user.id
		)
	},
	me: function () {
		var o = u.copy(window.user)
		if (is_video(o.image)) o.image = profile_picture(o.image).replace(/\.[^\.]+$/, '.png')
		else o.image = profile_picture(o.image)
		return o
	},
	meRoom: function () {
		for (var id in window.room.users) {
			if (window.room.users[id].id == window.user.id) {
				var o = u.copy(window.room.users[id])
				if (is_video(o.image)) o.image = profile_picture(o.image).replace(/\.[^\.]+$/, '.png')
				else o.image = profile_picture(o.image)
				return o
			}
		}
		return {}
	},
	componentDidUpdate: function () {
		window.embed = document.getElementById('game-swf')
	},

	start: function () {
		if (this.host() || window.user.mod || window.user.pu) {
			emit({
				id: 'room update',
				started: true,
			})
		}
	},
	stop: function () {
		if (this.host()) {
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
	end: function () {
		if (this.host() || window.user.mod || window.user.pu) {
			emit({
				id: 'room update',
				end: true,
			})
		}
	},
	onGameStart: function () {},
	onGameOver: function () {
		setTimeout(function () {
			if (window.room.started) {
				emit({
					id: 'checkers',
					f: 'd',
				})
				u.focusChat()
			}
		}, 1000)
	},
})
