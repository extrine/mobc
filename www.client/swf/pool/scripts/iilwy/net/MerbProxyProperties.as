package iilwy.net
{
   import flash.utils.getTimer;
   import iilwy.application.analytics.AnalyticsManager;
   import mochi.as3.MochiDigits;
   
   public class MerbProxyProperties
   {
      
      public static var timeStamp:Number;
      
      public static var location:String = "";
      
      public static var secureLocation:String = "";
      
      public static var timeoutSeconds:int = -1;
      
      protected static var _serverNowTimeStamp:Number = getTimer();
      
      protected static var _serverNowTimeStampDate:Date = new Date();
      
      protected static var _serverNowRecorded:MochiDigits;
      
      protected static var _localToServerTimeVariance:Number;
      
      protected static var makeavg:Array;
      
      protected static var _localToserverTimeVarianceAVG:Number = Number.MIN_VALUE;
      
      protected static var _serverTimeDelta:int;
      
      protected static var _localTimeDelta:int;
      
      public static var sessionID:String;
      
      public static var analyticsManager:AnalyticsManager;
       
      
      public function MerbProxyProperties()
      {
         super();
      }
      
      public static function get serverNow() : Date
      {
         var date:Date = new Date(serverNowRecorded + (getTimer() - _serverNowTimeStamp));
         return date;
      }
      
      public static function get serverNowInMS() : Number
      {
         return serverNowRecorded + (getTimer() - _serverNowTimeStamp);
      }
      
      public static function getServerNowInMSClampedByDate(clampLow:Boolean, clampHigh:Boolean) : Number
      {
         var tsOffset:Number = getTimer() - _serverNowTimeStamp;
         var dateOffset:Number = new Date().time - _serverNowTimeStampDate.time;
         if(clampLow)
         {
            tsOffset = Math.max(dateOffset,tsOffset);
         }
         if(clampHigh)
         {
            tsOffset = Math.min(dateOffset,tsOffset);
         }
         return serverNowRecorded + tsOffset;
      }
      
      public static function get serverNowRecorded() : Number
      {
         if(!_serverNowRecorded)
         {
            _serverNowRecorded = new MochiDigits();
            _serverNowRecorded.setValue(new Date().time);
         }
         return _serverNowRecorded.value;
      }
      
      public static function set serverNowRecorded(n:Number) : void
      {
         if(!_serverNowRecorded)
         {
            _serverNowRecorded = new MochiDigits();
         }
         _serverNowRecorded.setValue(n);
      }
      
      public static function setServerNow(val:Number) : void
      {
         var i:int = 0;
         if(val > 1000)
         {
            _localTimeDelta = getTimer() - _serverNowTimeStamp;
            _serverTimeDelta = val - serverNowRecorded;
            serverNowRecorded = val;
            _serverNowTimeStamp = getTimer();
            _serverNowTimeStampDate = new Date();
            if(_serverTimeDelta >= 1000)
            {
               _localToServerTimeVariance = -1 + _localTimeDelta / _serverTimeDelta;
               if(!makeavg)
               {
                  makeavg = [];
               }
               makeavg.push(_localToServerTimeVariance);
               if(makeavg)
               {
                  if(makeavg.length > 5)
                  {
                     makeavg.shift();
                     _localToserverTimeVarianceAVG = 0;
                     for(i = 0; i < makeavg.length; i++)
                     {
                        _localToserverTimeVarianceAVG = _localToserverTimeVarianceAVG + makeavg[i];
                     }
                     _localToserverTimeVarianceAVG = _localToserverTimeVarianceAVG / makeavg.length;
                  }
                  else
                  {
                     _localToserverTimeVarianceAVG = Number.MIN_VALUE;
                  }
               }
            }
         }
      }
      
      public static function trackDiagnostic(path:String) : void
      {
         if(analyticsManager)
         {
            analyticsManager.trackDiagnostic(path);
         }
      }
   }
}
