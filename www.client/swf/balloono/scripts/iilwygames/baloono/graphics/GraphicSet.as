package iilwygames.baloono.graphics
{
   import com.partlyhuman.debug.Console;
   import flash.geom.Rectangle;
   import iilwygames.baloono.BaloonoGame;
   
   public class GraphicSet
   {
       
      
      public var assets:Object;
      
      public var name:String;
      
      public var drawLayer:int;
      
      public function GraphicSet(param1:String, param2:int)
      {
         super();
         this.name = param1;
         this.drawLayer = param2;
         this.assets = new Object();
      }
      
      public function getAsset(param1:String) : GraphicAsset
      {
         var ret:GraphicAsset = null;
         var id:String = param1;
         try
         {
            ret = GraphicAsset(this.assets[id]);
         }
         catch(error:Error)
         {
            if(BaloonoGame.instance.DEBUG_LOGGING)
            {
               Console.error("Asset " + id + " requested but not found in set " + name);
            }
         }
         return ret;
      }
      
      public function setTileSize(param1:Rectangle) : void
      {
         var _loc3_:* = null;
         var _loc2_:int = 0;
         for(_loc3_ in this.assets)
         {
            GraphicAsset(this.assets[_loc3_]).rasterizeFrames(param1);
            _loc2_++;
         }
      }
      
      public function addAsset(param1:GraphicAsset, param2:String) : void
      {
         this.assets[param2] = param1;
      }
   }
}
