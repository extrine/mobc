package iilwy.model.dataobjects.promo.enum.popup
{
   import iilwy.model.dataobjects.promo.enum.ImageDefinition;
   import iilwy.ui.containers.ListDirection;
   import iilwy.ui.utils.ControlAlign;
   
   public class PopupViewDefinition
   {
       
      
      public var id:String;
      
      public var image:ImageDefinition;
      
      public var overlayImage:ImageDefinition;
      
      public var buttonXPos:int;
      
      public var buttonYPos:int;
      
      public var buttonSize:int;
      
      public var buttonAlign:String;
      
      public var buttonDirection:String;
      
      public var buttonStyleId:String;
      
      public var buttonColor:uint;
      
      public var buttons:Array;
      
      public var closable:Boolean;
      
      public var trackingPixel:String;
      
      public function PopupViewDefinition(id:String, image:ImageDefinition = null, overlayImage:ImageDefinition = null, buttonXPos:int = 0, buttonYPos:int = 0, buttonSize:int = 40, buttonAlign:String = null, buttonDirection:String = null, buttonStyleId:String = null, buttonColor:uint = 0.0, buttons:Array = null, closable:Boolean = true, trackingPixel:String = null)
      {
         super();
         if(!buttonAlign)
         {
            buttonAlign = ControlAlign.LEFT;
         }
         if(!buttonDirection)
         {
            buttonDirection = ListDirection.HORIZONTAL;
         }
         this.id = id;
         this.image = image;
         this.overlayImage = overlayImage;
         this.buttonXPos = buttonXPos;
         this.buttonYPos = buttonYPos;
         this.buttonSize = buttonSize;
         this.buttonAlign = buttonAlign;
         this.buttonDirection = buttonDirection;
         this.buttonStyleId = buttonStyleId;
         this.buttonColor = buttonColor;
         this.buttons = buttons;
         this.closable = closable;
         this.trackingPixel = trackingPixel;
      }
      
      public function get viewData() : Object
      {
         return {
            "image":this.image,
            "overlayImage":this.overlayImage,
            "buttonXPos":this.buttonXPos,
            "buttonYPos":this.buttonYPos,
            "buttonSize":this.buttonSize,
            "buttonAlign":this.buttonAlign,
            "buttonDirection":this.buttonDirection,
            "buttonStyleId":this.buttonStyleId,
            "buttonColor":this.buttonColor,
            "buttons":this.buttons,
            "closable":this.closable,
            "trackingPixel":this.trackingPixel
         };
      }
      
      public function getButtonById(id:String) : ButtonDefinition
      {
         var button:ButtonDefinition = null;
         for each(button in this.buttons)
         {
            if(button.id == id)
            {
               return button;
            }
         }
         return null;
      }
   }
}
