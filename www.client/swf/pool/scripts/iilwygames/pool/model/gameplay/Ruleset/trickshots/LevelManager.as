package iilwygames.pool.model.gameplay.Ruleset.trickshots
{
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLRequestMethod;
   import iilwy.utils.logging.Logger;
   import iilwygames.pool.core.Globals;
   
   public class LevelManager
   {
      
      private static const SOURCE:String = "http://static.iminlikewithyou.com/gameassets/fbpool/trickshots/levels.txt";
       
      
      public var ready:Boolean;
      
      private var _levels:Vector.<Level>;
      
      public function LevelManager()
      {
         super();
         this._levels = new Vector.<Level>();
         this.ready = false;
      }
      
      public function destroy() : void
      {
         var level:Level = null;
         for each(level in this._levels)
         {
            level.destroy();
         }
         this._levels = null;
      }
      
      public function loadLevels() : void
      {
         var request:URLRequest = null;
         var urlLoader:URLLoader = null;
         if(!this.ready)
         {
            request = new URLRequest(SOURCE);
            request.contentType = "application/octet-stream";
            request.method = URLRequestMethod.GET;
            urlLoader = new URLLoader();
            urlLoader.addEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
            urlLoader.addEventListener(Event.COMPLETE,this.onLoadComplete);
            urlLoader.load(request);
         }
      }
      
      private function onIOError(error:IOErrorEvent) : void
      {
         trace("blegh");
         this.loadLevels();
      }
      
      private function onLoadComplete(e:Event) : void
      {
         var data:* = undefined;
         var levels:Array = null;
         var i:int = 0;
         var levelData:* = undefined;
         var newLevel:Level = null;
         var loader:URLLoader = e.target as URLLoader;
         if(loader)
         {
            data = JSON.deserialize(loader.data);
            levels = data.levels;
            for(i = 0; i < levels.length; i++)
            {
               levelData = levels[i];
               newLevel = new Level();
               newLevel.loadFromObject(levelData);
               this._levels.push(newLevel);
            }
         }
         this.ready = true;
         if(Globals.EDITOR_MODE)
         {
            Globals.view.editorView.invalidateProperties();
         }
      }
      
      private function saveToServer() : void
      {
         var level:Level = null;
         var dataInJSON:String = null;
         var request:URLRequest = null;
         var uploader:URLLoader = null;
         var levelData:* = undefined;
         var data:* = new Object();
         var levelArray:Array = [];
         for each(level in this._levels)
         {
            levelData = level.toObject();
            levelArray.push(levelData);
         }
         data.levels = levelArray;
         dataInJSON = JSON.serialize(data);
         request = new URLRequest(SOURCE);
         request.contentType = "application/octet-stream";
         request.method = URLRequestMethod.POST;
         request.data = dataInJSON;
         uploader = new URLLoader();
         uploader.addEventListener(IOErrorEvent.IO_ERROR,this.onUploadIOError);
         uploader.addEventListener(Event.COMPLETE,this.onUploadComplete);
         uploader.load(request);
      }
      
      private function printToConsole() : void
      {
         var level:Level = null;
         var dataInJSON:String = null;
         var levelData:* = undefined;
         var data:* = new Object();
         var levelArray:Array = [];
         for each(level in this._levels)
         {
            levelData = level.toObject();
            levelArray.push(levelData);
         }
         data.levels = levelArray;
         dataInJSON = JSON.serialize(data);
         Logger.getLogger(this).log(dataInJSON);
      }
      
      private function onUploadIOError(error:IOErrorEvent) : void
      {
         trace("error");
      }
      
      private function onUploadComplete(e:Event) : void
      {
         trace("level commit success");
      }
      
      public function saveLevel(level:Level) : void
      {
         var currLevel:Level = null;
         var levelIndex:int = -1;
         for(var i:int = 0; i < this._levels.length; i++)
         {
            currLevel = this._levels[i];
            if(currLevel.name == level.name)
            {
               levelIndex = i;
               break;
            }
         }
         if(levelIndex > -1)
         {
            if(level != this._levels[levelIndex])
            {
               this._levels[levelIndex].destroy();
               this._levels[levelIndex] = level;
            }
         }
         else
         {
            this._levels.push(level);
         }
         this.printToConsole();
      }
      
      public function getLevel(name:String) : Level
      {
         var level:Level = null;
         for(var i:int = 0; i < this._levels.length; i++)
         {
            level = this._levels[i];
            if(level.name == name)
            {
               return level;
            }
         }
         return null;
      }
      
      public function getLevelNames() : Array
      {
         var level:Level = null;
         var name:String = null;
         var names:Array = [];
         for(var i:int = 0; i < this._levels.length; i++)
         {
            level = this._levels[i];
            name = level.name;
            names.push(name);
         }
         return names;
      }
      
      public function deleteByName(name:String) : Level
      {
         var index:int = 0;
         var level:Level = this.getLevel(name);
         if(level)
         {
            index = this._levels.indexOf(level);
            if(index > -1)
            {
               this._levels.splice(index,1);
            }
         }
         return level;
      }
   }
}
