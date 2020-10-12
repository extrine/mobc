var Ranking = React.createClass({
	mixins: [React.addons.PureRenderMixin],
	componentWillUnmount: function () {
		this.mounted = false
	},
	componentDidMount: function () {
		this.mounted = true
	},
	getInitialState: function () {
		emit(
			{
				id: 'ranking',
			},
			function (data) {
				if (this.mounted) this.setState(uncompress(data))
			}.bind(this),
		)

		this.cheaters = {
			swapples: {},
		}
		this.banned = {}
		return {
			swapples_record: [],
			swapples_matches: [],

			ball8_record: [],
			ball8_percent: [],
			ball8_wins: [],
			ball8_matches: [],
			ball8_loses: [],

			ball9_record: [],
			ball9_percent: [],
			ball9_wins: [],
			ball9_matches: [],
			ball9_loses: [],

			dinglepop_matches: [],
			dinglepop_drops: [],
			dinglepop_items: [],
			dinglepop_cleared: [],
			dinglepop_percent: [],

			blockles_matches: [],
			blockles_record: [],

			gemmers_matches: [],
			gemmers_record: [],

			tonk3_matches: [],

			skypigs_matches: [],
			skypigs_score: [],

			cuacka_matches: [],
			cuacka_score: [],

			checkers_percent: [],
			checkers_matches: [],
			checkers_wins: [],

			balloono_percent: [],
			balloono_matches: [],
			balloono_wins: [],

			balloonoboot_percent: [],
			balloonoboot_matches: [],
			balloonoboot_wins: [],

			blocklesmulti_percent: [],
			blocklesmulti_matches: [],
			blocklesmulti_wins: [],

			yt: [],
		}
	},
	title: function (item) {
		return item.d ? 'User helped to pay for stuff' : null
	},
	isHidden: function (item) {
		return this.banned[item.u] ? ' hidden ' : null
	},
	render: function () {
		return (
			<div className="ranking">
				<h1>Game Rankings</h1>
				<hr />
				<b>
					Ranking data updates one time every 7 days (because updating it lags the server a lot).
				</b>{' '}
				Displays top 40 users, if user 41 has same score as 40 it will not be displayed because
				makes the tables ugly.
				<hr />
				<TabArea>
					<Tab
						id="pool"
						title={<img src="https://omgmobc.com/img/icon/pool.png" width="25" height="25" />}
					>
						<h2>
							{' '}
							<img src="https://omgmobc.com/img/icon/pool.png" width="30" height="30" /> Pool
						</h2>
						<hr />
						To appear in "Wins Percent" you must have at least 500 matches.
						<hr />
						<ul className="data">
							<li>
								<b>
									<img src="img/medals/gold.png?1" className="ranking" /> Record Time Clearing Table
								</b>
								{this.state.ball8_record.map(
									function (item) {
										return (
											<div key={item.u} className={this.isHidden(item)}>
												<a
													href={'#u/' + encodeURIComponent(item.u)}
													title={this.title(item)}
													className="username white no-underline"
												>
													{item.u}
												</a>{' '}
												{item.d ? <img src={u.badge(item.u)} /> : null} : {item.v}
											</div>
										)
									}.bind(this),
								)}
							</li>
							<li>
								<b>
									<img src="img/medals/gold.png?1" className="ranking" /> Wins Percent
								</b>
								{this.state.ball8_percent.map(
									function (item) {
										return (
											<div key={item.u} className={this.isHidden(item)}>
												<a
													href={'#u/' + encodeURIComponent(item.u)}
													title={this.title(item)}
													className="username white no-underline"
												>
													{item.u}
												</a>{' '}
												{item.d ? <img src={u.badge(item.u)} /> : null} : {item.v}%
											</div>
										)
									}.bind(this),
								)}
							</li>
							<li>
								<b>
									<img src="img/medals/gold.png?1" className="ranking" /> Wins
								</b>
								{this.state.ball8_wins.map(
									function (item) {
										return (
											<div key={item.u} className={this.isHidden(item)}>
												<a
													href={'#u/' + encodeURIComponent(item.u)}
													title={this.title(item)}
													className="username white no-underline"
												>
													{item.u}
												</a>{' '}
												{item.d ? <img src={u.badge(item.u)} /> : null} : {item.v}
											</div>
										)
									}.bind(this),
								)}
							</li>
							<li>
								<b>
									<img src="img/medals/gold.png?1" className="ranking" /> Matches
								</b>
								{this.state.ball8_matches.map(
									function (item) {
										return (
											<div key={item.u} className={this.isHidden(item)}>
												<a
													href={'#u/' + encodeURIComponent(item.u)}
													title={this.title(item)}
													className="username white no-underline"
												>
													{item.u}
												</a>{' '}
												{item.d ? <img src={u.badge(item.u)} /> : null} : {item.v}
											</div>
										)
									}.bind(this),
								)}
							</li>
							<div className="clear" />
						</ul>
					</Tab>
					<Tab
						id="tonk"
						title={<img src="https://omgmobc.com/img/icon/tonk3.png" width="25" height="25" />}
					>
						<h2>
							{' '}
							<img src="https://omgmobc.com/img/icon/tonk3.png" width="30" height="30" /> Tonk3
							Matches
						</h2>{' '}
						<hr />
						<ul className="column data">
							<li>
								{this.state.tonk3_matches.map(
									function (item) {
										return (
											<div key={item.u}>
												<a
													href={'#u/' + encodeURIComponent(item.u)}
													title={this.title(item)}
													className="username white no-underline"
												>
													{item.u}
												</a>{' '}
												{item.d ? <img src={u.badge(item.u)} /> : null} : {item.v}
											</div>
										)
									}.bind(this),
								)}
							</li>{' '}
							<div className="clear" />
						</ul>
					</Tab>
					<Tab
						id="swapples"
						title={<img src="https://omgmobc.com/img/icon/swapples.png" width="25" height="25" />}
					>
						<h2>
							{' '}
							<img src="https://omgmobc.com/img/icon/swapples.png" width="30" height="30" />{' '}
							Swapples Matches
						</h2>{' '}
						<hr />
						<ul className="column data">
							<li>
								{this.state.swapples_matches.map(
									function (item) {
										return (
											<div
												key={item.u}
												className={this.cheaters.swapples[item.u] ? 'cheater' : this.isHidden(item)}
											>
												<a
													href={'#u/' + encodeURIComponent(item.u)}
													title={this.title(item)}
													className="username white no-underline"
												>
													{item.u}
												</a>{' '}
												{item.d ? <img src={u.badge(item.u)} /> : null} : {item.v}{' '}
												{this.cheaters.swapples[item.u] ? ' - *BOT*' : null}
											</div>
										)
									}.bind(this),
								)}
							</li>{' '}
							<div className="clear" />
						</ul>
						<hr />
						<h2>
							{' '}
							<img src="https://omgmobc.com/img/icon/swapples.png" width="30" height="30" />{' '}
							Swapples High Score
						</h2>{' '}
						<hr />
						<ul className="column data">
							<li>
								{this.state.swapples_record.map(
									function (item, id) {
										return (
											<div
												key={item.u}
												className={this.cheaters.swapples[item.u] ? 'cheater' : this.isHidden(item)}
											>
												[
												<a
													href={'#m/swapples-rank-' + encodeURIComponent(item.r)}
													title="Play This Board"
													className="white no-underline"
												>
													PB
												</a>
												] -{' '}
												<a
													href={'#u/' + encodeURIComponent(item.u)}
													title={this.title(item)}
													className="username white no-underline"
												>
													{item.u}
												</a>{' '}
												{item.d ? <img src={u.badge(item.u)} /> : null} :{' '}
												{item.u == 'Connor' ? (
													<a
														href="https://www.youtube.com/watch?v=tJAXI03xjfk"
														className="white normal"
														target="_blank"
													>
														<b className="white normal underline">{item.v}</b>
													</a>
												) : (
													item.v
												)}{' '}
												{this.cheaters.swapples[item.u] ? ' - *BOT*' : null}
											</div>
										)
									}.bind(this),
								)}
							</li>
							<div className="clear" />
						</ul>
					</Tab>
					<Tab
						id="bubbla"
						title={<img src="https://omgmobc.com/img/icon/dinglepop.png" width="25" height="25" />}
					>
						<h2>
							<img src="https://omgmobc.com/img/icon/dinglepop.png" width="30" height="30" /> Bubbla
						</h2>
						<hr />
						To appear in "Success" you must have at least 250 matches.
						<hr />
						<ul className="data">
							<li className="w20">
								<b>
									<img src="img/medals/gold.png?1" className="ranking" /> Success
								</b>
								<div key={'Daphne'}>
									<a
										href={'#u/' + encodeURIComponent('Daphne')}
										className="username white no-underline"
									>
										{'Daphne'}
									</a>{' '}
									<img src={u.badge('Daphne')} /> : Infinity
								</div>
								{this.state.dinglepop_percent.map(
									function (item) {
										return item.u != 'Daphne' ? (
											<div key={item.u} className={this.isHidden(item)}>
												<a
													href={'#u/' + encodeURIComponent(item.u)}
													title={this.title(item)}
													className="username white no-underline"
												>
													{item.u}
												</a>{' '}
												{item.d ? <img src={u.badge(item.u)} /> : null} :{' '}
												{item.u == 'Daphne' ? 'Infinity' : item.v + '%'}
											</div>
										) : null
									}.bind(this),
								)}
							</li>
							<li className="w20">
								<b>
									<img src="img/medals/gold.png?1" className="ranking" /> Clearing
								</b>
								{this.state.dinglepop_cleared.map(
									function (item) {
										return (
											<div key={item.u} className={this.isHidden(item)}>
												<a
													href={'#u/' + encodeURIComponent(item.u)}
													title={this.title(item)}
													className="username white no-underline"
												>
													{item.u}
												</a>{' '}
												{item.d ? <img src={u.badge(item.u)} /> : null} : {item.v}
											</div>
										)
									}.bind(this),
								)}
							</li>
							<li className="w20">
								<b>
									<img src="img/medals/gold.png?1" className="ranking" /> Games
								</b>
								{this.state.dinglepop_matches.map(
									function (item) {
										return (
											<div key={item.u} className={this.isHidden(item)}>
												<a
													href={'#u/' + encodeURIComponent(item.u)}
													title={this.title(item)}
													className="username white no-underline"
												>
													{item.u}
												</a>{' '}
												{item.d ? <img src={u.badge(item.u)} /> : null} : {item.v}
											</div>
										)
									}.bind(this),
								)}
							</li>
							<li className="w20">
								<b>
									<img src="img/medals/gold.png?1" className="ranking" /> Drops
								</b>
								{this.state.dinglepop_drops.map(
									function (item) {
										return (
											<div key={item.u} className={this.isHidden(item)}>
												<a
													href={'#u/' + encodeURIComponent(item.u)}
													title={this.title(item)}
													className="username white no-underline"
												>
													{item.u}
												</a>{' '}
												{item.d ? <img src={u.badge(item.u)} /> : null} : {item.v}
											</div>
										)
									}.bind(this),
								)}
							</li>
							<li className="w20">
								<b>
									<img src="img/medals/gold.png?1" className="ranking" /> Items
								</b>
								{this.state.dinglepop_items.map(
									function (item) {
										return (
											<div key={item.u} className={this.isHidden(item)}>
												<a
													href={'#u/' + encodeURIComponent(item.u)}
													title={this.title(item)}
													className="username white no-underline"
												>
													{item.u}
												</a>{' '}
												{item.d ? <img src={u.badge(item.u)} /> : null} : {item.v}
											</div>
										)
									}.bind(this),
								)}
							</li>
							<div className="clear" />
						</ul>
					</Tab>
					<Tab
						id="blockles"
						title={<img src="https://omgmobc.com/img/icon/blockles.png" width="25" height="25" />}
					>
						<div className="">
							<h2>
								<img src="https://omgmobc.com/img/icon/blockles.png" width="30" height="30" />{' '}
								Blockles
							</h2>
							<hr />
							<ul className="data">
								<li className="w50">
									<b>
										<img src="img/medals/gold.png?1" className="ranking" /> High Score
									</b>
									{this.state.blockles_record.map(
										function (item) {
											return (
												<div key={item.u} className={this.isHidden(item)}>
													<a
														href={'#u/' + encodeURIComponent(item.u)}
														title={this.title(item)}
														className="username white no-underline"
													>
														{item.u}
													</a>{' '}
													{item.d ? <img src={u.badge(item.u)} /> : null} : {item.v}
												</div>
											)
										}.bind(this),
									)}
								</li>
								<li className="w50">
									<b>
										<img src="img/medals/gold.png?1" className="ranking" /> Games
									</b>
									{this.state.blockles_matches.map(
										function (item) {
											return (
												<div key={item.u} className={this.isHidden(item)}>
													<a
														href={'#u/' + encodeURIComponent(item.u)}
														title={this.title(item)}
														className="username white no-underline"
													>
														{item.u}
													</a>{' '}
													{item.d ? <img src={u.badge(item.u)} /> : null} : {item.v}
												</div>
											)
										}.bind(this),
									)}
								</li>
								<div className="clear" />
							</ul>
						</div>
						<div className="clear" />
					</Tab>
					<Tab
						id="gemmers"
						title={<img src="https://omgmobc.com/img/icon/gemmers.png" width="25" height="25" />}
					>
						<div className="">
							<h2>
								<img src="https://omgmobc.com/img/icon/gemmers.png" width="30" height="30" />{' '}
								Gemmers
							</h2>
							<hr />
							<ul className="data">
								<li className="w50">
									<b>
										<img src="img/medals/gold.png?1" className="ranking" /> High Score
									</b>
									{this.state.gemmers_record.map(
										function (item) {
											return (
												<div key={item.u} className={this.isHidden(item)}>
													<a
														href={'#u/' + encodeURIComponent(item.u)}
														title={this.title(item)}
														className="username white no-underline"
													>
														{item.u}
													</a>{' '}
													{item.d ? <img src={u.badge(item.u)} /> : null} : {item.v}
												</div>
											)
										}.bind(this),
									)}
								</li>
								<li className="w50">
									<b>
										<img src="img/medals/gold.png?1" className="ranking" /> Games
									</b>
									{this.state.gemmers_matches.map(
										function (item) {
											return (
												<div key={item.u} className={this.isHidden(item)}>
													<a
														href={'#u/' + encodeURIComponent(item.u)}
														title={this.title(item)}
														className="username white no-underline"
													>
														{item.u}
													</a>{' '}
													{item.d ? <img src={u.badge(item.u)} /> : null} : {item.v}
												</div>
											)
										}.bind(this),
									)}
								</li>
								<div className="clear" />
							</ul>
						</div>
						<div className="clear" />
					</Tab>
					<Tab
						id="skypigs"
						title={<img src="https://omgmobc.com/img/icon/skypigs.png" width="25" height="25" />}
					>
						<div>
							<h2>
								<img src="https://omgmobc.com/img/icon/skypigs.png" width="30" height="30" />{' '}
								Skypigs
							</h2>
							<hr />
							<ul className="data">
								<li className="w50">
									<b>
										<img src="img/medals/gold.png?1" className="ranking" /> Games
									</b>
									{this.state.skypigs_matches.map(
										function (item) {
											return (
												<div key={item.u} className={this.isHidden(item)}>
													<a
														href={'#u/' + encodeURIComponent(item.u)}
														title={this.title(item)}
														className="username white no-underline"
													>
														{item.u}
													</a>{' '}
													{item.d ? <img src={u.badge(item.u)} /> : null} : {item.v}
												</div>
											)
										}.bind(this),
									)}
								</li>
								<li className="w50">
									<b>
										<img src="img/medals/gold.png?1" className="ranking" /> Feet
									</b>
									{this.state.skypigs_score.map(
										function (item) {
											return (
												<div key={item.u} className={this.isHidden(item)}>
													<a
														href={'#u/' + encodeURIComponent(item.u)}
														title={this.title(item)}
														className="username white no-underline"
													>
														{item.u}
													</a>{' '}
													{item.d ? <img src={u.badge(item.u)} /> : null} : {item.v}
												</div>
											)
										}.bind(this),
									)}
								</li>
								<div className="clear" />
							</ul>
						</div>
					</Tab>
					<Tab
						id="balloono"
						title={<img src="https://omgmobc.com/img/icon/balloono.png" width="25" height="25" />}
					>
						<div>
							<h2>
								{' '}
								<img src="https://omgmobc.com/img/icon/balloono.png" width="30" height="30" />{' '}
								Balloono
							</h2>
							<hr />
							To appear in "Wins Percent" you must have at least 500 matches.
							<hr />
							<ul className="data">
								<li>
									<b>
										<img src="img/medals/gold.png?1" className="ranking" /> Wins Percent
									</b>
									{this.state.balloono_percent.map(
										function (item) {
											return (
												<div key={item.u} className={this.isHidden(item)}>
													<a
														href={'#u/' + encodeURIComponent(item.u)}
														title={this.title(item)}
														className="username white no-underline"
													>
														{item.u}
													</a>{' '}
													{item.d ? <img src={u.badge(item.u)} /> : null} : {item.v}%
												</div>
											)
										}.bind(this),
									)}
								</li>
								<li>
									<b>
										<img src="img/medals/gold.png?1" className="ranking" /> Wins
									</b>
									{this.state.balloono_wins.map(
										function (item) {
											return (
												<div key={item.u} className={this.isHidden(item)}>
													<a
														href={'#u/' + encodeURIComponent(item.u)}
														title={this.title(item)}
														className="username white no-underline"
													>
														{item.u}
													</a>{' '}
													{item.d ? <img src={u.badge(item.u)} /> : null} : {item.v}
												</div>
											)
										}.bind(this),
									)}
								</li>
								<li>
									<b>
										<img src="img/medals/gold.png?1" className="ranking" /> Matches
									</b>
									{this.state.balloono_matches.map(
										function (item) {
											return (
												<div key={item.u} className={this.isHidden(item)}>
													<a
														href={'#u/' + encodeURIComponent(item.u)}
														title={this.title(item)}
														className="username white no-underline"
													>
														{item.u}
													</a>{' '}
													{item.d ? <img src={u.badge(item.u)} /> : null} : {item.v}
												</div>
											)
										}.bind(this),
									)}
								</li>
								<div className="clear" />
							</ul>
						</div>
					</Tab>
					<Tab
						id="balloonoboot"
						title={
							<img src="https://omgmobc.com/img/icon/balloonoboot.png" width="25" height="25" />
						}
					>
						<div>
							<h2>
								{' '}
								<img
									src="https://omgmobc.com/img/icon/balloonoboot.png"
									width="30"
									height="30"
								/>{' '}
								Balloono Boot
							</h2>
							<hr />
							To appear in "Wins Percent" you must have at least 500 matches.
							<hr />
							<ul className="data">
								<li>
									<b>
										<img src="img/medals/gold.png?1" className="ranking" /> Wins Percent
									</b>
									{this.state.balloonoboot_percent.map(
										function (item) {
											return (
												<div key={item.u} className={this.isHidden(item)}>
													<a
														href={'#u/' + encodeURIComponent(item.u)}
														title={this.title(item)}
														className="username white no-underline"
													>
														{item.u}
													</a>{' '}
													{item.d ? <img src={u.badge(item.u)} /> : null} : {item.v}%
												</div>
											)
										}.bind(this),
									)}
								</li>
								<li>
									<b>
										<img src="img/medals/gold.png?1" className="ranking" /> Wins
									</b>
									{this.state.balloonoboot_wins.map(
										function (item) {
											return (
												<div key={item.u} className={this.isHidden(item)}>
													<a
														href={'#u/' + encodeURIComponent(item.u)}
														title={this.title(item)}
														className="username white no-underline"
													>
														{item.u}
													</a>{' '}
													{item.d ? <img src={u.badge(item.u)} /> : null} : {item.v}
												</div>
											)
										}.bind(this),
									)}
								</li>
								<li>
									<b>
										<img src="img/medals/gold.png?1" className="ranking" /> Matches
									</b>
									{this.state.balloonoboot_matches.map(
										function (item) {
											return (
												<div key={item.u} className={this.isHidden(item)}>
													<a
														href={'#u/' + encodeURIComponent(item.u)}
														title={this.title(item)}
														className="username white no-underline"
													>
														{item.u}
													</a>{' '}
													{item.d ? <img src={u.badge(item.u)} /> : null} : {item.v}
												</div>
											)
										}.bind(this),
									)}
								</li>
								<div className="clear" />
							</ul>
						</div>
					</Tab>
					<Tab
						id="blocklesm"
						title={<img src="https://omgmobc.com/img/icon/blocklesm.png" width="25" height="25" />}
					>
						<div>
							<h2>
								{' '}
								<img src="https://omgmobc.com/img/icon/blocklesm.png" width="30" height="30" />{' '}
								Blockles Multi
							</h2>
							<hr />
							To appear in "Wins Percent" you must have at least 250 matches.
							<hr />
							<ul className="data">
								<li>
									<b>
										<img src="img/medals/gold.png?1" className="ranking" /> Wins Percent
									</b>
									{this.state.blocklesmulti_percent.map(
										function (item) {
											return (
												<div key={item.u} className={this.isHidden(item)}>
													<a
														href={'#u/' + encodeURIComponent(item.u)}
														title={this.title(item)}
														className="username white no-underline"
													>
														{item.u}
													</a>{' '}
													{item.d ? <img src={u.badge(item.u)} /> : null} : {item.v}%
												</div>
											)
										}.bind(this),
									)}
								</li>
								<li>
									<b>
										<img src="img/medals/gold.png?1" className="ranking" /> Wins
									</b>
									{this.state.blocklesmulti_wins.map(
										function (item) {
											return (
												<div key={item.u} className={this.isHidden(item)}>
													<a
														href={'#u/' + encodeURIComponent(item.u)}
														title={this.title(item)}
														className="username white no-underline"
													>
														{item.u}
													</a>{' '}
													{item.d ? <img src={u.badge(item.u)} /> : null} : {item.v}
												</div>
											)
										}.bind(this),
									)}
								</li>
								<li>
									<b>
										<img src="img/medals/gold.png?1" className="ranking" /> Matches
									</b>
									{this.state.blocklesmulti_matches.map(
										function (item) {
											return (
												<div key={item.u} className={this.isHidden(item)}>
													<a
														href={'#u/' + encodeURIComponent(item.u)}
														title={this.title(item)}
														className="username white no-underline"
													>
														{item.u}
													</a>{' '}
													{item.d ? <img src={u.badge(item.u)} /> : null} : {item.v}
												</div>
											)
										}.bind(this),
									)}
								</li>
								<div className="clear" />
							</ul>
						</div>
					</Tab>
					<Tab id="cuacka" title={<span style={{ fontSize: '18px' }}>🦆</span>}>
						<div>
							<h2>
								<img src="https://omgmobc.com/img/icon/cuacka.png" width="30" height="30" /> Quacka
							</h2>
							<hr />
							<ul className="data">
								<li className="w50">
									<b>
										<img src="img/medals/gold.png?1" className="ranking" /> Games
									</b>
									{this.state.cuacka_matches.map(
										function (item) {
											return (
												<div key={item.u} className={this.isHidden(item)}>
													<a
														href={'#u/' + encodeURIComponent(item.u)}
														title={this.title(item)}
														className="username white no-underline"
													>
														{item.u}
													</a>{' '}
													{item.d ? <img src={u.badge(item.u)} /> : null} : {item.v}
												</div>
											)
										}.bind(this),
									)}
								</li>
								<li className="w50">
									<b>
										<img src="img/medals/gold.png?1" className="ranking" /> High Score
									</b>
									<div>
										<a href={'#u/Lussx'} title="Lussx" className="username white no-underline">
											Lussx
										</a>{' '}
										: 1008440
									</div>
									{this.state.cuacka_score.map(
										function (item) {
											return (
												<div key={item.u} className={this.isHidden(item)}>
													<a
														href={'#u/' + encodeURIComponent(item.u)}
														title={this.title(item)}
														className="username white no-underline"
													>
														{item.u}
													</a>{' '}
													{item.d ? <img src={u.badge(item.u)} /> : null} : {item.v}
												</div>
											)
										}.bind(this),
									)}
								</li>
								<div className="clear" />
							</ul>
						</div>
					</Tab>
					<Tab
						id="9ball"
						title={<img src="https://omgmobc.com/img/icon/9ball.png" width="25" height="25" />}
					>
						<h2>
							<img src="https://omgmobc.com/img/icon/9ball.png" width="30" height="30" /> 9 Ball
						</h2>
						<hr />
						To appear in "Wins Percent" you must have at least 250 matches.
						<hr />
						<ul className="data">
							<li>
								<b>
									<img src="img/medals/gold.png?1" className="ranking" /> Record Time Clearing Table
								</b>
								{this.state.ball9_record.map(
									function (item) {
										return (
											<div key={item.u} className={this.isHidden(item)}>
												<a
													href={'#u/' + encodeURIComponent(item.u)}
													title={this.title(item)}
													className="username white no-underline"
												>
													{item.u}
												</a>{' '}
												{item.d ? <img src={u.badge(item.u)} /> : null} : {item.v}
											</div>
										)
									}.bind(this),
								)}
							</li>
							<li>
								<b>
									<img src="img/medals/gold.png?1" className="ranking" /> Wins Percent
								</b>
								{this.state.ball9_percent.map(
									function (item) {
										return (
											<div key={item.u} className={this.isHidden(item)}>
												<a
													href={'#u/' + encodeURIComponent(item.u)}
													title={this.title(item)}
													className="username white no-underline"
												>
													{item.u}
												</a>{' '}
												{item.d ? <img src={u.badge(item.u)} /> : null} : {item.v}%
											</div>
										)
									}.bind(this),
								)}
							</li>
							<li>
								<b>
									<img src="img/medals/gold.png?1" className="ranking" /> Wins
								</b>
								{this.state.ball9_wins.map(
									function (item) {
										return (
											<div key={item.u} className={this.isHidden(item)}>
												<a
													href={'#u/' + encodeURIComponent(item.u)}
													title={this.title(item)}
													className="username white no-underline"
												>
													{item.u}
												</a>{' '}
												{item.d ? <img src={u.badge(item.u)} /> : null} : {item.v}
											</div>
										)
									}.bind(this),
								)}
							</li>
							<li>
								<b>
									<img src="img/medals/gold.png?1" className="ranking" /> Matches
								</b>
								{this.state.ball9_matches.map(
									function (item) {
										return (
											<div key={item.u} className={this.isHidden(item)}>
												<a
													href={'#u/' + encodeURIComponent(item.u)}
													title={this.title(item)}
													className="username white no-underline"
												>
													{item.u}
												</a>{' '}
												{item.d ? <img src={u.badge(item.u)} /> : null} : {item.v}
											</div>
										)
									}.bind(this),
								)}
							</li>
							<div className="clear" />
						</ul>
					</Tab>
					<Tab
						id="checkers"
						title={<img src="https://omgmobc.com/img/icon/checkers.png" width="25" height="25" />}
					>
						<h2>
							{' '}
							<img src="https://omgmobc.com/img/icon/checkers.png" width="30" height="30" />{' '}
							Checkers
						</h2>
						<hr />
						To appear in "Wins Percent" you must have at least 100 matches.
						<hr />
						<ul className="data">
							<li>
								<b>
									<img src="img/medals/gold.png?1" className="ranking" /> Wins Percent
								</b>
								{this.state.checkers_percent.map(
									function (item) {
										return (
											<div key={item.u} className={this.isHidden(item)}>
												<a
													href={'#u/' + encodeURIComponent(item.u)}
													title={this.title(item)}
													className="username white no-underline"
												>
													{item.u}
												</a>{' '}
												{item.d ? <img src={u.badge(item.u)} /> : null} : {item.v}%
											</div>
										)
									}.bind(this),
								)}
							</li>
							<li>
								<b>
									<img src="img/medals/gold.png?1" className="ranking" /> Wins
								</b>
								{this.state.checkers_wins.map(
									function (item) {
										return (
											<div key={item.u} className={this.isHidden(item)}>
												<a
													href={'#u/' + encodeURIComponent(item.u)}
													title={this.title(item)}
													className="username white no-underline"
												>
													{item.u}
												</a>{' '}
												{item.d ? <img src={u.badge(item.u)} /> : null} : {item.v}
											</div>
										)
									}.bind(this),
								)}
							</li>
							<li>
								<b>
									<img src="img/medals/gold.png?1" className="ranking" /> Matches
								</b>
								{this.state.checkers_matches.map(
									function (item) {
										return (
											<div key={item.u} className={this.isHidden(item)}>
												<a
													href={'#u/' + encodeURIComponent(item.u)}
													title={this.title(item)}
													className="username white no-underline"
												>
													{item.u}
												</a>{' '}
												{item.d ? <img src={u.badge(item.u)} /> : null} : {item.v}
											</div>
										)
									}.bind(this),
								)}
							</li>
							<div className="clear" />
						</ul>
					</Tab>
					<Tab
						id="yt"
						title={
							<img src="https://omgmobc.com/img/icon/watchtogether.png" width="25" height="25" />
						}
					>
						<h2>
							{' '}
							<img
								src="https://omgmobc.com/img/icon/watchtogether.png"
								width="30"
								height="30"
								className="pixelated"
							/>{' '}
							YouTube
						</h2>
						<hr />
						<ul className="column data">
							<li>
								<div className="clear" />
								{this.state.yt.map(
									function (item) {
										return (
											<div key={item.u} className={this.isHidden(item)}>
												<a
													href={'#u/' + encodeURIComponent(item.u)}
													title={this.title(item)}
													className="username white no-underline"
												>
													{item.u}
												</a>{' '}
												{item.d ? <img src={u.badge(item.u)} /> : null} : {item.v}
											</div>
										)
									}.bind(this),
								)}
							</li>
							<br />
						</ul>
					</Tab>
					<Tab id="rip" title={<span style={{ fontSize: '18px', color: 'gold' }}>†</span>}>
						<h2>
							<span className="cyellow">✿</span>
							<span className="corange">✿</span> In Memoriam - Rest in Peace †{' '}
							<span className="corange">✿</span>
							<span className="cyellow">✿</span>
						</h2>
						<hr />
						<ul className="">
							<div className="clear" />
							{Object.keys(rip).map(
								function (item) {
									return item != 'william49' ? (
										<div key={item}>
											<a
												href={'#u/' + encodeURIComponent(item)}
												className="username white no-underline"
											>
												{item}
											</a>{' '}
											<img src={u.badge(item)} /> — {rip[item]}
										</div>
									) : null
								}.bind(this),
							)}
						</ul>
					</Tab>
					<Tab
						id="tornament_winners"
						title={<span style={{ fontSize: '18px', color: 'gold' }}>🥇</span>}
					>
						<h2>Pool Tournament Winner 🥇</h2>
						<hr />
						<ul className="">
							<div className="clear" />
							{[
								{ user: 'Roxann', date: '1st', runner: 'franzfranzy' },
								{ user: 'Roxann', date: '2nd', runner: 'Leafsman17' },
								{ user: 'Roxann', date: '3rd', runner: 'Leafsman17' },
								{ user: 'Blasé', date: '4th', runner: 'Roxann' },
							].map(
								function (item, idx) {
									return (
										<div key={idx}>
											<img src="img/medals/gold.png?1" className="ranking" /> {item.date} edition:{' '}
											<a
												href={'#u/' + encodeURIComponent(item.user)}
												className="username white no-underline"
											>
												{item.user}
											</a>{' '}
											<img src={u.badge(item.user)} /> - Runner up{' '}
											<img src="img/medals/silver.png?1" className="ranking" />{' '}
											<a
												href={'#u/' + encodeURIComponent(item.runner)}
												className="username white no-underline"
											>
												{item.runner}
											</a>{' '}
											<img src={u.badge(item.runner)} />{' '}
										</div>
									)
								}.bind(this),
							)}
							<div>
								<img className="ranking" />{' '}
								<a href={'#u/' + encodeURIComponent()} className="username white no-underline">
									{}
								</a>{' '}
							</div>
						</ul>
					</Tab>
				</TabArea>
				<SeeAlso />
			</div>
		)
	},
})
