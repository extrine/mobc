package org.igniterealtime.xiff.data.im
{
   import flash.events.EventDispatcher;
   import org.igniterealtime.xiff.core.UnescapedJID;
   import org.igniterealtime.xiff.events.PropertyChangeEvent;
   
   [Event(name="change",type="org.igniterealtime.xiff.events.PropertyChangeEvent")]
   public class RosterItemVO extends EventDispatcher implements Contact
   {
      
      private static var allContacts:Object = {};
       
      
      private var _askType:String;
      
      private var _displayName:String;
      
      private var _groups:Array;
      
      private var _jid:UnescapedJID;
      
      private var _online:Boolean = false;
      
      private var _priority:int;
      
      private var _show:String;
      
      private var _status:String;
      
      private var _subscribeType:String;
      
      public function RosterItemVO(newJID:UnescapedJID)
      {
         this._groups = [];
         super();
         this.jid = newJID;
      }
      
      public static function get(jid:UnescapedJID, create:Boolean = false) : RosterItemVO
      {
         var bareJID:String = jid.bareJID;
         var item:RosterItemVO = allContacts[bareJID];
         if(!item && create)
         {
            allContacts[bareJID] = item = new RosterItemVO(new UnescapedJID(bareJID));
         }
         return item;
      }
      
      override public function toString() : String
      {
         return this.jid.toString();
      }
      
      private function dispatchChangeEvent(name:String, newValue:*, oldValue:*) : void
      {
         var event:PropertyChangeEvent = new PropertyChangeEvent(PropertyChangeEvent.CHANGE);
         event.name = name;
         event.newValue = newValue;
         event.oldValue = oldValue;
         dispatchEvent(event);
      }
      
      public function get askType() : String
      {
         return this._askType;
      }
      
      public function set askType(value:String) : void
      {
         var oldasktype:String = this.askType;
         var oldPending:Boolean = this.pending;
         this._askType = value;
         this.dispatchChangeEvent("askType",this.askType,oldasktype);
         this.dispatchChangeEvent("pending",this.pending,oldPending);
      }
      
      public function get displayName() : String
      {
         return Boolean(this._displayName)?this._displayName:this._jid.node;
      }
      
      public function set displayName(value:String) : void
      {
         var olddisplayname:String = this.displayName;
         this._displayName = value;
         this.dispatchChangeEvent("displayName",this.displayName,olddisplayname);
      }
      
      public function get jid() : UnescapedJID
      {
         return this._jid;
      }
      
      public function set jid(value:UnescapedJID) : void
      {
         var oldjid:UnescapedJID = this._jid;
         this._jid = value;
         if(!this._displayName)
         {
            this.dispatchChangeEvent("jid",value,oldjid);
         }
      }
      
      public function get online() : Boolean
      {
         return this._online;
      }
      
      public function set online(value:Boolean) : void
      {
         if(value == this.online)
         {
            return;
         }
         var oldOnline:Boolean = this.online;
         this._online = value;
         this.dispatchChangeEvent("online",this._online,oldOnline);
      }
      
      public function get pending() : Boolean
      {
         return this.askType == RosterExtension.ASK_TYPE_SUBSCRIBE && (this.subscribeType == RosterExtension.SUBSCRIBE_TYPE_NONE || this.subscribeType == RosterExtension.SUBSCRIBE_TYPE_FROM);
      }
      
      public function get priority() : int
      {
         return this._priority;
      }
      
      public function set priority(value:int) : void
      {
         var oldPriority:int = this.priority;
         this._priority = value;
         this.dispatchChangeEvent("priority",this._priority,oldPriority);
      }
      
      public function get show() : String
      {
         return this._show;
      }
      
      public function set show(value:String) : void
      {
         var oldShow:String = this.show;
         this._show = value;
         this.dispatchChangeEvent("show",this._show,oldShow);
      }
      
      public function get status() : String
      {
         if(!this.online)
         {
            return "Offline";
         }
         return Boolean(this._status)?this._status:"Available";
      }
      
      public function set status(value:String) : void
      {
         var oldStatus:String = this.status;
         this._status = value;
         this.dispatchChangeEvent("status",this._status,oldStatus);
      }
      
      public function get subscribeType() : String
      {
         return this._subscribeType;
      }
      
      public function set subscribeType(value:String) : void
      {
         var oldSub:String = this.subscribeType;
         this._subscribeType = value;
         this.dispatchChangeEvent("subscribeType",this._subscribeType,oldSub);
      }
      
      public function get uid() : String
      {
         return this._jid.toString();
      }
      
      public function set uid(value:String) : void
      {
      }
   }
}
