package iilwy.ui.controls
{
   import iilwy.namespaces.omgpop_internal;
   
   use namespace omgpop_internal;
   
   public class CheckBoxGroup extends AbstractOptionButtonGroup
   {
       
      
      public function CheckBoxGroup()
      {
         super();
      }
      
      public function get selections() : Array
      {
         return selections;
      }
      
      public function set selections(value:Array) : void
      {
         selections = value;
      }
      
      public function get unselectableCheckBoxes() : Array
      {
         return unselectableButtons;
      }
      
      public function get selectionLimit() : int
      {
         return selectionLimit;
      }
      
      public function set selectionLimit(value:int) : void
      {
         selectionLimit = value;
      }
      
      public function get numCheckBoxes() : int
      {
         return numButtons;
      }
      
      public function get numSelectedCheckBoxes() : int
      {
         return numSelectedButtons;
      }
      
      public function selectCheckBox(checkBox:CheckBox) : void
      {
         selectButton(checkBox);
      }
      
      public function deselectCheckBox(checkBox:CheckBox) : void
      {
         deselectButton(checkBox);
      }
      
      public function addCheckBox(checkBox:CheckBox) : void
      {
         addButton(checkBox);
      }
      
      public function removeCheckBox(checkBox:CheckBox) : void
      {
         removeButton(checkBox);
      }
      
      public function getCheckBoxAt(index:int) : CheckBox
      {
         return getButtonAt(index) as CheckBox;
      }
      
      public function selectAll() : void
      {
         selectAll();
      }
      
      public function deselectAll() : void
      {
         deselectAll();
      }
      
      public function get unselectableEnabled() : Boolean
      {
         return unselectableEnabled;
      }
      
      public function set unselectableEnabled(value:Boolean) : void
      {
         unselectableEnabled = value;
      }
   }
}
