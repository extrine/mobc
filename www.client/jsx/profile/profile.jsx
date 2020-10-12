var rip = {
	'bart opphile23': ' July 21, 2016',
	'Shane E Samuels316': ' March 12, 2017',
	'Big Daddy': ' November 2017',
	'.LEGEND.': ' April 2018',
	SweetTart: ' 22 April 2018',
	'Silent Fart': ' June 2019',
	boxmaker: ' August 25 2019',
	Lullaby: ' February 2019',
	'Danny McAlpin': ' July 22 2020',
}
var profileOpenCount = 0

var ProfileOpened = false
var Profile = React.createClass({
	// mixins: [React.addons.PureRenderMixin],

	getInitialState: function() {
		ProfileOpened = this
		this.itemsPerPage = 20
		this.mounted = false
		return this.defaultState()
	},
	defaultState: function() {
		return {
			a: {},
			b: false,
			ba: false,
			border: '',
			c: 'white',
			cw: true,
			f: [],
			g: [],
			i: 'https://omgmobc.com/img/loading.gif',
			ic: '',
			id: 0,
			l: 0,
			m: [],
			o: [],
			p: 0,
			pl: '',
			pu: false,
			s: 'Mooading...',
			sidebar: '',
			sky: '',
			t: '',
			u: 'Lame Guest',
			ul: 'Unknown',
			us: 'Unknown',
			wall: '',
			pv: '',
			ls: '',

			upload_loading: false,
		}
	},
	mediaStart: function() {},

	mediaStop: function(doUpload) {
		doUpload(function(link) {
			var val = $('.content-container .footer .page .profile .post textarea').val()
			$('.content-container .footer .page .profile .post textarea').val(val + ' ' + link + ' ')
		})
	},
	onUpload: function(doUpload) {
		doUpload(function(link) {
			var val = $('.content-container .footer .page .profile .post textarea').val()
			$('.content-container .footer .page .profile .post textarea').val(val + ' ' + link + ' ')
		})
	},
	render: function() {
		var shield = (
			<svg role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512">
				<path
					fill="currentColor"
					d="M113.12 159.533L256 100v309.65c-77.73-47.559-134.486-133.931-142.88-250.117zM496 128c0 221.282-135.934 344.645-221.539 380.308a48 48 0 0 1-36.923 0C130.495 463.713 16 326.487 16 128a48 48 0 0 1 29.539-44.308l192-80a48 48 0 0 1 36.923 0l192 80A48 48 0 0 1 496 128zm-48 0L255.999 48 64 128c0 169.278 94.451 295.361 191.998 335.999C349.602 425.017 448 301.804 448 128z"
				/>
			</svg>
		)

		if (this.state.sidebar)
			var sidebar = {
				backgroundColor: this.state.sidebar,
			}
		else var sidebar = {}

		var entries = {}

		if (this.state.wall) {
			var wall = {
				backgroundColor: this.state.wall,
			}
			entries.backgroundColor = this.state.wall
		} else var wall = {}

		var separator = {}
		if (this.state.border) {
			var border = {
				borderColor: this.state.border,
			}
			entries.borderColor = this.state.border
			separator.backgroundColor = this.state.border
		} else var border = {}

		if (this.state.sky)
			var sky = {
				background: 'linear-gradient(' + this.state.sky + ', transparent)',
			}
		else var sky = {}

		var m_displayed = []

		if (this.state.ic && this.state.ic != '') {
			u.readAndCall(
				this.state.ic,
				function(url) {
					if (ProfileOpened && ProfileOpened.state && ProfileOpened.state.ic == url) {
						document
							.querySelector('.content-container .footer .page')
							.style.setProperty('background-image', 'url("' + this.state.ic + '")', 'important')
					} else {
						document
							.querySelector('.content-container .footer .page')
							.style.removeProperty('background-image')
					}
				}.bind(this),
			)
		} else {
			document
				.querySelector('.content-container .footer .page')
				.style.removeProperty('background-image')
		}

		var posting = storage.get().posting || ''

		var likes = this.state.l

		if (this.state.u == 'schindler') likes = '🌻'
		else if (this.state.u == 'Leafsman17') likes = '★'
		else if (this.state.u == 'Lily') likes = likes + 539
		else if (u.is_mod(this.state.u)) likes = 'ツ'
		else if (this.state.u == 'coelle') likes = '❤️'
		else if (this.state.u == 'Adrianna') likes = 'No Licks'
		else if (this.state.u == 'Kilo') likes = 'null'
		else if (this.state.u == 'Tuaha') likes = -likes

		var seen = this.state.ul
		if (seen != 'Unknown') {
			if (this.state.u == 'Kilo') seen = 'Getting milk'
			else if (this.state.u == 'Adrianna') seen = 'Lost in space'
			else if (this.state.u == 'Salma') seen = 'inside the pyramids'
		}

		var friend_list = this.state.f
			.slice(0)
			.sort(function(a, b) {
				return a.t - b.t
			})
			.reverse()

		return (
			<div className="profile" style={sky} data-username={this.props.username}>
				<div className="avatar" data-donated={this.state.b}>
					{!is_video(this.state.i) ? (
						<img
							width="160"
							height="160"
							onMouseOver={this.playSound}
							className="profile-image no-select"
							src={profile_picture(this.state.i, true)}
						/>
					) : (
						<Video
							width="160"
							height="160"
							onMouseOver={this.playSound}
							src={profile_picture(this.state.i, true)}
							className="profile-image no-select"
						/>
					)}
					{profile_video_star(this.state.u)}
					<span
						className={
							'likes no-select ' +
							(this.state.pv != '' && /^[0-9]+$/.test(this.state.pv) ? ' bkblue ' : '')
						}
						title={this.state.l}
					>
						{this.state.pv != '' ? this.state.pv : likes}
					</span>
					<span className="username" data-username={this.state.u} data-donated={this.state.b}>
						{this.state.u}{' '}
						<span className="no-select">
							{u.is_mod(this.state.u) ? (
								<small title="This user is a confirmed ADMIN" className="red">
									ADMIN
								</small>
							) : null}
						</span>
						{verified(this.state.u)}
					</span>
					<Box vertical-waterfall className="user-info">
						{this.state.pl &&
							this.state.pl != '' &&
							this.state.pl
								.split('\n')
								.reverse()
								.map(function(item, idx) {
									return <Favicon key={idx} url={item} />
								})}
						<span className="user-id" title="User Number">
							{this.state.ba == 2
								? 'BANNED'
								: this.state.ba == 1
								? 'CLOSED'
								: this.state.pu
								? 'PU'
								: ''}
							#{this.state.id}
						</span>
					</Box>
					<span
						className="status"
						dangerouslySetInnerHTML={{
							__html: u.linkyNoLink(this.state.s),
						}}
					/>
					<div className="separator" style={border} />
				</div>
				<div className="profile-columns">
					<div className={'opponents '} style={sidebar}>
						<div className="arcade" data-username={this.state.u}>
							{rip[this.state.u] ? (
								<span>
									<span className="cblue">✿</span>
									◦.¸.◦
									<span className="cpurple">✿</span> † † <span className="corange">✿</span>
									◦.¸.◦
									<span className="cyellow">✿</span> — {rip[this.state.u]}
									<br />
									<br />
								</span>
							) : (
								''
							)}
							{!seen || seen == 'Unknown' || String(seen).indexOf('.') !== -1 ? null : (
								<span title={u.format_time(seen)}>
									<svg role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512">
										<path
											fill="currentColor"
											d="M256 8C119 8 8 119 8 256s111 248 248 248 248-111 248-248S393 8 256 8zm57.1 350.1L224.9 294c-3.1-2.3-4.9-5.9-4.9-9.7V116c0-6.6 5.4-12 12-12h48c6.6 0 12 5.4 12 12v137.7l63.5 46.2c5.4 3.9 6.5 11.4 2.6 16.8l-28.2 38.8c-3.9 5.3-11.4 6.5-16.8 2.6z"
										/>
									</svg>{' '}
									Last Seen /{' '}
									{!seen || seen == 'Unknown' || String(seen).indexOf('.') !== -1
										? 'Unknown'
										: typeof seen == 'string'
										? this.state.ls != ''
											? this.state.ls
											: seen
										: this.state.ls != ''
										? this.state.ls
										: u.format_time(seen)}
									<br />
								</span>
							)}
							<svg role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 640 512">
								<path
									fill="currentColor"
									d="M624 208h-64v-64c0-8.8-7.2-16-16-16h-32c-8.8 0-16 7.2-16 16v64h-64c-8.8 0-16 7.2-16 16v32c0 8.8 7.2 16 16 16h64v64c0 8.8 7.2 16 16 16h32c8.8 0 16-7.2 16-16v-64h64c8.8 0 16-7.2 16-16v-32c0-8.8-7.2-16-16-16zm-400 48c70.7 0 128-57.3 128-128S294.7 0 224 0 96 57.3 96 128s57.3 128 128 128zm89.6 32h-16.7c-22.2 10.2-46.9 16-72.9 16s-50.6-5.8-72.9-16h-16.7C60.2 288 0 348.2 0 422.4V464c0 26.5 21.5 48 48 48h352c26.5 0 48-21.5 48-48v-41.6c0-74.2-60.2-134.4-134.4-134.4z"
								/>
							</svg>{' '}
							User Since /{' '}
							{!this.state.us || this.state.us == 'Unknown'
								? 'Unknown'
								: u.format_time(this.state.us)}
							<hr style={separator} />
							{window.friend && window.friend && window.friend[this.props.username] ? (
								<div>
									<svg role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 640 512">
										<path
											fill="currentColor"
											d="M624 208h-64v-64c0-8.8-7.2-16-16-16h-32c-8.8 0-16 7.2-16 16v64h-64c-8.8 0-16 7.2-16 16v32c0 8.8 7.2 16 16 16h64v64c0 8.8 7.2 16 16 16h32c8.8 0 16-7.2 16-16v-64h64c8.8 0 16-7.2 16-16v-32c0-8.8-7.2-16-16-16zm-400 48c70.7 0 128-57.3 128-128S294.7 0 224 0 96 57.3 96 128s57.3 128 128 128zm89.6 32h-16.7c-22.2 10.2-46.9 16-72.9 16s-50.6-5.8-72.9-16h-16.7C60.2 288 0 348.2 0 422.4V464c0 26.5 21.5 48 48 48h352c26.5 0 48-21.5 48-48v-41.6c0-74.2-60.2-134.4-134.4-134.4z"
										/>
									</svg>{' '}
									Added / {u.format_time(window.friend[this.props.username])}
									<hr style={separator} />
								</div>
							) : null}
							{window.user && window.user.mod ? (
								<div className="mod buttons block-clear">
									{shield}{' '}
									<span className="link" onClick={this.modTools}>
										Tools
									</span>
									<hr style={separator} />
									<div className="visibility-hover" style={{ display: 'none' }}>
										<div>
											{shield}{' '}
											<span className="link" onClick={this.modTrace}>
												Trace
											</span>
										</div>

										<hr style={separator} />
										<div>
											{shield}{' '}
											<span className="link" onClick={this.modLog}>
												Logs
											</span>
										</div>

										<div>
											{shield}{' '}
											<span className="link" onClick={this.modLogIII}>
												Online
											</span>
										</div>

										<div>
											{shield}{' '}
											<span className="link" onClick={this.modStats}>
												Users
											</span>
										</div>
										<hr style={separator} />
										<div>
											{shield}{' '}
											<span className="link" onClick={this.modSearch}>
												Power Search
											</span>
										</div>
										<hr style={separator} />

										<div>
											{shield}{' '}
											<span className="link" onClick={this.modSendMessageSiteChat}>
												Chat Message To Site
											</span>
										</div>

										<hr style={separator} />
										<div>
											{shield}{' '}
											<span className="link" onClick={this.modDonationToggleDonated}>
												Toggle "STAR"
											</span>
										</div>
										<div>
											{shield}{' '}
											<span className="link" onClick={this.modDonationTogglePU}>
												Toggle "PU"
											</span>
										</div>

										<hr style={separator} />
										<div>
											{shield}{' '}
											<span className="link" onClick={this.modRename}>
												Rename User
											</span>
										</div>
										<hr
											className={'not-self ' + (this.state.u == 'Lame Guest' ? ' hidden' : '')}
											data-self={this.state.u == window.user.username}
											style={separator}
										/>
										<div
											className={'not-self  ' + (this.state.u == 'Lame Guest' ? ' hidden' : '')}
											data-self={this.state.u == window.user.username}
										>
											{shield}{' '}
											<span className="link" onClick={this.modResetPassword}>
												Reset Password
											</span>
										</div>
										<div
											className={'not-self  ' + (this.state.u == 'Lame Guest' ? ' hidden' : '')}
											data-self={this.state.u == window.user.username}
										>
											{shield}{' '}
											<span className="link" onClick={this.modResetProfile}>
												Reset Profile
											</span>
										</div>
										<hr style={separator} />
										<div>
											{shield}{' '}
											<span className="link" onClick={this.modClear}>
												Clear Output
											</span>
										</div>
										<br />
									</div>
								</div>
							) : null}
							{this.state.u != window.user.username ? (
								<div>
									<svg role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 640 512">
										<path
											fill="currentColor"
											d="M624 208h-64v-64c0-8.8-7.2-16-16-16h-32c-8.8 0-16 7.2-16 16v64h-64c-8.8 0-16 7.2-16 16v32c0 8.8 7.2 16 16 16h64v64c0 8.8 7.2 16 16 16h32c8.8 0 16-7.2 16-16v-64h64c8.8 0 16-7.2 16-16v-32c0-8.8-7.2-16-16-16zm-400 48c70.7 0 128-57.3 128-128S294.7 0 224 0 96 57.3 96 128s57.3 128 128 128zm89.6 32h-16.7c-22.2 10.2-46.9 16-72.9 16s-50.6-5.8-72.9-16h-16.7C60.2 288 0 348.2 0 422.4V464c0 26.5 21.5 48 48 48h352c26.5 0 48-21.5 48-48v-41.6c0-74.2-60.2-134.4-134.4-134.4z"
										/>
									</svg>{' '}
									{window.friend && window.friend[this.props.username] ? (
										<span className="link" onClick={this.removeFriend}>
											Remove Friend
										</span>
									) : (
										<span className="link" onClick={this.addFriend}>
											Add Friend
										</span>
									)}
									<hr style={separator} />
									<div>
										<svg role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 640 512">
											<path
												fill="currentColor"
												d="M624 208h-64v-64c0-8.8-7.2-16-16-16h-32c-8.8 0-16 7.2-16 16v64h-64c-8.8 0-16 7.2-16 16v32c0 8.8 7.2 16 16 16h64v64c0 8.8 7.2 16 16 16h32c8.8 0 16-7.2 16-16v-64h64c8.8 0 16-7.2 16-16v-32c0-8.8-7.2-16-16-16zm-400 48c70.7 0 128-57.3 128-128S294.7 0 224 0 96 57.3 96 128s57.3 128 128 128zm89.6 32h-16.7c-22.2 10.2-46.9 16-72.9 16s-50.6-5.8-72.9-16h-16.7C60.2 288 0 348.2 0 422.4V464c0 26.5 21.5 48 48 48h352c26.5 0 48-21.5 48-48v-41.6c0-74.2-60.2-134.4-134.4-134.4z"
											/>
										</svg>{' '}
										{window.user.block && window.user.block[this.props.username] ? (
											<span className="link" onClick={this.unblock}>
												Unblock User
											</span>
										) : (
											<span className="link" onClick={this.block2}>
												Block User
											</span>
										)}
									</div>
									<hr style={separator} />
								</div>
							) : null}
						</div>
						{window.user && this.state.u === window.user.username ? (
							<div className="buttons">
								<svg role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512">
									<path
										fill="currentColor"
										d="M512 144v288c0 26.5-21.5 48-48 48H48c-26.5 0-48-21.5-48-48V144c0-26.5 21.5-48 48-48h88l12.3-32.9c7-18.7 24.9-31.1 44.9-31.1h125.5c20 0 37.9 12.4 44.9 31.1L376 96h88c26.5 0 48 21.5 48 48zM376 288c0-66.2-53.8-120-120-120s-120 53.8-120 120 53.8 120 120 120 120-53.8 120-120zm-32 0c0 48.5-39.5 88-88 88s-88-39.5-88-88 39.5-88 88-88 88 39.5 88 88z"
									/>
								</svg>{' '}
								<a className="link " href="#p/Settings">
									Upload Profile Picture
								</a>
								<hr style={separator} />
								<svg role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512">
									<path
										fill="currentColor"
										d="M504 256c0 136.997-111.043 248-248 248S8 392.997 8 256C8 119.083 119.043 8 256 8s248 111.083 248 248zM262.655 90c-54.497 0-89.255 22.957-116.549 63.758-3.536 5.286-2.353 12.415 2.715 16.258l34.699 26.31c5.205 3.947 12.621 3.008 16.665-2.122 17.864-22.658 30.113-35.797 57.303-35.797 20.429 0 45.698 13.148 45.698 32.958 0 14.976-12.363 22.667-32.534 33.976C247.128 238.528 216 254.941 216 296v4c0 6.627 5.373 12 12 12h56c6.627 0 12-5.373 12-12v-1.333c0-28.462 83.186-29.647 83.186-106.667 0-58.002-60.165-102-116.531-102zM256 338c-25.365 0-46 20.635-46 46 0 25.364 20.635 46 46 46s46-20.636 46-46c0-25.365-20.635-46-46-46z"
									/>
								</svg>{' '}
								<a href="#p/Issues/" className="link">
									I Have A Problem
								</a>
								<hr style={separator} />
								<svg role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 576 512">
									<path
										fill="currentColor"
										d="M416 192c0-88.4-93.1-160-208-160S0 103.6 0 192c0 34.3 14.1 65.9 38 92-13.4 30.2-35.5 54.2-35.8 54.5-2.2 2.3-2.8 5.7-1.5 8.7S4.8 352 8 352c36.6 0 66.9-12.3 88.7-25 32.2 15.7 70.3 25 111.3 25 114.9 0 208-71.6 208-160zm122 220c23.9-26 38-57.7 38-92 0-66.9-53.5-124.2-129.3-148.1.9 6.6 1.3 13.3 1.3 20.1 0 105.9-107.7 192-240 192-10.8 0-21.3-.8-31.7-1.9C207.8 439.6 281.8 480 368 480c41 0 79.1-9.2 111.3-25 21.8 12.7 52.1 25 88.7 25 3.2 0 6.1-1.9 7.3-4.8 1.3-2.9.7-6.3-1.5-8.7-.3-.3-22.4-24.2-35.8-54.5z"
									/>
								</svg>{' '}
								<span className="link " onClick={this.profileClearWall}>
									Delete All My Messages
								</span>
								<hr style={separator} />
								<svg role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 448 512">
									<path
										fill="currentColor"
										d="M0 84V56c0-13.3 10.7-24 24-24h112l9.4-18.7c4-8.2 12.3-13.3 21.4-13.3h114.3c9.1 0 17.4 5.1 21.5 13.3L312 32h112c13.3 0 24 10.7 24 24v28c0 6.6-5.4 12-12 12H12C5.4 96 0 90.6 0 84zm416 56v324c0 26.5-21.5 48-48 48H80c-26.5 0-48-21.5-48-48V140c0-6.6 5.4-12 12-12h360c6.6 0 12 5.4 12 12zm-272 68c0-8.8-7.2-16-16-16s-16 7.2-16 16v224c0 8.8 7.2 16 16 16s16-7.2 16-16V208zm96 0c0-8.8-7.2-16-16-16s-16 7.2-16 16v224c0 8.8 7.2 16 16 16s16-7.2 16-16V208zm96 0c0-8.8-7.2-16-16-16s-16 7.2-16 16v224c0 8.8 7.2 16 16 16s16-7.2 16-16V208z"
									/>
								</svg>{' '}
								<span className="link " onClick={this.profileClearBlock}>
									Clear List Of Users I Blocked
								</span>
								<hr style={separator} />
								<svg role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 448 512">
									<path
										fill="currentColor"
										d="M0 84V56c0-13.3 10.7-24 24-24h112l9.4-18.7c4-8.2 12.3-13.3 21.4-13.3h114.3c9.1 0 17.4 5.1 21.5 13.3L312 32h112c13.3 0 24 10.7 24 24v28c0 6.6-5.4 12-12 12H12C5.4 96 0 90.6 0 84zm416 56v324c0 26.5-21.5 48-48 48H80c-26.5 0-48-21.5-48-48V140c0-6.6 5.4-12 12-12h360c6.6 0 12 5.4 12 12zm-272 68c0-8.8-7.2-16-16-16s-16 7.2-16 16v224c0 8.8 7.2 16 16 16s16-7.2 16-16V208zm96 0c0-8.8-7.2-16-16-16s-16 7.2-16 16v224c0 8.8 7.2 16 16 16s16-7.2 16-16V208zm96 0c0-8.8-7.2-16-16-16s-16 7.2-16 16v224c0 8.8 7.2 16 16 16s16-7.2 16-16V208z"
									/>
								</svg>{' '}
								<span className="link " onClick={this.profileReset}>
									Reset My Profile
								</span>
								<hr style={separator} />
								<svg role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 448 512">
									<path
										fill="currentColor"
										d="M0 84V56c0-13.3 10.7-24 24-24h112l9.4-18.7c4-8.2 12.3-13.3 21.4-13.3h114.3c9.1 0 17.4 5.1 21.5 13.3L312 32h112c13.3 0 24 10.7 24 24v28c0 6.6-5.4 12-12 12H12C5.4 96 0 90.6 0 84zm416 56v324c0 26.5-21.5 48-48 48H80c-26.5 0-48-21.5-48-48V140c0-6.6 5.4-12 12-12h360c6.6 0 12 5.4 12 12zm-272 68c0-8.8-7.2-16-16-16s-16 7.2-16 16v224c0 8.8 7.2 16 16 16s16-7.2 16-16V208zm96 0c0-8.8-7.2-16-16-16s-16 7.2-16 16v224c0 8.8 7.2 16 16 16s16-7.2 16-16V208zm96 0c0-8.8-7.2-16-16-16s-16 7.2-16 16v224c0 8.8 7.2 16 16 16s16-7.2 16-16V208z"
									/>
								</svg>{' '}
								<span className="link " onClick={this.profileResetStats}>
									Reset My Stats
								</span>
								<hr style={separator} />
								<svg role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 448 512">
									<path
										fill="currentColor"
										d="M0 84V56c0-13.3 10.7-24 24-24h112l9.4-18.7c4-8.2 12.3-13.3 21.4-13.3h114.3c9.1 0 17.4 5.1 21.5 13.3L312 32h112c13.3 0 24 10.7 24 24v28c0 6.6-5.4 12-12 12H12C5.4 96 0 90.6 0 84zm416 56v324c0 26.5-21.5 48-48 48H80c-26.5 0-48-21.5-48-48V140c0-6.6 5.4-12 12-12h360c6.6 0 12 5.4 12 12zm-272 68c0-8.8-7.2-16-16-16s-16 7.2-16 16v224c0 8.8 7.2 16 16 16s16-7.2 16-16V208zm96 0c0-8.8-7.2-16-16-16s-16 7.2-16 16v224c0 8.8 7.2 16 16 16s16-7.2 16-16V208zm96 0c0-8.8-7.2-16-16-16s-16 7.2-16 16v224c0 8.8 7.2 16 16 16s16-7.2 16-16V208z"
									/>
								</svg>{' '}
								<span className="opacity" onClick={this.profileClose}>
									Close Account
								</span>
								<hr style={separator} />
							</div>
						) : null}
					</div>

					<div className="entries" style={entries}>
						{window.user && window.user.mod ? (
							<div className="hidden mod-output" onClick={this.modUpdate} />
						) : null}
						<div
							className="thinking"
							dangerouslySetInnerHTML={{
								__html: !this.state.t
									? ''
									: u.linkyNoScroll(this.state.t).replace(/<audio /g, '<audio autoplay loop '),
							}}
						/>
						<TabArea>
							{(!this.state.cw || this.state.ba) && !window.user.mod ? null : (
								<Tab id="wall" title="WALL">
									{this.state.u == 'Lame Guest' ||
									(this.state.g.length == 0 && this.state.u != window.user.username) ? null : (
										<div
											className="gallery-content"
											data-self={window.user && window.user.username == this.state.u}
										>
											{window.user && window.user.username == this.state.u ? (
												<div className="upload l pointer" title="Upload New Photo To Gallery">
													<div onClick={this.askUploadImage}>
														<img
															width="80"
															height="80"
															className="upload-button"
															title="Upload to Gallery"
															src={
																this.state.upload_loading
																	? 'https://omgmobc.com/img/upload.gif?4'
																	: 'https://omgmobc.com/img/upload.png'
															}
														/>
														<input
															type="file"
															className="upload-file"
															onChange={this.doUploadImage}
														/>
													</div>
												</div>
											) : null}
											<Gallery
												u={this.state.u}
												i={this.state.i}
												ic={this.state.ic}
												gallery={this.state.g}
												setData={this.setState.bind(this)}
											/>
											<div className="clear" />
										</div>
									)}

									<div className="post guest-hidden">
										{!is_video(window.user.image) ? (
											<img
												width="45"
												height="45"
												className="profile-image pointer"
												onClick={openProfile}
												data-username={window.user.username}
												src={profile_picture(window.user.image)}
											/>
										) : (
											<img
												width="45"
												height="45"
												className="profile-image pointer"
												onClick={openProfile}
												data-username={window.user.username}
												src={profile_picture(window.user.image).replace(/\.[^\.]+$/, '.png')}
											/>
										)}

										<textarea
											className="message"
											maxLength={window.user.mod ? '30000' : '4000'}
											placeholder={
												'Post a message' +
												(this.state.u == window.user.username ? '…' : ' to ' + this.state.u + '…')
											}
											spellCheck="true"
											defaultValue={posting}
											onChange={this.postingUpdate}
										/>

										<Box
											row
											vertical
											grow
											className="buttons r"
											css="display:flex !important;width:calc(100% - 64px);"
										>
											{!window.user.mod ? null : (
												<Box row grow left>
													{this.state.u.indexOf('Lame Guest') !== 0 && !rip[this.state.u] ? (
														<span
															className="button button-private red not-self"
															onClick={this.postAsMOBC}
														>
															POST AS OMGMOBC.COM
														</span>
													) : null}
												</Box>
											)}
											<RecordMedia type="audio" onStart={this.mediaStart} onStop={this.mediaStop} />
											<RecordMedia type="video" onStart={this.mediaStart} onStop={this.mediaStop} />
											<UploadButton onUpload={this.onUpload} />
											{!this.state.cw || this.state.ba ? null : (
												<span>
													{this.state.u === window.user.username ? (
														<span
															className="button button-public thinking-button"
															onClick={this.postSoapbox}
														>
															soapbox
														</span>
													) : null}
													{this.state.u !== 'omgmobc.com' ? (
														<span
															className="button button-public green not-self"
															data-self={this.state.u === window.user.username}
															onClick={this.post}
														>
															POST PUBLIC
														</span>
													) : null}
													{this.state.u.indexOf('Lame Guest') !== 0 && !rip[this.state.u] ? (
														<span
															className="button button-private red not-self"
															data-self={this.state.u === window.user.username}
															onClick={this.postPrivate}
														>
															POST PRIVATE
														</span>
													) : null}
													{this.state.u === window.user.username ? (
														<span className="button button-public yellow" onClick={this.postOwn}>
															POST IN YOUR OWN WALL
														</span>
													) : null}
												</span>
											)}
										</Box>

										<div className="clear" />
									</div>

									{this.state.m.map(
										function(item, id) {
											var user_color = {
												color: u.readable(item.t) || '',
											}
											var display =
												id >= this.state.p && id <= this.state.p + (this.itemsPerPage - 1)
											if (display) m_displayed[item.d] = true

											return !display ? null : (
												<div key={id} className="entry" data-id={item.d} data-by={item.u}>
													{!is_video(item.i) ? (
														<img
															width="45"
															height="45"
															className="profile-image pointer"
															title={item.u}
															data-username={item.u}
															onClick={openProfile}
															src={profile_picture(item.i)}
														/>
													) : (
														<img
															width="45"
															height="45"
															className="profile-image pointer"
															title={item.u}
															data-username={item.u}
															onClick={openProfile}
															src={profile_picture(item.i).replace(/\.[^\.]+$/, '.png')}
														/>
													)}
													<span className="message">
														<span
															className="text"
															dir={u.isRTL(item.m) ? 'rtl' : 'ltr'}
															dangerouslySetInnerHTML={{
																__html: u.linkyNoScroll(item.m),
															}}
														/>
														<div className="clear" />

														<small className="buttons">
															<span className="white">
																{item.p === 1 ? (
																	<span title="For your eyes only">
																		<svg
																			role="img"
																			xmlns="http://www.w3.org/2000/svg"
																			viewBox="0 0 448 512"
																		>
																			<path
																				fill="currentColor"
																				d="M400 224h-24v-72C376 68.2 307.8 0 224 0S72 68.2 72 152v72H48c-26.5 0-48 21.5-48 48v192c0 26.5 21.5 48 48 48h352c26.5 0 48-21.5 48-48V272c0-26.5-21.5-48-48-48zm-104 0H152v-72c0-39.7 32.3-72 72-72s72 32.3 72 72v72z"
																			/>
																		</svg>{' '}
																		Private Message —{' '}
																	</span>
																) : null}
															</span>{' '}
															by{' '}
															<a
																className="username border-hover no-underline"
																style={user_color}
																href={'#u/' + encodeURIComponent(item.u)}
															>
																{item.u}
															</a>{' '}
															{item.ud ? <img src={u.badge(item.u)} className="donated" /> : null} -{' '}
															<span title={u.date(item.d)}>{u.format_time(item.d)}</span>
															{(this.state.u == window.user.username &&
																item.u != window.user.username) ||
															(window.user.mod && this.state.u == 'omgmobc.com') ? (
																<span
																	className="border-hover guest-hidden button-block"
																	onClick={this.block}
																>
																	/ block user
																</span>
															) : null}{' '}
															{// if in my profile I can delete them all
															this.state.u == window.user.username ||
															//if isnt my profile but is my message
															item.u == window.user.username ||
															// mods watching omgmobc.com profile
															(window.user.mod && this.state.u == 'omgmobc.com') ? (
																<span
																	className="border-hover guest-hidden button-block"
																	onClick={this.remove_all_by}
																>
																	/ delete all
																</span>
															) : null}{' '}
															{this.state.u == window.user.username ||
															item.u == window.user.username ||
															(window.user.mod && this.state.u == 'omgmobc.com') ? (
																<span
																	className="border-hover guest-hidden button-delete"
																	onClick={this.remove}
																>
																	/ delete message
																</span>
															) : null}
														</small>
													</span>
													<div className="clear" />
												</div>
											)
										}.bind(this),
									)}

									{this.state.m.map(
										function(item, id) {
											if (m_displayed[item.d]) return null
											if (u.is_mod(item.u) && !u.is_mod(this.state.u)) {
												return (
													<div key={id} className="entry" data-id={item.d} data-by={item.u}>
														{!is_video(item.i) ? (
															<img
																width="45"
																height="45"
																className="profile-image pointer"
																title={item.u}
																data-username={item.u}
																onClick={openProfile}
																src={profile_picture(item.i)}
															/>
														) : (
															<img
																width="45"
																height="45"
																className="profile-image pointer"
																title={item.u}
																data-username={item.u}
																onClick={openProfile}
																src={profile_picture(item.i).replace(/\.[^\.]+$/, '.png')}
															/>
														)}
														<span className="message">
															<span
																className="text"
																dir={u.isRTL(item.m) ? 'rtl' : 'ltr'}
																dangerouslySetInnerHTML={{
																	__html: u.linkyNoScroll(item.m),
																}}
															/>
															<small className="buttons">
																<span className="white">
																	{item.p === 1 ? (
																		<span title="For your eyes only">
																			<svg
																				role="img"
																				xmlns="http://www.w3.org/2000/svg"
																				viewBox="0 0 448 512"
																			>
																				<path
																					fill="currentColor"
																					d="M400 224h-24v-72C376 68.2 307.8 0 224 0S72 68.2 72 152v72H48c-26.5 0-48 21.5-48 48v192c0 26.5 21.5 48 48 48h352c26.5 0 48-21.5 48-48V272c0-26.5-21.5-48-48-48zm-104 0H152v-72c0-39.7 32.3-72 72-72s72 32.3 72 72v72z"
																				/>
																			</svg>{' '}
																			Private Message —{' '}
																		</span>
																	) : null}
																</span>{' '}
																by{' '}
																<a
																	className="username border-hover no-underline"
																	href={'#u/' + encodeURIComponent(item.u)}
																>
																	{item.u}
																</a>{' '}
																{item.ud ? <img src={u.badge(item.u)} className="donated" /> : null}{' '}
																- <span title={u.date(item.d)}>{u.format_time(item.d)}</span>
																{(this.state.u == window.user.username &&
																	item.u != window.user.username) ||
																(window.user.mod && this.state.u == 'omgmobc.com') ? (
																	<span
																		className="border-hover guest-hidden button-block"
																		onClick={this.block}
																	>
																		/ block user
																	</span>
																) : null}{' '}
																{this.state.u == window.user.username ||
																item.u == window.user.username ||
																(window.user.mod && this.state.u == 'omgmobc.com') ? (
																	<span
																		className="border-hover guest-hidden button-delete"
																		onClick={this.remove}
																	>
																		/ delete message
																	</span>
																) : null}
															</small>
														</span>
														<div className="clear" />
													</div>
												)
											} else {
												return null
											}
										}.bind(this),
									)}

									{this.state.u == 'omgmobc.com' ? this.predefinedMessages() : null}

									<div className="clear" />
									{this.state.m.length ? (
										<div className="arrows">
											{this.state.p - this.itemsPerPage >= 0 ? (
												<span
													className="arrow-left"
													onClick={this.paginateL}
													title="Newer Messages"
												/>
											) : null}
											{this.state.m[this.state.p + this.itemsPerPage] ? (
												<span
													className="arrow-right"
													onClick={this.paginateR}
													title="Older Messages"
												/>
											) : null}
										</div>
									) : null}
								</Tab>
							)}

							{!Object.keys(this.state.a).length ? null : (
								<Tab id="arcade" title="ARCADE">
									<div className="arcade-tab">
										<div>
											<div>
												<img src="https://omgmobc.com/img/icon/pool.png" width="21" height="21" />{' '}
												{this.state.a.pool && this.state.a.pool.games
													? (this.state.a.pool.win / (this.state.a.pool.games / 100)).toFixed(0) +
													  '%'
													: '0%'}{' '}
												/ G{' '}
												{this.state.a.pool && this.state.a.pool.games ? this.state.a.pool.games : 0}{' '}
												/ W {this.state.a.pool && this.state.a.pool.win ? this.state.a.pool.win : 0}{' '}
												/ RT{' '}
												{this.state.a.pool && this.state.a.pool.record
													? this.state.a.pool.record
													: '0:00'}
											</div>
											<div>
												<img src="https://omgmobc.com/img/icon/9ball.png" width="21" height="21" />{' '}
												{this.state.a['9ball'] && this.state.a['9ball'].games
													? (
															this.state.a['9ball'].win /
															(this.state.a['9ball'].games / 100)
													  ).toFixed(0) + '%'
													: '0%'}{' '}
												/ G{' '}
												{this.state.a['9ball'] && this.state.a['9ball'].games
													? this.state.a['9ball'].games
													: 0}{' '}
												/ W{' '}
												{this.state.a['9ball'] && this.state.a['9ball'].win
													? this.state.a['9ball'].win
													: 0}{' '}
												/ RT{' '}
												{this.state.a['9ball'] && this.state.a['9ball'].record
													? this.state.a['9ball'].record
													: '0:00'}
											</div>
											<div>
												<img
													src="https://omgmobc.com/img/icon/swapples.png"
													width="21"
													height="21"
												/>{' '}
												G{' '}
												{this.state.a.swapples && this.state.a.swapples.games
													? this.state.a.swapples.games
													: 0}{' '}
												/ HS{' '}
												{this.state.a.swapples &&
												this.state.a.swapples.score &&
												this.state.a.swapples.score.g
													? this.state.a.swapples.score.g.p
													: 0}
											</div>
											<div className="hidden">
												<img src="https://omgmobc.com/img/icon/poker.png" width="21" height="21" />{' '}
												G{' '}
												{this.state.a.poker && this.state.a.poker.games
													? this.state.a.poker.games
													: 0}{' '}
												/ HS{' '}
												{this.state.a.poker &&
												this.state.a.poker.score &&
												this.state.a.poker.score.g
													? this.state.a.poker.score.g.p
													: 0}
											</div>
											<div>
												<img
													src="https://omgmobc.com/img/icon/dinglepop.png"
													width="21"
													height="21"
												/>{' '}
												{this.state.a.dinglepop && this.state.a.dinglepop.games
													? (
															(this.state.a.dinglepop.cleared
																? this.state.a.dinglepop.cleared
																: 0) /
															(this.state.a.dinglepop.games / 100)
													  ).toFixed(0) + '%'
													: '0%'}{' '}
												/ G{' '}
												{this.state.a.dinglepop && this.state.a.dinglepop.games
													? this.state.a.dinglepop.games
													: 0}{' '}
												/ C{' '}
												{this.state.a.dinglepop && this.state.a.dinglepop.cleared
													? this.state.a.dinglepop.cleared
													: 0}{' '}
												/ I{' '}
												{this.state.a.dinglepop && this.state.a.dinglepop.items
													? this.state.a.dinglepop.items
													: 0}{' '}
												/ D{' '}
												{this.state.a.dinglepop && this.state.a.dinglepop.drops
													? this.state.a.dinglepop.drops
													: 0}
											</div>
											<div>
												<img
													src="https://omgmobc.com/img/icon/blockles.png"
													width="21"
													height="21"
												/>{' '}
												G{' '}
												{this.state.a.blockles && this.state.a.blockles.games
													? this.state.a.blockles.games
													: 0}{' '}
												/ HS{' '}
												{this.state.a.blockles && this.state.a.blockles.score
													? this.state.a.blockles.score
													: 0}
											</div>
											<div>
												<img
													src="https://omgmobc.com/img/icon/blocklesm.png"
													width="21"
													height="21"
												/>{' '}
												{this.state.a.blocklesmulti && this.state.a.blocklesmulti.games
													? (
															(this.state.a.blocklesmulti.win || 0) /
															(this.state.a.blocklesmulti.games / 100)
													  ).toFixed(0) + '%'
													: '0%'}{' '}
												/ G{' '}
												{this.state.a.blocklesmulti && this.state.a.blocklesmulti.games
													? this.state.a.blocklesmulti.games
													: 0}{' '}
												/ W{' '}
												{this.state.a.blocklesmulti && this.state.a.blocklesmulti.win
													? this.state.a.blocklesmulti.win
													: 0}
											</div>
										</div>
										<div>
											<div>
												<img src="https://omgmobc.com/img/icon/tonk3.png" width="21" height="21" />{' '}
												G{' '}
												{this.state.a.tonk3 && this.state.a.tonk3.games
													? this.state.a.tonk3.games
													: 0}
											</div>
											<div>
												<img
													src="https://omgmobc.com/img/icon/gemmers.png"
													width="21"
													height="21"
												/>{' '}
												G{' '}
												{this.state.a.gemmers && this.state.a.gemmers.games
													? this.state.a.gemmers.games
													: 0}{' '}
												/ HS{' '}
												{this.state.a.gemmers && this.state.a.gemmers.score
													? this.state.a.gemmers.score
													: 0}
											</div>
											<div>
												<img
													src="https://omgmobc.com/img/icon/skypigs.png"
													width="21"
													height="21"
												/>{' '}
												G{' '}
												{this.state.a.skypigs && this.state.a.skypigs.games
													? this.state.a.skypigs.games
													: 0}{' '}
												/ Feet{' '}
												{this.state.a.skypigs && this.state.a.skypigs.score
													? this.state.a.skypigs.score
													: 0}
											</div>
											<div>
												<img
													src="https://omgmobc.com/img/icon/balloono.png"
													width="21"
													height="21"
												/>{' '}
												{this.state.a.balloono && this.state.a.balloono.games
													? (
															(this.state.a.balloono.win || 0) /
															(this.state.a.balloono.games / 100)
													  ).toFixed(0) + '%'
													: '0%'}{' '}
												/ G{' '}
												{this.state.a.balloono && this.state.a.balloono.games
													? this.state.a.balloono.games
													: 0}{' '}
												/ W{' '}
												{this.state.a.balloono && this.state.a.balloono.win
													? this.state.a.balloono.win
													: 0}
											</div>
											<div>
												<img
													src="https://omgmobc.com/img/icon/balloonoboot.png"
													width="21"
													height="21"
												/>{' '}
												{this.state.a.balloonoboot && this.state.a.balloonoboot.games
													? (
															(this.state.a.balloonoboot.win || 0) /
															(this.state.a.balloonoboot.games / 100)
													  ).toFixed(0) + '%'
													: '0%'}{' '}
												/ G{' '}
												{this.state.a.balloonoboot && this.state.a.balloonoboot.games
													? this.state.a.balloonoboot.games
													: 0}{' '}
												/ W{' '}
												{this.state.a.balloonoboot && this.state.a.balloonoboot.win
													? this.state.a.balloonoboot.win
													: 0}
											</div>
											<div>
												<img
													src="https://omgmobc.com/img/icon/checkers.png"
													width="21"
													height="21"
												/>{' '}
												{this.state.a.checkers && this.state.a.checkers.games
													? (
															this.state.a.checkers.win /
															(this.state.a.checkers.games / 100)
													  ).toFixed(0) + '%'
													: '0%'}{' '}
												/ G{' '}
												{this.state.a.checkers && this.state.a.checkers.games
													? this.state.a.checkers.games
													: 0}{' '}
												/ W{' '}
												{this.state.a.checkers && this.state.a.checkers.win
													? this.state.a.checkers.win
													: 0}
											</div>
											<div>
												<img src="https://omgmobc.com/img/icon/cuacka.png" width="21" height="21" />{' '}
												G{' '}
												{this.state.a.cuacka && this.state.a.cuacka.games
													? this.state.a.cuacka.games
													: 0}{' '}
												/ HS{' '}
												{this.state.a.cuacka && this.state.a.cuacka.score
													? this.state.a.cuacka.score
													: 0}
											</div>
											<div>
												<img
													src="https://omgmobc.com/img/icon/watchtogether.png"
													width="21"
													height="21"
												/>{' '}
												YT {this.state.a.yt && this.state.a.yt.c ? this.state.a.yt.c : 0}
											</div>
										</div>
									</div>
								</Tab>
							)}
							{this.state.f.length > 0 ? (
								<Tab id="friend" title="FRIENDS">
									<div className="friends">
										<ul>
											{friend_list.map(
												function(item, id) {
													if (item.u === this.state.u) return ''

													return (
														<li
															key={item.u}
															className="pointer"
															style={sidebar}
															onClick={openProfile}
															title={item.u}
															data-username={item.u}
														>
															{!is_video(item.i) ? (
																<img
																	className="image pointer friend-image"
																	src={profile_picture(item.i)}
																/>
															) : (
																<img
																	className="image pointer friend-image"
																	src={profile_picture(item.i).replace(/\.[^\.]+$/, '.png')}
																/>
															)}
															<div className="friend-info">
																<b
																	className="username"
																	style={{ color: u.readable(item.c) || 'white' }}
																>
																	{item.u}
																</b>
																{window.friend &&
																	!window.friend[item.u] &&
																	item.u !== window.user.username && (
																		<div
																			onClick={() => {
																				this.addFriend(item.u)
																			}}
																		>
																			Add friend
																		</div>
																	)}
															</div>
														</li>
													)
												}.bind(this),
											)}
										</ul>
									</div>
								</Tab>
							) : null}
							{this.state.o.length > 0 ? (
								<Tab id="opponent" title="OPPONENTS">
									<div className="friends">
										<ul>
											{this.state.o.map(
												function(item, id) {
													if (item.u === this.state.u) return ''

													return (
														<li
															key={item.u}
															className="pointer"
															style={sidebar}
															onClick={openProfile}
															title={item.u}
															data-username={item.u}
														>
															{!is_video(item.i) ? (
																<img
																	className="image pointer friend-image"
																	src={profile_picture(item.i)}
																/>
															) : (
																<img
																	className="image pointer friend-image"
																	src={profile_picture(item.i).replace(/\.[^\.]+$/, '.png')}
																/>
															)}
															<div className="friend-info">
																<b
																	className="username"
																	style={{ color: u.readable(item.c) || 'white' }}
																>
																	{item.u}
																</b>
																{window.friend &&
																	!window.friend[item.u] &&
																	item.u !== window.user.username && (
																		<div
																			onClick={() => {
																				this.addFriend(item.u)
																			}}
																		>
																			Add friend
																		</div>
																	)}
															</div>
														</li>
													)
												}.bind(this),
											)}
										</ul>
									</div>
								</Tab>
							) : null}
						</TabArea>
					</div>
				</div>
			</div>
		)
	},
	modTools: function() {
		$('.visibility-hover').slideToggle('fast', function() {})
	},
	addFriend: function(e) {
		var username
		if (typeof e == 'string') username = e
		else username = this.props.username

		CONFIRM(
			`Add ${username} as friend?`,
			function() {
				emit({
					id: 'friend',
					f: 'add',
					v: username,
				})
			}.bind(this),
		)
	},
	removeFriend: function(e) {
		var v = $(e.currentTarget.parentNode.parentNode.parentNode).attr('data-id')
		var username = this.props.username

		CONFIRM(
			'Remove Friend?',
			function() {
				emit({
					id: 'friend',
					f: 'remove',
					v: this.props.username,
				})
			}.bind(this),
		)
	},
	askUploadImage: function(e) {
		u.click($('.content-container .footer .page .profile .entries .upload-file').get(0))
	},
	doUploadImage: function() {
		var input = $('.content-container .footer .page .profile .entries .upload-file').get(0)

		var self = this

		function error(message) {
			message = String(message)
			if (message.indexOf('>') !== -1) message = 'The image size is too big'
			self.setState({
				upload_loading: false,
			})
			window.message('error', message)
		}

		if (input.files && input.files[0]) {
			this.setState({
				upload_loading: true,
			})

			var file = input.files[0]
			var formdata = new FormData()
			formdata.append('file', file)
			var ajax = new XMLHttpRequest()
			ajax.addEventListener(
				'load',
				function(e) {
					try {
						var data = String(e.target.responseText)
						if (data.indexOf('https://') === 0) {
							if (this.mounted) {
								self.setState({
									upload_loading: false,
								})
							}
							emit(
								{
									id: 'gallery',
									f: 'up',
									v: data,
								},
								function(d) {
									if (this.mounted)
										this.setState({
											i: d.i,
											ic: d.ic,
											g: d.g,
										})
								}.bind(this),
							)
						} else {
							error(data)
						}
					} catch (e) {
						error('No image selected!')
					}
				}.bind(this),
				false,
			)
			ajax.addEventListener('error', error, false)
			ajax.addEventListener('abort', error, false)
			ajax.open('POST', 'https://omgmobc.com/php/upload.php?action=upload&type=gallery')
			try {
				ajax.send(formdata)
			} catch (e) {
				error('Unable to upload pic, please try later!')
			}
		} else {
			error('No image selected!')
		}
	},
	playSound: function() {
		u.soundWhenTabNotMuted('clink')
	},
	paginateL: function() {
		var p = this.state.p
		p -= this.itemsPerPage
		if (p < 0) p = 0
		this.setState({
			p: p,
		})
		if (!isMobile) {
			$('.content-container .footer .page .profile .post textarea').focus()
		}
	},
	paginateR: function() {
		var p = this.state.p
		p += this.itemsPerPage
		if (!this.state.m[p]) p -= this.itemsPerPage
		if (p < 0) p = 0
		this.setState({
			p: p,
		})
		if (!isMobile) {
			$('.content-container .footer .page .profile .post textarea').focus()
		}
	},
	setData: function(data) {
		if (this.mounted) {
			setTimeout(
				function() {
					if (this.mounted) {
						/*	data.sidebar = !data.sidebar ? '' : data.sidebar
						data.wall = !data.wall ? '' : data.wall
						data.border = !data.border ? '' : data.border
						data.sky = !data.sky ? '' : data.sky
						data.t = !data.t ? '' : data.t
						data.friend = !data.friend ? {} : data.friend*/

						data.p = 0
						if (data.m && typeof data.m === 'string') {
							data.m = uncompress(data.m)
						}
						this.setState(data, function() {})
					}
				}.bind(this),
				0,
			)
		}
	},
	remove: function(e) {
		var v = $(e.currentTarget.parentNode.parentNode.parentNode).attr('data-id')
		var username = this.props.username

		if (window.user.username == this.props.username) {
			emit(
				{
					id: 'profile remove',
					u: username,
					v: v,
				},
				function(data) {
					this.setData(data) // ok
				}.bind(this),
			)
		} else {
			CONFIRM(
				'Are you sure!?, theres no undo',
				function() {
					emit({
						id: 'profile remove',
						u: username,
						v: v,
					})
				}.bind(this),
			)
		}
	},
	remove_all_by: function(e) {
		var v = $(e.currentTarget.parentNode.parentNode.parentNode).attr('data-id')
		var username = this.props.username

		CONFIRM(
			'Are you sure you want to delete all messages!?, theres no undo',
			function() {
				emit({
					id: 'profile remove all by',
					u: username,
					v: v,
				})
			}.bind(this),
		)
	},
	block: function(e) {
		var v = $(e.currentTarget.parentNode.parentNode.parentNode).attr('data-id')
		var username = this.props.username

		CONFIRM(
			'Are you sure!?, theres no undo',
			function() {
				emit({
					id: 'profile remove block',
					u: username,
					v: v,
				})
			}.bind(this),
		)
	},
	block2: function() {
		emit({ id: 'profile block', f: 'add', v: this.props.username }, data => {
			window.user.block = data.block
			if (this.mounted) this.setState({ nada: !this.state.nada })
		})
	},
	unblock: function() {
		emit({ id: 'profile block', f: 'remove', v: this.props.username }, data => {
			window.user.block = data.block
			if (this.mounted) this.setState({ nada: !this.state.nada })
		})
	},
	profileClearWall: function(e) {
		var username = this.props.username
		CONFIRM(
			'Are you sure!?, theres no undo',
			function() {
				emit({
					id: 'profile clear wall',
					u: username,
				})
			}.bind(this),
		)
	},
	profileClearBlock: function(e) {
		var username = this.props.username
		CONFIRM(
			'Are you sure!?, theres no undo',
			function() {
				emit({
					id: 'profile clear blocklist',
					u: username,
				})
			}.bind(this),
		)
	},

	profileClose: function(e) {
		var username = this.props.username
		CONFIRM(
			'Are you sure!?, theres no undo',
			function() {
				var yes = prompt(
					'You sure? We dont have undo for this and all data is erased but your username and email. Type "yes" if you want to close the account. If you want to reopen the account then do a "forgot password".',
					'',
				)
				if (yes && yes === 'yes') {
					emit({
						id: 'user close profile',
						u: username,
					})
				}
			}.bind(this),
		)
	},
	profileReset: function(e) {
		CONFIRM(
			'Are you sure!?, theres no undo for this',
			function() {
				emit({
					id: 'user reset profile',
				})
			}.bind(this),
		)
	},
	profileResetStats: function(e) {
		CONFIRM(
			'Are you sure!?, theres no undo for this',
			function() {
				emit({
					id: 'user reset stats',
				})
			}.bind(this),
		)
	},
	postingUpdate: function() {
		storage.update({
			posting: $('.content-container .footer .page .profile .post textarea').val(),
		})
	},
	post: function(e) {
		var v = $('.content-container .footer .page .profile .post textarea').val()
		$('.content-container .footer .page .profile .post textarea').val('')
		storage.update({
			posting: '',
		})
		if (v.trim() != '') {
			emit(
				{
					id: 'profile post',
					u: this.props.username,
					v: v.substr(0, window.user.mod ? 30000 : 4000),
				},
				function(data) {
					this.setData(data) /// ok
				}.bind(this),
			)
		}
	},
	postOwn: function(e) {
		var v = $('.content-container .footer .page .profile .post textarea').val()
		var username = this.props.username
		CONFIRM(
			'You sure you want to post on your own wall?',
			function() {
				storage.update({
					posting: '',
				})
				if (v.trim() != '') {
					emit({
						id: 'profile post',
						u: username,
						v: v.substr(0, window.user.mod ? 30000 : 4000),
					})
				}
			}.bind(this),
		)
	},
	postSoapbox: function(e) {
		var v = $('.content-container .footer .page .profile .post textarea')
			.val()
			.substr(0, window.user.mod ? 30000 : 4000)
		$('.content-container .footer .page .profile .post textarea').val('')

		var username = this.props.username

		storage.update({
			posting: '',
		})

		emit(
			{
				id: 'profile post soapbox',
				u: username,
				v: v,
			},
			function() {
				if (this.mounted) this.setState({ t: v })
			}.bind(this),
		)
	},
	postPrivate: function(e) {
		var v = $('.content-container .footer .page .profile .post textarea').val()
		$('.content-container .footer .page .profile .post textarea').val('')
		storage.update({
			posting: '',
		})
		if (v.trim() != '') {
			emit(
				{
					id: 'profile post',
					u: this.props.username,
					v: v.substr(0, window.user.mod ? 30000 : 4000),
					p: true,
				},
				function(data) {
					this.setData(data)
				}.bind(this),
			)
		}
	},
	postAsMOBC: function(e) {
		var v = $('.content-container .footer .page .profile .post textarea').val()
		$('.content-container .footer .page .profile .post textarea').val('')
		storage.update({
			posting: '',
		})
		if (v.trim() != '') {
			emit(
				{
					id: 'profile post as mobc',
					u: this.props.username,
					v: v.substr(0, window.user.mod ? 30000 : 4000),
					p: true,
				},
				function(data) {
					this.setData(data)
				}.bind(this),
			)
		}
	},
	modResetProfile: function() {
		var username = this.props.username

		if (confirm('RESET PROFILE FOR "' + this.props.username + '" !?')) {
			emit({
				id: 'profile reset profile',
				u: username,
			})
		}
	},

	modResetPassword: function() {
		var username = this.props.username
		if (confirm('RESET PASSWORD FOR "' + this.props.username + '" !?')) {
			emit({
				id: 'profile reset password',
				u: username,
			})
		}
	},
	modRename: function() {
		var v = prompt('New Username for "' + this.props.username + '"', this.props.username)
		if (v && v != '' && confirm('RENAME FOR "' + this.props.username + '" to "' + v + '" !?')) {
			emit(
				{
					id: 'profile rename',
					u: this.props.username,
					to: v,
				},
				function(u) {
					if (u) {
						location.replace('#u/' + encodeURIComponent(u))
					}
				}.bind(this),
			)
		}
	},

	modSendMessageSiteChat: function() {
		var v = prompt('Send Message To Complete Site on Chat', '')
		if (v && v != '' && String(v).trim() != '') {
			emit({
				id: 'mod send message site chat',
				v: v,
			})
		}
	},

	modDonationToggleDonated: function() {
		var username = this.props.username
		if (confirm('Toggle donor on "' + this.props.username + '" ?')) {
			emit({
				id: 'mod donation toggle',
				u: username,
			})
		}
	},
	modDonationTogglePU: function() {
		var username = this.props.username
		if (confirm('Toggle PU On "' + this.props.username + '"!?')) {
			emit({
				id: 'mod pu toggle',
				u: username,
			})
		}
	},

	modUpdate: function(e) {
		if (
			e.target.tagName === 'INPUT' &&
			(!$(e.target).attr('placeholder') || $(e.target).attr('placeholder') == '')
		) {
			if (confirm('You Sure!?')) {
				$(
					'input[type="checkbox"][data-name="' +
						u.escape($(e.target).attr('data-name')) +
						'"][data-value="' +
						u.escape($(e.target).attr('data-value')) +
						'"]',
				).prop('checked', $(e.target).prop('checked'))
				if ($(e.target).prop('checked'))
					$(
						'input[type="checkbox"][data-name="' +
							u.escape($(e.target).attr('data-name')) +
							'"][data-value="' +
							u.escape($(e.target).attr('data-value')) +
							'"]',
					)
						.parent()
						.addClass('selected')
				else
					$(
						'input[type="checkbox"][data-name="' +
							u.escape($(e.target).attr('data-name')) +
							'"][data-value="' +
							u.escape($(e.target).attr('data-value')) +
							'"]',
					)
						.parent()
						.removeClass('selected')

				emit({
					id: 'mod update',
					n: $(e.target).attr('data-name'),
					v: $(e.target).attr('data-value'),
					o: $(e.target).prop('checked'),
					u: this.props.username,
				})
			} else {
				e.preventDefault()
				e.stopPropagation()
			}
		} else if (e.target.tagName === 'SPAN' && $(e.target).attr('data-username')) {
			openProfile({
				currentTarget: e.target,
			})
		}
	},

	modClear: function() {
		$('.content-container .footer .page .profile .mod-output').html('')
	},

	modLog: function() {
		emit(
			{
				id: 'mod log',
				u: this.props.username,
			},
			function(title, data) {
				$('.content-container .footer .page .profile .mod-output').html(
					title +
						data
							.reverse()
							.join('\n')
							.replace(/>20[0-9][0-9]\./g, '>')
							.replace(/<div><br>• BLOCKED/g, '<div>• BLOCKED'),
				)
				this.scroll()
			}.bind(this),
		)
	},

	modLogIII: function() {
		emit(
			{
				id: 'mod log iii',
			},
			function(data) {
				$('.content-container .footer .page .profile .mod-output').html(
					data.replace(/>20[0-9][0-9]\./g, '>'),
				)
				this.scroll()
			}.bind(this),
		)
	},

	modTrace: function(e) {
		emit(
			{
				id: 'mod trace',
				u: this.props.username,
			},
			function(data) {
				$('.content-container .footer .page .profile .mod-output').html(
					data.replace(/>20[0-9][0-9]\./g, '>'),
				)
				this.scroll()
			}.bind(this),
		)
	},
	modStats: function(e) {
		emit(
			{
				id: 'mod stats',
				u: this.props.username,
			},
			function(data) {
				$('.content-container .footer .page .profile .mod-output').html(
					data.replace(/>20[0-9][0-9]\./g, '>'),
				)
				this.scroll()
			}.bind(this),
		)
	},
	modSearch: function() {
		var v = prompt('Search For (IP, Username, Email, etc)', '')
		if (v && v != '' && String(v).trim() != '') {
			emit(
				{
					id: 'mod search',
					v: v,
				},
				function(data) {
					$('.content-container .footer .page .profile .mod-output').html(
						data.replace(/>20[0-9][0-9]\./g, '>'),
					)
					this.scroll()
				}.bind(this),
			)
		}
	},

	componentDidMount: function() {
		this.mounted = true

		this.doUpdate()
	},
	componentDidUpdate: function() {
		this.doUpdate()

		this.scroll()
	},
	doUpdate: function() {
		if (window.openedProfile != this.props.username) {
			profileOpenCount++
			if (profileOpenCount > 400) {
				location.hash = ''
				location.reload(true)
			}
			window.openedProfile = this.props.username
			this.setData(this.defaultState())
			emit(
				{
					id: 'profile',
					u: this.props.username,
				},
				function(data) {
					if (this.mounted) {
						if (
							data.u.indexOf('Lame Guest') !== 0 &&
							this.props.username != data.u &&
							this.props.username.toLowerCase() == data.u.toLowerCase()
						) {
							if (location.hash.toLowerCase() == '#u/' + data.u.toLowerCase()) {
								location.replace('#u/' + encodeURIComponent(data.u))
							} else {
								location.hash = 'u/' + encodeURIComponent(data.u)
							}
						} else {
							location.hash = 'u/' + encodeURIComponent(data.u)
						}

						this.setData(data)
						this.scroll()
					}
				}.bind(this),
			)
		}
	},
	scroll: function() {
		if (
			!$('.content-container .footer .page .profile .mod-output').length ||
			$('.content-container .footer .page .profile .mod-output:empty').length
		) {
			if (!isMobile) {
				$('.content-container .footer .page .profile .post textarea').focus()
			}
		}
		$('.content-container .footer .page').animate(
			{
				scrollTop: 0,
			},
			0,
		)
	},
	componentWillUnmount: function() {
		this.mounted = false

		window.openedProfile = ''
		document
			.querySelector('.content-container .footer .page')
			.style.removeProperty('background-image')
		ProfileOpened = false
	},

	predefinedMessages: function() {
		return (
			<div>
				<div className="entry">
					<img
						width="45"
						height="45"
						className="profile-image pointer"
						title="omgmobc.com"
						data-username="omgmobc.com"
						src="https://omgmobc.com/img/profile.png"
					/>
					<span className="message">
						<span className="text" dir="ltr">
							<b>
								HOW DO I BECOME A{' '}
								<img className="star" src="https://omgmobc.com/img/badge/star-big.png" /> MEMBER
							</b>
							<br />
							<br />
							Check this page. <a href="#p/Contribute">#p/Contribute</a>
							<br />
						</span>
						<small className="buttons">
							{' '}
							by{' '}
							<a className="username border-hover no-underline" href="#u/omgmobc.com">
								omgmobc.com
							</a>
						</small>
					</span>
					<div className="clear" />
				</div>
				<div className="entry">
					<img
						width="45"
						height="45"
						className="profile-image pointer"
						title="omgmobc.com"
						data-username="omgmobc.com"
						src="https://omgmobc.com/img/profile.png"
					/>
					<span className="message">
						<span className="text" dir="ltr">
							<b>I DON'T HAVE A PAYPAL ACCOUNT. CAN I STILL DONATE?</b>
							<br />
							<br />
							Yes please write to us here explaining that you wish to get STAR but don't have a
							paypal account.
							<br />
						</span>
						<small className="buttons">
							{' '}
							by{' '}
							<a className="username border-hover no-underline" href="#u/omgmobc.com">
								omgmobc.com
							</a>
						</small>
					</span>
					<div className="clear" />
				</div>
				<div className="entry">
					<img
						width="45"
						height="45"
						className="profile-image pointer"
						title="omgmobc.com"
						data-username="omgmobc.com"
						src="https://omgmobc.com/img/profile.png"
					/>
					<span className="message">
						<span className="text" dir="ltr">
							<b>I ACCIDENTALLY CLOSED MY PROFILE. CAN YOU BRING IT BACK?</b>
							<br />
							<br />
							You can get the account back by doing "forgot password".
							<br />
						</span>
						<small className="buttons">
							{' '}
							by{' '}
							<a className="username border-hover no-underline" href="#u/omgmobc.com">
								omgmobc.com
							</a>
						</small>
					</span>
					<div className="clear" />
				</div>
				<div className="entry">
					<img
						width="45"
						height="45"
						className="profile-image pointer"
						title="omgmobc.com"
						data-username="omgmobc.com"
						src="https://omgmobc.com/img/profile.png"
					/>
					<span className="message">
						<span className="text" dir="ltr">
							<b>I ACCIDENTALLY RESET MY STATS/PROFILE. CAN YOU PLEASE UNDO IT?</b>
							<br />
							<br />
							Unfortunately, no. All the data has been erased permanently.
							<br />
						</span>
						<small className="buttons">
							{' '}
							by{' '}
							<a className="username border-hover no-underline" href="#u/omgmobc.com">
								omgmobc.com
							</a>
						</small>
					</span>
					<div className="clear" />
				</div>
				<div className="entry">
					<img
						width="45"
						height="45"
						className="profile-image pointer"
						title="omgmobc.com"
						data-username="omgmobc.com"
						src="https://omgmobc.com/img/profile.png"
					/>
					<span className="message">
						<span className="text" dir="ltr">
							<b>HOW DO I CHANGE MY USERNAME?</b>
							<br />
							<br />
							We can change your username, read here{' '}
							<a className="username border-hover no-underline" href="#p/Contribute">
								#p/Contribute
							</a>
							.<br />
						</span>
						<small className="buttons">
							{' '}
							by{' '}
							<a className="username border-hover no-underline" href="#u/omgmobc.com">
								omgmobc.com
							</a>
						</small>
					</span>
					<div className="clear" />
				</div>
				<div className="entry">
					<img
						width="45"
						height="45"
						className="profile-image pointer"
						title="omgmobc.com"
						data-username="omgmobc.com"
						src="https://omgmobc.com/img/profile.png"
					/>
					<span className="message">
						<span className="text" dir="ltr">
							<b>HOW DO I BECOME PU?</b>
							<br />
							<br />
							We've stopped giving out PU. Please do not ask for PU.
							<br />
						</span>
						<small className="buttons">
							{' '}
							by{' '}
							<a className="username border-hover no-underline" href="#u/omgmobc.com">
								omgmobc.com
							</a>
						</small>
					</span>
					<div className="clear" />
				</div>
				<div className="entry">
					<img
						width="45"
						height="45"
						className="profile-image pointer"
						title="omgmobc.com"
						data-username="omgmobc.com"
						src="https://omgmobc.com/img/profile.png"
					/>
					<span className="message">
						<span className="text" dir="ltr">
							<b>HOW DO I BLOCK SOMEONE?</b>
							<br />
							<br />
							Go to their profile and press "Block user"
							<br />
						</span>
						<small className="buttons">
							{' '}
							by{' '}
							<a className="username border-hover no-underline" href="#u/omgmobc.com">
								omgmobc.com
							</a>
						</small>
					</span>
					<div className="clear" />
				</div>
				<div className="entry">
					<img
						width="45"
						height="45"
						className="profile-image pointer"
						title="omgmobc.com"
						data-username="omgmobc.com"
						src="https://omgmobc.com/img/profile.png"
					/>
					<span className="message">
						<span className="text" dir="ltr">
							<b>HOW DO I UNBLOCK SOMEONE?</b>
							<br />
							<br />
							Go to their profile and press "Unblock user"
							<br />
						</span>
						<small className="buttons">
							{' '}
							by{' '}
							<a className="username border-hover no-underline" href="#u/omgmobc.com">
								omgmobc.com
							</a>
						</small>
					</span>
					<div className="clear" />
				</div>
			</div>
		)
	},
})
