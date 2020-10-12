package iilwy.ui.controls
{
   import flash.display.BitmapData;
   import flash.filters.GlowFilter;
   import iilwy.ui.themes.Style;
   import iilwy.ui.utils.Skin;
   
   public class SkinButton extends AbstractButton
   {
       
      
      protected var _skin:Skin;
      
      public function SkinButton(label:String, x:Number, y:Number, width:Number, height:Number, styleID:String)
      {
         super(label,x,y,width,height,styleID);
         this._skin = new Skin();
         addChild(this._skin);
         this._skin.renderMethod = this.renderSkinState;
         this._skin.useStaticCache = false;
      }
      
      override public function destroy() : void
      {
         this._skin.destroy();
         super.destroy();
      }
      
      override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         if(useFocusGlow)
         {
            if(focused)
            {
               if(!AbstractButton.focusFilter)
               {
                  AbstractButton.focusFilter = new GlowFilter(13093089,0.4,5,5,4,1,false,false);
               }
               this._skin.filters = [AbstractButton.focusFilter];
            }
            else
            {
               this._skin.filters = [];
            }
         }
      }
      
      override protected function applySubStyle(... options) : void
      {
         this._skin.defaultStyle = style;
         this._skin.setStyle.apply(this._skin,options);
      }
      
      protected function renderSkinState(style:Style) : BitmapData
      {
         return null;
      }
      
      public function get skin() : Skin
      {
         return this._skin;
      }
   }
}
