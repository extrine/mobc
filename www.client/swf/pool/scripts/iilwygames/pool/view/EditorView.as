package iilwygames.pool.view
{
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.ui.Keyboard;
   import iilwy.managers.GraphicManager;
   import iilwy.ui.containers.Canvas;
   import iilwy.ui.containers.List;
   import iilwy.ui.containers.UiContainer;
   import iilwy.ui.controls.ComboBox;
   import iilwy.ui.controls.IconButton;
   import iilwy.ui.controls.Label;
   import iilwy.ui.controls.LabelSelector;
   import iilwy.ui.controls.SimpleButton;
   import iilwy.ui.controls.SimpleMenuDataProvider;
   import iilwy.ui.controls.TextInput;
   import iilwy.ui.events.ComboBoxEvent;
   import iilwygames.pool.core.Globals;
   import iilwygames.pool.model.gameplay.Ruleset.trickshots.Editor;
   import iilwygames.pool.model.gameplay.Ruleset.trickshots.Level;
   
   public class EditorView extends UiContainer
   {
       
      
      private var _new:SimpleButton;
      
      private var _load:SimpleButton;
      
      private var _save:SimpleButton;
      
      private var _saveas:SimpleButton;
      
      private var _delete:SimpleButton;
      
      private var _run:SimpleButton;
      
      private var _buttonList:List;
      
      private var _undo:SimpleButton;
      
      private var _redo:SimpleButton;
      
      private var _guideLines:SimpleButton;
      
      private var _shotLimit:LabelSelector;
      
      private var _timeLimit:LabelSelector;
      
      private var _levelName:Label;
      
      private var _levelSelector:ComboBox;
      
      private var _textInput:TextInput;
      
      private var _menuPopup:Canvas;
      
      private var _menuPopupLabel:Label;
      
      private var _exitButton:IconButton;
      
      private var _menuType:int;
      
      private const MENU_LOAD:int = 0;
      
      private const MENU_SAVE:int = 1;
      
      private const MENU_SAVEAS:int = 2;
      
      private const MENU_DELETE:int = 3;
      
      public function EditorView()
      {
         super();
      }
      
      override public function destroy() : void
      {
         super.destroy();
         if(this._exitButton)
         {
            this._exitButton.removeEventListener(MouseEvent.CLICK,this.onClickExit);
         }
         if(this._buttonList)
         {
            this._buttonList.removeEventListener(MouseEvent.CLICK,this.onClick);
         }
         if(this._levelSelector)
         {
            this._levelSelector.removeEventListener(ComboBoxEvent.CHANGED,this.onLevelSelected);
            this._levelSelector.removeEventListener(MouseEvent.CLICK,this.onLevelClick);
         }
         if(this._textInput)
         {
            this._textInput.removeEventListener(KeyboardEvent.KEY_DOWN,this.onTextInputKeyDown);
         }
         this._buttonList = null;
         this._load = null;
         this._save = null;
         this._delete = null;
         this._run = null;
         this._guideLines = null;
         this._shotLimit = null;
         this._timeLimit = null;
         this._levelSelector = null;
         this._menuPopup = null;
         this._menuPopupLabel = null;
         this._exitButton = null;
         this._levelName = null;
      }
      
      override public function createChildren() : void
      {
         this._menuPopup = new Canvas();
         this._menuPopup.backgroundColor = 16709786;
         this._menuPopup.setPadding(20,20);
         this._menuPopupLabel = new Label();
         this._new = new SimpleButton("new level");
         this._load = new SimpleButton("load");
         this._save = new SimpleButton("save");
         this._saveas = new SimpleButton("save as");
         this._delete = new SimpleButton("delete");
         this._run = new SimpleButton("run");
         this._undo = new SimpleButton("undo");
         this._redo = new SimpleButton("redo");
         this._guideLines = new SimpleButton("guide lines");
         this._textInput = new TextInput();
         this._shotLimit = new LabelSelector();
         this._timeLimit = new LabelSelector();
         this._levelSelector = new ComboBox("Choose Level");
         this._exitButton = new IconButton(GraphicManager.iconX2);
         this._levelName = new Label("Untitled",0,0,"strongWhite");
         this._buttonList = new List(0,0,"horizontal");
         this._buttonList.addContentChild(this._levelName);
         this._buttonList.addContentChild(this._new);
         this._buttonList.addContentChild(this._load);
         this._buttonList.addContentChild(this._save);
         this._buttonList.addContentChild(this._saveas);
         this._buttonList.addContentChild(this._delete);
         this._buttonList.addContentChild(this._run);
         this._buttonList.addContentChild(this._undo);
         this._buttonList.addContentChild(this._redo);
         this._buttonList.addContentChild(this._guideLines);
         addContentChild(this._buttonList);
         addContentChild(this._shotLimit);
         addContentChild(this._timeLimit);
         addContentChild(this._menuPopup);
         this._menuPopup.addContentChild(this._menuPopupLabel);
         this._menuPopup.addContentChild(this._levelSelector);
         this._menuPopup.addContentChild(this._textInput);
         this._menuPopup.addContentChild(this._exitButton);
         this._buttonList.addEventListener(MouseEvent.CLICK,this.onClick);
         this._levelSelector.addEventListener(ComboBoxEvent.CHANGED,this.onLevelSelected);
         this._levelSelector.addEventListener(MouseEvent.CLICK,this.onLevelClick);
         this._textInput.addEventListener(KeyboardEvent.KEY_DOWN,this.onTextInputKeyDown);
         this._exitButton.addEventListener(MouseEvent.CLICK,this.onClickExit);
         this._shotLimit.addItem("1 Shots","1");
         this._shotLimit.addItem("2 Shots","2");
         this._shotLimit.addItem("3 Shots","3");
         this._shotLimit.addItem("4 Shots","4");
         this._shotLimit.addItem("5 Shots","5");
         this._shotLimit.addItem("6 Shots","6");
         this._shotLimit.addItem("7 Shots","7");
         this._shotLimit.addItem("8 Shots","8");
         this._shotLimit.addItem("9 Shots","9");
         this._shotLimit.addItem("10 Shots","10");
         this._timeLimit.addItem("0 s","0");
         this._timeLimit.addItem("5 s","5");
         this._timeLimit.addItem("10 s","10");
         this._timeLimit.addItem("15 s","15");
         this._timeLimit.addItem("20 s","20");
         this._timeLimit.addItem("25 s","25");
         this._timeLimit.addItem("30 s","30");
         this._timeLimit.addItem("35 s","35");
         this._timeLimit.addItem("40 s","40");
         this._timeLimit.addItem("45 s","45");
         this._timeLimit.addItem("50 s","50");
         this._timeLimit.addItem("55 s","55");
         this._timeLimit.addItem("60 s","60");
         this._menuPopup.visible = false;
      }
      
      override public function commitProperties() : void
      {
         var levelNames:Array = null;
         var data:SimpleMenuDataProvider = null;
         var name:String = null;
         if(Globals.levelManager.ready)
         {
            levelNames = Globals.levelManager.getLevelNames();
            data = new SimpleMenuDataProvider();
            for each(name in levelNames)
            {
               data.addItem(name);
            }
            this._levelSelector.dataProvider = data;
         }
      }
      
      override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         this._shotLimit.x = unscaledWidth - this._shotLimit.width;
         this._timeLimit.x = this._shotLimit.x - this._timeLimit.width - 10;
         var fixed_width:Number = unscaledWidth * 0.4;
         this._exitButton.x = fixed_width - this._exitButton.width;
         this._exitButton.y = 0;
         if(this._menuType == this.MENU_LOAD || this._menuType == this.MENU_DELETE)
         {
            this._levelSelector.y = this._menuPopupLabel.y + this._menuPopupLabel.height + 5;
         }
         else if(this._menuType == this.MENU_SAVE)
         {
            this._textInput.y = this._menuPopupLabel.y + this._menuPopupLabel.height + 15;
         }
         else if(this._menuType == this.MENU_SAVEAS)
         {
            this._textInput.y = this._menuPopupLabel.y + this._menuPopupLabel.height + 3;
            this._levelSelector.y = this._textInput.y + this._textInput.height + 3;
         }
         this._menuPopup.invalidateSize();
         this._menuPopup.invalidateDisplayList();
         this._menuPopup.validate();
      }
      
      protected function onClick(me:MouseEvent) : void
      {
         var name:String = null;
         if(this._menuPopup.visible)
         {
            return;
         }
         var target:SimpleButton = me.target as SimpleButton;
         var editorRS:Editor = Globals.model.ruleset as Editor;
         if(target)
         {
            if(target.label == "new level")
            {
               editorRS.newLevel();
               this._levelName.text = "Untitled";
            }
            else if(target.label == "load")
            {
               this.showMenuPopup(this.MENU_LOAD);
            }
            else if(target.label == "save")
            {
               name = editorRS.getLevelName();
               if(name)
               {
                  editorRS.saveCurrentLevel(name);
               }
               else
               {
                  this.showMenuPopup(this.MENU_SAVE);
               }
            }
            else if(target.label == "save as")
            {
               this.showMenuPopup(this.MENU_SAVEAS);
            }
            else if(target.label == "delete")
            {
               this.showMenuPopup(this.MENU_DELETE);
            }
            else if(target.label == "run")
            {
               editorRS.runLevel();
            }
            else if(target.label == "undo")
            {
               editorRS.undoCommand();
            }
            else if(target.label == "redo")
            {
               editorRS.redoCommand();
            }
            else if(target.label == "guide lines")
            {
               TableView.RENDER_TABLE_OUTLINE = !TableView.RENDER_TABLE_OUTLINE;
               Globals.view.table.redrawTable();
            }
         }
      }
      
      private function onLevelClick(event:MouseEvent) : void
      {
         invalidateProperties();
      }
      
      private function onLevelSelected(event:ComboBoxEvent) : void
      {
         var name:String = null;
         var level:Level = null;
         trace("level selected");
         var editor:Editor = Globals.model.ruleset as Editor;
         if(this._menuType == this.MENU_LOAD)
         {
            editor.loadLevelByName(event.name);
            name = event.name;
         }
         else if(this._menuType == this.MENU_SAVEAS)
         {
            editor.saveCurrentLevel(event.name);
            name = event.name;
         }
         else if(this._menuType == this.MENU_DELETE)
         {
            level = Globals.levelManager.deleteByName(event.name);
            if(level == editor.getCurrentLevel())
            {
               editor.newLevel();
               name = "Untitled";
            }
         }
         if(name)
         {
            this._levelName.text = name;
         }
         this.hideMenuPopup();
      }
      
      protected function onTextInputKeyDown(event:KeyboardEvent) : void
      {
         var editorRS:Editor = null;
         var name:String = null;
         if(event.keyCode == Keyboard.ENTER)
         {
            if(this._textInput.text.length > 0)
            {
               editorRS = Globals.model.ruleset as Editor;
               name = this._textInput.text;
               this._textInput.text = "";
               editorRS.saveCurrentLevel(name);
               this._levelName.text = name;
               this.hideMenuPopup();
            }
         }
      }
      
      protected function onClickExit(me:MouseEvent) : void
      {
         this.hideMenuPopup();
      }
      
      public function getTimeLimit() : int
      {
         return int(this._timeLimit.selected);
      }
      
      public function getShotLimit() : int
      {
         return int(this._shotLimit.selected);
      }
      
      public function update() : void
      {
      }
      
      private function showMenuPopup(type:int) : void
      {
         this._menuPopup.visible = true;
         this._menuType = type;
         this._textInput.visible = false;
         this._levelSelector.visible = false;
         this._levelSelector.includeInLayout = false;
         this._textInput.includeInLayout = false;
         this._levelSelector.reset();
         if(type == this.MENU_LOAD)
         {
            this._menuPopupLabel.text = "Load Level";
            this._levelSelector.visible = true;
            this._levelSelector.includeInLayout = true;
         }
         else if(type == this.MENU_SAVE)
         {
            this._menuPopupLabel.text = "Save Level";
            this._textInput.visible = true;
            this._textInput.includeInLayout = true;
         }
         else if(type == this.MENU_SAVEAS)
         {
            this._menuPopupLabel.text = "Save As";
            this._levelSelector.visible = true;
            this._levelSelector.includeInLayout = true;
            this._textInput.visible = true;
            this._textInput.includeInLayout = true;
         }
         else if(type == this.MENU_DELETE)
         {
            this._menuPopupLabel.text = "Delete Level. Are you sure??";
            this._levelSelector.visible = true;
            this._levelSelector.includeInLayout = true;
         }
         invalidateDisplayList();
      }
      
      private function hideMenuPopup() : void
      {
         this._menuPopup.visible = false;
      }
   }
}
