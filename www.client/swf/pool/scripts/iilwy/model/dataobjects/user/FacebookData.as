package iilwy.model.dataobjects.user
{
   import com.facebook.graph.data.FacebookSession;
   import iilwy.collections.ArrayCollection;
   import iilwy.model.dataobjects.facebook.FBFriendList;
   
   public class FacebookData
   {
       
      
      public var session:FacebookSession;
      
      public var connected:Boolean;
      
      public var permissions:ArrayCollection;
      
      public var permissionsLoaded:Boolean;
      
      public var friendList:FBFriendList;
      
      public var creditBalance:int;
      
      public function FacebookData()
      {
         super();
         this.session = new FacebookSession();
         this.permissions = new ArrayCollection();
         this.friendList = new FBFriendList();
      }
      
      public function clear() : void
      {
         this.session = new FacebookSession();
         this.connected = false;
         this.permissions.removeAll();
         this.permissionsLoaded = false;
         this.friendList.clear();
         this.creditBalance = 0;
      }
   }
}
