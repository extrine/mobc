package org.igniterealtime.xiff.data.browse
{
   import flash.xml.XMLNode;
   import org.igniterealtime.xiff.data.ExtensionClassRegistry;
   import org.igniterealtime.xiff.data.IExtension;
   import org.igniterealtime.xiff.data.ISerializable;
   
   public class BrowseExtension extends BrowseItem implements IExtension, ISerializable
   {
      
      public static const NS:String = "jabber:iq:browse";
      
      public static const ELEMENT_NAME:String = "query";
      
      private static var staticDepends:Class = ExtensionClassRegistry;
       
      
      private var _items:Array;
      
      public function BrowseExtension(parent:XMLNode = null)
      {
         this._items = [];
         super(parent);
         getNode().attributes.xmlns = this.getNS();
         getNode().nodeName = this.getElementName();
      }
      
      public static function enable() : void
      {
         ExtensionClassRegistry.register(BrowseExtension);
      }
      
      public function getNS() : String
      {
         return BrowseExtension.NS;
      }
      
      public function getElementName() : String
      {
         return BrowseExtension.ELEMENT_NAME;
      }
      
      public function addItem(item:BrowseItem) : BrowseItem
      {
         this._items.push(item);
         return item;
      }
      
      override public function serialize(parentNode:XMLNode) : Boolean
      {
         var item:BrowseItem = null;
         var node:XMLNode = getNode();
         for each(item in this._items)
         {
            item.serialize(node);
         }
         if(!exists(node.parentNode))
         {
            parentNode.appendChild(node.cloneNode(true));
         }
         return true;
      }
      
      override public function deserialize(node:XMLNode) : Boolean
      {
         var child:XMLNode = null;
         var item:BrowseItem = null;
         setNode(node);
         this["deserialized"] = true;
         this._items = [];
         for each(child in node.childNodes)
         {
            switch(child.nodeName)
            {
               case "item":
                  item = new BrowseItem(getNode());
                  item.deserialize(child);
                  this._items.push(item);
                  continue;
               default:
                  continue;
            }
         }
         return true;
      }
      
      public function get items() : Array
      {
         return this._items;
      }
   }
}
