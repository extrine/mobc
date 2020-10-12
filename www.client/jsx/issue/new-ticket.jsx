var NewTicket = React.createClass({
	getInitialState: function () {
		return {
			type: null,
			category: null,
			error: '',
		}
	},
	componentDidMount: function () {
		var o = storage.get()
		if (o.tickets && o.tickets.new)
			for (var key in o.tickets.new) {
				this.refs[key].value = o.tickets.new[key]
			}
		if (this.refs.type.value != 'type') this.setTypeState(this.refs.type.value)
		if (this.refs.category.value != 'category') this.setCategoryState(this.refs.category.value)
		this.refs.title.focus()
	},
	open: function () {
		let data = {
			t: this.refs.title.value.trim(),
			b: this.refs.comment.value.trim(),
			ty: this.state.type,
			c: this.state.category,
		}
		if (!data.ty || !data.c) {
			this.setState({
				error: 'Select a type and category before opening ticket.',
			})
			return
		} else if (data.t === '') {
			this.setState({ error: 'Title of ticket is required.' })
			return
		} else {
			var o = storage.get()
			o.tickets.new.title = ''
			o.tickets.new.comment = ''
			storage.update(o)
			this.props.openTicket(data)
		}
	},
	back: function () {
		this.props.ss({ status: 'open', view: 'ticket' })
	},
	setType: function (e) {
		this.setTypeState(e.currentTarget.value)
		this.storage(e)
	},
	setTypeState: function (t) {
		var type = u.swap(ticketTypes)[t]
		if (type != undefined) this.setState({ type: type })
	},
	setCategory: function (e) {
		this.setCategoryState(e.currentTarget.value)
		this.storage(e)
	},
	setCategoryState: function (c) {
		var category = u.swap(ticketCategories)[c]
		if (category != undefined) this.setState({ category: category })
	},
	storage: function (e) {
		var type = e.currentTarget.className,
			input = e.currentTarget.value,
			o = storage.get()
		if (!o.tickets) o.tickets = {}
		if (!o.tickets.new) o.tickets.new = {}
		o.tickets.new[type] = input
		storage.update(o)
	},
	onUpload: function (doUpload) {
		doUpload(
			function (link) {
				this.refs.comment.value = this.refs.comment.value + ' ' + link + ' '
			}.bind(this),
		)
	},
	render: function () {
		return (
			<div className="new-ticket">
				{this.state.error && <div className="error">{this.state.error}</div>}
				<div className="ticket-toolbar">
					<Box
						className="arrow-left"
						onClick={this.back}
						title="Back"
						style={{
							margin: '-8px',
							marginLeft: '-3px !important;',
							marginRight: '10px',
						}}
					/>{' '}
					<b>New Ticket</b>
					<form>
						<label className="inline">
							<select className="type" ref="type" onChange={this.setType}>
								<option>type</option>
								{Object.values(ticketTypes).map((type, i) => {
									return (
										<option value={type} key={`t${i}`}>
											{type}
										</option>
									)
								})}
							</select>
						</label>
						<label className="inline">
							<select className="category" ref="category" onChange={this.setCategory}>
								<option>category</option>
								{Object.values(ticketCategories).map((category, i) => {
									return (
										<option value={category} key={`c${i}`}>
											{category}
										</option>
									)
								})}
							</select>
						</label>
					</form>
					<Box grow vertical></Box>
					<UploadButton onUpload={this.onUpload} />
					<span className="button pointer" onClick={this.open}>
						Open Ticket
					</span>
				</div>
				<div className="in">
					<input
						className="title"
						placeholder="Title"
						maxLength="200"
						ref="title"
						onChange={this.storage}
					/>
					<textarea
						className="comment"
						placeholder={`Only report site issues/bugs here.\nDon't report users here.\nSpamming won't be tolerated.\nPlease be as descriptive as possible.`}
						maxLength="10000"
						ref="comment"
						onChange={this.storage}
					/>
				</div>
			</div>
		)
	},
})
