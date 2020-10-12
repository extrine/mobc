package org.igniterealtime.xiff.data.disco
{
   import flash.xml.XMLNode;
   import org.igniterealtime.xiff.data.ExtensionClassRegistry;
   import org.igniterealtime.xiff.data.IExtension;
   
   public class InfoDiscoExtension extends DiscoExtension implements IExtension
   {
      
      public static const NS:String = "http://jabber.org/protocol/disco#info";
       
      
      private var _identities:Array;
      
      private var _features:Array;
      
      public function InfoDiscoExtension(xmlNode:XMLNode = null)
      {
         super(xmlNode);
      }
      
      public static function enable() : void
      {
         ExtensionClassRegistry.register(InfoDiscoExtension);
      }
      
      public function getElementName() : String
      {
         return DiscoExtension.ELEMENT_NAME;
      }
      
      public function getNS() : String
      {
         return InfoDiscoExtension.NS;
      }
      
      public function get identities() : Array
      {
         return this._identities;
      }
      
      public function get features() : Array
      {
         return this._features;
      }
      
      override public function deserialize(node:XMLNode) : Boolean
      {
         var child:XMLNode = null;
         if(!super.deserialize(node))
         {
            return false;
         }
         this._identities = [];
         this._features = [];
         for each(child in getNode().childNodes)
         {
            switch(child.nodeName)
            {
               case "identity":
                  this._identities.push(child.attributes);
                  continue;
               case "feature":
                  this._features.push(child.attributes["var"]);
                  continue;
               default:
                  continue;
            }
         }
         return true;
      }
   }
}
