package iilwy.model
{
   public class ExternalSounds
   {
      
      public static const B24:String = "b_24";
      
      public static const BUBBLE_UP:String = "bubbleup";
      
      public static const BUBBLES:String = "bubbles";
      
      public static const BUZZES:String = "buzzes";
      
      public static const CHANGE:String = "change";
      
      public static const CLINK:String = "clink";
      
      public static const DROP:String = "drop";
      
      public static const ERROR:String = "error";
      
      public static const GAME_ON:String = "gameon";
      
      public static const KNOCK_KNOCK:String = "knockknock";
      
      public static const LOWDING:String = "lowding";
      
      public static const LOWUP:String = "lowup";
      
      public static const MESSAGE:String = "message";
      
      public static const MINIMENU:String = "minimenu";
      
      public static const OMG:String = "omg";
      
      public static const PHONE:String = "phone";
      
      public static const PLINK:String = "plink";
      
      public static const POINT_DOWN:String = "pointdown";
      
      public static const POINT_UP:String = "pointup";
      
      public static const POPUP:String = "popup";
      
      public static const TONE_TONE_TONE:String = "tonetonetone";
      
      public static const TONE_UP:String = "toneup";
      
      public static const GIRL_COME_ON:String = "girlcomeon";
      
      public static const GUY_COME_ON:String = "guycomeon";
      
      public static const LEAVE:String = "leave";
       
      
      public function ExternalSounds()
      {
         super();
      }
      
      public static function getSoundForEvent(eventId:String) : String
      {
         var lookup:* = {
            "friend_logs_in":KNOCK_KNOCK,
            "new_chat_message":MESSAGE,
            "successful_photo_uploaded":TONE_UP
         };
         var result:String = lookup[eventId];
         if(!result)
         {
            result = BUBBLE_UP;
         }
         return result;
      }
   }
}
