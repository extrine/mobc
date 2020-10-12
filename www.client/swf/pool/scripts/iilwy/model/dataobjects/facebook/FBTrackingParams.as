package iilwy.model.dataobjects.facebook
{
   import flash.net.URLVariables;
   
   public dynamic class FBTrackingParams extends URLVariables
   {
       
      
      public function FBTrackingParams(source:String = null)
      {
         super(source);
      }
      
      public function addTrackingTag(value:String) : void
      {
         this["t"] = value;
      }
      
      public function addSubType(value:*) : int
      {
         var subTypeNum:int = !!hasOwnProperty("st3")?int(0):!!hasOwnProperty("st2")?int(3):!!hasOwnProperty("st1")?int(2):int(1);
         if(subTypeNum > 0)
         {
            this["st" + subTypeNum] = value;
         }
         return subTypeNum;
      }
   }
}
