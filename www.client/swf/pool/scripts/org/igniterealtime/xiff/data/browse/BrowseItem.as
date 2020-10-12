package org.igniterealtime.xiff.data.browse
{
   import flash.xml.XMLNode;
   import org.igniterealtime.xiff.data.ISerializable;
   import org.igniterealtime.xiff.data.XMLStanza;
   
   public class BrowseItem extends XMLStanza implements ISerializable
   {
       
      
      public function BrowseItem(parent:XMLNode)
      {
         super();
         getNode().nodeName = "item";
         if(exists(parent))
         {
            parent.appendChild(getNode());
         }
      }
      
      public function serialize(parentNode:XMLNode) : Boolean
      {
         var node:XMLNode = getNode();
         if(!exists(node.parentNode))
         {
            parentNode.appendChild(node.cloneNode(true));
         }
         return true;
      }
      
      public function deserialize(node:XMLNode) : Boolean
      {
         setNode(node);
         return true;
      }
      
      public function addNamespace(value:String) : XMLNode
      {
         return addTextNode(getNode(),"ns",value);
      }
      
      public function get jid() : String
      {
         return getNode().attributes.jid;
      }
      
      public function set jid(value:String) : void
      {
         getNode().attributes.jid = value;
      }
      
      public function get category() : String
      {
         return getNode().attributes.category;
      }
      
      public function set category(value:String) : void
      {
         getNode().attributes.category = value;
      }
      
      public function get name() : String
      {
         return getNode().attributes.name;
      }
      
      public function set name(value:String) : void
      {
         getNode().attributes.name = value;
      }
      
      public function get type() : String
      {
         return getNode().attributes.type;
      }
      
      public function set type(value:String) : void
      {
         getNode().attributes.type = value;
      }
      
      public function get version() : String
      {
         return getNode().attributes.version;
      }
      
      public function set version(value:String) : void
      {
         getNode().attributes.version = value;
      }
      
      public function get namespaces() : Array
      {
         var child:XMLNode = null;
         var res:Array = [];
         for each(child in getNode().childNodes)
         {
            if(child.nodeName == "ns")
            {
               res.push(child.firstChild.nodeValue);
            }
         }
         return res;
      }
   }
}
