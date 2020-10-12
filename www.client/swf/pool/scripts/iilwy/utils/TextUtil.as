package iilwy.utils
{
   import br.com.stimuli.mona.validators.EmailValidator;
   import flash.utils.ByteArray;
   import iilwy.application.AppComponents;
   import iilwy.application.AppProperties;
   import iilwy.model.dataobjects.ArcadeGamePackData;
   
   public class TextUtil
   {
      
      public static var topLevelDomains:Array = ["com","org","edu","gov","tv","net","biz","uk","info","fr","us","fm","de"];
      
      public static var internalDomains:Array = ["iminlikewithyou.com","iilwy.com","omgpop.com"];
      
      public static var externalDomainPaths:Array = ["blog","forums"];
       
      
      public function TextUtil()
      {
         super();
      }
      
      public static function makeSlashSeparatedString(components:Array) : String
      {
         var str:String = "";
         for(var i:int = 0; i < components.length; i++)
         {
            if(i > 0)
            {
               str = str + " // ";
            }
            str = str + components[i];
         }
         return str;
      }
      
      public static function loginSignupHtmlBlurb() : String
      {
         var str:String = null;
         str = "<a class = \'actionLink\' href = \'event:login\'>Log in</a> " + "or <a class = \'actionLink\' href = \'event:signup\'>Sign up</a>";
         return str;
      }
      
      public static function websiteOnlyBlurb(url:String = null) : String
      {
         var str:String = null;
         var turl:String = null;
         if(!url)
         {
            turl = "event:/signup";
         }
         else
         {
            turl = "event:" + url;
         }
         str = "<a class = \'actionLink\' href = \'" + turl + "\'>website only</a> feature";
         return str;
      }
      
      public static function truncateTimeToInterval(time:Number, intervalSeconds:Number) : Number
      {
         var result:Number = time;
         result = Math.round(result / (intervalSeconds * 1000)) * intervalSeconds;
         result = Math.max(Math.floor(intervalSeconds / 2),result);
         return result;
      }
      
      public static function clipText(text:String, length:Number, clipToSpace:Boolean = true) : String
      {
         var spaceIndex:int = 0;
         var msg:String = text;
         if(msg && msg.length > length)
         {
            msg = msg.substr(0,length);
            if(clipToSpace)
            {
               spaceIndex = msg.lastIndexOf(" ");
               if(spaceIndex >= 0)
               {
                  msg = msg.substring(0,spaceIndex);
               }
            }
            msg = msg + "...";
         }
         return msg;
      }
      
      public static function isValidProfileName(profile:String) : Boolean
      {
         var valid:Boolean = true;
         if(profile.match(/^[a-zA-Z0-9_\(\)\[\]\. ]{3,40}$/i) == null)
         {
            valid = false;
         }
         if(profile.match(/^[ ]+$/i) != null)
         {
            valid = false;
         }
         return valid;
      }
      
      public static function getEmailName(address:String) : String
      {
         var arr:* = undefined;
         var result:String = "";
         if(EmailValidator.isValidEmail(address))
         {
            arr = address.match(/(^.+)\@[a-zA-Z0-9]+\./);
            result = arr[1];
         }
         return result;
      }
      
      public static function getEmailDomain(address:String) : String
      {
         var arr:* = undefined;
         var result:String = "";
         if(EmailValidator.isValidEmail(address))
         {
            arr = address.match(/^.+\@([a-zA-Z0-9]+)\./);
            result = arr[1];
         }
         return result;
      }
      
      public static function stripDoubleCommas(str:String) : String
      {
         return str.replace(", ,",", ");
      }
      
      public static function abbreviateNumber(n:Number, precision:int = 0) : String
      {
         var abbrNum:String = null;
         if(n >= 1000000)
         {
            n = n / 1000000;
            n = MathUtil.roundToPrecision(n,precision);
            abbrNum = n.toString() + "M";
         }
         else if(n >= 1000)
         {
            n = n / 1000;
            n = MathUtil.roundToPrecision(n,precision);
            abbrNum = n.toString() + "k";
         }
         else
         {
            n = MathUtil.roundToPrecision(n,precision);
            abbrNum = n.toString();
         }
         return abbrNum;
      }
      
      public static function commaFormatNumber(n:Number) : String
      {
         var split:Array = Math.round(n).toString().split("");
         var ct:int = 0;
         var output:Array = [];
         do
         {
            output.unshift(split.pop());
            ct++;
            if(ct == 3 && split.length > 0)
            {
               ct = 0;
               output.unshift(",");
            }
         }
         while(split.length > 0);
         
         return output.join("");
      }
      
      public static function commaAndConjunctionFormatWords(words:Array, conjunction:String = "and") : String
      {
         var output:String = null;
         var lastWord:String = null;
         if(words.length <= 1)
         {
            output = words.toString();
         }
         else if(words.length == 2)
         {
            output = words.join(" " + conjunction + " ");
         }
         else
         {
            lastWord = words.pop();
            output = words.join(", ");
            output = output + (" " + conjunction + " " + lastWord);
         }
         return output;
      }
      
      public static function makePlural(str:String, count:Number = 2) : String
      {
         if(count > 1 || count < 1)
         {
            return str + "s";
         }
         return str;
      }
      
      public static function makePosessive(str:String) : String
      {
         if(str.charAt(str.length) == "s")
         {
            return str + "\'";
         }
         return str + "\'s";
      }
      
      public static function makeSingular(str:String) : String
      {
         if(str.toLowerCase().charAt(str.length - 1) == "s")
         {
            return str.substr(0,str.length - 1);
         }
         return str;
      }
      
      public static function replaceMultiple(original:String, patterns:Array, replace:Array) : String
      {
         var result:String = original;
         var l:Number = Math.min(patterns.length,replace.length);
         for(var i:Number = 0; i < l; i++)
         {
            result = result.replace(patterns[i],replace[i]);
         }
         return result;
      }
      
      public static function makeLinksOpenNewWindow(t:String) : String
      {
         var pattern:RegExp = /(\<\s*a\s+href\s*=\s*[\"|\'][\S]+[\"|\'])()(\s*>)/mgi;
         var tText:String = t.replace(pattern,"$1 target=\'_blank\' $3");
         return tText;
      }
      
      public static function linkifyUrlsNotHrefs(t:String) : String
      {
         var pattern:RegExp = /((?:https{0,1}\:\/\/)|[^@\w\.]|^)([\w\.\-]*\.(com|tv|net|org|biz|gov|org|uk|info|us|fm|de)([\S]*[\/\w])*)\b/gi;
         var tText:String = t.replace(pattern,"<a href=\'http://$2\' target=\'_blank\'>$1$2</a>");
         return tText;
      }
      
      public static function prettyText(t:String, allowStandardCSS:Boolean = false, authorUserID:int = -1) : String
      {
         var tags:Array = null;
         var emptyTags:Array = null;
         var tag:String = null;
         var tagPattern:RegExp = null;
         if(t == null)
         {
            return null;
         }
         var tText:String = t;
         tText = tText.replace(/&amp;#8220;/g,"\"");
         tText = tText.replace(/&amp;#8221;/g,"\"");
         tText = tText.replace(/&amp;#8216;/g,"\'");
         tText = tText.replace(/&amp;#8217;/g,"\'");
         tText = tText.replace(/&amp;#8230;/g,"...");
         tText = tText.replace(/\</g,"&lt;");
         tText = tText.replace(/\>/g,"&gt;");
         if(allowStandardCSS)
         {
            tags = ["font","body","h1","h2","h3","h4","h5","h6","p","strong","stuff","a","span"];
            emptyTags = ["br"];
            for each(tag in tags)
            {
               tagPattern = new RegExp("&lt;" + tag + "((?:\\s+\\w+(?:\\s*=\\s*(?:\"[^\"]*?\"|\'[^\']*?\'))?)+\\s*|\\s*)&gt;((?:(?>(?:(?!&lt;).)+)|&lt;(?!" + tag + "\\b(?:(?!&gt;).)*&gt;))*?)&lt;/" + tag + "&gt;");
               while(tagPattern.test(tText))
               {
                  tText = tText.replace(tagPattern,"<" + tag + "$1>$2</" + tag + ">");
               }
            }
            for each(tag in emptyTags)
            {
               tagPattern = new RegExp("&lt;" + tag + "((?:\\s+\\w+(?:\\s*=\\s*(?:\"[^\"]*?\"|\'[^\']*?\'))?)+\\s*|\\s*)/&gt;");
               while(tagPattern.test(tText))
               {
                  tText = tText.replace(tagPattern,"<" + tag + "$1/>");
               }
            }
         }
         else
         {
            tText = tText.replace(/&apos;/g,"\'");
            tText = tText.replace(/&#39;/g,"\'");
            tText = tText.replace(/&quot;/g,"\"");
            tText = tText.replace(/&(?!lt;|gt;)/g,"&amp;");
         }
         tText = tText.replace(urlPattern,escapeLink);
         tText = eventifyInternalLinks(tText);
         tText = eventifyExternalLinks(tText,authorUserID);
         tText = tText.replace(/\r\n|\n\r|\n|\r/g,"<br>");
         return tText;
      }
      
      public static function get urlPattern() : RegExp
      {
         var pattern:RegExp = new RegExp("(?:(https?:\\/\\/))?((?:www\\.)?[-\\w]+(?:\\.[-\\w]+)*\\.(?:" + topLevelDomains.join("|") + "))(:\\d+)?([^\\s<>]*)","gi");
         return pattern;
      }
      
      public static function get internalURLPattern() : RegExp
      {
         var pattern:RegExp = new RegExp("(?:(https?:\\/\\/))?((?:www\\.)?(?:" + internalDomains.join("|") + "))(?!\\/" + externalDomainPaths.join("|\\/") + ")(:\\d+)?([^\\s<>]*)","gi");
         return pattern;
      }
      
      public static function get internalLinkPattern() : RegExp
      {
         var pattern:RegExp = new RegExp("((?:<a href=[\\\"\\\']))(http:\\/\\/(?:www\\.)?(?:" + internalDomains.join("|") + ")\\/)(?!" + externalDomainPaths.join("|") + ")([^\\\"\\\']+)","gi");
         return pattern;
      }
      
      public static function get externalLinkPattern() : RegExp
      {
         var pattern:RegExp = new RegExp("((?:<a href=))[\\\"\\\'](http:\\/\\/(?:www\\.)?((?!" + internalDomains.join("|") + ")[\\w\\.%]*)\\.(" + topLevelDomains.join("|") + ")[^\\\"\\\']*)[\\\"\\\']","gi");
         return pattern;
      }
      
      private static function escapeLink() : String
      {
         var args:Array = arguments;
         var protocol:String = arguments[1];
         var domain:String = arguments[2];
         var port:String = arguments[3];
         var path:String = escape(unescape(arguments[4]));
         path = path.replace(/\%23/g,"#");
         path = path.replace(/\%3F/g,"?");
         path = path.replace(/\%26/g,"&");
         path = path.replace(/\%3D/g,"=");
         var url:String = (Boolean(protocol)?protocol:"http://") + domain + port + path;
         var text:String = protocol + domain + port + path;
         var link:String = "<a href=\'" + url + "\'>" + text + "</a>";
         return link;
      }
      
      public static function eventifyInternalLinks(t:String) : String
      {
         var result:String = t;
         try
         {
            result = t.replace(internalLinkPattern,"$1event:$3");
         }
         catch(e:Error)
         {
         }
         result = replaceLinkText(result);
         return result;
      }
      
      public static function eventifyExternalLinks(t:String, authorUserID:int = -1) : String
      {
         var result:String = t;
         try
         {
            result = t.replace(externalLinkPattern,"$1\'event:$2,%USER_ID%\'");
            result = result.replace(/%USER_ID%/gi,authorUserID);
         }
         catch(e:Error)
         {
         }
         return result;
      }
      
      public static function replaceLinkText(t:String) : String
      {
         var pattern:RegExp = null;
         var result:String = t;
         try
         {
            pattern = /((?:<a href=[\"'])(?:event:)((?:[^\"']+))[\"'].*?>)(.*?)(<\/a>)/gi;
            result = t.replace(pattern,replaceInternalLinkTextFunction);
         }
         catch(e:Error)
         {
         }
         return result;
      }
      
      private static function replaceInternalLinkTextFunction() : String
      {
         var inviteLink:String = null;
         var gameID:String = null;
         var gamePack:ArcadeGamePackData = null;
         var chatroomName:String = null;
         var asciiPattern:RegExp = null;
         var endIndex:int = 0;
         var recruiterID:String = null;
         var args:Array = arguments;
         var t:String = arguments[0];
         var subPath:Array = String(arguments[2]).split("/");
         var firstSubPath:String = subPath.shift();
         if(firstSubPath == "#")
         {
            firstSubPath = subPath.shift();
         }
         var secondSubPath:String = subPath.length > 0?subPath.shift():null;
         var ignoreRewrite:Boolean = subPath.length > 0 && subPath[subPath.length - 1] == "ignore_rewrite" || secondSubPath && secondSubPath == "ignore_rewrite"?Boolean(true):Boolean(false);
         if(ignoreRewrite)
         {
            t = t.replace(/\/ignore_rewrite/g,"");
            return t;
         }
         if(firstSubPath == "i")
         {
            inviteLink = subPath.shift();
            gameID = secondSubPath;
            gamePack = AppComponents.model.arcade.getCatalogItem(gameID);
            if(gameID && arguments[6].indexOf("Play me in") == -1)
            {
               t = arguments[1] + "Play me in " + gamePack.title + arguments[4];
            }
         }
         else if(firstSubPath == "chatrooms")
         {
            chatroomName = secondSubPath;
            asciiPattern = /%(0(0|1|2|3|4|5|6|7|8|9|A|B|C|D|E|F)|(1(0|1|2|3|4|5|6|7|8|9|A|B|C|D|E|F)|(7F)))/gi;
            chatroomName = chatroomName.replace(asciiPattern,"");
            if(chatroomName)
            {
               t = arguments[1] + "Chat with me in " + unescape(chatroomName) + arguments[4];
            }
         }
         else if(firstSubPath.indexOf("?r=") == 0)
         {
            endIndex = firstSubPath.indexOf("&") > -1?int(firstSubPath.indexOf("&")):int(firstSubPath.length);
            recruiterID = firstSubPath.substring(3,endIndex);
            t = "<a href=\'event:recruiter/" + recruiterID + "\'>" + arguments[3] + "</a>";
         }
         return t;
      }
      
      public static function eventifyLinks(t:String) : String
      {
         var pattern:RegExp = /href\s*=\s*[\'|\"](?!event:)/gi;
         var tText:String = t.replace(pattern,"$&event:");
         var pattern2:RegExp = /http\:\/\/iminlikewithyou\.com/gi;
         var tText2:String = tText.replace(pattern2,"");
         return tText2;
      }
      
      public static function isLinkInternal(link:String) : Boolean
      {
         var pattern:RegExp = /http:\/\/(w{3}\.)?(iminlikewithyou.com|iilwy.com|omgpop.com)(\/[^\s]+)?/;
         return pattern.test(link);
      }
      
      public static function getDeepLinkURL(internalLink:String) : String
      {
         var pattern:RegExp = /http:\/\/(w{3}\.)?(iminlikewithyou.com|iilwy.com|omgpop.com)(?P<deeplink>\/[^\s]+)?/;
         var result:Object = pattern.exec(internalLink);
         var deepLink:String = result && result.deeplink?result.deeplink:null;
         return deepLink;
      }
      
      public static function prettyFormText(t:String) : String
      {
         if(t == null)
         {
            return null;
         }
         var tText:String = t;
         tText = tText.replace(/&amp;#8220;/g,"\"");
         tText = tText.replace(/&amp;#8221;/g,"\"");
         tText = tText.replace(/&amp;#8217;/g,"\'");
         tText = tText.replace(/&amp;#8230;/g,"...");
         tText = tText.replace(/&#39;/g,"\'");
         tText = tText.replace(/&quot;/g,"\"");
         tText = tText.replace(/&lt;/g,"<");
         tText = tText.replace(/&gt;/g,">");
         tText = tText.replace(/&apos;/g,"\'");
         tText = tText.replace(/&amp;/g,"&");
         tText = tText.replace(/&amp;/g,"&");
         return tText;
      }
      
      public static function prettyTextNoLinkify(t:String) : String
      {
         var tText:String = t;
         tText = tText.replace(/&amp;#8220;/g,"\"");
         tText = tText.replace(/&amp;#8221;/g,"\"");
         tText = tText.replace(/&amp;#8217;/g,"\'");
         tText = tText.replace(/&amp;#8230;/g,"...");
         tText = tText.replace(/&#39;/g,"\'");
         tText = tText.replace(/&quot;/g,"\"");
         tText = tText.replace(/&lt;/g,"<");
         tText = tText.replace(/&gt;/g,">");
         tText = tText.replace(/&apos;/g,"\'");
         tText = tText.replace(/&amp;/g,"&");
         tText = tText.replace(/&amp;/g,"&");
         tText = tText.replace(/\r\n|\n\r|\n|\r/g,"<br>");
         return tText;
      }
      
      public static function replaceChars(text:String) : String
      {
         if(!text)
         {
            return "";
         }
         text = text.replace(/&quot;/g,"\"");
         text = text.replace(/\r\n|\n\r|\n|\r/g,"<br>");
         return text;
      }
      
      public static function removeWhiteSpace(text:String) : String
      {
         if(!text)
         {
            return "";
         }
         return text.replace(/\s|!|\.|\*|\/|\'/gi,"_");
      }
      
      public static function spaceEscape(text:String) : String
      {
         if(!text)
         {
            return "";
         }
         return text.replace(/\s/gi,"+");
      }
      
      public static function stripTags(text:String) : String
      {
         if(!text)
         {
            return "";
         }
         return text.replace(/<\/?[^>]+>/gim,"");
      }
      
      public static function parseEmbeddedXML(source:Class) : XML
      {
         var byteArray:ByteArray = new source() as ByteArray;
         var string:String = byteArray.readUTFBytes(byteArray.length);
         XML.ignoreWhitespace = true;
         var xml:XML = new XML(string);
         return xml;
      }
      
      public static function splitQueryString(query:String) : Object
      {
         var parts:Array = null;
         var name:String = null;
         var value:String = null;
         var parameters:Object = {};
         if(query.charAt(0) == "?")
         {
            query = query.substr(1,query.length - 1);
         }
         var nameValuePairs:Array = query.split("&");
         var len:int = nameValuePairs.length;
         for(var i:int = 0; i < len; i++)
         {
            parts = (nameValuePairs[i] as String).split("=");
            name = parts[0];
            value = parts[1];
            parameters[name] = value;
         }
         return parameters;
      }
      
      public static function getEmoticonFromText(text:String) : String
      {
         var emoticonURL:String = null;
         var emoticons:Object = {};
         emoticons[":)"] = "smile";
         emoticons[":("] = "frown";
         emoticons[":D"] = "happy";
         emoticons[":o"] = "surprise";
         emoticons[":*"] = "kiss";
         emoticons[":/"] = "confused";
         emoticons[":\\"] = "confused";
         emoticons[";)"] = "wink";
         emoticons["B)"] = "cool";
         emoticons[":\'("] = "cry";
         var emotion:String = emoticons[text];
         if(emotion)
         {
            emoticonURL = AppProperties.fileServerStatic + "graphics-emoticons-" + emotion + ".png";
         }
         return emoticonURL;
      }
      
      public static function toSentenceCase(value:String, upperCaseAll:Boolean = false) : String
      {
         var words:Array = null;
         var i:int = 0;
         if(!value)
         {
            return value;
         }
         if(value.indexOf(" ") && upperCaseAll)
         {
            words = value.split(" ");
            value = "";
            for(i = 0; i < words.length; i++)
            {
               words[i] = words[i].charAt(0).toUpperCase() + words[i].substr(1,words[i].length).toLowerCase();
            }
            value = words.join(" ");
         }
         else
         {
            value = value.charAt(0).toUpperCase() + value.substr(1,value.length).toLowerCase();
         }
         return value;
      }
      
      public static function dayArray() : Array
      {
         var days:Array = [];
         for(var i:int = 1; i <= 31; i++)
         {
            days.push(i.toString());
         }
         return days;
      }
      
      public static function monthArray() : Array
      {
         var months:Array = ["January","February","March","April","May","June","July","August","September","October","November","December"];
         return months;
      }
      
      public static function yearArray(upTo:int = 0) : Array
      {
         var currentYear:int = new Date().fullYear - upTo;
         var years:Array = [];
         for(var i:int = 1900; i <= currentYear; i++)
         {
            years.push(i.toString());
         }
         return years;
      }
      
      public static function getCoolWord() : String
      {
         var words:Array = ["Whoa","Sweet","Hot","OMGz","LOL","LOO","Wat","MFJ","COWABUNGA","Boioioioing","Srsly","4srs","Really","Fo shizzle","SAWCY","BBQ","Shoop","r0x0rs","OH SNAP","w00t","YARR","shizznizz","DING"];
         var id:int = Math.random() * words.length - 1;
         return words[id];
      }
      
      public static function countryArray() : Array
      {
         var countries:Array = [{
            "label":"Afghanistan",
            "value":"Afghanistan"
         },{
            "label":"Albania",
            "value":"Albania"
         },{
            "label":"Algeria",
            "value":"Algeria"
         },{
            "label":"American Samoa",
            "value":"American Samoa"
         },{
            "label":"Andorra",
            "value":"Andorra"
         },{
            "label":"Angola",
            "value":"Angola"
         },{
            "label":"Anguilla",
            "value":"Anguilla"
         },{
            "label":"Antarctica",
            "value":"Antarctica"
         },{
            "label":"Antigua and Barbuda",
            "value":"Antigua and Barbuda"
         },{
            "label":"Argentina",
            "value":"Argentina"
         },{
            "label":"Armenia",
            "value":"Armenia"
         },{
            "label":"Aruba",
            "value":"Aruba"
         },{
            "label":"Australia",
            "value":"Australia"
         },{
            "label":"Austria",
            "value":"Austria"
         },{
            "label":"Azerbaijan",
            "value":"Azerbaijan"
         },{
            "label":"Bahamas",
            "value":"Bahamas"
         },{
            "label":"Bahrain",
            "value":"Bahrain"
         },{
            "label":"Bangladesh",
            "value":"Bangladesh"
         },{
            "label":"Barbados",
            "value":"Barbados"
         },{
            "label":"Belarus",
            "value":"Belarus"
         },{
            "label":"Belgium",
            "value":"Belgium"
         },{
            "label":"Belize",
            "value":"Belize"
         },{
            "label":"Benin",
            "value":"Benin"
         },{
            "label":"Bermuda",
            "value":"Bermuda"
         },{
            "label":"Bhutan",
            "value":"Bhutan"
         },{
            "label":"Bolivia",
            "value":"Bolivia"
         },{
            "label":"Bosnia and Herzegovina",
            "value":"Bosnia and Herzegovina"
         },{
            "label":"Botswana",
            "value":"Botswana"
         },{
            "label":"Bouvet Island",
            "value":"Bouvet Island"
         },{
            "label":"Brazil",
            "value":"Brazil"
         },{
            "label":"British Indian Ocean territory",
            "value":"British Indian Ocean territory"
         },{
            "label":"Brunei Darussalam",
            "value":"Brunei Darussalam"
         },{
            "label":"Bulgaria",
            "value":"Bulgaria"
         },{
            "label":"Burkina Faso",
            "value":"Burkina Faso"
         },{
            "label":"Burundi",
            "value":"Burundi"
         },{
            "label":"Cambodia",
            "value":"Cambodia"
         },{
            "label":"Cameroon",
            "value":"Cameroon"
         },{
            "label":"Canada",
            "value":"Canada"
         },{
            "label":"Cape Verde",
            "value":"Cape Verde"
         },{
            "label":"Cayman Islands",
            "value":"Cayman Islands"
         },{
            "label":"Central African Republic",
            "value":"Central African Republic"
         },{
            "label":"Chad",
            "value":"Chad"
         },{
            "label":"Chile",
            "value":"Chile"
         },{
            "label":"China",
            "value":"China"
         },{
            "label":"Christmas Island",
            "value":"Christmas Island"
         },{
            "label":"Cocos (Keeling) Islands",
            "value":"Cocos (Keeling) Islands"
         },{
            "label":"Colombia",
            "value":"Colombia"
         },{
            "label":"Comoros",
            "value":"Comoros"
         },{
            "label":"Congo",
            "value":"Congo"
         },{
            "label":"Congo, Democratic Republic",
            "value":"Congo, Democratic Republic"
         },{
            "label":"Cook Islands",
            "value":"Cook Islands"
         },{
            "label":"Costa Rica",
            "value":"Costa Rica"
         },{
            "label":"Cote d\'Ivoire (Ivory Coast)",
            "value":"Cote d\'Ivoire (Ivory Coast)"
         },{
            "label":"Croatia (Hrvatska)",
            "value":"Croatia (Hrvatska)"
         },{
            "label":"Cuba",
            "value":"Cuba"
         },{
            "label":"Cyprus",
            "value":"Cyprus"
         },{
            "label":"Czech Republic",
            "value":"Czech Republic"
         },{
            "label":"Denmark",
            "value":"Denmark"
         },{
            "label":"Djibouti",
            "value":"Djibouti"
         },{
            "label":"Dominica",
            "value":"Dominica"
         },{
            "label":"Dominican Republic",
            "value":"Dominican Republic"
         },{
            "label":"East Timor",
            "value":"East Timor"
         },{
            "label":"Ecuador",
            "value":"Ecuador"
         },{
            "label":"Egypt",
            "value":"Egypt"
         },{
            "label":"El Salvador",
            "value":"El Salvador"
         },{
            "label":"Equatorial Guinea",
            "value":"Equatorial Guinea"
         },{
            "label":"Eritrea",
            "value":"Eritrea"
         },{
            "label":"Estonia",
            "value":"Estonia"
         },{
            "label":"Ethiopia",
            "value":"Ethiopia"
         },{
            "label":"Falkland Islands",
            "value":"Falkland Islands"
         },{
            "label":"Faroe Islands",
            "value":"Faroe Islands"
         },{
            "label":"Fiji",
            "value":"Fiji"
         },{
            "label":"Finland",
            "value":"Finland"
         },{
            "label":"France",
            "value":"France"
         },{
            "label":"French Guiana",
            "value":"French Guiana"
         },{
            "label":"French Polynesia",
            "value":"French Polynesia"
         },{
            "label":"French Southern Territories",
            "value":"French Southern Territories"
         },{
            "label":"Gabon",
            "value":"Gabon"
         },{
            "label":"Gambia",
            "value":"Gambia"
         },{
            "label":"Georgia",
            "value":"Georgia"
         },{
            "label":"Germany",
            "value":"Germany"
         },{
            "label":"Ghana",
            "value":"Ghana"
         },{
            "label":"Gibraltar",
            "value":"Gibraltar"
         },{
            "label":"Greece",
            "value":"Greece"
         },{
            "label":"Greenland",
            "value":"Greenland"
         },{
            "label":"Grenada",
            "value":"Grenada"
         },{
            "label":"Guadeloupe",
            "value":"Guadeloupe"
         },{
            "label":"Guam",
            "value":"Guam"
         },{
            "label":"Guatemala",
            "value":"Guatemala"
         },{
            "label":"Guinea",
            "value":"Guinea"
         },{
            "label":"Guinea-Bissau",
            "value":"Guinea-Bissau"
         },{
            "label":"Guyana",
            "value":"Guyana"
         },{
            "label":"Haiti",
            "value":"Haiti"
         },{
            "label":"Heard and McDonald Islands",
            "value":"Heard and McDonald Islands"
         },{
            "label":"Honduras",
            "value":"Honduras"
         },{
            "label":"Hong Kong",
            "value":"Hong Kong"
         },{
            "label":"Hungary",
            "value":"Hungary"
         },{
            "label":"Iceland",
            "value":"Iceland"
         },{
            "label":"India",
            "value":"India"
         },{
            "label":"Indonesia",
            "value":"Indonesia"
         },{
            "label":"Iran",
            "value":"Iran"
         },{
            "label":"Iraq",
            "value":"Iraq"
         },{
            "label":"Ireland",
            "value":"Ireland"
         },{
            "label":"Israel",
            "value":"Israel"
         },{
            "label":"Italy",
            "value":"Italy"
         },{
            "label":"Jamaica",
            "value":"Jamaica"
         },{
            "label":"Japan",
            "value":"Japan"
         },{
            "label":"Jordan",
            "value":"Jordan"
         },{
            "label":"Kazakhstan",
            "value":"Kazakhstan"
         },{
            "label":"Kenya",
            "value":"Kenya"
         },{
            "label":"Kiribati",
            "value":"Kiribati"
         },{
            "label":"Korea (north)",
            "value":"Korea (north)"
         },{
            "label":"Korea (south)",
            "value":"Korea (south)"
         },{
            "label":"Kuwait",
            "value":"Kuwait"
         },{
            "label":"Kyrgyzstan",
            "value":"Kyrgyzstan"
         },{
            "label":"Lao People\'s Democratic Republic",
            "value":"Lao People\'s Democratic Republic"
         },{
            "label":"Latvia",
            "value":"Latvia"
         },{
            "label":"Lebanon",
            "value":"Lebanon"
         },{
            "label":"Lesotho",
            "value":"Lesotho"
         },{
            "label":"Liberia",
            "value":"Liberia"
         },{
            "label":"Libyan Arab Jamahiriya",
            "value":"Libyan Arab Jamahiriya"
         },{
            "label":"Liechtenstein",
            "value":"Liechtenstein"
         },{
            "label":"Lithuania",
            "value":"Lithuania"
         },{
            "label":"Luxembourg",
            "value":"Luxembourg"
         },{
            "label":"Macao",
            "value":"Macao"
         },{
            "label":"Macedonia",
            "value":"Macedonia"
         },{
            "label":"Madagascar",
            "value":"Madagascar"
         },{
            "label":"Malawi",
            "value":"Malawi"
         },{
            "label":"Malaysia",
            "value":"Malaysia"
         },{
            "label":"Maldives",
            "value":"Maldives"
         },{
            "label":"Mali",
            "value":"Mali"
         },{
            "label":"Malta",
            "value":"Malta"
         },{
            "label":"Marshall Islands",
            "value":"Marshall Islands"
         },{
            "label":"Martinique",
            "value":"Martinique"
         },{
            "label":"Mauritania",
            "value":"Mauritania"
         },{
            "label":"Mauritius",
            "value":"Mauritius"
         },{
            "label":"Mayotte",
            "value":"Mayotte"
         },{
            "label":"Mexico",
            "value":"Mexico"
         },{
            "label":"Micronesia",
            "value":"Micronesia"
         },{
            "label":"Moldova",
            "value":"Moldova"
         },{
            "label":"Monaco",
            "value":"Monaco"
         },{
            "label":"Mongolia",
            "value":"Mongolia"
         },{
            "label":"Montserrat",
            "value":"Montserrat"
         },{
            "label":"Morocco",
            "value":"Morocco"
         },{
            "label":"Mozambique",
            "value":"Mozambique"
         },{
            "label":"Myanmar",
            "value":"Myanmar"
         },{
            "label":"Namibia",
            "value":"Namibia"
         },{
            "label":"Nauru",
            "value":"Nauru"
         },{
            "label":"Nepal",
            "value":"Nepal"
         },{
            "label":"Netherlands",
            "value":"Netherlands"
         },{
            "label":"Netherlands Antilles",
            "value":"Netherlands Antilles"
         },{
            "label":"New Caledonia",
            "value":"New Caledonia"
         },{
            "label":"New Zealand",
            "value":"New Zealand"
         },{
            "label":"Nicaragua",
            "value":"Nicaragua"
         },{
            "label":"Niger",
            "value":"Niger"
         },{
            "label":"Nigeria",
            "value":"Nigeria"
         },{
            "label":"Niue",
            "value":"Niue"
         },{
            "label":"Norfolk Island",
            "value":"Norfolk Island"
         },{
            "label":"Northern Mariana Islands",
            "value":"Northern Mariana Islands"
         },{
            "label":"Norway",
            "value":"Norway"
         },{
            "label":"Oman",
            "value":"Oman"
         },{
            "label":"Pakistan",
            "value":"Pakistan"
         },{
            "label":"Palau",
            "value":"Palau"
         },{
            "label":"Palestinian Territories",
            "value":"Palestinian Territories"
         },{
            "label":"Panama",
            "value":"Panama"
         },{
            "label":"Papua New Guinea",
            "value":"Papua New Guinea"
         },{
            "label":"Paraguay",
            "value":"Paraguay"
         },{
            "label":"Peru",
            "value":"Peru"
         },{
            "label":"Philippines",
            "value":"Philippines"
         },{
            "label":"Pitcairn",
            "value":"Pitcairn"
         },{
            "label":"Poland",
            "value":"Poland"
         },{
            "label":"Portugal",
            "value":"Portugal"
         },{
            "label":"Puerto Rico",
            "value":"Puerto Rico"
         },{
            "label":"Qatar",
            "value":"Qatar"
         },{
            "label":"Romania",
            "value":"Romania"
         },{
            "label":"Russian Federation",
            "value":"Russian Federation"
         },{
            "label":"Rwanda",
            "value":"Rwanda"
         },{
            "label":"Saint Helena",
            "value":"Saint Helena"
         },{
            "label":"Saint Kitts and Nevis",
            "value":"Saint Kitts and Nevis"
         },{
            "label":"Saint Lucia",
            "value":"Saint Lucia"
         },{
            "label":"Saint Pierre and Miquelon",
            "value":"Saint Pierre and Miquelon"
         },{
            "label":"Saint Vincent and the Grenadines",
            "value":"Saint Vincent and the Grenadines"
         },{
            "label":"Samoa",
            "value":"Samoa"
         },{
            "label":"San Marino",
            "value":"San Marino"
         },{
            "label":"Sao Tome and Principe",
            "value":"Sao Tome and Principe"
         },{
            "label":"Saudi Arabia",
            "value":"Saudi Arabia"
         },{
            "label":"Senegal",
            "value":"Senegal"
         },{
            "label":"Serbia and Montenegro",
            "value":"Serbia and Montenegro"
         },{
            "label":"Seychelles",
            "value":"Seychelles"
         },{
            "label":"Sierra Leone",
            "value":"Sierra Leone"
         },{
            "label":"Singapore",
            "value":"Singapore"
         },{
            "label":"Slovakia",
            "value":"Slovakia"
         },{
            "label":"Slovenia",
            "value":"Slovenia"
         },{
            "label":"Solomon Islands",
            "value":"Solomon Islands"
         },{
            "label":"Somalia",
            "value":"Somalia"
         },{
            "label":"South Africa",
            "value":"South Africa"
         },{
            "label":"South Georgia and the South Sandwich Islands",
            "value":"South Georgia and the South Sandwich Islands"
         },{
            "label":"Spain",
            "value":"Spain"
         },{
            "label":"Sri Lanka",
            "value":"Sri Lanka"
         },{
            "label":"Sudan",
            "value":"Sudan"
         },{
            "label":"Suriname",
            "value":"Suriname"
         },{
            "label":"Svalbard and Jan Mayen Islands",
            "value":"Svalbard and Jan Mayen Islands"
         },{
            "label":"Swaziland",
            "value":"Swaziland"
         },{
            "label":"Sweden",
            "value":"Sweden"
         },{
            "label":"Switzerland",
            "value":"Switzerland"
         },{
            "label":"Syria",
            "value":"Syria"
         },{
            "label":"Taiwan",
            "value":"Taiwan"
         },{
            "label":"Tajikistan",
            "value":"Tajikistan"
         },{
            "label":"Tanzania",
            "value":"Tanzania"
         },{
            "label":"Thailand",
            "value":"Thailand"
         },{
            "label":"Togo",
            "value":"Togo"
         },{
            "label":"Tokelau",
            "value":"Tokelau"
         },{
            "label":"Tonga",
            "value":"Tonga"
         },{
            "label":"Trinidad and Tobago",
            "value":"Trinidad and Tobago"
         },{
            "label":"Tunisia",
            "value":"Tunisia"
         },{
            "label":"Turkey",
            "value":"Turkey"
         },{
            "label":"Turkmenistan",
            "value":"Turkmenistan"
         },{
            "label":"Turks and Caicos Islands",
            "value":"Turks and Caicos Islands"
         },{
            "label":"Tuvalu",
            "value":"Tuvalu"
         },{
            "label":"Uganda",
            "value":"Uganda"
         },{
            "label":"Ukraine",
            "value":"Ukraine"
         },{
            "label":"United Arab Emirates",
            "value":"United Arab Emirates"
         },{
            "label":"United Kingdom",
            "value":"United Kingdom"
         },{
            "label":"United States of America",
            "value":"US"
         },{
            "label":"Uruguay",
            "value":"Uruguay"
         },{
            "label":"Uzbekistan",
            "value":"Uzbekistan"
         },{
            "label":"Vanuatu",
            "value":"Vanuatu"
         },{
            "label":"Vatican City",
            "value":"Vatican City"
         },{
            "label":"Venezuela",
            "value":"Venezuela"
         },{
            "label":"Vietnam",
            "value":"Vietnam"
         },{
            "label":"Virgin Islands (British)",
            "value":"Virgin Islands (British)"
         },{
            "label":"Virgin Islands (US)",
            "value":"Virgin Islands (US)"
         },{
            "label":"Wallis and Futuna Islands",
            "value":"Wallis and Futuna Islands"
         },{
            "label":"Western Sahara",
            "value":"Western Sahara"
         },{
            "label":"Yemen",
            "value":"Yemen"
         },{
            "label":"Zaire",
            "value":"Zaire"
         },{
            "label":"Zambia",
            "value":"Zambia"
         },{
            "label":"Zimbabwe",
            "value":"Zimbabwe"
         }];
         return countries;
      }
   }
}
