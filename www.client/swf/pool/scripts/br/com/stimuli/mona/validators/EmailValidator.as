package br.com.stimuli.mona.validators
{
   public class EmailValidator
   {
      
      public static const EMAIL_REGEX:RegExp = /^[A-Z0-9._%+-]+@(?:[A-Z0-9-]+\.)+[A-Z]{2,4}$/i;
       
      
      public function EmailValidator()
      {
         super();
         throw new Error("The EmailValidator class is not intended to be instantiated.");
      }
      
      public static function isValidEmail(email:String) : Boolean
      {
         return Boolean(email.match(EMAIL_REGEX));
      }
      
      public static function isValidEmailList(emailList:String, separator:String = ",") : Boolean
      {
         var email:String = null;
         var addresses:Array = emailList.split(separator);
         for each(email in addresses)
         {
            if(!isValidEmail(email.replace(/\s/,"")))
            {
               return false;
            }
         }
         return true;
      }
      
      public static function validate(email:String, errorClass:Class = null, errorMessage:String = "Invalid e-mail address.") : void
      {
         if(isValidEmail(email))
         {
            return;
         }
         errorClass = errorClass || Error;
         throw new errorClass(errorMessage);
      }
   }
}
