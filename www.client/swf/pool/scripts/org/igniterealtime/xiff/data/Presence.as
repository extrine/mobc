package org.igniterealtime.xiff.data
{
   import flash.xml.XMLNode;
   import org.igniterealtime.xiff.core.EscapedJID;
   
   public class Presence extends XMPPStanza implements ISerializable
   {
      
      public static const TYPE_ERROR:String = "error";
      
      public static const TYPE_PROBE:String = "probe";
      
      public static const TYPE_SUBSCRIBE:String = "subscribe";
      
      public static const TYPE_SUBSCRIBED:String = "subscribed";
      
      public static const TYPE_UNAVAILABLE:String = "unavailable";
      
      public static const TYPE_UNSUBSCRIBE:String = "unsubscribe";
      
      public static const TYPE_UNSUBSCRIBED:String = "unsubscribed";
      
      public static const SHOW_AWAY:String = "away";
      
      public static const SHOW_CHAT:String = "chat";
      
      public static const SHOW_DND:String = "dnd";
      
      public static const SHOW_XA:String = "xa";
       
      
      private var myShowNode:XMLNode;
      
      private var myStatusNode:XMLNode;
      
      private var myPriorityNode:XMLNode;
      
      public function Presence(recipient:EscapedJID = null, sender:EscapedJID = null, presenceType:String = null, showVal:String = null, statusVal:String = null, priorityVal:int = 0)
      {
         super(recipient,sender,presenceType,null,"presence");
         this.show = showVal;
         this.status = statusVal;
         this.priority = priorityVal;
      }
      
      override public function serialize(parentNode:XMLNode) : Boolean
      {
         return super.serialize(parentNode);
      }
      
      override public function deserialize(xmlNode:XMLNode) : Boolean
      {
         var children:Array = null;
         var i:* = null;
         var isDeserialized:Boolean = super.deserialize(xmlNode);
         if(isDeserialized)
         {
            children = xmlNode.childNodes;
            for(i in children)
            {
               switch(children[i].nodeName)
               {
                  case "show":
                     this.myShowNode = children[i];
                     continue;
                  case "status":
                     this.myStatusNode = children[i];
                     continue;
                  case "priority":
                     this.myPriorityNode = children[i];
                     continue;
                  default:
                     continue;
               }
            }
         }
         return isDeserialized;
      }
      
      public function get show() : String
      {
         if(!this.myShowNode || !exists(this.myShowNode.firstChild))
         {
            return null;
         }
         return this.myShowNode.firstChild.nodeValue;
      }
      
      public function set show(value:String) : void
      {
         if(value != SHOW_AWAY && value != SHOW_CHAT && value != SHOW_DND && value != SHOW_XA && value != null && value != "")
         {
            throw new Error("Invalid show value: " + value + " for presence");
         }
         if(this.myShowNode && (value == null || value == ""))
         {
            this.myShowNode.removeNode();
            this.myShowNode = null;
         }
         this.myShowNode = replaceTextNode(getNode(),this.myShowNode,"show",value);
      }
      
      public function get status() : String
      {
         if(this.myStatusNode == null || this.myStatusNode.firstChild == null)
         {
            return null;
         }
         return this.myStatusNode.firstChild.nodeValue;
      }
      
      public function set status(value:String) : void
      {
         this.myStatusNode = replaceTextNode(getNode(),this.myStatusNode,"status",value);
      }
      
      public function get priority() : int
      {
         if(this.myPriorityNode == null)
         {
            return NaN;
         }
         var p:int = int(this.myPriorityNode.firstChild.nodeValue);
         if(isNaN(p))
         {
            return NaN;
         }
         return p;
      }
      
      public function set priority(value:int) : void
      {
         this.myPriorityNode = replaceTextNode(getNode(),this.myPriorityNode,"priority",value.toString());
      }
   }
}
