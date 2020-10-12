package org.igniterealtime.xiff.data.im
{
   import flash.xml.XMLNode;
   import org.igniterealtime.xiff.core.EscapedJID;
   import org.igniterealtime.xiff.data.ISerializable;
   import org.igniterealtime.xiff.data.XMLStanza;
   
   public class RosterItem extends XMLStanza implements ISerializable
   {
      
      public static const ELEMENT_NAME:String = "item";
       
      
      private var myGroupNodes:Array;
      
      public function RosterItem(parent:XMLNode = null)
      {
         super();
         getNode().nodeName = ELEMENT_NAME;
         this.myGroupNodes = [];
         if(exists(parent))
         {
            parent.appendChild(getNode());
         }
      }
      
      public function serialize(parent:XMLNode) : Boolean
      {
         if(!exists(this.jid))
         {
            trace("Warning: required roster item attributes \'jid\' missing");
            return false;
         }
         if(parent != getNode().parentNode)
         {
            parent.appendChild(getNode().cloneNode(true));
         }
         return true;
      }
      
      public function deserialize(node:XMLNode) : Boolean
      {
         var i:* = null;
         setNode(node);
         var children:Array = node.childNodes;
         for(i in children)
         {
            switch(children[i].nodeName)
            {
               case "group":
                  this.myGroupNodes.push(children[i]);
                  continue;
               default:
                  continue;
            }
         }
         return true;
      }
      
      public function addGroupNamed(groupName:String) : void
      {
         var node:XMLNode = addTextNode(getNode(),"group",groupName);
         this.myGroupNodes.push(node);
      }
      
      public function get groupNames() : Array
      {
         var i:* = null;
         var node:XMLNode = null;
         var returnArr:Array = [];
         for(i in this.myGroupNodes)
         {
            node = this.myGroupNodes[i].firstChild;
            if(node != null)
            {
               returnArr.push(node.nodeValue);
            }
         }
         return returnArr;
      }
      
      public function get groupCount() : uint
      {
         return this.myGroupNodes.length;
      }
      
      public function removeAllGroups() : void
      {
         var i:* = null;
         for(i in this.myGroupNodes)
         {
            this.myGroupNodes[i].removeNode();
         }
         this.myGroupNodes = [];
      }
      
      public function removeGroupByName(groupName:String) : Boolean
      {
         var i:* = null;
         for(i in this.myGroupNodes)
         {
            if(this.myGroupNodes[i].nodeValue == groupName)
            {
               this.myGroupNodes[i].removeNode();
               this.myGroupNodes.splice(parseInt(i),1);
               return true;
            }
         }
         return false;
      }
      
      public function get jid() : EscapedJID
      {
         return new EscapedJID(getNode().attributes.jid);
      }
      
      public function set jid(value:EscapedJID) : void
      {
         getNode().attributes.jid = value.toString();
      }
      
      public function get name() : String
      {
         return getNode().attributes.name;
      }
      
      public function set name(value:String) : void
      {
         getNode().attributes.name = value;
      }
      
      public function get subscription() : String
      {
         return getNode().attributes.subscription;
      }
      
      public function set subscription(value:String) : void
      {
         getNode().attributes.subscription = value;
      }
      
      public function get askType() : String
      {
         return getNode().attributes.ask;
      }
      
      public function set askType(value:String) : void
      {
         getNode().attributes.ask = value;
      }
      
      public function get pending() : Boolean
      {
         if(this.askType == RosterExtension.ASK_TYPE_SUBSCRIBE && (this.subscription == RosterExtension.SUBSCRIBE_TYPE_NONE || this.subscription == RosterExtension.SUBSCRIBE_TYPE_FROM))
         {
            return true;
         }
         return false;
      }
   }
}
