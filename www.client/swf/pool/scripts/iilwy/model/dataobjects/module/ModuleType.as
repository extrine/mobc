package iilwy.model.dataobjects.module
{
   public class ModuleType
   {
      
      public static const TYPE_PAGEVIEW:ModuleType = new ModuleType("pageView","pageviews");
      
      public static const TYPE_POPUP:ModuleType = new ModuleType("popup","popups");
       
      
      public var id:String;
      
      public var directory:String;
      
      public function ModuleType(id:String, directory:String)
      {
         super();
         this.id = id;
         this.directory = directory;
      }
   }
}
