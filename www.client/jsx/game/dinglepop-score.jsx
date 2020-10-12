var GameDinglepopScores = React.createClass({
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
		for (var id in table) {
			table[id].data = {
				s: table[id].data && table[id].data.s ? table[id].data.s.split(',') : [0, 0, 0],
				c: table[id].data && table[id].data.c ? table[id].data.c : 9468992852536,
				d: table[id].data ? table[id].data.d : false,
			}
		}

		table.sort(
			firstBy(function (a, b) {
				return (a.data.c ? a.data.c : 9468992852536) - (b.data.c ? b.data.c : 9468992852536)
			})
				.thenBy(function (a, b) {
					return b.data.s[0] - a.data.s[0]
				})
				.thenBy(function (a, b) {
					return b.data.s[2] - a.data.s[2]
				})
				.thenBy(function (a, b) {
					return b.data.s[1] - a.data.s[1]
				}),
		)

		var should_stop = table.every(function (item) {
			return item.data && item.data.d
		})
		if (should_stop && window.swf && window.swf.host()) {
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
										onClick={this.item_use}
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
											<div className="st-score" title="Level - Pooped - Dropped">
												L:
												{item.data.s[0]} D:
												{item.data.s[2]} P:
												{item.data.s[1]}
											</div>
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
	item_use: function (e) {
		if (window.embed && window.embed['iuJS']) {
			window.embed['iuJS']($(e.currentTarget).attr('data-username'))
			u.focusGame(true)
		}
	},
})
