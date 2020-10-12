package iilwy.model.dataobjects.market.product.searchcommand
{
   public class StringMatch
   {
      
      protected static const vowels:String = "/aeiouy/";
      
      protected static const illegal:String = "/+*&^%$#@!~`|}{][;:/?.,></";
       
      
      public function StringMatch()
      {
         super();
      }
      
      public static function execute(input:String, compare:String) : Number
      {
         input = input.toLowerCase();
         input = filterInitial(input);
         compare = compare.toLocaleLowerCase();
         compare = filterInitial(compare);
         var totalLength:int = compare.length;
         var score:int = 0;
         if(compare.search(new RegExp(input)) == -1)
         {
            score = 0;
         }
         else
         {
            score = 100;
         }
         var result:Number = score / totalLength;
         return result;
      }
      
      protected static function filterInitial(input:String) : String
      {
         var result:String = null;
         result = input.replace(new RegExp(illegal),"");
         return result;
      }
   }
}
