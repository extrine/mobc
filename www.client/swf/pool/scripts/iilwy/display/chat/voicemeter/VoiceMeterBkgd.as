package iilwy.display.chat.voicemeter
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.PixelSnapping;
   import flash.display.Sprite;
   import flash.geom.ColorTransform;
   import iilwy.managers.GraphicManager;
   
   public class VoiceMeterBkgd extends Sprite
   {
      
      public static const ON:uint = 0;
      
      public static const MUTED:uint = 1;
      
      public static const NULL:uint = 2;
      
      private static var VOICE_BKGD_BITMAP:BitmapData;
      
      private static var VOICE_SPEAKER_BITMAP:BitmapData;
       
      
      private var bkgd:Bitmap;
      
      private var speaker:Bitmap;
      
      public function VoiceMeterBkgd()
      {
         super();
         if(!VOICE_BKGD_BITMAP)
         {
            VOICE_BKGD_BITMAP = new GraphicManager.voicechat_bkgd().bitmapData;
            VOICE_SPEAKER_BITMAP = new GraphicManager.voicechat_volume_speaker().bitmapData;
         }
         this.bkgd = Bitmap(addChild(new Bitmap(VOICE_BKGD_BITMAP,PixelSnapping.ALWAYS)));
         this.speaker = Bitmap(addChild(new Bitmap(VOICE_SPEAKER_BITMAP,PixelSnapping.ALWAYS)));
         this.speaker.x = 5;
         this.speaker.y = 3;
      }
      
      public function set state(value:uint) : void
      {
         var ct:ColorTransform = new ColorTransform();
         switch(value)
         {
            case MUTED:
               ct.color = 11141120;
               break;
            case NULL:
               ct.color = 10066329;
         }
         this.bkgd.transform.colorTransform = ct;
      }
   }
}
