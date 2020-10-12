var Design = React.createClass({
	mixins: [React.addons.PureRenderMixin],

	render: function () {
		return (
			<div>
				<h1>Designs</h1>
				<hr />
				Some users improve the site by sending designs, here some guidelines, thanks a lot!
				<hr />
				<ul>
					<li>Q: Where do I submit designs?</li>
					<li>
						A:
						<br />
						1. First please be sure graphic is final and take your time to check if does comply with
						the specifications.
						<br />
						2. Give to your design a name.
						<br />
						3. Give links to the images AND a name in the{' '}
						<a className="white" href="#u/omgmobc.com">
							write to an admin
						</a>{' '}
						page.
						<br />
						4. Instead of posting the images in write to admin you may send us an email to:
						omg@omgmobc.com
						<br />
						5. If you fail to follow the specifications, we may reject it.
						<br />
						<br />
					</li>

					<li>Q: Emoji specifications?</li>
					<li>
						A:
						<br />
						1. Image should be in PNG 64x64 with everything <b>NOT</b> used transparent.
						<br />
						2. Do not resize it.
						<br />
						3. You must use this <img src="https://omgmobc.com/img/icon/@template.png" />
						<br />
						4. If you do not follow the sun pattern emoji will not be accepted.
						<br />
						5. Please do not completely cover the sun with your design.
						<br />
						<br />
						<br />
					</li>

					<li>Q: Decal specifications?</li>
					<li>
						A:
						<br />
						1. Image should be in PNG 24 1376x688 2:1 with everything <b>NOT</b> used transparent.
						<br />
						2. Do not resize it.
						<br />
						3. You may use this one as{' '}
						<a
							className="white"
							href="https://omgmobc.com/img/template/decal-template.png"
							target="_blank"
						>
							template
						</a>
						.<br />
						<br />
					</li>

					<li>Q: Table design specifications?</li>
					<li>
						A:
						<br />
						1. Image should be in PNG 1523x841 with everything <b>NOT</b> used transparent.
						<br />
						2. Do not resize it.
						<br />
						3. You may use this one as{' '}
						<a
							className="white"
							href="https://omgmobc.com/img/template/table-template.png"
							target="_blank"
						>
							template
						</a>
						.<br />
						4. Do not draw in the centre or green felt because balls will lose shadow, if you want a
						decal make a decal instead of a table.
						<br />
						5. Image should at the end look somewhat{' '}
						<a
							className="white"
							href="https://omgmobc.com/img/template/table-example.png"
							target="_blank"
						>
							like this
						</a>
						, no pocket, felt and stuff because the final product is something{' '}
						<a
							className="white"
							href="https://omgmobc.com/img/template/table-example2.png"
							target="_blank"
						>
							like this
						</a>
						<br />
						<br />
					</li>

					<li>Q: Profile pic specifications?</li>
					<li>
						A:
						<br />
						1. Profile pic will be resized to 310x310.
						<br />
						<br />
					</li>

					<li>Q: Cover pic specifications?</li>
					<li>
						A:
						<br />
						1. Cover pic will be resized to 1500x1125 4:3.
						<br />
						<br />
					</li>

					<li>Q: Pictures/Audio/Videos Formats?</li>
					<li>
						A: Supported formats are: {link_all_formats.join(', ')}.
						<br />
						<br />
					</li>

					<li>Q: Pictures/Audio/Videos Size Limits?</li>
					<li>
						A: Max size for videos/gifs 4Mb for pictures 20Mb. Pictures are resized down for profile
						pics so the size on your "room picture" will be small. However, in the case of videos we
						need to serve the video as is because we dont process them, thats why the size of the
						video/gif should be relative small.
						<br />
						<br />
					</li>
				</ul>
				<SeeAlso />
			</div>
		)
	},
})
