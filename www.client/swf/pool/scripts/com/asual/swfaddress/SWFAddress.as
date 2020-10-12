package com.asual.swfaddress
{
   import flash.errors.IllegalOperationError;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.external.ExternalInterface;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.system.Capabilities;
   import flash.utils.Timer;
   
   [Event(name="change",type="com.asual.swfaddress.SWFAddressEvent")]
   [Event(name="init",type="com.asual.swfaddress.SWFAddressEvent")]
   public class SWFAddress
   {
      
      private static var _init:Boolean = false;
      
      private static var _initChange:Boolean = false;
      
      private static var _initChanged:Boolean = false;
      
      private static var _strict:Boolean = true;
      
      private static var _value:String = "";
      
      private static var _queue:Array = new Array();
      
      private static var _queueTimer:Timer = new Timer(10);
      
      private static var _initTimer:Timer = new Timer(10);
      
      private static var _availability:Boolean = ExternalInterface.available;
      
      private static var _dispatcher:EventDispatcher = new EventDispatcher();
      
      public static var onInit:Function;
      
      public static var onChange:Function;
      
      private static var _initializer:Boolean = _initialize();
       
      
      public function SWFAddress()
      {
         super();
         throw new IllegalOperationError("SWFAddress cannot be instantiated.");
      }
      
      private static function _initialize() : Boolean
      {
         if(_availability)
         {
            try
            {
               _availability = ExternalInterface.call("function() { return (typeof SWFAddress != \"undefined\"); }") as Boolean;
               ExternalInterface.addCallback("getSWFAddressValue",function():String
               {
                  return _value;
               });
               ExternalInterface.addCallback("setSWFAddressValue",_setValue);
            }
            catch(e:Error)
            {
               _availability = false;
            }
         }
         _queueTimer.addEventListener(TimerEvent.TIMER,_callQueue);
         _initTimer.addEventListener(TimerEvent.TIMER,_check);
         _initTimer.start();
         return true;
      }
      
      private static function _check(event:TimerEvent) : void
      {
         if((typeof SWFAddress["onInit"] == "function" || _dispatcher.hasEventListener(SWFAddressEvent.INIT)) && !_init)
         {
            SWFAddress._setValueInit(_getValue());
            SWFAddress._init = true;
         }
         if(typeof SWFAddress["onChange"] == "function" || _dispatcher.hasEventListener(SWFAddressEvent.CHANGE))
         {
            _initTimer.stop();
            SWFAddress._init = true;
            SWFAddress._setValueInit(_getValue());
         }
      }
      
      private static function _strictCheck(value:String, force:Boolean) : String
      {
         if(SWFAddress.getStrict())
         {
            if(force)
            {
               if(value.substr(0,1) != "/")
               {
                  value = "/" + value;
               }
            }
            else if(value == "")
            {
               value = "/";
            }
         }
         return value;
      }
      
      private static function _getValue() : String
      {
         var value:String = null;
         var arr:Array = null;
         var ids:String = null;
         if(_availability)
         {
            value = ExternalInterface.call("SWFAddress.getValue") as String;
            arr = ExternalInterface.call("SWFAddress.getIds") as Array;
            if(arr != null)
            {
               ids = arr.toString();
            }
         }
         if(ids == null || !_availability || _initChanged)
         {
            value = SWFAddress._value;
         }
         else if(value == "undefined" || value == null)
         {
            value = "";
         }
         return _strictCheck(value || "",false);
      }
      
      private static function _setValueInit(value:String) : void
      {
         SWFAddress._value = value;
         if(!_init)
         {
            _dispatchEvent(SWFAddressEvent.INIT);
         }
         else
         {
            _dispatchEvent(SWFAddressEvent.CHANGE);
         }
         _initChange = true;
      }
      
      private static function _setValue(value:String) : void
      {
         if(value == "undefined" || value == null)
         {
            value = "";
         }
         if(SWFAddress._value == value && SWFAddress._init)
         {
            return;
         }
         if(!SWFAddress._initChange)
         {
            return;
         }
         SWFAddress._value = value;
         if(!_init)
         {
            SWFAddress._init = true;
            if(typeof SWFAddress["onInit"] == "function" || _dispatcher.hasEventListener(SWFAddressEvent.INIT))
            {
               _dispatchEvent(SWFAddressEvent.INIT);
            }
         }
         _dispatchEvent(SWFAddressEvent.CHANGE);
      }
      
      private static function _dispatchEvent(type:String) : void
      {
         if(_dispatcher.hasEventListener(type))
         {
            _dispatcher.dispatchEvent(new SWFAddressEvent(type));
         }
         type = type.substr(0,1).toUpperCase() + type.substring(1);
         if(typeof SWFAddress["on" + type] == "function")
         {
            SWFAddress["on" + type]();
         }
      }
      
      private static function _callQueue(event:TimerEvent) : void
      {
         var script:String = null;
         var i:int = 0;
         var obj:Object = null;
         if(_queue.length != 0)
         {
            script = "";
            for(i = 0; obj = _queue[i]; i++)
            {
               if(obj.param is String)
               {
                  obj.param = "\"" + obj.param + "\"";
               }
               script = script + (obj.fn + "(" + obj.param + ");");
            }
            _queue = new Array();
            navigateToURL(new URLRequest("javascript:" + script + "void(0);"),"_self");
         }
         else
         {
            _queueTimer.stop();
         }
      }
      
      private static function _call(fn:String, param:Object = "") : void
      {
         if(_availability)
         {
            if(Capabilities.os.indexOf("Mac") != -1)
            {
               if(_queue.length == 0)
               {
                  _queueTimer.start();
               }
               _queue.push({
                  "fn":fn,
                  "param":param
               });
            }
            else
            {
               ExternalInterface.call(fn,param);
            }
         }
      }
      
      public static function back() : void
      {
         _call("SWFAddress.back");
      }
      
      public static function forward() : void
      {
         _call("SWFAddress.forward");
      }
      
      public static function up() : void
      {
         var path:String = SWFAddress.getPath();
         SWFAddress.setValue(path.substr(0,path.lastIndexOf("/",path.length - 2) + (path.substr(path.length - 1) == "/"?1:0)));
      }
      
      public static function go(delta:int) : void
      {
         _call("SWFAddress.go",delta);
      }
      
      public static function href(url:String, target:String = "_self") : void
      {
         if(_availability && Capabilities.playerType == "ActiveX")
         {
            ExternalInterface.call("SWFAddress.href",url,target);
            return;
         }
         navigateToURL(new URLRequest(url),target);
      }
      
      public static function popup(url:String, name:String = "popup", options:String = "\"\"", handler:String = "") : void
      {
         if(_availability && (Capabilities.playerType == "ActiveX" || ExternalInterface.call("asual.util.Browser.isSafari")))
         {
            ExternalInterface.call("SWFAddress.popup",url,name,options,handler);
            return;
         }
         navigateToURL(new URLRequest("javascript:popup=window.open(\"" + url + "\",\"" + name + "\"," + options + ");" + handler + ";void(0);"),"_self");
      }
      
      public static function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
      {
         _dispatcher.addEventListener(type,listener,useCapture,priority,useWeakReference);
      }
      
      public static function removeEventListener(type:String, listener:Function, useCapture:Boolean = false) : void
      {
         _dispatcher.removeEventListener(type,listener,useCapture);
      }
      
      public static function dispatchEvent(event:Event) : Boolean
      {
         return _dispatcher.dispatchEvent(event);
      }
      
      public static function hasEventListener(type:String) : Boolean
      {
         return _dispatcher.hasEventListener(type);
      }
      
      public static function getBaseURL() : String
      {
         var url:String = null;
         if(_availability)
         {
            url = String(ExternalInterface.call("SWFAddress.getBaseURL"));
         }
         return url == null || url == "null" || !_availability?"":url;
      }
      
      public static function getStrict() : Boolean
      {
         var strict:String = null;
         if(_availability)
         {
            strict = ExternalInterface.call("SWFAddress.getStrict") as String;
         }
         return strict == null?Boolean(_strict):Boolean(strict == "true");
      }
      
      public static function setStrict(strict:Boolean) : void
      {
         _call("SWFAddress.setStrict",strict);
         _strict = strict;
      }
      
      public static function getHistory() : Boolean
      {
         return !!_availability?Boolean(ExternalInterface.call("SWFAddress.getHistory") as Boolean):Boolean(false);
      }
      
      public static function setHistory(history:Boolean) : void
      {
         _call("SWFAddress.setHistory",history);
      }
      
      public static function getTracker() : String
      {
         return !!_availability?ExternalInterface.call("SWFAddress.getTracker") as String:"";
      }
      
      public static function setTracker(tracker:String) : void
      {
         _call("SWFAddress.setTracker",tracker);
      }
      
      public static function getTitle() : String
      {
         var title:String = !!_availability?ExternalInterface.call("SWFAddress.getTitle") as String:"";
         if(title == "undefined" || title == null)
         {
            title = "";
         }
         return decodeURI(title);
      }
      
      public static function setTitle(title:String) : void
      {
         _call("SWFAddress.setTitle",encodeURI(decodeURI(title)));
      }
      
      public static function getStatus() : String
      {
         var status:String = !!_availability?ExternalInterface.call("SWFAddress.getStatus") as String:"";
         if(status == "undefined" || status == null)
         {
            status = "";
         }
         return decodeURI(status);
      }
      
      public static function setStatus(status:String) : void
      {
         _call("SWFAddress.setStatus",encodeURI(decodeURI(status)));
      }
      
      public static function resetStatus() : void
      {
         _call("SWFAddress.resetStatus");
      }
      
      public static function getValue() : String
      {
         return decodeURI(_strictCheck(_value || "",false));
      }
      
      public static function setValue(value:String) : void
      {
         if(value == "undefined" || value == null)
         {
            value = "";
         }
         value = encodeURI(decodeURI(_strictCheck(value,true)));
         if(SWFAddress._value == value)
         {
            return;
         }
         SWFAddress._value = value;
         _call("SWFAddress.setValue",value);
         if(SWFAddress._init)
         {
            _dispatchEvent(SWFAddressEvent.CHANGE);
         }
         else
         {
            _initChanged = true;
         }
      }
      
      public static function getPath() : String
      {
         var value:String = SWFAddress.getValue();
         if(value.indexOf("?") != -1)
         {
            return value.split("?")[0];
         }
         if(value.indexOf("#") != -1)
         {
            return value.split("#")[0];
         }
         return value;
      }
      
      public static function getPathNames() : Array
      {
         var path:String = SWFAddress.getPath();
         var names:Array = path.split("/");
         if(path.substr(0,1) == "/" || path.length == 0)
         {
            names.splice(0,1);
         }
         if(path.substr(path.length - 1,1) == "/")
         {
            names.splice(names.length - 1,1);
         }
         return names;
      }
      
      public static function getQueryString() : String
      {
         var value:String = SWFAddress.getValue();
         var index:Number = value.indexOf("?");
         if(index != -1 && index < value.length)
         {
            return value.substr(index + 1);
         }
         return "";
      }
      
      public static function getParameter(param:String) : String
      {
         var params:Array = null;
         var p:Array = null;
         var i:Number = NaN;
         var value:String = SWFAddress.getValue();
         var index:Number = value.indexOf("?");
         if(index != -1)
         {
            value = value.substr(index + 1);
            params = value.split("&");
            i = params.length;
            while(i--)
            {
               p = params[i].split("=");
               if(p[0] == param)
               {
                  return p[1];
               }
            }
         }
         return "";
      }
      
      public static function getParameterNames() : Array
      {
         var params:Array = null;
         var i:Number = NaN;
         var value:String = SWFAddress.getValue();
         var index:Number = value.indexOf("?");
         var names:Array = new Array();
         if(index != -1)
         {
            value = value.substr(index + 1);
            if(value != "" && value.indexOf("=") != -1)
            {
               params = value.split("&");
               i = 0;
               while(i < params.length)
               {
                  names.push(params[i].split("=")[0]);
                  i++;
               }
            }
         }
         return names;
      }
   }
}
