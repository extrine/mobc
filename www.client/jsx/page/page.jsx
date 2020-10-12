var Prompt = React.createClass({
	mixins: [React.addons.PureRenderMixin],
	getInitialState: function () {
		return {}
	},
	render: function () {
		$('.content-container .footer .page').attr('data-page', 'confirm')
		return (
			<div>
				<div className="no-select">{this.props.text}</div>
				<hr />
				<div className="message">
					<input
						type="text"
						className="prompt-value"
						onKeyDown={this.onKeyDown}
						defaultValue={this.props.value}
					/>
				</div>

				<div className="r">
					<div className="button green" onClick={this.ok}>
						OK
					</div>{' '}
					<div className="button red" onClick={this.close}>
						CANCEL
					</div>
				</div>
			</div>
		)
	},
	onKeyDown: function (e) {
		if (e.keyCode == 13) {
			e.preventDefault()
			e.stopPropagation()
			this.ok()
		}
	},
	ok: function () {
		var value = $('.prompt-value').val()
		var aFunction = this.props.callback
		this.close()
		setTimeout(function () {
			aFunction(value)
		}, 0)
	},
	componentDidUpdate: function () {
		$('.content-container .footer .page').attr('data-page', 'confirm')
	},
	componentDidMount: function () {
		$('.content-container .footer .page')[0].scrollTop = 0
		$('.content-container .footer').attr('data-open', 'true')
		$('.content-container .footer .page').attr('data-open', 'true')
		$('.content-container .footer .page').attr('data-page', 'confirm')
		$('.content-container .footer .page .prompt-value').focus()

		body.on(
			'mousedown.page',
			function (e) {
				if (!$(e.target).hasClass('page') && !$(e.target).parents('.page').length) {
					$('.content-container .footer .page')[0].scrollTop = 0
					this.close()
				}
			}.bind(this),
		)
	},
	componentWillUnmount: function () {
		$('.content-container .footer .page')[0].scrollTop = 0

		body.off('mousedown.page')
		$('.content-container .footer').attr('data-open', 'false')
		$('.content-container .footer .page').attr('data-open', 'false')
		$('.content-container .footer .page').attr('data-page', null)
	},
	close: function () {
		body.off('mousedown.page')
		$('.content-container .footer').attr('data-open', 'false')
		$('.content-container .footer .page').attr('data-open', 'false')
		$('.content-container .footer .page').attr('data-page', null)
		ReactDOM.unmountComponentAtNode(document.querySelector('.content-container .footer .page'))
		setTimeout(function () {
			window.onhashchange()
		}, 0)
	},
})

function PROMPT(text, aCallback, value) {
	ReactDOM.render(
		<Prompt text={text} value={value} callback={aCallback} />,
		document.querySelector('.content-container .footer .page'),
	)
}

var Confirm = React.createClass({
	mixins: [React.addons.PureRenderMixin],
	getInitialState: function () {
		return {}
	},
	render: function () {
		$('.content-container .footer .page').attr('data-page', 'confirm')
		return (
			<div>
				<div className="no-select">CONFIRM ACTION</div>
				<hr />
				<div className="message">{this.props.text}</div>

				<div className="r">
					<div className="button green" onClick={this.ok}>
						OK
					</div>{' '}
					<div className="button red" onClick={this.close}>
						CANCEL
					</div>
				</div>
			</div>
		)
	},
	ok: function () {
		this.close()
		var aFunction = this.props.callback
		setTimeout(function () {
			aFunction()
		}, 0)
	},
	componentDidUpdate: function () {
		$('.content-container .footer .page').attr('data-page', 'confirm')
	},
	componentDidMount: function () {
		$('.content-container .footer .page')[0].scrollTop = 0
		$('.content-container .footer').attr('data-open', 'true')
		$('.content-container .footer .page').attr('data-open', 'true')
		$('.content-container .footer .page').attr('data-page', 'confirm')
		body.on(
			'mousedown.page',
			function (e) {
				if (!$(e.target).hasClass('page') && !$(e.target).parents('.page').length) {
					$('.content-container .footer .page')[0].scrollTop = 0
					this.close()
				}
			}.bind(this),
		)
	},
	componentWillUnmount: function () {
		$('.content-container .footer .page')[0].scrollTop = 0

		body.off('mousedown.page')
		$('.content-container .footer').attr('data-open', 'false')
		$('.content-container .footer .page').attr('data-open', 'false')
		$('.content-container .footer .page').attr('data-page', null)
	},
	close: function () {
		body.off('mousedown.page')
		$('.content-container .footer').attr('data-open', 'false')
		$('.content-container .footer .page').attr('data-open', 'false')
		$('.content-container .footer .page').attr('data-page', null)
		ReactDOM.unmountComponentAtNode(document.querySelector('.content-container .footer .page'))
		setTimeout(function () {
			window.onhashchange()
		}, 120)
	},
})

function CONFIRM(text, aCallback) {
	ReactDOM.render(
		<Confirm text={text} callback={aCallback} />,
		document.querySelector('.content-container .footer .page'),
	)
}

var Page = React.createClass({
	mixins: [React.addons.PureRenderMixin],
	getInitialState: function () {
		return {}
	},
	doUpdate: function () {
		if (this.mounted) this.setState({ nada: !this.state.nada })
	},
	render: function () {
		var page = this.props.page.replace(/\/.*/, '')

		u.title(u.capital(page) + ': ')
		if (page == 'Ranking') {
			return <Ranking />
		} else if (page == 'FAQs') {
			return <FAQs />
		} else if (page == 'Rules') {
			return <Rules />
		} else if (page == 'ChangeLog') {
			return <ChangeLog />
		} else if (page == 'Emoji') {
			return <Emoji />
		} else if (page == 'Contribute') {
			return <Contribute />
		} else if (page == 'Settings') {
			return <UserSettings />
		} else if (page == 'Chat') {
			return <ChatHelp />
		} else if (page == 'Design') {
			return <Design />
		} else if (page == 'BubblesMapGenerator') {
			return <BubblesMapGenerator />
		} else if (page == 'Profile') {
			u.title(this.props.username + ': ')
			return <Profile username={this.props.username} />
		} else if (page == 'Search') {
			u.title('Search: ' + this.props.page.replace(/^Search\//, '') + ': ')
			return <Search username={this.props.page.replace(/^Search\//, '')} />
		} else if (page == 'Tournaments') {
			return <Tournaments />
		} else if (page == 'Tournament9BallBrackets') {
			return <Tournament9BallBrackets />
		} else if (page == 'TournamentPoolBrackets') {
			return <TournamentPoolBrackets />
		} else if (page == 'TournamentDingleBrackets') {
			return <TournamentDingleBrackets />
		} else if (page == 'TournamentSwapplesBrackets') {
			return <TournamentSwapplesBrackets />
		} else if (page == 'Issues') {
			return <IssueTracker tid={this.props.page.replace(/^Issues\//, '')} />
		} else {
			return null
		}
	},
	componentDidUpdate: function () {
		$('.content-container .footer .page').attr(
			'data-page',
			this.props.page.toLowerCase().replace(/\/.*$/g, ''),
		)

		if ($('.content-container .footer .page .profile .avatar  .profile-image').length) {
		} else {
			$('.content-container .footer .page').animate(
				{
					scrollTop: 0,
				},
				0,
			)
		}
	},
	componentDidMount: function () {
		this.mounted = true
		onUserLogin.push(this.doUpdate)
		$('.content-container .footer .page')[0].scrollTop = 0
		$('.content-container .footer').attr('data-open', 'true')
		$('.content-container .footer .page').attr('data-open', 'true')
		$('.content-container .footer .page').attr(
			'data-page',
			this.props.page.toLowerCase().replace(/\/.*$/g, ''),
		)
		body.on(
			'mousedown.page',
			function (e) {
				if (!$(e.target).hasClass('page') && !$(e.target).parents('.page').length) {
					$('.content-container .footer .page')[0].scrollTop = 0
					this.close()
				}
			}.bind(this),
		)
	},
	componentWillUnmount: function () {
		this.mounted = false

		u.title()

		u.removeValueFromArray(onUserLogin, this.doUpdate)
		$('.content-container .footer .page')[0].scrollTop = 0

		body.off('mousedown.page')
		$('.content-container .footer').attr('data-open', 'false')
		$('.content-container .footer .page').attr('data-open', 'false')
		$('.content-container .footer .page').attr('data-page', null)
	},
	close: function () {
		body.off('mousedown.page')
		$('.content-container .footer').attr('data-open', 'false')
		$('.content-container .footer .page').attr('data-open', 'false')
		$('.content-container .footer .page').attr('data-page', null)
		ReactDOM.unmountComponentAtNode(document.querySelector('.content-container .footer .page'))
		var hash = u.getHash()
		if (window.room && hash != 'm/' + window.room.id) {
			location.hash = 'm/' + encodeURIComponent(window.room.id)
		} else if (window.room && hash == 'm/' + window.room.id) {
		} else {
			location.hash = ''
		}
	},
})

function openPage(page) {
	ReactDOM.render(<Page page={page} />, document.querySelector('.content-container .footer .page'))
}

function openProfile(username) {
	if (typeof username != 'string' && username && username.currentTarget)
		username = $(username.currentTarget).attr('data-username')
	if (!username || username == '') {
		PROMPT(
			'Username',
			function (username) {
				username = username.trim()
				if (username && username != '' && username != 'MOBC') {
					if (/^[0-9]+$/.test(username))
						location.hash = 'u/' + encodeURIComponent('Lame Guest ' + username)
					else location.hash = 'p/Search/' + encodeURIComponent(username)
				}
			},
			'',
		)
		return
	}
	if (username && username != '' && username != 'MOBC')
		ReactDOM.render(
			<Page page="Profile" username={username} />,
			document.querySelector('.content-container .footer .page'),
		)
}

function pageUnmount() {
	ReactDOM.unmountComponentAtNode(document.querySelector('.content-container .footer .page'))
	if (location.href.indexOf('#m/') === -1) {
		location.replace('#')
	}
}
