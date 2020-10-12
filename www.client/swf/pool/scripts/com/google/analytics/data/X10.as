package com.google.analytics.data
{
   public class X10
   {
       
      
      private var _projectData:Object;
      
      private var _key:String = "k";
      
      private var _value:String = "v";
      
      private var _set:Array;
      
      private var _delimBegin:String = "(";
      
      private var _delimEnd:String = ")";
      
      private var _delimSet:String = "*";
      
      private var _delimNumValue:String = "!";
      
      private var _escapeChar:String = "\'";
      
      private var _escapeCharMap:Object;
      
      private var _minimum:int;
      
      private var _hasData:int;
      
      public function X10()
      {
         this._set = [this._key,this._value];
         super();
         this._projectData = {};
         this._escapeCharMap = {};
         this._escapeCharMap[this._escapeChar] = "\'0";
         this._escapeCharMap[this._delimEnd] = "\'1";
         this._escapeCharMap[this._delimSet] = "\'2";
         this._escapeCharMap[this._delimNumValue] = "\'3";
         this._minimum = 1;
      }
      
      private function _setInternal(projectId:Number, type:String, num:Number, value:String) : void
      {
         if(!this.hasProject(projectId))
         {
            this._projectData[projectId] = {};
         }
         if(this._projectData[projectId][type] == undefined)
         {
            this._projectData[projectId][type] = [];
         }
         this._projectData[projectId][type][num] = value;
         this._hasData = this._hasData + 1;
      }
      
      private function _getInternal(projectId:Number, type:String, num:Number) : Object
      {
         if(this.hasProject(projectId) && this._projectData[projectId][type] != undefined)
         {
            return this._projectData[projectId][type][num];
         }
         return undefined;
      }
      
      private function _clearInternal(projectId:Number, type:String) : void
      {
         var isEmpty:Boolean = false;
         var i:int = 0;
         var l:int = 0;
         if(this.hasProject(projectId) && this._projectData[projectId][type] != undefined)
         {
            this._projectData[projectId][type] = undefined;
            isEmpty = true;
            l = this._set.length;
            for(i = 0; i < l; i++)
            {
               if(this._projectData[projectId][this._set[i]] != undefined)
               {
                  isEmpty = false;
                  break;
               }
            }
            if(isEmpty)
            {
               this._projectData[projectId] = undefined;
               this._hasData = this._hasData - 1;
            }
         }
      }
      
      private function _escapeExtensibleValue(value:String) : String
      {
         var i:int = 0;
         var c:String = null;
         var escaped:String = null;
         var result:String = "";
         for(i = 0; i < value.length; i++)
         {
            c = value.charAt(i);
            escaped = this._escapeCharMap[c];
            if(escaped)
            {
               result = result + escaped;
            }
            else
            {
               result = result + c;
            }
         }
         return result;
      }
      
      private function _renderDataType(data:Array) : String
      {
         var str:String = null;
         var i:int = 0;
         var result:Array = [];
         for(i = 0; i < data.length; i++)
         {
            if(data[i] != undefined)
            {
               str = "";
               if(i != this._minimum && data[i - 1] == undefined)
               {
                  str = str + i.toString();
                  str = str + this._delimNumValue;
               }
               str = str + this._escapeExtensibleValue(data[i]);
               result.push(str);
            }
         }
         return this._delimBegin + result.join(this._delimSet) + this._delimEnd;
      }
      
      private function _renderProject(project:Object) : String
      {
         var i:int = 0;
         var data:Array = null;
         var result:String = "";
         var needTypeQualifier:Boolean = false;
         var l:int = this._set.length;
         for(i = 0; i < l; i++)
         {
            data = project[this._set[i]];
            if(data)
            {
               if(needTypeQualifier)
               {
                  result = result + this._set[i];
               }
               result = result + this._renderDataType(data);
               needTypeQualifier = false;
            }
            else
            {
               needTypeQualifier = true;
            }
         }
         return result;
      }
      
      public function hasProject(projectId:Number) : Boolean
      {
         return this._projectData[projectId];
      }
      
      public function hasData() : Boolean
      {
         return this._hasData > 0;
      }
      
      public function setKey(projectId:Number, num:Number, value:String) : Boolean
      {
         this._setInternal(projectId,this._key,num,value);
         return true;
      }
      
      public function getKey(projectId:Number, num:Number) : String
      {
         return this._getInternal(projectId,this._key,num) as String;
      }
      
      public function clearKey(projectId:Number) : void
      {
         this._clearInternal(projectId,this._key);
      }
      
      public function setValue(projectId:Number, num:Number, value:Number) : Boolean
      {
         if(Math.round(value) != value || isNaN(value) || value == Infinity)
         {
            return false;
         }
         this._setInternal(projectId,this._value,num,value.toString());
         return true;
      }
      
      public function getValue(projectId:Number, num:Number) : *
      {
         var value:* = this._getInternal(projectId,this._value,num);
         if(value == null)
         {
            return null;
         }
         return Number(value);
      }
      
      public function clearValue(projectId:Number) : void
      {
         this._clearInternal(projectId,this._value);
      }
      
      public function renderUrlString() : String
      {
         var projectId:* = null;
         var result:Array = [];
         for(projectId in this._projectData)
         {
            if(this.hasProject(Number(projectId)))
            {
               result.push(projectId + this._renderProject(this._projectData[projectId]));
            }
         }
         return result.join("");
      }
      
      public function renderMergedUrlString(extObject:X10 = null) : String
      {
         var projectId:* = null;
         if(!extObject)
         {
            return this.renderUrlString();
         }
         var result:Array = [extObject.renderUrlString()];
         for(projectId in this._projectData)
         {
            if(this.hasProject(Number(projectId)) && !extObject.hasProject(Number(projectId)))
            {
               result.push(projectId + this._renderProject(this._projectData[projectId]));
            }
         }
         return result.join("");
      }
   }
}
