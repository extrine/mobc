package iilwygames.baloono.gameplay.input
{
   import flash.events.TimerEvent;
   import flash.ui.Keyboard;
   import flash.utils.Timer;
   import iilwygames.baloono.gameplay.player.PlayerDirection;
   import iilwygames.baloono.managers.KeyboardInputManager;
   
   public class PlayerKeyboardInputMap implements IKeyboardInputMap
   {
      
      public static var instance:PlayerKeyboardInputMap = new PlayerKeyboardInputMap();
      
      public static const ACTION:uint = 17;
      
      public static const DROP_BOMB:uint = 16;
       
      
      protected var ret:Array;
      
      protected const D:uint = 68;
      
      protected const A:uint = 65;
      
      protected const S:uint = 83;
      
      protected const W:uint = 87;
      
      protected var testTimer:Timer;
      
      public function PlayerKeyboardInputMap()
      {
         this.ret = [];
         super();
      }
      
      public function processInput(param1:KeyboardInputManager) : Array
      {
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         var _loc6_:Boolean = false;
         var _loc7_:Boolean = false;
         var _loc8_:Array = param1.pressedKeys;
         _loc2_ = _loc8_[Keyboard.LEFT] || _loc8_[this.A];
         _loc3_ = _loc8_[Keyboard.RIGHT] || _loc8_[this.D];
         _loc4_ = _loc8_[Keyboard.UP] || _loc8_[this.W];
         _loc5_ = _loc8_[Keyboard.DOWN] || _loc8_[this.S];
         _loc6_ = _loc8_[Keyboard.SPACE] || _loc8_[Keyboard.CONTROL];
         _loc7_ = _loc8_[Keyboard.SHIFT];
         if(this.ret.length > 0)
         {
            this.ret.splice(0);
         }
         if(_loc2_ && !_loc3_)
         {
            this.ret.push(PlayerDirection.GO_LEFT);
         }
         if(_loc3_ && !_loc2_)
         {
            this.ret.push(PlayerDirection.GO_RIGHT);
         }
         if(_loc4_ && !_loc5_)
         {
            this.ret.push(PlayerDirection.GO_UP);
         }
         if(_loc5_ && !_loc4_)
         {
            this.ret.push(PlayerDirection.GO_DOWN);
         }
         if(_loc6_)
         {
            this.ret.push(DROP_BOMB);
         }
         if(_loc7_)
         {
            this.ret.push(ACTION);
         }
         return this.ret;
      }
      
      public function control(param1:TimerEvent) : void
      {
         var _loc8_:int = 0;
         if(this.ret.length > 0)
         {
            this.ret.splice(0);
         }
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         var _loc6_:Boolean = false;
         if(Math.random() > 0.5)
         {
            _loc2_ = true;
         }
         else
         {
            _loc3_ = true;
         }
         if(Math.random() > 0.5)
         {
            _loc4_ = true;
         }
         else
         {
            _loc5_ = true;
         }
         if(Math.random() > 0.9)
         {
            _loc6_ = true;
         }
         if(_loc2_ && !_loc3_)
         {
            this.ret.push(PlayerDirection.GO_LEFT);
         }
         if(_loc3_ && !_loc2_)
         {
            this.ret.push(PlayerDirection.GO_RIGHT);
         }
         if(_loc4_ && !_loc5_)
         {
            this.ret.push(PlayerDirection.GO_UP);
         }
         if(_loc5_ && !_loc4_)
         {
            this.ret.push(PlayerDirection.GO_DOWN);
         }
         if(_loc6_)
         {
            this.ret.push(DROP_BOMB);
         }
         if(Math.random() > 0.5)
         {
            _loc8_ = 100 + 500 * Math.random();
         }
         else
         {
            _loc8_ = 200;
         }
         this.testTimer.delay = _loc8_;
      }
   }
}
