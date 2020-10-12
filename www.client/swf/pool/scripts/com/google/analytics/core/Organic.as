package com.google.analytics.core
{
   import com.google.analytics.utils.Variables;
   
   public class Organic
   {
      
      public static var throwErrors:Boolean = false;
       
      
      private var _sources:Array;
      
      private var _sourcesCache:Array;
      
      private var _sourcesEngine:Array;
      
      private var _ignoredReferrals:Array;
      
      private var _ignoredReferralsCache:Object;
      
      private var _ignoredKeywords:Array;
      
      private var _ignoredKeywordsCache:Object;
      
      public function Organic()
      {
         super();
         this._sources = [];
         this._sourcesCache = [];
         this._sourcesEngine = [];
         this._ignoredReferrals = [];
         this._ignoredReferralsCache = {};
         this._ignoredKeywords = [];
         this._ignoredKeywordsCache = {};
      }
      
      public static function getKeywordValueFromPath(keyword:String, path:String) : String
      {
         var value:String = null;
         var vars:Variables = null;
         if(path.indexOf(keyword + "=") > -1)
         {
            if(path.charAt(0) == "?")
            {
               path = path.substr(1);
            }
            path = path.split("+").join("%20");
            vars = new Variables(path);
            value = vars[keyword];
         }
         return value;
      }
      
      public function get count() : int
      {
         return this._sources.length;
      }
      
      public function get sources() : Array
      {
         return this._sources;
      }
      
      public function get ignoredReferralsCount() : int
      {
         return this._ignoredReferrals.length;
      }
      
      public function get ignoredKeywordsCount() : int
      {
         return this._ignoredKeywords.length;
      }
      
      public function addSource(engine:String, keyword:String) : void
      {
         var orgref:OrganicReferrer = new OrganicReferrer(engine,keyword);
         if(this._sourcesCache[orgref.toString()] == undefined)
         {
            this._sources.push(orgref);
            this._sourcesCache[orgref.toString()] = this._sources.length - 1;
            if(this._sourcesEngine[orgref.engine] == undefined)
            {
               this._sourcesEngine[orgref.engine] = [this._sources.length - 1];
            }
            else
            {
               this._sourcesEngine[orgref.engine].push(this._sources.length - 1);
            }
         }
         else if(throwErrors)
         {
            throw new Error(orgref.toString() + " already exists, we don\'t add it.");
         }
      }
      
      public function addIgnoredReferral(referrer:String) : void
      {
         if(this._ignoredReferralsCache[referrer] == undefined)
         {
            this._ignoredReferrals.push(referrer);
            this._ignoredReferralsCache[referrer] = this._ignoredReferrals.length - 1;
         }
         else if(throwErrors)
         {
            throw new Error("\"" + referrer + "\" already exists, we don\'t add it.");
         }
      }
      
      public function addIgnoredKeyword(keyword:String) : void
      {
         if(this._ignoredKeywordsCache[keyword] == undefined)
         {
            this._ignoredKeywords.push(keyword);
            this._ignoredKeywordsCache[keyword] = this._ignoredKeywords.length - 1;
         }
         else if(throwErrors)
         {
            throw new Error("\"" + keyword + "\" already exists, we don\'t add it.");
         }
      }
      
      public function clear() : void
      {
         this.clearEngines();
         this.clearIgnoredReferrals();
         this.clearIgnoredKeywords();
      }
      
      public function clearEngines() : void
      {
         this._sources = [];
         this._sourcesCache = [];
         this._sourcesEngine = [];
      }
      
      public function clearIgnoredReferrals() : void
      {
         this._ignoredReferrals = [];
         this._ignoredReferralsCache = {};
      }
      
      public function clearIgnoredKeywords() : void
      {
         this._ignoredKeywords = [];
         this._ignoredKeywordsCache = {};
      }
      
      public function getKeywordValue(or:OrganicReferrer, path:String) : String
      {
         var keyword:String = or.keyword;
         return getKeywordValueFromPath(keyword,path);
      }
      
      public function getReferrerByName(name:String) : OrganicReferrer
      {
         var index:int = 0;
         if(this.match(name))
         {
            index = this._sourcesEngine[name][0];
            return this._sources[index];
         }
         return null;
      }
      
      public function isIgnoredReferral(referrer:String) : Boolean
      {
         if(this._ignoredReferralsCache.hasOwnProperty(referrer))
         {
            return true;
         }
         return false;
      }
      
      public function isIgnoredKeyword(keyword:String) : Boolean
      {
         if(this._ignoredKeywordsCache.hasOwnProperty(keyword))
         {
            return true;
         }
         return false;
      }
      
      public function match(name:String) : Boolean
      {
         if(name == "")
         {
            return false;
         }
         name = name.toLowerCase();
         if(this._sourcesEngine[name] != undefined)
         {
            return true;
         }
         return false;
      }
   }
}
