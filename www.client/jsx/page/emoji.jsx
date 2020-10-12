var Emoji = React.createClass({
	mixins: [React.addons.PureRenderMixin],

	render: function () {
		return (
			<div className="emoji-list">
				<h1>Emoji List</h1>
				<hr />
				Here have the complete uptodate emoji list to use on chat or user profiles.
				<TabArea>
					{u.emojies_keys.map(function (key) {
						var emojies = {}
						Object.keys(u.emojies[key]).forEach(function (item) {
							if (!emojies[u.emojies[key][item]]) {
								emojies[u.emojies[key][item]] = item
							} else {
								emojies[u.emojies[key][item]] += ' ' + item
							}
						})
						return (
							<Tab id={key} title={key} key={key}>
								<hr />
								<h2>{key} Emojies</h2>
								<hr />
								<ul className="column">
									{Object.keys(emojies).map(function (item, idx) {
										return (
											<li key={idx}>
												<img src={'https://omgmobc.com/img/icon/' + item} />
												{emojies[item]}
											</li>
										)
									})}
								</ul>
							</Tab>
						)
					})}
				</TabArea>
				<SeeAlso />
			</div>
		)
	},
})
