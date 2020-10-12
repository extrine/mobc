package org.igniterealtime.xiff.data
{
   import flash.xml.XMLNode;
   import org.igniterealtime.xiff.core.EscapedJID;
   import org.igniterealtime.xiff.data.id.IIDGenerator;
   import org.igniterealtime.xiff.data.id.IncrementalGenerator;
   
   public dynamic class XMPPStanza extends XMLStanza implements ISerializable, IExtendable
   {
      
      public static const CLIENT_NAMESPACE:String = "jabber:client";
      
      public static const CLIENT_VERSION:String = "1.0";
      
      public static const NAMESPACE_FLASH:String = "http://www.jabber.com/streams/flash";
      
      public static const NAMESPACE_STREAM:String = "http://etherx.jabber.org/streams";
      
      public static const XML_LANG:String = "en";
      
      private static var staticDependencies:Array = [IncrementalGenerator,ExtensionContainer];
      
      private static var isStaticConstructed = XMPPStanzaStaticConstructor();
       
      
      private var myErrorNode:XMLNode;
      
      private var myErrorConditionNode:XMLNode;
      
      public function XMPPStanza(recipient:EscapedJID, sender:EscapedJID, theType:String, theID:String, nName:String)
      {
         super();
         getNode().nodeName = nName;
         this.to = recipient;
         this.from = sender;
         this.type = theType;
         this.id = theID;
      }
      
      private static function XMPPStanzaStaticConstructor() : void
      {
      }
      
      public static function generateID(prefix:String) : String
      {
         var id:String = IncrementalGenerator.getInstance().getID(prefix);
         return id;
      }
      
      public static function setIDGenerator(generator:IIDGenerator) : void
      {
      }
      
      public function serialize(parentNode:XMLNode) : Boolean
      {
         var ext:ISerializable = null;
         var node:XMLNode = getNode();
         var exts:Array = getAllExtensions();
         for each(ext in exts)
         {
            ext.serialize(node);
         }
         if(!exists(node.parentNode))
         {
            node = node.cloneNode(true);
            parentNode.appendChild(node);
         }
         return true;
      }
      
      public function deserialize(xmlNode:XMLNode) : Boolean
      {
         var i:* = null;
         var nName:String = null;
         var nNamespace:String = null;
         var extClass:Class = null;
         var ext:IExtension = null;
         setNode(xmlNode);
         var children:Array = xmlNode.childNodes;
         for(i in children)
         {
            nName = children[i].nodeName;
            nNamespace = children[i].attributes.xmlns;
            nNamespace = !!exists(nNamespace)?nNamespace:CLIENT_NAMESPACE;
            if(nName == "error")
            {
               this.myErrorNode = children[i];
               if(exists(this.myErrorNode.firstChild.nodeName))
               {
                  this.myErrorConditionNode = this.myErrorNode.firstChild;
               }
            }
            else
            {
               extClass = ExtensionClassRegistry.lookup(nNamespace);
               if(extClass != null)
               {
                  ext = new extClass();
                  ISerializable(ext).deserialize(children[i]);
                  addExtension(ext);
               }
            }
         }
         return true;
      }
      
      public function get to() : EscapedJID
      {
         return new EscapedJID(getNode().attributes.to);
      }
      
      public function set to(value:EscapedJID) : void
      {
         delete getNode().attributes.to;
         if(exists(value))
         {
            getNode().attributes.to = value.toString();
         }
      }
      
      public function get from() : EscapedJID
      {
         var jid:String = getNode().attributes.from;
         return Boolean(jid)?new EscapedJID(jid):null;
      }
      
      public function set from(value:EscapedJID) : void
      {
         delete getNode().attributes.from;
         if(exists(value))
         {
            getNode().attributes.from = value.toString();
         }
      }
      
      public function get type() : String
      {
         return getNode().attributes.type;
      }
      
      public function set type(value:String) : void
      {
         delete getNode().attributes.type;
         if(exists(value))
         {
            getNode().attributes.type = value;
         }
      }
      
      public function get id() : String
      {
         return getNode().attributes.id;
      }
      
      public function set id(value:String) : void
      {
         delete getNode().attributes.id;
         if(exists(value))
         {
            getNode().attributes.id = value;
         }
      }
      
      public function get errorMessage() : String
      {
         if(exists(this.errorCondition))
         {
            return this.errorCondition.toString();
         }
         if(this.myErrorNode && this.myErrorNode.firstChild)
         {
            return this.myErrorNode.firstChild.nodeValue;
         }
         return null;
      }
      
      public function set errorMessage(value:String) : void
      {
         var attributes:Object = null;
         this.myErrorNode = ensureNode(this.myErrorNode,"error");
         value = !!exists(value)?value:"";
         if(exists(this.errorCondition))
         {
            this.myErrorConditionNode = replaceTextNode(this.myErrorNode,this.myErrorConditionNode,this.errorCondition,value);
         }
         else
         {
            attributes = this.myErrorNode.attributes;
            this.myErrorNode = replaceTextNode(getNode(),this.myErrorNode,"error",value);
            this.myErrorNode.attributes = attributes;
         }
      }
      
      public function get errorCondition() : String
      {
         if(exists(this.myErrorConditionNode))
         {
            return this.myErrorConditionNode.nodeName;
         }
         return null;
      }
      
      public function set errorCondition(value:String) : void
      {
         this.myErrorNode = ensureNode(this.myErrorNode,"error");
         var attributes:Object = this.myErrorNode.attributes;
         var msg:String = this.errorMessage;
         if(exists(value))
         {
            this.myErrorNode = replaceTextNode(getNode(),this.myErrorNode,"error","");
            this.myErrorConditionNode = addTextNode(this.myErrorNode,value,msg);
         }
         else
         {
            this.myErrorNode = replaceTextNode(getNode(),this.myErrorNode,"error",msg);
         }
         this.myErrorNode.attributes = attributes;
      }
      
      public function get errorType() : String
      {
         return this.myErrorNode.attributes.type;
      }
      
      public function set errorType(value:String) : void
      {
         this.myErrorNode = ensureNode(this.myErrorNode,"error");
         delete this.myErrorNode.attributes.type;
         if(exists(value))
         {
            this.myErrorNode.attributes.type = value;
         }
      }
      
      public function get errorCode() : int
      {
         return parseInt(this.myErrorNode.attributes.code);
      }
      
      public function set errorCode(value:int) : void
      {
         this.myErrorNode = ensureNode(this.myErrorNode,"error");
         delete this.myErrorNode.attributes.code;
         if(exists(value))
         {
            this.myErrorNode.attributes.code = value;
         }
      }
   }
}
