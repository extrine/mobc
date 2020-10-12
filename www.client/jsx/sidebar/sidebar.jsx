var Sidebar = React.createClass({
	getInitialState: function() {
		ios.on('a', data => {
			switch (data.id) {
				case 'room': {
					this.setState({ inRoom: data.room !== false ? true : false })
					break
				}
				case 'rooms': {
					this.setState({
						rooms: window.rooms,
					})
					break
				}
			}
		})
		return {
			inRoom: false,
			rooms: [],
			o: mobileOrientation,
		}
	},
	componentDidMount: function() {
		window.mobileOrientationCallbacks.push(data => {
			this.setState({ o: data })
		})
	},
	render: function() {
		return (
			<div className="sidebar">
				<div className="user-container">
					<User />
				</div>

				{isMobile ? null : <hr />}

				<div className="messages-container">
					<Messages />
				</div>

				<div className="room-container">
					<Room />
				</div>

				<div className="player-container">
					<Player />
				</div>

				<SidebarNotifications />

				<TabArea id="sidebar" className="no-guest">
					<Tab id="room" title={this.state.inRoom ? 'ROOM' : 'LOBBY'}>
						<div className="chat-container">
							<Chat />
						</div>
					</Tab>

					<Tab
						id="lobby"
						title={isMobile ? 'ROOMS' : 'LOBBY'}
						style={{
							display:
								this.state.inRoom || (isMobile && this.state.o == 'portrait') ? 'block' : 'none',
						}}
					>
						<div className="rooms-container">
							<Rooms items={this.state.rooms} />
						</div>
					</Tab>

					<Tab id="private" title="PRIVATE">
						<div className="chat-private-container">
							<ChatPrivate />
						</div>
					</Tab>

					<Tab id="friends" title="FRIENDS">
						<TabArea id="friends" inner="true">
							<Tab id="online" title="ONLINE">
								<div className="friend-list-container">
									<FriendList />
								</div>
							</Tab>
							<Tab id="requests" title="REQUESTS">
								<div className="friend-requests-container">
									<FriendRequests data={window.user.followers} />
								</div>
							</Tab>
						</TabArea>
					</Tab>
				</TabArea>
			</div>
		)
	},
})

var SidebarNotifications = React.createClass({
	render: function() {
		return (
			<div>
				{has_flash || isMobile ? null : (
					<div className="wtf   center " style={{ backgroundColor: 'red' }}>
						<small>
							<a href="#p/Issues/289" className="white">
								<b>Fix Flash Not Working</b>
							</a>
						</small>
					</div>
				)}
				<div className="no-guest center donate guest-hidden hidden-when-chat-has-focus">
					<a className="white no-underline" href="#p/Contribute">
						<small style={{ fontSize: '1rem', lineHeight: '1' }}>
							<b>
								<span className="underline">Become</span>{' '}
								<img alt="🖼" className="star" src="https://omgmobc.com/img/badge/star-big.png" />
							</b>
						</small>
					</a>
				</div>

				{/*	{
					<div className="yes-wtf no-guest no-mobile">
						<center>
							<small>
								<b>
									<a href="#p/Tournaments" className="white">
										Dingle Tournament
									</a>
								</b>
							</small>
						</center>
					</div>
				}

				{
					<div className="yes-wtf no-guest no-mobile">
						<center>
							<small>
								<b>
									<a href="#p/Tournament9BallBrackets" className="white">
										9 Ball Brackets
									</a>{' '}
									Ready! Let's Play!
								</b>
							</small>
						</center>
					</div>
				}*/}
				{/*	{
					<div className="">
						<center>
							<small>
								<span className="corange">✿</span>
								◦.¸.◦
								<span className="cyellow">✿</span> Rest in Peace †{' '}
								<span className="corange">✿</span>
								◦.¸.◦
								<span className="cyellow">✿</span> Danny Mcalpin{' - '}
								<a href="#u/Jean" className="white">
									Jean's
								</a>{' '}
								husband.
							</small>
						</center>
					</div>
				}*/}
			</div>
		)
	},
})

$(function() {
	ReactDOM.render(<Sidebar />, document.querySelector('.sidebar-container'))
})
