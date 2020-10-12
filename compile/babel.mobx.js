module.exports = {
	presets: [
		[
			'minify',
			{
				//evaluate: false,
				builtIns: false,
				//deadcode: false,
			},
		],
	],
	cwd: 'compile/',
	plugins: [
		[
			'babel-plugin-jsx-dom-expressions',
			{
				'moduleName': 'mobx-jsx',
				'alwaysCreateComponents': false,
				'wrapConditionals': true,
				'delegateEvents': true,
				'contextToCustomElements': false,
			},
		],
		/*['@babel/plugin-transform-runtime', { useESModules: false, absoluteRuntime: false }],*/
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
	babelHelpers: 'bundled',
}
