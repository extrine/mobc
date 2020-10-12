package iilwygames.baloono.embedded
{
   import flash.media.Sound;
   import flash.media.SoundTransform;
   import flash.utils.Dictionary;
   
   public class SoundAssets
   {
      
      public static const DIE:String = "DIE";
      
      public static const EXPLODE:String = "EXPLODE";
      
      public static const GAMEOVER:String = "GAMEOVER";
      
      public static const DROP:String = "DROP";
      
      public static const COUNTDOWN_READY:String = "COUNTDOWN_READY";
      
      public static const COUNTDOWN_GO:String = "COUNTDOWN_GO";
      
      public static const POWERUP:String = "POWERUP";
       
      
      public var die:Class;
      
      public var explode:Class;
      
      public var gameover:Class;
      
      public var go:Class;
      
      private var _embeddedSounds:Dictionary;
      
      private var _globalSoundTransform:SoundTransform;
      
      public var powerup:Class;
      
      public var drop:Class;
      
      public var readyset:Class;
      
      public function SoundAssets()
      {
         this.die = SoundAssets_die;
         this.drop = SoundAssets_drop;
         this.explode = SoundAssets_explode;
         this.gameover = SoundAssets_gameover;
         this.powerup = SoundAssets_powerup;
         this.readyset = SoundAssets_readyset;
         this.go = SoundAssets_go;
         super();
         this._embeddedSounds = new Dictionary();
         this._embeddedSounds[COUNTDOWN_GO] = new this.go();
         this._embeddedSounds[COUNTDOWN_READY] = new this.readyset();
         this._embeddedSounds[DIE] = new this.die();
         this._embeddedSounds[DROP] = new this.drop();
         this._embeddedSounds[EXPLODE] = new this.explode();
         this._embeddedSounds[GAMEOVER] = new this.gameover();
         this._embeddedSounds[POWERUP] = new this.powerup();
         this._globalSoundTransform = new SoundTransform();
      }
      
      public function playSound(param1:String, param2:Number = 0, param3:Number = 1) : void
      {
         var _loc4_:Sound = this._embeddedSounds[param1];
         if(_loc4_)
         {
            if(param3 < 0.05)
            {
               param3 = 0.02;
            }
            this._globalSoundTransform.volume = param3;
            _loc4_.play(0,param2,this._globalSoundTransform);
         }
      }
   }
}
