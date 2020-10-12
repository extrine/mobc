var TournamentDingleRules = React.createClass({
	mixins: [React.addons.PureRenderMixin],

	render: function () {
		return (
			<div>
				<div>
					<h1>MOBC DINGLE TOURNAMENT</h1>
					<br />
					Hello fellow omgpopers, <br /> <br /> We are hosting a Dinglepop 2v2 teams tournament with
					the ability of choosing your partner. Here are the details:
					<br />
					<br />
					<h3>
						Brackets to be defined
						{/*Please see the{' '}
						<a
							href="https://omgmobc.com/img/icon/brackets.png"
							target="_blank"
							rel="noopener"
							className="white"
						>
							brackets
						</a>{' '}*/}
					</h3>
					<br />
					<br />
					<h3>LEGEND:</h3>
					<ol>
						<li>Dingle Ni : Dingle no items</li>
						<li>Dingle M : Dingle with items</li>
					</ol>
					<h3>REGISTRATION:</h3>
					<ol>
						<li>
							Write the username OR link the profile of the player(s) you want to team up with on
							the{' '}
							<a href="#u/omgmobc.com" rel="noopener" className="white">
								admin wall
							</a>
							.
						</li>
						<li>
							If two players choose one another, they'll be in a team, otherwise a teammate will be
							chosen for you.
						</li>
						<li>
							Each player is only allowed to register with 1 account, no alternative accounts are
							allowed. If you try to participate with two accounts you will be disqualified
						</li>
					</ol>
					<h3>MATCH MAKING:</h3>
					<ol>
						<li>
							A time should be arranged by the team leaders that suits both teams for a scheduled
							match.
						</li>
						<li>
							Players can play their match before or after the scheduled time if both teams are
							available to do so.
						</li>
						<li>
							A referee is not mandatory until Semi-finals. If you would like to request a referee:
							type in the lobby chat "/dingle Ready for my dingle round" (without the quotations) If
							there is no response within 10 minutes, wait until the scheduled time or try again
							later.
						</li>
						<li>
							Team leaders should report the match results onto the admin wall. If a disagreement
							occurs about the score. The match will be reset with a mandatory referee, unless there
							is video evidence of the entire match . If video evidence is provided, the admins will
							review the footage and reach a verdict. This decision can't be appealed.
						</li>
						<li>
							As a substitution for spectating, players will use{' '}
							<a href="https://quack.uy/" rel="noopener" target="_blank" className="white ">
								this site
							</a>{' '}
							to share their screen. Players who lag can refrain from using it, but it’s recommended
							that at least 1 player share their screen, otherwise the referee will be useless (this
							is optional until Semi-finals).
						</li>
						<li>
							If a player fails to show up, you can request another partner as long as the player
							hasn't participated in the tournament. Otherwise another time may be arranged by both
							parties. If they fail to show up for the second time, the opposing team will be
							declared the winner by default.
						</li>
						<li>
							If a schedule cannot be decided, each player will be contacted. If they fail to reach
							a schedule, the team with the most attempts will be declared the winner by default.
						</li>
						<li>
							Semi-finals and finals must have a referee and at least 1 player must use screen
							share.
						</li>
					</ol>
					<h3>GAME RULES:</h3>
					<ol>
						<li>
							All rounds leading up to the semi-finals will be first to 10 (First to 5 in NI, then
							first to 5 in M).
						</li>
						<li>Semi-finals will be first to 15. (8 NI, 7 M).</li>
						<li>Finals will be first to 20. (10 NI, 10 M).</li>
						<li>
							All rounds will be split in half between NI and M. The team with the most points at
							the end wins.
						</li>
						<li>Free items will be allowed in DingleM.</li>
						<li>
							If a player starts late, the match will be reset immediately for 1 round. If this
							occurs consecutively it'll be a disqualification and the other team will gain a point
							for that round.
						</li>
						<li>
							If a player disconnects in the middle of a match, it could be replayed as long as they
							provide proof to the opposing team of the disconnection. Only 1 disconnection is
							tolerated per 1 set. So if you disconnect twice you lose that round.
						</li>
						<li>
							A kill swap* is a disqualification* This also applies for attempted kill swaps*. It's
							for the best if you don't shoot in a straight line or lower your wall too much before
							swapping to avoid disqualification.
						</li>
						<li>
							If a player loses from a floater, the round resets. Unless they had no obvious chance
							of surviving regardless, or if the referee decides otherwise.
						</li>
					</ol>
					<h3>DISQUALIFICATION:</h3>
					<ol>
						<li>Disqualification: The opposing team gets a point for that round</li>
						<li>
							Kill swap: A swap which immediately kills the receiving player due to insufficient
							reaction time{' '}
						</li>
						<li>
							Attempted Kill swap: Purposely shooting in a straight line to make your board as low
							as possible in order to swap your opponent and kill them with 1 red item, or after
							they shoot once.
						</li>
					</ol>
					<h3>PRIZES:</h3>
					<ol>
						<li>
							A free star will be awarded to each player of the winning team. In the event a player
							already owns an existing star, it'll then be upgraded to a custom badge. If the
							player(s) owns a custom badge, the user(s) of the winning team may gift a star to a
							user of their choosing.
						</li>
						<li>
							Each player of the winning team will receive a "Dinglepop Champion" medal on their
							profile.
						</li>
						<li>Their victory will be announced on the entire site.</li>
					</ol>
				</div>
			</div>
		)
	},
})
