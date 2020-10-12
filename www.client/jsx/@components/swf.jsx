var set_swf_size = false
$(window).resize(function() {
	if (set_swf_size && set_swf_size.mounted) {
		var item = $('.game-swf')
		set_swf_size.setState({
			width: item.width(),
			height: item.height(),
		})
	}
})

var SWFObject = React.createClass({
	mixins: [React.addons.PureRenderMixin],
	getInitialState: function() {
		set_swf_size = this
		var item = $('.game-swf')
		return {
			width: item.width(),
			height: item.height(),
		}
	},
	componentDidMount: function() {
		this.mounted = true
		if (
			window.room &&
			(window.room.game == 'balloono' ||
				window.room.game == 'balloonoboot' ||
				window.room.game == 'cuacka' ||
				window.room.game == 'blockles' ||
				window.room.game == 'blocklesmulti' ||
				window.room.game == 'skypigs')
		)
			u.focusGame(true)
	},
	componentWillUnmount: function() {
		this.mounted = false
		u.focusChat()
	},
	render: function() {
		var url = this.props.url
		return has_flash ||
			/fox/i.test(navigator.userAgent) ||
			/edge/i.test(navigator.userAgent) ||
			/opr/i.test(navigator.userAgent) ? (
			<object
				id="game-swf"
				className={'game-' + this.props.name}
				width={this.state.width}
				height={this.state.height}
				type="application/x-shockwave-flash"
				onContextMenu={stopEvent}
				data={url}
			>
				{this.props.color ? <param name="bgcolor" value={this.props.color} /> : null}

				{this.props.color ? (
					<param name="wmode" value="opaque" />
				) : (
					<param name="wmode" value="transparent" />
				)}
				<param name="allowscriptaccess" value="always" />
				<param name="browserzoom" value="noscale" />
				<param name="allowNetworking" value="all" />
				<param name="allowDomain" value="*" />
				<param name="allowInsecureDomain" value="*" />
				<param name="menu" value="false" />

				<param name="width" value={this.state.width} />
				<param name="height" value={this.state.height} />

				{!window.user.fq ? <param name="quality" value="best" /> : null}
				{window.user.fq == 1 ? <param name="quality" value="low" /> : null}
				{window.user.fq == 2 ? <param name="quality" value="autolow" /> : null}
				{window.user.fq == 3 ? <param name="quality" value="autohigh" /> : null}
				{window.user.fq == 4 ? <param name="quality" value="high" /> : null}
				{window.user.fq == 5 ? <param name="quality" value="medium" /> : null}
			</object>
		) : (
			<Box flex center full col>
				<h2>You need Flash Player to play this game</h2>

				<h3> You may use the MOBC Desktop App</h3>

				<br />

				<div>
					<a style={{ color: 'white' }} href="#p/Issues/286">
						Windows
					</a>{' '}
					-{' '}
					<a style={{ color: 'white' }} href="#p/Issues/287">
						Linux
					</a>{' '}
					-{' '}
					<a style={{ color: 'white' }} href="#p/Issues/288">
						Mac
					</a>
				</div>
			</Box>
		)
	},
})
