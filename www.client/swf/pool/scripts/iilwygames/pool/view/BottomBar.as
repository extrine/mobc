package iilwygames.pool.view
{
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import iilwy.display.arcade.ArcadePlayerThumbnail;
   import iilwy.gamenet.model.PlayerData;
   import iilwy.ui.controls.AutoScrollLabel;
   import iilwy.ui.controls.Image;
   import iilwy.ui.controls.Label;
   import iilwy.ui.events.UiEvent;
   import iilwygames.pool.core.Globals;
   import iilwygames.pool.model.Player;
   import iilwygames.pool.model.gameplay.Ball;
   import iilwygames.pool.model.gameplay.Ruleset.Ruleset;
   import iilwygames.pool.model.gameplay.Team;

   public class BottomBar extends Sprite
   {


      public var _width:Number;

      public var _height:Number;

      public var cueControl:CueControlView;

      private var background:Bitmap;

      private var teamThumbnailA:Array;

      private var teamThumbnailB:Array;

      private var autoScrollNames:Array;

      private var solidView:LabelView;

      private var stripeView:LabelView;

      private var nameLabels:Array;

      private var englishLabel:Label;

      private var ballsPocketed:Label;

      public function BottomBar()
      {
         super();
         this.teamThumbnailA = [];
         this.teamThumbnailB = [];
         this.autoScrollNames = [];
         this._width = 524;
         this._height = 70;
         this.background = new Bitmap();
         this.cueControl = new CueControlView();
         this.solidView = new LabelView();
         this.stripeView = new LabelView();
         this.englishLabel = new Label("ENGLISH");
         this.ballsPocketed = new Label("BALLS SUNK");
         this.solidView.display.text = "SOLIDS";
         this.stripeView.display.text = "STRIPES";
         this.solidView.visible = false;
         this.stripeView.visible = false;
         this.englishLabel.setStyleById("white");
         this.englishLabel.fontSize = 10;
         this.englishLabel.alpha = 0.5;
         this.ballsPocketed.setStyleById("white");
         this.ballsPocketed.fontSize = 10;
         this.ballsPocketed.alpha = 0.5;
         addChild(this.background);
         addChild(this.cueControl);
         addChild(this.solidView);
         addChild(this.stripeView);
         addChild(this.englishLabel);
         addChild(this.ballsPocketed);
      }

      public function stop() : void
      {
         var tn:ArcadePlayerThumbnail = null;
         var tnb:ArcadePlayerThumbnail = null;
         var asl:AutoScrollLabel = null;
         for each(tn in this.teamThumbnailA)
         {
            removeChild(tn);
            tn.removeEventListener(UiEvent.INVALIDATE_DISPLAYLIST,this.onImgInvalidate);
            tn.destroy();
         }
         for each(tnb in this.teamThumbnailB)
         {
            removeChild(tnb);
            tnb.removeEventListener(UiEvent.INVALIDATE_DISPLAYLIST,this.onImgInvalidate);
            tnb.destroy();
         }
         for each(asl in this.autoScrollNames)
         {
            removeChild(asl);
            asl.destroy();
         }
         this.teamThumbnailA.length = 0;
         this.teamThumbnailB.length = 0;
         this.autoScrollNames.length = 0;
      }

      public function destroy() : void
      {
         this.teamThumbnailA = null;
         this.teamThumbnailB = null;
         this.autoScrollNames = null;
         removeChild(this.solidView);
         removeChild(this.stripeView);
         removeChild(this.cueControl);
         removeChild(this.background);
         removeChild(this.englishLabel);
         removeChild(this.ballsPocketed);
         this.cueControl.destroy();
         this.solidView.destroy();
         this.stripeView.destroy();
         this.ballsPocketed.destroy();
         this.englishLabel.destroy();
         this.solidView = null;
         this.stripeView = null;
         this.cueControl = null;
         this.ballsPocketed = null;
         this.englishLabel = null;
      }

      public function setPlayers(players:Vector.<Player>) : void
      {
         var fp:Player = null;
         var thumbnail:ArcadePlayerThumbnail = null;
         var playerName:AutoScrollLabel = null;
         var startX:Number = 68;
         var startY:Number = 34;
         for each(fp in players)
         {
            thumbnail = new ArcadePlayerThumbnail();
            thumbnail.player = fp.playerData as PlayerData;
            thumbnail.useYouThumbnail = true;
            thumbnail.addEventListener(UiEvent.INVALIDATE_DISPLAYLIST,this.onImgInvalidate);
            if(fp.teamID == 0)
            {
               thumbnail.x = startX;
               thumbnail.y = startY;
               this.teamThumbnailA.push(thumbnail);
            }
            else
            {
               thumbnail.x = startX + (this._width - startX) * 0.5;
               thumbnail.y = startY;
               this.teamThumbnailB.push(thumbnail);
            }
            thumbnail.width = 32;
            thumbnail.height = 32;
            playerName = new AutoScrollLabel(fp.playerData.profileName);
            playerName.label.setStyleById("white");
            playerName.label.fontSize = 12;
            playerName.width = 128;
            this.autoScrollNames.push(playerName);
            playerName.x = thumbnail.x + thumbnail.width + 2;
            playerName.y = thumbnail.y;
            addChild(thumbnail);
            addChild(playerName);
         }
         this.solidView.visible = false;
         this.stripeView.visible = false;
      }

      public function setTeamType() : void
      {
         var rs:Ruleset = Globals.model.ruleset;
         var teamA:Team = rs.teams[0];
         var startX:Number = 68 + 32 + 2;
         var startY:Number = 35 + 16;
         var endX:Number = startX + (this._width - 68) * 0.5;
         if(teamA.teamBallType == Ball.BALL_SOLID)
         {
            this.solidView.x = startX;
            this.solidView.y = startY;
            this.stripeView.x = endX;
            this.stripeView.y = startY;
         }
         else
         {
            this.solidView.x = endX;
            this.solidView.y = startY;
            this.stripeView.x = startX;
            this.stripeView.y = startY;
         }
         this.stripeView.visible = true;
         this.solidView.visible = true;
      }

      public function update(et:Number) : void
      {
         if(Globals.model.ruleset.teamTurn == 0){
            this.autoScrollNames[0].label.fontColor =0xFF04ff0c
            this.autoScrollNames[0].label.fontThickness =400

            if( this.autoScrollNames[1]){
               this.autoScrollNames[1].label.fontColor = 0xFFa5a7ab
               this.autoScrollNames[1].label.fontThickness = 0
            }
         } else {
            this.autoScrollNames[0].label.fontColor = 0xFFa5a7ab
            this.autoScrollNames[0].label.fontThickness = 0
            if( this.autoScrollNames[1]){
               this.autoScrollNames[1].label.fontColor =0xFF04ff0c
               this.autoScrollNames[1].label.fontThickness =400
            }
         }
         this.cueControl.update();
      }

      public function resize(w:Number, h:Number) : void
      {
         this.resizeAssets();
         this.cueControl.resize(40,40);
         this.cueControl.x = 30;
         this.cueControl.y = 41;
         this.englishLabel.x = 6;
         this.englishLabel.y = 2;
         this.ballsPocketed.x = 65;
         this.ballsPocketed.y = 2;
      }

      public function resizeAssets() : void
      {
         this.background.bitmapData = Globals.resourceManager.getTexture("bottomBar");
         if(this.background.bitmapData)
         {
            this._width = this.background.width;
            this._height = this.background.height;
         }
         this.cueControl.resizeAssets();
         this.stripeView.addIcon(Globals.resourceManager.getTexture("stripe"));
         this.solidView.addIcon(Globals.resourceManager.getTexture("solid"));
      }

      protected function onImgInvalidate(event:UiEvent) : void
      {
         var img:Image = event.currentTarget as Image;
         img.cacheAsBitmap = true;
      }
   }
}
