package iilwy.model.dataobjects
{
   import iilwy.utils.TextUtil;
   
   public class ViralMediaData
   {
      
      public static const TYPE_NEWS:String = "news";
      
      public static const TYPE_VIDEO:String = "video";
       
      
      public var imageUrl:String = "";
      
      public var subHeadline:String = "";
      
      public var headLine:String = "";
      
      public var authorText:String = "";
      
      public var authorImageUrl:String = "";
      
      public var articleText:String = "";
      
      public var authorProfile:String = "";
      
      public var videoUrl:String = "";
      
      public var date:String = "Today";
      
      public var id:String;
      
      public var linkUrl:String;
      
      public var linkLabel:String;
      
      public var gameID:String;
      
      public var type:String;
      
      public var commentList:CommentListData;
      
      public var commentCount:Number;
      
      public var detailsLoaded:Boolean = false;
      
      public var previousItem:ViralMediaData;
      
      public var nextItem:ViralMediaData;
      
      public function ViralMediaData()
      {
         super();
         this.commentList = new CommentListData();
      }
      
      public static function createTestVideo() : ViralMediaData
      {
         var article:ViralMediaData = new ViralMediaData();
         var json:Object = JSON.deserialize("{\"viral_video\":{\"profile_photo_url\":\"http://media.beta.iminlikewithyou.com/1/photos/1rx7dfxadyjox6o.jpg\",\"pub_date\":1193862840,\"created_at\":1193862910,\"previous_item\":null,\"next_item\":{\"caption\":\"Lighting water on fire\",\"id\":2},\"profile_name\":\"Charles\",\"caption\":\"LEAVE BRITNEY ALONE\",\"comments\":[],\"filename\":\"http%3A%2F%2Fvideo.iminlikewithyou.com%2F1%2Fviral_videos%2F1r155dfh3fy28o2GqtjOn9qVg4.flv\",\"id\":4,\"description\":\"ej. i find myself falling in love with this girl.\"}}");
         article.initFromVideoJSON(json.viral_video);
         article.commentList = CommentListData.createTest(CommentData.COMMENTED_ON_TYPE_VIDEO);
         return article;
      }
      
      public static function createTest() : ViralMediaData
      {
         var article:ViralMediaData = new ViralMediaData();
         var json:Object = JSON.deserialize("{\"news_item\":{\"sub_headline\":\"poop and pee and wieners and piss\",\"body\":\"Pop yourself a squat because Im about to reveal to you an incredibly important decision as made by an incredibly important member of society. Are you sitting? Okay. Here goes: <a href=&quot;http://www.halle-berry.org/&quot;>Halle Berry</a> has chosen to ensure the safety of her as-yet-unborn babys… POOP. Awriiight! Shes gonna be wrapping that babys bum in organic. Having opted to house the thing in an entirely eco-friendly nursery (which Im sure isnt in the least expensive), Halle is taking into special consideration the wellbeing of kid-dingleBerrys behind, <a href=&quot;http://www.people.com/people/article/0,,20152636,00.html?xid=rss-topheadlines&quot;>a matter of interest to PEOPLE</a>, apparently. &quot;They even have <a href=&quot;http://www.ecobaby.com/&quot;>organic disposable diapers</a> now that you can use, Berry, showing her growing baby bump, told PEOPLE.&quot; Well, Halle-effin-lujah! Why just the other day I was saying to my friends growing baby bump (ew), &quot;Im really concerned about the state of the world and what kind of person youll be, but Im primarily concerned about your ass and the quality of the stuff in which youll shit.&quot; For whatever reason, PEOPLE didnt write about me. Say, is poop organic? Or does it depend on what you eat, HB? Wait. I guess I dont care and/or ganic get over yourself.\",\"profile_name\":\"heather\",\"link_text\":\"\",\"link_href\":\"\",\"headline\":\"Halle Berry: Saving Behinds, Baby!\",\"comments\":[{\"x\":61527.0,\"message\":\"hola\",\"profile_name\":\"ejm\",\"drawing_id\":null,\"y\":76588.0,\"drawing_filename\":null,\"news_item_id\":195,\"amount\":10,\"news_item_headline\":\"Halle Berry: Saving Behinds, Baby!\",\"photo_url\":\"http://media.iminlikewithyou.com/120/photos/1202dmsy2wyyoxpjg.jpg\",\"id\":78,\"profile_id\":118,\"created_at\":1193179377},{\"x\":19508.0,\"message\":\"sagtacular\",\"profile_name\":\"setpixel\",\"drawing_id\":1449,\"y\":81609.0,\"drawing_filename\":\"http://drawring.iminlikewithyou.com/11433/drawings/11433b15oga311wj8wz.jpg\",\"news_item_id\":195,\"amount\":20,\"news_item_headline\":\"Halle Berry: Saving Behinds, Baby!\",\"photo_url\":\"http://media.iminlikewithyou.com/11433/photos/11433izzvz64w5l0rh0.jpg\",\"id\":61,\"profile_id\":11115,\"created_at\":1193167606},{\"x\":29932.0,\"message\":\"nose\",\"profile_name\":\"ejm\",\"drawing_id\":null,\"y\":32486.0,\"drawing_filename\":null,\"news_item_id\":195,\"amount\":35,\"news_item_headline\":\"Halle Berry: Saving Behinds, Baby!\",\"photo_url\":\"http://media.iminlikewithyou.com/120/photos/1202dmsy2wyyoxpjg.jpg\",\"id\":75,\"profile_id\":118,\"created_at\":1193179122},{\"x\":24706.0,\"message\":\"botox\",\"profile_name\":\"ejm\",\"drawing_id\":null,\"y\":20327.0,\"drawing_filename\":null,\"news_item_id\":195,\"amount\":40,\"news_item_headline\":\"Halle Berry: Saving Behinds, Baby!\",\"photo_url\":\"http://media.iminlikewithyou.com/120/photos/1202dmsy2wyyoxpjg.jpg\",\"id\":74,\"profile_id\":118,\"created_at\":1193178227},{\"x\":35871.0,\"message\":\"eye\",\"profile_name\":\"ejm\",\"drawing_id\":null,\"y\":23412.0,\"drawing_filename\":null,\"news_item_id\":195,\"amount\":57,\"news_item_headline\":\"Halle Berry: Saving Behinds, Baby!\",\"photo_url\":\"http://media.iminlikewithyou.com/120/photos/1202dmsy2wyyoxpjg.jpg\",\"id\":76,\"profile_id\":118,\"created_at\":1193179161},{\"x\":64853.0,\"message\":\"mic\",\"profile_name\":\"ejm\",\"drawing_id\":null,\"y\":60436.0,\"drawing_filename\":null,\"news_item_id\":195,\"amount\":80,\"news_item_headline\":\"Halle Berry: Saving Behinds, Baby!\",\"photo_url\":\"http://media.iminlikewithyou.com/120/photos/1202dmsy2wyyoxpjg.jpg\",\"id\":79,\"profile_id\":118,\"created_at\":1193179480},{\"x\":93835.0,\"message\":\"shoulder\",\"profile_name\":\"ejm\",\"drawing_id\":null,\"y\":48639.0,\"drawing_filename\":null,\"news_item_id\":195,\"amount\":100,\"news_item_headline\":\"Halle Berry: Saving Behinds, Baby!\",\"photo_url\":\"http://media.iminlikewithyou.com/120/photos/1202dmsy2wyyoxpjg.jpg\",\"id\":80,\"profile_id\":118,\"created_at\":1193179647},{\"x\":70361.0,\"message\":\"neck1\",\"profile_name\":\"ejm\",\"drawing_id\":null,\"y\":43004.0,\"drawing_filename\":null,\"news_item_id\":195,\"amount\":120,\"news_item_headline\":\"Halle Berry: Saving Behinds, Baby!\",\"photo_url\":\"http://media.iminlikewithyou.com/120/photos/1202dmsy2wyyoxpjg.jpg\",\"id\":108,\"profile_id\":118,\"created_at\":1193241968}],\"photo_url\":\"http://media.iminlikewithyou.com/541/photos/541hmtkxlf0gnkycc.jpg\",\"profile_photo_url\":\"http://media.iminlikewithyou.com/541/photos/541p10lrg7kd0k0e7.jpg\",\"created_at\":1192567647,\"id\":195,\"pub_date\":1192567440},\"ts\":1193333996}");
         article.initFromJSON(json.news_item);
         return article;
      }
      
      public function initFromJSON(newsItem:Object) : void
      {
         this.type = TYPE_NEWS;
         this.imageUrl = String(newsItem.photo_url);
         this.subHeadline = String(newsItem.sub_headline);
         this.headLine = String(newsItem.headline);
         this.authorText = String(newsItem.profile_name);
         this.authorImageUrl = String(newsItem.profile_photo_url);
         this.authorProfile = "Setpixel";
         this.commentCount = newsItem.comment_count;
         var e:String = TextUtil.replaceChars(newsItem.body);
         this.articleText = e;
         this.id = newsItem.id;
         this.commentList = new CommentListData();
         this.commentList.initFromJson(newsItem.comments);
         this.commentList.commentedOnId = this.id;
         this.commentList.commentedOnType = CommentData.COMMENTED_ON_TYPE_NEWS;
         if(newsItem.next_item != null)
         {
            this.nextItem = new ViralMediaData();
            this.nextItem.id = newsItem.next_item.id;
            this.nextItem.headLine = newsItem.next_item.headline;
         }
         if(newsItem.previous_item != null)
         {
            this.previousItem = new ViralMediaData();
            this.previousItem.id = newsItem.previous_item.id;
            this.previousItem.headLine = newsItem.previous_item.headline;
         }
      }
      
      public function initFromVideoJSON(json:Object) : void
      {
         this.type = TYPE_VIDEO;
         this.imageUrl = String(unescape(json.filename));
         this.videoUrl = String(unescape(json.filename));
         this.subHeadline = String(json.description);
         this.headLine = String(json.caption);
         this.authorText = String(json.profile_name);
         this.authorImageUrl = String(json.profile_photo_url);
         this.authorProfile = "Setpixel";
         this.id = json.id;
         this.commentCount = json.comment_count;
         this.commentList = new CommentListData();
         if(json.comments != null)
         {
            this.commentList.initFromJson(json.comments);
            this.commentList.commentedOnId = this.id;
            this.commentList.commentedOnType = CommentData.COMMENTED_ON_TYPE_VIDEO;
         }
         if(json.next_item != null)
         {
            this.nextItem = new ViralMediaData();
            this.nextItem.id = json.next_item.id;
            this.nextItem.headLine = json.next_item.headline;
            this.nextItem.type = ViralMediaData.TYPE_VIDEO;
         }
         if(json.previous_item != null)
         {
            this.previousItem = new ViralMediaData();
            this.previousItem.id = json.previous_item.id;
            this.previousItem.headLine = json.previous_item.headline;
            this.previousItem.type = ViralMediaData.TYPE_VIDEO;
         }
      }
      
      public function get url() : String
      {
         var str:String = null;
         if(this.type == TYPE_VIDEO)
         {
            str = "/video/" + this.id;
         }
         else
         {
            str = "/news/" + this.id;
         }
         return str;
      }
   }
}
