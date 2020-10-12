package com.facebook.graph.data.ui.credits
{
   public class Credits
   {
       
      
      public var order_info:String;
      
      public var purchase_type:String;
      
      public var credits_purchase:Boolean;
      
      public var dev_purchase_params:Object;
      
      public function Credits()
      {
         super();
      }
      
      public function toObject() : Object
      {
         var object:Object = {};
         if(this.order_info)
         {
            object.order_info = this.order_info;
         }
         if(this.purchase_type)
         {
            object.purchase_type = this.purchase_type;
         }
         if(this.credits_purchase)
         {
            object.credits_purchase = this.credits_purchase;
         }
         if(this.dev_purchase_params)
         {
            object.dev_purchase_params = this.dev_purchase_params;
         }
         return object;
      }
   }
}
