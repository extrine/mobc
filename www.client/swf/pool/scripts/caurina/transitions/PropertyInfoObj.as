package caurina.transitions
{
   public class PropertyInfoObj
   {
       
      
      public var valueStart:Number;
      
      public var valueComplete:Number;
      
      public var originalValueComplete:Object;
      
      public var arrayIndex:Number;
      
      public var extra:Object;
      
      public var isSpecialProperty:Boolean;
      
      public var hasModifier:Boolean;
      
      public var modifierFunction:Function;
      
      public var modifierParameters:Array;
      
      public function PropertyInfoObj(p_valueStart:Number, p_valueComplete:Number, p_originalValueComplete:Object, p_arrayIndex:Number, p_extra:Object, p_isSpecialProperty:Boolean, p_modifierFunction:Function, p_modifierParameters:Array)
      {
         super();
         this.valueStart = p_valueStart;
         this.valueComplete = p_valueComplete;
         this.originalValueComplete = p_originalValueComplete;
         this.arrayIndex = p_arrayIndex;
         this.extra = p_extra;
         this.isSpecialProperty = p_isSpecialProperty;
         this.hasModifier = Boolean(p_modifierFunction);
         this.modifierFunction = p_modifierFunction;
         this.modifierParameters = p_modifierParameters;
      }
      
      public function clone() : PropertyInfoObj
      {
         var nProperty:PropertyInfoObj = new PropertyInfoObj(this.valueStart,this.valueComplete,this.originalValueComplete,this.arrayIndex,this.extra,this.isSpecialProperty,this.modifierFunction,this.modifierParameters);
         return nProperty;
      }
      
      public function toString() : String
      {
         var returnStr:String = "\n[PropertyInfoObj ";
         returnStr = returnStr + ("valueStart:" + String(this.valueStart));
         returnStr = returnStr + ", ";
         returnStr = returnStr + ("valueComplete:" + String(this.valueComplete));
         returnStr = returnStr + ", ";
         returnStr = returnStr + ("originalValueComplete:" + String(this.originalValueComplete));
         returnStr = returnStr + ", ";
         returnStr = returnStr + ("arrayIndex:" + String(this.arrayIndex));
         returnStr = returnStr + ", ";
         returnStr = returnStr + ("extra:" + String(this.extra));
         returnStr = returnStr + ", ";
         returnStr = returnStr + ("isSpecialProperty:" + String(this.isSpecialProperty));
         returnStr = returnStr + ", ";
         returnStr = returnStr + ("hasModifier:" + String(this.hasModifier));
         returnStr = returnStr + ", ";
         returnStr = returnStr + ("modifierFunction:" + String(this.modifierFunction));
         returnStr = returnStr + ", ";
         returnStr = returnStr + ("modifierParameters:" + String(this.modifierParameters));
         returnStr = returnStr + "]\n";
         return returnStr;
      }
   }
}
