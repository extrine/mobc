package iilwy.tracking
{
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLRequestMethod;
   import flash.net.URLVariables;
   import flash.utils.Dictionary;
   
   public class KontagentTracker
   {
      
      private static const BASE_URL:String = "http://api.geo.kontagent.net/api/v1/";
       
      
      private var kontagentLoaders:Dictionary;
      
      private var key:String;
      
      private var eventsTracked:Dictionary;
      
      private var eventsToBeTracked:Array;
      
      private var _uid:Number;
      
      public function KontagentTracker(key:String)
      {
         super();
         this.kontagentLoaders = new Dictionary();
         this.eventsTracked = new Dictionary();
         this.eventsToBeTracked = [];
         this.key = key;
      }
      
      public function get uid() : Number
      {
         return this._uid;
      }
      
      public function set uid(value:Number) : void
      {
         var event:Object = null;
         this._uid = value;
         if(this.eventsToBeTracked.length > 0)
         {
            for each(event in this.eventsToBeTracked)
            {
               this.trackEvent(event.eventName,event.value,event.level,event.st1,event.st2,event.st3);
            }
            this.eventsToBeTracked = [];
         }
      }
      
      public function trackEvent(eventName:String, value:int = 1, level:int = 1, st1:String = null, st2:String = null, st3:String = null) : void
      {
         if(isNaN(this._uid))
         {
            this.eventsToBeTracked.push({
               "eventName":eventName,
               "value":value,
               "level":level,
               "st1":st1,
               "st2":st2,
               "st3":st3
            });
            return;
         }
         var url:String = BASE_URL + this.key + "/evt/";
         var params:URLVariables = new URLVariables();
         params.s = this._uid;
         params.n = eventName;
         params.v = value;
         params.l = level;
         if(st1)
         {
            params.st1 = st1;
         }
         if(st2)
         {
            params.st2 = st2;
         }
         if(st3)
         {
            params.st3 = st3;
         }
         var request:URLRequest = new URLRequest(url);
         request.method = URLRequestMethod.GET;
         request.data = params;
         var loader:URLLoader = new URLLoader();
         loader.addEventListener(Event.COMPLETE,this.onKontagentComplete,false,0,true);
         loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onKontagentError,false,0,true);
         loader.addEventListener(IOErrorEvent.IO_ERROR,this.onKontagentError,false,0,true);
         loader.load(request);
         this.kontagentLoaders[loader] = loader;
         this.eventsTracked[eventName] = !!this.eventsTracked.hasOwnProperty(eventName)?this.eventsTracked[eventName]++:1;
      }
      
      public function getEventTrackCount(eventName:String) : Boolean
      {
         return !!this.eventsTracked.hasOwnProperty(eventName)?Boolean(this.eventsTracked[eventName]):Boolean(0);
      }
      
      protected function onKontagentComplete(event:Event) : void
      {
         if(this.kontagentLoaders[event.target])
         {
            delete this.kontagentLoaders[event.target];
         }
      }
      
      protected function onKontagentError(event:Event) : void
      {
         if(this.kontagentLoaders[event.target])
         {
            delete this.kontagentLoaders[event.target];
         }
      }
   }
}
