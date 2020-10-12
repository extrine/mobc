package org.igniterealtime.xiff.data.vcard
{
   import flash.xml.XMLNode;
   import org.igniterealtime.xiff.data.Extension;
   import org.igniterealtime.xiff.data.IExtension;
   import org.igniterealtime.xiff.data.ISerializable;
   
   public class VCardExtension extends Extension implements IExtension, ISerializable
   {
       
      
      public function VCardExtension()
      {
         super();
      }
      
      public function getNS() : String
      {
         return "vcard-temp";
      }
      
      public function getElementName() : String
      {
         return "vCard";
      }
      
      public function serialize(parentNode:XMLNode) : Boolean
      {
         parentNode.appendChild(getNode());
         return true;
      }
      
      public function deserialize(node:XMLNode) : Boolean
      {
         return true;
      }
   }
}
