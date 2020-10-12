package org.igniterealtime.xiff.auth
{
   import com.hurlant.crypto.hash.MD5;
   import com.hurlant.util.Base64;
   import com.hurlant.util.Hex;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import org.igniterealtime.xiff.core.XMPPConnection;
   
   public class XFacebookPlatform extends SASLAuth
   {
      
      public static const MECHANISM:String = "X-FACEBOOK-PLATFORM";
      
      public static const NS:String = "urn:ietf:params:xml:ns:xmpp-sasl";
      
      public static var fb_api_key:String;
      
      public static var fb_secret:String;
      
      public static var fb_session_key:String;
       
      
      public function XFacebookPlatform(connection:XMPPConnection)
      {
         super();
         req.setNamespace(XFacebookPlatform.NS);
         req.@mechanism = XFacebookPlatform.MECHANISM;
         response.setNamespace(XFacebookPlatform.NS);
         stage = 0;
      }
      
      public static function setFacebookSessionValues(api_key:String, secret:String, session_key:String) : void
      {
         fb_api_key = api_key;
         fb_secret = secret;
         fb_session_key = session_key;
      }
      
      public static function formatSig(map:Dictionary) : String
      {
         var p:* = null;
         var s:String = null;
         var arg:* = undefined;
         var md5:MD5 = new MD5();
         var a:Array = [];
         for(p in map)
         {
            arg = map[p];
            a.push(p + "=" + arg.toString());
         }
         a.sort();
         s = a.join("");
         if(fb_secret != null)
         {
            s = s + fb_secret;
         }
         var sig:ByteArray = new ByteArray();
         sig.writeUTFBytes(s);
         sig = md5.hash(sig);
         return Hex.fromArray(sig);
      }
      
      override public function handleChallenge(stage:int, challenge:XML) : XML
      {
         var keyValuePair:String = null;
         var responseMap:Dictionary = null;
         var challengeResponse:String = null;
         var resp:XML = null;
         var keyValue:Array = null;
         var decodedChallenge:String = Base64.decode(challenge);
         var challengeKeyValuePairs:Array = decodedChallenge.split("&");
         var challengeMap:Dictionary = new Dictionary();
         for each(keyValuePair in challengeKeyValuePairs)
         {
            keyValue = keyValuePair.split("=");
            challengeMap[keyValue[0]] = keyValue[1];
         }
         responseMap = new Dictionary();
         responseMap.api_key = fb_api_key;
         responseMap.call_id = new Date().time;
         responseMap.method = challengeMap.method;
         responseMap.nonce = challengeMap.nonce;
         responseMap.session_key = fb_session_key;
         responseMap.v = "1.0";
         responseMap.sig = formatSig(responseMap);
         challengeResponse = "api_key=" + responseMap.api_key;
         challengeResponse = challengeResponse + ("&call_id=" + responseMap.call_id);
         challengeResponse = challengeResponse + ("&method=" + responseMap.method);
         challengeResponse = challengeResponse + ("&nonce=" + responseMap.nonce);
         challengeResponse = challengeResponse + ("&session_key=" + responseMap.session_key);
         challengeResponse = challengeResponse + ("&sig=" + responseMap.sig);
         challengeResponse = challengeResponse + ("&v=" + responseMap.v);
         challengeResponse = Base64.encode(challengeResponse);
         resp = response;
         resp.setChildren(challengeResponse);
         return resp;
      }
      
      override public function handleResponse(stage:int, response:XML) : Object
      {
         var success:Boolean = response.localName() == "success";
         return {
            "authComplete":true,
            "authSuccess":success,
            "authStage":stage++
         };
      }
   }
}
