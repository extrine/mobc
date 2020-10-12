package iilwy.model.dataobjects.shop
{
   public class CompoundPrice
   {
       
      
      protected var _soft:int;
      
      protected var _hard:int;
      
      public function CompoundPrice(soft:int = 0, hard:int = 0)
      {
         super();
         this.soft = soft;
         this.hard = hard;
      }
      
      public function set soft(value:int) : void
      {
         this._soft = value;
      }
      
      public function get soft() : int
      {
         return this._soft;
      }
      
      public function set hard(value:int) : void
      {
         this._hard = value;
      }
      
      public function get hard() : int
      {
         return this._hard;
      }
   }
}
