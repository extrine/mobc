package iilwy.ui.events
{
   import flash.events.Event;
   import flash.geom.Rectangle;
   import iilwy.events.DataEvent;
   import iilwy.ui.containers.UiContainer;
   import iilwy.ui.utils.Margin;
   
   public class ContainerEvent extends DataEvent
   {
      
      public static var CLOSE:String = "containerEventClose";
      
      public static var MAXIMIZE:String = "containerEventMaximize";
      
      public static var MINIMIZE:String = "containerEventMinimize";
      
      public static var FOCUS:String = "containerEventFocus";
      
      public static var REMOVED_FROM_CONTAINER:String = "containerEventRemovedFromContainer";
      
      public static var ADDED_TO_CONTAINER:String = "containerEventAddedToContainer";
      
      public static var AUTO_REMOVE:String = "containerEventAutoRemove";
      
      public static var CLICK_OUT:String = "containerEventClickOut";
      
      public static var MOUSE_UP_OUT:String = "containerEventMouseUpOut";
      
      public static var RESIZE:String = "containerEventResize";
      
      public static var START_ALERT:String = "containerEventStartAlert";
      
      public static var STOP_ALERT:String = "containerEventStopAlert";
      
      public static var START_PROCESSING:String = "containerEventStartProcessing";
      
      public static var STOP_PROCESSING:String = "containerEventStopProcessing";
      
      public static var SET_PROCESSING_MARGIN:String = "containerEventSetProcessingMargin";
      
      public static var UPDATE_BACKGROUND:String = "containerEventUpdateBackground";
      
      public static var VIEW_CHANGED:String = "containerEventViewChanged";
      
      public static var SET_TITLE:String = "containerEventSetTitle";
      
      public static var UNMASK_CONTENTS:String = "containerEventUnmaskContents";
      
      public static var DESTROY:String = "containerEventDestroy";
       
      
      public var container:UiContainer;
      
      public var title:String;
      
      public var force:Boolean;
      
      public var margin:Margin;
      
      public var backgroundStripesOffset:Rectangle;
      
      public var backgroundImageAlpha:Number = 1;
      
      public function ContainerEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
      
      override public function clone() : Event
      {
         var containerEvent:ContainerEvent = new ContainerEvent(type,bubbles,cancelable);
         containerEvent.data = data;
         containerEvent.container = this.container;
         containerEvent.title = this.title;
         containerEvent.force = this.force;
         if(this.margin)
         {
            containerEvent.margin = this.margin.clone();
         }
         if(this.backgroundStripesOffset)
         {
            containerEvent.backgroundStripesOffset = this.backgroundStripesOffset.clone();
         }
         containerEvent.backgroundImageAlpha = this.backgroundImageAlpha;
         return containerEvent;
      }
      
      override public function toString() : String
      {
         return formatToString("ContainerEvent","type","bubbles","cancelable","eventPhase");
      }
   }
}
