package iilwy.model.dataobjects.promo.enum.popup
{
   public class ButtonDefinition
   {
      
      public static const TYPE_CLOSE:String = "close";
      
      public static const TYPE_SKIP:String = "skip";
       
      
      public var id:String;
      
      public var label:String;
      
      public var navData:XMLList;
      
      public var hilight:Boolean;
      
      public var clickAction:String;
      
      public function ButtonDefinition(id:String, label:String = null, navData:XMLList = null, hilght:Boolean = false, clickAction:String = null)
      {
         super();
         this.id = id;
         this.label = label;
         this.navData = navData;
         this.hilight = this.hilight;
         this.clickAction = clickAction;
      }
   }
}
