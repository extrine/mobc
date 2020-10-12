package iilwy.model.dataobjects.shop.enum
{
   import flash.utils.Dictionary;
   
   public class PartnerCurrency
   {
      
      public static const IMVU:PartnerCurrency = new PartnerCurrency("imvu","IMVU","credit",7,0.01);
      
      protected static var idDict:Dictionary;
      
      protected static var nameDict:Dictionary;
       
      
      protected var _id:String;
      
      protected var _name:String;
      
      protected var _currencyName:String;
      
      protected var _softExchangeRate:Number;
      
      protected var _hardExchangeRate:Number;
      
      public function PartnerCurrency(id:String, name:String, currencyName:String, softExchangeRate:Number, hardExchangeRate:Number)
      {
         super();
         if(!idDict)
         {
            idDict = new Dictionary();
         }
         if(!nameDict)
         {
            nameDict = new Dictionary();
         }
         this.id = id;
         this.name = name;
         this.currencyName = currencyName;
         this.softExchangeRate = softExchangeRate;
         this.hardExchangeRate = hardExchangeRate;
      }
      
      public static function getByID(id:String) : PartnerCurrency
      {
         return idDict[id];
      }
      
      public static function getByName(name:String) : PartnerCurrency
      {
         return nameDict[name];
      }
      
      public function get id() : String
      {
         return this._id;
      }
      
      public function set id(value:String) : void
      {
         this._id = value;
         idDict[value] = this;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function set name(value:String) : void
      {
         this._name = value;
         nameDict[value] = this;
      }
      
      public function get currencyName() : String
      {
         return this._currencyName;
      }
      
      public function set currencyName(value:String) : void
      {
         this._currencyName = value;
      }
      
      public function get softExchangeRate() : Number
      {
         return this._softExchangeRate;
      }
      
      public function set softExchangeRate(value:Number) : void
      {
         this._softExchangeRate = value;
      }
      
      public function get hardExchangeRate() : Number
      {
         return this._hardExchangeRate;
      }
      
      public function set hardExchangeRate(value:Number) : void
      {
         this._hardExchangeRate = value;
      }
   }
}
