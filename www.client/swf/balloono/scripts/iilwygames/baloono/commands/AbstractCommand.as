package iilwygames.baloono.commands
{
   import com.partlyhuman.types.IDestroyable;
   import de.polygonal.ds.Prioritizable;
   
   public class AbstractCommand extends Prioritizable implements IDestroyable
   {
       
      
      public var occurTime:uint;
      
      public function AbstractCommand(param1:uint)
      {
         super();
         this.occurTime = param1;
      }
      
      override public function get priority() : int
      {
         return uint.MAX_VALUE - this.occurTime;
      }
      
      public function destroy() : void
      {
      }
   }
}
