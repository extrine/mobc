package iilwy.utils
{
   public class TestUtil
   {
       
      
      public function TestUtil()
      {
         super();
      }
      
      public static function generateLoremImsum(length:Number) : String
      {
         var words:Array = String(" lorem| ipsum| sit| olor| damet|. Lorem").split("|");
         var str:String = "Lorem";
         for(var i:int = 0; i < length; i++)
         {
            str = str + words[Math.floor(Math.random() * words.length)];
         }
         str = str + " dolor.";
         return str;
      }
      
      public static function randomName(gender:Number = 0) : String
      {
         var name:String = null;
         var male:Array = ["Bob","setpixel","Iqram","kortina","CC","William Wizzardly Westerton"];
         var female:Array = ["Christine","Michelle","iJustine"];
         var both:Array = male.concat(female);
         if(gender == 0)
         {
            name = both[Math.floor(Math.random() * both.length)];
         }
         else if(gender == 1)
         {
            name = female[Math.floor(Math.random() * female.length)];
         }
         else if(gender == 2)
         {
            name = male[Math.floor(Math.random() * male.length)];
         }
         return name;
      }
      
      public static function randomPhoto() : String
      {
         var photos:Array = ["http://media.beta.iminlikewithyou.com/5/photos/5yuzrjm1mbnxrfx.gif","http://media.beta.iminlikewithyou.com/120/photos/120f7o10j8kud1quv.jpg","http://media.beta.iminlikewithyou.com/27/photos/27lnsphbwr5lvxv1.jpg"];
         return photos[Math.floor(Math.random() * photos.length)];
      }
      
      public static function randomUserId() : Number
      {
         return Math.floor(Math.random() * 8);
      }
      
      public static function getName(id:Number) : String
      {
         var list:Array = ["Bob","setpixel","Iqram","kortina","CC","Christine","Michelle","iJustine"];
         return list[id];
      }
   }
}
