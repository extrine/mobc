package iilwy.chat.xiff.auth
{
   import iilwy.events.AsyncEvent;
   import iilwy.events.FBEvent;
   import iilwy.utils.Responder;
   import iilwy.utils.StageReference;
   import org.igniterealtime.xiff.auth.XFacebookPlatform;
   import org.igniterealtime.xiff.core.XMPPConnection;
   
   public class XFacebookPlatformExtended extends XFacebookPlatform
   {
       
      
      private var responseCallback:Function;
      
      private var responder:Responder;
      
      public function XFacebookPlatformExtended(connection:XMPPConnection)
      {
         super(connection);
      }
      
      public function handleChallenge2(stage:int, challenge:XML, challengeResponseCallback:Function) : void
      {
         this.responseCallback = challengeResponseCallback;
         this.responder = new Responder();
         this.responder.setAsyncListeners(this.onSignSuccess,this.onSignFail);
         var signEvent:FBEvent = new FBEvent(FBEvent.SIGN,true,true);
         signEvent.challenge = challenge.toString();
         signEvent.responder = this.responder;
         StageReference.stage.dispatchEvent(signEvent);
      }
      
      private function onSignSuccess(event:AsyncEvent) : void
      {
         var resp:XML = response;
         resp.setChildren(event.data);
         this.responseCallback(resp);
      }
      
      private function onSignFail(event:AsyncEvent) : void
      {
      }
   }
}
