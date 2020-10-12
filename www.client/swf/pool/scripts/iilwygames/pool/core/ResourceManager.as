package iilwygames.pool.core
{
   import flash.display.BitmapData;
   import flash.display.BlendMode;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.external.ExternalInterface;
   import flash.filters.BitmapFilterQuality;
   import flash.filters.BlurFilter;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.net.URLRequest;
   import flash.system.LoaderContext;
   import flash.system.SecurityDomain;
   import flash.utils.Dictionary;
   import iilwy.application.AppProperties;
   import iilwy.gamenet.developer.GamenetController;
   import iilwy.gamenet.developer.GamenetPlayerData;
   import iilwy.utils.logging.Logger;
   import iilwygames.pool.events.ResourceManagerEvent;
   import iilwygames.pool.util.CustomLoader;
   import iilwygames.pool.view.TableView;

   public class ResourceManager extends EventDispatcher
   {


      public var _defaultScaleValue:Number = 644;

      private var _loadedArtAsset;

      private var externalLoaders:Vector.<CustomLoader>;

      private var _localTextures:Dictionary;

      private var _ballTextures:Dictionary;

      private var _spriteAsset:Dictionary;

      private var _renderMatrix:Matrix;

      private var _swfLoadCount:int;

      private var ballTexturesCreated:Boolean;

      private var _localEmbedReady:Boolean;

      private const TEST_ASSET:Boolean = false;

      public function ResourceManager()
      {
         super();
         this._localTextures = new Dictionary();
         this._ballTextures = new Dictionary();
         this._spriteAsset = new Dictionary();
         this._loadedArtAsset = null;
         this._renderMatrix = new Matrix();
         this._swfLoadCount = 0;
         this.ballTexturesCreated = false;
         this.externalLoaders = new Vector.<CustomLoader>();
         this._localEmbedReady = false;
      }

      public function destroy() : void
      {
         var bmd:BitmapData = null;
         var ld:Loader = null;
         for each(bmd in this._ballTextures)
         {
            if(bmd)
            {
               bmd.dispose();
            }
         }
         for each(ld in this.externalLoaders)
         {
            ld.unload();
         }
         this._ballTextures = null;
         this._localTextures = null;
         this._loadedArtAsset = null;
         this._renderMatrix = null;
         this._spriteAsset = null;
         this.externalLoaders = null;
      }

      public function stop() : void
      {
         var ld:Loader = null;
         this.disposeTextures();
         for each(ld in this.externalLoaders)
         {
            ld.unload();
         }
         this.externalLoaders.length = 0;
      }

      protected function disposeTextures() : void
      {
         var bitmap:BitmapData = null;
         for each(bitmap in this._localTextures)
         {
            if(bitmap)
            {
               bitmap.dispose();
            }
         }
         this._localTextures = new Dictionary();
         this._spriteAsset = new Dictionary();
      }

      public function loadCustomAsset(urlReq:String, playerJid:String) : void
      {
         var req:* = new URLRequest(urlReq);
         this._swfLoadCount++;
         trace(this._swfLoadCount);
         var ld:* = new CustomLoader(playerJid);
         ld.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onExternalAssetLoaded,false,0,true);
         ld.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.ioErrorHandler,false,0,true);
         ld.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.securityErrorHandler,false,0,true);
         var context:* = new LoaderContext();
         context.checkPolicyFile = true;
         context.securityDomain = SecurityDomain.currentDomain;
         ld.load(req,context);
         this.externalLoaders.push(ld);
      }

      public function loadAssets(controller:GamenetController) : void
      {
         try
         {
            if(controller)
            {
               this.loadExternalResources(controller);
            }
         }
         catch(error:Error)
         {
            trace("error while loading external resources");
            Logger.getInstance().log("error while loading external resources");
            _swfLoadCount = 0;
         }
         try
         {
            this.loadLocalResources();
         }
         catch(error:Error)
         {
            trace("error while loading embedded resources");
            Logger.getInstance().log("error while loading embedded resources");
         }
      }

      protected function loadLocalResources() : void
      {
         var artAssets:Class = null;
         if(!this._loadedArtAsset)
         {
            this._localEmbedReady = false;
            this._swfLoadCount++;
            trace(this._swfLoadCount);
            artAssets = Globals.embeddedResources.art;
            this._loadedArtAsset = new artAssets();
            (this._loadedArtAsset as EventDispatcher).addEventListener(Event.ADDED,this.onArtLoaded,false,0,true);
         }
         else
         {
            this.handleLocalEmbed();
         }
      }

      protected function loadExternalResources(controller:GamenetController) : void
      {
         var productId:String = null;
         var categoryId:String = null;
         var meta:* = undefined;
         var asset:String = null;
         var urlReq:String = null;
         var context:LoaderContext = null;
         var req:URLRequest = null;
         var pdata:GamenetPlayerData = null;
         var gameProducts:* = undefined;
         var websiteProducts:* = undefined;
         var shopID:int = 0;
         var testLoader:CustomLoader = null;
         var obj:* = undefined;
         var ld:CustomLoader = null;
         var js_users:* = ExternalInterface.call("swf.players","");
         Globals.model.darkFelt = false;
         for(var i:int = 0; i < controller.playerList.length; i++)
         {
            pdata = controller.playerList[i];
            gameProducts = null;
            websiteProducts = null;
            if(pdata.activeProductData)
            {
               shopID = controller.shopId;
               if(shopID == -1)
               {
                  shopID = 15;
               }
               gameProducts = pdata.activeProductData[shopID];
               websiteProducts = pdata.activeProductData[1];
            }
            if(this.TEST_ASSET)
            {
               urlReq = "/Users/will/Documents/Projects/omgpop/repository/projects/games/Pool/src/iilwygames/pool/assets/art/decal_9BallKing.swf";
               req = new URLRequest(urlReq);
               testLoader = new CustomLoader(pdata.playerJid);
               testLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onExternalAssetLoaded,false,0,true);
               testLoader.load(req);
               this._swfLoadCount++;
               trace(this._swfLoadCount);
               this.externalLoaders.push(testLoader);
            }
            else if(pdata)
            {
               if(gameProducts)
               {
                  for each(obj in gameProducts)
                  {
                     productId = null;
                     categoryId = null;
                     meta = null;
                     if(obj.base && obj.base.meta)
                     {
                        productId = obj.base.meta.id;
                        categoryId = obj.base.category;
                        meta = obj.base.meta;
                        urlReq = obj.base.asset;
                     }
                     if(meta && meta.feltType)
                     {
                        if(categoryId == "felt")
                        {
                           if(meta.feltType == "dark")
                           {
                              Globals.model.darkFelt = true;
                           }
                           Globals.model.hasFeltProperty = true;
                        }
                     }
                     if(urlReq)
                     {
                        req = new URLRequest(urlReq);
                        this._swfLoadCount++;
                        trace(this._swfLoadCount);
                        ld = new CustomLoader(pdata.playerJid);
                        ld.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onExternalAssetLoaded,false,0,true);
                        ld.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.ioErrorHandler,false,0,true);
                        ld.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.securityErrorHandler,false,0,true);
                        context = new LoaderContext();
                        context.checkPolicyFile = true;
                        if(urlReq.indexOf("http://") > -1 && AppProperties.debugMode != AppProperties.MODE_LOCAL_DEBUGGING)
                        {
                           context.securityDomain = SecurityDomain.currentDomain;
                        }
                        ld.load(req,context);
                        this.externalLoaders.push(ld);
                     }
                  }
               }
            }
         }
         if(js_users[0].pool != null)
         {
            if(js_users[0].pool.decal != null)
            {
               this.loadCustomAsset(js_users[0].pool.decal,js_users[0].username);
            }
            if(js_users[0].pool.table != null)
            {
               this.loadCustomAsset(js_users[0].pool.table,js_users[0].username);
            }
            if(js_users[0].pool.felt != null)
            {
               this.loadCustomAsset(js_users[0].pool.felt,js_users[0].username);
            }
         }
         if(js_users[0].pool != null && js_users[0].pool.stick != null && js_users[0].pool.stick != "")
         {
            this.loadCustomAsset(js_users[0].pool.stick,js_users[0].username);
         }
         else
         {
            this.loadCustomAsset("https://omgmobc.com/game/pool/stick.swf",js_users[0].username);
         }
         if(js_users.length > 1)
         {
            if(js_users[1].pool != null && js_users[1].pool.stick != null && js_users[1].pool.stick != "")
            {
               this.loadCustomAsset(js_users[1].pool.stick,js_users[1].username);
            }
            else
            {
               this.loadCustomAsset("https://omgmobc.com/game/pool/stick.swf",js_users[1].username);
            }
         }
      }

      protected function onArtLoaded(event:Event) : void
      {
         event.currentTarget.removeEventListener(Event.ADDED,this.onArtLoaded);
         if(this._swfLoadCount > 0)
         {
            this._swfLoadCount--;
         }
         this._localEmbedReady = true;
         this.handleLocalEmbed();
      }

      protected function handleLocalEmbed() : void
      {
         var rme:ResourceManagerEvent = null;
         var success:Boolean = this.prepareLocalTextures(this._loadedArtAsset);
         if(success)
         {
            this.buildBallTextures();
            if(this._swfLoadCount == 0)
            {
               rme = new ResourceManagerEvent(ResourceManagerEvent.ASSETS_READY);
               dispatchEvent(rme);
            }
         }
      }

      protected function prepareLocalTextures(object:*) : Boolean
      {
         var asset:MovieClip = null;
         var loader:Loader = MovieClip(object).getChildAt(0) as Loader;
         var lmc:MovieClip = loader.content as MovieClip;
         var size:Number = Globals.view._width;
         if(size == 0)
         {
            return false;
         }
         var i:int = 0;
         while(i < lmc.numChildren)
         {
            asset = lmc.getChildAt(i) as MovieClip;
            if(asset)
            {
               if(asset.name.indexOf("pool") > -1)
               {
                  this._spriteAsset[asset.name] = asset;
                  this._localTextures[asset.name] = this.renderSprite(asset,0,true,true);
                  this._localTextures[asset.name + "_fixed"] = this.renderSprite(asset,1.5,true,true);
               }
               else
               {
                  this._spriteAsset[asset.name] = asset;
                  this._localTextures[asset.name] = this.renderSprite(asset,1);
               }
            }
            i++;
         }
         return true;
      }

      protected function prepareTextureFromMovieClip(mc:MovieClip, owner:String) : void
      {
         var asset:MovieClip = null;
         var i:int = 0;
         while(i < mc.numChildren)
         {
            asset = mc.getChildAt(i) as MovieClip;
            if(asset)
            {
               this._spriteAsset[owner + asset.name] = asset;
               this._localTextures[owner + asset.name] = this.renderSprite(asset);
            }
            i++;
         }
      }

      protected function renderSprite(sprite:Sprite, sizeOverride:Number = 0, transparent:Boolean = true, poolAsset:Boolean = false) : BitmapData
      {
         var bd:BitmapData = null;
         var ct:ColorTransform = null;
         var size:Number = Globals.view.table._width;
         var matrix:Matrix = this._renderMatrix;
         var scalingValue:Number = size / this._defaultScaleValue * TableView.TABLE_SCALE;
         var spriteWidth:Number = sprite.width;
         var spriteHeight:Number = sprite.height;
         if(poolAsset)
         {
            spriteWidth = Math.min(spriteWidth,644);
            spriteHeight = Math.min(spriteHeight,396);
         }
         var renderWidth:Number = Math.ceil(spriteWidth * scalingValue);
         var renderHeight:Number = Math.ceil(spriteHeight * scalingValue);
         matrix.identity();
         if(sizeOverride > 0)
         {
            renderWidth = Math.ceil(sprite.width * sizeOverride);
            renderHeight = Math.ceil(sprite.height * sizeOverride);
            matrix.scale(sizeOverride,sizeOverride);
         }
         else
         {
            matrix.scale(scalingValue,scalingValue);
         }
         if(transparent || sprite.name == "cueBall" || sprite.name.indexOf("decal") > -1 || sprite.name.indexOf("pool_cue") > -1 || sprite.name.indexOf("pool_table") > -1 || sprite.name.indexOf("pool_felt") > -1 || sprite.name.indexOf("pool_bumpers") > -1 || sprite.name == "stripe" || sprite.name == "solid" || sprite.name == "bottomBar")
         {
            bd = new BitmapData(renderWidth,renderHeight,true,0);
         }
         else
         {
            bd = new BitmapData(renderWidth,renderHeight,false,4278190080);
         }
         if(sprite.name.indexOf("decal") > -1)
         {
            ct = new ColorTransform();
            ct.concat(sprite.transform.colorTransform);
            if(Globals.model.darkFelt)
            {
               ct.alphaMultiplier = 1;
            }
            else
            {
               ct.alphaMultiplier = 1;
            }
            bd.draw(sprite,matrix,ct,sprite.blendMode,null,true);
         }
         else
         {
            bd.draw(sprite,matrix,sprite.transform.colorTransform,sprite.blendMode,null,true);
         }
         return bd;
      }

      public function getTexture(name:String, prefix:String = null) : BitmapData
      {
         var textureReq:BitmapData = null;
         if(prefix)
         {
            textureReq = this._localTextures[prefix + name];
            if(!textureReq)
            {
               textureReq = this._localTextures[name];
            }
         }
         else
         {
            textureReq = this._localTextures[name];
         }
         if(!textureReq)
         {
            Logger.getInstance().log("Missing texture: ",name);
         }
         return textureReq;
      }

      public function getSpriteAsset(name:String, prefix:String = "") : Sprite
      {
         var spriteReq:Sprite = this._spriteAsset[prefix + name];
         if(!spriteReq)
         {
            spriteReq = this._spriteAsset[name];
         }
         return spriteReq;
      }

      public function getBallTexture(name:String) : BitmapData
      {
         var textureReq:BitmapData = this._ballTextures[name];
         return textureReq;
      }

      public function resizeAssets() : void
      {
         var ld:CustomLoader = null;
         var rme:ResourceManagerEvent = null;
         this.disposeTextures();
         var success:Boolean = false;
         if(this._loadedArtAsset && this._localEmbedReady)
         {
            success = this.prepareLocalTextures(this._loadedArtAsset);
         }
         for each(ld in this.externalLoaders)
         {
            if(ld.loadComplete)
            {
               this.prepareTextureFromMovieClip(ld.content as MovieClip,ld.ownerJID);
            }
         }
         if(success)
         {
            this.buildBallTextures();
            if(this._swfLoadCount == 0)
            {
               rme = new ResourceManagerEvent(ResourceManagerEvent.ASSETS_READY);
               dispatchEvent(rme);
            }
         }
      }

      private function buildBallTextures() : void
      {
         var color:uint = 0;
         var ballName:String = null;
         if(this.ballTexturesCreated)
         {
            return;
         }
         var W:Number = 256;
         var H:Number = W * 0.5;
         var DOTX:Number = H * 0.5;
         var DOTY:Number = DOTX;
         var white:uint = 16119260;
         var blur:BlurFilter = new BlurFilter(4.5,4.5,BitmapFilterQuality.HIGH);
         var numberTexture:BitmapData = this.getTexture("numbers");
         var ballTexture:BitmapData = new BitmapData(W,H,false,white);
         var tempShape:Shape = new Shape();
         var matrix:Matrix = new Matrix();
         var numberMatrix:Matrix = new Matrix();
         tempShape.graphics.beginFill(9109504);
         tempShape.graphics.drawCircle(DOTX,DOTY,DOTX / 8);
         tempShape.graphics.endFill();
         matrix.identity();
         ballTexture.draw(tempShape,matrix,null,null,null,true);
         matrix.translate(H,0);
         ballTexture.draw(tempShape,matrix,null,null,null,true);
         this._ballTextures["cueball"] = ballTexture;
         ballTexture.applyFilter(ballTexture,ballTexture.rect,new Point(),blur);
         tempShape.graphics.clear();
         tempShape.graphics.beginFill(white);
         tempShape.graphics.drawCircle(DOTX,DOTY,DOTX / 3.5);
         tempShape.graphics.endFill();
         matrix.identity();
         var colorArray:Array = [16756224,272269,13697556,6238111,15951616,2263842,9568530,0];
         var numHeight:Number = 35;
         var numRect:Rectangle = new Rectangle(1 / 4 * W - 0.5 * numberTexture.width,0.5 * H - 0.5 * numHeight,numberTexture.width,numHeight);
         for(var i:int = 0; i < 8; i++)
         {
            color = colorArray[i];
            ballTexture = new BitmapData(W,H,false,color);
            ballTexture.draw(tempShape,matrix,null,null,null,true);
            ballName = "solid_" + (i + 1).toString();
            this._ballTextures[ballName] = ballTexture;
            ballTexture.applyFilter(ballTexture,ballTexture.rect,new Point(),blur);
            numberMatrix.identity();
            numberMatrix.translate(-0.5 * numberTexture.width,0);
            numberMatrix.scale(1,1);
            numberMatrix.translate(0.5 * numberTexture.width,0);
            numberMatrix.translate(1 / 4 * W - 0.5 * numberTexture.width,0.5 * H - 0.5 * numHeight - i * numHeight);
            ballTexture.draw(numberTexture,numberMatrix,null,BlendMode.SUBTRACT,numRect,true);
         }
         var rect:Rectangle = new Rectangle(0,H / 3,W,H / 3);
         for(i = 0; i < 7; i++)
         {
            color = colorArray[i];
            ballTexture = new BitmapData(W,H,false,white);
            ballTexture.fillRect(rect,color);
            ballTexture.draw(tempShape,matrix,null,null,null,true);
            ballName = "stripe_" + (i + 9).toString();
            this._ballTextures[ballName] = ballTexture;
            ballTexture.applyFilter(ballTexture,ballTexture.rect,new Point(),blur);
            numberMatrix.identity();
            numberMatrix.translate(-0.5 * numberTexture.width,0);
            numberMatrix.scale(1,1);
            numberMatrix.translate(0.5 * numberTexture.width,0);
            numberMatrix.translate(1 / 4 * W - 0.5 * numberTexture.width,0.5 * H - 0.5 * numHeight - (i + 8) * numHeight);
            ballTexture.draw(numberTexture,numberMatrix,null,BlendMode.SUBTRACT,numRect,true);
         }
         ballTexture = new BitmapData(W,H,false,11119017);
         tempShape.graphics.clear();
         tempShape.graphics.beginFill(0);
         tempShape.graphics.drawCircle(DOTX,DOTY,DOTX / 8);
         tempShape.graphics.endFill();
         matrix.identity();
         ballTexture.draw(tempShape,matrix,null,null,null,true);
         matrix.translate(H,0);
         ballTexture.draw(tempShape,matrix,null,null,null,true);
         this._ballTextures["extra_ball"] = ballTexture;
         ballTexture.applyFilter(ballTexture,ballTexture.rect,new Point(),blur);
         this.ballTexturesCreated = true;
      }

      private function onExternalAssetLoaded(e:Event) : void
      {
         var ld:CustomLoader = null;
         var mc:MovieClip = null;
         var rme:ResourceManagerEvent = null;
         var info:LoaderInfo = e.target as LoaderInfo;
         if(info)
         {
            ld = info.loader as CustomLoader;
            mc = ld.content as MovieClip;
            ld.loadComplete = true;
            this.prepareTextureFromMovieClip(mc,ld.ownerJID);
            if(this._swfLoadCount > 0)
            {
               this._swfLoadCount--;
            }
            trace(this._swfLoadCount);
            if(this._swfLoadCount == 0)
            {
               rme = new ResourceManagerEvent(ResourceManagerEvent.ASSETS_READY);
               dispatchEvent(rme);
            }
         }
      }

      private function ioErrorHandler(e:Event) : void
      {
         var rme:ResourceManagerEvent = null;
         trace(e);
         if(this._swfLoadCount > 0)
         {
            this._swfLoadCount--;
         }
         if(this._swfLoadCount == 0)
         {
            rme = new ResourceManagerEvent(ResourceManagerEvent.ASSETS_READY);
            dispatchEvent(rme);
         }
      }

      private function securityErrorHandler(e:Event) : void
      {
         var rme:ResourceManagerEvent = null;
         trace(e);
         if(this._swfLoadCount > 0)
         {
            this._swfLoadCount--;
         }
         if(this._swfLoadCount == 0)
         {
            rme = new ResourceManagerEvent(ResourceManagerEvent.ASSETS_READY);
            dispatchEvent(rme);
         }
      }
   }
}
