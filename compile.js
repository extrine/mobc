module.exports = {
	domain: 'omgmobc.com',
	ip: '195.201.17.65',
	port: 3333,

	autoupdate: [
		['https://unpkg.com/jquery@3/dist/jquery.min.js', 'www.client/js/external/jquery.min.js'],
	],
	on_compile: function() {
		return Promise.all([
			read('www.client/m/f.min.js'),
			read('www.client/m/f.css'),
			read('www.client/asset/pool/@list'),
			read('www.client/index.template'),
			read('www.client/index.html'),
		]).then(function(c) {
			var js = c[0],
				css = c[1],
				list = c[2],
				template = c[3],
				index = c[4]

			js = js.replace('__ASSETS_POOL__', list.replace(/\n/g, '\\n'))

			template = template
				.replace(/js\?h[^"]*"/g, 'js?h' + hash(js).substr(0, 10) + '"')
				.replace(/css\?h[^"]*"/g, 'css?h' + hash(css).substr(0, 10) + '"')

			if (
				template.replace(/var version_time = [0-9]+/, '') !=
				index.replace(/var version_time = [0-9]+/, '')
			) {
				template = template.replace(
					/var version_time = [0-9]+;/,
					'var version_time = ' + version_time + ';',
				)
				return Promise.all([
					write('www.client/m/f.js', js),
					write('www.client/index.html', template),
				]).then(function() {
					log('Wrote index.html')
				})
			}
		})
	},
}
