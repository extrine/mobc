package iilwy.model.dataobjects.promo.enum
{
   public class ImageDefinition
   {
       
      
      public var url:String;
      
      public var x:int;
      
      public var y:int;
      
      public function ImageDefinition(url:String, x:int = 0, y:int = 0)
      {
         super();
         this.url = url;
         this.x = x;
         this.y = y;
      }
      
      public function toString() : String
      {
         return this.url;
      }
   }
}
