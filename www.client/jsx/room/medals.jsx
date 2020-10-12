var GameMedals = React.createClass({
	mixins: [React.addons.PureRenderMixin],

	render: function () {
		if (!window.room || !window.room.medals) return null

		var default_multiplier = 5
		var multiplier = default_multiplier
		var medals = {
			gold: window.room.medals.gold[this.props.username] || 0,
			silver: window.room.medals.silver[this.props.username] || 0,
			bronze: window.room.medals.bronze[this.props.username] || 0,
		}

		if (medals.gold + medals.silver + medals.bronze > 20) {
			var multiplier = Math.min(medals.gold, medals.silver, medals.bronze)
			if (multiplier < default_multiplier) multiplier = default_multiplier
		}

		medals.supergold = Math.floor(medals.gold / multiplier)
		medals.supersilver = Math.floor(medals.silver / multiplier)
		medals.superbronze = Math.floor(medals.bronze / multiplier)

		medals.gold -= medals.supergold * multiplier
		medals.silver -= medals.supersilver * multiplier
		medals.bronze -= medals.superbronze * multiplier

		return (
			<div
				className="medals"
				title={
					(beat_captain[this.props.username] > 0
						? 'Beat Captain ' + beat_captain[this.props.username] + ', '
						: '') +
					'Gold ' +
					(medals.gold + medals.supergold * multiplier) +
					', ' +
					'Silver ' +
					(medals.silver + medals.supersilver * multiplier) +
					', ' +
					'Bronze ' +
					(medals.bronze + medals.superbronze * multiplier) +
					', '
				}
			>
				{beat_captain[this.props.username] ? (
					<img className="" src="img/medals/captain.png" />
				) : null}
				{u.repeat(medals.supergold).map(function (_, idx) {
					return <img key={idx} className="hue-rotate" src="img/medals/gold.png?1" />
				})}
				{u.repeat(medals.gold).map(function (_, idx) {
					return <img key={idx} src="img/medals/gold.png?1" />
				})}
				{u.repeat(medals.supersilver).map(function (_, idx) {
					return <img key={idx} className="hue-rotate" src="img/medals/silver.png?1" />
				})}
				{u.repeat(medals.silver).map(function (_, idx) {
					return <img key={idx} src="img/medals/silver.png?1" />
				})}
				{u.repeat(medals.superbronze).map(function (_, idx) {
					return <img key={idx} className="hue-rotate" src="img/medals/bronze.png?1" />
				})}
				{u.repeat(medals.bronze).map(function (_, idx) {
					return <img key={idx} src="img/medals/bronze.png?1" />
				})}
			</div>
		)
	},
})
