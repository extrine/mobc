package iilwy.model.dataobjects
{
   import iilwy.utils.MathUtil;
   import iilwy.utils.TestUtil;
   
   public class CommentData
   {
      
      public static const COMMENTED_ON_TYPE_NEWS:String = "news";
      
      public static const COMMENTED_ON_TYPE_VIDEO:String = "video";
       
      
      public var id:String;
      
      public var commentedOnId:String;
      
      public var commentedOnType:String;
      
      public var commentedOnHeadline:String;
      
      public var userId:String;
      
      public var profile:ProfileData;
      
      public var timeIndex:Number;
      
      public var timeDuration:Number;
      
      public var createdAt:Date;
      
      public var message:String;
      
      public var amount:Number;
      
      public var drawing:DrawingData;
      
      public var x:Number;
      
      public var y:Number;
      
      public function CommentData()
      {
         super();
         this.profile = new ProfileData();
         this.timeDuration = 2000;
      }
      
      public static function createTest(type:String = null) : CommentData
      {
         var comment:CommentData = new CommentData();
         if(type == COMMENTED_ON_TYPE_VIDEO)
         {
            comment.commentedOnType = COMMENTED_ON_TYPE_VIDEO;
            comment.timeIndex = Math.random() * (1000 * 30);
         }
         else
         {
            comment.commentedOnType = COMMENTED_ON_TYPE_NEWS;
         }
         comment.id = Math.floor(Math.random() * 1000).toString();
         comment.commentedOnId = Math.floor(Math.random() * 1000).toString();
         comment.message = TestUtil.generateLoremImsum(20);
         comment.amount = Math.floor(Math.random() * 1000);
         comment.profile = ProfileData.createTest();
         comment.createdAt = new Date(new Date().getTime() - Math.random() * 100000);
         if(Math.random() < 0.5)
         {
            comment.drawing = DrawingData.createTest();
         }
         comment.x = Math.random();
         comment.y = Math.random();
         return comment;
      }
      
      public function initFromJson(json:Object) : void
      {
         this.id = json.id;
         this.message = json.message;
         this.amount = json.amount;
         if(json.news_item_id != null)
         {
            this.commentedOnId = json.news_item_id;
            this.commentedOnType = "news";
            this.commentedOnHeadline = json.news_item_headline;
         }
         else if(json.viral_video_id != null)
         {
            this.commentedOnId = json.viral_video_id;
            this.commentedOnType = "video";
            this.commentedOnHeadline = json.viral_video_caption;
            this.timeIndex = json.time_code;
            this.timeDuration = MathUtil.clamp(1000,6000,this.message.length * 60);
         }
         this.profile = new ProfileData();
         this.profile.id = json.profile_id;
         this.profile.photo_url = json.photo_url;
         this.profile.profile_name = json.profile_name;
         if(json.drawing_id != null)
         {
            this.drawing = new DrawingData();
            this.drawing.url = json.drawing_filename;
            this.drawing.id = json.drawing_id;
            this.timeDuration = this.timeDuration + 1000;
            this.timeDuration = Math.max(this.timeDuration,2500);
         }
         this.x = json.x / 100000;
         this.y = json.y / 100000;
         this.createdAt = new Date(json.created_at * 1000);
      }
      
      public function equals(another:CommentData) : Boolean
      {
         var flag:Boolean = false;
         if(this.id == another.id)
         {
            flag = true;
         }
         return flag;
      }
      
      public function get commentedOnUrl() : String
      {
         var str:String = null;
         if(this.commentedOnType == COMMENTED_ON_TYPE_VIDEO)
         {
            str = "/video/" + this.commentedOnId;
         }
         else
         {
            str = "/news/" + this.commentedOnId;
         }
         return str;
      }
   }
}
