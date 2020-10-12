package iilwy.model.dataobjects.chat.extensions.jingle
{
   import flash.xml.XMLNode;
   import org.igniterealtime.xiff.data.ISerializable;
   import org.igniterealtime.xiff.data.XMLStanza;
   
   public class JingleContent extends XMLStanza implements ISerializable
   {
      
      public static var ELEMENT:String = "content";
       
      
      private var creatorNode:XMLNode;
      
      private var dispositionNode:XMLNode;
      
      private var nameNode:XMLNode;
      
      private var sendersNode:XMLNode;
      
      public function JingleContent(parent:XMLNode = null)
      {
         super();
         getNode().nodeName = ELEMENT;
         if(parent)
         {
            parent.appendChild(getNode());
         }
      }
      
      public function serialize(parent:XMLNode) : Boolean
      {
         if(parent != getNode().parentNode)
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
               case "creator":
                  this.creatorNode = children[i];
                  continue;
               case "disposition":
                  this.dispositionNode = children[i];
                  continue;
               case "name":
                  this.nameNode = children[i];
                  continue;
               case "senders":
                  this.sendersNode = children[i];
                  continue;
               default:
                  continue;
            }
         }
         return true;
      }
      
      public function get creator() : String
      {
         return this.creatorNode && this.creatorNode.firstChild?this.creatorNode.firstChild.nodeValue:JingleContentParty.INITIATOR;
      }
      
      public function set creator(value:String) : void
      {
         this.creatorNode = replaceTextNode(getNode(),this.creatorNode,"creator",value);
      }
      
      public function get disposition() : String
      {
         return this.dispositionNode && this.dispositionNode.firstChild?this.dispositionNode.firstChild.nodeValue:ContentDisposition.SESSION;
      }
      
      public function set disposition(value:String) : void
      {
         this.dispositionNode = replaceTextNode(getNode(),this.dispositionNode,"disposition",value);
      }
      
      public function get name() : String
      {
         return this.nameNode && this.nameNode.firstChild?this.nameNode.firstChild.nodeValue:null;
      }
      
      public function set name(value:String) : void
      {
         this.nameNode = replaceTextNode(getNode(),this.nameNode,"name",value);
      }
      
      public function get senders() : String
      {
         return this.sendersNode && this.sendersNode.firstChild?this.sendersNode.firstChild.nodeValue:JingleContentParty.BOTH;
      }
      
      public function set senders(value:String) : void
      {
         this.sendersNode = replaceTextNode(getNode(),this.sendersNode,"senders",value);
      }
   }
}
