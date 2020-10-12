package de.polygonal.math
{
   public class PM_PRNG
   {
       
      
      public var seed:uint;
      
      public function PM_PRNG()
      {
         super();
         this.seed = 1;
      }
      
      private function gen() : uint
      {
         return this.seed = this.seed * 16807 % 2147483647;
      }
      
      public function nextIntRange(param1:Number, param2:Number) : uint
      {
         param1 = param1 - 0.4999;
         param2 = param2 + 0.4999;
         return Math.round(param1 + (param2 - param1) * this.nextDouble());
      }
      
      public function nextDouble() : Number
      {
         return this.gen() / 2147483647;
      }
      
      public function nextDoubleRange(param1:Number, param2:Number) : Number
      {
         return param1 + (param2 - param1) * this.nextDouble();
      }
      
      public function nextInt() : uint
      {
         return this.gen();
      }
   }
}
