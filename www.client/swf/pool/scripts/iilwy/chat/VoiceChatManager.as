package iilwy.chat
{
   import flash.events.ActivityEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.NetStatusEvent;
   import flash.events.SecurityErrorEvent;
   import flash.events.StatusEvent;
   import flash.events.TimerEvent;
   import flash.media.Microphone;
   import flash.net.NetConnection;
   import flash.net.NetStream;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import iilwy.application.AppComponents;
   import iilwy.events.ChatEvent;
   import iilwy.events.UserDataEvent;
   import iilwy.model.ExternalSounds;
   import iilwy.model.dataobjects.chat.extensions.jingle.JingleExtension;
   import iilwy.model.dataobjects.user.PremiumLevels;
   import iilwy.net.NetStatusCode;
   import iilwy.net.NetStreamPublishType;
   import org.igniterealtime.xiff.core.UnescapedJID;
   
   [Event(name="streamRemoved",type="VoiceChatManager")]
   [Event(name="streamAdded",type="VoiceChatManager")]
   public class VoiceChatManager extends EventDispatcher
   {
      
      public static const REQUIRED_PREMIUM_LEVEL:int = PremiumLevels.STAR;
      
      public static const STREAM_ADDED:String = "streamAdded";
      
      public static const STREAM_REMOVED:String = "streamRemoved";
       
      
      private const SERVER_URL:String = "rtmp://ec2-174-129-127-169.compute-1.amazonaws.com/live";
      
      private const MIC_DEFAULT_GAIN:uint = 60;
      
      private const MIC_SAMPLE_TIME:uint = 50;
      
      private var microphone:Microphone;
      
      private var publishedStream:NetStream;
      
      private var publishedStreamName:String;
      
      private var publishedStreamClient:VoiceChatStreamClient;
      
      private var subscriptionStreams:Dictionary;
      
      private var streamClients:Dictionary;
      
      private var micSampleTimer:Timer;
      
      private var _connection:NetConnection;
      
      private var _voiceChatEnabled:Boolean;
      
      private var _channel:UnescapedJID;
      
      public function VoiceChatManager()
      {
         super();
         this.subscriptionStreams = new Dictionary();
         this.streamClients = new Dictionary();
         this.setupConnection();
         this.setupMicrophone();
         this.registerExtensions();
         AppComponents.model.addEventListener(UserDataEvent.PRIVATE_LOGIN_STATE_CHANGED,this.onLoginChanged);
      }
      
      public function get connection() : NetConnection
      {
         return this._connection;
      }
      
      public function get voiceChatEnabled() : Boolean
      {
         return this._voiceChatEnabled;
      }
      
      public function get channel() : UnescapedJID
      {
         return this._channel;
      }
      
      public function connect() : void
      {
         this._connection.connect(this.SERVER_URL);
      }
      
      public function disconnect() : void
      {
         this.closeStream();
         this._connection.close();
      }
      
      public function publishStream(streamName:String, channel:UnescapedJID, gender:int = 0) : void
      {
         this.publishedStreamName = streamName;
         this._channel = channel;
         this.createPublishStream();
         this.createMicSampleTimer();
         this._voiceChatEnabled = true;
         var chatEvent:ChatEvent = new ChatEvent(ChatEvent.VOICE_CHAT_ENABLED);
         chatEvent.voiceChatChannel = this._channel;
         dispatchEvent(chatEvent);
         var sound:String = gender == 1?ExternalSounds.GUY_COME_ON:ExternalSounds.GIRL_COME_ON;
         AppComponents.soundManager.playSound(sound);
      }
      
      public function closeStream() : void
      {
         if(this.publishedStreamName)
         {
            AppComponents.soundManager.playSound(ExternalSounds.LEAVE);
         }
         var chatEvent:ChatEvent = new ChatEvent(ChatEvent.VOICE_CHAT_DISABLED);
         chatEvent.voiceChatChannel = this._channel;
         dispatchEvent(chatEvent);
         this._voiceChatEnabled = false;
         this.destroyMicSampleTimer();
         this.destroyPublishStream();
         this._channel = null;
         this.publishedStreamName = null;
      }
      
      public function addSubscriptionStream(streamName:String, gender:int = 0) : void
      {
         var client:VoiceChatStreamClient = null;
         var subscriptionStream:NetStream = null;
         var sound:String = null;
         if(streamName != this.publishedStreamName && !this.subscriptionStreams[streamName])
         {
            client = new VoiceChatStreamClient();
            subscriptionStream = new NetStream(this._connection);
            subscriptionStream.client = client;
            subscriptionStream.addEventListener(NetStatusEvent.NET_STATUS,this.onNetStatus,false,0,true);
            subscriptionStream.play(streamName);
            trace("Playing " + streamName);
            this.subscriptionStreams[streamName] = subscriptionStream;
            this.streamClients[streamName] = client;
            dispatchEvent(new Event(VoiceChatManager.STREAM_ADDED));
            sound = gender == 1?ExternalSounds.GUY_COME_ON:ExternalSounds.GIRL_COME_ON;
            AppComponents.soundManager.playSound(sound);
         }
      }
      
      public function removeSubscriptionStream(streamName:String) : void
      {
         var subscriptionStream:NetStream = this.subscriptionStreams[streamName];
         if(subscriptionStream)
         {
            subscriptionStream.close();
            trace("Closing " + streamName);
            delete this.subscriptionStreams[streamName];
            delete this.streamClients[streamName];
            dispatchEvent(new Event(VoiceChatManager.STREAM_REMOVED));
            AppComponents.soundManager.playSound(ExternalSounds.LEAVE);
         }
      }
      
      public function muteStream(streamName:String) : void
      {
         var subscriptionStream:NetStream = null;
         if(streamName == this.publishedStreamName)
         {
            this.microphone.gain = 0;
         }
         else
         {
            subscriptionStream = this.subscriptionStreams[streamName];
            if(subscriptionStream)
            {
               subscriptionStream.receiveAudio(false);
            }
         }
      }
      
      public function unmuteStream(streamName:String) : void
      {
         var subscriptionStream:NetStream = null;
         if(streamName == this.publishedStreamName)
         {
            this.microphone.gain = this.MIC_DEFAULT_GAIN;
         }
         else
         {
            subscriptionStream = this.subscriptionStreams[streamName];
            if(subscriptionStream)
            {
               subscriptionStream.receiveAudio(true);
            }
         }
      }
      
      public function getStreamClient(streamName:String) : VoiceChatStreamClient
      {
         return this.streamClients[streamName];
      }
      
      public function closeAllSubscriptionStreams() : void
      {
         var streamName:* = null;
         for(streamName in this.subscriptionStreams)
         {
            this.removeSubscriptionStream(streamName);
         }
      }
      
      private function setupConnection() : void
      {
         this._connection = new NetConnection();
         this._connection.addEventListener(NetStatusEvent.NET_STATUS,this.onNetStatus,false,0,true);
         this._connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError,false,0,true);
      }
      
      private function setupMicrophone() : void
      {
         this.microphone = Microphone.getMicrophone();
         if(this.microphone)
         {
            this.microphone.setLoopBack(false);
            this.microphone.setUseEchoSuppression(true);
            this.microphone.setSilenceLevel(1);
            this.microphone.rate = 11;
            this.microphone.gain = this.MIC_DEFAULT_GAIN;
            this.microphone.addEventListener(ActivityEvent.ACTIVITY,this.onMicrophoneActivity);
            this.microphone.addEventListener(StatusEvent.STATUS,this.onMicrophoneStatus);
         }
      }
      
      private function registerExtensions() : void
      {
         JingleExtension.enable();
      }
      
      private function createPublishStream() : void
      {
         this.publishedStream = new NetStream(this._connection);
         this.publishedStream.addEventListener(NetStatusEvent.NET_STATUS,this.onNetStatus,false,0,true);
         this.publishedStream.attachAudio(this.microphone);
         this.publishedStream.publish(this.publishedStreamName,NetStreamPublishType.LIVE);
         this.publishedStreamClient = new VoiceChatStreamClient();
         this.streamClients[this.publishedStreamName] = this.publishedStreamClient;
         dispatchEvent(new Event(VoiceChatManager.STREAM_ADDED));
      }
      
      private function destroyPublishStream() : void
      {
         this.closeAllSubscriptionStreams();
         if(this.publishedStream)
         {
            this.publishedStream.close();
         }
         this.publishedStreamClient = null;
         delete this.streamClients[this.publishedStreamName];
         dispatchEvent(new Event(VoiceChatManager.STREAM_REMOVED));
      }
      
      private function createMicSampleTimer() : void
      {
         this.micSampleTimer = new Timer(this.MIC_SAMPLE_TIME);
         this.micSampleTimer.addEventListener(TimerEvent.TIMER,this.onMicSample);
      }
      
      private function destroyMicSampleTimer() : void
      {
         if(this.micSampleTimer)
         {
            this.micSampleTimer.stop();
            this.micSampleTimer.removeEventListener(TimerEvent.TIMER,this.onMicSample);
            this.micSampleTimer = null;
         }
      }
      
      private function onLoginChanged(event:UserDataEvent) : void
      {
         if(!AppComponents.model.privateUser.isLoggedIn)
         {
            this.disconnect();
         }
      }
      
      private function onNetStatus(event:NetStatusEvent) : void
      {
         switch(event.info.code)
         {
            case NetStatusCode.NETCONNECTION_CONNECT_SUCCESS:
               break;
            case NetStatusCode.NETSTREAM_PUBLISH_BADNAME:
               break;
            case NetStatusCode.NETSTREAM_PLAY_STREAMNOTFOUND:
         }
         dispatchEvent(event);
      }
      
      private function onSecurityError(event:SecurityErrorEvent) : void
      {
      }
      
      private function onMicrophoneActivity(event:ActivityEvent) : void
      {
         if(this.micSampleTimer)
         {
            if(this.microphone.activityLevel <= this.microphone.silenceLevel)
            {
               this.micSampleTimer.stop();
            }
            else if(!this.micSampleTimer.running)
            {
               this.micSampleTimer.start();
            }
         }
         this.publishedStream.send("onRemoteVolumeChange",this.microphone.activityLevel);
         this.publishedStreamClient.volume = this.microphone.activityLevel;
      }
      
      private function onMicSample(event:TimerEvent) : void
      {
         if(this.microphone.activityLevel != this.publishedStreamClient.volume)
         {
            this.publishedStream.send("onRemoteVolumeChange",this.microphone.activityLevel);
            this.publishedStreamClient.volume = this.microphone.activityLevel;
         }
      }
      
      private function onMicrophoneStatus(event:StatusEvent) : void
      {
      }
   }
}
