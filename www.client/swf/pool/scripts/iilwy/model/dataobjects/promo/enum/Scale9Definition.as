package iilwy.model.dataobjects.promo.enum
{
   public class Scale9Definition
   {
       
      
      public var top:int;
      
      public var right:int;
      
      public var bottom:int;
      
      public var left:int;
      
      public var imageURL:String;
      
      public var clickURL:String;
      
      public function Scale9Definition(top:int = 0, right:int = 0, bottom:int = 0, left:int = 0, imageURL:String = null, clickURL:String = null)
      {
         super();
         this.top = top;
         this.right = right;
         this.bottom = bottom;
         this.left = left;
         this.imageURL = imageURL;
         this.clickURL = clickURL;
      }
      
      public function toString() : String
      {
         var props:Array = [];
         if(this.top)
         {
            props.push(this.top.toString());
         }
         if(this.right)
         {
            props.push(this.right.toString());
         }
         if(this.bottom)
         {
            props.push(this.bottom.toString());
         }
         if(this.left)
         {
            props.push(this.left.toString());
         }
         if(this.imageURL)
         {
            props.push(this.imageURL);
         }
         if(this.clickURL)
         {
            props.push(this.clickURL);
         }
         return props.join(",");
      }
   }
}
