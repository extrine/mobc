package com.google.analytics.core
{
   public class ServerOperationMode
   {
      
      public static const local:ServerOperationMode = new ServerOperationMode(0,"local");
      
      public static const remote:ServerOperationMode = new ServerOperationMode(1,"remote");
      
      public static const both:ServerOperationMode = new ServerOperationMode(2,"both");
       
      
      private var _name:String;
      
      private var _value:int;
      
      public function ServerOperationMode(value:int = 0, name:String = "")
      {
         super();
         this._value = value;
         this._name = name;
      }
      
      public function toString() : String
      {
         return this._name;
      }
      
      public function valueOf() : int
      {
         return this._value;
      }
   }
}
