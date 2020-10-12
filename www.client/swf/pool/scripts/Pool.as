package
{
    import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.display.StageAlign;
   import flash.display.StageScaleMode;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.external.ExternalInterface;
   import flash.geom.Rectangle;
   import flash.media.SoundMixer;
   import flash.media.SoundTransform;
   import flash.system.Security;
   import iilwy.gamenet.developer.test.GamenetControllerFactory;
   import iilwy.utils.StageReference;
   import iilwygames.pool.core.Game;


   public class Pool extends Sprite
   {


      private var _game:Game;

      public function Pool()
      {
         super();
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
      }

      protected function onAddedToStage(event:Event) : void
      {
          Security.allowDomain("*");
         Security.allowInsecureDomain("*");
         //ShopPreview(null);
         removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         StageReference.init(this.stage);
         this.focusRect = null;
        // AppComponents.themeManager = new ThemeManager();
        // AppComponents.tooltipManager = new TooltipManager(this);
         stage.frameRate =  ExternalInterface.call("swf.user").fps;
         stage.scaleMode = StageScaleMode.NO_SCALE;
         stage.align = StageAlign.TOP_LEFT;
         stage.addEventListener(Event.RESIZE,this.onTestResize);
         stage.addEventListener(MouseEvent.MOUSE_UP,this.doMouseUp,false,0,true);
         ExternalInterface.addCallback("setMutedState",this.setMutedState);
         this.setMutedState();
         this.testCreate();
         this.testStart();
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
      protected function onGameReady(event:Event) : void
      {
         this.onTestResize();
      }

      protected function createTestButtons() : void
      {
         var but:Sprite = null;
         var methods:Array = [this.testCreate,this.testDestroy,this.testStart,this.testStop,this.testPlayerFinished];
         var colors:Array = [16777215,0,65280,16711680,3355443];
         var y:Number = 0;
         for(var i:int = 0; i < methods.length; i++)
         {
            but = new Sprite();
            but.graphics.beginFill(colors[i]);
            but.graphics.drawRect(0,0,10,10);
            but.addEventListener(MouseEvent.CLICK,methods[i]);
            addChild(but);
            but.y = y;
            y = y + 15;
         }
      }

      protected function testCreate(event:Event = null) : void
      {
         this._game = new Game();
         this._game.x = 0;
         addChild(this._game);
      }

      protected function testDestroy(event:Event = null) : void
      {
         this._game.destroy();
         removeChild(this._game);
         this._game = null;
      }

      protected function testStart(event:Event = null) : void
      {
         this.onTestResize();
         this._game.start(this.stage,GamenetControllerFactory.createTest(1,false));
      }

      protected function testStop(event:Event = null) : void
      {
         this._game.stop();
      }

      protected function testPlayerFinished(event:Event = null) : void
      {
         trace("testPlayerFinished");
      }

      protected function onTestResize(event:Event = null) : void
      {
         var finalSize:Rectangle = this._game.setSize(Math.floor(stage.stageWidth)+20,Math.floor(stage.stageHeight)+20);
         this._game.x = Math.floor((stage.stageWidth - finalSize.width) * 0.5);
         this._game.y = Math.floor((stage.stageHeight - finalSize.height) * 0.5);
      }
      protected function doMouseUp(param1:MouseEvent) : void
      {
         ExternalInterface.call("u.focusChat");
      }
   }
}
