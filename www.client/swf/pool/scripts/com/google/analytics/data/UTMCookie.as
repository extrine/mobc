package com.google.analytics.data
{
   import com.google.analytics.core.Buffer;
   
   public class UTMCookie implements Cookie
   {
       
      
      private var _creation:Date;
      
      private var _expiration:Date;
      
      private var _timespan:Number;
      
      protected var name:String;
      
      protected var inURL:String;
      
      protected var fields:Array;
      
      public var proxy:Buffer;
      
      public function UTMCookie(name:String, inURL:String, fields:Array, timespan:Number = 0)
      {
         super();
         this.name = name;
         this.inURL = inURL;
         this.fields = fields;
         this._timestamp(timespan);
      }
      
      private function _timestamp(timespan:Number) : void
      {
         this.creation = new Date();
         this._timespan = timespan;
         if(timespan > 0)
         {
            this.expiration = new Date(this.creation.valueOf() + timespan);
         }
      }
      
      protected function update() : void
      {
         this.resetTimestamp();
         if(this.proxy)
         {
            this.proxy.update(this.name,this.toSharedObject());
         }
      }
      
      public function get creation() : Date
      {
         return this._creation;
      }
      
      public function set creation(value:Date) : void
      {
         this._creation = value;
      }
      
      public function get expiration() : Date
      {
         if(this._expiration)
         {
            return this._expiration;
         }
         return new Date(new Date().valueOf() + 1000);
      }
      
      public function set expiration(value:Date) : void
      {
         this._expiration = value;
      }
      
      public function fromSharedObject(data:Object) : void
      {
         var field:String = null;
         var len:int = this.fields.length;
         for(var i:int = 0; i < len; i++)
         {
            field = this.fields[i];
            if(data[field])
            {
               this[field] = data[field];
            }
         }
         if(data.creation)
         {
            this.creation = data.creation;
         }
         if(data.expiration)
         {
            this.expiration = data.expiration;
         }
      }
      
      public function isEmpty() : Boolean
      {
         var field:String = null;
         var empty:int = 0;
         for(var i:int = 0; i < this.fields.length; i++)
         {
            field = this.fields[i];
            if(this[field] is Number && isNaN(this[field]))
            {
               empty++;
            }
            else if(this[field] is String && this[field] == "")
            {
               empty++;
            }
         }
         if(empty == this.fields.length)
         {
            return true;
         }
         return false;
      }
      
      public function isExpired() : Boolean
      {
         var current:Date = new Date();
         var diff:Number = this.expiration.valueOf() - current.valueOf();
         if(diff <= 0)
         {
            return true;
         }
         return false;
      }
      
      public function reset() : void
      {
         var field:String = null;
         for(var i:int = 0; i < this.fields.length; i++)
         {
            field = this.fields[i];
            if(this[field] is Number)
            {
               this[field] = NaN;
            }
            else if(this[field] is String)
            {
               this[field] = "";
            }
         }
         this.resetTimestamp();
         this.update();
      }
      
      public function resetTimestamp(timespan:Number = NaN) : void
      {
         if(!isNaN(timespan))
         {
            this._timespan = timespan;
         }
         this._creation = null;
         this._expiration = null;
         this._timestamp(this._timespan);
      }
      
      public function toURLString() : String
      {
         return this.inURL + "=" + this.valueOf();
      }
      
      public function toSharedObject() : Object
      {
         var field:String = null;
         var value:* = undefined;
         var data:Object = {};
         for(var i:int = 0; i < this.fields.length; i++)
         {
            field = this.fields[i];
            value = this[field];
            if(value is String)
            {
               data[field] = value;
            }
            else if(value == 0)
            {
               data[field] = value;
            }
            else if(!isNaN(value))
            {
               data[field] = value;
            }
         }
         data.creation = this.creation;
         data.expiration = this.expiration;
         return data;
      }
      
      public function toString(showTimestamp:Boolean = false) : String
      {
         var field:String = null;
         var value:* = undefined;
         var data:Array = [];
         var len:int = this.fields.length;
         for(var i:int = 0; i < len; i++)
         {
            field = this.fields[i];
            value = this[field];
            if(value is String)
            {
               data.push(field + ": \"" + value + "\"");
            }
            else if(value == 0)
            {
               data.push(field + ": " + value);
            }
            else if(!isNaN(value))
            {
               data.push(field + ": " + value);
            }
         }
         var str:String = this.name.toUpperCase() + " {" + data.join(", ") + "}";
         if(showTimestamp)
         {
            str = str + (" creation:" + this.creation + ", expiration:" + this.expiration);
         }
         return str;
      }
      
      public function valueOf() : String
      {
         var field:String = null;
         var value:* = undefined;
         var testData:Array = null;
         var data:Array = [];
         var testOut:String = "";
         for(var i:int = 0; i < this.fields.length; i++)
         {
            field = this.fields[i];
            value = this[field];
            if(value is String)
            {
               if(value == "")
               {
                  value = "-";
                  data.push(value);
               }
               else
               {
                  data.push(value);
               }
            }
            else if(value is Number)
            {
               if(value == 0)
               {
                  data.push(value);
               }
               else if(isNaN(value))
               {
                  value = "-";
                  data.push(value);
               }
               else
               {
                  data.push(value);
               }
            }
         }
         if(this.isEmpty())
         {
            return "-";
         }
         return "" + data.join(".");
      }
   }
}
