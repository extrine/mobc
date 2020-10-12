package iilwy.model.dataobjects.avatar
{
   import flash.events.EventDispatcher;
   import iilwy.model.dataobjects.market.product.Product;
   import iilwy.model.dataobjects.market.product.ProductCollection;
   
   public class BasicAvatar extends EventDispatcher
   {
       
      
      public var avatarParts:ProductCollection;
      
      public var avatarInfo:AvatarInfo;
      
      public function BasicAvatar()
      {
         super();
      }
      
      public function set pack(avatarPack:AvatarPack) : void
      {
         if(avatarPack.itemList && avatarPack.itemList)
         {
            this.avatarInfo = avatarPack.info;
            this.avatarParts = avatarPack.itemList;
         }
      }
      
      public function getAsParams() : Array
      {
         var entry:Object = null;
         var focus:Product = null;
         var result:Array = new Array();
         var length:int = this.avatarParts.length;
         for(var i:int = 0; i < length; i++)
         {
            entry = new Object();
            focus = this.avatarParts.source[i];
            entry.id = focus.id;
            entry.instance_meta = focus.instanceMetadata.data;
            result.push(entry);
         }
         return result;
      }
      
      public function getIDList() : Array
      {
         var focus:Product = null;
         var result:Array = new Array();
         var length:int = this.avatarParts.length;
         for(var i:int = 0; i < length; i++)
         {
            focus = this.avatarParts.source[i];
            result.push(focus.id);
         }
         return result;
      }
      
      public function clone() : BasicAvatar
      {
         var i:int = 0;
         var focus:Product = null;
         var info:AvatarInfo = null;
         var makeClone:BasicAvatar = new BasicAvatar();
         var parts:ProductCollection = new ProductCollection();
         if(this.avatarParts)
         {
            for(i = 0; i < this.avatarParts.length; i++)
            {
               focus = this.avatarParts.source[i].clone();
               parts.addItem(focus);
            }
         }
         if(info)
         {
            info = this.avatarInfo.clone();
         }
         makeClone.avatarInfo = info;
         makeClone.avatarParts = parts;
         return makeClone;
      }
      
      public function getByID(id:String) : void
      {
      }
      
      public function add(item:Product) : void
      {
         this.avatarParts.addItem(item);
      }
      
      public function remove(id:int) : void
      {
         this.avatarParts.removeProductByID(id);
      }
      
      public function moveUp(id:int) : void
      {
         this.avatarParts.moveUp(id);
      }
      
      public function moveDown(id:int) : void
      {
         this.avatarParts.moveDown(id);
      }
   }
}
