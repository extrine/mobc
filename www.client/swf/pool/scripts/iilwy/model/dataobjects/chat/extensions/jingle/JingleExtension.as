package iilwy.model.dataobjects.chat.extensions.jingle
{
   import flash.xml.XMLNode;
   import mx.utils.UIDUtil;
   import org.igniterealtime.xiff.data.Extension;
   import org.igniterealtime.xiff.data.ExtensionClassRegistry;
   import org.igniterealtime.xiff.data.IExtension;
   import org.igniterealtime.xiff.data.ISerializable;
   
   public class JingleExtension extends Extension implements IExtension, ISerializable
   {
      
      public static var NS:String = "urn:xmpp:jingle:1";
      
      public static var ELEMENT:String = "jingle";
       
      
      private var contentElements:Array;
      
      public function JingleExtension(parent:XMLNode = null)
      {
         this.contentElements = [];
         super(parent);
      }
      
      public static function enable() : void
      {
         ExtensionClassRegistry.register(JingleExtension);
      }
      
      public function getNS() : String
      {
         return JingleExtension.NS;
      }
      
      public function getElementName() : String
      {
         return JingleExtension.ELEMENT;
      }
      
      public function serialize(parent:XMLNode) : Boolean
      {
         var i:* = null;
         if(!this.sid)
         {
            this.sid = UIDUtil.createUID();
         }
         var node:XMLNode = getNode();
         for(i in this.contentElements)
         {
            if(!this.contentElements[i].serialize(node))
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
         var content:JingleContent = null;
         setNode(node);
         var children:Array = node.childNodes;
         for(i in children)
         {
            switch(children[i].nodeName)
            {
               case "content":
                  content = new JingleContent(getNode());
                  if(!content.deserialize(children[i]))
                  {
                     return false;
                  }
                  this.contentElements.push(content);
                  continue;
               default:
                  continue;
            }
         }
         return true;
      }
      
      public function get action() : String
      {
         return getNode().attributes.action;
      }
      
      public function set action(value:String) : void
      {
         getNode().attributes.action = value;
      }
      
      public function get initiator() : String
      {
         return getNode().attributes.initiator;
      }
      
      public function set initiator(value:String) : void
      {
         getNode().attributes.initiator = value;
      }
      
      public function get responder() : String
      {
         return getNode().attributes.responder;
      }
      
      public function set responder(value:String) : void
      {
         getNode().attributes.responder = value;
      }
      
      public function get sid() : String
      {
         return getNode().attributes.sid;
      }
      
      public function set sid(value:String) : void
      {
         getNode().attributes.sid = value;
      }
      
      public function getAllContent() : Array
      {
         return this.contentElements;
      }
      
      public function getContentByName(name:String) : JingleContent
      {
         var i:* = null;
         for(i in this.contentElements)
         {
            if(this.contentElements[i].name == name)
            {
               return this.contentElements[i];
            }
         }
         return null;
      }
      
      public function addContent(creator:String = null, disposition:String = null, name:String = null, senders:String = null) : void
      {
         var content:JingleContent = new JingleContent(getNode());
         if(creator)
         {
            content.creator = creator;
         }
         if(disposition)
         {
            content.disposition = disposition;
         }
         if(name)
         {
            content.name = name;
         }
         if(senders)
         {
            content.senders = senders;
         }
      }
      
      public function removeAllContent() : void
      {
         var i:* = null;
         for(i in this.contentElements)
         {
            this.contentElements[i].setNode(null);
         }
         this.contentElements = [];
      }
   }
}
