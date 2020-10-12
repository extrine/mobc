package org.igniterealtime.xiff.data
{
   public class ExtensionContainer implements IExtendable
   {
       
      
      public var _exts:Object;
      
      public function ExtensionContainer()
      {
         this._exts = {};
         super();
      }
      
      public function addExtension(ext:IExtension) : IExtension
      {
         if(this._exts[ext.getNS()] == null)
         {
            this._exts[ext.getNS()] = [];
         }
         this._exts[ext.getNS()].push(ext);
         return ext;
      }
      
      public function removeExtension(ext:IExtension) : Boolean
      {
         var i:* = null;
         var extensions:Object = this._exts[ext.getNS()];
         for(i in extensions)
         {
            if(extensions[i] === ext)
            {
               extensions[i].remove();
               extensions.splice(parseInt(i),1);
               return true;
            }
         }
         return false;
      }
      
      public function removeAllExtensions(ns:String) : void
      {
         var i:* = null;
         for(i in this._exts[ns])
         {
            this.removeExtension(this._exts[ns][i]);
         }
         this._exts[ns] = [];
      }
      
      public function getAllExtensionsByNS(ns:String) : Array
      {
         return this._exts[ns];
      }
      
      public function getExtension(name:String) : Extension
      {
         return this.getAllExtensions().filter(function(obj:IExtension, idx:int, arr:Array):Boolean
         {
            return obj.getElementName() == name;
         })[0];
      }
      
      public function getAllExtensions() : Array
      {
         var ns:* = null;
         var exts:Array = [];
         for(ns in this._exts)
         {
            exts = exts.concat(this._exts[ns]);
         }
         return exts;
      }
   }
}
