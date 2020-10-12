package iilwygames.pool.view
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.geom.Vector3D;
   import iilwygames.pool.core.Globals;
   import iilwygames.pool.model.Player;
   import iilwygames.pool.model.gameplay.Ball;
   import iilwygames.pool.model.gameplay.Ruleset.Ruleset;
   import iilwygames.pool.model.gameplay.Team;
   import iilwygames.pool.model.physics.Wall;
   
   public class TableView extends Sprite
   {
      
      public static const TABLE_SCALE:Number = 1.16;
      
      public static var RENDER_TABLE_OUTLINE:Boolean = true;
      
      public static var MAX_BALLS:int = 24;
       
      
      public var _width:Number;
      
      public var _height:Number;
      
      public var playFieldWidth:Number;
      
      public var playFieldHeight:Number;
      
      public var playFieldOffsetX:Number;
      
      public var playFieldOffsetY:Number;
      
      private var ballViews:Vector.<BallView>;
      
      private var pocketLayer:Bitmap;
      
      private var underFeltLayer:Sprite;
      
      private var feltLayer:Bitmap;
      
      private var decalLayer:Bitmap;
      
      private var ballLayer:Sprite;
      
      private var bumperLayer:Bitmap;
      
      private var tableLayer:Bitmap;
      
      private var ballShadowLayer:Sprite;
      
      private var ballTargetLayer:Sprite;
      
      private var kitchenArea:Sprite;
      
      private var testSprite:Sprite;
      
      private var ballHoleMask:Sprite;
      
      private var _targetPocket:Vector.<Sprite>;
      
      public function TableView()
      {
         var bv:BallView = null;
         super();
         if(Globals.FACEBOOK_BUILD)
         {
            MAX_BALLS = 24;
         }
         else
         {
            MAX_BALLS = 16;
         }
         this.pocketLayer = new Bitmap();
         this.underFeltLayer = new Sprite();
         this.feltLayer = new Bitmap();
         this.ballLayer = new Sprite();
         this.bumperLayer = new Bitmap();
         this.tableLayer = new Bitmap();
         this.decalLayer = new Bitmap();
         this.ballShadowLayer = new Sprite();
         this.ballHoleMask = new Sprite();
         this.kitchenArea = new Sprite();
         this.ballTargetLayer = new Sprite();
         this._width = 0;
         this._height = 0;
         this.playFieldWidth = 0;
         this.playFieldHeight = 0;
         this.playFieldOffsetX = 0;
         this.playFieldOffsetY = 0;
         this.ballViews = new Vector.<BallView>();
         this._targetPocket = new Vector.<Sprite>();
         for(var i:int = 0; i < MAX_BALLS; i++)
         {
            bv = new BallView();
            this.ballViews.push(bv);
            this.ballLayer.addChild(bv);
            this.ballShadowLayer.addChild(bv.ballShadow);
            bv.visible = false;
         }
         addChild(this.feltLayer);
         addChild(this.decalLayer);
         addChild(this.ballShadowLayer);
         addChild(this.bumperLayer);
         addChild(this.tableLayer);
         addChild(this.kitchenArea);
         addChild(this.pocketLayer);
         addChild(this.underFeltLayer);
         addChild(this.ballTargetLayer);
         addChild(this.ballLayer);
         addChild(this.ballHoleMask);
         this.underFeltLayer.mask = this.ballHoleMask;
         if(RENDER_TABLE_OUTLINE)
         {
            this.testSprite = new Sprite();
            addChild(this.testSprite);
         }
         mouseEnabled = false;
         this.kitchenArea.visible = false;
      }
      
      public function destroy() : void
      {
         var bv:BallView = null;
         for(var i:int = 0; i < MAX_BALLS; i++)
         {
            bv = this.ballViews[i];
            if(this.ballLayer.contains(bv))
            {
               this.ballLayer.removeChild(bv);
            }
            else if(this.underFeltLayer.contains(bv))
            {
               this.underFeltLayer.removeChild(bv);
            }
            bv.destroy();
         }
         var j:int = this.ballShadowLayer.numChildren;
         while(j-- > 0)
         {
            this.ballShadowLayer.removeChildAt(j);
         }
         removeChild(this.pocketLayer);
         removeChild(this.underFeltLayer);
         removeChild(this.feltLayer);
         removeChild(this.decalLayer);
         removeChild(this.ballLayer);
         removeChild(this.bumperLayer);
         removeChild(this.tableLayer);
         removeChild(this.ballHoleMask);
         removeChild(this.ballShadowLayer);
         removeChild(this.kitchenArea);
         this.ballViews = null;
         this.pocketLayer = null;
         this.underFeltLayer = null;
         this.feltLayer = null;
         this.decalLayer = null;
         this.ballLayer = null;
         this.bumperLayer = null;
         this.tableLayer = null;
         this.ballShadowLayer = null;
         this.kitchenArea = null;
         this.ballHoleMask = null;
      }
      
      public function stop() : void
      {
         var bv:BallView = null;
         for(var i:int = 0; i < MAX_BALLS; i++)
         {
            bv = this.ballViews[i];
            bv.stop();
            bv.visible = false;
         }
      }
      
      public function initModels() : void
      {
         var bv:BallView = null;
         var fb:Ball = null;
         var rs:Ruleset = Globals.model.ruleset;
         var balls:Vector.<Ball> = rs.balls;
         var numBalls:int = rs.balls.length;
         for(var j:int = 0; j < MAX_BALLS; j++)
         {
            bv = this.ballViews[j];
            bv.stop();
            bv.visible = false;
         }
         for(var i:int = 0; i < numBalls; i++)
         {
            fb = balls[i];
            bv = this.ballViews[i];
            bv.visible = true;
            bv.attachObject(fb);
            this.resetBall(fb);
         }
         bv = this.ballViews[numBalls];
         bv.attachObject(rs.cueBall);
         this.resetBall(rs.cueBall);
      }
      
      public function pocketBall(ball:Ball) : void
      {
         var bv:BallView = null;
         for(var i:int = 0; i < MAX_BALLS; i++)
         {
            bv = this.ballViews[i];
            if(bv.ball == ball)
            {
               if(this.ballLayer.contains(bv))
               {
                  this.ballLayer.removeChild(bv);
               }
               if(this.ballLayer.contains(bv.ballShadow))
               {
                  this.ballLayer.removeChild(bv.ballShadow);
               }
               if(this.underFeltLayer.contains(bv.ballShadow) == false)
               {
                  this.underFeltLayer.addChild(bv.ballShadow);
               }
               if(this.underFeltLayer.contains(bv) == false)
               {
                  this.underFeltLayer.addChild(bv);
               }
            }
         }
      }
      
      public function resetBall(ball:Ball) : void
      {
         var bv:BallView = null;
         for(var i:int = 0; i < MAX_BALLS; i++)
         {
            bv = this.ballViews[i];
            if(bv.ball == ball)
            {
               if(this.underFeltLayer.contains(bv))
               {
                  this.underFeltLayer.removeChild(bv);
               }
               if(this.underFeltLayer.contains(bv.ballShadow))
               {
                  this.underFeltLayer.removeChild(bv.ballShadow);
               }
               if(this.ballShadowLayer.contains(bv.ballShadow) == false)
               {
                  this.ballShadowLayer.addChild(bv.ballShadow);
               }
               if(this.ballLayer.contains(bv) == false)
               {
                  this.ballLayer.addChild(bv);
               }
               bv.visible = true;
               bv.ballShadow.visible = true;
               return;
            }
         }
      }
      
      public function redrawTable() : void
      {
         var breakerJID:String = null;
         var teams:Vector.<Team> = null;
         var breakingTeam:Team = null;
         var player:Player = null;
         var pockets:Vector.<Vector3D> = null;
         var pocketRadius:Number = NaN;
         var i:int = 0;
         var pk:Vector3D = null;
         var pocketX:Number = NaN;
         var pocketY:Number = NaN;
         if(Globals.model && Globals.model.ruleset)
         {
            teams = Globals.model.ruleset.teams;
         }
         if(teams && teams.length > Globals.model.breakingTeam)
         {
            breakingTeam = Globals.model.ruleset.teams[Globals.model.breakingTeam];
         }
         if(breakingTeam)
         {
            player = breakingTeam.getCurrentPlayerUp();
            if(player)
            {
               breakerJID = player.playerData.playerJid;
            }
         }
         var pocket:BitmapData = Globals.resourceManager.getTexture("pool_holes");
         var felt:BitmapData = Globals.resourceManager.getTexture("pool_felt",breakerJID);
         var bumper:BitmapData = Globals.resourceManager.getTexture("pool_bumpers",breakerJID);
         var table:BitmapData = Globals.resourceManager.getTexture("pool_table",breakerJID);
         var decal:BitmapData = Globals.resourceManager.getTexture("pool_decal",breakerJID);
         this.pocketLayer.bitmapData = pocket;
         this.feltLayer.bitmapData = felt;
         this.bumperLayer.bitmapData = bumper;
         this.tableLayer.bitmapData = table;
         this.decalLayer.bitmapData = decal;
         if(RENDER_TABLE_OUTLINE && Globals.EDITOR_MODE)
         {
            this.renderGuideLines();
         }
         else if(this.testSprite)
         {
            this.testSprite.graphics.clear();
         }
         var scale:Number = 1;
         this.ballHoleMask.graphics.clear();
         if(Globals.model.ruleset)
         {
            scale = this.playFieldWidth / Globals.model.ruleset.tableWidth;
            pockets = Globals.model.ruleset.pocketPositions;
            pocketRadius = Globals.model.ruleset.pocketRadius * scale;
            for(i = 0; i < 6; i++)
            {
               pk = pockets[i];
               pocketX = pk.x * scale;
               pocketY = pk.y * scale;
               this.ballHoleMask.graphics.beginFill(16711680,1);
               this.ballHoleMask.graphics.drawCircle(pocketX,pocketY,pocketRadius);
               this.ballHoleMask.graphics.endFill();
            }
            this.kitchenArea.graphics.clear();
            this.kitchenArea.graphics.beginFill(0,0.2);
            this.kitchenArea.graphics.drawRect(0,0,Globals.model.ruleset.tableWidth * 0.25 * scale,Globals.model.ruleset.tableHeight * scale);
            this.kitchenArea.graphics.endFill();
         }
      }
      
      public function update(et:Number) : void
      {
         var bv:BallView = null;
         var colorArray:Array = [16756224,272269,13697556,6238111,15951616,2263842,9568530,0,16777215];
         var scale:Number = this.playFieldWidth / Globals.model.ruleset.tableWidth;
         this.ballTargetLayer.graphics.clear();
         var targetRadius:Number = 0.05715 * 0.25;
         for(var i:int = 0; i < MAX_BALLS; i++)
         {
            bv = this.ballViews[i];
            if(bv.visible)
            {
               bv.update(et);
               if(bv.ball.hasTarget)
               {
                  this.ballTargetLayer.graphics.beginFill(colorArray[bv.ball.ballNumber - 1]);
                  this.ballTargetLayer.graphics.drawCircle(bv.ball.targetPocket.x * scale,bv.ball.targetPocket.y * scale,targetRadius * scale);
                  this.ballTargetLayer.graphics.endFill();
               }
            }
         }
      }
      
      public function showKitchenArea() : void
      {
         this.kitchenArea.visible = true;
      }
      
      public function hideKitchenArea() : void
      {
         this.kitchenArea.visible = false;
      }
      
      public function resizeAssets() : void
      {
         var bv:BallView = null;
         this.redrawTable();
         for(var i:int = 0; i < MAX_BALLS; i++)
         {
            bv = this.ballViews[i];
            bv.resizeAssets();
         }
      }
      
      private function renderGuideLines() : void
      {
         var scale:Number = NaN;
         var tableWidth:Number = NaN;
         var tableHeight:Number = NaN;
         var segmentWidth:Number = NaN;
         var segmentHeight:Number = NaN;
         var i:int = 0;
         var j:int = 0;
         this.testSprite.graphics.clear();
         if(Globals.model.ruleset)
         {
            scale = this.playFieldWidth / Globals.model.ruleset.tableWidth;
            tableWidth = Globals.model.ruleset.tableWidth;
            tableHeight = Globals.model.ruleset.tableHeight;
            segmentWidth = tableWidth / 8;
            segmentHeight = tableHeight / 4;
            for(i = 0; i <= 8; i++)
            {
               this.testSprite.graphics.lineStyle(1,16777215,0.5);
               this.testSprite.graphics.moveTo(i * segmentWidth * scale,0);
               this.testSprite.graphics.lineTo(i * segmentWidth * scale,tableHeight * scale);
               this.testSprite.graphics.endFill();
            }
            for(j = 0; j <= 4; j++)
            {
               this.testSprite.graphics.lineStyle(1,16777215,0.5);
               this.testSprite.graphics.moveTo(0,j * segmentHeight * scale);
               this.testSprite.graphics.lineTo(tableWidth * scale,j * segmentHeight * scale);
               this.testSprite.graphics.endFill();
            }
         }
      }
      
      public function renderTestTable() : void
      {
         var pockets:Vector.<Vector3D> = null;
         var pocketRadius:Number = NaN;
         var pocket:Vector3D = null;
         var pocketX:Number = NaN;
         var pocketY:Number = NaN;
         var wall:Wall = null;
         var wall2:Wall = null;
         var i:int = 0;
         var len:int = Globals.model.world.gameObjects.length;
         var scale:Number = 1;
         this.testSprite.graphics.clear();
         if(Globals.model.ruleset)
         {
            scale = this.playFieldWidth / Globals.model.ruleset.tableWidth;
            pockets = Globals.model.ruleset.pocketPositions;
            pocketRadius = Globals.model.ruleset.pocketRadius * scale;
            for(i = 0; i < 6; i++)
            {
               pocket = pockets[i];
               pocketX = pocket.x * scale;
               pocketY = pocket.y * scale;
               this.testSprite.graphics.lineStyle();
               this.testSprite.graphics.beginFill(255,1);
               this.testSprite.graphics.drawCircle(pocketX,pocketY,pocketRadius);
               this.testSprite.graphics.endFill();
            }
         }
         len = Globals.model.world.walls.length;
         for(i = 0; i < len; i++)
         {
            wall = Globals.model.world.walls[i];
            this.testSprite.graphics.lineStyle(1,0,1);
            this.testSprite.graphics.moveTo(wall.pointA.x * scale,wall.pointA.y * scale);
            this.testSprite.graphics.lineTo(wall.pointB.x * scale,wall.pointB.y * scale);
            this.testSprite.graphics.endFill();
         }
         if(Globals.model.ruleset)
         {
            len = Globals.model.ruleset.quickWallCheck.length;
            for(i = 0; i < len; i++)
            {
               wall2 = Globals.model.ruleset.quickWallCheck[i];
               this.testSprite.graphics.lineStyle(1,16777215,1);
               this.testSprite.graphics.moveTo(wall2.pointA.x * scale,wall2.pointA.y * scale);
               this.testSprite.graphics.lineTo(wall2.pointB.x * scale,wall2.pointB.y * scale);
               this.testSprite.graphics.endFill();
            }
         }
      }
      
      public function setSize(w:Number, h:Number) : void
      {
         var bv:BallView = null;
         var ratio:Number = 644 / 396;
         var currRatio:Number = w / h;
         if(currRatio > ratio)
         {
            this._width = h * ratio;
            this._height = h;
         }
         else
         {
            this._width = w;
            this._height = w / ratio;
         }
         this.playFieldOffsetX = 72.5 / 644 * this._width * TABLE_SCALE;
         this.playFieldOffsetY = 72.5 / 396 * this._height * TABLE_SCALE;
         this.playFieldWidth = TABLE_SCALE * this._width - 2 * this.playFieldOffsetX;
         this.playFieldHeight = TABLE_SCALE * this._width * 50 / 100;
         if(RENDER_TABLE_OUTLINE)
         {
            this.testSprite.x = this.playFieldOffsetX;
            this.testSprite.y = this.playFieldOffsetY;
         }
         this.ballHoleMask.x = this.playFieldOffsetX;
         this.ballHoleMask.y = this.playFieldOffsetY;
         this.kitchenArea.x = this.playFieldOffsetX;
         this.kitchenArea.y = this.playFieldOffsetY;
         this.ballTargetLayer.x = this.playFieldOffsetX;
         this.ballTargetLayer.y = this.playFieldOffsetY;
         for(var i:int = 0; i < this.ballViews.length; i++)
         {
            bv = this.ballViews[i];
            bv.resize(this.playFieldWidth);
         }
      }
   }
}
