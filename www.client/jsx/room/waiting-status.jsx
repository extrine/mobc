var WaitingStatus = React.createClass({
	mixins: [React.addons.PureRenderMixin],

	render: function () {
		return (
			<div className="waiting-status no-select">
				<b
					style={{
						color: 'lime',
					}}
				>
					●
				</b>{' '}
				{this.props.children}
			</div>
		)
	},
})
