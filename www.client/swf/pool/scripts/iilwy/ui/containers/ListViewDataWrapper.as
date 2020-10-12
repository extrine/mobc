package iilwy.ui.containers
{
   public class ListViewDataWrapper
   {
      
      public static var uidIndex:Number = 0;
       
      
      public var data;
      
      public var uid:Number;
      
      public function ListViewDataWrapper(data:*)
      {
         super();
         this.data = data;
         this.uid = ListViewDataWrapper.uidIndex++;
      }
   }
}
