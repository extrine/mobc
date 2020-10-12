var Favicon = React.createClass({
	mixins: [React.addons.PureRenderMixin],

	render: function () {
		if (this.props.url && this.props.url != '' && /^https?:\/\//.test(this.props.url)) {
			return (
				<a
					href={this.props.url}
					target="_blank"
					rel="noopener"
					onClick={stopPropagation}
					className="favicon"
				>
					<img
						src={
							'https://icons.duckduckgo.com/ip3/' +
							this.props.url.replace(/^https?:\/\//, '').replace(/\/.*$/, '') +
							'.ico'
						}
						alt={this.props.url}
						title={this.props.url}
					/>
				</a>
			)
		} else {
			return null
		}
	},
})
