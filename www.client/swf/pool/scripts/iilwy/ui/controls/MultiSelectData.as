package iilwy.ui.controls
{
   public class MultiSelectData
   {
       
      
      public var label:String;
      
      public var value:String;
      
      public var tooltip:String;
      
      public var icon:Class;
      
      public var disabled:Boolean = false;
      
      public function MultiSelectData(label:String = null, value:String = null, icon:Class = null, tooltip:String = null, disabled:Boolean = false)
      {
         super();
         this.label = label;
         this.value = value;
         this.tooltip = tooltip;
         this.icon = icon;
         this.disabled = disabled;
      }
   }
}
