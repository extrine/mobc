var Player = React.createClass({
	mixins: [React.addons.PureRenderMixin],

	getInitialState: function () {
		window.playerIncoming = this.incoming

		return {
			selected: '',
		}
	},
	incoming: function (e) {
		var item = $(e.currentTarget)
		var video = item.attr('data-video-id')

		if (video && video != '' && window.playThis) {
			window.playThis(e, video)
			e.preventDefault()
			e.stopPropagation()
		} else {
			this.setState({
				selected: video,
			})
			body.attr('data-video-id', video)
		}
	},
	render: function () {
		return (
			<div className="player">
				{this.state.selected != '' ? (
					<span>
						<iframe
							width="100%"
							className="ratio youtube-frame"
							src={
								'https://www.youtube.com/embed/' +
								this.state.selected +
								'?autoplay=1&modestbranding=1'
							}
							allowFullScreen="true"
							scrolling="no"
							frameBorder="0"
							allow="autoplay"
						/>
						<svg
							title="Close Video"
							className=" close-video pointer"
							onClick={this.close}
							role="img"
							xmlns="http://www.w3.org/2000/svg"
							viewBox="0 0 512 512"
						>
							<path
								fill="currentColor"
								d="M256 8C119 8 8 119 8 256s111 248 248 248 248-111 248-248S393 8 256 8zm121.6 313.1c4.7 4.7 4.7 12.3 0 17L338 377.6c-4.7 4.7-12.3 4.7-17 0L256 312l-65.1 65.6c-4.7 4.7-12.3 4.7-17 0L134.4 338c-4.7-4.7-4.7-12.3 0-17l65.6-65-65.6-65.1c-4.7-4.7-4.7-12.3 0-17l39.6-39.6c4.7-4.7 12.3-4.7 17 0l65 65.7 65.1-65.6c4.7-4.7 12.3-4.7 17 0l39.6 39.6c4.7 4.7 4.7 12.3 0 17L312 256l65.6 65.1z"
							/>
						</svg>
					</span>
				) : null}
			</div>
		)
	},
	close: function (e) {
		this.setState({
			selected: '',
		})
		body.attr('data-video-id', '')
	},
	play: function (e) {
		this.setState({
			selected: $(e.target).attr('data-video-id'),
		})
		body.attr('data-video-id', $(e.target).attr('data-video-id'))
	},
	componentDidUpdate: function () {
		if (window.updateScroll) window.updateScroll()
	},
})
