var SearchCache = {}
var Search = React.createClass({
	mixins: [React.addons.PureRenderMixin],
	getInitialState: function () {
		this.timeout = false
		return {
			users: [],
			searching: false,
		}
	},
	render: function () {
		var displayed = {}
		return (
			<div className="search">
				<h1>
					{this.state.searching ? (
						<span>
							<Loading className="search-loading" /> Searching for "{this.props.username} " ...
						</span>
					) : (
						'Search for "' +
						this.props.username +
						'" done, results  ' +
						this.state.users.length +
						''
					)}
				</h1>
				<hr />
				<input
					type="text"
					className="textbox w50"
					defaultValue={this.props.username}
					placeholder="Type a username here.."
					onKeyUp={this.search}
					onKeyDown={this.search}
					onChange={this.search}
					onFocus={this.search}
					onBlur={this.search}
					maxLength="20"
				/>
				<div className="button">Search</div>
				<hr />
				<div className="clear" />
				<ul className="column">
					{this.state.users.map(
						function (item, id) {
							if (displayed[item.u]) return null
							displayed[item.u] = true
							var style = {
								borderColor: item.c || 'white',
								borderTopColor: item.c || 'white',
							}
							return (
								<li key={id}>
									{is_video(item.i) ? (
										<img
											width="67"
											height="67"
											style={style}
											className="image pointer"
											title={item.u}
											data-username={item.u}
											onClick={openProfile}
											src={profile_picture(item.i).replace(/\.[^\.]+$/, '.png')}
										/>
									) : (
										<img
											width="67"
											height="67"
											style={style}
											className="image pointer"
											title={item.u}
											data-username={item.u}
											onClick={openProfile}
											src={profile_picture(item.i)}
										/>
									)}

									<b className="username">{item.u}</b>
									<br />
									<span className="status" title={item.s}>
										{item.s}
									</span>
								</li>
							)
						}.bind(this),
					)}
				</ul>
				<div className="clear" />
				<SeeAlso />
			</div>
		)
	},
	search: function () {
		var v = $('.page .textbox').val().trim().substr(0, 20)
		location.hash = 'p/Search/' + encodeURIComponent(v)
	},
	update: function () {
		var v = $('.page .textbox').val().trim().substr(0, 20)
		clearTimeout(this.timeout)
		this.timeout = setTimeout(
			function () {
				if (v && v != '') {
					if (!this.mounted) return
					this.setState({
						searching: true,
						users: [],
					})
					if (SearchCache[v]) {
						this.setState({
							users: SearchCache[v],
						})
						this.setState({
							searching: false,
						})
					} else {
						emit(
							{
								id: 'search',
								v: v,
							},
							function (data) {
								if (!this.mounted) return

								SearchCache[v] = data
								this.setState({
									users: data,
								})
								this.setState({
									searching: false,
								})
							}.bind(this),
						)
					}
				}
			}.bind(this),
			350,
		)
	},
	componentDidMount: function () {
		this.mounted = true
		this.update()
	},
	componentWillUnmount: function () {
		this.mounted = false
	},
	componentWillReceiveProps: function () {
		this.update()
	},
})
