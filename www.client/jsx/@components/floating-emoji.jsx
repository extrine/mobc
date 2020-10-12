var floating_emoji_user_messages = {}

var FloatingEmoji = React.createClass({
	mixins: [React.addons.PureRenderMixin],

	getInitialState: function () {
		this.timeout = false
		return {
			m: '',
		}
	},
	getDefaultProps: function () {
		return {
			username: '',
		}
	},
	componentWillUnmount: function () {
		this.mounted = false
	},
	componentDidMount: function () {
		this.mounted = true
		floating_emoji_user_messages[this.props.username] = this.setMessage
	},
	setMessage: function (m) {
		if (m.indexOf('https://omgmobc.com/img') !== -1) {
			setTimeout(
				function () {
					if (this.mounted)
						this.setState(
							{
								m: '',
							},
							function () {
								this.setState({
									m: m,
								})
							}.bind(this),
						)
				}.bind(this),
				0,
			)
			clearTimeout(this.timeout)
			this.timeout = setTimeout(
				function () {
					if (this.mounted)
						this.setState({
							m: '',
						})
				}.bind(this),
				5000,
			)
		}
	},
	render: function () {
		if (
			!this.state.m ||
			this.state.m == '' ||
			this.state.m.indexOf('https://omgmobc.com/img') === -1
		) {
			return null
		} else {
			var found = this.state.m.match(/(https:\/\/omgmobc.com\/img\/icon\/[a-z0-9/-\s]+\.(png|gif))/)
			if (found) {
				return <img src={found[0]} className="floating-emoji" />
			} else {
				return null
			}
		}
	},
})
