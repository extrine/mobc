package iilwygames.baloono.gameplay
{
   public interface IAbility
   {
       
      
      function mergeAbility(param1:IAbility) : void;
      
      function get expiresAt() : int;
   }
}
