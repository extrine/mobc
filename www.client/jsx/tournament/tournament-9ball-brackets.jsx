var Tournament9BallBrackets = React.createClass({
	mixins: [React.addons.PureRenderMixin],

	render: function () {
		var bracket = [
			[
				['Finals', 'Before July 6th', 17],
				/*01*/ ['Rehaaan', 5, 'scixam', 9],
			],
			[
				['Semifinals', 'Before June 29th', 11],
				/*01*/ ['Index', 5, 'Rehaaan', 6],
				/*02*/ ['Jackpool', 3, 'scixam', 6],
			],
			[
				['Round 3', 'Before June 22nd', 7],
				/*01*/ ['Tiks', 2, 'Index', 4],
				/*02*/ ['Rehaaan', 4, 'Harjeev', 3],
				/*03*/ ['toonontherun', 3, 'Jackpool', 4],
				/*04*/ ['scixam', 4, 'Pɾҽƚƚყ💋Pσιʂσɳ', 1],
			],
			[
				['Round 2', 'Before June 15th', 7],
				/*01*/ ['Tiks', 4, 'Blasé', 2],
				/*02*/ ['… III Ali III …', 0, 'Index', 'Winner by default', 0],
				/*03*/ ['Rehaaan', 4, 'Wade', 2],
				/*04*/ ['Leafsman17', 2, 'Harjeev', 4],
				/*05*/ ['Lily', 1, 'toonontherun', 4],
				/*06*/ ['Jackpool', 4, 'Vivek', 3],
				/*07*/ ['Selle', 2, 'scixam', 4],
				/*08*/ ['captain barnacles', 3, 'Pɾҽƚƚყ💋Pσιʂσɳ', 4],
			],
			[
				['Round 1', 'Before June 8th', 7],
				/*01*/ ['Tiks', 4, 'iGee', 1],
				/*02*/ ['Calyx', 1, 'Blasé', 4],
				/*03*/ ['Index', 4, '-Amir-', 3],
				/*04*/ ['Queen Looby', 1, '… III Ali III …', 4],
				/*05*/ ['Roniksome', 1, 'Rehaaan', 4],
				/*06*/ ['Wade', 4, 'iMohammad', 3],
				/*07*/ ['Leafsman17', 4, 'ruben0017', 1],
				/*08*/ ['Dead____Roses', 2, 'Harjeev', 4],
				/*09*/ ['HBK!!!', 3, 'Lily', 4],
				/*10*/ ['LiveVegan', 3, 'toonontherun', 4],
				/*11*/ ['Jackpool', 4, 'taha', 1],
				/*12*/ ['Al-Awan', 1, 'Vivek', 4],
				/*13*/ ['alan', 2, 'Selle', 4],
				/*14*/ ['Tito', 0, 'scixam', 4],
				/*15*/ ['captain barnacles', 4, 'Trix', 1],
				/*16*/ ['Anker.', 2, 'Pɾҽƚƚყ💋Pσιʂσɳ', 4],
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
