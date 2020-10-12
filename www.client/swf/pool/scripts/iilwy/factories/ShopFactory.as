package iilwy.factories
{
   import iilwy.collections.PagingArrayCollection;
   import iilwy.model.dataobjects.shop.ProductCategory;
   import iilwy.model.dataobjects.shop.ProductPage;
   import iilwy.model.dataobjects.shop.ProductShop;
   
   public class ShopFactory
   {
       
      
      public function ShopFactory()
      {
         super();
      }
      
      public static function createShops(data:Object) : Array
      {
         var merbCollection:Object = null;
         var shopData:Object = null;
         var shop:ProductShop = null;
         var merbCollections:Array = data.product_collections;
         var shops:Array = [];
         for each(merbCollection in merbCollections)
         {
            shopData = {"product_collection":merbCollection};
            shop = createShop(shopData);
            shops.push(shop);
         }
         return shops;
      }
      
      public static function createShop(data:Object) : ProductShop
      {
         var categoryData:Object = null;
         data = data.product_collection;
         var shop:ProductShop = new ProductShop();
         shop.id = int(data.id);
         shop.key = data.external_key;
         shop.name = data.name;
         shop.iconURL = data.icon_url;
         shop.imageURL = data.image_url;
         shop.gameUID = data.game_id;
         var allCategory:Object = {
            "name":"All",
            "id":-1,
            "icon_url":"",
            "selection_limit":1,
            "external_key":"all"
         };
         shop.categories = [createCategory(allCategory)];
         for each(categoryData in data.categories)
         {
            shop.categories.push(createCategory(categoryData));
         }
         shop.themeDescriptor = data.theme;
         return shop;
      }
      
      public static function createInventoryCategory() : ProductCategory
      {
         var invCategory:Object = {
            "name":"My Inventory",
            "id":-2,
            "icon_url":"",
            "selection_limit":1,
            "external_key":"inventory"
         };
         return createCategory(invCategory);
      }
      
      public static function createCategory(data:Object) : ProductCategory
      {
         var tagTypeData:Object = null;
         var tagData:Object = null;
         var category:ProductCategory = new ProductCategory();
         category.id = int(data.id);
         category.key = data.external_key;
         category.name = data.name;
         category.description = data.description;
         category.iconURL = data.icon_url;
         category.selectionLimit = data.selection_limit;
         category.deselectable = !!data.hasOwnProperty("deselectable")?Boolean(data.deselectable):Boolean(true);
         category.isPreviewable = data.previewable;
         category.isGiftable = data.giftable;
         category.tagTypes = [];
         for each(tagTypeData in data.tag_types)
         {
            category.tagTypes.push(ProductFactory.createProductTagType(tagTypeData));
         }
         category.tags = [];
         for each(tagData in data.tags)
         {
            category.tags.push(ProductFactory.createProductTag(tagData));
         }
         return category;
      }
      
      public static function createProductPage(data:Object, limit:int, offset:int) : ProductPage
      {
         var item:Object = null;
         var productPage:ProductPage = new ProductPage();
         productPage.page = offset / limit + 1;
         productPage.numPages = int(data.total_records) / limit + 1;
         if(int(data.total_records) == (productPage.numPages - 1) * limit)
         {
            productPage.numPages = productPage.numPages - 1;
         }
         var products:PagingArrayCollection = new PagingArrayCollection();
         products.offset = offset;
         for each(item in data.product_bases)
         {
            products.addItem(ProductFactory.createCatalogProductBase(item));
         }
         productPage.items = products;
         return productPage;
      }
   }
}
