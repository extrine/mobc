package iilwy.gamenet.model
{
   import iilwy.collections.ArrayCollection;
   
   public class PlayerCollection extends ArrayCollection
   {
       
      
      private var _players:Array;
      
      private var _jidHash:Object;
      
      private var _profileHash:Object;
      
      private var _userIDHash:Object;
      
      public function PlayerCollection()
      {
         super();
         this._players = new Array();
         this._jidHash = {};
         this._profileHash = {};
         this._userIDHash = {};
      }
      
      override public function addItem(item:*) : void
      {
         super.addItem(item);
      }
      
      public function addPlayer(player:PlayerData) : Boolean
      {
         return this.addPlayerAt(player,length);
      }
      
      public function addPlayerAt(player:PlayerData, index:int) : Boolean
      {
         var match:PlayerData = this.findPlayerByJid(player.playerJid);
         if(match == null)
         {
            this._jidHash[player.playerJid] = player;
            this._profileHash[player.profileId] = player;
            this._userIDHash[player.userId] = player;
            addItemAt(player,index);
            return true;
         }
         return false;
      }
      
      public function setPlayerAt(player:PlayerData, index:int) : Boolean
      {
         var match:PlayerData = this.findPlayerByJid(player.playerJid);
         if(match == null)
         {
            this._jidHash[player.playerJid] = player;
            this._profileHash[player.profileId] = player;
            this._userIDHash[player.userId] = player;
            setItemAt(player,index);
            return true;
         }
         return false;
      }
      
      public function removePlayer(plyr:PlayerData) : Boolean
      {
         var index:int = this.findIndexByJid(plyr.playerJid);
         if(index != -1)
         {
            removeItemAt(index);
            delete this._jidHash[plyr.playerJid];
            delete this._profileHash[plyr.profileId];
            delete this._userIDHash[plyr.userId];
            return true;
         }
         return false;
      }
      
      public function modifyPlayer(oldPlayer:PlayerData, newPlayer:PlayerData) : void
      {
         oldPlayer.copy(newPlayer);
         itemUpdated(oldPlayer);
      }
      
      public function findPlayerByJid(jid:String) : PlayerData
      {
         var player:PlayerData = this._jidHash[jid];
         return player;
      }
      
      public function findIndexByJid(jid:String) : int
      {
         var i:int = 0;
         for(i = 0; i < source.length; i++)
         {
            if(PlayerData(source[i]).playerJid == jid)
            {
               return i;
            }
         }
         return -1;
      }
      
      public function findPlayerByProfileId(id:String) : PlayerData
      {
         var player:PlayerData = this._profileHash[id];
         return player;
      }
      
      public function findPlayerByUserId(id:int) : PlayerData
      {
         var player:PlayerData = this._userIDHash[id];
         return player;
      }
      
      override public function removeAll() : void
      {
         this._jidHash = {};
         this._profileHash = {};
         this._userIDHash = {};
         super.removeAll();
      }
      
      public function toObject() : Array
      {
         var json:Array = [];
         for(var i:int = 0; i < length; i++)
         {
            json.push(PlayerData(getItemAt(i)).toMinimizedStatusObject());
         }
         return json;
      }
      
      public function clone() : PlayerCollection
      {
         var i:int = 0;
         for(var col:PlayerCollection = new PlayerCollection(); i < length; )
         {
            col.addPlayer(PlayerData(getItemAt(i)).clone());
            i++;
         }
         return col;
      }
   }
}
