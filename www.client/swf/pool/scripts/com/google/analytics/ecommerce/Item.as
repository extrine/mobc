package com.google.analytics.ecommerce
{
   import com.google.analytics.utils.Variables;
   
   public class Item
   {
       
      
      private var _id:String;
      
      private var _sku:String;
      
      private var _name:String;
      
      private var _category:String;
      
      private var _price:String;
      
      private var _quantity:String;
      
      public function Item(id:String, sku:String, name:String, category:String, price:String, quantity:String)
      {
         super();
         this._id = id;
         this._sku = sku;
         this._name = name;
         this._category = category;
         this._price = price;
         this._quantity = quantity;
      }
      
      public function toGifParams() : Variables
      {
         var vars:Variables = new Variables();
         vars.URIencode = true;
         vars.post = ["utmt","utmtid","utmipc","utmipn","utmiva","utmipr","utmiqt"];
         vars.utmt = "item";
         vars.utmtid = this._id;
         vars.utmipc = this._sku;
         vars.utmipn = this._name;
         vars.utmiva = this._category;
         vars.utmipr = this._price;
         vars.utmiqt = this._quantity;
         return vars;
      }
      
      public function get id() : String
      {
         return this._id;
      }
      
      public function get sku() : String
      {
         return this._sku;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function get category() : String
      {
         return this._category;
      }
      
      public function get price() : String
      {
         return this._price;
      }
      
      public function get quantity() : String
      {
         return this._quantity;
      }
      
      public function set id(value:String) : void
      {
         this._id = value;
      }
      
      public function set sku(value:String) : void
      {
         this._sku = value;
      }
      
      public function set name(value:String) : void
      {
         this._name = value;
      }
      
      public function set category(value:String) : void
      {
         this._category = value;
      }
      
      public function set price(value:String) : void
      {
         this._price = value;
      }
      
      public function set quantity(value:String) : void
      {
         this._quantity = value;
      }
   }
}
