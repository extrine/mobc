var FriendList = React.createClass({
	getInitialState: function () {
		var o = storage.get(),
			showOffline = !(o.showOffline === false)

		ios.on(
			'disconnect',
			function (reason, a, b) {
				this.setState({
					online: {},
					data: {},
				})
			}.bind(this),
		)

		window.FriendListUpdate = this
		return {
			online: {},
			showOffline: showOffline,
			data: {},
		}
	},
	componentDidMount: function () {
		ios.on('f', data => {
			this.setState({ online: data })
		})
	},
	setStatus: function () {
		var status = prompt('New status?', window.user.doing)
		if (status != null)
			emit({
				id: 'friend status',
				s: status.substring(0, 30),
			})
	},
	render: function () {
		var friends = {}
		for (var friend in this.state.data)
			friends[friend] = {
				online: Object.keys(this.state.online).includes(friend) ? true : false,
			}

		var sortedFriends = Object.keys(friends).sort((a, b) => {
			return a.toUpperCase() === b.toUpperCase() ? 0 : a.toUpperCase() < b.toUpperCase() ? -1 : 1
		})

		if (this.state.showOffline === false) {
			sortedFriends = sortedFriends.filter(e => {
				return friends[e].online
			})
		} else {
			sortedFriends = sortedFriends.sort((a, b) => {
				return friends[a].online === friends[b].online ? 0 : friends[a].online ? -1 : 1
			})
		}

		return (
			<div className="friend-list-container">
				<div className="friend-list-toolbar r">
					<span className="button yellow pointer" onClick={this.setStatus}>
						Set status
					</span>
					<span
						className={this.state.showOffline ? 'button red pointer' : 'button green pointer'}
						onClick={this.toggleOffline}
					>
						{this.state.showOffline ? 'hide' : 'show'} offline
					</span>
				</div>
				<div className="clear" />
				{window.user.doing && <div className="idoing">{window.user.doing}</div>}
				{!sortedFriends.length ? (
					<div>No friends online.</div>
				) : (
					sortedFriends.map((friend, i) => {
						var status = {
							color:
								window.user && window.user.block && window.user.block[friend]
									? 'gray'
									: friends[friend].online
									? 'lime'
									: 'red',
						}
						var nameStyle = {
							color: this.state.online[friend]
								? u.readable(this.state.online[friend].c) || 'white'
								: 'gray',
							fontWeight: this.state.online[friend] ? 'bolder' : 'normal',
							whiteSpace: 'nowrap',
						}
						var doingStyle = {
							color: this.state.online[friend]
								? u.readable(this.state.online[friend].sc) || 'white'
								: 'gray',
						}
						return (
							<Box className="friend-container" key={'friend' + i} col>
								<Box className="friend" row top>
									<svg
										role="img"
										xmlns="http://www.w3.org/2000/svg"
										viewBox="0 0 576 512"
										data-username={friend}
										onClick={this.newPM}
										className="pointer pm"
									>
										<path
											fill="currentColor"
											d="M416 192c0-88.4-93.1-160-208-160S0 103.6 0 192c0 34.3 14.1 65.9 38 92-13.4 30.2-35.5 54.2-35.8 54.5-2.2 2.3-2.8 5.7-1.5 8.7S4.8 352 8 352c36.6 0 66.9-12.3 88.7-25 32.2 15.7 70.3 25 111.3 25 114.9 0 208-71.6 208-160zm122 220c23.9-26 38-57.7 38-92 0-66.9-53.5-124.2-129.3-148.1.9 6.6 1.3 13.3 1.3 20.1 0 105.9-107.7 192-240 192-10.8 0-21.3-.8-31.7-1.9C207.8 439.6 281.8 480 368 480c41 0 79.1-9.2 111.3-25 21.8 12.7 52.1 25 88.7 25 3.2 0 6.1-1.9 7.3-4.8 1.3-2.9.7-6.3-1.5-8.7-.3-.3-22.4-24.2-35.8-54.5z"
										/>
									</svg>{' '}
									<Box style={nameStyle} data-id={'f' + i} inline row vertical>
										<Box
											inline
											onClick={openProfile}
											data-username={friend}
											className="pointer"
											vertical-waterfall
										>
											<Box style={status} inline margin-right="5px">
												{this.state.online[friend] && this.state.online[friend].m ? (
													<svg
														aria-hidden="true"
														data-prefix="far"
														data-icon="mobile"
														role="img"
														xmlns="http://www.w3.org/2000/svg"
														viewBox="0 0 320 512"
														style={status}
														onClick={openProfile}
														data-username={friend}
														className="pointer"
													>
														<path
															fill="currentColor"
															d="M192 416c0 17.7-14.3 32-32 32s-32-14.3-32-32 14.3-32 32-32 32 14.3 32 32zM320 48v416c0 26.5-21.5 48-48 48H48c-26.5 0-48-21.5-48-48V48C0 21.5 21.5 0 48 0h224c26.5 0 48 21.5 48 48zm-48 410V54c0-3.3-2.7-6-6-6H54c-3.3 0-6 2.7-6 6v404c0 3.3 2.7 6 6 6h212c3.3 0 6-2.7 6-6z"
														/>
													</svg>
												) : (
													'●'
												)}
											</Box>{' '}
											{friend}{' '}
											<Box className="friend-list-rooms" inline vertical>
												{this.state.online[friend] &&
													this.state.online[friend].r.map((room, i) => {
														var game = room[0]
														var icon

														if (game === 'bubblesni' || game === 'bubbles') {
															icon = 'img/icon/dinglepopni.png'
														} else if (game === 'blocklesmulti') {
															icon = 'img/icon/blocklesm.png'
														} else {
															icon = 'img/icon/' + game + '.png'
														}

														return (
															<Box
																key={'room' + i}
																title={`join ${friend} in ${game}`}
																data-id={room[1]}
																onClick={this.join}
																className="pointer"
																inline
																vertical
															>
																<img alt="🖼" src={icon} alt={'join ' + game} />
															</Box>
														)
													})}
											</Box>
										</Box>

										{this.state.online[friend] && this.state.online[friend].s && (
											<Box
												className="doing pointer"
												style={doingStyle}
												row
												onClick={openProfile}
												data-username={friend}
												vertical
												wrap
												dangerouslySetInnerHTML={{
													__html: u.linkyNoLink(this.state.online[friend].s),
												}}
											/>
										)}
									</Box>
								</Box>
							</Box>
						)
					})
				)}
			</div>
		)
	},
	toggleOffline: function () {
		var o = storage.get()
		o.showOffline = !this.state.showOffline
		storage.update(o)
		this.setState({ showOffline: !this.state.showOffline })
	},
	join: function (e) {
		if (!window.room) {
			location.hash = 'm/' + $(e.currentTarget).attr('data-id')
		} else {
			window.open('#m/' + $(e.currentTarget).attr('data-id'), '_blank')
		}
	},
	newPM: function (e) {
		var user = $(e.currentTarget).attr('data-username')

		document
			.querySelector(
				'div.sidebar-container > div > div.tab-area > div.tab-area-tabs > span[data-id="private"]',
			)
			.click()

		var users = [user, window.user.username]
		users.sort()
		var selector = 'div.sidebar-container .group[data-group-users="' + users.join() + '"]'

		if (document.querySelector(selector)) {
			document.querySelector(selector).click()
		} else {
			emit(
				{
					id: 'group new',
				},
				function (data) {
					emit(
						{
							id: 'group invite',
							u: user,
							g: data.g,
						},
						function () {
							document
								.querySelector(
									'div.sidebar-container > div > div.tab-area > div.tab-area-content > span:nth-child(2) > div > div > div > div:nth-last-child(2)',
								)
								.click()
						},
					)
				},
			)
		}
	},
})
