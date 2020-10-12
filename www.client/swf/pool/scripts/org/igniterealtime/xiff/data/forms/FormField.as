package org.igniterealtime.xiff.data.forms
{
   import flash.xml.XMLNode;
   import org.igniterealtime.xiff.data.ISerializable;
   import org.igniterealtime.xiff.data.XMLStanza;
   
   public class FormField extends XMLStanza implements ISerializable
   {
      
      public static const ELEMENT_NAME:String = "field";
       
      
      private var myDescNode:XMLNode;
      
      private var myRequiredNode:XMLNode;
      
      private var myValueNodes:Array;
      
      private var myOptionNodes:Array;
      
      public function FormField()
      {
         super();
      }
      
      public function serialize(parent:XMLNode) : Boolean
      {
         getNode().nodeName = FormField.ELEMENT_NAME;
         if(parent != getNode().parentNode)
         {
            parent.appendChild(getNode().cloneNode(true));
         }
         return true;
      }
      
      public function deserialize(node:XMLNode) : Boolean
      {
         var i:* = null;
         var c:XMLNode = null;
         setNode(node);
         this.myValueNodes = [];
         this.myOptionNodes = [];
         var children:Array = node.childNodes;
         for(i in children)
         {
            c = children[i];
            switch(children[i].nodeName)
            {
               case "desc":
                  this.myDescNode = c;
                  continue;
               case "required":
                  this.myRequiredNode = c;
                  continue;
               case "value":
                  this.myValueNodes.push(c);
                  continue;
               case "option":
                  this.myOptionNodes.push(c);
                  continue;
               default:
                  continue;
            }
         }
         return true;
      }
      
      public function get name() : String
      {
         return getNode().attributes["var"];
      }
      
      public function set name(value:String) : void
      {
         getNode().attributes["var"] = value;
      }
      
      public function get type() : String
      {
         return getNode().attributes.type;
      }
      
      public function set type(value:String) : void
      {
         getNode().attributes.type = value;
      }
      
      public function get label() : String
      {
         return getNode().attributes.label;
      }
      
      public function set label(value:String) : void
      {
         getNode().attributes.label = value;
      }
      
      public function get value() : String
      {
         try
         {
            if(this.myValueNodes[0] != null && this.myValueNodes[0].firstChild != null)
            {
               return this.myValueNodes[0].firstChild.nodeValue;
            }
         }
         catch(error:Error)
         {
            trace(error.getStackTrace());
         }
         return null;
      }
      
      public function set value(value:String) : void
      {
         if(this.myValueNodes == null)
         {
            this.myValueNodes = [];
         }
         this.myValueNodes[0] = replaceTextNode(getNode(),this.myValueNodes[0],"value",value);
      }
      
      public function getAllValues() : Array
      {
         var valueNode:XMLNode = null;
         var res:Array = [];
         for each(valueNode in this.myValueNodes)
         {
            res.push(valueNode.firstChild.nodeValue);
         }
         return res;
      }
      
      public function setAllValues(value:Array) : void
      {
         var v:XMLNode = null;
         for each(v in this.myValueNodes)
         {
            v.removeNode();
         }
         this.myValueNodes = value.map(function(value:String, index:uint, arr:Array):*
         {
            return replaceTextNode(getNode(),undefined,"value",value);
         });
      }
      
      public function getAllOptions() : Array
      {
         return this.myOptionNodes.map(function(optionNode:XMLNode, index:uint, arr:Array):Object
         {
            return {
               "label":optionNode.attributes.label,
               "value":optionNode.firstChild.firstChild.nodeValue
            };
         });
      }
      
      public function setAllOptions(value:Array) : void
      {
         var optionNode:XMLNode = null;
         for each(optionNode in this.myOptionNodes)
         {
            optionNode.removeNode();
         }
         this.myOptionNodes = value.map(function(v:Object, index:uint, arr:Array):XMLNode
         {
            var option:* = replaceTextNode(getNode(),undefined,"value",v.value);
            option.attributes.label = v.label;
            return option;
         });
      }
   }
}
