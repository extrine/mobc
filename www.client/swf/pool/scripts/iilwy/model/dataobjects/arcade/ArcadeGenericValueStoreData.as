package iilwy.model.dataobjects.arcade
{
   import iilwy.application.AppComponents;
   import iilwy.events.GenericValueEvent;
   import iilwy.model.dataobjects.ArcadeGamePackData;
   import iilwy.utils.StageReference;
   
   public class ArcadeGenericValueStoreData
   {
       
      
      public var numbers:Object;
      
      public function ArcadeGenericValueStoreData()
      {
         this.numbers = {};
         super();
      }
      
      protected static function getPrefix(gamePack:ArcadeGamePackData) : String
      {
         var result:String = "g_" + gamePack.id + "_";
         return result;
      }
      
      public static function getNamespacedNumberKeys(gamePack:ArcadeGamePackData) : Array
      {
         var s:String = null;
         var result:Array = [];
         for each(s in gamePack.genericNumberStoreKeys)
         {
            result.push(getPrefix(gamePack) + s);
         }
         return result;
      }
      
      public function reset() : void
      {
         this.numbers = {};
      }
      
      public function setNumbers(data:*) : void
      {
         var id:* = null;
         var value:Number = NaN;
         var key:String = null;
         var prefix:String = getPrefix(AppComponents.model.arcade.currentGamePack);
         this.numbers = {};
         for(id in data)
         {
            if(id.indexOf(prefix) >= 0)
            {
               value = data[id];
               key = id.split(prefix)[1];
               this.numbers[key] = value;
            }
         }
      }
      
      public function incrementNumber(key:String, amount:uint) : void
      {
         this.send(GenericValueEvent.METHOD_INCREMENT,getPrefix(AppComponents.model.arcade.currentGamePack) + key,amount);
         if(this.numbers && this.numbers.hasOwnProperty(key))
         {
            this.numbers[key] = this.numbers[key] + amount;
         }
         else
         {
            this.numbers[key] = amount;
         }
      }
      
      public function decrementNumber(key:String, amount:uint) : void
      {
         this.send(GenericValueEvent.METHOD_DECREMENT,getPrefix(AppComponents.model.arcade.currentGamePack) + key,amount);
         if(this.numbers && this.numbers.hasOwnProperty(key))
         {
            this.numbers[key] = this.numbers[key] - amount;
         }
         else
         {
            this.numbers[key] = -amount;
         }
      }
      
      public function setNumber(key:String, amount:uint) : void
      {
         this.send(GenericValueEvent.METHOD_SET,getPrefix(AppComponents.model.arcade.currentGamePack) + key,amount);
         if(this.numbers)
         {
            this.numbers[key] = amount;
         }
      }
      
      public function send(methodType:String, key:String, amount:int) : void
      {
         if(!AppComponents.model.privateUser.isLoggedIn)
         {
            return;
         }
         var updateEvent:GenericValueEvent = new GenericValueEvent(GenericValueEvent.MODIFY_VALUE);
         updateEvent.methodType = methodType;
         updateEvent.key = key;
         updateEvent.intValue = amount;
         StageReference.stage.dispatchEvent(updateEvent);
      }
   }
}
