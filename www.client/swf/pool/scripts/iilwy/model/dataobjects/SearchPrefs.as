package iilwy.model.dataobjects
{
   import iilwy.application.AppComponents;
   import iilwy.events.ModelEvent;
   
   public class SearchPrefs
   {
      
      public static const WATCH_ITEMS:String = "only_watch_items";
      
      public static const CONTACTS:String = "contacts";
      
      public static const FRIENDS_OF_FRIENDS:String = "contacts_contacts";
      
      public static const GAMES_YOUR_FRIENDS_BID_ON:String = "games_contacts_bid_on";
      
      public static const LAST_LOGIN_SORT:String = "last_login";
      
      public static const NEW_MEMBERS_SORT:String = "new_members";
      
      public static const GAMES_CLOSING_SORT:String = "games_closing";
      
      public static const NEW_GAMES_SORT:String = "new_games";
      
      public static const HIGH_BID_SORT:String = "high_bid";
       
      
      private var _radius:String = "";
      
      private var _age_bottom:String = "";
      
      private var _zip:String = "";
      
      private var _gender:String = "";
      
      private var _age_top:String = "";
      
      private var _filters:String = "";
      
      private var _order:String = "";
      
      public var ethnicity:String = "";
      
      public var results_per_page:String = "";
      
      public var display_mode:String = "";
      
      public var orientation:String = "";
      
      public var id:String = "";
      
      public var mobile_photos:String = "";
      
      public var user_id:String = "";
      
      private var _changedPrefs:Object;
      
      public function SearchPrefs()
      {
         super();
         this._changedPrefs = new Object();
      }
      
      public static function createTest() : SearchPrefs
      {
         var data:SearchPrefs = new SearchPrefs();
         data.zip = "10002";
         data.age_bottom = "21";
         data.age_top = "33";
         return data;
      }
      
      public function getChangedPreferences() : Object
      {
         return this._changedPrefs;
      }
      
      public function getChangedSearchPrefsAsQueryString() : String
      {
         var p:* = undefined;
         var qstring:String = "";
         for(p in this._changedPrefs)
         {
            qstring = qstring + ("search_pref[" + p + "]=" + this._changedPrefs[p] + "&");
         }
         this.clearChangedPrefs();
         return qstring;
      }
      
      private function clearChangedPrefs() : void
      {
         var p:* = undefined;
         for(p in this._changedPrefs)
         {
            delete this._changedPrefs[p];
         }
         this._changedPrefs = null;
         this._changedPrefs = new Object();
      }
      
      public function initFromJSON(json:Object) : void
      {
         this.clearChangedPrefs();
         this.age_bottom = json.age_bottom;
         this.results_per_page = json.results_per_page;
         this.radius = json.radius;
         this.age_top = json.age_top;
         this.zip = json.zip;
         this.ethnicity = json.ethnicity;
         this.display_mode = json.display_mode;
         this.filters = json.filters;
         this.orientation = json.orientation;
         this.gender = json.gender;
         this.id = json.id;
         this.mobile_photos = json.mobile_photos;
         this._order = json.order;
         AppComponents.model.dispatchEvent(new ModelEvent(ModelEvent.SEARCH_PREFS_CHANGED));
      }
      
      public function get zip() : String
      {
         return this._zip;
      }
      
      public function set zip(val:String) : void
      {
         if(val == null)
         {
            this._zip = "";
         }
         else
         {
            this._zip = val;
            this.changedPrefs.zip = val;
         }
      }
      
      public function get age_bottom() : String
      {
         return this._age_bottom;
      }
      
      public function set age_bottom(val:String) : void
      {
         if(val == null)
         {
            this._age_bottom = "";
         }
         else
         {
            this._age_bottom = val;
            this.changedPrefs.age_bottom = val;
         }
      }
      
      public function get radius() : String
      {
         return this._radius;
      }
      
      public function set radius(val:String) : void
      {
         if(val == null)
         {
            this._radius = "";
         }
         else
         {
            this._radius = val;
            this.changedPrefs.radius = val;
         }
      }
      
      public function get age_top() : String
      {
         return this._age_top;
      }
      
      public function set age_top(val:String) : void
      {
         if(val == null)
         {
            this._age_top = "";
         }
         else
         {
            this._age_top = val;
            this.changedPrefs.age_top = val;
         }
      }
      
      public function get gender() : String
      {
         return this._gender;
      }
      
      public function set gender(val:String) : void
      {
         if(val == null)
         {
            this._gender = "";
         }
         else
         {
            this._gender = val;
            this.changedPrefs.gender = val;
         }
      }
      
      public function get filters() : String
      {
         return this._filters;
      }
      
      public function set filters(val:String) : void
      {
         if(val == null)
         {
            this._filters = "";
         }
         else
         {
            this._filters = val;
            this.changedPrefs.filters = val;
         }
      }
      
      public function get order() : String
      {
         return this._order;
      }
      
      public function set order(val:String) : void
      {
         if(val == null)
         {
            this._order = "";
         }
         else
         {
            this._order = val;
            this.changedPrefs.order = val;
         }
      }
      
      private function set changedPrefs(e:*) : void
      {
         this._changedPrefs = e;
         AppComponents.model.dispatchEvent(new ModelEvent(ModelEvent.SEARCH_PREFS_CHANGED));
      }
      
      private function get changedPrefs() : *
      {
         return this._changedPrefs;
      }
   }
}
