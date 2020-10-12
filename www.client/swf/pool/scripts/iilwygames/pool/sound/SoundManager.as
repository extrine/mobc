package iilwygames.pool.sound
{
   import flash.media.Sound;
   import flash.media.SoundTransform;
   import flash.utils.Dictionary;
   import flash.utils.describeType;
   
   public class SoundManager
   {
       
      
      [Embed(symbol="iilwygames.pool.ball3",source="../assets/sound/sound.swf")]
      public var ball3:Class;
      
      [Embed(symbol="iilwygames.pool.ball6",source="../assets/sound/sound.swf")]
      public var ball6:Class;
      
      [Embed(symbol="iilwygames.pool.ball7",source="../assets/sound/sound.swf")]
      public var ball7:Class;
      
      [Embed(symbol="iilwygames.pool.break1",source="../assets/sound/sound.swf")]
      public var break1:Class;
      
      [Embed(symbol="iilwygames.pool.error.mp3",source="../assets/sound/sound.swf")]
      public var error:Class;
      
      [Embed(symbol="iilwygames.pool.go",source="../assets/sound/sound.swf")]
      public var go:Class;
      
      [Embed(symbol="iilwygames.pool.lose.aiff",source="../assets/sound/sound.swf")]
      public var lose:Class;
      
      [Embed(symbol="iilwygames.pool.pocket1",source="../assets/sound/sound.swf")]
      public var pocket1:Class;
      
      [Embed(symbol="iilwygames.pool.rack",source="../assets/sound/sound.swf")]
      public var rack:Class;
      
      [Embed(symbol="iilwygames.pool.strike5",source="../assets/sound/sound.swf")]
      public var strike5:Class;
      
      [Embed(symbol="iilwygames.pool.tick",source="../assets/sound/sound.swf")]
      public var tick:Class;
      
      [Embed(symbol="iilwygames.pool.wall2",source="../assets/sound/sound.swf")]
      public var wall2:Class;
      
      [Embed(symbol="iilwygames.pool.win.aiff",source="../assets/sound/sound.swf")]
      public var win:Class;
      
      private var soundResources:Dictionary;
      
      private var soundTransform:SoundTransform;
      
      public function SoundManager()
      {
         var scXML:XML = null;
         var className:String = null;
         var sc:Class = null;
         this.ball3 = SoundManager_ball3;
         this.ball6 = SoundManager_ball6;
         this.ball7 = SoundManager_ball7;
         this.break1 = SoundManager_break1;
         this.error = SoundManager_error;
         this.go = SoundManager_go;
         this.lose = SoundManager_lose;
         this.pocket1 = SoundManager_pocket1;
         this.rack = SoundManager_rack;
         this.strike5 = SoundManager_strike5;
         this.tick = SoundManager_tick;
         this.wall2 = SoundManager_wall2;
         this.win = SoundManager_win;
         super();
         var ds:XMLList = describeType(this)..variable;
         this.soundResources = new Dictionary();
         for each(scXML in ds)
         {
            className = scXML.@name.toString();
            sc = this[className] as Class;
            if(sc)
            {
               this.soundResources[scXML.@name.toString()] = new sc();
            }
         }
         this.soundTransform = new SoundTransform(1,0);
      }
      
      public function destroy() : void
      {
         this.soundResources = null;
      }
      
      public function stop() : void
      {
      }
      
      public function playSound(id:String, volume:Number = 1) : void
      {
         var soundObject:Sound = this.soundResources[id];
         this.soundTransform.volume = volume;
         if(soundObject)
         {
            soundObject.play(0,0,this.soundTransform);
         }
      }
   }
}
