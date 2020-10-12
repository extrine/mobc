package iilwy.delegates
{
   import iilwy.utils.logging.Logger;
   
   public class Delegate
   {
       
      
      protected var _logger:Logger;
      
      public function Delegate()
      {
         super();
         this._logger = Logger.getLogger(this);
      }
   }
}
