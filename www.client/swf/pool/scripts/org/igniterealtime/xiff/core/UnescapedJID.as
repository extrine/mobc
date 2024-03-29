package org.igniterealtime.xiff.core
{
   public class UnescapedJID extends AbstractJID
   {
       
      
      public function UnescapedJID(inJID:String, validate:Boolean = false)
      {
         super(inJID,validate);
         if(node)
         {
            _node = unescapedNode(node);
         }
      }
      
      public function equals(testJID:UnescapedJID, shouldTestBareJID:Boolean) : Boolean
      {
         if(shouldTestBareJID)
         {
            return testJID.bareJID == bareJID;
         }
         return testJID.toString() == toString();
      }
      
      public function get escaped() : EscapedJID
      {
         return new EscapedJID(toString());
      }
   }
}
