package iilwy.gamenet.model
{
   import iilwy.utils.logging.Logger;
   
   public class MatchBehavior
   {
       
      
      protected var _match:MatchData;
      
      protected var _logger:Logger;
      
      protected var _matchEventRegistry:Array;
      
      public function MatchBehavior()
      {
         this._matchEventRegistry = [];
         super();
         this._logger = Logger.getLogger(this);
         this._logger.level = Logger.LOG;
      }
      
      protected function addMatchListener(type:String, listener:Function) : void
      {
         if(this._match != null)
         {
            this._match.addEventListener(type,listener,false,0,true);
            this._matchEventRegistry.push({
               "type":type,
               "listener":listener
            });
         }
      }
      
      protected function removeMatchListener(type:String, listener:Function) : void
      {
         if(this._match != null)
         {
            this._match.removeEventListener(type,listener);
         }
      }
      
      protected function clearAllListeners() : void
      {
         var entry:* = undefined;
         for each(entry in this._matchEventRegistry)
         {
            this._match.removeEventListener(entry.type,entry.listener);
         }
      }
   }
}
