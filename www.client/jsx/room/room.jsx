var Room = React.createClass({
	mixins: [React.addons.PureRenderMixin],

	getInitialState: function () {
		ios.on(
			'a',
			function (data) {
				if (data.id == 'room') {
					if (window.room && data.room.started != window.room.started) {
						if (!u.document_is_visible) {
							if (window.room.users[0] && window.room.users[0].username == window.user.username) {
								u.soundAlways('knockknock')
							} else {
								u.soundWhenTabNotMuted('knockknock')
							}

							if (window.room.game == 'pool' || window.room.game == '9ball') {
								if (!data.room.started) {
									if (
										window.room.users[2] &&
										window.room.users[2].username == window.user.username
									) {
										u.soundAlways('knockknock')
										u.notification({
											title: 'Wake up! Your Turn!',
											body: 'To play ' + window.room.game,
											image: window.user.image,
										})
									}
								} else {
									if (
										window.room.users[1] &&
										window.room.users[1].username == window.user.username
									) {
										u.soundAlways('knockknock')
										u.notification({
											title: 'Wake up! Your Turn!',
											body: 'To play ' + window.room.game,
											image: window.user.image,
										})
									}
								}
							}
						}
					}
					var old_id = window.room ? window.room.id : ''

					window.room = data.room
					if (!window.room) {
						location.hash = ''
					} else {
						if (data.room.id != old_id) location.hash = 'm/' + encodeURIComponent(data.room.id)
					}
					body.attr('data-game', data.room ? data.room.game : '')
					body.attr(
						'data-host',
						window.room && window.room.users && window.room.users[0].id == window.user.id
							? 'true'
							: '',
					)

					// here we just recieved the "room" data (users creators state of the room etc)
					// so we take the creator part and say OK if we are the creator
					// because we comparing it with window.user.username (Which is us)
					// so when window.room.creator == window.user.username is true means we created the room
					// so body[data-creator="true"] will be that, if we arent the creator then
					//  body[data-creator="false"] <- that will be false
					body.attr(
						'data-creator',
						window.room && window.room.users && window.room.creator == window.user.username
							? 'true'
							: '',
					)

					body.attr(
						'data-num-players',
						window.room && window.room.users
							? window.room.users.length > 10
								? 11
								: window.room.users.length
							: 0,
					)
					body.attr('data-game-started', window.room && window.room.started ? true : false)
					body.attr(
						'data-rotate',
						window.room && window.room.users
							? window.room.users[window.room.users.length - 1].id != window.user.id
							: false,
					)
					this.setState(data)

					ReactDOM.render(
						<Game
							room={data.room}
							data={data.room && data.room.round ? data.room.round.data : null}
						/>,
						document.querySelector('.content-container .content'),
					)
				} else if (data.id == 'rd') {
					ReactDOM.render(
						<Game room={window.room} data={data.data} />,
						document.querySelector('.content-container .content'),
					)
				} else if (data.id == 'sound joined') {
					if (
						window.room &&
						window.room.users &&
						(window.room.users.length == 1 || window.room.users.length == 2)
					)
						u.soundAlways('knockknock')
					else u.soundWhenTabNotMuted('plant')
				}
			}.bind(this),
		)

		return {}
	},
	render: function () {
		return (
			<div className="room">
				{this.state.room ? (
					<div>
						<div className="players">
							{this.state.room.users.map(
								function (item) {
									return this.user(item)
								}.bind(this),
							)}
						</div>
						<hr className="hidden-on-video" />
					</div>
				) : null}
			</div>
		)
	},
	user: function (item) {
		var style = {
			borderColor: item.color || 'white',
			color: u.readable(item.mcolor) || 'white',
		}
		return (
			<div
				key={item.id}
				data-username={item.username}
				title={item.username}
				className="player break"
			>
				{!is_video(item.image) ? (
					<img
						data-break-it="true"
						src={profile_picture(item.image)}
						style={style}
						width="19"
						height="19"
						className="pointer user"
						data-username={item.username}
						onClick={openProfile}
					/>
				) : (
					<img
						data-break-it="true"
						src={profile_picture(item.image).replace(/\.[^\.]+$/, '.png')}
						style={style}
						width="19"
						height="19"
						className="pointer user"
						data-username={item.username}
						onClick={openProfile}
					/>
				)}
				<span
					data-username={item.username}
					className="pointer underline-hover username"
					style={{
						color: u.readable(item.mcolor) || 'white',
						fontWeight: 'bold',
					}}
					data-admin={u.is_mod(item.username)}
					data-donated={item.donated}
					onClick={openProfile}
				>
					{item.username}{' '}
					{item.donated ? <img src={u.badge(item.username)} className="donated" /> : null}
				</span>{' '}
				<small className="  pointer" onClick={this.mod_kick}>
					[kick]
				</small>
			</div>
		)
	},

	mod_kick: function (e) {
		var username = $(e.currentTarget.parentNode).attr('data-username')
		if (username && username != '') {
			CONFIRM('Are you SURE you want to KICK "' + username + '"', function () {
				emit({
					id: 'mod kick',
					username: username,
				})
			})
		}
	},
	leave: function () {
		location.hash = ''
	},
	componentDidUpdate: function () {
		if (window.updateScroll) window.updateScroll()
	},
})
