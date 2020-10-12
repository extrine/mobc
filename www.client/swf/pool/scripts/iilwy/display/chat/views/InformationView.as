package iilwy.display.chat.views
{
   import flash.events.Event;
   import iilwy.ui.containers.UiContainer;
   import iilwy.ui.events.ContainerEvent;
   import iilwy.ui.partials.scrollgroups.TextBlockScrollGroup;
   
   public class InformationView extends UiContainer
   {
       
      
      private var information:TextBlockScrollGroup;
      
      public function InformationView()
      {
         super();
         setPadding(20);
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
      }
      
      override public function createChildren() : void
      {
         this.information = new TextBlockScrollGroup();
         this.information.textBlock.field.condenseWhite = true;
         this.information.textBlock.setStyleById("cssBlock");
         this.information.textBlock.enableScrollWheel();
         this.information.scrollbar.autoHide = true;
         addContentChild(this.information);
         this.information.textBlock.htmlText = "<body>";
         this.information.textBlock.htmlText = this.information.textBlock.htmlText + "<h2>Chat Room Rules</h2>";
         this.information.textBlock.htmlText = this.information.textBlock.htmlText + "<br />";
         this.information.textBlock.htmlText = this.information.textBlock.htmlText + "<p>1. Never EVER give people your real name. NEVER share real world contact details</p>";
         this.information.textBlock.htmlText = this.information.textBlock.htmlText + "<p>2. People who harass, insult and grief will be stripped of their XP first then banned for life from the site</p>";
         this.information.textBlock.htmlText = this.information.textBlock.htmlText + "<p>3. REPORT people by clicking on their profile picture in the chat window and selecting \"Report this person\"</p>";
         this.information.textBlock.htmlText = this.information.textBlock.htmlText + "<p>4. BLOCK people by clicking on their profile picture in the chat window and selecting \"Block\"</p>";
         this.information.textBlock.htmlText = this.information.textBlock.htmlText + "<br />";
         this.information.textBlock.htmlText = this.information.textBlock.htmlText + "<h2>Also</h2>";
         this.information.textBlock.htmlText = this.information.textBlock.htmlText + "<br />";
         this.information.textBlock.htmlText = this.information.textBlock.htmlText + "<p>1. We log EVERY chat. And keep that log FOREVER.</p>";
         this.information.textBlock.htmlText = this.information.textBlock.htmlText + "<p>2. Slurs and room names or comments that insult anyone for their race, gender, sexuality will not be tolerated</p>";
         this.information.textBlock.htmlText = this.information.textBlock.htmlText + "<p>3. Oh yeah, have fun :)</p>";
         this.information.textBlock.htmlText = this.information.textBlock.htmlText + "<br />";
         this.information.textBlock.htmlText = this.information.textBlock.htmlText + "<p>Chat should be safe and fun for all. Use the tools provided to block out those who bother you.</p>";
         this.information.textBlock.htmlText = this.information.textBlock.htmlText + "</body>";
      }
      
      override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         this.information.x = padding.left;
         this.information.y = padding.top;
         this.information.width = unscaledWidth - padding.horizontal;
         this.information.height = unscaledHeight - padding.vertical;
      }
      
      private function onAddedToStage(event:Event) : void
      {
         dispatchEvent(new ContainerEvent(ContainerEvent.STOP_PROCESSING,true));
      }
      
      private function onRemovedFromStage(event:Event) : void
      {
      }
   }
}
