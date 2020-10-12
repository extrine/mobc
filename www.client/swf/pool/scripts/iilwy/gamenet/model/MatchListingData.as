package iilwy.gamenet.model
{
   import flash.events.EventDispatcher;
   import iilwy.gamenet.utils.DataUtil;
   import iilwy.utils.logging.Logger;
   import org.igniterealtime.xiff.core.UnescapedJID;
   
   public class MatchListingData extends EventDispatcher
   {
       
      
      public var matchName:String;
      
      public var gameId:String;
      
      public var description:String;
      
      public var maxPlayers:Number;
      
      public var config:Object;
      
      public var serverID:int = -1;
      
      public var host:PlayerData;
      
      public var open:Boolean;
      
      public var jid:UnescapedJID;
      
      public var skillLevel:String;
      
      public var useItems:Boolean;
      
      public var teamType:String = "";
      
      public var gameType:String = "";
      
      public var betAmount:int = -1;
      
      private var subjectObj:Object;
      
      public var approvedPlayerJids:Array;
      
      public var creationTime:Number;
      
      public var round:Number = 0;
      
      public var players:PlayerCollection;
      
      public var privateMatch:Boolean = false;
      
      public var friendsOnly:Boolean = false;
      
      public var allowGuests:Boolean = true;
      
      public var minLevel:Number = 0;
      
      public var minRating:Number = 0;
      
      public var avgLevel:Number = 1;
      
      public var avgRating:Number = 1300;
      
      public var libVersion:String;
      
      public var uid:int = -1;
      
      public var thumbnailUrl:String;
      
      public var aboutString:String;
      
      public var predictedOpenTime:Number = 0;
      
      public function MatchListingData()
      {
         super();
         this.players = new PlayerCollection();
         this.approvedPlayerJids = [];
      }
      
      public static function createTest() : MatchListingData
      {
         var data:MatchListingData = new MatchListingData();
         data.description = "Test match " + Math.floor(Math.random() * 1000);
         data.gameId = "blockles";
         data.host = PlayerData.createTest();
         data.useItems = true;
         data.open = true;
         data.approvedPlayerJids = [1];
         data.matchName = "m_" + data.gameId + "_" + Math.floor(Math.random() * 1000000);
         data.jid = new UnescapedJID(data.matchName);
         return data;
      }
      
      public function get hasSubject() : Boolean
      {
         return this.subjectObj != null;
      }
      
      public function get isOpen() : Boolean
      {
         return this.open;
      }
      
      public function toSubjectObj() : Object
      {
         var obj:Object = {
            "description":this.description,
            "config":this.config,
            "game_id":this.gameId,
            "max_players":this.maxPlayers.toString(),
            "approved_player_jids":this.approvedPlayerJids,
            "host":this.host.toStatusObject(),
            "open":this.open,
            "game_type":this.gameType,
            "skill_level":this.skillLevel,
            "use_items":this.useItems,
            "team_type":this.teamType,
            "round":this.round,
            "player_data":this.players.toObject(),
            "private_match":this.privateMatch,
            "team_data":{},
            "server_id":this.serverID,
            "jid":this.jid.toString(),
            "allow_guests":this.allowGuests,
            "friends_only":this.friendsOnly,
            "min_level":this.minLevel,
            "min_elo":this.minRating,
            "thumbnail_url":this.thumbnailUrl,
            "about_string":this.aboutString,
            "avg_elo":this.avgRating,
            "avg_level":this.avgLevel,
            "open_at":this.predictedOpenTime
         };
         if(this.betAmount > -1)
         {
            obj.bet_amount = this.betAmount;
         }
         return obj;
      }
      
      public function initFromSubjectObj(subjectObj:Object) : void
      {
         var i:int = 0;
         var p:PlayerData = null;
         this.description = subjectObj.description;
         this.maxPlayers = subjectObj.max_players;
         this.host = new PlayerData();
         this.host.initFromStatusObject(subjectObj.host);
         this.gameId = subjectObj.game_id;
         this.config = subjectObj.config;
         this.privateMatch = subjectObj.private_match;
         this.approvedPlayerJids = subjectObj.approved_player_jids;
         this.open = subjectObj.open;
         this.teamType = subjectObj.team_type;
         this.useItems = subjectObj.use_items;
         this.skillLevel = subjectObj.skill_level;
         this.gameType = subjectObj.game_type;
         if(subjectObj.bet_amount)
         {
            this.betAmount = subjectObj.bet_amount;
         }
         this.serverID = subjectObj.server_id;
         this.allowGuests = subjectObj.allow_guests == null?Boolean(true):Boolean(subjectObj.allow_guests);
         this.friendsOnly = subjectObj.friends_only;
         this.minLevel = subjectObj.min_level;
         this.minRating = subjectObj.min_elo;
         this.avgLevel = subjectObj.avg_level;
         this.avgRating = subjectObj.avg_elo;
         this.libVersion = subjectObj.lib_version;
         this.thumbnailUrl = subjectObj.thumbnail_url;
         this.aboutString = subjectObj.about_string;
         this.predictedOpenTime = subjectObj.open_at;
         this.players = new PlayerCollection();
         if(subjectObj.player_data)
         {
            for(i = 0; i < subjectObj.player_data.length; i++)
            {
               p = new PlayerData();
               p.initFromStatusObject(subjectObj.player_data[i]);
               this.players.addPlayer(p);
            }
         }
      }
      
      public function copy(from:MatchListingData) : void
      {
         this.description = from.description;
         this.maxPlayers = from.maxPlayers;
         this.host = new PlayerData();
         this.host.initFromStatusObject(from.host.toStatusObject());
         this.creationTime = from.creationTime;
         this.gameId = from.gameId;
         this.config = from.config;
         this.approvedPlayerJids = from.approvedPlayerJids.slice(0);
         this.gameType = from.gameType;
         this.betAmount = from.betAmount;
         this.privateMatch = from.privateMatch;
         this.serverID = from.serverID;
         this.open = from.open;
         this.useItems = from.useItems;
         this.teamType = from.teamType;
         this.skillLevel = from.skillLevel;
         this.allowGuests = from.allowGuests;
         this.minLevel = from.minLevel;
         this.minRating = from.minRating;
         this.friendsOnly = from.friendsOnly;
         this.players = from.players.clone();
         this.thumbnailUrl = from.thumbnailUrl;
         this.aboutString = from.aboutString;
         this.predictedOpenTime = from.predictedOpenTime;
      }
      
      public function initFromApiResponse(json:*) : void
      {
         var unescaped:String = null;
         this.jid = new UnescapedJID(json.jid);
         this.matchName = this.jid.toString();
         this.uid = json.id;
         this.creationTime = Number(DataUtil.getMatchCreationTime(this.matchName));
         try
         {
            unescaped = unescape(json.subject);
            this.subjectObj = JSON.deserialize(unescaped);
         }
         catch(e:Error)
         {
            Logger.getLogger(this).error("Couldnt deserialize subject",json.subject);
         }
         if(this.subjectObj != null)
         {
            this.initFromSubjectObj(this.subjectObj);
         }
      }
      
      public function initFromServiceInfo(node:XML) : void
      {
         var disco:Namespace = null;
         var xns:Namespace = null;
         var rawSubject:String = null;
         disco = new Namespace("http://jabber.org/protocol/disco#info");
         xns = new Namespace("jabber:x:data");
         this.jid = new UnescapedJID(node.disco::identity.@name[0].toXMLString());
         this.matchName = this.jid.toString();
         this.creationTime = Number(DataUtil.getMatchCreationTime(this.matchName));
         rawSubject = node..xns::field.(attribute("label") == "Subject").xns::value;
         try
         {
            this.subjectObj = JSON.deserialize(rawSubject);
         }
         catch(e:Error)
         {
         }
         if(this.subjectObj != null)
         {
            this.initFromSubjectObj(this.subjectObj);
         }
      }
   }
}
