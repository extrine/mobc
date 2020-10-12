package org.igniterealtime.xiff.data.disco
{
   import flash.xml.XMLNode;
   import org.igniterealtime.xiff.data.ExtensionClassRegistry;
   import org.igniterealtime.xiff.data.IExtension;
   
   public class ItemDiscoExtension extends DiscoExtension implements IExtension
   {
      
      public static const NS:String = "http://jabber.org/protocol/disco#items";
       
      
      private var _items:Array;
      
      public function ItemDiscoExtension(xmlNode:XMLNode = null)
      {
         super(xmlNode);
      }
      
      public static function enable() : void
      {
         ExtensionClassRegistry.register(ItemDiscoExtension);
      }
      
      public function getElementName() : String
      {
         return DiscoExtension.ELEMENT_NAME;
      }
      
      public function getNS() : String
      {
         return ItemDiscoExtension.NS;
      }
      
      public function get items() : Array
      {
         return this._items;
      }
      
      override public function deserialize(node:XMLNode) : Boolean
      {
         var item:XMLNode = null;
         if(!super.deserialize(node))
         {
            return false;
         }
         this._items = [];
         for each(item in getNode().childNodes)
         {
            this._items.push(item.attributes);
         }
         return true;
      }
   }
}
