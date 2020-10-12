package iilwy.model.dataobjects.promo.enum.popup
{
   public class PopupDefinition
   {
       
      
      public var campaignId:String;
      
      public var width:int;
      
      public var height:int;
      
      public var views:Array;
      
      public var displayInterval:int;
      
      public var styleId:String;
      
      public function PopupDefinition(campaignId:String, width:int = 500, height:int = 400, views:Array = null, displayInterval:int = 0, styleId:String = null)
      {
         super();
         this.campaignId = campaignId;
         this.width = width;
         this.height = height;
         this.views = views;
         this.displayInterval = displayInterval;
         this.styleId = styleId;
      }
      
      public function getViewById(id:String) : PopupViewDefinition
      {
         var view:PopupViewDefinition = null;
         for each(view in this.views)
         {
            if(view.id == id)
            {
               return view;
            }
         }
         return null;
      }
      
      public function getNextViewById(id:String) : PopupViewDefinition
      {
         var view:PopupViewDefinition = null;
         for(var i:int = 0; i < this.views.length; i++)
         {
            view = this.views[i] as PopupViewDefinition;
            if(view.id == id)
            {
               if(i + 1 < this.views.length)
               {
                  return this.views[i + 1];
               }
               return this.views[0];
            }
         }
         return null;
      }
      
      public function get cookieName() : String
      {
         if(!this.campaignId)
         {
            return null;
         }
         return "AUTO_PROMPTED_" + this.campaignId.toUpperCase() + "_POPUP";
      }
   }
}
