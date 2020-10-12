var Tournaments = React.createClass({
	mixins: [React.addons.PureRenderMixin],

	render: function () {
		return (
			<div>
				<div>
					<h1>MOBC TOURNAMENTS</h1>
					<hr />
					From time to time we host game Tournaments. Here are the details. This document may be
					modified, so pay attention! In any case please write to us{' '}
					<a href="#u/omgmobc.com" className="white">
						omgmobc.com
					</a>{' '}
					♥.
					<br />
					<br />
					<h3>ACTIVE TOURNAMENTS</h3>
					<details>
						<summary>9 Ball [click here for details]</summary>
						<Tournament9BallRules />
						<br />
						<hr />
					</details>
					<details>
						<summary>Dingle [click here for details]</summary>
						<TournamentDingleRules />
						<br />
						<hr />
					</details>
					<br />
					<h3>INACTIVE TOURNAMENTS</h3>
					<details>
						<summary>Pool [click here for details]</summary>
						<TournamentPoolRules />
						<br />
						<hr />
					</details>
					<details>
						<summary>Swapples [click here for details]</summary>
						<TournamentSwapplesRules />
						<br />
						<hr />
					</details>
				</div>

				<div>
					<SeeAlso />
				</div>
			</div>
		)
	},
})
