package org.igniterealtime.xiff.core
{
   import org.igniterealtime.xiff.data.ExtensionClassRegistry;
   import org.igniterealtime.xiff.data.IQ;
   import org.igniterealtime.xiff.data.browse.BrowseExtension;
   import org.igniterealtime.xiff.data.disco.InfoDiscoExtension;
   import org.igniterealtime.xiff.data.disco.ItemDiscoExtension;
   
   public class Browser
   {
      
      private static var _staticDepends:Array = [ItemDiscoExtension,InfoDiscoExtension,BrowseExtension,ExtensionClassRegistry];
      
      private static var _isEventEnabled:Boolean = BrowserStaticConstructor();
       
      
      private var _connection:XMPPConnection;
      
      private var _pending:Object;
      
      public function Browser(aConnection:XMPPConnection)
      {
         this._pending = {};
         super();
         this.connection = aConnection;
      }
      
      private static function BrowserStaticConstructor() : Boolean
      {
         ItemDiscoExtension.enable();
         InfoDiscoExtension.enable();
         BrowseExtension.enable();
         return true;
      }
      
      public function getNodeInfo(service:EscapedJID, node:String, callback:Function, errorCallback:Function = null) : void
      {
         var ext:InfoDiscoExtension = null;
         var iq:IQ = new IQ(service,IQ.TYPE_GET);
         ext = new InfoDiscoExtension(iq.getNode());
         ext.service = service;
         ext.serviceNode = node;
         iq.callback = callback;
         iq.errorCallback = errorCallback;
         iq.addExtension(ext);
         this._connection.send(iq);
      }
      
      public function getNodeItems(service:EscapedJID, node:String, callback:Function, errorCallback:Function = null) : void
      {
         var iq:IQ = new IQ(service,IQ.TYPE_GET);
         var ext:ItemDiscoExtension = new ItemDiscoExtension(iq.getNode());
         ext.service = service;
         ext.serviceNode = node;
         iq.callback = callback;
         iq.errorCallback = errorCallback;
         iq.addExtension(ext);
         this._connection.send(iq);
      }
      
      public function getServiceInfo(server:EscapedJID, callback:Function, errorCallback:Function = null) : void
      {
         var iq:IQ = new IQ(server,IQ.TYPE_GET);
         iq.callback = callback;
         iq.errorCallback = errorCallback;
         iq.addExtension(new InfoDiscoExtension(iq.getNode()));
         this._connection.send(iq);
      }
      
      public function getServiceItems(server:EscapedJID, callback:Function, errorCallback:Function = null) : void
      {
         var iq:IQ = new IQ(server,IQ.TYPE_GET);
         iq.callback = callback;
         iq.errorCallback = errorCallback;
         iq.addExtension(new ItemDiscoExtension(iq.getNode()));
         this._connection.send(iq);
      }
      
      public function browseItem(id:EscapedJID, callback:Function, errorCallback:Function = null) : void
      {
         var iq:IQ = new IQ(id,IQ.TYPE_GET);
         iq.callback = callback;
         iq.errorCallback = errorCallback;
         iq.addExtension(new BrowseExtension(iq.getNode()));
         this._connection.send(iq);
      }
      
      public function get connection() : XMPPConnection
      {
         return this._connection;
      }
      
      public function set connection(value:XMPPConnection) : void
      {
         this._connection = value;
      }
   }
}
