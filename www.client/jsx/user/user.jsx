window.user = {
	username: 'Lame Guest ',
	color: 'white',
}

var User = React.createClass({
	mixins: [React.addons.PureRenderMixin],

	getInitialState: function() {
		var user = {
			u: {
				username: 'Lame Guest ',
			},
			logged: false,
		}

		ios.on('uf', function(data) {
			window.friend = data.fr
			window.user.followers = data.fo

			if (window.FriendListUpdate) {
				window.FriendListUpdate.setState({ data: data.fr })
			}
			if (window.FriendRequestsUpdate) {
				window.FriendRequestsUpdate.setState({ data: data.fo })
			}
		})
		ios.on(
			'a',
			function(data) {
				if (data.id == 'login') {
					window.user = data.u
					window.user.username_lower = window.user.username.toLowerCase()
					window.user.tags_modified = window.user.tags
						.replace(/,/g, ' ')
						.replace(/@/g, ' ')
						.replace(/\s+/g, ' ')
						.toLowerCase()
						.trim()
						.split(' ')
					window.user.tags_modified.push(window.user.username_lower.substr(0, 3))
					window.user.tags_modified.push(window.user.username_lower.substr(0, 4))
					window.user.tags_modified.push(window.user.username_lower.substr(0, 5))
					window.user.tags_modified.push(window.user.username_lower.split(' ')[0])
					window.user.tags_modified.push(window.user.username_lower.split(' ')[1])
					window.user.tags_modified.push(window.user.username_lower.replace(/[0-9]/g, ''))
					window.user.tags_modified = u.arrayUnique(window.user.tags_modified)
					window.friend = u.copy(data.u.friend)
					window.user.friend = {}
					window.user.fps = +data.u.fps

					if (window.FriendListUpdate) {
						window.FriendListUpdate.setState({ data: window.friend })
					}
					if (window.FriendRequestsUpdate) {
						window.FriendRequestsUpdate.setState({ data: data.u.followers })
					}

					user.u = data.u
					user.logged = data.logged
					if (!body) body = $('body')

					body.attr('data-mod', data.u.mod ? 'true' : '')
					body.attr('data-nohd', data.u.nohd ? 'true' : '')
					body.attr('data-cblind', data.u.cblind ? 'true' : '')
					body.attr('data-pu', data.u.pu ? 'true' : '')
					body.attr('data-guest', data.u.username.indexOf('Lame Guest') === 0)
					if (!data.u.donated) {
						body.attr('data-donated', false)
					} else {
						body.attr('data-donated', true)
					}

					this.setState(user)
					this.setState({
						unread: data.unread,
					})
					if (data.unread > 0) u.soundAlways('message' + String(Math.floor(Math.random() * 2) + 1))

					if (window.user.username.indexOf('Lame Guest') === -1) {
						setTimeout(function() {
							for (var id in onUserLogin) {
								setTimeout(onUserLogin[id], 10)
							}
							onUserLogin = []
						}, 2000)
					}
				} else if (data.id == 'unread') {
					this.setState({
						unread: data.d,
					})
				} else if (data.id == 'notify-wall') {
					u.soundAlways('message' + String(Math.floor(Math.random() * 2) + 1))
					if (window.user.nty && window.user.ntyw) {
						u.notification({
							title: 'Wall Message From ' + data.u,
							body: data.b,
							image: data.i,
							url: '#u/' + encodeURIComponent(data.u),
						})
					}
				} else if (data.id == 'notify-pool') {
					u.soundAlways('knockknock')
					u.notification({
						title: 'Wake up! Your Turn!',
						body: 'To play ' + window.room.game,
						image: window.user.image,
					})
				} else if (data.id == 'ep') {
					storage.update({
						password: data.v,
						email: data.e,
					})
				}
			}.bind(this),
		)
		window.login = this.login
		this.welcome()
		return user
	},
	render: function() {
		return (
			<div className="user">
				{this.state.logged ? (
					<div className="relative no-select">
						<a
							data-unread={this.state.unread}
							className="username break pointer white no-underline"
							href={'#u/' + encodeURIComponent(this.state.u.username)}
						>
							{this.state.u.username}{' '}
							<img src="https://omgmobc.com/img/icon/favicon.png" width="16" height="16" />
						</a>{' '}
						<span className="r">
							<svg
								className="  pointer"
								title="Search for a user…"
								onClick={openProfile}
								role="img"
								xmlns="http://www.w3.org/2000/svg"
								viewBox="0 0 512 512"
							>
								<path
									fill="currentColor"
									d="M505 442.7L405.3 343c-4.5-4.5-10.6-7-17-7H372c27.6-35.3 44-79.7 44-128C416 93.1 322.9 0 208 0S0 93.1 0 208s93.1 208 208 208c48.3 0 92.7-16.4 128-44v16.3c0 6.4 2.5 12.5 7 17l99.7 99.7c9.4 9.4 24.6 9.4 33.9 0l28.3-28.3c9.4-9.4 9.4-24.6.1-34zM208 336c-70.7 0-128-57.2-128-128 0-70.7 57.2-128 128-128 70.7 0 128 57.2 128 128 0 70.7-57.2 128-128 128z"
								/>
							</svg>{' '}
							<a className="white" href="#p/Settings">
								<svg
									className="pointer"
									title="Preferences"
									style={{
										color: '#85c334',
									}}
									role="img"
									xmlns="http://www.w3.org/2000/svg"
									viewBox="0 0 512 512"
								>
									<path
										fill="currentColor"
										d="M444.788 291.1l42.616 24.599c4.867 2.809 7.126 8.618 5.459 13.985-11.07 35.642-29.97 67.842-54.689 94.586a12.016 12.016 0 0 1-14.832 2.254l-42.584-24.595a191.577 191.577 0 0 1-60.759 35.13v49.182a12.01 12.01 0 0 1-9.377 11.718c-34.956 7.85-72.499 8.256-109.219.007-5.49-1.233-9.403-6.096-9.403-11.723v-49.184a191.555 191.555 0 0 1-60.759-35.13l-42.584 24.595a12.016 12.016 0 0 1-14.832-2.254c-24.718-26.744-43.619-58.944-54.689-94.586-1.667-5.366.592-11.175 5.459-13.985L67.212 291.1a193.48 193.48 0 0 1 0-70.199l-42.616-24.599c-4.867-2.809-7.126-8.618-5.459-13.985 11.07-35.642 29.97-67.842 54.689-94.586a12.016 12.016 0 0 1 14.832-2.254l42.584 24.595a191.577 191.577 0 0 1 60.759-35.13V25.759a12.01 12.01 0 0 1 9.377-11.718c34.956-7.85 72.499-8.256 109.219-.007 5.49 1.233 9.403 6.096 9.403 11.723v49.184a191.555 191.555 0 0 1 60.759 35.13l42.584-24.595a12.016 12.016 0 0 1 14.832 2.254c24.718 26.744 43.619 58.944 54.689 94.586 1.667 5.366-.592 11.175-5.459 13.985L444.788 220.9a193.485 193.485 0 0 1 0 70.2zM336 256c0-44.112-35.888-80-80-80s-80 35.888-80 80 35.888 80 80 80 80-35.888 80-80z"
									/>
								</svg>
							</a>{' '}
							<Mute />
							<svg
								className="  pointer"
								title="Hard Reload"
								onClick={function() {
									window.location.reload(true)
								}}
								role="img"
								xmlns="http://www.w3.org/2000/svg"
								viewBox="0 0 512 512"
							>
								<path
									fill="currentColor"
									d="M212.333 224.333H12c-6.627 0-12-5.373-12-12V12C0 5.373 5.373 0 12 0h48c6.627 0 12 5.373 12 12v78.112C117.773 39.279 184.26 7.47 258.175 8.007c136.906.994 246.448 111.623 246.157 248.532C504.041 393.258 393.12 504 256.333 504c-64.089 0-122.496-24.313-166.51-64.215-5.099-4.622-5.334-12.554-.467-17.42l33.967-33.967c4.474-4.474 11.662-4.717 16.401-.525C170.76 415.336 211.58 432 256.333 432c97.268 0 176-78.716 176-176 0-97.267-78.716-176-176-176-58.496 0-110.28 28.476-142.274 72.333h98.274c6.627 0 12 5.373 12 12v48c0 6.627-5.373 12-12 12z"
								></path>
							</svg>{' '}
							<svg
								className="pointer"
								title="Logout"
								onClick={this.logout}
								role="img"
								xmlns="http://www.w3.org/2000/svg"
								viewBox="0 0 512 512"
							>
								<path
									fill="currentColor"
									d="M497 273L329 441c-15 15-41 4.5-41-17v-96H152c-13.3 0-24-10.7-24-24v-96c0-13.3 10.7-24 24-24h136V88c0-21.4 25.9-32 41-17l168 168c9.3 9.4 9.3 24.6 0 34zM192 436v-40c0-6.6-5.4-12-12-12H96c-17.7 0-32-14.3-32-32V160c0-17.7 14.3-32 32-32h84c6.6 0 12-5.4 12-12V76c0-6.6-5.4-12-12-12H96c-53 0-96 43-96 96v192c0 53 43 96 96 96h84c6.6 0 12-5.4 12-12z"
								/>
							</svg>
						</span>
						<div className="clear" />
					</div>
				) : (
					<div>
						<div className="login">
							<div>
								<b>LOGIN</b>
							</div>
							<form onSubmit={this.save}>
								<label>
									<div>email/username:</div>
									<div>
										<input type="text" className="email" autoComplete="email" />
									</div>
								</label>
								<label>
									<div>password:</div>
									<div>
										<input type="password" className="password" autoComplete="current-password" />
									</div>
									<small>"Please do not use the same password you use on other sites"</small>
								</label>
								<label>
									<div>
										<input type="submit" value="login" className="button yellow" />
									</div>
								</label>
							</form>
							<small onClick={this.toggle} className="link">
								signup
							</small>{' '}
							-{' '}
							<small onClick={this.toggleForgotPassword} className="link">
								forgot password
							</small>
						</div>
						<div className="signup hidden">
							<div>
								<b>SIGNUP</b>
							</div>
							<form onSubmit={this.signup}>
								<label>
									<div>username:</div>
									<div>
										<input type="text" className="username" maxLength="20" autoComplete="off" />
									</div>
								</label>
								<label>
									<div>email:</div>
									<div>
										<input type="text" className="email" autoComplete="new-email" />
									</div>
								</label>
								<label>
									<div>password:</div>
									<div>
										<input type="password" className="password" autoComplete="new-password" />
									</div>
									"Please do not use the same password you use on other sites"
								</label>
								<label>
									<div>
										<input type="submit" value="signup" className="button yellow" />
									</div>
								</label>
							</form>
							<small onClick={this.toggle} className="link">
								login
							</small>{' '}
							-{' '}
							<small onClick={this.toggleForgotPassword} className="link">
								forgot password
							</small>
						</div>
						<div className="forgot hidden">
							<hr />
							<div>
								<b>FORGOT PASSWORD</b>
							</div>
							<label>
								<div>email:</div>
								<div>
									<input type="text" className="email" />
								</div>
							</label>
							<label>
								<div>
									<span className="button yellow" onClick={this.forgotPassword}>
										reset password
									</span>
								</div>
							</label>
						</div>
					</div>
				)}
			</div>
		)
	},

	logout: function() {
		storage.update({
			email: false,
			password: false,
		})
		emit({
			id: 'logout',
		})
	},
	signup: function(e) {
		e.preventDefault()
		e.stopPropagation()
		if (
			confirm('YOU MUST CONFIRM THE ACCOUNT VIA EMAIL TO PLAY.\nAre you sure you want to continue?')
		) {
			var username = $('.user-container .user .signup .username').val()
			var email = $('.user-container .user .signup .email').val()
			var password = $('.user-container .user .signup .password').val()
			if (email != '' && password != '') {
				storage.update({
					email: email,
					password: password,
				})
				emit(
					{
						id: 'signup',
						username: username,
						email: email,
						password: password,
					},
					function() {
						$('.user-container .user .signup .username').val('')
						$('.user-container .user .signup .email').val('')
						$('.user-container .user .signup .password').val('')
					},
				)
			}
		}
	},
	save: function(e) {
		e.preventDefault()
		e.stopPropagation()
		var email = $('.user-container .user .login .email').val()
		var password = $('.user-container .user .login .password').val()

		if (email != '' && password != '') {
			storage.update({
				email: email,
				password: password,
			})
			this.login()
		}
	},
	welcome: function() {
		this.login(false, function() {
			window.onhashchange()
		})
	},
	forgotPassword: function() {
		var email = $('.user-container .user .forgot .email').val()
		if (email != '') {
			emit({
				id: 'forgot',
				email: email,
			})
			$('.user-container .user .forgot .email').val('')
		}
	},
	login: function(event, callback) {
		try {
			var t = new Date().toString().match(/([A-Z]+[\+-][0-9]+.*)/)[1]
		} catch (e) {
			var t = new Date().getTimezoneOffset()
		}

		var o = storage.get()

		fp(function(r) {
			r = sha1(JSON.stringify(r))
			emit(
				{
					id: 'login',
					email: o.email || false,
					password: o.password || false,
					version: version,
					tf: u.document_is_visible,
					a: r,
					b: storage.i(),
					t:
						t +
						'.' +
						window.screen.width +
						'.' +
						window.screen.height +
						'.' +
						(window.navigator.languages || []).join(','),
					m: isMobile ? true : false,
				},
				function() {
					if (callback) callback()
				},
			)
		})
	},
	toggle: function() {
		$('.user-container .user .login').toggleClass('hidden')
		$('.user-container .user .signup').toggleClass('hidden')
		$('.user-container .user .forgot').addClass('hidden')
	},
	toggleForgotPassword: function() {
		$('.user-container .user .forgot').toggleClass('hidden')
	},
})
