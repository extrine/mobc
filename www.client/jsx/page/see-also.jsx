var SeeAlso = React.createClass({
	mixins: [React.addons.PureRenderMixin],

	render: function () {
		return (
			<Box>
				<hr />

				<Box wrap className="see-also" center>
					<div>
						<a className="white no-underline" href="#p/Contribute">
							<span className="underline">Become a STAR</span>
						</a>
					</div>
					<div>
						<a
							className="white"
							target="_blank"
							href="https://www.facebook.com/sharer/sharer.php?u=https%3A%2F%2Fomgmobc.com%2Findex.html#"
						>
							Play With Friends
						</a>
					</div>
					<div>
						<a className="white" href="#p/FAQs">
							Frequently Asked Questions
						</a>
					</div>
					<div>
						<a className="white" href="#p/Rules">
							Site Rules
						</a>
					</div>
					<div>
						<a className="white" href="#p/Chat">
							Chat Help
						</a>
					</div>
					<div>
						<a className="white" href="#p/Emoji">
							Chat Help / Emoji List
						</a>
					</div>
					<div>
						<a className="white" href="#p/Ranking">
							Game Rankings
						</a>
					</div>
					<div>
						<a className="white" href="#p/Settings">
							User Settings and Configuration
						</a>
					</div>
					<div>
						<a className="white" href="#p/Design">
							Design your own pool table, decal and/or emoji
						</a>
					</div>
					<div>
						<a className="white" href="#p/BubblesMapGenerator">
							Bubbles Map Generator
						</a>
					</div>
					<div>
						<a className="white" href="#p/ChangeLog">
							Change Log
						</a>
					</div>
					<div>
						<a className="white" href="#p/Tournaments">
							Tournaments
						</a>
					</div>
					<div>
						<a className="white" href="#p/Issues">
							Issues
						</a>
					</div>
					<div>
						<a className="white" href="#u/omgmobc.com">
							Contact
						</a>
					</div>
				</Box>
			</Box>
		)
	},
})
