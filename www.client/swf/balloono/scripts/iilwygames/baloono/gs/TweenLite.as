package iilwygames.baloono.gs
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.geom.ColorTransform;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   
   public class TweenLite
   {
      
      private static var _timer:Timer = new Timer(2000);
      
      private static var _classInitted:Boolean;
      
      public static var defaultEase:Function = TweenLite.easeOut;
      
      public static var version:Number = 9.1;
      
      public static var masterList:Dictionary = new Dictionary(false);
      
      private static var _sprite:Sprite = new Sprite();
      
      public static var currentTime:uint;
      
      public static var overwriteManager:Object;
      
      public static var killDelayedCallsTo:Function = TweenLite.killTweensOf;
       
      
      public var delay:Number;
      
      protected var _hasUpdate:Boolean;
      
      protected var _subTweens:Array;
      
      public var initted:Boolean;
      
      public var startTime:Number;
      
      public var forceActive:Boolean;
      
      public var duration:Number;
      
      public var target:Object;
      
      protected var _hst:Boolean;
      
      public var gc:Boolean;
      
      protected var _isDisplayObject:Boolean;
      
      public var tweens:Array;
      
      public var vars:Object;
      
      public var ease:Function;
      
      public var initTime:Number;
      
      public var combinedTimeScale:Number;
      
      public function TweenLite(param1:Object, param2:Number, param3:Object)
      {
         var _loc5_:* = undefined;
         super();
         if(param1 == null)
         {
            return;
         }
         if(!_classInitted)
         {
            currentTime = getTimer();
            _sprite.addEventListener(Event.ENTER_FRAME,executeAll);
            if(overwriteManager == null)
            {
               overwriteManager = {
                  "mode":1,
                  "enabled":false
               };
            }
            _timer.addEventListener("timer",killGarbage);
            _timer.start();
            _classInitted = true;
         }
         this.vars = param3;
         this.duration = Number(param2) || Number(0.001);
         this.delay = Number(param3.delay) || Number(0);
         this.combinedTimeScale = Number(param3.timeScale) || Number(1);
         this.forceActive = param2 == 0 && this.delay == 0;
         this.target = param1;
         this._isDisplayObject = param1 is DisplayObject;
         if(!(this.vars.ease is Function))
         {
            this.vars.ease = defaultEase;
         }
         if(this.vars.easeParams != null)
         {
            this.vars.proxiedEase = this.vars.ease;
            this.vars.ease = this.easeProxy;
         }
         this.ease = this.vars.ease;
         if(!isNaN(Number(this.vars.autoAlpha)))
         {
            this.vars.alpha = Number(this.vars.autoAlpha);
            this.vars.visible = this.vars.alpha > 0;
         }
         this.tweens = [];
         this._subTweens = [];
         this.initted = false;
         this._hst = false;
         this.initTime = currentTime;
         this.startTime = this.initTime + this.delay * 1000;
         var _loc4_:int = param3.overwrite == undefined || !overwriteManager.enabled && param3.overwrite > 1?int(overwriteManager.mode):int(int(param3.overwrite));
         if(masterList[param1] == undefined || param1 != null && _loc4_ == 1)
         {
            masterList[param1] = [];
         }
         masterList[param1].push(this);
         if(this.vars.runBackwards == true && this.vars.renderOnStart != true || this.forceActive)
         {
            this.initTweenVals();
            if(this.forceActive)
            {
               this.render(this.startTime + 1);
            }
            else
            {
               this.render(this.startTime);
            }
            _loc5_ = this.vars.visible;
            if(this.vars.isTV == true)
            {
               _loc5_ = this.vars.exposedProps.visible;
            }
            if(_loc5_ != null && this.vars.runBackwards == true && this._isDisplayObject)
            {
               this.target.visible = Boolean(_loc5_);
            }
         }
      }
      
      public static function frameProxy(param1:Object) : void
      {
         param1.info.target.gotoAndStop(Math.round(param1.target.frame));
      }
      
      public static function removeTween(param1:TweenLite, param2:Boolean = true) : void
      {
         if(param1 != null)
         {
            if(param2)
            {
               param1.clear();
            }
            param1.enabled = false;
         }
      }
      
      public static function killTweensOf(param1:Object = null, param2:Boolean = false) : void
      {
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:TweenLite = null;
         if(param1 != null && masterList[param1] != undefined)
         {
            _loc3_ = masterList[param1];
            _loc4_ = _loc3_.length - 1;
            while(_loc4_ > -1)
            {
               _loc5_ = _loc3_[_loc4_];
               if(param2 && !_loc5_.gc)
               {
                  _loc5_.complete(false);
               }
               _loc5_.clear();
               _loc4_--;
            }
            delete masterList[param1];
         }
      }
      
      public static function delayedCall(param1:Number, param2:Function, param3:Array = null) : TweenLite
      {
         return new TweenLite(param2,0,{
            "delay":param1,
            "onComplete":param2,
            "onCompleteParams":param3,
            "overwrite":0
         });
      }
      
      public static function from(param1:Object, param2:Number, param3:Object) : TweenLite
      {
         param3.runBackwards = true;
         return new TweenLite(param1,param2,param3);
      }
      
      public static function executeAll(param1:Event = null) : void
      {
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc2_:uint = currentTime = getTimer();
         var _loc3_:Dictionary = masterList;
         for each(_loc4_ in _loc3_)
         {
            _loc5_ = _loc4_.length - 1;
            while(_loc5_ > -1)
            {
               if(_loc4_[_loc5_] != null && _loc4_[_loc5_].active)
               {
                  _loc4_[_loc5_].render(_loc2_);
               }
               _loc5_--;
            }
         }
      }
      
      public static function easeOut(param1:Number, param2:Number, param3:Number, param4:Number) : Number
      {
         return -param3 * (param1 = param1 / param4) * (param1 - 2) + param2;
      }
      
      public static function volumeProxy(param1:Object) : void
      {
         param1.info.target.soundTransform = param1.target;
      }
      
      public static function killGarbage(param1:TimerEvent) : void
      {
         var _loc3_:* = null;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc2_:Dictionary = masterList;
         for(_loc3_ in _loc2_)
         {
            _loc4_ = _loc2_[_loc3_];
            _loc5_ = _loc4_.length - 1;
            while(_loc5_ > -1)
            {
               if(_loc4_[_loc5_].gc)
               {
                  _loc4_.splice(_loc5_,1);
               }
               _loc5_--;
            }
            if(_loc4_.length == 0)
            {
               delete _loc2_[_loc3_];
            }
         }
      }
      
      public static function tintProxy(param1:Object) : void
      {
         var _loc2_:Number = param1.target.progress;
         var _loc3_:Number = 1 - _loc2_;
         var _loc4_:Object = param1.info.color;
         var _loc5_:Object = param1.info.endColor;
         param1.info.target.transform.colorTransform = new ColorTransform(_loc4_.redMultiplier * _loc3_ + _loc5_.redMultiplier * _loc2_,_loc4_.greenMultiplier * _loc3_ + _loc5_.greenMultiplier * _loc2_,_loc4_.blueMultiplier * _loc3_ + _loc5_.blueMultiplier * _loc2_,_loc4_.alphaMultiplier * _loc3_ + _loc5_.alphaMultiplier * _loc2_,_loc4_.redOffset * _loc3_ + _loc5_.redOffset * _loc2_,_loc4_.greenOffset * _loc3_ + _loc5_.greenOffset * _loc2_,_loc4_.blueOffset * _loc3_ + _loc5_.blueOffset * _loc2_,_loc4_.alphaOffset * _loc3_ + _loc5_.alphaOffset * _loc2_);
      }
      
      public static function to(param1:Object, param2:Number, param3:Object) : TweenLite
      {
         return new TweenLite(param1,param2,param3);
      }
      
      public function get enabled() : Boolean
      {
         return !this.gc;
      }
      
      public function set enabled(param1:Boolean) : void
      {
         var _loc2_:Array = null;
         var _loc3_:Boolean = false;
         var _loc4_:int = 0;
         if(param1)
         {
            if(masterList[this.target] == undefined)
            {
               masterList[this.target] = [this];
            }
            else
            {
               _loc2_ = masterList[this.target];
               _loc4_ = _loc2_.length - 1;
               while(_loc4_ > -1)
               {
                  if(_loc2_[_loc4_] == this)
                  {
                     _loc3_ = true;
                     break;
                  }
                  _loc4_--;
               }
               if(!_loc3_)
               {
                  masterList[this.target].push(this);
               }
            }
         }
         this.gc = !param1;
         if(this.gc || this.startTime > currentTime)
         {
            this.forceActive = false;
         }
         else
         {
            this.forceActive = this.initted;
         }
      }
      
      protected function addSubTween(param1:String, param2:Function, param3:Object, param4:Object, param5:Object = null) : void
      {
         var _loc6_:* = null;
         this._subTweens[this._subTweens.length] = {
            "name":param1,
            "proxy":param2,
            "target":param3,
            "info":param5
         };
         for(_loc6_ in param4)
         {
            if(typeof param4[_loc6_] == "number")
            {
               this.tweens[this.tweens.length] = [param3,_loc6_,param3[_loc6_],param4[_loc6_] - param3[_loc6_],param1];
            }
            else
            {
               this.tweens[this.tweens.length] = [param3,_loc6_,param3[_loc6_],Number(param4[_loc6_]),param1];
            }
         }
         this._hst = true;
      }
      
      public function clear() : void
      {
         this.tweens = [];
         this._subTweens = [];
         this.vars = {};
         this._hasUpdate = false;
         this._hst = false;
      }
      
      public function get active() : Boolean
      {
         if(this.forceActive)
         {
            return true;
         }
         if(this.gc)
         {
            return false;
         }
         if(currentTime >= this.startTime)
         {
            this.forceActive = true;
            if(!this.initted)
            {
               this.initTweenVals();
            }
            else if(this.vars.visible != undefined && this._isDisplayObject)
            {
               this.target.visible = true;
            }
            if(this.vars.onStart != null)
            {
               this.vars.onStart.apply(null,this.vars.onStartParams);
            }
            if(this.duration == 0.001)
            {
               this.startTime = this.startTime - 1;
            }
            return true;
         }
         return false;
      }
      
      public function render(param1:uint) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         var _loc2_:Number = (param1 - this.startTime) / 1000;
         if(_loc2_ >= this.duration)
         {
            _loc2_ = this.duration;
            _loc3_ = this.ease == this.vars.ease || this.duration == 0.001?Number(1):Number(0);
         }
         else
         {
            _loc3_ = this.ease(_loc2_,0,1,this.duration);
         }
         _loc5_ = this.tweens.length - 1;
         while(_loc5_ > -1)
         {
            _loc4_ = this.tweens[_loc5_];
            _loc4_[0][_loc4_[1]] = _loc4_[2] + _loc3_ * _loc4_[3];
            _loc5_--;
         }
         if(this._hst)
         {
            _loc5_ = this._subTweens.length - 1;
            while(_loc5_ > -1)
            {
               this._subTweens[_loc5_].proxy(this._subTweens[_loc5_]);
               _loc5_--;
            }
         }
         if(this._hasUpdate)
         {
            this.vars.onUpdate.apply(null,this.vars.onUpdateParams);
         }
         if(_loc2_ == this.duration)
         {
            this.complete(true);
         }
      }
      
      protected function easeProxy(param1:Number, param2:Number, param3:Number, param4:Number) : Number
      {
         return this.vars.proxiedEase.apply(null,arguments.concat(this.vars.easeParams));
      }
      
      public function initTweenVals(param1:Boolean = false, param2:String = "") : void
      {
         var _loc3_:* = null;
         var _loc4_:int = 0;
         var _loc6_:Array = null;
         var _loc7_:ColorTransform = null;
         var _loc8_:ColorTransform = null;
         var _loc9_:Object = null;
         var _loc5_:Object = this.vars;
         if(_loc5_.isTV == true)
         {
            _loc5_ = _loc5_.exposedProps;
         }
         if(!param1 && overwriteManager.enabled)
         {
            overwriteManager.manageOverwrites(this,masterList[this.target]);
         }
         if(this.target is Array)
         {
            _loc6_ = this.vars.endArray || [];
            _loc4_ = 0;
            while(_loc4_ < _loc6_.length)
            {
               if(this.target[_loc4_] != _loc6_[_loc4_] && this.target[_loc4_] != undefined)
               {
                  this.tweens[this.tweens.length] = [this.target,_loc4_.toString(),this.target[_loc4_],_loc6_[_loc4_] - this.target[_loc4_],_loc4_.toString()];
               }
               _loc4_++;
            }
         }
         else
         {
            if((typeof _loc5_.tint != "undefined" || this.vars.removeTint == true) && this._isDisplayObject)
            {
               _loc7_ = this.target.transform.colorTransform;
               _loc8_ = new ColorTransform();
               if(_loc5_.alpha != undefined)
               {
                  _loc8_.alphaMultiplier = _loc5_.alpha;
                  delete _loc5_.alpha;
               }
               else
               {
                  _loc8_.alphaMultiplier = this.target.alpha;
               }
               if(this.vars.removeTint != true && (_loc5_.tint != null && _loc5_.tint != "" || _loc5_.tint == 0))
               {
                  _loc8_.color = _loc5_.tint;
               }
               this.addSubTween("tint",tintProxy,{"progress":0},{"progress":1},{
                  "target":this.target,
                  "color":_loc7_,
                  "endColor":_loc8_
               });
            }
            if(_loc5_.frame != null && this._isDisplayObject)
            {
               this.addSubTween("frame",frameProxy,{"frame":this.target.currentFrame},{"frame":_loc5_.frame},{"target":this.target});
            }
            if(!isNaN(this.vars.volume) && this.target.hasOwnProperty("soundTransform"))
            {
               this.addSubTween("volume",volumeProxy,this.target.soundTransform,{"volume":this.vars.volume},{"target":this.target});
            }
            for(_loc3_ in _loc5_)
            {
               if(!(_loc3_ == "ease" || _loc3_ == "delay" || _loc3_ == "overwrite" || _loc3_ == "onComplete" || _loc3_ == "onCompleteParams" || _loc3_ == "runBackwards" || _loc3_ == "visible" || _loc3_ == "autoOverwrite" || _loc3_ == "persist" || _loc3_ == "onUpdate" || _loc3_ == "onUpdateParams" || _loc3_ == "autoAlpha" || _loc3_ == "timeScale" && !(this.target is TweenLite) || _loc3_ == "onStart" || _loc3_ == "onStartParams" || _loc3_ == "renderOnStart" || _loc3_ == "proxiedEase" || _loc3_ == "easeParams" || param1 && param2.indexOf(" " + _loc3_ + " ") != -1))
               {
                  if(!(this._isDisplayObject && (_loc3_ == "tint" || _loc3_ == "removeTint" || _loc3_ == "frame")) && !(_loc3_ == "volume" && this.target.hasOwnProperty("soundTransform")))
                  {
                     if(typeof _loc5_[_loc3_] == "number")
                     {
                        this.tweens[this.tweens.length] = [this.target,_loc3_,this.target[_loc3_],_loc5_[_loc3_] - this.target[_loc3_],_loc3_];
                     }
                     else
                     {
                        this.tweens[this.tweens.length] = [this.target,_loc3_,this.target[_loc3_],Number(_loc5_[_loc3_]),_loc3_];
                     }
                  }
               }
            }
         }
         if(this.vars.runBackwards == true)
         {
            _loc4_ = this.tweens.length - 1;
            while(_loc4_ > -1)
            {
               _loc9_ = this.tweens[_loc4_];
               _loc9_[2] = _loc9_[2] + _loc9_[3];
               _loc9_[3] = _loc9_[3] * -1;
               _loc4_--;
            }
         }
         if(_loc5_.visible == true && this._isDisplayObject)
         {
            this.target.visible = true;
         }
         if(this.vars.onUpdate != null)
         {
            this._hasUpdate = true;
         }
         this.initted = true;
      }
      
      public function killVars(param1:Object) : void
      {
         if(overwriteManager.enabled)
         {
            overwriteManager.killVars(param1,this.vars,this.tweens,this._subTweens,[]);
         }
      }
      
      public function complete(param1:Boolean = false) : void
      {
         if(!param1)
         {
            if(!this.initted)
            {
               this.initTweenVals();
            }
            this.startTime = currentTime - this.duration * 1000 / this.combinedTimeScale;
            this.render(currentTime);
            return;
         }
         if(this.vars.visible != undefined && this._isDisplayObject)
         {
            if(!isNaN(this.vars.autoAlpha) && this.target.alpha == 0)
            {
               this.target.visible = false;
            }
            else if(this.vars.runBackwards != true)
            {
               this.target.visible = this.vars.visible;
            }
         }
         if(this.vars.persist != true)
         {
            this.enabled = false;
         }
         if(this.vars.onComplete != null)
         {
            this.vars.onComplete.apply(null,this.vars.onCompleteParams);
         }
      }
   }
}
