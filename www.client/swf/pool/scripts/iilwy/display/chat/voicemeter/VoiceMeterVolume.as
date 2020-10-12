package iilwy.display.chat.voicemeter
{
   import flash.display.Sprite;
   
   public class VoiceMeterVolume extends Sprite
   {
      
      private static const NUM_LEDS:uint = 5;
      
      private static const MARGIN:uint = 1;
       
      
      private var leds:Vector.<VolumeLED>;
      
      public function VoiceMeterVolume()
      {
         var led:VolumeLED = null;
         super();
         this.leds = new Vector.<VolumeLED>(NUM_LEDS,true);
         for(var i:int = 0; i < NUM_LEDS; i++)
         {
            led = new VolumeLED();
            led.on = false;
            led.x = i * (led.width + MARGIN);
            addChild(led);
            this.leds[i] = led;
         }
      }
      
      public function set volume(value:Number) : void
      {
         var numOn:uint = uint(value * NUM_LEDS);
         numOn = Math.min(numOn,NUM_LEDS);
         for(var i:int = 0; i < NUM_LEDS; i++)
         {
            this.leds[i].on = i < numOn;
         }
      }
   }
}
