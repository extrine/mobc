package iilwy.ui.containers
{
   import caurina.transitions.Tweener;
   import flash.utils.Dictionary;
   import iilwy.ui.controls.UiElement;
   
   public class ViewStack extends UiContainer
   {
       
      
      protected var items:Array;
      
      protected var itemIDs:Dictionary;
      
      protected var itemElements:Dictionary;
      
      protected var selectionValid:Boolean = true;
      
      protected var previousSelectedElement:UiElement;
      
      protected var _selectedIndex:int = -1;
      
      protected var _selectedID:String;
      
      protected var _selectedElement:UiElement;
      
      protected var _scaleContent:Boolean = false;
      
      protected var _fadeTransition:Boolean = false;
      
      protected var _pendingSelectedElement:UiElement;
      
      public function ViewStack()
      {
         this.items = new Array();
         this.itemIDs = new Dictionary();
         this.itemElements = new Dictionary();
         super();
      }
      
      public function get selectedIndex() : int
      {
         return this._selectedIndex;
      }
      
      public function set selectedIndex(value:int) : void
      {
         if(value == this._selectedIndex)
         {
            return;
         }
         this._selectedID = Boolean(this.items[value])?this.items[value]:null;
         this._selectedIndex = Boolean(this._selectedID)?int(value):int(-1);
         this._pendingSelectedElement = Boolean(this._selectedID)?this.itemIDs[this._selectedID]:null;
         this.selectionValid = false;
         invalidateProperties();
         invalidateDisplayList();
      }
      
      public function get selectedID() : String
      {
         return this._selectedID;
      }
      
      public function set selectedID(value:String) : void
      {
         if(value == this._selectedID)
         {
            return;
         }
         this._selectedID = value;
         this._pendingSelectedElement = Boolean(this._selectedID)?this.itemIDs[this._selectedID]:null;
         this._selectedIndex = Boolean(this._selectedID)?int(this.items.indexOf(this._selectedID)):int(-1);
         this.selectionValid = false;
         invalidateProperties();
         invalidateDisplayList();
      }
      
      public function get selectedElement() : UiElement
      {
         return this._selectedElement;
      }
      
      public function set selectedElement(value:UiElement) : void
      {
         if(this._selectedElement && value.name == this._selectedElement.name)
         {
            return;
         }
         this._selectedID = value && this.itemElements[value.name]?this.itemElements[value.name]:null;
         this._pendingSelectedElement = Boolean(this._selectedID)?value:null;
         this._selectedIndex = Boolean(this._selectedID)?int(this.items.indexOf(this._selectedID)):int(-1);
         this.selectionValid = false;
         invalidateProperties();
         invalidateDisplayList();
      }
      
      public function get scaleContent() : Boolean
      {
         return this._scaleContent;
      }
      
      public function set scaleContent(value:Boolean) : void
      {
         this._scaleContent = value;
      }
      
      public function get fadeTransition() : Boolean
      {
         return this._fadeTransition;
      }
      
      public function set fadeTransition(value:Boolean) : void
      {
         this._fadeTransition = value;
      }
      
      public function addItem(id:String, element:UiElement) : void
      {
         this.items.push(id);
         this.itemIDs[id] = element;
         this.itemElements[element.name] = id;
         invalidateProperties();
         invalidateDisplayList();
      }
      
      public function getItemByID(id:String) : UiElement
      {
         return this.itemIDs[id];
      }
      
      override public function commitProperties() : void
      {
         if(!this.selectionValid)
         {
            this.selectionValid = true;
            this.previousSelectedElement = this._selectedElement;
            if(this.previousSelectedElement)
            {
               Tweener.removeTweens(this.previousSelectedElement);
               this.previousSelectedElement.alpha = 1;
               removeContentChild(this.previousSelectedElement);
            }
            if(this._pendingSelectedElement)
            {
               addContentChild(this._pendingSelectedElement);
               if(this.fadeTransition)
               {
                  this._pendingSelectedElement.alpha = 0;
                  Tweener.addTween(this._pendingSelectedElement,{
                     "alpha":1,
                     "time":0.4,
                     "transition":"easeInOutCubic"
                  });
               }
               this._selectedElement = this._pendingSelectedElement;
            }
         }
      }
      
      override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         if(this.scaleContent)
         {
            if(this.selectedElement)
            {
               this.selectedElement.width = unscaledWidth;
               this.selectedElement.height = unscaledHeight;
            }
         }
      }
   }
}
