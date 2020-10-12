package iilwy.ui.utils
{
   public class Margin
   {
       
      
      public var top:Number;
      
      public var right:Number;
      
      public var bottom:Number;
      
      public var left:Number;
      
      public function Margin(left:Number = 0, top:Number = 0, right:Number = 0, bottom:Number = 0)
      {
         super();
         this.top = top;
         this.right = right;
         this.bottom = bottom;
         this.left = left;
      }
      
      public static function create(... args) : Margin
      {
         var margin:Margin = new Margin();
         margin.setValues.apply(margin,args);
         return margin;
      }
      
      public function clone() : Margin
      {
         var margin:Margin = new Margin(this.left,this.top,this.right,this.bottom);
         return margin;
      }
      
      public function setValues(... args) : void
      {
         if(args.length == 1)
         {
            this.top = args[0];
            this.right = args[0];
            this.bottom = args[0];
            this.left = args[0];
         }
         else if(args.length == 2)
         {
            this.top = args[0];
            this.bottom = args[0];
            this.left = args[1];
            this.right = args[1];
         }
         else if(args.length == 4)
         {
            this.top = args[0];
            this.right = args[1];
            this.bottom = args[2];
            this.left = args[3];
         }
      }
      
      public function get horizontal() : Number
      {
         return this.left + this.right;
      }
      
      public function get vertical() : Number
      {
         return this.top + this.bottom;
      }
   }
}
