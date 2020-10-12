var Loading = React.createClass({
	mixins: [React.addons.PureRenderMixin],

	render: function () {
		return (
			<div className={'lds-dual-ring ' + (this.props.className ? this.props.className : '')}></div>
		)
	},
})
