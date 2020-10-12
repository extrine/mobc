package iilwy.utils
{
   public final class Scale
   {
      
      public static const SCALE_ORIGINAL:String = "SCALE_ORIGINAL";
      
      public static const SCALE_STRETCH:String = "SCALE_STRETCH";
      
      public static const SCALE_FIT:String = "SCALE_FIT";
      
      public static const SCALE_CROP:String = "SCALE_CROP";
      
      public static const SCALE_PAD:String = "SCALE_PAD";
      
      public static const POS_UPPER_LEFT:String = "POS_UPPER_LEFT";
      
      public static const POS_CENTER:String = "POS_CENTER";
      
      public static const POS_FACE:String = "POS_FACE";
      
      public static const POS_FACETOP:String = "POS_FACETOP";
       
      
      public function Scale()
      {
         super();
      }
      
      public static function scaleContent(windowWidth:Number, windowHeight:Number, contentWidth:Number, contentHeight:Number, scaleMode:String, padPixels:Number, padPercent:Number, position:String) : Object
      {
         var returnObject:Object = {
            "width":0,
            "height":0,
            "x":0,
            "y":0
         };
         switch(scaleMode)
         {
            case SCALE_ORIGINAL:
               returnObject.width = contentWidth;
               returnObject.height = contentHeight;
               break;
            case SCALE_STRETCH:
               returnObject.width = windowWidth;
               returnObject.height = windowHeight;
               break;
            case SCALE_FIT:
               if(windowWidth / windowHeight > contentWidth / contentHeight)
               {
                  returnObject.height = windowHeight;
                  returnObject.width = windowHeight / contentHeight * contentWidth;
               }
               else
               {
                  returnObject.width = windowWidth;
                  returnObject.height = windowWidth / contentWidth * contentHeight;
               }
               break;
            case SCALE_CROP:
               if(windowWidth / windowHeight > contentWidth / contentHeight)
               {
                  returnObject.width = windowWidth;
                  returnObject.height = windowWidth / contentWidth * contentHeight;
               }
               else
               {
                  returnObject.height = windowHeight;
                  returnObject.width = windowHeight / contentHeight * contentWidth;
               }
               break;
            case SCALE_PAD:
               if(windowWidth / windowHeight > contentWidth / contentHeight)
               {
                  if(padPixels != 0)
                  {
                     returnObject.width = windowWidth + padPixels * 2;
                  }
                  else
                  {
                     returnObject.width = windowWidth + windowWidth * (padPercent / 100) * 2;
                  }
                  returnObject.height = returnObject.width / contentWidth * contentHeight;
               }
               else
               {
                  if(padPixels != 0)
                  {
                     returnObject.height = windowHeight + padPixels * 2;
                  }
                  else
                  {
                     returnObject.height = windowHeight + windowHeight * (padPercent / 100) * 2;
                  }
                  returnObject.width = returnObject.height / contentHeight * contentWidth;
               }
         }
         switch(position)
         {
            case POS_UPPER_LEFT:
               returnObject.x = 0;
               returnObject.y = 0;
               break;
            case POS_CENTER:
               returnObject.x = (windowWidth - returnObject.width) / 2;
               returnObject.y = (windowHeight - returnObject.height) / 2;
               break;
            case POS_FACE:
               returnObject.x = (windowWidth - returnObject.width) / 2;
               returnObject.y = (windowHeight - returnObject.height) * 0.4;
               break;
            case POS_FACETOP:
               returnObject.x = (windowWidth - returnObject.width) / 2;
               returnObject.y = (windowHeight - returnObject.height) * 0.15;
         }
         return returnObject;
      }
   }
}
