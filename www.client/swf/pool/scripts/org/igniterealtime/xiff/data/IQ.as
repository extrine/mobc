package org.igniterealtime.xiff.data
{
   import flash.xml.XMLNode;
   import org.igniterealtime.xiff.core.EscapedJID;
   
   public class IQ extends XMPPStanza implements ISerializable
   {
      
      public static const TYPE_ERROR:String = "error";
      
      public static const TYPE_GET:String = "get";
      
      public static const TYPE_RESULT:String = "result";
      
      public static const TYPE_SET:String = "set";
       
      
      private var myCallback:Function;
      
      private var myErrorCallback:Function;
      
      private var myQueryName:String;
      
      private var myQueryFields:Array;
      
      public function IQ(recipient:EscapedJID = null, iqType:String = null, iqID:String = null, iqCallback:Function = null, iqErrorCallback:Function = null)
      {
         var id:String = !!exists(iqID)?iqID:generateID("iq_");
         super(recipient,null,iqType,id,"iq");
         this.callback = iqCallback;
         this.errorCallback = iqErrorCallback;
      }
      
      override public function serialize(parentNode:XMLNode) : Boolean
      {
         return super.serialize(parentNode);
      }
      
      override public function deserialize(xmlNode:XMLNode) : Boolean
      {
         return super.deserialize(xmlNode);
      }
      
      public function get callback() : Function
      {
         return this.myCallback;
      }
      
      public function set callback(value:Function) : void
      {
         this.myCallback = value;
      }
      
      public function get errorCallback() : Function
      {
         return this.myErrorCallback;
      }
      
      public function set errorCallback(value:Function) : void
      {
         this.myErrorCallback = value;
      }
   }
}
