package iilwy.utils
{
   public class EmbedUtil
   {
       
      
      public function EmbedUtil()
      {
         super();
      }
      
      public static function commentedVideoKey(id:String) : String
      {
         return UrlCodeEncryption.decrypt("commentedvideo_" + id);
      }
      
      public static function arcadeStatsBadgeEmbed(gameId:String, profileId:String) : String
      {
         var key:String = "arcadestatsbadge?" + "game_id=" + gameId + "&profile_id=" + profileId;
         var code:String = embedCode(key,175,330);
         return code;
      }
      
      public static function omgpopARPromoEmbed() : String
      {
         var key:String = "omgpopARPromo";
         var code:String = embedCode(key,400,300);
         return code;
      }
      
      public static function arcadeGameEmbed(gameId:String) : String
      {
         var key:String = "externalarcade?" + "initialUrl=" + "arcade/gamelobby/" + gameId;
         var code:String = embedCode(key,800,480);
         return code;
      }
      
      public static function embedCode(key:String, width:Number, height:Number) : String
      {
         var code:String = "<object classid=\"clsid:D27CDB6E-AE6D-11cf-96B8-444553540000\" width=\"#width#\" height=\"#height#\" id=\"omgpop\">" + "<param name=\"movie\" value=\"http://flashcdn.omgpop.com/embedder.swf?key=#key#\" />" + "<param name=\"allowScriptAccess\" value=\"always\" />" + "<param name=\"allowFullScreen\" value=\"true\" />" + "<embed src=\"http://flashcdn.omgpop.com/embedder.swf?key=#key#\" width=\"#width#\" height=\"#height#\" type=\"application/x-shockwave-flash\" allowScriptAccess=\"always\" allowFullScreen=\"true\" name=\"omgpop\" ></embed>" + "</object>" + "<br/><a href = \"http://www.omgpop.com\">Play fun multiplayer games</a>";
         var result:String = code;
         result = result.replace(/#key#/g,UrlCodeEncryption.encrypt(key));
         result = result.replace(/#width#/g,width);
         result = result.replace(/#height#/g,height);
         return result;
      }
   }
}
