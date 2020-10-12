var GalleryDisplay = React.createClass({
	componentDidMount: function () {
		$('.page').addClass('no-overflow')
	},
	componentWillUnmount: function () {
		$('.page').removeClass('no-overflow')
	},
	deleteImage: function () {
		this.props.delete()
	},
	setDefault: function () {
		this.props.setDefault()
	},
	setCover: function () {
		this.props.setCover()
	},
	scrollDisplay: function (d) {
		this.props.display(null, d)
	},
	render: function () {
		var coverStyle = {
			color: this.props.img === this.props.ic.replace(/cover/i, 'gallery') ? 'lime' : 'white',
		}
		var defaultStyle = {
			color: this.props.img === this.props.i.replace(/profile/i, 'gallery') ? 'lime' : 'white',
		}
		return (
			<div className="gallery-display" onClick={this.props.hide}>
				<div className="gallery-display-buttons">
					{window.user && this.props.u === window.user.username ? (
						<div className="gallery-display-default" style={defaultStyle} onClick={this.setDefault}>
							Set As Profile |{' '}
						</div>
					) : null}
					{window.user && this.props.u === window.user.username ? (
						<div className="gallery-display-bg" style={coverStyle} onClick={this.setCover}>
							Set As Cover |{' '}
						</div>
					) : null}
					{window.user && this.props.u === window.user.username ? (
						<div className="gallery-display-delete" onClick={this.deleteImage}>
							Delete |{' '}
						</div>
					) : null}
					<div className="gallery-display-delete" onClick={this.props.hide}>
						Close
					</div>
				</div>
				<div className="gallery-display-previous">
					<span className="arrow-left" onClick={this.scrollDisplay.bind(null, 'down')} />
				</div>
				{!is_video(this.props.img) ? (
					<img src={this.props.img} onClick={this.props.hide} />
				) : (
					<Video src={this.props.img} onClick={this.props.hide} />
				)}
				<div className="gallery-display-next">
					<span className="arrow-right" onClick={this.scrollDisplay.bind(null, 'up')} />
				</div>
			</div>
		)
	},
})

var Carousel = React.createClass({
	onClick: function (i) {
		this.props.display(i)
	},
	scrollL: function () {
		$('.gallery-container .gallery-carousel').stop().animate(
			{
				scrollLeft: '-=150',
			},
			120,
		)
	},
	scrollR: function () {
		$('.gallery-container .gallery-carousel').stop().animate(
			{
				scrollLeft: '+=150',
			},
			120,
		)
	},
	render: function () {
		return (
			<div className="gallery-carousel-container">
				{this.props.gallery.length > 4 ? (
					<div className="gallery-carousel-scrollL">
						<span className="arrow-left" onClick={this.scrollL} />
					</div>
				) : null}
				<div className="gallery-carousel">
					{this.props.gallery.map(
						function (img, i) {
							if (!is_video(img))
								return (
									<img
										key={img + '' + i}
										src={img.replace('gallery/', 'gallery/thumb_')}
										onClick={this.onClick.bind(this, i)}
									/>
								)
							else
								return (
									<img
										key={img + '' + i}
										src={img.replace('gallery/', 'gallery/thumb_').replace(/\.[^\.]+$/, '.png')}
										onClick={this.onClick.bind(this, i)}
									/>
								)
						}.bind(this),
					)}
				</div>
				{this.props.gallery.length > 4 ? (
					<div className="gallery-carousel-scrollR">
						<span className="arrow-right" onClick={this.scrollR} />
					</div>
				) : null}
			</div>
		)
	},
})

var Gallery = React.createClass({
	getInitialState: function () {
		return {
			index: 0,
			display: false,
		}
	},
	hideDisplay: function (e) {
		if (e.currentTarget == e.target) {
			this.setState({
				display: false,
			})
		}
	},
	setDisplay: function (i, d) {
		if (d) {
			if (d == 'up')
				this.setState({
					index:
						this.state.index < this.props.gallery.length - 1
							? this.state.index + 1
							: this.state.index,
				})
			else
				this.setState({
					index: this.state.index > 0 ? this.state.index - 1 : this.state.index,
				})
		} else {
			this.setState({
				index: i,
				display: true,
			})
		}
	},
	setDefault: function () {
		emit(
			{
				id: 'gallery',
				f: 'copy',
				v: this.props.gallery[this.state.index],
				t: 'profile',
			},
			function (d) {
				this.props.setData(d)
			}.bind(this),
		)
	},
	setCover: function () {
		emit(
			{
				id: 'gallery',
				f: 'copy',
				v: this.props.gallery[this.state.index],
				t: 'cover',
			},
			function (d) {
				this.props.setData(d)
			}.bind(this),
		)
	},
	deleteImage: function () {
		CONFIRM(
			"Are you sure!? There's no undo.",
			function () {
				emit({
					id: 'gallery',
					f: 'del',
					v: this.props.gallery[this.state.index],
				})
			}.bind(this),
		)
	},
	preload: function () {
		if (this.props.gallery[this.state.index]) u.preload(this.props.gallery[this.state.index])
		if (this.props.gallery[this.state.index + 1])
			u.preload(this.props.gallery[this.state.index + 1])
		else if (this.props.gallery[this.state.index - 1])
			u.preload(this.props.gallery[this.state.index - 1])
		if (this.props.gallery[this.state.index + 2])
			u.preload(this.props.gallery[this.state.index + 2])
		return true
	},
	render: function () {
		return (
			<div className="gallery-container">
				<Carousel gallery={this.props.gallery} display={this.setDisplay} />
				{this.state.display && this.preload() ? (
					<GalleryDisplay
						img={this.props.gallery[this.state.index]}
						hide={this.hideDisplay}
						display={this.setDisplay}
						delete={this.deleteImage}
						setDefault={this.setDefault}
						setCover={this.setCover}
						i={this.props.i}
						ic={this.props.ic}
						u={this.props.u}
					/>
				) : null}
			</div>
		)
	},
})
