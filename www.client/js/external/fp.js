/* global define */
;(function (name, context, definition) {
	'use strict'
	if (typeof window !== 'undefined' && typeof define === 'function' && define.amd) {
		define(definition)
	} else if (typeof module !== 'undefined' && module.exports) {
		module.exports = definition()
	} else if (context.exports) {
		context.exports = definition()
	} else {
		context[name] = definition()
	}
})('fp', this, function () {
	'use strict'

	var defaultOptions = {
		preprocessor: null,

		screen: {
			// To ensure consistent fps when users rotate their mobile devices
			detectScreenOrientation: true,
		},
		plugins: {
			sortPluginsFor: [/palemoon/i],
			excludeIE: false,
		},
		extraComponents: [],
		excludes: {},
		NOT_AVAILABLE: 'not available',
		ERROR: 'error',
		EXCLUDED: 'excluded',
	}

	var each = function (obj, iterator) {
		if (Array.prototype.forEach && obj.forEach === Array.prototype.forEach) {
			obj.forEach(iterator)
		} else if (obj.length === +obj.length) {
			for (var i = 0, l = obj.length; i < l; i++) {
				iterator(obj[i], i, obj)
			}
		} else {
			for (var key in obj) {
				if (obj.hasOwnProperty(key)) {
					iterator(obj[key], key, obj)
				}
			}
		}
	}

	var map = function (obj, iterator) {
		var results = []
		// Not using strict equality so that this acts as a
		// shortcut to checking for `null` and `undefined`.
		if (obj == null) {
			return results
		}
		if (Array.prototype.map && obj.map === Array.prototype.map) {
			return obj.map(iterator)
		}
		each(obj, function (value, index, list) {
			results.push(iterator(value, index, list))
		})
		return results
	}

	var extendSoft = function (target, source) {
		if (source == null) {
			return target
		}
		var value
		var key
		for (key in source) {
			value = source[key]
			if (value != null && !Object.prototype.hasOwnProperty.call(target, key)) {
				target[key] = value
			}
		}
		return target
	}

	var webdriver = function (done, options) {
		done(navigator.webdriver == null ? options.NOT_AVAILABLE : navigator.webdriver)
	}
	var languageKey = function (done, options) {
		done(
			navigator.language ||
				navigator.userLanguage ||
				navigator.browserLanguage ||
				navigator.systemLanguage ||
				options.NOT_AVAILABLE,
		)
	}
	var colorDepthKey = function (done, options) {
		done(window.screen.colorDepth || options.NOT_AVAILABLE)
	}

	var screenResolutionKey = function (done, options) {
		done(getScreenResolution(options))
	}
	var getScreenResolution = function (options) {
		var resolution = [window.screen.width, window.screen.height]
		if (options.screen.detectScreenOrientation) {
			resolution.sort().reverse()
		}
		return resolution
	}
	var availableScreenResolutionKey = function (done, options) {
		done(getAvailableScreenResolution(options))
	}
	var getAvailableScreenResolution = function (options) {
		if (window.screen.availWidth && window.screen.availHeight) {
			var available = [window.screen.availHeight, window.screen.availWidth]
			if (options.screen.detectScreenOrientation) {
				available.sort().reverse()
			}
			return available
		}
		// headless browsers
		return options.NOT_AVAILABLE
	}
	var timezoneOffset = function (done) {
		done(new Date().getTimezoneOffset())
	}

	var sessionStorageKey = function (done, options) {
		done(hasSessionStorage(options))
	}
	var localStorageKey = function (done, options) {
		done(hasLocalStorage(options))
	}
	var indexedDbKey = function (done, options) {
		done(hasIndexedDB(options))
	}
	var addBehaviorKey = function (done) {
		// body might not be defined at this point or removed programmatically
		done(!!(document.body && document.body.addBehavior))
	}
	var openDatabaseKey = function (done) {
		done(!!window.openDatabase)
	}
	var cpuClassKey = function (done, options) {
		done(getNavigatorCpuClass(options))
	}
	var platformKey = function (done, options) {
		done(getNavigatorPlatform(options))
	}

	var canvasKey = function (done, options) {
		if (isCanvasSupported()) {
			done(getCanvasFp(options))
			return
		}
		done(options.NOT_AVAILABLE)
	}

	var pluginsComponent = function (done, options) {
		if (isIE()) {
			if (!options.plugins.excludeIE) {
				done(getIEPlugins(options))
			} else {
				done(options.EXCLUDED)
			}
		} else {
			done(getRegularPlugins(options))
		}
	}
	var getRegularPlugins = function (options) {
		if (navigator.plugins == null) {
			return options.NOT_AVAILABLE
		}

		var plugins = []
		// plugins isn't defined in Node envs.
		for (var i = 0, l = navigator.plugins.length; i < l; i++) {
			if (navigator.plugins[i]) {
				plugins.push(navigator.plugins[i])
			}
		}

		// sorting plugins only for those user agents, that we know randomize the plugins
		// every time we try to enumerate them
		if (pluginsShouldBeSorted(options)) {
			plugins = plugins.sort(function (a, b) {
				if (a.name > b.name) {
					return 1
				}
				if (a.name < b.name) {
					return -1
				}
				return 0
			})
		}
		return map(plugins, function (p) {
			var mimeTypes = map(p, function (mt) {
				return [mt.type, mt.suffixes]
			})
			return [p.name, p.description, mimeTypes]
		})
	}
	var getIEPlugins = function (options) {
		var result = []
		if (
			(Object.getOwnPropertyDescriptor &&
				Object.getOwnPropertyDescriptor(window, 'ActiveXObject')) ||
			'ActiveXObject' in window
		) {
			var names = [
				'AcroPDF.PDF', // Adobe PDF reader 7+
				'Adodb.Stream',
				'AgControl.AgControl', // Silverlight
				'DevalVRXCtrl.DevalVRXCtrl.1',
				'MacromediaFlashPaper.MacromediaFlashPaper',
				'Msxml2.DOMDocument',
				'Msxml2.XMLHTTP',
				'PDF.PdfCtrl', // Adobe PDF reader 6 and earlier, brrr
				'QuickTime.QuickTime', // QuickTime
				'QuickTimeCheckObject.QuickTimeCheck.1',
				'RealPlayer',
				'RealPlayer.RealPlayer(tm) ActiveX Control (32-bit)',
				'RealVideo.RealVideo(tm) ActiveX Control (32-bit)',
				'Scripting.Dictionary',
				'SWCtl.SWCtl', // ShockWave player
				'Shell.UIHelper',
				'ShockwaveFlash.ShockwaveFlash', // flash plugin
				'Skype.Detection',
				'TDCCtl.TDCCtl',
				'WMPlayer.OCX', // Windows media player
				'rmocx.RealPlayer G2 Control',
				'rmocx.RealPlayer G2 Control.1',
			]
			// starting to detect plugins in IE
			result = map(names, function (name) {
				try {
					// eslint-disable-next-line no-new
					new window.ActiveXObject(name)
					return name
				} catch (e) {
					return options.ERROR
				}
			})
		} else {
			result.push(options.NOT_AVAILABLE)
		}
		if (navigator.plugins) {
			result = result.concat(getRegularPlugins(options))
		}
		return result
	}
	var pluginsShouldBeSorted = function (options) {
		var should = false
		for (var i = 0, l = options.plugins.sortPluginsFor.length; i < l; i++) {
			var re = options.plugins.sortPluginsFor[i]
			if (navigator.userAgent.match(re)) {
				should = true
				break
			}
		}
		return should
	}
	var touchSupportKey = function (done) {
		done(getTouchSupport())
	}
	var hardwareConcurrencyKey = function (done, options) {
		done(getHardwareConcurrency(options))
	}
	var hasSessionStorage = function (options) {
		try {
			return !!window.sessionStorage
		} catch (e) {
			return options.ERROR // SecurityError when referencing it means it exists
		}
	}

	// https://bugzilla.mozilla.org/show_bug.cgi?id=781447
	var hasLocalStorage = function (options) {
		try {
			return !!window.localStorage
		} catch (e) {
			return options.ERROR // SecurityError when referencing it means it exists
		}
	}
	var hasIndexedDB = function (options) {
		try {
			return !!window.indexedDB
		} catch (e) {
			return options.ERROR // SecurityError when referencing it means it exists
		}
	}
	var getHardwareConcurrency = function (options) {
		if (navigator.hardwareConcurrency) {
			return navigator.hardwareConcurrency
		}
		return options.NOT_AVAILABLE
	}
	var getNavigatorCpuClass = function (options) {
		return navigator.cpuClass || options.NOT_AVAILABLE
	}
	var getNavigatorPlatform = function (options) {
		if (navigator.platform) {
			return navigator.platform
		} else {
			return options.NOT_AVAILABLE
		}
	}

	// This is a crude and primitive touch screen detection.
	// It's not possible to currently reliably detect the  availability of a touch screen
	// with a JS, without actually subscribing to a touch event.
	// http://www.stucox.com/blog/you-cant-detect-a-touchscreen/
	// https://github.com/Modernizr/Modernizr/issues/548
	// method returns an array of 3 values:
	// maxTouchPoints, the success or failure of creating a TouchEvent,
	// and the availability of the 'ontouchstart' property

	var getTouchSupport = function () {
		var maxTouchPoints = 0
		var touchEvent
		if (typeof navigator.maxTouchPoints !== 'undefined') {
			maxTouchPoints = navigator.maxTouchPoints
		} else if (typeof navigator.msMaxTouchPoints !== 'undefined') {
			maxTouchPoints = navigator.msMaxTouchPoints
		}
		try {
			document.createEvent('TouchEvent')
			touchEvent = true
		} catch (_) {
			touchEvent = false
		}
		var touchStart = 'ontouchstart' in window
		return [maxTouchPoints, touchEvent, touchStart]
	}
	// https://www.browserleaks.com/canvas#how-does-it-work

	var getCanvasFp = function (options) {
		var result = []
		// Very simple now, need to make it more complex (geo shapes etc)
		var canvas = document.createElement('canvas')
		canvas.width = 2000
		canvas.height = 200
		canvas.style.display = 'inline'
		var ctx = canvas.getContext('2d')
		// detect browser support of canvas winding
		// http://blogs.adobe.com/webplatform/2013/01/30/winding-rules-in-canvas/
		// https://github.com/Modernizr/Modernizr/blob/master/feature-detects/canvas/winding.js
		ctx.rect(0, 0, 10, 10)
		ctx.rect(2, 2, 6, 6)
		result.push('canvas winding:' + (ctx.isPointInPath(5, 5, 'evenodd') === false ? 'yes' : 'no'))

		ctx.textBaseline = 'alphabetic'
		ctx.fillStyle = '#f60'
		ctx.fillRect(125, 1, 62, 20)
		ctx.fillStyle = '#069'

		ctx.font = '11pt Arial'

		ctx.fillText('Cwm fjordbank glyphs vext quiz, \ud83d\ude03', 2, 15)
		ctx.fillStyle = 'rgba(102, 204, 0, 0.2)'
		ctx.font = '18pt Arial'
		ctx.fillText('Cwm fjordbank 😋glyphs vext quiz, \ud83d\ude03', 4, 45)

		// canvas blending
		// http://blogs.adobe.com/webplatform/2013/01/28/blending-features-in-canvas/
		// http://jsfiddle.net/NDYV8/16/
		ctx.globalCompositeOperation = 'multiply'
		ctx.fillStyle = 'rgb(255,0,255,.5)'
		ctx.beginPath()
		ctx.arc(50, 50, 50, 0, Math.PI * 2, true)
		ctx.closePath()
		ctx.fill()
		ctx.fillStyle = 'rgb(0,255,255,.5)'
		ctx.beginPath()
		ctx.arc(100, 50, 50, 0, Math.PI * 2, true)
		ctx.closePath()
		ctx.fill()
		ctx.fillStyle = 'rgb(255,255,0,.5)'
		ctx.beginPath()
		ctx.arc(75, 100, 50, 0, Math.PI * 2, true)
		ctx.closePath()
		ctx.fill()
		ctx.fillStyle = 'rgb(255,0,255,.5)'
		// canvas winding
		// http://blogs.adobe.com/webplatform/2013/01/30/winding-rules-in-canvas/
		// http://jsfiddle.net/NDYV8/19/
		ctx.arc(75, 75, 75, 0, Math.PI * 2, true)
		ctx.arc(75, 75, 25, 0, Math.PI * 2, true)
		ctx.fill('evenodd')

		if (canvas.toDataURL) {
			result.push('canvas fp:' + canvas.toDataURL())
		}
		return result
	}

	var isCanvasSupported = function () {
		var elem = document.createElement('canvas')
		return !!(elem.getContext && elem.getContext('2d'))
	}

	var isIE = function () {
		if (navigator.appName === 'Microsoft Internet Explorer') {
			return true
		} else if (navigator.appName === 'Netscape' && /Trident/.test(navigator.userAgent)) {
			// IE 11
			return true
		}
		return false
	}

	var components = [
		//{ key: 'userAgent', getData: userAgentKey },
		{ key: 'webdriver', getData: webdriver },
		{ key: 'language', getData: languageKey },
		{ key: 'colorDepth', getData: colorDepthKey },
		//{ key: 'deviceMemory', getData: deviceMemoryKey },
		//{ key: 'pixelRatio', getData: pixelRatioKey },
		{ key: 'hardwareConcurrency', getData: hardwareConcurrencyKey },
		{ key: 'screenResolution', getData: screenResolutionKey },
		{ key: 'availableScreenResolution', getData: availableScreenResolutionKey },
		{ key: 'timezoneOffset', getData: timezoneOffset },
		//{ key: 'timezone', getData: timezone },
		{ key: 'sessionStorage', getData: sessionStorageKey },
		{ key: 'localStorage', getData: localStorageKey },
		{ key: 'indexedDb', getData: indexedDbKey },
		{ key: 'addBehavior', getData: addBehaviorKey },
		{ key: 'openDatabase', getData: openDatabaseKey },
		{ key: 'cpuClass', getData: cpuClassKey },
		{ key: 'platform', getData: platformKey },
		//{ key: 'doNotTrack', getData: doNotTrackKey },
		{ key: 'plugins', getData: pluginsComponent },
		{ key: 'canvas', getData: canvasKey },
		//{ key: 'webgl', getData: webglKey },
		//{ key: 'webglVendorAndRenderer', getData: webglVendorAndRendererKey },
		//{ key: 'adBlock', getData: adBlockKey },
		//{ key: 'hasLiedLanguages', getData: hasLiedLanguagesKey },
		//{ key: 'hasLiedResolution', getData: hasLiedResolutionKey },
		//{ key: 'hasLiedOs', getData: hasLiedOsKey },
		//{ key: 'hasLiedBrowser', getData: hasLiedBrowserKey },
		{ key: 'touchSupport', getData: touchSupportKey },
		//{ key: 'fonts', getData: jsFontsKey, pauseBefore: true },
		//{ key: 'fontsFlash', getData: flashFontsKey, pauseBefore: true },
		//{ key: 'audio', getData: audioKey },
		//{ key: 'enumerateDevices', getData: enumerateDevicesKey },
	]

	var fp = function (options, callback) {
		if (!callback) {
			callback = options
			options = {}
		} else if (!options) {
			options = {}
		}
		extendSoft(options, defaultOptions)
		options.components = options.extraComponents.concat(components)

		var keys = {
			data: [],
			addPreprocessedComponent: function (key, value) {
				if (typeof options.preprocessor === 'function') {
					value = options.preprocessor(key, value)
				}
				keys.data.push({ key: key, value: value })
			},
		}

		var i = -1
		var chainComponents = function (alreadyWaited) {
			i += 1
			if (i >= options.components.length) {
				// on finish
				callback(keys.data)
				return
			}
			var component = options.components[i]

			if (options.excludes[component.key]) {
				chainComponents(false) // skip
				return
			}

			if (!alreadyWaited && component.pauseBefore) {
				i -= 1
				setTimeout(function () {
					chainComponents(true)
				}, 1)
				return
			}

			try {
				component.getData(function (value) {
					keys.addPreprocessedComponent(component.key, value)
					chainComponents(false)
				}, options)
			} catch (error) {
				// main body error
				keys.addPreprocessedComponent(component.key, String(error))
				chainComponents(false)
			}
		}

		chainComponents(false)
	}

	// fp.VERSION = '2.1.0'
	return fp
})
