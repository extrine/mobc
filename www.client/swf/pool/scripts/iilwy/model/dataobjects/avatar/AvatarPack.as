package iilwy.model.dataobjects.avatar
{
   import iilwy.model.dataobjects.market.product.Product;
   import iilwy.model.dataobjects.market.product.ProductCollection;
   
   public class AvatarPack
   {
       
      
      public var itemList:ProductCollection;
      
      public var info:AvatarInfo;
      
      public var data;
      
      public function AvatarPack(input:*)
      {
         super();
         this.data = input;
         this.parseAsObject();
      }
      
      public function parseAsObject() : void
      {
         var length:int = 0;
         var i:int = 0;
         var focus:Object = null;
         var entry:Product = null;
         this.info = new AvatarInfo();
         this.info.avatarName = this.data.name;
         this.info.avatarID = this.data.id;
         this.info.filename = this.data.filename;
         if(this.data.items)
         {
            length = this.data.items.length;
            this.itemList = new ProductCollection();
            for(i = 0; i < length; i++)
            {
               focus = this.data.items[i];
               entry = new Product();
               entry.setData(focus);
               this.itemList.addItem(entry);
            }
         }
      }
   }
}
