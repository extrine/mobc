package iilwy.display.popups.shop
{
   public class AbstractCurrencyPack
   {
       
      
      protected var _productID:int;
      
      protected var _price:Number;
      
      protected var _numMonthsStar:int;
      
      protected var _promoText:String;
      
      protected var _numCurrency:int;
      
      protected var _numBonusCurrency:int;
      
      public function AbstractCurrencyPack(productID:int, numCurrency:Number, numBonusCurrency:Number, price:Number, numMonthsStar:int = 0, promoText:String = null)
      {
         super();
         this.productID = productID;
         this.numCurrency = numCurrency;
         this.numBonusCurrency = numBonusCurrency;
         this.price = price;
         this.numMonthsStar = numMonthsStar;
         this.promoText = promoText;
      }
      
      public function get productID() : int
      {
         return this._productID;
      }
      
      public function set productID(value:int) : void
      {
         this._productID = value;
      }
      
      public function get numCurrency() : int
      {
         return this._numCurrency;
      }
      
      public function set numCurrency(value:int) : void
      {
         this._numCurrency = value;
      }
      
      public function get numBonusCurrency() : int
      {
         return this._numBonusCurrency;
      }
      
      public function set numBonusCurrency(value:int) : void
      {
         this._numBonusCurrency = value;
      }
      
      public function get price() : Number
      {
         return this._price;
      }
      
      public function set price(value:Number) : void
      {
         this._price = value;
      }
      
      public function get numMonthsStar() : int
      {
         return this._numMonthsStar;
      }
      
      public function set numMonthsStar(value:int) : void
      {
         this._numMonthsStar = value;
      }
      
      public function get promoText() : String
      {
         return this._promoText;
      }
      
      public function set promoText(value:String) : void
      {
         this._promoText = value;
      }
   }
}
