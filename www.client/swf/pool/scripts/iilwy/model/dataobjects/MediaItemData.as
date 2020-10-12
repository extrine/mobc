package iilwy.model.dataobjects
{
   import iilwy.net.MediaProxy;
   
   public class MediaItemData
   {
       
      
      public var id:String;
      
      public var caption:String = "";
      
      public var url:String;
      
      public var clickURL:String;
      
      public var deleted:Boolean = false;
      
      public var visible:Boolean = true;
      
      public function MediaItemData()
      {
         super();
      }
      
      public static function createFromMerbRequest(data:*) : MediaItemData
      {
         var mi:MediaItemData = new MediaItemData();
         mi.id = data.id;
         mi.caption = data.caption;
         mi.url = data.photo_url;
         mi.deleted = data.deleted == "1"?Boolean(true):Boolean(false);
         mi.visible = !data.privacy;
         return mi;
      }
      
      public static function createListFromMerbRequest(array:Array, includePrivate:Boolean = false) : Array
      {
         var md:MediaItemData = null;
         var result:Array = [];
         for(var i:int = 0; i < array.length; i++)
         {
            md = MediaItemData.createFromMerbRequest(array[i]);
            if(md.visible || includePrivate)
            {
               result.unshift(md);
            }
         }
         return result;
      }
      
      public function initFromJSON(json:Object) : void
      {
         this.id = json.id;
         this.caption = json.caption;
         this.url = json.photo_url;
         this.clickURL = json.click_url;
         this.deleted = json.deleted == "1"?Boolean(true):Boolean(false);
      }
      
      public function initFromUploadedPhotoEvent(json:Object) : void
      {
         this.url = json.e_image;
         this.caption = "";
         this.visible = true;
      }
      
      public function equals(item:MediaItemData) : Boolean
      {
         return this.compareURL(item.url);
      }
      
      public function compareURL(url:String) : Boolean
      {
         if(MediaProxy.url(this.url,MediaProxy.SIZE_ORIGINAL) == MediaProxy.url(url,MediaProxy.SIZE_ORIGINAL))
         {
            return true;
         }
         return false;
      }
   }
}
