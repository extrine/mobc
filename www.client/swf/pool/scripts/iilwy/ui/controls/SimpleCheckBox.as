package iilwy.ui.controls
{
   import iilwy.ui.utils.Margin;
   
   public class SimpleCheckBox extends CheckBox
   {
       
      
      public function SimpleCheckBox(x:Number = 0, y:Number = 0, styleId:String = "simpleButtonDark")
      {
         super(x,y,styleId);
         iconPadding = new Margin(6,6,6,6);
      }
   }
}
