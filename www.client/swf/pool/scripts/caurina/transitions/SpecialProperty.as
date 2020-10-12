package caurina.transitions
{
   public class SpecialProperty
   {
       
      
      public var getValue:Function;
      
      public var setValue:Function;
      
      public var parameters:Array;
      
      public var preProcess:Function;
      
      public function SpecialProperty(p_getFunction:Function, p_setFunction:Function, p_parameters:Array = null, p_preProcessFunction:Function = null)
      {
         super();
         this.getValue = p_getFunction;
         this.setValue = p_setFunction;
         this.parameters = p_parameters;
         this.preProcess = p_preProcessFunction;
      }
      
      public function toString() : String
      {
         var value:String = "";
         value = value + "[SpecialProperty ";
         value = value + ("getValue:" + String(this.getValue));
         value = value + ", ";
         value = value + ("setValue:" + String(this.setValue));
         value = value + ", ";
         value = value + ("parameters:" + String(this.parameters));
         value = value + ", ";
         value = value + ("preProcess:" + String(this.preProcess));
         value = value + "]";
         return value;
      }
   }
}
