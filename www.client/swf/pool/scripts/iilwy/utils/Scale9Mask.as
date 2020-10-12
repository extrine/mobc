package iilwy.utils
{
   import flash.display.Sprite;
   
   public class Scale9Mask extends Sprite
   {
       
      
      private var topLeftCorner:Sprite;
      
      private var topRightCorner:Sprite;
      
      private var bottomLeftCorner:Sprite;
      
      private var bottomRightCorner:Sprite;
      
      private var topRectangle:Sprite;
      
      private var leftRectangle:Sprite;
      
      private var rightRectangle:Sprite;
      
      private var bottomRectangle:Sprite;
      
      private var mainRectangle:Sprite;
      
      private var topLeftRadius:Number;
      
      private var topRightRadius:Number;
      
      private var bottomRightRadius:Number;
      
      private var bottomLeftRadius:Number;
      
      private var leftMargin:Number;
      
      private var bottomMargin:Number;
      
      private var topMargin:Number;
      
      private var rightMargin:Number;
      
      private var innerWidth:Number;
      
      private var innerHeight:Number;
      
      public function Scale9Mask(width:Number, height:Number, topLeftRadius:Number, topRightRadius:Number, bottomRightRadius:Number, bottomLeftRadius:Number)
      {
         super();
         this.topLeftRadius = topLeftRadius;
         this.topRightRadius = topRightRadius;
         this.bottomLeftRadius = bottomLeftRadius;
         this.bottomRightRadius = bottomRightRadius;
         this.initMargins();
         this.innerWidth = width - this.leftMargin - this.rightMargin;
         this.innerHeight = height - this.topMargin - this.bottomMargin;
         this.initDisplayObjects();
      }
      
      public function destroy() : void
      {
         removeChild(this.topRectangle);
         removeChild(this.rightRectangle);
         removeChild(this.bottomRectangle);
         removeChild(this.leftRectangle);
         removeChild(this.mainRectangle);
         removeChild(this.topRightCorner);
         removeChild(this.bottomRightCorner);
         removeChild(this.topLeftCorner);
         removeChild(this.bottomLeftCorner);
      }
      
      override public function set width(value:Number) : void
      {
         this.innerWidth = value - this.leftMargin - this.rightMargin;
         this.topRectangle.width = this.mainRectangle.width = this.bottomRectangle.width = this.innerWidth;
         var newLeft:Number = this.mainRectangle.x + this.mainRectangle.width;
         this.topRightCorner.x = newLeft;
         this.bottomRightCorner.x = newLeft;
         if(this.bottomRightRadius > 0)
         {
            this.bottomRightCorner.x = this.bottomRightCorner.x + this.rightMargin;
         }
         this.rightRectangle.x = newLeft;
      }
      
      override public function set height(value:Number) : void
      {
         this.innerHeight = value - this.topMargin - this.bottomMargin;
         this.leftRectangle.height = this.mainRectangle.height = this.rightRectangle.height = this.innerHeight;
         var newTop:Number = this.mainRectangle.y + this.mainRectangle.height;
         this.bottomLeftCorner.y = newTop;
         if(this.bottomLeftRadius > 0)
         {
            this.bottomLeftCorner.y = this.bottomLeftCorner.y + this.leftMargin;
         }
         this.bottomRightCorner.y = newTop;
         this.bottomRectangle.y = newTop;
      }
      
      override public function get scaleX() : Number
      {
         return this.mainRectangle.scaleX;
      }
      
      override public function set scaleX(value:Number) : void
      {
         var newLeft:Number = NaN;
         this.topRectangle.scaleX = this.mainRectangle.scaleX = this.bottomRectangle.scaleX = value;
         newLeft = this.mainRectangle.x + this.mainRectangle.width;
         this.topRightCorner.x = newLeft;
         this.bottomRightCorner.x = newLeft;
         if(this.bottomRightRadius > 0)
         {
            this.bottomRightCorner.x = this.bottomRightCorner.x + this.rightMargin;
         }
         this.rightRectangle.x = newLeft;
      }
      
      override public function get scaleY() : Number
      {
         return this.mainRectangle.scaleY;
      }
      
      override public function set scaleY(value:Number) : void
      {
         this.leftRectangle.scaleY = this.mainRectangle.scaleY = this.rightRectangle.scaleY = value;
         var newTop:Number = this.mainRectangle.y + this.mainRectangle.height;
         this.bottomLeftCorner.y = newTop;
         if(this.bottomLeftRadius > 0)
         {
            this.bottomLeftCorner.y = this.bottomLeftCorner.y + Number(this.leftMargin);
         }
         this.bottomRightCorner.y = newTop;
         this.bottomRectangle.y = newTop;
      }
      
      private function initMargins() : void
      {
         this.topMargin = this.topLeftRadius > this.topRightRadius?Number(this.topLeftRadius):Number(this.topRightRadius);
         this.leftMargin = this.bottomLeftRadius > this.topLeftRadius?Number(this.bottomLeftRadius):Number(this.topLeftRadius);
         this.bottomMargin = this.bottomLeftRadius > this.bottomRightRadius?Number(this.bottomLeftRadius):Number(this.bottomRightRadius);
         this.rightMargin = this.topRightRadius > this.bottomRightRadius?Number(this.topRightRadius):Number(this.bottomRightRadius);
      }
      
      private function initDisplayObjects() : void
      {
         this.topRectangle = this.createRect(this.leftMargin,0,this.innerWidth,this.topMargin);
         addChild(this.topRectangle);
         this.rightRectangle = this.createRect(this.leftMargin + this.innerWidth,this.topMargin,this.rightMargin,this.innerHeight);
         addChild(this.rightRectangle);
         this.bottomRectangle = this.createRect(this.leftMargin,this.topMargin + this.innerHeight,this.innerWidth,this.bottomMargin);
         addChild(this.bottomRectangle);
         this.leftRectangle = this.createRect(0,this.topMargin,this.leftMargin,this.innerHeight);
         addChild(this.leftRectangle);
         this.mainRectangle = this.createRect(this.leftMargin,this.topMargin,this.innerWidth,this.innerHeight);
         addChild(this.mainRectangle);
         this.topRightCorner = this.topRightRadius > 0?this.createCorner(this.rightRectangle.x,0,this.rightMargin,this.topMargin,0):this.createRect(this.rightRectangle.x,0,this.rightMargin,this.topMargin);
         addChild(this.topRightCorner);
         this.bottomRightCorner = this.bottomRightRadius > 0?this.createCorner(this.rightRectangle.x + this.rightMargin,this.bottomRectangle.y,this.rightMargin,this.bottomMargin,90):this.createRect(this.rightRectangle.x,this.bottomRectangle.y,this.rightMargin,this.bottomMargin);
         addChild(this.bottomRightCorner);
         this.topLeftCorner = this.topLeftRadius > 0?this.createCorner(0,this.topMargin,this.leftMargin,this.topMargin,270):this.createRect(0,0,this.leftMargin,this.topMargin);
         addChild(this.topLeftCorner);
         this.bottomLeftCorner = this.bottomLeftRadius > 0?this.createCorner(this.leftMargin,this.bottomRectangle.y + this.bottomMargin,this.leftMargin,this.bottomMargin,180):this.createRect(0,this.bottomRectangle.y,this.leftMargin,this.bottomMargin);
         addChild(this.bottomLeftCorner);
      }
      
      private function createRect(xPos:Number, yPos:Number, w:Number, h:Number) : Sprite
      {
         var rect:Sprite = new Sprite();
         rect.graphics.beginFill(0,1);
         rect.graphics.drawRect(0,0,w,h);
         rect.graphics.endFill();
         rect.x = xPos;
         rect.y = yPos;
         return rect;
      }
      
      private function createCorner(xPos:Number, yPos:Number, w:Number, h:Number, rotation:Number) : Sprite
      {
         var corner:Sprite = new Sprite();
         corner.graphics.beginFill(0);
         corner.graphics.drawRoundRectComplex(0,0,w,h,0,w,0,0);
         corner.graphics.endFill();
         corner.rotation = rotation;
         corner.x = xPos;
         corner.y = yPos;
         return corner;
      }
   }
}
