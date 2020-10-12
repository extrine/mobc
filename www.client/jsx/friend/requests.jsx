var FriendRequests = React.createClass({
	getInitialState: function () {
		window.FriendRequestsUpdate = this
		return {
			data: {},
		}
	},
	render: function () {
		var requests = this.state.data ? Object.keys(this.state.data) : []

		return (
			<div className="friend-requests">
				{requests &&
					requests.map((user, i) => {
						return (
							<span className="friend-request" key={'fr' + i}>
								<span className="buttons">
									<span className="button green" onClick={this.confirmFriend} data-user={user}>
										✓
									</span>
									<span className="button red" onClick={this.denyFriend} data-user={user}>
										x
									</span>
								</span>
								<span className="user" data-username={user} onClick={openProfile}>
									{user}
								</span>
							</span>
						)
					})}
			</div>
		)
	},
	confirmFriend: function (e) {
		var user = e.currentTarget.getAttribute('data-user')
		emit({
			id: 'friend',
			f: 'confirm',
			v: user,
		})
	},
	denyFriend: function (e) {
		var user = e.currentTarget.getAttribute('data-user')
		emit({
			id: 'friend',
			f: 'deny',
			v: user,
		})
	},
})
