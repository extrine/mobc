package iilwygames.baloono.graphics
{
   import com.partlyhuman.debug.Console;
   import com.partlyhuman.util.EmbedUtilities;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.geom.ColorTransform;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import iilwygames.baloono.BaloonoGame;
   import iilwygames.baloono.embedded.CharacterSheet;
   import iilwygames.baloono.embedded.SpriteSheets;
   
   public class AssetManager extends EventDispatcher
   {
       
      
      protected var highestActiveDrawLayer:int;
      
      protected var numLoadingSheets:int;
      
      protected var loadingSheets:Dictionary;
      
      protected var loadedSets:Object;
      
      protected var activeSets:Array;
      
      protected var loadedSheets:Object;
      
      protected var characterSheet:XML;
      
      public function AssetManager()
      {
         super();
         this.initialize();
      }
      
      public function consumeCharacterSheet(param1:XML) : void
      {
         var _loc2_:XML = null;
         this.characterSheet = param1;
         this.highestActiveDrawLayer = 0;
         for each(_loc2_ in param1.entity.asset)
         {
            this.getSpriteSheet(this.findXMLAttributeRecursively(_loc2_,"sheet"));
         }
      }
      
      public function clearActive() : void
      {
         this.activeSets = new Array();
      }
      
      public function getSpriteSheet(param1:String) : DisplayObjectContainer
      {
         var _loc2_:DisplayObjectContainer = null;
         if(!(param1 in this.loadedSheets))
         {
            _loc2_ = DisplayObjectContainer(new SpriteSheets[param1]());
            this.loadingSheets[_loc2_] = param1;
            this.numLoadingSheets++;
            _loc2_.addEventListener(Event.ADDED,this.onSheetReady,false,0,true);
            this.loadedSheets[param1] = _loc2_;
         }
         return DisplayObjectContainer(this.loadedSheets[param1]);
      }
      
      public function resizeActiveGraphics(param1:Rectangle) : void
      {
         var _loc3_:GraphicSet = null;
         var _loc2_:int = 0;
         for each(_loc3_ in this.activeSets)
         {
            _loc3_.setTileSize(param1);
            _loc2_++;
         }
         trace(_loc2_ + " active sets");
      }
      
      protected function findXMLAttributeRecursively(param1:XML, param2:String) : String
      {
         while(param1.attribute(param2).length() != 1)
         {
            if(param1.parent() == null)
            {
               return null;
            }
            param1 = param1.parent();
         }
         return param1.attribute(param2).toString();
      }
      
      public function getGraphicSet(param1:String) : GraphicSet
      {
         var node:XML = null;
         var graphicSet:GraphicSet = null;
         var colorNode:* = undefined;
         var colorTransform:ColorTransform = null;
         var assetNode:XML = null;
         var id:String = param1;
         if(!(id in this.loadedSets))
         {
            node = this.characterSheet.entity.(@id == id)[0];
            if(!node)
            {
               if(BaloonoGame.instance.DEBUG_LOGGING)
               {
                  Console.error("Entity not found in character sheet!",id);
               }
               return null;
            }
            graphicSet = new GraphicSet(id,parseInt(node.@layer));
            colorNode = node.colorTransform[0];
            if(colorNode)
            {
               colorTransform = new ColorTransform(colorNode.@ra,colorNode.@ga,colorNode.@ba,1,colorNode.@rb,colorNode.@gb,colorNode.@bb,1);
            }
            for each(assetNode in node.asset)
            {
               graphicSet.addAsset(this.createAsset(assetNode,colorTransform),assetNode.@id);
            }
            this.loadedSets[id] = graphicSet;
            if(graphicSet.drawLayer > this.highestActiveDrawLayer)
            {
               this.highestActiveDrawLayer = graphicSet.drawLayer;
            }
            this.activeSets.push(this.loadedSets[id]);
         }
         return GraphicSet(this.loadedSets[id]);
      }
      
      protected function createAsset(param1:XML, param2:ColorTransform) : GraphicAsset
      {
         var asset:GraphicAsset = null;
         var sheet:DisplayObjectContainer = null;
         var assetNode:XML = param1;
         var colorTransform:ColorTransform = param2;
         var sheetid:String = this.findXMLAttributeRecursively(assetNode,"sheet");
         var linkage:String = assetNode.@linkage;
         var mc:MovieClip = null;
         asset = new GraphicAsset(assetNode.@id,parseInt(this.findXMLAttributeRecursively(assetNode,"framerate")),this.findXMLAttributeRecursively(assetNode,"loop") != "false",this.findXMLAttributeRecursively(assetNode,"blendmode"),colorTransform);
         try
         {
            sheet = this.getSpriteSheet(sheetid);
            mc = MovieClip(sheet.getChildByName(linkage));
         }
         catch(error:Error)
         {
            trace("empty");
         }
         if(mc)
         {
            asset.consumeFrames(mc);
         }
         else if(BaloonoGame.instance.DEBUG_LOGGING)
         {
            Console.error("Sprite " + linkage + " not found in sprite sheet " + sheetid);
         }
         return asset;
      }
      
      public function get activeDrawLayers() : int
      {
         return this.highestActiveDrawLayer + 1;
      }
      
      protected function onSheetReady(param1:Event) : void
      {
         var _loc2_:DisplayObjectContainer = DisplayObjectContainer(param1.currentTarget);
         var _loc3_:String = this.loadingSheets[_loc2_];
         delete this.loadingSheets[_loc2_];
         this.numLoadingSheets--;
         _loc2_.removeEventListener(Event.ADDED,this.onSheetReady);
         this.loadedSheets[_loc3_] = param1.target;
         if(this.numLoadingSheets == 0)
         {
            if(BaloonoGame.instance.DEBUG_LOGGING)
            {
               Console.log("Completed initializing sprite sheets.");
            }
            dispatchEvent(new Event(Event.COMPLETE));
         }
      }
      
      protected function initialize() : void
      {
         this.loadedSheets = new Object();
         this.loadedSets = new Object();
         this.loadingSheets = new Dictionary();
         this.clearActive();
         this.consumeCharacterSheet(EmbedUtilities.classToXML(CharacterSheet.CharacterSheetBinary));
      }
   }
}
