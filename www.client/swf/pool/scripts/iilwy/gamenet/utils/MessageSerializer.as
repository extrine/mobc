package iilwy.gamenet.utils
{
   import iilwy.utils.logging.Logger;
   
   public class MessageSerializer
   {
      
      public static const TYPE_NOTIFICATION:int = 1;
      
      public static const TYPE_CHAT:int = 2;
      
      public static const TYPE_LOBBYEVENT:int = 3;
      
      public static const TYPE_MATCHMAKINGEVENT:int = 4;
      
      public static const TYPE_GAMEACTION:int = 5;
      
      public static const TYPE_GENERIC:int = 6;
      
      public static const TYPE_PING:int = 7;
      
      private static var _instance:MessageSerializer;
       
      
      private var _logger:Logger;
      
      public function MessageSerializer()
      {
         super();
         this._logger = Logger.getLogger(this);
         this._logger.level = Logger.NONE;
      }
      
      public static function getInstance() : MessageSerializer
      {
         if(_instance == null)
         {
            _instance = new MessageSerializer();
         }
         return _instance;
      }
      
      public function serialize(obj:Object) : String
      {
         var regexp:RegExp = null;
         var str:String = JSON.serialize(obj);
         regexp = /|/gi;
         str = str.replace(regexp,"");
         regexp = /"/gi;
         str = str.replace(regexp,"|");
         return str;
      }
      
      public function deserialize(string:String) : Object
      {
         var parsed:String = null;
         var obj:Object = new Object();
         try
         {
            parsed = string.replace(/\|/gi,"\"");
            obj = JSON.deserialize(parsed);
         }
         catch(e:Error)
         {
         }
         if(obj.type == null)
         {
            obj.type = MessageSerializer.TYPE_GENERIC;
            obj.data = string;
         }
         return obj;
      }
      
      public function extractPlayerJIDFromSender(sender:String) : String
      {
         return sender.match(/\/(\w+$)/)[1];
      }
   }
}
