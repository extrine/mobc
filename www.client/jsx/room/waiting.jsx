var lame_statuses_used = {}

var Waiting = React.createClass({
	mixins: [React.addons.PureRenderMixin],

	getInitialState: function () {
		return {}
	},
	getDefaultProps: function () {
		return {
			room: {
				users: [],
			},
		}
	},
	render: function () {
		var profile_pic_size = 310
		var padding_border_width =
			/* image border */ 12 + /* image padding?? */ 10 + /* user padding */ 30
		var padding_border_height =
			93 +
			10 +
			20 +
			15 /* the complete .user height - (size of the pic + border of the pic)  + padding*/

		var available_width = $('.toolbar ')[0].offsetWidth - 50 /* .waiting padding */
		var available_height =
			$('.game').height() - $('.toolbar ')[0].offsetHeight - 1 /* .waiting padding */

		var users_per_row = (available_width / (profile_pic_size + padding_border_width)) | 0
		var users_per_col = (available_height / (profile_pic_size + padding_border_height)) | 0
		while (window.room.users.length + 1 > users_per_row * users_per_col) {
			profile_pic_size -= 1
			users_per_row = (available_width / (profile_pic_size + padding_border_width)) | 0
			users_per_col = (available_height / (profile_pic_size + padding_border_height)) | 0
		}

		return (
			<div className="waiting">
				{this.props.room.users.map(
					function (item, idx) {
						var transparent =
							!item.color || item.color == '' || tinycolor(item.color).getAlpha() === 0
								? true
								: false

						if (transparent) var size = profile_pic_size + 12
						else var size = profile_pic_size

						var style = {
							borderColor: String(item.color),
							width: size + 'px',
							height: size + 'px',
						}

						if (transparent) {
							style.border = 'none'
						}
						var Ping = function Ping() {
							return <span className="ping">{item.tang ? ' / ' + item.tang + 'ms' : ''}</span>
						}
						if (item.waitingbg3 && tinycolor(item.waitingbg3).getAlpha() === 1) {
							item.waitingbg3 = tinycolor(item.waitingbg3).setAlpha(0.3).toString()
						}
						if (item.waitingbg2 && tinycolor(item.waitingbg2).getAlpha() === 1) {
							item.waitingbg2 = tinycolor(item.waitingbg2).setAlpha(0.3).toString()
						}
						if (item.waitingbg && tinycolor(item.waitingbg).getAlpha() === 1) {
							item.waitingbg = tinycolor(item.waitingbg).setAlpha(0.3).toString()
						}

						return (
							<div
								key={item.id}
								className="user"
								style={{
									maxWidth: profile_pic_size + 12 + 'px',
									color: u.readable(item.mccolor) || 'white',
									background:
										'linear-gradient(' +
										(item.waitingbg3 || 'rgba(0, 0, 0, 0)') +
										',' +
										(item.waitingbg2 || 'rgba(0, 0, 0, 0)') +
										',' +
										(item.waitingbg || 'rgba(0, 0, 0, 0)') +
										')',
								}}
								data-donated={item.donated}
								data-username={item.username}
							>
								<div className="img pointer" onClick={openProfile} data-username={item.username}>
									<FloatingEmoji username={item.username} />
									{!is_video(item.image) ? (
										<img
											key={item.id}
											data-break-it="true"
											onMouseOver={this.playSound}
											data-sound={idx + 1}
											style={style}
											title={item.username}
											src={profile_picture(item.image, true)}
										/>
									) : (
										<Video
											key={item.id}
											onMouseOver={this.playSound}
											data_sound={idx + 1}
											title={item.username}
											style={style}
											src={profile_picture(item.image, true)}
											className="profile-image no-select"
										/>
									)}
									<Favicon url={item.plink} />
									<GameMedals username={item.username} />
								</div>
								<div
									className="username"
									data-username={item.username}
									data-admin={u.is_mod(item.username)}
									data-donated={item.donated}
									title={item.username}
									style={
										item.mcolor
											? { color: u.readable(item.mcolor) || 'white', fontWeight: 'bold' }
											: {}
									}
								>
									{verified(item.username)} {item.username}{' '}
									{item.donated ? <img src={u.badge(item.username)} className="badge" /> : null}
								</div>

								{item.username.indexOf('Lame Guest') === 0 ? (
									<div data-username={item.username} className="arcade">
										I Love MOBC ♥
									</div>
								) : (
									<div data-username={item.username} className="arcade">
										<div
											className="hidden stats-pool"
											title={
												(item.arcade.pool && item.arcade.pool.games
													? (item.arcade.pool.win / (item.arcade.pool.games / 100)).toFixed(3) + '%'
													: '0%') + ' / Games / Wins / YouTube / Rounds / Ping'
											}
										>
											G{' '}
											<b>
												{item.arcade.pool && item.arcade.pool.games ? item.arcade.pool.games : '0'}
											</b>{' '}
											/ W{' '}
											<b>{item.arcade.pool && item.arcade.pool.win ? item.arcade.pool.win : '0'}</b>{' '}
											/ YT <b>{item.arcade.yt && item.arcade.yt.c ? item.arcade.yt.c : '0'}</b> / R{' '}
											<b>{item.arcade.r && item.arcade.r ? item.arcade.r : '0'}</b>
											<Ping />
										</div>
										<div
											className="hidden stats-9ball"
											title={
												(item.arcade['9ball'] && item.arcade['9ball'].games
													? (item.arcade['9ball'].win / (item.arcade['9ball'].games / 100)).toFixed(
															3,
													  ) + '%'
													: '0%') + ' / Games / Wins / YouTube / Rounds / Ping'
											}
										>
											G{' '}
											<b>
												{item.arcade['9ball'] && item.arcade['9ball'].games
													? item.arcade['9ball'].games
													: '0'}
											</b>{' '}
											/ W{' '}
											<b>
												{item.arcade['9ball'] && item.arcade['9ball'].win
													? item.arcade['9ball'].win
													: '0'}
											</b>{' '}
											/ YT <b>{item.arcade.yt && item.arcade.yt.c ? item.arcade.yt.c : '0'}</b> / R{' '}
											<b>{item.arcade.r && item.arcade.r ? item.arcade.r : '0'}</b>
											<Ping />
										</div>
										<div
											className="hidden stats-swapples"
											title="Games / High Score / YouTube / Rounds / Ping"
										>
											G{' '}
											<b>
												{item.arcade.swapples && item.arcade.swapples.games
													? item.arcade.swapples.games
													: '0'}
											</b>{' '}
											/ HS{' '}
											<b>
												{item.arcade.swapples &&
												item.arcade.swapples.score &&
												item.arcade.swapples.score.g
													? item.arcade.swapples.score.g.p
													: '0'}
											</b>{' '}
											/ YT <b>{item.arcade.yt && item.arcade.yt.c ? item.arcade.yt.c : '0'}</b> / R{' '}
											<b>{item.arcade.r && item.arcade.r ? item.arcade.r : '0'}</b>
											<Ping />
										</div>
										<div
											className="hidden stats-poker"
											title="Games / High Score / YouTube / Rounds / Ping"
										>
											G{' '}
											<b>
												{item.arcade.poker && item.arcade.poker.games
													? item.arcade.poker.games
													: '0'}
											</b>{' '}
											/ HS{' '}
											<b>
												{item.arcade.poker && item.arcade.poker.score && item.arcade.poker.score.g
													? item.arcade.poker.score.g.p
													: '0'}
											</b>{' '}
											/ YT <b>{item.arcade.yt && item.arcade.yt.c ? item.arcade.yt.c : '0'}</b> / R{' '}
											<b>{item.arcade.r && item.arcade.r ? item.arcade.r : '0'}</b>
											<Ping />
										</div>
										<div
											className="hidden stats-bubbles"
											title="Games / Cleared / YouTube / Rounds / Ping"
										>
											G{' '}
											<b>
												{item.arcade.dinglepop && item.arcade.dinglepop.games
													? item.arcade.dinglepop.games
													: '0'}
											</b>{' '}
											/ C{' '}
											<b>
												{item.arcade.dinglepop && item.arcade.dinglepop.cleared
													? item.arcade.dinglepop.cleared
													: '0'}
											</b>{' '}
											/ YT <b>{item.arcade.yt && item.arcade.yt.c ? item.arcade.yt.c : '0'}</b> / R{' '}
											<b>{item.arcade.r && item.arcade.r ? item.arcade.r : '0'}</b>
											<Ping />
										</div>
										<div
											className="hidden stats-dinglepop"
											title="Games / Cleared / YouTube / Rounds / Ping"
										>
											{' '}
											YT <b>{item.arcade.yt && item.arcade.yt.c ? item.arcade.yt.c : '0'}</b> / R{' '}
											<b>{item.arcade.r && item.arcade.r ? item.arcade.r : '0'}</b>
											<Ping />
										</div>
										<div
											className="hidden stats-blockles"
											title="Games / High Score / YouTube / Rounds / Ping"
										>
											G{' '}
											<b>
												{item.arcade.blockles && item.arcade.blockles.games
													? item.arcade.blockles.games
													: '0'}
											</b>{' '}
											/ HS{' '}
											<b>
												{item.arcade.blockles && item.arcade.blockles.score
													? item.arcade.blockles.score
													: '0'}
											</b>{' '}
											/ YT <b>{item.arcade.yt && item.arcade.yt.c ? item.arcade.yt.c : '0'}</b> / R{' '}
											<b>{item.arcade.r && item.arcade.r ? item.arcade.r : '0'}</b>
											<Ping />
										</div>
										<div
											className="hidden stats-blocklesmulti"
											title={
												(item.arcade.blocklesmulti && item.arcade.blocklesmulti.games
													? (
															item.arcade.blocklesmulti.win /
															(item.arcade.blocklesmulti.games / 100)
													  ).toFixed(3) + '%'
													: '0%') + ' / Games / Wins / YouTube / Rounds / Ping'
											}
										>
											G{' '}
											<b>
												{item.arcade.blocklesmulti && item.arcade.blocklesmulti.games
													? item.arcade.blocklesmulti.games
													: '0'}
											</b>{' '}
											/ W{' '}
											<b>
												{item.arcade.blocklesmulti && item.arcade.blocklesmulti.win
													? item.arcade.blocklesmulti.win
													: '0'}
											</b>{' '}
											/ YT <b>{item.arcade.yt && item.arcade.yt.c ? item.arcade.yt.c : '0'}</b> / R{' '}
											<b>{item.arcade.r && item.arcade.r ? item.arcade.r : '0'}</b>
											<Ping />
										</div>
										<div
											className="hidden stats-gemmers"
											title="Games / High Score / YouTube / Rounds / Ping"
										>
											G{' '}
											<b>
												{item.arcade.gemmers && item.arcade.gemmers.games
													? item.arcade.gemmers.games
													: '0'}
											</b>{' '}
											/ HS{' '}
											<b>
												{item.arcade.gemmers && item.arcade.gemmers.score
													? item.arcade.gemmers.score
													: '0'}
											</b>{' '}
											/ YT <b>{item.arcade.yt && item.arcade.yt.c ? item.arcade.yt.c : '0'}</b> / R{' '}
											<b>{item.arcade.r && item.arcade.r ? item.arcade.r : '0'}</b>
											<Ping />
										</div>

										<div className="hidden stats-tonk3" title="Games / YouTube / Rounds / Ping">
											G{' '}
											<b>
												{item.arcade.tonk3 && item.arcade.tonk3.games
													? item.arcade.tonk3.games
													: '0'}
											</b>{' '}
											/ YT <b>{item.arcade.yt && item.arcade.yt.c ? item.arcade.yt.c : '0'}</b> / R{' '}
											<b>{item.arcade.r && item.arcade.r ? item.arcade.r : '0'}</b>
											<Ping />
										</div>
										<div
											className="hidden stats-skypigs"
											title="Games / Feet / YouTube / Rounds / Ping"
										>
											G{' '}
											<b>
												{item.arcade.skypigs && item.arcade.skypigs.games
													? item.arcade.skypigs.games
													: '0'}
											</b>{' '}
											/ Feet{' '}
											<b>
												{item.arcade.skypigs && item.arcade.skypigs.score
													? item.arcade.skypigs.score
													: '0'}
											</b>{' '}
											/ YT <b>{item.arcade.yt && item.arcade.yt.c ? item.arcade.yt.c : '0'}</b> / R{' '}
											<b>{item.arcade.r && item.arcade.r ? item.arcade.r : '0'}</b>
											<Ping />
										</div>

										<div
											className="hidden stats-balloono"
											title={
												(item.arcade.balloono && item.arcade.balloono.games
													? (item.arcade.balloono.win / (item.arcade.balloono.games / 100)).toFixed(
															3,
													  ) + '%'
													: '0%') + ' / Games / Wins / YouTube / Rounds / Ping'
											}
										>
											G{' '}
											<b>
												{item.arcade.balloono && item.arcade.balloono.games
													? item.arcade.balloono.games
													: '0'}
											</b>{' '}
											/ W{' '}
											<b>
												{item.arcade.balloono && item.arcade.balloono.win
													? item.arcade.balloono.win
													: '0'}
											</b>{' '}
											/ YT <b>{item.arcade.yt && item.arcade.yt.c ? item.arcade.yt.c : '0'}</b> / R{' '}
											<b>{item.arcade.r && item.arcade.r ? item.arcade.r : '0'}</b>
											<Ping />
										</div>
										<div
											className="hidden stats-balloonoboot"
											title={
												(item.arcade.balloonoboot && item.arcade.balloonoboot.games
													? (
															item.arcade.balloonoboot.win /
															(item.arcade.balloonoboot.games / 100)
													  ).toFixed(3) + '%'
													: '0%') + ' / Games / Wins / YouTube / Rounds / Ping'
											}
										>
											G{' '}
											<b>
												{item.arcade.balloonoboot && item.arcade.balloonoboot.games
													? item.arcade.balloonoboot.games
													: '0'}
											</b>{' '}
											/ W{' '}
											<b>
												{item.arcade.balloonoboot && item.arcade.balloonoboot.win
													? item.arcade.balloonoboot.win
													: '0'}
											</b>{' '}
											/ YT <b>{item.arcade.yt && item.arcade.yt.c ? item.arcade.yt.c : '0'}</b> / R{' '}
											<b>{item.arcade.r && item.arcade.r ? item.arcade.r : '0'}</b>
											<Ping />
										</div>
										<div
											className="hidden stats-checkers"
											title={
												(item.arcade.checkers && item.arcade.checkers.games
													? (item.arcade.checkers.win / (item.arcade.checkers.games / 100)).toFixed(
															3,
													  ) + '%'
													: '0%') + ' / Games / Wins / YouTube / Rounds / Ping'
											}
										>
											G{' '}
											<b>
												{item.arcade.checkers && item.arcade.checkers.games
													? item.arcade.checkers.games
													: '0'}
											</b>{' '}
											/ W{' '}
											<b>
												{item.arcade.checkers && item.arcade.checkers.win
													? item.arcade.checkers.win
													: '0'}
											</b>{' '}
											/ YT <b>{item.arcade.yt && item.arcade.yt.c ? item.arcade.yt.c : '0'}</b> / R{' '}
											<b>{item.arcade.r && item.arcade.r ? item.arcade.r : '0'}</b>
											<Ping />
										</div>
										<div
											className="hidden stats-cuacka"
											title="Games / High Score / YouTube / Rounds / Ping"
										>
											G{' '}
											<b>
												{item.arcade.cuacka && item.arcade.cuacka.games
													? item.arcade.cuacka.games
													: '0'}
											</b>{' '}
											/ HS{' '}
											<b>
												{item.arcade.cuacka && item.arcade.cuacka.score
													? item.arcade.cuacka.score
													: '0'}
											</b>{' '}
											/ YT <b>{item.arcade.yt && item.arcade.yt.c ? item.arcade.yt.c : '0'}</b> / R{' '}
											<b>{item.arcade.r && item.arcade.r ? item.arcade.r : '0'}</b>
											<Ping />
										</div>
										<div
											className="hidden stats-watchtogether"
											title="YouTube Videos Shareds / Ping"
										>
											YouTube <b>{item.arcade.yt && item.arcade.yt.c ? item.arcade.yt.c : '0'}</b> /
											R <b>{item.arcade.r && item.arcade.r ? item.arcade.r : '0'}</b>
											<Ping />
										</div>
									</div>
								)}

								<div
									className="status"
									title={item.status}
									dangerouslySetInnerHTML={{
										__html: u.linky_no_link_cached(item.status),
									}}
								/>
							</div>
						)
					}.bind(this),
				)}
			</div>
		)
	},
	noop: function () {
		this.setState({
			noop: !this.state.noop,
		})
	},
	componentDidMount: function () {
		window.addEventListener('resize', this.noop, {
			passive: true,
		})
	},
	componentWillUnmount: function () {
		window.removeEventListener('resize', this.noop, {
			passive: true,
		})
	},
	playSound: function (e) {
		var idx = +$(e.currentTarget).attr('data-sound')

		while (idx > 8) idx -= 8
		if (1 % idx == 0) u.soundWhenTabNotMuted('notes/1')
		else if (2 % idx == 0) u.soundWhenTabNotMuted('notes/2')
		else if (3 % idx == 0) u.soundWhenTabNotMuted('notes/3')
		else if (4 % idx == 0) u.soundWhenTabNotMuted('notes/4')
		else if (5 % idx == 0) u.soundWhenTabNotMuted('notes/5')
		else if (6 % idx == 0) u.soundWhenTabNotMuted('notes/6')
		else if (7 % idx == 0) u.soundWhenTabNotMuted('notes/7')
		else if (8 % idx == 0) u.soundWhenTabNotMuted('notes/8')
	},
})
