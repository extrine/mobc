var TabArea = React.createClass({
	getInitialState: function () {
		ios.on('a', data => {
			var notify
			switch (data.id) {
				case 'c':
					if (
						this.props.id == 'sidebar' &&
						this.state.viewing != 'room' &&
						!this.state.notify.room &&
						data.un &&
						data.un != 'MOBC' &&
						data.un != 'game'
					) {
						this.notify('room')
					}
					break
				case 'room':
					if (this.props.id == 'sidebar') {
						if (data.room != false && !this.didFocus) {
							this.didFocus = true
							this.setTab('room')
						} else if (data.room == false) {
							this.didFocus = false
						}
						if (
							this.state.viewing != 'room' &&
							!this.state.notify.room &&
							data.un &&
							data.un != 'MOBC' &&
							data.un != 'game'
						) {
							this.notify('room')
						}
					}
					break
				case 'pc':
					if (this.props.id == 'sidebar') {
						this.notify('private')
					}
					break
				default:
					return
			}
		})

		ios.on('nt', data => {
			if (this.props.id == 'sidebar') {
				this.notify('friends')
			}
			if (this.props.id == 'friends') {
				this.notify(data)
			}
		})

		ios.on('f', data => {
			if (this.props.id == 'sidebar') {
				if (this.state.last == 'init') {
					this.setState({ last: Object.keys(data).sort() })
				}
				clearTimeout(this.to)
				this.to = setTimeout(() => {
					var list = Object.keys(data).sort()
					var last = this.state.last
					if (list.join() != last.join()) {
						this.notify('friends')
						this.setState({ last: list }, () => {
							setTimeout(() => {
								this.unnotify('friends')
							}, 4000)
						})
					}
				}, 30000)
			}
			//if (this.props.id == 'friends') this.notify('online')
		})

		return {
			viewing: this.props.children[0].props.id,
			notify: {},
			scroll: false,
			last: 'init',
		}
	},
	componentDidUpdate: function () {
		if (this.scroll) {
			this.scroll = false
			switch (this.state.viewing) {
				case 'private':
					window.updateScrollPrivate()
					break
				case 'room':
					window.updateScroll()
			}
		}
		var tabs = this.props.children.filter(child => {
			if (child != null) return 1
		})

		var tabExists = false
		for (var tab = 0, len = tabs.length; tab < len; tab++) {
			var hidden =
				tabs[tab] &&
				tabs[tab].props &&
				tabs[tab].props.style &&
				tabs[tab].props.style.display == 'none'
					? true
					: false
			if (tabs[tab].props.id === this.state.viewing && !hidden) {
				tabExists = true
				break
			}
		}

		if (!tabExists) {
			for (var tab = 0, len = tabs.length; tab < len; tab++) {
				if (tabs[tab].props) {
					if (tabs[tab].props.style && tabs[tab].props.style.display == 'none') continue
					else this.setTab(tabs[tab].props.id)
					break
				}
			}
		}
	},
	componentDidMount: function () {
		setTimeout(() => {
			if (this.props.id == 'sidebar' && document.querySelector('.chat-private .unread') !== null) {
				this.notify('private')
			}
			if (
				this.props.id == 'friends' &&
				window.user.followers &&
				Object.keys(window.user.followers).length > 0
			) {
				this.notify('requests')
			}
			var o = storage.get()
			if (this.props.id == 'sidebar' && o.tab) this.setTab(o.tab.sidebar)
		}, 1000)
	},

	render: function () {
		var tabs = this.props.children.filter(child => {
			if (child != null) return 1
		})

		return (
			<div className={'tab-area ' + this.props.className} data-inner={this.props.inner}>
				<div className="tab-area-tabs" data-inner={this.props.inner}>
					{tabs.map((tab, i) => {
						return (
							<span
								className={
									this.state.viewing === tab.props.id
										? 'tab-area-tabs-tab tab-area-tabs-selected'
										: this.state.notify[tab.props.id]
										? 'tab-area-tabs-tab notify'
										: 'tab-area-tabs-tab'
								}
								key={'tat' + i}
								onClick={this.setTab}
								data-inner={this.props.inner}
								data-id={tab.props.id}
								style={tab.props.style || {}}
							>
								{this.props.id == 'sidebar' &&
								tab.props.title == 'FRIENDS' &&
								this.state.last != 'init' &&
								this.state.last.length > 0 &&
								window.user.email != '' ? (
									<span className="count">{this.state.last.length}</span>
								) : (
									''
								)}
								{tab.props.title}
							</span>
						)
					})}
				</div>
				<div className="tab-area-content" data-inner={this.props.inner}>
					{tabs.map((tab, i) => {
						var style = {
							display: tab.props.id === this.state.viewing ? 'inherit' : 'none',
						}
						return (
							<span key={'tab' + i} style={style}>
								{tab}
							</span>
						)
					})}
				</div>
			</div>
		)
	},

	setTab: function (e) {
		var id = typeof e === 'string' ? e : e.currentTarget.getAttribute('data-id')

		if (this.props.id === 'sidebar') {
			if (id === 'lobby' && this.state.viewing !== 'lobby') {
				emit({
					id: 'user viewing lobby',
					v: true,
				})
			} else if (this.state.viewing === 'lobby' && id !== 'lobby') {
				emit({
					id: 'user viewing lobby',
					v: false,
				})
			}
		}
		if (id == 'room' || id == 'private') this.scroll = true

		this.setState({ viewing: id })
		if (this.props.id == 'sidebar') {
			var o = storage.get()
			if (!o.tab) o.tab = {}
			o.tab[this.props.id] = id
			storage.update(o)
		}

		if (this.state.notify[id]) {
			this.unnotify(id)
		}
	},

	notify: function (/*taId, */ id) {
		if (/*this.props.id == taId && */ this.state.viewing != id && !this.state.notify[id]) {
			var notify = { ...this.state.notify }
			notify[id] = true
			this.setState({ notify: notify })
		}
	},
	unnotify: function (id) {
		var notify = { ...this.state.notify }
		delete notify[id]
		this.setState({ notify: notify })
	},
})

var Tab = React.createClass({
	render() {
		return <div className="tab">{this.props.children}</div>
	},
})
