package iilwygames.baloono.gameplay.tiles
{
   import iilwygames.baloono.BaloonoGame;
   
   public final class TileState
   {
      
      public static const INACTIVE_ANIMATING:TileState = new TileState();
      
      public static const INACTIVE:TileState = new TileState();
      
      public static const ACTIVE:TileState = new TileState();
       
      
      public function TileState()
      {
         super();
      }
      
      public function get inactive() : Boolean
      {
         return this == INACTIVE || this == INACTIVE_ANIMATING;
      }
      
      public function toString() : String
      {
         var _loc1_:* = "";
         if(BaloonoGame.instance.DEBUG_LOGGING)
         {
            _loc1_ = "[TileState ";
            switch(this)
            {
               case ACTIVE:
                  _loc1_ = _loc1_ + "ACTIVE";
                  break;
               case INACTIVE:
                  _loc1_ = _loc1_ + "INACTIVE";
                  break;
               case INACTIVE_ANIMATING:
                  _loc1_ = _loc1_ + "INACTIVE_ANIMATING";
            }
            _loc1_ = _loc1_ + "]";
         }
         return _loc1_;
      }
      
      public function get active() : Boolean
      {
         return this == ACTIVE;
      }
   }
}
