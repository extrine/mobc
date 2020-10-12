package iilwy.ui.controls
{
   import flash.utils.getDefinitionByName;
   import iilwy.ui.containers.ListViewDataProvider;
   import iilwy.ui.containers.ListViewDataWrapper;
   
   public class SimpleMenuDataProvider extends ListViewDataProvider
   {
       
      
      public function SimpleMenuDataProvider()
      {
         super();
      }
      
      override public function addItem(data:*) : void
      {
         var TextUtil:* = undefined;
         var label:String = null;
         var opt:Object = new Object();
         if(data is String)
         {
            opt.label = data;
            opt.value = data;
         }
         else if(data is Number)
         {
            try
            {
               TextUtil = getDefinitionByName("iilwy.utils.TextUtil") as Class;
            }
            catch(error:Error)
            {
            }
            label = Boolean(TextUtil)?TextUtil.commaFormatNumber(Number(data)):Number(data).toString();
            opt.label = label;
            opt.value = Number(data).toString();
         }
         else
         {
            opt.label = data.label;
            opt.value = data.value;
         }
         var wrapper:ListViewDataWrapper = new ListViewDataWrapper(opt);
         _data.push(wrapper);
         dispatchChangedEvent();
      }
      
      public function addItems(array:Array) : void
      {
         for(var i:int = 0; i < array.length; i++)
         {
            this.addItem(array[i]);
         }
      }
      
      public function get value() : String
      {
         var v:String = null;
         var item:ListViewDataWrapper = getItemAt(selectedIndex);
         if(item)
         {
            v = item.data.value;
         }
         return v;
      }
      
      public function set value(s:String) : void
      {
         var l:Number = items.length;
         for(var i:Number = 0; i < l; i++)
         {
            if(getItemAt(i).data.value == s)
            {
               selectedUid = getItemAt(i).uid;
            }
         }
      }
   }
}
