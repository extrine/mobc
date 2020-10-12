var Rooms = React.createClass({
	mixins: [React.addons.PureRenderMixin],
	rendered: 0,
	getInitialState: function () {
		return {
			sort: {
				by: 'oldest',
				type: 'all',
				string: '',
			},
		}
	},
	getDefaultProps: function () {
		return {
			items: [],
		}
	},
	render: function () {
		var sorted = this.props.items
		switch (this.state.sort.by) {
			case 'oldest':
				sorted = this.props.items.slice(0)
				break

			case 'newest':
				sorted = this.props.items.slice(0).reverse()
				break

			case 'type':
				sorted = this.props.items.slice(0).sort(function (a, b) {
					if (a[2] < b[2]) return -1
					else return 1
				})
				break

			case 'playerascend':
				sorted = this.props.items.slice(0).sort(function (a, b) {
					if (a[3].length < b[3].length) return -1
					else return 1
				})
				break

			case 'playerdescend':
				sorted = this.props.items.slice(0).sort(function (a, b) {
					if (a[3].length > b[3].length) return -1
					else return 1
				})
				break
		}
		if (!sorted) {
			sorted = this.props.items || []
		}
		if (this.state.sort.type !== 'all') {
			sorted = sorted.filter(e => e[2] === this.state.sort.type)
		}

		if (this.state.sort.string) {
			sorted = sorted.filter(e => {
				var ret = false
				for (var player in e[3])
					ret = this.search(this.state.sort.string, e[3][player][0]) == true ? true : ret
				return ret
			})
		}

		var games = [
			['9ball', '9ball', 0],
			['balloono', 'Balloono', 0],
			['balloonoboot', 'Balloono Boot', 0],
			['blockles', 'Blockles', 0],
			['blocklesmulti', 'Blockles M', 0],
			['bubbles', 'Bubbles', 0],
			['bubblesni', 'Bubbles NI', 0],
			['checkers', 'Checkers', 0],
			['cuacka', 'Cuacka', 0],
			['dinglepop', 'Dinglepop', 0],
			['gemmers', 'Gemmers', 0],
			['pool', 'Pool', 0],
			['skypigs', 'Skypigs', 0],
			['swapples', 'Swapples', 0],
			['loonobum', 'loonobum', 0],
			['poker', 'Poker', 0],
			['tonk3', 'Tonk', 0],
			['watchtogether', 'WatchTogether', 0],
		]

		for (var game in games) {
			for (var item in this.props.items) {
				if (games[game][0] === this.props.items[item][2]) {
					games[game][2]++
				}
			}
		}

		return (
			<div className="rooms ">
				<Box row wrap className="toolbar">
					<Box grow row>
						Rooms ({this.props.items.length ? this.props.items.length : 0})
						{this.state.sort.type !== 'all' || this.state.sort.string !== '' ? (
							<span>Shown ({sorted.length})</span>
						) : null}{' '}
					</Box>

					<div>
						<label className="inline">
							<span className="sort-label">Sort:</span>
							<select ref="sortby" onChange={this.updateSort}>
								<option defaultValue value="oldest">
									Oldest First
								</option>
								<option value="newest">Newest First</option>
								<option value="playerascend">Number of Players (asc)</option>
								<option value="playerdescend">Number of Players (des)</option>
								<option value="type">Game Type</option>
							</select>
						</label>
					</div>
					<div>
						<label className="inline">
							<span className="sort-label">Filter:</span>
							<select ref="sorttype" onChange={this.updateSort}>
								<option defaultValue value="all">
									All
								</option>
								{games.map((game, i) => {
									return (
										<option value={game[0]} key={i}>
											({game[2]}) {game[1]}
										</option>
									)
								})}
							</select>
						</label>
					</div>
					<div>
						<label className="inline">
							<span className="sort-label">Filter:</span>
							<input placeholder="Username" onChange={this.updateFilter} />
						</label>
					</div>
				</Box>
				<Box row wrap grow className="rooms-container-flex">
					{sorted.map(
						function (item, x) {
							return (
								<Box
									key={item[0]}
									data-id={item[0]}
									data-game={item[2]}
									className="room break"
									title="Click to join the room"
									onClick={this.join}
									grow
								>
									<div className="name-container">
										<span className="name">
											<span
												dangerouslySetInnerHTML={{
													__html: u.linky_no_link_cached(this.room_name(item)),
												}}
											/>
											{/-[0-9]+$/.test(item[0]) ? (
												<img className="ranked" src="img/medals/gold.png?1" />
											) : null}
											<img
												className="creator"
												title={'Creator ' + item[4].u}
												src={
													is_video(item[4].i)
														? profile_picture(item[4].i).replace(/\.[^\.]+$/, '.png')
														: profile_picture(item[4].i)
												}
											/>
										</span>
									</div>
									{item[3] ? (
										<div className="image-container">
											{item[3].map(function (user) {
												var img = (user[1] && user[1].indexOf('http') === 0
													? user[1]
													: user[1]
													? 'https://omgmobc.com/profile/' + user[1]
													: 'https://omgmobc.com/img/user.png'
												).replace('profile/', 'profile/thumb_')

												return (
													<span key={item[0] + '-' + user[0]}>
														{!is_video(img) ? (
															<img
																className="profile-image"
																title={user[0]}
																src={img}
																width="30"
																height="30"
															/>
														) : (
															<img
																className="profile-image"
																title={user[0]}
																src={img.replace(/\.[^\.]+$/, '.png')}
																width="30"
																height="30"
															/>
														)}
														{user[2] ? <img src={u.badge(user[0])} className="donated" /> : null}
													</span>
												)
											})}
										</div>
									) : null}
								</Box>
							)
						}.bind(this),
					)}
				</Box>
			</div>
		)
	},
	updateSort: function (e) {
		if (e && e.target) {
			var sort = {
				by: this.refs.sortby.value,
				type: this.refs.sorttype.value,
				string: this.state.sort.string,
			}
			this.setState({ sort: sort })
		}
	},
	updateFilter: function (e) {
		var sort = {
			by: this.state.sort.by,
			type: this.state.sort.type,
			string: e.target.value,
		}
		this.setState({ sort: sort })
	},
	room_name: function (item) {
		var user = 'Lame Guest'
		if (item[3].length) user = item[3][0][0]
		return item[1].replace(/#name#/g, user)
	},
	join: function (e) {
		if (!$(e.currentTarget).parents('.sidebar-container').length || isMobile) {
			location.hash = 'm/' + $(e.currentTarget).attr('data-id')
		} else {
			window.open('#m/' + $(e.currentTarget).attr('data-id'), '_blank')
		}
	},
	search: function (search, string) {
		string = string.trim().toLowerCase()
		if (search.trim() == '') return true
		//finding "or" conditions
		search = search
			.trim()
			.toLowerCase()
			.replace(/ or /gi, ' ')
			.replace(/,/g, ' ')
			.replace(/ +/g, ' ')
		search = search.split(' ')

		//for each "or" condition - if no "or" conditions was found, this will loop one time.
		for (var id in search) {
			var sub_search = search[id].trim().split(' ')
			var found = false

			//foreach word to search
			for (var id2 in sub_search) {
				var word = sub_search[id2].trim()

				if (word == '' || word == '-' || word == '+') {
					continue
				} else if (word[0] == '-' && string.indexOf(word.replace(/^-/, '')) != -1) {
					found = false
					break
				} else if (word[0] != '-' && string.indexOf(word) == -1) {
					found = false
					break
				} else {
					found = true
				}
			}
			if (found) return true
		}
		return false
	},
})
