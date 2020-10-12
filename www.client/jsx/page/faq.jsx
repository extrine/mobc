var FAQs = React.createClass({
	mixins: [React.addons.PureRenderMixin],

	render: function () {
		return (
			<div>
				<h1>Frequently Asked Questions</h1>
				<hr />
				If a question is not answered here, ask{' '}
				<a className="white" href="#u/omgmobc.com">
					here
				</a>
				:<hr />
				<ul>
					<li>Q: What happened to omgpop?</li>
					<li>
						A: Omgpop was closed. We are unrelated to the previous site. Volunteers help to develop
						and maintain the site, and users help to pay for site resources. We do not profit from
						this site. This site and its games exist mainly to reconnect with people we lost and for
						nostalgia’s sake.
						<br />
						<br />
					</li>

					<li>Q: How do I create or join a game?</li>
					<li>
						A: You can see a list of the games on the left panel on the main page. You can click on
						any of them to create a game. You can also see all the public games that have been
						created by other people; You can join any one of them.
						<br />
						<br />
					</li>

					<li>Q: How do I invite a friend to my game?</li>
					<li>
						A: You can invite other people by sharing the URL of the match.
						<br />
						<br />
					</li>

					<li>Q: What does the number in red in my profile mean?</li>
					<li>
						A: Is just the number of visits your profile had, one user visiting your profile many
						times will count as 1 visit.
						<br />
						<br />
					</li>

					<li>Q: Someone is being mean to me, what do I do?</li>
					<li>
						A: Feel free to report the user in the contact page. Unfortunately we can't monitor and
						control every social situation at the time of interaction. We've added a user block
						feature for this reason. Block them from their profile, and stay out of their rooms to
						avoid further issues!
						<br />
						<br />
					</li>
				</ul>
				<SeeAlso />
			</div>
		)
	},
})
