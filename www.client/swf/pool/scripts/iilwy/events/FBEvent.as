package iilwy.events
{
   import com.facebook.graph.data.FacebookSession;
   import com.facebook.graph.data.api.user.FacebookUser;
   import com.facebook.graph.data.fql.user.FQLUser;
   import com.facebook.graph.data.ui.apprequest.AppRequest;
   import com.facebook.graph.data.ui.credits.Credits;
   import com.facebook.graph.data.ui.stream.Stream;
   import flash.events.Event;
   import iilwy.model.dataobjects.chat.ChatUser;
   import iilwy.model.dataobjects.facebook.FBLoginOptions;
   import iilwy.model.dataobjects.facebook.FBTrackingParams;
   import iilwy.model.dataobjects.shop.CatalogProduct;
   
   public class FBEvent extends ResponderEvent
   {
      
      public static const APP_REQUEST:String = "iilwy.events.FBEvent.APP_REQUEST";
      
      public static const CONNECT_TO_CHAT_SERVER:String = "iilwy.events.FBEvent.CONNECT_TO_CHAT_SERVER";
      
      public static const CREDIT_BALANCE_UPDATED:String = "iilwy.events.FBEvent.CREDIT_BALANCE_UPDATED";
      
      public static const CREDIT_PURCHASE:String = "iilwy.events.FBEvent.CREDIT_PURCHASE";
      
      public static const EXTENDED_PERMISSIONS_DATA:String = "iilwy.events.FBEvent.EXTENDED_PERMISSIONS_DATA";
      
      public static const FIND_FRIENDS:String = "iilwy.events.FBEvent.FIND_FRIENDS";
      
      public static const FRICTIONLESS_CREDIT_PURCHASE:String = "iilwy.events.FBEvent.FRICTIONLESS_CREDIT_PURCHASE";
      
      public static const GAMES_CREATE_MATCH:String = "iilwy.events.FBEvent.GAMES_CREATE_MATCH";
      
      public static const GET_CREDIT_BALANCE:String = "iilwy.events.FBEvent.GET_CREDIT_BALANCE";
      
      public static const GET_EXTENDED_PERMISSIONS:String = "iilwy.events.FBEvent.GET_EXTENDED_PERMISSIONS";
      
      public static const GET_FRIENDS:String = "iilwy.events.FBEvent.GET_FRIENDS";
      
      public static const GET_STANDARD_INFO:String = "iilwy.events.FBEvent.GET_STANDARD_INFO";
      
      public static const INITIALIZE:String = "iilwy.events.FBEvent.INITIALIZE";
      
      public static const INITIALIZE_PERMISSIONS:String = "iilwy.events.FBEvent.INITIALIZE_PERMISSIONS";
      
      public static const INVITE_A_FRIEND:String = "iilwy.events.FBEvent.INVITE_A_FRIEND";
      
      public static const INVITE_FRIENDS:String = "iilwy.events.FBEvent.INVITE_FRIENDS";
      
      public static const LOGGED_INTO_CHAT_SERVER:String = "iilwy.events.FBEvent.LOGGED_INTO_CHAT_SERVER";
      
      public static const LOGIN:String = "iilwy.events.FBEvent.LOGIN";
      
      public static const LOGOUT:String = "iilwy.events.FBEvent.LOGOUT";
      
      public static const PAY_PROMPT:String = "iilwy.events.FBEvent.PAY_PROMPT";
      
      public static const PROMPT_CONNECT:String = "iilwy.events.FBEvent.PROMPT_CONNECT";
      
      public static const REQUEST_EXTENDED_PERMISSIONS:String = "iilwy.events.FBEvent.REQUEST_EXTENDED_PERMISSIONS";
      
      public static const SEND_MATCH_INVITE:String = "iilwy.events.FBEvent.SEND_MATCH_INVITE";
      
      public static const SENT_CHATLINK:String = "iilwy.events.FBEvent.SENT_CHATLINK";
      
      public static const SENT_REQUEST:String = "iilwy.events.FBEvent.SENT_REQUEST";
      
      public static const SENT_WALLPOST:String = "iilwy.events.FBEvent.SENT_WALLPOST";
      
      public static const SIGN:String = "iilwy.events.FBEvent.SIGN";
      
      public static const STREAM_PUBLISH:String = "iilwy.events.FBEvent.STREAM_PUBLISH";
      
      public static const STREAM_SHARE:String = "iilwy.events.FBEvent.STREAM_SHARE";
      
      public static const USER_DATA:String = "iilwy.events.FBEvent.USER_DATA";
      
      public static const FRIENDS_DATA:String = "iilwy.events.FBEvent.FRIENDS_DATA";
      
      public static const PROCESS_ALL:int = 0;
      
      public static const PROCESS_LOGIN:int = 1;
      
      public static const PROCESS_CONNECT_TO_CHAT_SERVER:int = 2;
       
      
      public var force:Boolean;
      
      public var merge:Boolean;
      
      public var getUserOnLogin:Boolean;
      
      public var initializeUserOnLogin:Boolean;
      
      public var initializePermissionsOnLogin:Boolean;
      
      public var requireSession:Boolean = true;
      
      public var uids:Array;
      
      public var userColumns:Array;
      
      public var query:String;
      
      public var fields:Array;
      
      public var notification:String;
      
      public var subject:String;
      
      public var text:String;
      
      public var fbml:String;
      
      public var stream:Stream;
      
      public var extendedPermissions:Array;
      
      public var session:FacebookSession;
      
      public var user:FacebookUser;
      
      public var fqlUser:FQLUser;
      
      public var event:String;
      
      public var loginOptions:FBLoginOptions;
      
      public var challenge:String;
      
      public var chatUser:ChatUser;
      
      public var processesToShow:Array;
      
      public var credits:Credits;
      
      public var product:CatalogProduct;
      
      public var excludeIDs:Array;
      
      public var includeIDs:Array;
      
      public var requestIDs:Array;
      
      public var recipients:Array;
      
      public var trackingParams:FBTrackingParams;
      
      public var url:String;
      
      public var appRequest:AppRequest;
      
      public var appID:String;
      
      public function FBEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
      
      override public function clone() : Event
      {
         var fbEvent:FBEvent = new FBEvent(type,bubbles,cancelable);
         fbEvent.responder = responder;
         fbEvent.force = this.force;
         fbEvent.merge = this.merge;
         fbEvent.initializeUserOnLogin = this.initializeUserOnLogin;
         fbEvent.initializePermissionsOnLogin = this.initializePermissionsOnLogin;
         fbEvent.requireSession = this.requireSession;
         fbEvent.uids = Boolean(this.uids)?this.uids.concat():this.uids;
         fbEvent.userColumns = Boolean(this.userColumns)?this.userColumns.concat():this.userColumns;
         fbEvent.fields = Boolean(this.fields)?this.fields.concat():this.fields;
         fbEvent.notification = this.notification;
         fbEvent.subject = this.subject;
         fbEvent.text = this.text;
         fbEvent.fbml = this.fbml;
         fbEvent.stream = this.stream;
         fbEvent.extendedPermissions = Boolean(this.extendedPermissions)?this.extendedPermissions.concat():this.extendedPermissions;
         fbEvent.session = this.session;
         fbEvent.user = this.user;
         fbEvent.fqlUser = this.fqlUser;
         fbEvent.event = this.event;
         fbEvent.loginOptions = this.loginOptions;
         fbEvent.challenge = this.challenge;
         fbEvent.chatUser = this.chatUser;
         fbEvent.processesToShow = this.processesToShow;
         fbEvent.credits = this.credits;
         fbEvent.product = this.product;
         fbEvent.excludeIDs = this.excludeIDs;
         fbEvent.includeIDs = this.includeIDs;
         fbEvent.requestIDs = this.requestIDs;
         fbEvent.recipients = this.recipients;
         fbEvent.trackingParams = this.trackingParams;
         fbEvent.url = this.url;
         fbEvent.appRequest = this.appRequest;
         fbEvent.appID = this.appID;
         return fbEvent;
      }
      
      override public function toString() : String
      {
         return formatToString("FBEvent","type","bubbles","cancelable","eventPhase");
      }
   }
}
