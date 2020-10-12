package iilwygames.baloono.gameplay
{
   public interface IPlayer
   {
       
      
      function get id() : int;
      
      function registerBomb(param1:IBomb) : void;
      
      function deregisterBomb(param1:IBomb) : void;
   }
}
