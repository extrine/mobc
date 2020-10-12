package iilwy.chat.xiff.core
{
   import flash.xml.XMLNode;
   import iilwy.chat.xiff.auth.XFacebookPlatformExtended;
   import org.igniterealtime.xiff.core.XMPPConnection;
   
   public class XMPPConnectionExtended extends XMPPConnection
   {
       
      
      public function XMPPConnectionExtended()
      {
         super();
      }
      
      override protected function handleChallenge(challengeBody:XMLNode) : void
      {
         if(auth is XFacebookPlatformExtended)
         {
            XFacebookPlatformExtended(auth).handleChallenge2(0,XML(challengeBody.toString()),this.handleChallenge_response);
         }
         else
         {
            super.handleChallenge(challengeBody);
         }
      }
      
      protected function handleChallenge_response(response:XML) : void
      {
         sendXML(response);
      }
   }
}
