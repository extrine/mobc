var GameWatchtogetherPlayerCache = {}

var GameWatchtogether = React.createClass({
	mixins: [React.addons.PureRenderMixin],
	getInitialState: function () {
		window.swf = this
		return null
	},
	render: function () {
		return (
			<div className="game-swf">
				{!this.props.room.started ? (
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
				) : (
					<div className="game-swf-object">
						{!is_video(this.props.room.users[0].image) ? (
							<img className="videodj-img" src={profile_picture(this.props.room.users[0].image)} />
						) : (
							<img
								className="videodj-img"
								src={profile_picture(this.props.room.users[0].image).replace(/\.[^\.]+$/, '.png')}
							/>
						)}

						<GameWatchtogetherPlayer
							player="1"
							room={this.props.room}
							data={this.props.room.round.data ? this.props.room.round.data[1] : {}}
						/>
					</div>
				)}
			</div>
		)
	},

	muted: function () {
		var o = storage.get()
		return o.muted ? true : false
	},
	getUsers: function () {
		return window.room.users
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
})

var GameWatchtogetherPlayer = React.createClass({
	mixins: [React.addons.PureRenderMixin],
	getInitialState: function () {
		this.lastSeek = 0
		this.firstTime = true
		this.autoplay_timeout = false
		this.autoplay_played = {}
		if (this.props.player == '1') {
			window.playThis = this.playThis
		}

		return {
			results: [],
			queue: [],
		}
	},
	playThis: function (e, video_id) {
		if (this.host() && this.player) {
			this.onSelectVideo(e, {
				'id': { 'kind': 'youtube#video', 'videoId': video_id },
				'snippet': {
					'title': 'YT/' + video_id,
					'thumbnails': {
						'default': {
							'url': 'https://omgmobc.com/img/icon/favicon.png',
							'width': 120,
							'height': 90,
						},
						'medium': {
							'url': 'https://omgmobc.com/img/icon/favicon.png',
							'width': 320,
							'height': 180,
						},
						'high': {
							'url': 'https://omgmobc.com/img/icon/favicon.png',
							'width': 480,
							'height': 360,
						},
					},
				},
			})
		}
	},

	render: function () {
		var results = this.state.results || []
		var queue = this.state.queue || []
		var related = this.props.data && this.props.data.related ? this.props.data.related : []
		setTimeout(
			function () {
				this.firstTime = false
			}.bind(this),
			0,
		)
		return (
			<div
				className={
					'full-height l w50 player-container ' +
					(this.state.maximize ||
					(this.firstTime && this.props.player === '1' && (this.state.maximize = true))
						? ' maximize '
						: '')
				}
			>
				{false && this.props.data && this.props.data.n ? (
					<iframe
						onDoubleClick={stopEvent}
						frameBorder="0"
						className="lyrics"
						src={
							'https://genius.com/search?q=' +
							encodeURIComponent(
								this.props.data.n
									.replace(/\[[^\]]+\]/g, ' ')
									.replace(/\([^)]+\)/g, ' ')
									.replace(/official/g, ' ')
									.replace(/original/g, ' ')
									.replace(/video/g, ' ')
									.replace(/version/g, ' ')
									.replace(/mix/g, ' ')
									.replace(/remix/g, ' ')
									.replace(/"/g, ' ')
									.replace(/'/g, ' ')
									.replace(/new song/g, ' ')
									.replace(/ ?19[0-9][0-9] ?/g, ' ')
									.replace(/ ?20[0-9][0-9] ?/g, ' ')
									.replace(/\|/g, ' - ')
									.replace(/&[^ ;]+;/g, ' ')
									.replace(/quot;/g, ' ')
									.replace(/:/g, ' - ')
									.replace(/\s+/g, ' ')
									.trim()
									.replace(/^[0-9]+\s/g, ''),
							)
						}
						sandbox={
							//  'allow-downloads-without-user-activation ' +
							'allow-forms ' +
							// 'allow-modals ' +
							// 'allow-orientation-lock ' +
							// 'allow-pointer-lock ' +
							// 'allow-popups ' +
							// 'allow-popups-to-escape-sandbox '+
							//  'allow-presentation ' +
							'allow-same-origin ' +
							'allow-scripts ' +
							// 'allow-storage-access-by-user-activation ' +
							// 'allow-top-navigation '+
							// 'allow-top-navigation-by-user-activation '+
							''
						}
					/>
				) : null}
				<iframe
					id={'watchtogether-player' + this.props.player}
					onDoubleClick={stopEvent}
					frameBorder="0"
					width="100%"
					height="70%"
					allow="autoplay"
					allowFullScreen="allowFullScreen"
					src={
						'//www.youtube.com/embed/?disablekb=1&fs=1&modestbranding=1&iv_load_policy=3&rel=0&enablejsapi=1&autoplay=1&' +
						'origin=' +
						location.protocol +
						'//' +
						location.host +
						//'&host=https://' +
						//location.host +
						'&widgetid=1'
					}
					enablejsapi="1"
				/>

				<div className="search">
					<input
						onKeyUp={this.search}
						onChange={this.search}
						onKeyPress={this.search}
						onKeyDown={this.search}
						placeholder="Search for Video.."
						className={'player-input' + this.props.player}
					/>
					<div className="results" ref="results">
						{results.map(
							function (item, idx) {
								return (
									<a
										data-href={'https://www.youtube.com/watch?v=' + item.id.videoId}
										key={idx}
										title={item.snippet.title}
										className={
											'item' +
											(item.snippet.liveBroadcastContent == 'live' ? ' live ' : ' ') +
											(item.id.videoId ==
											(this.props.data && this.props.data.v ? this.props.data.v : '')
												? ' selected '
												: '')
										}
										onClick={e => this.onSelectVideo(e, item)}
										data-video-id={item.id.videoId}
										data-video-title={item.snippet.title}
										target="_blank"
									>
										<img
											width="30"
											height="23"
											src={item.snippet.thumbnails.default.url}
											data-video-id={item.id.videoId}
											data-video-title={item.snippet.title}
										/>{' '}
										<span>{item.snippet.title}</span>
										<div className="clear" />
									</a>
								)
							}.bind(this),
						)}

						{queue.map(
							function (item, idx) {
								return (
									<a
										data-href={'https://www.youtube.com/watch?v=' + item.id.videoId}
										key={idx}
										title={item.snippet.title}
										className={
											'item' +
											(item.snippet.liveBroadcastContent == 'live' ? ' live ' : '') +
											(item.id.videoId ==
											(this.props.data && this.props.data.v ? this.props.data.v : '')
												? ' selected '
												: '')
										}
										onClick={e => this.onSelectVideo(e, item)}
										data-video-id={item.id.videoId}
										data-video-title={item.snippet.title}
										target="_blank"
									>
										<img
											width="30"
											height="23"
											src={item.snippet.thumbnails.default.url}
											data-video-id={item.id.videoId}
											data-video-title={item.snippet.title}
										/>{' '}
										<span>{item.snippet.title}</span>
										<div className="clear" />
									</a>
								)
							}.bind(this),
						)}
					</div>
					<div className="results" ref="related">
						{related.map(
							function (item, idx) {
								return (
									<a
										data-href={'https://www.youtube.com/watch?v=' + item.id.videoId}
										key={idx}
										title={item.snippet.title}
										className={
											'item' +
											(item.snippet.liveBroadcastContent == 'live' ? ' live ' : '') +
											(item.id.videoId ==
											(this.props.data && this.props.data.v ? this.props.data.v : '')
												? ' selected '
												: '')
										}
										onClick={e => this.onSelectVideo(e, item)}
										data-video-id={item.id.videoId}
										data-video-title={item.snippet.title}
										target="_blank"
									>
										<img
											width="30"
											height="23"
											src={item.snippet.thumbnails.default.url}
											data-video-id={item.id.videoId}
											data-video-title={item.snippet.title}
										/>{' '}
										<span>{item.snippet.title}</span>
										<div className="clear" />
									</a>
								)
							}.bind(this),
						)}
					</div>
				</div>
			</div>
		)
	},
	maximize: function () {
		this.setState({
			maximize: !this.state.maximize,
		})
	},

	onSelectVideo: function (e, vid) {
		var item = $(e.currentTarget)
		if ((e.ctrlKey || e.metaKey) && !e.shiftKey) {
			window.open(item.attr('data-href'), '_blank')
		} else if (this.host() && e.shiftKey && (e.ctrlKey || e.metaKey) && vid) {
			this.setState({
				queue: this.state.queue.filter(function (item) {
					return item.id.videoId != vid.id.videoId
				}),
			})
		} else if (this.host() && e.shiftKey && vid) {
			this.setState({ queue: [...this.state.queue, vid] })
		} else {
			if (this.host()) {
				if (item.attr('data-video-id') && item.attr('data-video-id') != '') {
					clearTimeout(this.autoplay_timeout)
					this.autoplay_played[item.attr('data-video-id')] = true
					this.player.loadVideoById({
						videoId: item.attr('data-video-id'),
					})
				}
			} else {
				if (item.attr('data-video-id') && item.attr('data-video-id') != '') {
					var msg =
						'https://www.youtube.com/watch?v=' +
						encodeURIComponent(item.attr('data-video-id')) +
						' ' +
						item.attr('data-video-title')

					if (this.lastMessage != msg) {
						this.lastMessage = msg
						emit({
							id: 'c',
							m: this.lastMessage,
							r: window.room && window.room.id,
						})
					}
				}
			}
		}
	},
	search: function (e) {
		var value = String(e.target.value)
			.trim()
			.replace(/^([^&]+).*$/g, '$1')
		if (value.length > 2) {
			clearTimeout(this.searchResultsClearTimeout)
			if (GameWatchtogetherPlayerCache[value]) {
				this.setState({
					results: GameWatchtogetherPlayerCache[value],
				})
				this.refs.results.scrollTop = 0
				this.searchResultsClearTimeout = setTimeout(
					function () {
						this.setState({
							results: [],
						})
					}.bind(this),
					40000,
				)
			} else {
				clearTimeout(this.searchTimeout)
				this.searchTimeout = setTimeout(
					function () {
						emit(
							{
								id: 'wts',
								s: value,
							},
							function (data) {
								GameWatchtogetherPlayerCache[value] = data
								this.setState({
									results: GameWatchtogetherPlayerCache[value],
								})
								if (this.refs && this.refs.results) this.refs.results.scrollTop = 0
								this.searchResultsClearTimeout = setTimeout(
									function () {
										this.setState({
											results: [],
										})
									}.bind(this),
									40000,
								)
							}.bind(this),
						)
					}.bind(this),
					2000,
				)
			}
		} else {
			this.setState({
				results: [],
			})
		}
	},
	componentWillUnmount: function () {
		this.player = null
		window.playThis = null
	},
	componentDidUpdate: function (prevProps, prevState) {
		this.componentDidMount()

		try {
			if (!this.host()) {
				if (this.ready && this.props.data && this.props.data.v && prevProps != this.props) {
					if (this.props.data && this.player.getVideoData().video_id != this.props.data.v) {
						this.autoplay_played[this.props.data.v] = true
						this.player.loadVideoById({
							videoId: this.props.data.v,
						})

						this.lastSeek = 0
					}

					if (this.lastSeek != Math.round(this.props.data.t)) {
						this.lastSeek = Math.round(this.props.data.t)
						this.player.seekTo(this.props.data.t + (this.props.room.now - this.props.data.c) / 1000)
					}

					if (this.props.data.s === 0) {
						this.player.pauseVideo()
					} else {
						this.player.playVideo()
					}
				}
			}
		} catch (e) {
			setTimeout(
				function () {
					this.componentDidUpdate()
				}.bind(this),
				200,
			)
		}
	},
	componentDidMount: function () {
		if (
			this.props.room.started &&
			!this.player &&
			document.getElementById('watchtogether-player' + this.props.player)
		) {
			this.player = new YT.Player(
				document.getElementById('watchtogether-player' + this.props.player),
				{
					height: '100%',
					width: '100%',
					videoId: this.props.data && this.props.data.v ? this.props.data.v : '',
					origin: location.protocol + '//' + location.host,
					//host: 'https://' + location.host,
					playerVars: {
						color: '#8015f5',
						disablekb: 1,
						fs: 0,
						modestbranding: 1,
						iv_load_policy: 3,
						rel: 0,
						enablejsapi: 1,
						autoplay: 1,
						origin: 'https://' + location.host,
						//host: 'https://' + location.host,
						widgetid: 1,
					},
					events: {
						onReady: this.componentDidUpdateReady, // .bind(this)
						onStateChange: this.onStateChange, // .bind(this)
					},
				},
			)
		}
	},

	componentDidUpdateReady: function () {
		try {
			this.ready = true

			if (!this.host()) {
				if (this.props.data && this.player.getVideoData().video_id != this.props.data.v) {
					try {
						var seek_to = this.props.data.t + (this.props.room.now - this.props.data.c) / 1000 + 3
					} catch (e) {
						var seek_to = 0
					}
					this.autoplay_played[this.props.data.v] = true
					this.player.loadVideoById({
						videoId: this.props.data.v,
						startSeconds: seek_to,
					})
				}

				if (this.props.data && this.props.data.t !== undefined) {
					if (this.props.data.s === 0) {
						this.player.pauseVideo()
					} else {
						this.player.playVideo()
					}
					if (this.props.data.s === 1) {
						var seek_to = this.props.data.t + (this.props.room.now - this.props.data.c) / 1000 + 3

						this.player.seekTo(seek_to)
						setTimeout(
							function () {
								try {
									this.player.seekTo(seek_to)
								} catch (e) {}
							}.bind(this),
							1000,
						)
					} else {
						this.player.seekTo(this.props.data.t)
					}
				} else {
				}
			}
		} catch (e) {
			setTimeout(
				function () {
					this.componentDidUpdateReady()
				}.bind(this),
				100,
			)
		}
	},
	next_video: function () {
		if (this.state.queue.length > 0) {
			var queue = [...this.state.queue]
			var next = queue.shift()
			this.setState({ queue: queue })
			return next.id.videoId
		} else {
			var related = this.props.data && this.props.data.related ? this.props.data.related : []

			for (var id in related) {
				if (this.autoplay_played[related[id].id.videoId]) {
				} else {
					return related[id].id.videoId
				}
			}

			return false
		}
	},
	onStateChange: function (event) {
		try {
			var self = this

			if (self.host()) {
				var data = this.player.getVideoData()
				data.time = this.player.getCurrentTime()
				if (event.data === -1) {
				} else if (event.data === 0) {
					clearTimeout(this.pause_timeout)

					if (self.host()) {
						var to_play = this.next_video()
						if (to_play) {
							clearTimeout(this.autoplay_timeout)

							this.autoplay_timeout = setTimeout(
								function () {
									this.autoplay_played[to_play] = true
									this.player.loadVideoById({
										videoId: to_play,
									})

									var data = this.player.getVideoData()
									if (data)
										emit({
											id: 'wt',
											d: {
												v: data.video_id,
												t: data.time,
												n: data.title,
												s: 1,
												p: +this.props.player,
											},
										})
								}.bind(this),
								1500,
							)
						} else {
							emit({
								id: 'wt',
								d: {
									v: data.video_id,
									t: data.time,
									n: data.title,
									s: 0,
									p: +this.props.player,
								},
							})
						}
					}
				} else if (event.data === 1) {
					this.lastSeek = Math.round(data.time)

					clearTimeout(this.pause_timeout)
					if (self.host())
						emit({
							id: 'wt',
							d: {
								v: data.video_id,
								t: data.time,
								n: data.title,
								s: 1,
								p: +this.props.player,
							},
						})
				} else if (event.data === 2) {
					this.lastSeek = Math.round(data.time)

					clearTimeout(this.pause_timeout)
					this.pause_timeout = setTimeout(
						function () {
							//if (self.host())
							emit({
								id: 'wt',
								d: {
									v: data.video_id,
									t: data.time,
									n: data.title,
									s: 0,
									p: +this.props.player,
								},
							})
						}.bind(this),
						400,
					)
				} else if (event.data === 3) {
					clearTimeout(this.pause_timeout)
				} else if (event.data === 5) {
				}
			}
		} catch (e) {
			setTimeout(
				function () {
					//this.onStateChange()
				}.bind(this),
				100,
			)
		}
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

	host: function () {
		return (
			window.room &&
			window.room.users &&
			window.room.users[0] &&
			window.room.users[0].id == window.user.id
		)
	},
	me: function () {
		return window.user
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
})
