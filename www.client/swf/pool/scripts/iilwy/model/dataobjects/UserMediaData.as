package iilwy.model.dataobjects
{
   import iilwy.net.MediaProxy;
   
   public class UserMediaData
   {
       
      
      public var photos:Array;
      
      public var loaded:Boolean = false;
      
      public function UserMediaData()
      {
         this.photos = [];
         super();
      }
      
      public function get visiblePhotos() : Array
      {
         var mi:MediaItemData = null;
         var arr:Array = new Array();
         for(var i:Number = 0; i < this.photos.length; i++)
         {
            mi = this.photos[i];
            if(mi.visible)
            {
               arr.push(mi);
            }
         }
         return arr;
      }
      
      public function get isValid() : Boolean
      {
         return this.loaded;
      }
      
      public function addPhoto(mi:MediaItemData) : MediaItemData
      {
         if(this.indexOfPhoto(mi.url) == -1)
         {
            this.photos.unshift(mi);
            return mi;
         }
         throw new Error("An image of that url already exists");
      }
      
      public function removePhoto(mi:MediaItemData) : MediaItemData
      {
         var index:Number = this.indexOfPhoto(mi.url);
         if(index >= 0)
         {
            this.photos.splice(index,1);
            return mi;
         }
         throw new Error("That image is not in the photos array");
      }
      
      public function indexOfPhoto(url:String) : Number
      {
         var mi:MediaItemData = null;
         var index:Number = -1;
         for(var i:Number = 0; i < this.photos.length; i++)
         {
            mi = this.photos[i];
            if(MediaProxy.url(mi.url,MediaProxy.SIZE_ORIGINAL) == MediaProxy.url(url,MediaProxy.SIZE_ORIGINAL))
            {
               index = i;
            }
         }
         return index;
      }
      
      public function setPhotoVisibility(item:MediaItemData, visible:Boolean) : void
      {
         var mi:MediaItemData = null;
         var index:Number = this.indexOfPhoto(item.url);
         if(index >= 0)
         {
            mi = this.photos[index];
            mi.visible = visible;
            return;
         }
         throw new Error("That photo is not in the collection");
      }
   }
}
