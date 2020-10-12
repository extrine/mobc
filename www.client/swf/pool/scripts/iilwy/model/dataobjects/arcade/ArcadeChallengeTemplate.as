package iilwy.model.dataobjects.arcade
{
   public class ArcadeChallengeTemplate
   {
      
      public static const SCORE_COMPARE_ASCENDING:String = "ascending";
      
      public static const SCORE_COMPARE_DESCENDING:String = "descending";
       
      
      public var id:String;
      
      public var scoreId:String;
      
      public var scoreCompare:String;
      
      public var maxPlayers:Number;
      
      public var minPlayers:Number;
      
      public var title:String;
      
      public var description:String;
      
      public var gameType:String;
      
      public var expReward:Number;
      
      public function ArcadeChallengeTemplate()
      {
         super();
      }
      
      public static function createFromXml(xml:XML) : ArcadeChallengeTemplate
      {
         var c:ArcadeChallengeTemplate = new ArcadeChallengeTemplate();
         c.id = xml.@id.toXMLString();
         c.scoreId = xml.scoreId.text();
         c.scoreCompare = xml.scoreCompare.text();
         c.title = xml.title.text();
         c.gameType = xml.gameType.text();
         c.description = xml.description.text();
         c.minPlayers = xml.minPlayers.text();
         c.maxPlayers = xml.maxPlayers.text();
         c.expReward = xml.expReward.text();
         return c;
      }
      
      public static function createFromMerbResult(data:*) : ArcadeChallengeTemplate
      {
         var c:ArcadeChallengeTemplate = new ArcadeChallengeTemplate();
         c.id = data.id;
         c.scoreId = data.score_id;
         c.scoreCompare = data.score_compare;
         c.title = data.title;
         c.gameType = data.game_type;
         c.description = data.description;
         c.minPlayers = data.min_player;
         c.maxPlayers = data.max_players;
         c.expReward = data.exp_reward;
         return c;
      }
   }
}
