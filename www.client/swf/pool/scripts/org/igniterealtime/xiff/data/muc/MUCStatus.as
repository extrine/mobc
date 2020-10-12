package org.igniterealtime.xiff.data.muc
{
   import flash.xml.XMLNode;
   import org.igniterealtime.xiff.data.XMLStanza;
   
   public class MUCStatus
   {
       
      
      private var node:XMLNode;
      
      private var parent:XMLStanza;
      
      public function MUCStatus(xmlNode:XMLNode, parentStanza:XMLStanza)
      {
         super();
         this.node = Boolean(xmlNode)?xmlNode:new XMLNode(1,"status");
         this.parent = parentStanza;
      }
      
      public function get code() : Number
      {
         return this.node.attributes.code;
      }
      
      public function set code(value:Number) : void
      {
         this.node.attributes.code = value.toString();
      }
      
      public function get message() : String
      {
         if(this.node.firstChild)
         {
            return this.node.firstChild.nodeValue;
         }
         return null;
      }
      
      public function set message(value:String) : void
      {
         this.node = this.parent.replaceTextNode(this.parent.getNode(),this.node,"status",value);
      }
   }
}
