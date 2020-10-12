package iilwy.ui.controls
{
   import iilwy.namespaces.omgpop_internal;
   import iilwy.ui.utils.Margin;
   
   use namespace omgpop_internal;
   
   public class CheckBox extends AbstractOptionButton
   {
       
      
      [Embed(symbol="iconCheck2",source="/../assets/website/vector/icons.swf")]
      private var iconCheck2:Class;
      
      public function CheckBox(x:Number = 0, y:Number = 0, styleID:String = "checkBox")
      {
         this.iconCheck2 = CheckBox_iconCheck2;
         super(x,y,styleID);
         iconClass = this.iconCheck2;
         iconPadding = new Margin(5,5,5,5);
      }
      
      public function get group() : CheckBoxGroup
      {
         return buttonGroup as CheckBoxGroup;
      }
      
      public function set group(value:CheckBoxGroup) : void
      {
         buttonGroup = value;
      }
   }
}
