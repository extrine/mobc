package com.partlyhuman.display
{
   import com.partlyhuman.debug.Console;
   import com.partlyhuman.types.DisplayListIterator;
   import com.partlyhuman.types.IDestroyable;
   import com.partlyhuman.types.IIterator;
   import com.partlyhuman.types.TypedIterator;
   import flash.display.Bitmap;
   import flash.display.BlendMode;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.geom.ColorTransform;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   
   public class DisplayUtilities
   {
       
      
      public function DisplayUtilities()
      {
         super();
      }
      
      public static function makeButton(param1:Sprite, param2:Boolean = false, param3:Object = null) : void
      {
         var _loc4_:Sprite = null;
         if(param2)
         {
            _loc4_ = new Sprite();
            _loc4_.graphics.beginFill(16711680,1);
            _loc4_.graphics.drawRect(0,0,param1.width,param1.height);
            _loc4_.mouseEnabled = false;
            if(param3 == null)
            {
               param3 = param1;
            }
            param3.addChildAt(_loc4_,0);
         }
         param1.buttonMode = true;
         param1.mouseChildren = false;
      }
      
      public static function getClassFromInstance(param1:DisplayObject, param2:Class = null) : Class
      {
         var className:String = null;
         var instance:DisplayObject = param1;
         var requiredSubclass:Class = param2;
         var clazz:Class = null;
         try
         {
            className = getQualifiedClassName(instance);
            clazz = Class(getDefinitionByName(className));
            if(requiredSubclass)
            {
               if(!(instance is requiredSubclass))
               {
                  clazz = null;
               }
            }
         }
         catch(error:ReferenceError)
         {
            return null;
         }
         return clazz;
      }
      
      public static function color(param1:DisplayObject, param2:uint) : void
      {
         var _loc4_:uint = param2 & 255;
         param2 = param2 >> 8;
         var _loc5_:uint = param2 & 255;
         param2 = param2 >> 8;
         var _loc6_:uint = param2 & 255;
         var _loc7_:ColorTransform = param1.transform.colorTransform;
         _loc7_.redMultiplier = _loc7_.greenMultiplier = _loc7_.blueMultiplier = 0;
         _loc7_.redOffset = _loc6_;
         _loc7_.greenOffset = _loc5_;
         _loc7_.blueOffset = _loc4_;
         param1.blendMode = BlendMode.LAYER;
         param1.transform.colorTransform = _loc7_;
      }
      
      public static function isAncestor(param1:DisplayObject, param2:DisplayObject) : Boolean
      {
         if(param1 == null)
         {
            return false;
         }
         if(param1 is DisplayObject)
         {
            if(param1 === param2)
            {
               return true;
            }
            return isAncestor(param1.parent,param2);
         }
         return false;
      }
      
      public static function containsDescendent(param1:Object, param2:DisplayObject) : Boolean
      {
         var iter:IIterator = null;
         var mc:DisplayObject = null;
         var rootObjectOrObjects:Object = param1;
         var toFind:DisplayObject = param2;
         if(rootObjectOrObjects is Array)
         {
            return (rootObjectOrObjects as Array).some(function(param1:*, ... rest):Boolean
            {
               return containsDescendent(param1,toFind);
            });
         }
         if(rootObjectOrObjects is DisplayObjectContainer)
         {
            iter = new DisplayListIterator(DisplayObjectContainer(rootObjectOrObjects));
            while(mc = DisplayObject(iter.next()))
            {
               if(mc === toFind)
               {
                  return true;
               }
               if(mc is DisplayObjectContainer)
               {
                  if(containsDescendent(mc,toFind))
                  {
                     return true;
                  }
               }
            }
         }
         else if(rootObjectOrObjects is DisplayObject)
         {
            return rootObjectOrObjects === toFind;
         }
         return false;
      }
      
      public static function childrenAsArray(param1:DisplayObjectContainer) : Array
      {
         var me:DisplayObjectContainer = param1;
         var numChildren:int = me.numChildren;
         var ret:Array = new Array(numChildren);
         var i:int = 0;
         while(i < numChildren)
         {
            try
            {
               ret[i] = me.getChildAt(i);
            }
            catch(error:Error)
            {
               Console.error("Error getting child during childrenAsArray(): " + error.message);
            }
            i++;
         }
         return ret;
      }
      
      public static function enableSmoothing(param1:DisplayObject) : void
      {
         var _loc3_:DisplayObject = null;
         if(!(param1 is DisplayObjectContainer))
         {
            if(param1 is Bitmap)
            {
               Bitmap(param1).smoothing = true;
            }
            return;
         }
         var _loc2_:IIterator = new DisplayListIterator(DisplayObjectContainer(param1));
         while(_loc3_ = DisplayObject(_loc2_.next()))
         {
            if(_loc3_ is Bitmap)
            {
               Bitmap(_loc3_).smoothing = true;
            }
            else if(_loc3_ is DisplayObjectContainer)
            {
               enableSmoothing(DisplayObjectContainer(_loc3_));
            }
         }
      }
      
      public static function unparentDisplayObjects(... rest) : void
      {
         var _loc2_:Object = null;
         var _loc3_:DisplayObject = null;
         for each(_loc2_ in rest)
         {
            if(_loc2_ is DisplayObject)
            {
               _loc3_ = DisplayObject(_loc2_);
               if(_loc3_.parent && _loc3_.parent.contains(_loc3_))
               {
                  _loc3_.parent.removeChild(_loc3_);
               }
            }
         }
      }
      
      public static function getChildByType(param1:DisplayObjectContainer, param2:Class) : Object
      {
         return new TypedIterator(new DisplayListIterator(param1),param2).next();
      }
      
      public static function sizeContent(param1:DisplayObject, param2:DisplayObject = null) : void
      {
         var _loc3_:Number = param1.width;
         var _loc4_:Number = param1.height;
         param1.scaleY = 1;
         param1.scaleX = 1;
         if(param2)
         {
            param2.width = _loc3_;
            param2.height = _loc4_;
         }
      }
      
      public static function destroyChildren(param1:DisplayObjectContainer) : void
      {
         var _loc3_:IDestroyable = null;
         var _loc2_:IIterator = new TypedIterator(new DisplayListIterator(param1),IDestroyable);
         while(_loc3_ = _loc2_.next() as IDestroyable)
         {
            _loc3_.destroy();
         }
         removeAllChildren(param1);
      }
      
      public static function removeAllChildren(param1:DisplayObjectContainer) : void
      {
         var me:DisplayObjectContainer = param1;
         var numChildren:int = me.numChildren;
         var i:int = 0;
         while(i < numChildren)
         {
            try
            {
               me.removeChildAt(0);
            }
            catch(error:Error)
            {
               Console.error("Error removing child during ElementUtility.removeAllChildren(): " + error.message);
            }
            i++;
         }
      }
      
      public static function sortChildrenDepthBy(param1:DisplayObjectContainer, param2:String, param3:uint) : void
      {
         var me:DisplayObjectContainer = param1;
         var sortKey:String = param2;
         var sortOptions:uint = param3;
         var depths:Array = childrenAsArray(me);
         depths.sortOn(sortKey,sortOptions);
         var i:int = 0;
         while(i < depths.length)
         {
            try
            {
               me.setChildIndex(depths[i],i);
            }
            catch(error:Error)
            {
            }
            i++;
         }
      }
   }
}
