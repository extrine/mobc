package iilwy.display.shop
{
   import flash.display.Sprite;
   import iilwy.model.dataobjects.shop.enum.CurrencyType;
   import iilwy.ui.containers.UiContainer;
   import iilwy.ui.controls.Label;
   import iilwy.ui.controls.UiElement;
   import iilwy.ui.utils.ControlAlign;
   import iilwy.utils.CurrencyUtil;
   import iilwy.utils.TextUtil;
   
   public class PriceIndicator extends UiContainer
   {
      
      public static const TYPE_PRICE:String = "price";
      
      public static const TYPE_BALANCE:String = "balance";
       
      
      protected var iconHolder:UiElement;
      
      protected var icon:Sprite;
      
      protected var currencyTypeValid:Boolean;
      
      protected var _label:Label;
      
      protected var _header:Label;
      
      protected var _amountType:String = "price";
      
      protected var _amount:Number = 0;
      
      protected var _showHeader:Boolean;
      
      protected var _currencyType:CurrencyType;
      
      protected var _iconSize:Number = 10;
      
      protected var _iconAlign:String;
      
      protected var _iconPadding:Number = 3;
      
      protected var _prefix:String;
      
      protected var _suffix:String;
      
      public function PriceIndicator()
      {
         this._currencyType = CurrencyType.SOFT;
         this._iconAlign = ControlAlign.RIGHT;
         super();
         setStyleById("p");
         this._label = new Label();
         this._header = new Label();
         mouseChildren = false;
      }
      
      override public function createChildren() : void
      {
         addContentChild(this._header);
         addContentChild(this._label);
         this.iconHolder = new UiElement();
         this.iconHolder.width = this._iconSize;
         this.iconHolder.height = this._iconSize;
         addContentChild(this.iconHolder);
      }
      
      override public function commitProperties() : void
      {
         var str:String = "";
         this._header.setStyleById(styleID);
         this._label.setStyleById(styleID);
         if(this._currencyType && !this.currencyTypeValid)
         {
            if(this.icon)
            {
               this.iconHolder.removeChild(this.icon);
            }
            this.icon = CurrencyUtil.getIcon(this._currencyType,this._iconSize,false);
            this.iconHolder.addChild(this.icon);
            this._header.text = this._currencyType.titlePlural.toUpperCase() + ":";
            this.currencyTypeValid = true;
         }
         if(this._prefix)
         {
            str = str + this._prefix;
         }
         if(this._amount < 0)
         {
            str = str + "--";
         }
         else if(this._amount == 0 && this._amountType == TYPE_PRICE)
         {
            str = str + "FREE";
         }
         else
         {
            str = str + TextUtil.commaFormatNumber(this._amount);
         }
         if(this._suffix)
         {
            str = str + this._suffix;
         }
         this._header.visible = this._header.includeInLayout = this._showHeader;
         this._label.text = str;
      }
      
      override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var y:Number = NaN;
         var h:Number = NaN;
         var xPos:Number = NaN;
         this._label.setStyleById(styleID);
         if(this._showHeader)
         {
            this._header.setStyleById(styleID);
            y = this._header.height + this._header.margin.bottom;
            h = unscaledHeight - y;
            xPos = padding.left;
            this._header.x = xPos;
            xPos = xPos + (this._header.width + this._iconPadding);
            this._label.x = xPos;
            xPos = xPos + (this._label.width + this._iconPadding);
            this.iconHolder.x = xPos;
         }
         else if(this._iconAlign == ControlAlign.RIGHT)
         {
            this._label.x = unscaledWidth - this._label.width;
            this.iconHolder.x = this._label.width + this._iconPadding;
            this._label.x = 0;
         }
         else
         {
            this._header.x = padding.left;
            this.iconHolder.x = 0;
            this._label.x = this.iconHolder.width + this._iconPadding;
         }
         this.iconHolder.y = Math.round(unscaledHeight / 2 - this.iconHolder.height / 2);
      }
      
      override public function measure() : void
      {
         var w:Number = padding.left;
         if(this._showHeader)
         {
            w = w + (this._header.width + this._iconPadding);
         }
         w = w + (this._label.width + this._iconPadding + this._iconSize + padding.right);
         measuredWidth = w;
         measuredHeight = this._label.height;
      }
      
      public function get label() : Label
      {
         return this._label;
      }
      
      public function get header() : Label
      {
         return this._header;
      }
      
      public function get amountType() : String
      {
         return this._amountType;
      }
      
      public function set amountType(value:String) : void
      {
         this._amountType = value;
         invalidateProperties();
      }
      
      public function get amount() : Number
      {
         return this._amount;
      }
      
      public function set amount(value:Number) : void
      {
         this._amount = value;
         invalidateProperties();
         invalidateSize();
         invalidateDisplayList();
      }
      
      public function get showHeader() : Boolean
      {
         return this._showHeader;
      }
      
      public function set showHeader(value:Boolean) : void
      {
         this._showHeader = value;
         invalidateProperties();
         invalidateSize();
         invalidateDisplayList();
      }
      
      public function get currencyType() : CurrencyType
      {
         return this._currencyType;
      }
      
      public function set currencyType(value:CurrencyType) : void
      {
         this.currencyTypeValid = false;
         this._currencyType = value;
         invalidateProperties();
      }
      
      public function get iconSize() : Number
      {
         return this._iconSize;
      }
      
      public function set iconSize(value:Number) : void
      {
         this._iconSize = value;
         invalidateProperties();
         invalidateSize();
      }
      
      public function get iconAlign() : String
      {
         return this._iconAlign;
      }
      
      public function set iconAlign(value:String) : void
      {
         this._iconAlign = value;
         invalidateDisplayList();
      }
      
      public function get iconPadding() : Number
      {
         return this._iconPadding;
      }
      
      public function set iconPadding(value:Number) : void
      {
         this._iconPadding = value;
         invalidateSize();
         invalidateDisplayList();
      }
      
      public function get prefix() : String
      {
         return this._prefix;
      }
      
      public function set prefix(value:String) : void
      {
         this._prefix = value;
         invalidateProperties();
      }
      
      public function get suffix() : String
      {
         return this._suffix;
      }
      
      public function set suffix(value:String) : void
      {
         this._suffix = value;
         invalidateProperties();
      }
   }
}
