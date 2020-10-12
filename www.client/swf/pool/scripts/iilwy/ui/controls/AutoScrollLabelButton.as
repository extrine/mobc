package iilwy.ui.controls
{
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import iilwy.ui.themes.Style;
   import iilwy.ui.utils.ControlState;
   import iilwy.ui.utils.Margin;
   import iilwy.utils.GraphicUtil;
   
   public class AutoScrollLabelButton extends SimpleButton
   {
       
      
      private var scrollLabel:AutoScrollLabel;
      
      private var clippedLabel:Label;
      
      private var labelText:String;
      
      public function AutoScrollLabelButton(label:String = null, x:Number = 0, y:Number = 0, width:Number = undefined, height:Number = 16, styleID:String = "simpleButton")
      {
         super("",x,y,width,height,styleID);
         this.labelText = label;
         this.scrollLabel = new AutoScrollLabel(label,0,0,width,styleID);
         this.scrollLabel.visible = false;
         addChild(this.scrollLabel);
         this.clippedLabel = new Label(label,0,0,styleID);
         addChild(this.clippedLabel);
      }
      
      override public function get label() : String
      {
         return this.labelText;
      }
      
      override public function set label(value:String) : void
      {
         this.labelText = value;
         invalidateSize();
         invalidateDisplayList();
      }
      
      override public function setStyleById(styleID:String) : void
      {
         super.setStyleById(styleID);
         if(this.scrollLabel)
         {
            this.scrollLabel.setStyleById(styleID);
         }
         if(this.clippedLabel)
         {
            this.clippedLabel.setStyleById(styleID);
         }
      }
      
      override protected function updateState(state:String) : void
      {
         super.updateState(state);
         if(!this.scrollLabel || !this.clippedLabel)
         {
            return;
         }
         this.scrollLabel.text = this.label;
         if(state == ControlState.OVER)
         {
            this.clippedLabel.visible = false;
            this.scrollLabel.visible = true;
         }
         else if(state == ControlState.DEFAULT)
         {
            this.scrollLabel.visible = false;
            this.clippedLabel.visible = true;
         }
      }
      
      override protected function getSkinStateLabelField(style:Style, textConstraint:Rectangle, padding:Margin) : TextField
      {
         var field:TextField = super.getSkinStateLabelField(style,textConstraint,padding);
         field.visible = false;
         this.scrollLabel.text = this.label;
         this.clippedLabel.text = this.label;
         var h:Number = field.height;
         this.scrollLabel.width = textConstraint.width;
         this.clippedLabel.width = textConstraint.width;
         var fmt:TextFormat = style.textFormat;
         var align:String = fmt.align;
         if(_fontAlign)
         {
            align = _fontAlign;
         }
         if(align == TextFormatAlign.CENTER)
         {
            GraphicUtil.centerInto(this.scrollLabel,textConstraint.x,0,textConstraint.width,height);
            GraphicUtil.centerInto(this.clippedLabel,textConstraint.x,0,textConstraint.width,height);
         }
         else
         {
            this.scrollLabel.x = textConstraint.x;
            this.clippedLabel.x = textConstraint.x;
         }
         this.scrollLabel.y = Math.ceil((height - h) / 2);
         this.clippedLabel.y = Math.ceil((height - h) / 2);
         var clipIndex:int = this.scrollLabel.label.field.getCharIndexAtPoint(this.scrollLabel.width,this.scrollLabel.height / 2);
         if(clipIndex != -1)
         {
            this.clippedLabel.text = this.scrollLabel.text.slice(0,clipIndex) + "...";
         }
         return field;
      }
      
      override protected function applySubStyle(... options) : void
      {
         super.applySubStyle.apply(this,options);
         var len:int = options.length;
         for(var i:int = 0; i < len; i++)
         {
            if(options[i] != null)
            {
               this.scrollLabel.label.style = options[i];
               break;
            }
         }
      }
      
      override protected function onMouseEvent(event:MouseEvent) : void
      {
         super.onMouseEvent(event);
         if(event.type == MouseEvent.MOUSE_OVER)
         {
            this.scrollLabel.onRollOver(event);
         }
         else if(event.type == MouseEvent.MOUSE_OUT)
         {
            this.scrollLabel.onRollOut(event);
         }
      }
   }
}
