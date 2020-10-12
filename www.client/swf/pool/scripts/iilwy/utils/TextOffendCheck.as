package iilwy.utils
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import iilwy.application.AppProperties;
   
   public class TextOffendCheck extends EventDispatcher
   {
       
      
      private var offendList:Object;
      
      public var ready:Boolean;
      
      public function TextOffendCheck()
      {
         super();
         this.ready = false;
      }
      
      public function loadList() : void
      {
         var fileloc:String = AppProperties.fileServerStatic + "wordfilter.txt";
         fileloc = fileloc + ("?" + "v=" + String(Math.floor(new Date().time / (1000 * 60 * 10))));
         var loader:URLLoader = new URLLoader();
         loader.addEventListener(Event.COMPLETE,this.loadListSuccess);
         loader.addEventListener(IOErrorEvent.IO_ERROR,this.loadListFail);
         loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.loadListFail);
         loader.dataFormat = URLLoaderDataFormat.TEXT;
         loader.load(new URLRequest(fileloc));
      }
      
      private function loadListSuccess(e:Event) : void
      {
         var loader:URLLoader = e.target as URLLoader;
         var presplit:String = loader.data;
         var splitArray:Array = presplit.split("\n");
         var toObject:Object = new Object();
         var length:int = splitArray.length;
         for(var i:int = 0; i < length; i++)
         {
            if(splitArray[i] != "")
            {
               toObject[splitArray[i].toLowerCase()] = true;
            }
         }
         this.initList(toObject);
         this.ready = true;
      }
      
      private function loadListFail(e:Event) : void
      {
         trace("OFFENDLIST LOAD FAILED");
      }
      
      public function initList(data:Object) : void
      {
         this.offendList = data;
      }
      
      public function isOffensive(input:String) : Boolean
      {
         var param:* = null;
         if(!this.offendList)
         {
            return false;
         }
         input = input.toLowerCase();
         var check:Array = input.split(" ");
         var length:int = check.length;
         for(var i:int = 0; i < length; i++)
         {
            for(param in this.offendList)
            {
               if(check[i] == param)
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      public function containsOffensive(input:String) : Boolean
      {
         var param:* = null;
         var regexp:RegExp = null;
         var check:Array = null;
         if(!this.offendList)
         {
            return false;
         }
         var result:Boolean = false;
         for(param in this.offendList)
         {
            regexp = new RegExp(param,"gi");
            check = input.match(regexp);
            if(check && check.length > 0)
            {
               result = true;
               break;
            }
         }
         return result;
      }
      
      public function screenOffensive(input:String) : String
      {
         var param:* = null;
         var replacement:String = null;
         var regexp:RegExp = null;
         if(!input)
         {
            return null;
         }
         if(!this.offendList)
         {
            return input;
         }
         var result:String = input;
         var replacements:Array = ["","x","xx","xxx","xxxx","xxxxx","xxxxxx","xxxxxxx","xxxxxxxx"];
         for(param in this.offendList)
         {
            replacement = replacements[Math.min(replacements.length,param.length)];
            regexp = new RegExp(param,"gi");
            result = result.replace(regexp,replacement);
         }
         return result;
      }
   }
}
