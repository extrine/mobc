var medals = {}
var beat_captain = {}
var GameSwapplesScores = React.createClass({
	mixins: [React.addons.PureRenderMixin],

	getInitialState: function () {
		this.timer = false
		return {}
	},
	componentWillUnmount: function () {
		clearTimeout(this.timer)
	},
	render: function () {
		var table = []
		for (var user in this.props.room.users) {
			table[user] = {
				user: this.props.room.users[user],
				data: this.props.data ? this.props.data[this.props.room.users[user].id] : false,
			}
		}

		table.sort(function (a, b) {
			return (b.data && b.data.s ? b.data.s : 0) - (a.data && a.data.s ? a.data.s : 0)
		})
		var should_stop = table.every(function (item) {
			return item.data && item.data.d
		})
		medals = {}
		if (table[0] && table[0].data && table[0].data.s > 0) {
			medals.gold = table[0].user.username
		}
		if (table[1] && table[1].data && table[1].data.s > 0) {
			medals.silver = table[1].user.username
			if (should_stop && table[1].user.username == 'captain barnacles') {
				if (!beat_captain[table[0].user.username]) beat_captain[table[0].user.username] = 0
				beat_captain[table[0].user.username]++
			}
		}
		if (table[2] && table[2].data && table[2].data.s > 0) {
			medals.bronze = table[2].user.username
			if (should_stop && table[2].user.username == 'captain barnacles') {
				if (!beat_captain[table[0].user.username]) beat_captain[table[0].user.username] = 0
				beat_captain[table[0].user.username]++
				if (!beat_captain[table[1].user.username]) beat_captain[table[1].user.username] = 0
				beat_captain[table[1].user.username]++
			}
		}

		if (should_stop && window.swf && window.swf.host() && !this.props.room.pseed) {
			this.timer = setTimeout(window.swf.end, 7000)
		}
		return (
			<div>
				<div className="game-score">
					<div className="score-table">
						{table.map(
							function (item) {
								return (
									<div
										className={
											'pointer player ' +
											(item.user.id == window.user.id ? 'me' : '') +
											(item.data && item.data.d ? ' done' : '')
										}
										onClick={openProfile}
										data-username={item.user.username}
										key={item.user.id}
									>
										{is_video(item.user.image) ? (
											<img
												className="st-img l"
												src={profile_picture(item.user.image).replace(/\.[^\.]+$/, '.png')}
											/>
										) : (
											<img className="st-img l" src={profile_picture(item.user.image)} />
										)}
										<div className="r">
											<div className="st-score">{item.data && item.data.s ? item.data.s : 0}</div>
											<div className="st-user">{item.user.username}</div>
										</div>
										<div className="clear" />
									</div>
								)
							}.bind(this),
						)}
					</div>
				</div>
			</div>
		)
	},
})
