package org.igniterealtime.xiff.data.muc
{
   import flash.xml.XMLNode;
   import org.igniterealtime.xiff.data.Extension;
   import org.igniterealtime.xiff.data.IExtension;
   import org.igniterealtime.xiff.data.ISerializable;
   
   public class MUCExtension extends Extension implements IExtension, ISerializable
   {
      
      public static const NS:String = "http://jabber.org/protocol/muc";
      
      public static const ELEMENT_NAME:String = "x";
       
      
      private var myHistoryNode:XMLNode;
      
      private var myPasswordNode:XMLNode;
      
      public function MUCExtension(parent:XMLNode = null)
      {
         super(parent);
      }
      
      public function getNS() : String
      {
         return MUCExtension.NS;
      }
      
      public function getElementName() : String
      {
         return MUCExtension.ELEMENT_NAME;
      }
      
      public function serialize(parent:XMLNode) : Boolean
      {
         var ext:IExtension = null;
         if(exists(getNode().parentNode))
         {
            return false;
         }
         var node:XMLNode = getNode().cloneNode(true);
         for each(ext in getAllExtensions())
         {
            if(ext is ISerializable)
            {
               ISerializable(ext).serialize(node);
            }
         }
         parent.appendChild(node);
         return true;
      }
      
      public function deserialize(node:XMLNode) : Boolean
      {
         var child:XMLNode = null;
         setNode(node);
         for each(child in node.childNodes)
         {
            switch(child.nodeName)
            {
               case "history":
                  this.myHistoryNode = child;
                  continue;
               case "password":
                  this.myPasswordNode = child;
                  continue;
               default:
                  continue;
            }
         }
         return true;
      }
      
      public function addChildNode(childNode:XMLNode) : void
      {
         getNode().appendChild(childNode);
      }
      
      public function get password() : String
      {
         if(this.myPasswordNode && this.myPasswordNode.firstChild)
         {
            return this.myPasswordNode.firstChild.nodeValue;
         }
         return null;
      }
      
      public function set password(value:String) : void
      {
         this.myPasswordNode = replaceTextNode(getNode(),this.myPasswordNode,"password",value);
      }
      
      public function get history() : Boolean
      {
         return exists(this.myHistoryNode);
      }
      
      public function set history(value:Boolean) : void
      {
         if(value)
         {
            this.myHistoryNode = ensureNode(this.myHistoryNode,"history");
         }
         else
         {
            this.myHistoryNode.removeNode();
            this.myHistoryNode = null;
         }
      }
      
      public function get maxchars() : int
      {
         return parseInt(this.myHistoryNode.attributes.maxchars);
      }
      
      public function set maxchars(value:int) : void
      {
         this.myHistoryNode = ensureNode(this.myHistoryNode,"history");
         this.myHistoryNode.attributes.maxchars = value.toString();
      }
      
      public function get maxstanzas() : int
      {
         return parseInt(this.myHistoryNode.attributes.maxstanzas);
      }
      
      public function set maxstanzas(value:int) : void
      {
         this.myHistoryNode = ensureNode(this.myHistoryNode,"history");
         this.myHistoryNode.attributes.maxstanzas = value.toString();
      }
      
      public function get seconds() : Number
      {
         return Number(this.myHistoryNode.attributes.seconds);
      }
      
      public function set seconds(value:Number) : void
      {
         this.myHistoryNode = ensureNode(this.myHistoryNode,"history");
         this.myHistoryNode.attributes.seconds = value.toString();
      }
      
      public function get since() : String
      {
         return this.myHistoryNode.attributes.since;
      }
      
      public function set since(value:String) : void
      {
         this.myHistoryNode = ensureNode(this.myHistoryNode,"history");
         this.myHistoryNode.attributes.since = value;
      }
   }
}
