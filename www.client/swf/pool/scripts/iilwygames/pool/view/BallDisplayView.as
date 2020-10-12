package iilwygames.pool.view
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import iilwygames.pool.core.Globals;
   
   public class BallDisplayView extends Sprite
   {
       
      
      private var _mask:Sprite;
      
      private var _ballTexture:BitmapData;
      
      private var _bmHolder:Bitmap;
      
      private var _specular:Bitmap;
      
      public function BallDisplayView()
      {
         super();
         this._mask = new Sprite();
         this._bmHolder = new Bitmap();
         this._specular = new Bitmap();
         addChild(this._bmHolder);
         addChild(this._specular);
         addChild(this._mask);
         mask = this._mask;
         this._mask.graphics.clear();
         this._mask.graphics.beginFill(16777215);
         this._mask.graphics.drawCircle(17,17,8.5);
         this._mask.graphics.endFill();
      }
      
      public function destroy() : void
      {
         removeChild(this._mask);
         removeChild(this._bmHolder);
         removeChild(this._specular);
         this._bmHolder = null;
         this._mask = null;
         this._specular = null;
      }
      
      public function setTexture(ballNumber:int) : void
      {
         var textureName:String = null;
         if(ballNumber < 9)
         {
            textureName = "solid_" + ballNumber;
         }
         else
         {
            textureName = "stripe_" + ballNumber;
         }
         this._ballTexture = Globals.resourceManager.getBallTexture(textureName);
         this._bmHolder.bitmapData = this._ballTexture;
         this._bmHolder.width = 68;
         this._bmHolder.height = 34;
         this._specular.bitmapData = Globals.resourceManager.getTexture("pool_glow_fixed");
      }
   }
}
