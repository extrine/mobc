var GameBlockles = React.createClass({
	mixins: [React.addons.PureRenderMixin],

	getInitialState: function () {
		window.swf = this
		this.url = 'swf/blockles/game.swf?22'
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

				{this.state.loaded === true && !this.props.room.started ? (
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

				{this.state.loaded === true && this.props.room.started ? (
					<span className="restart" onClick={this.restart}>
						<svg role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 640 512">
							<path
								fill="currentColor"
								d="M480 96H160C71.6 96 0 167.6 0 256s71.6 160 160 160c44.8 0 85.2-18.4 114.2-48h91.5c29 29.6 69.5 48 114.2 48 88.4 0 160-71.6 160-160S568.4 96 480 96zM256 276c0 6.6-5.4 12-12 12h-52v52c0 6.6-5.4 12-12 12h-40c-6.6 0-12-5.4-12-12v-52H76c-6.6 0-12-5.4-12-12v-40c0-6.6 5.4-12 12-12h52v-52c0-6.6 5.4-12 12-12h40c6.6 0 12 5.4 12 12v52h52c6.6 0 12 5.4 12 12v40zm184 68c-26.5 0-48-21.5-48-48s21.5-48 48-48 48 21.5 48 48-21.5 48-48 48zm80-80c-26.5 0-48-21.5-48-48s21.5-48 48-48 48 21.5 48 48-21.5 48-48 48z"
							/>
						</svg>{' '}
						PLAY AGAIN
					</span>
				) : null}

				{this.state.loaded === true && this.props.room.started ? (
					<div className="game-swf-object">
						<GameBlocklesScores room={this.props.room} data={this.props.data} />
						<SWFObject name={this.name()} url={this.url} /> {/*color="#120c1f"*/}
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
		return 'blockles'
	},
	background_image: function () {
		return 'https://omgmobc.com/img/background/games-droppingobjects-readybg.jpg'
	},
	componentWillUnmount: function () {
		this.mounted = false
	},
	componentDidMount: function () {
		this.mounted = true
	},
	seed: function () {
		return (Math.random() * 100000000) | 0 //window.room.round.seed
	},
	muted: function () {
		var o = storage.get()
		return o.muted ? true : false
	},
	getUsers: function () {
		var oa = []

		for (var id in window.room.users) {
			var o = u.copy(window.room.users[id])
			if (is_video(o.image)) o.image = profile_picture(o.image).replace(/\.[^\.]+$/, '.png')
			else o.image = profile_picture(o.image)
			oa[id] = o
		}
		return oa
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
	onGameOver: function () {},
})