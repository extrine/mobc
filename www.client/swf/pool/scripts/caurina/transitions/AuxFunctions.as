package caurina.transitions
{
   public class AuxFunctions
   {
       
      
      public function AuxFunctions()
      {
         super();
      }
      
      public static function numberToR(p_num:Number) : Number
      {
         return (p_num & 16711680) >> 16;
      }
      
      public static function numberToG(p_num:Number) : Number
      {
         return (p_num & 65280) >> 8;
      }
      
      public static function numberToB(p_num:Number) : Number
      {
         return p_num & 255;
      }
      
      public static function getObjectLength(p_object:Object) : uint
      {
         var pName:* = null;
         var totalProperties:uint = 0;
         for(pName in p_object)
         {
            totalProperties++;
         }
         return totalProperties;
      }
      
      public static function concatObjects(... args) : Object
      {
         var currentObject:Object = null;
         var prop:* = null;
         var finalObject:Object = {};
         for(var i:int = 0; i < args.length; i++)
         {
            currentObject = args[i];
            for(prop in currentObject)
            {
               if(currentObject[prop] == null)
               {
                  delete finalObject[prop];
               }
               else
               {
                  finalObject[prop] = currentObject[prop];
               }
            }
         }
         return finalObject;
      }
   }
}
