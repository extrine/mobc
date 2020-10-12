var Ticket = React.createClass({
	componentDidMount() {
		var o = storage.get()
		if (o.tickets && o.tickets[this.props.data.id])
			for (var key in o.tickets[this.props.data.id]) {
				if (this.refs[key]) this.refs[key].value = o.tickets[this.props.data.id][key]
			}
	},
	comment: function (e) {
		let c = this.refs['add-comment'].value
		if (c.trim() !== '') {
			if (e.ctrlKey || e.metaKey) {
				this.props.addCommentClose({
					id: this.props.data.id,
					b: c.substring(0, 10000),
				})
			} else {
				this.props.addComment({
					id: this.props.data.id,
					b: c.substring(0, 10000),
				})
			}
			if (this.refs['add-comment']) this.refs['add-comment'].value = ''
			var o = storage.get()
			o.tickets[this.props.data.id]['add-comment'] = ''
			storage.update(o)
		}
	},
	setTitle: function (title) {
		if (title && title != '' && title != this.props.data.title) {
			this.props.setTitle({
				id: this.props.data.id,
				a: 'changed title',
				t: title,
			})
		}
	},
	back: function () {
		this.props.ss({ view: 'ticket' })
	},
	storage: function (e) {
		var type = e.currentTarget.className,
			input = e.currentTarget.value,
			o = storage.get(),
			id = this.props.data.id
		if (!o.tickets) o.tickets = {}
		if (!o.tickets[id]) o.tickets[id] = {}
		o.tickets[id][type] = input
		storage.update(o)
	},
	onUpload: function (doUpload) {
		doUpload(
			function (link) {
				this.refs['add-comment'].value = this.refs['add-comment'].value + ' ' + link + ' '
			}.bind(this),
		)
	},
	render: function () {
		return (
			<div className="ticket">
				<h1>
					<span className="arrow-left" onClick={this.back} title="Back"></span>
					<span className="ticket-title">
						{window.user.mod ? (
							<Editable
								className="title"
								html={this.props.data.title}
								title="Click to edit title"
								onChange={this.setTitle}
							/>
						) : (
							this.props.data.title
						)}
					</span>
					<span className="ticket-id">#{this.props.data.id}</span>
				</h1>
				<div className="ticket-info">
					<span className={'status ' + this.props.data.status}>{this.props.data.status}</span>
					<span className="small">
						<span className="pointer" data-username={this.props.data.m[0].u} onClick={openProfile}>
							{this.props.data.m[0].u}
						</span>{' '}
						opened this issue {u.date(this.props.data.m[0].t).toString()}
					</span>
				</div>
				<hr />
				<div className="ticket-content">
					<div className="ticket-comments">
						{this.props.data.m.map((m, i) => {
							return m.m ? (
								<TicketComment
									data={m}
									tid={this.props.data.id}
									cid={i}
									key={'tc' + i}
									editComment={this.props.editComment}
								/>
							) : (
								<TicketAction data={m} key={'ta' + i} />
							)
						})}
						{this.props.data.status === 'open' ? (
							<div className="ticket-comment-container">
								<div className="user">
									<img
										width="45"
										height="45"
										className="profile-image pointer"
										title={window.user.username}
										data-username={window.user.username}
										onClick={openProfile}
										src={
											is_video(window.user.image)
												? profile_picture(window.user.image).replace(/\.[^\.]+$/, '.png')
												: profile_picture(window.user.image)
										}
									/>
								</div>
								<div className="ticket-comment">
									<div className="comment-title">
										<span>Commenting as {window.user.username}</span>
										<Box grow vertical></Box>
										<span className="title-buttons">
											<UploadButton onUpload={this.onUpload} />
											<span className="comment button pointer" onClick={this.comment}>
												Comment
											</span>
										</span>
									</div>
									<textarea
										className="add-comment"
										ref="add-comment"
										placeholder="Char. limit: 10,000"
										maxLength="10000"
										onChange={this.storage}
									/>
								</div>
							</div>
						) : null}
					</div>
					<div>
						<TicketSidebar
							data={this.props.data}
							closeTicket={this.props.closeTicket}
							reopenTicket={this.props.reopenTicket}
							hideTicket={this.props.hideTicket}
							toggleSub={this.props.toggleSub}
							toggleLike={this.props.toggleLike}
							markDone={this.props.markDone}
							setType={this.props.setType}
							setCategory={this.props.setCategory}
						/>
					</div>
				</div>
			</div>
		)
	},
})

var TicketComment = React.createClass({
	getInitialState: function () {
		return {
			editing: false,
		}
	},
	edit: function () {
		this.setState({ editing: true }, function () {
			this.refs.edit.focus()
			this.refs.edit.setSelectionRange(this.refs.edit.value.length, this.refs.edit.value.length)
		})
	},
	cancel: function () {
		this.setState({ editing: false })
	},
	submit: function () {
		var data = {
			tid: this.props.tid,
			cid: this.props.cid,
			m: this.refs.edit.value.substring(0, 10000),
		}
		this.props.editComment(data)
		this.setState({ editing: false })
	},
	render: function () {
		return (
			<div className="ticket-comment-container">
				<div className="user">
					<img
						width="45"
						height="45"
						className="profile-image pointer"
						title={this.props.data.u}
						data-username={this.props.data.u}
						onClick={openProfile}
						src={
							is_video(this.props.data.i)
								? profile_picture(this.props.data.i).replace(/\.[^\.]+$/, '.png')
								: profile_picture(this.props.data.i)
						}
					/>
				</div>
				<div className="ticket-comment">
					<div className="comment-title">
						<span>
							<span className="pointer" data-username={this.props.data.u} onClick={openProfile}>
								{this.props.data.u}
							</span>{' '}
							<span>
								commented <span className="small">{u.format_time(this.props.data.t)}</span>
							</span>
							{this.props.data.e && (
								<span>
									{' / '}
									Edited <span className="small">{u.format_time(this.props.data.e)}</span>
								</span>
							)}
						</span>
						<span className="comment-toolbar">
							{this.props.data.u === window.user.username &&
								(this.state.editing ? (
									<span>
										<span className="pointer" onClick={this.submit}>
											Confirm
										</span>
										{' | '}
										<span className="pointer" onClick={this.cancel}>
											Cancel
										</span>
									</span>
								) : (
									<span className="pointer" onClick={this.edit}>
										<Icon type="edit" />
									</span>
								))}
						</span>
					</div>
					{this.state.editing ? (
						<textarea ref="edit" defaultValue={this.props.data.m} maxLength="10000" />
					) : (
						<p
							dangerouslySetInnerHTML={{
								__html: u.linkyNoScroll(this.props.data.m),
							}}
						></p>
					)}
				</div>
			</div>
		)
	},
})

var TicketAction = React.createClass({
	render: function () {
		return (
			<div className="ticket-action">
				<span className="user pointer" data-username={this.props.data.u} onClick={openProfile}>
					{this.props.data.u}
				</span>{' '}
				{this.props.data.a} {u.format_time(this.props.data.t)}
			</div>
		)
	},
})

var TicketSidebar = React.createClass({
	getInitialState: function () {
		return {
			pv: false,
			type: this.props.data.type,
			category: this.props.data.category,
			labelEdit: false,
		}
	},
	closeTicket: function () {
		if (this.props.data.status !== 'closed') this.props.closeTicket(this.props.data.id)
	},
	reopenTicket: function () {
		if (this.props.data.status !== 'open') this.props.reopenTicket(this.props.data.id)
	},
	hideTicket: function () {
		this.props.hideTicket(this.props.data.id)
	},
	setPv: function (v) {
		this.setState({ pv: v })
	},
	toggleSub: function () {
		this.props.toggleSub(this.props.data.id)
	},
	toggleLike: function () {
		this.props.toggleLike(this.props.data.id)
	},
	markDone: function () {
		this.props.markDone(this.props.data.id)
	},
	setType: function (e) {
		var type = u.swap(ticketTypes)[e.currentTarget.value]
		if (type != undefined) {
			this.setState({ type: type })
			this.props.setType({
				id: this.props.data.id,
				ty: type,
			})
		}
	},
	setCategory: function (e) {
		var category = u.swap(ticketCategories)[e.currentTarget.value]
		if (category != undefined) {
			this.setState({ category: category })
			this.props.setCategory({
				id: this.props.data.id,
				c: category,
			})
		}
	},
	toggleLabelEdit: function () {
		this.setState({ labelEdit: !this.state.labelEdit })
	},
	render: function () {
		return (
			<div className="ticket-sidebar">
				<div className="actions">
					Actions:
					<ul style={{ marginTop: '2px', width: '150px' }}>
						{window.user.mod && (
							<div>
								<li
									className="pointer"
									title={this.props.data.status === 'open' ? 'close ticket' : 'reopen ticket'}
									onClick={this.props.data.status === 'open' ? this.closeTicket : this.reopenTicket}
								>
									{this.props.data.status === 'open' ? 'close' : 'reopen'}
								</li>
								<li className="pointer" title="logically delete ticket" onClick={this.hideTicket}>
									hide
								</li>
								{this.props.data.status === 'open' && (
									<div>
										<li className="pointer" title={'mark done and close'} onClick={this.markDone}>
											mark done
										</li>
									</div>
								)}
							</div>
						)}
						<li
							className="pointer"
							title={
								this.props.data.s && this.props.data.s[window.user.username] === true
									? 'unsubscribe'
									: 'subscribe'
							}
							onClick={this.toggleSub}
						>
							{this.props.data.s && this.props.data.s[window.user.username] === true
								? 'unsubscribe'
								: 'subscribe'}
						</li>
						<li
							className="pointer"
							title={
								this.props.data.h && this.props.data.h[window.user.username] === true
									? 'unlike'
									: 'like'
							}
							onClick={this.toggleLike}
						>
							{this.props.data.h && this.props.data.h[window.user.username] === true
								? 'unlike'
								: 'like'}
						</li>
					</ul>
				</div>
				<hr />
				<Box vertical-waterfall className="labels">
					{this.state.labelEdit ? (
						<form>
							<label className="inline">
								<select value={ticketCategories[this.state.category]} onChange={this.setCategory}>
									<option>Category</option>
									{Object.values(ticketCategories).map((category, i) => {
										return (
											<option value={category} key={`c${i}`}>
												{category}
											</option>
										)
									})}
								</select>
							</label>
							<label className="inline">
								<select value={ticketTypes[this.state.type]} onChange={this.setType}>
									<option>Type</option>
									{Object.values(ticketTypes).map((type, i) => {
										return (
											<option value={type} key={`t${i}`}>
												{type}
											</option>
										)
									})}
								</select>
							</label>
						</form>
					) : (
						<span>
							<span className="label category">{ticketCategories[this.props.data.category]}</span>
							<span className={`label ${ticketTypes[this.props.data.type]}`}>
								{ticketTypes[this.props.data.type]}
							</span>
						</span>
					)}
					{window.user.mod && (
						<span className="pointer" title="edit" onClick={this.toggleLabelEdit}>
							{' '}
							<Icon type="edit" />
						</span>
					)}
				</Box>
				<hr />
				{this.props.data.h && Object.entries(this.props.data.h).length > 0 && (
					<div className="likes">
						Liked by: {this.props.data.h && Object.keys(this.props.data.h).join(', ')}
					</div>
				)}
			</div>
		)
	},
})
