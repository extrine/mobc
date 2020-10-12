package iilwy.gamenet.model
{
   import iilwy.collections.ArrayCollection;
   import org.igniterealtime.xiff.core.UnescapedJID;
   
   public class MatchListingCollection extends ArrayCollection
   {
      
      public static var MATCHLIST_ADD:String = "matchlist_add";
      
      public static var MATCHLIST_DELETE:String = "matchlist_delete";
      
      public static var MATCHLIST_MODIFY:String = "matchlist_modify";
       
      
      private var _matches:Array;
      
      public function MatchListingCollection()
      {
         super();
         this._matches = new Array();
      }
      
      protected static function sortByPlayerCount(a:MatchListingData, b:MatchListingData) : int
      {
         if(a.approvedPlayerJids.length == b.approvedPlayerJids.length)
         {
            return 0;
         }
         return a.approvedPlayerJids.length < b.approvedPlayerJids.length?int(-1):int(1);
      }
      
      public function addMatch(match:MatchListingData) : Boolean
      {
         var exists:MatchListingData = this.findMatchByJid(match.jid);
         if(exists == null)
         {
            addItem(match);
            return true;
         }
         return false;
      }
      
      public function removeMatch(match:MatchListingData) : Boolean
      {
         var i:int = this.getIndexOf(match);
         if(i != -1)
         {
            removeItemAt(i);
            return true;
         }
         return false;
      }
      
      public function modifyMatch(oldMatch:MatchListingData, newMatch:MatchListingData) : void
      {
         var i:int = this.getIndexOf(oldMatch);
         oldMatch.copy(newMatch);
         itemUpdated(oldMatch);
      }
      
      public function findMatchByJid(jid:UnescapedJID) : MatchListingData
      {
         var item:MatchListingData = null;
         for(var i:int = 0; i < length; i++)
         {
            item = getItemAt(i) as MatchListingData;
            if(item.jid.equals(jid,true))
            {
               return item;
            }
         }
         return null;
      }
      
      public function getIndexOf(match:MatchListingData) : int
      {
         var item:MatchListingData = null;
         for(var i:int = 0; i < length; i++)
         {
            item = getItemAt(i) as MatchListingData;
            if(match != null && item != null && item.jid.equals(match.jid,true))
            {
               return i;
            }
         }
         return -1;
      }
      
      public function sortedByPlayerCount() : Array
      {
         var result:Array = source.slice(0);
         result.sort(sortByPlayerCount);
         return result;
      }
      
      public function openMatchesSortedByPlayerCount() : Array
      {
         var match:MatchListingData = null;
         var result:Array = [];
         for(var i:int = 0; i < source.length; i++)
         {
            match = getItemAt(i) as MatchListingData;
            if(match.isOpen)
            {
               result.push(match);
            }
         }
         result.sort(sortByPlayerCount);
         return result;
      }
      
      public function closedMatchesSortedByPlayerCount() : Array
      {
         var match:MatchListingData = null;
         var result:Array = [];
         for(var i:int = 0; i < source.length; i++)
         {
            match = getItemAt(i) as MatchListingData;
            if(!match.isOpen)
            {
               result.push(match);
            }
         }
         result.sort(sortByPlayerCount);
         return result;
      }
      
      public function getMatchJids() : Array
      {
         var arr:Array = [];
         for(var i:int = 0; i < length; i++)
         {
            arr.push(MatchListingData(getItemAt(i)).jid.toString());
         }
         return arr;
      }
      
      public function getMatchUids() : Array
      {
         var arr:Array = [];
         for(var i:int = 0; i < length; i++)
         {
            arr.push(MatchListingData(getItemAt(i)).uid);
         }
         return arr;
      }
      
      public function find_openmatch(name:String) : MatchListingData
      {
         var i:int = 0;
         for(i = 0; i < this._matches.length; i++)
         {
            if(this._matches[i].game_name == name && this._matches[i].open)
            {
               return this._matches[i];
            }
         }
         return null;
      }
      
      public function get_number_matches() : int
      {
         return this._matches.length;
      }
      
      public function get_match(i:int) : MatchListingData
      {
         if(i < this._matches.length)
         {
            return this._matches[i];
         }
         return null;
      }
      
      public function cloneSource() : Array
      {
         var match:MatchListingData = null;
         var result:Array = [];
         for each(match in source)
         {
            result.push(match);
         }
         return result;
      }
   }
}
