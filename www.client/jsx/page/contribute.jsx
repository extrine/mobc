var Contribute = React.createClass({
	mixins: [React.addons.PureRenderMixin],

	render: function () {
		return (
			<div>
				<h1>STAR Users</h1>
				<hr />
				This site is run by volunteers, developers and administrators, however, running the website
				costs money and we rely on donations from users to cover these costs.
				<br />
				<br />
				By becoming STAR you can do the following:
				<ul>
					<li>create direct private chat with one or more people (bottom left)</li>
					<li>invite users to chat groups</li>
					<li>change match settings to private to play with other star players</li>
					<li>change room name when host</li>
					<li>
						request username changes (the number of times you can request a name change very
						depending on how much you have contributed. see below for details)
					</li>
				</ul>
				There are different types of STAR badges depending on the amount you donate:
				<ul>
					<li>blue star badge + option for one time name change - 15 USD</li>
					<li>golden star badge + up to two name changes - 30 USD</li>
					<li>
						any color star badge (this is a standard 'STAR' badge with regular white text and one
						background color of your choice) + up to three name changes - 40 USD
					</li>
					<li>custom colors and text for the badge + up to four name changes - 50 USD</li>
				</ul>
				You can do it via the following channels:
				<ul>
					<li>
						<a
							target="_blank"
							href="https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=AS27SER9A86D2"
							className="white"
						>
							<b>Paypal</b>
						</a>
					</li>
					<li>
						Facebook (
						<a className="pointer underline white" href="#u/omgmobc.com">
							ask for details here
						</a>
						)
					</li>
					<li>
						Google Wallet (
						<a className="pointer underline white" href="#u/omgmobc.com">
							ask for details here
						</a>
						)
					</li>
					<li>
						Wester Union (
						<a className="pointer underline white" href="#u/omgmobc.com">
							ask for details here
						</a>
						)
					</li>
				</ul>
				For more information on donating via alternate payment methods, please write{' '}
				<a className="pointer underline white" href="#u/omgmobc.com">
					here
				</a>{' '}
				<br />
				<br />
				If you have already made a donation but haven't received star, Please share the payment
				method you used and any relevant information like the transaction ID{' '}
				<a className="pointer underline white" href="#u/omgmobc.com">
					here
				</a>
				. Sometimes, we are unable to match the source of a donation with a particular
				account/username, so please provide us with the relevant information and allow us a couple
				of days.
				<br />
				<br />
				Please Note: Donating does not grant you immunity from any of the rules or the right to
				abuse/harass other players. Donating does not entitle you to be upgraded to “Power User” or
				grant you any privileges other than those mentioned above. Donating exists for the purpose
				to keep the site alive and running. We deeply appreciate your support and effort! Thank you
				very much! <br />
				<br />
				<h2>Frequently Asked Questions About Contributions</h2>
				<hr />
				If a question is not answered here, you may{' '}
				<a className="pointer underline white" href="#u/omgmobc.com">
					contact us
				</a>
				<hr />
				<ul>
					<li>Q: What do you do with the money?</li>
					<li>
						A: We use the donations to meet the website maintenance costs such as servers,
						certificates, domain name, etc.
						<br />
						<br />
					</li>

					<li>Q: I'm not sure if I should contribute:..</li>
					<li>
						A: If you gonna miss the people around this site if ever comes offline one day... then
						we suggest you to considerate to make a donation.. or If you use the site daily or for
						"long periods of time"
						<br />
						<br />
					</li>

					<li>Q: How much does it cost to keep the site operational?</li>
					<li>
						A: That's relative to the amount of users, if usage continues to be somewhat low as it
						is currently, the cost is around 1500USD/year.
						<br />
						<br />
					</li>

					<li>Q: You aren't looking for profits?</li>
					<li>
						A: No, we do not want to profit or make a living off this site.
						<br />
						<br />
					</li>

					<li>Q: If you don't profit how do you keep site running?</li>
					<li>
						A: With the help of volunteers’ work and donations to keep up with the costs.
						<br />
						<br />
					</li>

					<li>Q: What will you do if the site becomes popular?</li>
					<li>
						A: We will give priority to all users that donated.
						<br />
						<br />
					</li>

					<li>Q: How much should I donate?</li>
					<li>
						A: Well, there's no minimum amount, you can donate as much as you can/wish, we suggest
						to try to help with around 50 USD once a year. If you can't reach this amount that is
						OK, every bit counts and we are deeply grateful for it.!
						<br />
						<br />
					</li>

					<li>Q: I already donated, can I donate again?.</li>
					<li>
						A: Of course, we appreciate your support!
						<br />
						<br />
					</li>

					<li>Q: Badge preview!?</li>
					<li>
						A: You may use the{' '}
						<a
							href="http://nothingbutpop.freetzi.com/tag/"
							target="_blank"
							rel="noopener"
							className="white"
						>
							badge generator
						</a>{' '}
						to preview it
						<br />
						<br />
					</li>

					<li>Q: I donated and I'm now banned</li>
					<li>
						A: Yeah... well yes, we are sorry, but our first priority is to protect and preserve
						this community, so donating does not give you immunity from the rules (read as
						abusing/harassing other users). <br />
						<br />
					</li>

					<li>Q: How long do I have to wait for “star” status to be activated after donating?</li>
					<li>
						A: It can take up to a couple of days to verify your donation and upgrade your profile
						to “STAR” status. If you have not received STAR even after a few days please{' '}
						<a className="pointer underline white" href="#u/omgmobc.com">
							contact us
						</a>{' '}
						<br />
						<br />
					</li>

					<li>Q: Can I donate for a friend?</li>
					<li>
						A: Yes, please provide us the necessary information to verify your donation along with
						the username of the person on behalf of whom you are donating. <br />
						<br />
					</li>
				</ul>
				<SeeAlso />
			</div>
		)
	},
})
