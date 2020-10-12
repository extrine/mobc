package org.igniterealtime.xiff.auth
{
   public class SASLAuth
   {
       
      
      protected var req:XML;
      
      protected var response:XML;
      
      protected var stage:int;
      
      public function SASLAuth()
      {
         this.req = <auth/>;
         this.response = <response/>;
         super();
      }
      
      public function handleChallenge(stage:int, challenge:XML) : XML
      {
         throw new Error("Don\'t call this method on SASLAuth; use a subclass");
      }
      
      public function handleResponse(stage:int, response:XML) : Object
      {
         throw new Error("Don\'t call this method on SASLAuth; use a subclass");
      }
      
      public function get request() : XML
      {
         return this.req;
      }
   }
}
