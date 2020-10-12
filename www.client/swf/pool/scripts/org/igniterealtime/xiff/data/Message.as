package org.igniterealtime.xiff.data
{
   import flash.xml.XMLNode;
   import org.igniterealtime.xiff.core.EscapedJID;
   import org.igniterealtime.xiff.data.muc.MUCUserExtension;
   import org.igniterealtime.xiff.data.xhtml.XHTMLExtension;
   
   public class Message extends XMPPStanza implements ISerializable
   {
      
      public static const TYPE_CHAT:String = "chat";
      
      public static const TYPE_ERROR:String = "error";
      
      public static const TYPE_GROUPCHAT:String = "groupchat";
      
      public static const TYPE_HEADLINE:String = "headline";
      
      public static const TYPE_NORMAL:String = "normal";
      
      public static const STATE_ACTIVE:String = "active";
      
      public static const STATE_COMPOSING:String = "composing";
      
      public static const STATE_PAUSED:String = "paused";
      
      public static const STATE_INACTIVE:String = "inactive";
      
      public static const STATE_GONE:String = "gone";
      
      public static const NS_STATE:String = "http://jabber.org/protocol/chatstates";
      
      public static const RECEIPT_REQUEST:String = "request";
      
      public static const RECEIPT_RECEIVED:String = "received";
      
      public static const NS_RECEIPT:String = "urn:xmpp:receipts";
      
      private static var isMessageStaticCalled:Boolean = MessageStaticConstructor();
      
      private static var staticConstructorDependency:Array = [XMPPStanza,XHTMLExtension,ExtensionClassRegistry];
       
      
      private var myBodyNode:XMLNode;
      
      private var mySubjectNode:XMLNode;
      
      private var myThreadNode:XMLNode;
      
      private var myTimeStampNode:XMLNode;
      
      private var myStateNode:XMLNode;
      
      public function Message(recipient:EscapedJID = null, msgID:String = null, msgBody:String = null, msgHTMLBody:String = null, msgType:String = null, msgSubject:String = null, chatState:String = null)
      {
         var msgId:String = !!exists(msgID)?msgID:generateID("m_");
         super(recipient,null,msgType,msgId,"message");
         this.body = msgBody;
         this.htmlBody = msgHTMLBody;
         this.subject = msgSubject;
         this.state = chatState;
      }
      
      public static function MessageStaticConstructor() : Boolean
      {
         XHTMLExtension.enable();
         return true;
      }
      
      override public function serialize(parentNode:XMLNode) : Boolean
      {
         return super.serialize(parentNode);
      }
      
      override public function deserialize(xmlNode:XMLNode) : Boolean
      {
         var children:Array = null;
         var i:* = null;
         var mucUserExtension:MUCUserExtension = null;
         var isSerialized:Boolean = super.deserialize(xmlNode);
         if(isSerialized)
         {
            children = xmlNode.childNodes;
            for(i in children)
            {
               switch(children[i].nodeName)
               {
                  case "error":
                     continue;
                  case "body":
                     this.myBodyNode = children[i];
                     continue;
                  case "subject":
                     this.mySubjectNode = children[i];
                     continue;
                  case "thread":
                     this.myThreadNode = children[i];
                     continue;
                  case "x":
                     if(children[i].attributes.xmlns == "jabber:x:delay")
                     {
                        this.myTimeStampNode = children[i];
                     }
                     if(children[i].attributes.xmlns == MUCUserExtension.NS)
                     {
                        mucUserExtension = new MUCUserExtension(getNode());
                        mucUserExtension.deserialize(children[i]);
                        addExtension(mucUserExtension);
                     }
                     continue;
                  case "delay":
                     trace("Message used \'delay\' as defined in XEP-0203.");
                     continue;
                  case Message.STATE_ACTIVE:
                  case Message.STATE_COMPOSING:
                  case Message.STATE_GONE:
                  case Message.STATE_INACTIVE:
                  case Message.STATE_PAUSED:
                     this.myStateNode = children[i];
                     continue;
                  default:
                     continue;
               }
            }
         }
         return isSerialized;
      }
      
      public function get body() : String
      {
         if(!exists(this.myBodyNode) || !exists(this.myBodyNode.firstChild))
         {
            return null;
         }
         var value:String = "";
         try
         {
            value = this.myBodyNode.firstChild.nodeValue;
         }
         catch(error:Error)
         {
            trace(error.getStackTrace());
         }
         return value;
      }
      
      public function set body(value:String) : void
      {
         this.myBodyNode = replaceTextNode(getNode(),this.myBodyNode,"body",value);
      }
      
      public function get htmlBody() : String
      {
         var ext:XHTMLExtension = null;
         try
         {
            ext = getAllExtensionsByNS(XHTMLExtension.NS)[0];
            return ext.body;
         }
         catch(error:Error)
         {
            trace("Error : null trapped. Resuming.");
         }
         return null;
      }
      
      public function set htmlBody(value:String) : void
      {
         var ext:XHTMLExtension = null;
         removeAllExtensions(XHTMLExtension.NS);
         if(exists(value) && value.length > 0)
         {
            ext = new XHTMLExtension(getNode());
            ext.body = value;
            addExtension(ext);
         }
      }
      
      public function get subject() : String
      {
         if(this.mySubjectNode == null || this.mySubjectNode.firstChild == null)
         {
            return null;
         }
         return this.mySubjectNode.firstChild.nodeValue;
      }
      
      public function set subject(value:String) : void
      {
         this.mySubjectNode = replaceTextNode(getNode(),this.mySubjectNode,"subject",value);
      }
      
      public function get thread() : String
      {
         if(this.myThreadNode == null || this.myThreadNode.firstChild == null)
         {
            return null;
         }
         return this.myThreadNode.firstChild.nodeValue;
      }
      
      public function set thread(value:String) : void
      {
         this.myThreadNode = replaceTextNode(getNode(),this.myThreadNode,"thread",value);
      }
      
      public function get time() : Date
      {
         if(this.myTimeStampNode == null)
         {
            return null;
         }
         var stamp:String = this.myTimeStampNode.attributes.stamp;
         trace("myTimeStampNode: " + this.myTimeStampNode.toString());
         var value:Date = new Date();
         value.setUTCFullYear(stamp.substr(0,4));
         value.setUTCMonth(parseInt(stamp.substr(4,2)) - 1);
         value.setUTCDate(stamp.substr(6,2));
         value.setUTCHours(stamp.substr(9,2));
         value.setUTCMinutes(stamp.substr(12,2));
         value.setUTCSeconds(stamp.substr(15,2));
         return value;
      }
      
      public function set time(value:Date) : void
      {
      }
      
      public function get state() : String
      {
         if(!this.myStateNode)
         {
            return null;
         }
         return this.myStateNode.nodeName;
      }
      
      public function set state(value:String) : void
      {
         if(value != Message.STATE_ACTIVE && value != Message.STATE_COMPOSING && value != Message.STATE_PAUSED && value != Message.STATE_INACTIVE && value != Message.STATE_GONE && value != null && value != "")
         {
            throw new Error("Invalid state value: " + value + " for ChatState");
         }
         if(this.myStateNode && (value == null || value == ""))
         {
            this.myStateNode.removeNode();
            this.myStateNode = null;
         }
         else if(this.myStateNode && (value != null && value != ""))
         {
            this.myStateNode.nodeName = value;
         }
         else if(!this.myStateNode && (value != null && value != ""))
         {
            this.myStateNode = XMLStanza.XMLFactory.createElement(value);
            this.myStateNode.attributes = {"xmlns":Message.NS_STATE};
            getNode().appendChild(this.myStateNode);
         }
      }
   }
}
