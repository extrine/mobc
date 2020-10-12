var TicketListToolbar = React.createClass({
	componentDidMount() {
		var o = storage.get()
		if (o.tickets && o.tickets.list) {
			for (var key in o.tickets.list) {
				this.refs[key].value = o.tickets.list[key]
			}
			if (this.refs.sort.value != 'recent') this.setSort(this.refs.sort.value)
			if (this.refs.search.value != '') this.setSearch(this.refs.search.value)
		}
	},
	sort: function (e) {
		if (e.currentTarget.value !== 'Sort by') {
			this.setSort(e.currentTarget.value)
			this.storage(e)
		}
	},
	setSort: function (str) {
		this.props.setSort(str)
	},
	search: function (e) {
		this.setSearch(e.currentTarget.value)
		this.storage(e)
	},
	setSearch: function (str) {
		this.props.setSearch(str)
	},
	toggleHidden: function () {
		this.props.toggleHidden()
	},
	clearTickets: function () {
		this.props.clearTickets()
	},
	storage: function (e) {
		var type = e.currentTarget.className,
			input = e.currentTarget.value,
			o = storage.get(),
			id = 'list'
		if (!o.tickets) o.tickets = {}
		if (!o.tickets[id]) o.tickets[id] = {}
		o.tickets[id][type] = input
		storage.update(o)
	},
	render: function () {
		const selected = {
			fontWeight: 'bold',
			color: 'white',
		}
		return (
			<div className="ticket-toolbar">
				<span className="tickets-update pointer" onClick={this.props.update}>
					<Icon type="refresh" />
				</span>
				<span
					className="pointer"
					onClick={() => this.props.ss({ status: 'open', view: 'ticket' })}
					style={this.props.status === 'open' ? selected : null}
				>
					{this.props.tickets &&
						this.props.tickets.filter(t => {
							if (!t) return false
							return t.status === 'open'
						}).length}{' '}
					Open
				</span>{' '}
				/{' '}
				<span
					className="pointer"
					onClick={() => this.props.ss({ status: 'closed', view: 'ticket' })}
					style={this.props.status === 'closed' ? selected : null}
				>
					{this.props.tickets &&
						this.props.tickets.filter(t => {
							if (!t) return false
							return t.status === 'closed' && !t.hidden
						}).length}{' '}
					Closed
				</span>
				{window.user.mod === true && (
					<span className="actions pointer small">
						<span onClick={this.toggleHidden}>
							{this.props.hiddenVisible ? 'hide' : 'show'} hidden
						</span>
						{/*{' | '}
						<span onClick={this.clearTickets}>clear all tickets</span>*/}
					</span>
				)}
				<label className="inline">
					<select className="sort" ref="sort" onChange={this.sort} defaultValue={this.props.sort}>
						<option>decending</option>
						<option>ascending</option>
						<option>recent</option>
						<option>type</option>
						<option>category</option>
						<option>like count</option>
						<option>my likes</option>
					</select>
				</label>
				<label className="inline">
					<input className="search" ref="search" placeholder="Search" onChange={this.search} />
				</label>
				<span className="button pointer" onClick={() => this.props.ss({ view: 'new' })}>
					New Ticket
				</span>
			</div>
		)
	},
})

var TicketList = React.createClass({
	getInitialState: function () {
		return {
			sort: 'recent',
			search: '',
		}
	},
	setSort: function (sort) {
		this.setState({ sort: sort })
	},
	setSearch: function (str) {
		this.setState({ search: str.toLowerCase() })
	},
	render: function () {
		var ts = [...this.props.tickets]
		switch (this.state.sort) {
			case 'ascending':
				break
			case 'decending':
				ts.reverse()
				break
			case 'recent':
				ts.sort((a, b) => {
					return b.m[b.m.length - 1].t - a.m[a.m.length - 1].t
				})
				break
			case 'type':
				ts.sort((a, b) => {
					return (a.type || 0) - (b.type || 0)
				})
				break
			case 'category':
				ts.sort((a, b) => {
					return (a.category || 0) - (b.category || 0)
				})
				break
			case 'like count':
				ts.sort((a, b) => {
					return (b.h ? Object.entries(b.h).length : 0) - (a.h ? Object.entries(a.h).length : 0)
				})
				break
			case 'my likes':
				ts.sort((a, b) => {
					return (
						(b.h ? Object.keys(b.h).some(user => user === window.user.username) : 0) -
						(a.h ? Object.keys(a.h).some(user => user === window.user.username) : 0)
					)
				})
				break
			default:
				break
		}
		if (this.state.search !== '')
			ts = ts.filter(t => {
				if (t) {
					var s = this.state.search
					return u.search(
						s,
						t.title +
							JSON.stringify(t.m) +
							(t.category != undefined ? ticketCategories[t.category] : '') +
							(t.type != undefined ? ticketTypes[t.type] : ''),
					)
				}
			})
		return (
			<div className="tickets">
				<TicketListToolbar
					update={this.props.update}
					ss={this.props.ss}
					tickets={this.props.tickets}
					sort={this.state.sort}
					setSort={this.setSort}
					setSearch={this.setSearch}
					status={this.props.status}
					toggleHidden={this.props.toggleHidden}
					clearTickets={this.props.clearTickets}
					hiddenVisible={this.props.hiddenVisible}
				/>
				{ts.map((ticket, i) => {
					return ticket &&
						ticket.status === this.props.status &&
						(ticket.hidden !== true || this.props.hiddenVisible) ? (
						<ShortTicket
							data={ticket}
							ss={this.props.ss}
							key={'ticket' + i}
							toggleLike={this.props.toggleLike}
						/>
					) : null
				})}
			</div>
		)
	},
})
var ShortTicket = React.createClass({
	setView: function () {
		emit({
			id: 'ticket',
			tid: this.props.data.id,
			type: 'update_t',
		})
		this.props.ss({ view: this.props.data })
	},
	toggleLike: function (e) {
		e.stopPropagation()
		this.props.toggleLike(this.props.data.id)
	},
	render: function () {
		let style = {
				color: this.props.data.status === 'open' ? 'lime' : 'red',
			},
			lastId = this.props.data.m.length - 1
		let commentCount = Object.keys(
			this.props.data.m.filter(m => {
				return m.m ? true : false
			}),
		).length
		return (
			<div
				className="short-ticket pointer"
				title={
					`${this.props.data.title}\n` +
					this.props.data.m
						.filter(m => {
							return m.m ? true : false
						})
						.map(m => {
							return `${m.u}: ${m.m}\n`
						})
						.join('')
				}
				onClick={this.setView}
			>
				<div className="ticket-title">
					<span className="label category">{ticketCategories[this.props.data.category]}</span>
					<span className={`label ${ticketTypes[this.props.data.type]}`}>
						{ticketTypes[this.props.data.type]}
					</span>
					<span className="title">{u.capital(this.props.data.title)}</span>
				</div>
				<span className="info">
					<span style={style}>#</span>
					{this.props.data.id} opened {u.format_time(this.props.data.m[0].t)} by{' '}
					{this.props.data.m[0].u}
					{this.props.data.m.length > 1 && (
						<span>
							{' | '}last msg {u.format_time(this.props.data.m[lastId].t)} by{' '}
							{this.props.data.m[lastId].u}
						</span>
					)}
					<span className="sub-info">
						{commentCount > 0 && (
							<span className="msgs" title={`${commentCount} comments`}>
								{commentCount} <Icon type="comments" />
								{' | '}
							</span>
						)}
						<span
							className="likes"
							onClick={this.toggleLike}
							title={`${this.props.data.h ? Object.keys(this.props.data.h).length : '0'} likes`}
						>
							{this.props.data.h ? Object.keys(this.props.data.h).length : '0'}{' '}
							{this.props.data.h && this.props.data.h[window.user.username] === true ? (
								<Icon type="heart" />
							) : (
								<Icon type="hearthollow" />
							)}
						</span>
					</span>
				</span>
			</div>
		)
	},
})
