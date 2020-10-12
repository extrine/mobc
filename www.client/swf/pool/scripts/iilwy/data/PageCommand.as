package iilwy.data
{
   public class PageCommand
   {
       
      
      public var pageClassType:Class;
      
      public var data:Object;
      
      public var url:String = "";
      
      public var path:Array;
      
      public var subPath:Array;
      
      public var eventType:String;
      
      public var eventParam:String;
      
      public var eventClass:Class;
      
      public var loginConditional:Boolean;
      
      public function PageCommand()
      {
         this.data = new Object();
         this.path = [];
         this.subPath = [];
         super();
      }
      
      public function shuffleSubPathLeft() : String
      {
         var item:String = null;
         if(this.subPath.length > 0)
         {
            item = this.subPath.shift();
         }
         if(item)
         {
            this.path.push(item);
         }
         return item;
      }
      
      public function shuffleSubPathRight() : String
      {
         var item:String = null;
         if(this.path.length > 0)
         {
            item = this.path.pop();
         }
         if(item)
         {
            this.subPath.unshift(item);
         }
         return item;
      }
      
      public function copy(from:PageCommand) : void
      {
         this.pageClassType = from.pageClassType;
         this.url = from.url;
         this.path = from.path.concat();
         this.subPath = from.subPath.concat();
         this.eventType = from.eventType;
         this.eventParam = from.eventParam;
         this.eventClass = from.eventClass;
      }
      
      public function clone() : PageCommand
      {
         var result:PageCommand = new PageCommand();
         result.copy(this);
         return result;
      }
   }
}
