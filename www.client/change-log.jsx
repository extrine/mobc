var ChangeLog = React.createClass({
	mixins: [React.addons.PureRenderMixin],
	//nada
	render: function() {
		var indented = { margin: '10px 20px' }
		return (
			<div>
				<h1>Change Log</h1>
				<div style={indented}>
					List of stuff that changes on site. We don't expect from you to agree to every change. We
					trying our best. You may need to refresh by pressing CTRL+F5 to see the changes, the index
					is cached for an hour so is very likely that you wont see changes till you get a fresh
					copy.
				</div>
				<hr />
				<DayLog
					data={{
						date: 'LEGEND',
						log: [
							'/d/default',
							'/a/added',
							'/e/edited',
							'/r/removed',
							'/i/improved-fixed',
							'/m/moderater',
						],
					}}
				/>

				<DayLog
					data={{
						date: '3020-1-22',
						log: ['/i/hello is me Bender from future'],
					}}
				/>
				{/*
					Start of logs
				*/}

				<DayLog
					data={{
						date: '2020-8-29',
						log: ['/a/Desktop Version is out of beta for windows.'],
					}}
				/>

				<DayLog
					data={{
						date: '2020-8-18',
						log: ['/a/An experimental Desktop Version is available.'],
					}}
				/>

				<DayLog
					data={{
						date: '2020-6-21',
						log: [
							'/i/fix lame guest cant see error messages like "user/email or password" incorrect.',
						],
					}}
				/>
				<DayLog
					data={{
						date: '2020-6-14',
						log: ['/a/add commands "pls jail|handcuff|cuff|cream|kick|boot username" to chat '],
					}}
				/>
				<DayLog
					data={{
						date: '2020-6-6',
						log: [
							'/i/fix compiler for some platforms',
							'/m/allow admins to toggle star, star should only be toggle when the user ask not when the admin decides.',
						],
					}}
				/>
				<DayLog
					data={{
						date: '2020-6-1',
						log: [
							'/i/fix background image is missbehaving',
							'/a/default colour for site is grey',
							'/m/removes disconnect button',
						],
					}}
				/>
				<DayLog
					data={{
						date: '2020-5-28',
						log: ['/i/fix too many boo boos on lobby', '/i/fix 3rd for 4th on the ranking page'],
					}}
				/>
				<DayLog
					data={{
						date: '2020-5-27',
						log: [
							'/i/fix mentions discord-markup for discord and mobc',
							'/a/special page for tournaments',
							'/a/added @dingle so you can mention referees on the dingle tournament',
							'/a/added commands on chat /pool /9ball /dingle /swapples to chat to discord for tournament purposes (one way[mobc to discord], if someone replies on discord you wont read unless you go discord to read)',
						],
					}}
				/>
				<DayLog
					data={{
						date: '2020-5-21',
						log: ['/i/fixed floating dingles on dingleni'],
					}}
				/>
				<DayLog
					data={{
						date: '2020-5-17',
						log: ['/i/do not scroll chat while holding shift key used to queue videos on youtube'],
					}}
				/>
				<DayLog
					data={{
						date: '2020-5-16',
						log: ['/i/balloonoboot works again!', '/i/improved youtube cache'],
					}}
				/>
				<DayLog
					data={{
						date: '2020-5-14',
						log: [
							'/i/fix discord emojis arent displayed',
							'/i/hide gliberish from discord',
							'/i/videos are posted more than once to the music and videos channel ',
						],
					}}
				/>
				<DayLog
					data={{
						date: '2020-5-10',
						log: [
							'/a/videos on youtube rooms can be queued by the host when they SHIFT click any video link. The queue is diplayed in place of the search results and the search results disapear after 40 seconds',
							'/a/videos on youtube rooms can be removed from the queued by the host when they CTRL+SHIFT click any video link',
							'/i/fixed sometimes the video results jumps to the top',
							'/i/fixed video title displays in a new line when the screen is somewhat small or zoomed in ',
							'/a/when someone plays a YT video, it shows in the "music" channel of discord',
							'/a/lobby messages are sent to "mobc-lobby" channel in discord',
							'/a/you can send a message to the discord "general" channel by typing "/discord message"',
							'/a/you can send a message to the discord "play with me" channel by typing "/invite"',
						],
					}}
				/>
				<DayLog
					data={{
						date: '2020-5-8',
						log: [
							'/i/improves layout of profiles on mobile',
							'/i/maybe fix some balloono timing issues',
							'/i/fix autosizing chat textbox jumps a lot on chrome dev',
							'/m/add button post as omgmobc.com to profiles',
							'/m/mods can read posts made by omgmobc.com on profiles',
							'/m/STAR status can be given but not taken unless you develop on the site',
						],
					}}
				/>
				<DayLog
					data={{
						date: '2020-4-30',
						log: [
							'/i/tweak youtube searches and related videos',
							'/i/fix some native emojis are displayed small',
						],
					}}
				/>
				<DayLog
					data={{
						date: '2020-4-29',
						log: ['/i/fix youtube runs out of quota', '/i/tweaks youtube caching and searching'],
					}}
				/>
				<DayLog
					data={{
						date: '2020-4-23',
						log: [
							'/i/remove noise supression and echo reduction to improve audio quality on recordings',
						],
					}}
				/>
				<DayLog
					data={{
						date: '2020-4-20',
						log: ['/a/we have a discord group =)'],
					}}
				/>
				<DayLog
					data={{
						date: '2020-4-13',
						log: ['/i/fix an error with arcade stats on balloono'],
					}}
				/>

				<DayLog
					data={{
						date: '2020-4-5',
						log: ['/a/adds upload to issues/tickets', '/i/tweaks usernames weight on chat'],
					}}
				/>
				<DayLog
					data={{
						date: '2020-2-23',
						log: ['/i/quacka can be paused, a bit glitchy but pauses'],
					}}
				/>
				<DayLog
					data={{
						date: '2020-2-15',
						log: [
							'/i/updated dinglepop maps removing some not so game friendly maps',
							'/i/updated dinglepop maps to put random maps every 4 matches instead of 2',
							'/i/ctrl no longer makes the chat scroll ',
							'/i/balloono auto rotates again ',
							'/i/balloono does not end that quick ',
							'/i/balloono cannot be spectated ',
							'/i/gallery can maybe be closed when clicking outside of the picture  ',
							'/i/chat no longer notify if the mention of your username does not have an @  ',
							'/i/you can turn off spectator  ',
							'/i/welcome messages should appear after lobby message ',
							'/i/notifications get closed automatically ',
							'/i/fix tags get populate with stuff ',
						],
					}}
				/>
				<DayLog
					data={{
						date: '2020-2-13',
						log: [
							'/a/updated balloono to stock',
							'/a/added medals to baloono ',
							'/i/we are aware that you cant kick balloons on balloono boot ',
							'/i/maybe fixed "cant use own table/decal/felt" on pool when your stuff is just blank ',
							'/i/balloono and pool centered on the screen',
							'/i/fix google complains',
							'/i/balloono runs at 60 fps',
							'/i/in balloono and balloonoboot if you are not in the room when starts you just get skipped from the players playing ',
							'/i/improved balloono and balloonoboot startup time as we dont need to wait for people to download',
							'/a/blockes singleplayer starts with random board',
						],
					}}
				/>
				<DayLog
					data={{
						date: '2020-2-12',
						log: ['/d/bbq day'],
					}}
				/>
				<DayLog
					data={{
						date: '2020-2-10',
						log: [
							'/i/pool game will skip your turn and let the next one play if you are in another tab when the game starts',
							'/i/autofocus of games on game start only happens to games that use the keyboard ( balloono, balloonoboot, cuacka, blockles, blocklesmulti, skypigs)',
							'/i/improved notifications for pool',
							'/i/improved emojis on issue tracker',
							'/a/pool and 9ball now has medals',
							'/a/pool and 9ball can be spectated',
							'/a/adedd blitz mode when you are playing alone in pool/9ball',
							'/i/leaving pool and 9ball middle game counts as a lose',
							'/i/pool and 9ball have correct stats ',
							'/i/pool and 9ball does not count matches that you play alone ',
							'/i/room title now crops if does not fit ',
							'/i/do not display profile views in blue unless is needed ',
							'/i/highlight with green the turn on the username labels ',
						],
					}}
				/>
				<DayLog
					data={{
						date: '2020-2-7',
						log: [
							'/i/scrolling to the bottom of the chat should resume auto-scrolling',
							'/i/the toolbar in the room wraps if does not fit in the screen',
							'/i/the search toolbar in homepage wraps if does not fit in the screen',
							'/i/fix rooms show in the sidebar as a row instead of as a column',
							'/i/issues textareas can be resized',
							'/i/listen to scroll was a bad idea because images push the scrollbar while these are loading',
						],
					}}
				/>
				<DayLog
					data={{
						date: '2020-2-6',
						log: [
							'/a/when a user is marked as star they dont need to refresh anymore',
							'/i/profile views textbox allows numbers if theres anything else with them',
							'/i/profile views now allow anything but it will show blue if you modify it',
							'/i/profiles take the full height',
							'/i/webcam videos do not longer autoplay on lobby ',
							'/a/chat allows multiple lines(shift+enter) ',
							'/i/fix scrolling outside the chat pauses chat scrolling ',
							'/i/fix medals on rankings and toolbars ',
							'/i/"delete all" is visible for you in the profile of others but the button still does not work ',
							'/a/"delete all" on profiles now works ',
							'/i/fix titles of youtube rooms sometimes are carried to the next video',
						],
					}}
				/>
				<DayLog
					data={{
						date: '2020-2-5',
						log: [
							'/i/Improved notification for when someone invites a new user to a group chat',
							'/e/Number inputs disallowed for the "Text for profile views" box in settings .',
							'/i/fix wall messages make sound on all tabs, it should make sound on the first tab only',
							'/i/bigger icons for social media links',
							'/i/removed browser notifications for lobby as it gets annoying',
							'/i/mysteriously game ending should in theory be fixed',
							'/i/improved issue filtering by adding negative keywords, like "profile -mobile" or just "-mobile" to hide entries with mobile in it',
							'/i/fix tags wasnt working when using more than one tag',
							'/i/play sound only if the username is find as a word not into a word. if your username has a space then it may be found in a word',
							'/a/highlight when you are tagged.',
							'/i/using the mouse to scroll will stop the chat from scrolling, to enable just click anywhere',
							'/a/first link of social media appears in the waiting screen',
							'/a/added medals to swapples ',
							'/i/improved medals by making these persistent on the room',
							'/m/fix issue tracker mark done confirm issue',
							'/i/clear issue tracker comment local storage after commenting',
							'/i/fix issue tracker category sort',
							'/i/fixed tab setState in render',
							'/m/small temp fix for undefined issue with ticket search after closing ticket',
							'/m/fix prettier config not working on vscode',
						],
					}}
				/>
				<DayLog
					data={{
						date: '2020-2-4',
						log: [
							'/i/improved mail subjects',
							'/a/show closed accounts like closed not banned',
							'/i/youtube titles default to empty',
							'/a/fix orientation of uploaded images automatically',
							'/a/notifications for wall messages when all tabs are not focused',
							'/a/notifications for chat messages when tab is not focused',
							'/i/improve file upload performance server side by avoiding unnecessary copies',
							'/i/improve file upload by not re-uploading stuff that has been uploaded already at some point',
							'/i/fix profile pic and cover uploads were behaving strange',
							'/i/fix cancelling an upload triggers a weird error',
							'/i/custom colours on chat are disable by default',
							'/i/closing an account or banning it no longer deletes the friend list',
							'/a/fine settings for notifications',
							'/a/a notification for when is your turn on pool and you are sleeping',
							'/a/Ability to hide the camera button from Settings > Site "hide camera button"',
							'/a/holding the click down will prevent the chat from scolling',
							'/a/pressing TAB key to switch the focus between the chat and game works again',
							'/a/starting game should focus game, ending game should focus chat',
							'/i/improves balloono by halving the network requests and function calls',
							'/i/balloono is no longer locked to 60 fps! ',
						],
					}}
				/>
				<DayLog
					data={{
						date: '2020-2-3',
						log: [
							'/i/fix Edge was crashing',
							'/i/added back polyfills just in case',
							'/i/fix some emojis on lobby are too small',
							'/i/redesigned "see also"',
							'/i/fix restarting games shows 100% downloaded but no game .ee. ',
							'/i/disconnect when the tab is closed ',
							'/i/autofocus when page load ',
							'/i/fix race condition on user login  ',
							'/a/we finally have backups of wall messages   ',
						],
					}}
				/>
				<DayLog
					data={{
						date: '2020-2-2',
						log: [
							'/i/fix some profile messages mount over others',
							'/i/organized some temporal files',
							'/i/better collection of client errors',
							'/i/fix random front end errors',
							'/i/removed some legacy system users',
							'/i/fix some funny audio issues when hovering the profile picture on profiles',
							'/i/do not welcome the user if already has a tab open',
							'/i/fix date is wrong for lobby messages',
							'/i/toggling PU does not require refreshing anymore',
							'/i/toggling bans does not disconnect the user unless is banned',
							'/i/fixed emojis display weird in the status of the friend list',
							'/i/eval replies back with the same command',
							'/i/improves colouring of the text messages on lobby',
							'/i/do not send indicators related to lame guests',
							'/i/emojis on the lobby are locked to the small ones',
							'/a/lock in youtube title',
							'/a/game download progress meter',
							'/a/title to the browser tabs',
							'/a/a waiting to play indicator in the waiting screen',
							'/a/ability to add custom text for views on profile',
							'/a/ability to add custom text for last seen on profile',
							'/a/ability to use personalized colours for emojis by enabling hue-rotate',
							'/a/the number of history messages on chat is customizable',
						],
					}}
				/>
				<DayLog
					data={{
						date: '2020-2-1',
						log: [
							'/a/add Social Media links to profiles',
							'/i/hide textbox on profiles when the user is banned',
							'/i/fix refreshing while in the settings page leads to lose of profile picture and cover',
							'/i/fix profile for friends only should show soapbox to friends',
							'/i/fix location replace wasnt working',
							'/i/fix setState craziness on profiles but something could be broken',
							'/a/when opening a profile consisting only of numbers it will redirect you to the profile with that #ID',
							'/i/fix inconsistency of lowercase/uppercase redirection on profiles ',
							'/a/highlight your username everywhere ',
							'/a/omgmobc.com can clear messages on lobby ',
							'/i/status on friend list can have emojis ',
							'/i/mobc/games messages vanishes before user messages',
							'/i/improve vanishing of messages',
							'/a/add list with the winner of the tournaments',
							'/a/add styled quotes everywhere',
							'/i/fixed refreshing on profiles does not work ',
							'/i/fixed refreshing on search does not work',
							'/i/fixed some mod logs appear empty',
						],
					}}
				/>
				<DayLog
					data={{
						date: '2020-1-31',
						log: [
							'/i/correct the location of the client log',
							'/i/replace location when redirecting issue tracker and renamed users (so you can hit go back)',
							'/i/fix trying to add a picture to the gallery ask for the file non stop',
							'/i/improved lyrics search',
							'/a/show when a user is banned on the profile',
							'/a/show when a user is a pu on a profile',
							'/i/improved search, added loading spinner',
							'/a/add hard reload button to the user toolbar',
							'/i/improve file and folder watcher(again)',
							'/m/fix mod disconnect not working',
							'/i/tweak the responsive textbox when the keyboard is open on mobile to take the full width',
							'/a/allow to save links in the profile to display a favicons',
							'/i/fixed capitalized usernames on profiles were not redirecting to their lower case version(in reverse it worked)',
							'/i/maybe the unread indicator behaves better',
							'/i/fix the recording indicator does not go away if the video/audio is too short',
							'/i/fix settings, color change wasnt loading when refreshing over the settings page itself',
							'/i/use merge union for the change log to avoid conflicts!',
							'/i/maybe fix gifv format wasnt working',
							'/i/when someone mention your name in chat and the tab is not focused and also you didnt mute then it will make a sound',
							'/i/when someone mention your @name in chat it will make a sound even if you are muted or unfocused',
							'/i/fix chat mention makes sounds when user is yourself, game or MOBC',
						],
					}}
				/>
				<DayLog
					data={{
						date: '2020-1-30',
						log: [
							'/i/test changes for using "full" mobile site in landscape orientation',
							'/i/use identical version for source maps and index',
							'/i/fix watching files/folders bug',
							'/i/log errors with source maps',
							'/i/resolve some weird react errors',
							'/i/allow mobc to have opponents and friends ',
							'/i/improve search',
							'/i/fix sometimes you cannot invite people to chat if they or you dont have friends',
							'/i/fix F1 broke again',
							'/i/fix sometimes the background of the profiles is carried to another pages/profiles',
							'/i/add an horizontal line for unread messages',
							'/i/fix settings not working when you refresh the page',
							'/i/fix autosize box does not scroll the chat',
							'/i/fix clicking the text on the game button of the homepage opens pool xD ',
							'/i/maybe fix fake clicks not working in firefox ',
							'/e/reverted landscape orientation changes due to css being a pile of junk',
							'/i/updated the height of the user list on the rooms as it moved when we corrected overflow of big usernames',
						],
					}}
				/>
				<DayLog
					data={{
						date: '2020-1-29',
						log: [
							'/i/when you play a video from chat any video bellow will play too after the current one ends',
							'/a/added record video, audio and upload images to profiles ',
							'/i/upload allows multiple files ',
							'/i/refactor recording and uploads ',
							'/i/video from web-cam has controls so maybe you can hear it ',
							'/i/fix audio/video recording indicator does not go away when you are done recording ',
							'/i/fix profile pictures are too blurry ',
							'/i/fix inconsistency on the sidebar tabs when on mobile ',
							'/i/the chat-boxes will grow as you type',
							'/i/when you reconnect via a phone/tablet it will join the same room',
							'/i/fix upload not working',
							'/i/fix chat-boxes that grow do not update the scroll',
							'/i/fix regression pacman broke',
							'/i/recoded issue tracker label system',
							'/i/tracker short issue comment count no longer includes actions',
							'/i/tracker subscription alerts now use > instead of quotes (for future quote feature)',
							'/i/fixed some react dev warnings related to select elements',
							"/i/maybe some other stuff that I can't remember now",
						],
					}}
				/>
				<DayLog
					data={{
						date: '2020-1-28',
						log: [
							'/a/added mark done button to ticket tracker',
							'/a/added like sorting to issue tracker',
							'/i/F1 key records audio on public rooms and on private chats',
							'/i/CTRL+F1 records video on public rooms and on private chats',
							'/i/Fixed recording audio and video on mobile while holding the buttons',
							'/a/added click to record video and click again to stop recording video',
							'/i/Fix input textbox for private chat wasnt growing',
							'/i/Set back cache of index to one hour',
							'/i/compiler pushes faster',
							'/m/mod disconnect is back',
							'/i/make log of server blocking more clear',
							'/a/add user profile reset',
							'/a/add user profile reset stats',
							'/a/add #ID (your user number) to user profiles',
							'/i/fix tonk when using single player only adds 1 opponent',
							'/i/when you play an audio from chat any audio bellow will play too after the current one ends',
						],
					}}
				/>
				<DayLog
					data={{
						date: '2020-1-27',
						log: [
							'/a/added legend to change log',
							'/a/added liking to issue tracker',
							'/a/added comment count to issue tracker short tickets',
							'/i/issue tracker search now includes comments',
							'/i/issue tracker short ticket last msg hidden if there are no comments',
							'/i/issue tracker data now compressed',
							'/e/issue tracker title char limit bumped to 200',
							'/e/issue tracker comment char limit bumped to 10,000',
							'/e/issue tracker title now shown in hover over title',
							'/i/gray and black themes now show scrollbar',
							'/e/show offline in friends list now defaulted to true',
						],
					}}
				/>
				<DayLog
					data={{
						date: '2020-1-25',
						log: [
							'/i/maybe fixed the automatic reconnection',
							'/i/sending emails to everyone',
							'/i/compiler tweaks, images auto optimized before uploading',
						],
					}}
				/>
				<DayLog
					data={{
						date: '2020-1-24',
						log: [
							'/i/when copying wall/chat messages the images gonna be copied too',
							'/i/fix login with username is case sensitive',
							'/i/removed error handlers from images as these are no longer needed',
							'/i/simplified some messages',
						],
					}}
				/>
				<DayLog
					data={{
						date: '2020-1-23',
						log: [
							'/i/maybe fixed typing indicator',
							'/a/now you can record video with the web-cam',
							'/a/add fullscreen button to youtube videos',
							'/i/improved layout of chat buttons',
							'/i/fix link to issue tracker from wall posts',
							'/i/maybe fix some compiler edge cases',
							'/i/do not restart web-server when no need',
							'/i/tweak image upload/download to be more efficient',
							'/i/unify supported file formats',
							'/a/prevent ugly people from sending videos',
							'/i/removed cron deleted no longer needed',
							'/i/do not welcome banned usernames ',
							'/i/do not show user typing/recording for banned users  ',
							'/i/status on friend list bumped to 30 chars, validated on server char length :P  ',
						],
					}}
				/>
				<DayLog
					data={{
						date: '2020-1-21',
						log: [
							'/i/fix large images in tracker pushing sidebar off screen',
							'/i/try to reconnect harder when we lose connection (server restart or just losing connection)',
							'/i/fix audio recording indicator not working',
							'/i/remove black background from "game loading"',
							'/i/upload temporal audios and images to a temp folder, these gonna be deleted after 7 days of the "last access"',
							'/i/improve displaying of stack traces ',
							'/i/fix typing indicator not going away in some situations ',
							'/i/limit mod search to 400 results  ',
							'/a/added status to friends list',
						],
					}}
				/>
				<DayLog
					data={{
						date: '2020-1-20',
						log: [
							'/i/searching no longer blocks the server',
							'/i/recording audio stops the tracks when you stop recording making the "record" icon on tabs to update properly',
							'/i/updated databases',
							'/i/track slow functions',
							'/i/a rename will update your friends list (they will see your new name on their friend list)',
							'/i/redirect issue tracker profile to issues page',
						],
					}}
				/>
				<DayLog
					data={{
						date: '2020-1-19',
						log: [
							'/i/CSS improvements to issue tracker.',
							'/i/add comment editing to issue tracker.',
							'/i/fix introduced selector issue with tracker.',
							'/i/lots of backend and compiler improvements.',
						],
					}}
				/>

				<DayLog
					data={{
						date: '2020-1-17',
						log: [
							'/i/improved notifications for when someone leaves or is removed from a group chat.',
							'/i/add automatic force reload of the page if the client does not connect after 10 seconds.',
							'/i/when an image fails to load do not cache it. this will prevent persistent NA that can be seen by other users',
							'/i/fixed caching for the complete site, games, images, audios, assets etc. Everything caches forever unless theres an error.',
						],
					}}
				/>
				<DayLog
					data={{
						date: '2020-1-16',
						log: ['/i/refactor compiler, add source maps, minify source', '/i/removed polyfills'],
					}}
				/>
				<DayLog
					data={{
						date: '2020-1-8',
						log: [
							'/i/lobby bans are now persistent between restarts',
							'/i/fixed broken tickets due to missing sub var',
						],
					}}
				/>
				<DayLog
					data={{
						date: '2020-1-7',
						log: ['/a/Implemented subscriptions to issue tracker'],
					}}
				/>
				<DayLog
					data={{
						date: '2020-1-3',
						log: [
							'/i/Fixed swapplesrank rooms so that they can no longer be switched to other games',
							'/i/Fix youtube search is broken',
						],
					}}
				/>
				<DayLog
					data={{
						date: '2020-1-1',
						log: [
							'/i/fix webm is not played as video on the chat',
							'/i/improve search results for lyrics on youtube rooms',
							'/i/improved display of lyrics on youtube videos',
							'/a/added ban to lobby chat',
							'/i/you can use jfif on gallery now',
							'/a/trying to add an overlay with the lyrics over the youtube videos',
						],
					}}
				/>
				<DayLog
					data={{
						date: '2019-12-28',
						log: [
							'/i/you can clear lobby messages but just for yourself',
							'/i/lobby messages wont load when you refresh in a room (well these will be hidden)',
							'/i/do not welcome duplicate users on lobby ',
						],
					}}
				/>
				<DayLog
					data={{
						date: '2019-12-25',
						log: [
							'/a/lobby chat is back',
							'/r/removed ability to clear messages from lobby chat',
							'/i/no colours for user messsages on lobby chat',
							'/i/fix only mods can /clear private messages',
							'/i/make looby messages persistent on server restart',
						],
					}}
				/>
				<DayLog
					data={{
						date: '2019-12-18',
						log: [
							'/i/links display decoded again',
							'/i/server maintenance should be done around 8am uk time',
						],
					}}
				/>
				<DayLog
					data={{
						date: '2019-12-17',
						log: [
							'/i/separate the settings "can write on wall" from "profile privacy"',
							'/i/improved daily maintenance',
							'/i/creator img fixed for users with mp4 avatars',
							'/i/fix chat scrolling when clicking',
							'/i/improved enable flash tutorial video',
						],
					}}
				/>
				<DayLog
					data={{
						date: '2019-12-16',
						log: [
							'/i/ranking data now updates every 7 days to reduce lag time in the daily maintenance',
							'/i/fix omgmobc.com cannot reply to messages on walls for friends only',
						],
					}}
				/>
				<DayLog
					data={{
						date: '2019-12-15',
						log: [
							'/i/tweaks to chat scrolling',
							'/i/once disconnected there should be no friends online on sidebar',
							'/i/improving pasting links on youtube search',
							'/i/allow to add issues without body',
							'/i/fix friends sorting on profiles',
							'/i/friends are sorted by date added even if they are renamed',
							'/i/fix delete all by button on profile messages',
							'/i/allow to hide arcade',
							'/i/fix browsing to a profile fast and blocking can end on blocking yourself',
							'/i/color all usernames on the room list even if they didnt donate',
							'/i/dont show on your profile as friend someone that didnt accepted you yet',
							'/i/tweak profile privacy',
							'/i/blocking a user shows a blank profile to them',
							'/i/fix hiding friend list does not hide it',
						],
					}}
				/>
				<DayLog
					data={{
						date: '2019-12-10',
						log: ['/a/added /clear back to chat'],
					}}
				/>
				<DayLog
					data={{
						date: '2019-12-9',
						log: ['/r/Removed /clear from chat'],
					}}
				/>
				<DayLog
					data={{
						date: '2019-12-8',
						log: ['/a/add delete all by.. on profiles'],
					}}
				/>
				<DayLog
					data={{
						date: '2019-12-6',
						log: ['/a/Status text can be up to 300 characters'],
					}}
				/>
				<DayLog
					data={{
						date: '2019-12-1',
						log: ['/a/Implemented issue tracker'],
					}}
				/>
				<DayLog
					data={{
						date: '2019-11-29',
						log: [
							'/i/Happy thanks giving, specially to fat rats.',
							'/i/Add support for webp images on gallery.',
							'/i/Maybe daily lag is improved by a lot... lets see :D .',
						],
					}}
				/>
				<DayLog
					data={{
						date: '2019-11-22',
						log: ['/i/Added recording audio indicator.'],
					}}
				/>
				<DayLog
					data={{
						date: '2019-11-21',
						log: [
							'/i/Fix some usernames are longer than excepted when these have emojis.',
							'/i/Fix cant change color on settings.',
							'/i/Remove scrolling when focusing chat.',
						],
					}}
				/>
				<DayLog
					data={{
						date: '2019-11-19',
						log: [
							'/i/Once disconnected the lobby list is cleared.',
							'/i/Users can login with username instead of email.',
						],
					}}
				/>
				<DayLog
					data={{
						date: '2019-11-1',
						log: ['/i/PM from friends list while in room no longer opens lobby tab.'],
					}}
				/>
				<DayLog
					data={{
						date: '2019-10-21',
						log: [
							'/i/Timeout of typing indicator is now 10 seconds instead of 3.',
							'/i/Typing indicator will be off if the content is blank (like in typing something then deleting everything).',
							'/i/Leaving a group required a click in a very specific place, now it should just work by clicking the "leave" icon.',
							'/i/Create new group has some margin so you dont create groups unintentionally.',
						],
					}}
				/>
				<DayLog
					data={{
						date: '2019-10-20',
						log: [
							'/i/Themed toggle switches.',
							'/i/Reworked red theme.',
							'/i/New footer images for missing themes.',
							'/i/Added button to upload images directly to the chat.',
							"/i/Switching browser's tabs will focus chat automatically.",
							'/i/TAB key will now also focus private chat.',
							'/i/Clicking anywhere will focus the chat.',
							'/i/Fix text selection breaks when trying too hard to focus the chat xd.',
						],
					}}
				/>
				<DayLog
					data={{
						date: '2019-10-16',
						log: [
							'/i/Forms added in needed areas.',
							'/i/Checkboxes replaced with toggle switches (still needs themeing).',
							'/i/Fixed small typo in asset file.',
						],
					}}
				/>
				<DayLog
					data={{
						date: '2019-10-9',
						log: [
							'/a/You can now upload images directly to the chat by holding CTRL and clicking somewhere in the chat.',
						],
					}}
				/>
				<DayLog
					data={{
						date: '2019-10-5',
						log: ['/i/Red messages on top have a max height now to avoid spam over the games.'],
					}}
				/>
				<DayLog
					data={{
						date: '2019-10-2',
						log: [
							'/r/Removed ability to rotate host in pool and 9ball while game is running.',
							'/m/Recoded tourney bracket, hopefully this helps maintainers. c:',
						],
					}}
				/>
				<DayLog
					data={{
						date: '2019-10-1',
						log: [
							'/a/Added an afk host rotation (/rotate) for mods, star users, and power users. Abusing this function will lead to losing your special status.',
						],
					}}
				/>
				<DayLog
					data={{
						date: '2019-9-29',
						log: ['/a/Implemented an Australian mode.'],
					}}
				/>
				<DayLog
					data={{
						date: '2019-9-28',
						log: [
							'/i/You can now type "/clear" on rooms and on private messages(which was already done btw). Also CTRL+ENTER will work the same way, but this time it will remove all the mssages for everyone not just for you(as used to do).',
							'/i/Changed layout of private messages. The idea is to make a bit clear who typed what by getting rid of the pictures.',
						],
					}}
				/>
				<DayLog
					data={{
						date: '2019-9-27',
						log: [
							'/i/Users can now customize the color of their chat messsages.',
							'/i/Users can prevent customization of the color of the chat messsages.',
							'/i/Power users and STAR can now send red messages to the room.',
						],
					}}
				/>
				<DayLog
					data={{
						date: '2019-9-20',
						log: [
							'/i/Blocking a user via their profile button "block user" now deletes their messages and updates your blocklist on settings.',
						],
					}}
				/>
				<DayLog
					data={{
						date: '2019-8-16',
						log: ['/i/Fixed rotate opponent button.'],
					}}
				/>
				<DayLog
					data={{
						date: '2019-7-23',
						log: [
							'/i/The change that cuased a swapples match to end when someone was AFk has been reverted as been causing problems on some edge cases.',
						],
					}}
				/>
				<DayLog
					data={{
						date: '2019-7-15',
						log: ['/i/Improved server speed.'],
					}}
				/>

				<DayLog
					data={{
						date: '2019-7-10',
						log: [
							'/i/In swapples when the game is over and someone still has score of 0 the match should stop anyways.',
						],
					}}
				/>
				<DayLog
					data={{
						date: '2019-7-2',
						log: ['/i/Added classic swapples which means that "fast" setting will be ignored.'],
					}}
				/>
				<DayLog
					data={{
						date: '2019-6-10',
						log: ['/i/Improved local development'],
					}}
				/>
				<DayLog
					data={{
						date: '2019-5-30',
						log: [
							'/i/Now you can mute cuacka game. You must restart the game if you mute middle game.',
						],
					}}
				/>
				<DayLog
					data={{
						date: '2019-5-14',
						log: [
							"/i/You can now appear as offline by clicking 'Show Me As Offline/Online' from the friend list. Which will hide you from your friends online list.",
						],
					}}
				/>
				<DayLog
					data={{
						date: '2019-5-8',
						log: [
							"/i/Blocking user feature been improved to not include in the block list people that isn't explicitly blocked and in your friend list. In other words: If you have been blocked in cascade because of a block applied to someone else, you will not blocked if you are in their friend list.",
						],
					}}
				/>
				<DayLog
					data={{
						date: '2019-2-22',
						log: ['/i/Fixed more random errors.'],
					}}
				/>
				<DayLog
					data={{
						date: '2019-2-19',
						log: [
							'/i/removed the 3 consecutive foul auto loss rule from 9-ball (since nobody was being credited with the win when this happened).',
						],
					}}
				/>
				<DayLog
					data={{
						date: '2019-2-18',
						log: [
							'/i/fixed a lot of miscellaneous not so important errors.',
							'/i/on mobile it does not autofocus the textbox when opening a profile',
							'/i/minor style tweaks',
						],
					}}
				/>
				<DayLog
					data={{
						date: '2019-2-14',
						log: [
							'/i/private matches now record the stats, we should hide arcade from profiles instead of not recording games.',
							'/i/random maps added for dinglepop with items, maps removed from dinglepop without items',
							'/i/host/creators/power users can change game type',
							'/i/balloono runs always on 60fps',
						],
					}}
				/>
				<DayLog
					data={{
						date: '2019-2-12',
						log: [
							'/a/added ability to kick bombs in balloono (albeit a bit buggy)',
							'/r/reverted ballono back =)',
							'/a/added balloono version as "balloono boot"',
						],
					}}
				/>
				<DayLog
					data={{
						date: '2019-2-11',
						log: [
							'/i/Order of sidebar tabs changed.',
							'/i/Improvements in tab code.',
							'/i/Friend count color changed to black when selected.',
						],
					}}
				/>
				<DayLog
					data={{
						date: '2019-2-10',
						log: [
							'/i/Alternative color for chat was assigned at random, now thats not the case. You can just change it on settings.',
						],
					}}
				/>
				<DayLog
					data={{
						date: '2019-2-9',
						log: ['/i/People can use a gradient in the chat username.'],
					}}
				/>
				<DayLog
					data={{
						date: '2019-2-5',
						log: [
							'/i/Edited style of friend PM button in sidebar.',
							'/i/Sidebar tab location and show/hide offline now saved to local storage.',
							'/i/Room tab now hidden outside of room.',
							'/i/Order of tabs changed.',
						],
					}}
				/>
				<DayLog
					data={{
						date: '2019-2-4',
						log: [
							'/i/renaming a username keeps the list of friends.',
							'/i/assigned everyone a chat color in case they dont have one.',
							'/i/username on chat now accepts a an underline/alternative(we figuring out the best way to show this) color for distinguishing users that use similar colors.',
							'/m/add confirmation for some actions.',
							'/m/dont log some unnecessary mod stuff.',
							'/i/removed some useless messages.',
							'/i/when password is incorrect tell them to use the forget password before disconnecting them.',
							'/i/can post to self when wall is for friends only.',
							'/i/improved auto-refresh in local development.',
							'/i/if an image is used in the admin messages be sure the image is somewhat small.',
							'/i/reduce time an admin message is shown to 20 seconds.',
							'/i/colors in settings wrap, color picker is displayed on top.',
						],
					}}
				/>
				<DayLog
					data={{
						date: '2019-2-3',
						log: ['/i/raised group limits to 20 per user and 40 messages per group.'],
					}}
				/>
				<DayLog
					data={{
						date: '2019-2-2',
						log: [
							"/i/Private chat now displays [ BLOCKED ] for users you've blocked.",
							'/i/Online indicator for blocked users is now gray.',
							'/i/Friends tab in sidebar now displays online friend count.',
							"/i/Updated friend notifications. You may notice they're not in real time. This is to prevent notifying when someone quickly checks site, or refreshes.",
							'/i/Overflow added for rooms toolbar.',
							'/i/Fixed position of friends inner tab in user settings.',
						],
					}}
				/>
				<DayLog
					data={{
						date: '2019-2-1',
						log: [
							'/a/Added friend requests.',
							'/i/Closing account now removes friend(s) and pending requests from all parties.',
							'/r/Removed friends updated notification to prevent misclicks.',
							'/i/when clicking a room from the sidebar it will open in new tab.',
							'/i/fixed some images trigger a fancy download.',
							'/i/fixed # gets converted to emoji in chat.',
							'/i/proxy everything that isnt omgmobc.com.',
							'/i/can open in new tab external videos/images etc.',
							'/i/fix emojies are displayed as link.',
							'/i/links to rooms in chat open in new tab while pages and user profiles open on same tab.',
							'/i/fix weird padding on right for some profiles.',
							'/i/fix alignment of username on profile.',
							'/i/fix chrome extension still saying has read access to site.',
							'/i/improves padding and margins on room user list.',
							'/i/opening new private message from friend list will use any existent created group.',
							'/i/star button is only hidden in mobile when typing.',
							'/i/removed confirmation for new private messages but separated the items more.',
							'/i/friend code updated to prevent issues with non existant friends/followers.',
							'/i/daily update no longer resets banned users, fixing an issue with long timeouts.',
						],
					}}
				/>
				<DayLog
					data={{
						date: '2019-1-31',
						log: [
							'/a/Added typing indicator for private chat.',
							'/i/new badge for omgmobc.com and related issues with this account displaying in public.',
							'/i/add video about how to enable flash on this site for chrome.',
							'/i/less intruding detection of flash.',
							'/i/edited chrome extension to remove the "read data on site omgmobc.com" a is no longer needed because of the better detection of flash. you may want to go to extensions and then "update extensions"',
							'/i/when in mobile dont show the "flash not enabled".',
							'/i/when in mobile hide the "become STAR" when the textbox has focus',
							'/i/when in mobile after 5 private groups a scrollbar is shown',
							'/i/when in desktop after 9 private groups a scrollbar is shown',
							'/i/when in lazy mode dont do anything',
							'/i/when something is broken, report, forget, relax and enjoy',
							'/i/when in doubt, I agree',
						],
					}}
				/>
				<DayLog
					data={{
						date: '2019-1-30',
						log: ['/i/Improved indicator code.'],
					}}
				/>
				<DayLog
					data={{
						date: '2019-1-29',
						log: ['/a/Added typing indicator for room chat.'],
					}}
				/>
				<DayLog
					data={{
						date: '2019-1-28',
						log: ['/i/restart and refresh much faster in the development environment.'],
					}}
				/>
				<DayLog
					data={{
						date: '2019-1-27',
						log: [
							'/a/mobile users now display an icon in friend list.',
							'/a/color options in settings set to display in lines of 4 max. so that all the color pickers should display properly even on smaller screen sizes.',
							'/r/removed friend login message in favour of flashing friend tab.',
							'/i/fixed chat scrolling when lobby updates.',
						],
					}}
				/>
				<DayLog
					data={{
						date: '2019-1-26',
						log: [
							'/a/lobby rooms now display on phones.',
							'/i/list of users in rooms now display in line to consume less space.',
							'/i/better display for color in settings.',
							'/i/fix scroll for room and private chats when changing tabs.',
						],
					}}
				/>
				<DayLog
					data={{
						date: '2019-1-24',
						log: [
							'/r/removed delete option friend from sidebar friend list.',
							'/a/added markup (*bold* /italics/ _underline_ -strike-) for single words.',
							'/a/added full message underline and strike. Beginning with _ and - respectively.',
							'/a/added calculator to chat. (See chat help for more details on markup changes)',
						],
					}}
				/>
				<DayLog
					data={{
						date: '2019-1-23',
						log: [
							'/i/fixed soapbox not updating properly.',
							'/i/minor improvements on profile friend list styling.',
							'/i/do not focus chat when people use mobile (as that gonna open their keyboard!!!).',
						],
					}}
				/>
				<DayLog
					data={{
						date: '2019-1-22',
						log: [
							'/i/improved hovering over picture in waiting screen.',
							'/i/force alpha on waiting screen when color has no alpha.',
							'/i/renamed "is connected" to "is online".',
							'/i/maybe site wide messages display over videos.',
							'/m/fixed bug with iso_code in stacks',
							'/m/when kicking someone fails, disconnect user automatically',
						],
					}}
				/>
				<DayLog
					data={{
						date: '2019-1-19',
						log: ['/i/added color picker for color customization in settings.'],
					}}
				/>
				<DayLog
					data={{
						date: '2019-1-18',
						log: [
							'/i/color tint for background of the waiting screen now accepts a third color.',
							'/m/updated geo location',
							'/m/log of stuff was overly verbose.',
							'/m/improved users online display.',
						],
					}}
				/>
				<DayLog
					data={{
						date: '2019-1-17',
						log: [
							'/i/fixed star users cannot join private matches.',
							'/i/color tint for background of the waiting screen consistent with other colors.',
							'/m/fixed losing wall messages written to and from omgmobc.com.',
							'/m/improved output of trace.',
							'/m/do not log web server errors as is spamming the log with useless stuff.',
							'/m/removed some specific useless stack logs.',
							'/i/fixed padding top and padding bottom on waiting screen when theres 1, 2 or 3 players.',
							'/i/improved the way lobby is sent to users.',
							'/i/improved the way group chat is sent to users.',
							'/i/improved the way groups chats are sent to users.',
							'/i/improved the way ranking is sent to users.',
						],
					}}
				/>
				<DayLog
					data={{
						date: '2019-1-16',
						log: [
							'/i/adjustable tint for waiting picture added in the settings.',
							'/a/Rule 14 added: Players cannot modify the rules of the games unless the room is private. Exception: bank 8 in pool could be agreed while the room is public. If you want to play with your own rules make the match private. Because if the game stays open and people comes to play they will expect the game to behave normally, if you kick them then you letting someone in to then kick, not cool.',
							'/i/to make a room private everyone in the room should be star.',
							'/i/people can only join a private room if they are star.',
							'/m/anyone can join a private room created by an admin.',
							'/i/Post wall by omgmobc.com can be deleted only by admins.',
							'/i/omgmobc.com can now post in walls even if they arent friends.',
							'/m/admin messages gets deleted after 3 days.',
							'/m/an admin that isnt omgmobc.com can be blocked by a user.',
						],
					}}
				/>
				<DayLog
					data={{
						date: '2019-1-14',
						log: ['/i/In tonk computer will not play if theres at least 2 players.'],
					}}
				/>
				<DayLog
					data={{
						date: '2019-1-12',
						log: [
							'/i/Improved the way wall messages are stored.',
							'/i/Renaming a username now keeps wall messages on all profiles.',
							'/i/Closing an account deletes messages on all profiles.',
							'/i/Improved profile loading time.',
							'/i/Deleted all unreachable messages. Prevent also for messages to become unreachable',
							'/a/Added ping time to the waiting screen. Ping time tells you how many milliseconds takes for your commands to reach the server. It is the latency not the connection speed. If you own a Ferrari but you need to drive 100 blocks to reach server and I own a bicycle but Im just half a block from the server, then with my bicycle Im gonna reach server faster than you with your Ferrari, thats latency. Usually when your connection is faster the latency is low, but if your connection is busy (by downloading or uploading stuff) then the latency gonna be high.',
						],
					}}
				/>
				<DayLog
					data={{
						date: '2019-1-11',
						log: [
							'/i/Fixed a couple of incorrect game icons in the friends list (previously the icon for blocklesmulti was the same as the one for the other blockles and same thing with Dingle NI, both these icons have been fixed).',
							'/a/New background image designed for Tonk.',
						],
					}}
				/>
				<DayLog
					data={{
						date: '2019-1-10',
						log: [
							'/i/Tab for room chat will skip notifications for MOBC and game messages.',
							'/a/Added ability to make walls writeable by "friends only". If you don\'t add someone that person cannot write to you a wall message.',
							'/a/Added ability to clear a private group chat by typing "/clear".',
							'/i/Closing an account deletes the friend list.',
							'/e/Removed double separator between links on profiles.',
							'/i/Fixed error when private group chat is blank(thing that in theory does not happen).',
							'/a/Tell people when server will "lag" for about 30 seconds or so due to maintenance.',
							'/e/Better log of server "lag/blocks".',
							'/e/Moved privacy tab to the left in settings.',
							'/i/One of every 2 rounds in dingle is a random generated map.',
							'/i/Updated the random map generator to create symmetric maps.',
						],
					}}
				/>
				<DayLog
					data={{
						date: '2019-1-9',
						log: [
							'/i/Colorized STAR users names in the player map (list of players in the top right corner of the screen in a room) .',
						],
					}}
				/>
				<DayLog
					data={{
						date: '2019-1-7',
						log: ['/i/Added option to customize color for stats/status (in room) .'],
					}}
				/>
				<DayLog
					data={{
						date: '2019-1-6',
						log: ['/i/Minor improvements to front end.'],
					}}
				/>
				<DayLog
					data={{
						date: '2019-1-5',
						log: [
							'/m/Added clear output for profile mod tools.',
							'/m/Fixed location of profile mod tools display.',
							'/a/Added colors to, and organized logs.',
							'/a/Added lobby tab to sidebar.',
							'/i/A user discovered that when you "kick yourself" in a room you become invisible to the room. The user didnt report it to admins! =/ His power user been removed and the issue of becoming invisible been fixed. Thanks to the anonymous reporter ♥',
							'/e/Profile of friend now shows when you added them.',
							'/e/Styling of tabs changed.',
						],
					}}
				/>
				<DayLog
					data={{
						date: '2018-12-23',
						log: [
							'/a/Added notification for private chat upon logging.',
							'/a/Added a menu to pm, open profile, and remove friend when you click them in the sidebar friend list.',
							'/i/Fixed issue of sidebar menu not opening for usernames containing certain characters.',
							'/e/Minor changes to server.',
						],
					}}
				/>
				<DayLog
					data={{
						date: '2018-12-20',
						log: ['/a/Added Notifications for room and private chat tabs.'],
					}}
				/>
				<DayLog
					data={{
						date: '2018-12-19',
						log: [
							'/a/Added blocking/unblocking to profile.',
							'/a/Added list of blocked users to privacy settings.',
							'/i/Improved performance of the site a bit.',
							'/i/Fixed incorrect game icon in friends list after switching games.',
							'/i/Fixed theme not applying.',
							'/e/Privacy settings moved to own tab.',
							'/e/Chat messages from a blocked user now display [ Blocked ].',
							'/r/Removed ability to friend someone that blocked you.',
						],
					}}
				/>
				<DayLog
					data={{
						date: '2018-12-17',
						log: [
							'/a/Added user colors to the friend list in sidebar.',
							"/i/Updated yesterday's log to be more verbose.",
							'/i/Optimized friend code in the backend.',
							'/i/Fixed wrong username color being displayed in friends and opponents tabs in profile.',
							'/e/Offline friends are now grayed out.',
							'/e/Online status indicator changed from green to lime to stand out more against the red for offline.',
							'/e/Moved theme selector to site settings.',
						],
					}}
				/>
				<DayLog
					data={{
						date: '2018-12-16',
						log: [
							'/a/Added friends.',
							"/i/Friend list in sidebar contains online and offline friends. This will serve as an easy way to see who's online, access profiles, and join games.",
							'/i/Friend list in user profiles will also contain your friends for all to see. Also acts as an easy way to access profiles. (Can be hidden in settings)',
							'/i/Anyone can add anyone (except themselves).',
							'/i/Online status will only be shown to friends that friend you back.',
							'/i/Connected alerts will also only be shown to friends that friend you back.',
							'/i/Organized profile and sidebar.',
							'/e/Opponents and arcade rankings moved to their own tabs in profile.',
							'/e/Private chat moved to sidebar.',
						],
					}}
				/>
				<DayLog
					data={{
						date: '2018-12-10',
						log: ['/i/Fixed typo that caused user data to be rolled back on server restart.'],
					}}
				/>
				<DayLog
					data={{
						date: '2018-12-08',
						log: ['/i/Fix an issue related to local development.'],
					}}
				/>
				<DayLog
					data={{
						date: '2018-12-03',
						log: ['/i/Improved the way user data is stored.'],
					}}
				/>
				<DayLog
					data={{
						date: '2018-11-29',
						log: ['/i/Improved relative time.', '/i/Fixed some images on chat not loading at all.'],
					}}
				/>
				<DayLog
					data={{
						date: '2018-11-28',
						log: [
							'/e/reduce size of polyfill based on user agent.',
							'/r/removed rasta gradient it just does not look good.',
						],
					}}
				/>
				<DayLog
					data={{
						date: '2018-11-26',
						log: [
							'/a/Added rasta gradient to reggae rooms on main lobby.',
							'/a/Added red theme.',
							'/i/fixed weird alignment of theme selector.',
							'/i/Corrected some typos on this page =p.',
							'/r/Removed all kind of notifications because these do not work reliable.',
						],
					}}
				/>
				<DayLog
					data={{
						date: '2018-11-25',
						log: [
							'/e/All badges on home screen align the same even if they have different size.',
							'/e/Put contact and emoji links in rooms.',
						],
					}}
				/>
				<DayLog
					data={{
						date: '2018-11-24',
						log: [
							'/a/Added this change log :)',
							'/a/Added pink theme',
							'/a/Added back preload for images in profiles galleries but only preloads when clicking a picture. Preloads next two picture from gallery.',
							'/i/Improved text overflow in Firefox for private chats by not cutting words at random places',
							'/i/Improved size of private chat for small screens',
							'/i/Fixed kicking a user from your same ip kicks yourself.',
							'/i/Fixed: when someone leaves a private chat their image is no longer displayed',
							'/i/Corrected alignment of the pin button on private chats that moved when the scrollbars changed size',
							'/e/Non star users can create private chat and invite others to chat.',
							"/e/Non star users can invite others to chat in groups they didn't create.",
							'/e/"/list" command only broadcast to self to prevent spamming of the private chat group.',
							'/r/Removed couple of buttons from room toolbar to make room for match name and private button.',
						],
					}}
				/>
				<DayLog
					data={{
						date: 'Past days',
						log: [
							'/a/Creators of private chats can remove people from the group by typing "/remove usernamehere" in a similar way people could be invited to chat by typing "/add usernamehere"',
							'/a/Added ability to rename a username',
							'/i/Improved compatibility with older browsers',
							"/e/The creator of a room cannot be kicked anymore and can kick everyone in room. The logic is that people shouldn't be forced to play with people they just don't want to play.",
							'/r/The lobby has been removed because is just too complicated to maintain and while theres good moments theres also bad moments that affect people.',
							'/r/Removed difference between power user special and power users. Now everyone is a power user special.',
						],
					}}
				/>
				<DayLog
					data={{
						date: 'Before Past days',
						log: [
							'/m/♥♥♥',
							'/a/A massive amount of volunteer work done with dedication by numerous people (development, designs, mechanics, texts, moderation, support). Thanks to all ♥',
						],
						nohr: true,
					}}
				/>

				<SeeAlso />
			</div>
		)
	},
})

var DayLog = React.createClass({
	mixins: [React.addons.PureRenderMixin],

	render: function() {
		/*
			Tags:
				/d/efault
				/a/dded
				/e/dited
				/r/emoved
				/i/mproved-fixed
				/m/oderater

			Order:
				m, a, i, e, r

			Example:
				'/m/You're a mod, Harry!'
				'/a/Added self-destruct'
				'/i/Fixed brain'
			*/
		return (
			<div>
				{this.props.data.date ? <h3>{this.props.data.date}</h3> : null}
				<ul>
					{this.sort(this.props.data.log).map((log, i) => {
						if (this.getTag(log) === 'm' && !window.user.mod) return null
						else {
							var color = this.getColor(log)
							return (
								<li style={{ color: color }} key={i}>
									<span style={{ color: 'white' }}>{this.casing(this.removeTag(log))}</span>
								</li>
							)
						}
					})}
				</ul>
				{this.props.data.nohr ? null : <hr />}
			</div>
		)
	},
	hasTag: function(s) {
		return s.charAt(0) == '/' && s.charAt(2) == '/'
	},
	getTag: function(s) {
		return this.hasTag(s) ? s.charAt(1) : 'd'
	},
	removeTag: function(s) {
		return this.hasTag(s) ? s.slice(3, s.length) : s
	},
	getColor: function(s) {
		var c = { d: 'white', a: 'lime', e: 'goldenrod', r: 'red', i: 'lightblue', m: 'violet' }
		return c[this.getTag(s)]
	},
	casing: function(s) {
		return s.charAt(0).toUpperCase() + s.slice(1)
	},
	sort: function(arr) {
		var o = {
			m: 0,
			a: 1,
			i: 2,
			e: 3,
			r: 4,
		}
		return arr.sort((a, b) => {
			var c = this.getTag(a),
				d = this.getTag(b)
			return o[c] === o[d] ? 0 : o[c] < o[d] ? -1 : 1
		})
	},
})
