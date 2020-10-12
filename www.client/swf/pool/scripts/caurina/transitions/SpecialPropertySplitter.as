package caurina.transitions
{
   public class SpecialPropertySplitter
   {
       
      
      public var parameters:Array;
      
      public var splitValues:Function;
      
      public function SpecialPropertySplitter(p_splitFunction:Function, p_parameters:Array)
      {
         super();
         this.splitValues = p_splitFunction;
         this.parameters = p_parameters;
      }
      
      public function toString() : String
      {
         var value:String = "";
         value = value + "[SpecialPropertySplitter ";
         value = value + ("splitValues:" + String(this.splitValues));
         value = value + ", ";
         value = value + ("parameters:" + String(this.parameters));
         value = value + "]";
         return value;
      }
   }
}
