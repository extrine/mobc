package iilwy.ui.themes
{
   public class Theme
   {
       
      
      public var name:String = "";
      
      protected var themeDescriptors:Array;
      
      private var colorNames:Array;
      
      private var styles:Array;
      
      private var combinedDescriptor:Object;
      
      public function Theme(name:String)
      {
         this.themeDescriptors = [];
         super();
         this.name = name;
         this.process();
      }
      
      protected function process() : void
      {
         this.defineProperties();
         this.defineDescriptor();
         this.processDescriptor();
      }
      
      protected function defineProperties() : void
      {
      }
      
      protected function defineDescriptor() : void
      {
      }
      
      private function processDescriptor() : void
      {
         var prop:* = null;
         var nextDescriptor:* = undefined;
         this.combinedDescriptor = this.themeDescriptors.shift();
         if(this.themeDescriptors.length > 0)
         {
            do
            {
               nextDescriptor = this.themeDescriptors.shift();
               this.mixDescriptor(nextDescriptor);
            }
            while(this.themeDescriptors.length > 0);
            
         }
         this.colorNames = [];
         for(prop in this.combinedDescriptor.colorNames)
         {
            this.colorNames[prop] = this.combinedDescriptor.colorNames[prop];
         }
         this.styles = [];
         for(prop in this.combinedDescriptor.styles)
         {
            this.styles[prop] = new Style(prop,this.combinedDescriptor.styles[prop],null,this);
         }
         this.themeDescriptors = null;
         this.combinedDescriptor = null;
      }
      
      public function getStyle(id:String) : Style
      {
         var s:Style = this.styles[id];
         if(s == null)
         {
            s = this.styles["noStyle"];
         }
         return s;
      }
      
      public function mixDescriptor(next:*) : void
      {
         this.mixDescriptor_recursive(this.combinedDescriptor.styles,next.styles);
      }
      
      protected function mixDescriptor_recursive(origNode:*, nextNode:*) : void
      {
         var prop:* = null;
         var n:* = undefined;
         var ct:Boolean = false;
         for(prop in nextNode)
         {
            if(origNode[prop] == null)
            {
               origNode[prop] = nextNode[prop];
            }
            else
            {
               n = nextNode[prop];
               ct = n is String || n is Array || n is Number;
               if(ct)
               {
                  origNode[prop] = nextNode[prop];
               }
               else
               {
                  this.mixDescriptor_recursive(origNode[prop],nextNode[prop]);
               }
            }
         }
      }
   }
}
