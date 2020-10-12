var Editable = React.createClass({
	render: function () {
		return (
			<span
				onBlur={this.onBlur}
				onKeyDown={this.onKeyDown}
				onPaste={this.onPaste}
				className={this.props.className + ' pointer'}
				title={this.props.title}
				contentEditable="true"
				spellCheck="false"
				dangerouslySetInnerHTML={{ __html: u.escape(this.props.html) }}
			/>
		)
	},
	onKeyDown: function (e) {
		if (e.keyCode == 13) {
			e.preventDefault()
			e.stopPropagation()
		}
	},
	shouldComponentUpdate: function (nextProps) {
		return nextProps.html !== ReactDOM.findDOMNode(this).innerHTML
	},
	onBlur: function () {
		var html = $(ReactDOM.findDOMNode(this)).text()
		if (this.props.onChange && html !== this.lastHtml) {
			this.props.onChange(html)
		}
		this.lastHtml = html
	},
})
