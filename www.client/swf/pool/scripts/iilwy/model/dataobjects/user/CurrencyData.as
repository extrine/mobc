package iilwy.model.dataobjects.user
{
   import iilwy.model.dataobjects.shop.enum.CurrencyType;
   
   public class CurrencyData
   {
       
      
      public var currencyType:CurrencyType;
      
      public function CurrencyData(currencyType:CurrencyType)
      {
         super();
         this.currencyType = currencyType;
      }
   }
}
