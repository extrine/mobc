package iilwygames.ui.partials
{
   import flash.display.GradientType;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.filters.DropShadowFilter;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   import iilwy.gamenet.developer.RoundResults;
   import iilwy.ui.containers.List;
   import iilwy.ui.containers.UiContainer;
   import iilwy.ui.controls.Divider;
   import iilwy.ui.controls.Label;
   import iilwy.utils.GraphicUtil;
   import iilwy.utils.ItemFactory;
   import iilwy.utils.UiRender;
   
   public class GameOverPopup extends UiContainer
   {
       
      
      protected var _data:RoundResults;
      
      protected var _header:Label;
      
      protected var _list:List;
      
      protected var _itemFactory:ItemFactory;
      
      private var _background:Sprite;
      
      private var _bottomDivider:Divider;
      
      public var isWinner:Boolean = false;
      
      public function GameOverPopup()
      {
         super();
         backgroundColor = 2868903935;
         this._background = new Sprite();
         addContentChild(this._background);
         UiRender.renderRoundRect(this._background,backgroundColor,0,0,100,100,30);
         var alpha:Number = GraphicUtil.getAlpha(backgroundColor);
         var matr:Matrix = new Matrix();
         matr.createGradientBox(100,100,Math.PI / 2,0,0);
         this._background.graphics.beginGradientFill(GradientType.LINEAR,[backgroundColor,backgroundColor],[alpha * 1.2,0],[0,255],matr);
         this._background.graphics.drawRoundRect(6,6,88,88,20,20);
         this._background.scale9Grid = new Rectangle(20,20,60,60);
         addContentChild(this._background);
         this._header = new Label("GAME OVER",0,0,"strong");
         setPadding(20,30,30,30);
         width = 320;
         filters = [new DropShadowFilter(4,90,0,0.5,15,15,1,1,false,false,false)];
         this._itemFactory = new ItemFactory(GameOverItem);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
      }
      
      protected function onRemovedFromStage(event:Event) : void
      {
         this._header.text = "GAME OVER";
      }
      
      public function set title(s:String) : void
      {
         this._header.text = s;
      }
      
      override public function createChildren() : void
      {
         this._header.fontSize = 20;
         this._header.alpha = 0.4;
         addContentChild(this._header);
         this._list = new List();
         this._list.itemPadding = 0;
         addContentChild(this._list);
         this._bottomDivider = new Divider();
      }
      
      override public function destroy() : void
      {
         this._data = null;
         this._itemFactory.destroy();
         super.destroy();
      }
      
      override public function measure() : void
      {
         if(this._data)
         {
            measuredHeight = 60 * this._data.list.length + this._header.height + 20 + padding.vertical;
         }
         else
         {
            measuredHeight = 200;
         }
      }
      
      override public function commitProperties() : void
      {
         var child:Array = null;
         var i:int = 0;
         var item:GameOverItem = null;
         if(this._data)
         {
            this._list.removeContentChild(this._bottomDivider);
            child = this._list.clearContentChildren(false);
            this._itemFactory.recyleItems(child);
            for(i = 0; i < this._data.list.length; i++)
            {
               item = this._itemFactory.createItem();
               item.data = this._data.list[i].player;
               item.rank = i + 1;
               item.width = 320 - padding.horizontal;
               this._list.addContentChild(item);
            }
            this._bottomDivider.width = 320 - padding.horizontal;
            this._list.addContentChild(this._bottomDivider);
         }
      }
      
      override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         this._background.width = unscaledWidth;
         this._background.height = unscaledHeight;
         this._header.x = Math.floor((unscaledWidth - this._header.width) / 2);
         this._header.y = padding.top;
         this._list.y = this._header.y + this._header.height + 20;
         this._list.x = padding.left;
      }
      
      public function set data(d:RoundResults) : void
      {
         this._data = d;
         invalidateDisplayList();
         invalidateSize();
         invalidateProperties();
      }
   }
}

import iilwy.display.thumbnails.PlayerThumbnail;
import iilwy.gamenet.model.PlayerData;
import iilwy.ui.containers.UiContainer;
import iilwy.ui.controls.AutoScrollLabelMultiple;
import iilwy.ui.controls.Divider;

class GameOverItem extends UiContainer
{
    
   
   private var _divider:Divider;
   
   private var _thumbnail:PlayerThumbnail;
   
   private var _labels:AutoScrollLabelMultiple;
   
   private var _data:PlayerData;
   
   private var _rank:int;
   
   function GameOverItem()
   {
      super();
      height = 60;
   }
   
   override public function destroy() : void
   {
      this._data = null;
      super.destroy();
   }
   
   override public function createChildren() : void
   {
      this._divider = new Divider(0,0,100,1);
      addContentChild(this._divider);
      this._thumbnail = new PlayerThumbnail(0,10);
      addContentChild(this._thumbnail);
      this._labels = new AutoScrollLabelMultiple(2);
      this._labels.getLabelAt(0).setStyleById("strong");
      addContentChild(this._labels);
      this._labels.y = 8;
      this._labels.x = 50;
   }
   
   override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
   {
      super.updateDisplayList(unscaledWidth,unscaledHeight);
      this._divider.width = unscaledWidth;
      this._labels.width = unscaledWidth - this._labels.x;
   }
   
   override public function commitProperties() : void
   {
      this._thumbnail.playerData = this._data;
      this._labels.getLabelAt(0).text = this._rank.toString() + " // " + this._data.profileName;
      this._labels.getLabelAt(1).text = this._data.getInGameAboutString();
      if(this._rank == 1)
      {
         this._labels.getLabelAt(0).label.fontSize = 20;
         this._labels.getLabelAt(0).idleScroll = true;
         this._labels.getLabelAt(1).idleScroll = true;
         this._labels.getLabelAt(0).reset();
         this._labels.getLabelAt(1).reset();
      }
      else
      {
         this._labels.getLabelAt(0).label.fontSize = 12;
         this._labels.getLabelAt(0).idleScroll = false;
         this._labels.getLabelAt(1).idleScroll = false;
      }
   }
   
   public function set data(d:PlayerData) : void
   {
      this._data = d;
      invalidateProperties();
      invalidateDisplayList();
   }
   
   public function set rank(i:int) : void
   {
      this._rank = i;
      invalidateProperties();
      invalidateDisplayList();
   }
}
