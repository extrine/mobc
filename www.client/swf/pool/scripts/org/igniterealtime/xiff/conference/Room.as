package org.igniterealtime.xiff.conference
{
   import org.igniterealtime.xiff.collections.ArrayCollection;
   import org.igniterealtime.xiff.core.EscapedJID;
   import org.igniterealtime.xiff.core.UnescapedJID;
   import org.igniterealtime.xiff.core.XMPPConnection;
   import org.igniterealtime.xiff.data.IExtension;
   import org.igniterealtime.xiff.data.IQ;
   import org.igniterealtime.xiff.data.Message;
   import org.igniterealtime.xiff.data.Presence;
   import org.igniterealtime.xiff.data.XMPPStanza;
   import org.igniterealtime.xiff.data.forms.FormExtension;
   import org.igniterealtime.xiff.data.muc.MUC;
   import org.igniterealtime.xiff.data.muc.MUCAdminExtension;
   import org.igniterealtime.xiff.data.muc.MUCBaseExtension;
   import org.igniterealtime.xiff.data.muc.MUCExtension;
   import org.igniterealtime.xiff.data.muc.MUCItem;
   import org.igniterealtime.xiff.data.muc.MUCOwnerExtension;
   import org.igniterealtime.xiff.data.muc.MUCStatus;
   import org.igniterealtime.xiff.data.muc.MUCUserExtension;
   import org.igniterealtime.xiff.events.DisconnectionEvent;
   import org.igniterealtime.xiff.events.MessageEvent;
   import org.igniterealtime.xiff.events.PresenceEvent;
   import org.igniterealtime.xiff.events.PropertyChangeEvent;
   import org.igniterealtime.xiff.events.RoomEvent;
   
   [Event(name="userPresenceChange",type="org.igniterealtime.xiff.events.RoomEvent")]
   [Event(name="userKicked",type="org.igniterealtime.xiff.events.RoomEvent")]
   [Event(name="userJoin",type="org.igniterealtime.xiff.events.RoomEvent")]
   [Event(name="userDeparture",type="org.igniterealtime.xiff.events.RoomEvent")]
   [Event(name="userBanned",type="org.igniterealtime.xiff.events.RoomEvent")]
   [Event(name="subjectChange",type="org.igniterealtime.xiff.events.RoomEvent")]
   [Event(name="roomLeave",type="org.igniterealtime.xiff.events.RoomEvent")]
   [Event(name="roomJoin",type="org.igniterealtime.xiff.events.RoomEvent")]
   [Event(name="roomDestroyed",type="org.igniterealtime.xiff.events.RoomEvent")]
   [Event(name="registrationReqError",type="org.igniterealtime.xiff.events.RoomEvent")]
   [Event(name="privateMessage",type="org.igniterealtime.xiff.events.RoomEvent")]
   [Event(name="passwordError",type="org.igniterealtime.xiff.events.RoomEvent")]
   [Event(name="nickConflict",type="org.igniterealtime.xiff.events.RoomEvent")]
   [Event(name="maxUsersError",type="org.igniterealtime.xiff.events.RoomEvent")]
   [Event(name="lockedError",type="org.igniterealtime.xiff.events.RoomEvent")]
   [Event(name="groupMessage",type="org.igniterealtime.xiff.events.RoomEvent")]
   [Event(name="declined",type="org.igniterealtime.xiff.events.RoomEvent")]
   [Event(name="configureRoomComplete",type="org.igniterealtime.xiff.events.RoomEvent")]
   [Event(name="configureRoom",type="org.igniterealtime.xiff.events.RoomEvent")]
   [Event(name="bannedError",type="org.igniterealtime.xiff.events.RoomEvent")]
   [Event(name="affiliations",type="org.igniterealtime.xiff.events.RoomEvent")]
   [Event(name="affiliationChangeComplete",type="org.igniterealtime.xiff.events.RoomEvent")]
   [Event(name="adminError",type="org.igniterealtime.xiff.events.RoomEvent")]
   [Event(name="change",type="org.igniterealtime.xiff.events.PropertyChangeEvent")]
   public class Room extends ArrayCollection
   {
      
      public static const AFFILIATION_ADMIN:String = MUC.AFFILIATION_ADMIN;
      
      public static const AFFILIATION_MEMBER:String = MUC.AFFILIATION_MEMBER;
      
      public static const AFFILIATION_NONE:String = MUC.AFFILIATION_NONE;
      
      public static const AFFILIATION_OUTCAST:String = MUC.AFFILIATION_OUTCAST;
      
      public static const AFFILIATION_OWNER:String = MUC.AFFILIATION_OWNER;
      
      public static const ROLE_MODERATOR:String = MUC.ROLE_MODERATOR;
      
      public static const ROLE_NONE:String = MUC.ROLE_NONE;
      
      public static const ROLE_PARTICIPANT:String = MUC.ROLE_PARTICIPANT;
      
      public static const ROLE_VISITOR:String = MUC.ROLE_VISITOR;
      
      private static var roomStaticConstructed:Boolean = RoomStaticConstructor();
      
      private static var staticConstructorDependencies:Array = [FormExtension,MUC];
       
      
      private var _active:Boolean;
      
      private var _affiliation:String;
      
      private var _anonymous:Boolean = true;
      
      private var _connection:XMPPConnection;
      
      private var _nickname:String;
      
      private var _password:String;
      
      private var _role:String;
      
      private var _roomJID:UnescapedJID;
      
      private var _subject:String;
      
      private var myIsReserved:Boolean;
      
      private var pendingNickname:String;
      
      private var affiliationExtension:MUCBaseExtension;
      
      private var affiliationArgs:Array;
      
      public function Room(aConnection:XMPPConnection = null)
      {
         this.affiliationArgs = [];
         super();
         this.setActive(false);
         if(aConnection != null)
         {
            this.connection = aConnection;
         }
         this.affiliationExtension = new MUCAdminExtension();
      }
      
      private static function RoomStaticConstructor() : Boolean
      {
         MUC.enable();
         FormExtension.enable();
         return true;
      }
      
      public function allow(jids:Array) : void
      {
         this.grant(Room.AFFILIATION_NONE,jids);
      }
      
      public function ban(jids:Array) : void
      {
         var banJID:UnescapedJID = null;
         var iq:IQ = new IQ(this.roomJID.escaped,IQ.TYPE_SET,null,this.ban_response,this.ban_error);
         var adminExt:MUCAdminExtension = new MUCAdminExtension();
         for each(banJID in jids)
         {
            adminExt.addItem(Room.AFFILIATION_OUTCAST,null,null,banJID.escaped,null,null);
         }
         iq.addExtension(adminExt);
         this._connection.send(iq);
      }
      
      public function cancelConfiguration() : void
      {
         var iq:IQ = new IQ(this.roomJID.escaped,IQ.TYPE_SET);
         var ownerExt:MUCOwnerExtension = new MUCOwnerExtension();
         var form:FormExtension = new FormExtension();
         form.type = FormExtension.TYPE_CANCEL;
         ownerExt.addExtension(form);
         iq.addExtension(ownerExt);
         this._connection.send(iq);
      }
      
      public function changeSubject(newSubject:String) : void
      {
         var message:Message = null;
         if(this.isActive)
         {
            message = new Message(this.roomJID.escaped,null,null,null,Message.TYPE_GROUPCHAT,newSubject);
            this._connection.send(message);
         }
      }
      
      public function configure(fieldmap:Object) : void
      {
         var form:FormExtension = null;
         var iq:IQ = new IQ(this.roomJID.escaped,IQ.TYPE_SET,null,this.configure_response,this.configure_error);
         var ownerExt:MUCOwnerExtension = new MUCOwnerExtension();
         if(fieldmap is FormExtension)
         {
            form = FormExtension(fieldmap);
         }
         else
         {
            form = new FormExtension();
            fieldmap["FORM_TYPE"] = ["http://jabber.org/protocol/muc#roomconfig"];
            form.setFields(fieldmap);
         }
         form.type = FormExtension.TYPE_SUBMIT;
         ownerExt.addExtension(form);
         iq.addExtension(ownerExt);
         this._connection.send(iq);
      }
      
      public function decline(jid:UnescapedJID, reason:String) : void
      {
         var message:Message = new Message(this.roomJID.escaped);
         var userExt:MUCUserExtension = new MUCUserExtension();
         userExt.decline(jid.escaped,undefined,reason);
         message.addExtension(userExt);
         this._connection.send(message);
      }
      
      public function destroy(reason:String, alternateJID:UnescapedJID = null, callback:Function = null) : void
      {
         var jid:EscapedJID = null;
         var iq:IQ = new IQ(this.roomJID.escaped,IQ.TYPE_SET);
         var ownerExt:MUCOwnerExtension = new MUCOwnerExtension();
         if(alternateJID != null)
         {
            jid = alternateJID.escaped;
         }
         iq.callback = callback;
         ownerExt.destroy(reason,jid);
         iq.addExtension(ownerExt);
         this._connection.send(iq);
      }
      
      public function getMessage(body:String = null, htmlBody:String = null) : Message
      {
         var message:Message = new Message(this.roomJID.escaped,null,body,htmlBody,Message.TYPE_GROUPCHAT);
         return message;
      }
      
      public function getOccupantNamed(name:String) : RoomOccupant
      {
         var occ:RoomOccupant = null;
         for each(occ in this)
         {
            if(occ.displayName == name)
            {
               return occ;
            }
         }
         return null;
      }
      
      public function grant(affiliation:String, jids:Array) : void
      {
         var jid:UnescapedJID = null;
         this.affiliationArgs = arguments;
         var iq:IQ = new IQ(this.roomJID.escaped,IQ.TYPE_SET,null,this.grant_response,this.grant_error);
         for each(jid in jids)
         {
            this.affiliationExtension.addItem(affiliation,null,null,jid.escaped,null,null);
         }
         iq.addExtension(this.affiliationExtension as IExtension);
         this._connection.send(iq);
      }
      
      public function invite(jid:UnescapedJID, reason:String) : void
      {
         var message:Message = new Message(this.roomJID.escaped);
         var userExt:MUCUserExtension = new MUCUserExtension();
         userExt.invite(jid.escaped,undefined,reason);
         message.addExtension(userExt);
         this._connection.send(message);
      }
      
      public function isThisRoom(sender:UnescapedJID) : Boolean
      {
         var value:Boolean = false;
         if(this._roomJID != null)
         {
            value = sender.bareJID.toLowerCase() == this.roomJID.bareJID.toLowerCase();
         }
         return value;
      }
      
      public function isThisUser(sender:UnescapedJID) : Boolean
      {
         var value:Boolean = false;
         if(this.userJID != null)
         {
            value = sender.toString().toLowerCase() == this.userJID.toString().toLowerCase();
         }
         return value;
      }
      
      public function join(createReserved:Boolean = false, joinPresenceExtensions:Array = null) : Boolean
      {
         var muc:MUCExtension = new MUCExtension();
         if(this.password != null)
         {
            muc.password = this.password;
         }
         return this.joinWithExplicitMUCExtension(createReserved,muc,joinPresenceExtensions);
      }
      
      public function joinWithExplicitMUCExtension(createReserved:Boolean, mucExtension:MUCExtension, joinPresenceExtensions:Array = null) : Boolean
      {
         var joinExt:* = undefined;
         if(!this._connection.isActive() || this.isActive)
         {
            return false;
         }
         this.myIsReserved = createReserved;
         var joinPresence:Presence = new Presence(this.userJID.escaped);
         joinPresence.addExtension(mucExtension);
         if(joinPresenceExtensions != null)
         {
            for each(joinExt in joinPresenceExtensions)
            {
               joinPresence.addExtension(joinExt);
            }
         }
         this._connection.send(joinPresence);
         return true;
      }
      
      public function kickOccupant(occupantNick:String, reason:String) : void
      {
         var iq:IQ = null;
         var adminExt:MUCAdminExtension = null;
         if(this.isActive)
         {
            iq = new IQ(this.roomJID.escaped,IQ.TYPE_SET,XMPPStanza.generateID("kick_occupant_"));
            adminExt = new MUCAdminExtension(iq.getNode());
            adminExt.addItem(null,MUC.ROLE_NONE,occupantNick,null,null,reason);
            iq.addExtension(adminExt);
            this._connection.send(iq);
         }
      }
      
      public function leave() : void
      {
         var leavePresence:Presence = null;
         if(this.isActive)
         {
            leavePresence = new Presence(this.userJID.escaped,null,Presence.TYPE_UNAVAILABLE);
            this._connection.send(leavePresence);
            removeAll();
            this._connection.removeEventListener(MessageEvent.MESSAGE,this.handleEvent);
            this._connection.removeEventListener(DisconnectionEvent.DISCONNECT,this.handleEvent);
         }
      }
      
      public function requestAffiliations(affiliation:String) : void
      {
         var iq:IQ = new IQ(this.roomJID.escaped,IQ.TYPE_GET,null,this.requestAffiliations_response,this.requestAffiliations_error);
         var adminExt:MUCAdminExtension = new MUCAdminExtension();
         adminExt.addItem(affiliation);
         iq.addExtension(adminExt);
         this._connection.send(iq);
      }
      
      public function requestConfiguration() : void
      {
         var iq:IQ = new IQ(this.roomJID.escaped,IQ.TYPE_GET,null,this.requestConfiguration_response,this.requestConfiguration_error);
         var ownerExt:MUCOwnerExtension = new MUCOwnerExtension();
         iq.addExtension(ownerExt);
         this._connection.send(iq);
      }
      
      public function revoke(jids:Array) : void
      {
         this.grant(Room.AFFILIATION_NONE,jids);
      }
      
      public function sendMessage(body:String = null, htmlBody:String = null) : void
      {
         var message:Message = null;
         if(this.isActive)
         {
            message = new Message(this.roomJID.escaped,null,body,htmlBody,Message.TYPE_GROUPCHAT);
            this._connection.send(message);
         }
      }
      
      public function sendMessageWithExtension(message:Message) : void
      {
         if(this.isActive)
         {
            this._connection.send(message);
         }
      }
      
      public function sendPrivateMessage(recipientNickname:String, body:String = null, htmlBody:String = null) : void
      {
         var message:Message = null;
         if(this.isActive)
         {
            message = new Message(new EscapedJID(this.roomJID + "/" + recipientNickname),null,body,htmlBody,Message.TYPE_CHAT);
            this._connection.send(message);
         }
      }
      
      public function setOccupantVoice(occupantNick:String, voice:Boolean) : void
      {
         var iq:IQ = null;
         var adminExt:MUCAdminExtension = null;
         if(this.isActive)
         {
            iq = new IQ(this.roomJID.escaped,IQ.TYPE_SET,XMPPStanza.generateID("voice_"));
            adminExt = new MUCAdminExtension(iq.getNode());
            adminExt.addItem(null,!!voice?MUC.ROLE_PARTICIPANT:MUC.ROLE_VISITOR,occupantNick);
            iq.addExtension(adminExt);
            this._connection.send(iq);
         }
      }
      
      override public function toString() : String
      {
         return "[object Room]";
      }
      
      private function admin_error(iq:IQ) : void
      {
         var event:RoomEvent = new RoomEvent(RoomEvent.ADMIN_ERROR);
         event.errorCondition = iq.errorCondition;
         event.errorMessage = iq.errorMessage;
         event.errorType = iq.errorType;
         event.errorCode = iq.errorCode;
         dispatchEvent(event);
      }
      
      private function admin_response(iq:IQ) : void
      {
      }
      
      private function ban_error(iq:IQ) : void
      {
         this.admin_error(iq);
      }
      
      private function ban_response(iq:IQ) : void
      {
      }
      
      private function configure_error(iq:IQ) : void
      {
         this.admin_error(iq);
      }
      
      private function configure_response(iq:IQ) : void
      {
         var event:RoomEvent = new RoomEvent(RoomEvent.CONFIGURE_ROOM_COMPLETE);
         dispatchEvent(event);
      }
      
      private function dispatchChangeEvent(name:String, newValue:*, oldValue:*) : void
      {
         var event:PropertyChangeEvent = new PropertyChangeEvent(PropertyChangeEvent.CHANGE);
         event.name = name;
         event.newValue = newValue;
         event.oldValue = oldValue;
         dispatchEvent(event);
      }
      
      private function grant_error(iq:IQ) : void
      {
         if(this.affiliationExtension is MUCAdminExtension && this.affiliationArgs.length > 0)
         {
            this.affiliationExtension = new MUCOwnerExtension();
            this.grant.apply(null,this.affiliationArgs);
         }
         else
         {
            this.affiliationArgs = [];
            this.admin_error(iq);
         }
      }
      
      private function grant_response(iq:IQ) : void
      {
         this.affiliationArgs = [];
         var event:RoomEvent = new RoomEvent(RoomEvent.AFFILIATION_CHANGE_COMPLETE);
         dispatchEvent(event);
      }
      
      private function handleEvent(eventObj:Object) : void
      {
         var userExt:MUCUserExtension = null;
         var message:Message = null;
         var userExts:Array = null;
         var roomEvent:RoomEvent = null;
         var form:Array = null;
         var presence:Presence = null;
         var status:MUCStatus = null;
         switch(eventObj.type)
         {
            case "message":
               message = eventObj.data;
               userExts = message.getAllExtensionsByNS(MUCUserExtension.NS);
               if(this.isThisRoom(message.from.unescaped))
               {
                  if(message.type == Message.TYPE_GROUPCHAT)
                  {
                     if(message.subject != null)
                     {
                        this._subject = message.subject;
                        roomEvent = new RoomEvent(RoomEvent.SUBJECT_CHANGE);
                        roomEvent.subject = message.subject;
                        dispatchEvent(roomEvent);
                     }
                     else if(!userExts || userExts.length == 0 || !userExts[0].hasStatusCode(100))
                     {
                        roomEvent = new RoomEvent(RoomEvent.GROUP_MESSAGE);
                        roomEvent.nickname = message.from.resource;
                        roomEvent.data = message;
                        dispatchEvent(roomEvent);
                     }
                  }
                  else if(message.type == Message.TYPE_NORMAL)
                  {
                     form = message.getAllExtensionsByNS(FormExtension.NS)[0];
                     if(form)
                     {
                        roomEvent = new RoomEvent(RoomEvent.CONFIGURE_ROOM);
                        roomEvent.data = form;
                        dispatchEvent(roomEvent);
                     }
                  }
                  else if(message.type == Message.TYPE_CHAT)
                  {
                     roomEvent = new RoomEvent(RoomEvent.PRIVATE_MESSAGE);
                     roomEvent.data = message;
                     dispatchEvent(roomEvent);
                  }
               }
               else if(this.isThisUser(message.to.unescaped) && message.type == Message.TYPE_CHAT)
               {
                  roomEvent = new RoomEvent(RoomEvent.PRIVATE_MESSAGE);
                  roomEvent.data = message;
                  dispatchEvent(roomEvent);
               }
               else if(userExts != null && userExts.length > 0)
               {
                  userExt = userExts[0];
                  if(userExt && userExt.type == MUCUserExtension.TYPE_DECLINE)
                  {
                     roomEvent = new RoomEvent(RoomEvent.DECLINED);
                     roomEvent.from = userExt.reason;
                     roomEvent.reason = userExt.reason;
                     roomEvent.data = message;
                     dispatchEvent(roomEvent);
                  }
               }
               break;
            case "presence":
               for each(presence in eventObj.data)
               {
                  if(presence.type == Presence.TYPE_ERROR)
                  {
                     switch(presence.errorCode)
                     {
                        case 401:
                           roomEvent = new RoomEvent(RoomEvent.PASSWORD_ERROR);
                           break;
                        case 403:
                           roomEvent = new RoomEvent(RoomEvent.BANNED_ERROR);
                           break;
                        case 404:
                           roomEvent = new RoomEvent(RoomEvent.LOCKED_ERROR);
                           break;
                        case 407:
                           roomEvent = new RoomEvent(RoomEvent.REGISTRATION_REQ_ERROR);
                           break;
                        case 409:
                           roomEvent = new RoomEvent(RoomEvent.NICK_CONFLICT);
                           roomEvent.nickname = this.nickname;
                           break;
                        case 503:
                           roomEvent = new RoomEvent(RoomEvent.MAX_USERS_ERROR);
                           break;
                        default:
                           roomEvent = new RoomEvent("MUC Error of type: " + presence.errorCode);
                     }
                     roomEvent.errorCode = presence.errorCode;
                     roomEvent.errorMessage = presence.errorMessage;
                     dispatchEvent(roomEvent);
                  }
                  else if(this.isThisRoom(presence.from.unescaped))
                  {
                     if(presence.from.resource == this.pendingNickname)
                     {
                        this._nickname = this.pendingNickname;
                        this.pendingNickname = null;
                     }
                     userExt = presence.getAllExtensionsByNS(MUCUserExtension.NS)[0];
                     for each(status in userExt.statuses)
                     {
                        switch(status.code)
                        {
                           case 100:
                           case 172:
                              this._anonymous = false;
                              continue;
                           case 174:
                              this._anonymous = true;
                              continue;
                           case 201:
                              this.unlockRoom(this.myIsReserved);
                              continue;
                           default:
                              continue;
                        }
                     }
                     this.updateRoomRoster(presence);
                     if(presence.type == Presence.TYPE_UNAVAILABLE && this.isActive && this.isThisUser(presence.from.unescaped))
                     {
                        this.setActive(false);
                        if(userExt.type == MUCUserExtension.TYPE_DESTROY)
                        {
                           roomEvent = new RoomEvent(RoomEvent.ROOM_DESTROYED);
                        }
                        else
                        {
                           roomEvent = new RoomEvent(RoomEvent.ROOM_LEAVE);
                        }
                        dispatchEvent(roomEvent);
                        this._connection.removeEventListener(PresenceEvent.PRESENCE,this.handleEvent);
                     }
                  }
               }
               break;
            case "disconnection":
               this.setActive(false);
               removeAll();
               roomEvent = new RoomEvent(RoomEvent.ROOM_LEAVE);
               dispatchEvent(roomEvent);
         }
      }
      
      private function requestAffiliations_error(iq:IQ) : void
      {
         this.admin_error(iq);
      }
      
      private function requestAffiliations_response(iq:IQ) : void
      {
         var adminExt:MUCAdminExtension = null;
         var items:Array = null;
         var event:RoomEvent = null;
         if(iq.type == IQ.TYPE_RESULT)
         {
            adminExt = iq.getAllExtensionsByNS(MUCAdminExtension.NS)[0];
            items = adminExt.getAllItems();
            event = new RoomEvent(RoomEvent.AFFILIATIONS);
            event.data = items;
            dispatchEvent(event);
         }
      }
      
      private function requestConfiguration_error(iq:IQ) : void
      {
         this.admin_error(iq);
      }
      
      private function requestConfiguration_response(iq:IQ) : void
      {
         var event:RoomEvent = null;
         var ownerExt:MUCOwnerExtension = iq.getAllExtensionsByNS(MUCOwnerExtension.NS)[0];
         var form:FormExtension = ownerExt.getAllExtensionsByNS(FormExtension.NS)[0];
         if(form.type == FormExtension.TYPE_REQUEST)
         {
            event = new RoomEvent(RoomEvent.CONFIGURE_ROOM);
            event.data = form;
            dispatchEvent(event);
         }
      }
      
      private function setActive(state:Boolean) : void
      {
         var oldActive:Boolean = this._active;
         this._active = state;
         if(this._active != oldActive)
         {
            this.dispatchChangeEvent("active",this._active,oldActive);
         }
      }
      
      private function unlockRoom(isReserved:Boolean) : void
      {
         var iq:IQ = null;
         var ownerExt:MUCOwnerExtension = null;
         var form:FormExtension = null;
         if(isReserved)
         {
            this.requestConfiguration();
         }
         else
         {
            iq = new IQ(this.roomJID.escaped,IQ.TYPE_SET);
            ownerExt = new MUCOwnerExtension();
            form = new FormExtension();
            form.type = FormExtension.TYPE_SUBMIT;
            ownerExt.addExtension(form);
            iq.addExtension(ownerExt);
            this._connection.send(iq);
         }
      }
      
      private function updateRoomRoster(aPresence:Presence) : void
      {
         var roomEvent:RoomEvent = null;
         var oldAffiliation:String = null;
         var oldRole:String = null;
         var userExt:MUCUserExtension = null;
         var status:MUCStatus = null;
         var userNickname:String = aPresence.from.unescaped.resource;
         var userExts:Array = aPresence.getAllExtensionsByNS(MUCUserExtension.NS);
         var item:MUCItem = userExts[0].getAllItems()[0];
         if(this.isThisUser(aPresence.from.unescaped))
         {
            oldAffiliation = this._affiliation;
            this._affiliation = item.affiliation;
            if(this._affiliation != oldAffiliation)
            {
               this.dispatchChangeEvent("affiliation",this._affiliation,oldAffiliation);
            }
            oldRole = this._role;
            this._role = item.role;
            if(this._role != oldRole)
            {
               this.dispatchChangeEvent("role",this._role,oldRole);
            }
            if(!this.isActive && aPresence.type != Presence.TYPE_UNAVAILABLE)
            {
               this.setActive(true);
               roomEvent = new RoomEvent(RoomEvent.ROOM_JOIN);
               dispatchEvent(roomEvent);
            }
         }
         var occupant:RoomOccupant = this.getOccupantNamed(userNickname);
         if(occupant)
         {
            if(aPresence.type == Presence.TYPE_UNAVAILABLE)
            {
               removeItemAt(getItemIndex(occupant));
               userExt = aPresence.getAllExtensionsByNS(MUCUserExtension.NS)[0];
               for each(status in userExt.statuses)
               {
                  switch(status.code)
                  {
                     case 301:
                        roomEvent = new RoomEvent(RoomEvent.USER_BANNED);
                        roomEvent.nickname = userNickname;
                        roomEvent.data = aPresence;
                        dispatchEvent(roomEvent);
                        return;
                     case 307:
                        roomEvent = new RoomEvent(RoomEvent.USER_KICKED);
                        roomEvent.nickname = userNickname;
                        roomEvent.data = aPresence;
                        dispatchEvent(roomEvent);
                        return;
                     default:
                        continue;
                  }
               }
               roomEvent = new RoomEvent(RoomEvent.USER_DEPARTURE);
               roomEvent.nickname = userNickname;
               roomEvent.data = aPresence;
               dispatchEvent(roomEvent);
            }
            else
            {
               occupant.affiliation = item.affiliation;
               occupant.role = item.role;
               occupant.show = aPresence.show;
               roomEvent = new RoomEvent(RoomEvent.USER_PRESENCE_CHANGE);
               roomEvent.nickname = userNickname;
               roomEvent.data = aPresence;
               dispatchEvent(roomEvent);
            }
         }
         else if(aPresence.type != Presence.TYPE_UNAVAILABLE)
         {
            addItem(new RoomOccupant(userNickname,aPresence.show,item.affiliation,item.role,Boolean(item.jid)?item.jid.unescaped:null,this));
            roomEvent = new RoomEvent(RoomEvent.USER_JOIN);
            roomEvent.nickname = userNickname;
            roomEvent.data = aPresence;
            dispatchEvent(roomEvent);
         }
      }
      
      public function get affiliation() : String
      {
         return this._affiliation;
      }
      
      public function get anonymous() : Boolean
      {
         return this._anonymous;
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
            this._connection.removeEventListener(PresenceEvent.PRESENCE,this.handleEvent);
            this._connection.removeEventListener(DisconnectionEvent.DISCONNECT,this.handleEvent);
         }
         this._connection = value;
         this._connection.addEventListener(MessageEvent.MESSAGE,this.handleEvent,false,0,true);
         this._connection.addEventListener(PresenceEvent.PRESENCE,this.handleEvent,false,0,true);
         this._connection.addEventListener(DisconnectionEvent.DISCONNECT,this.handleEvent,false,0,true);
      }
      
      public function get conferenceServer() : String
      {
         return this._roomJID.domain;
      }
      
      public function set conferenceServer(value:String) : void
      {
         this.roomJID = new UnescapedJID(this.roomName + "@" + value);
      }
      
      public function get isActive() : Boolean
      {
         return this._active;
      }
      
      public function get nickname() : String
      {
         return this._nickname == null?this._connection.username:this._nickname;
      }
      
      public function set nickname(value:String) : void
      {
         var presence:Presence = null;
         if(this.isActive)
         {
            this.pendingNickname = value;
            presence = new Presence(new EscapedJID(this.userJID + "/" + value));
            this._connection.send(presence);
         }
         else
         {
            this._nickname = value;
         }
      }
      
      public function get password() : String
      {
         return this._password;
      }
      
      public function set password(value:String) : void
      {
         this._password = value;
      }
      
      public function get role() : String
      {
         return this._role;
      }
      
      public function get roomJID() : UnescapedJID
      {
         return this._roomJID;
      }
      
      public function set roomJID(jid:UnescapedJID) : void
      {
         this._roomJID = jid;
      }
      
      public function get roomName() : String
      {
         return this._roomJID.node;
      }
      
      public function set roomName(value:String) : void
      {
         this.roomJID = new UnescapedJID(value + "@" + this.conferenceServer);
      }
      
      public function get subject() : String
      {
         return this._subject;
      }
      
      public function get userJID() : UnescapedJID
      {
         if(this._roomJID != null)
         {
            return new UnescapedJID(this._roomJID.bareJID + "/" + this.nickname);
         }
         return null;
      }
   }
}
