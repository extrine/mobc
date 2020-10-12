package iilwy.model.dataobjects.market.product
{
   import com.adobe.utils.DateUtil;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class Product extends EventDispatcher
   {
       
      
      protected const MONTHS:Array = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];
      
      public var instanceMetadata:ProductMetadata;
      
      public var metadata:ProductMetadata;
      
      public var id:int;
      
      public var developerID:int;
      
      public var gameID:String;
      
      public var name:String;
      
      public var filename:String;
      
      public var category:String;
      
      public var usedByRoom:Boolean;
      
      public var usedByAvatar:Boolean;
      
      public var usedByGame:Boolean;
      
      public var price:int;
      
      public var quantityOriginal:int;
      
      public var quantityRemaining:int;
      
      public var forSale:Boolean;
      
      public var approved:Boolean;
      
      public var gender:int;
      
      public var inUse:Boolean;
      
      public var createdDate:Date;
      
      public var baseItemID:int;
      
      public var purchaseDate:Date;
      
      public var active:Boolean;
      
      public var deleted:Boolean;
      
      public var defaultX:int;
      
      public var defaultY:int;
      
      public var x:int;
      
      public var y:int;
      
      public var movable:Boolean;
      
      public function Product()
      {
         super();
      }
      
      public function get assetFilename() : String
      {
         return this.filename;
      }
      
      public function get priceString() : String
      {
         return Boolean(this.price)?this.formatPrice(this.price):null;
      }
      
      public function get limited() : Boolean
      {
         return Boolean(this.quantityOriginal)?Boolean(true):Boolean(false);
      }
      
      public function get createdDateString() : String
      {
         return Boolean(this.createdDate)?this.MONTHS[this.createdDate.month] + " " + this.createdDate.date + ", " + this.createdDate.fullYear:null;
      }
      
      public function get purchaseDateString() : String
      {
         return Boolean(this.purchaseDate)?this.MONTHS[this.purchaseDate.month] + " " + this.purchaseDate.date + ", " + this.purchaseDate.fullYear:null;
      }
      
      public function setData(data:*) : void
      {
         this.setMetadata(data);
         this.setProperties(data);
      }
      
      protected function setMetadata(data:*) : void
      {
         var instanceMeta:Object = null;
         var meta:Object = null;
         if(data.instance_meta)
         {
            instanceMeta = data.instance_meta is String?JSON.deserialize(data.instance_meta):data.instance_meta;
         }
         else if(data.default_instance_meta)
         {
            instanceMeta = data.default_instance_meta is String?JSON.deserialize(data.default_instance_meta):data.default_instance_meta;
         }
         if(data.base_item_meta)
         {
            meta = data.base_item_meta is String?JSON.deserialize(data.base_item_meta):data.base_item_meta;
         }
         else if(data.meta)
         {
            meta = data.meta is String?JSON.deserialize(data.meta):data.meta;
         }
         if(instanceMeta)
         {
            this.instanceMetadata = new ProductMetadata(data.name,instanceMeta);
         }
         if(meta)
         {
            this.metadata = new ProductMetadata(data.name,meta);
         }
      }
      
      protected function setProperties(data:*) : void
      {
         this.id = data.id;
         this.developerID = data.dev_id;
         this.gameID = data.game_id;
         this.name = data.name;
         this.filename = Boolean(data.filename)?data.filename:Boolean(data.base_item_id)?data.base_item_id:data.id;
         this.category = Boolean(data.category)?data.category:data.group;
         this.usedByRoom = data.used_by_room;
         this.usedByAvatar = data.used_by_avatar;
         this.usedByGame = data.used_by_game;
         this.price = data.price;
         this.quantityOriginal = data.quantity_original;
         this.quantityRemaining = data.quantity_remaining;
         this.forSale = data.for_sale;
         this.approved = data.approved;
         this.gender = data.gender;
         this.createdDate = Boolean(data.created_at)?DateUtil.parseW3CDTF(data.created_at):null;
         this.baseItemID = Boolean(data.base_item_id)?int(data.base_item_id):int(data.id);
         this.purchaseDate = Boolean(data.purchase_date)?DateUtil.parseW3CDTF(data.purchase_date):null;
         this.active = data.active;
         this.deleted = data.deleted;
         if(this.instanceMetadata)
         {
            this.x = this.instanceMetadata.getParamValue("x");
         }
         if(this.instanceMetadata)
         {
            this.y = this.instanceMetadata.getParamValue("y");
         }
         if(this.instanceMetadata)
         {
            this.movable = this.instanceMetadata.getParamValue("movable");
         }
      }
      
      public function dataChanged() : void
      {
         var event:Event = new Event(Event.CHANGE,true);
         dispatchEvent(event);
      }
      
      public function clone() : Product
      {
         var clonedProduct:Product = new Product();
         if(this.instanceMetadata)
         {
            clonedProduct.instanceMetadata = this.instanceMetadata.clone();
         }
         if(this.metadata)
         {
            clonedProduct.metadata = this.metadata.clone();
         }
         clonedProduct.id = this.id;
         clonedProduct.developerID = this.developerID;
         clonedProduct.gameID = this.gameID;
         clonedProduct.name = this.name;
         clonedProduct.filename = this.filename;
         clonedProduct.category = this.category;
         clonedProduct.usedByRoom = this.usedByRoom;
         clonedProduct.usedByAvatar = this.usedByAvatar;
         clonedProduct.usedByGame = this.usedByGame;
         clonedProduct.price = this.price;
         clonedProduct.quantityOriginal = this.quantityOriginal;
         clonedProduct.quantityRemaining = this.quantityRemaining;
         clonedProduct.forSale = this.forSale;
         clonedProduct.approved = this.approved;
         clonedProduct.gender = this.gender;
         clonedProduct.inUse = this.inUse;
         clonedProduct.createdDate = this.createdDate;
         clonedProduct.baseItemID = this.baseItemID;
         clonedProduct.purchaseDate = this.purchaseDate;
         clonedProduct.active = this.active;
         clonedProduct.deleted = this.deleted;
         clonedProduct.x = this.x;
         clonedProduct.y = this.y;
         clonedProduct.movable = this.movable;
         return clonedProduct;
      }
      
      protected function formatPrice(price:int) : String
      {
         var i:int = 0;
         var stringPrice:String = String(price);
         var reorder:Array = new Array();
         var pricelist:Array = stringPrice.split("");
         if(pricelist.length > 3)
         {
            for(i = 0; i < pricelist.length; i++)
            {
               if(i != 0 && (pricelist.length - i) % 3 == 0)
               {
                  reorder.push("," + pricelist[i]);
               }
               else
               {
                  reorder.push(pricelist[i]);
               }
            }
            return reorder.join("");
         }
         return stringPrice;
      }
   }
}
