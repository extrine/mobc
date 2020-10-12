package org.igniterealtime.xiff.data.disco
{
   import flash.xml.XMLNode;
   import org.igniterealtime.xiff.core.EscapedJID;
   import org.igniterealtime.xiff.data.Extension;
   import org.igniterealtime.xiff.data.ISerializable;
   
   public class DiscoExtension extends Extension implements ISerializable
   {
      
      public static const NS:String = "http://jabber.org/protocol/disco";
      
      public static const ELEMENT_NAME:String = "query";
       
      
      public var _service:EscapedJID;
      
      public function DiscoExtension(xmlNode:XMLNode)
      {
         super(xmlNode);
      }
      
      public function get serviceNode() : String
      {
         return getNode().parentNode.attributes.node;
      }
      
      public function set serviceNode(value:String) : void
      {
         getNode().parentNode.attributes.node = value;
      }
      
      public function get service() : EscapedJID
      {
         var parent:XMLNode = getNode().parentNode;
         if(parent.attributes.type == "result")
         {
            return new EscapedJID(parent.attributes.from);
         }
         return new EscapedJID(parent.attributes.to);
      }
      
      public function set service(value:EscapedJID) : void
      {
         var parent:XMLNode = getNode().parentNode;
         if(parent.attributes.type == "result")
         {
            parent.attributes.from = value.toString();
         }
         else
         {
            parent.attributes.to = value.toString();
         }
      }
      
      public function serialize(parentNode:XMLNode) : Boolean
      {
         if(parentNode != getNode().parentNode)
         {
            parentNode.appendChild(getNode().cloneNode(true));
         }
         return true;
      }
      
      public function deserialize(node:XMLNode) : Boolean
      {
         setNode(node);
         return true;
      }
   }
}
