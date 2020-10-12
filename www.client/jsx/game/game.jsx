var Game = React.createClass({
	mixins: [React.addons.PureRenderMixin],

	getInitialState: function() {
		var o = storage.get()
		body.attr('data-theme', o.theme ? o.theme : 'white')
		ios.on(
			'disconnect',
			function(reason, a, b) {
				this.setState({
					rooms: [],
				})
			}.bind(this),
		)
		ios.on(
			'a',
			function(data) {
				switch (data.id) {
					case 'rooms': {
						window.rooms = u.toArray(uncompress(data.rooms))
						this.setState({
							rooms: window.rooms,
						})
						break
					}
					case 'room switch to': {
						if (window.room && window.room.id) {
						}
						break
					}
					case 'embed': {
						if (window.embed && window.embed[data.f]) {
							/*if (document.hidden) window.embed[data.f](data.d)
							else {
								requestAnimationFrame(function() {*/
							window.embed[data.f](data.d)
							/*})
							}*/
						}
						break
					}
					case 'embedUser': {
						if (data.p == window.user.username && window.embed && window.embed[data.f]) {
							/*if (document.hidden) window.embed[data.f](data)
							else {
								requestAnimationFrame(function() {*/
							window.embed[data.f](data)
							/*})
							}*/
						}
						break
					}
				}
			}.bind(this),
		)
		return {
			rooms: [],
			qp: {
				swapples: [],
				loonobum: [],
				poker: [],
				pool: [],
				watchtogether: [],
				bubblesni: [],
				'9ball': [],
				balloono: [],
				balloonoboot: [],
				skypigs: [],
				blocklesmulti: [],
				tonk3: [],
				cuacka: [],
				bubbles: [],
				blockles: [],
				dinglepop: [],
				gemmers: [],
				checkers: [],
			},
		}
	},
	render: function() {
		var games = [
			['swapples', 'swapples', 'swapples.jpg', 'Fast Swap'],
			//['loonobum', 'loonobum', 'loonobum.jpg', 'LOONOBUM'],
			//['poker', 'poker', 'poker.jpg', 'POKER'],
			['pool', 'pool', 'pool.jpg', 'Pool'],
			['watchtogether', 'watchtogether', 'watchtogether.jpg', 'Youtube'],
			['bubblesni', 'bubbles', 'dinglepop.jpg', 'Dinglepoop NI'],
			['9ball', '9ball', '9ball.jpg', '9 Ball'],
			['balloono', 'balloono', 'balloono.jpg?', 'Balloono'],
			['balloonoboot', 'balloonoboot', 'balloonoboot2.jpg?', 'Boot'],
			['skypigs', 'skypigs', 'skypigs.jpg', 'Bacon'],
			['blocklesmulti', 'blockles', 'blockles.jpg', 'Blockles M'],
			['tonk3', 'tonk3', 'tonk3.jpg', 'Tonk'],
			['cuacka', 'cuacka', 'cuacka.jpg', 'Quacka'],
			['bubbles', 'bubbles', 'dinglepop.jpg', 'Dinglepoop M'],
			['blockles', 'blockles', 'blockles.jpg', 'Blockles'],
			['dinglepop', 'dinglepop', 'dinglepop.jpg', 'Dinglepoop'],
			['gemmers', 'gemmers', 'gemmers.jpg', 'Clickets'],
			['checkers', 'checkers', 'checkers.jpg', 'Checkers'],
		]

		if (this.props.room && this.props.room.game) {
			u._title_original = u.capital(this.props.room.game)
			u.title()
		} else {
			u._title_original = 'Lobby'
			u.title()
		}
		return (
			<div className="game-container">
				{this.props.room && this.props.room.game ? (
					<div className="game">
						<Box className="toolbar break clear flex flex-row " wrap vertical-waterfall>
							<Box grow wrap text-crop>
								<Box text-crop>
									<span
										title="Click To Toggle Public/Private Status"
										className="pointer"
										onClick={this.room_toggle_private}
									>
										{this.props.room.private ? 'Private' : 'Public'}
									</span>{' '}
									/ <b>{this.props.room.creator}</b> / #{this.props.room.round.id} /{' '}
									<Editable
										className="name"
										html={this.props.room.name.replace(/#name#/g, window.room.users[0].username)}
										title="Click To Edit Match Name"
										onChange={this.room_set_name}
									/>
								</Box>
							</Box>
							<Box element="small" wrap vertical-waterfall uppercase>
								<a
									className="pointer underline-hover white no-underline corange"
									href="#p/Tournaments"
								>
									<b>Tournaments</b>
								</a>{' '}
								|{' '}
								<a className="pointer underline-hover white no-underline" href="#u/omgmobc.com">
									contact
								</a>{' '}
								|{' '}
								<a className="pointer underline-hover white no-underline" href="#p/Issues">
									Issues
								</a>{' '}
								|{' '}
								<a className="pointer underline-hover white no-underline" href="#p/Emoji">
									emoji
								</a>
								|{' '}
								<a
									className="pointer buttouttoutton-ranking no-select white no-underline guest-hidden"
									href="#p/Contribute"
									title="Help pay for stuff"
								>
									{' '}
									<img alt="🖼" className="star" src="https://omgmobc.com/img/badge/star-big.png" />
								</a>{' '}
								|
								<a
									className="pointer button-ranking no-select white no-underline guest-hidden"
									title="Game Rankings"
									href="#p/Ranking"
								>
									{' '}
									<img alt="🖼" src="img/medals/gold.png?1" className="ranking" />
								</a>{' '}
								|{' '}
								<i className="button-change-game no-italic pointer relative hidden creator host mod pu">
									<svg
										aria-hidden="true"
										data-prefix="fas"
										data-icon="gamepad"
										role="img"
										xmlns="http://www.w3.org/2000/svg"
										viewBox="0 0 640 512"
									>
										<path
											fill="currentColor"
											d="M480 96H160C71.6 96 0 167.6 0 256s71.6 160 160 160c44.8 0 85.2-18.4 114.2-48h91.5c29 29.6 69.5 48 114.2 48 88.4 0 160-71.6 160-160S568.4 96 480 96zM256 276c0 6.6-5.4 12-12 12h-52v52c0 6.6-5.4 12-12 12h-40c-6.6 0-12-5.4-12-12v-52H76c-6.6 0-12-5.4-12-12v-40c0-6.6 5.4-12 12-12h52v-52c0-6.6 5.4-12 12-12h40c6.6 0 12 5.4 12 12v52h52c6.6 0 12 5.4 12 12v40zm184 68c-26.5 0-48-21.5-48-48s21.5-48 48-48 48 21.5 48 48-21.5 48-48 48zm80-80c-26.5 0-48-21.5-48-48s21.5-48 48-48 48 21.5 48 48-21.5 48-48 48z"
										/>
									</svg>{' '}
									<div className="font selector">
										<div
											className="to-game"
											onClick={this.room_switch_to}
											data-game="pool"
											title="Play Pool"
										>
											<img
												alt="🖼"
												src="https://omgmobc.com/img/icon/pool.png"
												width="21"
												height="21"
											/>{' '}
											Pool
										</div>
										<div
											className="to-game"
											onClick={this.room_switch_to}
											data-game="swapples"
											title="Play Swapples"
										>
											<img
												alt="🖼"
												src="https://omgmobc.com/img/icon/swapples.png"
												width="21"
												height="21"
											/>{' '}
											Swapples
										</div>
										<div
											className="to-game hidden"
											onClick={this.room_switch_to}
											data-game="loonobum"
											title="Play Loonobum"
										>
											<img
												alt="🖼"
												src="https://omgmobc.com/img/icon/loonobum.png"
												width="21"
												height="21"
											/>{' '}
											Loonobum
										</div>

										<div
											className="to-game"
											onClick={this.room_switch_to}
											data-game="blockles"
											title="Play Blockles"
										>
											<img
												alt="🖼"
												src="https://omgmobc.com/img/icon/blockles.png"
												width="21"
												height="21"
											/>{' '}
											Blockles
										</div>
										<div
											className="to-game"
											onClick={this.room_switch_to}
											data-game="blocklesmulti"
											title="Play Blockles Multiplayer"
										>
											<img
												alt="🖼"
												src="https://omgmobc.com/img/icon/blocklesm.png"
												width="21"
												height="21"
											/>{' '}
											Blockles M
										</div>
										<div
											className="to-game"
											onClick={this.room_switch_to}
											data-game="bubbles"
											title="Play Bubbles"
										>
											<img
												alt="🖼"
												src="https://omgmobc.com/img/icon/dinglepop.png"
												width="21"
												height="21"
											/>{' '}
											Dingle M
										</div>
										<div
											className="to-game"
											onClick={this.room_switch_to}
											data-game="bubblesni"
											title="Play Bubbles No items"
										>
											<img
												alt="🖼"
												src="https://omgmobc.com/img/icon/dinglepopni.png"
												width="21"
												height="21"
											/>{' '}
											Dingle NI
										</div>
										<div
											className="to-game"
											onClick={this.room_switch_to}
											data-game="dinglepop"
											title="Play Bubbla"
										>
											<img
												alt="🖼"
												src="https://omgmobc.com/img/icon/dinglepop.png"
												width="21"
												height="21"
											/>{' '}
											Dingle
										</div>
										<div
											className="to-game"
											onClick={this.room_switch_to}
											data-game="tonk3"
											title="Play Tonk"
										>
											<img
												alt="🖼"
												src="https://omgmobc.com/img/icon/tonk3.png"
												width="21"
												height="21"
											/>{' '}
											Tonk
										</div>
										<div
											className="to-game"
											onClick={this.room_switch_to}
											data-game="9ball"
											title="Play 9ball"
										>
											<img
												alt="🖼"
												src="https://omgmobc.com/img/icon/9ball.png"
												width="21"
												height="21"
											/>{' '}
											9 Ball
										</div>
										<div
											className="to-game"
											onClick={this.room_switch_to}
											data-game="skypigs"
											title="Play Skypigs"
										>
											<img
												alt="🖼"
												src="https://omgmobc.com/img/icon/skypigs.png"
												width="21"
												height="21"
											/>{' '}
											Skypigs
										</div>
										<div
											className="to-game"
											onClick={this.room_switch_to}
											data-game="gemmers"
											title="Play Gemmers"
										>
											<img
												alt="🖼"
												src="https://omgmobc.com/img/icon/gemmers.png"
												width="21"
												height="21"
											/>{' '}
											Gemmers
										</div>
										<div
											className="to-game"
											onClick={this.room_switch_to}
											data-game="balloono"
											title="Play Balloono"
										>
											<img
												alt="🖼"
												src="https://omgmobc.com/img/icon/balloono.png"
												width="21"
												height="21"
											/>{' '}
											Balloono CLS
										</div>
										<div
											className="to-game"
											onClick={this.room_switch_to}
											data-game="balloonoboot"
											title="Play Balloono Boot"
										>
											<img
												alt="🖼"
												src="https://omgmobc.com/img/icon/balloonoboot.png"
												width="21"
												height="21"
											/>{' '}
											Balloono Boot
										</div>
										<div
											className="to-game"
											onClick={this.room_switch_to}
											data-game="checkers"
											title="Play Checkers"
										>
											<img
												alt="🖼"
												src="https://omgmobc.com/img/icon/checkers.png"
												width="21"
												height="21"
											/>{' '}
											Checkers
										</div>
										<div
											className="to-game"
											onClick={this.room_switch_to}
											data-game="watchtogether"
											title="Watch Together"
										>
											<img
												alt="🖼"
												src="https://omgmobc.com/img/icon/watchtogether.png"
												width="21"
												height="21"
											/>{' '}
											YTogether
										</div>
										<div
											className="to-game"
											onClick={this.room_switch_to}
											data-game="cuacka"
											title="Play Cuacka"
										>
											<img
												alt="🖼"
												src="https://omgmobc.com/img/icon/cuacka.png"
												width="21"
												height="21"
											/>{' '}
											Cuacka
										</div>
										<div
											className="to-game hidden"
											onClick={this.room_switch_to}
											data-game="poker"
											title="Play Poker"
										>
											<img
												alt="🖼"
												src="https://omgmobc.com/img/icon/poker.png"
												width="21"
												height="21"
											/>{' '}
											Poker
										</div>
									</div>
								</i>{' '}
								<span
									className={
										'pointer button-rotate button-rotate-opponent no-select hidden host creator mod ' +
										(window.room.started &&
										(window.room.users[0].username == window.user.username ||
											(window.room.users[1] &&
												window.room.users[1].username == window.user.username))
											? ' hidden '
											: '')
									}
									onClick={this.room_rotate_opponent}
								>
									<svg role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512">
										<path
											fill="currentColor"
											d="M212.333 224.333H12c-6.627 0-12-5.373-12-12V12C0 5.373 5.373 0 12 0h48c6.627 0 12 5.373 12 12v78.112C117.773 39.279 184.26 7.47 258.175 8.007c136.906.994 246.448 111.623 246.157 248.532C504.041 393.258 393.12 504 256.333 504c-64.089 0-122.496-24.313-166.51-64.215-5.099-4.622-5.334-12.554-.467-17.42l33.967-33.967c4.474-4.474 11.662-4.717 16.401-.525C170.76 415.336 211.58 432 256.333 432c97.268 0 176-78.716 176-176 0-97.267-78.716-176-176-176-58.496 0-110.28 28.476-142.274 72.333h98.274c6.627 0 12 5.373 12 12v48c0 6.627-5.373 12-12 12z"
										/>
									</svg>{' '}
									Opp. |{' '}
								</span>{' '}
								<span
									className={
										'pointer button-rotate no-select ' +
										(window.room.started &&
										window.room.game != 'watchtogether' &&
										(window.room.users[0].username == window.user.username ||
											(window.room.users[1] &&
												window.room.users[1].username == window.user.username))
											? ' hidden '
											: '')
									}
									onClick={this.room_rotate}
								>
									<svg role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512">
										<path
											fill="currentColor"
											d="M212.333 224.333H12c-6.627 0-12-5.373-12-12V12C0 5.373 5.373 0 12 0h48c6.627 0 12 5.373 12 12v78.112C117.773 39.279 184.26 7.47 258.175 8.007c136.906.994 246.448 111.623 246.157 248.532C504.041 393.258 393.12 504 256.333 504c-64.089 0-122.496-24.313-166.51-64.215-5.099-4.622-5.334-12.554-.467-17.42l33.967-33.967c4.474-4.474 11.662-4.717 16.401-.525C170.76 415.336 211.58 432 256.333 432c97.268 0 176-78.716 176-176 0-97.267-78.716-176-176-176-58.496 0-110.28 28.476-142.274 72.333h98.274c6.627 0 12 5.373 12 12v48c0 6.627-5.373 12-12 12z"
										/>
									</svg>{' '}
									|{' '}
								</span>{' '}
								<span
									title="Start the Game"
									className="pointer button-start hidden host mod no-select"
									onClick={this.start}
								>
									{' '}
									<svg
										aria-hidden="true"
										data-prefix="fas"
										data-icon="play"
										role="img"
										xmlns="http://www.w3.org/2000/svg"
										viewBox="0 0 448 512"
									>
										<path
											fill="currentColor"
											d="M424.4 214.7L72.4 6.6C43.8-10.3 0 6.1 0 47.9V464c0 37.5 40.7 60.1 72.4 41.3l352-208c31.4-18.5 31.5-64.1 0-82.6z"
										/>
									</svg>{' '}
									Start |{' '}
								</span>
								<span
									title="Stop the Game"
									className="pointer button-stop hidden host mod no-select"
									onClick={this.stop}
								>
									<svg
										aria-hidden="true"
										data-prefix="fas"
										data-icon="stop"
										role="img"
										xmlns="http://www.w3.org/2000/svg"
										viewBox="0 0 448 512"
									>
										<path
											fill="currentColor"
											d="M400 32H48C21.5 32 0 53.5 0 80v352c0 26.5 21.5 48 48 48h352c26.5 0 48-21.5 48-48V80c0-26.5-21.5-48-48-48z"
										/>
									</svg>{' '}
									|{' '}
								</span>{' '}
								<span
									className="pointer button-clear-kicks hidden creator mod pu no-select"
									title="Clear Kicks"
									onClick={this.room_clear_kicks}
								>
									<svg
										aria-hidden="true"
										data-prefix="fas"
										data-icon="balance-scale"
										role="img"
										xmlns="http://www.w3.org/2000/svg"
										viewBox="0 0 640 512"
									>
										<path
											fill="currentColor"
											d="M256 336h-.02c0-16.18 1.34-8.73-85.05-181.51-17.65-35.29-68.19-35.36-85.87 0C-2.06 328.75.02 320.33.02 336H0c0 44.18 57.31 80 128 80s128-35.82 128-80zM128 176l72 144H56l72-144zm511.98 160c0-16.18 1.34-8.73-85.05-181.51-17.65-35.29-68.19-35.36-85.87 0-87.12 174.26-85.04 165.84-85.04 181.51H384c0 44.18 57.31 80 128 80s128-35.82 128-80h-.02zM440 320l72-144 72 144H440zm88 128H352V153.25c23.51-10.29 41.16-31.48 46.39-57.25H528c8.84 0 16-7.16 16-16V48c0-8.84-7.16-16-16-16H383.64C369.04 12.68 346.09 0 320 0s-49.04 12.68-63.64 32H112c-8.84 0-16 7.16-16 16v32c0 8.84 7.16 16 16 16h129.61c5.23 25.76 22.87 46.96 46.39 57.25V448H112c-8.84 0-16 7.16-16 16v32c0 8.84 7.16 16 16 16h416c8.84 0 16-7.16 16-16v-32c0-8.84-7.16-16-16-16z"
										/>
									</svg>{' '}
									|{' '}
								</span>{' '}
								<a
									className="pointer button-leave no-select white no-underline"
									href="#"
									title="Leave Game"
								>
									<svg
										aria-hidden="true"
										data-prefix="fas"
										data-icon="reply"
										role="img"
										xmlns="http://www.w3.org/2000/svg"
										viewBox="0 0 512 512"
									>
										<path
											fill="currentColor"
											d="M8.309 189.836L184.313 37.851C199.719 24.546 224 35.347 224 56.015v80.053c160.629 1.839 288 34.032 288 186.258 0 61.441-39.581 122.309-83.333 154.132-13.653 9.931-33.111-2.533-28.077-18.631 45.344-145.012-21.507-183.51-176.59-185.742V360c0 20.7-24.3 31.453-39.687 18.164l-176.004-152c-11.071-9.562-11.086-26.753 0-36.328z"
										/>
									</svg>{' '}
									Leave
								</a>
							</Box>
						</Box>
						{this.props.room.game == 'pool' ? <GamePool room={this.props.room} /> : null}
						{this.props.room.game == '9ball' ? <Game9Ball room={this.props.room} /> : null}
						{this.props.room.game == 'swapples' ? (
							<GameSwapples room={this.props.room} data={this.props.data} />
						) : null}
						{this.props.room.game == 'loonobum' ? (
							<GameLoonobum room={this.props.room} data={this.props.data} />
						) : null}
						{this.props.room.game == 'poker' ? (
							<GamePoker room={this.props.room} data={this.props.data} />
						) : null}
						{this.props.room.game == 'watchtogether' ? (
							<GameWatchtogether room={this.props.room} data={this.props.data} />
						) : null}
						{this.props.room.game == 'skypigs' ? (
							<GameSkypigs room={this.props.room} data={this.props.data} />
						) : null}

						{this.props.room.game == 'bubbles' ? (
							<GameBubbles room={this.props.room} data={this.props.data} />
						) : null}
						{this.props.room.game == 'bubblesni' ? (
							<GameBubblesNi room={this.props.room} data={this.props.data} />
						) : null}
						{this.props.room.game == 'dinglepop' ? (
							<GameDinglepop room={this.props.room} data={this.props.data} />
						) : null}
						{this.props.room.game == 'blockles' ? (
							<GameBlockles room={this.props.room} data={this.props.data} />
						) : null}
						{this.props.room.game == 'blocklesmulti' ? (
							<GameBlocklesMulti room={this.props.room} data={this.props.data} />
						) : null}
						{this.props.room.game == 'gemmers' ? (
							<GameGemmers room={this.props.room} data={this.props.data} />
						) : null}
						{this.props.room.game == 'tonk3' ? (
							<GameTonk3 room={this.props.room} data={this.props.data} />
						) : null}

						{this.props.room.game == 'balloono' ? (
							<GameBalloono room={this.props.room} data={this.props.data} />
						) : null}
						{this.props.room.game == 'balloonoboot' ? (
							<GameBalloonoboot room={this.props.room} data={this.props.data} />
						) : null}
						{this.props.room.game == 'cuacka' ? (
							<GameCuacka room={this.props.room} data={this.props.data} />
						) : null}

						{this.props.room.game == 'checkers' ? (
							<GameCheckers room={this.props.room} data={this.props.data} />
						) : null}
						{this.props.room.game == 'test' ? (
							<GameTest room={this.props.room} data={this.props.data} />
						) : null}
					</div>
				) : (
					<div className="home">
						<div className="toolbar">
							Games with our friends.
							<small className="r guest-hidden">
								<a
									className="pointer underline-hover white no-underline corange"
									href="#p/Tournaments"
								>
									<b>Tournaments</b>
								</a>{' '}
								| <img alt="🖼" src="img/medals/gold.png?1" className="ranking" />{' '}
								<a className="pointer underline-hover white no-underline" href="#p/Ranking">
									Rankings
								</a>{' '}
								|{' '}
								<a
									className="pointer button-ranking no-select white no-underline"
									href="#p/Contribute"
									title="Help pay for stuff"
								>
									{' '}
									<img alt="🖼" className="star" src="https://omgmobc.com/img/badge/star-big.png" />
								</a>{' '}
								|{' '}
								<a className="pointer underline-hover white no-underline" href="#u/omgmobc.com">
									contact
								</a>{' '}
								|{' '}
								<a className="pointer underline-hover white no-underline" href="#p/Issues">
									Issues
								</a>{' '}
								|{' '}
								<a className="pointer underline-hover white no-underline" href="#p/FAQs">
									FAQs
								</a>{' '}
								|{' '}
								<a className="pointer underline-hover white no-underline" href="#p/Rules">
									Rules
								</a>{' '}
								|{' '}
								<a className="pointer underline-hover white no-underline" href="#p/ChangeLog">
									Change Log
								</a>{' '}
								|{' '}
								<a className="pointer underline-hover white no-underline" href="#p/Emoji">
									emoji
								</a>
							</small>
						</div>

						<div className="home-content">
							<div className="flex-column">
								<div className="game-buttons">
									<span className="button-draw-something game-button">
										<a href="https://drawesome.uy/" target="_blank" rel="noopener">
											<img
												alt="🖼"
												width="185"
												height="70"
												src="https://omgmobc.com/img/panel/drawesome.jpg"
											/>
											<span className="game-title">Drawesome</span>
										</a>
									</span>

									<span className=" game-button swapples-nof" onClick={this.create_swapples_cls}>
										<img
											alt="🖼"
											width="185"
											height="70"
											src="https://omgmobc.com/img/panel/swapples.jpg"
										/>
										<span className="game-title">Swapples</span>
									</span>

									{games.map((game, i) => {
										return (
											<span
												data-game={game[0]}
												className={'button-' + game[1] + ' game-button'}
												onClick={this.create}
												key={'game' + i}
											>
												<img alt="🖼" width="185" height="70" src={'/img/panel/' + game[2]} />
												{/*<div className="game-button-create">CREATE</div>*/}

												<div className="game-button-quick" onClick={this.tryJoin}>
													PLAY
												</div>
												<span className="game-title">{game[3]}</span>
											</span>
										)
									})}

									{local ? (
										<span>
											<span className="button-missile game-button" onClick={this.create_test}>
												<img
													alt="🖼"
													width="185"
													height="70"
													src="https://omgmobc.com/img/panel/skypigs.jpg"
												/>
												<span className="game-title">TEST</span>
											</span>
										</span>
									) : null}
								</div>
							</div>

							<div className="rooms-container">
								<Rooms items={this.state.rooms} />
							</div>
						</div>
					</div>
				)}
			</div>
		)
	},
	create: function(e) {
		var game = e.currentTarget.getAttribute('data-game')

		emit({
			id: 'room create',
			game: game,
		})
	},
	create_swapples_cls: function(e) {
		location.hash = 'm/swapples-nof' + gd()
	},

	create_test: function() {
		emit({
			id: 'room create',
			game: 'test',
		})
	},

	tryJoin: function(e) {
		var preferredSize = {
			swapples: 6,
			loonobum: 4,
			poker: 6,
			pool: 2,
			watchtogether: 6,
			bubblesni: 6,
			'9ball': 2,
			balloono: 6,
			balloonoboot: 6,
			skypigs: 6,
			blocklesmulti: 6,
			tonk3: 3,
			cuacka: 6,
			bubbles: 6,
			blockles: 6,
			dinglepop: 6,
			gemmers: 6,
			checkers: 2,
		}

		var game = e.target.parentElement.getAttribute('data-game')
		var filtered = this.state.rooms.filter(e => e[2] === game)
		var found = false

		for (var room in filtered) {
			if (
				filtered[room][3].length < preferredSize[game] &&
				!this.state.qp[game].includes(filtered[room][0])
			) {
				found = filtered[room][0]
				break
			}
		}

		var qp = this.state.qp

		if (found !== false) {
			qp[game].push(found)
			location.hash = 'm/' + found
			// e.cancelBubble = true
			if (e.stopPropagation) e.stopPropagation()
		} else {
			qp[game] = []
		}

		if (qp !== this.state.qp) this.setState({ qp: qp })
	},

	room_set_name: function(name) {
		if (this.props.room.name.replace(/#name#/g, window.room.users[0].username) != name)
			emit({
				id: 'room update',
				name: name.replace(window.room.users[0].username, '#name#'),
			})
	},
	room_toggle_private: function() {
		emit({
			id: 'room update',
			private: !this.props.room.private,
		})
	},
	room_switch_to: function(e) {
		emit({
			id: 'room switch to',
			game: $(e.currentTarget).attr('data-game'),
		})
	},
	room_toggle_guest: function() {
		emit({
			id: 'room update',
			guest: !this.props.room.guest,
		})
	},
	room_rotate: function() {
		emit({
			id: 'room rotate',
		})
	},
	room_rotate_opponent: function() {
		CONFIRM('Are you Sure you want to Rotate The Opponent?', function() {
			emit({
				id: 'room rotate opponent',
			})
		})
	},
	room_clear_kicks: function() {
		CONFIRM('Are you Sure you want to Clear Kicks?', function() {
			emit({
				id: 'room clear kicks',
			})
		})
	},
	start: function() {
		if (window.swf && window.swf.start) {
			window.swf.start()
		}
	},
	stop: function() {
		if (window.swf && window.swf.stop) {
			window.swf.stop()
		}
	},
})

$(function() {
	ReactDOM.render(<Game room="" data="" />, document.querySelector('.content-container .content'))
})
