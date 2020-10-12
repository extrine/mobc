package iilwy.display.chat.voicemeter
{
   import flash.events.Event;
   import flash.events.MouseEvent;
   import iilwy.application.AppComponents;
   import iilwy.chat.VoiceChatManager;
   import iilwy.chat.VoiceChatStreamClient;
   import iilwy.events.ChatEvent;
   import iilwy.model.dataobjects.chat.ChatUser;
   import iilwy.ui.controls.UiElement;
   import org.igniterealtime.xiff.core.UnescapedJID;
   
   public class VoiceMeter extends UiElement
   {
       
      
      private var bkgd:VoiceMeterBkgd;
      
      private var volume:VoiceMeterVolume;
      
      private var voiceChatManager:VoiceChatManager;
      
      private var voiceChatStreamClient:VoiceChatStreamClient;
      
      private var invalidData:Boolean;
      
      private var _user:ChatUser;
      
      private var _channel:UnescapedJID;
      
      public function VoiceMeter()
      {
         super();
         this.voiceChatManager = AppComponents.voiceChatManager;
         this.voiceChatManager.addEventListener(VoiceChatManager.STREAM_ADDED,this.onConnectDisconnect);
         this.voiceChatManager.addEventListener(VoiceChatManager.STREAM_REMOVED,this.onConnectDisconnect);
         buttonMode = true;
         useHandCursor = true;
         addEventListener(MouseEvent.CLICK,this.onMouseClick);
      }
      
      override public function measure() : void
      {
         if(this.bkgd)
         {
            measuredWidth = this.bkgd.width;
            measuredHeight = this.bkgd.height;
         }
         else
         {
            measuredWidth = measuredHeight = 0;
         }
      }
      
      override public function commitProperties() : void
      {
         if(this.invalidData)
         {
            this.invalidData = false;
            if(this.voiceChatStreamClient != null)
            {
               this.voiceChatStreamClient.removeEventListener(VoiceChatStreamClient.VOLUME_CHANGED,this.onMicVolumeChanged);
               this.voiceChatStreamClient = null;
            }
            if(this._user == null)
            {
               return;
            }
            if(this._user.premiumLevel >= VoiceChatManager.REQUIRED_PREMIUM_LEVEL)
            {
               if(!this._user.isMuted && this.voiceChatManager.voiceChatEnabled && this.channelEqualsVoiceChannel)
               {
                  this.voiceChatStreamClient = this.voiceChatManager.getStreamClient(this._user.jid.node);
               }
               if(this.voiceChatStreamClient != null)
               {
                  this.bkgd.state = VoiceMeterBkgd.ON;
                  this.voiceChatStreamClient.addEventListener(VoiceChatStreamClient.VOLUME_CHANGED,this.onMicVolumeChanged);
               }
               else
               {
                  this.bkgd.state = !!this._user.isMuted?uint(VoiceMeterBkgd.MUTED):uint(VoiceMeterBkgd.NULL);
                  this.volume.volume = 0;
               }
            }
         }
      }
      
      override public function createChildren() : void
      {
         this.bkgd = new VoiceMeterBkgd();
         addChild(this.bkgd);
         this.volume = new VoiceMeterVolume();
         this.volume.x = 3;
         this.volume.y = 15;
         addChild(this.volume);
         this.bkgd.state = VoiceMeterBkgd.NULL;
         this.volume.volume = 0;
      }
      
      public function set user(value:ChatUser) : void
      {
         if(this._user != value)
         {
            this._user = value;
            this.invalidData = true;
            invalidateProperties();
         }
      }
      
      public function set channel(value:UnescapedJID) : void
      {
         if(this._channel != value)
         {
            this._channel = value;
            this.invalidData = true;
            invalidateProperties();
         }
      }
      
      private function get channelEqualsVoiceChannel() : Boolean
      {
         return this._channel && this.voiceChatManager.channel && this.voiceChatManager.channel.equals(this._channel,true);
      }
      
      private function onConnectDisconnect(event:Event) : void
      {
         this._channel = this.voiceChatManager.channel;
         this.invalidData = true;
         invalidateProperties();
      }
      
      private function onMicVolumeChanged(event:Event) : void
      {
         var normalized:Number = NaN;
         if(this.voiceChatStreamClient != null)
         {
            normalized = this.voiceChatStreamClient.volume / 30;
            this.volume.volume = normalized;
         }
      }
      
      private function onMouseClick(event:MouseEvent) : void
      {
         var chatEvent:ChatEvent = null;
         if(this._user)
         {
            if(!this.voiceChatManager.voiceChatEnabled)
            {
               chatEvent = new ChatEvent(ChatEvent.ENABLE_VOICE_CHAT,true,true);
               chatEvent.voiceChatChannel = this._channel;
               dispatchEvent(chatEvent);
            }
            else
            {
               this._user.isMuted = !this._user.isMuted;
               if(this._user.isMuted)
               {
                  this.voiceChatManager.muteStream(this._user.jid.node);
               }
               else
               {
                  this.voiceChatManager.unmuteStream(this._user.jid.node);
               }
            }
            this.invalidData = true;
            invalidateProperties();
         }
      }
   }
}
