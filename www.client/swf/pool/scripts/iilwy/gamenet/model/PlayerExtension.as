package iilwy.gamenet.model
{
   import flash.xml.XMLNode;
   import org.igniterealtime.xiff.data.Extension;
   import org.igniterealtime.xiff.data.ExtensionClassRegistry;
   import org.igniterealtime.xiff.data.IExtension;
   import org.igniterealtime.xiff.data.ISerializable;
   
   public class PlayerExtension extends Extension implements IExtension, ISerializable
   {
      
      public static var NS:String = "http://omgpop.com/protocol/gamenet#player";
      
      public static var ELEMENT:String = "gamenet_player";
       
      
      private var statusNode:XMLNode;
      
      public function PlayerExtension(parent:XMLNode = null)
      {
         super(parent);
      }
      
      public static function enable() : void
      {
         ExtensionClassRegistry.register(PlayerExtension);
      }
      
      public function getNS() : String
      {
         return PlayerExtension.NS;
      }
      
      public function getElementName() : String
      {
         return PlayerExtension.ELEMENT;
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
               case "status":
                  this.statusNode = children[i];
                  continue;
               default:
                  continue;
            }
         }
         return true;
      }
      
      public function get status() : String
      {
         return this.statusNode && this.statusNode.firstChild?this.statusNode.firstChild.nodeValue:null;
      }
      
      public function set status(value:String) : void
      {
         this.statusNode = replaceTextNode(getNode(),this.statusNode,"status",value);
      }
   }
}
