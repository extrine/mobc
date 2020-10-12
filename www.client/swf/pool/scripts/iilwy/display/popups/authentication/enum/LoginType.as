package iilwy.display.popups.authentication.enum
{
   import flash.utils.Dictionary;
   import iilwy.managers.GraphicManager;
   
   public class LoginType
   {
      
      public static var EMAIL:LoginType = new LoginType("email","Email","Email Address",null,1000);
      
      public static var FACEBOOK:LoginType = new LoginType("facebook","Facebook","Facebook",GraphicManager.loginFacebookIcon,3000);
      
      public static var AIM:LoginType = new LoginType("aim","AIM","AIM",GraphicManager.loginAIMIcon,1000);
      
      private static var finalized:Boolean = true;
      
      private static var idDict:Dictionary;
      
      private static var nameDict:Dictionary;
      
      private static var _loginTypes:Array;
       
      
      private var _id:String;
      
      private var _name:String;
      
      private var _connection:String;
      
      private var _icon:Class;
      
      private var _numCoinsIfAdded:int;
      
      public function LoginType(id:String, name:String, connection:String, icon:Class, numCoinsIfAdded:int)
      {
         super();
         if(!idDict)
         {
            idDict = new Dictionary();
         }
         if(!nameDict)
         {
            nameDict = new Dictionary();
         }
         if(!_loginTypes)
         {
            _loginTypes = [];
         }
         this._id = id;
         this._name = name;
         this._connection = connection;
         this._icon = icon;
         this._numCoinsIfAdded = numCoinsIfAdded;
         idDict[this._id] = this;
         nameDict[this._name] = this;
         if(!finalized)
         {
            _loginTypes.push(this);
         }
      }
      
      public static function getByID(id:String) : LoginType
      {
         return idDict[id];
      }
      
      public static function getByName(name:String) : LoginType
      {
         return nameDict[name];
      }
      
      public static function get loginTypes() : Array
      {
         return _loginTypes.concat();
      }
      
      public function get id() : String
      {
         return this._id;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function get connection() : String
      {
         return this._connection;
      }
      
      public function get icon() : Class
      {
         return this._icon;
      }
      
      public function get numCoinsIfAdded() : int
      {
         return this._numCoinsIfAdded;
      }
      
      public function toString() : String
      {
         return "[LoginType id=" + this.id + " name=" + this.name + "]";
      }
   }
}
