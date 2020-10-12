package iilwy.model.dataobjects
{
   import flash.display.BitmapData;
   
   public class DrawingData
   {
       
      
      public var id:String;
      
      public var url:String;
      
      public var bitmapData:BitmapData;
      
      public function DrawingData()
      {
         super();
      }
      
      public static function createTest() : DrawingData
      {
         var drawing:DrawingData = new DrawingData();
         drawing.id = "poo";
         drawing.url = "http://drawring.iminlikewithyou.com/1/drawings/1tdfkbnktvetdsx_80.jpg";
         return drawing;
      }
      
      public static function createFromMerbResult(result:*) : DrawingData
      {
         var d:DrawingData = new DrawingData();
         d.id = result.drawing_id;
         d.url = result.drawing_filename;
         return d;
      }
   }
}
