package iilwy.ui.partials.badges
{
   import iilwy.application.AppProperties;
   import iilwy.model.dataobjects.chat.ChatUser;
   
   public class ChatUserBadgeSet extends AbstractBadgeSet
   {
       
      
      protected var facebookBadge:FacebookBadge;
      
      public function ChatUserBadgeSet()
      {
         super();
         this.facebookBadge = new FacebookBadge();
         addContentChild(this.facebookBadge);
      }
      
      public function get chatUser() : ChatUser
      {
         return this.facebookBadge.chatUser;
      }
      
      public function set chatUser(value:ChatUser) : void
      {
         if(AppProperties.fbDefined)
         {
            this.facebookBadge.chatUser = value;
         }
         invalidateSize();
         invalidateDisplayList();
      }
      
      override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         var margin:Number = premiumBadge.width > 0?Number(this.facebookBadge.margin.left):Number(0);
         this.facebookBadge.x = premiumBadge.width + margin;
      }
      
      override public function measure() : void
      {
         measuredWidth = premiumBadge.width + this.facebookBadge.width;
         measuredHeight = Math.max(premiumBadge.height,this.facebookBadge.height);
      }
   }
}
