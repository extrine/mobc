package org.igniterealtime.xiff.conference
{
   import flash.events.EventDispatcher;
   import org.igniterealtime.xiff.core.XMPPConnection;
   import org.igniterealtime.xiff.data.Message;
   import org.igniterealtime.xiff.data.muc.MUCUserExtension;
   import org.igniterealtime.xiff.events.InviteEvent;
   import org.igniterealtime.xiff.events.MessageEvent;
   
   [Event(name="invited",type="org.igniterealtime.xiff.events.InviteEvent")]
   public class InviteListener extends EventDispatcher
   {
       
      
      private var _connection:XMPPConnection;
      
      public function InviteListener(aConnection:XMPPConnection = null)
      {
         super();
         if(aConnection != null)
         {
            this.connection = aConnection;
         }
      }
      
      private function handleEvent(event:Object) : void
      {
         var message:Message = null;
         var exts:Array = null;
         var muc:MUCUserExtension = null;
         var room:Room = null;
         var inviteEvent:InviteEvent = null;
         switch(event.type)
         {
            case MessageEvent.MESSAGE:
               try
               {
                  message = event.data as Message;
                  exts = message.getAllExtensionsByNS(MUCUserExtension.NS);
                  if(!exts || exts.length < 0)
                  {
                     return;
                  }
                  muc = exts[0];
                  if(muc.type == MUCUserExtension.TYPE_INVITE)
                  {
                     room = new Room(this._connection);
                     room.roomJID = message.from.unescaped;
                     room.password = muc.password;
                     inviteEvent = new InviteEvent();
                     inviteEvent.from = muc.from.unescaped;
                     inviteEvent.reason = muc.reason;
                     inviteEvent.room = room;
                     inviteEvent.data = message;
                     dispatchEvent(inviteEvent);
                  }
               }
               catch(error:Error)
               {
                  trace(error.getStackTrace());
               }
         }
      }
      
      public function get connection() : XMPPConnection
      {
         return this._connection;
      }
      
      public function set connection(value:XMPPConnection) : void
      {
         if(this._connection != null)
         {
            this._connection.removeEventListener(MessageEvent.MESSAGE,this.handleEvent);
         }
         this._connection = value;
         this._connection.addEventListener(MessageEvent.MESSAGE,this.handleEvent);
      }
   }
}
