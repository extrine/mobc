package org.igniterealtime.xiff.data.muc
{
   import flash.xml.XMLNode;
   import org.igniterealtime.xiff.core.EscapedJID;
   import org.igniterealtime.xiff.data.IExtension;
   
   public class MUCUserExtension extends MUCBaseExtension implements IExtension
   {
      
      public static const NS:String = "http://jabber.org/protocol/muc#user";
      
      public static const ELEMENT_NAME:String = "x";
      
      public static const TYPE_DECLINE:String = "decline";
      
      public static const TYPE_DESTROY:String = "destroy";
      
      public static const TYPE_INVITE:String = "invite";
      
      public static const TYPE_OTHER:String = "other";
       
      
      private var _actionNode:XMLNode;
      
      private var _passwordNode:XMLNode;
      
      private var _statuses:Array;
      
      public function MUCUserExtension(parent:XMLNode = null)
      {
         this._statuses = [];
         super(parent);
      }
      
      public function getNS() : String
      {
         return MUCUserExtension.NS;
      }
      
      public function getElementName() : String
      {
         return MUCUserExtension.ELEMENT_NAME;
      }
      
      override public function deserialize(node:XMLNode) : Boolean
      {
         var child:XMLNode = null;
         super.deserialize(node);
         for each(child in node.childNodes)
         {
            switch(child.nodeName)
            {
               case TYPE_DECLINE:
                  this._actionNode = child;
                  continue;
               case TYPE_DESTROY:
                  this._actionNode = child;
                  continue;
               case TYPE_INVITE:
                  this._actionNode = child;
                  continue;
               case "status":
                  this._statuses.push(new MUCStatus(child,this));
                  continue;
               case "password":
                  this._passwordNode = child;
                  continue;
               default:
                  continue;
            }
         }
         return true;
      }
      
      public function invite(to:EscapedJID, from:EscapedJID, reason:String) : void
      {
         this.updateActionNode(TYPE_INVITE,{
            "to":to.toString(),
            "from":(Boolean(from)?from.toString():null)
         },reason);
      }
      
      public function destroy(room:EscapedJID, reason:String) : void
      {
         this.updateActionNode(TYPE_DESTROY,{"jid":room.toString()},reason);
      }
      
      public function decline(to:EscapedJID, from:EscapedJID, reason:String) : void
      {
         this.updateActionNode(TYPE_DECLINE,{
            "to":to.toString(),
            "from":(Boolean(from)?from.toString():null)
         },reason);
      }
      
      public function hasStatusCode(code:Number) : Boolean
      {
         var status:MUCStatus = null;
         for each(status in this.statuses)
         {
            if(status.code == code)
            {
               return true;
            }
         }
         return false;
      }
      
      private function updateActionNode(type:String, attrs:Object, reason:String) : void
      {
         var i:* = null;
         if(this._actionNode != null)
         {
            this._actionNode.removeNode();
         }
         this._actionNode = XMLFactory.createElement(type);
         for(i in attrs)
         {
            if(exists(attrs[i]))
            {
               this._actionNode.attributes[i] = attrs[i];
            }
         }
         getNode().appendChild(this._actionNode);
         if(reason.length > 0)
         {
            replaceTextNode(this._actionNode,undefined,"reason",reason);
         }
      }
      
      public function get type() : String
      {
         if(this._actionNode == null)
         {
            return null;
         }
         return this._actionNode.nodeName == null?TYPE_OTHER:this._actionNode.nodeName;
      }
      
      public function get to() : EscapedJID
      {
         return new EscapedJID(this._actionNode.attributes.to);
      }
      
      public function get from() : EscapedJID
      {
         return new EscapedJID(this._actionNode.attributes.from);
      }
      
      public function get jid() : EscapedJID
      {
         return new EscapedJID(this._actionNode.attributes.jid);
      }
      
      public function get reason() : String
      {
         if(this._actionNode.firstChild != null)
         {
            if(this._actionNode.firstChild.firstChild != null)
            {
               return this._actionNode.firstChild.firstChild.nodeValue;
            }
         }
         return null;
      }
      
      public function get password() : String
      {
         if(this._passwordNode == null)
         {
            return null;
         }
         return this._passwordNode.firstChild.nodeValue;
      }
      
      public function set password(value:String) : void
      {
         this._passwordNode = replaceTextNode(getNode(),this._passwordNode,"password",value);
      }
      
      public function get statuses() : Array
      {
         return this._statuses;
      }
      
      public function set statuses(value:Array) : void
      {
         this._statuses = value;
      }
   }
}
