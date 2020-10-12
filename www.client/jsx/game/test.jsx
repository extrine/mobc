var GameTest = React.createClass({
	mixins: [React.addons.PureRenderMixin],

	getInitialState: function () {
		window.swf = this
		return {
			loaded: false,
		}
	},
	render: function () {
		var version = '0'

		var games = [
			{
				name: 'nineballpool',
				dev: 'swf/test/dev/56812a7bd445d2052f34c9c2ed85f885b.swf',
				dev_loader: 'swf/loader.swf?swf/test/dev/56812a7bd445d2052f34c9c2ed85f885b.swf',
				pro: 'swf/test/pro/3046400114046d63cb79bd76b83ca556p.swf',
				pro_loader: 'swf/loader.swf?swf/test/pro/3046400114046d63cb79bd76b83ca556p.swf',
			},
			{
				name: 'aimforthenuts',
				dev: 'swf/test/dev/cfd41951e57fabe3d4ce691110c3ba84b.swf',
				dev_loader: 'swf/loader.swf?swf/test/dev/cfd41951e57fabe3d4ce691110c3ba84b.swf',
				pro: 'swf/test/pro/3796e57245d227bfc411165dda432500p.swf',
				pro_loader: 'swf/loader.swf?swf/test/pro/3796e57245d227bfc411165dda432500p.swf',
			},
			{
				name: 'aimreallygood',
				dev: 'swf/test/dev/7d43c91cd078752124acca9d102478fdb.swf',
				dev_loader: 'swf/loader.swf?swf/test/dev/7d43c91cd078752124acca9d102478fdb.swf',
				pro: 'swf/test/pro/542646154b9966bce7300fcc869676cap.swf',
				pro_loader: 'swf/loader.swf?swf/test/pro/542646154b9966bce7300fcc869676cap.swf',
			},
			{
				name: 'missilecommand',
				dev: 'swf/test/dev/69261ac7823d15119c2b28e531e85c7ab.swf',
				dev_loader: 'swf/loader.swf?swf/test/dev/69261ac7823d15119c2b28e531e85c7ab.swf',
				pro: 'swf/test/pro/5f9a167bab55f8de32e1db726fd7b1bdp.swf',
				pro_loader: 'swf/loader.swf?swf/test/pro/5f9a167bab55f8de32e1db726fd7b1bdp.swf',
			},
			{
				name: 'balloono',
				dev: 'swf/test/dev/d616197d941ce1c9106d95a7ac8aab25b.swf',
				dev_loader: 'swf/loader.swf?swf/test/dev/d616197d941ce1c9106d95a7ac8aab25b.swf',
				pro: 'swf/test/pro/b84973fbd76048446148c3f815c908fep.swf',
				pro_loader: 'swf/loader.swf?swf/test/pro/b84973fbd76048446148c3f815c908fep.swf',
			},
			{
				name: 'balloonoclassic',
				dev: 'swf/test/dev/05ad43281eaa28f95085507581bd8d7db.swf',
				dev_loader: 'swf/loader.swf?swf/test/dev/05ad43281eaa28f95085507581bd8d7db.swf',
				pro: 'swf/test/pro/d54cfb27a085034554725b180032133cp.swf',
				pro_loader: 'swf/loader.swf?swf/test/pro/d54cfb27a085034554725b180032133cp.swf',
			},
			{
				name: 'ballracer',
				dev: 'swf/test/dev/7ed73bd8b9b114359021cf692b04a433b.swf',
				dev_loader: 'swf/loader.swf?swf/test/dev/7ed73bd8b9b114359021cf692b04a433b.swf',
				pro: 'swf/test/pro/d077c47a290e8488e9aa781ed997a2c9p.swf',
				pro_loader: 'swf/loader.swf?swf/test/pro/d077c47a290e8488e9aa781ed997a2c9p.swf',
			},
			{
				name: 'blockles',
				dev: 'swf/test/dev/18032391390d77b4fd86c9a5b404ffbdb.swf',
				dev_loader: 'swf/loader.swf?swf/test/dev/18032391390d77b4fd86c9a5b404ffbdb.swf',
				pro: 'swf/test/pro/8caf225490b618980e866d0a472d97fap.swf',
				pro_loader: 'swf/loader.swf?swf/test/pro/8caf225490b618980e866d0a472d97fap.swf',
			},
			{
				name: 'booya',
				dev: 'swf/test/dev/3c165ebe1ba01b94d02ae1236ebbbc14b.swf',
				dev_loader: 'swf/loader.swf?swf/test/dev/3c165ebe1ba01b94d02ae1236ebbbc14b.swf',
				pro: 'swf/test/pro/85fc2466ccd36d84b99d1d4949fc6cb8p.swf',
				pro_loader: 'swf/loader.swf?swf/test/pro/85fc2466ccd36d84b99d1d4949fc6cb8p.swf',
			},
			{
				name: 'checkers',
				dev: 'swf/test/dev/f8a99e9b6d9f0b53cf6f927c04c2fee8b.swf',
				dev_loader: 'swf/loader.swf?swf/test/dev/f8a99e9b6d9f0b53cf6f927c04c2fee8b.swf',
				pro: 'swf/test/pro/b1fae9f8ead50e4382d620f74d174a0fp.swf',
				pro_loader: 'swf/loader.swf?swf/test/pro/b1fae9f8ead50e4382d620f74d174a0fp.swf',
			},
			{
				name: 'dinglepop',
				dev: 'swf/test/dev/45465399909bd44509d7dae1a7ff5e38b.swf',
				dev_loader: 'swf/loader.swf?swf/test/dev/45465399909bd44509d7dae1a7ff5e38b.swf',
				pro: 'swf/test/pro/16b0399420080e184223ba8472046ecdp.swf',
				pro_loader: 'swf/loader.swf?swf/test/pro/16b0399420080e184223ba8472046ecdp.swf',
			},
			{
				name: 'fleetfighter',
				dev: 'swf/test/dev/a8f5eab0c54c760d8c8ea6808f0f2614b.swf',
				dev_loader: 'swf/loader.swf?swf/test/dev/a8f5eab0c54c760d8c8ea6808f0f2614b.swf',
				pro: 'swf/test/pro/a6a87e44b09ce1e431a00ed0a903d183p.swf',
				pro_loader: 'swf/loader.swf?swf/test/pro/a6a87e44b09ce1e431a00ed0a903d183p.swf',
			},
			{
				name: 'fourplay',
				dev: 'swf/test/dev/975865d59018f592fd82f2beefdc1de6b.swf',
				dev_loader: 'swf/loader.swf?swf/test/dev/975865d59018f592fd82f2beefdc1de6b.swf',
				pro: 'swf/test/pro/58ea68e4af021444ec72668f62c24eb6p.swf',
				pro_loader: 'swf/loader.swf?swf/test/pro/58ea68e4af021444ec72668f62c24eb6p.swf',
			},
			{
				name: 'gemmers',
				dev: 'swf/test/dev/b8e6c5d5295013174fd3e75cac8052ecb.swf',
				dev_loader: 'swf/loader.swf?swf/test/dev/b8e6c5d5295013174fd3e75cac8052ecb.swf',
				pro: 'swf/test/pro/cd4f37e96bb0d1ad56796cc021c319c6p.swf',
				pro_loader: 'swf/loader.swf?swf/test/pro/cd4f37e96bb0d1ad56796cc021c319c6p.swf',
			},
			{
				name: 'hamsterbattle',
				dev: 'swf/test/dev/a97aefe225b0594522147f57311068fab.swf',
				dev_loader: 'swf/loader.swf?swf/test/dev/a97aefe225b0594522147f57311068fab.swf',
				pro: 'swf/test/pro/51a78b3ac8a057236725a3d4a500d706p.swf',
				pro_loader: 'swf/loader.swf?swf/test/pro/51a78b3ac8a057236725a3d4a500d706p.swf',
			},
			{
				name: 'hamsterjet',
				dev: 'swf/test/dev/81d5c2653938f1244252c6af2f591e98b.swf',
				dev_loader: 'swf/loader.swf?swf/test/dev/81d5c2653938f1244252c6af2f591e98b.swf',
				pro: 'swf/test/pro/cbc8f8bceb9a6c9144d460add7568a51p.swf',
				pro_loader: 'swf/loader.swf?swf/test/pro/cbc8f8bceb9a6c9144d460add7568a51p.swf',
			},
			{
				name: 'hitmachine',
				dev: 'swf/test/dev/2e4f9915e5e7743d82cb4b4a9807a3f8b.swf',
				dev_loader: 'swf/loader.swf?swf/test/dev/2e4f9915e5e7743d82cb4b4a9807a3f8b.swf',
				pro: 'swf/test/pro/dec939a0c92c8aa011feee5dfa94682dp.swf',
				pro_loader: 'swf/loader.swf?swf/test/pro/dec939a0c92c8aa011feee5dfa94682dp.swf',
			},
			{
				name: 'hoverkartbattle wth?',
				dev: 'swf/test/dev/fb319a2da45d026e93bfe2f4e70c5c18b.swf',
				dev_loader: 'swf/loader.swf?swf/test/dev/fb319a2da45d026e93bfe2f4e70c5c18b.swf',
				pro: 'swf/test/pro/1154d59e3d0b03afe2c42f2461327bb2p.swf',
				pro_loader: 'swf/loader.swf?swf/test/pro/1154d59e3d0b03afe2c42f2461327bb2p.swf',
			},
			{
				name: 'hoverkartparty',
				dev: 'swf/test/dev/ea64af176d5a7da01101d7f4220bf860b.swf',
				dev_loader: 'swf/loader.swf?swf/test/dev/ea64af176d5a7da01101d7f4220bf860b.swf',
				pro: 'swf/test/pro/3292c6309b9347b119914321cbc2b8aep.swf',
				pro_loader: 'swf/loader.swf?swf/test/pro/3292c6309b9347b119914321cbc2b8aep.swf',
			},
			{
				name: 'hoverkart',
				dev: 'swf/test/dev/2966d54b6693ea046ddbcf2d74f24ee0b.swf',
				dev_loader: 'swf/loader.swf?swf/test/dev/2966d54b6693ea046ddbcf2d74f24ee0b.swf',
				pro: 'swf/test/pro/5bc261d5546d2d2b3663ce8c36ec22e3p.swf',
				pro_loader: 'swf/loader.swf?swf/test/pro/5bc261d5546d2d2b3663ce8c36ec22e3p.swf',
			},
			{
				name: 'jigsawce',
				dev: 'swf/test/dev/43d1c773b881beab2e22d81fa2515e62b.swf',
				dev_loader: 'swf/loader.swf?swf/test/dev/43d1c773b881beab2e22d81fa2515e62b.swf',
				pro: 'swf/test/pro/5d353f370a80a9018b0660bfdad34658p.swf',
				pro_loader: 'swf/loader.swf?swf/test/pro/5d353f370a80a9018b0660bfdad34658p.swf',
			},
			{
				name: 'letterblox',
				dev: 'swf/test/dev/b12f49f9552af4da6ffaf1701b34f95cb.swf',
				dev_loader: 'swf/loader.swf?swf/test/dev/b12f49f9552af4da6ffaf1701b34f95cb.swf',
				pro: 'swf/test/pro/2a32d78aa06e1e05c2333139b3e3e81bp.swf',
				pro_loader: 'swf/loader.swf?swf/test/pro/2a32d78aa06e1e05c2333139b3e3e81bp.swf',
			},
			{
				name: 'pool',
				dev: 'swf/test/dev/a7a8b473e78d9510ca86d254a3e3d43fb.swf',
				dev_loader: 'swf/loader.swf?swf/test/dev/a7a8b473e78d9510ca86d254a3e3d43fb.swf',
				pro: 'swf/test/pro/aa56bdc3edbdbb9064fc527cd1a15440p.swf',
				pro_loader: 'swf/loader.swf?swf/test/pro/aa56bdc3edbdbb9064fc527cd1a15440p.swf',
			},
			{
				name: 'fbpool',
				dev: 'swf/test/dev/b74fd463d5809940d1795aaf7039dd70b.swf',
				dev_loader: 'swf/loader.swf?swf/test/dev/b74fd463d5809940d1795aaf7039dd70b.swf',
				pro: 'swf/test/pro/8da44a33d5d97c7d3805e022c2f34c84p.swf',
				pro_loader: 'swf/loader.swf?swf/test/pro/8da44a33d5d97c7d3805e022c2f34c84p.swf',
			},
			{
				name: 'puttputtpenguin',
				dev: 'swf/test/dev/c47cef0d42edf838158138dd41e1c07ab.swf',
				dev_loader: 'swf/loader.swf?swf/test/dev/c47cef0d42edf838158138dd41e1c07ab.swf',
				pro: 'swf/test/pro/47758c01f36a437b9063b7a5d705755ap.swf',
				pro_loader: 'swf/loader.swf?swf/test/pro/47758c01f36a437b9063b7a5d705755ap.swf',
			},
			{
				name: 'skypigs',
				dev: 'swf/test/dev/68b9a50bbdcac729ec854db2db1d5fd9b.swf',
				dev_loader: 'swf/loader.swf?swf/test/dev/68b9a50bbdcac729ec854db2db1d5fd9b.swf',
				pro: 'swf/test/pro/4e90d300ad914969ea2e452f88cddc71p.swf',
				pro_loader: 'swf/loader.swf?swf/test/pro/4e90d300ad914969ea2e452f88cddc71p.swf',
			},
			{
				name: 'solitaire',
				dev: 'swf/test/dev/1d095c0212a4787eb4f08f6ddf29b744b.swf',
				dev_loader: 'swf/loader.swf?swf/test/dev/1d095c0212a4787eb4f08f6ddf29b744b.swf',
				pro: 'swf/test/pro/73f89acc07c82724c91ad3bb7ae1f78ap.swf',
				pro_loader: 'swf/loader.swf?swf/test/pro/73f89acc07c82724c91ad3bb7ae1f78ap.swf',
			},
			{
				name: 'swapples',
				dev: 'swf/test/dev/a4262a8737bf26a3d9e2a874d492359ab.swf',
				dev_loader: 'swf/loader.swf?swf/test/dev/a4262a8737bf26a3d9e2a874d492359ab.swf',
				pro: 'swf/test/pro/04362bafc59379cb7332699b2c8cc599p.swf',
				pro_loader: 'swf/loader.swf?swf/test/pro/04362bafc59379cb7332699b2c8cc599p.swf',
			},
			{
				name: 'tonk',
				dev: 'swf/test/dev/ae912c04e58f51c6d1ebe010bb0c4864b.swf',
				dev_loader: 'swf/loader.swf?swf/test/dev/ae912c04e58f51c6d1ebe010bb0c4864b.swf',
				pro: 'swf/test/pro/41abb045be481cde7b6db2db98aa10dbp.swf',
				pro_loader: 'swf/loader.swf?swf/test/pro/41abb045be481cde7b6db2db98aa10dbp.swf',
			},
			{
				name: 'tracism',
				dev: 'swf/test/dev/952246ff2f3210ed289befc4f197ae26b.swf',
				dev_loader: 'swf/loader.swf?swf/test/dev/952246ff2f3210ed289befc4f197ae26b.swf',
				pro: 'swf/test/pro/824fac1bdee9bdf2100f0d836940230bp.swf',
				pro_loader: 'swf/loader.swf?swf/test/pro/824fac1bdee9bdf2100f0d836940230bp.swf',
			},
			{
				name: 'typow2',
				dev: 'swf/test/dev/f5004013c814c7591363c69ceb914664b.swf',
				dev_loader: 'swf/loader.swf?swf/test/dev/f5004013c814c7591363c69ceb914664b.swf',
				pro: 'swf/test/pro/6d113e4622a2c3964e6622c07a1f1f19p.swf',
				pro_loader: 'swf/loader.swf?swf/test/pro/6d113e4622a2c3964e6622c07a1f1f19p.swf',
			},
			{
				name: 'typow',
				dev: 'swf/test/dev/49da84d0e18a31e342cade5f5a481d1bb.swf',
				dev_loader: 'swf/loader.swf?swf/test/dev/49da84d0e18a31e342cade5f5a481d1bb.swf',
				pro: 'swf/test/pro/b3a0f185bee829d054dbe637b4190ef4p.swf',
				pro_loader: 'swf/loader.swf?swf/test/pro/b3a0f185bee829d054dbe637b4190ef4p.swf',
			},
		]

		return (
			<div className="game-swf">
				{!this.props.room.started ? (
					<div className="game-swf-object">
						<ul className="">
							{games.map(
								function (item) {
									return (
										<li
											style={{ textAlign: 'left' }}
											className={
												this.state.url == item.dev ||
												this.state.url == item.pro ||
												this.state.url == item.dev_loader ||
												this.state.url == item.pro_loader
													? 'green'
													: ' w30'
											}
										>
											{item.name} : [
											<span onClick={this.set_url} data-url={item.dev} className="link">
												dev
											</span>
											] - [
											<span onClick={this.set_url} data-url={item.pro} className="link">
												pro
											</span>
											] - [
											<span onClick={this.set_url} data-url={item.dev_loader} className="link">
												dev loader
											</span>
											] - [
											<span onClick={this.set_url} data-url={item.pro_loader} className="link">
												pro loader
											</span>
											]
										</li>
									)
								}.bind(this),
							)}
						</ul>
					</div>
				) : null}

				{this.props.room.started ? (
					<div className="game-swf-object">
						<div>
							{this.state.url} -{' '}
							<span onClick={this.restart} className="link">
								RESTART
							</span>{' '}
							/{' '}
							<span onClick={this.stop} className="link">
								STOP
							</span>
						</div>
						<SWFObject color="#000000" name={this.name()} url={this.state.url} />
					</div>
				) : null}
			</div>
		)
	},
	name: function () {
		return 'missile'
	},
	background_image: function () {
		return 'https://omgmobc.com/img/background/games-pool-readybg.jpg?1'
	},
	url: function () {
		return this.state.url.replace('swf/loader.swf?', '')
	},
	set_url: function (e) {
		this.setState({
			url: $(e.currentTarget).attr('data-url'),
		})
		this.start()
	},
	restart: function () {
		this.stop()
		this.start()
	},
	componentWillUnmount: function () {
		this.mounted = false
	},
	componentDidMount: function () {
		this.mounted = true
	},
	seed: function () {
		return window.room.round.seed
	},
	muted: function () {
		var o = storage.get()
		return o.muted ? true : false
	},
	getUsers: function () {
		var oa = []

		for (var id in window.room.users) {
			var o = u.copy(window.room.users[id])
			if (is_video(o.image)) o.image = profile_picture(o.image).replace(/\.[^\.]+$/, '.png')
			else o.image = profile_picture(o.image)
			oa[id] = o
		}
		return oa
	},
	spectator: function () {
		return window.room.started
	},
	host: function () {
		return (
			window.room &&
			window.room.users &&
			window.room.users[0] &&
			window.room.users[0].id == window.user.id
		)
	},
	me: function () {
		var o = u.copy(window.user)
		if (is_video(o.image)) o.image = profile_picture(o.image).replace(/\.[^\.]+$/, '.png')
		else o.image = profile_picture(o.image)
		return o
	},
	componentDidUpdate: function () {
		window.embed = document.getElementById('game-swf')
	},
	onGameLoaded: function () {
		this.setState({
			loaded: true,
		})
	},
	start: function () {
		if (this.host() || window.user.mod || window.user.pu) {
			emit({
				id: 'room update',
				started: true,
			})
		}
	},
	stop: function () {
		if (this.host() || window.user.mod || window.user.pu) {
			emit({
				id: 'room update',
				started: false,
			})
		}
	},
	end: function () {
		if (this.host() || window.user.mod || window.user.pu) {
			emit({
				id: 'room update',
				end: true,
			})
		}
	},
	onGameOver: function () {},
})
