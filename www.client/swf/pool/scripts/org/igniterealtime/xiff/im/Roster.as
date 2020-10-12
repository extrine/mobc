package org.igniterealtime.xiff.im
{
   import flash.utils.Dictionary;
   import org.igniterealtime.xiff.collections.ArrayCollection;
   import org.igniterealtime.xiff.core.EscapedJID;
   import org.igniterealtime.xiff.core.UnescapedJID;
   import org.igniterealtime.xiff.core.XMPPConnection;
   import org.igniterealtime.xiff.data.ExtensionClassRegistry;
   import org.igniterealtime.xiff.data.IQ;
   import org.igniterealtime.xiff.data.Presence;
   import org.igniterealtime.xiff.data.XMLStanza;
   import org.igniterealtime.xiff.data.XMPPStanza;
   import org.igniterealtime.xiff.data.im.RosterExtension;
   import org.igniterealtime.xiff.data.im.RosterGroup;
   import org.igniterealtime.xiff.data.im.RosterItemVO;
   import org.igniterealtime.xiff.events.LoginEvent;
   import org.igniterealtime.xiff.events.PresenceEvent;
   import org.igniterealtime.xiff.events.RosterEvent;
   
   [Event(name="userSubscriptionUpdated",type="org.igniterealtime.xiff.events.RosterEvent")]
   [Event(name="userPresenceUpdated",type="org.igniterealtime.xiff.events.RosterEvent")]
   [Event(name="userRemoved",type="org.igniterealtime.xiff.events.RosterEvent")]
   [Event(name="rosterLoaded",type="org.igniterealtime.xiff.events.RosterEvent")]
   [Event(name="userAvailable",type="org.igniterealtime.xiff.events.RosterEvent")]
   [Event(name="userAvailable",type="org.igniterealtime.xiff.events.RosterEvent")]
   [Event(name="subscriptionDenial",type="org.igniterealtime.xiff.events.RosterEvent")]
   [Event(name="subscriptionRequest",type="org.igniterealtime.xiff.events.RosterEvent")]
   [Event(name="subscriptionRevocation",type="org.igniterealtime.xiff.events.RosterEvent")]
   public class Roster extends ArrayCollection
   {
      
      private static var rosterStaticConstructed:Boolean = RosterStaticConstructor();
      
      private static const staticConstructorDependencies:Array = [ExtensionClassRegistry,RosterExtension];
       
      
      private var _connection:XMPPConnection;
      
      private var _groups:Object;
      
      private var _presenceMap:Object;
      
      private var pendingSubscriptionRequests:Dictionary;
      
      public function Roster(aConnection:XMPPConnection = null)
      {
         this._groups = {};
         this._presenceMap = {};
         this.pendingSubscriptionRequests = new Dictionary();
         super();
         if(aConnection != null)
         {
            this.connection = aConnection;
         }
      }
      
      private static function RosterStaticConstructor() : Boolean
      {
         ExtensionClassRegistry.register(RosterExtension);
         return true;
      }
      
      public function addContact(id:UnescapedJID, displayName:String, groupName:String = null, requestSubscription:Boolean = true) : void
      {
         if(displayName == null)
         {
            displayName = id.toString();
         }
         var callbackMethod:Function = null;
         var subscription:String = RosterExtension.SUBSCRIBE_TYPE_NONE;
         var askType:String = RosterExtension.ASK_TYPE_NONE;
         var iqID:String = XMPPStanza.generateID("add_user_");
         if(requestSubscription == true)
         {
            callbackMethod = this.addContact_result;
            this.pendingSubscriptionRequests[iqID.toString()] = id;
            subscription = RosterExtension.SUBSCRIBE_TYPE_TO;
            askType = RosterExtension.ASK_TYPE_SUBSCRIBE;
         }
         var iq:IQ = new IQ(null,IQ.TYPE_SET,iqID,callbackMethod);
         var ext:RosterExtension = new RosterExtension(iq.getNode());
         ext.addItem(id.escaped,null,displayName,Boolean(groupName)?[groupName]:null);
         iq.addExtension(ext);
         this._connection.send(iq);
         this.addRosterItem(id,displayName,RosterExtension.SHOW_PENDING,RosterExtension.SHOW_PENDING,[groupName],subscription,askType);
      }
      
      public function addContact_result(resultIQ:IQ) : void
      {
         var subscriptionId:UnescapedJID = null;
         var iqID:String = resultIQ.id.toString();
         if(this.pendingSubscriptionRequests.hasOwnProperty(iqID))
         {
            subscriptionId = this.pendingSubscriptionRequests[iqID] as UnescapedJID;
            this.requestSubscription(subscriptionId);
            delete this.pendingSubscriptionRequests[iqID];
         }
      }
      
      public function denySubscription(tojid:UnescapedJID) : void
      {
         var presence:Presence = new Presence(tojid.escaped,null,Presence.TYPE_UNSUBSCRIBED);
         this._connection.send(presence);
      }
      
      public function fetchRoster() : void
      {
         var iq:IQ = new IQ(null,IQ.TYPE_GET,XMPPStanza.generateID("roster_"),this.fetchRoster_result);
         iq.addExtension(new RosterExtension(iq.getNode()));
         this._connection.send(iq);
      }
      
      public function fetchRoster_result(resultIQ:IQ) : void
      {
         var ext:RosterExtension = null;
         var rosterEvent:RosterEvent = null;
         var item:* = undefined;
         var askType:String = null;
         removeAll();
         try
         {
            for each(ext in resultIQ.getAllExtensionsByNS(RosterExtension.NS))
            {
               for each(item in ext.getAllItems())
               {
                  if(!(!item is XMLStanza))
                  {
                     askType = item.askType != null?item.askType.toLowerCase():RosterExtension.ASK_TYPE_NONE;
                     this.addRosterItem(new UnescapedJID(item.jid),item.name,RosterExtension.SHOW_UNAVAILABLE,"Offline",item.groupNames,item.subscription.toLowerCase(),askType);
                  }
               }
            }
            rosterEvent = new RosterEvent(RosterEvent.ROSTER_LOADED,false,false);
            dispatchEvent(rosterEvent);
         }
         catch(error:Error)
         {
            trace(error.getStackTrace());
         }
      }
      
      public function getContainingGroups(item:RosterItemVO) : Array
      {
         var key:* = null;
         var group:RosterGroup = null;
         var result:Array = [];
         for(key in this._groups)
         {
            group = this._groups[key] as RosterGroup;
            if(group.contains(item))
            {
               result.push(group);
            }
         }
         return result;
      }
      
      public function getGroup(name:String) : RosterGroup
      {
         return this._groups[name] as RosterGroup;
      }
      
      public function getPresence(jid:UnescapedJID) : Presence
      {
         return this._presenceMap[jid.toString()] as Presence;
      }
      
      public function grantSubscription(tojid:UnescapedJID, requestAfterGrant:Boolean = true) : void
      {
         var presence:Presence = new Presence(tojid.escaped,null,Presence.TYPE_SUBSCRIBED);
         this._connection.send(presence);
         if(requestAfterGrant)
         {
            this.requestSubscription(tojid,true);
         }
      }
      
      public function removeContact(rosterItem:RosterItemVO) : void
      {
         var iq:IQ = null;
         var ext:RosterExtension = null;
         if(contains(rosterItem))
         {
            iq = new IQ(null,IQ.TYPE_SET,XMPPStanza.generateID("remove_user_"),this.unsubscribe_result);
            ext = new RosterExtension(iq.getNode());
            ext.addItem(new EscapedJID(rosterItem.jid.bareJID),RosterExtension.SUBSCRIBE_TYPE_REMOVE);
            iq.addExtension(ext);
            this._connection.send(iq);
         }
      }
      
      public function requestSubscription(id:UnescapedJID, isResponse:Boolean = false) : void
      {
         var presence:Presence = null;
         if(isResponse)
         {
            presence = new Presence(id.escaped,null,Presence.TYPE_SUBSCRIBE);
            this._connection.send(presence);
            return;
         }
         if(contains(RosterItemVO.get(id,false)))
         {
            presence = new Presence(id.escaped,null,Presence.TYPE_SUBSCRIBE);
            this._connection.send(presence);
         }
      }
      
      public function setPresence(show:String, status:String, priority:int) : void
      {
         var presence:Presence = new Presence(null,null,null,show,status,priority);
         this._connection.send(presence);
      }
      
      public function unsubscribe_result(resultIQ:IQ) : void
      {
      }
      
      public function updateContactGroups(rosterItem:RosterItemVO, newGroupNames:Array) : void
      {
         this.updateContact(rosterItem,rosterItem.displayName,newGroupNames);
      }
      
      public function updateContactName(rosterItem:RosterItemVO, newName:String) : void
      {
         var group:RosterGroup = null;
         var groupNames:Array = [];
         for each(group in this.getContainingGroups(rosterItem))
         {
            groupNames.push(group.label);
         }
         this.updateContact(rosterItem,newName,groupNames);
      }
      
      private function addRosterItem(jid:UnescapedJID, displayName:String, show:String, status:String, groupNames:Array, type:String, askType:String = "none") : Boolean
      {
         if(!jid)
         {
            return false;
         }
         var rosterItem:RosterItemVO = RosterItemVO.get(jid,true);
         if(!contains(rosterItem))
         {
            addItem(rosterItem);
         }
         if(displayName)
         {
            rosterItem.displayName = displayName;
         }
         rosterItem.subscribeType = type;
         rosterItem.askType = askType;
         rosterItem.status = status;
         rosterItem.show = show;
         this.setContactGroups(rosterItem,groupNames);
         var event:RosterEvent = new RosterEvent(RosterEvent.USER_ADDED);
         event.jid = jid;
         event.data = rosterItem;
         dispatchEvent(event);
         return true;
      }
      
      private function handleEvent(eventObj:*) : void
      {
         var ext:RosterExtension = null;
         var items:Array = null;
         var item:* = undefined;
         var jid:UnescapedJID = null;
         var rosterItemVO:RosterItemVO = null;
         var rosterEvent:RosterEvent = null;
         var group:RosterGroup = null;
         var groupNames:Array = null;
         var askType:String = null;
         switch(eventObj.type)
         {
            case PresenceEvent.PRESENCE:
               this.handlePresences(eventObj.data);
               break;
            case LoginEvent.LOGIN:
               this.fetchRoster();
               this.setPresence(null,"Online",5);
               break;
            case RosterExtension.NS:
               try
               {
                  ext = (eventObj.iq as IQ).getAllExtensionsByNS(RosterExtension.NS)[0] as RosterExtension;
                  items = ext.getAllItems();
                  for each(item in items)
                  {
                     jid = new UnescapedJID(item.jid);
                     rosterItemVO = RosterItemVO.get(jid,true);
                     if(contains(rosterItemVO))
                     {
                        switch(item.subscription.toLowerCase())
                        {
                           case RosterExtension.SUBSCRIBE_TYPE_NONE:
                              rosterEvent = new RosterEvent(RosterEvent.SUBSCRIPTION_REVOCATION);
                              rosterEvent.jid = jid;
                              dispatchEvent(rosterEvent);
                              break;
                           case RosterExtension.SUBSCRIBE_TYPE_REMOVE:
                              rosterEvent = new RosterEvent(RosterEvent.USER_REMOVED);
                              for each(group in this.getContainingGroups(rosterItemVO))
                              {
                                 group.removeItem(rosterItemVO);
                              }
                              rosterEvent.data = removeItemAt(getItemIndex(rosterItemVO));
                              rosterEvent.jid = jid;
                              dispatchEvent(rosterEvent);
                              break;
                           default:
                              this.updateRosterItemSubscription(rosterItemVO,item.subscription.toLowerCase(),item.name,item.groupNames);
                        }
                     }
                     else
                     {
                        groupNames = item.groupNames;
                        askType = item.askType != null?item.askType.toLowerCase():RosterExtension.ASK_TYPE_NONE;
                        if(item.subscription.toLowerCase() != RosterExtension.SUBSCRIBE_TYPE_REMOVE && item.subscription.toLowerCase() != RosterExtension.SUBSCRIBE_TYPE_NONE)
                        {
                           this.addRosterItem(jid,item.name,RosterExtension.SHOW_UNAVAILABLE,"Offline",groupNames,item.subscription.toLowerCase(),askType);
                        }
                        else if((item.subscription.toLowerCase() == RosterExtension.SUBSCRIBE_TYPE_NONE || item.subscription.toLowerCase() == RosterExtension.SUBSCRIBE_TYPE_FROM) && item.askType == RosterExtension.ASK_TYPE_SUBSCRIBE)
                        {
                           this.addRosterItem(jid,item.name,RosterExtension.SHOW_PENDING,"Pending",groupNames,item.subscription.toLowerCase(),askType);
                        }
                     }
                  }
               }
               catch(error:Error)
               {
                  trace(error.getStackTrace());
               }
         }
      }
      
      private function handlePresences(presenceArray:Array) : void
      {
         var aPresence:Presence = null;
         var type:String = null;
         var rosterEvent:RosterEvent = null;
         var unavailableItem:RosterItemVO = null;
         var availableItem:RosterItemVO = null;
         for each(aPresence in presenceArray)
         {
            type = Boolean(aPresence.type)?aPresence.type.toLowerCase():null;
            rosterEvent = null;
            switch(type)
            {
               case Presence.TYPE_SUBSCRIBE:
                  rosterEvent = new RosterEvent(RosterEvent.SUBSCRIPTION_REQUEST);
                  break;
               case Presence.TYPE_UNSUBSCRIBED:
                  rosterEvent = new RosterEvent(RosterEvent.SUBSCRIPTION_DENIAL);
                  break;
               case Presence.TYPE_UNAVAILABLE:
                  rosterEvent = new RosterEvent(RosterEvent.USER_UNAVAILABLE);
                  unavailableItem = RosterItemVO.get(aPresence.from.unescaped,false);
                  if(!unavailableItem)
                  {
                     break;
                  }
                  this.updateRosterItemPresence(unavailableItem,aPresence);
                  break;
               default:
                  rosterEvent = new RosterEvent(RosterEvent.USER_AVAILABLE);
                  rosterEvent.data = aPresence;
                  if(aPresence.from)
                  {
                     availableItem = RosterItemVO.get(aPresence.from.unescaped,false);
                  }
                  if(!availableItem)
                  {
                     break;
                  }
                  this.updateRosterItemPresence(availableItem,aPresence);
                  break;
            }
            if(rosterEvent != null)
            {
               if(aPresence.from)
               {
                  rosterEvent.jid = aPresence.from.unescaped;
               }
               dispatchEvent(rosterEvent);
            }
         }
      }
      
      private function setContactGroups(contact:RosterItemVO, groupNames:Array) : void
      {
         var name:String = null;
         var group:RosterGroup = null;
         if(!groupNames || groupNames.length == 0)
         {
            groupNames = ["General"];
         }
         for each(name in groupNames)
         {
            if(!this.getGroup(name))
            {
               this._groups[name] = new RosterGroup(name);
            }
         }
         for each(group in this._groups)
         {
            if(groupNames.indexOf(group.label) >= 0)
            {
               group.addItem(contact);
            }
            else
            {
               group.removeItem(contact);
            }
         }
      }
      
      private function updateContact(rosterItem:RosterItemVO, newName:String, groupNames:Array) : void
      {
         var iq:IQ = new IQ(null,IQ.TYPE_SET,XMPPStanza.generateID("update_contact_"));
         var ext:RosterExtension = new RosterExtension(iq.getNode());
         ext.addItem(rosterItem.jid.escaped,rosterItem.subscribeType,newName,groupNames);
         iq.addExtension(ext);
         this._connection.send(iq);
      }
      
      private function updateRosterItemPresence(item:RosterItemVO, presence:Presence) : void
      {
         var event:RosterEvent = null;
         try
         {
            item.status = presence.status;
            item.show = presence.show;
            item.priority = presence.priority;
            if(!presence.type)
            {
               item.online = true;
            }
            else if(presence.type == Presence.TYPE_UNAVAILABLE)
            {
               item.online = false;
            }
            itemUpdated(item);
            event = new RosterEvent(RosterEvent.USER_PRESENCE_UPDATED);
            event.jid = item.jid;
            event.data = item;
            dispatchEvent(event);
            this._presenceMap[item.jid.toString()] = presence;
         }
         catch(error:Error)
         {
            trace(error.getStackTrace());
         }
      }
      
      private function updateRosterItemSubscription(item:RosterItemVO, type:String, name:String, newGroupNames:Array) : void
      {
         item.subscribeType = type;
         this.setContactGroups(item,newGroupNames);
         if(name)
         {
            item.displayName = name;
         }
         var event:RosterEvent = new RosterEvent(RosterEvent.USER_SUBSCRIPTION_UPDATED);
         event.jid = item.jid;
         event.data = item;
         dispatchEvent(event);
      }
      
      public function get connection() : XMPPConnection
      {
         return this._connection;
      }
      
      public function set connection(value:XMPPConnection) : void
      {
         this._connection = value;
         this._connection.addEventListener(PresenceEvent.PRESENCE,this.handleEvent);
         this._connection.addEventListener(LoginEvent.LOGIN,this.handleEvent);
         this._connection.addEventListener(RosterExtension.NS,this.handleEvent);
      }
   }
}
