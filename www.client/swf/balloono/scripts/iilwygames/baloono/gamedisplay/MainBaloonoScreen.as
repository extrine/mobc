package iilwygames.baloono.gamedisplay
{
   import com.partlyhuman.debug.LED;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import iilwygames.baloono.BaloonoGame;
   import iilwygames.baloono.core.CoreGameEvent;
   import iilwygames.baloono.effects.ParticleSystem;
   import iilwygames.baloono.gameplay.map.MapView;
   import iilwygames.baloono.graphics.IResizable;
   import iilwygames.baloono.gs.TweenFilterLite;
   
   public class MainBaloonoScreen extends Sprite implements IScreen, IResizable
   {
       
      
      public var green:LED;
      
      protected var cachedWidth:Number;
      
      public var particle:Sprite;
      
      public var red:LED;
      
      public var blue:LED;
      
      public var psystem:ParticleSystem;
      
      public var mapView:MapView;
      
      protected var cachedHeight:Number;
      
      protected var popup:DisplayObject;
      
      protected var tf:TextField;
      
      public var hudLayer:Sprite;
      
      public function MainBaloonoScreen()
      {
         super();
         this.mapView = new MapView();
         addChild(this.mapView.display);
         this.psystem = new ParticleSystem();
         this.particle = new Sprite();
         this.particle.addChild(this.psystem);
         addChild(this.particle);
         this.hudLayer = new Sprite();
         addChild(this.hudLayer);
         if(BaloonoGame.instance.DEBUG_VISUAL)
         {
            this.red = new LED(16719647);
            this.green = new LED(3538758);
            this.blue = new LED(1128959);
            this.red.y = this.green.y = this.blue.y = 8;
            this.red.x = 10;
            this.green.x = 20;
            this.blue.x = 30;
            addChild(this.red);
            addChild(this.green);
            addChild(this.blue);
            this.tf = new TextField();
            this.tf.height = 30;
            this.tf.width = 60;
            this.tf.defaultTextFormat = new TextFormat("Verdana",20,16777215);
            addChild(this.tf);
         }
      }
      
      public function get size() : Rectangle
      {
         return this.mapView.size;
      }
      
      public function reset() : void
      {
         this.mapView.display.filters = [];
         this.psystem.reset();
      }
      
      public function resize(param1:Number, param2:Number) : void
      {
         this.cachedHeight = param2;
         this.cachedWidth = param1;
         this.mapView.resize(param1,param2);
         this.layout();
         if(BaloonoGame.instance.DEBUG_VISUAL)
         {
            this.tf.x = -50;
            this.tf.y = 50;
         }
      }
      
      public function layout() : void
      {
         this.mapView.display.x = 0;
         this.mapView.display.y = 0;
         if(this.popup && contains(this.popup))
         {
            this.popup.x = Math.max(0,(this.mapView.cachedWidth - this.popup.width) * 0.5);
            this.popup.y = Math.max(0,(this.mapView.cachedHeight - this.popup.height) * 0.5);
         }
      }
      
      public function redraw(param1:CoreGameEvent) : void
      {
         if(BaloonoGame.instance.DEBUG_VISUAL)
         {
            this.tf.text = BaloonoGame.instance.framerateMonitor.framerate.toFixed(0);
         }
      }
      
      public function setPopup(param1:DisplayObject, param2:Boolean = true) : void
      {
         var newPopup:DisplayObject = param1;
         var animate:Boolean = param2;
         if(newPopup == null)
         {
            if(this.popup && contains(this.popup))
            {
               removeChild(this.popup);
            }
            if(this.popup)
            {
               this.popup = null;
            }
            if(animate)
            {
               TweenFilterLite.killTweensOf(this.mapView.display);
               TweenFilterLite.to(this.mapView.display,1,{
                  "blurFilter":{
                     "blurX":0,
                     "blurY":0
                  },
                  "onComplete":function():void
                  {
                     mapView.display.filters = [];
                  }
               });
            }
            return;
         }
         if(this.popup)
         {
            this.setPopup(null,false);
         }
         this.popup = newPopup;
         addChild(this.popup);
         this.layout();
         if(animate)
         {
            TweenFilterLite.killTweensOf(this.mapView.display);
            TweenFilterLite.to(this.mapView.display,1.5,{
               "blurFilter":{
                  "blurX":2,
                  "blurY":2
               },
               "colorMatrixFilter":{"saturation":0}
            });
         }
      }
   }
}
