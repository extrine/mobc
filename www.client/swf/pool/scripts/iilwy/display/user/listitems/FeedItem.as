package iilwy.display.user.listitems
{
   import flash.events.MouseEvent;
   import iilwy.application.AppComponents;
   import iilwy.display.drawing.model.DrawingFileData;
   import iilwy.events.ApplicationEvent;
   import iilwy.events.UserRequestEvent;
   import iilwy.managers.GraphicManager;
   import iilwy.model.dataobjects.DrawingData;
   import iilwy.model.dataobjects.MediaItemData;
   import iilwy.model.dataobjects.ProfileData;
   import iilwy.model.dataobjects.shop.CatalogProductBase;
   import iilwy.model.dataobjects.user.FeedData;
   import iilwy.net.MediaProxy;
   import iilwy.ui.containers.List;
   import iilwy.ui.containers.ListDirection;
   import iilwy.ui.containers.UiContainer;
   import iilwy.ui.controls.Divider;
   import iilwy.ui.controls.IconButton;
   import iilwy.ui.controls.ImageButton;
   import iilwy.ui.controls.Label;
   import iilwy.ui.controls.TextBlock;
   import iilwy.ui.controls.Thumbnail;
   import iilwy.ui.controls.UiElement;
   import iilwy.ui.events.ButtonEvent;
   import iilwy.ui.utils.ControlAlign;
   import iilwy.utils.ItemFactory;
   import iilwy.utils.TimeUtil;
   
   public class FeedItem extends UiContainer implements IFeedListItem
   {
       
      
      protected var thumb:Thumbnail;
      
      protected var subjectBlock:TextBlock;
      
      protected var bodyBlock:TextBlock;
      
      protected var divider:Divider;
      
      protected var extraImageList:List;
      
      protected var extraImageFactory:ItemFactory;
      
      protected var _data:FeedData;
      
      protected var _useDivider:Boolean = true;
      
      protected var _deleteButton:IconButton;
      
      protected var _editable:Boolean = false;
      
      protected var timeStampLabel:Label;
      
      public function FeedItem()
      {
         super();
         setPadding(10,0);
         this.width = 500;
      }
      
      override public function createChildren() : void
      {
         this.thumb = new Thumbnail(0,0,40);
         this.thumb.deferredLoad = true;
         addContentChild(this.thumb);
         this.thumb.addEventListener(MouseEvent.MOUSE_DOWN,this.onThumbMouseDown);
         this.subjectBlock = new TextBlock();
         this.subjectBlock.setStyleById("cssBlock");
         this.subjectBlock.margin.bottom = -2;
         addContentChild(this.subjectBlock);
         this.bodyBlock = new TextBlock();
         this.bodyBlock.setStyleById("cssBlock");
         this.bodyBlock.width = getExplicitOrMeasuredWidth();
         addContentChild(this.bodyBlock);
         this._deleteButton = new IconButton(GraphicManager.iconX1,0,0,16,16,"iconButtonReverse");
         addContentChild(this._deleteButton);
         this._deleteButton.addEventListener(ButtonEvent.CLICK,this.onDeleteClick);
         this.extraImageList = new List(0,0,ListDirection.HORIZONTAL);
         this.extraImageList.setMargin(10,0,0,0);
         addContentChild(this.extraImageList);
         this.extraImageList.addEventListener(ButtonEvent.CLICK,this.onExtraImageClick);
         this.timeStampLabel = new Label("timestamp");
         this.extraImageFactory = new ItemFactory(ImageButton);
         this.divider = new Divider();
         addContentChild(this.divider);
      }
      
      override public function commitProperties() : void
      {
         var displayTimeStamp:Boolean = false;
         var str:String = null;
         var tsString:String = null;
         var imgdata:* = undefined;
         var imgButton:ImageButton = null;
         this.thumb.visible = false;
         this.bodyBlock.visible = false;
         this.bodyBlock.includeInLayout = false;
         this.subjectBlock.visible = false;
         this.subjectBlock.includeInLayout = false;
         this.thumb.mouseEnabled = false;
         this.thumb.buttonMode = false;
         this.extraImageFactory.recyleItems(this.extraImageList.clearContentChildren(false));
         this.extraImageList.includeInLayout = false;
         this._deleteButton.visible = false;
         if(this._data)
         {
            if(this._data.primaryImageURL)
            {
               this.thumb.url = MediaProxy.url(this._data.primaryImageURL,MediaProxy.SIZE_MEDIUM_THUMB);
               this.thumb.visible = true;
               this.thumb.borderSize = 0;
               this.thumb.borderColor = 33554431;
               this.thumb.borderColor = 33554431;
               this.thumb.setStyleById("thumbnail");
            }
            else if(this._data.icon)
            {
               this.thumb.url = this._data.icon;
               this.thumb.borderSize = 0;
               this.thumb.visible = true;
               this.thumb.setStyleById("clearImage");
            }
            if(this._data.subject)
            {
               this.subjectBlock.visible = true;
               this.subjectBlock.includeInLayout = true;
               this.subjectBlock.htmlText = "<body><strong>" + this._data.subject + "</strong></body>";
            }
            displayTimeStamp = this.shouldDisplayTimeStamp(this._data);
            if(this._data.body || displayTimeStamp)
            {
               this.bodyBlock.visible = true;
               this.bodyBlock.includeInLayout = true;
               str = Boolean(this._data.body)?AppComponents.textOffendCheck.screenOffensive(this._data.body):"";
               if(this.shouldDisplayTimeStamp(this._data))
               {
                  tsString = TimeUtil.timeLeftInWords(this._data.timeStamp);
                  tsString = tsString.replace(/\s/gi,"&nbsp;");
                  str = str + (str != ""?" ":"");
                  str = str + ("<span class=\'timeStamp\'>" + tsString + "&nbsp;ago" + "</span>");
               }
               this.bodyBlock.htmlText = "<body>" + str + "</body>";
            }
            if(this._data.extraImages)
            {
               this.extraImageList.includeInLayout = true;
               for each(imgdata in this._data.extraImages)
               {
                  imgButton = this.extraImageFactory.createItem();
                  imgButton.width = 80;
                  imgButton.height = this._data.type == "blog_post" || this._data.type == "blog_comment"?Number(80):Number(50);
                  imgButton.url = imgdata.url;
                  this.extraImageList.addContentChild(imgButton);
               }
            }
            if(this._editable)
            {
               this._deleteButton.visible = true;
            }
            if(this._data.primaryImageData && (this._data.primaryImageData is ProfileData || this._data.primaryImageData is CatalogProductBase))
            {
               this.thumb.mouseEnabled = true;
               this.thumb.buttonMode = true;
            }
         }
      }
      
      protected function calculateItemHeight() : int
      {
         var h:int = 0;
         h = h + (!!this.subjectBlock.includeInLayout?this.subjectBlock.height + this.subjectBlock.margin.vertical:0);
         h = h + (!!this.bodyBlock.includeInLayout?this.bodyBlock.height + this.bodyBlock.margin.vertical:0);
         h = h + (!!this.extraImageList.includeInLayout?this.extraImageList.height + this.extraImageList.margin.vertical:0);
         return h;
      }
      
      override public function measure() : void
      {
         var itemHeight:int = this.calculateItemHeight();
         measuredHeight = Math.max(this.thumb.height,itemHeight) + padding.top + padding.bottom;
      }
      
      override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         var iWidth:Number = calculateInnerWidth(unscaledWidth);
         var spacer:int = 5;
         var xPos:Number = padding.left;
         if(this.thumb.visible)
         {
            this.thumb.y = padding.top;
            this.thumb.x = xPos;
            xPos = xPos + (this.thumb.width + 5);
         }
         this._deleteButton.x = unscaledWidth - this._deleteButton.width;
         this._deleteButton.y = 3;
         this.timeStampLabel.y = padding.top;
         this.timeStampLabel.x = unscaledWidth - this.timeStampLabel.width;
         if(this._deleteButton.visible)
         {
            this.timeStampLabel.x = this.timeStampLabel.x - (this._deleteButton.width - 5);
         }
         var w:Number = iWidth - xPos;
         this.subjectBlock.width = w;
         this.bodyBlock.width = w;
         this.divider.width = unscaledWidth;
         this.divider.y = unscaledHeight;
         var itemHeight:int = this.calculateItemHeight();
         var yPos:int = padding.top;
         if(itemHeight < this.thumb.height)
         {
            yPos = this.thumb.y + this.thumb.height / 2 - itemHeight / 2;
         }
         if(this.subjectBlock.includeInLayout)
         {
            this.subjectBlock.y = yPos;
            this.subjectBlock.x = xPos;
            yPos = yPos + (this.subjectBlock.height + this.subjectBlock.margin.bottom);
         }
         if(this.bodyBlock.includeInLayout)
         {
            yPos = yPos + this.bodyBlock.margin.top;
            this.bodyBlock.y = yPos;
            this.bodyBlock.x = xPos;
            yPos = yPos + (this.bodyBlock.height - this.bodyBlock.margin.bottom);
         }
         if(this.extraImageList.includeInLayout)
         {
            yPos = yPos + this.extraImageList.margin.top;
            this.extraImageList.x = xPos;
            this.extraImageList.y = yPos;
         }
      }
      
      public function set data(value:FeedData) : void
      {
         this._data = value;
         this._editable = false;
         invalidateProperties();
         invalidateSize();
         invalidateDisplayList();
      }
      
      public function set useDivider(value:Boolean) : void
      {
         this._useDivider = value;
         invalidateDisplayList();
      }
      
      public function set editable(value:Boolean) : void
      {
         this._editable = value;
         invalidateDisplayList();
         invalidateProperties();
         invalidateSize();
      }
      
      public function set selected(b:Boolean) : void
      {
      }
      
      public function asUiElement() : UiElement
      {
         return this;
      }
      
      protected function onThumbMouseDown(event:MouseEvent) : void
      {
         if(this._data && this._data.primaryImageData)
         {
            if(this._data.primaryImageData is ProfileData)
            {
               AppComponents.contextMenuManager.showProfileContextMenu(this._data.primaryImageData,this.thumb,ControlAlign.LEFT);
            }
            if(this._data.primaryImageData is CatalogProductBase)
            {
               AppComponents.contextMenuManager.showClickShopContextMenu(this._data.primaryImageData,null,this.thumb,ControlAlign.LEFT);
            }
         }
      }
      
      protected function onExtraImageClick(event:ButtonEvent) : void
      {
         var data:* = undefined;
         var appEvent:ApplicationEvent = null;
         var drawingFileData:DrawingFileData = null;
         var index:int = this.extraImageList.content.getChildIndex(event.button);
         if(index >= 0)
         {
            data = this._data.extraImages[index];
            if(data is DrawingData)
            {
               appEvent = new ApplicationEvent(ApplicationEvent.OPEN_DRAWING_LIGHTBOX);
               drawingFileData = new DrawingFileData();
               drawingFileData.drawing_filename = data.url;
               appEvent.drawingFileData = drawingFileData;
               dispatchEvent(appEvent);
            }
            else if(data is MediaItemData)
            {
               if(data.clickURL)
               {
                  appEvent = new ApplicationEvent(ApplicationEvent.NAVIGATE_TO_URL,data.clickURL);
                  dispatchEvent(appEvent);
               }
            }
         }
      }
      
      protected function onDeleteClick(event:ButtonEvent) : void
      {
         var evt:UserRequestEvent = new UserRequestEvent(UserRequestEvent.DELETE_FEED_REQUEST,true);
         evt.feedData = this._data;
         dispatchEvent(evt);
      }
      
      override public function set width(n:Number) : void
      {
         var x:Number = NaN;
         var iWidth:Number = NaN;
         var w:Number = NaN;
         super.width = n;
         if(childrenCreated)
         {
            x = padding.left;
            iWidth = calculateInnerWidth(n);
            if(this.thumb.visible)
            {
               x = x + (this.thumb.width + 5);
            }
            w = iWidth - x;
            this.subjectBlock.width = w;
            this.bodyBlock.width = w;
         }
      }
      
      protected function shouldDisplayTimeStamp(data:FeedData) : Boolean
      {
         var result:Boolean = false;
         if(data.type == "wall_item" || data.type == "blog_comment" || data.type == "blog_post")
         {
            result = true;
         }
         return result;
      }
   }
}
