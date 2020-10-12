var ChatPrivateImages = {}
var ChatPrivate = React.createClass({
	mixins: [React.addons.PureRenderMixin],

	getInitialState: function () {
		this.id = 0
		this.focused = false
		this.unread = 0

		this.holdingNOSCROLL = false
		ios.on(
			'a',
			function (data) {
				if (data.id == 'groups update') {
					data.g = uncompress(data.g)
					for (var gr in data.g) {
						if (data.g[gr] && data.g[gr].m) {
							for (msg in data.g[gr].m) {
								if (window.user && window.user.block && window.user.block[data.g[gr].m[msg].u]) {
									data.g[gr].m[msg].m = '[ Blocked ]'
								}
							}
						}
					}
					this.setState({
						groups: data.g,
					})
					var found = false,
						focused = this.state.focused
					for (var id in data.g) {
						if (data.g[id].id == focused) {
							found = true
							break
						}
					}
					if (!found) {
						if (data.g[0] && this.state.focused == false)
							this.setState({
								focused: data.g[0].id,
							})
						else
							this.setState({
								focused: false,
							})
					}
				} else if (data.id == 'group update') {
					data.g = uncompress(data.g)
					for (msg in data.g.m) {
						if (
							data.g.m &&
							data.g.m[msg] &&
							data.g.m[msg].u &&
							data.g.m[msg].m &&
							window.user &&
							window.user.block &&
							window.user.block[data.g.m[msg].u]
						) {
							data.g.m[msg].m = '[ Blocked ]'
						}
					}
					var found = false
					for (var id in this.state.groups) {
						if (this.state.groups[id].id == data.g.id) {
							this.state.groups[id] = data.g
							found = true
							break
						}
					}
					if (!found) {
						this.state.groups.push(data.g)
					}
					this.setState({
						groups: [].concat(this.state.groups),
					})
					if (this.state.focused == false && this.state.groups[0])
						this.setState({
							focused: this.state.groups[0].id,
						})
					else if (this.state.groups.length === 0)
						this.setState({
							focused: false,
						})
				} else if (data.id == 'pc') {
					if (data.m.u && window.user && window.user.block && window.user.block[data.m.u]) {
						data.m.m = '[ Blocked ]'
					}
					for (var id in this.state.groups) {
						if (this.state.groups[id].id == data.g) {
							this.state.groups[id].m.push(data.m)

							if (window.user.username != data.m.u) {
								u.soundWhenTabUnfocusedMuted('mention')

								if (this.state.focused == this.state.groups[id].id && this.focused && this.opened) {
									var o = storage.get()
									if (!o.unread) o.unread = {}

									o.unread[this.state.groups[id].id] = data.m.id
									storage.update(o)
								}
							} else {
								var o = storage.get()
								if (!o.unread) o.unread = {}

								o.unread[this.state.groups[id].id] = data.m.id
								storage.update(o)
							}
							break
						}
					}

					this.setState({
						groups: [].concat(this.state.groups),
					})
				}
			}.bind(this),
		)

		ios.on('ti', data => {
			if (data.g && data.u != window.user.username) {
				if (data.u.indexOf('Lame Guest') === 0) {
					return
				}
				let isTyping = { ...this.state.isTyping }
				if (!isTyping[data.g]) isTyping[data.g] = {}
				switch (data.v) {
					case true:
						isTyping[data.g][data.u] = true
						break
					case false:
						delete isTyping[data.g][data.u]
						break
				}
				this.setState({ isTyping: isTyping })
			}
		})

		ios.on('si', data => {
			if (data.g && data.u != window.user.username) {
				if (data.u.indexOf('Lame Guest') === 0) {
					return
				}
				let isSinging = { ...this.state.isSinging }
				switch (data.v) {
					case true:
						isSinging[data.u] = true
						break
					case false:
						delete isSinging[data.u]
						break
				}
				this.setState({ isSinging: isSinging })
			}
		})

		document.addEventListener(
			'keydown',
			function (e) {
				if (e.key === 'F1' && !e.repeat) {
					e.preventDefault()
					e.stopPropagation()
					if ($('.chat-private .chat-input').is(':visible')) {
						if (e.ctrlKey || e.metaKey) {
							this.recordVideoStart(e)
						} else {
							this.recordAudioStart(e)
						}
					}
				}
			}.bind(this),
			false,
		)

		document.addEventListener(
			'keyup',
			function (e) {
				if (e.key === 'F1') {
					if ($('.chat-private .chat-input').is(':visible')) {
						e.preventDefault()
						e.stopPropagation()
						this.recordVideoStop(e)
						this.recordAudioStop(e)
					}
				}
			}.bind(this),
			false,
		)

		u.on_document_visibility_change.push(
			function (visible) {
				if (visible) {
					this.unread = 0
					u.unread(this.unread)
				}
				this.holdingNOSCROLL = false
			}.bind(this),
		)

		document.addEventListener(
			'keydown',
			function (e) {
				this.holdingNOSCROLL = e.altKey || e.ctrlKey || e.metaKey || e.shiftKey
				if (e.keyCode === 8 && !u.isInput(document.activeElement, e)) {
					e.preventDefault()
					e.stopPropagation()
					return false
				}
			}.bind(this),
			{
				passive: true,
			},
		)
		document.addEventListener(
			'keyup',
			function (e) {
				this.holdingNOSCROLL = false
			}.bind(this),
			{
				passive: true,
			},
		)

		document.addEventListener(
			'mousedown',
			function (e) {
				this.holdingNOSCROLL = true
			}.bind(this),
			{ passive: true },
		)
		document.addEventListener(
			'mouseup',
			function (e) {
				this.holdingNOSCROLL = false
			}.bind(this),
			{ passive: true },
		)
		window.updateScrollPrivate = this.scroll
		this.opened = false
		return {
			items: [],
			goal: 0,
			groups: [],
			results: [],
			focused: false,
			textboxFocused: false,
			unread: {},
			isTyping: {},
			isSinging: {},
		}
	},
	disableScroll: function () {
		this.holdingNOSCROLL = true
		/*
		scrollTop, at maximum scroll, will be equal to the scrollHeight minus offsetHeight of the element.
		This is because the offsetHeight is included in the scrollHeight.
*/
		var element = $('.chat-private .messages')[0]
		if (element && element.scrollTop >= element.scrollHeight - element.offsetHeight) {
			this.holdingNOSCROLL = false
		}
	},
	group_new: function () {
		emit({
			id: 'group new',
		})
		$('.chat-private .chat-input').focus()
	},
	group_click: function (e) {
		if ($(e.target).attr('data-group-leave')) {
			if (confirm('Are you sure you want to leave the group?')) {
				var id = $(e.target).attr('data-group-leave')
				emit({
					id: 'group leave',
					g: id,
				})
				$('.chat-private .chat-input').focus()
			} else {
				this.setState({
					focused: $(e.target).attr('data-group-leave'),
				})

				$('.chat-private .chat-input').focus()
			}
		} else if ($(e.target).attr('data-username')) {
		} else {
			this.setState({
				focused: $(e.currentTarget).attr('data-group-id'),
			})
			this.setState({
				results: [],
			})
			$('.chat-input-search').val('')
			$('.chat-private .chat-input').focus()

			setTimeout(this.checkRead, 300)
		}
	},
	onMouseOver: function (e) {
		this.opened = true
		setTimeout(
			function () {
				if (this.opened) this.checkRead()
			}.bind(this),
			400,
		)
	},
	onMouseOut: function (e) {
		this.opened = false
	},
	has_emoji_cache: {},
	has_emoji: function (username) {
		if (this.has_emoji_cache[username] === undefined) {
			u.emoji_regexp.lastIndex = 0
			if (/^[0-9a-z\. _-]+$/i.test(username)) {
				this.has_emoji_cache[username] = false
			} else {
				this.has_emoji_cache[username] = u.emoji_regexp.test(username)
			}
		}
		return this.has_emoji_cache[username]
	},

	render: function () {
		var focused_group
		for (var id in this.state.groups) {
			if (this.state.groups[id].id == this.state.focused) {
				focused_group = this.state.groups[id]
				break
			}
		}
		var last_user = ''

		var o = storage.get()
		if (!o.unread) {
			o.unread = {}
			storage.update(o)
		}

		var isTyping = this.state.isTyping[this.state.focused]
			? Object.keys(this.state.isTyping[this.state.focused])
			: []
		var isSinging = this.state.isSinging[this.state.focused]
			? Object.keys(this.state.isSinging[this.state.focused])
			: []

		return (
			<div
				className={'chat-private ' + (this.state.textboxFocused ? ' focused ' : '')}
				onMouseOver={this.onMouseOver}
				onMouseOut={this.onMouseOut}
			>
				{this.state.groups.length < 8 || window.user.mod ? (
					<div className="r       pointer no-select" onClick={this.group_new}>
						<div className="text  "> Create New Private Chat... </div>
					</div>
				) : null}
				<br />
				<div className="groups">
					{this.state.groups.map(
						function (item, idx) {
							var group_users = []
							item.u.forEach(function (u) {
								group_users.push(u.u)
							})
							group_users.sort()
							return (
								<div
									key={idx}
									className={
										'group no-select pointer ' +
										(item.id != this.state.focused &&
										item.m.length &&
										o.unread[item.id] != item.m[item.m.length - 1].id
											? ' unread '
											: '') +
										(item.id == this.state.focused ? ' focused ' : '')
									}
									data-group-id={item.id}
									data-group-users={group_users.join(',')}
									onClick={this.group_click}
								>
									{item.u.map(
										function (u, idx) {
											ChatPrivateImages[u.u] = u.i
											if (!is_video(u.i))
												return (
													<img
														key={idx}
														src={profile_picture(ChatPrivateImages[u.u])}
														title={u.u}
														className="user"
													/>
												)
											else
												return (
													<img
														key={idx}
														src={profile_picture(ChatPrivateImages[u.u]).replace(
															/\.[^.]+$/,
															'.png',
														)}
														title={u.u}
														className="user"
													/>
												)
										}.bind(this),
									)}

									<svg
										className="  "
										title="Leave Group"
										data-group-leave={item.id}
										role="img"
										xmlns="http://www.w3.org/2000/svg"
										viewBox="0 0 512 512"
									>
										<path
											data-group-leave={item.id}
											fill="currentColor"
											d="M497 273L329 441c-15 15-41 4.5-41-17v-96H152c-13.3 0-24-10.7-24-24v-96c0-13.3 10.7-24 24-24h136V88c0-21.4 25.9-32 41-17l168 168c9.3 9.4 9.3 24.6 0 34zM192 436v-40c0-6.6-5.4-12-12-12H96c-17.7 0-32-14.3-32-32V160c0-17.7 14.3-32 32-32h84c6.6 0 12-5.4 12-12V76c0-6.6-5.4-12-12-12H96c-53 0-96 43-96 96v192c0 53 43 96 96 96h84c6.6 0 12-5.4 12-12z"
										/>
									</svg>
								</div>
							)
						}.bind(this),
					)}
				</div>

				<div className="content" onClick={this.checkRead}>
					{this.state.focused && focused_group ? (
						<div className="messages" onWheel={this.disableScroll}>
							<div className="text">
								<small>
									Note: Invited people can read past messages. To add a user type "/add username",
									to remove a user type "/remove username", to list users type "/list"
								</small>
								<hr />
							</div>
							{
								/*this.opened
								? */ focused_group.m.map(
									function (m, idx) {
										if (!m.m2) {
											if (m.s) m.m2 = u.escape(m.m)
											else m.m2 = u.linky(m.m).replace('window.updateScroll();', '')
										}

										var style = {
											color: u.readable(m.c),
										}
										if (
											m.u != 'MOBC' &&
											m.u != 'game' &&
											m.mu != '' &&
											m.mu != undefined &&
											!this.has_emoji(m.u)
										) {
											style.background =
												'linear-gradient(90deg, ' + u.readable(m.c) + ', ' + m.mu + ')'
										}
										return (
											<div className="text" title={u.time(m.id)} key={idx}>
												<span
													data-break-it="true"
													title={m.u}
													data-username={m.u}
													onClick={openProfile}
													className="pointer user"
													data-underline={
														m.u != 'MOBC' &&
														m.u != 'game' &&
														m.mu != '' &&
														m.mu != undefined &&
														!this.has_emoji(m.u)
													}
													style={style}
												>
													<b>{m.u}</b>:
												</span>{' '}
												<span
													dangerouslySetInnerHTML={{
														__html: m.m2,
													}}
												/>
											</div>
										)
									}.bind(this),
								)
								/*: null*/
							}
						</div>
					) : null}
					<div className="typing-indicator">
						{isTyping.length == 1
							? is_typing_text(isTyping[0])
							: isTyping.length == 2
							? isTyping.join(' and ') + ' are typing… '
							: isTyping.length > 2
							? isTyping.length + ' people are typing… '
							: ''}
						{isSinging.length == 1
							? is_singing_text(isSinging[0])
							: isSinging.length == 2
							? isSinging.join(' and ') + ' are recording…'
							: isSinging.length > 2
							? isSinging.length + ' people are recording…'
							: ''}
					</div>
					{this.state.focused ? (
						<div className="buttons relative">
							PRIVATE CHAT GROUP
							<Box row vertical className="chat-input-container">
								<Box
									grow
									row
									element="textarea"
									type="text"
									className="chat-input input-autosize"
									placeholder="Click To Private Chat"
									onKeyDown={this.textboxKeyDown}
									onFocus={this.textboxFocus}
									onBlur={this.textboxBlur}
									maxLength="1500"
									spellCheck="true"
									onChange={this.onChange}
									autoFocus={true}
								/>

								<RecordMedia
									type="audio"
									onStart={this.mediaStart}
									onStop={this.mediaStop}
									bind={this}
								/>

								<RecordMedia
									type="video"
									onStart={this.mediaStart}
									onStop={this.mediaStop}
									bind={this}
								/>

								<UploadButton onUpload={this.onUpload} />
							</Box>
						</div>
					) : null}
				</div>
			</div>
		)
	},

	onChange: function (e) {
		this.indicate(e)
		this.autosize()
	},
	autosize: function () {
		if (!isMobile) {
			u.autosize($('.chat-private .chat-input')[0], 169)
		}
	},

	mediaStart: function () {
		this.indicateMedia()
	},

	mediaStop: function (doUpload) {
		this.unindicateMedia()
		var group = this.state.focused
		doUpload(function (link) {
			emit({
				id: 'pc',
				g: group,
				m: link,
			})
		})
	},
	onUpload: function (doUpload) {
		var group = this.state.focused
		if (group) {
			doUpload(function (link) {
				emit({
					id: 'pc',
					g: group,
					m: link,
				})
			})
		}
	},
	textboxFocus: function () {
		$('.chat-private-container').addClass('focused')
		body.attr('data-chat-focused', true)
		this.focused = true
		this.checkRead()
		//this.scroll()
	},
	checkRead: function () {
		if (this.state.focused) {
			var o = storage.get()
			if (!o.unread) o.unread = {}
			for (var id in this.state.groups) {
				if (this.state.focused == this.state.groups[id].id) {
					var group = this.state.groups[id]
					break
				}
			}
			if (group) {
				if (group.m.length && o.unread[this.state.focused] != group.m[group.m.length - 1].id) {
					o.unread[this.state.focused] = group.m[group.m.length - 1].id
					storage.update(o)
					this.setState({
						nada: !this.state.nada,
					})
				}
			}
		}
	},
	textboxBlur: function () {
		this.focused = false
		body.attr('data-chat-focused', false)
	},

	textboxKeyDown: function (e) {
		if (e.keyCode === 13 && !e.shiftKey) {
			e.preventDefault()
			var v = e.target.value.replace(/data:[^ ]+/g, '')
			if (v && v != '' && v != '/' && v != '*') {
				if (v.length > 6 && /^[0-9*\-+/()\. ]+$/.test(v) && !/^[0-9 ]+$/.test(v)) {
					try {
						var r = eval(v)
						if (r != null && r != undefined && !isNaN(r) && isFinite(r)) {
							v = v + '=' + r
						}
					} catch (e) {}
				}
				emit({
					id: 'pc',
					g: this.state.focused,
					m: v.substr(0, window.user.mod ? 30000 : 1500),
				})
				this.checkRead()
				this.unindicate()
			}
			e.target.value = ''
			this.autosize()
		} else if (e.keyCode == 9) {
			u.focusGame(true)
			e.preventDefault()
			e.stopPropagation()
		}
	},

	scroll: function () {
		if (!this.holdingNOSCROLL) requestAnimationFrame(this._scroll)
	},
	_scroll: function () {
		if ($('.chat-private .messages')[0]) $('.chat-private .messages')[0].scrollTop = 1000000
	},
	componentDidMount: function () {
		$(window).resize(this.scroll)
	},

	componentDidUpdate: function () {
		this.scroll()
		setTimeout(this.scroll, 50)
		setTimeout(this.scroll, 200)
		setTimeout(this.scroll, 400)
	},

	indicate: function (e) {
		if (e.target.value.trim() == '') {
			this.unindicate()
		} else {
			if (!this.indicated) {
				this.indicated = true
				emit({
					id: 'ti',
					v: true,
					g: this.state.focused,
				})
			}

			clearTimeout(this.indicateTimeout)
			this.indicateTimeout = setTimeout(this.unindicate, 10000)
		}
	},

	unindicate: function () {
		clearTimeout(this.indicateTimeout)
		this.indicated = false
		emit({
			id: 'ti',
			v: false,
			g: this.state.focused,
		})
	},

	indicateMedia: function (e) {
		if (!this.indicatedMedia) {
			this.indicatedMedia = true
			emit({
				id: 'si',
				v: true,
				g: this.state.focused,
			})
		}
	},

	unindicateMedia: function () {
		this.indicatedMedia = false
		emit({
			id: 'si',
			v: false,
			g: this.state.focused,
		})
	},
})
