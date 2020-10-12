var ChatHelp = React.createClass({
	mixins: [React.addons.PureRenderMixin],

	render: function () {
		var arrow = <span style={{ color: 'lime' }}>➡</span>
		return (
			<div>
				<h1>Chat Help!</h1>
				<hr />
				Help for chat-related stuff.
				<hr />
				<h2>Markup</h2>
				<ul>
					<li>Single word tags</li>
					<ul>
						<li>
							*bold* {arrow} <b>bold</b>
						</li>
						<li>
							/italics/ {arrow} <i>italics</i>
						</li>
						<li>
							_underline_ {arrow} <u>underline</u>
						</li>
						<li>
							-strike- {arrow} <s>strike</s>
						</li>
					</ul>
					<br />
					<li>Full message Tags (Must be first character)</li>
					<ul>
						<li>
							*bold all the things {arrow} <b>bold all the things</b>
						</li>
						<li>
							/italics all the things {arrow} <i>italics all the things</i>
						</li>
						<li>
							_underline all the things {arrow} <u>underline all the things</u>
						</li>
						<li>
							-strike all the things {arrow} <s>strike all the things</s>
						</li>
					</ul>
					<br />
					<li>Arithmetic (Do not include spaces)</li>
					<ul>
						<li>5+5 {arrow} calculator: 10</li>
						<li>5-5 {arrow} calculator: 0</li>
						<li>5*5 {arrow} calculator: 25</li>
						<li>5/5 {arrow} calculator: 1</li>
						<li>(5+5)*(5/5) {arrow} calculator: 10</li>
					</ul>
				</ul>
				<hr />
				<h2>Q&A</h2>
				<ul>
					<li>Q: I want to clear the history of messages!?</li>

					<li>
						A: Just press ENTER while holding CTRL in the chatbox without anything written and all
						the messages will disappear.
						<br />
						<br />
					</li>

					<li>
						Q: How to prevent the chat from auto-scrolling? I want to read something but keeps
						moving!
					</li>
					<li>
						A: Just Hold the ALT key and chat will stop auto-scrolling to bottom while you have that
						key pressed. It may continues moving because new messages arrive, but just a bit, not to
						the bottom.
						<br />
						<br />
					</li>

					<li>Q: Is there a list of emojis!?</li>
					<li>
						A: Yes in the following{' '}
						<a className="white underline" href="#p/Emoji">
							link
						</a>
						.<br />
						<br />
					</li>

					<li>Q: How can I make the text bigger?</li>
					<li>
						A: With browser "zoom". Press CTRL++ to make bigger, CTRL--- to make smaller.
						<br />
						<br />
					</li>

					<li>Q: How to make an emoji bigger?</li>
					<li>
						A: Add a "."(dot) to the end of the emoji, for example if you want a big ":)" just type
						":)."
						<br />
						<br />
					</li>

					<li>Q: YouTube does not have sound?</li>
					<li>
						A: Full-screen the video and check if sound on YouTube is muted.
						<br />
						<br />
					</li>

					<li>Q: Quickly switching between game and chat?</li>
					<li>
						A: You can press TAB key to switch to the chat and start typing, once you done you can
						press TAB again to focus the game. This come in handy in blockles which requires
						pressing keys to play.
						<br />
						<br />
					</li>
				</ul>
				<SeeAlso />
			</div>
		)
	},
})
