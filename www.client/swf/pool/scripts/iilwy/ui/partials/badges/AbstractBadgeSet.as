package iilwy.ui.partials.badges
{
   import iilwy.ui.containers.UiContainer;
   
   public class AbstractBadgeSet extends UiContainer
   {
       
      
      protected var premiumBadge:PremiumBadge;
      
      public function AbstractBadgeSet()
      {
         super();
         this.premiumBadge = new PremiumBadge();
         addContentChild(this.premiumBadge);
         setMargin(4,0,0,5);
      }
      
      public function get level() : Number
      {
         return this.premiumBadge.level;
      }
      
      public function set level(value:Number) : void
      {
         this.premiumBadge.level = value;
         invalidateSize();
         invalidateDisplayList();
      }
      
      override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
      }
      
      override public function measure() : void
      {
         measuredWidth = this.premiumBadge.width;
         measuredHeight = this.premiumBadge.height;
      }
   }
}
