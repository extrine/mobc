module.exports = {
	presets: [
		/*	[
			'@babel/preset-env',
			{
				modules: false,
				'targets': '> 0.25%, not dead',
			},
		],*/
		'@babel/preset-react',
		[
			'minify',

			{
				builtIns: false,
				//deadcode: false,
			},
		],
	],
	cwd: 'compile/',
	plugins: [
		['@babel/plugin-proposal-decorators', { legacy: true }],
		['@babel/plugin-proposal-class-properties', { loose: true }],
	],
	ast: false,
	sourceMaps: 'inline',
	comments: false,
	envName: 'production',
	sourceType: 'module',
	retainLines: false,
	compact: true,
	minified: true,
}
