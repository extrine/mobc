package org.igniterealtime.xiff.data
{
   import flash.xml.XMLNode;
   
   public interface ISerializable
   {
       
      
      function serialize(parentNode:XMLNode) : Boolean;
      
      function deserialize(node:XMLNode) : Boolean;
   }
}
