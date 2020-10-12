package iilwy.utils.dragdrop
{
   public interface IDropResponder
   {
       
      
      function dragIn(source:Draggable) : void;
      
      function dragOut(source:Draggable) : void;
      
      function dragDrop(source:Draggable) : void;
      
      function dragDropFail(source:Draggable) : void;
   }
}
