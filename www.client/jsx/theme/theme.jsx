var ThemeSelector = React.createClass({
	render: function () {
		return (
			<span className="theme-selector">
				<span onClick={this.set_theme} data-theme="white" className="preview preview-white" />
				<span onClick={this.set_theme} data-theme="gray" className="preview preview-gray" />
				<span
					onClick={this.set_theme}
					data-theme="dark-purple"
					className="preview preview-dark-purple"
				/>
				<span onClick={this.set_theme} data-theme="orange" className="preview preview-orange" />
				<span onClick={this.set_theme} data-theme="red" className="preview preview-red" />
				<span onClick={this.set_theme} data-theme="pink" className="preview preview-pink" />
				<span onClick={this.set_theme} data-theme="black" className="preview preview-black" />
			</span>
		)
	},
	set_theme: function (e) {
		var o = storage.get()

		o.theme = $(e.currentTarget).attr('data-theme')
		body.attr('data-theme', o.theme)

		storage.update(o)
	},
})
