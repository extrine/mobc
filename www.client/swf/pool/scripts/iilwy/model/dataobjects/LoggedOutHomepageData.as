package iilwy.model.dataobjects
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import iilwy.collections.ArrayCollection;
   
   public class LoggedOutHomepageData extends EventDispatcher
   {
       
      
      public var newsAndVideos:Array;
      
      public var arcade:Array;
      
      public var people:Array;
      
      public var loaded:Boolean = false;
      
      public var featuredPeople:ArrayCollection;
      
      public function LoggedOutHomepageData()
      {
         super();
         this.newsAndVideos = new Array();
         this.people = new Array();
      }
      
      public function initFromJson(json:*) : void
      {
         var i:int = 0;
         var obj:* = undefined;
         var g:ProfileData = null;
         var tNewsItems:Array = json.news_items;
         var tVideoItems:Array = json.viral_videos;
         var vitem:ViralMediaData = null;
         obj = tVideoItems.shift();
         vitem = new ViralMediaData();
         vitem.initFromVideoJSON(obj);
         if(vitem && vitem.id)
         {
            this.newsAndVideos.push(vitem);
         }
         obj = tVideoItems.shift();
         vitem = new ViralMediaData();
         vitem.initFromVideoJSON(obj);
         if(vitem && vitem.id)
         {
            this.newsAndVideos.push(vitem);
         }
         for(i = 0; i < 20; i++)
         {
            try
            {
               if(i % 2 == 0)
               {
                  obj = tVideoItems.shift();
                  vitem = new ViralMediaData();
                  vitem.initFromVideoJSON(obj);
               }
               else
               {
                  obj = tNewsItems.shift();
                  vitem = new ViralMediaData();
                  vitem.initFromJSON(obj);
               }
            }
            catch(e:Error)
            {
            }
            if(vitem && vitem.id)
            {
               this.newsAndVideos.push(vitem);
            }
         }
         this.arcade = json.arcade;
         this.arcade[0].photos = ["homepage-blockles-1.jpg","homepage-blockles-2.jpg","homepage-blockles-3.jpg"];
         for(i = 0; i < json.people.length; i++)
         {
            g = new ProfileData();
            g.initFromJSON(json.people[i]);
            this.people.push(g);
         }
         for(i = 0; i < 3; i++)
         {
            this.people.unshift(this.people.splice(Math.floor(Math.random() * this.people.length),1)[0]);
         }
      }
      
      public function createTest() : void
      {
         var i:int = 0;
         var g:ProfileData = null;
         var obj:* = undefined;
         var vitem:ViralMediaData = null;
         this.arcade = new Array();
         this.arcade[0] = {
            "name":"Blockles",
            "id":"blockles",
            "time_spent":10000000,
            "total_matches":10000
         };
         for(i = 0; i < 10; i++)
         {
            g = ProfileData.createTest();
            this.people.push(g);
         }
         var tNewsItems:Array = JSON.deserialize(this.testNewsItems).news_items;
         var tVideoItems:Array = JSON.deserialize(this.testVideoItems).video_items;
         for(i = 0; i < 10; i++)
         {
            try
            {
               if(i % 2 == 0)
               {
                  obj = tNewsItems.shift();
                  vitem = new ViralMediaData();
                  vitem.initFromJSON(obj);
               }
               else
               {
                  obj = tVideoItems.shift();
                  vitem = new ViralMediaData();
                  vitem.initFromVideoJSON(obj);
               }
            }
            catch(e:Error)
            {
            }
            if(vitem.id)
            {
               this.newsAndVideos.push(vitem);
            }
         }
         this.loaded = true;
         var t:Timer = new Timer(300,1);
         t.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTestLoaded);
         t.start();
      }
      
      private function onTestLoaded(event:TimerEvent) : void
      {
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      private function get testVideoItems() : String
      {
         var str:String = null;
         return str;
      }
      
      private function get testNewsItems() : String
      {
         var str:String = null;
         return str;
      }
   }
}
