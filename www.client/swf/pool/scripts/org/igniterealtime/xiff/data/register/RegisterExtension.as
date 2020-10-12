package org.igniterealtime.xiff.data.register
{
   import flash.xml.XMLNode;
   import org.igniterealtime.xiff.data.Extension;
   import org.igniterealtime.xiff.data.ExtensionClassRegistry;
   import org.igniterealtime.xiff.data.IExtension;
   import org.igniterealtime.xiff.data.ISerializable;
   
   public class RegisterExtension extends Extension implements IExtension, ISerializable
   {
      
      public static const NS:String = "jabber:iq:register";
      
      public static const ELEMENT_NAME:String = "query";
      
      private static var staticDepends:Class = ExtensionClassRegistry;
       
      
      private var _fields:Object;
      
      private var _keyNode:XMLNode;
      
      private var _instructionsNode:XMLNode;
      
      private var _removeNode:XMLNode;
      
      public function RegisterExtension(parent:XMLNode = null)
      {
         this._fields = {};
         super(parent);
      }
      
      public static function enable() : void
      {
         ExtensionClassRegistry.register(RegisterExtension);
      }
      
      public function getNS() : String
      {
         return RegisterExtension.NS;
      }
      
      public function getElementName() : String
      {
         return RegisterExtension.ELEMENT_NAME;
      }
      
      public function serialize(parentNode:XMLNode) : Boolean
      {
         if(!exists(getNode().parentNode))
         {
            parentNode.appendChild(getNode().cloneNode(true));
         }
         return true;
      }
      
      public function deserialize(node:XMLNode) : Boolean
      {
         var i:* = null;
         setNode(node);
         var children:Array = getNode().childNodes;
         for(i in children)
         {
            switch(children[i].nodeName)
            {
               case "key":
                  this._keyNode = children[i];
                  continue;
               case "instructions":
                  this._instructionsNode = children[i];
                  continue;
               case "remove":
                  this._removeNode = children[i];
                  continue;
               default:
                  this._fields[children[i].nodeName] = children[i];
                  continue;
            }
         }
         return true;
      }
      
      public function getRequiredFieldNames() : Array
      {
         var i:* = null;
         var fields:Array = [];
         for(i in this._fields)
         {
            fields.push(i);
         }
         return fields;
      }
      
      public function getField(name:String) : String
      {
         var node:XMLNode = this._fields[name];
         if(node && node.firstChild)
         {
            return node.firstChild.nodeValue;
         }
         return null;
      }
      
      public function setField(name:String, value:String) : void
      {
         this._fields[name] = replaceTextNode(getNode(),this._fields[name],name,value);
      }
      
      public function get unregister() : Boolean
      {
         return exists(this._removeNode);
      }
      
      public function set unregister(value:Boolean) : void
      {
         this._removeNode = replaceTextNode(getNode(),this._removeNode,"remove","");
      }
      
      public function get key() : String
      {
         if(this._keyNode && this._keyNode.firstChild)
         {
            return this._keyNode.firstChild.nodeValue;
         }
         return null;
      }
      
      public function set key(value:String) : void
      {
         this._keyNode = replaceTextNode(getNode(),this._keyNode,"key",value);
      }
      
      public function get instructions() : String
      {
         if(this._instructionsNode && this._instructionsNode.firstChild)
         {
            return this._instructionsNode.firstChild.nodeValue;
         }
         return null;
      }
      
      public function set instructions(value:String) : void
      {
         this._instructionsNode = replaceTextNode(getNode(),this._instructionsNode,"instructions",value);
      }
      
      public function get username() : String
      {
         return this.getField("username");
      }
      
      public function set username(value:String) : void
      {
         this.setField("username",value);
      }
      
      public function get nick() : String
      {
         return this.getField("nick");
      }
      
      public function set nick(value:String) : void
      {
         this.setField("nick",value);
      }
      
      public function get password() : String
      {
         return this.getField("password");
      }
      
      public function set password(value:String) : void
      {
         this.setField("password",value);
      }
      
      public function get first() : String
      {
         return this.getField("first");
      }
      
      public function set first(value:String) : void
      {
         this.setField("first",value);
      }
      
      public function get last() : String
      {
         return this.getField("last");
      }
      
      public function set last(value:String) : void
      {
         this.setField("last",value);
      }
      
      public function get email() : String
      {
         return this.getField("email");
      }
      
      public function set email(value:String) : void
      {
         this.setField("email",value);
      }
      
      public function get address() : String
      {
         return this.getField("address");
      }
      
      public function set address(value:String) : void
      {
         this.setField("address",value);
      }
      
      public function get city() : String
      {
         return this.getField("city");
      }
      
      public function set city(value:String) : void
      {
         this.setField("city",value);
      }
      
      public function get state() : String
      {
         return this.getField("state");
      }
      
      public function set state(value:String) : void
      {
         this.setField("state",value);
      }
      
      public function get zip() : String
      {
         return this.getField("zip");
      }
      
      public function set zip(value:String) : void
      {
         this.setField("zip",value);
      }
      
      public function get phone() : String
      {
         return this.getField("phone");
      }
      
      public function set phone(value:String) : void
      {
         this.setField("phone",value);
      }
      
      public function get url() : String
      {
         return this.getField("url");
      }
      
      public function set url(value:String) : void
      {
         this.setField("url",value);
      }
      
      public function get date() : String
      {
         return this.getField("date");
      }
      
      public function set date(value:String) : void
      {
         this.setField("date",value);
      }
      
      public function get misc() : String
      {
         return this.getField("misc");
      }
      
      public function set misc(value:String) : void
      {
         this.setField("misc",value);
      }
      
      public function get text() : String
      {
         return this.getField("text");
      }
      
      public function set text(value:String) : void
      {
         this.setField("text",value);
      }
   }
}
