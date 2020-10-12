var Video = React.createClass({
	mixins: [React.addons.PureRenderMixin],

	render: function () {
		return (
			<video
				muted="true"
				loop="true"
				autoPlay="true"
				width={this.props.width}
				height={this.props.height}
				style={this.props.style}
				title={this.props.title}
				data-sound={this.props.data_sound}
				data-username={this.props.data_username}
				onMouseOver={this.props.onMouseOver}
				onClick={this.props.onClick}
				className={this.props.className}
				onPause={this.log}
				key={this.props.src}
				src={this.props.src}
				ref="video"
			>
				<source
					key={this.props.src}
					src={this.props.src}
					type={'video/' + video_extension(this.props.src)}
				/>
			</video>
		)
	},
	componentDidMount() {
		this.update()
	},

	componentDidUpdate() {
		this.update()
	},
	update() {
		this.refs.video.setAttribute('muted', '1')
		this.refs.video.setAttribute('playsinline', '1')
		this.refs.video.setAttribute('autoplay', '1')
		this.refs.video.setAttribute('loop', '1')
	},

	log: function (e) {
		if (e.target && e.target.play) e.target.play()
	},
})
