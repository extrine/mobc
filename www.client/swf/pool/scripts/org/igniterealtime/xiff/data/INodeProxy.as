package org.igniterealtime.xiff.data
{
   import flash.xml.XMLNode;
   
   public interface INodeProxy
   {
       
      
      function getNode() : XMLNode;
      
      function setNode(node:XMLNode) : Boolean;
   }
}
