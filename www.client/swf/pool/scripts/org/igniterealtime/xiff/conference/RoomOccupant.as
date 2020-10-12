package org.igniterealtime.xiff.conference
{
   import flash.events.EventDispatcher;
   import org.igniterealtime.xiff.core.UnescapedJID;
   import org.igniterealtime.xiff.data.im.Contact;
   import org.igniterealtime.xiff.data.im.RosterItemVO;
   
   public class RoomOccupant extends EventDispatcher implements Contact
   {
       
      
      private var _affiliation:String;
      
      private var _jid:UnescapedJID;
      
      private var _nickname:String;
      
      private var _role:String;
      
      private var _room:Room;
      
      private var _show:String;
      
      private var _uid:String;
      
      public function RoomOccupant(nickname:String, show:String, affiliation:String, role:String, jid:UnescapedJID, room:Room)
      {
         super();
         this.displayName = nickname;
         this.show = show;
         this.affiliation = affiliation;
         this.role = role;
         this.jid = jid;
         this._room = room;
      }
      
      public function get affiliation() : String
      {
         return this._affiliation;
      }
      
      public function set affiliation(value:String) : void
      {
         this._affiliation = value;
      }
      
      public function get displayName() : String
      {
         return this._nickname;
      }
      
      public function set displayName(value:String) : void
      {
         this._nickname = value;
      }
      
      public function get jid() : UnescapedJID
      {
         return this._jid;
      }
      
      public function set jid(value:UnescapedJID) : void
      {
         this._jid = value;
      }
      
      public function get online() : Boolean
      {
         return true;
      }
      
      public function set online(value:Boolean) : void
      {
      }
      
      public function get role() : String
      {
         return this._role;
      }
      
      public function set role(value:String) : void
      {
         this._role = value;
      }
      
      public function get room() : Room
      {
         return this._room;
      }
      
      public function set room(value:Room) : void
      {
         this._room = value;
      }
      
      public function get rosterItem() : RosterItemVO
      {
         if(!this._jid)
         {
            return null;
         }
         return RosterItemVO.get(this._jid,true);
      }
      
      public function get show() : String
      {
         return this._show;
      }
      
      public function set show(value:String) : void
      {
         this._show = value;
      }
      
      public function get uid() : String
      {
         return this._uid;
      }
      
      public function set uid(value:String) : void
      {
         this._uid = value;
      }
   }
}
