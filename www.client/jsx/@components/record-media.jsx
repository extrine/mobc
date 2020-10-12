var RecordMedia = React.createClass({
	mixins: [React.addons.PureRenderMixin],
	getInitialState: function () {
		this.recording = false
		// this.doUpload = this.doUpload.bind(this)
		onUserLogin.push(this.doUpdate)
		return {
			recording: false,
		}
	},
	doUpdate: function () {
		if (this.mounted) {
			this.setState({ nada: !this.state.nada })
		}
	},
	doUpload: function (fn) {
		$.ajax({
			type: 'POST',
			url: 'https://omgmobc.com/php/upload.php?type=tmp&action=upload',
			data: this.formData,
			contentType: false,
			processData: false,
			success: function (link) {
				this.formData = null
				if (link.indexOf('https://') === 0) {
					fn(link)
				}
			}.bind(this),
		})
	},
	componentWillUnmount: function () {
		u.removeValueFromArray(onUserLogin, this.doUpdate)
		this.mounted = false
	},
	componentDidMount: function () {
		this.mounted = true
		if (this.props.bind) {
			if (this.props.type == 'video') {
				this.props.bind.recordVideoStart = this.start
				this.props.bind.recordVideoStop = this._stop
			} else {
				this.props.bind.recordAudioStart = this.start
				this.props.bind.recordAudioStop = this._stop
			}
		}
	},
	render: function () {
		if (this.props.type == 'video')
			return window.user && window.user.nocam ? null : (
				<svg
					draggable="false"
					title="Press and Hold to Record Video+Audio"
					className={
						'pointer no-select record-media-video ' + (this.state.recording ? ' cgreen' : ' ')
					}
					onMouseDown={this.start}
					onMouseUp={this._stop}
					onMouseOut={this._stop}
					onTouchStart={this.start}
					onTouchEnd={this._stop}
					onTouchCancel={stopEvent}
					onDoubleClick={stopEvent}
					onClick={stopEvent}
					role="img"
					xmlns="http://www.w3.org/2000/svg"
					viewBox="0 0 576 512"
				>
					<path
						fill="currentColor"
						d="M336.2 64H47.8C21.4 64 0 85.4 0 111.8v288.4C0 426.6 21.4 448 47.8 448h288.4c26.4 0 47.8-21.4 47.8-47.8V111.8c0-26.4-21.4-47.8-47.8-47.8zm189.4 37.7L416 177.3v157.4l109.6 75.5c21.2 14.6 50.4-.3 50.4-25.8V127.5c0-25.4-29.1-40.4-50.4-25.8z"
					/>
				</svg>
			)
		else
			return (
				<svg
					draggable="false"
					title="Press and Hold to Record Audio"
					className={
						'pointer no-select record-media-audio ' + (this.state.recording ? ' cgreen' : ' ')
					}
					onMouseDown={this.start}
					onMouseOut={this._stop}
					onMouseUp={this._stop}
					onTouchStart={this.start}
					onTouchEnd={this._stop}
					onTouchCancel={stopEvent}
					onDoubleClick={stopEvent}
					onClick={stopEvent}
					role="img"
					xmlns="http://www.w3.org/2000/svg"
					viewBox="0 0 352 512"
				>
					<path
						fill="currentColor"
						d="M176 352c53.02 0 96-42.98 96-96V96c0-53.02-42.98-96-96-96S80 42.98 80 96v160c0 53.02 42.98 96 96 96zm160-160h-16c-8.84 0-16 7.16-16 16v48c0 74.8-64.49 134.82-140.79 127.38C96.71 376.89 48 317.11 48 250.3V208c0-8.84-7.16-16-16-16H16c-8.84 0-16 7.16-16 16v40.16c0 89.64 63.97 169.55 152 181.69V464H96c-8.84 0-16 7.16-16 16v16c0 8.84 7.16 16 16 16h160c8.84 0 16-7.16 16-16v-16c0-8.84-7.16-16-16-16h-56v-33.77C285.71 418.47 352 344.9 352 256v-48c0-8.84-7.16-16-16-16z"
					/>
				</svg>
			)
	},
	start: function (e) {
		if (e.button !== undefined && e.button != 0 && e.type != 'keydown') return
		e.preventDefault()
		e.stopPropagation()

		if (!this.recording) {
			this.recording = true
			this.timeout = setTimeout(this.stop, 1000 * 60 * 2) // 2 minutes

			var chunks = []

			var start = Date.now()
			var min_record = this.props.type == 'video' ? 2000 : 1000

			navigator.mediaDevices
				.getUserMedia({
					audio: {
						echoCancellation: false,
						noiseSuppression: false,
					},
					video: this.props.type == 'video' ? true : false,
				})
				.then(
					function (stream) {
						if (this.recording) {
							this.props.onStart()
							this.setState({
								recording: true,
							})
							chunks = []
							this.stream = stream
							this.recorder = new MediaRecorder(stream)
							this.recorder.ondataavailable = function (e) {
								chunks.push(e.data)
							}

							this.recorder.onstop = function () {
								this.stopTracks(stream)
								this.stopTracks(this.recorder.stream)
								if (Date.now() - start > min_record) {
									var blob = new Blob(chunks)

									this.formData = new FormData()
									this.formData.append(
										'file',
										blob,
										this.props.type == 'video' ? 'video.mp4' : 'audio.ogg',
									)
									this.props.onStop(this.doUpload)
								} else {
									this.props.onStop(function () {})
								}
								if (this.recording) {
									this.recording = false
									this.setState({
										recording: false,
									})
								}
							}.bind(this)

							this.recorder.start()
						} else {
							this.stopTracks(stream)
						}
					}.bind(this),
				)
				.catch(function () {})
		} else if (this.clickToRecordStop()) {
			this.stop()
		}
	},
	clickToRecordStop: function () {
		return (
			(this.props.type == 'video' && window.user.recordvideo) ||
			(this.props.type == 'audio' && window.user.record)
		)
	},
	_stop: function (e) {
		e.preventDefault()
		e.stopPropagation()
		if (this.recording && !this.clickToRecordStop()) setTimeout(this.stop, 0)
	},
	stop: function () {
		if (this.stream) {
			this.stopTracks(this.stream)
		}

		if (this.recorder && this.recorder.stream) {
			this.stopTracks(this.recorder.stream)
		}
		if (this.recorder) {
			if (this.recorder.state != 'inactive') {
				this.recorder.stop()
			}
		}

		clearTimeout(this.timeout)
	},
	stopTracks: function (stream) {
		stream.getAudioTracks().forEach(function (track) {
			track.stop()
		})
		stream.getVideoTracks().forEach(function (track) {
			track.stop()
		})
		stream.getTracks().forEach(function (track) {
			track.stop()
		})
	},
})
