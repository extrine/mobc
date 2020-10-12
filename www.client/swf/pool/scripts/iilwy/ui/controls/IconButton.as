package iilwy.ui.controls
{
   import iilwy.display.core.TooltipManager;
   
   public class IconButton extends SimpleButton
   {
       
      
      public function IconButton(icon:Class = null, x:Number = 0, y:Number = 0, width:Number = 16, height:Number = 16, styleID:String = "iconButton")
      {
         super("",x,y,width,height,styleID);
         this.cornerRadius = height;
         this.tooltipDelay = TooltipManager.DELAY_MINIMUM;
         this.icon = icon;
         _skin.useStaticCache = true;
      }
   }
}
