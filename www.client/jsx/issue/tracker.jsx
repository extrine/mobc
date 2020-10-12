var ticketTypes = {
		0: 'bug',
		1: 'feature',
	},
	ticketCategories = {
		0: 'bans',
		1: 'chat game',
		2: 'chat lobby',
		3: 'chat private',
		4: 'development',
		5: 'emails',
		6: 'emojis',
		7: 'flash',
		8: 'friends',
		9: 'game',
		10: 'homepage',
		11: 'keyboard',
		12: 'links',
		13: 'mobile',
		14: 'mods',
		15: 'other',
		16: 'privacy',
		17: 'profiles',
		18: 'ranking',
		19: 'room',
		20: 'rooms',
		21: 'search',
		22: 'settings',
		23: 'sidebar',
		24: 'sounds',
		25: 'star users',
		26: 'themes',
		27: 'tickets',
		28: 'waiting',
		29: 'youtube',
	}

var IssueTracker = React.createClass({
	getInitialState: function () {
		ios.on('tsup', data => {
			this.setState({ tickets: uncompress(data) })
			if (this.props.tid !== 'Issues') {
				if (this.props.tid === 'new') this.setState({ view: 'new' })
				else
					this.setState({
						view: this.state.tickets[this.props.tid] || 'ticket',
					})
			}
		})
		ios.on('tup', data => {
			let t = [...this.state.tickets]
			t[data.id] = data
			this.setState({
				tickets: t,
				view: this.state.view === 'ticket' ? 'ticket' : data,
			})
		})
		return {
			status: 'open',
			view: 'ticket',
			tickets: [],
			hiddenVisible: false,
		}
	},
	componentDidMount: function () {
		this.updateTickets()
	},
	componentWillUnmount: function () {
		ios.off('tsup')
		ios.off('tup')
	},
	componentDidUpdate(prevProps) {
		if (prevProps.tid !== this.props.tid) {
			if (this.props.tid === 'new') this.setState({ view: 'new' })
			else this.setState({ view: this.state.tickets[this.props.tid] || 'ticket' })
		}
	},
	updateTickets: function () {
		emit({
			id: 'ticket',
			type: 'update',
		})
	},
	openTicket: function (data) {
		let ticket = {
			status: 'open',
			title: data.t,
			type: data.ty,
			category: data.c,
			m: [
				{
					m: data.b,
				},
			],
		}
		this.ss({ view: 'ticket', status: 'open' })
		emit({
			id: 'ticket',
			type: 'open',
			t: ticket,
		})
	},
	reopenTicket: function (id) {
		CONFIRM(
			'Are you sure you want to reopen this ticket?',
			function () {
				let m = {
					a: 'reopened ticket',
				}

				emit({
					id: 'ticket',
					tid: id,
					type: 'reopen',
					m: m,
				})
			}.bind(this),
		)
	},
	closeTicket: function (id) {
		CONFIRM(
			'Are you sure you want to close this ticket?',
			function () {
				let m = {
					a: 'closed ticket',
				}
				//this.setState({ view: "ticket" });
				emit({
					id: 'ticket',
					tid: id,
					type: 'close',
					m: m,
				})
				location.href = '#p/Issues'
			}.bind(this),
		)
	},
	addComment: function (data) {
		let m = {
			m: data.b,
		}

		emit({
			id: 'ticket',
			tid: data.id,
			type: 'add_c',
			m: m,
		})
	},
	addCommentClose: function (data) {
		CONFIRM(
			'Are you sure you want to comment and close ticket?',
			function () {
				this.addComment({ id: data.id, b: data.b })
				let m = {
					a: 'closed ticket',
				}
				//this.setState({ view: "ticket" });
				emit({
					id: 'ticket',
					tid: data.id,
					type: 'close',
					m: m,
				})
				location.href = '#p/Issues'
			}.bind(this),
		)
	},
	setTitle: function (data) {
		CONFIRM(
			`Are you sure you want to rename this ticket to "${data.t}"?`,
			function () {
				let m = {
					a: 'changed title',
				}

				emit({
					id: 'ticket',
					tid: data.id,
					type: 'rename',
					m: m,
					t: data.t,
				})
			}.bind(this),
		)
	},
	hideTicket: function (id) {
		CONFIRM(
			'Are you sure you want to hide this ticket?',
			function () {
				let m = {
					a: 'closed and hid ticket',
				}
				emit({
					id: 'ticket',
					tid: id,
					type: 'hide',
					m: m,
				})
				location.href = '#p/Issues'
			}.bind(this),
		)
	},
	toggleHidden: function () {
		this.setState({ hiddenVisible: !this.state.hiddenVisible })
	},
	clearTickets: function () {
		/*CONFIRM(
			'Are you sure you want to delete all the tickets?',
			function() {
				emit({
					id: 'ticket',
					type: 'clear',
				})
			}.bind(this),
		)*/
	},
	toggleSub: function (id) {
		CONFIRM(
			'Are you sure you want to do this?',
			function () {
				emit({
					id: 'ticket',
					tid: id,
					type: 'toggle-sub',
				})
			}.bind(this),
		)
	},
	editComment: function (data) {
		emit({
			id: 'ticket',
			tid: data.tid,
			type: 'edit-comment',
			cid: data.cid,
			m: data.m,
		})
	},
	toggleLike: function (id) {
		emit({
			id: 'ticket',
			tid: id,
			type: 'toggle-like',
		})
	},
	markDone: function (id) {
		this.addCommentClose({ id: id, b: 'done' })
	},
	setType: function (data) {
		CONFIRM(
			'Are you sure you want to do this?',
			function () {
				let m = {
					a: 'changed ticket type',
				}
				emit({
					id: 'ticket',
					tid: data.id,
					type: 'set-type',
					ty: data.ty,
					m: m,
				})
			}.bind(this),
		)
	},
	setCategory: function (data) {
		CONFIRM(
			'Are you sure you want to do this?',
			function () {
				let m = {
					a: 'changed ticket category',
				}
				emit({
					id: 'ticket',
					tid: data.id,
					type: 'set-category',
					c: data.c,
					m: m,
				})
			}.bind(this),
		)
	},
	ss: function (data) {
		this.setState(data)
		if (!data.view) return
		if (data.view === 'ticket') location.hash = 'p/Issues/'
		else if (data.view === 'new') location.hash = 'p/Issues/new'
		else location.hash = 'p/Issues/' + encodeURIComponent(data.view.id)
	},
	render: function () {
		return (
			<div className="issue-tracker">
				{this.state.view === 'ticket' ? (
					<TicketList
						tickets={this.state.tickets}
						status={this.state.status}
						openTicket={this.openTicket}
						ss={this.ss}
						update={this.updateTickets}
						toggleHidden={this.toggleHidden}
						clearTickets={this.clearTickets}
						hiddenVisible={this.state.hiddenVisible}
						toggleLike={this.toggleLike}
					/>
				) : this.state.view === 'new' ? (
					<NewTicket ss={this.ss} openTicket={this.openTicket} />
				) : (
					<Ticket
						data={this.state.view}
						ss={this.ss}
						addComment={this.addComment}
						addCommentClose={this.addCommentClose}
						closeTicket={this.closeTicket}
						reopenTicket={this.reopenTicket}
						setTitle={this.setTitle}
						hideTicket={this.hideTicket}
						toggleSub={this.toggleSub}
						editComment={this.editComment}
						toggleLike={this.toggleLike}
						markDone={this.markDone}
						setType={this.setType}
						setCategory={this.setCategory}
					/>
				)}
			</div>
		)
	},
})
