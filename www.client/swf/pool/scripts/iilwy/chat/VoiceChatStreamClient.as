package iilwy.chat
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   [Event(name="volumeChanged",type="VoiceChatStreamClient")]
   public class VoiceChatStreamClient extends EventDispatcher
   {
      
      public static const VOLUME_CHANGED:String = "volumeChanged";
       
      
      private var _volume:Number;
      
      public function VoiceChatStreamClient()
      {
         super();
         this._volume = 0;
      }
      
      public function get volume() : Number
      {
         return this._volume;
      }
      
      public function set volume(value:Number) : void
      {
         if(this._volume != value)
         {
            this._volume = value;
            dispatchEvent(new Event(VoiceChatStreamClient.VOLUME_CHANGED));
         }
      }
      
      public function onRemoteVolumeChange(value:Number) : void
      {
         this.volume = value;
      }
   }
}
