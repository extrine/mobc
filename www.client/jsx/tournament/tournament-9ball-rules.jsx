var Tournament9BallRules = React.createClass({
	mixins: [React.addons.PureRenderMixin],

	render: function () {
		return (
			<div>
				<div>
					<h1>MOBC 9 BALL TOURNAMENT</h1>

					<br />
					<h3>
						Please see the{' '}
						<a href="#p/Tournament9BallBrackets" className="white">
							<b>brackets</b>
						</a>
					</h3>
					<br />
					<br />
					<h3>GENERAL RULES:</h3>
					<ol>
						<li>
							People have 6 days to arrange the match. Match should be played before the "Before"
							date.
						</li>
						<li>
							Theres no longer obligation to announce the date and time the game is played for
							others to join the room (if thats possible and desirable by the opponents you may do
							it)
						</li>
						<li>
							If a player fails to show up at the set time both players should make an attempt to
							re-schedule. If that person fails to show a 2nd time it is an auto loss for them
						</li>

						<li>The room may be public or not.</li>
						<li>Do NOT attempt to join the tournament on multiple accounts! </li>

						<li>
							If you want to be against your match result, you should provide a complete video from
							the beginning of the match till the end of it. Failure to have a video, you have no
							case. Decision will be on admins with no right to appeal.
						</li>
						<li>
							If after any round we have an odd number of players remaining then the best loser
							(player who lost by the least ammount of games in that round) will move on to the next
							round. if two or more people are tied for a best loser spot then it will go to the
							person with the best win percentage. the percentages will be gotten from this{' '}
							<a
								href="https://omgmobc.com/img/icon/list5.png"
								target="_blank"
								rel="noopener"
								className="white"
							>
								list of stats
							</a>{' '}
							which was recorded prior to the start of the tournament. a single player can only
							advance as best loser one time during the course of the tournament.
						</li>
					</ol>
				</div>
				<div>
					<h3>GAME RULES:</h3>
					<ol>
						<li>
							We will play best of 7 for all games leading up to the semi-finals, that means the one
							to win 4 matches first goes to next round.
						</li>
						<li>
							The semi-finals will be best of 11, that means the one to win 6 matches first goes to
							the next round
						</li>
						<li>
							The finals will be best of 17, that means the one to win 9 matches first goes to the
							next round
						</li>
						<li>
							If a player gets disconnected during a game that results in an auto loss for them.
						</li>
						<li>
							<b>Break</b>
						</li>
						<ol>
							<li>
								The one with "higher percentage of wins" at the time of the break, breaks the first
								game. They both should take turns regardless of who wins.
							</li>
							<li>
								The break shot should be a "soft break" (no balls potted on break). If the player
								doing the break pots a ball on the break they get two chances to start the game
								over, if it happens three consecutive times then it counts as a loss for them. some
								players might find it slightly more difficult to perform the soft break in 9 ball
								than in 8 ball so it is recomended that you practice this before your match, the
								easiest way is to avoid moving the cue ball when doing the break and shoot straight
							</li>

							<li>
								The player doing the break shot should wait for their opponent to confirm that the
								table has loaded for them before shooting
							</li>
						</ol>

						<li>
							<b>Game Play</b>
						</li>
						<ol>
							<li>the matches will be ALL BANK</li>
							<li>
								As in regular 9 ball games potting the 9 early on a legal shot will win the game but
								ONLY if its the result of a bank shot otherwise it counts as a loss unless another
								foul occurs on the play (such as a scratch) in which case the game will
								automatically reset the 9 ball to its orginal position and play will resume
							</li>
							<li>
								if you fail to bank on any shot where a ball is potted then you must shoot the cue
								ball into a pocket to give it back to your opponet
							</li>
							<li>if you fail to bank the 9 ball then you lose the game</li>
						</ol>
					</ol>
				</div>
				<div>
					<h3>PRIZES:</h3>
					<ol>
						<li>
							Free star status to the overall winner (or upgrade to the next badge level if they are
							already a STAR user) if the winner already has a custom badge they can choose any
							player to give star status to.
						</li>
						<li>Overall winner will get a pool decal designed for them to celebrate their win</li>
						<li>Overall winner will have their victory announced on the site for all to see .</li>
					</ol>
				</div>
			</div>
		)
	},
})
