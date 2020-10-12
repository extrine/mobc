package mx.utils
{
   [ExcludeClass]
   public interface IXMLNotifiable
   {
       
      
      function xmlNotification(currentTarget:Object, type:String, target:Object, value:Object, detail:Object) : void;
   }
}
