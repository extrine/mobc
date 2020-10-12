package org.igniterealtime.xiff.data.auth
{
   import flash.xml.XMLNode;
   import org.igniterealtime.xiff.data.Extension;
   import org.igniterealtime.xiff.data.ExtensionClassRegistry;
   import org.igniterealtime.xiff.data.IExtension;
   import org.igniterealtime.xiff.data.ISerializable;
   import org.igniterealtime.xiff.data.XMLStanza;
   import org.igniterealtime.xiff.util.SHA1;
   
   public class AuthExtension extends Extension implements IExtension, ISerializable
   {
      
      public static const NS:String = "jabber:iq:auth";
      
      public static const ELEMENT_NAME:String = "query";
       
      
      private var myUsernameNode:XMLNode;
      
      private var myPasswordNode:XMLNode;
      
      private var myDigestNode:XMLNode;
      
      private var myResourceNode:XMLNode;
      
      public function AuthExtension(parent:XMLNode = null)
      {
         super(parent);
      }
      
      public static function enable() : void
      {
         ExtensionClassRegistry.register(AuthExtension);
      }
      
      public static function computeDigest(sessionID:String, password:String) : String
      {
         return SHA1.calcSHA1(sessionID + password).toLowerCase();
      }
      
      public function getNS() : String
      {
         return AuthExtension.NS;
      }
      
      public function getElementName() : String
      {
         return AuthExtension.ELEMENT_NAME;
      }
      
      public function serialize(parent:XMLNode) : Boolean
      {
         if(!exists(getNode().parentNode))
         {
            parent.appendChild(getNode().cloneNode(true));
         }
         return true;
      }
      
      public function deserialize(node:XMLNode) : Boolean
      {
         var i:* = null;
         setNode(node);
         var children:Array = node.childNodes;
         for(i in children)
         {
            switch(children[i].nodeName)
            {
               case "username":
                  this.myUsernameNode = children[i];
                  continue;
               case "password":
                  this.myPasswordNode = children[i];
                  continue;
               case "digest":
                  this.myDigestNode = children[i];
                  continue;
               case "resource":
                  this.myResourceNode = children[i];
                  continue;
               default:
                  continue;
            }
         }
         return true;
      }
      
      public function isDigest() : Boolean
      {
         return exists(this.myDigestNode);
      }
      
      public function isPassword() : Boolean
      {
         return exists(this.myPasswordNode);
      }
      
      public function get username() : String
      {
         if(this.myUsernameNode && this.myUsernameNode.firstChild)
         {
            return this.myUsernameNode.firstChild.nodeValue;
         }
         return null;
      }
      
      public function set username(value:String) : void
      {
         this.myUsernameNode = replaceTextNode(getNode(),this.myUsernameNode,"username",value);
      }
      
      public function get password() : String
      {
         if(this.myPasswordNode && this.myPasswordNode.firstChild)
         {
            return this.myPasswordNode.firstChild.nodeValue;
         }
         return null;
      }
      
      public function set password(value:String) : void
      {
         this.myDigestNode = this.myDigestNode == null?XMLStanza.XMLFactory.createElement(""):this.myDigestNode;
         this.myDigestNode.removeNode();
         this.myDigestNode = null;
         this.myPasswordNode = replaceTextNode(getNode(),this.myPasswordNode,"password",value);
      }
      
      public function get digest() : String
      {
         if(this.myDigestNode && this.myDigestNode.firstChild)
         {
            return this.myDigestNode.firstChild.nodeValue;
         }
         return null;
      }
      
      public function set digest(value:String) : void
      {
         this.myPasswordNode.removeNode();
         this.myPasswordNode = null;
         this.myDigestNode = replaceTextNode(getNode(),this.myDigestNode,"digest",value);
      }
      
      public function get resource() : String
      {
         if(this.myResourceNode && this.myResourceNode.firstChild)
         {
            return this.myResourceNode.firstChild.nodeValue;
         }
         return null;
      }
      
      public function set resource(value:String) : void
      {
         this.myResourceNode = replaceTextNode(getNode(),this.myResourceNode,"resource",value);
      }
   }
}
