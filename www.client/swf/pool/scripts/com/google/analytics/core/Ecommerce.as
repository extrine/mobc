package com.google.analytics.core
{
   import com.google.analytics.debug.DebugConfiguration;
   import com.google.analytics.ecommerce.Transaction;
   
   public class Ecommerce
   {
       
      
      private var _debug:DebugConfiguration;
      
      private var _trans:Array;
      
      public function Ecommerce(debug:DebugConfiguration)
      {
         super();
         this._debug = debug;
         this._trans = new Array();
      }
      
      public function addTransaction(id:String, affiliation:String, total:String, tax:String, shipping:String, city:String, state:String, country:String) : Transaction
      {
         var newTrans:Transaction = null;
         newTrans = this.getTransaction(id);
         if(newTrans == null)
         {
            newTrans = new Transaction(id,affiliation,total,tax,shipping,city,state,country);
            this._trans.push(newTrans);
         }
         else
         {
            newTrans.affiliation = affiliation;
            newTrans.total = total;
            newTrans.tax = tax;
            newTrans.shipping = shipping;
            newTrans.city = city;
            newTrans.state = state;
            newTrans.country = country;
         }
         return newTrans;
      }
      
      public function getTransaction(orderId:String) : Transaction
      {
         var i:Number = NaN;
         for(i = 0; i < this._trans.length; i++)
         {
            if(this._trans[i].id == orderId)
            {
               return this._trans[i];
            }
         }
         return null;
      }
      
      public function getTransFromArray(i:Number) : Transaction
      {
         return this._trans[i];
      }
      
      public function getTransLength() : Number
      {
         return this._trans.length;
      }
   }
}
