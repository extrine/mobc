var settings = [
	'PluginsContentSetting',
	'NotificationsContentSetting',
	'MicrophoneContentSetting',
	'notifications',
	'plugins',
	'microphone',
]

settings.forEach(function(item) {
	if (chrome.contentSettings[item] && chrome.contentSettings[item].set)
		chrome.contentSettings[item].set({
			primaryPattern: '*://omgmobc.com/*',
			setting: 'allow',
			scope: 'regular',
		})
})
