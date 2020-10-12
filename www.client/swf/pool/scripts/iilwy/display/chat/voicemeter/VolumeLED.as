package iilwy.display.chat.voicemeter
{
   import flash.display.Shape;
   
   public class VolumeLED extends Shape
   {
       
      
      public function VolumeLED()
      {
         super();
         graphics.beginFill(16777215);
         graphics.drawRect(0,0,2,4);
      }
      
      public function set on(value:Boolean) : void
      {
         alpha = !!value?Number(1):Number(0.5);
      }
   }
}
