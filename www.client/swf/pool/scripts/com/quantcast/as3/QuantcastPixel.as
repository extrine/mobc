package com.quantcast.as3
{
   import flash.display.Loader;
   import flash.net.URLRequest;
   
   public class QuantcastPixel
   {
       
      
      private var baseOptions;
      
      private var loaders:Array;
      
      public function QuantcastPixel(options:*)
      {
         super();
         this.baseOptions = options;
         this.loaders = [];
         for(var i:int = 0; i < 10; i++)
         {
            this.loaders.push(new Loader());
         }
      }
      
      public function played(options:*) : void
      {
         var rand:String = "_" + new Date().getTime() + "_" + Math.floor(Math.random() * 9999999);
         var pattern:String = "media=flash" + "&publisherId=" + escape(this.baseOptions.publisherId) + "&event=played" + "&title=" + escape(options.title) + "&videoId=" + escape(options.videoId) + "&pageURL=" + escape("http://www.omgpop.com" + options.videoId) + "&url=" + escape(options.videoId) + "&duration=2000" + "&r=" + rand + "&labels=" + escape(this.baseOptions.labels);
         var url:String = "http://flash.quantserve.com/pixel.swf" + "?" + pattern;
         var req:URLRequest = new URLRequest(url);
         var loader:Loader = this.loaders.pop();
         this.loaders.push(loader);
         loader.unload();
         loader.load(req);
      }
   }
}
