package iilwygames.pool.core
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   import gs.TweenLite;
   import iilwy.gamenet.developer.GamenetController;
   import iilwy.managers.GraphicManager;
   import iilwy.motion.Equations;
   import iilwy.ui.controls.IconButton;
   import iilwy.ui.controls.Label;
   import iilwygames.pool.events.ResourceManagerEvent;
   
   public class ShopPreview extends Sprite
   {
       
      
      protected var initialized:Boolean;
      
      private var _width:Number;
      
      private var _height:Number;
      
      private var windowW:Number;
      
      private var windowH:Number;
      
      private var panHolder:Sprite;
      
      private var scaleHolder:Sprite;
      
      private var pocketLayer:Bitmap;
      
      private var feltLayer:Bitmap;
      
      private var decalLayer:Bitmap;
      
      private var bumperLayer:Bitmap;
      
      private var tableLayer:Bitmap;
      
      private var stickOnTable:Bitmap;
      
      private var maskSprite:Sprite;
      
      private var zoomBar:Sprite;
      
      private var zoomLabel:Label;
      
      private var zoomOutButton:IconButton;
      
      private var zoomInButton:IconButton;
      
      private var zoomLevel:Number;
      
      private var dragbounds:Rectangle;
      
      public function ShopPreview()
      {
         super();
         this.initialized = false;
         this._width = 0;
         this._height = 0;
         this.scaleHolder = new Sprite();
         this.panHolder = new Sprite();
         this.panHolder.buttonMode = true;
         this.panHolder.useHandCursor = true;
         addChild(this.scaleHolder);
         this.scaleHolder.addChild(this.panHolder);
         this.feltLayer = new Bitmap();
         this.decalLayer = new Bitmap();
         this.bumperLayer = new Bitmap();
         this.tableLayer = new Bitmap();
         this.pocketLayer = new Bitmap();
         this.stickOnTable = new Bitmap();
         this.panHolder.addChild(this.feltLayer);
         this.panHolder.addChild(this.decalLayer);
         this.panHolder.addChild(this.bumperLayer);
         this.panHolder.addChild(this.tableLayer);
         this.panHolder.addChild(this.pocketLayer);
         this.panHolder.addChild(this.stickOnTable);
         this.stickOnTable.filters = [new DropShadowFilter(1,90,0,0.5,40,40,2)];
         this.zoomBar = new Sprite();
         this.zoomLabel = new Label("ZOOM",0,0,"strongWhite");
         this.zoomInButton = new IconButton(GraphicManager.iconPlus2,0,0,20,20,"iconButtonWhiteReverse");
         this.zoomInButton.cornerRadius = 6;
         this.zoomOutButton = new IconButton(GraphicManager.iconMinus,0,-5,20,20,"iconButtonWhiteReverse");
         this.zoomOutButton.cornerRadius = 6;
         addChild(this.zoomBar);
         addChild(this.zoomLabel);
         addChild(this.zoomInButton);
         addChild(this.zoomOutButton);
         this.maskSprite = new Sprite();
         addChild(this.maskSprite);
         mask = this.maskSprite;
         this.zoomInButton.addEventListener(MouseEvent.CLICK,this.onZoomIn,false,0,true);
         this.zoomOutButton.addEventListener(MouseEvent.CLICK,this.onZoomOut,false,0,true);
         addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown,false,0,true);
         addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp,false,0,true);
         addEventListener(MouseEvent.MOUSE_OUT,this.onMouseUp,false,0,true);
         this.zoomLevel = 1;
         this.dragbounds = new Rectangle();
      }
      
      public function stop() : void
      {
      }
      
      public function destroy() : void
      {
         if(this.stickOnTable.bitmapData)
         {
            this.stickOnTable.bitmapData.dispose();
            this.stickOnTable.bitmapData = null;
         }
         this.panHolder.removeChild(this.feltLayer);
         this.panHolder.removeChild(this.decalLayer);
         this.panHolder.removeChild(this.bumperLayer);
         this.panHolder.removeChild(this.tableLayer);
         this.panHolder.removeChild(this.pocketLayer);
         this.panHolder.removeChild(this.stickOnTable);
         this.scaleHolder.removeChild(this.panHolder);
         removeChild(this.zoomBar);
         removeChild(this.zoomLabel);
         removeChild(this.zoomInButton);
         removeChild(this.zoomOutButton);
         this.zoomInButton.destroy();
         this.zoomOutButton.destroy();
         this.zoomLabel.destroy();
         this.scaleHolder = null;
         this.panHolder = null;
         this.pocketLayer = null;
         this.feltLayer = null;
         this.decalLayer = null;
         this.bumperLayer = null;
         this.tableLayer = null;
         this.stickOnTable = null;
         this.zoomBar = null;
         this.zoomLabel = null;
         this.zoomInButton = null;
         this.zoomOutButton = null;
         this.dragbounds = null;
         Globals.destroy();
         this.initialized = false;
         removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         removeEventListener(MouseEvent.MOUSE_OUT,this.onMouseUp);
      }
      
      public function initialize() : void
      {
         if(this.initialized)
         {
            dispatchEvent(new Event(Event.COMPLETE,false));
            return;
         }
         this.initialized = true;
         Globals.initialize();
         dispatchEvent(new Event(Event.COMPLETE,false));
         Globals.resourceManager.removeEventListener(ResourceManagerEvent.ASSETS_READY,this.assetsReady);
         Globals.resourceManager.addEventListener(ResourceManagerEvent.ASSETS_READY,this.assetsReady);
      }
      
      public function setController(gnc:GamenetController) : void
      {
         trace("setController");
         if(this.stickOnTable && this.stickOnTable.bitmapData)
         {
            this.stickOnTable.bitmapData.dispose();
            this.stickOnTable.bitmapData = null;
         }
         Globals.resourceManager.stop();
         Globals.resourceManager.loadAssets(gnc);
      }
      
      public function assetsReady(event:ResourceManagerEvent) : void
      {
         trace("ready");
         var fakeJID:String = "12345";
         var pocket:BitmapData = Globals.resourceManager.getTexture("pool_holes");
         var felt:BitmapData = Globals.resourceManager.getTexture("pool_felt",fakeJID);
         var bumper:BitmapData = Globals.resourceManager.getTexture("pool_bumpers",fakeJID);
         var table:BitmapData = Globals.resourceManager.getTexture("pool_table",fakeJID);
         var decal:BitmapData = Globals.resourceManager.getTexture("pool_decal",fakeJID);
         var cueStickSprite:Sprite = Globals.resourceManager.getSpriteAsset("pool_cue",fakeJID);
         this.pocketLayer.bitmapData = pocket;
         this.feltLayer.bitmapData = felt;
         this.bumperLayer.bitmapData = bumper;
         this.tableLayer.bitmapData = table;
         this.decalLayer.bitmapData = decal;
         this.feltLayer.smoothing = true;
         this.decalLayer.smoothing = true;
         this.bumperLayer.smoothing = true;
         this.tableLayer.smoothing = true;
         this.pocketLayer.smoothing = true;
         var scalar:Number = this._width / this.tableLayer.width;
         this.scaleHolder.scaleX = scalar;
         this.scaleHolder.scaleY = scalar;
         this.zoomLevel = 1;
         this.panHolder.x = -0.5 * this.panHolder.width;
         this.panHolder.y = -0.5 * this.panHolder.height;
         var dragLimitScale:Number = 0.9;
         this.dragbounds.x = -this.panHolder.width * dragLimitScale;
         this.dragbounds.y = -this.panHolder.height * dragLimitScale;
         this.dragbounds.right = -(1 - dragLimitScale) * this.panHolder.width;
         this.dragbounds.bottom = -(1 - dragLimitScale) * this.panHolder.height;
         if(this.stickOnTable.bitmapData)
         {
            this.stickOnTable.bitmapData.dispose();
            this.stickOnTable.bitmapData = null;
         }
         var transformMatrix:Matrix = new Matrix();
         scalar = this.tableLayer.width / cueStickSprite.height * 0.65;
         transformMatrix.scale(scalar,scalar);
         var cuestickbmd:BitmapData = new BitmapData(cueStickSprite.width * scalar,cueStickSprite.height * scalar,true,0);
         cuestickbmd.draw(cueStickSprite,transformMatrix,null,null,null,true);
         this.stickOnTable.bitmapData = cuestickbmd;
         this.stickOnTable.rotationZ = -63;
         this.stickOnTable.x = (this.tableLayer.width - this.stickOnTable.width) * 0.5;
         this.stickOnTable.y = (this.tableLayer.height - this.stickOnTable.height) * 0.5;
         this.stickOnTable.smoothing = true;
         this.scaleHolder.alpha = 0;
         TweenLite.to(this.scaleHolder,1,{
            "alpha":1,
            "ease":Equations.easeOutExpo
         });
      }
      
      protected function setDisplayObjectDim(displayObject:DisplayObject, xPos:Number, yPos:Number, w:Number, h:Number) : void
      {
         displayObject.x = xPos;
         displayObject.y = yPos;
         displayObject.width = w;
         displayObject.height = h;
      }
      
      public function setSize(width:Number, height:Number) : void
      {
         var ratio:Number = 644 / 396;
         var currRatio:Number = width / height;
         if(currRatio > ratio)
         {
            this._width = height * ratio;
            this._height = height;
         }
         else
         {
            this._width = width;
            this._height = width / ratio;
         }
         this.windowH = height;
         this.windowW = width;
         Globals.view.setSize(1024,1024);
         this.maskSprite.graphics.clear();
         this.maskSprite.graphics.beginFill(16711680,1);
         this.maskSprite.graphics.drawRoundRect(0,0,width,height,10);
         this.maskSprite.graphics.endFill();
         this.zoomBar.graphics.clear();
         this.zoomBar.graphics.beginFill(0,0.15);
         this.zoomBar.graphics.drawRect(0,0,width,25);
         this.zoomBar.graphics.endFill();
         this.zoomLabel.x = 10;
         this.zoomLabel.y = 0.5 * (this.zoomBar.height - this.zoomLabel.height);
         this.zoomInButton.x = width - 10 - this.zoomInButton.width;
         this.zoomOutButton.x = this.zoomInButton.x - 5 - this.zoomOutButton.width;
         this.zoomInButton.y = 0.5 * (this.zoomBar.height - this.zoomInButton.height);
         this.zoomOutButton.y = 0.5 * (this.zoomBar.height - this.zoomOutButton.height);
         var scalar:Number = this._width / this.tableLayer.width;
         this.scaleHolder.scaleX = scalar;
         this.scaleHolder.scaleY = scalar;
         this.scaleHolder.x = 0.5 * width;
         this.scaleHolder.y = 0.5 * height;
      }
      
      protected function onZoomOut(me:MouseEvent) : void
      {
         var scalar:Number = this._width / this.tableLayer.width;
         if(this.zoomLevel > 1)
         {
            this.zoomLevel = this.zoomLevel / 2;
         }
         var sx:Number = scalar * this.zoomLevel;
         var sy:Number = scalar * this.zoomLevel;
         TweenLite.to(this.scaleHolder,1,{
            "scaleX":sx,
            "scaleY":sy,
            "ease":Equations.easeOutExpo
         });
         if(this.zoomLevel <= 1)
         {
            TweenLite.to(this.panHolder,0.8,{
               "x":-0.5 * this.panHolder.width,
               "y":-0.5 * this.panHolder.height,
               "ease":Equations.easeOutExpo
            });
         }
      }
      
      protected function onZoomIn(me:MouseEvent) : void
      {
         var scalar:Number = this._width / this.tableLayer.width;
         if(this.zoomLevel <= 2)
         {
            this.zoomLevel = this.zoomLevel * 2;
         }
         var sx:Number = scalar * this.zoomLevel;
         var sy:Number = scalar * this.zoomLevel;
         TweenLite.to(this.scaleHolder,1,{
            "scaleX":sx,
            "scaleY":sy,
            "ease":Equations.easeOutExpo
         });
      }
      
      protected function onMouseDown(me:MouseEvent) : void
      {
         if(this.zoomLevel > 1)
         {
            this.panHolder.startDrag(false,this.dragbounds);
         }
      }
      
      protected function onMouseUp(me:MouseEvent) : void
      {
         this.panHolder.stopDrag();
      }
   }
}
