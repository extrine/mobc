var GameBalloonoboot = React.createClass({
	mixins: [React.addons.PureRenderMixin],

	getInitialState: function () {
		window.swf = this

		this.version = '189'

		return {
			loaded: true,
		}
	},
	render: function () {
		var url = 'swf/loader.swf?' + this.version

		return (
			<div className="game-swf">
				{this.state.loaded === true && (!this.props.room.started || this.meRoom().spectator) ? (
					<div className="game-swf-object">
						<Waiting room={this.props.room} />
					</div>
				) : null}

				{this.state.loaded === true && this.props.room.started && !this.meRoom().spectator ? (
					<div className="game-swf-object">
						<SWFObject name={this.name()} url={url} />
					</div>
				) : null}
			</div>
		)
	},
	getVersion: function () {
		return this.version
	},
	name: function () {
		return 'balloonoboot'
	},
	background_image: function () {
		return 'https://omgmobc.com/img/background/games-balloonoclassic-readybg.jpg'
	},
	url: function () {
		return 'swf/balloonoboot/game.swf?' + this.version
	},
	seed: function () {
		return window.room.round.seed
	},
	startTime: function () {
		return window.room.round.startTime
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
		return oa.slice(0, 6)
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
	onGameLoaded: function () {
		this.setState({
			loaded: true,
		})
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
