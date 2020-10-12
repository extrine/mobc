package org.igniterealtime.xiff.core
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.events.TimerEvent;
   import flash.net.Socket;
   import flash.utils.ByteArray;
   import flash.utils.Timer;
   import flash.xml.XMLDocument;
   import flash.xml.XMLNode;
   import org.igniterealtime.xiff.auth.Anonymous;
   import org.igniterealtime.xiff.auth.DigestMD5;
   import org.igniterealtime.xiff.auth.External;
   import org.igniterealtime.xiff.auth.Plain;
   import org.igniterealtime.xiff.auth.SASLAuth;
   import org.igniterealtime.xiff.data.Extension;
   import org.igniterealtime.xiff.data.IExtension;
   import org.igniterealtime.xiff.data.IQ;
   import org.igniterealtime.xiff.data.Message;
   import org.igniterealtime.xiff.data.Presence;
   import org.igniterealtime.xiff.data.XMPPStanza;
   import org.igniterealtime.xiff.data.auth.AuthExtension;
   import org.igniterealtime.xiff.data.bind.BindExtension;
   import org.igniterealtime.xiff.data.forms.FormExtension;
   import org.igniterealtime.xiff.data.ping.PingExtension;
   import org.igniterealtime.xiff.data.register.RegisterExtension;
   import org.igniterealtime.xiff.data.session.SessionExtension;
   import org.igniterealtime.xiff.events.ChangePasswordSuccessEvent;
   import org.igniterealtime.xiff.events.ConnectionSuccessEvent;
   import org.igniterealtime.xiff.events.DisconnectionEvent;
   import org.igniterealtime.xiff.events.IQEvent;
   import org.igniterealtime.xiff.events.IncomingDataEvent;
   import org.igniterealtime.xiff.events.LoginEvent;
   import org.igniterealtime.xiff.events.MessageEvent;
   import org.igniterealtime.xiff.events.OutgoingDataEvent;
   import org.igniterealtime.xiff.events.PresenceEvent;
   import org.igniterealtime.xiff.events.RegistrationFieldsEvent;
   import org.igniterealtime.xiff.events.RegistrationSuccessEvent;
   import org.igniterealtime.xiff.events.XIFFErrorEvent;
   import org.igniterealtime.xiff.exception.SerializationException;
   
   [Event(name="registrationSuccess",type="org.igniterealtime.xiff.events.RegistrationSuccessEvent")]
   [Event(name="presence",type="org.igniterealtime.xiff.events.PresenceEvent")]
   [Event(name="outgoingData",type="org.igniterealtime.xiff.events.OutgoingDataEvent")]
   [Event(name="message",type="org.igniterealtime.xiff.events.MessageEvent")]
   [Event(name="login",type="org.igniterealtime.xiff.events.LoginEvent")]
   [Event(name="incomingData",type="org.igniterealtime.xiff.events.IncomingDataEvent")]
   [Event(name="error",type="org.igniterealtime.xiff.events.XIFFErrorEvent")]
   [Event(name="disconnection",type="org.igniterealtime.xiff.events.DisconnectionEvent")]
   [Event(name="connection",type="org.igniterealtime.xiff.events.ConnectionSuccessEvent")]
   [Event(name="changePasswordSuccess",type="org.igniterealtime.xiff.events.ChangePasswordSuccessEvent")]
   public class XMPPConnection extends EventDispatcher
   {
      
      public static const STREAM_TYPE_STANDARD:uint = 0;
      
      public static const STREAM_TYPE_STANDARD_TERMINATED:uint = 1;
      
      public static const STREAM_TYPE_FLASH:uint = 2;
      
      public static const STREAM_TYPE_FLASH_TERMINATED:uint = 3;
      
      protected static var saslMechanisms:Object = {
         "ANONYMOUS":Anonymous,
         "DIGEST-MD5":DigestMD5,
         "EXTERNAL":External,
         "PLAIN":Plain
      };
      
      protected static var _openConnections:Array = [];
       
      
      protected var auth:SASLAuth;
      
      protected var closingStreamTag:String;
      
      protected var compressionNegotiated:Boolean = false;
      
      protected var expireTagSearch:Boolean;
      
      protected var incompleteRawXML:String = "";
      
      protected var loggedIn:Boolean = false;
      
      protected var openingStreamTag:String;
      
      protected var pendingIQs:Object;
      
      protected var presenceQueue:Array;
      
      protected var presenceQueueTimer:Timer;
      
      protected var sessionID:String;
      
      protected var socket:Socket;
      
      protected var streamType:uint = 0;
      
      protected var _active:Boolean = false;
      
      protected var _compress:Boolean = false;
      
      protected var _domain:String;
      
      protected var _ignoreWhitespace:Boolean = true;
      
      protected var _incomingBytes:uint = 0;
      
      protected var _outgoingBytes:uint = 0;
      
      protected var _password:String;
      
      protected var _port:uint = 5222;
      
      protected var _queuePresences:Boolean = true;
      
      protected var _resource:String = "xiff";
      
      protected var _server:String;
      
      protected var _useAnonymousLogin:Boolean = false;
      
      protected var _username:String;
      
      public function XMPPConnection()
      {
         this.pendingIQs = {};
         this.presenceQueue = [];
         super();
         AuthExtension.enable();
         BindExtension.enable();
         SessionExtension.enable();
         RegisterExtension.enable();
         FormExtension.enable();
         PingExtension.enable();
      }
      
      public static function disableSASLMechanism(name:String) : void
      {
         saslMechanisms[name] = null;
      }
      
      public static function registerSASLMechanism(name:String, authClass:Class) : void
      {
         saslMechanisms[name] = authClass;
      }
      
      public static function get openConnections() : Array
      {
         return _openConnections;
      }
      
      public function changePassword(password:String) : void
      {
         var passwordIQ:IQ = new IQ(new EscapedJID(this.domain),IQ.TYPE_SET,XMPPStanza.generateID("pswd_change_"),this.changePassword_response);
         var ext:RegisterExtension = new RegisterExtension(passwordIQ.getNode());
         ext.username = this.jid.escaped.bareJID;
         ext.password = password;
         passwordIQ.addExtension(ext);
         this.send(passwordIQ);
      }
      
      public function connect(streamType:uint = 0) : Boolean
      {
         this.createSocket();
         this.streamType = streamType;
         this.active = false;
         this.loggedIn = false;
         this.chooseStreamTags(streamType);
         this.socket.connect(this.server,this.port);
         return true;
      }
      
      public function disconnect() : void
      {
         var disconnectionEvent:DisconnectionEvent = null;
         if(this.isActive())
         {
            this.sendXML(this.closingStreamTag);
            if(this.socket && this.socket.connected)
            {
               this.socket.close();
            }
            this.active = false;
            this.loggedIn = false;
            disconnectionEvent = new DisconnectionEvent();
            dispatchEvent(disconnectionEvent);
         }
      }
      
      public function getRegistrationFields() : void
      {
         var regIQ:IQ = new IQ(new EscapedJID(this.domain),IQ.TYPE_GET,XMPPStanza.generateID("reg_info_"),this.getRegistrationFields_response);
         regIQ.addExtension(new RegisterExtension(regIQ.getNode()));
         this.send(regIQ);
      }
      
      public function isActive() : Boolean
      {
         return this.active;
      }
      
      public function isLoggedIn() : Boolean
      {
         return this.loggedIn;
      }
      
      public function send(data:XMPPStanza) : void
      {
         var root:XMLNode = null;
         var iq:IQ = null;
         if(this.isActive())
         {
            if(data is IQ)
            {
               iq = data as IQ;
               if(iq.callback != null || iq.errorCallback != null)
               {
                  this.addIQCallbackToPending(iq.id,iq.callback,iq.errorCallback);
               }
            }
            root = data.getNode().parentNode;
            if(root == null)
            {
               root = new XMLDocument();
            }
            if(data.serialize(root))
            {
               this.sendXML(root.firstChild);
            }
            else
            {
               throw new SerializationException();
            }
         }
      }
      
      public function sendKeepAlive() : void
      {
         var ping:IQ = new IQ(new EscapedJID(this.server),IQ.TYPE_GET);
         ping.addExtension(new PingExtension());
         this.send(ping);
      }
      
      public function sendRegistrationFields(fieldMap:Object, key:String) : void
      {
         var i:* = null;
         var regIQ:IQ = new IQ(new EscapedJID(this.domain),IQ.TYPE_SET,XMPPStanza.generateID("reg_attempt_"),this.sendRegistrationFields_response);
         var ext:RegisterExtension = new RegisterExtension(regIQ.getNode());
         for(i in fieldMap)
         {
            ext.setField(i,fieldMap[i]);
         }
         if(key != null)
         {
            ext.key = key;
         }
         regIQ.addExtension(ext);
         this.send(regIQ);
      }
      
      protected function addIQCallbackToPending(id:String, callback:Function, errorCallback:Function) : void
      {
         this.pendingIQs[id] = {
            "func":callback,
            "errorFunc":errorCallback
         };
      }
      
      protected function beginAuthentication() : void
      {
         if(this.auth != null)
         {
            this.sendXML(this.auth.request);
         }
      }
      
      protected function bindConnection() : void
      {
         var bindIQ:IQ = new IQ(null,IQ.TYPE_SET);
         var bindExt:BindExtension = new BindExtension();
         if(this.resource)
         {
            bindExt.resource = this.resource;
         }
         bindIQ.addExtension(bindExt);
         bindIQ.callback = this.bindConnection_response;
         bindIQ.errorCallback = this.bindConnection_error;
         this.send(bindIQ);
      }
      
      protected function bindConnection_response(iq:IQ) : void
      {
         var bind:BindExtension = iq.getExtension("bind") as BindExtension;
         var jid:UnescapedJID = bind.jid.unescaped;
         this._resource = jid.resource;
         this._username = jid.node;
         this._domain = jid.domain;
         this.establishSession();
      }
      
      protected function bindConnection_error(iq:IQ) : void
      {
      }
      
      protected function changePassword_response(iq:IQ) : void
      {
         var event:ChangePasswordSuccessEvent = null;
         if(iq.type == IQ.TYPE_RESULT)
         {
            event = new ChangePasswordSuccessEvent();
            dispatchEvent(event);
         }
         else
         {
            this.dispatchError("unexpected-request","Unexpected Request","wait",400);
         }
      }
      
      protected function chooseStreamTags(type:uint) : void
      {
         this.openingStreamTag = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>";
         if(type == STREAM_TYPE_FLASH || type == STREAM_TYPE_FLASH_TERMINATED)
         {
            this.openingStreamTag = this.openingStreamTag + "<flash";
            this.closingStreamTag = "</flash:stream>";
         }
         else
         {
            this.openingStreamTag = this.openingStreamTag + "<stream";
            this.closingStreamTag = "</stream:stream>";
         }
         this.openingStreamTag = this.openingStreamTag + (":stream xmlns=\"" + XMPPStanza.CLIENT_NAMESPACE + "\" ");
         if(type == STREAM_TYPE_FLASH || type == STREAM_TYPE_FLASH_TERMINATED)
         {
            this.openingStreamTag = this.openingStreamTag + ("xmlns:flash=\"" + XMPPStanza.NAMESPACE_FLASH + "\"");
         }
         else
         {
            this.openingStreamTag = this.openingStreamTag + ("xmlns:stream=\"" + XMPPStanza.NAMESPACE_STREAM + "\"");
         }
         this.openingStreamTag = this.openingStreamTag + (" to=\"" + this.domain + "\"" + " xml:lang=\"" + XMPPStanza.XML_LANG + "\"" + " version=\"" + XMPPStanza.CLIENT_VERSION + "\"");
         if(type == STREAM_TYPE_FLASH_TERMINATED || type == STREAM_TYPE_STANDARD_TERMINATED)
         {
            this.openingStreamTag = this.openingStreamTag + " /";
         }
         this.openingStreamTag = this.openingStreamTag + ">";
      }
      
      protected function configureAuthMechanisms(mechanisms:XMLNode) : void
      {
         var authClass:Class = null;
         var mechanism:XMLNode = null;
         for each(mechanism in mechanisms.childNodes)
         {
            authClass = saslMechanisms[mechanism.firstChild.nodeValue];
            if(this.useAnonymousLogin)
            {
               if(authClass == Anonymous)
               {
                  break;
               }
            }
            else if(authClass != Anonymous && authClass != null)
            {
               break;
            }
         }
         if(!authClass)
         {
            this.dispatchError("SASL missing","The server is not configured to support any available SASL mechanisms","SASL",-1);
         }
         else
         {
            this.auth = new authClass(this);
         }
      }
      
      protected function configureStreamCompression() : void
      {
         var ask:XML = <compress xmlns="http://jabber.org/protocol/compress"><method>zlib</method></compress>;
         this.sendXML(ask);
      }
      
      protected function createSocket() : void
      {
         this.socket = new Socket();
         this.socket.addEventListener(Event.CLOSE,this.onSocketClosed);
         this.socket.addEventListener(Event.CONNECT,this.onSocketConnected);
         this.socket.addEventListener(ProgressEvent.SOCKET_DATA,this.onSocketDataReceived);
         this.socket.addEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
         this.socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError);
      }
      
      protected function dispatchError(condition:String, message:String, type:String, code:int, extension:Extension = null) : void
      {
         var event:XIFFErrorEvent = new XIFFErrorEvent();
         event.errorCondition = condition;
         event.errorMessage = message;
         event.errorType = type;
         event.errorCode = code;
         event.errorExt = extension;
         dispatchEvent(event);
      }
      
      protected function establishSession() : void
      {
         var sessionIQ:IQ = new IQ(null,IQ.TYPE_SET);
         sessionIQ.addExtension(new SessionExtension());
         sessionIQ.callback = this.establishSession_response;
         sessionIQ.errorCallback = this.establishSession_error;
         this.send(sessionIQ);
      }
      
      protected function establishSession_response(iq:IQ) : void
      {
         dispatchEvent(new LoginEvent());
      }
      
      protected function establishSession_error(iq:IQ) : void
      {
      }
      
      protected function flushPresenceQueue(event:TimerEvent) : void
      {
         var presenceEvent:PresenceEvent = null;
         if(this.presenceQueue.length > 0)
         {
            presenceEvent = new PresenceEvent();
            presenceEvent.data = this.presenceQueue;
            dispatchEvent(presenceEvent);
            this.presenceQueue = [];
         }
      }
      
      protected function getRegistrationFields_response(iq:IQ) : void
      {
         var ext:RegisterExtension = null;
         var fields:Array = null;
         var event:RegistrationFieldsEvent = null;
         try
         {
            ext = iq.getAllExtensionsByNS(RegisterExtension.NS)[0];
            fields = ext.getRequiredFieldNames();
            event = new RegistrationFieldsEvent();
            event.fields = fields;
            event.data = ext;
            dispatchEvent(event);
         }
         catch(err:Error)
         {
            trace(err.getStackTrace());
         }
      }
      
      protected function handleAuthentication(response:XMLNode) : void
      {
         var status:Object = this.auth.handleResponse(0,XML(response.toString()));
         if(status.authComplete)
         {
            if(status.authSuccess)
            {
               this.loggedIn = true;
               this.restartStream();
            }
            else
            {
               this.dispatchError("Authentication Error","","",401);
               this.disconnect();
            }
         }
      }
      
      protected function handleChallenge(challenge:XMLNode) : void
      {
         var response:XML = this.auth.handleChallenge(0,XML(challenge.toString()));
         this.sendXML(response);
      }
      
      protected function handleIQ(node:XMLNode) : IQ
      {
         var callbackInfo:* = undefined;
         var exts:Array = null;
         var ns:* = null;
         var ext:IExtension = null;
         var iqEvent:IQEvent = null;
         var iq:IQ = new IQ();
         if(!iq.deserialize(node))
         {
            throw new SerializationException();
         }
         if(iq.type == IQ.TYPE_ERROR)
         {
            this.dispatchError(iq.errorCondition,iq.errorMessage,iq.errorType,iq.errorCode);
            if(this.pendingIQs[iq.id] !== undefined)
            {
               callbackInfo = this.pendingIQs[iq.id];
               if(callbackInfo.errorFunc != null)
               {
                  callbackInfo.errorFunc(iq);
               }
               this.pendingIQs[iq.id] = null;
               delete this.pendingIQs[iq.id];
            }
         }
         else if(this.pendingIQs[iq.id] !== undefined)
         {
            callbackInfo = this.pendingIQs[iq.id];
            if(callbackInfo.func != null)
            {
               callbackInfo.func(iq);
            }
            this.pendingIQs[iq.id] = null;
            delete this.pendingIQs[iq.id];
         }
         else
         {
            exts = iq.getAllExtensions();
            for(ns in exts)
            {
               ext = exts[ns] as IExtension;
               if(ext != null)
               {
                  iqEvent = new IQEvent(ext.getNS());
                  iqEvent.data = ext;
                  iqEvent.iq = iq;
                  dispatchEvent(iqEvent);
               }
            }
         }
         return iq;
      }
      
      protected function handleMessage(node:XMLNode) : Message
      {
         var exts:Array = null;
         var messageEvent:MessageEvent = null;
         var message:Message = new Message();
         if(!message.deserialize(node))
         {
            throw new SerializationException();
         }
         if(message.type == Message.TYPE_ERROR)
         {
            exts = message.getAllExtensions();
            this.dispatchError(message.errorCondition,message.errorMessage,message.errorType,message.errorCode,exts.length > 0?exts[0]:null);
         }
         else
         {
            messageEvent = new MessageEvent();
            messageEvent.data = message;
            dispatchEvent(messageEvent);
         }
         return message;
      }
      
      protected function handleNodeType(node:XMLNode) : void
      {
         var nodeName:String = node.nodeName.toLowerCase();
         switch(nodeName)
         {
            case "stream:stream":
            case "flash:stream":
               this.expireTagSearch = false;
               this.handleStream(node);
               break;
            case "stream:error":
               this.handleStreamError(node);
               break;
            case "stream:features":
               this.handleStreamFeatures(node);
               break;
            case "iq":
               this.handleIQ(node);
               break;
            case "message":
               this.handleMessage(node);
               break;
            case "presence":
               this.handlePresence(node);
               break;
            case "challenge":
               this.handleChallenge(node);
               break;
            case "success":
               this.handleAuthentication(node);
               break;
            case "compressed":
               this.compressionNegotiated = true;
               this.restartStream();
               break;
            case "failure":
               this.handleAuthentication(node);
               break;
            default:
               this.dispatchError("undefined-condition","Unknown Error","modify",500);
         }
      }
      
      protected function handlePresence(node:XMLNode) : Presence
      {
         var presenceEvent:PresenceEvent = null;
         if(!this.presenceQueueTimer)
         {
            this.presenceQueueTimer = new Timer(1,1);
            this.presenceQueueTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.flushPresenceQueue);
         }
         var presence:Presence = new Presence();
         if(!presence.deserialize(node))
         {
            throw new SerializationException();
         }
         if(this.queuePresences)
         {
            this.presenceQueue.push(presence);
            this.presenceQueueTimer.reset();
            this.presenceQueueTimer.start();
         }
         else
         {
            presenceEvent = new PresenceEvent();
            presenceEvent.data = [presence];
            dispatchEvent(presenceEvent);
         }
         return presence;
      }
      
      protected function handleStream(node:XMLNode) : void
      {
         var childNode:XMLNode = null;
         this.sessionID = node.attributes.id;
         this.domain = node.attributes.from;
         for each(childNode in node.childNodes)
         {
            if(childNode.nodeName == "stream:features")
            {
               this.handleStreamFeatures(childNode);
            }
         }
      }
      
      protected function handleStreamError(node:XMLNode) : void
      {
         this.dispatchError("service-unavailable","Remote Server Error","cancel",502);
         try
         {
            this.socket.close();
         }
         catch(error:Error)
         {
         }
         this.active = false;
         this.loggedIn = false;
         var disconnectionEvent:DisconnectionEvent = new DisconnectionEvent();
         dispatchEvent(disconnectionEvent);
      }
      
      protected function handleStreamFeatures(node:XMLNode) : void
      {
         var feature:XMLNode = null;
         if(!this.loggedIn)
         {
            for each(feature in node.childNodes)
            {
               if(feature.nodeName == "starttls")
               {
                  this.handleStreamTLS(feature);
               }
               else if(feature.nodeName == "mechanisms")
               {
                  this.configureAuthMechanisms(feature);
               }
               else if(feature.nodeName == "compression")
               {
                  if(this._compress)
                  {
                     this.configureStreamCompression();
                  }
               }
            }
            if(this.authenticationReady)
            {
               if(this.useAnonymousLogin || this.username != null && this.username.length > 0)
               {
                  this.beginAuthentication();
               }
               else
               {
                  this.getRegistrationFields();
               }
            }
         }
         else
         {
            this.bindConnection();
         }
      }
      
      protected function handleStreamTLS(node:XMLNode) : void
      {
         if(node.firstChild && node.firstChild.nodeName == "required")
         {
            this.dispatchError("TLS required","The server requires TLS, but this feature is not implemented.","cancel",501);
            this.disconnect();
            return;
         }
      }
      
      protected function onIOError(event:IOErrorEvent) : void
      {
         this.dispatchError("service-unavailable","Service Unavailable","cancel",503);
      }
      
      protected function onSecurityError(event:SecurityErrorEvent) : void
      {
         trace("there was a security error of type: " + event.type + "\nError: " + event.text);
         this.dispatchError("not-authorized","Not Authorized","auth",401);
      }
      
      protected function onSocketClosed(event:Event) : void
      {
         this.active = false;
         this.loggedIn = false;
         var disconnectionEvent:DisconnectionEvent = new DisconnectionEvent();
         dispatchEvent(disconnectionEvent);
      }
      
      protected function onSocketConnected(event:Event) : void
      {
         this.active = true;
         this.sendXML(this.openingStreamTag);
         var connectionEvent:ConnectionSuccessEvent = new ConnectionSuccessEvent();
         dispatchEvent(connectionEvent);
      }
      
      protected function onSocketDataReceived(event:ProgressEvent) : void
      {
         var bytedata:ByteArray = new ByteArray();
         this.socket.readBytes(bytedata);
         this.parseDataReceived(bytedata);
      }
      
      protected function parseDataReceived(bytedata:ByteArray) : void
      {
         var data:String = null;
         var pattern:RegExp = null;
         var resultObj:Object = null;
         var pattern2:RegExp = null;
         var resultObj2:Object = null;
         var isComplete:Boolean = false;
         var incomingEvent:IncomingDataEvent = null;
         var len:uint = 0;
         var i:int = 0;
         var currentNode:XMLNode = null;
         this._incomingBytes = this._incomingBytes + bytedata.length;
         if(this.compressionNegotiated)
         {
            bytedata.uncompress();
         }
         bytedata.position = 0;
         data = bytedata.readUTFBytes(bytedata.length);
         var rawXML:String = this.incompleteRawXML + data;
         var rawData:ByteArray = new ByteArray();
         rawData.writeUTFBytes(rawXML);
         if(!this.expireTagSearch)
         {
            pattern = /<flash:stream/;
            resultObj = pattern.exec(rawXML);
            if(resultObj != null)
            {
               rawXML = rawXML.concat("</flash:stream>");
               this.expireTagSearch = true;
            }
         }
         if(!this.expireTagSearch)
         {
            pattern2 = /<stream:stream/;
            resultObj2 = pattern2.exec(rawXML);
            if(resultObj2 != null)
            {
               rawXML = rawXML.concat("</stream:stream>");
               this.expireTagSearch = true;
            }
         }
         var xmlData:XMLDocument = new XMLDocument();
         xmlData.ignoreWhite = this._ignoreWhitespace;
         try
         {
            isComplete = true;
            xmlData.parseXML(rawXML);
            this.incompleteRawXML = "";
         }
         catch(err:Error)
         {
            isComplete = false;
            incompleteRawXML = incompleteRawXML + data;
         }
         if(isComplete)
         {
            incomingEvent = new IncomingDataEvent();
            incomingEvent.data = rawData;
            dispatchEvent(incomingEvent);
            len = xmlData.childNodes.length;
            for(i = 0; i < len; i++)
            {
               currentNode = xmlData.childNodes[i];
               this.handleNodeType(currentNode);
            }
         }
      }
      
      protected function restartStream() : void
      {
         this.sendXML(this.openingStreamTag);
      }
      
      protected function sendRegistrationFields_response(iq:IQ) : void
      {
         var event:RegistrationSuccessEvent = null;
         if(iq.type == IQ.TYPE_RESULT)
         {
            event = new RegistrationSuccessEvent();
            dispatchEvent(event);
         }
         else
         {
            this.dispatchError("unexpected-request","Unexpected Request","wait",400);
         }
      }
      
      protected function sendXML(data:*) : void
      {
         data = data is XML?XML(data).toXMLString():data;
         var bytedata:ByteArray = new ByteArray();
         bytedata.writeUTFBytes(data);
         bytedata.position = 0;
         if(this.compressionNegotiated)
         {
            bytedata.compress();
            bytedata.position = 0;
         }
         if(this.socket && this.socket.connected)
         {
            this.socket.writeBytes(bytedata,0,bytedata.length);
            this.socket.flush();
         }
         this._outgoingBytes = this._outgoingBytes + bytedata.length;
         var event:OutgoingDataEvent = new OutgoingDataEvent();
         event.data = bytedata;
         dispatchEvent(event);
      }
      
      public function get compress() : Boolean
      {
         return this._compress;
      }
      
      public function set compress(value:Boolean) : void
      {
         this._compress = value;
      }
      
      public function get domain() : String
      {
         if(!this._domain)
         {
            return this._server;
         }
         return this._domain;
      }
      
      public function set domain(value:String) : void
      {
         this._domain = value;
      }
      
      public function get ignoreWhitespace() : Boolean
      {
         return this._ignoreWhitespace;
      }
      
      public function set ignoreWhitespace(value:Boolean) : void
      {
         this._ignoreWhitespace = value;
         XML.ignoreWhitespace = value;
      }
      
      public function get incomingBytes() : uint
      {
         return this._incomingBytes;
      }
      
      public function get jid() : UnescapedJID
      {
         return new UnescapedJID(this._username + "@" + this._domain + "/" + this._resource);
      }
      
      public function get outgoingBytes() : uint
      {
         return this._outgoingBytes;
      }
      
      public function get password() : String
      {
         return this._password;
      }
      
      public function set password(value:String) : void
      {
         this._password = value;
      }
      
      public function get port() : uint
      {
         return this._port;
      }
      
      public function set port(value:uint) : void
      {
         this._port = value;
      }
      
      public function get queuePresences() : Boolean
      {
         return this._queuePresences;
      }
      
      public function set queuePresences(value:Boolean) : void
      {
         if(this._queuePresences && !value)
         {
            if(this.presenceQueueTimer)
            {
               this.presenceQueueTimer.stop();
            }
            this.flushPresenceQueue(null);
         }
         this._queuePresences = value;
      }
      
      public function get resource() : String
      {
         return this._resource;
      }
      
      public function set resource(value:String) : void
      {
         if(value.length > 0)
         {
            this._resource = value;
         }
      }
      
      public function get server() : String
      {
         if(!this._server)
         {
            return this._domain;
         }
         return this._server;
      }
      
      public function set server(value:String) : void
      {
         this._server = value;
      }
      
      public function get useAnonymousLogin() : Boolean
      {
         return this._useAnonymousLogin;
      }
      
      public function set useAnonymousLogin(value:Boolean) : void
      {
         if(!this.isActive())
         {
            this._useAnonymousLogin = value;
         }
      }
      
      public function get username() : String
      {
         return this._username;
      }
      
      public function set username(value:String) : void
      {
         this._username = value;
      }
      
      protected function get active() : Boolean
      {
         return this._active;
      }
      
      protected function set active(value:Boolean) : void
      {
         if(value)
         {
            _openConnections.push(this);
         }
         else
         {
            _openConnections.splice(_openConnections.indexOf(this),1);
         }
         this._active = value;
      }
      
      protected function get authenticationReady() : Boolean
      {
         return this._compress && this.compressionNegotiated || !this._compress;
      }
   }
}
