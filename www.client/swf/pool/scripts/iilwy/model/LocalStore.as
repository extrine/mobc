package iilwy.model
{
   import flash.events.TimerEvent;
   import flash.net.SharedObject;
   import flash.utils.Timer;
   import iilwy.application.AppComponents;
   import iilwy.utils.logging.Logger;
   
   public class LocalStore
   {
      
      public static const ANON:String = "___anonymous___";
       
      
      protected var _logger:Logger;
      
      protected var _flushQueue:Array;
      
      protected var _enabled:Boolean = true;
      
      protected var _model;
      
      protected var _modelRead:Boolean;
      
      protected var _needsFlush:Boolean;
      
      protected var _id:String;
      
      protected var _flushTimer:Timer;
      
      public function LocalStore(id:String = null)
      {
         this._flushQueue = [];
         super();
         if(id == null)
         {
            this._id = "omgpop_so2";
         }
         else
         {
            this._id = id;
         }
         this._logger = Logger.getLogger("LocalStore:" + this._id);
         this._logger.level = Logger.NONE;
         this._flushTimer = new Timer(1000,1);
         this._flushTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onFlushTimer);
      }
      
      public function clear() : void
      {
         this._modelRead = false;
         this._model = {"initialized":false};
         this.onFlushTimer(null);
         this._logger.log("Cleared");
      }
      
      public function toString() : String
      {
         var str:String = null;
         str = JSON.serialize(this._model);
         return str;
      }
      
      protected function getModel() : *
      {
         var so:SharedObject = null;
         if(!this._modelRead)
         {
            this._modelRead = true;
            try
            {
               so = SharedObject.getLocal(this._id,"/",false);
            }
            catch(e:Error)
            {
            }
            if(so)
            {
               this._model = so.data.value;
            }
            if(!this._model || !this._model.initialized)
            {
               this._model = {
                  "initialized":true,
                  "formValues":{},
                  "userSpecific":{},
                  "generic":{}
               };
            }
         }
         return this._model;
      }
      
      protected function flushLater() : void
      {
         this._needsFlush = true;
      }
      
      public function flushQueuedObjects() : void
      {
         if(this._needsFlush)
         {
            this._needsFlush = false;
            if(!this._flushTimer.running)
            {
               this._flushTimer.reset();
               this._flushTimer.start();
            }
         }
      }
      
      protected function onFlushTimer(event:TimerEvent) : void
      {
         var so:SharedObject = null;
         try
         {
            so = SharedObject.getLocal(this._id,"/",false);
         }
         catch(e:Error)
         {
         }
         if(so)
         {
            so.data.value = this._model;
            so.flush();
         }
      }
      
      protected function getAnonymousUserModel() : *
      {
         var result:* = undefined;
         result = this.getModel().userSpecific[ANON];
         if(!result)
         {
            this.getModel().userSpecific[ANON] = {};
         }
         return this.getModel().userSpecific[ANON];
      }
      
      protected function getUserSpecificModel() : *
      {
         var result:* = undefined;
         result = this.getModel().userSpecific[this.userString];
         if(!result)
         {
            this.getModel().userSpecific[this.userString] = {};
         }
         return this.getModel().userSpecific[this.userString];
      }
      
      protected function get userString() : String
      {
         var str:String = null;
         if(AppComponents.model.privateUser.isLoggedIn)
         {
            str = AppComponents.model.privateUser.id.toString();
         }
         else
         {
            str = ANON;
         }
         return str;
      }
      
      public function getObject(name:String) : *
      {
         var value:* = undefined;
         this._logger.log("Looking for object: ",name);
         if(this._enabled)
         {
            value = this.getModel().generic[name];
         }
         if(value)
         {
            this._logger.log("Found value for: ",name,value);
         }
         return value;
      }
      
      public function saveObject(name:String, value:*) : void
      {
         if(!this._enabled)
         {
            return;
         }
         this.getModel().generic[name] = value;
         this.flushLater();
      }
      
      public function getUserSpecificObject(name:String) : *
      {
         var value:* = undefined;
         this._logger.log("Looking for user object: ",name);
         if(this._enabled)
         {
            value = this.getUserSpecificModel()[name];
         }
         if(value)
         {
            this._logger.log("Found value for: ",name,value);
         }
         return value;
      }
      
      public function saveUserSpecificObject(name:String, value:*, overwriteAnonymous:Boolean = false) : *
      {
         if(!this._enabled)
         {
            return;
         }
         this.getUserSpecificModel()[name] = value;
         if(overwriteAnonymous)
         {
            this.getAnonymousUserModel()[name] = value;
         }
         this.flushLater();
         return value;
      }
      
      public function saveExpiringObject(name:String, expiration:Number, value:*) : *
      {
         if(!this._enabled)
         {
            return;
         }
         var obj:* = {};
         if(obj)
         {
            obj.value = value;
            obj.timeStamp = AppComponents.model.serverNow.getTime();
            obj.expiration = expiration;
         }
         this.getModel().generic[name] = obj;
         this.flushLater();
         return value;
      }
      
      public function getExpiringObject(name:String) : *
      {
         if(!this._enabled)
         {
            return null;
         }
         var obj:* = this.getModel().generic[name];
         var result:* = null;
         this._logger.log("Looking for expiring object: ",name);
         if(obj && obj.timeStamp && obj.expiration)
         {
            this._logger.log("Expiring object found",obj.timeStamp + obj.expiration);
            if(obj.timeStamp + obj.expiration < AppComponents.model.serverNow.getTime())
            {
               this._logger.log("Object expired");
            }
            else
            {
               this._logger.log("Object still valid");
               result = obj.value;
            }
         }
         return result;
      }
      
      public function getFormValue(name:String) : Array
      {
         if(!this._enabled)
         {
            return [];
         }
         var obj:* = this.getModel().formValues[name];
         this._logger.log("Looking for form values: ",name);
         if(obj)
         {
            this._logger.log("Found form values: ",obj);
            return obj;
         }
         return new Array();
      }
      
      public function saveFormValue(name:String, value:*) : *
      {
         if(!this._enabled)
         {
            return null;
         }
         if(value.length == 0 || value == " ")
         {
            return;
         }
         var vals:Array = this.getFormValue(name);
         var index:Number = vals.indexOf(value);
         if(index >= 0)
         {
            vals.splice(index,1);
         }
         vals.unshift(value);
         vals.splice(5);
         this.getModel().formValues[name] = vals;
         this.flushLater();
         return value;
      }
   }
}
