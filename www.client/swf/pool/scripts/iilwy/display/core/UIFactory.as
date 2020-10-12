package iilwy.display.core
{
   import flash.utils.Dictionary;
   import iilwy.display.user.listitems.FeedItem;
   import iilwy.ui.containers.Pane;
   import iilwy.ui.controls.Label;
   import iilwy.ui.controls.UiElement;
   import iilwy.utils.ItemFactory;
   
   public class UIFactory
   {
       
      
      private var paneFactory:ItemFactory;
      
      private var labelFactory:ItemFactory;
      
      private var feedFactory:ItemFactory;
      
      public var factoryDictionary:Dictionary;
      
      public function UIFactory()
      {
         super();
         this.paneFactory = new ItemFactory(Pane);
         this.labelFactory = new ItemFactory(Label);
         this.feedFactory = new ItemFactory(FeedItem);
         this.factoryDictionary = new Dictionary();
         this.factoryDictionary[Label] = this.labelFactory;
         this.factoryDictionary[Pane] = this.paneFactory;
         this.factoryDictionary[FeedItem] = this.feedFactory;
      }
      
      public function createPane() : Pane
      {
         return this.paneFactory.createItem();
      }
      
      public function createItem(classType:*) : *
      {
         var obj:* = undefined;
         var factory:ItemFactory = this.factoryDictionary[classType];
         if(factory)
         {
            obj = factory.createItem();
            return obj;
         }
         throw new Error("UIFactory does not support that class type");
      }
      
      public function recycleItem(obj:*, classType:*) : *
      {
         var _loc3_:ItemFactory = this.factoryDictionary[classType];
         if(_loc3_)
         {
            obj = _loc3_.recycleItem(obj);
            return obj;
         }
         throw new Error("UIFactory does not support that class type");
      }
      
      public function getFactory(classType:*) : ItemFactory
      {
         var factory:ItemFactory = this.factoryDictionary[classType];
         if(factory)
         {
            return factory;
         }
         throw new Error("UIFactory does not support that class type");
      }
      
      protected function prebuildItem(classType:*) : void
      {
         var factory:ItemFactory = this.factoryDictionary[classType];
         var obj:UiElement = new classType();
         obj.validate();
         factory.recycleItem(obj);
      }
   }
}
