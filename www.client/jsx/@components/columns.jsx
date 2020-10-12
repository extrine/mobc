var Columns = function (props) {
	if (props.count) {
		var basis = 100 / props.count + '%'
	} else if (props.size) {
		var basis = props.size
	} else if (props.children) {
		var basis = 100 / props.children.length + '%'
	} else {
		var basis = 'auto'
	}

	return (
		<Box
			row
			grow
			wrap
			css={
				'class > div{ flex-basis:' + basis + '; ' + (props.center ? 'text-align:center;' : '') + '}'
			}
		>
			{props.children}
		</Box>
	)
}
