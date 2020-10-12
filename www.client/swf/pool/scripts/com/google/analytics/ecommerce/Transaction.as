package com.google.analytics.ecommerce
{
   import com.google.analytics.utils.Variables;
   
   public class Transaction
   {
       
      
      private var _items:Array;
      
      private var _id:String;
      
      private var _affiliation:String;
      
      private var _total:String;
      
      private var _tax:String;
      
      private var _shipping:String;
      
      private var _city:String;
      
      private var _state:String;
      
      private var _country:String;
      
      private var _vars:Variables;
      
      public function Transaction(id:String, affiliation:String, total:String, tax:String, shipping:String, city:String, state:String, country:String)
      {
         super();
         this._id = id;
         this._affiliation = affiliation;
         this._total = total;
         this._tax = tax;
         this._shipping = shipping;
         this._city = city;
         this._state = state;
         this._country = country;
         this._items = new Array();
      }
      
      public function toGifParams() : Variables
      {
         var vars:Variables = new Variables();
         vars.URIencode = true;
         vars.utmt = "tran";
         vars.utmtid = this.id;
         vars.utmtst = this.affiliation;
         vars.utmtto = this.total;
         vars.utmttx = this.tax;
         vars.utmtsp = this.shipping;
         vars.utmtci = this.city;
         vars.utmtrg = this.state;
         vars.utmtco = this.country;
         vars.post = ["utmtid","utmtst","utmtto","utmttx","utmtsp","utmtci","utmtrg","utmtco"];
         return vars;
      }
      
      public function addItem(sku:String, name:String, category:String, price:String, quantity:String) : void
      {
         var newItem:Item = null;
         newItem = this.getItem(sku);
         if(newItem == null)
         {
            newItem = new Item(this._id,sku,name,category,price,quantity);
            this._items.push(newItem);
         }
         else
         {
            newItem.name = name;
            newItem.category = category;
            newItem.price = price;
            newItem.quantity = quantity;
         }
      }
      
      public function getItem(sku:String) : Item
      {
         var i:Number = NaN;
         for(i = 0; i < this._items.length; i++)
         {
            if(this._items[i].sku == sku)
            {
               return this._items[i];
            }
         }
         return null;
      }
      
      public function getItemsLength() : Number
      {
         return this._items.length;
      }
      
      public function getItemFromArray(i:Number) : Item
      {
         return this._items[i];
      }
      
      public function get id() : String
      {
         return this._id;
      }
      
      public function get affiliation() : String
      {
         return this._affiliation;
      }
      
      public function get total() : String
      {
         return this._total;
      }
      
      public function get tax() : String
      {
         return this._tax;
      }
      
      public function get shipping() : String
      {
         return this._shipping;
      }
      
      public function get city() : String
      {
         return this._city;
      }
      
      public function get state() : String
      {
         return this._state;
      }
      
      public function get country() : String
      {
         return this._country;
      }
      
      public function set id(value:String) : void
      {
         this._id = value;
      }
      
      public function set affiliation(value:String) : void
      {
         this._affiliation = value;
      }
      
      public function set total(value:String) : void
      {
         this._total = value;
      }
      
      public function set tax(value:String) : void
      {
         this._tax = value;
      }
      
      public function set shipping(value:String) : void
      {
         this._shipping = value;
      }
      
      public function set city(value:String) : void
      {
         this._city = value;
      }
      
      public function set state(value:String) : void
      {
         this._state = value;
      }
      
      public function set country(value:String) : void
      {
         this._country = value;
      }
   }
}
