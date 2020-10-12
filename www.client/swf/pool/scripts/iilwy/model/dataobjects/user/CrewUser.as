package iilwy.model.dataobjects.user
{
   import flash.utils.Dictionary;
   
   public class CrewUser
   {
      
      public static const CHARLES:CrewUser = new CrewUser(11433,"setpixel");
      
      public static const EJ:CrewUser = new CrewUser(120,"ejm");
      
      public static const KEN:CrewUser = new CrewUser(178,"ken");
      
      public static const DAN:CrewUser = new CrewUser(66138,"tfadp");
      
      public static const JASON:CrewUser = new CrewUser(200562,"crash2burn");
      
      public static const DANIEL:CrewUser = new CrewUser(206180,"Monstruoso");
      
      public static const MARK:CrewUser = new CrewUser(224164,"yourpalmark");
      
      public static const CHUL:CrewUser = new CrewUser(455645,"iilwy_chul");
      
      public static const ANDY:CrewUser = new CrewUser(513026,"andweez");
      
      public static const WILL:CrewUser = new CrewUser(566105,"i am will");
      
      public static const JOSEPH:CrewUser = new CrewUser(612926,"Swiftor");
      
      public static const NOAH:CrewUser = new CrewUser(2788478,"lostnation");
      
      public static const MALCOLM:CrewUser = new CrewUser(762817,"darkseraph");
      
      protected static var userIDDict:Dictionary;
      
      protected static var profileNameDict:Dictionary;
      
      private static var finalized:Boolean = true;
       
      
      private var _userID:int;
      
      private var _profileName:String;
      
      public function CrewUser(userID:int, profileName:String)
      {
         super();
         if(finalized)
         {
            throw new Error("CrewUser can not be instantiated.");
         }
         if(!userIDDict)
         {
            userIDDict = new Dictionary();
         }
         if(!profileNameDict)
         {
            profileNameDict = new Dictionary();
         }
         this._userID = userID;
         userIDDict[userID] = this;
         this._profileName = profileName;
         profileNameDict[profileName] = this;
      }
      
      public static function getByUserID(userID:int) : CrewUser
      {
         return userIDDict[userID];
      }
      
      public static function getByProfileName(profileName:String) : CrewUser
      {
         return profileNameDict[profileName];
      }
      
      public function get userID() : int
      {
         return this._userID;
      }
      
      public function get profileName() : String
      {
         return this._profileName;
      }
   }
}
