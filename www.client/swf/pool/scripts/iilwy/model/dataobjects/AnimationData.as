package iilwy.model.dataobjects
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class AnimationData
   {
       
      
      public var rect:Rectangle;
      
      public var frames:Array;
      
      public var frameRate:int = 30;
      
      public var loops:int = 0;
      
      public var center:Point;
      
      public function AnimationData()
      {
         this.rect = new Rectangle(0,0,100,100);
         this.frames = [];
         this.center = new Point(50,50);
         super();
      }
   }
}
