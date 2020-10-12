package iilwy.ui.partials.badges
{
   import flash.display.BitmapData;
   import flash.events.MouseEvent;
   import iilwy.managers.GraphicManager;
   import iilwy.model.dataobjects.chat.ChatUser;
   import iilwy.utils.BitmapCache;
   
   public class FacebookBadge extends AbstractBadge
   {
      
      private static const CACHE_ID:String = "facebookIcon";
      
      private static var staticCache:BitmapCache;
       
      
      protected var _chatUser:ChatUser;
      
      public function FacebookBadge()
      {
         super();
         if(!staticCache)
         {
            staticCache = new BitmapCache(1);
         }
         removeEventListener(MouseEvent.CLICK,this.onClick);
         buttonMode = false;
         useHandCursor = false;
      }
      
      public function get chatUser() : ChatUser
      {
         return this._chatUser;
      }
      
      public function set chatUser(value:ChatUser) : void
      {
         this._chatUser = value;
         invalidateSize();
         invalidateDisplayList();
         invalidateProperties();
      }
      
      override public function commitProperties() : void
      {
         var classAsset:Class = null;
         var bd:BitmapData = this._chatUser && this._chatUser.isFacebookUser()?staticCache.getItem(CACHE_ID):null;
         if(!bd)
         {
            classAsset = this._chatUser && this._chatUser.isFacebookUser()?GraphicManager.facebookIcon:null;
            bd = loadBitmap(classAsset);
            if(!bd)
            {
               return;
            }
            staticCache.addItem(CACHE_ID,bd);
         }
         bitmap.bitmapData = bd;
      }
      
      override public function measure() : void
      {
         if(!this._chatUser || !this._chatUser.isFacebookUser())
         {
            measuredHeight = 0;
            measuredWidth = 0;
         }
         else
         {
            super.measure();
         }
      }
      
      override protected function onClick(event:MouseEvent) : void
      {
      }
   }
}
