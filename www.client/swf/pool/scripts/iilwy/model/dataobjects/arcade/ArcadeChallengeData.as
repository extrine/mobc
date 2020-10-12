package iilwy.model.dataobjects.arcade
{
   import com.adobe.utils.DateUtil;
   import iilwy.model.dataobjects.ProfileData;
   
   public class ArcadeChallengeData
   {
      
      public static const STATE_P1WIN:String = "stateP1Win";
      
      public static const STATE_P2WIN:String = "stateP2Win";
      
      public static const STATE_OPEN:String = "stateOpen";
      
      public static const PENDING_TYPE_CREATE:String = "pendingCreate";
      
      public static const PENDING_TYPE_ACCEPT:String = "pendingAccept";
       
      
      public var gameId:String;
      
      public var challenged:ProfileData;
      
      public var challenger:ProfileData;
      
      public var challengeId:String;
      
      public var p1Score:Number;
      
      public var p2Score:Number;
      
      public var templateId:String;
      
      public var template:ArcadeChallengeTemplate;
      
      public var pendingType:String;
      
      public var state:String;
      
      public var winnerId:Number;
      
      public var creationDate:Date;
      
      public var expirationDate:Date;
      
      public function ArcadeChallengeData()
      {
         super();
      }
      
      public static function createListFromApiResponse(array:Array) : Array
      {
         var data:* = undefined;
         var challenge:ArcadeChallengeData = null;
         var result:Array = [];
         for each(data in array)
         {
            challenge = createFromApiResponse(data.challenge);
            result.push(challenge);
         }
         return result;
      }
      
      public static function createFromApiResponse(response:*) : ArcadeChallengeData
      {
         var result:ArcadeChallengeData = new ArcadeChallengeData();
         if(response.initiator)
         {
            result.challenger = ProfileData.createFromMerbResult(response.initiator);
         }
         result.template = new ArcadeChallengeTemplate();
         result.template.description = response.description;
         result.template.title = response.title;
         result.template.id = response.challenge_template_id;
         result.template.scoreId = response.score_key;
         result.gameId = response.game_id;
         result.challengeId = response.id;
         result.templateId = response.challenge_template_id;
         result.winnerId = response.winner_id;
         result.p1Score = response.initiator_score;
         result.p2Score = response.respondent_score;
         result.creationDate = Boolean(response.created_at)?DateUtil.parseW3CDTF(response.created_at):null;
         result.expirationDate = Boolean(response.expires)?DateUtil.parseW3CDTF(response.expires):null;
         return result;
      }
      
      public function clone() : ArcadeChallengeData
      {
         var c:ArcadeChallengeData = new ArcadeChallengeData();
         c.copy(this);
         return c;
      }
      
      public function copy(other:ArcadeChallengeData) : void
      {
         this.gameId = other.gameId;
         this.challenged = other.challenged;
         this.challenger = other.challenger;
         this.challengeId = other.challengeId;
         this.p1Score = other.p1Score;
         this.p2Score = other.p2Score;
         this.creationDate = other.creationDate;
         this.expirationDate = other.expirationDate;
         this.templateId = other.templateId;
         this.template = other.template;
         this.pendingType = other.pendingType;
      }
   }
}
