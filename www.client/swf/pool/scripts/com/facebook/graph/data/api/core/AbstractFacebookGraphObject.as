package com.facebook.graph.data.api.core
{
   import com.facebook.graph.core.facebook_internal;
   import com.facebook.graph.utils.FacebookDataUtils;
   
   use namespace facebook_internal;
   
   public class AbstractFacebookGraphObject implements IFacebookGraphObject
   {
       
      
      public var id:String;
      
      public var rawResult:Object;
      
      public function AbstractFacebookGraphObject()
      {
         super();
      }
      
      public function fromJSON(result:Object) : void
      {
         var property:* = null;
         this.rawResult = result;
         if(result != null)
         {
            for(property in result)
            {
               if(hasOwnProperty(property))
               {
                  this.setPropertyValue(property,result[property]);
               }
            }
         }
      }
      
      public function toString() : String
      {
         return this.toString(["id"]);
      }
      
      protected function setPropertyValue(property:String, value:*) : void
      {
         switch(property)
         {
            case "created_time":
            case "end_time":
            case "start_time":
            case "updated_time":
               this[property] = FacebookDataUtils.stringToDate(value);
               break;
            default:
               this[property] = value;
         }
      }
      
      facebook_internal function toString(properties:Array) : String
      {
         var property:String = null;
         var str:String = "[ ";
         var len:int = properties.length;
         for(var i:int = 0; i < len; i++)
         {
            property = properties[i];
            if(hasOwnProperty(property))
            {
               if(i > 0)
               {
                  str = str + ", ";
               }
               str = str + (property + ": " + this[property]);
            }
         }
         str = str + " ]";
         return str;
      }
   }
}
