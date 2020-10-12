package org.igniterealtime.xiff.data.forms
{
   import flash.xml.XMLNode;
   import org.igniterealtime.xiff.data.Extension;
   import org.igniterealtime.xiff.data.ExtensionClassRegistry;
   import org.igniterealtime.xiff.data.IExtension;
   import org.igniterealtime.xiff.data.ISerializable;
   
   public class FormExtension extends Extension implements IExtension, ISerializable
   {
      
      public static const FIELD_TYPE_BOOLEAN:String = "boolean";
      
      public static const FIELD_TYPE_FIXED:String = "fixed";
      
      public static const FIELD_TYPE_HIDDEN:String = "hidden";
      
      public static const FIELD_TYPE_JID_MULTI:String = "jid-multi";
      
      public static const FIELD_TYPE_JID_SINGLE:String = "jid-single";
      
      public static const FIELD_TYPE_LIST_MULTI:String = "list-multi";
      
      public static const FIELD_TYPE_LIST_SINGLE:String = "list-single";
      
      public static const FIELD_TYPE_TEXT_MULTI:String = "text-multi";
      
      public static const FIELD_TYPE_TEXT_PRIVATE:String = "text-private";
      
      public static const FIELD_TYPE_TEXT_SINGLE:String = "text-single";
      
      public static const TYPE_REQUEST:String = "form";
      
      public static const TYPE_RESULT:String = "result";
      
      public static const TYPE_SUBMIT:String = "submit";
      
      public static const TYPE_CANCEL:String = "cancel";
      
      public static const NS:String = "jabber:x:data";
      
      public static const ELEMENT_NAME:String = "x";
       
      
      private var _items:Array;
      
      private var _fields:Array;
      
      private var myReportedFields:Array;
      
      private var myInstructionsNode:XMLNode;
      
      private var myTitleNode:XMLNode;
      
      public function FormExtension(parent:XMLNode = null)
      {
         this._items = [];
         this._fields = [];
         this.myReportedFields = [];
         super(parent);
      }
      
      public static function enable() : Boolean
      {
         ExtensionClassRegistry.register(FormExtension);
         return true;
      }
      
      public function getNS() : String
      {
         return FormExtension.NS;
      }
      
      public function getElementName() : String
      {
         return FormExtension.ELEMENT_NAME;
      }
      
      public function serialize(parent:XMLNode) : Boolean
      {
         var field:FormField = null;
         var node:XMLNode = getNode();
         for each(field in this._fields)
         {
            if(!field.serialize(node))
            {
               return false;
            }
         }
         if(parent != node.parentNode)
         {
            parent.appendChild(node.cloneNode(true));
         }
         return true;
      }
      
      public function deserialize(node:XMLNode) : Boolean
      {
         var c:XMLNode = null;
         var field:FormField = null;
         var itemFields:Array = null;
         var reportedFieldXML:XMLNode = null;
         var itemFieldXML:XMLNode = null;
         setNode(node);
         this.removeAllItems();
         this.removeAllFields();
         for each(c in node.childNodes)
         {
            switch(c.nodeName)
            {
               case "instructions":
                  this.myInstructionsNode = c;
                  continue;
               case "title":
                  this.myTitleNode = c;
                  continue;
               case "reported":
                  for each(reportedFieldXML in c.childNodes)
                  {
                     field = new FormField();
                     field.deserialize(reportedFieldXML);
                     this.myReportedFields.push(field);
                  }
                  continue;
               case "item":
                  itemFields = [];
                  for each(itemFieldXML in c.childNodes)
                  {
                     field = new FormField();
                     field.deserialize(itemFieldXML);
                     itemFields.push(field);
                  }
                  this._items.push(itemFields);
                  continue;
               case "field":
                  field = new FormField();
                  field.deserialize(c);
                  this._fields.push(field);
                  continue;
               default:
                  continue;
            }
         }
         return true;
      }
      
      public function getFormType() : String
      {
         var field:FormField = null;
         for each(field in this._fields)
         {
            if(field.name == "FORM_TYPE")
            {
               return field.value;
            }
         }
         return "";
      }
      
      public function getAllItems() : Array
      {
         return this._items;
      }
      
      public function getFormField(value:String) : FormField
      {
         var field:FormField = null;
         for each(field in this._fields)
         {
            if(field.name == value)
            {
               return field;
            }
         }
         return null;
      }
      
      public function getAllFields() : Array
      {
         return this._fields;
      }
      
      public function setFields(fieldmap:Object) : void
      {
         var f:* = null;
         var field:FormField = null;
         this.removeAllFields();
         for(f in fieldmap)
         {
            field = new FormField();
            field.name = f;
            field.setAllValues(fieldmap[f]);
            this._fields.push(field);
         }
      }
      
      public function removeAllItems() : void
      {
         var item:FormField = null;
         var i:* = undefined;
         for each(item in this._items)
         {
            for each(i in item)
            {
               i.getNode().removeNode();
               i.setNode(null);
            }
         }
         this._items = [];
      }
      
      public function removeAllFields() : void
      {
         var item:FormField = null;
         var i:* = undefined;
         for each(item in this._fields)
         {
            for each(i in item)
            {
               i.getNode().removeNode();
               i.setNode(null);
            }
         }
         this._fields = [];
      }
      
      public function get instructions() : String
      {
         if(this.myInstructionsNode && this.myInstructionsNode.firstChild)
         {
            return this.myInstructionsNode.firstChild.nodeValue;
         }
         return null;
      }
      
      public function set instructions(value:String) : void
      {
         this.myInstructionsNode = replaceTextNode(getNode(),this.myInstructionsNode,"instructions",value);
      }
      
      public function get title() : String
      {
         if(this.myTitleNode && this.myTitleNode.firstChild)
         {
            return this.myTitleNode.firstChild.nodeValue;
         }
         return null;
      }
      
      public function set title(value:String) : void
      {
         this.myTitleNode = replaceTextNode(getNode(),this.myTitleNode,"Title",value);
      }
      
      public function getReportedFields() : Array
      {
         return this.myReportedFields;
      }
      
      public function get type() : String
      {
         return getNode().attributes.type;
      }
      
      public function set type(value:String) : void
      {
         getNode().attributes.type = value;
      }
   }
}
