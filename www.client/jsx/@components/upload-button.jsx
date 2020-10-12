var UploadButton = React.createClass({
	mixins: [React.addons.PureRenderMixin],
	getInitialState: function () {
		//this.doUpload = this.doUpload.bind(this)
		return {}
	},
	onClick: function (e) {
		u.click(this.refs.upload)
		e.stopPropagation()
		e.preventDefault()
	},
	doUpload: function (fn) {
		var input = this.refs.upload

		if (input.files) {
			for (let file of Array.from(input.files)) {
				let formData = new FormData()
				formData.append('file', file)
				var reader = new FileReader()
				reader.onload = function (event) {
					var binary = event.target.result
					var hash = sha1(binary)
					let url =
						'https://omgmobc.com/tmp/' + hash + '.' + file.name.split('.').pop().toLowerCase()

					function upload() {
						$.ajax({
							type: 'POST',
							url: 'https://omgmobc.com/php/upload.php?type=tmp&action=upload',
							data: formData,
							contentType: false,
							processData: false,
							success: function (link) {
								if (link.indexOf('https://') === 0) {
									fn(link)
								}
							}.bind(this),
						})
					}

					$.ajax({
						type: 'HEAD',
						url: url,
						contentType: false,
						processData: false,
						success: function (data, status, xhr) {
							if (xhr.getResponseHeader('x-status') == '404') {
								upload()
							} else {
								fn(url)
							}
						}.bind(this),
						error: function () {
							upload()
						}.bind(this),
					})
				}

				reader.readAsBinaryString(file)
			}
		}
		$(this.refs.upload).val('')
	},
	promptUpload: function () {
		this.props.onUpload(this.doUpload)
	},
	render: function () {
		return (
			<Box vertical>
				<input
					type="file"
					ref="upload"
					className="upload-file hidden"
					multiple="true"
					onChange={this.promptUpload}
				/>
				<svg
					draggable="false"
					role="img"
					xmlns="http://www.w3.org/2000/svg"
					viewBox="0 0 448 512"
					className="pointer no-select white no-underline chat-help "
					title="Upload Image/Audio/Video/Gif"
					onClick={this.onClick}
				>
					<path
						fill="currentColor"
						d="M128 192a32 32 0 1 0-32-32 32 32 0 0 0 32 32zM416 32H32A32 32 0 0 0 0 64v384a32 32 0 0 0 32 32h384a32 32 0 0 0 32-32V64a32 32 0 0 0-32-32zm-32 320H64V96h320zM268.8 209.07a16 16 0 0 0-25.6 0l-49.32 65.75L173.31 244a16 16 0 0 0-26.62 0L96 320h256z"
					></path>
				</svg>
			</Box>
		)
	},
})
