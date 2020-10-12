package iilwygames.pool.input
{
   public class InputData
   {
      
      public static var ID_MOUSE_UP:int = 0;
      
      public static var ID_MOUSE_DOWN:int = 1;
       
      
      public var type:int;
      
      public var mouseX:Number;
      
      public var mouseY:Number;
      
      public var cueX:Number;
      
      public var cueY:Number;
      
      public var turnIndex:int;
      
      public var inputIndex:int;
      
      public var isShiftDown:Boolean;
      
      public function InputData(itype:int)
      {
         super();
         this.mouseX = 0;
         this.mouseY = 0;
         this.cueX = 0;
         this.cueY = 0;
         this.type = itype;
         this.turnIndex = 0;
         this.inputIndex = 0;
      }
   }
}
