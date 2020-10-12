package iilwy.graphics
{
   import flash.display.Graphics;
   import flash.geom.Matrix;
   
   public class GradientFill
   {
       
      
      public var type:String;
      
      public var colors:Array;
      
      public var alphas:Array;
      
      public var ratios:Array;
      
      public var matrix:Matrix;
      
      public var spreadMethod:String;
      
      public var interpolationMethod:String;
      
      public var focalPointRatio:Number;
      
      public function GradientFill(type:String = "linear", colors:Array = null, alphas:Array = null, ratios:Array = null, matrix:Matrix = null, spreadMethod:String = "pad", interpolationMethod:String = "rgb", focalPointRatio:Number = 0)
      {
         super();
         this.type = type;
         this.colors = colors;
         this.alphas = alphas;
         this.ratios = ratios;
         this.matrix = matrix;
         this.spreadMethod = spreadMethod;
         this.interpolationMethod = interpolationMethod;
         this.focalPointRatio = focalPointRatio;
      }
      
      public static function beginFill(graphics:Graphics, fill:GradientFill) : void
      {
         graphics.beginGradientFill(fill.type,fill.colors,fill.alphas,fill.ratios,fill.matrix,fill.spreadMethod,fill.interpolationMethod,fill.focalPointRatio);
      }
   }
}
