package iilwy.motion
{
   import caurina.transitions.Tweener;
   
   public class Equations
   {
       
      
      public function Equations()
      {
         super();
         throw new Error("Should not call equations.");
      }
      
      public static function init() : void
      {
         Tweener.registerTransition("linear",easeNone);
         Tweener.registerTransition("easenone",easeNone);
         Tweener.registerTransition("easeinquad",easeInQuad);
         Tweener.registerTransition("easeoutquad",easeOutQuad);
         Tweener.registerTransition("easeinoutquad",easeInOutQuad);
         Tweener.registerTransition("easeinexpo",easeInExpo);
         Tweener.registerTransition("easeoutexpo",easeOutExpo);
         Tweener.registerTransition("easeinoutexpo",easeInOutExpo);
         Tweener.registerTransition("easeoutinexpo",easeOutInExpo);
         Tweener.registerTransition("easeinelastic",easeInElastic);
         Tweener.registerTransition("easeoutelastic",easeOutElastic);
         Tweener.registerTransition("easeinoutelastic",easeInOutElastic);
         Tweener.registerTransition("easeoutinelastic",easeOutInElastic);
      }
      
      public static function easeNone(t:Number, b:Number, c:Number, d:Number) : Number
      {
         return c * t / d + b;
      }
      
      public static function easeInQuad(t:Number, b:Number, c:Number, d:Number) : Number
      {
         return c * (t = t / d) * t + b;
      }
      
      public static function easeOutQuad(t:Number, b:Number, c:Number, d:Number) : Number
      {
         return -c * (t = t / d) * (t - 2) + b;
      }
      
      public static function easeInOutQuad(t:Number, b:Number, c:Number, d:Number) : Number
      {
         if((t = t / (d / 2)) < 1)
         {
            return c / 2 * t * t + b;
         }
         return -c / 2 * (--t * (t - 2) - 1) + b;
      }
      
      public static function easeInExpo(t:Number, b:Number, c:Number, d:Number) : Number
      {
         return t == 0?Number(b):Number(c * Math.pow(2,10 * (t / d - 1)) + b);
      }
      
      public static function easeOutExpo(t:Number, b:Number, c:Number, d:Number) : Number
      {
         return t == d?Number(b + c):Number(c * (-Math.pow(2,-10 * t / d) + 1) + b);
      }
      
      public static function easeInOutExpo(t:Number, b:Number, c:Number, d:Number) : Number
      {
         if(t == 0)
         {
            return b;
         }
         if(t == d)
         {
            return b + c;
         }
         if((t = t / (d / 2)) < 1)
         {
            return c / 2 * Math.pow(2,10 * (t - 1)) + b;
         }
         return c / 2 * (-Math.pow(2,-10 * --t) + 2) + b;
      }
      
      public static function easeOutInExpo(t:Number, b:Number, c:Number, d:Number) : Number
      {
         if(t == 0)
         {
            return b;
         }
         if(t == d)
         {
            return b + c;
         }
         if((t = t / (d / 2)) < 1)
         {
            return c / 2 * (-Math.pow(2,-10 * t / 1) + 1) + b;
         }
         return c / 2 * (Math.pow(2,10 * (t - 2) / 1) + 1) + b;
      }
      
      public static function easeInCirc(t:Number, b:Number, c:Number, d:Number) : Number
      {
         return -c * (Math.sqrt(1 - (t = Number(t / d)) * t) - 1) + b;
      }
      
      public static function easeOutCirc(t:Number, b:Number, c:Number, d:Number) : Number
      {
         return c * Math.sqrt(1 - (t = Number(t / d - 1)) * t) + b;
      }
      
      public static function easeInOutCirc(t:Number, b:Number, c:Number, d:Number) : Number
      {
         if((t = t / (d / 2)) < 1)
         {
            return -c / 2 * (Math.sqrt(1 - t * t) - 1) + b;
         }
         return c / 2 * (Math.sqrt(1 - (t = Number(t - 2)) * t) + 1) + b;
      }
      
      public static function easeOutInCirc(t:Number, b:Number, c:Number, d:Number) : Number
      {
         return NaN;
      }
      
      public static function easeInElastic(t:Number, b:Number, c:Number, d:Number, a:Number = NaN, p:Number = NaN) : Number
      {
         var s:Number = NaN;
         if(t == 0)
         {
            return b;
         }
         if((t = t / d) == 1)
         {
            return b + c;
         }
         if(!p)
         {
            p = d * 0.3;
         }
         if(!a || a < Math.abs(c))
         {
            a = c;
            s = p / 4;
         }
         else
         {
            s = p / (2 * Math.PI) * Math.asin(c / a);
         }
         return -(a * Math.pow(2,10 * (t = Number(t - 1))) * Math.sin((t * d - s) * (2 * Math.PI) / p)) + b;
      }
      
      public static function easeOutElastic(t:Number, b:Number, c:Number, d:Number, a:Number = NaN, p:Number = NaN) : Number
      {
         var s:Number = NaN;
         if(t == 0)
         {
            return b;
         }
         if((t = t / d) == 1)
         {
            return b + c;
         }
         if(!p)
         {
            p = d * 0.3;
         }
         if(!a || a < Math.abs(c))
         {
            a = c;
            s = p / 4;
         }
         else
         {
            s = p / (2 * Math.PI) * Math.asin(c / a);
         }
         return a * Math.pow(2,-10 * t) * Math.sin((t * d - s) * (2 * Math.PI) / p) + c + b;
      }
      
      public static function easeInOutElastic(t:Number, b:Number, c:Number, d:Number, a:Number = NaN, p:Number = NaN) : Number
      {
         var s:Number = NaN;
         if(t == 0)
         {
            return b;
         }
         if((t = t / (d / 2)) == 2)
         {
            return b + c;
         }
         if(!p)
         {
            p = d * (0.3 * 1.5);
         }
         if(!a || a < Math.abs(c))
         {
            a = c;
            s = p / 4;
         }
         else
         {
            s = p / (2 * Math.PI) * Math.asin(c / a);
         }
         if(t < 1)
         {
            return -0.5 * (a * Math.pow(2,10 * (t = Number(t - 1))) * Math.sin((t * d - s) * (2 * Math.PI) / p)) + b;
         }
         return a * Math.pow(2,-10 * (t = Number(t - 1))) * Math.sin((t * d - s) * (2 * Math.PI) / p) * 0.5 + c + b;
      }
      
      public static function easeOutInElastic(t:Number, b:Number, c:Number, d:Number, a:Number = NaN, p:Number = NaN) : Number
      {
         return NaN;
      }
   }
}
