var TournamentPoolBrackets = React.createClass({
	mixins: [React.addons.PureRenderMixin],

	render: function() {
		var bracket = [
			[
				['Finals', 'Febuary 24th', 17],
				['Roxann', 7, 'Blasé', 9],
			],
			[
				['Semifinals', 'Febuary 17th', 11],
				/*01*/ ['Roxann', 6, 'Leafsman17', 0],
				/*02*/ ['scixam', 3, 'Blasé', 6],
			],
			[
				['Round 4', 'Febuary 10th', 7],
				/*01*/ ['Roxann', 4, 'Blasé', 0],
				/*02*/ ['iMohammad', 0, 'Leafsman17', 4],
				/*03*/ ['__ hibye __', 0, 'scixam', 'Winner by default', 0],
			],
			[
				['Round 3', 'Febuary 3rd', 7],
				/*01*/ ['Selle', 0, 'Roxann', 4],
				/*02*/ ['Blasé', 4, 'Beach Buddy 1980', 2],
				/*03*/ ['BillA', 0, 'iMohammad', 'Winner by default', 0],
				/*04*/ ['SuGaR+SpIcE', 0, 'Leafsman17', 4],
				/*05*/ ['__ hibye __', 4, 'franzfranzy', 3],
				/*06*/ ['scixam', 4, 'toonontherun', 3],
			],
			[
				['Round 2', 'January 27th', 7],
				/*01*/ ['Tiks', 2, 'Selle', 4],
				/*02*/ ['Roxann', 4, 'captain barnacles', 0],
				/*03*/ ['alan', 1, 'Blasé', 4],
				/*04*/ ['Wade', 0, 'Beach Buddy 1980', 4],
				/*05*/ ['LiveVegan', 2, 'BillA', 4],
				/*06*/ ['iMohammad', 4, 'billtran9', 0],
				/*07*/ ['SuGaR+SpIcE', 4, 'Dead____Roses', 0],
				/*08*/ ['Lovebug', 1, 'Leafsman17', 4],
				/*09*/ ['__ hibye __', 4, 'toonontherun', 2],
				/*10*/ ['DEWONNA', 0, 'franzfranzy', 'Winner by default', 0],
				/*11*/ ['scixam', 4, 'HBK!!!', 1],
			],
			[
				['Round 1', 'January 20th', 7],
				/*01*/ ['Tiks', 4, 'Aloha808Ninja', 2],
				/*02*/ ['Doug2x', 2, 'Selle', 4],
				/*03*/ ['Edu016', 0, 'Roxann', 4],
				/*04*/ ['captain barnacles', 4, 'rahim sani', 2],
				/*05*/ ['taha', 0, 'alan', 'Winner by default', 0],
				/*06*/ ['Awanpaswal', 2, 'Blasé', 4],
				/*07*/ ['Rehaaan', 3, 'Wade', 4],
				/*08*/ ['Anker.', 3, 'Beach Buddy 1980', 4],
				/*09*/ ['D Joe', 3, 'LiveVegan', 4],
				/*10*/ ['BillA', 4, 'Looby Loo', 2],
				/*11*/ ['xavier', 2, 'iMohammad', 4],
				/*12*/ ['billtran9', 4, 'Rosee.', 3],
				/*13*/ ['SuGaR+SpIcE', 4, 'Calyx', 1],
				/*14*/ ['babie', 1, 'Dead____Roses', 4],
				/*15*/ ['lover', 0, 'Lovebug', 'Winner by default', 0],
				/*16*/ ['Wɐɹɹobnᴉu', 0, 'Leafsman17', 4],
				/*17*/ ['𝑹𝑶𝑿', 1, '__ hibye __', 4],
				/*18*/ ['Jackomatic', 1, 'toonontherun', 4],
				/*19*/ ['franzfranzy', 4, 'BIRDS-EYE', 0],
				/*20*/ ['DEWONNA', 4, 'ruben0017', 2],
				/*21*/ ['scixam', 4, 'FOXYlady', 0],
				/*22*/ ['RkingK', 0, 'HBK!!!', 'Winner by default', 0],
			],
		]
		return (
			<div>
				<div>
					<h1>MOBC POOL TOURNAMENT BRACKETS</h1>
					<hr />
					You should arrange your match with your oponent. Please see the{' '}
					<a className="white" href="#p/Tournaments" className="white">
						rules
					</a>
					.
				</div>
				<hr />
				{bracket.map((round, idx) => {
					var group = [...round]
					group.shift()
					return (
						<div key={idx}>
							<h2>
								{round[0][0]} ( Before {round[0][1]} )
							</h2>
							<small style={{ marginLeft: '10px' }}>
								Best of {round[0][2]} ( First to win {round[0][2] / 2 + 0.5} )
							</small>
							<hr />
							{group.map((data, i) => {
								return (
									<ul key={i}>
										{i > 0 && i % 2 == 0 ? <hr /> : null}
										{i > 0 && i % 4 == 0 ? <hr /> : null}
										{i > 0 && i % 8 == 0 ? <hr /> : null}

										<li>Group {i + 1}</li>
										<ul>
											<li>
												<a className="white" href={'#u/' + data[0]}>
													{data[0]}
												</a>{' '}
												({data[1]}){' '}
												{(round[0][0] === 'Finals' && data[1] === 9) ||
												(round[0][0] === 'Semifinals' && data[1] === 6) ||
												(round[0][0] !== 'Finals' &&
													round[0][0] !== 'Semifinals' &&
													data[1] === 4) ? (
													<img src="img/badge/winner.png" />
												) : null}
											</li>
											<li>
												<a className="white" href={'#u/' + data[2]}>
													{data[2]}
												</a>{' '}
												({data[3]}){' '}
												{(round[0][0] === 'Finals' && data[3] === 9) ||
												(round[0][0] === 'Semifinals' && data[3] === 6) ||
												(round[0][0] !== 'Finals' &&
													round[0][0] !== 'Semifinals' &&
													data[3] === 4) ? (
													<img src="img/badge/winner.png" />
												) : null}
											</li>
										</ul>
									</ul>
								)
							})}
							<hr />
						</div>
					)
				})}
				<div>
					<SeeAlso />
				</div>
			</div>
		)
	},
})
