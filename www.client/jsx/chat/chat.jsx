var Chat = React.createClass({
	mixins: [React.addons.PureRenderMixin],

	getInitialState: function() {
		this.mobc_messages = []
		this.stylesheet = $('style[id="users"]')
		this.stylesheetCounter = 0
		document.addEventListener(
			'keydown',
			function(e) {
				if (e.key === 'F1' && !e.repeat) {
					if ($('.chat .chat-input').is(':visible')) {
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
			function(e) {
				if (e.key === 'F1') {
					if ($('.chat .chat-input').is(':visible')) {
						e.preventDefault()
						e.stopPropagation()
						this.recordAudioStop(e)
						this.recordVideoStop(e)
					}
				}
			}.bind(this),
			false,
		)

		this.id = 0
		this.focused = false
		this.unread = 0

		this.holdingNOSCROLL = false

		ios.on(
			'a',
			function(data) {
				if (data.id == 'c') this.incoming(data)
			}.bind(this),
		)
		ios.on(
			'e',
			function(data) {
				setTimeout(function() {
					if (!window.room) {
						for (var id in data) {
							data[id].l = '1'
							this.incoming(data[id])
						}
					}
				}, 1000)
			}.bind(this),
		)

		ios.on(
			'b',
			function(data) {
				this.incoming({
					id: 'c',
					un: 'MOBC',
					ui: 1,
					m: data,
				})
			}.bind(this),
		)

		ios.on(
			'c',
			function(data) {
				this.incoming({
					id: 'c',
					un: 'game',
					ui: 2,
					m: data,
				})
			}.bind(this),
		)

		ios.on('ti', data => {
			if (!data.g && data.u != window.user.username) {
				let isTyping = { ...this.state.isTyping }
				switch (data.v) {
					case true:
						isTyping[data.u] = true
						break
					case false:
						delete isTyping[data.u]
						break
				}
				this.setState({ isTyping: isTyping })
			} else if (!data.g && data.u == window.user.username && data.v == 'clear') {
				this.setState({ isTyping: {} })
			}
		})

		ios.on('si', data => {
			if (!data.g && data.u != window.user.username) {
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
			} else if (!data.g && data.u == window.user.username && data.v == 'clear') {
				this.setState({ isSinging: {} })
			}
		})

		u.on_document_visibility_change.push(
			function(visible) {
				if (visible) {
					this.unread = 0
					u.unread(this.unread)
				}
				this.holdingNOSCROLL = false
			}.bind(this),
		)

		document.addEventListener(
			'keydown',
			function(e) {
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
			function(e) {
				this.holdingNOSCROLL = false
			}.bind(this),
			{
				passive: true,
			},
		)

		window.incoming = this.incoming
		window.incoming_delayed = function(data) {
			setTimeout(function() {
				this.incoming(data)
			}, 0)
		}
		window.updateScroll = this.scroll

		document.addEventListener(
			'mousedown',
			function(e) {
				this.holdingNOSCROLL = true
			}.bind(this),
			{ passive: true },
		)
		document.addEventListener(
			'mouseup',
			function(e) {
				this.holdingNOSCROLL = false
			}.bind(this),
			{ passive: true },
		)
		return {
			items: [],
			goal: 0,
			isTyping: {},
			isSinging: {},
		}
	},
	incoming: function(data) {
		data.om = data.m
		if (
			window.room &&
			window.room.game == 'blocklesmulti' &&
			data.un == 'game' &&
			(data.m == 'AH SWEET REVENGE. Use these 3 items for your revenge.' ||
				data.m ==
					'This is an item game. Collect items by breaking blocks. You can use the items on yourself or others, using the number keys: 1,2,3,4 (the number by the window). Blue items are generally good. Orange ones are generally bad. Game on!' ||
				data.m.indexOf('just sent you') != -1)
		) {
			return
		}
		if (window.user.username.indexOf('Lame Guest') === 0) {
			return
		}

		if (
			!u.document_is_visible &&
			data.un != 'game' &&
			data.un != window.user.username &&
			(window.room || data.un != 'MOBC')
		) {
			this.unread++
			data.unread = true
		}

		data.ml = data.m.toLowerCase()
		// we can only search for the complete username in an array if the username does not have a white space
		if (window.user.username.indexOf(' ') === -1) {
			data.ml = data.ml.split(' ')
		}

		/// if (u.document_is_visible) this.unread = 0

		u.unread(this.unread)

		// notification
		if (data.un != 'game' && data.un != 'MOBC' && data.un != window.user.username) {
			if (
				data.ml.indexOf('@' + window.user.username_lower) !== -1 ||
				data.ml.indexOf(window.user.username_lower + '!') !== -1 ||
				(window.user.tags_modified &&
					window.user.tags_modified.some(function(item) {
						return (
							item && (data.ml.indexOf('@' + item) !== -1 || data.ml.indexOf(item + '!') !== -1)
						)
					}))
			) {
				u.soundAlways('mention2')

				if (!u.document_is_visible && window.user.nty && window.user.ntyc) {
					if (window.room) {
						u.notification({
							title: 'Chat Mention From ' + data.un,
							body: data.m,
							image: data.i,
						})
					}
				}
			} else if (
				data.ml.indexOf(window.user.username_lower) !== -1 ||
				(window.user.tags_modified &&
					window.user.tags_modified.some(function(item) {
						return item && data.ml.indexOf(item) !== -1
					}))
			) {
				u.soundWhenTabUnfocused('mention2')
			}
		}

		if (data.un != 'game' && data.un != 'MOBC' && u.isRTL(data.m)) data.d = 'rtl'
		else data.d = 'ltr'

		data.t = u.time(data.t)
		data.id = this.id++

		if (data.un != 'game' && data.un != 'MOBC') {
			data.m = u.linky(data.m).replace('window.updateScrollPrivate()', '')
		} else {
			data.m = u.escape(data.m)
		}

		if (data.un && window.user && window.user.block && window.user.block[data.un]) {
			data.m = '[ Blocked ]'
		}
		if (floating_emoji_user_messages[data.un]) floating_emoji_user_messages[data.un](data.m)

		data.classes = 'message guest-hidden'
		if (data.un.indexOf('Lame Guest') === 0) data.classes += ' lame'
		else if (data.un == 'MOBC') {
			data.classes += ' mobc'
		} else if (data.un == 'game') data.classes += ' game'
		if (window.room && window.room.users && window.room.users[0].id == data.ui)
			data.classes += ' host'
		else if (
			window.room &&
			window.room.users &&
			window.room.users[1] &&
			window.room.users[1].id == data.ui
		)
			data.classes += ' player'
		else if (window.room && window.room.users) data.classes += ' spectator'

		var items = this.state.items.concat(data)

		if (data.un == 'game' || data.un == 'MOBC') {
			this.mobc_messages.push(data)
			if (this.mobc_messages.length > 40) {
				u.removeValueFromArray(items, this.mobc_messages.shift())
			}
		}

		if (data.om == '/version') {
			emit({
				id: 'c',
				m: version_time + ':' + new Date(Date.now()).toUTCString(),
				r: window.room && window.room.id,
			})
			return
		} else if (data.om == '/hands') {
			emit({
				id: 'c',
				m: '.hands.',
				r: window.room && window.room.id,
			})
			return
		}

		var limit =
			window.user && window.user.chathistory && window.user.chathistory >= 100
				? window.user.chathistory
				: 100
		if (u.isNoHD() && items.length > 30) items.shift()
		else if (items.length > limit) items.shift()
		this.setState({
			items: items,
		})
	},
	has_emoji_cache: {},
	has_emoji: function(username) {
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
	disableScroll: function(e) {
		this.holdingNOSCROLL = true
		/*
		scrollTop, at maximum scroll, will be equal to the scrollHeight minus offsetHeight of the element.
		This is because the offsetHeight is included in the scrollHeight.
*/
		if (this.elementD.scrollTop >= this.elementD.scrollHeight - this.elementD.offsetHeight) {
			this.holdingNOSCROLL = false
		}
	},
	render: function() {
		var isTyping = Object.keys(this.state.isTyping)
		var isSinging = Object.keys(this.state.isSinging)
		var markedUnread = false
		var HR = css('height:1px;background:red;margin:8px;')
		return (
			<div className="chat">
				<div className="app"></div>
				<div className="messages" onWheel={this.disableScroll}>
					{this.state.items.map(
						function(item) {
							var add = item.un != 'MOBC' ? ' border-hover pointer' : ''
							var style = {
								color: u.readable(item.mc),
							}
							if (
								item.un != 'MOBC' &&
								item.un != 'game' &&
								item.mu != '' &&
								!this.has_emoji(item.un)
							) {
								style.background =
									'linear-gradient(90deg, ' + u.readable(item.mc) + ', ' + item.mu + ')'
							}
							return (
								<div
									key={item.id}
									dir={item.d}
									className={item.classes}
									data-admin={u.is_mod(item.un)}
									data-lobby={item.l}
								>
									{item.unread && !markedUnread
										? (markedUnread = true && (
												<Box row grow>
													<HR grow /> Unread <HR grow />
												</Box>
										  ))
										: null}
									{item.un === 'SuGaR+SpIcE' ? (
										<span
											data-username={item.un}
											onClick={openProfile}
											className={'username ' + add}
										>
											<font color="#FF0000">S</font>
											<font color="#FF4000">u</font>
											<font color="#FE9A2E">G</font>
											<font color="#FFBF00">a</font>
											<font color="#FFFF00">R</font>
											<font color="#BFFF00"> & </font>
											<font color="#40FF00">S</font>
											<font color="#2EFE2E">p</font>
											<font color="#2EFE9A">I</font>
											<font color="#2EFEC8">c</font>
											<font color="#81DAF5">E</font>:
										</span>
									) : (
										<span
											data-username={item.un}
											data-underline={
												item.un != 'MOBC' &&
												item.un != 'game' &&
												item.mu != '' &&
												!this.has_emoji(item.un)
											}
											onClick={openProfile}
											style={style}
											className={'username ' + add}
										>
											{item.un != 'game' ? item.un + ':' : null}
										</span>
									)}{' '}
									<span
										dir={item.d}
										className={
											'text ' +
											this.className(
												(item.eh
													? 'class img[src^="https://omgmobc.com/img/icon/"] {filter: hue-rotate(' +
													  item.eh +
													  'deg);}'
													: '') +
													'class {color:' +
													(!window.user.nocolor || !window.room ? null : u.readable(item.sm)) +
													';}',
											)
										}
										title={item.t}
										dangerouslySetInnerHTML={{
											__html: item.m,
										}}
									/>
								</div>
							)
						}.bind(this),
					)}
				</div>

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

				<Box row vertical className="chat-input-container">
					<Box
						grow
						row
						element="textarea"
						type="text"
						className="chat-input input-autosize"
						placeholder="Click To Chat"
						onKeyDown={this.textboxKeyDown}
						onFocus={this.textboxFocus}
						onBlur={this.textboxBlur}
						maxLength={window.user.mod ? 30000 : 1500}
						spellCheck="true"
						onChange={this.onChange}
						autoFocus={true}
					/>

					<RecordMedia type="audio" onStart={this.mediaStart} onStop={this.mediaStop} bind={this} />

					<RecordMedia type="video" onStart={this.mediaStart} onStop={this.mediaStop} bind={this} />

					<UploadButton onUpload={this.onUpload} />
				</Box>
			</div>
		)
	},

	onChange: function(e) {
		this.indicate(e)

		this.autosize()
	},
	autosize: function() {
		if (!isMobile) {
			u.autosize($('.chat-input-container .chat-input')[0], 169)
		}
	},
	mediaStart: function() {
		this.indicateMedia()
	},
	mediaStop: function(doUpload) {
		this.unindicateMedia()
		var room = window.room && window.room.id
		doUpload(function(link) {
			if (room == (window.room && window.room.id)) {
				emit({
					id: 'c',
					m: link,
					r: room,
				})
			}
		})
	},
	onUpload: function(doUpload) {
		var room = window.room && window.room.id
		doUpload(function(link) {
			if (room == (window.room && window.room.id)) {
				emit({
					id: 'c',
					m: link,
					r: room,
				})
			}
		})
	},
	sendChat: function() {
		this.textboxKeyDown({
			keyCode: 13,
			target: $('.chat-input')[0],
			preventDefault: function() {},
		})
	},
	textboxFocus: function() {
		this.focused = true
		body.attr('data-chat-focused', true)
		this.markRead()
	},
	textboxBlur: function() {
		this.focused = false
		body.attr('data-chat-focused', false)
	},
	clearUnreadTimeout: false,
	markRead: function() {
		this.unread = 0
		for (var id in this.state.items) {
			this.state.items[id].sould_mark_read = true
		}
		setTimeout(
			function() {
				for (var id in this.state.items) {
					if (this.state.items[id].sould_mark_read) {
						this.state.items[id].unread = false
					}
				}
				this.setState({ items: [].concat(this.state.items) })
			}.bind(this),
			18000,
		)
	},

	textboxKeyDown: function(e) {
		if (e.keyCode === 13 && !e.shiftKey) {
			e.preventDefault()
			var v = e.target.value.replace(/data:[^ ]+/g, '')

			if (v && v != '' && v != '/') {
				if (v.length > 6 && /^[0-9*\-+/()\. ]+$/.test(v) && !/^[0-9 ()\.]+$/.test(v)) {
					try {
						var r = eval(v)
						if (r != null && r != undefined && !isNaN(r) && isFinite(r)) {
							v = v + '=' + r
						}
					} catch (e) {}
				}
				if (v && v == '/clear') {
					this.setState({
						items: [],
					})
					e.target.value = ''

					return
				}

				emit({
					id: 'c',
					m: v.substr(0, window.user.mod ? 30000 : 1500),
					r: window.room && window.room.id,
				})
				this.unindicate()
			}
			if (e.ctrlKey) {
				this.setState({
					items: [],
				})
			}
			e.target.value = ''
		} else if (e.keyCode == 9) {
			u.focusGame(true)
			e.preventDefault()
			e.stopPropagation()
		}
		this.autosize()
	},
	className: function(css) {
		if (!this.className[css]) {
			this.className[css] = 'cc' + this.stylesheetCounter++
			this.stylesheet.html(
				this.stylesheet.html() + css.replace(/class/g, '.' + this.className[css]),
			)
		}
		return this.className[css]
	},
	scroll: function() {
		if (!this.holdingNOSCROLL) requestAnimationFrame(this._scroll)
	},
	_scroll: function() {
		this.elementD.scrollTop = 1000000
	},
	componentDidMount: function() {
		this.elementJ = $('.chat .messages')
		this.elementD = this.elementJ[0]
		this.elementInputJ = $('.chat .chat-input')
		this.elementInputJ.focus()
		this.elementInputD = this.elementInputJ[0]
		$(window).resize(this.scroll)
		$(window).resize(this.calculateMediaRatio)
	},
	calculateMediaRatio: function() {
		var width = $('.sidebar-container').width()
		if (width > 0) {
			this.didCalculateMediaRatio = true
			var height = Math.floor(width / 2 + 18)
			$('style[id="media-ratio"]')
				.prop('type', 'text/css')
				.html(
					'.ratio {height:' + height + 'px;} .player .ratio {height:' + height + 'px !important;}',
				)
		}
	},
	componentDidUpdate: function() {
		if (!this.didCalculateMediaRatio) requestAnimationFrame(this.calculateMediaRatio)
		this.scroll()

		if (!this.room) {
			if (window.room && window.room.id) {
				this.room = window.room.id
			}
		} else {
			if (this.room != window.room.id) {
				this.room = window.room.id
				this.setState({ isTyping: {} })
				this.setState({ isSinging: {} })
			}
		}
	},

	indicate: function(e) {
		if (e.target.value.trim() == '') {
			this.unindicate()
		} else {
			if (!this.indicated) {
				this.indicated = true
				emit({
					id: 'ti',
					v: true,
					r: window.room && window.room.id,
				})
			}

			clearTimeout(this.indicateTimeout)
			this.indicateTimeout = setTimeout(this.unindicate, 10000)
		}
	},

	unindicate: function() {
		clearTimeout(this.indicateTimeout)
		this.indicated = false
		emit({
			id: 'ti',
			v: false,
			r: window.room && window.room.id,
		})
	},

	indicateMedia: function(e) {
		if (!this.indicatedMedia) {
			this.indicatedMedia = true
			emit({
				id: 'si',
				v: true,
				r: window.room && window.room.id,
			})
		}
	},

	unindicateMedia: function() {
		this.indicatedMedia = false
		emit({
			id: 'si',
			v: false,
			r: window.room && window.room.id,
		})
	},
})
