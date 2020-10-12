package iilwy.ui.partials
{
   import flash.display.Sprite;
   import flash.filters.ColorMatrixFilter;
   import iilwy.ui.controls.Label;
   import iilwy.ui.controls.UiElement;
   import iilwy.ui.events.UiEvent;
   import iilwy.ui.utils.ControlAlign;
   
   public class ImageSash extends UiElement
   {
       
      
      private var container:Sprite;
      
      private var sash:Sprite;
      
      private var dropShadow:Sprite;
      
      private var sashEdges:Sprite;
      
      private var labelField:Label;
      
      private var labelHolder:Sprite;
      
      private var _image:UiElement;
      
      private var _label:String;
      
      private var _color:uint;
      
      private var _align:String;
      
      private var _offset:Number;
      
      private var _percentageFill:Number;
      
      public function ImageSash(image:UiElement, label:String = "", width:Number = 100, height:Number = 24, color:uint = 12331044, align:String = "alignTopLeft", offset:Number = 5, percentageFill:Number = 0.4)
      {
         super();
         this.image = image;
         this.label = label;
         this.width = width;
         this.height = height;
         this.color = color;
         this.align = align;
         this.offset = offset;
         this.percentageFill = percentageFill;
      }
      
      public function get image() : UiElement
      {
         return this._image;
      }
      
      public function set image(value:UiElement) : void
      {
         this._image = value;
         if(this._image)
         {
            this._image.addEventListener(UiEvent.RESIZE,this.onImageResize);
         }
         invalidateDisplayList();
      }
      
      public function get label() : String
      {
         return this._label;
      }
      
      public function set label(value:String) : void
      {
         this._label = value;
         invalidateProperties();
         invalidateDisplayList();
      }
      
      public function get color() : uint
      {
         return this._color;
      }
      
      public function set color(value:uint) : void
      {
         this._color = value;
         invalidateDisplayList();
      }
      
      public function get align() : String
      {
         return this._align;
      }
      
      public function set align(value:String) : void
      {
         this._align = value;
         invalidateDisplayList();
      }
      
      public function get offset() : Number
      {
         return this._offset;
      }
      
      public function set offset(value:Number) : void
      {
         this._offset = value;
         invalidateDisplayList();
      }
      
      public function get percentageFill() : Number
      {
         return this._percentageFill;
      }
      
      public function set percentageFill(value:Number) : void
      {
         this._percentageFill = value;
         invalidateDisplayList();
      }
      
      override public function createChildren() : void
      {
         this.container = new Sprite();
         addChild(this.container);
         this.sash = new Sprite();
         this.container.addChild(this.sash);
         this.sashEdges = new Sprite();
         var matrix:Array = [1,0,0,0,-100,0,1,0,0,-100,0,0,1,0,-100,0,0,0,1,0];
         this.sashEdges.filters = [new ColorMatrixFilter(matrix)];
         this.container.addChild(this.sashEdges);
         this.dropShadow = new Sprite();
         this.container.addChild(this.dropShadow);
         this.labelHolder = new Sprite();
         this.container.addChild(this.labelHolder);
         this.labelField = new Label("",0,0,"strongWhite");
         this.labelField.fontSize = 12;
         this.labelHolder.addChild(this.labelField);
      }
      
      override public function commitProperties() : void
      {
         if(!this.labelField || !this.label)
         {
            return;
         }
         this.labelField.text = this.label.toUpperCase();
      }
      
      override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var shadowOffset:Number = unscaledWidth * 0.05;
         this.dropShadow.graphics.clear();
         this.dropShadow.graphics.beginFill(0,0.6);
         this.dropShadow.graphics.moveTo(0,unscaledHeight);
         this.dropShadow.graphics.lineTo(shadowOffset,unscaledHeight + 3);
         this.dropShadow.graphics.lineTo(unscaledWidth - shadowOffset,unscaledHeight + 3);
         this.dropShadow.graphics.lineTo(unscaledWidth,unscaledHeight);
         this.dropShadow.graphics.lineTo(0,unscaledHeight);
         this.dropShadow.graphics.endFill();
         this.dropShadow.x = -unscaledWidth / 2;
         this.sash.graphics.clear();
         this.sash.graphics.beginFill(this.color,1);
         this.sash.graphics.moveTo(0,unscaledHeight);
         this.sash.graphics.lineTo(unscaledHeight,0);
         this.sash.graphics.lineTo(unscaledWidth - unscaledHeight,0);
         this.sash.graphics.lineTo(unscaledWidth,unscaledHeight);
         this.sash.graphics.lineTo(0,unscaledHeight);
         this.sash.graphics.endFill();
         this.sash.x = -unscaledWidth / 2;
         var sashTopWidth:Number = unscaledWidth - unscaledHeight * 2;
         var sashPosition:Number = Math.cos(45 * (Math.PI / 180)) * (sashTopWidth / 2) - this.offset;
         if(this._align == ControlAlign.TOP_LEFT)
         {
            this.container.x = this.container.y = sashPosition;
            this.container.rotation = -45;
         }
         else if(this._align == ControlAlign.TOP_RIGHT)
         {
            if(this._image)
            {
               this.container.x = this._image.width - sashPosition;
            }
            else
            {
               this.container.x = -sashPosition;
            }
            this.container.y = sashPosition;
            this.container.rotation = 45;
         }
         var edgeLength:Number = Math.cos(45 * (Math.PI / 180)) * this.offset * 2;
         this.sashEdges.graphics.clear();
         this.sashEdges.graphics.beginFill(this.color,1);
         this.sashEdges.graphics.moveTo(-unscaledWidth / 2,unscaledHeight);
         this.sashEdges.graphics.lineTo(-unscaledWidth / 2,unscaledHeight + edgeLength);
         this.sashEdges.graphics.lineTo(-unscaledWidth / 2 + edgeLength,unscaledHeight);
         this.sashEdges.graphics.lineTo(-unscaledWidth / 2,unscaledHeight);
         this.sashEdges.graphics.moveTo(unscaledWidth / 2,unscaledHeight);
         this.sashEdges.graphics.lineTo(unscaledWidth / 2,unscaledHeight + edgeLength);
         this.sashEdges.graphics.lineTo(unscaledWidth / 2 - edgeLength,unscaledHeight);
         this.sashEdges.graphics.lineTo(unscaledWidth / 2,unscaledHeight);
         this.sashEdges.graphics.endFill();
         if(this.label && this.label.length)
         {
            this.labelField.x = -this.labelField.width / 2;
            this.labelField.y = -this.labelField.height / 2;
            this.adjustLabel(unscaledWidth,unscaledHeight);
            this.labelHolder.y = unscaledHeight / 2;
         }
      }
      
      private function adjustLabel(width:Number, height:Number) : void
      {
         var dw:Number = width / this.labelField.width;
         var dh:Number = height / this.labelField.height;
         var scale:Number = Math.abs(dw - 1) > Math.abs(dh - 1)?Number(dw):Number(dh);
         this.labelHolder.scaleX = this.labelHolder.scaleY = scale * this.percentageFill;
      }
      
      private function onImageResize(event:UiEvent) : void
      {
         invalidateDisplayList();
      }
   }
}
