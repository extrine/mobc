package
{
   import flash.display.Sprite;
   import flash.display.StageAlign;
   import flash.display.StageScaleMode;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import iilwy.application.AppComponents;
   import iilwy.display.core.ThemeManager;
   import iilwy.display.core.TooltipManager;
   import iilwy.gamenet.developer.test.GamenetControllerFactory;
   import iilwy.managers.FontManager;
   import iilwy.utils.StageReference;
   import iilwygames.baloono.BaloonoGame;
   import flash.media.SoundMixer;
   import flash.media.SoundTransform;
   import flash.external.ExternalInterface;

   public class balloono extends Sprite
   {


      protected var game:BaloonoGame;

      public function balloono()
      {
         super();
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
      }

      protected function testStart(param1:Event = null) : void
      {
         trace("testStart");
         this.game.start(this.stage,GamenetControllerFactory.createTest(4,false));
         this.onTestResize();
      }

      protected function onGameReady(param1:Event) : void
      {
         this.game.start(this.stage,GamenetControllerFactory.createTest(4,false));
         this.onTestResize();
      }

      protected function onAddedToStage(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         StageReference.init(this.stage);
         this.focusRect = null;
         // new FontManager();
         // AppComponents.themeManager = new ThemeManager();
         // AppComponents.tooltipManager = new TooltipManager(this);
         stage.frameRate =  60 //ExternalInterface.call("swf.user").fps;

         stage.scaleMode = StageScaleMode.NO_SCALE;
         stage.align = StageAlign.TOP_LEFT;
         stage.addEventListener(Event.RESIZE,this.onTestResize);
         ExternalInterface.addCallback("setMutedState",this.setMutedState);
         this.setMutedState();

         this.testCreate();
         this.testStart();
         // this.createTestButtons();
      }
      protected function setMutedState() : void
      {
         if(ExternalInterface.call("swf.is_muted"))
         {
            SoundMixer.soundTransform = new SoundTransform(0);
         }
         else
         {
            SoundMixer.soundTransform = new SoundTransform(1);
         }
      }
      protected function testPlayerFinished(param1:Event = null) : void
      {
         trace("testPlayerFinished");
      }

      protected function testDestroy(param1:Event = null) : void
      {
         trace("testDestroy");
         this.game.destroy();
         removeChild(this.game);
         this.game = null;
      }

      protected function createTestButtons() : void
      {
         var _loc5_:Sprite = null;
         var _loc1_:Array = [this.testCreate,this.testDestroy,this.testStart,this.testStop,this.testPlayerFinished];
         var _loc2_:Array = [16777215,0,65280,16711680,3355443];
         var _loc3_:Number = 0;
         var _loc4_:int = 0;
         while(_loc4_ < _loc1_.length)
         {
            _loc5_ = new Sprite();
            _loc5_.graphics.beginFill(_loc2_[_loc4_]);
            _loc5_.graphics.drawRect(0,0,10,10);
            _loc5_.addEventListener(MouseEvent.CLICK,_loc1_[_loc4_]);
            addChild(_loc5_);
            _loc5_.y = _loc3_;
            _loc3_ = _loc3_ + 15;
            _loc4_++;
         }
      }

      protected function testStop(param1:Event = null) : void
      {
         trace("testStop");
         this.game.stop();
      }

      protected function onTestResize(param1:Event = null) : void
      {
         var _loc2_:Rectangle = this.game.setSize(Math.floor(stage.stageWidth  ),Math.floor(stage.stageHeight  ));
         this.game.x = Math.floor((stage.stageWidth - _loc2_.width) / 2);
         this.game.y = Math.floor((stage.stageHeight - _loc2_.height) / 2);
      }

      protected function testCreate(param1:Event = null) : void
      {
         trace("testCreate");
         this.game = new BaloonoGame();
         this.game.x = 20;
         addChild(this.game);
      }
   }
}
