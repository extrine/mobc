package iilwygames.baloono.gameplay.player
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import iilwy.gamenet.developer.GamenetPlayerData;
   import iilwy.ui.controls.Label;
   import iilwy.utils.TextUtil;
   import iilwy.utils.UiRender;
   import iilwygames.baloono.BaloonoGame;
   
   public class PlayerLabel extends Sprite
   {
       
      
      private var bitmap:Bitmap;
      
      public function PlayerLabel(param1:GamenetPlayerData)
      {
         super();
         this.initialize();
         var _loc2_:Sprite = new Sprite();
         var _loc3_:Number = 2566914048;
         var _loc4_:Number = 3439329279;
         if(BaloonoGame.instance.gamenetController.playerData && param1.playerJid == BaloonoGame.instance.gamenetController.playerData.playerJid)
         {
            _loc3_ = 2583691263;
            _loc4_ = 3422552064;
         }
         var _loc5_:Sprite = new Sprite();
         UiRender.renderRoundRect(_loc5_,_loc3_,0,0,100,100,0);
         _loc2_.addChild(_loc5_);
         var _loc6_:String = TextUtil.clipText(param1.profileName,15);
         var _loc7_:Label = new Label(param1.profileName,4,1,"smallStrong");
         _loc7_.fontColor = _loc4_;
         _loc2_.addChild(_loc7_);
         _loc5_.width = _loc7_.width + 8;
         _loc5_.height = _loc7_.height + 2;
         UiRender.renderTriangle(_loc2_,_loc3_,Math.floor(_loc5_.width / 2) - 5,_loc5_.height,10,5);
         this.bitmap = new Bitmap();
         var _loc8_:BitmapData = new BitmapData(_loc2_.width,_loc2_.height,true,16777215);
         _loc8_.draw(_loc2_);
         this.bitmap.bitmapData = _loc8_;
         addChild(this.bitmap);
         this.bitmap.x = -Math.floor(this.bitmap.width / 2);
         this.bitmap.y = -this.bitmap.height;
      }
      
      public function initialize() : void
      {
      }
      
      public function destroy() : void
      {
         if(this.bitmap)
         {
            if(this.bitmap.bitmapData)
            {
               this.bitmap.bitmapData.dispose();
               this.bitmap.bitmapData = null;
            }
            this.bitmap = null;
         }
      }
   }
}
