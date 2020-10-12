var UserSettings = React.createClass({
	mixins: [React.addons.PureRenderMixin],

	getInitialState: function () {
		this.assets = {
			pool: {
				stick: [
					{
						asset: '',
						image: 'https://omgmobc.com/img/none.png',
						name: 'None',
					},
					{
						asset: 'https://omgmobc.com/items/productbasea-3819-1295289432.swf',
						image: 'https://omgmobc.com/media/productbase-3819-1295289423_mediumthumb.jpg',
						name: 'Extrava-Cue',
					},
					{
						asset: 'https://omgmobc.com/items/productbasea-3180-1291326152.swf',
						image: 'https://omgmobc.com/media/productbase-3180-1291326142_mediumthumb.jpg',
						name: 'The Heavy Metal',
					},
					{
						asset: 'https://omgmobc.com/items/productbasea-2955-1288983734.swf',
						image: 'https://omgmobc.com/media/productbase-2955-1288983727_mediumthumb.jpg',
						name: "Dead Man's Cue",
					},
					{
						asset: 'https://omgmobc.com/items/productbasea-2819-1287608352.swf',
						image: 'https://omgmobc.com/media/productbase-2819-1287608313_mediumthumb.jpg',
						name: 'The Invader',
					},
					{
						asset: 'https://omgmobc.com/items/productbasea-2609-1286223743.swf',
						image: 'https://omgmobc.com/media/productbase-2609-1286223735_mediumthumb.jpg',
						name: 'The Louis V',
					},
					{
						asset: 'https://omgmobc.com/items/productbasea-2500-1284754762.swf',
						image: 'https://omgmobc.com/media/productbase-2500-1284754754_mediumthumb.jpg',
						name: 'The Saucy Wench',
					},
					{
						asset: 'https://omgmobc.com/items/productbasea-2499-1284754501.swf',
						image: 'https://omgmobc.com/media/productbase-2499-1284754493_mediumthumb.jpg',
						name: 'The Swashbuckler',
					},
					{
						asset: 'https://omgmobc.com/items/productbasea-2463-1283367055.swf',
						image: 'https://omgmobc.com/media/productbase-2463-1283367047_mediumthumb.jpg',
						name: 'The Reaper',
					},
					{
						asset: 'https://omgmobc.com/items/productbasea--1281709898.swf',
						image: 'https://omgmobc.com/media/productbase--1281709889_mediumthumb.jpg',
						name: 'The Big Kahuna',
					},
					{
						asset: 'https://omgmobc.com/items/productbasea-2375-1281018261.swf',
						image: 'https://omgmobc.com/media/productbase--1280955268_mediumthumb.jpg',
						name: 'The Voodoo Magic',
					},
					{
						asset: 'https://omgmobc.com/items/productbasea-2363-1280843437.swf',
						image: 'https://omgmobc.com/media/productbase--1280784389_mediumthumb.jpg',
						name: 'The Hot Mama',
					},
					{
						asset: 'https://omgmobc.com/items/productbasea--1279559597.diamond',
						image: 'https://omgmobc.com/media/productbase--1279559590_mediumthumb.jpg',
						name: 'The Pink Bling',
					},
					{
						asset: 'https://omgmobc.com/items/productbasea--1277928240.4thjuly',
						image: 'https://omgmobc.com/media/productbase--1277928230_mediumthumb.jpg',
						name: 'The Patriot',
					},
					{
						asset: 'https://omgmobc.com/items/productbasea--1277531221.swf',
						image: 'https://omgmobc.com/media/productbase--1277531213_mediumthumb.jpg',
						name: 'The Joker',
					},
					{
						asset: 'https://omgmobc.com/items/productbasea--1277526013.swf',
						image: 'https://omgmobc.com/media/productbase--1277526005_mediumthumb.jpg',
						name: 'The Flame Thrower',
					},
					{
						asset: 'https://omgmobc.com/items/productbasea--1277525839.swf',
						image: 'https://omgmobc.com/media/productbase--1277525823_mediumthumb.jpg',
						name: 'The Green Titan',
					},
					{
						asset: 'https://omgmobc.com/items/productbasea--1277500847.swf',
						image: 'https://omgmobc.com/media/productbase--1277500835_mediumthumb.jpg',
						name: 'The Egyptian',
					},
					{
						asset: 'https://omgmobc.com/items/productbasea-2191-1277500621.swf',
						image: 'https://omgmobc.com/media/productbase--1277500480_mediumthumb.jpg',
						name: 'The Copperhead',
					},
					{
						asset: 'https://omgmobc.com/items/productbasea-2181-1277392378.swf',
						image: 'https://omgmobc.com/media/productbase--1277388845_mediumthumb.jpg',
						name: 'The Ebony King',
					},
				],

				felt: [
					{
						asset: '',
						image: 'https://omgmobc.com/img/none.png',
						name: 'None',
					},
					{
						asset: 'https://omgmobc.com/items/productbasea--1280854408.swf',
						image: 'https://omgmobc.com/media/productbase--1280854399_mediumthumb.jpg',
						name: 'Orange Neon',
					},
					{
						asset: 'https://omgmobc.com/items/productbasea-3915-1295646988.swf',
						image: 'https://omgmobc.com/media/productbase-3915-1295646978_mediumthumb.jpg',
						name: 'Extrava-Felt',
					},
					{
						asset: 'https://omgmobc.com/items/productbasea-3466-1293745312.swf',
						image: 'https://omgmobc.com/media/productbase-3466-1293745303_mediumthumb.jpg',
						name: 'Racer',
					},
					{
						asset: 'https://omgmobc.com/items/productbasea-3234-1291836643.swf',
						image: 'https://omgmobc.com/media/productbase-3234-1291834742_mediumthumb.jpg',
						name: 'Pocket Glow',
					},
					{
						asset: 'https://omgmobc.com/items/productbasea-3181-1291327790.swf',
						image: 'https://omgmobc.com/media/productbase-3181-1291327784_mediumthumb.jpg',
						name: 'Danger',
					},
					{
						asset: 'https://omgmobc.com/items/productbasea-2839-1288043263.swf',
						image: 'https://omgmobc.com/media/productbase-2839-1288042772_mediumthumb.jpg',
						name: "Dead Man's",
					},
					{
						asset: 'https://omgmobc.com/items/productbasea-2675-1287000048.swf',
						image: 'https://omgmobc.com/media/productbase-2675-1287000040_mediumthumb.jpg',
						name: 'Alien Invader',
					},
					{
						asset: 'https://omgmobc.com/items/productbasea-2607-1286294105.swf',
						image: 'https://omgmobc.com/media/productbase-2607-1286198883_mediumthumb.jpg',
						name: 'Louis V',
					},
					{
						asset: 'https://omgmobc.com/items/productbasea-2533-1285624762.swf',
						image: 'https://omgmobc.com/media/productbase-2533-1285621850_mediumthumb.jpg',
						name: 'Gothic Purple',
					},
					{
						asset: 'https://omgmobc.com/items/productbasea-2510-1285189237.swf',
						image: 'https://omgmobc.com/media/productbase-2510-1285189228_mediumthumb.jpg',
						name: 'Gothic Blue',
					},
					{
						asset: 'https://omgmobc.com/items/productbasea--1282586983.swf',
						image: 'https://omgmobc.com/media/productbase--1282586975_mediumthumb.jpg',
						name: 'Electric Pink Neon',
					},
					{
						asset: 'https://omgmobc.com/items/productbasea--1282166154.swf',
						image: 'https://omgmobc.com/media/productbase--1282166144_mediumthumb.jpg',
						name: 'Tiki Grass',
					},
					{
						asset: 'https://omgmobc.com/items/productbasea--1281548467.swf',
						image: 'https://omgmobc.com/media/productbase--1281548459_mediumthumb.jpg',
						name: 'Shocking Blue Neon',
					},
					{
						asset: 'https://omgmobc.com/items/productbasea--1281133266.swf',
						image: 'https://omgmobc.com/media/productbase--1281133261_mediumthumb.jpg',
						name: 'Black VIP',
					},
					{
						asset: 'https://omgmobc.com/items/productbasea-2348-1280438845.swf',
						image: 'https://omgmobc.com/media/productbase--1280430249_mediumthumb.jpg',
						name: 'Purple Neon',
					},
					{
						asset: 'https://omgmobc.com/items/productbasea-2316-1280179817.swf',
						image: 'https://omgmobc.com/media/productbase-2316-1279930445_mediumthumb.jpg',
						name: 'Crimson Bling VIP',
					},
					{
						asset: 'https://omgmobc.com/items/productbasea-2315-1280179802.swf',
						image: 'https://omgmobc.com/media/productbase--1279221306_mediumthumb.jpg',
						name: 'Gold',
					},
					{
						asset: 'https://omgmobc.com/items/productbasea--1276809226.swf',
						image: 'https://omgmobc.com/media/productbase-2170-1276810107_mediumthumb.jpg',
						name: 'Dive Bar Dark Green',
					},
					{
						asset: 'https://omgmobc.com/items/productbasea--1276285156.swf',
						image: 'https://omgmobc.com/media/productbase-1942-1276810312_mediumthumb.jpg',
						name: 'Purple VIP',
					},
					{
						asset: 'https://omgmobc.com/items/productbasea--1276285077.swf',
						image: 'https://omgmobc.com/media/productbase-1941-1276810279_mediumthumb.jpg',
						name: 'Blue VIP',
					},
					{
						asset: 'https://omgmobc.com/items/productbasea-1714-1276285556.swf',
						image: 'https://omgmobc.com/media/productbase-1714-1276810235_mediumthumb.jpg',
						name: 'Red VIP',
					},
					{
						asset: 'https://omgmobc.com/items/productbasea--1278707267.swf',
						image: 'https://omgmobc.com/media/productbase--1278707259_mediumthumb.jpg',
						name: 'Magenta Majesty',
					},
					{
						asset: 'https://omgmobc.com/items/productbasea-1944-1276295554.swf',
						image: 'https://omgmobc.com/media/productbase-1944-1276809977_mediumthumb.jpg',
						name: 'The Onyx',
					},
				],

				table: [
					{
						asset: '',
						image: 'https://omgmobc.com/img/none.png',
						name: 'None',
					},
					{
						asset: 'https://omgmobc.com/asset/pool/table/transparent.swf',
						image: 'https://omgmobc.com/asset/pool/table/transparent.png',
						name: 'Transparent',
					},
					{
						asset: 'https://omgmobc.com/items/productbasea--1283200138.swf',
						image: 'https://omgmobc.com/media/productbase--1283200128_mediumthumb.jpg',
						name: 'Black Gothic Fire',
					},
					{
						asset: 'https://omgmobc.com/items/productbasea-3505-1294441162.swf',
						image: 'https://omgmobc.com/media/productbase-3505-1294441154_mediumthumb.jpg',
						name: 'Extrava-Table',
					},
					{
						asset: 'https://omgmobc.com/items/productbasea-3468-1293812566.swf',
						image: 'https://omgmobc.com/media/productbase-3468-1293812559_mediumthumb.jpg',
						name: 'The Classy',
					},
					{
						asset: 'https://omgmobc.com/items/productbasea-3418-1292879628.swf',
						image: 'https://omgmobc.com/media/productbase-3418-1292879622_mediumthumb.jpg',
						name: 'Gold Ribbon',
					},
					{
						asset: 'https://omgmobc.com/items/productbasea-3120-1290788619.swf',
						image: 'https://omgmobc.com/media/productbase-3120-1290788612_mediumthumb.jpg',
						name: 'Metal Madness',
					},
					{
						asset: 'https://omgmobc.com/items/productbasea-3120-1290788619-purple.swf',
						image: 'https://omgmobc.com/media/productbase-3120-1290788612_mediumthumb.jpg',
						name: 'Metal Madness (Purple)',
					},
					{
						asset: 'https://omgmobc.com/items/productbasea-2838-1288042608.swf',
						image: 'https://omgmobc.com/media/productbase-2838-1288042600_mediumthumb.jpg',
						name: "Dead Man's",
					},
					{
						asset: 'https://omgmobc.com/items/productbasea-2674-1286999708.swf',
						image: 'https://omgmobc.com/media/productbase-2674-1286999697_mediumthumb.jpg',
						name: 'Alien Invader',
					},
					{
						asset: 'https://omgmobc.com/items/productbasea-2606-1286205012.swf',
						image: 'https://omgmobc.com/media/productbase-2606-1285963024_mediumthumb.jpg',
						name: 'Louis V',
					},
					{
						asset: 'https://omgmobc.com/items/productbasea--1281710297.swf',
						image: 'https://omgmobc.com/media/productbase--1281710288_mediumthumb.jpg',
						name: 'Tiki',
					},
					{
						asset: 'https://omgmobc.com/items/productbasea-2347-1280438826.swf',
						image: 'https://omgmobc.com/media/productbase--1280430062_mediumthumb.jpg',
						name: 'Neon',
					},
					{
						asset: 'https://omgmobc.com/items/productbasea-2317-1280264481.swf',
						image: 'https://omgmobc.com/media/productbase-2317-1279930373_mediumthumb.jpg',
						name: 'Diamond Bling',
					},
					{
						asset: 'https://omgmobc.com/items/productbasea--1276809367.swf',
						image: 'https://omgmobc.com/media/productbase-2171-1277412374_mediumthumb.jpg',
						name: 'Dive Bar',
					},
					{
						asset: 'https://omgmobc.com/items/productbasea-1717-1276279308.swf',
						image: 'https://omgmobc.com/media/productbase-1717-1277412348_mediumthumb.jpg',
						name: 'VIP',
					},
				],

				decal: [
					{
						asset: '',
						image: 'https://omgmobc.com/img/none.png',
						name: 'None',
					},
					{
						asset: 'https://omgmobc.com/items/productbasea-3495-1294262661.swf',
						image: 'https://omgmobc.com/media/productbase-3495-1294263875_mediumthumb.jpg',
						name: 'Octopool',
					},
					{
						asset: 'https://omgmobc.com/items/productbasea-3315-1292278910.swf',
						image: 'https://omgmobc.com/media/productbase-3315-1292278894_mediumthumb.jpg',
						name: 'Royal Lion',
					},
					{
						asset: 'https://omgmobc.com/items/productbasea-3063-1290637887.swf',
						image: 'https://omgmobc.com/media/productbase-3063-1290453066_mediumthumb.jpg',
						name: 'Victory',
					},
					{
						asset: 'https://omgmobc.com/items/productbasea-2987-1289328198.swf',
						image: 'https://omgmobc.com/media/productbase-2987-1289328193_mediumthumb.jpg',
						name: 'Shotcalla Graff',
					},
					{
						asset: 'https://omgmobc.com/items/productbasea-2937-1288897333.swf',
						image: 'https://omgmobc.com/media/productbase-2937-1288819830_mediumthumb.jpg',
						name: 'Trick Shot',
					},
					{
						asset: 'https://omgmobc.com/items/productbasea-2808-1287434191.swf',
						image: 'https://omgmobc.com/media/productbase-2808-1287434184_mediumthumb.jpg',
						name: 'Xenomorph',
					},
					{
						asset: 'https://omgmobc.com/items/productbasea-2617-1286318689.swf',
						image: 'https://omgmobc.com/media/productbase-2617-1286313571_mediumthumb.jpg',
						name: 'The Heartbreaker',
					},
					{
						asset: 'https://omgmobc.com/items/productbasea-2605-1286391946.swf',
						image: 'https://omgmobc.com/media/productbase-2605-1286319513_mediumthumb.jpg',
						name: 'Louis V',
					},
					{
						asset: 'https://omgmobc.com/items/productbasea-2513-1285768862.swf',
						image: 'https://omgmobc.com/media/productbase-2513-1285352150_mediumthumb.jpg',
						name: 'Is it Luck or Fate',
					},
					{
						asset: 'https://omgmobc.com/items/productbasea-2475-1283899427.swf',
						image: 'https://omgmobc.com/media/productbase-2475-1283899411_mediumthumb.jpg',
						name: 'Koi Fish',
					},
					{
						asset: 'https://omgmobc.com/items/productbasea--1283200421.swf',
						image: 'https://omgmobc.com/media/productbase-2454-1284761897_mediumthumb.jpg',
						name: 'Flying Death',
					},
					{
						asset: 'https://omgmobc.com/items/productbasea-2441-1282586102.swf',
						image: 'https://omgmobc.com/media/productbase--1282166733_mediumthumb.jpg',
						name: 'TIki',
					},
					{
						asset: 'https://omgmobc.com/items/productbasea--1281381922.swf',
						image: 'https://omgmobc.com/media/productbase-2380-1284762221_mediumthumb.jpg',
						name: 'King Baller',
					},
					{
						asset: 'https://omgmobc.com/items/productbasea-2344-1280375504.swf',
						image: 'https://omgmobc.com/media/productbase-2344-1280375497_mediumthumb.jpg',
						name: 'The HUSTLA',
					},
					{
						asset: 'https://omgmobc.com/items/productbasea--1279919894.swf',
						image: 'https://omgmobc.com/media/productbase--1279919888_mediumthumb.jpg',
						name: 'Death Sticks',
					},
					{
						asset: 'https://omgmobc.com/items/productbasea--1279919557.swf',
						image: 'https://omgmobc.com/media/productbase--1279919551_mediumthumb.jpg',
						name: 'Black Widow',
					},
					{
						asset: 'https://omgmobc.com/items/productbasea--1279919422.swf',
						image: 'https://omgmobc.com/media/productbase--1279919415_mediumthumb.jpg',
						name: 'Pool Shark',
					},
					{
						asset: 'https://omgmobc.com/game/pool/decal/snowfight.swf',
						image: 'https://omgmobc.com/game/pool/decal/snowfight.png',
						name: 'Snowfight',
					},
					{
						asset: 'https://omgmobc.com/game/pool/decal/blue.swf',
						image: 'https://omgmobc.com/game/pool/decal/blue.png',
						name: 'Blue',
					},
					{
						asset: 'https://omgmobc.com/game/pool/decal/bra.swf',
						image: 'https://omgmobc.com/game/pool/decal/bra.png',
						name: 'Bra',
					},
					{
						asset: 'https://omgmobc.com/game/pool/decal/clap.swf',
						image: 'https://omgmobc.com/game/pool/decal/clap.png',
						name: 'Clap',
					},
					{
						asset: 'https://omgmobc.com/game/pool/decal/dragon.swf',
						image: 'https://omgmobc.com/game/pool/decal/dragon.png',
						name: 'Dragon',
					},
					{
						asset: 'https://omgmobc.com/game/pool/decal/sugar.swf',
						image: 'https://omgmobc.com/game/pool/decal/sugar.png',
						name: 'Sugar',
					},
					{
						asset: 'https://omgmobc.com/game/pool/decal/bob.swf',
						image: 'https://omgmobc.com/game/pool/decal/bob.png',
						name: 'Bob',
					},
					{
						asset: 'https://omgmobc.com/game/pool/decal/snoopy-hug.swf',
						image: 'https://omgmobc.com/game/pool/decal/snoopy-hug.png',
						name: 'Hug',
					},
					{
						asset: 'https://omgmobc.com/game/pool/decal/snoopy.swf',
						image: 'https://omgmobc.com/game/pool/decal/snoopy.png',
						name: 'Snoopy',
					},
					{
						asset: 'https://omgmobc.com/game/pool/decal/super-star.swf',
						image: 'https://omgmobc.com/game/pool/decal/super-star.png',
						name: 'Super-star',
					},
					{
						asset: 'https://omgmobc.com/game/pool/decal/drunk.swf',
						image: 'https://omgmobc.com/game/pool/decal/drunk.png',
						name: 'Drunk',
					},
					{
						asset: 'https://omgmobc.com/game/pool/decal/golf.swf',
						image: 'https://omgmobc.com/game/pool/decal/golf.png',
						name: 'Golf',
					},
					{
						asset: 'https://omgmobc.com/game/pool/decal/sol.swf',
						image: 'https://omgmobc.com/game/pool/decal/sol.png',
						name: 'Sol',
					},
					{
						asset: 'https://omgmobc.com/game/pool/decal/leopard.swf',
						image: 'https://omgmobc.com/game/pool/decal/leopard.png',
						name: 'Leopard',
					},
				],
			},
		}
		if (u.assets) {
			for (var id in u.assets) {
				var asset = u.assets[id] || ''
				if (asset && /\.swf$/.test(asset)) {
					asset = asset.replace(/\.swf$/, '')
					if (asset != '') {
						if (
							asset.indexOf('-') === -1 ||
							(asset.indexOf('-') !== -1 && asset.indexOf(window.user.username) !== -1)
						) {
							var o = {
								asset: 'https://omgmobc.com/asset/pool/' + asset + '.swf',
								image: 'https://omgmobc.com/asset/pool/' + asset + '.png',
								name: u.capital(asset.replace(/^[^\/]+\//g, '').replace(/-/g, ' ')),
							}
							if (asset.indexOf('decal/') !== -1) this.assets.pool.decal.push(o)
							else if (asset.indexOf('table/') !== -1) this.assets.pool.table.push(o)
							else if (asset.indexOf('felt/') !== -1) this.assets.pool.felt.push(o)
							else if (asset.indexOf('stick/') !== -1) this.assets.pool.stick.push(o)
						}
					}
				}
			}
		}
		return {
			image_loading: false,
		}
	},
	render: function () {
		//nada

		return window.user.username == 'Lame Guest ' ? null : (
			<div className="user-settings">
				<h1>
					User Settings — {window.user.username}{' '}
					{window.user && window.user.pu ? <small title="Power User">(Power User)</small> : ''}
					{window.user && !window.user.confirmed ? <small> - UNCONFIRMED READ BELLOW</small> : null}
				</h1>
				<small className="r" style={{ marginTop: -45 }}>
					Built: {u.format_time(version_time)}, {String(version_time).substr(-4)}
				</small>
				{window.user && !window.user.confirmed ? (
					<div>
						<hr />
						<h3>
							Your account is unconfirmed and may be automatically deleted at some point.{' '}
							<u>
								To confirm your account be sure your email is correct and type your password, then
								click the chat to close settings and <b>CHECK YOUR EMAIL, CLICK THE LINK ON IT</b>.
							</u>{' '}
							You should receive in MINUTES an email with a LINK to confirm your account. If your
							account is new, you should not be able to play while it remains unconfirmed. Q: I
							didn't receive an email. R: Just wait takes some minutes.
						</h3>
					</div>
				) : null}
				<form>
					<TabArea>
						<Tab id="profile" title="PROFILE">
							<Columns count="2">
								<div style={{ maxWidth: '162px' }}>
									<div onClick={this.askUploadImage} className="avatar">
										<img
											width="150"
											height="150"
											className="image-preview"
											title="Change Profile Image"
											src={
												this.state.image_loading
													? 'https://omgmobc.com/img/loading.gif'
													: is_video(window.user.image)
													? profile_picture(window.user.image).replace(/\.[^\.]+$/, '.png')
													: profile_picture(window.user.image, true)
											}
										/>
										<input type="hidden" className="image-value" value={window.user.image} />
										<input type="file" className="image-file" onChange={this.doUploadImage} />
									</div>

									<div onClick={this.askUploadCover} className="cover-image cover">
										<img
											width="150"
											height="150"
											className="image-preview"
											title="Change Cover Image"
											src={
												this.state.image_cover_loading
													? 'https://omgmobc.com/img/loading.gif'
													: window.user.cover || 'https://omgmobc.com/img/background/dusk-dark.jpg'
											}
										/>
										<input type="hidden" className="image-value" value={window.user.cover || ''} />
										<input type="file" className="image-file" onChange={this.doUploadCover} />
									</div>
								</div>
								<div>
									<div className="user-data">
										<label>
											<div>Status (text bellow your picture):</div>
											<div>
												<input
													type="text"
													className="status"
													autoComplete="off"
													placeholder="Lame I born, lame going to be"
													defaultValue={window.user.status}
												/>
											</div>
										</label>
										<label>
											<div>Email (to change type also password):</div>
											<div>
												<input
													type="text"
													className="email"
													spellCheck="false"
													placeholder="Email address"
													autoComplete="email"
													defaultValue={window.user.email}
												/>
											</div>
										</label>
										<label>
											<div>New password:</div>
											<div>
												<input type="password" className="password" autoComplete="new-password" />
											</div>
										</label>
										<label>
											<div>Text for profile views (10 chars max):</div>
											<div>
												<input
													type="text"
													maxLength="10"
													className="profileviews"
													defaultValue={window.user.profileviews}
												/>
											</div>
										</label>
										<label>
											<div>Text for last seen (22 chars max):</div>
											<div>
												<input
													type="text"
													maxLength="22"
													className="lastseen"
													defaultValue={window.user.lastseen}
												/>
											</div>
										</label>
										<label>
											<div>
												User tags, for when you want to get a notification in case someone mention
												any of the text entered here (100 chars max):
											</div>
											<div>
												<input
													type="text"
													maxLength="100"
													className="tags"
													defaultValue={window.user.tags}
												/>
											</div>
										</label>

										<label>
											<div>
												Number of messages on chat history (valid values from 100(default) to 1500):
											</div>
											<div>
												<input
													type="number"
													className="chathistory"
													defaultValue={window.user.chathistory || 100}
												/>
											</div>
										</label>
									</div>
								</div>
							</Columns>

							<div className="clear" />
						</Tab>
						<Tab id="privacy" title="PRIVACY">
							<div>
								<b>PROFILE</b>:
							</div>
							<ToggleSwitch className="nologin" defaultValue={window.user.nologin}>
								Do not show "last seen".
							</ToggleSwitch>
							<ToggleSwitch className="noarcade" defaultValue={window.user.noarcade}>
								Do not show "arcade stats".
							</ToggleSwitch>
							<ToggleSwitch className="noopp" defaultValue={window.user.noopp}>
								Do not show "opponent list".
							</ToggleSwitch>
							<ToggleSwitch className="nofriend" defaultValue={window.user.nofriend}>
								Do not show "friend list".
							</ToggleSwitch>
							<ToggleSwitch className="private" defaultValue={window.user.private}>
								Make my public messages private (on my own profile).
							</ToggleSwitch>
							<ToggleSwitch className="wallf" defaultValue={window.user.wallf}>
								Make my wall writable only by friends.
							</ToggleSwitch>
							<ToggleSwitch className="wallfo" defaultValue={window.user.wallfo}>
								Make my profile visible only to friends.
							</ToggleSwitch>
							<ToggleSwitch>Make me a sandwich.</ToggleSwitch>
							<hr />
							<b>Blocked Users:</b>
							<ul>
								{user.block && Object.keys(user.block).length
									? Object.keys(user.block).map((ub, idx) => {
											return (
												<li key={idx}>
													<span className="pointer" data-username={ub} onClick={openProfile}>
														{ub}
													</span>
												</li>
											)
									  })
									: 'No blocked users'}
							</ul>
							<div className="clear" />
						</Tab>
						<Tab id="site" title="SITE">
							<div>
								<b>STUFF</b> (do not tick if you do not understand):
							</div>
							<ToggleSwitch className="cblind" defaultValue={window.user.cblind}>
								Color blind mode (improved version over normal colors)
							</ToggleSwitch>
							<ToggleSwitch className="nohd" defaultValue={window.user.nohd}>
								No HD. When checked: Makes everything as light as possible for slow computers:
								removes animations, transitions, shadows and transform. Chat limits messages to 40.
								To try when "laggy".
							</ToggleSwitch>
							<ToggleSwitch className="noinline" defaultValue={window.user.noinline}>
								Do not show images/videos inline in chats or profiles (displays links instead).
							</ToggleSwitch>
							<ToggleSwitch className="record" defaultValue={window.user.record}>
								Click to start record audio, click again to stop recording audio (not click and
								hold)
							</ToggleSwitch>
							<ToggleSwitch className="recordvideo" defaultValue={window.user.recordvideo}>
								Click to start record video, click again to stop recording video (not click and
								hold)
							</ToggleSwitch>
							<ToggleSwitch className="nocolor" defaultValue={window.user.nocolor}>
								Color user messages on chat
							</ToggleSwitch>
							<ToggleSwitch
								className="aussie"
								defaultValue={document.body.style.transform === 'rotate(180deg)'}
								onChange={this.flipScreen}
							>
								Aussie Mode (Does not work with "No HD" mode)
							</ToggleSwitch>
							<ToggleSwitch className="nocam" defaultValue={window.user.nocam}>
								Hide the camera icon
							</ToggleSwitch>
							<ToggleSwitch className="nospectate" defaultValue={window.user.nospectate}>
								Do not spectate
							</ToggleSwitch>
						</Tab>
						<Tab id="notifications" title="NOTIFICATIONS">
							<div>
								<b>Browser Notifications</b> :
							</div>
							<ToggleSwitch className="nty" defaultValue={window.user.nty}>
								Show notifications (this control all the notifications regardless of the settings
								bellow, if this is off no notifictions will be shown)
							</ToggleSwitch>
							<ToggleSwitch className="ntyw" defaultValue={window.user.ntyw}>
								Show a notification when you get a wall message and all tabs are not focused
							</ToggleSwitch>
							<ToggleSwitch className="ntyc" defaultValue={window.user.ntyc}>
								Show a notification when someone mentions you in a chat but the tab has no focus
							</ToggleSwitch>
						</Tab>
						<Tab id="colours" title="COLOURS">
							<hr />
							<div>
								<b>THEME:</b>
							</div>
							<div>
								<ThemeSelector />
							</div>
							<div className="clear" />
							<hr />
							<b>COLORS</b>:
							<div className="clear colors ">
								<div>
									<label>
										<div>
											<span className="preview-color" style={{ background: window.user.ccolor }} />
											<input
												type="hidden"
												className="ccolor"
												spellCheck="false"
												placeholder="#FFFFFF"
												defaultValue={window.user.ccolor}
											/>
										</div>
										<div> username on chat</div>
									</label>
								</div>
								<div>
									<label>
										<div>
											<span className="preview-color" style={{ background: window.user.smcolor }} />
											<input
												type="hidden"
												className="smcolor"
												spellCheck="false"
												placeholder="#FFFFFF"
												defaultValue={window.user.smcolor}
											/>
										</div>
										<div> messages on chat</div>
									</label>
								</div>
								<div>
									<label>
										<div>
											<span
												className="preview-color"
												style={{ background: window.user.underline }}
											/>
											<input
												type="hidden"
												className="underline"
												spellCheck="false"
												placeholder="#FFFFFF"
												defaultValue={window.user.underline}
											/>
										</div>
										<div>alternative color for username on chat</div>
									</label>
								</div>
								<div>
									<label>
										<div>
											<span className="preview-color" style={{ background: window.user.color }} />
											<input
												type="hidden"
												className="color"
												spellCheck="false"
												placeholder="#FFFFFF"
												defaultValue={window.user.color}
											/>
										</div>
										<div> waiting picture border</div>
									</label>
								</div>
								<div>
									<label>
										<div>
											<span className="preview-color" style={{ background: window.user.scolor }} />
											<input
												type="hidden"
												className="scolor"
												spellCheck="false"
												placeholder="#FFFFFF"
												defaultValue={window.user.scolor}
											/>
										</div>
										<div> stats/status</div>
									</label>
								</div>

								<div>
									<label>
										<div>
											<span className="preview-color" style={{ background: window.user.sky }} />
											<input
												type="hidden"
												className="sky"
												spellCheck="false"
												placeholder="#FFFFFF"
												defaultValue={window.user.sky}
											/>
										</div>
										<div> profile gradient overlay</div>
									</label>
								</div>
								<div>
									<label>
										<div>
											<span
												className="preview-color"
												style={{ background: window.user.waitingbg }}
											/>
											<input
												type="hidden"
												className="waitingbg"
												spellCheck="false"
												placeholder="rgba(0,0,0,.3)"
												defaultValue={window.user.waitingbg}
											/>
										</div>
										<div>frame bottom </div>
									</label>
								</div>
								<div>
									<label>
										<div>
											<span
												className="preview-color"
												style={{ background: window.user.waitingbg2 }}
											/>
											<input
												type="hidden"
												className="waitingbg2"
												spellCheck="false"
												placeholder="rgba(0,0,0,.3)"
												defaultValue={window.user.waitingbg2}
											/>
										</div>
										<div>frame middle</div>
									</label>
								</div>
								<div>
									<label>
										<div>
											<span
												className="preview-color"
												style={{ background: window.user.waitingbg3 }}
											/>
											<input
												type="hidden"
												className="waitingbg3"
												spellCheck="false"
												placeholder="rgba(0,0,0,.3)"
												defaultValue={window.user.waitingbg3}
											/>
										</div>
										<div>frame top</div>
									</label>
								</div>

								<div>
									<label>
										<div>
											<span className="preview-color" style={{ background: window.user.sidebar }} />
											<input
												type="hidden"
												className="sidebar"
												spellCheck="false"
												placeholder="#FFFFFF"
												defaultValue={window.user.sidebar}
											/>
										</div>
										<div> profile sidebar</div>
									</label>
								</div>
								<div>
									<label>
										<div>
											<span className="preview-color" style={{ background: window.user.border }} />
											<input
												type="hidden"
												className="border"
												spellCheck="false"
												placeholder="#FFFFFF"
												defaultValue={window.user.border}
											/>
										</div>
										<div> profile borders</div>
									</label>
								</div>
								<div>
									<label>
										<div>
											<span className="preview-color" style={{ background: window.user.wall }} />
											<input
												type="hidden"
												className="wall"
												spellCheck="false"
												placeholder="#FFFFFF"
												defaultValue={window.user.wall}
											/>
										</div>
										<div> profile wall</div>
									</label>
								</div>
							</div>
							<hr />
							<b>EMOJI HUE (valid values from 0 to 360):</b>:
							<label>
								<div>
									<input
										type="number"
										className="emojihue"
										size="4"
										defaultValue={window.user.emojihue || 0}
										onChange={function (e) {
											this.setState({ emojihue: e.target.value })
										}.bind(this)}
									/>
								</div>
								<Box
									className="emoji-hue-preview"
									style={
										'class img{ filter: hue-rotate(' +
										(this.state.emojihue || window.user.emojihue || 0) +
										'deg) !important; }'
									}
									dangerouslySetInnerHTML={{
										__html: u.linky(':P :X :D xD <3 :**'),
									}}
								/>
							</label>
							<div className="clear" />
						</Tab>
						<Tab id="socialmedia" title="SOCIAL MEDIA">
							<div>
								<div>
									<b>SOCIAL MEDIA LINKS</b> (to display as icons in the profile. One link to profile
									per line):
								</div>

								<Box
									row
									grow
									element="textarea"
									width
									rows="9"
									color="#666"
									defaultValue={window.user.plink}
									className="plink"
								/>
							</div>
						</Tab>
						<Tab id="flash" title="FLASH">
							<div>
								<b>FLASH QUALITY</b>:
							</div>
							<label>
								<div>
									<input
										type="radio"
										className="fq"
										name="fq"
										value="1"
										defaultChecked={window.user.fq === 1}
									/>{' '}
									LOW - favors playback speed over appearance and never uses anti-aliasing.
								</div>
							</label>
							<label>
								<div>
									<input
										type="radio"
										className="fq"
										name="fq"
										value="2"
										defaultChecked={window.user.fq === 2}
									/>{' '}
									AUTOLOW - emphasizes speed at first but improves appearance whenever possible.
									Playback begins with anti-aliasing turned off. If Flash Player detects that the
									processor can handle it, anti-aliasing is turned on.
								</div>
							</label>
							<label>
								<div>
									<input
										type="radio"
										className="fq"
										name="fq"
										value="3"
										defaultChecked={window.user.fq === 3}
									/>{' '}
									AUTOHIGH - emphasizes playback speed and appearance equally at first but
									sacrifices appearance for playback speed if necessary. Playback begins with
									anti-aliasing turned on. If the actual frame rate drops below the specified frame
									rate, anti-aliasing is turned off to improve playback speed. Use this setting to
									emulate the View - Antialias setting in Flash Professional.
								</div>
							</label>
							<label>
								<div>
									<input
										type="radio"
										className="fq"
										name="fq"
										value="5"
										defaultChecked={window.user.fq === 5}
									/>{' '}
									MEDIUM - (default) applies some anti-aliasing and does not smooth bitmaps. It
									produces a better quality than the Low setting, but lower quality than the High
									setting.
								</div>
							</label>
							<label>
								<div>
									<input
										type="radio"
										className="fq"
										name="fq"
										value="4"
										defaultChecked={window.user.fq === 4}
									/>{' '}
									HIGH - favors appearance over playback speed and always applies anti-aliasing. If
									the movie does not contain animation, bitmaps are smoothed; if the movie has
									animation, bitmaps are not smoothed.
								</div>
							</label>
							<label>
								<div>
									<input
										type="radio"
										className="fq"
										name="fq"
										value="0"
										defaultChecked={!window.user.fq}
									/>{' '}
									BEST - provides the best display quality and does not consider playback speed. All
									output is anti-aliased and all bitmaps are smoothed.
								</div>
							</label>
							<hr />
							<div>
								<b>FLASH FPS (Frames Per Second)</b>:
							</div>
							{/*<label>
							<div>
								<input
									type="radio"
									className="fps"
									name="fps"
									value="5"
									defaultChecked={window.user.fps === 5}
								/>{' '}
								5 (Meh) - My computer is a nokia 1100!.
							</div>
						</label>*/}
							<label>
								<div>
									<input
										type="radio"
										className="fps"
										name="fps"
										value="15"
										defaultChecked={window.user.fps === 15}
									/>{' '}
									15 (LOW) - My computer is super bad or I dont want it to let it heat!.
								</div>
							</label>
							<label>
								<div>
									<input
										type="radio"
										className="fps"
										name="fps"
										value="30"
										defaultChecked={window.user.fps === 30}
									/>{' '}
									30 (LOW) - My computer is bad.
								</div>
							</label>
							<label>
								<div>
									<input
										type="radio"
										className="fps"
										name="fps"
										value="45"
										defaultChecked={window.user.fps === 45}
									/>{' '}
									45 (LOW) - My computer is somewhat bad but may handle this.
								</div>
							</label>
							<label>
								<div>
									<input
										type="radio"
										className="fps"
										name="fps"
										value="60"
										defaultChecked={window.user.fps === 60}
									/>{' '}
									60 (NORMAL) - My computer is good enough.
								</div>
							</label>
							<label>
								<div>
									<input
										type="radio"
										className="fps"
										name="fps"
										value="72"
										defaultChecked={window.user.fps === 72}
									/>{' '}
									72 (does this even exists?) - My computer is super! but not super enough xD.
								</div>
							</label>
							<label>
								<div>
									<input
										type="radio"
										className="fps"
										name="fps"
										value="144"
										defaultChecked={window.user.fps === 144}
									/>{' '}
									144 (INSANE gaming computer screen refresh rate 144mhz) - My computer is my
									girlfriend!.
								</div>
							</label>

							<div className="clear" />
						</Tab>
						<Tab id="pool" title="POOL">
							<TabArea inner="true">
								<Tab id="table" title="TABLE">
									<label>
										<div className="asset-pool-table">
											<input
												type="hidden"
												className="pool-table"
												defaultValue={
													window.user.pool && window.user.pool.table ? window.user.pool.table : null
												}
											/>

											{this.assets.pool.table.reverse().map(
												function (item, id) {
													return (
														<div
															key={id}
															data-asset={item.asset}
															data-key="pool-table"
															data-selected={
																window.user.pool && window.user.pool.table == item.asset
															}
															onClick={this.selected}
															className="asset"
														>
															<img src={item.image} width="80" height="80" />
															{item.name}
														</div>
													)
												}.bind(this),
											)}
										</div>
									</label>
									<div className="clear" />
								</Tab>
								<Tab id="felt" title="FELT">
									<label>
										<div className="asset-pool-felt">
											<input
												type="hidden"
												className="pool-felt"
												defaultValue={
													window.user.pool && window.user.pool.felt ? window.user.pool.felt : null
												}
											/>
											{this.assets.pool.felt.reverse().map(
												function (item, id) {
													return (
														<div
															key={id}
															data-asset={item.asset}
															data-key="pool-felt"
															data-selected={
																window.user.pool && window.user.pool.felt == item.asset
															}
															onClick={this.selected}
															className="asset"
														>
															<img src={item.image} width="80" height="80" />
															{item.name}
														</div>
													)
												}.bind(this),
											)}
										</div>
									</label>
									<div className="clear" />
								</Tab>
								<Tab id="stick" title="STICK">
									<label>
										<div className="asset-pool-stick">
											<input
												type="hidden"
												className="pool-stick"
												defaultValue={
													window.user.pool && window.user.pool.stick ? window.user.pool.stick : null
												}
											/>
											{this.assets.pool.stick.reverse().map(
												function (item, id) {
													return (
														<div
															key={id}
															data-asset={item.asset}
															data-key="pool-stick"
															data-selected={
																window.user.pool && window.user.pool.stick == item.asset
															}
															onClick={this.selected}
															className="asset"
														>
															<img src={item.image} width="80" height="80" />
															{item.name}
														</div>
													)
												}.bind(this),
											)}
										</div>
									</label>
									<div className="clear" />
								</Tab>
								<Tab id="decal" title="DECAL">
									<label>
										<div className="asset-pool-decal">
											<input
												type="hidden"
												className="pool-decal"
												defaultValue={
													window.user.pool && window.user.pool.decal ? window.user.pool.decal : null
												}
											/>
											{this.assets.pool.decal.reverse().map(
												function (item, id) {
													return (
														<div
															key={id}
															data-asset={item.asset}
															data-key="pool-decal"
															data-selected={
																window.user.pool && window.user.pool.decal == item.asset
															}
															onClick={this.selected}
															className="asset"
														>
															<img src={item.image} width="80" height="80" />
															{item.name}
														</div>
													)
												}.bind(this),
											)}
										</div>
									</label>
									<div className="clear" />
								</Tab>
								<Tab id="poolmisc" title="MISC">
									<div>IN GAME:</div>
									<ToggleSwitch
										className="pool-own"
										defaultValue={window.user && window.user.pool && window.user.pool.own}
									>
										Play Pool and 9 Ball with my own table, felt and decal regardless of the
										opponent selections.
									</ToggleSwitch>
									<div className="clear" />
								</Tab>
							</TabArea>
						</Tab>
						<Tab id="swapples" title="SWAPPLES">
							<div>IN GAME:</div>
							<ToggleSwitch className="fswap" defaultValue={window.user.fswap}>
								Play Fast Swapples.
							</ToggleSwitch>
							<div className="clear" />
						</Tab>
					</TabArea>
				</form>
				<SeeAlso />
			</div>
		)
	},
	flipScreen: function (e) {
		document.body.style.transform = document.body.style.transform === '' ? 'rotate(180deg)' : ''
	},
	selected: function (e) {
		var item = $(e.currentTarget)

		var node = item.attr('data-key')
		var value = item.attr('data-asset')

		$('.content-container .footer .page .user-settings .' + node).val(value)
		$('.content-container .footer .page .user-settings .asset-' + node)
			.find('[data-selected]')
			.attr('data-selected', false)

		item.attr('data-selected', true)
	},
	save: function () {
		if (($('.content-container .footer .page .user-settings .email').val() || '') != '') {
			emit(
				{
					id: 'settings',
					image: $('.content-container .footer .page .user-settings .avatar .image-value').val(),
					cover: $('.content-container .footer .page .user-settings .cover .image-value').val(),
					status: $('.content-container .footer .page .user-settings .status').val(),
					plink: $('.content-container .footer .page .user-settings .plink').val(),
					color: $('.content-container .footer .page .user-settings .color').val(),
					ccolor: $('.content-container .footer .page .user-settings .ccolor').val(),
					underline: $('.content-container .footer .page .user-settings .underline').val(),
					border: $('.content-container .footer .page .user-settings .border').val(),
					scolor: $('.content-container .footer .page .user-settings .scolor').val(),
					waitingbg: $('.content-container .footer .page .user-settings .waitingbg').val(),
					waitingbg2: $('.content-container .footer .page .user-settings .waitingbg2').val(),
					waitingbg3: $('.content-container .footer .page .user-settings .waitingbg3').val(),
					emojihue: $('.content-container .footer .page .user-settings .emojihue').val(),
					chathistory: $('.content-container .footer .page .user-settings .chathistory').val(),
					profileviews: $('.content-container .footer .page .user-settings .profileviews').val(),
					lastseen: $('.content-container .footer .page .user-settings .lastseen').val(),
					tags: $('.content-container .footer .page .user-settings .tags')
						.val()
						.replace(/@/g, ' ')
						.replace(/,/g, ' '),
					smcolor: $('.content-container .footer .page .user-settings .smcolor').val(),
					sidebar: $('.content-container .footer .page .user-settings .sidebar').val(),
					wall: $('.content-container .footer .page .user-settings .wall').val(),
					sky: $('.content-container .footer .page .user-settings .sky').val(),
					password: $('.content-container .footer .page .user-settings .password').val(),
					email: $('.content-container .footer .page .user-settings .email').val(),
					nohd: $('.content-container .footer .page .user-settings .nohd').prop('checked'),
					nospectate: $('.content-container .footer .page .user-settings .nospectate').prop(
						'checked',
					),

					nty: $('.content-container .footer .page .user-settings .nty').prop('checked'),
					ntyw: $('.content-container .footer .page .user-settings .ntyw').prop('checked'),
					ntyc: $('.content-container .footer .page .user-settings .ntyc').prop('checked'),

					nocam: $('.content-container .footer .page .user-settings .nocam').prop('checked'),
					cblind: $('.content-container .footer .page .user-settings .cblind').prop('checked'),
					fps: +$('.content-container .footer .page .user-settings .fps:checked').val(),
					fswap: $('.content-container .footer .page .user-settings .fswap').prop('checked'),
					fq: +$('.content-container .footer .page .user-settings .fq:checked').val(),
					nologin: $('.content-container .footer .page .user-settings .nologin').prop('checked'),
					noarcade: $('.content-container .footer .page .user-settings .noarcade').prop('checked'),
					noopp: $('.content-container .footer .page .user-settings .noopp').prop('checked'),
					nofriend: $('.content-container .footer .page .user-settings .nofriend').prop('checked'),
					wallf: $('.content-container .footer .page .user-settings .wallf').prop('checked'),
					wallfo: $('.content-container .footer .page .user-settings .wallfo').prop('checked'),
					private: $('.content-container .footer .page .user-settings .private').prop('checked'),
					noinline: $('.content-container .footer .page .user-settings .noinline').prop('checked'),
					record: $('.content-container .footer .page .user-settings .record').prop('checked'),
					recordvideo: $('.content-container .footer .page .user-settings .recordvideo').prop(
						'checked',
					),
					nocolor: $('.content-container .footer .page .user-settings .nocolor').prop('checked'),
					pool: {
						table: $('.content-container .footer .page .user-settings .pool-table').val(),
						felt: $('.content-container .footer .page .user-settings .pool-felt').val(),
						decal: $('.content-container .footer .page .user-settings .pool-decal').val(),
						stick: $('.content-container .footer .page .user-settings .pool-stick').val(),
						own: $('.content-container .footer .page .user-settings .pool-own').prop('checked'),
					},
				},
				function (email, password) {
					storage.update({
						email: email,
						password: password,
					})
				},
			)
		}
	},
	componentDidMount: function () {
		this.mounted = true
		if (window.user.username == 'Lame Guest ') {
			clearInterval(this.interval)
			this.interval = setInterval(
				function () {
					if (window.user.username != 'Lame Guest ') {
						clearInterval(this.interval)
						if (this.mounted) this.setState({ nada: !this.state.nada }, this.onComponentDidMount)
					}
				}.bind(this),
				100,
			)
			return
		}
		this.onComponentDidMount()
	},
	onComponentDidMount: function () {
		var ids = [
			'.content-container .footer .page .user-settings .ccolor',
			'.content-container .footer .page .user-settings .underline',
			'.content-container .footer .page .user-settings .color',
			'.content-container .footer .page .user-settings .border',
			'.content-container .footer .page .user-settings .scolor',
			'.content-container .footer .page .user-settings .sidebar',
			'.content-container .footer .page .user-settings .wall',
			'.content-container .footer .page .user-settings .sky',
			'.content-container .footer .page .user-settings .waitingbg',
			'.content-container .footer .page .user-settings .waitingbg2',
			'.content-container .footer .page .user-settings .waitingbg3',
			'.content-container .footer .page .user-settings .smcolor',
		]
		ids.forEach(function (item) {
			var parent = document.querySelector(item).previousSibling
			var picker = new Picker(parent)
			picker.setOptions({
				color: document.querySelector(item).value,
				popup: 'right',
				editorFormat: 'rgb',
			})

			picker.onDone = function (color) {
				parent.style.background = color.rgbaString
				document.querySelector(item).value = color.rgbaString
			}
			/*parent.addEventListener('click', function() {
				picker.show()
			})*/
		})
	},
	componentWillUnmount: function () {
		this.mounted = false
		clearInterval(this.interval)
		if (window.user.username == 'Lame Guest ') return

		this.save()
	},
	askUploadImage: function () {
		u.click($('.content-container .footer .page .user-settings .avatar .image-file'))
	},
	doUploadImage: function () {
		var input = $('.content-container .footer .page .user-settings .avatar .image-file').get(0)

		var self = this

		function error(message) {
			if (String(message).indexOf('>') !== -1)
				message = 'The image size is too big or something went wrong.'
			if (self.mounted)
				self.setState({
					image_loading: false,
				})
			window.message('error', String(message))
		}

		if (input.files && input.files[0]) {
			if (this.mounted)
				this.setState({
					image_loading: true,
				})

			var file = input.files[0]
			var formdata = new FormData()
			formdata.append('file', file)
			var ajax = new XMLHttpRequest()
			ajax.addEventListener(
				'load',
				function (e) {
					try {
						var data = String(e.target.responseText)
						if (data.indexOf('https://') === 0) {
							window.user.image = data

							if (self.mounted)
								self.setState({
									image_loading: false,
								})
						} else {
							error(data)
						}
					} catch (e) {
						error('No image selected!')
					}
				},
				false,
			)
			ajax.addEventListener('error', error, false)
			ajax.addEventListener('abort', error, false)
			ajax.open('POST', 'https://omgmobc.com/php/upload.php?type=profile&action=upload')
			try {
				ajax.send(formdata)
			} catch (e) {
				error('Unable to upload pic, please try later!')
			}
		} else {
			error('No image selected!')
		}
	},
	askUploadCover: function () {
		u.click($('.content-container .footer .page .user-settings .cover .image-file'))
	},
	doUploadCover: function () {
		var input = $('.content-container .footer .page .user-settings .cover .image-file').get(0)

		var self = this

		function error(message) {
			if (String(message).indexOf('>') !== -1)
				message = 'The image size is too big or something went wrong.'
			if (self.mounted)
				self.setState({
					image_cover_loading: false,
				})
			window.message('error', String(message))
		}

		if (input.files && input.files[0]) {
			if (this.mounted)
				this.setState({
					image_cover_loading: true,
				})

			var file = input.files[0]
			var formdata = new FormData()
			formdata.append('file', file)
			var ajax = new XMLHttpRequest()
			ajax.addEventListener(
				'load',
				function (e) {
					try {
						var data = String(e.target.responseText)
						if (data.indexOf('https://') === 0) {
							window.user.cover = data

							if (self.mounted)
								self.setState({
									image_cover_loading: false,
								})
						} else {
							error(data)
						}
					} catch (e) {
						error('No image selected!')
					}
				},
				false,
			)
			ajax.addEventListener('error', error, false)
			ajax.addEventListener('abort', error, false)
			ajax.open('POST', 'https://omgmobc.com/php/upload.php?type=cover&action=upload')
			try {
				ajax.send(formdata)
			} catch (e) {
				error('Unable to upload pic, please try again later!')
			}
		} else {
			error('No image selected!')
		}
	},
})
