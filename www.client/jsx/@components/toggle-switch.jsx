var ToggleSwitch = React.createClass({
	render: function () {
		return (
			<label className="toggle-switch">
				<div className="switch">
					<input
						type="checkbox"
						className={this.props.className}
						defaultChecked={this.props.defaultValue}
						onChange={this.props.onChange}
					/>
					<span className="slider round"></span>
				</div>{' '}
				{this.props.children}
			</label>
		)
	},
})
