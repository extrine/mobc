package org.igniterealtime.xiff.data
{
   public interface IExtendable
   {
       
      
      function addExtension(extension:IExtension) : IExtension;
      
      function getAllExtensionsByNS(ns:String) : Array;
      
      function getAllExtensions() : Array;
      
      function removeExtension(extension:IExtension) : Boolean;
      
      function removeAllExtensions(ns:String) : void;
   }
}
