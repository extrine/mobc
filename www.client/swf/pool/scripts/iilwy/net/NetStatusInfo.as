package iilwy.net
{
   import flash.utils.Dictionary;
   
   public class NetStatusInfo
   {
      
      public static const NETSTREAM_BUFFER_EMPTY:NetStatusInfo = new NetStatusInfo(NetStatusCode.NETSTREAM_BUFFER_EMPTY,NetStatusLevel.STATUS);
      
      public static const NETSTREAM_BUFFER_FULL:NetStatusInfo = new NetStatusInfo(NetStatusCode.NETSTREAM_BUFFER_FULL,NetStatusLevel.STATUS);
      
      public static const NETSTREAM_BUFFER_FLUSH:NetStatusInfo = new NetStatusInfo(NetStatusCode.NETSTREAM_BUFFER_FLUSH,NetStatusLevel.STATUS);
      
      public static const NETSTREAM_FAILED:NetStatusInfo = new NetStatusInfo(NetStatusCode.NETSTREAM_FAILED,NetStatusLevel.ERROR);
      
      public static const NETSTREAM_PUBLISH_START:NetStatusInfo = new NetStatusInfo(NetStatusCode.NETSTREAM_PUBLISH_START,NetStatusLevel.STATUS);
      
      public static const NETSTREAM_PUBLISH_BADNAME:NetStatusInfo = new NetStatusInfo(NetStatusCode.NETSTREAM_PUBLISH_BADNAME,NetStatusLevel.ERROR);
      
      public static const NETSTREAM_PUBLISH_IDLE:NetStatusInfo = new NetStatusInfo(NetStatusCode.NETSTREAM_PUBLISH_IDLE,NetStatusLevel.STATUS);
      
      public static const NETSTREAM_UNPUBLISH_SUCCESS:NetStatusInfo = new NetStatusInfo(NetStatusCode.NETSTREAM_UNPUBLISH_SUCCESS,NetStatusLevel.STATUS);
      
      public static const NETSTREAM_PLAY_START:NetStatusInfo = new NetStatusInfo(NetStatusCode.NETSTREAM_PLAY_START,NetStatusLevel.STATUS);
      
      public static const NETSTREAM_PLAY_STOP:NetStatusInfo = new NetStatusInfo(NetStatusCode.NETSTREAM_PLAY_STOP,NetStatusLevel.STATUS);
      
      public static const NETSTREAM_PLAY_FAILED:NetStatusInfo = new NetStatusInfo(NetStatusCode.NETSTREAM_PLAY_FAILED,NetStatusLevel.ERROR);
      
      public static const NETSTREAM_PLAY_STREAMNOTFOUND:NetStatusInfo = new NetStatusInfo(NetStatusCode.NETSTREAM_PLAY_STREAMNOTFOUND,NetStatusLevel.ERROR);
      
      public static const NETSTREAM_PLAY_RESET:NetStatusInfo = new NetStatusInfo(NetStatusCode.NETSTREAM_PLAY_RESET,NetStatusLevel.STATUS);
      
      public static const NETSTREAM_PLAY_PUBLISHNOTIFY:NetStatusInfo = new NetStatusInfo(NetStatusCode.NETSTREAM_PLAY_PUBLISHNOTIFY,NetStatusLevel.STATUS);
      
      public static const NETSTREAM_PLAY_UNPUBLISHNOTIFY:NetStatusInfo = new NetStatusInfo(NetStatusCode.NETSTREAM_PLAY_UNPUBLISHNOTIFY,NetStatusLevel.STATUS);
      
      public static const NETSTREAM_PLAY_INSUFFICIENTBW:NetStatusInfo = new NetStatusInfo(NetStatusCode.NETSTREAM_PLAY_INSUFFICIENTBW,NetStatusLevel.WARNING);
      
      public static const NETSTREAM_PLAY_FILESTRUCTUREINVALID:NetStatusInfo = new NetStatusInfo(NetStatusCode.NETSTREAM_PLAY_FILESTRUCTUREINVALID,NetStatusLevel.ERROR);
      
      public static const NETSTREAM_PLAY_NOSUPPORTEDTRACKFOUND:NetStatusInfo = new NetStatusInfo(NetStatusCode.NETSTREAM_PLAY_NOSUPPORTEDTRACKFOUND,NetStatusLevel.ERROR);
      
      public static const NETSTREAM_PLAY_TRANSITION:NetStatusInfo = new NetStatusInfo(NetStatusCode.NETSTREAM_PLAY_TRANSITION,NetStatusLevel.STATUS);
      
      public static const NETSTREAM_PAUSE_NOTIFY:NetStatusInfo = new NetStatusInfo(NetStatusCode.NETSTREAM_PAUSE_NOTIFY,NetStatusLevel.STATUS);
      
      public static const NETSTREAM_UNPAUSE_NOTIFY:NetStatusInfo = new NetStatusInfo(NetStatusCode.NETSTREAM_UNPAUSE_NOTIFY,NetStatusLevel.STATUS);
      
      public static const NETSTREAM_RECORD_START:NetStatusInfo = new NetStatusInfo(NetStatusCode.NETSTREAM_RECORD_START,NetStatusLevel.STATUS);
      
      public static const NETSTREAM_RECORD_NOACCESS:NetStatusInfo = new NetStatusInfo(NetStatusCode.NETSTREAM_RECORD_NOACCESS,NetStatusLevel.ERROR);
      
      public static const NETSTREAM_RECORD_STOP:NetStatusInfo = new NetStatusInfo(NetStatusCode.NETSTREAM_RECORD_STOP,NetStatusLevel.STATUS);
      
      public static const NETSTREAM_RECORD_FAILED:NetStatusInfo = new NetStatusInfo(NetStatusCode.NETSTREAM_RECORD_FAILED,NetStatusLevel.ERROR);
      
      public static const NETSTREAM_SEEK_FAILED:NetStatusInfo = new NetStatusInfo(NetStatusCode.NETSTREAM_SEEK_FAILED,NetStatusLevel.ERROR);
      
      public static const NETSTREAM_SEEK_INVALIDTIME:NetStatusInfo = new NetStatusInfo(NetStatusCode.NETSTREAM_SEEK_INVALIDTIME,NetStatusLevel.ERROR);
      
      public static const NETSTREAM_SEEK_NOTIFY:NetStatusInfo = new NetStatusInfo(NetStatusCode.NETSTREAM_SEEK_NOTIFY,NetStatusLevel.STATUS);
      
      public static const NETCONNECTION_CALL_BADVERSION:NetStatusInfo = new NetStatusInfo(NetStatusCode.NETCONNECTION_CALL_BADVERSION,NetStatusLevel.ERROR);
      
      public static const NETCONNECTION_CALL_FAILED:NetStatusInfo = new NetStatusInfo(NetStatusCode.NETCONNECTION_CALL_FAILED,NetStatusLevel.ERROR);
      
      public static const NETCONNECTION_CALL_PROHIBITED:NetStatusInfo = new NetStatusInfo(NetStatusCode.NETCONNECTION_CALL_PROHIBITED,NetStatusLevel.ERROR);
      
      public static const NETCONNECTION_CONNECT_CLOSED:NetStatusInfo = new NetStatusInfo(NetStatusCode.NETCONNECTION_CONNECT_CLOSED,NetStatusLevel.STATUS);
      
      public static const NETCONNECTION_CONNECT_FAILED:NetStatusInfo = new NetStatusInfo(NetStatusCode.NETCONNECTION_CONNECT_FAILED,NetStatusLevel.ERROR);
      
      public static const NETCONNECTION_CONNECT_SUCCESS:NetStatusInfo = new NetStatusInfo(NetStatusCode.NETCONNECTION_CONNECT_SUCCESS,NetStatusLevel.STATUS);
      
      public static const NETCONNECTION_CONNECT_REJECTED:NetStatusInfo = new NetStatusInfo(NetStatusCode.NETCONNECTION_CONNECT_REJECTED,NetStatusLevel.ERROR);
      
      public static const NETSTREAM_CONNECT_CLOSED:NetStatusInfo = new NetStatusInfo(NetStatusCode.NETSTREAM_CONNECT_CLOSED,NetStatusLevel.STATUS);
      
      public static const NETSTREAM_CONNECT_FAILED:NetStatusInfo = new NetStatusInfo(NetStatusCode.NETSTREAM_CONNECT_FAILED,NetStatusLevel.ERROR);
      
      public static const NETSTREAM_CONNECT_SUCCESS:NetStatusInfo = new NetStatusInfo(NetStatusCode.NETSTREAM_CONNECT_SUCCESS,NetStatusLevel.STATUS);
      
      public static const NETSTREAM_CONNECT_REJECTED:NetStatusInfo = new NetStatusInfo(NetStatusCode.NETSTREAM_CONNECT_REJECTED,NetStatusLevel.ERROR);
      
      public static const NETCONNECTION_CONNECT_APPSHUTDOWN:NetStatusInfo = new NetStatusInfo(NetStatusCode.NETCONNECTION_CONNECT_APPSHUTDOWN,NetStatusLevel.ERROR);
      
      public static const NETCONNECTION_CONNECT_INVALIDAPP:NetStatusInfo = new NetStatusInfo(NetStatusCode.NETCONNECTION_CONNECT_INVALIDAPP,NetStatusLevel.ERROR);
      
      public static const SHAREDOBJECT_FLUSH_SUCCESS:NetStatusInfo = new NetStatusInfo(NetStatusCode.SHAREDOBJECT_FLUSH_SUCCESS,NetStatusLevel.STATUS);
      
      public static const SHAREDOBJECT_FLUSH_FAILED:NetStatusInfo = new NetStatusInfo(NetStatusCode.SHAREDOBJECT_FLUSH_FAILED,NetStatusLevel.ERROR);
      
      public static const SHAREDOBJECT_BADPERSISTENCE:NetStatusInfo = new NetStatusInfo(NetStatusCode.SHAREDOBJECT_BADPERSISTENCE,NetStatusLevel.ERROR);
      
      public static const SHAREDOBJECT_URIMISMATCH:NetStatusInfo = new NetStatusInfo(NetStatusCode.SHAREDOBJECT_URIMISMATCH,NetStatusLevel.ERROR);
      
      protected static var codeDict:Dictionary;
       
      
      private var _code:String;
      
      private var _level:String;
      
      public function NetStatusInfo(code:String, level:String)
      {
         super();
         if(!codeDict)
         {
            codeDict = new Dictionary();
         }
         this._code = code;
         codeDict[code] = this;
         this._level = level;
      }
      
      public static function getByCode(code:String) : NetStatusInfo
      {
         return codeDict[code];
      }
      
      public static function getAllCodes() : Dictionary
      {
         return codeDict;
      }
      
      public function get code() : String
      {
         return this._code;
      }
      
      public function get level() : String
      {
         return this._level;
      }
   }
}
