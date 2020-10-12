package iilwy.display.core
{
   import iilwy.application.AppProperties;
   import iilwy.model.dataobjects.DrawingData;
   import iilwy.model.dataobjects.quiz.QuizQuestion;
   import iilwy.net.EventNotificationType;
   import iilwy.net.MediaProxy;
   
   public class NotificationManagerData
   {
      
      public static const IMG_QUESTION:String = "graphics-notifications-question.png";
      
      public static const IMG_CONFIRMATION:String = "graphics-notifications-confirm.png";
      
      public static const IMG_ERROR:String = "graphics-notifications-error.png";
      
      public static const IMG_SYSMSG:String = "graphics-notifications-message.png";
      
      public static const IMG_POINTS:String = "graphics-notifications-points.png";
       
      
      public var title:String;
      
      public var message:String;
      
      public var type:String;
      
      public var image:String;
      
      public var link:String;
      
      public var drawing:DrawingData;
      
      public var suppressable:Boolean = true;
      
      public var callback:Function;
      
      public var header:String;
      
      public var yesLabel:String = "OK";
      
      public var noLabel:String = "Cancel";
      
      public var autoCloseDelay:Number = 10000;
      
      public var data;
      
      public var actionType:String;
      
      public function NotificationManagerData()
      {
         super();
      }
      
      public static function createConfirmation(message:String) : NotificationManagerData
      {
         var n:NotificationManagerData = new NotificationManagerData();
         n.message = message;
         n.image = AppProperties.fileServerStatic + IMG_CONFIRMATION;
         n.suppressable = false;
         return n;
      }
      
      public static function createError(message:String) : NotificationManagerData
      {
         var n:NotificationManagerData = new NotificationManagerData();
         n.message = message;
         n.image = AppProperties.fileServerStatic + IMG_ERROR;
         n.suppressable = false;
         return n;
      }
      
      public static function createPoints(message:String) : NotificationManagerData
      {
         var n:NotificationManagerData = new NotificationManagerData();
         n.message = message;
         n.image = AppProperties.fileServerStatic + IMG_POINTS;
         n.suppressable = false;
         return n;
      }
      
      public static function createQuizQuestion(question:QuizQuestion) : NotificationManagerData
      {
         var n:NotificationManagerData = new NotificationManagerData();
         n.type = EventNotificationType.QUIZ_QUESTION;
         n.message = question.question;
         n.image = AppProperties.fileServerStatic + IMG_QUESTION;
         n.data = question;
         return n;
      }
      
      public static function createFromRemote(data:*) : NotificationManagerData
      {
         var n:NotificationManagerData = null;
         var img:String = null;
         var imgmap:* = undefined;
         try
         {
            n = new NotificationManagerData();
            img = data.e_image;
            if(data.e_type == EventNotificationType.SYSTEM_MESSAGE)
            {
               img = AppProperties.fileServerStatic + IMG_CONFIRMATION;
            }
            else if(data.e_type == EventNotificationType.QUIZ_QUESTION)
            {
               img = AppProperties.fileServerStatic + IMG_QUESTION;
            }
            else if(img && img.indexOf("/gfx/message_icons/") >= 0 || img == "#")
            {
               imgmap = {};
               imgmap["#"] = AppProperties.fileServerStatic + IMG_SYSMSG;
               imgmap["http://www.iminlikewithyou.com/gfx/message_icons/question.gif"] = AppProperties.fileServerStatic + IMG_QUESTION;
               imgmap["http://www.iminlikewithyou.com/gfx/message_icons/message.gif"] = AppProperties.fileServerStatic + IMG_SYSMSG;
               imgmap["http://www.iminlikewithyou.com/gfx/message_icons/error.gif"] = AppProperties.fileServerStatic + IMG_ERROR;
               img = imgmap[data.e_image];
            }
            else if(img && img.indexOf("http://media") >= 0)
            {
               img = MediaProxy.url(img,MediaProxy.SIZE_MEDIUM_THUMB);
            }
            n.image = img;
            n.title = data.e_title;
            n.link = data.e_link;
            n.message = data.e_message;
            n.type = data.e_type;
            if(data.drawing_filename != null)
            {
               n.drawing = new DrawingData();
               n.drawing.url = data.drawing_filename;
            }
            if(data.e_drawing_filename != null)
            {
               n.drawing = new DrawingData();
               n.drawing.url = data.e_drawing_filename;
            }
            if(n.type == EventNotificationType.USER_LOGIN)
            {
               n.autoCloseDelay = 2000;
            }
            n.data = data;
         }
         catch(e:Error)
         {
         }
         return n;
      }
      
      public function get hasIconImage() : Boolean
      {
         var b:Boolean = false;
         if(this.image)
         {
            if(this.image.indexOf("/graphics-") >= 0 || this.image.indexOf(IMG_QUESTION) >= 0 || this.image.indexOf(IMG_CONFIRMATION) >= 0 || this.image.indexOf(IMG_ERROR) >= 0 || this.image.indexOf(IMG_SYSMSG) >= 0 || this.image.indexOf("achievement_asset") >= 0)
            {
               b = true;
            }
         }
         return b;
      }
      
      public function equivalent(other:NotificationManagerData) : Boolean
      {
         var b:Boolean = false;
         if(this.message == other.message && this.image == other.image)
         {
            b = true;
         }
         else if(this.type == EventNotificationType.QUIZ_QUESTION && other.type == EventNotificationType.QUIZ_QUESTION)
         {
            b = true;
         }
         return b;
      }
   }
}
