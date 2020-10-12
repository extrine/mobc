var Rules = React.createClass({
	mixins: [React.addons.PureRenderMixin],

	render: function() {
		return (
			<div>
				<h1>Rules</h1>
				<hr />
				If you break some of the following Rules, your account <b>may be</b> removed permanently
				without any kind of warning.
				<hr />
				<ol>
					<li>Respect other people. Abuse of any kind will NOT be tolerated.</li>
					<li>If you have a problem with a person talk with the person in private.. </li>
					<li>Blackmailing, harassment, threats, insulting will not be tolerated.</li>
					<li>
						It is forbidden to ask for, or share any kind of personal information about yourself and
						specially others.
					</li>
					<li>
						You can kick anyone from a room if they behave incorrectly. If the kick was justified or
						not it is decided by the admins.
					</li>
					<li>
						At most 2 accounts per person. You are allowed to have a secondary account to play with
						other friends or have some bit of privacy.
					</li>
					<li>
						It is forbidden to share an account, if you share an account you will lose your account
						and any related account automatically. No exceptions.
					</li>
					<li>Anyone participating in hateful discussions, will be banned.</li>
					<li>
						Political and religious discussions are barred from the site unless done in private with
						interested members
					</li>
					<li>
						NO PROFANITY IN ROOM NAMES, OR PROFILE NAMES. NO LEWD PICTURES IN PROFILE
						PICS/GALLERIES/ETC.
					</li>
					<li>
						DO NOT USE ON THIS SITE THE PASSWORD YOU USE FOR OTHER SITES. NEVER GIVE YOUR PASSWORDS
						TO ANYONE INCLUDING ADMINS.
					</li>
					<li>
						Players cannot modify the rules of the games unless the room is private. Exception: bank
						8 in pool could be agreed before hand while the room is public.
					</li>
					<li>
						By using this site, you must comply with these rules. Admins will always have the last
						word on issues.
					</li>
					<li>We reserve the right to modify the rules and site as we please.</li>
					<li>
						Site is +18! You must have at least 18 years old to use it. You must leave if you arent
						at least 18 years old.
					</li>
					<li>
						If you have any doubt just{' '}
						<a className="white" href="#u/omgmobc.com">
							contact us
						</a>
						.
					</li>
				</ol>
				<SeeAlso />
			</div>
		)
	},
})
