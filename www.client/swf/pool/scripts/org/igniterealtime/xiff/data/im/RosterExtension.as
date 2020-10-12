package org.igniterealtime.xiff.data.im
{
   import flash.xml.XMLNode;
   import org.igniterealtime.xiff.core.EscapedJID;
   import org.igniterealtime.xiff.data.Extension;
   import org.igniterealtime.xiff.data.ExtensionClassRegistry;
   import org.igniterealtime.xiff.data.IExtension;
   import org.igniterealtime.xiff.data.ISerializable;
   
   public class RosterExtension extends Extension implements IExtension, ISerializable
   {
      
      public static const NS:String = "jabber:iq:roster";
      
      public static const ELEMENT_NAME:String = "query";
      
      public static const SUBSCRIBE_TYPE_NONE:String = "none";
      
      public static const SUBSCRIBE_TYPE_TO:String = "to";
      
      public static const SUBSCRIBE_TYPE_FROM:String = "from";
      
      public static const SUBSCRIBE_TYPE_BOTH:String = "both";
      
      public static const SUBSCRIBE_TYPE_REMOVE:String = "remove";
      
      public static const ASK_TYPE_NONE:String = "none";
      
      public static const ASK_TYPE_SUBSCRIBE:String = "subscribe";
      
      public static const ASK_TYPE_UNSUBSCRIBE:String = "unsubscribe";
      
      public static const SHOW_UNAVAILABLE:String = "unavailable";
      
      public static const SHOW_PENDING:String = "Pending";
      
      private static var staticDepends:Array = [ExtensionClassRegistry];
       
      
      private var _items:Array;
      
      public function RosterExtension(parent:XMLNode = null)
      {
         this._items = [];
         super(parent);
      }
      
      public static function enable() : void
      {
         ExtensionClassRegistry.register(RosterExtension);
      }
      
      public function getNS() : String
      {
         return RosterExtension.NS;
      }
      
      public function getElementName() : String
      {
         return RosterExtension.ELEMENT_NAME;
      }
      
      public function serialize(parent:XMLNode) : Boolean
      {
         var i:* = null;
         var node:XMLNode = getNode();
         for(i in this._items)
         {
            if(!this._items[i].serialize(node))
            {
               return false;
            }
         }
         if(!exists(getNode().parentNode))
         {
            parent.appendChild(getNode().cloneNode(true));
         }
         return true;
      }
      
      public function deserialize(node:XMLNode) : Boolean
      {
         var i:* = null;
         var item:RosterItem = null;
         setNode(node);
         this.removeAllItems();
         var children:Array = node.childNodes;
         for(i in children)
         {
            switch(children[i].nodeName)
            {
               case "item":
                  item = new RosterItem(getNode());
                  if(!item.deserialize(children[i]))
                  {
                     return false;
                  }
                  this._items.push(item);
                  continue;
               default:
                  continue;
            }
         }
         return true;
      }
      
      public function getAllItems() : Array
      {
         return this._items;
      }
      
      public function getItemByJID(jid:EscapedJID) : RosterItem
      {
         var i:* = null;
         for(i in this._items)
         {
            if(this._items[i].jid == jid.toString())
            {
               return this._items[i];
            }
         }
         return null;
      }
      
      public function addItem(jid:EscapedJID = null, subscription:String = "", displayName:String = "", groups:Array = null) : void
      {
         var group:String = null;
         var item:RosterItem = new RosterItem(getNode());
         if(exists(jid))
         {
            item.jid = jid;
         }
         if(exists(subscription))
         {
            item.subscription = subscription;
         }
         if(exists(displayName))
         {
            item.name = displayName;
         }
         if(exists(groups))
         {
            for each(group in groups)
            {
               if(group)
               {
                  item.addGroupNamed(group);
               }
            }
         }
      }
      
      public function removeAllItems() : void
      {
         var i:* = null;
         for(i in this._items)
         {
            this._items[i].setNode(null);
         }
         this._items = [];
      }
   }
}
