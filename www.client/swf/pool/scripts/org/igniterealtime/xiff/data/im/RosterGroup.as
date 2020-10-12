package org.igniterealtime.xiff.data.im
{
   import org.igniterealtime.xiff.collections.ArrayCollection;
   
   public class RosterGroup
   {
       
      
      public var label:String;
      
      public var shared:Boolean = false;
      
      private var _items:ArrayCollection;
      
      public function RosterGroup(label:String)
      {
         super();
         this.label = label;
         this._items = new ArrayCollection();
      }
      
      public function addItem(item:RosterItemVO) : void
      {
         if(!this._items.contains(item))
         {
            this._items.addItem(item);
         }
      }
      
      public function removeItem(item:RosterItemVO) : Boolean
      {
         return this._items.removeItem(item);
      }
      
      public function contains(item:RosterItemVO) : Boolean
      {
         return this._items.contains(item);
      }
      
      public function get items() : ArrayCollection
      {
         return this._items;
      }
   }
}
