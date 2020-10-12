package caurina.transitions
{
   public class SpecialPropertyModifier
   {
       
      
      public var modifyValues:Function;
      
      public var getValue:Function;
      
      public function SpecialPropertyModifier(p_modifyFunction:Function, p_getFunction:Function)
      {
         super();
         this.modifyValues = p_modifyFunction;
         this.getValue = p_getFunction;
      }
      
      public function toString() : String
      {
         var value:String = "";
         value = value + "[SpecialPropertyModifier ";
         value = value + ("modifyValues:" + String(this.modifyValues));
         value = value + ", ";
         value = value + ("getValue:" + String(this.getValue));
         value = value + "]";
         return value;
      }
   }
}
