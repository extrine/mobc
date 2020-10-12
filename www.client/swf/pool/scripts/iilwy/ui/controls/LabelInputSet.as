package iilwy.ui.controls
{
   import flash.geom.Rectangle;
   import iilwy.ui.containers.UiContainer;
   import iilwy.ui.utils.ControlAlign;
   import iilwy.utils.GraphicUtil;
   import iilwy.utils.UiRender;
   
   public class LabelInputSet extends UiContainer
   {
       
      
      public var labelAlign:String;
      
      public var label:Label;
      
      public var input:TextInput;
      
      private var _cornerRadius:Number;
      
      public function LabelInputSet(labelText:String, labelAlign:String = "alignTop", labelStyleId:String = "p", inputStyleId:String = "textInput")
      {
         super();
         this.labelAlign = labelAlign;
         this.label = new Label(labelText,0,0,labelStyleId);
         this.label.setMargin(0,20,0,0);
         this.input = new TextInput(0,0,200,30,inputStyleId);
         addContainerBackground();
      }
      
      override protected function drawBackground() : void
      {
         var bgColor:Number = getValidValue(backgroundColor,style.backgroundColor,33554431);
         var cRad:Number = getValidValue(this._cornerRadius,style.cornerRadius,0);
         containerBackground.graphics.clear();
         UiRender.renderRoundRect(containerBackground,bgColor,0,0,100,100,cRad);
         if(cRad > 0)
         {
            containerBackground.scale9Grid = new Rectangle(cRad / 2,cRad / 2,100 - cRad,100 - cRad);
         }
      }
      
      override public function createChildren() : void
      {
         addContentChild(this.input);
         addContentChild(this.label);
      }
      
      override public function measure() : void
      {
         if(this.labelAlign == ControlAlign.LEFT)
         {
            measuredWidth = this.label.width + this.input.width + this.horizontalExtraSum;
            measuredHeight = this.input.height + padding.top + padding.bottom;
         }
      }
      
      override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         if(this.labelAlign == ControlAlign.LEFT)
         {
            GraphicUtil.centerTextInto(this.label,0,0,10,unscaledHeight);
            this.label.x = padding.left + this.label.margin.left;
            this.input.x = this.label.x + this.label.width + this.label.margin.right + this.input.margin.left;
            this.input.y = padding.top;
            if(!isNaN(explicitWidth))
            {
               this.input.width = Math.round(unscaledWidth - this.label.width - this.horizontalExtraSum);
            }
            if(!isNaN(explicitHeight))
            {
               this.input.height = Math.round(unscaledHeight - padding.top - padding.bottom);
            }
         }
      }
      
      private function get horizontalExtraSum() : Number
      {
         return padding.left + this.label.margin.left + this.label.margin.right + this.input.margin.left + this.input.margin.right + padding.right;
      }
      
      public function get cornerRadius() : Number
      {
         return this._cornerRadius;
      }
      
      public function set cornerRadius(n:Number) : void
      {
         this._cornerRadius = n;
         invalidateDisplayList();
      }
   }
}
