var BubblesMapGenerator = React.createClass({
	mixins: [React.addons.PureRenderMixin],

	render: function () {
		var rows = [0, 1, 2, 3, 4, 5, 6, 7, 8]

		return (
			<div>
				<h1>Create Your Own Bubbles Map</h1>
				<hr />

				<div>
					Just click the map to set the colors. NOTE: Please do NOT use black dingles unless you
					know what you doing.
				</div>
				<br />
				<br />
				{rows.map(
					function (row, idrow) {
						if (idrow % 2 == 0) var cols = [0, 1, 2, 3, 4, 5, 6, 7, 8]
						else var cols = [0, 1, 2, 3, 4, 5, 6, 7]

						return (
							<div className="row" key={idrow}>
								{cols.map(
									function (col, idcol) {
										return (
											<span
												key={idrow + ',' + idcol}
												id={'col' + idcol + 'row' + idrow}
												className="bubble"
												onClick={this.changeColor}
											>
												⭕
											</span>
										)
									}.bind(this),
								)}
							</div>
						)
					}.bind(this),
				)}
				<br />
				<br />
				<div id="result" onClick="">
					["_ _ _ _ _ _ _ _ _",
					<br />
					"_ _ _ _ _ _ _ _",
					<br />
					"_ _ _ _ _ _ _ _ _",
					<br />
					"_ _ _ _ _ _ _ _",
					<br />
					"_ _ _ _ _ _ _ _ _",
					<br />
					"_ _ _ _ _ _ _ _",
					<br />
					"_ _ _ _ _ _ _ _ _",
					<br />
					"_ _ _ _ _ _ _ _",
					<br />
					"_ _ _ _ _ _ _ _ _"]
					<br />
				</div>
				<div>
					Paste the code above into the "
					<a className="white" href="#u/omgmobc.com">
						contact us page
					</a>
					" so we can review and maybe add it to the game :)
				</div>
			</div>
		)
	},
	item: function (row, col) {
		var item = document.getElementById('col' + col + 'row' + row)

		switch (item.style.backgroundColor) {
			case '':
				return '_'
			case 'orange':
				return 'a'
			case 'green':
				return 'b'
			case 'blue':
				return 'c'
			case 'yellow':
				return 'd'
			case 'pink':
				return 'e'
			case 'black':
				return 'f'
			default:
				return '_'
		}
	},
	generateCode: function () {
		var map = '['
		var rows = [0, 1, 2, 3, 4, 5, 6, 7, 8]
		for (var idrow in rows) {
			map += '"'
			if (idrow % 2 == 0) var cols = [0, 1, 2, 3, 4, 5, 6, 7, 8]
			else var cols = [0, 1, 2, 3, 4, 5, 6, 7]
			for (var idcol in cols) {
				map += this.item(idrow, idcol) + ' '
			}
			map = map.replace(/ $/, '')
			map += '",\n'
		}
		map = map.replace(/,\n$/, '')

		map += ']'
		document.getElementById('result').innerHTML = map
	},
	changeColor: function (event) {
		var item = event.target

		if (!item.style.backgroundColor || item.style.backgroundColor == '')
			item.style.backgroundColor = 'orange'
		else if (item.style.backgroundColor == 'orange') item.style.backgroundColor = 'green'
		else if (item.style.backgroundColor == 'green') item.style.backgroundColor = 'blue'
		else if (item.style.backgroundColor == 'blue') item.style.backgroundColor = 'yellow'
		else if (item.style.backgroundColor == 'yellow') item.style.backgroundColor = 'pink'
		else if (item.style.backgroundColor == 'pink') item.style.backgroundColor = 'black'
		else if (item.style.backgroundColor == 'black') item.style.backgroundColor = ''
		this.generateCode()
	},
})
