package iilwy.managers
{
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.media.Sound;
   import flash.media.SoundMixer;
   import flash.media.SoundTransform;
   import flash.net.URLRequest;
   import iilwy.application.AppComponents;
   import iilwy.application.AppProperties;
   import iilwy.display.core.WindowManager;
   import iilwy.events.ModelEvent;
   import iilwy.utils.logging.Logger;
   
   public final class SoundManager
   {
       
      
      private var _entries:Object;
      
      private var _idLookup:Object;
      
      private var _logger:Logger;
      
      public function SoundManager()
      {
         this._entries = {};
         this._idLookup = {};
         super();
         this._idLookup = {
            "phone":"phone2",
            "bubbles":"bubles"
         };
         this._logger = Logger.getLogger("SoundManager");
      }
      
      public function playSound(id:String, volume:Number = 1) : void
      {
         var transform:SoundTransform = null;
         if(!id)
         {
            return;
         }
         if(AppComponents.model.globalVolume <= 0)
         {
            return;
         }
         if(WindowManager.getInstance().isMinimized)
         {
            return;
         }
         var entry:Object = this.findEntry(id);
         if(entry == null)
         {
            entry = this.createEntry(id);
         }
         if(entry.loadingState == 0)
         {
            this.loadEntry(entry,true);
         }
         else if(entry.loadingState == 2)
         {
            transform = new SoundTransform();
            transform.volume = AppComponents.model.globalVolume * volume;
            Sound(entry.sound).play(0,0,transform);
         }
      }
      
      public function preloadSound(id:String) : void
      {
         if(AppComponents.model.globalVolume <= 0)
         {
            return;
         }
         var entry:Object = this.findEntry(id);
         if(entry == null)
         {
            entry = this.createEntry(id);
            this.loadEntry(entry,false);
         }
      }
      
      public function createEntry(id:String) : Object
      {
         var entry:Object = new Object();
         entry.id = id;
         var urlBase:String = this._idLookup[id] != null?this._idLookup[id]:id;
         entry.url = AppProperties.fileServerStatic + urlBase + ".mp3";
         entry.sound = new Sound();
         entry.loadingState = 0;
         entry.playWhenLoaded = false;
         this._entries[id] = entry;
         return entry;
      }
      
      public function findEntry(id:String) : Object
      {
         return this._entries[id];
      }
      
      public function findEntryByUrl(url:String) : Object
      {
         var match:Object = null;
         var entry:Object = null;
         for each(entry in this._entries)
         {
            if(entry.url == url)
            {
               match = entry;
               break;
            }
         }
         return match;
      }
      
      public function loadEntry(entry:Object, autoplay:Boolean = false) : void
      {
         Sound(entry.sound).load(new URLRequest(entry.url));
         entry.loadingState = 1;
         entry.playWhenLoaded = autoplay;
         Sound(entry.sound).addEventListener(Event.COMPLETE,this.onSoundLoaded);
         Sound(entry.sound).addEventListener(IOErrorEvent.IO_ERROR,this.onSoundError);
      }
      
      private function onSoundLoaded(event:Event) : void
      {
         var transform:SoundTransform = null;
         var entry:Object = this.findEntryByUrl(Sound(event.target).url);
         entry.loadingState = 2;
         if(entry.playWhenLoaded)
         {
            transform = new SoundTransform();
            transform.volume = AppComponents.model.globalVolume;
            Sound(entry.sound).play(0,0,transform);
         }
      }
      
      private function onSoundError(event:IOErrorEvent) : void
      {
         var entry:Object = this.findEntryByUrl(Sound(event.target).url);
         if(entry)
         {
            entry.loadingState = 0;
         }
         this._logger.error("error loading sound",event.target.url);
      }
      
      public function applyGlobalSoundToMixer() : void
      {
         AppComponents.model.addEventListener(ModelEvent.GLOBAL_VOLUME_CHANGED,this.onGlobalVolumeChanged);
         this.onGlobalVolumeChanged();
      }
      
      public function releaseGlobalSoundFromMixer() : void
      {
         AppComponents.model.removeEventListener(ModelEvent.GLOBAL_VOLUME_CHANGED,this.onGlobalVolumeChanged);
         SoundMixer.soundTransform = new SoundTransform();
      }
      
      protected function onGlobalVolumeChanged(event:Event = null) : void
      {
         var transform:SoundTransform = new SoundTransform();
         transform.volume = AppComponents.model.globalVolume;
         SoundMixer.soundTransform = transform;
      }
   }
}
