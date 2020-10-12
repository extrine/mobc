var BarGraph = React.createClass({
	render: function () {
		var days = Object.keys(this.props.data)
		var data = []
		for (var day in days) {
			data.push([days[day], this.props.data[days[day]][this.props.id]])
		}

		var max = data.reduce(function (x, y) {
			return x[1] > y[1] ? x : y
		})[1]

		return (
			<div className="bar-graph">
				<span className="graph-name">{this.props.id.replace('_', ' ')}</span>
				{data.map((d, i) => {
					var red = this.props.red ? i * 5 : 0,
						green = this.props.green ? i * 5 : 0,
						blue = this.props.blue ? i * 5 : 0
					var style = {
						height: (d[1] / max) * 100 + '%',
						backgroundColor: 'rgba(' + red + ', ' + green + ', ' + blue + ', 0.6',
					}
					return (
						<div key={'bar' + i} className="bar-graph-bar" style={style} title={d[0] + '-' + d[1]}>
							{i}
						</div>
					)
				})}
			</div>
		)
	},
})

var LineGraph = React.createClass({
	render: function () {
		var wanted = this.props.ids.split(' ')
		var data = []
		var max = 0

		var days = Object.keys(this.props.data)

		if (this.props.period === 'day') {
			var day = days[days.length - 1]
			for (var want in wanted) {
				max += this.props.data[day][wanted[want]]
				data.push([wanted[want], this.props.data[day][wanted[want]]])
			}
		} else {
			var count = this.props.period === 'week' ? 7 : this.props.period === 'month' ? 30 : 360
			days = days.slice(0, count)

			var items = {}

			for (var day in days) {
				for (var want in wanted) {
					max += this.props.data[days[day]][wanted[want]]
					if (items[[wanted[want]]])
						items[[wanted[want]]] += this.props.data[days[day]][wanted[want]]
					else items[wanted[want]] = this.props.data[days[day]][wanted[want]]
				}
			}
			data = Object.keys(items).map((key, i) => {
				return [key, items[key]]
			})
		}

		data.sort(function (a, b) {
			return a[1] - b[1]
		})
		return (
			<div className="line-graph">
				<span className="graph-name">{this.props.id.replace('_', ' ')}</span>
				{data.map((d, i) => {
					var val = Math.round(255 / data.length)
					var red = this.props.red ? i * val : 0,
						green = this.props.green ? i * val : 0,
						blue = this.props.blue ? i * val : 0
					var width = (d[1] / max) * 100
					var style = {
						width: width + '%',
						backgroundColor: 'rgba(' + red + ', ' + green + ', ' + blue + ', 0.6',
					}
					return (
						<div
							className="line-graph-line"
							style={style}
							title={d[0] + '-' + d[1] + ' (' + Math.round(width) + '%)'}
						>
							{d[0].replace('_games', '')}
						</div>
					)
				})}
			</div>
		)
	},
})
