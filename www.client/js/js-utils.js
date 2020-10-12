$(document).ready(function() {
	body = $('body')
})
$(document).on('load', function() {
	body = $('body')
})
requestAnimationFrame(function() {
	body = $('body')
})

document.addEventListener('DOMContentLoaded', function(event) {
	body = $('body')
})
var Utils = function() {
	this.escape_replace = this.escape_replace.bind(this)
	this.entityMap = {
		'&': '&amp;',
		'<': '&lt;',
		'>': '&gt;',
		'"': '&quot;',
		"'": '&#39;',
		'\\': '&#x5C;',
	}
	this.entityMap = this.toArrayIndex(this.entityMap)
	this.escapeHTMLRegexp = /[&<>"'\\]/g

	this.linky_separator = /(\s+)/

	this.isRTLRegExp = /[\u0590-\u083F]|[\u08A0-\u08FF]|[\uFB1D-\uFDFF]|[\uFE70-\uFEFF]/gm
	this.emoji_regexp = /(\uD83C\uDFF4(?:\uDB40\uDC67\uDB40\uDC62(?:\uDB40\uDC65\uDB40\uDC6E\uDB40\uDC67|\uDB40\uDC77\uDB40\uDC6C\uDB40\uDC73|\uDB40\uDC73\uDB40\uDC63\uDB40\uDC74)\uDB40\uDC7F|\u200D\u2620\uFE0F)|\uD83D\uDC69\u200D\uD83D\uDC69\u200D(?:\uD83D\uDC66\u200D\uD83D\uDC66|\uD83D\uDC67\u200D(?:\uD83D[\uDC66\uDC67]))|\uD83D\uDC68(?:\u200D(?:\u2764\uFE0F\u200D(?:\uD83D\uDC8B\u200D)?\uD83D\uDC68|(?:\uD83D[\uDC68\uDC69])\u200D(?:\uD83D\uDC66\u200D\uD83D\uDC66|\uD83D\uDC67\u200D(?:\uD83D[\uDC66\uDC67]))|\uD83D\uDC66\u200D\uD83D\uDC66|\uD83D\uDC67\u200D(?:\uD83D[\uDC66\uDC67])|\uD83C[\uDF3E\uDF73\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDB0-\uDDB3])|(?:\uD83C[\uDFFB-\uDFFF])\u200D(?:\uD83C[\uDF3E\uDF73\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDB0-\uDDB3]))|\uD83D\uDC69\u200D(?:\u2764\uFE0F\u200D(?:\uD83D\uDC8B\u200D(?:\uD83D[\uDC68\uDC69])|\uD83D[\uDC68\uDC69])|\uD83C[\uDF3E\uDF73\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDB0-\uDDB3])|\uD83D\uDC69\u200D\uD83D\uDC66\u200D\uD83D\uDC66|(?:\uD83D\uDC41\uFE0F\u200D\uD83D\uDDE8|\uD83D\uDC69(?:\uD83C[\uDFFB-\uDFFF])\u200D[\u2695\u2696\u2708]|\uD83D\uDC68(?:(?:\uD83C[\uDFFB-\uDFFF])\u200D[\u2695\u2696\u2708]|\u200D[\u2695\u2696\u2708])|(?:(?:\u26F9|\uD83C[\uDFCB\uDFCC]|\uD83D\uDD75)\uFE0F|\uD83D\uDC6F|\uD83E[\uDD3C\uDDDE\uDDDF])\u200D[\u2640\u2642]|(?:\u26F9|\uD83C[\uDFCB\uDFCC]|\uD83D\uDD75)(?:\uD83C[\uDFFB-\uDFFF])\u200D[\u2640\u2642]|(?:\uD83C[\uDFC3\uDFC4\uDFCA]|\uD83D[\uDC6E\uDC71\uDC73\uDC77\uDC81\uDC82\uDC86\uDC87\uDE45-\uDE47\uDE4B\uDE4D\uDE4E\uDEA3\uDEB4-\uDEB6]|\uD83E[\uDD26\uDD37-\uDD39\uDD3D\uDD3E\uDDB8\uDDB9\uDDD6-\uDDDD])(?:(?:\uD83C[\uDFFB-\uDFFF])\u200D[\u2640\u2642]|\u200D[\u2640\u2642])|\uD83D\uDC69\u200D[\u2695\u2696\u2708])\uFE0F|\uD83D\uDC69\u200D\uD83D\uDC67\u200D(?:\uD83D[\uDC66\uDC67])|\uD83D\uDC69\u200D\uD83D\uDC69\u200D(?:\uD83D[\uDC66\uDC67])|\uD83D\uDC68(?:\u200D(?:(?:\uD83D[\uDC68\uDC69])\u200D(?:\uD83D[\uDC66\uDC67])|\uD83D[\uDC66\uDC67])|\uD83C[\uDFFB-\uDFFF])|\uD83C\uDFF3\uFE0F\u200D\uD83C\uDF08|\uD83D\uDC69\u200D\uD83D\uDC67|\uD83D\uDC69(?:\uD83C[\uDFFB-\uDFFF])\u200D(?:\uD83C[\uDF3E\uDF73\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDB0-\uDDB3])|\uD83D\uDC69\u200D\uD83D\uDC66|\uD83C\uDDF6\uD83C\uDDE6|\uD83C\uDDFD\uD83C\uDDF0|\uD83C\uDDF4\uD83C\uDDF2|\uD83D\uDC69(?:\uD83C[\uDFFB-\uDFFF])|\uD83C\uDDED(?:\uD83C[\uDDF0\uDDF2\uDDF3\uDDF7\uDDF9\uDDFA])|\uD83C\uDDEC(?:\uD83C[\uDDE6\uDDE7\uDDE9-\uDDEE\uDDF1-\uDDF3\uDDF5-\uDDFA\uDDFC\uDDFE])|\uD83C\uDDEA(?:\uD83C[\uDDE6\uDDE8\uDDEA\uDDEC\uDDED\uDDF7-\uDDFA])|\uD83C\uDDE8(?:\uD83C[\uDDE6\uDDE8\uDDE9\uDDEB-\uDDEE\uDDF0-\uDDF5\uDDF7\uDDFA-\uDDFF])|\uD83C\uDDF2(?:\uD83C[\uDDE6\uDDE8-\uDDED\uDDF0-\uDDFF])|\uD83C\uDDF3(?:\uD83C[\uDDE6\uDDE8\uDDEA-\uDDEC\uDDEE\uDDF1\uDDF4\uDDF5\uDDF7\uDDFA\uDDFF])|\uD83C\uDDFC(?:\uD83C[\uDDEB\uDDF8])|\uD83C\uDDFA(?:\uD83C[\uDDE6\uDDEC\uDDF2\uDDF3\uDDF8\uDDFE\uDDFF])|\uD83C\uDDF0(?:\uD83C[\uDDEA\uDDEC-\uDDEE\uDDF2\uDDF3\uDDF5\uDDF7\uDDFC\uDDFE\uDDFF])|\uD83C\uDDEF(?:\uD83C[\uDDEA\uDDF2\uDDF4\uDDF5])|\uD83C\uDDF8(?:\uD83C[\uDDE6-\uDDEA\uDDEC-\uDDF4\uDDF7-\uDDF9\uDDFB\uDDFD-\uDDFF])|\uD83C\uDDEE(?:\uD83C[\uDDE8-\uDDEA\uDDF1-\uDDF4\uDDF6-\uDDF9])|\uD83C\uDDFF(?:\uD83C[\uDDE6\uDDF2\uDDFC])|\uD83C\uDDEB(?:\uD83C[\uDDEE-\uDDF0\uDDF2\uDDF4\uDDF7])|\uD83C\uDDF5(?:\uD83C[\uDDE6\uDDEA-\uDDED\uDDF0-\uDDF3\uDDF7-\uDDF9\uDDFC\uDDFE])|\uD83C\uDDE9(?:\uD83C[\uDDEA\uDDEC\uDDEF\uDDF0\uDDF2\uDDF4\uDDFF])|\uD83C\uDDF9(?:\uD83C[\uDDE6\uDDE8\uDDE9\uDDEB-\uDDED\uDDEF-\uDDF4\uDDF7\uDDF9\uDDFB\uDDFC\uDDFF])|\uD83C\uDDE7(?:\uD83C[\uDDE6\uDDE7\uDDE9-\uDDEF\uDDF1-\uDDF4\uDDF6-\uDDF9\uDDFB\uDDFC\uDDFE\uDDFF])|[#\*0-9]\uFE0F\u20E3|\uD83C\uDDF1(?:\uD83C[\uDDE6-\uDDE8\uDDEE\uDDF0\uDDF7-\uDDFB\uDDFE])|\uD83C\uDDE6(?:\uD83C[\uDDE8-\uDDEC\uDDEE\uDDF1\uDDF2\uDDF4\uDDF6-\uDDFA\uDDFC\uDDFD\uDDFF])|\uD83C\uDDF7(?:\uD83C[\uDDEA\uDDF4\uDDF8\uDDFA\uDDFC])|\uD83C\uDDFB(?:\uD83C[\uDDE6\uDDE8\uDDEA\uDDEC\uDDEE\uDDF3\uDDFA])|\uD83C\uDDFE(?:\uD83C[\uDDEA\uDDF9])|(?:\uD83C[\uDFC3\uDFC4\uDFCA]|\uD83D[\uDC6E\uDC71\uDC73\uDC77\uDC81\uDC82\uDC86\uDC87\uDE45-\uDE47\uDE4B\uDE4D\uDE4E\uDEA3\uDEB4-\uDEB6]|\uD83E[\uDD26\uDD37-\uDD39\uDD3D\uDD3E\uDDB8\uDDB9\uDDD6-\uDDDD])(?:\uD83C[\uDFFB-\uDFFF])|(?:\u26F9|\uD83C[\uDFCB\uDFCC]|\uD83D\uDD75)(?:\uD83C[\uDFFB-\uDFFF])|(?:[\u261D\u270A-\u270D]|\uD83C[\uDF85\uDFC2\uDFC7]|\uD83D[\uDC42\uDC43\uDC46-\uDC50\uDC66\uDC67\uDC70\uDC72\uDC74-\uDC76\uDC78\uDC7C\uDC83\uDC85\uDCAA\uDD74\uDD7A\uDD90\uDD95\uDD96\uDE4C\uDE4F\uDEC0\uDECC]|\uD83E[\uDD18-\uDD1C\uDD1E\uDD1F\uDD30-\uDD36\uDDB5\uDDB6\uDDD1-\uDDD5])(?:\uD83C[\uDFFB-\uDFFF])|(?:[\u231A\u231B\u23E9-\u23EC\u23F0\u23F3\u25FD\u25FE\u2614\u2615\u2648-\u2653\u267F\u2693\u26A1\u26AA\u26AB\u26BD\u26BE\u26C4\u26C5\u26CE\u26D4\u26EA\u26F2\u26F3\u26F5\u26FA\u26FD\u2705\u270A\u270B\u2728\u274C\u274E\u2753-\u2755\u2757\u2795-\u2797\u27B0\u27BF\u2B1B\u2B1C\u2B50\u2B55]|\uD83C[\uDC04\uDCCF\uDD8E\uDD91-\uDD9A\uDDE6-\uDDFF\uDE01\uDE1A\uDE2F\uDE32-\uDE36\uDE38-\uDE3A\uDE50\uDE51\uDF00-\uDF20\uDF2D-\uDF35\uDF37-\uDF7C\uDF7E-\uDF93\uDFA0-\uDFCA\uDFCF-\uDFD3\uDFE0-\uDFF0\uDFF4\uDFF8-\uDFFF]|\uD83D[\uDC00-\uDC3E\uDC40\uDC42-\uDCFC\uDCFF-\uDD3D\uDD4B-\uDD4E\uDD50-\uDD67\uDD7A\uDD95\uDD96\uDDA4\uDDFB-\uDE4F\uDE80-\uDEC5\uDECC\uDED0-\uDED2\uDEEB\uDEEC\uDEF4-\uDEF9]|\uD83E[\uDD10-\uDD3A\uDD3C-\uDD3E\uDD40-\uDD45\uDD47-\uDD70\uDD73-\uDD76\uDD7A\uDD7C-\uDDA2\uDDB0-\uDDB9\uDDC0-\uDDC2\uDDD0-\uDDFF])|(?:[#\*0-9\xA9\xAE\u203C\u2049\u2122\u2139\u2194-\u2199\u21A9\u21AA\u231A\u231B\u2328\u23CF\u23E9-\u23F3\u23F8-\u23FA\u24C2\u25AA\u25AB\u25B6\u25C0\u25FB-\u25FE\u2600-\u2604\u260E\u2611\u2614\u2615\u2618\u261D\u2620\u2622\u2623\u2626\u262A\u262E\u262F\u2638-\u263A\u2640\u2642\u2648-\u2653\u265F\u2660\u2663\u2665\u2666\u2668\u267B\u267E\u267F\u2692-\u2697\u2699\u269B\u269C\u26A0\u26A1\u26AA\u26AB\u26B0\u26B1\u26BD\u26BE\u26C4\u26C5\u26C8\u26CE\u26CF\u26D1\u26D3\u26D4\u26E9\u26EA\u26F0-\u26F5\u26F7-\u26FA\u26FD\u2702\u2705\u2708-\u270D\u270F\u2712\u2714\u2716\u271D\u2721\u2728\u2733\u2734\u2744\u2747\u274C\u274E\u2753-\u2755\u2757\u2763\u2764\u2795-\u2797\u27A1\u27B0\u27BF\u2934\u2935\u2B05-\u2B07\u2B1B\u2B1C\u2B50\u2B55\u3030\u303D\u3297\u3299]|\uD83C[\uDC04\uDCCF\uDD70\uDD71\uDD7E\uDD7F\uDD8E\uDD91-\uDD9A\uDDE6-\uDDFF\uDE01\uDE02\uDE1A\uDE2F\uDE32-\uDE3A\uDE50\uDE51\uDF00-\uDF21\uDF24-\uDF93\uDF96\uDF97\uDF99-\uDF9B\uDF9E-\uDFF0\uDFF3-\uDFF5\uDFF7-\uDFFF]|\uD83D[\uDC00-\uDCFD\uDCFF-\uDD3D\uDD49-\uDD4E\uDD50-\uDD67\uDD6F\uDD70\uDD73-\uDD7A\uDD87\uDD8A-\uDD8D\uDD90\uDD95\uDD96\uDDA4\uDDA5\uDDA8\uDDB1\uDDB2\uDDBC\uDDC2-\uDDC4\uDDD1-\uDDD3\uDDDC-\uDDDE\uDDE1\uDDE3\uDDE8\uDDEF\uDDF3\uDDFA-\uDE4F\uDE80-\uDEC5\uDECB-\uDED2\uDEE0-\uDEE5\uDEE9\uDEEB\uDEEC\uDEF0\uDEF3-\uDEF9]|\uD83E[\uDD10-\uDD3A\uDD3C-\uDD3E\uDD40-\uDD45\uDD47-\uDD70\uDD73-\uDD76\uDD7A\uDD7C-\uDDA2\uDDB0-\uDDB9\uDDC0-\uDDC2\uDDD0-\uDDFF])\uFE0F?|(?:[\u261D\u26F9\u270A-\u270D]|\uD83C[\uDF85\uDFC2-\uDFC4\uDFC7\uDFCA-\uDFCC]|\uD83D[\uDC42\uDC43\uDC46-\uDC50\uDC66-\uDC69\uDC6E\uDC70-\uDC78\uDC7C\uDC81-\uDC83\uDC85-\uDC87\uDCAA\uDD74\uDD75\uDD7A\uDD90\uDD95\uDD96\uDE45-\uDE47\uDE4B-\uDE4F\uDEA3\uDEB4-\uDEB6\uDEC0\uDECC]|\uD83E[\uDD18-\uDD1C\uDD1E\uDD1F\uDD26\uDD30-\uDD39\uDD3D\uDD3E\uDDB5\uDDB6\uDDB8\uDDB9\uDDD1-\uDDDD]))/g
	this.emoji_keywords = {
		':heart:': '2764',
		':orange_heart:': '1f9e1',
		':yellow_heart:': '1f49b',
		':green_heart:': '1f49a',
		':blue_heart:': '1f499',
		':purple_heart:': '1f49c',
		':black_heart:': '1f5a4',
		':broken_heart:': '1f494',
		':heart_exclamation:': '2763',
		':two_hearts:': '1f495',
		':revolving_hearts:': '1f49e',
		':heartbeat:': '1f493',
		':heartpulse:': '1f497',
		':sparkling_heart:': '1f496',
		':cupid:': '1f498',
		':gift_heart:': '1f49d',
		':heart_decoration:': '1f49f',
		':peace:': '262e',
		':cross:': '271d',
		':star_and_crescent:': '262a',
		':om_symbol:': '1f549',
		':wheel_of_dharma:': '2638',
		':star_of_david:': '2721',
		':six_pointed_star:': '1f52f',
		':menorah:': '1f54e',
		':yin_yang:': '262f',
		':orthodox_cross:': '2626',
		':place_of_worship:': '1f6d0',
		':ophiuchus:': '26ce',
		':aries:': '2648',
		':taurus:': '2649',
		':gemini:': '264a',
		':cancer:': '264b',
		':leo:': '264c',
		':virgo:': '264d',
		':libra:': '264e',
		':scorpius:': '264f',
		':sagittarius:': '2650',
		':capricorn:': '2651',
		':aquarius:': '2652',
		':pisces:': '2653',
		':id:': '1f194',
		':atom:': '269b',
		':infinity:': '267e',
		':accept:': '1f251',
		':radioactive:': '2622',
		':biohazard:': '2623',
		':mobile_phone_off:': '1f4f4',
		':vibration_mode:': '1f4f3',
		':u6709:': '1f236',
		':u7121:': '1f21a',
		':u7533:': '1f238',
		':u55b6:': '1f23a',
		':u6708:': '1f237',
		':eight_pointed_black_star:': '2734',
		':vs:': '1f19a',
		':white_flower:': '1f4ae',
		':ideograph_advantage:': '1f250',
		':secret:': '3299',
		':congratulations:': '3297',
		':u5408:': '1f234',
		':u6e80:': '1f235',
		':u5272:': '1f239',
		':u7981:': '1f232',
		':a:': '1f170',
		':b:': '1f171',
		':ab:': '1f18e',
		':cl:': '1f191',
		':o2:': '1f17e',
		':sos:': '1f198',
		':x:': '274c',
		':o:': '2b55',
		':octagonal_sign:': '1f6d1',
		':no_entry:': '26d4',
		':name_badge:': '1f4db',
		':no_entry_sign:': '1f6ab',
		':100:': '1f4af',
		':anger:': '1f4a2',
		':hotsprings:': '2668',
		':no_pedestrians:': '1f6b7',
		':do_not_litter:': '1f6af',
		':no_bicycles:': '1f6b3',
		':non-potable_water:': '1f6b1',
		':underage:': '1f51e',
		':no_mobile_phones:': '1f4f5',
		':no_smoking:': '1f6ad',
		':exclamation:': '2757',
		':grey_exclamation:': '2755',
		':question:': '2753',
		':grey_question:': '2754',
		':bangbang:': '203c',
		':interrobang:': '2049',
		':low_brightness:': '1f505',
		':high_brightness:': '1f506',
		':part_alternation_mark:': '303d',
		':warning:': '26a0',
		':children_crossing:': '1f6b8',
		':trident:': '1f531',
		':fleur-de-lis:': '269c',
		':beginner:': '1f530',
		':recycle:': '267b',
		':white_check_mark:': '2705',
		':u6307:': '1f22f',
		':chart:': '1f4b9',
		':sparkle:': '2747',
		':eight_spoked_asterisk:': '2733',
		':negative_squared_cross_mark:': '274e',
		':globe_with_meridians:': '1f310',
		':diamond_shape_with_a_dot_inside:': '1f4a0',
		':m:': '24c2',
		':cyclone:': '1f300',
		':zzz:': '1f4a4',
		':atm:': '1f3e7',
		':wc:': '1f6be',
		':wheelchair:': '267f',
		':parking:': '1f17f',
		':u7a7a:': '1f233',
		':sa:': '1f202',
		':passport_control:': '1f6c2',
		':customs:': '1f6c3',
		':baggage_claim:': '1f6c4',
		':left_luggage:': '1f6c5',
		':mens:': '1f6b9',
		':womens:': '1f6ba',
		':baby_symbol:': '1f6bc',
		':restroom:': '1f6bb',
		':put_litter_in_its_place:': '1f6ae',
		':cinema:': '1f3a6',
		':signal_strength:': '1f4f6',
		':koko:': '1f201',
		':symbols:': '1f523',
		':information_source:': '2139',
		':abc:': '1f524',
		':abcd:': '1f521',
		':capital_abcd:': '1f520',
		':ng:': '1f196',
		':ok:': '1f197',
		':up:': '1f199',
		':cool:': '1f192',
		':new:': '1f195',
		':free:': '1f193',
		':zero:': '0030-20e3',
		':one:': '0031-20e3',
		':two:': '0032-20e3',
		':three:': '0033-20e3',
		':four:': '0034-20e3',
		':five:': '0035-20e3',
		':six:': '0036-20e3',
		':seven:': '0037-20e3',
		':eight:': '0038-20e3',
		':nine:': '0039-20e3',
		':keycap_ten:': '1f51f',
		':1234:': '1f522',
		':hash:': '0023-20e3',
		':asterisk:': '002a-20e3',
		':eject:': '23cf',
		':arrow_forward:': '25b6',
		':pause_button:': '23f8',
		':play_pause:': '23ef',
		':stop_button:': '23f9',
		':record_button:': '23fa',
		':track_next:': '23ed',
		':track_previous:': '23ee',
		':fast_forward:': '23e9',
		':rewind:': '23ea',
		':arrow_double_up:': '23eb',
		':arrow_double_down:': '23ec',
		':arrow_backward:': '25c0',
		':arrow_up_small:': '1f53c',
		':arrow_down_small:': '1f53d',
		':arrow_right:': '27a1',
		':arrow_left:': '2b05',
		':arrow_up:': '2b06',
		':arrow_down:': '2b07',
		':arrow_upper_right:': '2197',
		':arrow_lower_right:': '2198',
		':arrow_lower_left:': '2199',
		':arrow_upper_left:': '2196',
		':arrow_up_down:': '2195',
		':left_right_arrow:': '2194',
		':arrow_right_hook:': '21aa',
		':leftwards_arrow_with_hook:': '21a9',
		':arrow_heading_up:': '2934',
		':arrow_heading_down:': '2935',
		':twisted_rightwards_arrows:': '1f500',
		':repeat:': '1f501',
		':repeat_one:': '1f502',
		':arrows_counterclockwise:': '1f504',
		':arrows_clockwise:': '1f503',
		':musical_note:': '1f3b5',
		':notes:': '1f3b6',
		':heavy_plus_sign:': '2795',
		':heavy_minus_sign:': '2796',
		':heavy_division_sign:': '2797',
		':heavy_multiplication_x:': '2716',
		':heavy_dollar_sign:': '1f4b2',
		':currency_exchange:': '1f4b1',
		':tm:': '2122',
		':copyright:': '00a9',
		':registered:': '00ae',
		':wavy_dash:': '3030',
		':curly_loop:': '27b0',
		':loop:': '27bf',
		':end:': '1f51a',
		':back:': '1f519',
		':on:': '1f51b',
		':top:': '1f51d',
		':soon:': '1f51c',
		':heavy_check_mark:': '2714',
		':ballot_box_with_check:': '2611',
		':radio_button:': '1f518',
		':white_circle:': '26aa',
		':black_circle:': '26ab',
		':red_circle:': '1f534',
		':blue_circle:': '1f535',
		':small_red_triangle:': '1f53a',
		':small_red_triangle_down:': '1f53b',
		':small_orange_diamond:': '1f538',
		':small_blue_diamond:': '1f539',
		':large_orange_diamond:': '1f536',
		':large_blue_diamond:': '1f537',
		':white_square_button:': '1f533',
		':black_square_button:': '1f532',
		':black_small_square:': '25aa',
		':white_small_square:': '25ab',
		':black_medium_small_square:': '25fe',
		':white_medium_small_square:': '25fd',
		':black_medium_square:': '25fc',
		':white_medium_square:': '25fb',
		':black_large_square:': '2b1b',
		':white_large_square:': '2b1c',
		':speaker:': '1f508',
		':mute:': '1f507',
		':sound:': '1f509',
		':loud_sound:': '1f50a',
		':bell:': '1f514',
		':no_bell:': '1f515',
		':mega:': '1f4e3',
		':loudspeaker:': '1f4e2',
		':speech_left:': '1f5e8',
		':eye_in_speech_bubble:': '1f441-1f5e8',
		':speech_balloon:': '1f4ac',
		':thought_balloon:': '1f4ad',
		':anger_right:': '1f5ef',
		':spades:': '2660',
		':clubs:': '2663',
		':hearts:': '2665',
		':diamonds:': '2666',
		':black_joker:': '1f0cf',
		':flower_playing_cards:': '1f3b4',
		':mahjong:': '1f004',
		':clock1:': '1f550',
		':clock2:': '1f551',
		':clock3:': '1f552',
		':clock4:': '1f553',
		':clock5:': '1f554',
		':clock6:': '1f555',
		':clock7:': '1f556',
		':clock8:': '1f557',
		':clock9:': '1f558',
		':clock10:': '1f559',
		':clock11:': '1f55a',
		':clock12:': '1f55b',
		':clock130:': '1f55c',
		':clock230:': '1f55d',
		':clock330:': '1f55e',
		':clock430:': '1f55f',
		':clock530:': '1f560',
		':clock630:': '1f561',
		':clock730:': '1f562',
		':clock830:': '1f563',
		':clock930:': '1f564',
		':clock1030:': '1f565',
		':clock1130:': '1f566',
		':clock1230:': '1f567',
		':digit_zero:': '0030',
		':digit_one:': '0031',
		':digit_two:': '0032',
		':digit_three:': '0033',
		':digit_four:': '0034',
		':digit_five:': '0035',
		':digit_six:': '0036',
		':digit_seven:': '0037',
		':digit_eight:': '0038',
		':digit_nine:': '0039',
		':pound_symbol:': '0023',
		':asterisk_symbol:': '002a',
		':female_sign:': '2640',
		':male_sign:': '2642',
		':medical_symbol:': '2695',
		':soccer:': '26bd',
		':basketball:': '1f3c0',
		':football:': '1f3c8',
		':baseball:': '26be',
		':softball:': '1f94e',
		':tennis:': '1f3be',
		':volleyball:': '1f3d0',
		':rugby_football:': '1f3c9',
		':8ball:': '1f3b1',
		':ping_pong:': '1f3d3',
		':badminton:': '1f3f8',
		':goal:': '1f945',
		':hockey:': '1f3d2',
		':field_hockey:': '1f3d1',
		':cricket_game:': '1f3cf',
		':lacrosse:': '1f94d',
		':golf:': '26f3',
		':flying_disc:': '1f94f',
		':bow_and_arrow:': '1f3f9',
		':fishing_pole_and_fish:': '1f3a3',
		':boxing_glove:': '1f94a',
		':martial_arts_uniform:': '1f94b',
		':running_shirt_with_sash:': '1f3bd',
		':skateboard:': '1f6f9',
		':ice_skate:': '26f8',
		':curling_stone:': '1f94c',
		':sled:': '1f6f7',
		':ski:': '1f3bf',
		':skier:': '26f7',
		':snowboarder:': '1f3c2',
		':snowboarder_tone1:': '1f3c2-1f3fb',
		':snowboarder_tone2:': '1f3c2-1f3fc',
		':snowboarder_tone3:': '1f3c2-1f3fd',
		':snowboarder_tone4:': '1f3c2-1f3fe',
		':snowboarder_tone5:': '1f3c2-1f3ff',
		':person_lifting_weights:': '1f3cb',
		':person_lifting_weights_tone1:': '1f3cb-1f3fb',
		':person_lifting_weights_tone2:': '1f3cb-1f3fc',
		':person_lifting_weights_tone3:': '1f3cb-1f3fd',
		':person_lifting_weights_tone4:': '1f3cb-1f3fe',
		':person_lifting_weights_tone5:': '1f3cb-1f3ff',
		':woman_lifting_weights:': '1f3cb-2640',
		':woman_lifting_weights_tone1:': '1f3cb-1f3fb-2640',
		':woman_lifting_weights_tone2:': '1f3cb-1f3fc-2640',
		':woman_lifting_weights_tone3:': '1f3cb-1f3fd-2640',
		':woman_lifting_weights_tone4:': '1f3cb-1f3fe-2640',
		':woman_lifting_weights_tone5:': '1f3cb-1f3ff-2640',
		':man_lifting_weights:': '1f3cb-2642',
		':man_lifting_weights_tone1:': '1f3cb-1f3fb-2642',
		':man_lifting_weights_tone2:': '1f3cb-1f3fc-2642',
		':man_lifting_weights_tone3:': '1f3cb-1f3fd-2642',
		':man_lifting_weights_tone4:': '1f3cb-1f3fe-2642',
		':man_lifting_weights_tone5:': '1f3cb-1f3ff-2642',
		':people_wrestling:': '1f93c',
		':women_wrestling:': '1f93c-2640',
		':men_wrestling:': '1f93c-2642',
		':person_doing_cartwheel:': '1f938',
		':person_doing_cartwheel_tone1:': '1f938-1f3fb',
		':person_doing_cartwheel_tone2:': '1f938-1f3fc',
		':person_doing_cartwheel_tone3:': '1f938-1f3fd',
		':person_doing_cartwheel_tone4:': '1f938-1f3fe',
		':person_doing_cartwheel_tone5:': '1f938-1f3ff',
		':woman_cartwheeling:': '1f938-2640',
		':woman_cartwheeling_tone1:': '1f938-1f3fb-2640',
		':woman_cartwheeling_tone2:': '1f938-1f3fc-2640',
		':woman_cartwheeling_tone3:': '1f938-1f3fd-2640',
		':woman_cartwheeling_tone4:': '1f938-1f3fe-2640',
		':woman_cartwheeling_tone5:': '1f938-1f3ff-2640',
		':man_cartwheeling:': '1f938-2642',
		':man_cartwheeling_tone1:': '1f938-1f3fb-2642',
		':man_cartwheeling_tone2:': '1f938-1f3fc-2642',
		':man_cartwheeling_tone3:': '1f938-1f3fd-2642',
		':man_cartwheeling_tone4:': '1f938-1f3fe-2642',
		':man_cartwheeling_tone5:': '1f938-1f3ff-2642',
		':person_bouncing_ball:': '26f9',
		':person_bouncing_ball_tone1:': '26f9-1f3fb',
		':person_bouncing_ball_tone2:': '26f9-1f3fc',
		':person_bouncing_ball_tone3:': '26f9-1f3fd',
		':person_bouncing_ball_tone4:': '26f9-1f3fe',
		':person_bouncing_ball_tone5:': '26f9-1f3ff',
		':woman_bouncing_ball:': '26f9-2640',
		':woman_bouncing_ball_tone1:': '26f9-1f3fb-2640',
		':woman_bouncing_ball_tone2:': '26f9-1f3fc-2640',
		':woman_bouncing_ball_tone3:': '26f9-1f3fd-2640',
		':woman_bouncing_ball_tone4:': '26f9-1f3fe-2640',
		':woman_bouncing_ball_tone5:': '26f9-1f3ff-2640',
		':man_bouncing_ball:': '26f9-2642',
		':man_bouncing_ball_tone1:': '26f9-1f3fb-2642',
		':man_bouncing_ball_tone2:': '26f9-1f3fc-2642',
		':man_bouncing_ball_tone3:': '26f9-1f3fd-2642',
		':man_bouncing_ball_tone4:': '26f9-1f3fe-2642',
		':man_bouncing_ball_tone5:': '26f9-1f3ff-2642',
		':person_fencing:': '1f93a',
		':person_playing_handball:': '1f93e',
		':person_playing_handball_tone1:': '1f93e-1f3fb',
		':person_playing_handball_tone2:': '1f93e-1f3fc',
		':person_playing_handball_tone3:': '1f93e-1f3fd',
		':person_playing_handball_tone4:': '1f93e-1f3fe',
		':person_playing_handball_tone5:': '1f93e-1f3ff',
		':woman_playing_handball:': '1f93e-2640',
		':woman_playing_handball_tone1:': '1f93e-1f3fb-2640',
		':woman_playing_handball_tone2:': '1f93e-1f3fc-2640',
		':woman_playing_handball_tone3:': '1f93e-1f3fd-2640',
		':woman_playing_handball_tone4:': '1f93e-1f3fe-2640',
		':woman_playing_handball_tone5:': '1f93e-1f3ff-2640',
		':man_playing_handball:': '1f93e-2642',
		':man_playing_handball_tone1:': '1f93e-1f3fb-2642',
		':man_playing_handball_tone2:': '1f93e-1f3fc-2642',
		':man_playing_handball_tone3:': '1f93e-1f3fd-2642',
		':man_playing_handball_tone4:': '1f93e-1f3fe-2642',
		':man_playing_handball_tone5:': '1f93e-1f3ff-2642',
		':person_golfing:': '1f3cc',
		':person_golfing_tone1:': '1f3cc-1f3fb',
		':person_golfing_tone2:': '1f3cc-1f3fc',
		':person_golfing_tone3:': '1f3cc-1f3fd',
		':person_golfing_tone4:': '1f3cc-1f3fe',
		':person_golfing_tone5:': '1f3cc-1f3ff',
		':woman_golfing:': '1f3cc-2640',
		':woman_golfing_tone1:': '1f3cc-1f3fb-2640',
		':woman_golfing_tone2:': '1f3cc-1f3fc-2640',
		':woman_golfing_tone3:': '1f3cc-1f3fd-2640',
		':woman_golfing_tone4:': '1f3cc-1f3fe-2640',
		':woman_golfing_tone5:': '1f3cc-1f3ff-2640',
		':man_golfing:': '1f3cc-2642',
		':man_golfing_tone1:': '1f3cc-1f3fb-2642',
		':man_golfing_tone2:': '1f3cc-1f3fc-2642',
		':man_golfing_tone3:': '1f3cc-1f3fd-2642',
		':man_golfing_tone4:': '1f3cc-1f3fe-2642',
		':man_golfing_tone5:': '1f3cc-1f3ff-2642',
		':horse_racing:': '1f3c7',
		':horse_racing_tone1:': '1f3c7-1f3fb',
		':horse_racing_tone2:': '1f3c7-1f3fc',
		':horse_racing_tone3:': '1f3c7-1f3fd',
		':horse_racing_tone4:': '1f3c7-1f3fe',
		':horse_racing_tone5:': '1f3c7-1f3ff',
		':person_in_lotus_position:': '1f9d8',
		':person_in_lotus_position_tone1:': '1f9d8-1f3fb',
		':person_in_lotus_position_tone2:': '1f9d8-1f3fc',
		':person_in_lotus_position_tone3:': '1f9d8-1f3fd',
		':person_in_lotus_position_tone4:': '1f9d8-1f3fe',
		':person_in_lotus_position_tone5:': '1f9d8-1f3ff',
		':woman_in_lotus_position:': '1f9d8-2640',
		':woman_in_lotus_position_tone1:': '1f9d8-1f3fb-2640',
		':woman_in_lotus_position_tone2:': '1f9d8-1f3fc-2640',
		':woman_in_lotus_position_tone3:': '1f9d8-1f3fd-2640',
		':woman_in_lotus_position_tone4:': '1f9d8-1f3fe-2640',
		':woman_in_lotus_position_tone5:': '1f9d8-1f3ff-2640',
		':man_in_lotus_position:': '1f9d8-2642',
		':man_in_lotus_position_tone1:': '1f9d8-1f3fb-2642',
		':man_in_lotus_position_tone2:': '1f9d8-1f3fc-2642',
		':man_in_lotus_position_tone3:': '1f9d8-1f3fd-2642',
		':man_in_lotus_position_tone4:': '1f9d8-1f3fe-2642',
		':man_in_lotus_position_tone5:': '1f9d8-1f3ff-2642',
		':person_surfing:': '1f3c4',
		':person_surfing_tone1:': '1f3c4-1f3fb',
		':person_surfing_tone2:': '1f3c4-1f3fc',
		':person_surfing_tone3:': '1f3c4-1f3fd',
		':person_surfing_tone4:': '1f3c4-1f3fe',
		':person_surfing_tone5:': '1f3c4-1f3ff',
		':woman_surfing:': '1f3c4-2640',
		':woman_surfing_tone1:': '1f3c4-1f3fb-2640',
		':woman_surfing_tone2:': '1f3c4-1f3fc-2640',
		':woman_surfing_tone3:': '1f3c4-1f3fd-2640',
		':woman_surfing_tone4:': '1f3c4-1f3fe-2640',
		':woman_surfing_tone5:': '1f3c4-1f3ff-2640',
		':man_surfing:': '1f3c4-2642',
		':man_surfing_tone1:': '1f3c4-1f3fb-2642',
		':man_surfing_tone2:': '1f3c4-1f3fc-2642',
		':man_surfing_tone3:': '1f3c4-1f3fd-2642',
		':man_surfing_tone4:': '1f3c4-1f3fe-2642',
		':man_surfing_tone5:': '1f3c4-1f3ff-2642',
		':person_swimming:': '1f3ca',
		':person_swimming_tone1:': '1f3ca-1f3fb',
		':person_swimming_tone2:': '1f3ca-1f3fc',
		':person_swimming_tone3:': '1f3ca-1f3fd',
		':person_swimming_tone4:': '1f3ca-1f3fe',
		':person_swimming_tone5:': '1f3ca-1f3ff',
		':woman_swimming:': '1f3ca-2640',
		':woman_swimming_tone1:': '1f3ca-1f3fb-2640',
		':woman_swimming_tone2:': '1f3ca-1f3fc-2640',
		':woman_swimming_tone3:': '1f3ca-1f3fd-2640',
		':woman_swimming_tone4:': '1f3ca-1f3fe-2640',
		':woman_swimming_tone5:': '1f3ca-1f3ff-2640',
		':man_swimming:': '1f3ca-2642',
		':man_swimming_tone1:': '1f3ca-1f3fb-2642',
		':man_swimming_tone2:': '1f3ca-1f3fc-2642',
		':man_swimming_tone3:': '1f3ca-1f3fd-2642',
		':man_swimming_tone4:': '1f3ca-1f3fe-2642',
		':man_swimming_tone5:': '1f3ca-1f3ff-2642',
		':person_playing_water_polo:': '1f93d',
		':person_playing_water_polo_tone1:': '1f93d-1f3fb',
		':person_playing_water_polo_tone2:': '1f93d-1f3fc',
		':person_playing_water_polo_tone3:': '1f93d-1f3fd',
		':person_playing_water_polo_tone4:': '1f93d-1f3fe',
		':person_playing_water_polo_tone5:': '1f93d-1f3ff',
		':woman_playing_water_polo:': '1f93d-2640',
		':woman_playing_water_polo_tone1:': '1f93d-1f3fb-2640',
		':woman_playing_water_polo_tone2:': '1f93d-1f3fc-2640',
		':woman_playing_water_polo_tone3:': '1f93d-1f3fd-2640',
		':woman_playing_water_polo_tone4:': '1f93d-1f3fe-2640',
		':woman_playing_water_polo_tone5:': '1f93d-1f3ff-2640',
		':man_playing_water_polo:': '1f93d-2642',
		':man_playing_water_polo_tone1:': '1f93d-1f3fb-2642',
		':man_playing_water_polo_tone2:': '1f93d-1f3fc-2642',
		':man_playing_water_polo_tone3:': '1f93d-1f3fd-2642',
		':man_playing_water_polo_tone4:': '1f93d-1f3fe-2642',
		':man_playing_water_polo_tone5:': '1f93d-1f3ff-2642',
		':person_rowing_boat:': '1f6a3',
		':person_rowing_boat_tone1:': '1f6a3-1f3fb',
		':person_rowing_boat_tone2:': '1f6a3-1f3fc',
		':person_rowing_boat_tone3:': '1f6a3-1f3fd',
		':person_rowing_boat_tone4:': '1f6a3-1f3fe',
		':person_rowing_boat_tone5:': '1f6a3-1f3ff',
		':woman_rowing_boat:': '1f6a3-2640',
		':woman_rowing_boat_tone1:': '1f6a3-1f3fb-2640',
		':woman_rowing_boat_tone2:': '1f6a3-1f3fc-2640',
		':woman_rowing_boat_tone3:': '1f6a3-1f3fd-2640',
		':woman_rowing_boat_tone4:': '1f6a3-1f3fe-2640',
		':woman_rowing_boat_tone5:': '1f6a3-1f3ff-2640',
		':man_rowing_boat:': '1f6a3-2642',
		':man_rowing_boat_tone1:': '1f6a3-1f3fb-2642',
		':man_rowing_boat_tone2:': '1f6a3-1f3fc-2642',
		':man_rowing_boat_tone3:': '1f6a3-1f3fd-2642',
		':man_rowing_boat_tone4:': '1f6a3-1f3fe-2642',
		':man_rowing_boat_tone5:': '1f6a3-1f3ff-2642',
		':person_climbing:': '1f9d7',
		':person_climbing_tone1:': '1f9d7-1f3fb',
		':person_climbing_tone2:': '1f9d7-1f3fc',
		':person_climbing_tone3:': '1f9d7-1f3fd',
		':person_climbing_tone4:': '1f9d7-1f3fe',
		':person_climbing_tone5:': '1f9d7-1f3ff',
		':woman_climbing:': '1f9d7-2640',
		':woman_climbing_tone1:': '1f9d7-1f3fb-2640',
		':woman_climbing_tone2:': '1f9d7-1f3fc-2640',
		':woman_climbing_tone3:': '1f9d7-1f3fd-2640',
		':woman_climbing_tone4:': '1f9d7-1f3fe-2640',
		':woman_climbing_tone5:': '1f9d7-1f3ff-2640',
		':man_climbing:': '1f9d7-2642',
		':man_climbing_tone1:': '1f9d7-1f3fb-2642',
		':man_climbing_tone2:': '1f9d7-1f3fc-2642',
		':man_climbing_tone3:': '1f9d7-1f3fd-2642',
		':man_climbing_tone4:': '1f9d7-1f3fe-2642',
		':man_climbing_tone5:': '1f9d7-1f3ff-2642',
		':person_mountain_biking:': '1f6b5',
		':person_mountain_biking_tone1:': '1f6b5-1f3fb',
		':person_mountain_biking_tone2:': '1f6b5-1f3fc',
		':person_mountain_biking_tone3:': '1f6b5-1f3fd',
		':person_mountain_biking_tone4:': '1f6b5-1f3fe',
		':person_mountain_biking_tone5:': '1f6b5-1f3ff',
		':woman_mountain_biking:': '1f6b5-2640',
		':woman_mountain_biking_tone1:': '1f6b5-1f3fb-2640',
		':woman_mountain_biking_tone2:': '1f6b5-1f3fc-2640',
		':woman_mountain_biking_tone3:': '1f6b5-1f3fd-2640',
		':woman_mountain_biking_tone4:': '1f6b5-1f3fe-2640',
		':woman_mountain_biking_tone5:': '1f6b5-1f3ff-2640',
		':man_mountain_biking:': '1f6b5-2642',
		':man_mountain_biking_tone1:': '1f6b5-1f3fb-2642',
		':man_mountain_biking_tone2:': '1f6b5-1f3fc-2642',
		':man_mountain_biking_tone3:': '1f6b5-1f3fd-2642',
		':man_mountain_biking_tone4:': '1f6b5-1f3fe-2642',
		':man_mountain_biking_tone5:': '1f6b5-1f3ff-2642',
		':person_biking:': '1f6b4',
		':person_biking_tone1:': '1f6b4-1f3fb',
		':person_biking_tone2:': '1f6b4-1f3fc',
		':person_biking_tone3:': '1f6b4-1f3fd',
		':person_biking_tone4:': '1f6b4-1f3fe',
		':person_biking_tone5:': '1f6b4-1f3ff',
		':woman_biking:': '1f6b4-2640',
		':woman_biking_tone1:': '1f6b4-1f3fb-2640',
		':woman_biking_tone2:': '1f6b4-1f3fc-2640',
		':woman_biking_tone3:': '1f6b4-1f3fd-2640',
		':woman_biking_tone4:': '1f6b4-1f3fe-2640',
		':woman_biking_tone5:': '1f6b4-1f3ff-2640',
		':man_biking:': '1f6b4-2642',
		':man_biking_tone1:': '1f6b4-1f3fb-2642',
		':man_biking_tone2:': '1f6b4-1f3fc-2642',
		':man_biking_tone3:': '1f6b4-1f3fd-2642',
		':man_biking_tone4:': '1f6b4-1f3fe-2642',
		':man_biking_tone5:': '1f6b4-1f3ff-2642',
		':trophy:': '1f3c6',
		':first_place:': '1f947',
		':second_place:': '1f948',
		':third_place:': '1f949',
		':medal:': '1f3c5',
		':military_medal:': '1f396',
		':rosette:': '1f3f5',
		':reminder_ribbon:': '1f397',
		':ticket:': '1f3ab',
		':tickets:': '1f39f',
		':circus_tent:': '1f3aa',
		':person_juggling:': '1f939',
		':person_juggling_tone1:': '1f939-1f3fb',
		':person_juggling_tone2:': '1f939-1f3fc',
		':person_juggling_tone3:': '1f939-1f3fd',
		':person_juggling_tone4:': '1f939-1f3fe',
		':person_juggling_tone5:': '1f939-1f3ff',
		':woman_juggling:': '1f939-2640',
		':woman_juggling_tone1:': '1f939-1f3fb-2640',
		':woman_juggling_tone2:': '1f939-1f3fc-2640',
		':woman_juggling_tone3:': '1f939-1f3fd-2640',
		':woman_juggling_tone4:': '1f939-1f3fe-2640',
		':woman_juggling_tone5:': '1f939-1f3ff-2640',
		':man_juggling:': '1f939-2642',
		':man_juggling_tone1:': '1f939-1f3fb-2642',
		':man_juggling_tone2:': '1f939-1f3fc-2642',
		':man_juggling_tone3:': '1f939-1f3fd-2642',
		':man_juggling_tone4:': '1f939-1f3fe-2642',
		':man_juggling_tone5:': '1f939-1f3ff-2642',
		':performing_arts:': '1f3ad',
		':art:': '1f3a8',
		':clapper:': '1f3ac',
		':microphone:': '1f3a4',
		':headphones:': '1f3a7',
		':musical_score:': '1f3bc',
		':musical_keyboard:': '1f3b9',
		':drum:': '1f941',
		':saxophone:': '1f3b7',
		':trumpet:': '1f3ba',
		':guitar:': '1f3b8',
		':violin:': '1f3bb',
		':game_die:': '1f3b2',
		':dart:': '1f3af',
		':bowling:': '1f3b3',
		':video_game:': '1f3ae',
		':slot_machine:': '1f3b0',
		':watch:': '231a',
		':iphone:': '1f4f1',
		':calling:': '1f4f2',
		':computer:': '1f4bb',
		':keyboard:': '2328',
		':desktop:': '1f5a5',
		':printer:': '1f5a8',
		':mouse_three_button:': '1f5b1',
		':trackball:': '1f5b2',
		':joystick:': '1f579',
		':chess_pawn:': '265f',
		':jigsaw:': '1f9e9',
		':compression:': '1f5dc',
		':minidisc:': '1f4bd',
		':floppy_disk:': '1f4be',
		':cd:': '1f4bf',
		':dvd:': '1f4c0',
		':vhs:': '1f4fc',
		':camera:': '1f4f7',
		':camera_with_flash:': '1f4f8',
		':video_camera:': '1f4f9',
		':movie_camera:': '1f3a5',
		':projector:': '1f4fd',
		':film_frames:': '1f39e',
		':telephone_receiver:': '1f4de',
		':telephone:': '260e',
		':pager:': '1f4df',
		':fax:': '1f4e0',
		':tv:': '1f4fa',
		':radio:': '1f4fb',
		':microphone2:': '1f399',
		':level_slider:': '1f39a',
		':control_knobs:': '1f39b',
		':stopwatch:': '23f1',
		':timer:': '23f2',
		':alarm_clock:': '23f0',
		':clock:': '1f570',
		':hourglass:': '231b',
		':hourglass_flowing_sand:': '23f3',
		':satellite:': '1f4e1',
		':compass:': '1f9ed',
		':battery:': '1f50b',
		':electric_plug:': '1f50c',
		':magnet:': '1f9f2',
		':bulb:': '1f4a1',
		':flashlight:': '1f526',
		':candle:': '1f56f',
		':fire_extinguisher:': '1f9ef',
		':wastebasket:': '1f5d1',
		':oil:': '1f6e2',
		':money_with_wings:': '1f4b8',
		':dollar:': '1f4b5',
		':yen:': '1f4b4',
		':euro:': '1f4b6',
		':pound:': '1f4b7',
		':moneybag:': '1f4b0',
		':credit_card:': '1f4b3',
		':gem:': '1f48e',
		':nazar_amulet:': '1f9ff',
		':bricks:': '1f9f1',
		':scales:': '2696',
		':toolbox:': '1f9f0',
		':wrench:': '1f527',
		':hammer:': '1f528',
		':hammer_pick:': '2692',
		':tools:': '1f6e0',
		':pick:': '26cf',
		':nut_and_bolt:': '1f529',
		':gear:': '2699',
		':chains:': '26d3',
		':gun:': '1f52b',
		':bomb:': '1f4a3',
		':knife:': '1f52a',
		':dagger:': '1f5e1',
		':crossed_swords:': '2694',
		':shield:': '1f6e1',
		':smoking:': '1f6ac',
		':coffin:': '26b0',
		':urn:': '26b1',
		':amphora:': '1f3fa',
		':crystal_ball:': '1f52e',
		':prayer_beads:': '1f4ff',
		':barber:': '1f488',
		':alembic:': '2697',
		':test_tube:': '1f9ea',
		':petri_dish:': '1f9eb',
		':dna:': '1f9ec',
		':abacus:': '1f9ee',
		':telescope:': '1f52d',
		':microscope:': '1f52c',
		':hole:': '1f573',
		':pill:': '1f48a',
		':syringe:': '1f489',
		':thermometer:': '1f321',
		':toilet:': '1f6bd',
		':potable_water:': '1f6b0',
		':shower:': '1f6bf',
		':bathtub:': '1f6c1',
		':bath:': '1f6c0',
		':bath_tone1:': '1f6c0-1f3fb',
		':bath_tone2:': '1f6c0-1f3fc',
		':bath_tone3:': '1f6c0-1f3fd',
		':bath_tone4:': '1f6c0-1f3fe',
		':bath_tone5:': '1f6c0-1f3ff',
		':broom:': '1f9f9',
		':basket:': '1f9fa',
		':roll_of_paper:': '1f9fb',
		':soap:': '1f9fc',
		':sponge:': '1f9fd',
		':squeeze_bottle:': '1f9f4',
		':thread:': '1f9f5',
		':yarn:': '1f9f6',
		':bellhop:': '1f6ce',
		':key:': '1f511',
		':key2:': '1f5dd',
		':door:': '1f6aa',
		':couch:': '1f6cb',
		':bed:': '1f6cf',
		':sleeping_accommodation:': '1f6cc',
		':person_in_bed_tone1:': '1f6cc-1f3fb',
		':person_in_bed_tone2:': '1f6cc-1f3fc',
		':person_in_bed_tone3:': '1f6cc-1f3fd',
		':person_in_bed_tone4:': '1f6cc-1f3fe',
		':person_in_bed_tone5:': '1f6cc-1f3ff',
		':teddy_bear:': '1f9f8',
		':frame_photo:': '1f5bc',
		':shopping_bags:': '1f6cd',
		':shopping_cart:': '1f6d2',
		':gift:': '1f381',
		':balloon:': '1f388',
		':flags:': '1f38f',
		':ribbon:': '1f380',
		':confetti_ball:': '1f38a',
		':tada:': '1f389',
		':dolls:': '1f38e',
		':izakaya_lantern:': '1f3ee',
		':wind_chime:': '1f390',
		':red_envelope:': '1f9e7',
		':envelope:': '2709',
		':envelope_with_arrow:': '1f4e9',
		':incoming_envelope:': '1f4e8',
		':e-mail:': '1f4e7',
		':love_letter:': '1f48c',
		':inbox_tray:': '1f4e5',
		':outbox_tray:': '1f4e4',
		':package:': '1f4e6',
		':label:': '1f3f7',
		':mailbox_closed:': '1f4ea',
		':mailbox:': '1f4eb',
		':mailbox_with_mail:': '1f4ec',
		':mailbox_with_no_mail:': '1f4ed',
		':postbox:': '1f4ee',
		':postal_horn:': '1f4ef',
		':scroll:': '1f4dc',
		':page_with_curl:': '1f4c3',
		':page_facing_up:': '1f4c4',
		':receipt:': '1f9fe',
		':bookmark_tabs:': '1f4d1',
		':bar_chart:': '1f4ca',
		':chart_with_upwards_trend:': '1f4c8',
		':chart_with_downwards_trend:': '1f4c9',
		':notepad_spiral:': '1f5d2',
		':calendar_spiral:': '1f5d3',
		':calendar:': '1f4c6',
		':date:': '1f4c5',
		':card_index:': '1f4c7',
		':card_box:': '1f5c3',
		':ballot_box:': '1f5f3',
		':file_cabinet:': '1f5c4',
		':clipboard:': '1f4cb',
		':file_folder:': '1f4c1',
		':open_file_folder:': '1f4c2',
		':dividers:': '1f5c2',
		':newspaper2:': '1f5de',
		':newspaper:': '1f4f0',
		':notebook:': '1f4d3',
		':notebook_with_decorative_cover:': '1f4d4',
		':ledger:': '1f4d2',
		':closed_book:': '1f4d5',
		':green_book:': '1f4d7',
		':blue_book:': '1f4d8',
		':orange_book:': '1f4d9',
		':books:': '1f4da',
		':book:': '1f4d6',
		':bookmark:': '1f516',
		':link:': '1f517',
		':paperclip:': '1f4ce',
		':paperclips:': '1f587',
		':triangular_ruler:': '1f4d0',
		':straight_ruler:': '1f4cf',
		':safety_pin:': '1f9f7',
		':pushpin:': '1f4cc',
		':round_pushpin:': '1f4cd',
		':scissors:': '2702',
		':pen_ballpoint:': '1f58a',
		':pen_fountain:': '1f58b',
		':black_nib:': '2712',
		':paintbrush:': '1f58c',
		':crayon:': '1f58d',
		':pencil:': '1f4dd',
		':pencil2:': '270f',
		':mag:': '1f50d',
		':mag_right:': '1f50e',
		':lock_with_ink_pen:': '1f50f',
		':closed_lock_with_key:': '1f510',
		':dog:': '1f436',
		':cat:': '1f431',
		':mouse:': '1f42d',
		':hamster:': '1f439',
		':rabbit:': '1f430',
		':fox:': '1f98a',
		':raccoon:': '1f99d',
		':bear:': '1f43b',
		':panda_face:': '1f43c',
		':kangaroo:': '1f998',
		':badger:': '1f9a1',
		':koala:': '1f428',
		':tiger:': '1f42f',
		':lion_face:': '1f981',
		':cow:': '1f42e',
		':pig:': '1f437',
		':pig_nose:': '1f43d',
		':frog:': '1f438',
		':monkey_face:': '1f435',
		':see_no_evil:': '1f648',
		':hear_no_evil:': '1f649',
		':speak_no_evil:': '1f64a',
		':monkey:': '1f412',
		':chicken:': '1f414',
		':penguin:': '1f427',
		':bird:': '1f426',
		':baby_chick:': '1f424',
		':hatching_chick:': '1f423',
		':hatched_chick:': '1f425',
		':duck:': '1f986',
		':swan:': '1f9a2',
		':eagle:': '1f985',
		':owl:': '1f989',
		':parrot:': '1f99c',
		':peacock:': '1f99a',
		':bat:': '1f987',
		':wolf:': '1f43a',
		':boar:': '1f417',
		':horse:': '1f434',
		':unicorn:': '1f984',
		':bee:': '1f41d',
		':bug:': '1f41b',
		':butterfly:': '1f98b',
		':snail:': '1f40c',
		':shell:': '1f41a',
		':beetle:': '1f41e',
		':ant:': '1f41c',
		':cricket:': '1f997',
		':spider:': '1f577',
		':spider_web:': '1f578',
		':scorpion:': '1f982',
		':mosquito:': '1f99f',
		':microbe:': '1f9a0',
		':turtle:': '1f422',
		':snake:': '1f40d',
		':lizard:': '1f98e',
		':t_rex:': '1f996',
		':sauropod:': '1f995',
		':octopus:': '1f419',
		':squid:': '1f991',
		':shrimp:': '1f990',
		':crab:': '1f980',
		':lobster:': '1f99e',
		':blowfish:': '1f421',
		':tropical_fish:': '1f420',
		':fish:': '1f41f',
		':dolphin:': '1f42c',
		':whale:': '1f433',
		':whale2:': '1f40b',
		':shark:': '1f988',
		':crocodile:': '1f40a',
		':tiger2:': '1f405',
		':leopard:': '1f406',
		':zebra:': '1f993',
		':gorilla:': '1f98d',
		':elephant:': '1f418',
		':rhino:': '1f98f',
		':hippopotamus:': '1f99b',
		':dromedary_camel:': '1f42a',
		':camel:': '1f42b',
		':giraffe:': '1f992',
		':llama:': '1f999',
		':water_buffalo:': '1f403',
		':ox:': '1f402',
		':cow2:': '1f404',
		':racehorse:': '1f40e',
		':pig2:': '1f416',
		':ram:': '1f40f',
		':sheep:': '1f411',
		':goat:': '1f410',
		':deer:': '1f98c',
		':dog2:': '1f415',
		':poodle:': '1f429',
		':cat2:': '1f408',
		':rooster:': '1f413',
		':turkey:': '1f983',
		':dove:': '1f54a',
		':rabbit2:': '1f407',
		':mouse2:': '1f401',
		':rat:': '1f400',
		':chipmunk:': '1f43f',
		':hedgehog:': '1f994',
		':feet:': '1f43e',
		':dragon:': '1f409',
		':dragon_face:': '1f432',
		':cactus:': '1f335',
		':christmas_tree:': '1f384',
		':evergreen_tree:': '1f332',
		':deciduous_tree:': '1f333',
		':palm_tree:': '1f334',
		':seedling:': '1f331',
		':herb:': '1f33f',
		':shamrock:': '2618',
		':four_leaf_clover:': '1f340',
		':bamboo:': '1f38d',
		':tanabata_tree:': '1f38b',
		':leaves:': '1f343',
		':fallen_leaf:': '1f342',
		':maple_leaf:': '1f341',
		':mushroom:': '1f344',
		':ear_of_rice:': '1f33e',
		':bouquet:': '1f490',
		':tulip:': '1f337',
		':rose:': '1f339',
		':wilted_rose:': '1f940',
		':hibiscus:': '1f33a',
		':cherry_blossom:': '1f338',
		':blossom:': '1f33c',
		':sunflower:': '1f33b',
		':sun_with_face:': '1f31e',
		':full_moon_with_face:': '1f31d',
		':first_quarter_moon_with_face:': '1f31b',
		':last_quarter_moon_with_face:': '1f31c',
		':new_moon_with_face:': '1f31a',
		':full_moon:': '1f315',
		':waning_gibbous_moon:': '1f316',
		':last_quarter_moon:': '1f317',
		':waning_crescent_moon:': '1f318',
		':new_moon:': '1f311',
		':waxing_crescent_moon:': '1f312',
		':first_quarter_moon:': '1f313',
		':waxing_gibbous_moon:': '1f314',
		':crescent_moon:': '1f319',
		':earth_americas:': '1f30e',
		':earth_africa:': '1f30d',
		':earth_asia:': '1f30f',
		':dizzy:': '1f4ab',
		':star:': '2b50',
		':star2:': '1f31f',
		':sparkles:': '2728',
		':zap:': '26a1',
		':comet:': '2604',
		':boom:': '1f4a5',
		':fire:': '1f525',
		':cloud_tornado:': '1f32a',
		':rainbow:': '1f308',
		':sunny:': '2600',
		':white_sun_small_cloud:': '1f324',
		':partly_sunny:': '26c5',
		':white_sun_cloud:': '1f325',
		':cloud:': '2601',
		':white_sun_rain_cloud:': '1f326',
		':cloud_rain:': '1f327',
		':thunder_cloud_rain:': '26c8',
		':cloud_lightning:': '1f329',
		':cloud_snow:': '1f328',
		':snowflake:': '2744',
		':snowman2:': '2603',
		':snowman:': '26c4',
		':wind_blowing_face:': '1f32c',
		':dash:': '1f4a8',
		':droplet:': '1f4a7',
		':sweat_drops:': '1f4a6',
		':umbrella:': '2614',
		':umbrella2:': '2602',
		':ocean:': '1f30a',
		':fog:': '1f32b',
		':green_apple:': '1f34f',
		':apple:': '1f34e',
		':pear:': '1f350',
		':tangerine:': '1f34a',
		':lemon:': '1f34b',
		':banana:': '1f34c',
		':watermelon:': '1f349',
		':grapes:': '1f347',
		':strawberry:': '1f353',
		':melon:': '1f348',
		':cherries:': '1f352',
		':peach:': '1f351',
		':mango:': '1f96d',
		':pineapple:': '1f34d',
		':coconut:': '1f965',
		':kiwi:': '1f95d',
		':tomato:': '1f345',
		':eggplant:': '1f346',
		':avocado:': '1f951',
		':broccoli:': '1f966',
		':leafy_green:': '1f96c',
		':cucumber:': '1f952',
		':hot_pepper:': '1f336',
		':corn:': '1f33d',
		':carrot:': '1f955',
		':potato:': '1f954',
		':sweet_potato:': '1f360',
		':croissant:': '1f950',
		':bread:': '1f35e',
		':french_bread:': '1f956',
		':pretzel:': '1f968',
		':bagel:': '1f96f',
		':cheese:': '1f9c0',
		':egg:': '1f95a',
		':cooking:': '1f373',
		':pancakes:': '1f95e',
		':bacon:': '1f953',
		':cut_of_meat:': '1f969',
		':poultry_leg:': '1f357',
		':meat_on_bone:': '1f356',
		':hotdog:': '1f32d',
		':hamburger:': '1f354',
		':fries:': '1f35f',
		':pizza:': '1f355',
		':sandwich:': '1f96a',
		':stuffed_flatbread:': '1f959',
		':taco:': '1f32e',
		':burrito:': '1f32f',
		':salad:': '1f957',
		':shallow_pan_of_food:': '1f958',
		':canned_food:': '1f96b',
		':spaghetti:': '1f35d',
		':ramen:': '1f35c',
		':stew:': '1f372',
		':curry:': '1f35b',
		':sushi:': '1f363',
		':bento:': '1f371',
		':fried_shrimp:': '1f364',
		':rice_ball:': '1f359',
		':rice:': '1f35a',
		':rice_cracker:': '1f358',
		':fish_cake:': '1f365',
		':fortune_cookie:': '1f960',
		':oden:': '1f362',
		':dango:': '1f361',
		':shaved_ice:': '1f367',
		':ice_cream:': '1f368',
		':icecream:': '1f366',
		':pie:': '1f967',
		':cake:': '1f370',
		':birthday:': '1f382',
		':moon_cake:': '1f96e',
		':cupcake:': '1f9c1',
		':custard:': '1f36e',
		':lollipop:': '1f36d',
		':candy:': '1f36c',
		':chocolate_bar:': '1f36b',
		':popcorn:': '1f37f',
		':salt:': '1f9c2',
		':doughnut:': '1f369',
		':dumpling:': '1f95f',
		':cookie:': '1f36a',
		':chestnut:': '1f330',
		':peanuts:': '1f95c',
		':honey_pot:': '1f36f',
		':milk:': '1f95b',
		':baby_bottle:': '1f37c',
		':coffee:': '2615',
		':tea:': '1f375',
		':cup_with_straw:': '1f964',
		':sake:': '1f376',
		':beer:': '1f37a',
		':beers:': '1f37b',
		':champagne_glass:': '1f942',
		':wine_glass:': '1f377',
		':tumbler_glass:': '1f943',
		':cocktail:': '1f378',
		':tropical_drink:': '1f379',
		':champagne:': '1f37e',
		':spoon:': '1f944',
		':fork_and_knife:': '1f374',
		':fork_knife_plate:': '1f37d',
		':bowl_with_spoon:': '1f963',
		':takeout_box:': '1f961',
		':chopsticks:': '1f962',
		':grinning:': '1f600',
		':smiley:': '1f603',
		':smile:': '1f604',
		':grin:': '1f601',
		':laughing:': '1f606',
		':sweat_smile:': '1f605',
		':joy:': '1f602',
		':rofl:': '1f923',
		':relaxed:': '263a',
		':blush:': '1f60a',
		':innocent:': '1f607',
		':slight_smile:': '1f642',
		':upside_down:': '1f643',
		':wink:': '1f609',
		':relieved:': '1f60c',
		':heart_eyes:': '1f60d',
		':kissing_heart:': '1f618',
		':smiling_face_with_3_hearts:': '1f970',
		':kissing:': '1f617',
		':kissing_smiling_eyes:': '1f619',
		':kissing_closed_eyes:': '1f61a',
		':yum:': '1f60b',
		':stuck_out_tongue:': '1f61b',
		':stuck_out_tongue_closed_eyes:': '1f61d',
		':stuck_out_tongue_winking_eye:': '1f61c',
		':zany_face:': '1f92a',
		':face_with_raised_eyebrow:': '1f928',
		':face_with_monocle:': '1f9d0',
		':nerd:': '1f913',
		':sunglasses:': '1f60e',
		':star_struck:': '1f929',
		':partying_face:': '1f973',
		':smirk:': '1f60f',
		':unamused:': '1f612',
		':disappointed:': '1f61e',
		':pensive:': '1f614',
		':worried:': '1f61f',
		':confused:': '1f615',
		':slight_frown:': '1f641',
		':frowning2:': '2639',
		':persevere:': '1f623',
		':confounded:': '1f616',
		':tired_face:': '1f62b',
		':weary:': '1f629',
		':cry:': '1f622',
		':sob:': '1f62d',
		':triumph:': '1f624',
		':angry:': '1f620',
		':rage:': '1f621',
		':face_with_symbols_over_mouth:': '1f92c',
		':exploding_head:': '1f92f',
		':flushed:': '1f633',
		':scream:': '1f631',
		':fearful:': '1f628',
		':cold_sweat:': '1f630',
		':hot_face:': '1f975',
		':cold_face:': '1f976',
		':pleading_face:': '1f97a',
		':disappointed_relieved:': '1f625',
		':sweat:': '1f613',
		':hugging:': '1f917',
		':thinking:': '1f914',
		':face_with_hand_over_mouth:': '1f92d',
		':shushing_face:': '1f92b',
		':lying_face:': '1f925',
		':no_mouth:': '1f636',
		':neutral_face:': '1f610',
		':expressionless:': '1f611',
		':grimacing:': '1f62c',
		':rolling_eyes:': '1f644',
		':hushed:': '1f62f',
		':frowning:': '1f626',
		':anguished:': '1f627',
		':open_mouth:': '1f62e',
		':astonished:': '1f632',
		':sleeping:': '1f634',
		':drooling_face:': '1f924',
		':sleepy:': '1f62a',
		':dizzy_face:': '1f635',
		':zipper_mouth:': '1f910',
		':woozy_face:': '1f974',
		':nauseated_face:': '1f922',
		':face_vomiting:': '1f92e',
		':sneezing_face:': '1f927',
		':mask:': '1f637',
		':thermometer_face:': '1f912',
		':head_bandage:': '1f915',
		':money_mouth:': '1f911',
		':cowboy:': '1f920',
		':smiling_imp:': '1f608',
		':imp:': '1f47f',
		':japanese_ogre:': '1f479',
		':japanese_goblin:': '1f47a',
		':clown:': '1f921',
		':poop:': '1f4a9',
		':ghost:': '1f47b',
		':skull:': '1f480',
		':skull_crossbones:': '2620',
		':alien:': '1f47d',
		':space_invader:': '1f47e',
		':robot:': '1f916',
		':jack_o_lantern:': '1f383',
		':smiley_cat:': '1f63a',
		':smile_cat:': '1f638',
		':joy_cat:': '1f639',
		':heart_eyes_cat:': '1f63b',
		':smirk_cat:': '1f63c',
		':kissing_cat:': '1f63d',
		':scream_cat:': '1f640',
		':crying_cat_face:': '1f63f',
		':pouting_cat:': '1f63e',
		':palms_up_together:': '1f932',
		':palms_up_together_tone1:': '1f932-1f3fb',
		':palms_up_together_tone2:': '1f932-1f3fc',
		':palms_up_together_tone3:': '1f932-1f3fd',
		':palms_up_together_tone4:': '1f932-1f3fe',
		':palms_up_together_tone5:': '1f932-1f3ff',
		':open_hands:': '1f450',
		':open_hands_tone1:': '1f450-1f3fb',
		':open_hands_tone2:': '1f450-1f3fc',
		':open_hands_tone3:': '1f450-1f3fd',
		':open_hands_tone4:': '1f450-1f3fe',
		':open_hands_tone5:': '1f450-1f3ff',
		':raised_hands:': '1f64c',
		':raised_hands_tone1:': '1f64c-1f3fb',
		':raised_hands_tone2:': '1f64c-1f3fc',
		':raised_hands_tone3:': '1f64c-1f3fd',
		':raised_hands_tone4:': '1f64c-1f3fe',
		':raised_hands_tone5:': '1f64c-1f3ff',
		':clap:': '1f44f',
		':clap_tone1:': '1f44f-1f3fb',
		':clap_tone2:': '1f44f-1f3fc',
		':clap_tone3:': '1f44f-1f3fd',
		':clap_tone4:': '1f44f-1f3fe',
		':clap_tone5:': '1f44f-1f3ff',
		':handshake:': '1f91d',
		':thumbsup:': '1f44d',
		':thumbsup_tone1:': '1f44d-1f3fb',
		':thumbsup_tone2:': '1f44d-1f3fc',
		':thumbsup_tone3:': '1f44d-1f3fd',
		':thumbsup_tone4:': '1f44d-1f3fe',
		':thumbsup_tone5:': '1f44d-1f3ff',
		':thumbsdown:': '1f44e',
		':thumbsdown_tone1:': '1f44e-1f3fb',
		':thumbsdown_tone2:': '1f44e-1f3fc',
		':thumbsdown_tone3:': '1f44e-1f3fd',
		':thumbsdown_tone4:': '1f44e-1f3fe',
		':thumbsdown_tone5:': '1f44e-1f3ff',
		':punch:': '1f44a',
		':punch_tone1:': '1f44a-1f3fb',
		':punch_tone2:': '1f44a-1f3fc',
		':punch_tone3:': '1f44a-1f3fd',
		':punch_tone4:': '1f44a-1f3fe',
		':punch_tone5:': '1f44a-1f3ff',
		':fist:': '270a',
		':fist_tone1:': '270a-1f3fb',
		':fist_tone2:': '270a-1f3fc',
		':fist_tone3:': '270a-1f3fd',
		':fist_tone4:': '270a-1f3fe',
		':fist_tone5:': '270a-1f3ff',
		':left_facing_fist:': '1f91b',
		':left_facing_fist_tone1:': '1f91b-1f3fb',
		':left_facing_fist_tone2:': '1f91b-1f3fc',
		':left_facing_fist_tone3:': '1f91b-1f3fd',
		':left_facing_fist_tone4:': '1f91b-1f3fe',
		':left_facing_fist_tone5:': '1f91b-1f3ff',
		':right_facing_fist:': '1f91c',
		':right_facing_fist_tone1:': '1f91c-1f3fb',
		':right_facing_fist_tone2:': '1f91c-1f3fc',
		':right_facing_fist_tone3:': '1f91c-1f3fd',
		':right_facing_fist_tone4:': '1f91c-1f3fe',
		':right_facing_fist_tone5:': '1f91c-1f3ff',
		':fingers_crossed:': '1f91e',
		':fingers_crossed_tone1:': '1f91e-1f3fb',
		':fingers_crossed_tone2:': '1f91e-1f3fc',
		':fingers_crossed_tone3:': '1f91e-1f3fd',
		':fingers_crossed_tone4:': '1f91e-1f3fe',
		':fingers_crossed_tone5:': '1f91e-1f3ff',
		':v:': '270c',
		':v_tone1:': '270c-1f3fb',
		':v_tone2:': '270c-1f3fc',
		':v_tone3:': '270c-1f3fd',
		':v_tone4:': '270c-1f3fe',
		':v_tone5:': '270c-1f3ff',
		':love_you_gesture:': '1f91f',
		':love_you_gesture_tone1:': '1f91f-1f3fb',
		':love_you_gesture_tone2:': '1f91f-1f3fc',
		':love_you_gesture_tone3:': '1f91f-1f3fd',
		':love_you_gesture_tone4:': '1f91f-1f3fe',
		':love_you_gesture_tone5:': '1f91f-1f3ff',
		':metal:': '1f918',
		':metal_tone1:': '1f918-1f3fb',
		':metal_tone2:': '1f918-1f3fc',
		':metal_tone3:': '1f918-1f3fd',
		':metal_tone4:': '1f918-1f3fe',
		':metal_tone5:': '1f918-1f3ff',
		':ok_hand:': '1f44c',
		':ok_hand_tone1:': '1f44c-1f3fb',
		':ok_hand_tone2:': '1f44c-1f3fc',
		':ok_hand_tone3:': '1f44c-1f3fd',
		':ok_hand_tone4:': '1f44c-1f3fe',
		':ok_hand_tone5:': '1f44c-1f3ff',
		':point_left:': '1f448',
		':point_left_tone1:': '1f448-1f3fb',
		':point_left_tone2:': '1f448-1f3fc',
		':point_left_tone3:': '1f448-1f3fd',
		':point_left_tone4:': '1f448-1f3fe',
		':point_left_tone5:': '1f448-1f3ff',
		':point_right:': '1f449',
		':point_right_tone1:': '1f449-1f3fb',
		':point_right_tone2:': '1f449-1f3fc',
		':point_right_tone3:': '1f449-1f3fd',
		':point_right_tone4:': '1f449-1f3fe',
		':point_right_tone5:': '1f449-1f3ff',
		':point_up_2:': '1f446',
		':point_up_2_tone1:': '1f446-1f3fb',
		':point_up_2_tone2:': '1f446-1f3fc',
		':point_up_2_tone3:': '1f446-1f3fd',
		':point_up_2_tone4:': '1f446-1f3fe',
		':point_up_2_tone5:': '1f446-1f3ff',
		':point_down:': '1f447',
		':point_down_tone1:': '1f447-1f3fb',
		':point_down_tone2:': '1f447-1f3fc',
		':point_down_tone3:': '1f447-1f3fd',
		':point_down_tone4:': '1f447-1f3fe',
		':point_down_tone5:': '1f447-1f3ff',
		':point_up:': '261d',
		':point_up_tone1:': '261d-1f3fb',
		':point_up_tone2:': '261d-1f3fc',
		':point_up_tone3:': '261d-1f3fd',
		':point_up_tone4:': '261d-1f3fe',
		':point_up_tone5:': '261d-1f3ff',
		':raised_hand:': '270b',
		':raised_hand_tone1:': '270b-1f3fb',
		':raised_hand_tone2:': '270b-1f3fc',
		':raised_hand_tone3:': '270b-1f3fd',
		':raised_hand_tone4:': '270b-1f3fe',
		':raised_hand_tone5:': '270b-1f3ff',
		':raised_back_of_hand:': '1f91a',
		':raised_back_of_hand_tone1:': '1f91a-1f3fb',
		':raised_back_of_hand_tone2:': '1f91a-1f3fc',
		':raised_back_of_hand_tone3:': '1f91a-1f3fd',
		':raised_back_of_hand_tone4:': '1f91a-1f3fe',
		':raised_back_of_hand_tone5:': '1f91a-1f3ff',
		':hand_splayed:': '1f590',
		':hand_splayed_tone1:': '1f590-1f3fb',
		':hand_splayed_tone2:': '1f590-1f3fc',
		':hand_splayed_tone3:': '1f590-1f3fd',
		':hand_splayed_tone4:': '1f590-1f3fe',
		':hand_splayed_tone5:': '1f590-1f3ff',
		':vulcan:': '1f596',
		':vulcan_tone1:': '1f596-1f3fb',
		':vulcan_tone2:': '1f596-1f3fc',
		':vulcan_tone3:': '1f596-1f3fd',
		':vulcan_tone4:': '1f596-1f3fe',
		':vulcan_tone5:': '1f596-1f3ff',
		':wave:': '1f44b',
		':wave_tone1:': '1f44b-1f3fb',
		':wave_tone2:': '1f44b-1f3fc',
		':wave_tone3:': '1f44b-1f3fd',
		':wave_tone4:': '1f44b-1f3fe',
		':wave_tone5:': '1f44b-1f3ff',
		':call_me:': '1f919',
		':call_me_tone1:': '1f919-1f3fb',
		':call_me_tone2:': '1f919-1f3fc',
		':call_me_tone3:': '1f919-1f3fd',
		':call_me_tone4:': '1f919-1f3fe',
		':call_me_tone5:': '1f919-1f3ff',
		':muscle:': '1f4aa',
		':muscle_tone1:': '1f4aa-1f3fb',
		':muscle_tone2:': '1f4aa-1f3fc',
		':muscle_tone3:': '1f4aa-1f3fd',
		':muscle_tone4:': '1f4aa-1f3fe',
		':muscle_tone5:': '1f4aa-1f3ff',
		':leg:': '1f9b5',
		':leg_tone1:': '1f9b5-1f3fb',
		':leg_tone2:': '1f9b5-1f3fc',
		':leg_tone3:': '1f9b5-1f3fd',
		':leg_tone4:': '1f9b5-1f3fe',
		':leg_tone5:': '1f9b5-1f3ff',
		':foot:': '1f9b6',
		':foot_tone1:': '1f9b6-1f3fb',
		':foot_tone2:': '1f9b6-1f3fc',
		':foot_tone3:': '1f9b6-1f3fd',
		':foot_tone4:': '1f9b6-1f3fe',
		':foot_tone5:': '1f9b6-1f3ff',
		':middle_finger:': '1f595',
		':middle_finger_tone1:': '1f595-1f3fb',
		':middle_finger_tone2:': '1f595-1f3fc',
		':middle_finger_tone3:': '1f595-1f3fd',
		':middle_finger_tone4:': '1f595-1f3fe',
		':middle_finger_tone5:': '1f595-1f3ff',
		':writing_hand:': '270d',
		':writing_hand_tone1:': '270d-1f3fb',
		':writing_hand_tone2:': '270d-1f3fc',
		':writing_hand_tone3:': '270d-1f3fd',
		':writing_hand_tone4:': '270d-1f3fe',
		':writing_hand_tone5:': '270d-1f3ff',
		':pray:': '1f64f',
		':pray_tone1:': '1f64f-1f3fb',
		':pray_tone2:': '1f64f-1f3fc',
		':pray_tone3:': '1f64f-1f3fd',
		':pray_tone4:': '1f64f-1f3fe',
		':pray_tone5:': '1f64f-1f3ff',
		':ring:': '1f48d',
		':lipstick:': '1f484',
		':kiss:': '1f48b',
		':lips:': '1f444',
		':tongue:': '1f445',
		':ear:': '1f442',
		':ear_tone1:': '1f442-1f3fb',
		':ear_tone2:': '1f442-1f3fc',
		':ear_tone3:': '1f442-1f3fd',
		':ear_tone4:': '1f442-1f3fe',
		':ear_tone5:': '1f442-1f3ff',
		':nose:': '1f443',
		':nose_tone1:': '1f443-1f3fb',
		':nose_tone2:': '1f443-1f3fc',
		':nose_tone3:': '1f443-1f3fd',
		':nose_tone4:': '1f443-1f3fe',
		':nose_tone5:': '1f443-1f3ff',
		':footprints:': '1f463',
		':eye:': '1f441',
		':eyes:': '1f440',
		':brain:': '1f9e0',
		':bone:': '1f9b4',
		':tooth:': '1f9b7',
		':speaking_head:': '1f5e3',
		':bust_in_silhouette:': '1f464',
		':busts_in_silhouette:': '1f465',
		':baby:': '1f476',
		':baby_tone1:': '1f476-1f3fb',
		':baby_tone2:': '1f476-1f3fc',
		':baby_tone3:': '1f476-1f3fd',
		':baby_tone4:': '1f476-1f3fe',
		':baby_tone5:': '1f476-1f3ff',
		':girl:': '1f467',
		':girl_tone1:': '1f467-1f3fb',
		':girl_tone2:': '1f467-1f3fc',
		':girl_tone3:': '1f467-1f3fd',
		':girl_tone4:': '1f467-1f3fe',
		':girl_tone5:': '1f467-1f3ff',
		':child:': '1f9d2',
		':child_tone1:': '1f9d2-1f3fb',
		':child_tone2:': '1f9d2-1f3fc',
		':child_tone3:': '1f9d2-1f3fd',
		':child_tone4:': '1f9d2-1f3fe',
		':child_tone5:': '1f9d2-1f3ff',
		':boy:': '1f466',
		':boy_tone1:': '1f466-1f3fb',
		':boy_tone2:': '1f466-1f3fc',
		':boy_tone3:': '1f466-1f3fd',
		':boy_tone4:': '1f466-1f3fe',
		':boy_tone5:': '1f466-1f3ff',
		':woman:': '1f469',
		':woman_tone1:': '1f469-1f3fb',
		':woman_tone2:': '1f469-1f3fc',
		':woman_tone3:': '1f469-1f3fd',
		':woman_tone4:': '1f469-1f3fe',
		':woman_tone5:': '1f469-1f3ff',
		':adult:': '1f9d1',
		':adult_tone1:': '1f9d1-1f3fb',
		':adult_tone2:': '1f9d1-1f3fc',
		':adult_tone3:': '1f9d1-1f3fd',
		':adult_tone4:': '1f9d1-1f3fe',
		':adult_tone5:': '1f9d1-1f3ff',
		':man:': '1f468',
		':man_tone1:': '1f468-1f3fb',
		':man_tone2:': '1f468-1f3fc',
		':man_tone3:': '1f468-1f3fd',
		':man_tone4:': '1f468-1f3fe',
		':man_tone5:': '1f468-1f3ff',
		':blond_haired_person:': '1f471',
		':blond_haired_person_tone1:': '1f471-1f3fb',
		':blond_haired_person_tone2:': '1f471-1f3fc',
		':blond_haired_person_tone3:': '1f471-1f3fd',
		':blond_haired_person_tone4:': '1f471-1f3fe',
		':blond_haired_person_tone5:': '1f471-1f3ff',
		':blond-haired_woman:': '1f471-2640',
		':blond-haired_woman_tone1:': '1f471-1f3fb-2640',
		':blond-haired_woman_tone2:': '1f471-1f3fc-2640',
		':blond-haired_woman_tone3:': '1f471-1f3fd-2640',
		':blond-haired_woman_tone4:': '1f471-1f3fe-2640',
		':blond-haired_woman_tone5:': '1f471-1f3ff-2640',
		':blond-haired_man:': '1f471-2642',
		':blond-haired_man_tone1:': '1f471-1f3fb-2642',
		':blond-haired_man_tone2:': '1f471-1f3fc-2642',
		':blond-haired_man_tone3:': '1f471-1f3fd-2642',
		':blond-haired_man_tone4:': '1f471-1f3fe-2642',
		':blond-haired_man_tone5:': '1f471-1f3ff-2642',
		':woman_red_haired:': '1f469-1f9b0',
		':woman_red_haired_tone1:': '1f469-1f3fb-1f9b0',
		':woman_red_haired_tone2:': '1f469-1f3fc-1f9b0',
		':woman_red_haired_tone3:': '1f469-1f3fd-1f9b0',
		':woman_red_haired_tone4:': '1f469-1f3fe-1f9b0',
		':woman_red_haired_tone5:': '1f469-1f3ff-1f9b0',
		':man_red_haired:': '1f468-1f9b0',
		':man_red_haired_tone1:': '1f468-1f3fb-1f9b0',
		':man_red_haired_tone2:': '1f468-1f3fc-1f9b0',
		':man_red_haired_tone3:': '1f468-1f3fd-1f9b0',
		':man_red_haired_tone4:': '1f468-1f3fe-1f9b0',
		':man_red_haired_tone5:': '1f468-1f3ff-1f9b0',
		':woman_curly_haired:': '1f469-1f9b1',
		':woman_curly_haired_tone1:': '1f469-1f3fb-1f9b1',
		':woman_curly_haired_tone2:': '1f469-1f3fc-1f9b1',
		':woman_curly_haired_tone3:': '1f469-1f3fd-1f9b1',
		':woman_curly_haired_tone4:': '1f469-1f3fe-1f9b1',
		':woman_curly_haired_tone5:': '1f469-1f3ff-1f9b1',
		':man_curly_haired:': '1f468-1f9b1',
		':man_curly_haired_tone1:': '1f468-1f3fb-1f9b1',
		':man_curly_haired_tone2:': '1f468-1f3fc-1f9b1',
		':man_curly_haired_tone3:': '1f468-1f3fd-1f9b1',
		':man_curly_haired_tone4:': '1f468-1f3fe-1f9b1',
		':man_curly_haired_tone5:': '1f468-1f3ff-1f9b1',
		':woman_white_haired:': '1f469-1f9b3',
		':woman_white_haired_tone1:': '1f469-1f3fb-1f9b3',
		':woman_white_haired_tone2:': '1f469-1f3fc-1f9b3',
		':woman_white_haired_tone3:': '1f469-1f3fd-1f9b3',
		':woman_white_haired_tone4:': '1f469-1f3fe-1f9b3',
		':woman_white_haired_tone5:': '1f469-1f3ff-1f9b3',
		':man_white_haired:': '1f468-1f9b3',
		':man_white_haired_tone1:': '1f468-1f3fb-1f9b3',
		':man_white_haired_tone2:': '1f468-1f3fc-1f9b3',
		':man_white_haired_tone3:': '1f468-1f3fd-1f9b3',
		':man_white_haired_tone4:': '1f468-1f3fe-1f9b3',
		':man_white_haired_tone5:': '1f468-1f3ff-1f9b3',
		':woman_bald:': '1f469-1f9b2',
		':woman_bald_tone1:': '1f469-1f3fb-1f9b2',
		':woman_bald_tone2:': '1f469-1f3fc-1f9b2',
		':woman_bald_tone3:': '1f469-1f3fd-1f9b2',
		':woman_bald_tone4:': '1f469-1f3fe-1f9b2',
		':woman_bald_tone5:': '1f469-1f3ff-1f9b2',
		':man_bald:': '1f468-1f9b2',
		':man_bald_tone1:': '1f468-1f3fb-1f9b2',
		':man_bald_tone2:': '1f468-1f3fc-1f9b2',
		':man_bald_tone3:': '1f468-1f3fd-1f9b2',
		':man_bald_tone4:': '1f468-1f3fe-1f9b2',
		':man_bald_tone5:': '1f468-1f3ff-1f9b2',
		':bearded_person:': '1f9d4',
		':bearded_person_tone1:': '1f9d4-1f3fb',
		':bearded_person_tone2:': '1f9d4-1f3fc',
		':bearded_person_tone3:': '1f9d4-1f3fd',
		':bearded_person_tone4:': '1f9d4-1f3fe',
		':bearded_person_tone5:': '1f9d4-1f3ff',
		':older_woman:': '1f475',
		':older_woman_tone1:': '1f475-1f3fb',
		':older_woman_tone2:': '1f475-1f3fc',
		':older_woman_tone3:': '1f475-1f3fd',
		':older_woman_tone4:': '1f475-1f3fe',
		':older_woman_tone5:': '1f475-1f3ff',
		':older_adult:': '1f9d3',
		':older_adult_tone1:': '1f9d3-1f3fb',
		':older_adult_tone2:': '1f9d3-1f3fc',
		':older_adult_tone3:': '1f9d3-1f3fd',
		':older_adult_tone4:': '1f9d3-1f3fe',
		':older_adult_tone5:': '1f9d3-1f3ff',
		':older_man:': '1f474',
		':older_man_tone1:': '1f474-1f3fb',
		':older_man_tone2:': '1f474-1f3fc',
		':older_man_tone3:': '1f474-1f3fd',
		':older_man_tone4:': '1f474-1f3fe',
		':older_man_tone5:': '1f474-1f3ff',
		':man_with_chinese_cap:': '1f472',
		':man_with_chinese_cap_tone1:': '1f472-1f3fb',
		':man_with_chinese_cap_tone2:': '1f472-1f3fc',
		':man_with_chinese_cap_tone3:': '1f472-1f3fd',
		':man_with_chinese_cap_tone4:': '1f472-1f3fe',
		':man_with_chinese_cap_tone5:': '1f472-1f3ff',
		':person_wearing_turban:': '1f473',
		':person_wearing_turban_tone1:': '1f473-1f3fb',
		':person_wearing_turban_tone2:': '1f473-1f3fc',
		':person_wearing_turban_tone3:': '1f473-1f3fd',
		':person_wearing_turban_tone4:': '1f473-1f3fe',
		':person_wearing_turban_tone5:': '1f473-1f3ff',
		':woman_wearing_turban:': '1f473-2640',
		':woman_wearing_turban_tone1:': '1f473-1f3fb-2640',
		':woman_wearing_turban_tone2:': '1f473-1f3fc-2640',
		':woman_wearing_turban_tone3:': '1f473-1f3fd-2640',
		':woman_wearing_turban_tone4:': '1f473-1f3fe-2640',
		':woman_wearing_turban_tone5:': '1f473-1f3ff-2640',
		':man_wearing_turban:': '1f473-2642',
		':man_wearing_turban_tone1:': '1f473-1f3fb-2642',
		':man_wearing_turban_tone2:': '1f473-1f3fc-2642',
		':man_wearing_turban_tone3:': '1f473-1f3fd-2642',
		':man_wearing_turban_tone4:': '1f473-1f3fe-2642',
		':man_wearing_turban_tone5:': '1f473-1f3ff-2642',
		':woman_with_headscarf:': '1f9d5',
		':woman_with_headscarf_tone1:': '1f9d5-1f3fb',
		':woman_with_headscarf_tone2:': '1f9d5-1f3fc',
		':woman_with_headscarf_tone3:': '1f9d5-1f3fd',
		':woman_with_headscarf_tone4:': '1f9d5-1f3fe',
		':woman_with_headscarf_tone5:': '1f9d5-1f3ff',
		':police_officer:': '1f46e',
		':police_officer_tone1:': '1f46e-1f3fb',
		':police_officer_tone2:': '1f46e-1f3fc',
		':police_officer_tone3:': '1f46e-1f3fd',
		':police_officer_tone4:': '1f46e-1f3fe',
		':police_officer_tone5:': '1f46e-1f3ff',
		':woman_police_officer:': '1f46e-2640',
		':woman_police_officer_tone1:': '1f46e-1f3fb-2640',
		':woman_police_officer_tone2:': '1f46e-1f3fc-2640',
		':woman_police_officer_tone3:': '1f46e-1f3fd-2640',
		':woman_police_officer_tone4:': '1f46e-1f3fe-2640',
		':woman_police_officer_tone5:': '1f46e-1f3ff-2640',
		':man_police_officer:': '1f46e-2642',
		':man_police_officer_tone1:': '1f46e-1f3fb-2642',
		':man_police_officer_tone2:': '1f46e-1f3fc-2642',
		':man_police_officer_tone3:': '1f46e-1f3fd-2642',
		':man_police_officer_tone4:': '1f46e-1f3fe-2642',
		':man_police_officer_tone5:': '1f46e-1f3ff-2642',
		':construction_worker:': '1f477',
		':construction_worker_tone1:': '1f477-1f3fb',
		':construction_worker_tone2:': '1f477-1f3fc',
		':construction_worker_tone3:': '1f477-1f3fd',
		':construction_worker_tone4:': '1f477-1f3fe',
		':construction_worker_tone5:': '1f477-1f3ff',
		':woman_construction_worker:': '1f477-2640',
		':woman_construction_worker_tone1:': '1f477-1f3fb-2640',
		':woman_construction_worker_tone2:': '1f477-1f3fc-2640',
		':woman_construction_worker_tone3:': '1f477-1f3fd-2640',
		':woman_construction_worker_tone4:': '1f477-1f3fe-2640',
		':woman_construction_worker_tone5:': '1f477-1f3ff-2640',
		':man_construction_worker:': '1f477-2642',
		':man_construction_worker_tone1:': '1f477-1f3fb-2642',
		':man_construction_worker_tone2:': '1f477-1f3fc-2642',
		':man_construction_worker_tone3:': '1f477-1f3fd-2642',
		':man_construction_worker_tone4:': '1f477-1f3fe-2642',
		':man_construction_worker_tone5:': '1f477-1f3ff-2642',
		':guard:': '1f482',
		':guard_tone1:': '1f482-1f3fb',
		':guard_tone2:': '1f482-1f3fc',
		':guard_tone3:': '1f482-1f3fd',
		':guard_tone4:': '1f482-1f3fe',
		':guard_tone5:': '1f482-1f3ff',
		':woman_guard:': '1f482-2640',
		':woman_guard_tone1:': '1f482-1f3fb-2640',
		':woman_guard_tone2:': '1f482-1f3fc-2640',
		':woman_guard_tone3:': '1f482-1f3fd-2640',
		':woman_guard_tone4:': '1f482-1f3fe-2640',
		':woman_guard_tone5:': '1f482-1f3ff-2640',
		':man_guard:': '1f482-2642',
		':man_guard_tone1:': '1f482-1f3fb-2642',
		':man_guard_tone2:': '1f482-1f3fc-2642',
		':man_guard_tone3:': '1f482-1f3fd-2642',
		':man_guard_tone4:': '1f482-1f3fe-2642',
		':man_guard_tone5:': '1f482-1f3ff-2642',
		':detective:': '1f575',
		':detective_tone1:': '1f575-1f3fb',
		':detective_tone2:': '1f575-1f3fc',
		':detective_tone3:': '1f575-1f3fd',
		':detective_tone4:': '1f575-1f3fe',
		':detective_tone5:': '1f575-1f3ff',
		':woman_detective:': '1f575-2640',
		':woman_detective_tone1:': '1f575-1f3fb-2640',
		':woman_detective_tone2:': '1f575-1f3fc-2640',
		':woman_detective_tone3:': '1f575-1f3fd-2640',
		':woman_detective_tone4:': '1f575-1f3fe-2640',
		':woman_detective_tone5:': '1f575-1f3ff-2640',
		':man_detective:': '1f575-2642',
		':man_detective_tone1:': '1f575-1f3fb-2642',
		':man_detective_tone2:': '1f575-1f3fc-2642',
		':man_detective_tone3:': '1f575-1f3fd-2642',
		':man_detective_tone4:': '1f575-1f3fe-2642',
		':man_detective_tone5:': '1f575-1f3ff-2642',
		':woman_health_worker:': '1f469-2695',
		':woman_health_worker_tone1:': '1f469-1f3fb-2695',
		':woman_health_worker_tone2:': '1f469-1f3fc-2695',
		':woman_health_worker_tone3:': '1f469-1f3fd-2695',
		':woman_health_worker_tone4:': '1f469-1f3fe-2695',
		':woman_health_worker_tone5:': '1f469-1f3ff-2695',
		':man_health_worker:': '1f468-2695',
		':man_health_worker_tone1:': '1f468-1f3fb-2695',
		':man_health_worker_tone2:': '1f468-1f3fc-2695',
		':man_health_worker_tone3:': '1f468-1f3fd-2695',
		':man_health_worker_tone4:': '1f468-1f3fe-2695',
		':man_health_worker_tone5:': '1f468-1f3ff-2695',
		':woman_farmer:': '1f469-1f33e',
		':woman_farmer_tone1:': '1f469-1f3fb-1f33e',
		':woman_farmer_tone2:': '1f469-1f3fc-1f33e',
		':woman_farmer_tone3:': '1f469-1f3fd-1f33e',
		':woman_farmer_tone4:': '1f469-1f3fe-1f33e',
		':woman_farmer_tone5:': '1f469-1f3ff-1f33e',
		':man_farmer:': '1f468-1f33e',
		':man_farmer_tone1:': '1f468-1f3fb-1f33e',
		':man_farmer_tone2:': '1f468-1f3fc-1f33e',
		':man_farmer_tone3:': '1f468-1f3fd-1f33e',
		':man_farmer_tone4:': '1f468-1f3fe-1f33e',
		':man_farmer_tone5:': '1f468-1f3ff-1f33e',
		':woman_cook:': '1f469-1f373',
		':woman_cook_tone1:': '1f469-1f3fb-1f373',
		':woman_cook_tone2:': '1f469-1f3fc-1f373',
		':woman_cook_tone3:': '1f469-1f3fd-1f373',
		':woman_cook_tone4:': '1f469-1f3fe-1f373',
		':woman_cook_tone5:': '1f469-1f3ff-1f373',
		':man_cook:': '1f468-1f373',
		':man_cook_tone1:': '1f468-1f3fb-1f373',
		':man_cook_tone2:': '1f468-1f3fc-1f373',
		':man_cook_tone3:': '1f468-1f3fd-1f373',
		':man_cook_tone4:': '1f468-1f3fe-1f373',
		':man_cook_tone5:': '1f468-1f3ff-1f373',
		':woman_student:': '1f469-1f393',
		':woman_student_tone1:': '1f469-1f3fb-1f393',
		':woman_student_tone2:': '1f469-1f3fc-1f393',
		':woman_student_tone3:': '1f469-1f3fd-1f393',
		':woman_student_tone4:': '1f469-1f3fe-1f393',
		':woman_student_tone5:': '1f469-1f3ff-1f393',
		':man_student:': '1f468-1f393',
		':man_student_tone1:': '1f468-1f3fb-1f393',
		':man_student_tone2:': '1f468-1f3fc-1f393',
		':man_student_tone3:': '1f468-1f3fd-1f393',
		':man_student_tone4:': '1f468-1f3fe-1f393',
		':man_student_tone5:': '1f468-1f3ff-1f393',
		':woman_singer:': '1f469-1f3a4',
		':woman_singer_tone1:': '1f469-1f3fb-1f3a4',
		':woman_singer_tone2:': '1f469-1f3fc-1f3a4',
		':woman_singer_tone3:': '1f469-1f3fd-1f3a4',
		':woman_singer_tone4:': '1f469-1f3fe-1f3a4',
		':woman_singer_tone5:': '1f469-1f3ff-1f3a4',
		':man_singer:': '1f468-1f3a4',
		':man_singer_tone1:': '1f468-1f3fb-1f3a4',
		':man_singer_tone2:': '1f468-1f3fc-1f3a4',
		':man_singer_tone3:': '1f468-1f3fd-1f3a4',
		':man_singer_tone4:': '1f468-1f3fe-1f3a4',
		':man_singer_tone5:': '1f468-1f3ff-1f3a4',
		':woman_teacher:': '1f469-1f3eb',
		':woman_teacher_tone1:': '1f469-1f3fb-1f3eb',
		':woman_teacher_tone2:': '1f469-1f3fc-1f3eb',
		':woman_teacher_tone3:': '1f469-1f3fd-1f3eb',
		':woman_teacher_tone4:': '1f469-1f3fe-1f3eb',
		':woman_teacher_tone5:': '1f469-1f3ff-1f3eb',
		':man_teacher:': '1f468-1f3eb',
		':man_teacher_tone1:': '1f468-1f3fb-1f3eb',
		':man_teacher_tone2:': '1f468-1f3fc-1f3eb',
		':man_teacher_tone3:': '1f468-1f3fd-1f3eb',
		':man_teacher_tone4:': '1f468-1f3fe-1f3eb',
		':man_teacher_tone5:': '1f468-1f3ff-1f3eb',
		':woman_factory_worker:': '1f469-1f3ed',
		':woman_factory_worker_tone1:': '1f469-1f3fb-1f3ed',
		':woman_factory_worker_tone2:': '1f469-1f3fc-1f3ed',
		':woman_factory_worker_tone3:': '1f469-1f3fd-1f3ed',
		':woman_factory_worker_tone4:': '1f469-1f3fe-1f3ed',
		':woman_factory_worker_tone5:': '1f469-1f3ff-1f3ed',
		':man_factory_worker:': '1f468-1f3ed',
		':man_factory_worker_tone1:': '1f468-1f3fb-1f3ed',
		':man_factory_worker_tone2:': '1f468-1f3fc-1f3ed',
		':man_factory_worker_tone3:': '1f468-1f3fd-1f3ed',
		':man_factory_worker_tone4:': '1f468-1f3fe-1f3ed',
		':man_factory_worker_tone5:': '1f468-1f3ff-1f3ed',
		':woman_technologist:': '1f469-1f4bb',
		':woman_technologist_tone1:': '1f469-1f3fb-1f4bb',
		':woman_technologist_tone2:': '1f469-1f3fc-1f4bb',
		':woman_technologist_tone3:': '1f469-1f3fd-1f4bb',
		':woman_technologist_tone4:': '1f469-1f3fe-1f4bb',
		':woman_technologist_tone5:': '1f469-1f3ff-1f4bb',
		':man_technologist:': '1f468-1f4bb',
		':man_technologist_tone1:': '1f468-1f3fb-1f4bb',
		':man_technologist_tone2:': '1f468-1f3fc-1f4bb',
		':man_technologist_tone3:': '1f468-1f3fd-1f4bb',
		':man_technologist_tone4:': '1f468-1f3fe-1f4bb',
		':man_technologist_tone5:': '1f468-1f3ff-1f4bb',
		':woman_office_worker:': '1f469-1f4bc',
		':woman_office_worker_tone1:': '1f469-1f3fb-1f4bc',
		':woman_office_worker_tone2:': '1f469-1f3fc-1f4bc',
		':woman_office_worker_tone3:': '1f469-1f3fd-1f4bc',
		':woman_office_worker_tone4:': '1f469-1f3fe-1f4bc',
		':woman_office_worker_tone5:': '1f469-1f3ff-1f4bc',
		':man_office_worker:': '1f468-1f4bc',
		':man_office_worker_tone1:': '1f468-1f3fb-1f4bc',
		':man_office_worker_tone2:': '1f468-1f3fc-1f4bc',
		':man_office_worker_tone3:': '1f468-1f3fd-1f4bc',
		':man_office_worker_tone4:': '1f468-1f3fe-1f4bc',
		':man_office_worker_tone5:': '1f468-1f3ff-1f4bc',
		':woman_mechanic:': '1f469-1f527',
		':woman_mechanic_tone1:': '1f469-1f3fb-1f527',
		':woman_mechanic_tone2:': '1f469-1f3fc-1f527',
		':woman_mechanic_tone3:': '1f469-1f3fd-1f527',
		':woman_mechanic_tone4:': '1f469-1f3fe-1f527',
		':woman_mechanic_tone5:': '1f469-1f3ff-1f527',
		':man_mechanic:': '1f468-1f527',
		':man_mechanic_tone1:': '1f468-1f3fb-1f527',
		':man_mechanic_tone2:': '1f468-1f3fc-1f527',
		':man_mechanic_tone3:': '1f468-1f3fd-1f527',
		':man_mechanic_tone4:': '1f468-1f3fe-1f527',
		':man_mechanic_tone5:': '1f468-1f3ff-1f527',
		':woman_scientist:': '1f469-1f52c',
		':woman_scientist_tone1:': '1f469-1f3fb-1f52c',
		':woman_scientist_tone2:': '1f469-1f3fc-1f52c',
		':woman_scientist_tone3:': '1f469-1f3fd-1f52c',
		':woman_scientist_tone4:': '1f469-1f3fe-1f52c',
		':woman_scientist_tone5:': '1f469-1f3ff-1f52c',
		':man_scientist:': '1f468-1f52c',
		':man_scientist_tone1:': '1f468-1f3fb-1f52c',
		':man_scientist_tone2:': '1f468-1f3fc-1f52c',
		':man_scientist_tone3:': '1f468-1f3fd-1f52c',
		':man_scientist_tone4:': '1f468-1f3fe-1f52c',
		':man_scientist_tone5:': '1f468-1f3ff-1f52c',
		':woman_artist:': '1f469-1f3a8',
		':woman_artist_tone1:': '1f469-1f3fb-1f3a8',
		':woman_artist_tone2:': '1f469-1f3fc-1f3a8',
		':woman_artist_tone3:': '1f469-1f3fd-1f3a8',
		':woman_artist_tone4:': '1f469-1f3fe-1f3a8',
		':woman_artist_tone5:': '1f469-1f3ff-1f3a8',
		':man_artist:': '1f468-1f3a8',
		':man_artist_tone1:': '1f468-1f3fb-1f3a8',
		':man_artist_tone2:': '1f468-1f3fc-1f3a8',
		':man_artist_tone3:': '1f468-1f3fd-1f3a8',
		':man_artist_tone4:': '1f468-1f3fe-1f3a8',
		':man_artist_tone5:': '1f468-1f3ff-1f3a8',
		':woman_firefighter:': '1f469-1f692',
		':woman_firefighter_tone1:': '1f469-1f3fb-1f692',
		':woman_firefighter_tone2:': '1f469-1f3fc-1f692',
		':woman_firefighter_tone3:': '1f469-1f3fd-1f692',
		':woman_firefighter_tone4:': '1f469-1f3fe-1f692',
		':woman_firefighter_tone5:': '1f469-1f3ff-1f692',
		':man_firefighter:': '1f468-1f692',
		':man_firefighter_tone1:': '1f468-1f3fb-1f692',
		':man_firefighter_tone2:': '1f468-1f3fc-1f692',
		':man_firefighter_tone3:': '1f468-1f3fd-1f692',
		':man_firefighter_tone4:': '1f468-1f3fe-1f692',
		':man_firefighter_tone5:': '1f468-1f3ff-1f692',
		':woman_pilot:': '1f469-2708',
		':woman_pilot_tone1:': '1f469-1f3fb-2708',
		':woman_pilot_tone2:': '1f469-1f3fc-2708',
		':woman_pilot_tone3:': '1f469-1f3fd-2708',
		':woman_pilot_tone4:': '1f469-1f3fe-2708',
		':woman_pilot_tone5:': '1f469-1f3ff-2708',
		':man_pilot:': '1f468-2708',
		':man_pilot_tone1:': '1f468-1f3fb-2708',
		':man_pilot_tone2:': '1f468-1f3fc-2708',
		':man_pilot_tone3:': '1f468-1f3fd-2708',
		':man_pilot_tone4:': '1f468-1f3fe-2708',
		':man_pilot_tone5:': '1f468-1f3ff-2708',
		':woman_astronaut:': '1f469-1f680',
		':woman_astronaut_tone1:': '1f469-1f3fb-1f680',
		':woman_astronaut_tone2:': '1f469-1f3fc-1f680',
		':woman_astronaut_tone3:': '1f469-1f3fd-1f680',
		':woman_astronaut_tone4:': '1f469-1f3fe-1f680',
		':woman_astronaut_tone5:': '1f469-1f3ff-1f680',
		':man_astronaut:': '1f468-1f680',
		':man_astronaut_tone1:': '1f468-1f3fb-1f680',
		':man_astronaut_tone2:': '1f468-1f3fc-1f680',
		':man_astronaut_tone3:': '1f468-1f3fd-1f680',
		':man_astronaut_tone4:': '1f468-1f3fe-1f680',
		':man_astronaut_tone5:': '1f468-1f3ff-1f680',
		':woman_judge:': '1f469-2696',
		':woman_judge_tone1:': '1f469-1f3fb-2696',
		':woman_judge_tone2:': '1f469-1f3fc-2696',
		':woman_judge_tone3:': '1f469-1f3fd-2696',
		':woman_judge_tone4:': '1f469-1f3fe-2696',
		':woman_judge_tone5:': '1f469-1f3ff-2696',
		':man_judge:': '1f468-2696',
		':man_judge_tone1:': '1f468-1f3fb-2696',
		':man_judge_tone2:': '1f468-1f3fc-2696',
		':man_judge_tone3:': '1f468-1f3fd-2696',
		':man_judge_tone4:': '1f468-1f3fe-2696',
		':man_judge_tone5:': '1f468-1f3ff-2696',
		':bride_with_veil:': '1f470',
		':bride_with_veil_tone1:': '1f470-1f3fb',
		':bride_with_veil_tone2:': '1f470-1f3fc',
		':bride_with_veil_tone3:': '1f470-1f3fd',
		':bride_with_veil_tone4:': '1f470-1f3fe',
		':bride_with_veil_tone5:': '1f470-1f3ff',
		':man_in_tuxedo:': '1f935',
		':man_in_tuxedo_tone1:': '1f935-1f3fb',
		':man_in_tuxedo_tone2:': '1f935-1f3fc',
		':man_in_tuxedo_tone3:': '1f935-1f3fd',
		':man_in_tuxedo_tone4:': '1f935-1f3fe',
		':man_in_tuxedo_tone5:': '1f935-1f3ff',
		':princess:': '1f478',
		':princess_tone1:': '1f478-1f3fb',
		':princess_tone2:': '1f478-1f3fc',
		':princess_tone3:': '1f478-1f3fd',
		':princess_tone4:': '1f478-1f3fe',
		':princess_tone5:': '1f478-1f3ff',
		':prince:': '1f934',
		':prince_tone1:': '1f934-1f3fb',
		':prince_tone2:': '1f934-1f3fc',
		':prince_tone3:': '1f934-1f3fd',
		':prince_tone4:': '1f934-1f3fe',
		':prince_tone5:': '1f934-1f3ff',
		':mrs_claus:': '1f936',
		':mrs_claus_tone1:': '1f936-1f3fb',
		':mrs_claus_tone3:': '1f936-1f3fd',
		':mrs_claus_tone2:': '1f936-1f3fc',
		':mrs_claus_tone4:': '1f936-1f3fe',
		':mrs_claus_tone5:': '1f936-1f3ff',
		':santa:': '1f385',
		':santa_tone1:': '1f385-1f3fb',
		':santa_tone2:': '1f385-1f3fc',
		':santa_tone3:': '1f385-1f3fd',
		':santa_tone4:': '1f385-1f3fe',
		':santa_tone5:': '1f385-1f3ff',
		':superhero:': '1f9b8',
		':superhero_tone1:': '1f9b8-1f3fb',
		':superhero_tone2:': '1f9b8-1f3fc',
		':superhero_tone3:': '1f9b8-1f3fd',
		':superhero_tone4:': '1f9b8-1f3fe',
		':superhero_tone5:': '1f9b8-1f3ff',
		':woman_superhero:': '1f9b8-2640',
		':woman_superhero_tone1:': '1f9b8-1f3fb-2640',
		':woman_superhero_tone2:': '1f9b8-1f3fc-2640',
		':woman_superhero_tone3:': '1f9b8-1f3fd-2640',
		':woman_superhero_tone4:': '1f9b8-1f3fe-2640',
		':woman_superhero_tone5:': '1f9b8-1f3ff-2640',
		':man_superhero:': '1f9b8-2642',
		':man_superhero_tone1:': '1f9b8-1f3fb-2642',
		':man_superhero_tone2:': '1f9b8-1f3fc-2642',
		':man_superhero_tone3:': '1f9b8-1f3fd-2642',
		':man_superhero_tone4:': '1f9b8-1f3fe-2642',
		':man_superhero_tone5:': '1f9b8-1f3ff-2642',
		':supervillain:': '1f9b9',
		':supervillain_tone1:': '1f9b9-1f3fb',
		':supervillain_tone2:': '1f9b9-1f3fc',
		':supervillain_tone3:': '1f9b9-1f3fd',
		':supervillain_tone4:': '1f9b9-1f3fe',
		':supervillain_tone5:': '1f9b9-1f3ff',
		':woman_supervillain_tone1:': '1f9b9-1f3fb-2640',
		':woman_supervillain:': '1f9b9-2640',
		':woman_supervillain_tone2:': '1f9b9-1f3fc-2640',
		':woman_supervillain_tone3:': '1f9b9-1f3fd-2640',
		':woman_supervillain_tone4:': '1f9b9-1f3fe-2640',
		':woman_supervillain_tone5:': '1f9b9-1f3ff-2640',
		':man_supervillain:': '1f9b9-2642',
		':man_supervillain_tone1:': '1f9b9-1f3fb-2642',
		':man_supervillain_tone2:': '1f9b9-1f3fc-2642',
		':man_supervillain_tone3:': '1f9b9-1f3fd-2642',
		':man_supervillain_tone4:': '1f9b9-1f3fe-2642',
		':man_supervillain_tone5:': '1f9b9-1f3ff-2642',
		':mage:': '1f9d9',
		':mage_tone1:': '1f9d9-1f3fb',
		':mage_tone2:': '1f9d9-1f3fc',
		':mage_tone3:': '1f9d9-1f3fd',
		':mage_tone4:': '1f9d9-1f3fe',
		':mage_tone5:': '1f9d9-1f3ff',
		':woman_mage:': '1f9d9-2640',
		':woman_mage_tone1:': '1f9d9-1f3fb-2640',
		':woman_mage_tone2:': '1f9d9-1f3fc-2640',
		':woman_mage_tone3:': '1f9d9-1f3fd-2640',
		':woman_mage_tone4:': '1f9d9-1f3fe-2640',
		':woman_mage_tone5:': '1f9d9-1f3ff-2640',
		':man_mage:': '1f9d9-2642',
		':man_mage_tone1:': '1f9d9-1f3fb-2642',
		':man_mage_tone2:': '1f9d9-1f3fc-2642',
		':man_mage_tone3:': '1f9d9-1f3fd-2642',
		':man_mage_tone4:': '1f9d9-1f3fe-2642',
		':man_mage_tone5:': '1f9d9-1f3ff-2642',
		':elf:': '1f9dd',
		':elf_tone1:': '1f9dd-1f3fb',
		':elf_tone2:': '1f9dd-1f3fc',
		':elf_tone3:': '1f9dd-1f3fd',
		':elf_tone4:': '1f9dd-1f3fe',
		':elf_tone5:': '1f9dd-1f3ff',
		':woman_elf:': '1f9dd-2640',
		':woman_elf_tone1:': '1f9dd-1f3fb-2640',
		':woman_elf_tone2:': '1f9dd-1f3fc-2640',
		':woman_elf_tone3:': '1f9dd-1f3fd-2640',
		':woman_elf_tone4:': '1f9dd-1f3fe-2640',
		':woman_elf_tone5:': '1f9dd-1f3ff-2640',
		':man_elf:': '1f9dd-2642',
		':man_elf_tone1:': '1f9dd-1f3fb-2642',
		':man_elf_tone2:': '1f9dd-1f3fc-2642',
		':man_elf_tone3:': '1f9dd-1f3fd-2642',
		':man_elf_tone4:': '1f9dd-1f3fe-2642',
		':man_elf_tone5:': '1f9dd-1f3ff-2642',
		':vampire:': '1f9db',
		':vampire_tone1:': '1f9db-1f3fb',
		':vampire_tone2:': '1f9db-1f3fc',
		':vampire_tone3:': '1f9db-1f3fd',
		':vampire_tone4:': '1f9db-1f3fe',
		':vampire_tone5:': '1f9db-1f3ff',
		':woman_vampire:': '1f9db-2640',
		':woman_vampire_tone1:': '1f9db-1f3fb-2640',
		':woman_vampire_tone2:': '1f9db-1f3fc-2640',
		':woman_vampire_tone3:': '1f9db-1f3fd-2640',
		':woman_vampire_tone4:': '1f9db-1f3fe-2640',
		':woman_vampire_tone5:': '1f9db-1f3ff-2640',
		':man_vampire:': '1f9db-2642',
		':man_vampire_tone1:': '1f9db-1f3fb-2642',
		':man_vampire_tone2:': '1f9db-1f3fc-2642',
		':man_vampire_tone3:': '1f9db-1f3fd-2642',
		':man_vampire_tone4:': '1f9db-1f3fe-2642',
		':man_vampire_tone5:': '1f9db-1f3ff-2642',
		':zombie:': '1f9df',
		':woman_zombie:': '1f9df-2640',
		':man_zombie:': '1f9df-2642',
		':genie:': '1f9de',
		':woman_genie:': '1f9de-2640',
		':man_genie:': '1f9de-2642',
		':merperson:': '1f9dc',
		':merperson_tone1:': '1f9dc-1f3fb',
		':merperson_tone2:': '1f9dc-1f3fc',
		':merperson_tone3:': '1f9dc-1f3fd',
		':merperson_tone4:': '1f9dc-1f3fe',
		':merperson_tone5:': '1f9dc-1f3ff',
		':mermaid:': '1f9dc-2640',
		':mermaid_tone1:': '1f9dc-1f3fb-2640',
		':mermaid_tone2:': '1f9dc-1f3fc-2640',
		':mermaid_tone3:': '1f9dc-1f3fd-2640',
		':mermaid_tone4:': '1f9dc-1f3fe-2640',
		':mermaid_tone5:': '1f9dc-1f3ff-2640',
		':merman:': '1f9dc-2642',
		':merman_tone1:': '1f9dc-1f3fb-2642',
		':merman_tone2:': '1f9dc-1f3fc-2642',
		':merman_tone3:': '1f9dc-1f3fd-2642',
		':merman_tone4:': '1f9dc-1f3fe-2642',
		':merman_tone5:': '1f9dc-1f3ff-2642',
		':fairy:': '1f9da',
		':fairy_tone1:': '1f9da-1f3fb',
		':fairy_tone2:': '1f9da-1f3fc',
		':fairy_tone3:': '1f9da-1f3fd',
		':fairy_tone4:': '1f9da-1f3fe',
		':fairy_tone5:': '1f9da-1f3ff',
		':woman_fairy:': '1f9da-2640',
		':woman_fairy_tone1:': '1f9da-1f3fb-2640',
		':woman_fairy_tone2:': '1f9da-1f3fc-2640',
		':woman_fairy_tone3:': '1f9da-1f3fd-2640',
		':woman_fairy_tone4:': '1f9da-1f3fe-2640',
		':woman_fairy_tone5:': '1f9da-1f3ff-2640',
		':man_fairy:': '1f9da-2642',
		':man_fairy_tone1:': '1f9da-1f3fb-2642',
		':man_fairy_tone2:': '1f9da-1f3fc-2642',
		':man_fairy_tone3:': '1f9da-1f3fd-2642',
		':man_fairy_tone4:': '1f9da-1f3fe-2642',
		':man_fairy_tone5:': '1f9da-1f3ff-2642',
		':angel:': '1f47c',
		':angel_tone1:': '1f47c-1f3fb',
		':angel_tone2:': '1f47c-1f3fc',
		':angel_tone3:': '1f47c-1f3fd',
		':angel_tone4:': '1f47c-1f3fe',
		':angel_tone5:': '1f47c-1f3ff',
		':pregnant_woman:': '1f930',
		':pregnant_woman_tone1:': '1f930-1f3fb',
		':pregnant_woman_tone2:': '1f930-1f3fc',
		':pregnant_woman_tone3:': '1f930-1f3fd',
		':pregnant_woman_tone4:': '1f930-1f3fe',
		':pregnant_woman_tone5:': '1f930-1f3ff',
		':breast_feeding:': '1f931',
		':breast_feeding_tone1:': '1f931-1f3fb',
		':breast_feeding_tone2:': '1f931-1f3fc',
		':breast_feeding_tone3:': '1f931-1f3fd',
		':breast_feeding_tone4:': '1f931-1f3fe',
		':breast_feeding_tone5:': '1f931-1f3ff',
		':person_bowing:': '1f647',
		':person_bowing_tone1:': '1f647-1f3fb',
		':person_bowing_tone2:': '1f647-1f3fc',
		':person_bowing_tone3:': '1f647-1f3fd',
		':person_bowing_tone4:': '1f647-1f3fe',
		':person_bowing_tone5:': '1f647-1f3ff',
		':woman_bowing:': '1f647-2640',
		':woman_bowing_tone1:': '1f647-1f3fb-2640',
		':woman_bowing_tone2:': '1f647-1f3fc-2640',
		':woman_bowing_tone3:': '1f647-1f3fd-2640',
		':woman_bowing_tone4:': '1f647-1f3fe-2640',
		':woman_bowing_tone5:': '1f647-1f3ff-2640',
		':man_bowing:': '1f647-2642',
		':man_bowing_tone1:': '1f647-1f3fb-2642',
		':man_bowing_tone2:': '1f647-1f3fc-2642',
		':man_bowing_tone3:': '1f647-1f3fd-2642',
		':man_bowing_tone4:': '1f647-1f3fe-2642',
		':man_bowing_tone5:': '1f647-1f3ff-2642',
		':person_tipping_hand:': '1f481',
		':person_tipping_hand_tone1:': '1f481-1f3fb',
		':person_tipping_hand_tone2:': '1f481-1f3fc',
		':person_tipping_hand_tone3:': '1f481-1f3fd',
		':person_tipping_hand_tone4:': '1f481-1f3fe',
		':person_tipping_hand_tone5:': '1f481-1f3ff',
		':woman_tipping_hand:': '1f481-2640',
		':woman_tipping_hand_tone1:': '1f481-1f3fb-2640',
		':woman_tipping_hand_tone2:': '1f481-1f3fc-2640',
		':woman_tipping_hand_tone3:': '1f481-1f3fd-2640',
		':woman_tipping_hand_tone4:': '1f481-1f3fe-2640',
		':woman_tipping_hand_tone5:': '1f481-1f3ff-2640',
		':man_tipping_hand:': '1f481-2642',
		':man_tipping_hand_tone1:': '1f481-1f3fb-2642',
		':man_tipping_hand_tone2:': '1f481-1f3fc-2642',
		':man_tipping_hand_tone3:': '1f481-1f3fd-2642',
		':man_tipping_hand_tone4:': '1f481-1f3fe-2642',
		':man_tipping_hand_tone5:': '1f481-1f3ff-2642',
		':person_gesturing_no:': '1f645',
		':person_gesturing_no_tone1:': '1f645-1f3fb',
		':person_gesturing_no_tone2:': '1f645-1f3fc',
		':person_gesturing_no_tone3:': '1f645-1f3fd',
		':person_gesturing_no_tone4:': '1f645-1f3fe',
		':person_gesturing_no_tone5:': '1f645-1f3ff',
		':woman_gesturing_no:': '1f645-2640',
		':woman_gesturing_no_tone1:': '1f645-1f3fb-2640',
		':woman_gesturing_no_tone2:': '1f645-1f3fc-2640',
		':woman_gesturing_no_tone3:': '1f645-1f3fd-2640',
		':woman_gesturing_no_tone4:': '1f645-1f3fe-2640',
		':woman_gesturing_no_tone5:': '1f645-1f3ff-2640',
		':man_gesturing_no:': '1f645-2642',
		':man_gesturing_no_tone1:': '1f645-1f3fb-2642',
		':man_gesturing_no_tone2:': '1f645-1f3fc-2642',
		':man_gesturing_no_tone3:': '1f645-1f3fd-2642',
		':man_gesturing_no_tone4:': '1f645-1f3fe-2642',
		':man_gesturing_no_tone5:': '1f645-1f3ff-2642',
		':person_gesturing_ok:': '1f646',
		':person_gesturing_ok_tone1:': '1f646-1f3fb',
		':person_gesturing_ok_tone2:': '1f646-1f3fc',
		':person_gesturing_ok_tone3:': '1f646-1f3fd',
		':person_gesturing_ok_tone4:': '1f646-1f3fe',
		':person_gesturing_ok_tone5:': '1f646-1f3ff',
		':woman_gesturing_ok:': '1f646-2640',
		':woman_gesturing_ok_tone1:': '1f646-1f3fb-2640',
		':woman_gesturing_ok_tone2:': '1f646-1f3fc-2640',
		':woman_gesturing_ok_tone3:': '1f646-1f3fd-2640',
		':woman_gesturing_ok_tone4:': '1f646-1f3fe-2640',
		':woman_gesturing_ok_tone5:': '1f646-1f3ff-2640',
		':man_gesturing_ok:': '1f646-2642',
		':man_gesturing_ok_tone1:': '1f646-1f3fb-2642',
		':man_gesturing_ok_tone2:': '1f646-1f3fc-2642',
		':man_gesturing_ok_tone3:': '1f646-1f3fd-2642',
		':man_gesturing_ok_tone4:': '1f646-1f3fe-2642',
		':man_gesturing_ok_tone5:': '1f646-1f3ff-2642',
		':person_raising_hand:': '1f64b',
		':person_raising_hand_tone1:': '1f64b-1f3fb',
		':person_raising_hand_tone2:': '1f64b-1f3fc',
		':person_raising_hand_tone3:': '1f64b-1f3fd',
		':person_raising_hand_tone4:': '1f64b-1f3fe',
		':person_raising_hand_tone5:': '1f64b-1f3ff',
		':woman_raising_hand:': '1f64b-2640',
		':woman_raising_hand_tone1:': '1f64b-1f3fb-2640',
		':woman_raising_hand_tone2:': '1f64b-1f3fc-2640',
		':woman_raising_hand_tone3:': '1f64b-1f3fd-2640',
		':woman_raising_hand_tone4:': '1f64b-1f3fe-2640',
		':woman_raising_hand_tone5:': '1f64b-1f3ff-2640',
		':man_raising_hand:': '1f64b-2642',
		':man_raising_hand_tone1:': '1f64b-1f3fb-2642',
		':man_raising_hand_tone2:': '1f64b-1f3fc-2642',
		':man_raising_hand_tone3:': '1f64b-1f3fd-2642',
		':man_raising_hand_tone4:': '1f64b-1f3fe-2642',
		':man_raising_hand_tone5:': '1f64b-1f3ff-2642',
		':person_facepalming:': '1f926',
		':person_facepalming_tone1:': '1f926-1f3fb',
		':person_facepalming_tone2:': '1f926-1f3fc',
		':person_facepalming_tone3:': '1f926-1f3fd',
		':person_facepalming_tone4:': '1f926-1f3fe',
		':person_facepalming_tone5:': '1f926-1f3ff',
		':woman_facepalming:': '1f926-2640',
		':woman_facepalming_tone1:': '1f926-1f3fb-2640',
		':woman_facepalming_tone2:': '1f926-1f3fc-2640',
		':woman_facepalming_tone3:': '1f926-1f3fd-2640',
		':woman_facepalming_tone4:': '1f926-1f3fe-2640',
		':woman_facepalming_tone5:': '1f926-1f3ff-2640',
		':man_facepalming:': '1f926-2642',
		':man_facepalming_tone1:': '1f926-1f3fb-2642',
		':man_facepalming_tone2:': '1f926-1f3fc-2642',
		':man_facepalming_tone3:': '1f926-1f3fd-2642',
		':man_facepalming_tone4:': '1f926-1f3fe-2642',
		':man_facepalming_tone5:': '1f926-1f3ff-2642',
		':person_shrugging:': '1f937',
		':person_shrugging_tone1:': '1f937-1f3fb',
		':person_shrugging_tone2:': '1f937-1f3fc',
		':person_shrugging_tone3:': '1f937-1f3fd',
		':person_shrugging_tone4:': '1f937-1f3fe',
		':person_shrugging_tone5:': '1f937-1f3ff',
		':woman_shrugging:': '1f937-2640',
		':woman_shrugging_tone1:': '1f937-1f3fb-2640',
		':woman_shrugging_tone2:': '1f937-1f3fc-2640',
		':woman_shrugging_tone3:': '1f937-1f3fd-2640',
		':woman_shrugging_tone4:': '1f937-1f3fe-2640',
		':woman_shrugging_tone5:': '1f937-1f3ff-2640',
		':man_shrugging:': '1f937-2642',
		':man_shrugging_tone1:': '1f937-1f3fb-2642',
		':man_shrugging_tone2:': '1f937-1f3fc-2642',
		':man_shrugging_tone3:': '1f937-1f3fd-2642',
		':man_shrugging_tone4:': '1f937-1f3fe-2642',
		':man_shrugging_tone5:': '1f937-1f3ff-2642',
		':person_pouting:': '1f64e',
		':person_pouting_tone1:': '1f64e-1f3fb',
		':person_pouting_tone2:': '1f64e-1f3fc',
		':person_pouting_tone3:': '1f64e-1f3fd',
		':person_pouting_tone4:': '1f64e-1f3fe',
		':person_pouting_tone5:': '1f64e-1f3ff',
		':woman_pouting:': '1f64e-2640',
		':woman_pouting_tone1:': '1f64e-1f3fb-2640',
		':woman_pouting_tone2:': '1f64e-1f3fc-2640',
		':woman_pouting_tone3:': '1f64e-1f3fd-2640',
		':woman_pouting_tone4:': '1f64e-1f3fe-2640',
		':woman_pouting_tone5:': '1f64e-1f3ff-2640',
		':man_pouting:': '1f64e-2642',
		':man_pouting_tone1:': '1f64e-1f3fb-2642',
		':man_pouting_tone2:': '1f64e-1f3fc-2642',
		':man_pouting_tone3:': '1f64e-1f3fd-2642',
		':man_pouting_tone4:': '1f64e-1f3fe-2642',
		':man_pouting_tone5:': '1f64e-1f3ff-2642',
		':person_frowning:': '1f64d',
		':person_frowning_tone1:': '1f64d-1f3fb',
		':person_frowning_tone2:': '1f64d-1f3fc',
		':person_frowning_tone3:': '1f64d-1f3fd',
		':person_frowning_tone4:': '1f64d-1f3fe',
		':person_frowning_tone5:': '1f64d-1f3ff',
		':woman_frowning:': '1f64d-2640',
		':woman_frowning_tone1:': '1f64d-1f3fb-2640',
		':woman_frowning_tone2:': '1f64d-1f3fc-2640',
		':woman_frowning_tone3:': '1f64d-1f3fd-2640',
		':woman_frowning_tone4:': '1f64d-1f3fe-2640',
		':woman_frowning_tone5:': '1f64d-1f3ff-2640',
		':man_frowning:': '1f64d-2642',
		':man_frowning_tone1:': '1f64d-1f3fb-2642',
		':man_frowning_tone2:': '1f64d-1f3fc-2642',
		':man_frowning_tone3:': '1f64d-1f3fd-2642',
		':man_frowning_tone4:': '1f64d-1f3fe-2642',
		':man_frowning_tone5:': '1f64d-1f3ff-2642',
		':person_getting_haircut:': '1f487',
		':person_getting_haircut_tone1:': '1f487-1f3fb',
		':person_getting_haircut_tone2:': '1f487-1f3fc',
		':person_getting_haircut_tone3:': '1f487-1f3fd',
		':person_getting_haircut_tone4:': '1f487-1f3fe',
		':person_getting_haircut_tone5:': '1f487-1f3ff',
		':woman_getting_haircut:': '1f487-2640',
		':woman_getting_haircut_tone1:': '1f487-1f3fb-2640',
		':woman_getting_haircut_tone2:': '1f487-1f3fc-2640',
		':woman_getting_haircut_tone3:': '1f487-1f3fd-2640',
		':woman_getting_haircut_tone4:': '1f487-1f3fe-2640',
		':woman_getting_haircut_tone5:': '1f487-1f3ff-2640',
		':man_getting_haircut:': '1f487-2642',
		':man_getting_haircut_tone1:': '1f487-1f3fb-2642',
		':man_getting_haircut_tone2:': '1f487-1f3fc-2642',
		':man_getting_haircut_tone3:': '1f487-1f3fd-2642',
		':man_getting_haircut_tone4:': '1f487-1f3fe-2642',
		':man_getting_haircut_tone5:': '1f487-1f3ff-2642',
		':person_getting_massage:': '1f486',
		':person_getting_massage_tone1:': '1f486-1f3fb',
		':person_getting_massage_tone2:': '1f486-1f3fc',
		':person_getting_massage_tone3:': '1f486-1f3fd',
		':person_getting_massage_tone4:': '1f486-1f3fe',
		':person_getting_massage_tone5:': '1f486-1f3ff',
		':woman_getting_face_massage:': '1f486-2640',
		':woman_getting_face_massage_tone1:': '1f486-1f3fb-2640',
		':woman_getting_face_massage_tone2:': '1f486-1f3fc-2640',
		':woman_getting_face_massage_tone3:': '1f486-1f3fd-2640',
		':woman_getting_face_massage_tone4:': '1f486-1f3fe-2640',
		':woman_getting_face_massage_tone5:': '1f486-1f3ff-2640',
		':man_getting_face_massage:': '1f486-2642',
		':man_getting_face_massage_tone1:': '1f486-1f3fb-2642',
		':man_getting_face_massage_tone2:': '1f486-1f3fc-2642',
		':man_getting_face_massage_tone3:': '1f486-1f3fd-2642',
		':man_getting_face_massage_tone4:': '1f486-1f3fe-2642',
		':man_getting_face_massage_tone5:': '1f486-1f3ff-2642',
		':person_in_steamy_room:': '1f9d6',
		':person_in_steamy_room_tone1:': '1f9d6-1f3fb',
		':person_in_steamy_room_tone2:': '1f9d6-1f3fc',
		':person_in_steamy_room_tone3:': '1f9d6-1f3fd',
		':person_in_steamy_room_tone4:': '1f9d6-1f3fe',
		':person_in_steamy_room_tone5:': '1f9d6-1f3ff',
		':woman_in_steamy_room:': '1f9d6-2640',
		':woman_in_steamy_room_tone1:': '1f9d6-1f3fb-2640',
		':woman_in_steamy_room_tone2:': '1f9d6-1f3fc-2640',
		':woman_in_steamy_room_tone3:': '1f9d6-1f3fd-2640',
		':woman_in_steamy_room_tone4:': '1f9d6-1f3fe-2640',
		':woman_in_steamy_room_tone5:': '1f9d6-1f3ff-2640',
		':man_in_steamy_room:': '1f9d6-2642',
		':man_in_steamy_room_tone1:': '1f9d6-1f3fb-2642',
		':man_in_steamy_room_tone2:': '1f9d6-1f3fc-2642',
		':man_in_steamy_room_tone3:': '1f9d6-1f3fd-2642',
		':man_in_steamy_room_tone4:': '1f9d6-1f3fe-2642',
		':man_in_steamy_room_tone5:': '1f9d6-1f3ff-2642',
		':nail_care:': '1f485',
		':nail_care_tone1:': '1f485-1f3fb',
		':nail_care_tone2:': '1f485-1f3fc',
		':nail_care_tone3:': '1f485-1f3fd',
		':nail_care_tone4:': '1f485-1f3fe',
		':nail_care_tone5:': '1f485-1f3ff',
		':selfie:': '1f933',
		':selfie_tone1:': '1f933-1f3fb',
		':selfie_tone2:': '1f933-1f3fc',
		':selfie_tone3:': '1f933-1f3fd',
		':selfie_tone4:': '1f933-1f3fe',
		':selfie_tone5:': '1f933-1f3ff',
		':dancer:': '1f483',
		':dancer_tone1:': '1f483-1f3fb',
		':dancer_tone2:': '1f483-1f3fc',
		':dancer_tone3:': '1f483-1f3fd',
		':dancer_tone4:': '1f483-1f3fe',
		':dancer_tone5:': '1f483-1f3ff',
		':man_dancing:': '1f57a',
		':man_dancing_tone1:': '1f57a-1f3fb',
		':man_dancing_tone2:': '1f57a-1f3fc',
		':man_dancing_tone3:': '1f57a-1f3fd',
		':man_dancing_tone5:': '1f57a-1f3ff',
		':man_dancing_tone4:': '1f57a-1f3fe',
		':people_with_bunny_ears_partying:': '1f46f',
		':women_with_bunny_ears_partying:': '1f46f-2640',
		':men_with_bunny_ears_partying:': '1f46f-2642',
		':levitate:': '1f574',
		':levitate_tone1:': '1f574-1f3fb',
		':levitate_tone2:': '1f574-1f3fc',
		':levitate_tone3:': '1f574-1f3fd',
		':levitate_tone4:': '1f574-1f3fe',
		':levitate_tone5:': '1f574-1f3ff',
		':person_walking:': '1f6b6',
		':person_walking_tone1:': '1f6b6-1f3fb',
		':person_walking_tone2:': '1f6b6-1f3fc',
		':person_walking_tone3:': '1f6b6-1f3fd',
		':person_walking_tone4:': '1f6b6-1f3fe',
		':person_walking_tone5:': '1f6b6-1f3ff',
		':woman_walking:': '1f6b6-2640',
		':woman_walking_tone1:': '1f6b6-1f3fb-2640',
		':woman_walking_tone2:': '1f6b6-1f3fc-2640',
		':woman_walking_tone3:': '1f6b6-1f3fd-2640',
		':woman_walking_tone4:': '1f6b6-1f3fe-2640',
		':woman_walking_tone5:': '1f6b6-1f3ff-2640',
		':man_walking:': '1f6b6-2642',
		':man_walking_tone1:': '1f6b6-1f3fb-2642',
		':man_walking_tone2:': '1f6b6-1f3fc-2642',
		':man_walking_tone3:': '1f6b6-1f3fd-2642',
		':man_walking_tone4:': '1f6b6-1f3fe-2642',
		':man_walking_tone5:': '1f6b6-1f3ff-2642',
		':person_running:': '1f3c3',
		':person_running_tone1:': '1f3c3-1f3fb',
		':person_running_tone2:': '1f3c3-1f3fc',
		':person_running_tone3:': '1f3c3-1f3fd',
		':person_running_tone4:': '1f3c3-1f3fe',
		':person_running_tone5:': '1f3c3-1f3ff',
		':woman_running:': '1f3c3-2640',
		':woman_running_tone1:': '1f3c3-1f3fb-2640',
		':woman_running_tone2:': '1f3c3-1f3fc-2640',
		':woman_running_tone3:': '1f3c3-1f3fd-2640',
		':woman_running_tone4:': '1f3c3-1f3fe-2640',
		':woman_running_tone5:': '1f3c3-1f3ff-2640',
		':man_running:': '1f3c3-2642',
		':man_running_tone1:': '1f3c3-1f3fb-2642',
		':man_running_tone2:': '1f3c3-1f3fc-2642',
		':man_running_tone3:': '1f3c3-1f3fd-2642',
		':man_running_tone4:': '1f3c3-1f3fe-2642',
		':man_running_tone5:': '1f3c3-1f3ff-2642',
		':couple:': '1f46b',
		':two_women_holding_hands:': '1f46d',
		':two_men_holding_hands:': '1f46c',
		':couple_with_heart:': '1f491',
		':couple_with_heart_woman_man:': '1f469-2764-1f468',
		':couple_ww:': '1f469-2764-1f469',
		':couple_mm:': '1f468-2764-1f468',
		':couplekiss:': '1f48f',
		':kiss_woman_man:': '1f469-2764-1f48b-1f468',
		':kiss_ww:': '1f469-2764-1f48b-1f469',
		':kiss_mm:': '1f468-2764-1f48b-1f468',
		':family:': '1f46a',
		':family_man_woman_boy:': '1f468-1f469-1f466',
		':family_mwg:': '1f468-1f469-1f467',
		':family_mwgb:': '1f468-1f469-1f467-1f466',
		':family_mwbb:': '1f468-1f469-1f466-1f466',
		':family_mwgg:': '1f468-1f469-1f467-1f467',
		':family_wwb:': '1f469-1f469-1f466',
		':family_wwg:': '1f469-1f469-1f467',
		':family_wwgb:': '1f469-1f469-1f467-1f466',
		':family_wwbb:': '1f469-1f469-1f466-1f466',
		':family_wwgg:': '1f469-1f469-1f467-1f467',
		':family_mmb:': '1f468-1f468-1f466',
		':family_mmg:': '1f468-1f468-1f467',
		':family_mmgb:': '1f468-1f468-1f467-1f466',
		':family_mmbb:': '1f468-1f468-1f466-1f466',
		':family_mmgg:': '1f468-1f468-1f467-1f467',
		':family_woman_boy:': '1f469-1f466',
		':family_woman_girl:': '1f469-1f467',
		':family_woman_girl_boy:': '1f469-1f467-1f466',
		':family_woman_boy_boy:': '1f469-1f466-1f466',
		':family_woman_girl_girl:': '1f469-1f467-1f467',
		':family_man_boy:': '1f468-1f466',
		':family_man_girl:': '1f468-1f467',
		':family_man_girl_boy:': '1f468-1f467-1f466',
		':family_man_boy_boy:': '1f468-1f466-1f466',
		':family_man_girl_girl:': '1f468-1f467-1f467',
		':coat:': '1f9e5',
		':womans_clothes:': '1f45a',
		':shirt:': '1f455',
		':jeans:': '1f456',
		':necktie:': '1f454',
		':dress:': '1f457',
		':bikini:': '1f459',
		':kimono:': '1f458',
		':lab_coat:': '1f97c',
		':high_heel:': '1f460',
		':sandal:': '1f461',
		':boot:': '1f462',
		':mans_shoe:': '1f45e',
		':athletic_shoe:': '1f45f',
		':hiking_boot:': '1f97e',
		':womans_flat_shoe:': '1f97f',
		':socks:': '1f9e6',
		':gloves:': '1f9e4',
		':scarf:': '1f9e3',
		':tophat:': '1f3a9',
		':billed_cap:': '1f9e2',
		':womans_hat:': '1f452',
		':mortar_board:': '1f393',
		':helmet_with_cross:': '26d1',
		':crown:': '1f451',
		':pouch:': '1f45d',
		':purse:': '1f45b',
		':handbag:': '1f45c',
		':briefcase:': '1f4bc',
		':school_satchel:': '1f392',
		':eyeglasses:': '1f453',
		':dark_sunglasses:': '1f576',
		':goggles:': '1f97d',
		':closed_umbrella:': '1f302',
		':red_haired:': '1f9b0',
		':curly_haired:': '1f9b1',
		':white_haired:': '1f9b3',
		':bald:': '1f9b2',
		':regional_indicator_z:': '1f1ff',
		':regional_indicator_y:': '1f1fe',
		':regional_indicator_x:': '1f1fd',
		':regional_indicator_w:': '1f1fc',
		':regional_indicator_v:': '1f1fb',
		':regional_indicator_u:': '1f1fa',
		':regional_indicator_t:': '1f1f9',
		':regional_indicator_s:': '1f1f8',
		':regional_indicator_r:': '1f1f7',
		':regional_indicator_q:': '1f1f6',
		':regional_indicator_p:': '1f1f5',
		':regional_indicator_o:': '1f1f4',
		':regional_indicator_n:': '1f1f3',
		':regional_indicator_m:': '1f1f2',
		':regional_indicator_l:': '1f1f1',
		':regional_indicator_k:': '1f1f0',
		':regional_indicator_j:': '1f1ef',
		':regional_indicator_i:': '1f1ee',
		':regional_indicator_h:': '1f1ed',
		':regional_indicator_g:': '1f1ec',
		':regional_indicator_f:': '1f1eb',
		':regional_indicator_e:': '1f1ea',
		':regional_indicator_d:': '1f1e9',
		':regional_indicator_c:': '1f1e8',
		':regional_indicator_b:': '1f1e7',
		':regional_indicator_a:': '1f1e6',
		':red_car:': '1f697',
		':taxi:': '1f695',
		':blue_car:': '1f699',
		':bus:': '1f68c',
		':trolleybus:': '1f68e',
		':race_car:': '1f3ce',
		':police_car:': '1f693',
		':ambulance:': '1f691',
		':fire_engine:': '1f692',
		':minibus:': '1f690',
		':truck:': '1f69a',
		':articulated_lorry:': '1f69b',
		':tractor:': '1f69c',
		':scooter:': '1f6f4',
		':bike:': '1f6b2',
		':motor_scooter:': '1f6f5',
		':motorcycle:': '1f3cd',
		':rotating_light:': '1f6a8',
		':oncoming_police_car:': '1f694',
		':oncoming_bus:': '1f68d',
		':oncoming_automobile:': '1f698',
		':oncoming_taxi:': '1f696',
		':aerial_tramway:': '1f6a1',
		':mountain_cableway:': '1f6a0',
		':suspension_railway:': '1f69f',
		':railway_car:': '1f683',
		':train:': '1f68b',
		':mountain_railway:': '1f69e',
		':monorail:': '1f69d',
		':bullettrain_side:': '1f684',
		':bullettrain_front:': '1f685',
		':light_rail:': '1f688',
		':steam_locomotive:': '1f682',
		':train2:': '1f686',
		':metro:': '1f687',
		':tram:': '1f68a',
		':station:': '1f689',
		':airplane:': '2708',
		':airplane_departure:': '1f6eb',
		':airplane_arriving:': '1f6ec',
		':airplane_small:': '1f6e9',
		':seat:': '1f4ba',
		':luggage:': '1f9f3',
		':satellite_orbital:': '1f6f0',
		':rocket:': '1f680',
		':flying_saucer:': '1f6f8',
		':helicopter:': '1f681',
		':canoe:': '1f6f6',
		':sailboat:': '26f5',
		':speedboat:': '1f6a4',
		':motorboat:': '1f6e5',
		':cruise_ship:': '1f6f3',
		':ferry:': '26f4',
		':ship:': '1f6a2',
		':anchor:': '2693',
		':fuelpump:': '26fd',
		':construction:': '1f6a7',
		':vertical_traffic_light:': '1f6a6',
		':traffic_light:': '1f6a5',
		':busstop:': '1f68f',
		':map:': '1f5fa',
		':moyai:': '1f5ff',
		':statue_of_liberty:': '1f5fd',
		':tokyo_tower:': '1f5fc',
		':european_castle:': '1f3f0',
		':japanese_castle:': '1f3ef',
		':stadium:': '1f3df',
		':ferris_wheel:': '1f3a1',
		':roller_coaster:': '1f3a2',
		':carousel_horse:': '1f3a0',
		':fountain:': '26f2',
		':beach_umbrella:': '26f1',
		':beach:': '1f3d6',
		':island:': '1f3dd',
		':desert:': '1f3dc',
		':volcano:': '1f30b',
		':mountain:': '26f0',
		':mountain_snow:': '1f3d4',
		':mount_fuji:': '1f5fb',
		':camping:': '1f3d5',
		':tent:': '26fa',
		':house:': '1f3e0',
		':house_with_garden:': '1f3e1',
		':homes:': '1f3d8',
		':house_abandoned:': '1f3da',
		':construction_site:': '1f3d7',
		':factory:': '1f3ed',
		':office:': '1f3e2',
		':department_store:': '1f3ec',
		':post_office:': '1f3e3',
		':european_post_office:': '1f3e4',
		':hospital:': '1f3e5',
		':bank:': '1f3e6',
		':hotel:': '1f3e8',
		':convenience_store:': '1f3ea',
		':school:': '1f3eb',
		':love_hotel:': '1f3e9',
		':wedding:': '1f492',
		':classical_building:': '1f3db',
		':church:': '26ea',
		':mosque:': '1f54c',
		':synagogue:': '1f54d',
		':kaaba:': '1f54b',
		':shinto_shrine:': '26e9',
		':railway_track:': '1f6e4',
		':motorway:': '1f6e3',
		':japan:': '1f5fe',
		':rice_scene:': '1f391',
		':park:': '1f3de',
		':sunrise:': '1f305',
		':sunrise_over_mountains:': '1f304',
		':stars:': '1f320',
		':sparkler:': '1f387',
		':fireworks:': '1f386',
		':firecracker:': '1f9e8',
		':city_sunset:': '1f307',
		':city_dusk:': '1f306',
		':cityscape:': '1f3d9',
		':night_with_stars:': '1f303',
		':milky_way:': '1f30c',
		':bridge_at_night:': '1f309',
		':lock:': '1f512',
		':unlock:': '1f513',
		':foggy:': '1f301',
		':flag_white:': '1f3f3',
		':flag_black:': '1f3f4',
		':checkered_flag:': '1f3c1',
		':triangular_flag_on_post:': '1f6a9',
		':rainbow_flag:': '1f3f3-1f308',
		':pirate_flag:': '1f3f4-2620',
		':flag_af:': '1f1e6-1f1eb',
		':flag_ax:': '1f1e6-1f1fd',
		':flag_al:': '1f1e6-1f1f1',
		':flag_dz:': '1f1e9-1f1ff',
		':flag_as:': '1f1e6-1f1f8',
		':flag_ad:': '1f1e6-1f1e9',
		':flag_ao:': '1f1e6-1f1f4',
		':flag_ai:': '1f1e6-1f1ee',
		':flag_aq:': '1f1e6-1f1f6',
		':flag_ag:': '1f1e6-1f1ec',
		':flag_ar:': '1f1e6-1f1f7',
		':flag_am:': '1f1e6-1f1f2',
		':flag_aw:': '1f1e6-1f1fc',
		':flag_au:': '1f1e6-1f1fa',
		':flag_at:': '1f1e6-1f1f9',
		':flag_az:': '1f1e6-1f1ff',
		':flag_bs:': '1f1e7-1f1f8',
		':flag_bh:': '1f1e7-1f1ed',
		':flag_bd:': '1f1e7-1f1e9',
		':flag_bb:': '1f1e7-1f1e7',
		':flag_by:': '1f1e7-1f1fe',
		':flag_be:': '1f1e7-1f1ea',
		':flag_bz:': '1f1e7-1f1ff',
		':flag_bj:': '1f1e7-1f1ef',
		':flag_bm:': '1f1e7-1f1f2',
		':flag_bt:': '1f1e7-1f1f9',
		':flag_bo:': '1f1e7-1f1f4',
		':flag_ba:': '1f1e7-1f1e6',
		':flag_bw:': '1f1e7-1f1fc',
		':flag_br:': '1f1e7-1f1f7',
		':flag_io:': '1f1ee-1f1f4',
		':flag_vg:': '1f1fb-1f1ec',
		':flag_bn:': '1f1e7-1f1f3',
		':flag_bg:': '1f1e7-1f1ec',
		':flag_bf:': '1f1e7-1f1eb',
		':flag_bi:': '1f1e7-1f1ee',
		':flag_kh:': '1f1f0-1f1ed',
		':flag_cm:': '1f1e8-1f1f2',
		':flag_ca:': '1f1e8-1f1e6',
		':flag_ic:': '1f1ee-1f1e8',
		':flag_cv:': '1f1e8-1f1fb',
		':flag_bq:': '1f1e7-1f1f6',
		':flag_ky:': '1f1f0-1f1fe',
		':flag_cf:': '1f1e8-1f1eb',
		':flag_td:': '1f1f9-1f1e9',
		':flag_cl:': '1f1e8-1f1f1',
		':flag_cn:': '1f1e8-1f1f3',
		':flag_cx:': '1f1e8-1f1fd',
		':flag_cc:': '1f1e8-1f1e8',
		':flag_co:': '1f1e8-1f1f4',
		':flag_km:': '1f1f0-1f1f2',
		':flag_cg:': '1f1e8-1f1ec',
		':flag_cd:': '1f1e8-1f1e9',
		':flag_ck:': '1f1e8-1f1f0',
		':flag_cr:': '1f1e8-1f1f7',
		':flag_ci:': '1f1e8-1f1ee',
		':flag_hr:': '1f1ed-1f1f7',
		':flag_cu:': '1f1e8-1f1fa',
		':flag_cw:': '1f1e8-1f1fc',
		':flag_cy:': '1f1e8-1f1fe',
		':flag_cz:': '1f1e8-1f1ff',
		':flag_dk:': '1f1e9-1f1f0',
		':flag_dj:': '1f1e9-1f1ef',
		':flag_dm:': '1f1e9-1f1f2',
		':flag_do:': '1f1e9-1f1f4',
		':flag_ec:': '1f1ea-1f1e8',
		':flag_eg:': '1f1ea-1f1ec',
		':flag_sv:': '1f1f8-1f1fb',
		':flag_gq:': '1f1ec-1f1f6',
		':flag_er:': '1f1ea-1f1f7',
		':flag_ee:': '1f1ea-1f1ea',
		':flag_et:': '1f1ea-1f1f9',
		':flag_eu:': '1f1ea-1f1fa',
		':flag_fk:': '1f1eb-1f1f0',
		':flag_fo:': '1f1eb-1f1f4',
		':flag_fj:': '1f1eb-1f1ef',
		':flag_fi:': '1f1eb-1f1ee',
		':flag_fr:': '1f1eb-1f1f7',
		':flag_gf:': '1f1ec-1f1eb',
		':flag_pf:': '1f1f5-1f1eb',
		':flag_tf:': '1f1f9-1f1eb',
		':flag_ga:': '1f1ec-1f1e6',
		':flag_gm:': '1f1ec-1f1f2',
		':flag_ge:': '1f1ec-1f1ea',
		':flag_de:': '1f1e9-1f1ea',
		':flag_gh:': '1f1ec-1f1ed',
		':flag_gi:': '1f1ec-1f1ee',
		':flag_gr:': '1f1ec-1f1f7',
		':flag_gl:': '1f1ec-1f1f1',
		':flag_gd:': '1f1ec-1f1e9',
		':flag_gp:': '1f1ec-1f1f5',
		':flag_gu:': '1f1ec-1f1fa',
		':flag_gt:': '1f1ec-1f1f9',
		':flag_gg:': '1f1ec-1f1ec',
		':flag_gn:': '1f1ec-1f1f3',
		':flag_gw:': '1f1ec-1f1fc',
		':flag_gy:': '1f1ec-1f1fe',
		':flag_ht:': '1f1ed-1f1f9',
		':flag_hn:': '1f1ed-1f1f3',
		':flag_hk:': '1f1ed-1f1f0',
		':flag_hu:': '1f1ed-1f1fa',
		':flag_is:': '1f1ee-1f1f8',
		':flag_in:': '1f1ee-1f1f3',
		':flag_id:': '1f1ee-1f1e9',
		':flag_ir:': '1f1ee-1f1f7',
		':flag_iq:': '1f1ee-1f1f6',
		':flag_ie:': '1f1ee-1f1ea',
		':flag_im:': '1f1ee-1f1f2',
		':flag_il:': '1f1ee-1f1f1',
		':flag_it:': '1f1ee-1f1f9',
		':flag_jm:': '1f1ef-1f1f2',
		':flag_jp:': '1f1ef-1f1f5',
		':crossed_flags:': '1f38c',
		':flag_je:': '1f1ef-1f1ea',
		':flag_jo:': '1f1ef-1f1f4',
		':flag_kz:': '1f1f0-1f1ff',
		':flag_ke:': '1f1f0-1f1ea',
		':flag_ki:': '1f1f0-1f1ee',
		':flag_xk:': '1f1fd-1f1f0',
		':flag_kw:': '1f1f0-1f1fc',
		':flag_kg:': '1f1f0-1f1ec',
		':flag_la:': '1f1f1-1f1e6',
		':flag_lv:': '1f1f1-1f1fb',
		':flag_lb:': '1f1f1-1f1e7',
		':flag_ls:': '1f1f1-1f1f8',
		':flag_lr:': '1f1f1-1f1f7',
		':flag_ly:': '1f1f1-1f1fe',
		':flag_li:': '1f1f1-1f1ee',
		':flag_lt:': '1f1f1-1f1f9',
		':flag_lu:': '1f1f1-1f1fa',
		':flag_mo:': '1f1f2-1f1f4',
		':flag_mk:': '1f1f2-1f1f0',
		':flag_mg:': '1f1f2-1f1ec',
		':flag_mw:': '1f1f2-1f1fc',
		':flag_my:': '1f1f2-1f1fe',
		':flag_mv:': '1f1f2-1f1fb',
		':flag_ml:': '1f1f2-1f1f1',
		':flag_mt:': '1f1f2-1f1f9',
		':flag_mh:': '1f1f2-1f1ed',
		':flag_mq:': '1f1f2-1f1f6',
		':flag_mr:': '1f1f2-1f1f7',
		':flag_mu:': '1f1f2-1f1fa',
		':flag_yt:': '1f1fe-1f1f9',
		':flag_mx:': '1f1f2-1f1fd',
		':flag_fm:': '1f1eb-1f1f2',
		':flag_md:': '1f1f2-1f1e9',
		':flag_mc:': '1f1f2-1f1e8',
		':flag_mn:': '1f1f2-1f1f3',
		':flag_me:': '1f1f2-1f1ea',
		':flag_ms:': '1f1f2-1f1f8',
		':flag_ma:': '1f1f2-1f1e6',
		':flag_mz:': '1f1f2-1f1ff',
		':flag_mm:': '1f1f2-1f1f2',
		':flag_na:': '1f1f3-1f1e6',
		':flag_nr:': '1f1f3-1f1f7',
		':flag_np:': '1f1f3-1f1f5',
		':flag_nl:': '1f1f3-1f1f1',
		':flag_nc:': '1f1f3-1f1e8',
		':flag_nz:': '1f1f3-1f1ff',
		':flag_ni:': '1f1f3-1f1ee',
		':flag_ne:': '1f1f3-1f1ea',
		':flag_ng:': '1f1f3-1f1ec',
		':flag_nu:': '1f1f3-1f1fa',
		':flag_nf:': '1f1f3-1f1eb',
		':flag_kp:': '1f1f0-1f1f5',
		':flag_mp:': '1f1f2-1f1f5',
		':flag_no:': '1f1f3-1f1f4',
		':flag_om:': '1f1f4-1f1f2',
		':flag_pk:': '1f1f5-1f1f0',
		':flag_pw:': '1f1f5-1f1fc',
		':flag_ps:': '1f1f5-1f1f8',
		':flag_pa:': '1f1f5-1f1e6',
		':flag_pg:': '1f1f5-1f1ec',
		':flag_py:': '1f1f5-1f1fe',
		':flag_pe:': '1f1f5-1f1ea',
		':flag_ph:': '1f1f5-1f1ed',
		':flag_pn:': '1f1f5-1f1f3',
		':flag_pl:': '1f1f5-1f1f1',
		':flag_pt:': '1f1f5-1f1f9',
		':flag_pr:': '1f1f5-1f1f7',
		':flag_qa:': '1f1f6-1f1e6',
		':flag_re:': '1f1f7-1f1ea',
		':flag_ro:': '1f1f7-1f1f4',
		':flag_ru:': '1f1f7-1f1fa',
		':flag_rw:': '1f1f7-1f1fc',
		':flag_ws:': '1f1fc-1f1f8',
		':flag_sm:': '1f1f8-1f1f2',
		':flag_st:': '1f1f8-1f1f9',
		':flag_sa:': '1f1f8-1f1e6',
		':flag_sn:': '1f1f8-1f1f3',
		':flag_rs:': '1f1f7-1f1f8',
		':flag_sc:': '1f1f8-1f1e8',
		':flag_sl:': '1f1f8-1f1f1',
		':flag_sg:': '1f1f8-1f1ec',
		':flag_sx:': '1f1f8-1f1fd',
		':flag_sk:': '1f1f8-1f1f0',
		':flag_si:': '1f1f8-1f1ee',
		':flag_gs:': '1f1ec-1f1f8',
		':flag_sb:': '1f1f8-1f1e7',
		':flag_so:': '1f1f8-1f1f4',
		':flag_za:': '1f1ff-1f1e6',
		':flag_kr:': '1f1f0-1f1f7',
		':flag_ss:': '1f1f8-1f1f8',
		':flag_es:': '1f1ea-1f1f8',
		':flag_lk:': '1f1f1-1f1f0',
		':flag_bl:': '1f1e7-1f1f1',
		':flag_sh:': '1f1f8-1f1ed',
		':flag_kn:': '1f1f0-1f1f3',
		':flag_lc:': '1f1f1-1f1e8',
		':flag_pm:': '1f1f5-1f1f2',
		':flag_vc:': '1f1fb-1f1e8',
		':flag_sd:': '1f1f8-1f1e9',
		':flag_sr:': '1f1f8-1f1f7',
		':flag_sz:': '1f1f8-1f1ff',
		':flag_se:': '1f1f8-1f1ea',
		':flag_ch:': '1f1e8-1f1ed',
		':flag_sy:': '1f1f8-1f1fe',
		':flag_tw:': '1f1f9-1f1fc',
		':flag_tj:': '1f1f9-1f1ef',
		':flag_tz:': '1f1f9-1f1ff',
		':flag_th:': '1f1f9-1f1ed',
		':flag_tl:': '1f1f9-1f1f1',
		':flag_tg:': '1f1f9-1f1ec',
		':flag_tk:': '1f1f9-1f1f0',
		':flag_to:': '1f1f9-1f1f4',
		':flag_tt:': '1f1f9-1f1f9',
		':flag_tn:': '1f1f9-1f1f3',
		':flag_tr:': '1f1f9-1f1f7',
		':flag_tm:': '1f1f9-1f1f2',
		':flag_tc:': '1f1f9-1f1e8',
		':flag_vi:': '1f1fb-1f1ee',
		':flag_tv:': '1f1f9-1f1fb',
		':flag_ug:': '1f1fa-1f1ec',
		':flag_ua:': '1f1fa-1f1e6',
		':flag_ae:': '1f1e6-1f1ea',
		':flag_gb:': '1f1ec-1f1e7',
		':england:': '1f3f4-e0067-e0062-e0065-e006e-e0067-e007f',
		':scotland:': '1f3f4-e0067-e0062-e0073-e0063-e0074-e007f',
		':wales:': '1f3f4-e0067-e0062-e0077-e006c-e0073-e007f',
		':flag_us:': '1f1fa-1f1f8',
		':flag_uy:': '1f1fa-1f1fe',
		':flag_uz:': '1f1fa-1f1ff',
		':flag_vu:': '1f1fb-1f1fa',
		':flag_va:': '1f1fb-1f1e6',
		':flag_ve:': '1f1fb-1f1ea',
		':flag_vn:': '1f1fb-1f1f3',
		':flag_wf:': '1f1fc-1f1eb',
		':flag_eh:': '1f1ea-1f1ed',
		':flag_ye:': '1f1fe-1f1ea',
		':flag_zm:': '1f1ff-1f1f2',
		':flag_zw:': '1f1ff-1f1fc',
		':flag_ac:': '1f1e6-1f1e8',
		':flag_bv:': '1f1e7-1f1fb',
		':flag_cp:': '1f1e8-1f1f5',
		':flag_ea:': '1f1ea-1f1e6',
		':flag_dg:': '1f1e9-1f1ec',
		':flag_hm:': '1f1ed-1f1f2',
		':flag_mf:': '1f1f2-1f1eb',
		':flag_sj:': '1f1f8-1f1ef',
		':flag_ta:': '1f1f9-1f1e6',
		':flag_um:': '1f1fa-1f1f2',
		':united_nations:': '1f1fa-1f1f3',
		':tone1:': '1f3fb',
		':tone2:': '1f3fc',
		':tone3:': '1f3fd',
		':tone4:': '1f3fe',
		':tone5:': '1f3ff',
	}

	for (var id in this.emoji_keywords) {
		this.emoji_keywords[id] = this.unicodeFromCodePoint(this.emoji_keywords[id])
	}
	this.emoji_keywords = Object.assign(
		{
			pee: 'poo',
			peee: 'poo',
			peeee: 'poo',
			// small
			'.sl': 'https://omgmobc.com/sound/soosi-laugh.mp3',
			'.soosi': 'https://omgmobc.com/sound/soosi-laugh.mp3',
			'.lmao': 'https://omgmobc.com/sound/soosi-laugh.mp3',
			'.lol': 'https://omgmobc.com/sound/soosi-laugh.mp3',
			'.laugh': 'https://omgmobc.com/sound/soosi-laugh.mp3',
			'.omfg': 'https://omgmobc.com/sound/soosi-laugh.mp3',
			'.monday': 'https://omgmobc.com/sound/monday.ogg',
			'.ofcourse': 'https://omgmobc.com/img/icon/ofcourse.mp4',
			'.hehe': 'https://omgmobc.com/img/icon/ofcourse.mp4',
		},
		this.emoji_keywords,
	)

	this.cacheColorAlpha = []
	this.cacheColorLighten = []
	this.cacheColorReadable = []

	this.document_is_visible = !document.hidden
	this.on_document_visibility_change = []

	function visibilitychange(e) {
		if (e.target == e.currentTarget) {
			u.document_is_visible = e.type === 'blur' ? false : true // !document.hidden
			emit({
				id: 'tf',
				v: u.document_is_visible,
			})
			for (var id in this.on_document_visibility_change) {
				this.on_document_visibility_change[id](u.document_is_visible)
			}
		}
	}

	window.addEventListener('focus', visibilitychange.bind(this), { passive: true })
	window.addEventListener('blur', visibilitychange.bind(this), { passive: true })

	this.on_document_visibility_change.push(
		function(visible) {
			if (visible) {
				this.focusChat()
			}
		}.bind(this),
	)

	// focus chat
	document.addEventListener(
		'click',
		function(e) {
			if (!isMobile) {
				this.focusChat(e)
			}
		}.bind(this),
		{ passive: true },
	)

	document.addEventListener(
		'load',
		function(e) {
			if (!isMobile) {
				this.focusChat(e)
			}
		}.bind(this),
		{ passive: true },
	)
	document.addEventListener(
		'keydown',
		function(e) {
			if (!isMobile && e.target.tagName == 'OBJECT' && e.keyCode == 9) {
				this.focusChat(e)
			}
		}.bind(this),
		{ passive: true },
	)

	// place on image the src in the alt
	document.addEventListener(
		'load',
		function(e) {
			if (!e.target.tagName || e.target.tagName != 'IMG') return
			e.target.alt = e.target.src
		},
		true,
	)

	// when an image fails to load load the default image
	document.addEventListener(
		'error',
		function(e) {
			if (!e.target.tagName || e.target.tagName != 'IMG') return
			e.target.src = 'https://omgmobc.com/img/profile.png'
		},
		true,
	)
	// autoplay next audio/video on chat when the current one finishes
	document.addEventListener(
		'ended',
		function(e) {
			if (e.target.tagName && (e.target.tagName == 'AUDIO' || e.target.tagName == 'VIDEO')) {
				var playing = e.target
				var chats = ['.chat audio', '.chat-private audio', '.chat video', '.chat-private video']
				for (var id in chats) {
					var medias = document.querySelectorAll(chats[id])
					var play = false
					for (var id in medias) {
						var media = medias[id]
						if (play) {
							try {
								media.play()
							} catch (e) {}
							return
						}
						if (media == playing) {
							play = true
						}
					}
				}
			}
		},
		true,
	)
}

Utils.prototype.copy = function(o) {
	return JSON.parse(JSON.stringify(o))
}
Utils.prototype.isRTL = function(s) {
	this.isRTLRegExp.lastIndex = 0
	return this.isRTLRegExp.test(s)
}
Utils.prototype.toArray = function(o) {
	var a = []
	Object.keys(o).forEach(function(i) {
		a.push(o[i])
	})
	return a
}

Utils.prototype.toArrayIndex = function(o) {
	var a = []
	Object.keys(o).forEach(function(i) {
		a[i] = o[i]
	})
	return a
}

Utils.prototype.escape_replace = function(s) {
	return this.entityMap[s]
}
Utils.prototype.escape = function(s) {
	return s.replace(this.escapeHTMLRegexp, this.escape_replace)
}

Utils.prototype.decodeURI = function(s) {
	try {
		try {
			return decodeURIComponent(decodeURIComponent(s))
		} catch (e) {
			return decodeURIComponent(s)
		}
	} catch (e) {
		return s
	}
}

Utils.prototype.arrayUnique = function(b) {
	var a = []
	for (var i = 0, l = b.length; i < l; i++) {
		if (a.indexOf(b[i]) === -1) a.push(b[i])
	}

	return a
}
Utils.prototype.smiles = function(s) {
	s = s.split(this.linky_separator)
	for (var a = 0, l = s.length; a < l; a++) {
		var k = s[a].replace(/\.$/, '').toLowerCase()

		for (var id in this.emojies_keys) {
			if (
				this.emojies[this.emojies_keys[id]] &&
				(this.emojies[this.emojies_keys[id]].hasOwnProperty(k) ||
					this.emojies[this.emojies_keys[id]].hasOwnProperty(k.replace(/\.$/, '')))
			) {
				s[a] =
					'https://omgmobc.com/img/icon/' +
					this.emojies[this.emojies_keys[id]][k.replace(/\.$/, '')] +
					(/\.\.$/.test(s[a]) ? ' ..' : /\.$/.test(s[a]) ? ' .' : '')
				break
			} else if (this.emoji_keywords.hasOwnProperty(k)) {
				s[a] = this.emoji_keywords[k]
			}
		}
	}
	if (window.room) {
		s = s
			.join('')
			.replace(/\.png#32\s+\.\./gi, '.png#128 ')
			.replace(/\.gif#32\s+\.\./gi, '.gif#128 ')
			.replace(/\.png#32\s+\./gi, '.png ')
			.replace(/\.gif#32\s+\./gi, '.gif ')
			.replace(/\.gif\s+\./gi, '.gif ')
			.replace(/\.png\s+\./gi, '.png ')

		if (/^\.[a-z0-9]+\.$/.test(s)) {
			return u.smiles(s.replace(/([^\.])/g, '.$1. ').replace(/^\./, ''))
		} else if (/^\.[a-z0-9]+$/.test(s)) {
			return u.smiles(s.replace(/([^\.])/g, '.$1 ').replace(/^\./, ''))
		} else {
			return s
		}
	} else {
		s = s
			.join('')
			.replace(/\.png#32\s+\.\./gi, '.png#32 ')
			.replace(/\.gif#32\s+\.\./gi, '.gif#32 ')
			.replace(/\.png#32\s+\./gi, '.png#32 ')
			.replace(/\.gif#32\s+\./gi, '.gif#32 ')
			.replace(/\.gif\s+\./gi, '.gif ')
			.replace(/\.png\s+\./gi, '.png ')

		if (/^\.[a-z0-9]+\.$/.test(s)) {
			return u.smiles(s.replace(/([^\.])/g, '.$1 ').replace(/^\./, ''))
		} else if (/^\.[a-z0-9]+$/.test(s)) {
			return u.smiles(s.replace(/([^\.])/g, '.$1 ').replace(/^\./, ''))
		} else {
			return s
		}
	}
}

Utils.prototype.linky_cache = {}
Utils.prototype.linky_cached = function(s) {
	if (!this.linky_cache[s]) {
		this.linky_cache[s] = this.linkyNoScroll(s)
	}
	return this.linky_cache[s]
}
Utils.prototype.linky = function(s) {
	s = this.smiles(this.linkyFix(s.replace(/\s+$/, '').replace(/^(\s*\n+)+/, ''))).split(
		this.linky_separator,
	)
	for (var id = 0, l = s.length; id < l; id++) {
		var s_lower = s[id].toLowerCase()
		if (s[id].indexOf('http') === 0 && s[id] != 'http' && s[id] != 'https') {
			if (s[id].indexOf('https://www.youtube.com/watch?v=') === 0) {
				s[id] = s[id].split('&')[0].split('?list')[0]
				s[id] =
					'<a data-video-id="' +
					this.escape(s[id].split('=')[1]) +
					'" title="Click To Play Above Chat" target="_blank" rel="noopener" onclick="if(!(event.ctrlKey||event.metaKey)){window.playerIncoming(event);return false;}" href="' +
					this.escape(s[id]) +
					'">' +
					this.escape(s[id].replace('https://www.youtube.com/watch?v=', 'YT/')) +
					'</a>'
			} else {
				// unproxy link
				if (s[id].indexOf('https://omgmobc.com/php/image.php?url=') === 0) {
					s[id] = decodeURIComponent(s[id].replace('https://omgmobc.com/php/image.php?url=', ''))
				}
				if (s[id].indexOf('https://omgmobc.com/php.image.php?url=') === 0) {
					s[id] = decodeURIComponent(s[id].replace('https://omgmobc.com/php.image.php?url=', ''))
				}

				linky_video.lastIndex = 0
				linky_image.lastIndex = 0
				linky_audio.lastIndex = 0

				if (s[id].indexOf('https://omgmobc.com/') === 0) {
					var link = this.escape(s[id])
				} else {
					var link = 'https://omgmobc.com/php/image.php?url=' + encodeURIComponent(s[id])
				}

				if (linky_video.test(s[id])) {
					if (window.user.noinline) {
						s[id] =
							'<a target="_blank" rel="noopener" href="' +
							link +
							'">' +
							this.escape(this.decodeURI(s[id])) +
							'</a>'
					} else {
						s[id] =
							'<a target="_blank" rel="noopener"  class="no-border" href="' +
							link +
							'">' +
							'<video muted="true" loop="true" ' +
							'  autoplay="true" onloadeddata="window.updateScroll();window.updateScrollPrivate()"><source  src="' +
							link +
							'" type="video/' +
							this.escape(video_extension(s[id])) +
							'"/></video>' +
							'</a>'
					}
				} else if (linky_image.test(s[id])) {
					// emoji shoulnt be clickeable
					if (s[id].indexOf('https://omgmobc.com/img/') === 0) {
						s[id] =
							'<img onload="window.updateScroll();window.updateScrollPrivate()"  src="' +
							link +
							'"/>'
					} else if (window.user.noinline) {
						s[id] =
							'<a target="_blank" rel="noopener" href="' +
							link +
							'">' +
							this.escape(this.decodeURI(s[id])) +
							'</a>'
					} else {
						s[id] =
							'<a target="_blank" rel="noopener" class="no-border" href="' +
							link +
							'">' +
							'<img onload="window.updateScroll();window.updateScrollPrivate()"  src="' +
							link +
							'"/>' +
							'</a>'
					}
				} else if (linky_audio.test(s[id])) {
					if (window.user.noinline) {
						s[id] =
							'<a target="_blank" rel="noopener" href="' +
							link +
							'">' +
							this.escape(this.decodeURI(s[id])) +
							'</a>'
					} else {
						s[id] = '<audio controls><source draggable="false" src="' + link + '"/></audio>'
					}
				} else {
					s[id] =
						'<a  ' +
						(s[id].indexOf('https://omgmobc.com/index.html#u') === 0 ||
						s[id].indexOf('https://omgmobc.com/index.html#p') === 0
							? ''
							: ' target="_blank" ') +
						'  rel="noopener" href="' +
						this.escape(s[id]) +
						'">' +
						this.escape(this.decodeURI(s[id]).replace('https://omgmobc.com/index.html#', '#')) +
						'</a>'
				}
			}
		} else if (/^\*.+\*$/.test(s[id])) {
			s[id] = '<b>' + this.escape(/\*(.+)\*/.exec(s[id])[1]) + '</b>'
		} else if (/^\/.+\/$/.test(s[id])) {
			s[id] = '<i>' + this.escape(/\/(.+)\//.exec(s[id])[1]) + '</i>'
		} else if (
			window.user &&
			(window.user.username_lower == s_lower ||
				'@' + window.user.username_lower == s_lower ||
				window.user.username_lower + '!' == s_lower ||
				(window.user.tags_modified &&
					window.user.tags_modified.some(function(item) {
						return item && s_lower == item
					})))
		) {
			s[id] = '<mark>' + this.escape(s[id]) + '</mark>'
		} else {
			s[id] = this.escape(s[id])
			this.emoji_regexp.lastIndex = 0
			if (!/[a-z0-9&*#]/i.test(s[id]) && this.emoji_regexp.test(s[id])) {
				s[id] = '<span class="emoji-native">' + s[id] + '</span>'
			}
		}
	}

	s = s.join('').split('\n')
	for (var id = 0, l = s.length; id < l; id++) {
		if (s[id].indexOf('&gt; ') === 0) {
			s[id] = '<div class="quote">' + s[id].replace(/^&gt; /, '') + '</div>'
			while (s[id].indexOf('<div class="quote">&gt; ') !== -1) {
				s[id] =
					s[id].split('<div class="quote">&gt; ').join('<div class="quote"><div class="quote">') +
					'</div>'
			}
		} else if (s[id] === '&gt;') {
			s[id] = '<div class="quote"> </div>'
		}
	}
	s = s.join('\n')

	if (s[0] === '/' && s[1] && s[1] === '*') s = s.replace(/^\/\*([^\n]+)/, '<i><b>$1</b></i>')
	else if (s[0] === '/') s = s.replace(/^\/([^\n]+)/, '<i>$1</i>')
	else if (s[0] === '*') s = s.replace(/^\*([^\n]+)/, '<b>*$1</b>')

	return s
}

Utils.prototype.linkyNoScroll = function(s) {
	return u.linky(s).replace(/window.updateScroll\(\);window.updateScrollPrivate\(\)/g, '')
}
Utils.prototype.linkyFix = function(s) {
	return s
		.replace(/https?:\/\/youtu\.be\//gi, 'https://www.youtube.com/watch?v=')
		.replace(/YT\//g, 'https://www.youtube.com/watch?v=')
}
Utils.prototype.linkyNoLink = function(s) {
	return this.linkyNoScroll(s)
		.replace(/<source[^>]*>/gi, '')
		.replace(/<audio[^>]*>/gi, '')
		.replace(/<\/audio>/gi, '')
		.replace(/<video[^>]*>/gi, '')
		.replace(/<\/video>/gi, '')
		.replace(/<a[^>]*>/gi, '')
		.replace(/<\/a>/gi, '')
	// maybe remove video
}
Utils.prototype.linky_no_link_cache = {}
Utils.prototype.linky_no_link_cached = function(s) {
	if (!this.linky_no_link_cache[s]) {
		this.linky_no_link_cache[s] = this.linkyNoLink(s)
	}
	return this.linky_no_link_cache[s]
}
Utils.prototype.maybe = function(percent) {
	return Math.random() <= percent / 100 ? true : false
}
Utils.prototype.log = function() {
	if (arguments.length == 1) console.log(arguments[0])
	else console.log(arguments)
}
Utils.prototype.search = function(query, string) {
	string = string.toLowerCase().trim()
	query = query
		.toLowerCase()
		.replace(/,+/g, ' ')
		.replace(/ +/g, ' ')
		.trim()
		.split(' ')

	var found = false
	var all_negative = query.every(function(q) {
		return q[0] == '-'
	})
	for (var id in query) {
		var sub = query[id]
		if (sub == '-') {
			continue
		}
		if (sub[0] == '-' && string.indexOf(sub.replace(/^-/, '')) != -1) {
			return false
		} else if (sub[0] != '-' && string.indexOf(sub) != -1) {
			found = true
		} else if (all_negative) {
			found = true
		}
	}
	return found
}

Utils.prototype.time = function(time) {
	if (time) var date = new Date(time)
	else var date = new Date()
	return (
		(date.getHours() < 10 ? '0' : '') +
		date.getHours() +
		':' +
		(date.getMinutes() < 10 ? '0' : '') +
		date.getMinutes() +
		':' +
		(date.getSeconds() < 10 ? '0' : '') +
		date.getSeconds()
	)
}
Utils.prototype.is_dark = function() {
	var date = new Date()
	return date.getHours() < 6 || date.getHours() > 18
}
Utils.prototype.unicodeFromCodePoint = function(unicode) {
	if (unicode.indexOf('-') > -1) {
		var parts = []
		var s = unicode.split('-')
		for (var i = 0; i < s.length; i++) {
			var part = parseInt(s[i], 16)
			if (part >= 0x10000 && part <= 0x10ffff) {
				var hi = Math.floor((part - 0x10000) / 0x400) + 0xd800
				var lo = ((part - 0x10000) % 0x400) + 0xdc00
				part = String.fromCharCode(hi) + String.fromCharCode(lo)
			} else {
				part = String.fromCharCode(part)
			}
			parts.push(part)
		}
		return parts.join('')
	} else {
		var s = parseInt(unicode, 16)
		if (s >= 0x10000 && s <= 0x10ffff) {
			var hi = Math.floor((s - 0x10000) / 0x400) + 0xd800
			var lo = ((s - 0x10000) % 0x400) + 0xdc00
			return String.fromCharCode(hi) + String.fromCharCode(lo)
		} else {
			return String.fromCharCode(s)
		}
	}
}
Utils.prototype.date = function(time) {
	if (time) var date = new Date(time)
	else var date = new Date()
	return (
		date.getFullYear() +
		'.' +
		(date.getMonth() < 9 ? '0' : '') +
		(date.getMonth() + 1) +
		'.' +
		(date.getDate() < 10 ? '0' : '') +
		date.getDate() +
		' ' +
		(date.getHours() < 10 ? '0' : '') +
		date.getHours() +
		':' +
		(date.getMinutes() < 10 ? '0' : '') +
		date.getMinutes() +
		':' +
		(date.getSeconds() < 10 ? '0' : '') +
		date.getSeconds()
	)
}
Utils.prototype.getHash = function() {
	return decodeURIComponent(location.hash.replace(/^#?\/?/, ''))
}
jQuery.expr.filters.visible = function(elem) {
	return !!(elem.offsetWidth || elem.offsetHeight || elem.getClientRects().length)
}

Utils.prototype.isInput = function(e, e2) {
	return (
		e &&
		e.tagName &&
		(e.tagName == 'INPUT' ||
			e.tagName == 'TEXTAREA' ||
			e.tagName == 'SELECT' ||
			e.tagName == 'OPTION' ||
			e.tagName == 'SVG' ||
			$(e).attr('contenteditable') ||
			(e2 &&
				($(e2.target).hasClass('preview-color') ||
					$(e2.target)
						.parents()
						.hasClass('preview-color'))))
	)
}
Utils.prototype.focusChat = function(e) {
	if (!isMobile) {
		setTimeout(
			function() {
				if (
					(window.getSelection() == null || window.getSelection().toString() == '') &&
					!u.isInput(document.activeElement, e)
				) {
					var box = $('.chat .chat-input').is(':visible')
					if (box) {
						$('.chat .chat-input').focus()
					} else {
						var box = $('.chat-private .chat-input').is(':visible')
						if (box) {
							$('.chat-private .chat-input').focus()
						}
					}
				}
			}.bind(this),
			0,
		)
	}
}

Utils.prototype.download = function(url, callback) {
	var xhr = new XMLHttpRequest()
	xhr.addEventListener(
		'progress',
		function(evt) {
			if (evt.lengthComputable) {
				callback(((evt.loaded / evt.total) * 100).toFixed(2))
			}
		},
		false,
	)
	xhr.addEventListener('load', function() {
		callback(100)
	})
	xhr.open('GET', url)

	xhr.send()
}
Utils.prototype.focusGame = function(force) {
	if (!isMobile) {
		if (force || !document.activeElement || !u.isInput(document.activeElement)) {
			if ($('#game-swf').is(':visible')) {
				$('#game-swf').focus()
			} else {
				u.focusChat()
			}
		}
	}
}

Utils.prototype.sound = function(type) {
	var o = storage.get()
	if (!o.muted) {
		this.playSound(type)
	}
}
Utils.prototype.playSound = function(type) {
	var audio = new Audio(
		'https://omgmobc.com/sound/' + type + '.' + (type.indexOf('notes') !== -1 ? 'ogg' : 'mp3'),
	)
	audio.volume = 0.9
	var playPromise = audio.play()

	if (playPromise !== undefined) {
		playPromise.then(function() {}).catch(function() {})
	}
}
Utils.prototype.soundAlways = function(type) {
	this.playSound(type)
}

Utils.prototype.soundWhenTabUnfocused = function(type) {
	var o = storage.get()
	if (!o.muted && !this.document_is_visible) {
		this.playSound(type)
	}
}
Utils.prototype.soundWhenTabUnfocusedMuted = function(type) {
	if (!this.document_is_visible) {
		this.playSound(type)
	}
}

Utils.prototype.soundWhenTabNotMuted = function(type) {
	var o = storage.get()
	if (!o.muted) {
		this.playSound(type)
	}
}
Utils.prototype.soundIfMutedSilence = function(type) {
	var o = storage.get()
	if (!o.muted) {
		this.playSound(type)
	} else {
		this.playSound('silence')
	}
}

Utils.prototype.soundSWF = function(type) {
	setTimeout(function() {
		u.soundWhenTabNotMuted(type)
	}, 0)
}

Utils.prototype.chatSWF = function(data) {
	setTimeout(function() {
		incoming(data)
	}, 0)
}
Utils.prototype.swfSCale = function() {
	return 1.26
}

Utils.prototype.gameH = function() {
	return $('.game-swf').height()
}

Utils.prototype.getAssets = function(result) {
	this.assets = []
	result = String(result)
		.trim()
		.replace(/\r/g, '\n')
		.replace(/\n+/g, '\n')
		.split('\n')
	for (var id in result) {
		if (result[id].indexOf('.swf') !== -1) {
			this.assets.push(result[id])
		}
	}
}
Utils.prototype.notification = function(data) {
	try {
		function show() {
			var notification = new Notification(data.title, { body: data.body, icon: data.image })
			notification.onclick = function(x) {
				try {
					notification.close()
				} catch (e) {}
				window.focus()
				if (data.url) {
					location.href = data.url
				}
			}
			notification.onclose = function(x) {
				u.removeValueFromArray(u.on_document_visibility_change, close)
			}

			function close() {
				try {
					notification.close()
				} catch (e) {}
				u.removeValueFromArray(u.on_document_visibility_change, close)
			}
			u.on_document_visibility_change.push(close)
		}
		if (!('Notification' in window)) {
			return
		} else if (Notification.permission === 'granted') {
			show()
		} else if (Notification.permission !== 'denied') {
			Notification.requestPermission(function(permission) {
				if (!('permission' in Notification)) {
					Notification.permission = permission
				}

				if (permission === 'granted') {
					show()
				}
			})
		}
	} catch (e) {}
}

Utils.prototype.removeValueFromArray = function(a, v) {
	var i = a.indexOf(v)
	if (i !== -1) a.splice(i, 1)
}

Utils.prototype.isNoHD = function() {
	return window.user && window.user.nohd
}
Utils.prototype.title = function(item) {
	if (!this._title) this._title = $('title')
	if (!this._title_original) this._title_original = this._title.attr('data-title')
	if (!this._title_last) this._title_last = this._title_original
	var title =
		(item ? item + ' ' + this._title_original : this._title_original) + ': OMGMOBC - Social Games'

	if (title != this._title_last) {
		this._title_last = title
		this._title.text(title)
	}
	if (window.changeTitle) {
		window.changeTitle(document.title)
	}
	return true
}
Utils.prototype.unread = function(item) {
	var title = document.title.replace(/^\([0-9]+\) /, '')
	if (item) document.title = '(' + item + ') ' + title
	else document.title = title
	if (window.changeTitle) {
		window.changeTitle(document.title)
	}
}
Utils.prototype.capital = function(s) {
	return s.charAt(0).toUpperCase() + s.slice(1)
}

Utils.prototype.preload = function(url, aCallback) {
	$.ajax({
		url: url,

		success: function(aData) {
			if (aCallback) aCallback(aData)
		},
	})
}
Utils.prototype.read = function(url, aCallback) {
	$.ajax({
		url: url,
		dataType: 'text',
		headers: {
			'Cache-Control': 'max-age=0,no-cache,post-check=0,pre-check=0',
			Pragma: 'no-cache',
		},
		success: function(aData) {
			if (aCallback) aCallback(aData)
		},
	})
}

Utils.prototype.readAndCall = function(url, aCallback) {
	var i = new Image()
	i.onload = function() {
		if (aCallback) aCallback(url)
	}
	i.src = url
}

Utils.prototype.randomNumber = function(bottom, top) {
	return Math.floor(Math.random() * (1 + top - bottom)) + bottom
}
Utils.prototype.rand = function(a) {
	return a[Math.floor(Math.random() * a.length)]
}

Utils.prototype.reload = function() {
	var urls = ['index.html']

	u.read(urls.shift(), function(data) {
		var re = /(href|src)=["']([^"']+)["']/g,
			m
		while ((m = re.exec(data))) {
			if (m[2].indexOf('.css') !== -1 || m[2].indexOf('.js') !== -1) urls.push(m[2])
		}

		function read(url) {
			u.read(url, function() {
				if (urls.length) read(urls.shift())
				else {
					location.reload(true)
				}
			})
		}
		read(urls.shift())
	})
}

Utils.prototype.alpha = function(color, amount) {
	if (!color) return ''
	else if (!this.cacheColorAlpha[color + ',' + (amount || '')])
		this.cacheColorAlpha[color + ',' + (amount || '')] = tinycolor(color)
			.setAlpha(amount || 0.44)
			.toRgbString()
	return this.cacheColorAlpha[color + ',' + (amount || '')]
}
Utils.prototype.lighten = function(color, amount) {
	if (!color) return ''
	else if (!this.cacheColorLighten[color])
		this.cacheColorLighten[color] = tinycolor(color)
			.brighten(amount || 15)
			.lighten(2)
			.toString()
	return this.cacheColorLighten[color]
}
Utils.prototype.readable = function(color) {
	if (!color) return ''
	if (!this.cacheColorReadable[color]) {
		color = tinycolor(color)
			.setAlpha(1)
			.toString()

		this.cacheColorReadable[color] =
			tinycolor.readability('#000', color) >= 3 ? color : u.lighten(color, 40)
	}

	return this.cacheColorReadable[color]
}
Utils.prototype.colorGenerate = function(color) {
	if (!color)
		color = [this.randomNumber(50, 100), this.randomNumber(50, 100), this.randomNumber(50, 100)] // blend
	var red = this.randomNumber(0, 255)
	var green = this.randomNumber(0, 255)
	var blue = this.randomNumber(0, 255)

	if (color) {
		red = (red + color[0]) >> 1
		green = (green + color[1]) >> 1
		blue = (blue + color[2]) >> 1
	}
	return '#' + this.color2Hex(red) + '' + this.color2Hex(green) + '' + this.color2Hex(blue)
}

Utils.prototype.color2Hex = function(n) {
	n = parseInt(n, 10)
	if (isNaN(n)) return '00'
	n = Math.max(0, Math.min(n, 255))
	return '0123456789ABCDEF'.charAt((n - (n % 16)) / 16) + '0123456789ABCDEF'.charAt(n % 16)
}
Utils.prototype.filterable = function(e) {
	var s = e.value.trim().toLowerCase()
	clearTimeout(this.do_filterable_timeout)
	this.do_filterable_timeout = setTimeout(
		function() {
			this.do_filterable(s)
		}.bind(this),
		300,
	)
}

Utils.prototype.do_filterable = function(s) {
	$('.filterable').each(function() {
		var i = $(this)
		if (
			!s ||
			s == '' ||
			i
				.html()
				.toLowerCase()
				.indexOf(s) !== -1
		)
			i.removeClass('hidden')
		else i.addClass('hidden')
	})
}

Utils.prototype.unique = function(b) {
	var a = []
	for (var i = 0, l = b.length; i < l; i++) {
		if (a.indexOf(b[i]) === -1) a.push(b[i])
	}
	return a
}
Utils.prototype.is_mod = function(u) {
	return u === 'omgmobc.com'
}
Utils.prototype.autosize = function(element, max) {
	for (var a = 0; a < 13; a++) {
		this._autosize(element, max)
	}
	setTimeout(
		function() {
			this._autosize(element, max)
			if (!isMobile) {
				window.updateScroll()
				window.updateScrollPrivate()
			}
		}.bind(this),
		150,
	)
	if (!isMobile) {
		window.updateScroll()
		window.updateScrollPrivate()
	}
}
Utils.prototype._autosize = function(element, max) {
	if (element) {
		element.style.height = 'initial'
		const computed = window.getComputedStyle(element)

		const scrollHeight =
			element.scrollHeight -
			(parseInt(computed.getPropertyValue('padding-top')) +
				parseInt(computed.getPropertyValue('padding-bottom')))

		var correction = 13
		if (scrollHeight + correction > max) {
			var h = max + correction
			element.style.maxHeight = h + 'px'
		} else {
			var h = scrollHeight + correction
			element.style.maxHeight = h + 'px'
		}
		var h = scrollHeight + correction

		element.style.height = h + 'px'
	}
}

Utils.prototype.format_time = function(diff) {
	diff = (Date.now() - diff) / 1000
	if (diff >= 31557600) return 'long time ago'
	else if (diff >= 7776000) return 'months ago'
	else if (diff >= 5184000) return '2 months ago'
	else if (diff >= 2592000) return '1 month ago'
	else if (diff >= 1814400) return 'weeks ago'
	else if (diff >= 1209600) return '2 weeks ago'
	else if (diff >= 604800) return '1 week ago'
	else if (diff >= 259200) return 'days ago'
	else if (diff >= 172800) return '2 days ago'
	else if (diff >= 86400) return 'yesterday'
	else if (diff >= 43200) return 'half a day ago'
	else if (diff >= 10800) return 'hours ago'
	else if (diff >= 7200) return '2 hours ago'
	else if (diff >= 3600) return 'an hour ago'
	else if (diff >= 1500) return 'half hour ago'
	else if (diff >= 200) return 'minutes ago'
	else return 'Just now'
}
Utils.prototype.hash_code = function(s) {
	var hash = 0,
		i,
		chr
	if (s.length === 0) return hash
	for (i = 0; i < s.length; i++) {
		chr = s.charCodeAt(i)
		hash = (hash << 5) - hash + chr
		hash |= 0
	}
	return hash
}
Utils.prototype.shuffle = function(array, random) {
	var currentIndex = array.length,
		temporaryValue,
		randomIndex

	while (0 !== currentIndex) {
		randomIndex = Math.floor((!random ? Math.random() : random()) * currentIndex)
		currentIndex -= 1

		temporaryValue = array[currentIndex]
		array[currentIndex] = array[randomIndex]
		array[randomIndex] = temporaryValue
	}

	return array
}

Utils.prototype.click = function(item) {
	try {
		item.click()
	} catch (e) {
		try {
			item[0].click()
		} catch (e) {
			try {
				$(item)[0].click()
			} catch (e) {
				try {
					$(item).click()
				} catch (e) {}
			}
		}
	}
}
Utils.prototype.swap = function(json) {
	var ret = {}
	for (var key in Object.keys(json)) {
		ret[json[key]] = key
	}
	return ret
}
Utils.prototype.repeat = function(n) {
	return Array.apply(null, { length: n })
}

function profile_picture(img, big) {
	if (big) {
		if (!img) return 'https://omgmobc.com/img/profile.png'
		else return img
	} else {
		if (!img) return 'https://omgmobc.com/img/profile.png'
		else {
			return img.replace('profile/', 'profile/thumb_')
		}
	}
}
function profile_picture_static(img) {
	if (is_video(img)) {
		img = profile_picture(img).replace(/\.[^\.]+$/, '.png')
	} else {
		img = profile_picture(img)
	}
	return img
}

function is_video(src) {
	if (!!src && /(mpg|mpeg|mp4|webm)$/.test(src)) return true
	return false
}

function video_extension(src) {
	return src
		.split('.')
		.pop()
		.replace(/\?.*$/, '')
}

function compress(s) {
	return pako.deflate(JSON.stringify(s), { level: 3, to: 'string' })
}
function uncompress(s) {
	return JSON.parse(pako.inflate(s, { to: 'string' }))
}
