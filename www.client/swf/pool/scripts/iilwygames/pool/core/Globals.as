package iilwygames.pool.core
{
   import iilwy.gamenet.developer.GamenetController;
   import iilwygames.pool.achievements.AchievementManager;
   import iilwygames.pool.assets.EmbeddedResources;
   import iilwygames.pool.mcplayer.MovieClipPlayer;
   import iilwygames.pool.model.GameModel;
   import iilwygames.pool.model.gameplay.Ruleset.trickshots.LevelManager;
   import iilwygames.pool.network.GamenetMediator;
   import iilwygames.pool.sound.SoundManager;
   import iilwygames.pool.view.GameView;
   import flash.external.ExternalInterface;

   public class Globals
   {

      public static var model:GameModel;

      public static var view:GameView;

      public static var netController:GamenetController;

      public static var netMediator:GamenetMediator;

      public static var resourceManager:ResourceManager;

      public static var embeddedResources:EmbeddedResources;

      public static var soundManager:SoundManager;

      public static var achievementManager:AchievementManager;

      public static var keyListener:KeyListener;

      public static var levelManager:LevelManager;

      public static var productManager:ProductManager;

      public static var movieClipPlayer:MovieClipPlayer;

      public static var gameState:int;

      public static var FACEBOOK_BUILD:Boolean = false //ExternalInterface.call('swf.getPlayers','').length == 1 ;

      public static var CPU_PLAYER_ENABLED:Boolean = false;

      public static var CPU_TAKEOVER:Boolean = false;

      public static var EDITOR_MODE:Boolean = false;


      public function Globals()
      {
         super();
      }

      public static function initialize() : void
      {
         if(!model)
         {
            model = new GameModel();
         }
         if(!view)
         {
            view = new GameView();
         }
         if(!netMediator)
         {
            netMediator = new GamenetMediator();
         }
         if(!resourceManager)
         {
            resourceManager = new ResourceManager();
         }
         if(!embeddedResources)
         {
            embeddedResources = new EmbeddedResources();
         }
         if(!soundManager)
         {
            soundManager = new SoundManager();
         }
         if(!achievementManager)
         {
            achievementManager = new AchievementManager();
         }
         if(!keyListener)
         {
            keyListener = new KeyListener();
         }
         if(!levelManager)
         {
            levelManager = new LevelManager();
         }
         if(!productManager)
         {
            productManager = new ProductManager();
         }
         if(!movieClipPlayer)
         {
            movieClipPlayer = new MovieClipPlayer();
         }
      }

      public static function destroy() : void
      {
         if(model)
         {
            model.destroy();
         }
         if(view)
         {
            view.destroy();
         }
         if(netMediator)
         {
            netMediator.destroy();
         }
         if(resourceManager)
         {
            resourceManager.destroy();
         }
         if(soundManager)
         {
            soundManager.destroy();
         }
         if(achievementManager)
         {
            achievementManager.destroy();
         }
         if(keyListener)
         {
            keyListener.destroy();
         }
         if(levelManager)
         {
            levelManager.destroy();
         }
         if(productManager)
         {
            productManager.destroy();
         }
         if(movieClipPlayer)
         {
            movieClipPlayer.destroy();
         }
         model = null;
         view = null;
         netMediator = null;
         resourceManager = null;
         embeddedResources = null;
         soundManager = null;
         achievementManager = null;
         keyListener = null;
         levelManager = null;
         productManager = null;
         movieClipPlayer = null;
      }

      public static function stop() : void
      {
         if(netMediator)
         {
            netMediator.deactivate();
         }
         netController = null;
         if(model)
         {
            model.stop();
         }
         if(resourceManager)
         {
            resourceManager.stop();
         }
         if(view)
         {
            view.stop();
         }
         if(soundManager)
         {
            soundManager.stop();
         }
         if(keyListener)
         {
            keyListener.deactivate();
         }
         if(productManager)
         {
            productManager.stop();
         }
         if(movieClipPlayer)
         {
            movieClipPlayer.stop();
         }
      }
   }
}
