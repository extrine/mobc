package iilwy.display.shop
{
   import iilwy.model.dataobjects.shop.CatalogProductBase;
   import iilwy.ui.containers.Canvas;
   import iilwy.ui.containers.List;
   import iilwy.ui.controls.Label;
   import iilwy.utils.GraphicUtil;
   import iilwy.utils.ShopUtil;
   
   public class LockedProductIndicator extends Canvas
   {
       
      
      public var list:List;
      
      public var topLabel:Label;
      
      public var bottomLabel:Label;
      
      private var _base:CatalogProductBase;
      
      public function LockedProductIndicator()
      {
         super();
         height = 40;
         width = 100;
         cornerRadius = 12;
         backgroundColor = 827903;
      }
      
      override public function createChildren() : void
      {
         this.topLabel = new Label("LOCKED",0,0,"strongWhite");
         this.topLabel.fontSize = 14;
         addContentChild(this.topLabel);
         this.bottomLabel = new Label("",0,0,"white");
         this.bottomLabel.fontSize = 10;
         addContentChild(this.bottomLabel);
      }
      
      override public function commitProperties() : void
      {
         var reason:String = ShopUtil.canCurrentUserBuyProductBasedOnExperienceReason(this._base);
         this.bottomLabel.text = reason;
         if(reason == ShopUtil.REASON_SOLD_OUT)
         {
            this.topLabel.text = "SOLD OUT";
         }
         else
         {
            this.topLabel.text = "LOCKED";
         }
      }
      
      override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         GraphicUtil.centerHorizontallyInto(this.topLabel,0,unscaledWidth,true);
         GraphicUtil.centerHorizontallyInto(this.bottomLabel,0,unscaledWidth,true);
         this.topLabel.y = Math.floor(unscaledHeight / 2 - this.topLabel.height) + 4;
         this.bottomLabel.y = this.topLabel.y + this.topLabel.height - 5;
      }
      
      public function set catalogProductBase(base:CatalogProductBase) : void
      {
         this._base = base;
         invalidateProperties();
         invalidateDisplayList();
      }
   }
}
