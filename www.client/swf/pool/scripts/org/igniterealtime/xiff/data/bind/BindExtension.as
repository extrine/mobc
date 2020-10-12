package org.igniterealtime.xiff.data.bind
{
   import flash.xml.XMLNode;
   import org.igniterealtime.xiff.core.EscapedJID;
   import org.igniterealtime.xiff.data.Extension;
   import org.igniterealtime.xiff.data.ExtensionClassRegistry;
   import org.igniterealtime.xiff.data.IExtension;
   import org.igniterealtime.xiff.data.ISerializable;
   import org.igniterealtime.xiff.data.XMLStanza;
   
   public class BindExtension extends Extension implements IExtension, ISerializable
   {
      
      public static const NS:String = "urn:ietf:params:xml:ns:xmpp-bind";
      
      public static const ELEMENT_NAME:String = "bind";
       
      
      private var _jid:EscapedJID;
      
      private var _resource:String;
      
      public function BindExtension(parent:XMLNode = null)
      {
         super(parent);
      }
      
      public static function enable() : void
      {
         ExtensionClassRegistry.register(BindExtension);
      }
      
      public function getNS() : String
      {
         return BindExtension.NS;
      }
      
      public function getElementName() : String
      {
         return BindExtension.ELEMENT_NAME;
      }
      
      public function get jid() : EscapedJID
      {
         return this._jid;
      }
      
      public function serialize(parent:XMLNode) : Boolean
      {
         var child:XMLNode = null;
         var resourceNode:XMLNode = null;
         if(!exists(getNode().parentNode))
         {
            child = getNode().cloneNode(true);
            resourceNode = new XMLNode(1,"resource");
            resourceNode.appendChild(XMLStanza.XMLFactory.createTextNode(Boolean(this.resource)?this.resource:"xiff"));
            child.appendChild(resourceNode);
            parent.appendChild(child);
         }
         return true;
      }
      
      public function deserialize(node:XMLNode) : Boolean
      {
         var i:* = null;
         setNode(node);
         var children:Array = node.childNodes;
         while(true)
         {
            loop0:
            for(i in children)
            {
               switch(children[i].nodeName)
               {
                  case "jid":
                     this._jid = new EscapedJID(children[i].firstChild.nodeValue);
                     continue;
                  default:
                     break loop0;
               }
            }
            return true;
         }
         throw "Unknown element: " + children[i].nodeName;
      }
      
      public function set resource(value:String) : void
      {
         this._resource = value;
      }
      
      public function get resource() : String
      {
         return this._resource;
      }
   }
}
