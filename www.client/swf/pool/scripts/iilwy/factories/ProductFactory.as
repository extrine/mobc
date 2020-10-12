package iilwy.factories
{
   import com.adobe.utils.DateUtil;
   import iilwy.collections.ArrayCollection;
   import iilwy.model.dataobjects.shop.CatalogProduct;
   import iilwy.model.dataobjects.shop.CatalogProductBase;
   import iilwy.model.dataobjects.shop.InventoryProduct;
   import iilwy.model.dataobjects.shop.InventoryProductCollection;
   import iilwy.model.dataobjects.shop.ProductGift;
   import iilwy.model.dataobjects.shop.ProductInventory;
   import iilwy.model.dataobjects.shop.ProductMetadata;
   import iilwy.model.dataobjects.shop.ProductTag;
   import iilwy.model.dataobjects.shop.ProductTagType;
   import iilwy.model.dataobjects.shop.ProductTransaction;
   import iilwy.model.dataobjects.shop.enum.ProductPurchaseType;
   import iilwy.utils.logging.Logger;
   
   public class ProductFactory
   {
       
      
      public function ProductFactory()
      {
         super();
      }
      
      public static function createCatalogProductBaseCollection(products:Array) : ArrayCollection
      {
         var item:Object = null;
         var catalogProductBaseCollection:ArrayCollection = new ArrayCollection();
         for each(item in products)
         {
            catalogProductBaseCollection.addItem(createCatalogProductBase(item));
         }
         return catalogProductBaseCollection;
      }
      
      public static function createCatalogProductBase(data:Object) : CatalogProductBase
      {
         var tagData:Object = null;
         var limited:Boolean = false;
         var catalogProduct:CatalogProduct = null;
         var defaultProduct:CatalogProduct = null;
         var productData:Object = null;
         var catalogProductBase:CatalogProductBase = new CatalogProductBase();
         if(data.product_category)
         {
            catalogProductBase.category = ShopFactory.createCategory(data.product_category);
            catalogProductBase.categoryID = data.product_category_id;
            catalogProductBase.categoryKey = data.product_category.external_key;
            catalogProductBase.categoryName = data.product_category.name;
            if(data.product_category.product_collection)
            {
               catalogProductBase.collectionID = data.product_category.product_collection.id;
               catalogProductBase.collectionKey = data.product_category.product_collection.external_key;
               catalogProductBase.collectionName = data.product_category.product_collection.name;
            }
            else
            {
               catalogProductBase.collectionID = data.product_category.product_collection_id;
            }
         }
         if(data.product_collection)
         {
            catalogProductBase.collectionID = data.product_collection.id;
            catalogProductBase.collectionKey = data.product_collection.external_key;
            catalogProductBase.collectionName = data.product_collection.name;
         }
         catalogProductBase.description = data.description;
         catalogProductBase.id = data.id;
         catalogProductBase.name = data.name;
         catalogProductBase.imageURL = data.image_url;
         catalogProductBase.assetURL = data.asset_url;
         catalogProductBase.tags = [];
         for each(tagData in data.tags)
         {
            catalogProductBase.tags.push(createProductTag(tagData));
         }
         catalogProductBase.minimumPremiumLevel = data.minimum_premium_level;
         catalogProductBase.minimumExperienceLevel = data.minimum_site_level;
         catalogProductBase.minimumGameExperienceLevel = data.minimum_game_level;
         catalogProductBase.minimumGameFriends = data.minimum_game_friends;
         catalogProductBase.minimumRecruits = data.minimum_recruits;
         catalogProductBase.facebookFanRequired = data.facebook_fan_required == "true";
         catalogProductBase.popText = data.pop_text;
         catalogProductBase.purchasable = data.purchasable;
         if(data.catalog_meta)
         {
            catalogProductBase.meta = createProductMetadata(catalogProductBase.name,data.catalog_meta);
         }
         catalogProductBase.products = [];
         for each(productData in data.products)
         {
            catalogProduct = createCatalogProduct(productData);
            catalogProductBase.products.push(catalogProduct);
            if(!defaultProduct || !defaultProduct.purchasable && catalogProduct.purchasable)
            {
               defaultProduct = catalogProduct;
            }
         }
         if(defaultProduct)
         {
            catalogProductBase.defaultProduct = defaultProduct;
            if(defaultProduct.purchaseType == ProductPurchaseType.EXPIRABLE)
            {
               catalogProductBase.popText = defaultProduct.packQuantity + " DAYS";
            }
         }
         if(!isNaN(catalogProductBase.stockQuantity) && catalogProductBase.stockQuantity < 200 && catalogProductBase.stockQuantity > 0)
         {
            catalogProductBase.popText = catalogProductBase.stockQuantity + " LEFT";
         }
         return catalogProductBase;
      }
      
      public static function createCatalogProduct(data:Object) : CatalogProduct
      {
         var product:CatalogProduct = new CatalogProduct();
         product.id = data.id;
         product.name = data.name;
         product.packQuantity = data.pack_quantity;
         product.units = "Day";
         product.acquirable = data.acquirable;
         product.acquireLimit = data.acquire_limit;
         product.price = data.price;
         product.productType = data.product_type;
         product.purchasable = data.purchasable;
         product.purchaseLimit = data.purchase_limit;
         if(data.stock_quantity != null)
         {
            product.stockQuantity = data.stock_quantity;
         }
         product.purchaseType = data.product_type;
         product.sellbackSoftAmount = data.sell_back_coin_amount;
         product.sellbackCurrencyType = data.sell_back_currency_type;
         product.currencyType = data.currency_type;
         product.imageURL = data.image_url;
         return product;
      }
      
      public static function createInventoryProductCollection(products:Array) : InventoryProductCollection
      {
         var item:Object = null;
         var productCollection:InventoryProductCollection = new InventoryProductCollection();
         for each(item in products)
         {
            productCollection.addItem(createInventoryProduct(item));
         }
         return productCollection;
      }
      
      public static function createInventoryProduct(data:Object) : InventoryProduct
      {
         var product:InventoryProduct = new InventoryProduct();
         product.id = data.id;
         product.active = data.active;
         product.packQuantity = data.pack_quantity;
         product.units = "Day";
         product.shopID = data.product_collection_id;
         product.autoRenew = data.renew;
         product.quantity = Boolean(data.quantity)?Number(data.quantity):Number(undefined);
         if(data.last_purchased_at)
         {
            product.purchaseDate = DateUtil.parseW3CDTF(data.last_purchased_at);
         }
         if(data.expires_at)
         {
            product.expirationDate = DateUtil.parseW3CDTF(data.expires_at);
         }
         if(data.product)
         {
            product.catalogProduct = createCatalogProduct(data.product);
         }
         if(data.product_base)
         {
            product.catalogProductBase = createCatalogProductBase(data.product_base);
            if(data.inventory_meta)
            {
               product.meta = createProductMetadata(product.catalogProductBase.name,data.inventory_meta);
            }
         }
         try
         {
            product.inventoryMetadata = JSON.decode(data.inventory_meta,false);
         }
         catch(error:Error)
         {
         }
         product.purchaseType = data.product_type;
         product.sellbackSoftAmount = data.sell_back_coin_amount;
         return product;
      }
      
      public static function createProductGift(data:*) : ProductGift
      {
         var result:ProductGift = null;
         result = new ProductGift();
         result.id = data.id;
         result.status = data.status;
         if(data.product)
         {
            result.inventoryProduct = createInventoryProduct(data.product);
         }
         if(data.product_base)
         {
            result.catalogProductBase = createCatalogProductBase(data.product_base);
         }
         try
         {
            result.meta = JSON.decode(data.gift_meta,false);
         }
         catch(error:Error)
         {
            result.meta = data.gift_meta;
         }
         return result;
      }
      
      public static function createProductTagType(data:Object) : ProductTagType
      {
         var tagType:ProductTagType = new ProductTagType();
         tagType.id = data.id;
         tagType.name = data.name;
         return tagType;
      }
      
      public static function createProductTag(data:Object) : ProductTag
      {
         var tag:ProductTag = new ProductTag();
         tag.id = data.id;
         tag.name = data.name;
         if(data.tag_type)
         {
            tag.type = createProductTagType(data.tag_type);
         }
         tag.description = data.description;
         if(data.tag_meta)
         {
            tag.meta = createProductMetadata(tag.name,data.tag_meta);
         }
         return tag;
      }
      
      public static function createProductMetadata(name:String, data:String) : ProductMetadata
      {
         var meta:Object = null;
         try
         {
            meta = JSON.decode(data,false);
         }
         catch(error:Error)
         {
            Logger.getLogger("ProductFactory").log("Error parsing " + name + ", please send feedback about this issue.");
         }
         return new ProductMetadata(name,meta);
      }
      
      public static function createProductInventory(data:Object) : ProductInventory
      {
         var shopID:* = null;
         var dataProducts:Array = null;
         var productCollection:InventoryProductCollection = null;
         var productData:Object = null;
         var inventoryProduct:InventoryProduct = null;
         var inventory:ProductInventory = new ProductInventory();
         for(shopID in data)
         {
            dataProducts = data[shopID];
            productCollection = inventory.getProductCollection(int(shopID));
            for each(productData in dataProducts)
            {
               inventoryProduct = createInventoryProduct(productData);
               productCollection.addItem(inventoryProduct);
            }
         }
         return inventory;
      }
      
      public static function createProductInventoryFromArrayOfInventoryProducts(data:Array) : ProductInventory
      {
         var inventoryProduct:InventoryProduct = null;
         var collection:InventoryProductCollection = null;
         var hash:Object = {};
         var inventory:ProductInventory = new ProductInventory();
         for each(inventoryProduct in data)
         {
            collection = inventory.getProductCollection(inventoryProduct.shopID);
            collection.addItem(inventoryProduct);
         }
         return inventory;
      }
      
      public static function createProductInventoryFromArray(data:Array) : ProductInventory
      {
         var productData:Object = null;
         var inventoryProduct:InventoryProduct = null;
         var collection:InventoryProductCollection = null;
         var inventory:ProductInventory = new ProductInventory();
         for each(productData in data)
         {
            inventoryProduct = createInventoryProduct(productData);
            collection = inventory.getProductCollection(inventoryProduct.shopID);
            collection.addItem(inventoryProduct);
         }
         return inventory;
      }
      
      public static function deserializeProductInventory(obj:*) : ProductInventory
      {
         return null;
      }
      
      public static function serializeCatalogProductBaseCollection(collection:ArrayCollection) : Array
      {
         var base:CatalogProductBase = null;
         var result:Array = [];
         for each(base in collection.source)
         {
            result.push(serializeCatalogProductBase(base));
         }
         return result;
      }
      
      public static function serializeProductInventory(inventory:ProductInventory) : Object
      {
         var shopID:int = 0;
         var dataProducts:Array = null;
         var productCollection:InventoryProductCollection = null;
         var product:InventoryProduct = null;
         var ids:Array = inventory.getShopIDs();
         var result:Object = {};
         for each(shopID in ids)
         {
            dataProducts = [];
            productCollection = inventory.getProductCollection(shopID);
            for each(product in productCollection.source)
            {
               dataProducts.push(serializeInventoryProduct(product));
            }
            result[shopID] = dataProducts;
         }
         return result;
      }
      
      public static function deserializeInventoryProduct(obj:*) : InventoryProduct
      {
         var product:InventoryProduct = new InventoryProduct();
         product.catalogProductBase = deserializeCatalogProductBase(obj.base);
         return product;
      }
      
      public static function serializeInventoryProduct(product:InventoryProduct) : Object
      {
         var result:Object = {
            "base":serializeCatalogProductBase(product.catalogProductBase),
            "itemID":product.id
         };
         if(product.purchaseType == ProductPurchaseType.PERMANENT_QUANTITY)
         {
            result.quantity = product.quantity;
         }
         return result;
      }
      
      public static function deserializeCatalogProductBase(obj:*) : CatalogProductBase
      {
         var base:CatalogProductBase = new CatalogProductBase();
         base.id = obj.id;
         base.name = obj.name;
         base.imageURL = obj.image;
         base.categoryKey = obj.category;
         if(obj.meta)
         {
            base.meta = new ProductMetadata(obj.meta.name,obj.meta);
         }
         if(obj.asset)
         {
            base.assetURL = obj.asset;
         }
         if(obj.price)
         {
            base.defaultProduct = new CatalogProduct();
            base.defaultProduct.price = obj.price;
         }
         return base;
      }
      
      public static function serializeCatalogProductBase(product:CatalogProductBase) : Object
      {
         var result:Object = null;
         if(!product)
         {
            return {};
         }
         result = {
            "id":product.id,
            "name":product.name,
            "image":product.imageURL,
            "category":product.categoryKey
         };
         if(product.meta)
         {
            result.meta = product.meta.data;
         }
         if(product.assetURL)
         {
            result.asset = product.assetURL;
         }
         if(product.defaultProduct)
         {
            if(product.defaultProduct.price >= 0)
            {
               result.price = product.defaultProduct.price;
            }
         }
         return result;
      }
      
      public static function createProductTransaction(data:*) : ProductTransaction
      {
         var result:ProductTransaction = new ProductTransaction();
         result.id = data.coin_transaction_id;
         result.productID = data.product_id;
         return result;
      }
   }
}
