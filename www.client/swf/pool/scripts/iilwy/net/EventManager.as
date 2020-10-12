package iilwy.net
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import iilwy.events.RemoteEvent;
   
   public final class EventManager extends EventDispatcher implements IRemote
   {
      
      private static var instance:EventManager;
       
      
      private var queuedEvents:Array;
      
      private var _enabled:Boolean = true;
      
      private var _suspended:Boolean;
      
      public function EventManager(enforcer:SingletonEnforcer)
      {
         this.queuedEvents = [];
         super();
      }
      
      public static function getInstance() : EventManager
      {
         if(!instance)
         {
            instance = new EventManager(new SingletonEnforcer());
         }
         return instance;
      }
      
      public static function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0.0, useWeakReference:Boolean = true) : void
      {
         instance.addEventListener(type,listener,useCapture,priority,useWeakReference);
      }
      
      public static function dispatchEvent(event:Event) : Boolean
      {
         return instance.dispatchEvent(event);
      }
      
      public static function hasEventListener(type:String) : Boolean
      {
         return instance.hasEventListener(type);
      }
      
      public static function removeEventListener(type:String, listener:Function, useCapture:Boolean = false) : void
      {
         instance.removeEventListener(type,listener,useCapture);
      }
      
      public static function willTrigger(type:String) : Boolean
      {
         return instance.willTrigger(type);
      }
      
      public function get enabled() : Boolean
      {
         return this._enabled;
      }
      
      public function set enabled(value:Boolean) : void
      {
         this._enabled = value;
      }
      
      public function get suspended() : Boolean
      {
         return this._suspended;
      }
      
      public function set suspended(value:Boolean) : void
      {
         var event:Object = null;
         var remoteEvent:RemoteEvent = null;
         if(this._suspended == value)
         {
            return;
         }
         this._suspended = value;
         if(!value)
         {
            for each(event in this.queuedEvents)
            {
               this.addEvent(event);
            }
            remoteEvent = new RemoteEvent(RemoteEvent.QUEUED_EVENTS);
            remoteEvent.queuedEvents = this.queuedEvents.concat();
            dispatchEvent(remoteEvent);
         }
         this.queuedEvents = [];
      }
      
      public function addEvent(data:Object, allowSuppress:Boolean = true) : void
      {
         var dispatchReceiveNotificationEvent:Boolean = false;
         if(!this.enabled)
         {
            return;
         }
         if(this.suspended && allowSuppress)
         {
            this.queuedEvents.push(data);
            return;
         }
         switch(data.e_type)
         {
            case EventNotificationType.BAN:
               instance.dispatchEvent(new RemoteEvent(RemoteEvent.USER_BANNED,data));
               break;
            case EventNotificationType.BET_LOST:
               instance.dispatchEvent(new RemoteEvent(RemoteEvent.BET_LOST,data));
               dispatchReceiveNotificationEvent = true;
               break;
            case EventNotificationType.BET_WON:
               instance.dispatchEvent(new RemoteEvent(RemoteEvent.BET_WON,data));
               dispatchReceiveNotificationEvent = true;
               break;
            case EventNotificationType.COIN_DOWN:
            case EventNotificationType.COIN_UP:
               instance.dispatchEvent(new RemoteEvent(RemoteEvent.BALANCE_CHANGED,data));
               break;
            case EventNotificationType.CONTACT_LOGGED_IN:
            case EventNotificationType.FRIEND_LOGS_IN:
               instance.dispatchEvent(new RemoteEvent(RemoteEvent.CONTACT_LOGS_IN,data));
               dispatchReceiveNotificationEvent = true;
               break;
            case EventNotificationType.CONTACT_LOGGED_OUT:
               instance.dispatchEvent(new RemoteEvent(RemoteEvent.CONTACT_LOGS_OUT,data));
               break;
            case EventNotificationType.CONTACT_OFF_FROM_IDLE:
               instance.dispatchEvent(new RemoteEvent(RemoteEvent.CONTACT_LOGS_OUT_FROM_IDLE,data));
               dispatchReceiveNotificationEvent = true;
               break;
            case EventNotificationType.CONTACT_STATUS_CHANGED:
               instance.dispatchEvent(new RemoteEvent(RemoteEvent.CONTACT_STATUS_CHANGES,data));
               break;
            case EventNotificationType.EARNED_GAME_XP:
               instance.dispatchEvent(new RemoteEvent(RemoteEvent.EARNED_GAME_EXPERIENCE,data));
               break;
            case EventNotificationType.EARNED_XP:
               instance.dispatchEvent(new RemoteEvent(RemoteEvent.EARNED_EXPERIENCE,data));
               break;
            case EventNotificationType.FRIEND_REQUEST:
               data.e_link = "/home";
               instance.dispatchEvent(new RemoteEvent(RemoteEvent.NEW_CONTACT_REQUEST,data));
               dispatchReceiveNotificationEvent = true;
               break;
            case EventNotificationType.GAME_LEVEL_UP:
               instance.dispatchEvent(new RemoteEvent(RemoteEvent.GAME_LEVEL_UP,data));
               break;
            case EventNotificationType.GOLD_MEDAL:
            case EventNotificationType.SILVER_MEDAL:
            case EventNotificationType.BRONZE_MEDAL:
               instance.dispatchEvent(new RemoteEvent(RemoteEvent.MEDAL_RECEIVED,data));
               dispatchReceiveNotificationEvent = true;
               break;
            case EventNotificationType.GOT_POINTS:
               instance.dispatchEvent(new RemoteEvent(RemoteEvent.POINTS_CHANGED,data));
               break;
            case EventNotificationType.LEVEL_UP:
               instance.dispatchEvent(new RemoteEvent(RemoteEvent.LEVEL_UP,data));
               break;
            case EventNotificationType.NEW_CONTACT:
               instance.dispatchEvent(new RemoteEvent(RemoteEvent.NEW_CONTACT_ADDED,data));
               dispatchReceiveNotificationEvent = true;
               break;
            case EventNotificationType.QUIZ_QUESTION:
               data.e_link = "/home";
               dispatchReceiveNotificationEvent = true;
               break;
            case EventNotificationType.QUIZ_QUESTION_ANSWERED:
               break;
            case EventNotificationType.REPORT:
               instance.dispatchEvent(new RemoteEvent(RemoteEvent.USER_REPORTED,data));
               break;
            case EventNotificationType.SECONDARY_FRIEND_CREATE:
               instance.dispatchEvent(new RemoteEvent(RemoteEvent.SECONDARY_FRIEND_CREATE,data));
               break;
            case EventNotificationType.SECONDARY_FRIEND_REMOVE:
               instance.dispatchEvent(new RemoteEvent(RemoteEvent.SECONDARY_FRIEND_REMOVE,data));
               break;
            case EventNotificationType.SUCCESSFUL_PHOTO_UPLOAD:
               instance.dispatchEvent(new RemoteEvent(RemoteEvent.NEW_PHOTO_UPLOADED,data));
               dispatchReceiveNotificationEvent = true;
               break;
            case EventNotificationType.VERSION_UPDATED:
               instance.dispatchEvent(new RemoteEvent(RemoteEvent.VERSION_UPDATED,data));
               break;
            default:
               dispatchReceiveNotificationEvent = true;
         }
         if(dispatchReceiveNotificationEvent)
         {
            instance.dispatchEvent(new RemoteEvent(RemoteEvent.RECEIVE_NOTIFICATION,data));
         }
      }
   }
}

class SingletonEnforcer
{
    
   
   function SingletonEnforcer()
   {
      super();
   }
}
