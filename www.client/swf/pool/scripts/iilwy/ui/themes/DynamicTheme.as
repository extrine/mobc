package iilwy.ui.themes
{
   public class DynamicTheme extends BaseTheme
   {
       
      
      protected var extraDescriptor;
      
      public function DynamicTheme(name:String, extraDescriptor:*)
      {
         super("dynamicTheme_" + name);
         this.extraDescriptor = extraDescriptor;
         super.process();
      }
      
      override protected function process() : void
      {
      }
      
      override protected function defineDescriptor() : void
      {
         super.defineDescriptor();
         themeDescriptors.push(this.extraDescriptor);
      }
   }
}
