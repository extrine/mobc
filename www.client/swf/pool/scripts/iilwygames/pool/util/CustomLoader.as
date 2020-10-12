package iilwygames.pool.util
{
   import flash.display.Loader;
   
   public class CustomLoader extends Loader
   {
       
      
      public var ownerJID:String;
      
      public var loadComplete:Boolean;
      
      public function CustomLoader(owner:String)
      {
         this.ownerJID = owner;
         this.loadComplete = false;
         super();
      }
   }
}
